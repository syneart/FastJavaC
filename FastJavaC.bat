::https://www.syneart.com
@echo off&set mytitle=FastJavaC v1.9 (20151113) by Syneart
title %mytitle%
if (%~n1) EQU () echo 不要直接點擊本批次檔, 請將 *.Java 拖曳至本批次檔案圖示開啟&set /p .=&goto End
title [ %~nx1 ] - %mytitle%
set nowDirectory="%cd%"&set maybeisx86on64="false"&set Wow6432Node=\
:getJDKPath
if %maybeisx86on64% EQU "true" (set Wow6432Node=\Wow6432Node\)
set packagePath=nul&set CheckpackagePath=nul&set fileTmepPath=%temp%\fastJavaTmp&set HaveParameter="false"&set CanClose="false"&set NoMainFunction=*
(for /f "tokens=2* delims=	 " %%a in ('REG QUERY "hklm\SOfTWaRE%Wow6432Node%JavaSoft\Java Development Kit" /v CurrentVersion') do set JavaVersion=%%b) >nul 2>nul
if "%JavaVersion%" EQU "" if %maybeisx86on64% EQU "false" (set maybeisx86on64="true"&goto getJDKPath)
for /f "tokens=2* delims=	 " %%a in ('REG QUERY "hklm\SOfTWaRE%Wow6432Node%JavaSoft\Java Development Kit\%JavaVersion%" /v JavaHome') do set JavaHome=%%b\bin\
for /f "tokens=1* delims=:package" %%a in ('findstr /i /n "package " %1') do set packagePath=%%b
set packagePath=%packagePath:;=%
set packagePath=%packagePath: =%
set CheckpackagePath=%packagePath://=EOF%
if "%packagePath%" EQU "nul" (set packagePath=%~n1)
if "%CheckpackagePath%" NEQ "%packagePath%" (set packagePath=%~n1)
:main
cls
for /f "tokens=1* delims=:main" %%a in ('findstr /i /n "void main" %1') do (set NoMainFunction=%~n1)
md %fileTmepPath% >nul 2>nul
del %fileTmepPath%\%~n1.class >nul 2>nul
del %fileTmepPath%\%packagePath%\%~n1.class >nul 2>nul
echo ^>^> %~n1 檔案編譯中, 請稍後 ...&echo.
cd /d %~dp1%
"%JavaHome%javac" %NoMainFunction%.java -d %fileTmepPath%
if "%JavaVersion%" EQU "" if %maybeisx86on64% EQU "true" (echo.&echo 請先下載安裝 Java SE Development Kit ^(JDK^)&set /p .=&goto End)
if not exist %fileTmepPath%\%~n1.class (
   if not exist %fileTmepPath%\%packagePath%\%~n1.class (echo.&echo 請修正以上錯誤 !! 並按 Enter 鍵重新編譯 ... &set /p .=&goto main)
   set packagePath=%packagePath%.%~n1
)
for /f "tokens=1* delims=" %%a in ('findstr /i /n "\<arg.*[0-9]\>" %1') do (set HaveParameter="true")
if %HaveParameter% EQU "true" (cls&echo 您所拖曳的 Java 程式需要輸入參數，請輸入參數 :&set /p argument=)
for /f "tokens=1* delims=:.awt" %%a in ('findstr /i /n ".awt " %1') do (set CanClose="true")
for /f "tokens=1* delims=:.swing " %%a in ('findstr /i /n ".swing " %1') do (set CanClose="true")
echo ^>^> 執行 %~n1 ...
if %CanClose% EQU "false" (cls)
cd /d %fileTmepPath%
"%JavaHome%java" %packagePath% %argument%
if %CanClose% EQU "false" (echo.&&cd %nowDirectory%&&set /p .=^>^> 執行完畢，按任意鍵結束程式 ...)
:End