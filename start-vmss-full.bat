@echo off
rem ------------------------------------------------------------
rem   Full launcher for Vehicle Management and Service System (VMSS)
rem ------------------------------------------------------------

set "PROJECT_ROOT=C:\Users\Arun kumar\OneDrive\Desktop\sid\vehicle-management-system"
set "TOOLS_DIR=C:\Users\Arun kumar\OneDrive\Desktop\sid\.tools"
set "MAVEN_BIN=%TOOLS_DIR%\apache-maven-3.9.6\bin"
set "TOMCAT_DIR=%TOOLS_DIR%\apache-tomcat-10.1.20"
set "JAVA_HOME=C:\Program Files\Java\jdk-23"

set "PATH=%JAVA_HOME%\bin;%MAVEN_BIN%;%PATH%"

echo [1/3] Checking WAR deployment package...
set "WAR_SOURCE=%PROJECT_ROOT%\target\vmss.war"
set "WAR_DEST=%TOMCAT_DIR%\webapps\vmss.war"

if not exist "%WAR_SOURCE%" (
    echo Building VMSS WAR ...
    cd /d "%PROJECT_ROOT%"
    call "%MAVEN_BIN%\mvn.cmd" clean package -DskipTests
)

copy /Y "%WAR_SOURCE%" "%WAR_DEST%" >nul
echo       WAR package deployed to Tomcat.

echo [2/3] Starting Apache Tomcat 10.1...
start "Tomcat VMSS" cmd /k "set JAVA_HOME=%JAVA_HOME% && cd /d "%TOMCAT_DIR%\bin" && catalina.bat run"

echo [3/3] Opening browser...
timeout /t 5 >nul
start "" "http://localhost:8080/vmss/"

echo ============================================================
echo VMSS is now running! Keep the Tomcat console window open.
echo URL: http://localhost:8080/vmss/
echo ============================================================
pause
