@echo off
REM Navigate to the Docker compose directory
cd /d "{{DOCKER_COMPOSE_DIR}}" || (
    echo Failed to navigate to the Docker compose directory.
    exit /b 1
)

REM Restart Docker containers
docker-compose restart || (
    echo Docker Compose restart failed.
    exit /b 1
)

echo Docker Compose restart succeeded.
exit /b 0
