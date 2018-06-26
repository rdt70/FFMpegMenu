@echo off

cd /d %1
 
rem set EXT=mp4
call :organizeByDate mp4
call :organizeByDate mts
call :organizeByDate avi
call :organizeByDate jpg

pause
goto :eof

:organizeByDate
	for %%A in (*.%1) do ( 
		for /f "Tokens=1 Delims= " %%i In ('dir /t:w "%%A"^|find "%%A"') do (
			call :moveFile %%i "%%A"
		)
	)
goto :eof

:moveFile
	SET fileName=%2
	SET fileName=%fileName:"=%

	SET _date=%1
	SET _tmpdirname=%_date:/=.%
	setlocal ENABLEDELAYEDEXPANSION
	SET _dirname=%_tmpdirname%
	for /f "tokens=1-3 delims=." %%a in ("%_tmpdirname%") do  SET _dirname=%%c.%%b
	IF NOT EXIST %_dirname%\NUL mkdir %_dirname%
	if NOT EXIST ".\%_dirname%\%fileName%" (
		echo Moving ".\%fileName%" ".\%_dirname%\%fileName%" 
		move ".\%fileName%" ".\%_dirname%\%fileName%" ) else ( echo File %fileName% Exist on %_dirname%! )
	rem mklink ".\%_dirname%\%2" ".\%2"
goto :eof 

 