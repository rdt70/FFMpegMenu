@echo off

if exist %1\ (
	echo %1 is Directory
	cd /d %1
	for %%A in (*.avi) do call :getAudio "%%A"
	for %%A in (*.mp4) do call :getAudio "%%A"	
	for %%A in (*.mkv) do call :getAudio "%%A"
) else (
	echo %1 is File
	cd /d %~dp1
	:: echo %~nx1
	if exist "%~nx1" call :getAudio "%~nx1"
)


:getAudio
	echo Checking %1....
	"%~dp0\ffmpeg" -i %1 %1.mp3
goto :eof