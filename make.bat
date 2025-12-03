@echo off
setlocal EnableDelayedExpansion
rem ===================================
rem LaTeX Project Build Script
rem Last updated: 2025-02-12
rem ===================================

rem Set UTF-8 encoding
chcp 65001 >nul

rem Configuration
set "THESIS=main"
set "DEFAULT_ENGINE=-pdflatex"
set "BUILD_DIR=build"

rem Check for required programs
call :check_requirements
if errorlevel 1 goto :EOF

rem Parse command line arguments
if "%~1" == "" (
    set "ACTION=thesis"
) else (
    set "ACTION=%~1"
)

rem Engine selection with validation
if "%~2" == "" (
    set "ENGINE=%DEFAULT_ENGINE%"
    echo Using default engine: %DEFAULT_ENGINE%
) else (
    set "VALID_ENGINE=0"
    for %%e in (-pdflatex -xelatex -lualatex) do (
        if /i "%~2" == "%%e" (
            set "ENGINE=%%e"
            set "VALID_ENGINE=1"
        )
    )
    if !VALID_ENGINE! equ 0 (
        echo Error: Invalid engine "%~2"
        echo Available engines: -pdflatex, -xelatex, -lualatex
        echo Using default engine: %DEFAULT_ENGINE%
        set "ENGINE=%DEFAULT_ENGINE%"
    )
)

rem Create build directory if it doesn't exist
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

rem Process commands
call :%ACTION% 2>nul
if errorlevel 1 (
    if "%ACTION%" == "thesis" (
        echo.
        echo Error! Please check %BUILD_DIR%\%THESIS%.log for details...
        pause
    ) else (
        echo Error: Unknown command '%ACTION%'
        call :help
    )
)
goto :EOF

:check_requirements
set "MISSING_DEPS="
for %%x in (latexmk texcount) do (
    where %%x >nul 2>nul
    if errorlevel 1 set "MISSING_DEPS=!MISSING_DEPS! %%x"
)
if not "!MISSING_DEPS!" == "" (
    echo Error: Required programs not found:!MISSING_DEPS!
    echo Please install these programs and ensure they are in your PATH.
    exit /B 1
)
exit /B 0

:thesis
echo Building %THESIS%.tex with %ENGINE%...
latexmk %ENGINE% -synctex=1 -quiet -interaction=nonstopmode ^
    -file-line-error -halt-on-error -shell-escape ^
    -output-directory="%BUILD_DIR%" %THESIS%
if errorlevel 1 (
    exit /B 1
) else (
    call :clean
    echo Build completed successfully!
    echo Output files are in %BUILD_DIR% directory
)
exit /B 0

:clean
echo Cleaning auxiliary files...
latexmk -quiet -c -output-directory="%BUILD_DIR%" %THESIS%
del /F /Q *.aux *.log *.out *.toc *.lof *.lot *.bbl *.blg *.fdb_latexmk *.fls 2>nul
for /d %%G in (_minted-%THESIS%*) do rd /s /q "%%~G" 2>nul
echo Clean complete.
exit /B 0

:cleanall
echo Cleaning all generated files...
call :clean
latexmk -quiet -C -output-directory="%BUILD_DIR%" %THESIS%
if exist "%BUILD_DIR%\%THESIS%.pdf" (
    echo Attempting to remove %BUILD_DIR%\%THESIS%.pdf...
    del /F "%BUILD_DIR%\%THESIS%.pdf" 2>nul
    if errorlevel 1 (
        echo Cannot remove PDF - file is in use!
        echo Please close any PDF viewers and try again.
        pause
        goto :cleanall
    )
)
if exist "%BUILD_DIR%" rd /s /q "%BUILD_DIR%" 2>nul
echo Clean complete.
exit /B 0

:wordcount
echo Counting words in %THESIS%.tex...
for /f "tokens=*" %%a in ('texcount -inc -total -sum %THESIS%.tex 2^>nul') do (
    set "LINE=%%a"
    if "!LINE:~0,15!"=="Words in text: " (
        set /a "TOTAL_WORDS=!LINE:~15!"
    )
)

echo Words in %THESIS%.tex: %TOTAL_WORDS%
exit /B 0

:view
if exist "%BUILD_DIR%\%THESIS%.pdf" (
    echo Opening %BUILD_DIR%\%THESIS%.pdf...
    start "" "%BUILD_DIR%\%THESIS%.pdf"
) else (
    echo Error: %BUILD_DIR%\%THESIS%.pdf not found!
    echo Try building the document first with: make.bat thesis
    exit /B 1
)
exit /B 0

:help
echo LaTeX Project Build Script
echo Usage:
echo     make.bat [command] [engine]
echo.
echo Commands:
echo     thesis    Build the document ^(default^)
echo     clean     Remove auxiliary files
echo     cleanall  Remove all generated files including PDF
echo     count     Count words in document
echo     view      Open the PDF
echo     help      Show this help message
echo.
echo Engines:
echo     -pdflatex  PDFLaTeX ^(default^)
echo     -xelatex   XeLaTeX
echo     -lualatex  LuaLaTeX
echo.
echo Examples:
echo     make.bat thesis -xelatex
echo     make.bat count
echo.
echo Output files will be placed in the '%BUILD_DIR%' directory
exit /B 0

:EOF
endlocal
exit /B 0
