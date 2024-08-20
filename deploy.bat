@echo off
REM Navigate to the Docker compose directory
cd C:\path\to\your\docker-compose\files

REM Deploy Docker containers
docker-compose up -d --build
