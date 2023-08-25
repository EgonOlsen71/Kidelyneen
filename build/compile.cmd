call mospeed ..\basic\kidelyneen.bas -compression=true -generatesrc=false -memhole=8192-9192 -deadcodeopt=true
call mospeed ..\basic\loader.bas
call moscrunch ++loader.prg -addfiles=..\res\kidelyneen.img