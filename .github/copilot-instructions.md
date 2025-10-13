# Copilot Instructions for Inception Project

## Project Overview
This is a hands-on Docker lab project designed to strengthen system administration skills. The project involves building and running multiple Docker images inside a personal virtual machine.

## Project Purpose
- Learn Docker containerization concepts
- Practice system administration skills
- Build multi-container applications
- Understand Docker networking and volumes

## Technology Stack
- **Container Platform**: Docker
- **Infrastructure**: Docker Compose
- **Environment**: Virtual Machine (VM)

## Coding Conventions

### Docker Best Practices
- Use official base images when possible
- Keep Dockerfiles simple and maintainable
- Use multi-stage builds to reduce image size
- Don't run containers as root unless necessary
- Use `.dockerignore` files to exclude unnecessary files
- Pin versions of base images for reproducibility
- Group RUN commands to reduce layers
- Clean up package manager caches in the same layer

### Docker Compose Guidelines
- Use version 3.x for docker-compose.yml files
- Define named volumes for persistent data
- Use environment variables for configuration
- Document service dependencies
- Use health checks for services
- Define restart policies appropriately

### File Organization
- Keep Dockerfiles in their respective service directories
- Store docker-compose files in the project root
- Use clear naming conventions for services and containers
- Keep related configuration files together

### Documentation Standards
- Document service architecture and dependencies
- Include setup and installation instructions
- Provide troubleshooting guides
- Document environment variables and configuration options
- Add inline comments for complex configurations

## Development Workflow
- Test Docker builds locally before committing
- Validate docker-compose configurations
- Check for security vulnerabilities in base images
- Keep images updated with security patches
- Use descriptive commit messages

## Security Considerations
- Never commit secrets or credentials
- Use Docker secrets or environment files for sensitive data
- Follow principle of least privilege
- Keep base images updated
- Scan images for vulnerabilities

## Common Commands
```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and restart
docker-compose up -d --build
```

## Tips for Copilot
- When suggesting Dockerfile changes, ensure they follow multi-stage build patterns where appropriate
- Prioritize security in container configurations
- Suggest health checks for services
- Recommend appropriate restart policies
- Consider resource constraints (memory, CPU limits)
- Suggest using environment variables for configurable values
