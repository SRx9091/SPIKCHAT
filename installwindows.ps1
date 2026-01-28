Write-Host "=== Configuración de Entorno de Desarrollo IA para Telegram ===" -ForegroundColor Cyan

Write-Host "`n1. Creando entorno virtual..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "   Entorno virtual ya existe, omitiendo." -ForegroundColor Green
} else {
    python -m venv venv
    Write-Host "   Entorno virtual creado." -ForegroundColor Green
}

Write-Host "`n2. Instalando dependencias..." -ForegroundColor Yellow
.\venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install python-telegram-bot==20.7 requests python-dotenv
Write-Host "   Dependencias instaladas." -ForegroundColor Green

Write-Host "`n3. Configurando modelo Ollama..." -ForegroundColor Yellow
try {
    $ollamaCheck = ollama list
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   Ollama no está en PATH o no está instalado." -ForegroundColor Red
        Write-Host "   Por favor, instala Ollama manualmente desde https://ollama.com" -ForegroundColor Red
    }
} catch {
    Write-Host "   Ollama no encontrado. Instala manualmente." -ForegroundColor Red
}

Write-Host "`n   Descargando modelo dolphin-llama3..." -ForegroundColor Yellow
ollama pull dolphin-llama3
Write-Host "   Modelo descargado/verificado." -ForegroundColor Green

Write-Host "`n4. Configurando variables de entorno..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    @"
TELEGRAM_BOT_TOKEN=tu_token_aqui
"@ | Out-File -FilePath ".env" -Encoding UTF8
    Write-Host "   Archivo .env creado. Agrega tu token de Telegram." -ForegroundColor Green
} else {
    Write-Host "   Archivo .env ya existe." -ForegroundColor Green
}

Write-Host "`n5. Creando archivo de ejecución automática..." -ForegroundColor Yellow
@"
@echo off
cd /d %~dp0
call venv\Scripts\activate.bat
python main.py
pause
"@ | Out-File -FilePath "RUN_BOT.bat" -Encoding ASCII

Write-Host "   Archivo RUN_BOT.bat creado." -ForegroundColor Green

Write-Host "`n=== Configuración completada ===" -ForegroundColor Cyan
Write-Host "`nPasos finales:" -ForegroundColor Yellow
Write-Host "1. Agrega tu token de Telegram en el archivo .env" -ForegroundColor White
Write-Host "2. Asegúrate que Ollama esté ejecutándose (ollama serve)" -ForegroundColor White
Write-Host "3. Ejecuta RUN_BOT.bat para iniciar el bot" -ForegroundColor White
Write-Host "`nModelo activo: dolphin-llama3" -ForegroundColor Magenta
Write-Host "Puerto Ollama: localhost:11434" -ForegroundColor Magenta
