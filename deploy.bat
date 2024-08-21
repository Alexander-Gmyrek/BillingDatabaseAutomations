@echo off
REM Navigate to the Docker compose directory
cd /d "{{DOCKER_COMPOSE_DIR}}" || (
    echo Failed to navigate to the Docker compose directory.
    exit /b 1
)

REM Deploy Docker containers
docker-compose up -d --build || (
    echo Docker Compose deployment failed.
    exit /b 1
)

echo Docker Compose deployment succeeded.
exit /b 0
