#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

check_success() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Last step was not completed, exiting....${NC}"
        exit 1
    fi
}

operation_success() {
    echo ""
    echo -e "${GREEN}Operation completed successfully.${NC}"
    echo ""
}

echo -e "${YELLOW}Pulling latest changes...${NC}"
git pull
check_success
operation_success

echo -e "${YELLOW}apt update and upgrade starting...${NC}"
sudo apt update -qq && sudo apt upgrade -y -qq
check_success
operation_success

echo -e "${YELLOW}Installing dependencies on frontend...${NC}"
cd client
npm install
check_success
operation_success

echo -e "${YELLOW}Frontend build...${NC}"
sudo npm run build
check_success
operation_success

echo -e "${YELLOW}Static files update...${NC}"
sudo rm -rf /var/www/client
sudo cp -r dist /var/www/client
check_success
operation_success

echo -e "${YELLOW}Building .NET API...${NC}"
cd ../src
dotnet publish TaskProcessor.API/TaskProcessor.API.csproj -o debug_output/
check_success
operation_success

if tmux has-session -t taskprocessor-api 2>/dev/null; then
    echo -e "${YELLOW}Session 'taskprocessor-api' already running.${NC}"
    echo "What should I do?:"
    echo "1) Run new tmux instance 'taskprocessor-api_1'"
    echo "2) Kill old session and start new"
    echo "3) Abort deploy"
    read -p "Enter 1\2\3: " choice

    if [ "$choice" == "1" ]; then
        echo -e "${YELLOW}Running new session 'taskprocessor-api_1'...${NC}"
        tmux new-session -d -s taskprocessor-api_1 'dotnet debug_output/TaskProcessor.API.dll'
        check_success
        operation_success

    elif [ "$choice" == "2" ]; then
        echo -e "${YELLOW}Killing 'taskprocessor-api'...${NC}"
        tmux kill-session -t taskprocessor-api
        check_success
        echo -e "${GREEN}Session 'taskprocessor-api' killed.${NC}"
        echo -e "${YELLOW}Running 'taskprocessor-api'...${NC}"
        tmux new-session -d -s taskprocessor-api 'dotnet debug_output/TaskProcessor.API.dll'
        check_success
        operation_success

    else
        echo -e "${RED}Deploy aborted.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Running new tmux session...${NC}"
    tmux new-session -d -s taskprocessor-api 'dotnet debug_output/TaskProcessor.API.dll'
    check_success
    operation_success
fi

echo -e "${BLUE}Deployment completed successfully.${NC}"