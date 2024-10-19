# Task Processor

Web application for processing heavy computational tasks with load balancing.

## Project Structure

- `src/TaskProcessor.API` - Backend API
- `src/TaskProcessor.Core` - Business logic and domain models
- `src/TaskProcessor.Infrastructure` - Data access and external services
- `src/TaskProcessor.Common` - Shared components and DTOs
- `client/` - React frontend application
- `tests/` - Unit and integration tests

## Development

### Prerequisites
- .NET 8 SDK
- Node.js
- Docker & Docker Compose
- PostgreSQL

### Setup
1. Clone the repository
2. Run `dotnet restore` in the root folder
3. Navigate to `client` folder and run `npm install`

### Running the application
1. Start the backend: `dotnet run --project src/TaskProcessor.API`
2. Start the frontend: `cd client && npm start`

### Docker deployment
```bash
docker-compose up --build
```
