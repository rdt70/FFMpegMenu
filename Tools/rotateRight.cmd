@echo off

"%~dp0\ffmpeg" -i %1 -vf "transpose=1" -y "%~n1.rotate%~x1"