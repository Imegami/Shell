@echo off
setlocal enabledelayedexpansion
title Python to EXE Converter v1.0
color 0A

:: Configuración de rutas por defecto
set "DESKTOP=%USERPROFILE%\Desktop"
set "DOCUMENTS=%USERPROFILE%\Documents"
set "DOWNLOADS=%USERPROFILE%\Downloads"
set "OUTPUT_DIR=%USERPROFILE%\Desktop\Python_EXE_Output"

:: Banner del programa
echo.
echo ========================================
echo    PYTHON TO EXE CONVERTER v1.0
echo ========================================
echo.

:: Verificar si Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no esta instalado o no esta en PATH
    echo Por favor instala Python desde python.org
    pause
    exit /b 1
)

:: Verificar si PyInstaller está instalado
pip show pyinstaller >nul 2>&1
if errorlevel 1 (
    echo [INFO] PyInstaller no esta instalado. Instalando...
    pip install pyinstaller
    if errorlevel 1 (
        echo [ERROR] No se pudo instalar PyInstaller
        pause
        exit /b 1
    )
    echo [OK] PyInstaller instalado correctamente
)

:MAIN_MENU
cls
echo.
echo ========================================
echo    PYTHON TO EXE CONVERTER v1.0
echo ========================================
echo.
echo 1. Buscar archivos .py en Desktop
echo 2. Buscar archivos .py en Documents  
echo 3. Buscar archivos .py en Downloads
echo 4. Introducir ruta personalizada
echo 5. Convertir archivo especifico
echo 6. Configurar opciones avanzadas
echo 7. Salir
echo.
set /p "choice=Selecciona una opcion (1-7): "

if "%choice%"=="1" (
    set "SEARCH_PATH=%DESKTOP%"
    goto SEARCH_FILES
)
if "%choice%"=="2" (
    set "SEARCH_PATH=%DOCUMENTS%"
    goto SEARCH_FILES
)
if "%choice%"=="3" (
    set "SEARCH_PATH=%DOWNLOADS%"
    goto SEARCH_FILES
)
if "%choice%"=="4" goto CUSTOM_PATH
if "%choice%"=="5" goto SPECIFIC_FILE
if "%choice%"=="6" goto ADVANCED_OPTIONS
if "%choice%"=="7" exit /b 0

echo Opcion invalida. Presiona cualquier tecla para continuar...
pause >nul
goto MAIN_MENU

:SEARCH_FILES
cls
echo.
echo Buscando archivos .py en: %SEARCH_PATH%
echo.

:: Crear directorio de salida si no existe
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Buscar archivos Python
set count=0
for /f "delims=" %%i in ('dir /b "%SEARCH_PATH%\*.py" 2^>nul') do (
    set /a count+=1
    set "file!count!=%%i"
    echo !count!. %%i
)

if %count%==0 (
    echo No se encontraron archivos .py en esta ubicacion.
    echo.
    set /p "continue=Presiona ENTER para volver al menu..."
    goto MAIN_MENU
)

echo.
echo 0. Convertir TODOS los archivos
echo 99. Volver al menu principal
echo.
set /p "selection=Selecciona el archivo a convertir: "

if "%selection%"=="99" goto MAIN_MENU
if "%selection%"=="0" goto CONVERT_ALL

if %selection% gtr %count% (
    echo Seleccion invalida.
    pause
    goto SEARCH_FILES
)

:: Convertir archivo seleccionado
set "selected_file=!file%selection%!"
set "full_path=%SEARCH_PATH%\!selected_file!"
goto CONVERT_SINGLE

:CONVERT_ALL
echo.
echo Convirtiendo todos los archivos Python...
echo.
for /L %%i in (1,1,%count%) do (
    set "current_file=!file%%i!"
    echo Convirtiendo: !current_file!
    call :CONVERT_FILE "%SEARCH_PATH%\!current_file!"
)
echo.
echo [OK] Conversion completada. Archivos guardados en: %OUTPUT_DIR%
pause
goto MAIN_MENU

:CONVERT_SINGLE
echo.
echo Convirtiendo: %selected_file%
call :CONVERT_FILE "%full_path%"
echo.
echo [OK] Conversion completada. Archivo guardado en: %OUTPUT_DIR%
pause
goto MAIN_MENU

:CUSTOM_PATH
cls
echo.
echo === RUTA PERSONALIZADA ===
echo.
set /p "custom_path=Introduce la ruta completa del directorio: "

if not exist "%custom_path%" (
    echo [ERROR] La ruta especificada no existe.
    pause
    goto MAIN_MENU
)

set "SEARCH_PATH=%custom_path%"
goto SEARCH_FILES

:SPECIFIC_FILE
cls
echo.
echo === ARCHIVO ESPECIFICO ===
echo.
set /p "specific_file=Introduce la ruta completa del archivo .py: "

if not exist "%specific_file%" (
    echo [ERROR] El archivo especificado no existe.
    pause
    goto MAIN_MENU
)

:: Verificar extensión
echo "%specific_file%" | findstr /i "\.py$" >nul
if errorlevel 1 (
    echo [ERROR] El archivo debe tener extension .py
    pause
    goto MAIN_MENU
)

echo.
echo Convirtiendo archivo especifico...
call :CONVERT_FILE "%specific_file%"
echo.
echo [OK] Conversion completada. Archivo guardado en: %OUTPUT_DIR%
pause
goto MAIN_MENU

:ADVANCED_OPTIONS
cls
echo.
echo === OPCIONES AVANZADAS ===
echo.
echo Opciones actuales:
echo - Directorio de salida: %OUTPUT_DIR%
echo - Modo: Una sola ventana (--onefile)
echo - Sin consola: Desactivado
echo.
echo 1. Cambiar directorio de salida
echo 2. Activar/Desactivar modo sin consola (--windowed)
echo 3. Volver al menu principal
echo.
set /p "adv_choice=Selecciona opcion: "

if "%adv_choice%"=="1" (
    set /p "new_output=Nueva ruta de salida: "
    if exist "!new_output!" (
        set "OUTPUT_DIR=!new_output!"
        echo Directorio actualizado.
    ) else (
        echo Directorio invalido.
    )
    pause
)
if "%adv_choice%"=="2" (
    if defined WINDOWED_MODE (
        set "WINDOWED_MODE="
        echo Modo consola activado
    ) else (
        set "WINDOWED_MODE=--windowed"
        echo Modo sin consola activado
    )
    pause
)
if "%adv_choice%"=="3" goto MAIN_MENU

goto ADVANCED_OPTIONS

:: Función para convertir archivos
:CONVERT_FILE
set "input_file=%~1"
set "file_name=%~n1"
set "output_path=%OUTPUT_DIR%\%file_name%.exe"

echo.
echo ----------------------------------------
echo Procesando: %file_name%.py
echo ----------------------------------------

:: Ejecutar PyInstaller
cd /d "%~dp1"
pyinstaller --onefile %WINDOWED_MODE% --distpath "%OUTPUT_DIR%" "%input_file%" --log-level WARN

:: Limpiar archivos temporales
if exist "%~dp1build" rmdir /s /q "%~dp1build"
if exist "%~dp1%file_name%.spec" del "%~dp1%file_name%.spec"

:: Verificar si se creó el ejecutable
if exist "%output_path%" (
    echo [OK] %file_name%.exe creado exitosamente
) else (
    echo [ERROR] Fallo al crear %file_name%.exe
)

goto :eof
