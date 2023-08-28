call mospeed ..\basic\kidelyneen.bas -compression=true -generatesrc=false -memhole=8192-10472 -deadcodeopt=true -inlineasm=true
call mospeed ..\basic\loader.bas
call moscrunch ++loader.prg -addfiles=..\res\kidelyneen.img