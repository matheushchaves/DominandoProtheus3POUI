Clear-Host

# Caminho para o Docker Desktop. Modifique se o seu caminho for diferente.
$dockerDesktopPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
Write-Host "Verifying if Docker Desktop is running..."
# Verifica se o Docker Desktop está em execução
$dockerDesktopProcess = Get-Process | Where-Object { $_.Path -eq $dockerDesktopPath }
if (-not $dockerDesktopProcess) {
    # Inicia o Docker Desktop
    Start-Process -FilePath $dockerDesktopPath
    # Espera por 10 segundos para permitir que o Docker inicialize completamente
    Start-Sleep -Seconds 30
}

# Você pode adicionar uma verificação adicional aqui para verificar se o Docker Desktop iniciou corretamente
$dockerDesktopProcess = Get-Process | Where-Object { $_.Path -eq $dockerDesktopPath }
if ($dockerDesktopProcess) {
    Write-Host "Docker Desktop is running"
} else {
    Write-Host "Failed to start Docker Desktop"
}

docker run --rm `
    -v ${PWD}:/local `
    --workdir=/local `
    totvsengpro/dbaccess-postgres-dev `
        /opt/totvs/dbaccess/tools/dbaccesscfg `
        -u postgres `
        -p postgres `
        -a protheus `
        -d postgres `
        -c '/usr/lib64/libodbc.so' `
        -o 'ConnectionMode=2;ConnectionString=DRIVER!{PostgreSQL}@SERVERNAME!postgres-db@PORT!5432@DATABASE!protheus@USERNAME!postgres@PASSWORD!postgres' `
        -g 'LicenseServer=license;LicensePort=5555'

(Get-Content dbaccess.ini) -replace '!', '=' -replace '@', ';' | Set-Content dbaccess2.ini
Move-Item -Force dbaccess2.ini dbaccess.ini

@"
[environment_web]
rpodb=top
rpoversion=120
rpolanguage=multi
sourcepath=/opt/totvs/protheus/apo
rpocustom=/opt/totvs/protheus/custom/custom.rpo
rootpath=/opt/totvs/protheus/protheus_data
startpath=/system
dbdatabase=postgres
dbalias=protheus
dbserver=dbaccess-postgres
dbport=7890
topmemomega=10
specialkey=exemplo
FWTRACELOG=1

[environment]
rpodb=top
rpoversion=120
rpolanguage=multi
sourcepath=/opt/totvs/protheus/apo
rpocustom=/opt/totvs/protheus/custom/custom.rpo
rootpath=/opt/totvs/protheus/protheus_data
startpath=/system
dbdatabase=postgres
dbalias=protheus
dbserver=dbaccess-postgres
dbport=7890
topmemomega=10
specialkey=exemplo
FWTRACELOG=1

[general]
buildkillusers=1
consolelog=1
consolefile=/opt/totvs/appserver/console.log
maxstringsize=10
app_environment=environment_web

[drivers]
active=tcp
multiprotocolport=1
multiprotocolportsecure=0

[tcp]
type=tcpip
port=1234

[webapp]
enable=1
port=8080
EnvServer=environment,environment_web
app_environment=environment_web
LastMainProg=SIGAMDI,SIGACFG

[lockserver]
enable=1

[licenseclient]
server=license
port=5555

[webapp/webapp]
mpp=

[HTTPV11]
ENABLE=1
SOCKETS=HTTPREST

[ONSTART]
JOBS=HTTPJOB
REFRESHRATE=30

[HTTPURI]
URL=/REST
INSTANCES=1,2
PREPAREIN=ALL
CORSEnable=1
AllowOrigin=* 

[HTTPREST]
SECURITY=1
PORT=8081
URIS=HTTPURI

[HTTPJOB]
MAIN=HTTP_START
ENVIRONMENT=ENVIRONMENT
"@ | Set-Content -Path "appserver.ini"

# Replace the placeholders with actual values
$pgadminServerJson = @"
{
  "Servers": {
      "1": {
          "Name": "postgres-db",
          "Group": "Servers",
          "Host": "postgres-db",
          "Port": 5432,
          "MaintenanceDB": "postgres",
          "Username": "postgres",
          "UseSSHTunnel": 0,
          "TunnelPort": "22",
          "TunnelAuthentication": 0,
          "KerberosAuthentication": false,
          "ConnectionParameters": {
              "sslmode": "prefer",
              "connect_timeout": 10,
              "sslcert": "<STORAGE_DIR>/.postgresql/postgresql.crt",
              "sslkey": "<STORAGE_DIR>/.postgresql/postgresql.key"
          }
      }
  }
}
"@

# Create the directory if it doesn't exist
$directory = "pgadmin4"
if (-not (Test-Path $directory)) {
    New-Item -ItemType Directory -Path $directory
}

$pgadminServerJson | Set-Content -Path "$directory/servers.json"

@"
version: '3.6'

services:
  license:
    image: 'totvsengpro/license-dev'

  postgres-db:
    image: 'totvsengpro/postgres-dev:12.1.2210_bra'
#    volumes:
#      - '${PWD}/postgresdata/:/var/lib/postgresql/data'
    ports:
      - '5432:5432'
      
  dbaccess-postgres:
    image: 'totvsengpro/dbaccess-postgres-dev'
    volumes:
      - '${PWD}/dbaccess.ini:/opt/totvs/dbaccess/multi/dbaccess.ini'
    ports:
      - '7890:7890'

  appserver:
    image: 'totvsengpro/appserver-dev'
    volumes:
      - '${PWD}/appserver.ini:/opt/totvs/appserver/appserver.ini'
      - '${PWD}/tttm120.rpo:/opt/totvs/protheus/apo/tttm120.rpo'
      - '${PWD}/custom/:/opt/totvs/protheus/custom'
      - '${PWD}/sx2.unq:/opt/totvs/protheus/protheus_data/systemload/sx2.unq'
      - '${PWD}/sxsbra.txt:/opt/totvs/protheus/protheus_data/systemload/sxsbra.txt'
    ports:
      - '8080:8080'
      - '1234:1234'
      - '8081:8081'
      - '32033:32033'
    
  pgadmin:
      image: 'dpage/pgadmin4'
      ports:
        - '5050:80'  # Map pgAdmin container port 80 to host port 5050
      environment:
        - PGADMIN_DEFAULT_EMAIL=user@example.com
        - PGADMIN_DEFAULT_PASSWORD=SuperSecretPassword
      volumes:
        - '${PWD}/pgadmin4/servers.json:/pgadmin4/servers.json' # Map the servers.json file
        - '${PWD}/pgadmin4/storage:/var/lib/pgadmin/storage' # Used for storage of config/keys/etc
      
#volumes:
#      postgresdata:      
"@ | Set-Content -Path "docker-compose.yml"

docker-compose up -d