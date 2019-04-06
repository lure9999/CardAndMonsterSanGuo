set cur=%cd%\1.txt

@for /f "tokens=* delims=" %%i in ('dir /s /b /a-d *.lua') do @echo %%i>>1.txt

@echo %cur%
cd..
cd D:\work\SVN\client\cocos2d-x-2.2.3\scripting\lua\luajit\LuaJIT-2.0.1\src\

@for /f "delims=," %%i in (%cur%) do luajit.exe -b %%i %%i

pause()