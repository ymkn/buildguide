@echo off
setlocal enabledelayedexpansion

echo ===================================
echo  Build Guide Builder
echo ===================================
echo.

REM Check if Pandoc is installed
where pandoc >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Pandoc is not installed or not in PATH
    echo Please install Pandoc from https://pandoc.org/
    pause
    exit /b 1
)

REM Check if src directory exists
if not exist "src" (
    echo [ERROR] Source directory 'src' not found
    pause
    exit /b 1
)

REM Check if template exists
if not exist "template\template.html" (
    echo [ERROR] Template file template\template.html not found
    pause
    exit /b 1
)

REM Create docs directory structure if it doesn't exist
if not exist "docs" mkdir docs
if not exist "docs\css" mkdir docs\css
if not exist "docs\images" mkdir docs\images

echo [INFO] Copying CSS files...
REM Copy CSS files
copy src\css\style.css docs\css\ >nul
if %errorlevel% neq 0 (
    echo [ERROR] Failed to copy CSS files
    pause
    exit /b 1
)

echo [INFO] Processing Markdown files...
REM Process all .md files in src directory
set "found_files=0"
for %%f in (src\*.md) do (
    set "found_files=1"
    set "filename=%%~nf"
    echo [INFO] Processing: %%f
    echo [INFO] Output: docs\!filename!.html
    
    REM Convert Markdown to HTML
    pandoc --standalone -f markdown -t html5 --css css/style.css --template template/template.html --toc -i "%%f" -o "docs\!filename!.html"
    
    if !errorlevel! neq 0 (
        echo [ERROR] Failed to convert %%f to HTML
        pause
        exit /b 1
    )
    
    REM Copy corresponding image directory if it exists
    if exist "src\images\!filename!" (
        echo [INFO] Copying images for: !filename!
        if not exist "docs\images\!filename!" mkdir "docs\images\!filename!"
        xcopy "src\images\!filename!" "docs\images\!filename!" /E /I /Y >nul
        if !errorlevel! neq 0 (
            echo [ERROR] Failed to copy images for !filename!
            pause
            exit /b 1
        )
    ) else (
        echo [INFO] No image directory found for: !filename!
    )
    
    echo [SUCCESS] Completed: !filename!.html
    echo.
)

if "%found_files%"=="0" (
    echo [ERROR] No Markdown files found in src directory
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Build completed successfully!
echo Output directory: docs\
echo.
echo Files generated:
for %%f in (docs\*.html) do (
    echo   - %%~nxf
)
echo.
echo Ready for GitHub Pages deployment!
echo.
pause
