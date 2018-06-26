@echo off
rem 2 Pass dvx encoding
rem copy ffmpeg and this script on %USERPROFILE%\Videos
rem %USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo


set bitrate=4000k
set scale="-vf scale="iw/1:ih/2""

if exist %1\ (
	cd /d "%1"
	rem set the directory name to be used in the file output
	for %%* in (.) do set CurrDirName=%%~nx*

	if EXIST filelist.txt del filelist.txt

	for %%A in (*.avi) do call :encodeVideo "%%A"
	for %%A in (*.mp4) do call :encodeVideo "%%A"
	for %%A in (*.mkv) do call :encodeVideo "%%A"

	if EXIST *.mp3 call :joinMP3

	if EXIST *.jpg call :joinJPG


	goto :joinPart	
) else (
	echo %1 is File
	cd /d %~dp1
	:: echo %~nx1
	if exist "%~nx1" call :encodeVideo "%~nx1"
	goto :eof
)



:encodeVideo
	echo ">>>>>> Processing File...." %1
	rem remove "" from filename
	SET _before=%1
	SET _file=%_before:"=%
	
	"%~dp0\ffmpeg" -i "%_file%"  -vcodec  libx264 -crf 22  -b:v %bitrate% -pass 1 -acodec copy -f avi "%_file%_temp.avi"
	"%~dp0\ffmpeg" -i "%_file%_temp.avi" -vcodec libx264 -crf 22 -b:v %bitrate% -pass 2 -acodec libmp3lame -b:a 128k "%_file%.avi"
	del "%_file%_temp.avi"

	echo file '%_file%.avi' >> filelist.txt	
goto :eof
::------------------------------------------------------------------


echo Joining MP3
:joinMP3
	echo Joining mp3 files...
	if NOT EXIST "%CurrDirName%.mp3" (
		copy /b *.mp3 temp.mp3
		"%~dp0\ffmpeg" -i temp.mp3 -acodec libmp3lame "%CurrDirName%.mp3"
		del temp.mp3
	)
	
goto :eof
::-----------------------------------------------------------------

echo Joining JPG
:joinJPG
	echo Joining images to slideshow
	
	set /a count=0
	mkdir .\slideShow
	cd slideShow

	setlocal ENABLEDELAYEDEXPANSION
	for %%A in (..\*.jpg) do (
		set /a count=count+1
		copy "%%A" image-!count!.jpg 
		rem mklink image-!count!.jpg "%%A"
	)
	endlocal
	
	if EXIST "..\%CurrDirName%.mp3" (
		"%~dp0\ffmpeg" -y -f image2 -r 1/3 -i image-%%d.jpg -i "..\%CurrDirName%.mp3" -map 0:0 -map 1:0 -s:v 1080x720 -b:v 1M -shortest "..\%CurrDirName%.picture.avi"
	) else	(
		"%~dp0\ffmpeg" -y -f image2 -r 1/3 -i image-%%d.jpg -s:v 1080x720 -b:v 1M "..\%CurrDirName%.picture.avi"
	)
	rem move "%CurrDirName%.picture.avi" ..
	cd ..
	:: rmdir .\slideShow /s /q
	
	echo file '%CurrDirName%.picture.avi' >> filelist.txt	
::-------------------------------------------------------------------------------------------
goto :eof
	
:: Join all the AVI files
:joinPart
"%~dp0\ffmpeg" -f concat -i filelist.txt -c copy "%CurrDirName%.avi"

for /f "tokens=2 delims='" %%a in (filelist.txt) do del "%%a"

pause

explorer .
