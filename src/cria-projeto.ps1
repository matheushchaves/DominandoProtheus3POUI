# Solicita ao usuário o nome do novo projeto
$nomeDoNovoProjeto = Read-Host "Por favor, insira o nome do novo projeto"

# URL do repositório Git "template"
$urlDoTemplate = "https://github.com/matheushchaves/DominandoProtheus3POUI.git"

# Define a pasta de destino com base na localização atual do script e na pasta 'projects'
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$pastaDeDestino = Join-Path -Path $scriptPath -ChildPath "projects\$nomeDoNovoProjeto"

# Cria a pasta do projeto se ela não existir
if (-not (Test-Path $pastaDeDestino)) {
    New-Item -ItemType Directory -Path $pastaDeDestino
}

# Muda o diretório corrente para a pasta do projeto
Set-Location -Path $pastaDeDestino

# Inicializa um repositório Git vazio
git init
git remote add origin $urlDoTemplate

# Configura sparse-checkout
git config core.sparseCheckout true

# Especifica os caminhos para serem incluídos
echo "src/template/*" | Out-File -Encoding ASCII -FilePath .git/info/sparse-checkout

# Busca e faz checkout do branch principal (ajuste 'main' se o branch for diferente)
git fetch --depth=1 origin main
git checkout main

# Remove a configuração do git original para iniciar um novo repositório
Remove-Item .git -Recurse -Force

# Move os conteúdos clonados para a pasta raiz do projeto e remove as pastas desnecessárias
Move-Item src\template\* .\
Remove-Item src -Recurse

# Re-inicializa um novo repositório Git
git init
git add .
git commit -m "Inicialização do projeto $nomeDoNovoProjeto a partir do template."

# Pergunta ao usuário se deseja vincular a um repositório Git remoto
$vincularRemoto = Read-Host "Deseja vincular este projeto a um repositório Git remoto? (S/N)"

if ($vincularRemoto -eq 'S' -or $vincularRemoto -eq 's') {
    $urlDoRepositorioRemoto = Read-Host "Por favor, insira a URL do repositório Git remoto"
    git remote add origin $urlDoRepositorioRemoto
    git branch -M main
    git push -u origin main
    Write-Host "Projeto vinculado ao repositório remoto: $urlDoRepositorioRemoto"
}

# Exibe mensagem de sucesso
Write-Host "Projeto $nomeDoNovoProjeto criado com sucesso em $pastaDeDestino"

# Retorna ao diretório original onde o script foi executado
Set-Location -Path $scriptPath
