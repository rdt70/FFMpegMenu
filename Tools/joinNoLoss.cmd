@echo off

cd /d %1

if EXIST *.mts call "%~dp0\joinMTS.cmd" %1
if EXIST *.mp4 call "%~dp0\joinMP4.cmd" %1

echo. File *.mts and *.mp4 processed.
pause
goto :eof