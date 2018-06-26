@echo off

if (%1)==() (
	set "root=%~dp0"
	echo. Using current path: %root%
) else (
	set "root=%1\\"
	echo. Using path: %root%
	pause
	if NOT EXIST "%root%" mkdir "%root%"
	mkdir "%root%\Tools"
	xcopy .\Tools "%root%\Tools" /e
)

:: Add registry entries

set "keyName=FFmpeg"
set "regRoot=Directory"
set "commandList=joinNoLoss joinToAvi organizeByDate checkVideo"
call :addregKey

set "regRoot=*"
set "commandList=rotateLeft rotateRight checkVideo joinToAvi repairAV"
call :addregKey

goto :eof

:addregKey
	reg add HKCR\%regRoot%\shell\%keyName%	/f
	reg add HKCR\%regRoot%\shell\%keyName% /v MUIVerb /t reg_SZ /d "%keyName%"	/f
	reg add HKCR\%regRoot%\shell\%keyName% /v Icon /t reg_EXPAND_SZ /d """"%root%\Tools\multimedia.ico"""" /f
	reg add HKCR\%regRoot%\shell\%keyName% /v ExtendedSubCommandsKey /d  "%regRoot%\\ContextMenus\\%keyName%" /f
	reg add HKCR\%regRoot%\ContextMenus\%keyName%	/f

	call :addSubCommands %commandList%

goto :eof

:addSubCommands
	if NOT "%1"=="" (
		echo Adding subcommand... %1
		reg add HKCR\%regRoot%\ContextMenus\%keyName%\Shell\%1\command	/f
		reg add HKCR\%regRoot%\ContextMenus\%keyName%\Shell\%1 /v MUIVerb /t reg_SZ /d "%1"	/f
		reg add HKCR\%regRoot%\ContextMenus\%keyName%\Shell\%1\command /d """"%root%Tools\%1.cmd""" ""%%1"""""	/f
		
		shift
		goto :addSubCommands
	)
goto :eof


