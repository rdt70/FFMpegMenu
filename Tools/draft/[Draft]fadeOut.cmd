:: Note: ffmpeg should be located in the same script location
:: http://ffmpeg.org/ffmpeg-filters.html

@echo off

:: fadeTime are the second for fading in or out
set /a fadeTime=10

%~dp0\ffmpeg -i %1 2>&1 | find /i "Duration" > %~dp1\file.txt

for /f "tokens=1 delims=," %%a in (%~dp1\file.txt) do (
	rem @echo %%a
	:: Get duration
	for /f "tokens=2 delims= " %%i in ("%%a") do set _duration=%%i
	:: Get HH:MM:SS
	for /f "tokens=1 delims=." %%i in ("%_duration%") do (
		@echo %%i
		for /f "tokens=1-3 delims=:" %%a in ("%%i") do (
			set /a HH=%%a 
			set /a MM=%%b 
			set /a SS=%%c
		)
	)
)

if %SS% LSS %fadetime% (
	set /a SS=%SS%+60
	set /a MM=%MM%-1
)

set /a SS=%SS%-%fadetime%

rem echo New Time %HH%:%MM%:%SS%
set /a fadeSecond=%HH%*3600+%MM%*60+%SS%

rem echo Second=%fadeSecond%
set "fadeString=t=out:st=%fadeSecond%:d=%fadetime%

rem %~dp0\ffmpeg -i %1 -vf "fade=t=out:st=38:d=5" -af "afade=t=out:st=38:d=5" %1.fade.mp4
rem %~dp0\ffmpeg -i %1 -vf "fade=%fadeString%" -af "afade=%fadeString%" "%~dpn1.fade%~x1"

%~dp0\ffmpeg -i %1 -vf "fade=%fadeString%" -af "afade=%fadeString%" "%~dpn1.fade%~x1"
