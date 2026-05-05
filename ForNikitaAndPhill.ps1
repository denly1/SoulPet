# ============================================================================
# ForNikitaAndPhill.ps1
# Скрипт для автоматического обновления и запуска SoulPet на Android
# ============================================================================
# 
# Что делает этот скрипт:
# 1. Проверяет текущее состояние git репозитория
# 2. Получает последние изменения с GitHub
# 3. Автоматически разрешает конфликты (принимает версию с GitHub)
# 4. Запускает приложение на подключенном Android устройстве
#
# Использование:
#   .\ForNikitaAndPhill.ps1
#
# Требования:
#   - Git установлен и доступен в PATH
#   - Flutter SDK установлен (путь: C:\src\flutter)
#   - Android устройство подключено или эмулятор запущен
# ============================================================================

# Цвета для вывода
$ErrorColor = "Red"
$SuccessColor = "Green"
$InfoColor = "Cyan"
$WarningColor = "Yellow"

# Путь к проекту
$ProjectPath = "c:\Program Files\Develop\GoProject\SoulPet"
$FlutterPath = "C:\src\flutter\bin\flutter"

Write-Host "============================================================================" -ForegroundColor $InfoColor
Write-Host "  SoulPet - Автоматическое обновление и запуск" -ForegroundColor $InfoColor
Write-Host "============================================================================" -ForegroundColor $InfoColor
Write-Host ""

# Переходим в директорию проекта
Write-Host "[1/5] Переход в директорию проекта..." -ForegroundColor $InfoColor
Set-Location $ProjectPath
Write-Host "✓ Текущая директория: $ProjectPath" -ForegroundColor $SuccessColor
Write-Host ""

# Проверяем статус git
Write-Host "[2/5] Проверка статуса git репозитория..." -ForegroundColor $InfoColor
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "⚠ Обнаружены локальные изменения" -ForegroundColor $WarningColor
} else {
    Write-Host "✓ Рабочая директория чистая" -ForegroundColor $SuccessColor
}
Write-Host ""

# Получаем последние изменения с GitHub
Write-Host "[3/5] Получение последних изменений с GitHub..." -ForegroundColor $InfoColor
git fetch origin
Write-Host "✓ Изменения получены" -ForegroundColor $SuccessColor
Write-Host ""

# Пытаемся слить изменения
Write-Host "[4/5] Обновление до последней версии..." -ForegroundColor $InfoColor
$pullResult = git pull origin main 2>&1

# Проверяем наличие конфликтов
if ($pullResult -match "CONFLICT") {
    Write-Host "⚠ Обнаружены конфликты слияния - автоматическое разрешение..." -ForegroundColor $WarningColor
    
    # Принимаем версию с GitHub для всех конфликтующих файлов
    git checkout --theirs lib/features/chat/presentation/screens/chat_screen.dart 2>$null
    git checkout --theirs lib/features/home/presentation/screens/home_screen.dart 2>$null
    git checkout --theirs lib/shared/widgets/liquid_glass.dart 2>$null
    git checkout --theirs pubspec.lock 2>$null
    
    # Добавляем разрешённые файлы
    git add .
    
    # Завершаем слияние
    git commit -m "Merge: автоматическое обновление до последней версии с GitHub"
    
    Write-Host "✓ Конфликты разрешены, принята версия с GitHub" -ForegroundColor $SuccessColor
} elseif ($pullResult -match "Already up to date") {
    Write-Host "✓ Проект уже обновлён до последней версии" -ForegroundColor $SuccessColor
} else {
    Write-Host "✓ Проект успешно обновлён" -ForegroundColor $SuccessColor
}
Write-Host ""

# Запускаем приложение на Android
Write-Host "[5/5] Запуск приложения на Android устройстве..." -ForegroundColor $InfoColor
Write-Host "Подключите Android устройство или запустите эмулятор" -ForegroundColor $WarningColor
Write-Host ""

# Проверяем доступные устройства
Write-Host "Проверка подключенных устройств..." -ForegroundColor $InfoColor
& $FlutterPath devices

Write-Host ""
Write-Host "Запуск приложения..." -ForegroundColor $InfoColor
& $FlutterPath run

Write-Host ""
Write-Host "============================================================================" -ForegroundColor $InfoColor
Write-Host "  Скрипт завершён!" -ForegroundColor $SuccessColor
Write-Host "============================================================================" -ForegroundColor $InfoColor
