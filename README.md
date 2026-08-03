# Spring Microservices

A production-style microservices system built around a banking domain. The project covers the full stack of microservices concerns — centralized configuration, service discovery, API routing, inter-service communication, fault tolerance, event-driven messaging, containerization, and orchestration.

---

## Architecture Overview

```
                         ┌──────────────────┐
                         │   API Gateway    │ :8072
                         └────────┬─────────┘
                                  │
               ┌──────────────────┼──────────────────┐
               │                  │                  │
         ┌─────▼─────┐    ┌───────▼─────┐    ┌──────▼──────┐
         │  accounts │    │    cards    │    │    loans    │
         │   :8080   │    │    :9000    │    │    :8090    │
         └─────┬─────┘    └──────┬──────┘    └──────┬──────┘
               │                 │                  │
               └─────────────────▼──────────────────┘
                                 │  Kafka events
                          ┌──────▼──────┐
                          │   message   │
                          │    :9010    |    
                          └─────────────┘

         All services → Eureka (service registry) :8070
         All services → Config Server (centralized config) :8071
```

---

## Services

| Service | Responsibility | Port |
|---|---|---|
| `accounts` | Core banking accounts management | 8080 |
| `cards` | Credit/debit card operations | 9000 |
| `loans` | Loan products and applications | 8090 |
| `message` | Kafka event consumer for async notifications | 9010 |

## Infrastructure Components

| Component | Technology | Port |
|---|---|---|
| `config-server` | Spring Cloud Config — single source of truth for all service configs | 8071 |
| `discovery-server` | Netflix Eureka — service registry and discovery | 8070 |
| `api-gateway` | Spring Cloud Gateway — routing, load balancing, entry point | 8072 |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 4.1.0 |
| Service Discovery | Netflix Eureka (Spring Cloud 2025.1.2) |
| API Gateway | Spring Cloud Gateway |
| Config Management | Spring Cloud Config Server |
| Inter-service Calls | OpenFeign |
| Fault Tolerance | Resilience4j (circuit breaker, retry, rate limiter) |
| Messaging | Apache Kafka + Spring Cloud Stream |
| API Docs | Springdoc OpenAPI (Swagger UI) |
| Database | H2 (in-memory, per service) |
| Image Build | Google Jib (Maven plugin) |
| Containerization | Docker + Docker Compose |
| Orchestration | Kubernetes |
| Package Manager | Helm |
| CI/CD | GitHub Actions |

---

## Running the Project

### Prerequisites

- Java 17+
- Maven 3.8+
- Docker + Docker Compose

### Docker Compose (recommended)

Starts all services and infrastructure in the correct order:

```bash
cd infrastructure/docker-compose
docker compose up -d
```

### Manual startup (local dev)

Services depend on config-server and Eureka being up first. Start in this order:

```bash
# 1. Config server — must be first, everything reads config from here
cd infrastructure/config-server
mvn spring-boot:run

# 2. Eureka — service registry
cd infrastructure/discovery-server
mvn spring-boot:run

# 3. API Gateway
cd infrastructure/api-gateway
mvn spring-boot:run

# 4. Business services (any order)
cd services/accounts && mvn spring-boot:run
cd services/cards && mvn spring-boot:run
cd services/loans && mvn spring-boot:run
cd services/message && mvn spring-boot:run
```

---

## API Documentation

Each service exposes a Swagger UI once running:

```
http://localhost:8080/swagger-ui.html   → accounts
http://localhost:9000/swagger-ui.html   → cards
http://localhost:8090/swagger-ui.html   → loans
```

All requests in production go through the gateway on `:8072`.

A full Postman collection is available at `docs/Microservices.postman_collection.json` — import it and all endpoints are ready to test.

---

## Docker Images

Images are built using **Jib** (no Dockerfile needed):

```bash
mvn compile jib:build -pl services/accounts
mvn compile jib:build -pl services/cards
mvn compile jib:build -pl services/loans
```

Images are pushed to Docker Hub under `mazenkhaled1/<service>:s14`.

---

## Kubernetes Deployment

Manifests are in `k8s/`. Apply everything at once:

```bash
kubectl apply -f k8s/
```

Check status:

```bash
kubectl get pods
kubectl get services
```

---

## Helm

```bash
# Install
helm install eazybank helm/

# Upgrade after changes
helm upgrade eazybank helm/

# Uninstall
helm uninstall eazybank
```

---

## Project Structure

```
spring-microservices/
├── services/
│   ├── accounts/
│   ├── cards/
│   ├── loans/
│   └── message/
├── infrastructure/
│   ├── api-gateway/
│   ├── config-server/
│   ├── discovery-server/
│   └── docker-compose/
├── k8s/
├── helm/
├── docs/
│   └── Microservices.postman_collection.json
└── .github/
    └── workflows/
        └── ci.yml
```

---

## Key Patterns Implemented

- **Config externalization** — no hardcoded config in any service; everything pulled from config-server at startup
- **Service discovery** — services locate each other via Eureka, no hardcoded URLs
- **Circuit breaker** — Resilience4j prevents cascade failures when a downstream service is down
- **Event-driven communication** — accounts service publishes Kafka events; message service consumes them asynchronously
- **API gateway** — single entry point handles routing and client-side load balancing across service instances
