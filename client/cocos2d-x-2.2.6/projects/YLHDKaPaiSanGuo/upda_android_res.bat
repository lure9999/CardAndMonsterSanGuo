
@echo off

set SourPath=%cd%\Resources

set SourPath_Script_Byte=%cd%\Byte_lua_jit

set SourPath_Image_Byte=%cd%\Byte_Image

set destPath_res=%cd%\proj.android\assets\

set NotCopy=Script

set NotCopy1=Image

@Rem ������Դ

xcopy /i /e /y "%SourPath%" "%destPath_res%"


@Rem ����2���ƽű�
PUSHD %SourPath_Script_Byte%
for /f "delims=" %%i in ('dir /ad /b') do (xcopy /i /e /y "%%i" "%destPath_res%%NotCopy%\%%i")

 
@Rem ����2����tupian

xcopy /i /e /y "%SourPath_Image_Byte%" "%destPath_res%%NotCopy1%"


@echo "demo ������Դ �ɹ�" 
@Pause