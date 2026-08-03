@echo off
setlocal enabledelayedexpansion

echo ============================================
echo  Spring Microservices - Repo Restructure
echo ============================================
echo.
echo This script will:
echo  1. Copy section14 as the main project source
echo  2. Create a clean professional folder structure
echo  3. Move k8s and helm configs
echo  4. Add README, .gitignore, and CI workflow
echo  5. Stage everything for a new git commit
echo.
set /p CONFIRM=Are you sure you want to continue? (yes/no): 
if /i not "%CONFIRM%"=="yes" (
    echo Aborted.
    exit /b
)

echo.
echo [1/7] Creating new folder structure...
mkdir services 2>nul
mkdir infrastructure 2>nul
mkdir k8s 2>nul
mkdir helm 2>nul
mkdir .github\workflows 2>nul
mkdir docs 2>nul

echo [2/7] Copying services from section14...
xcopy /e /i /q section14\accounts   services\accounts\   > nul
xcopy /e /i /q section14\cards      services\cards\      > nul
xcopy /e /i /q section14\loans      services\loans\      > nul
xcopy /e /i /q section14\message    services\message\    > nul

echo [3/7] Copying infrastructure from section14...
xcopy /e /i /q section14\configserver   infrastructure\config-server\   > nul
xcopy /e /i /q section14\eurekaserver   infrastructure\discovery-server\ > nul
xcopy /e /i /q section14\gatewayserver  infrastructure\api-gateway\     > nul
xcopy /e /i /q section14\docker-compose infrastructure\docker-compose\  > nul

echo [4/7] Copying k8s and helm configs...
xcopy /e /i /q section15\kubernates  k8s\  > nul
xcopy /e /i /q section16\helm-new    helm\ > nul

echo [5/7] Copying docs from section17...
copy /y section17\Microservices.postman_collection.json docs\ > nul

echo [6/7] Writing .gitignore...
(
echo # Maven
echo target/
echo !.mvn/wrapper/maven-wrapper.jar
echo *.jar
echo *.war
echo *.ear
echo.
echo # IntelliJ IDEA
echo .idea/
echo *.iml
echo *.iws
echo *.ipr
echo out/
echo.
echo # Eclipse
echo .classpath
echo .project
echo .settings/
echo .springBeans
echo .sts4-cache
echo.
echo # OS
echo .DS_Store
echo Thumbs.db
echo.
echo # Logs
echo *.log
echo logs/
echo.
echo # Docker
echo .docker/
echo.
echo # Env files
echo .env
echo *.env
) > .gitignore

echo [6b/7] Writing GitHub Actions CI workflow...
(
echo name: CI
echo.
echo on:
echo   push:
echo     branches: [ main ]
echo   pull_request:
echo     branches: [ main ]
echo.
echo jobs:
echo   build:
echo     runs-on: ubuntu-latest
echo     strategy:
echo       matrix:
echo         service: [accounts, cards, loans, message]
echo.
echo     steps:
echo       - uses: actions/checkout@v4
echo.
echo       - name: Set up JDK 17
echo         uses: actions/setup-java@v4
echo         with:
echo           java-version: '17'
echo           distribution: 'temurin'
echo           cache: maven
echo.
echo       - name: Build ^${{ matrix.service }}
echo         run: mvn -B verify --file services/^${{ matrix.service }}/pom.xml
echo.
echo   build-infra:
echo     runs-on: ubuntu-latest
echo     strategy:
echo       matrix:
echo         service: [config-server, discovery-server, api-gateway]
echo.
echo     steps:
echo       - uses: actions/checkout@v4
echo.
echo       - name: Set up JDK 17
echo         uses: actions/setup-java@v4
echo         with:
echo           java-version: '17'
echo           distribution: 'temurin'
echo           cache: maven
echo.
echo       - name: Build ^${{ matrix.service }}
echo         run: mvn -B verify --file infrastructure/^${{ matrix.service }}/pom.xml
) > .github\workflows\ci.yml

echo [7/7] Writing README.md...
(
echo # Spring Microservices
echo.
echo A production-style microservices architecture built with Spring Boot, Spring Cloud, Docker, Kubernetes, and Helm.
echo.
echo ## Architecture
echo.
echo ``` 
echo spring-microservices/
echo ^|-- services/
echo ^|   ^|-- accounts/          # Accounts microservice
echo ^|   ^|-- cards/             # Cards microservice
echo ^|   ^|-- loans/             # Loans microservice
echo ^|   ^`-- message/           # Event-driven messaging service
echo ^|
echo ^|-- infrastructure/
echo ^|   ^|-- api-gateway/       # Spring Cloud Gateway
echo ^|   ^|-- config-server/     # Spring Cloud Config Server
echo ^|   ^|-- discovery-server/  # Eureka Service Registry
echo ^|   ^`-- docker-compose/    # Docker Compose files
echo ^|
echo ^|-- k8s/                   # Kubernetes manifests
echo ^|-- helm/                  # Helm charts
echo ^|-- docs/                  # Postman collection ^& docs
echo ^`-- .github/workflows/     # CI/CD pipeline
echo ```
echo.
echo ## Tech Stack
echo.
echo ^| Layer ^| Technology ^|
echo ^|-------|------------|
echo ^| Services ^| Spring Boot 3, Spring Web, Spring Data JPA ^|
echo ^| Service Discovery ^| Netflix Eureka ^|
echo ^| API Gateway ^| Spring Cloud Gateway ^|
echo ^| Config ^| Spring Cloud Config Server ^|
echo ^| Messaging ^| RabbitMQ / Spring Cloud Stream ^|
echo ^| Containerization ^| Docker, Docker Compose ^|
echo ^| Orchestration ^| Kubernetes ^|
echo ^| Package Manager ^| Helm ^|
echo ^| CI/CD ^| GitHub Actions ^|
echo.
echo ## Getting Started
echo.
echo ### Run with Docker Compose
echo.
echo ```bash
echo cd infrastructure/docker-compose
echo docker compose up -d
echo ```
echo.
echo ### Run locally
echo.
echo Start services in this order:
echo 1. `infrastructure/config-server`
echo 2. `infrastructure/discovery-server`
echo 3. `infrastructure/api-gateway`
echo 4. Any of: `services/accounts`, `services/cards`, `services/loans`, `services/message`
echo.
echo ```bash
echo cd infrastructure/config-server
echo mvn spring-boot:run
echo ```
echo.
echo ## API Testing
echo.
echo Import `docs/Microservices.postman_collection.json` into Postman.
echo.
echo ## Kubernetes Deployment
echo.
echo ```bash
echo kubectl apply -f k8s/
echo ```
echo.
echo ## Helm Deployment
echo.
echo ```bash
echo helm install spring-ms helm/
echo ```
) > README.md

echo.
echo ============================================
echo  Structure created. Now staging git changes.
echo ============================================
echo.

git add services/ infrastructure/ k8s/ helm/ docs/ .gitignore README.md .github/
git status

echo.
echo ============================================
echo  Done! Review the changes above, then run:
echo.
echo    git commit -m "refactor: restructure repo to professional layout"
echo    git push origin main
echo.
echo  NOTE: The old section* folders are still
echo  present but NOT staged. Delete them manually
echo  after verifying everything looks correct:
echo.
echo    rmdir /s /q section2 section4 section6
echo    rmdir /s /q section7 section8 section9
echo    rmdir /s /q section10 section12 section13
echo    rmdir /s /q section14 section15 section16 section17
echo    git add -A
echo    git commit -m "chore: remove section folders"
echo    git push origin main
echo ============================================