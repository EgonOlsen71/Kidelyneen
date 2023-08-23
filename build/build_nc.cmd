del kidelyneen_AD.d64
c1541 -format kidelyneen,ky d64 kidelyneen_AD.d64
call ..\build\c1541 ..\build\kidelyneen_AD.d64 -write ++loader-c.prg loader,p
call ..\build\c1541 ..\build\kidelyneen_AD.d64 -write ++kidelyneen-c.prg kidelyneen,p
cd ..\build
goto :EOF

:add
..\build\c1541 ..\build\kidelyneen_AD.d64 -write %1 %1,s
