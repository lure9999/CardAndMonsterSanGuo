@echo off
:label1
@cls
echo ��ӭʹ��Python����Cocos2d-x����
set /p project=��������Ҫ�����Ĺ�����:
set /p aID=��������Ҫ������android�汾����ʶ��:
echo ������Ĺ�����Ϊ%project%
echo �������android�汾����ʶ��Ϊ%aID%
echo ȷ�ϴ���������?
CHOICE /C 123 /M "ȷ���밴 1��ȡ���밴 2�������˳��밴 3��"
echo %errorlevel%
if %errorlevel%==1 goto label2
if %errorlevel%==2 goto label1
if %errorlevel%==3 goto label3
:label2
echo ���ڴ�������...
python create_project.py -project %project% -package %aID% -language cpp
:label3
pause