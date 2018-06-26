@echo off

rem cd /d "%1"

rem set EXT=mp4
call :moveByDate %1


pause
goto :eof

:moveByDate
	cd %1
	cd
	for %%A in (*.*) do ( 
		move "%%A" ..
	)
	pause
	:: for /f "Tokens=1 Delims= " %%i In ('dir /ad-h /b') do (
	::	call :moveByDate "%%i"
	::)
	cd ..
goto :eof

 