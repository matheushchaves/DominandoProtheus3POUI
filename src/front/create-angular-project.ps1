Clear-Host

$projectName = Read-Host -Prompt 'Digite o nome do projeto'

ng new $projectName --routing=true --style=css --skip-install

cd $projectName

ng analytics off

# Define as dependencias necessárias
$requiredDependencies = @{
    "dependencies" = @{
        "@angular/animations" = "~15.0.3"
        "@angular/common" = "~15.0.3"
        "@angular/compiler" = "~15.0.3"
        "@angular/core" = "~15.0.3"
        "@angular/forms" = "~15.0.3"
        "@angular/platform-browser" = "~15.0.3"
        "@angular/platform-browser-dynamic" = "~15.0.3"
        "@angular/router" = "~15.0.3"
        "rxjs" = "~7.5.5"
        "tslib" = "^2.3.0"
        "zone.js" = "~0.12.0"
    }
    "devDependencies" = @{
        "@angular-devkit/build-angular" = "~15.0.3"
        "@angular/cli" = "~15.0.3"
        "@angular/compiler-cli" = "~15.0.3"
        "typescript" = "~4.8.4"
    }
}

# Obtém as dependencias do arquivo package.json
$packageJsonPath = "$pwd\package.json"
$packageJson = Get-Content $packageJsonPath -Raw | ConvertFrom-Json

# Função para atualizar as dependencias no package.json
function Update-Dependencies ($dependenciesSection, $requiredDependencies) {
    foreach ($dependency in $requiredDependencies.GetEnumerator()) {
        if (-not $dependenciesSection.PSObject.Properties.Name.Contains($dependency.Name)) {
            Write-Host "Faltando dependencia: $($dependency.Name), adicionando..." -ForegroundColor Yellow
            $dependenciesSection | Add-Member -NotePropertyName $dependency.Name -NotePropertyValue $dependency.Value
        } elseif ($dependenciesSection.$($dependency.Name) -ne $dependency.Value) {
            Write-Host "Atualizando versao da dependencia: $($dependency.Name) de $($dependenciesSection.$($dependency.Name)) para $($dependency.Value)" -ForegroundColor Yellow
            $dependenciesSection.$($dependency.Name) = $dependency.Value
        }
    }
}


# Atualiza as dependencias e dependencias de desenvolvimento
Update-Dependencies $packageJson.dependencies $requiredDependencies.dependencies
Update-Dependencies $packageJson.devDependencies $requiredDependencies.devDependencies

# Salva as alterações de volta no arquivo package.json
$packageJson | ConvertTo-Json -Depth 32 | Set-Content $packageJsonPath -Force

npm install

Write-Host "Preparando arquivo de configuracao do proxy..." -ForegroundColor Green

$proxyConfig = @"
{
  "/api": {
    "target": "http://localhost:8090/rest",
    "secure": false,
    "changeOrigin": true,
    "logLevel": "debug",
    "headers": {
      "Authorization": "Basic $( [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:admin")) )"
    }
  }
}
"@

$proxyConfigPath = "$pwd\proxy.conf.json"
$utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $false

[System.IO.File]::WriteAllLines($proxyConfigPath, $proxyConfig, $utf8NoBomEncoding)

Write-Host "Ajustando script 'start' no package.json..." -ForegroundColor Green

$packageJson.scripts.start = "ng serve --proxy-config proxy.conf.json"
$packageJson | ConvertTo-Json -Depth 32 | Set-Content $packageJsonPath -Force

npm install

ng add @po-ui/ng-components@15.0.1
ng add @po-ui/ng-templates@15.0.1

npm i @totvs/protheus-lib-core@15

npm start
