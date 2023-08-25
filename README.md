# Repositório de Containers Docker para Protheus

Este repositório contém um conjunto de arquivos e scripts para configurar e executar containers Docker para o ambiente Protheus. Utilizamos o Docker para facilitar a criação, distribuição e gerenciamento do ambiente de desenvolvimento do Protheus, garantindo consistência e agilidade em diferentes máquinas.

## Pré-requisitos

Antes de começar, certifique-se de que você tenha o Docker instalado em sua máquina. Você pode baixar e instalar o Docker a partir do [site oficial do Docker](https://www.docker.com/get-started).

## Estrutura do Repositório

O repositório está organizado da seguinte maneira:

- `.vscode`: Pasta contendo arquivos de configuração para o Visual Studio Code. Você pode ignorar essa pasta se não estiver usando o VS Code como IDE.

- `includes`: Pasta destinada a armazenar os arquivos `.ch` do Protheus. Esses arquivos são essenciais para a configuração do ambiente e devem ser colocados aqui. **Certifique-se de que os arquivos necessários já estão presentes nessa pasta antes de prosseguir**.

- `.gitattributes` e `.gitignore`: Arquivos de configuração do Git para especificar como o Git deve tratar certos arquivos e pastas, e quais arquivos devem ser ignorados no controle de versão.

- `start.ps1`: Script PowerShell para iniciar a criação e execução dos containers. Certifique-se de executar este script para iniciar o processo de construção dos containers Docker.

- Outros arquivos: Outros arquivos específicos da aplicação ou do projeto.

## Como Usar

Siga estas etapas para configurar e executar os containers Docker do Protheus:

1. Certifique-se de que o Docker esteja instalado em sua máquina.

2. Clone este repositório para o seu ambiente local.

3. Abra um terminal ou prompt de comando e navegue até o diretório onde você clonou o repositório.

4. Execute o script `start.ps1` usando o PowerShell:
   ```powershell
   ./start.ps1

Esse script automatiza o processo de configuração e execução dos containers Docker para o ambiente Protheus. Ele configura os containers necessários, define arquivos de configuração e inicia o ambiente Protheus.

Aguarde até que o processo seja concluído. Isso pode levar algum tempo, dependendo das configurações e do tamanho dos containers.

Uma vez concluído, o ambiente Protheus estará disponível nos containers Docker.

## Script `start.ps1`

O script `start.ps1` automatiza a configuração e a execução dos containers Docker do Protheus. Ele executa uma série de comandos que configuram os containers necessários, definem arquivos de configuração e iniciam o ambiente Protheus.

O script realiza as seguintes etapas:

1. Configuração dos containers `dbaccess-postgres` e `appserver`.
2. Criação e substituição dos arquivos de configuração `dbaccess.ini` e `appserver.ini`.
3. Criação do arquivo `docker-compose.yml` com definições de serviços e volumes.
4. Execução do comando `docker-compose up -d` para iniciar os containers.

Certifique-se de que os arquivos de configuração e os arquivos específicos do Protheus estejam corretamente localizados no diretório do repositório antes de executar o script.

## Contribuições

Se você deseja contribuir para este repositório, siga as etapas mencionadas no README original. Certifique-se de que suas contribuições sejam relevantes para o contexto do ambiente Protheus.

## Contato

Se você tiver alguma dúvida ou precisar de ajuda específica para configurar ou usar o ambiente Protheus em containers Docker, sinta-se à vontade para criar uma issue neste repositório. Também estamos disponíveis por email em matheushchaves@gmail.com para qualquer assistência necessária.

---

Mantenha este README atualizado com qualquer informação relevante sobre o uso, configuração e manutenção dos containers Docker do Protheus. Isso garantirá que todos os colaboradores possam aproveitar ao máximo o ambiente configurado.
