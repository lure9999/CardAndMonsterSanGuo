
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
 
@Rem 拷贝2进制脚本

xcopy /i /e /y "%SourPath_Script_Byte%" "%destPath%%NotCopy%"

@Rem 拷贝2进制tupian

xcopy /i /e /y "%SourPath_Image_Byte%" "%destPath%%NotCopy1%"

 
@echo "demo 更新资源 成功"
@Pause