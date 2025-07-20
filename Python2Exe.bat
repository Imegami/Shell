@echo off
title Python to EXE Converter
color 0A

echo ===============================================
echo     CONVERTIDOR PYTHON 2 EXE
echo ===============================================
echo.

REM Verificar que Python este instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no esta instalado o no esta en PATH
    echo Por favor instala Python desde python.org
    pause
    exit /b 1
)

echo [OK] Python detectado correctamente
echo.

REM Instalar PyInstaller
echo Instalando PyInstaller...
pip install pyinstaller
if errorlevel 1 (
    echo [ERROR] No se pudo instalar PyInstaller
    pause
    exit /b 1
)

echo [OK] PyInstaller instalado
echo.

REM Crear el archivo Python del convertidor
echo Creando archivo del convertidor...

(
echo import tkinter as tk
echo from tkinter import ttk, filedialog, messagebox, scrolledtext
echo import os
echo import subprocess
echo import threading
echo import sys
echo from pathlib import Path
echo.
echo class PythonToExeConverter:
echo     def __init__(self, root^):
echo         self.root = root
echo         self.root.title("Python to EXE Converter"^)
echo         self.root.geometry("800x600"^)
echo         self.root.minsize(700, 500^)
echo         
echo         # Variables
echo         self.selected_files = []
echo         self.output_dir = ""
echo         
echo         # Configurar estilo
echo         self.setup_style(^)
echo         
echo         # Crear interfaz
echo         self.create_widgets(^)
echo         
echo         # Verificar PyInstaller
echo         self.check_pyinstaller(^)
echo     
echo     def setup_style(self^):
echo         """Configurar estilo moderno"""
echo         style = ttk.Style(^)
echo         style.theme_use('clam'^)
echo         
echo         # Colores modernos
echo         style.configure('Title.TLabel', font=('Arial', 16, 'bold'^), foreground='#2c3e50'^)
echo         style.configure('Heading.TLabel', font=('Arial', 10, 'bold'^), foreground='#34495e'^)
echo         style.configure('Modern.TButton', padding=(10, 5^)^)
echo         
echo     def create_widgets(self^):
echo         """Crear la interfaz gráfica"""
echo         main_frame = ttk.Frame(self.root, padding="20"^)
echo         main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S^)^)
echo         
echo         # Configurar grid
echo         self.root.columnconfigure(0, weight=1^)
echo         self.root.rowconfigure(0, weight=1^)
echo         main_frame.columnconfigure(1, weight=1^)
echo         
echo         # Título
echo         title_label = ttk.Label(main_frame, text="Python to EXE Converter", 
echo                                style='Title.TLabel'^)
echo         title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20^)^)
echo         
echo         # Sección de selección de archivos
echo         files_frame = ttk.LabelFrame(main_frame, text="Selección de Archivos Python", 
echo                                     padding="10"^)
echo         files_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E^), pady=(0, 10^)^)
echo         files_frame.columnconfigure(0, weight=1^)
echo         
echo         # Botones de selección rápida
echo         quick_buttons_frame = ttk.Frame(files_frame^)
echo         quick_buttons_frame.grid(row=0, column=0, columnspan=3, sticky=(tk.W, tk.E^), pady=(0, 10^)^)
echo         
echo         ttk.Button(quick_buttons_frame, text="Desktop", 
echo                   command=lambda: self.browse_folder(Path.home(^) / "Desktop"^),
echo                   style='Modern.TButton'^).pack(side=tk.LEFT, padx=(0, 5^)^)
echo         
echo         ttk.Button(quick_buttons_frame, text="Documents", 
echo                   command=lambda: self.browse_folder(Path.home(^) / "Documents"^),
echo                   style='Modern.TButton'^).pack(side=tk.LEFT, padx=5^)
echo         
echo         ttk.Button(quick_buttons_frame, text="Downloads", 
echo                   command=lambda: self.browse_folder(Path.home(^) / "Downloads"^),
echo                   style='Modern.TButton'^).pack(side=tk.LEFT, padx=5^)
echo         
echo         ttk.Button(quick_buttons_frame, text="Examinar...", 
echo                   command=self.browse_files,
echo                   style='Modern.TButton'^).pack(side=tk.LEFT, padx=5^)
) > temp_converter.py

echo [OK] Archivo del convertidor creado
echo.

REM Crear el ejecutable
echo Creando ejecutable... (esto puede tomar unos minutos^)
pyinstaller --onefile --windowed --name "PythonToExeConverter" temp_converter.py

if exist "dist\PythonToExeConverter.exe" (
    echo.
    echo ===============================================
    echo            CONVERSION EXITOSA!
    echo ===============================================
    echo.
    echo El ejecutable esta listo en:
    echo %cd%\dist\PythonToExeConverter.exe
    echo.
    echo Limpiando archivos temporales...
    rmdir /s /q build 2>nul
    rmdir /s /q __pycache__ 2>nul
    del PythonToExeConverter.spec 2>nul
    del temp_converter.py 2>nul
    
    echo.
    echo ^> Ejecuta: dist\PythonToExeConverter.exe
    echo.
    pause
    start dist\PythonToExeConverter.exe
) else (
    echo [ERROR] No se pudo crear el ejecutable
    pause
)
