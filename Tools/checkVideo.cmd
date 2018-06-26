@echo off

if exist %1\ (
	echo %1 is Directory
	cd /d %1
	for %%A in (*.avi) do call :checkVideos "%%A"
	for %%A in (*.mp4) do call :checkVideos "%%A"	
) else (
	echo %1 is File
	cd /d %~dp1
	:: echo %~nx1
	if exist "%~nx1" call :checkVideos "%~nx1"
)

goto :eof

:checkVideos
	echo Checking %1....
	echo "%~dp0\ffmpeg" -v error -i %1 -f null - > %1.log 2>&1
	"%~dp0\ffmpeg" -v error -i %1 -f null - > %1.log 2>&1
	echo Open file %1.log to see the result
	pause
goto :eof
