# Execucao do projeto Terraform

Este projeto cria uma VPC com sub-redes publicas e privadas, uma EC2 publica e um RDS privado. O PostgreSQL e o banco padrao; MySQL tambem pode ser selecionado. A EC2 nao instala nem executa uma aplicacao.

## Pre-requisitos

- Terraform 1.5 ou superior.
- AWS CLI configurado com credenciais que possam criar VPC, sub-redes, rotas, Security Groups, EC2 e RDS.
- Permissoes AWS para criar key pairs EC2, chaves KMS e parametros SSM SecureString.
- O IP publico de origem do SSH, informado como CIDR `/32`.

O provider usa `us-east-1` por padrao. A autenticacao AWS pode ser feita com `aws configure` ou com um perfil AWS ja configurado.

## Criar o par de chaves

Gere o par localmente antes de executar o Terraform. A chave privada fica na sua maquina; somente a publica sera enviada a AWS:

```sh
ssh-keygen -t ed25519 -f "$HOME/.ssh/fiap-app" -N ""
chmod 600 "$HOME/.ssh/fiap-app"
```

Se esse arquivo ja existir, escolha outro nome para nao sobrescreve-lo.

## Configurar variaveis

Crie `infra-live/terraform.tfvars` (ignorado pelo Git):

```hcl
aws_region       = "us-east-1"
ssh_allowed_cidr = "SEU_IP_PUBLICO/32"
ec2_key_name     = "fiap-app-ssh"
ssh_public_key_path = "~/.ssh/fiap-app.pub"
db_engine        = "postgres"
db_password      = "defina-uma-senha-forte"
```

O Terraform criara o key pair `ec2_key_name` na regiao escolhida a partir de `ssh_public_key_path`. Para MySQL, altere `db_engine` para `mysql`. Restrinja as permissoes do arquivo local:

```sh
chmod 600 infra-live/terraform.tfvars
```

Nao versione esse arquivo. A senha fica no state e no plano Terraform; proteja esses arquivos e use um backend remoto criptografado em ambientes compartilhados ou de producao.

## Validar e aplicar

Execute os comandos a partir da raiz do repositorio:

```sh
terraform fmt -check -recursive infra-module
terraform -chdir=infra-live fmt -check main.tf outputs.tf variables.tf versions.tf region.tf
terraform -chdir=infra-live init
terraform -chdir=infra-live validate
terraform -chdir=infra-live plan -out=deploy.tfplan
terraform -chdir=infra-live apply deploy.tfplan
```

Revise o plano antes de aplicar. A criacao do RDS pode levar varios minutos.

O Terraform tambem cria a chave KMS que sera usada para cifrar a chave privada no Parameter Store. A chave privada nao e enviada ao Terraform e nao fica no state.

## Armazenar a chave privada no SSM

Depois do `apply`, armazene a chave local como parametro `SecureString`, cifrado pela KMS criada:

```sh
PARAM_NAME="$(terraform -chdir=infra-live output -raw ssh_private_key_parameter_name)"
KMS_KEY_ID="$(terraform -chdir=infra-live output -raw ssh_kms_key_id)"
aws ssm put-parameter \
	--name "$PARAM_NAME" \
	--type SecureString \
	--key-id "$KMS_KEY_ID" \
	--value "file://$HOME/.ssh/fiap-app" \
	--overwrite
```

O parametro e criado pela AWS CLI para que o valor privado nao passe pelo state Terraform. A identidade AWS precisa de `ssm:PutParameter` e permissoes KMS para cifrar.

## Consultar recursos e acessar a EC2

Depois do `apply`, consulte os identificadores e enderecos:

```sh
terraform -chdir=infra-live output
terraform -chdir=infra-live output -raw ec2_public_ip
terraform -chdir=infra-live output -raw ec2_public_dns
terraform -chdir=infra-live output -raw rds_endpoint
```

A EC2 nao executa servidor web. As portas 80 e 443 estao liberadas no Security Group, mas nao ha aplicacao ou servico HTTP configurado nelas. Para recuperar a chave privada do SSM e usa-la por SSH:

```sh
umask 077
aws ssm get-parameter \
	--name "$(terraform -chdir=infra-live output -raw ssh_private_key_parameter_name)" \
	--with-decryption \
	--query Parameter.Value \
	--output text > "$HOME/.ssh/fiap-app-from-ssm"
chmod 600 "$HOME/.ssh/fiap-app-from-ssm"
ssh -i "$HOME/.ssh/fiap-app-from-ssm" \
	ec2-user@"$(terraform -chdir=infra-live output -raw ec2_public_dns)"
```

Para recuperar o parametro, a identidade AWS precisa de `ssm:GetParameter` e `kms:Decrypt`. O endpoint do RDS e privado e a entrada do banco no Security Group aceita conexoes vindas somente do Security Group da EC2.

## Remover os recursos

Quando nao precisar mais do ambiente, revise os recursos que serao removidos e execute:

```sh
aws ssm delete-parameter \
	--name "$(terraform -chdir=infra-live output -raw ssh_private_key_parameter_name)"
terraform -chdir=infra-live destroy
```

Remova primeiro o parametro SSM; a chave KMS e agendada para exclusao durante a destruicao. Por padrao, o RDS nao cria snapshot final. Avalie `skip_final_snapshot` e `deletion_protection` antes de usar em producao.