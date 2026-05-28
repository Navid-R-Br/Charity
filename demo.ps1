# Charity API Demo - PowerShell Script
$baseUrl = "http://127.0.0.1:8000"

Write-Host "=== Charity API Demo ===" -ForegroundColor Cyan

# Step 1: Register benefactor
Write-Host "Step 1: Register benefactor user" -ForegroundColor Yellow
$body = @{
    username = "demo_benefactor"
    password = "StrongP@ss123"
    phone = "09123456789"
    address = "Tehran, Iran"
    gender = "M"
    age = 25
    description = "I want to help"
    first_name = "Demo"
    last_name = "Benefactor"
    email = "demo@example.com"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$baseUrl/accounts/register/" -Method Post -Body $body -ContentType "application/json"
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 2: Login benefactor
Write-Host "Step 2: Login benefactor" -ForegroundColor Yellow
$body = @{ username = "demo_benefactor"; password = "StrongP@ss123" } | ConvertTo-Json
$login = Invoke-RestMethod -Uri "$baseUrl/accounts/login/" -Method Post -Body $body -ContentType "application/json"
$benefactorToken = $login.token
Write-Host "Benefactor token: $benefactorToken" -ForegroundColor Green

# Step 3: Create Benefactor profile
Write-Host "Step 3: Create Benefactor profile" -ForegroundColor Yellow
$headers = @{ Authorization = "Token $benefactorToken" }
$body = @{ experience = 1; free_time_per_week = 10 } | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$baseUrl/benefactors/" -Method Post -Body $body -Headers $headers -ContentType "application/json"
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 4: Register charity user
Write-Host "Step 4: Register charity user" -ForegroundColor Yellow
$body = @{
    username = "demo_charity"
    password = "Charity@123"
    phone = "09987654321"
    address = "Tehran, Iran"
    gender = "F"
    age = 40
    description = "Charity organization"
    first_name = "Demo"
    last_name = "Charity"
    email = "charity@example.com"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$baseUrl/accounts/register/" -Method Post -Body $body -ContentType "application/json"
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 5: Login charity
Write-Host "Step 5: Login charity" -ForegroundColor Yellow
$body = @{ username = "demo_charity"; password = "Charity@123" } | ConvertTo-Json
$login = Invoke-RestMethod -Uri "$baseUrl/accounts/login/" -Method Post -Body $body -ContentType "application/json"
$charityToken = $login.token
Write-Host "Charity token: $charityToken" -ForegroundColor Green

# Step 6: Create Charity profile
Write-Host "Step 6: Create Charity profile" -ForegroundColor Yellow
$headers = @{ Authorization = "Token $charityToken" }
$body = @{ name = "Helping Hands"; reg_number = "1234567890" } | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$baseUrl/charities/" -Method Post -Body $body -Headers $headers -ContentType "application/json"
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 7: Create Task
Write-Host "Step 7: Create Task" -ForegroundColor Yellow
$body = @{
    title = "Food distribution event"
    description = "Need helpers to pack and distribute meals"
    date = "2025-06-01"
    age_limit_from = 18
    age_limit_to = 60
    gender_limit = "MF"
} | ConvertTo-Json
$task = Invoke-RestMethod -Uri "$baseUrl/tasks/" -Method Post -Body $body -Headers $headers -ContentType "application/json"
$taskId = $task.id
Write-Host "Created task with ID: $taskId" -ForegroundColor Green
Write-Host "Task: $($task | ConvertTo-Json)" -ForegroundColor Green

# Step 8: List tasks (as benefactor)
Write-Host "Step 8: List tasks (benefactor)" -ForegroundColor Yellow
$headers = @{ Authorization = "Token $benefactorToken" }
$tasks = Invoke-RestMethod -Uri "$baseUrl/tasks/" -Method Get -Headers $headers
Write-Host "Tasks: $($tasks | ConvertTo-Json)" -ForegroundColor Green

# Step 9: Request task (benefactor)
Write-Host "Step 9: Request task (benefactor)" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/tasks/$taskId/request/" -Method Get -Headers $headers
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 10: Charity accepts request
Write-Host "Step 10: Charity accepts request" -ForegroundColor Yellow
$headers = @{ Authorization = "Token $charityToken" }
$body = @{ response = "A" } | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$baseUrl/tasks/$taskId/response/" -Method Post -Body $body -Headers $headers -ContentType "application/json"
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 11: Mark task as done
Write-Host "Step 11: Mark task as done" -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "$baseUrl/tasks/$taskId/done/" -Method Post -Headers $headers
Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Green

# Step 12: Open About Us page
Write-Host "Step 12: Opening About Us page in browser" -ForegroundColor Yellow
Start-Process "http://127.0.0.1:8000/about-us/"

Write-Host "Demo completed successfully!" -ForegroundColor Cyan