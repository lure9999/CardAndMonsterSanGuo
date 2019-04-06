
set SourPath=%cd%\Resources\Script
set destPath=%cd%\Byte_lua
set exePath=%cd%\..\..\tools\cocos2d-console\console\bin

cd /d "%SourPath%"
for /f "delims=" %%i in ('dir /ad /b') do (xcopy /i /e /y "%SourPath%\%%i" "%destPath%\%%i")
@echo "lua copy complete"

@Pause