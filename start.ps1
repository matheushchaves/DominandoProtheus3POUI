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
        -o 'ConnectionMode=2;ConnectionString=DRIVER!{PostgreSQL}@SERVERNAME!postgres-iniciado@PORT!5432@DATABASE!protheus@USERNAME!postgres@PASSWORD!postgres' `
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
      "Name": "PostgreSQL Server",
      "Group": "Servers",
      "Host": "postgres-db",  # The service name defined in your docker-compose.yml
      "Port": 5432,
      "Username": "postgres",  # Your PostgreSQL username
      "SSLMode": "prefer",
      "MaintenanceDB": "postgres",
      "Passfile": "/var/lib/pgadmin/servers.passfile"
    }
  }
}
"@

$pgadminServerJson | Set-Content -Path "pgadmin4_server.json"

@"
version: '3.6'

services:
  license:
    image: 'totvsengpro/license-dev'

  postgres-db:
    image: 'totvsengpro/postgres-dev:12.1.2210_bra'
    volumes:
      - '${PWD}/postgresdata/:/var/lib/postgresql/data'
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
    
  pgadmin:
      image: 'dpage/pgadmin4'
      ports:
        - '5050:80'  # Map pgAdmin container port 80 to host port 5050
      environment:
        - PGADMIN_DEFAULT_EMAIL=user@example.com
        - PGADMIN_DEFAULT_PASSWORD=SuperSecretPassword
      volumes:
        - '${PWD}/pgadmin4_server.json:/pgadmin4/servers.json' # Map the servers.json file
      
volumes:
      postgresdata:      
"@ | Set-Content -Path "docker-compose.yml"

docker-compose up -d