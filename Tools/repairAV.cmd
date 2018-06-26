@echo off

cd /d %~dp1

echo Repairing %1 ....
:: "%~dp0\ffmpeg" -i %1 -vcodec copy -acodec libmp3lame "%~n1.[repaired]%~x1"

"%~dp0\ffmpeg" -i %1 -vcodec copy -acodec copy "%~n1.[repaired]%~x1"