
set SourPath=%cd%\Resources\Script
set destPath=%cd%\Byte_lua_jit
set exePath=%cd%\..\..\tools\cocos2d-console\console\bin

cd /d "%SourPath%"
for /f "delims=" %%i in ('dir /ad /b') do (xcopy /i /e /y "%SourPath%\%%i" "%destPath%\%%i")
@echo "lua copy complete"

cd /d "%destPath%"
@for /f "tokens=* delims=" %%i in ('dir /s /b /a-d *.lua') do ( 
cd /d "%exePath%" 
luajit -b %%i %%i
 cd /d "%destPath%"
)

@echo "lua to byte complete"
@Pause