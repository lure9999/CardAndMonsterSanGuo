@echo off
:label1
@cls
echo 欢迎使用Python创建Cocos2d-x工程
set /p project=请输入需要创建的工程名:
set /p aID=请输入需要创建的android版本包标识名:
echo 您输入的工程名为%project%
echo 您输入的android版本包标识名为%aID%
echo 确认创建工程吗?
CHOICE /C 123 /M "确认请按 1，取消请按 2，或者退出请按 3。"
echo %errorlevel%
if %errorlevel%==1 goto label2
if %errorlevel%==2 goto label1
if %errorlevel%==3 goto label3
:label2
echo 正在创建工程...
python create_project.py -project %project% -package %aID% -language cpp
:label3
pause