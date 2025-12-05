@echo off
REM === VARIABLES ===
SET SRC_ROOT_DIR=src
SET LIB_DIR=lib
SET JAR_NAME=framework.jar
SET TEMP_BUILD_DIR=temp_classes
SET LIB_TEST=..\..\test_sprint\lib
SET SOURCES_LIST=framework_sources.txt

echo === PRÉPARATION DU BUILD DU FRAMEWORK ===

REM Nettoyage initial
IF EXIST "%TEMP_BUILD_DIR%" RMDIR /S /Q "%TEMP_BUILD_DIR%"
MKDIR "%TEMP_BUILD_DIR%"

IF NOT EXIST "%LIB_DIR%" MKDIR "%LIB_DIR%"

REM === COMPILATION ===
echo === COMPILATION DES CLASSES JAVA DU FRAMEWORK ===

REM Trouver tous les fichiers .java
DIR /S /B "%SRC_ROOT_DIR%\*.java" > "%SOURCES_LIST%"

echo Fichiers Framework à compiler:
type "%SOURCES_LIST%"

REM Compilation
javac -cp "%LIB_DIR%\*" ^
    -d "%TEMP_BUILD_DIR%" ^
    -sourcepath "%SRC_ROOT_DIR%" ^
    @"%SOURCES_LIST%"

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur de compilation du Framework
    DEL "%SOURCES_LIST%"
    exit /b 1
)

DEL "%SOURCES_LIST%"

echo ✅ Compilation du Framework réussie

REM === CREATION DU JAR ===
echo === CREATION DU JAR ===
jar -cvf "%LIB_DIR%\%JAR_NAME%" -C "%TEMP_BUILD_DIR%" .

REM === DEPLOIEMENT ===
echo === DEPLOIEMENT DU JAR DANS LE PROJET TEST ===
IF NOT EXIST "%LIB_TEST%" MKDIR "%LIB_TEST%"
COPY "%LIB_DIR%\%JAR_NAME%" "%LIB_TEST%"

REM === NETTOYAGE ===
echo === NETTOYAGE ===
RMDIR /S /Q "%TEMP_BUILD_DIR%"

echo === DEPLOIEMENT TERMINÉ ===
