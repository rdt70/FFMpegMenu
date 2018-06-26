@echo off
rem Join the .mp4 files in a file named <dirlocation>.mp4

set bitrate=3000k
rem copy ffmpeg and this script on %USERPROFILE%\Videos
rem %USERPROFILE%\AppData\Roaming\Microsoft\Windows\SendTo
cd /d %1

rem set the directory name to be used in the file output
for %%* in (.) do set CurrDirName=%%~nx*

rem echo %CurrDirName%

if EXIST filelist.txt del filelist.txt

for %%A in (*.mp4) do (
	 "%~dp0\ffmpeg" -i %%A -c copy -bsf:v h264_mp4toannexb -f mpegts %%A.ts
	 echo file '%%A.ts' >> filelist.txt
)

:: Join ts files
"%~dp0\ffmpeg" -f concat -i filelist.txt -c copy -bsf:a aac_adtstoasc "%CurrDirName%.mp4"
rem move "%CurrDirName%.mp4" ..

echo Joining completed! Press a key to continue

pause

for /f "tokens=2 delims='" %%a in (filelist.txt) do del "%%a"
if EXIST filelist.txt del filelist.txt