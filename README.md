# ToggleMaster — Análise Arquitetural

## 1. Visão geral

O [ToggleMaster](https://github.com/dougls/toggle-master-monolith) é uma aplicação desenvolvida em Python com Flask para gerenciar *feature flags*, permitindo ativar ou desativar funcionalidades. Utiliza PostgreSQL para persistência dos dados, Gunicorn para execução e Docker para empacotamento.

## 2. Arquitetura monolítica

A aplicação apresenta uma arquitetura monolítica porque suas rotas e funcionalidades estão concentradas principalmente no arquivo `app.py`, sendo executadas e implantadas como uma única unidade. As operações acessam diretamente a tabela `flags` no PostgreSQL, sem uma separação clara entre as camadas de API, regras de negócio e acesso a dados.

Essa abordagem é adequada para um MVP por oferecer desenvolvimento rápido, menor custo de infraestrutura e simplicidade de implantação e manutenção inicial. Entretanto, o crescimento da aplicação pode aumentar o acoplamento entre funcionalidades, dificultar a manutenção e limitar a escalabilidade independente de seus componentes.

## 3. Análise dos 12-Factor App

A metodologia [12-Factor App](https://12factor.net/) estabelece boas práticas para desenvolver aplicações portáteis, escaláveis e confiáveis.

| Fator                         | Situação                                                                                    |
| ----------------------------- | ------------------------------------------------------------------------------------------- |
| 1. Base de código             | Atende: código versionado no GitHub.                                                        |
| 2. Dependências               | Parcial: dependências declaradas, com necessidade de controle rigoroso das versões.         |
| 3. Configurações              | Parcial: utiliza variáveis de ambiente, mas requer atenção ao gerenciamento de credenciais. |
| 4. Serviços de apoio          | Parcial: utiliza PostgreSQL, sendo importante validar a configuração para produção.         |
| 5. Build, Release, Run        | Parcial: utiliza Docker e Gunicorn, mas precisa de um processo de entrega mais estruturado. |
| 6. Processos                  | Parcial: dados persistidos no banco; é necessário garantir processos sem estado local.      |
| 7. Vínculo de porta           | Atende: API disponibilizada por uma porta de rede.                                          |
| 8. Concorrência               | Parcial: Gunicorn suporta múltiplos workers, mas requer dimensionamento.                    |
| 9. Descartabilidade           | Parcial: precisa validar inicialização, encerramento gracioso e recuperação de falhas.      |
| 10. Paridade entre ambientes  | Parcial: Docker facilita a padronização, mas não garante equivalência entre ambientes.      |
| 11. Logs                      | Parcial: recomenda-se padronização e centralização dos registros.                           |
| 12. Processos administrativos | Parcial: tarefas de inicialização devem ser separadas da execução normal da API.            |


## 4. Melhorias recomendadas

Para tornar a aplicação mais robusta em produção, recomenda-se proteger credenciais, automatizar testes e implantações com CI/CD, centralizar logs, implementar verificações de saúde, dimensionar os processos do Gunicorn e separar as migrações do banco da inicialização da API.

## 5. Conclusão

A arquitetura monolítica é adequada ao MVP por sua simplicidade e baixo custo inicial. A aplicação já apresenta uma base para execução em contêineres e utilização de serviços externos, mas precisa aprimorar aspectos de segurança, automação, observabilidade e confiabilidade para produção. Essas melhorias podem ser implementadas sem migrar para microsserviços, mantendo a arquitetura atual até que o crescimento do sistema justifique mudanças.

## Referências

* [Repositório ToggleMaster](https://github.com/dougls/toggle-master-monolith)
* [Metodologia 12-Factor App](https://12factor.net/)
