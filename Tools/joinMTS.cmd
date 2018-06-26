@echo off
rem Join the .mts files in a file named <dirlocation>.m2ts

cd /d %1

for %%* in (.) do set CurrDirName=%%~nx*
::set videoFileName=".\test.m2ts"
set videoFileName="%CurrDirName%.m2ts"

::set mtsList=".\00001.MTS"+".\00002.MTS"
setlocal enabledelayedexpansion
set "mtsList=" 

for %%i In (*.mts) DO set mtsList=!mtsList!+"%%i"
set mtsList=%mtsList:~1%
rem echo %mtsList%

rem pause

Rem =================================

set batFile=".\00.bat"
set metaFile=".\00.meta"
set audioFile=".\00.ac3"
set audioLogFile=".\00 - Log.txt"
set tsCommand1=MUXOPT --no-pcr-on-video-pid --new-audio-pes --vbr --vbv-len=500
set tsCommand2=V_MPEG4/ISO/AVC
set tsCommand3=fps=, insertSEI, contSPS, track=4113
set tsCommand4=A_AC3, %audioFile%, track=4352

Rem =================================

echo %tsCommand1% > %metaFile%
echo %tsCommand2%, %mtsList%, %tsCommand3% >> %metaFile%
echo %tsCommand4% >> %metaFile%
echo "%~dp0\eac3to\eac3to" %mtsList% %audioFile% > %batFile%
echo "%~dp0\tsMuxeR\tsMuxeR" %metaFile% %videoFileName% >> %batFile%

Rem =================================

call %batFile%

Rem =================================

del %audioFile%
del %audioLogFile%
del %batFile%
del %metaFile%

Rem =================================

cls
echo AVCHD Joining Complete.

Rem Batch code ends here ...
