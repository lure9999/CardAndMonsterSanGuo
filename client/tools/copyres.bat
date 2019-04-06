
set SourPath=D:\test1111\Image
set destPath=D:\test1111\all
set destExt=*.png
set Err=D:\test1111\Err.txt

@cd /d "%SourPath%"

@for /f "delims=" %%d in ('dir /ad /s /b /on') do ( 

@cd /d %%d 

for %%f in ("%destExt%") do (


@Rem @echo %%f

@Rem @echo "%destPath%\%%f"

@Rem @echo %%d

@if exist "%destPath%\%%f" (copy "%destPath%\%%f" %%d & @echo "压缩文件拷贝成功") else (@echo "%%d\%%f 在 %destPath%\%%f压缩文件不存在！">>%Err% )


) 

cd ..

@Rem @Pause

)

@Pause