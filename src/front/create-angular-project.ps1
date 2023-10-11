Clear-Host
# Solicita o nome do projeto ao usuário
$projectName = Read-Host -Prompt 'Digite o nome do projeto'

# Instala a versão 15 do Angular CLI globalmente
npm i -g @angular/cli@15

# Cria um novo projeto Angular com o nome fornecido
ng new $projectName

# Navega para o diretório do projeto
cd $projectName

# Faz o downgrade do rxjs para a versão 7.5.5
npm install rxjs@7.5.5

# Adiciona as dependências necessárias
ng add @po-ui/ng-components@15
ng add @po-ui/ng-templates@15
npm i subsink
npm i @totvs/protheus-lib-core@15

# Inicia o servidor de desenvolvimento
ng serve
