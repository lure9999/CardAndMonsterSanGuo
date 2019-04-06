
set SourPath=%cd%\Resources\Image
set destPath=%cd%\Byte_Image


cd /d "%SourPath%"

@Rem for /f "delims=" %%i in ('dir /ad /b ') do (xcopy /i /e /y "%SourPath%\%%i" "%destPath%\%%i")
xcopy /i /e /y "%SourPath%" "%destPath%"
@echo "Image copy complete"

@Pause