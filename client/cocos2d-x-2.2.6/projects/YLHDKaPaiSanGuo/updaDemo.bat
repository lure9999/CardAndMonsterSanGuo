
@echo off

set SourPath=%cd%\Resources

set SourPath_Script_Byte=%cd%\Byte_lua

set destPath=%cd%\..\..\..\..\share\demo\

set NotCopy=Script

set NotCopy1=Image

set SourPath_Image_Byte=%cd%\Byte_Image

cd /d "%SourPath%"

for /f "delims=" %%i in ('dir /ad /b') do (
 if not "%%i"=="%NotCopy%" (xcopy /i /e /y "%%i" "%destPath%%%i")
)
 
@Rem ����2���ƽű�

xcopy /i /e /y "%SourPath_Script_Byte%" "%destPath%%NotCopy%"

@Rem ����2����tupian

xcopy /i /e /y "%SourPath_Image_Byte%" "%destPath%%NotCopy1%"

 
@echo "demo ������Դ �ɹ�"
@Pause