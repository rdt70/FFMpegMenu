@echo off

cd /d %~dp1

set start=
set end=

:getStart
	SET /P start=Please enter start point: 
	IF "%start%"=="" goto :getStart

:getEnd
	SET /P end=Please enter end point: 
	IF "%end%"=="" goto :getEnd

goto :cutVideo

:cutVideo 
	echo Cutting %1 From:%start% To:%end%....
	%~dp0\ffmpeg -i %1 -vcodec copy -acodec copy -ss %start% -t %end% "%~n1.CUT%~x1"
goto :eof