#!/bin/bash

# Зупиняємо існуючі процеси
sudo systemctl stop taskprocessor-api
sudo systemctl stop taskprocessor-client

# Оновлюємо .NET SDK якщо потрібно
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0

# Компілюємо та запускаємо API
cd src/TaskProcessor.API
dotnet build
dotnet run --urls "http://localhost:5000" &

# Встановлюємо залежності та запускаємо клієнт
cd ../../client
npm install
npm run dev &

echo "Development environment started"
echo "API running on http://localhost:5000"
echo "Client running on http://localhost:5173"