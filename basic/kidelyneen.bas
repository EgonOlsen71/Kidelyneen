5 rem kidelyneen - egonolsen/2023
6 rem ***************************
10 gosub 500:gosub 25000:gosub 1000:gosub 40000
20 gosub 8300:gosub 8200
30 gosub 2000
40 end

500 rem preinit
510 dim ac%(3),ad%(1,1):sd%=40:li%=3
520 print chr$(8);chr$(142);:i=rnd(0)
530 ad%(0,0)=1:ad%(0,1)=40:ad%(1,0)=39:ad%(1,1)=41
540 gosub 27000:return

1000 rem reinit
1005 poke 646,1:print chr$(147);
1010 poke 53280,11:poke 53281,11:bc%=224:dc%=160:fx%=0
1030 ps%=1043:ft%=126:ed%=0:ie%=1:ec%=0:mf=0.7:zp%=0:pj%=0:oj%=0
1040 x%=rnd(1)*20+10:y%=5+rnd(1)*15:qp%=y%*40+x%+1024
1050 le%=2003:lt%=0:l0%=0:l1%=0:gosub 24000
1080 return

1200 rem calculate percentage
1210 pc=(ft%-126)/874:return

1500 rem copy back from buffer
1510 sa%=8192:se%=9192:ta%=1024
1520 gosub 10950:return

1800 rem check game over
1810 gosub 1200:if pc>=mf then gosub 1900:return
1815 os%=ps%
1820 if kf%<>1 then return
1825 gosub 8500:ps%=pr%:if pr%=-1 then ps%=1043
1830 le%=2003:li%=li%-1:gosub 8200
1840 kf%=0:jo%=0:if li%=0 then 1950
1850 gosub 22000:bl%=0:return

1900 rem epic win sequence
1910 for i=0 to 2:gosub 39850:for p=0 to 255:gosub 28500
1915 poke 53287,p:poke 53281,255-p:next p,i
1920 sd%=sd%-4:if sd%<5 then sd%=5
1930 jo%=0:poke 53287,13:gosub 1000
1940 gosub 8300:return

1950 rem epic game over sequence
1960 poke 53277,7:poke 53271,7:gosub 8400:gosub 39500
1970 for i=0 to 800:gosub 28500:poke 53281,i and 3:next i
1980 run

1999 rem player movement, main game loop
2000 pm%=ps%:bl%=0:kf%=0:pr%=-1:pj%=0:oj%=0:fx%=0
2002 gosub 2200::cf%=0
2003 pp%=peek(ps%):poke ps%,dc%:poke ct,2
2005 gosub 7000:gosub 17000:gosub 19000
2010 gosub 28500:gosub 1800:if jo%=0 then 2000
2015 if jo%=127 then 2002
2020 po%=ps%:gosub 2200
2025 nc%=0
2032 on 127-jo% goto 3000,3100,2002,3200,2002,2002,2002,3300
2035 goto 2002
2040 ed%=ed%-10:gosub 6000:if ps%<pm% then pm%=ps%
2070 gosub 23000: if tc% then gosub 4000:goto 2000
2080 goto 2002

2200 rem color track element
2210 cg%=5-2*(bl%>0):ct=ps%+54272
2220 poke ct,cg%:return

2500 rem check track
2510 if peek(ps%)=32 then bl%=bf%:if pr%=-1 then pr%=po%:ed%=0:ec%=0
2520 if peek(ps%)<>32 and (peek(ps%+54272) and 15)<>5 then ps%=po%
2530 return

3000 rem up
3005 if bl%=2 then nc%=1:goto 2040
3010 ps%=ps%-40:if ps%<1024 then ps%=po%
3015 bf%=1:gosub 2500
3020 goto 2040

3100 rem down
3105 if bl%=1 then nc%=1:goto 2040
3110 ps%=ps%+40:if ps%>2023 then ps%=po%
3115 bf%=2:gosub 2500
3120 goto 2040

3200 rem left
3205 if bl%=4 then nc%=1:goto 2040
3210 ps%=ps%-1:gosub 3400:if xs%<xo% then ps%=po%
3215 bf%=3:gosub 2500
3220 goto 2040

3300 rem right
3305 if bl%=3 then nc%=1:goto 2040
3310 ps%=ps%+1:gosub 3400:if xs%>xo% then ps%=po%
3315 bf%=4:gosub 2500
3320 goto 2040

3400 rem calculate x for ps%/po%
3410 xs%=(ps%-1024)/40:xo%=(po%-1024)/40
3420 return

3500 rem calculate x/y
3510 pv%=pv%-1024
3520 y%=pv%/40:x%=pv%-(y%*40)
3530 return

3600 rem calc x/y of sprites
3610 gosub 3500
3620 x%=x%*8+16:y%=y%*8+45
3630 return

4000 rem fill
4010 poke 53280,12:gosub 39880
4020 pv%=qp%:gosub 3500
4050 gosub 10300
4080 gosub 5500
4090 poke 53280,11:return

5500 rem copy inverted
5510 ft%=0:sa%=8192:se%=9192:ta%=1024
5540 ct=54272+ta%
5550 if peek(sa%)<>32 then 5570
5560 poke ta%,bc%
5570 poke(ct), peek(ct) and 253
5580 if peek(ta%)>32 then ft%=ft%+1:poke ta%,bc%
5590 ta%=ta%+1:sa%=sa%+1:ct=ct+1
5600 if sa%<se% then 5550
5610 gosub 8300:return

6000 rem delay
6010 ts=ti
6020 if ti-ts<2 then 6020
6030 return

7000 rem process main enemy
7002 ed%=ed%-1+(bl%>0)*5:if ed%>0 then cv%=qp%:gosub 8100:return
7005 ed%=sd%:gosub 7500
7010 pv%=qp%:gosub 3600
7020 poke 53249,y%
7030 if x%>255 then poke 53248,x%-255:poke 53264,peek(53264) or 1:goto 7050
7040 poke 53248,x%:poke 53264,peek(53264) and 254
7050 return

7500 rem move main enemy
7510 nq%=qp%:pv%=qp%:gosub 3500:xq%=x%:yq%=y%
7512 if ec%<=0 then pv%=ps%:zp%=0:goto 7516
7514 if ec%>0 then if zp%=0 then zp%=1024+1000*rnd(1):goto 7516
7515 pv%=zp%
7516 gosub 3500
7517 xd%=xq%-x%:yd%=yq%-y%:ax%=abs(xd%):ay%=abs(yd%)
7518 if peek(53266)>150 then 7525
7520 if ax%<ay% then xd%=0:goto 7525
7521 if ay%<ax% then yd%=0
7525 ec%=ec%-1:if ax%>0 then nq%=nq%-sgn(xd%)
7530 if ay%>0 then nq%=nq%-sgn(yd%)*40
7540 if ec%=0 then gosub 39850
7600 cv%=nq%:gosub 8100:qp%=nq%
7610 if pj%=qp% then oj%=oj%+1:if oj%=10 then ec%=1:return
7620 pj%=qp%:oj%=0:return

8000 rem enemy collision
8010 ct=nq%+54272
8020 oq%=nq%:nq%=qp%:if bl%=0 then 8070
8030 if (peek(ct-a0%) and 2)=2 then kf%=1:nq%=oq%:goto 8070
8040 if (peek(ct+a0%) and 2)=2 then kf%=1:nq%=oq%:goto 8070
8050 if (peek(ct-a1%) and 2)=2 then kf%=1:nq%=oq%:goto 8070
8060 if (peek(ct+a1%) and 2)=2 then kf%=1:nq%=oq%
8070 ec%=ec%+10:if ec%>280 then ec%=-100
8080 return

8100 rem actual collision check
8105 a0%=ad%(fx%,0):a1%=ad%(fx%,1)
8110 if peek(cv%-a0%)>32 then gosub 8000:goto 8150
8120 if peek(cv%+a0%)>32 then gosub 8000:goto 8150
8130 if peek(cv%-a1%)>32 then gosub 8000:goto 8150
8140 if peek(cv%+a1%)>32 then gosub 8000
8150 fx%=(fx%+1) and 1:return

8200 rem print lives
8210 a$=str$(li%):a$=chr$(83)+":"+mid$(a$,2)
8220 sp%=896:gosub 20000
8230 return

8300 rem print completion
8310 gosub 1200
8320 a$=str$(int(pc*100))+"%":a$=mid$(a$,2)
8330 sp%=960:gosub 20000
8340 return

8400 rem print game over
8410 a$="rip":gosub 9000:sp%=896:gosub 20000
8420 sp%=960:gosub 20000
8430 return

8500 rem death animation
8540 for i=0 to 3:ac%(i)=ps%:next:gosub 8800:gosub 39650
8580 for i=0 to 23:for p=0 to 3
8585 if ac%(p)<1024 or ac%(p)>2023 then 8610
8590 ct=54272+ac%(p):poke 704+p,peek(ac%(p)):poke 708+p,peek(ct)
8600 poke ct,rnd(1)*15:poke ac%(p),81
8610 next
8660 for p=0 to 3
8670 if ac%(p)<1024 or ac%(p)>2023 then 8690
8680 ct=54272+ac%(p):poke ac%(p),peek(704+p):poke ct,peek(708+p)
8690 next
8700 gosub 8800
8760 next
8770 return

8800 rem move explosion parts
8820 ac%(0)=ac%(0)-41
8830 ac%(1)=ac%(1)+41
8840 ac%(2)=ac%(2)+39
8850 ac%(3)=ac%(3)-39
8860 gosub 28500
8870 return

9000 rem convert into screen codes
9010 b$="":for i=1 to len(a$)
9020 b$=b$+chr$(asc(mid$(a$,i))-64)
9030 next:a$=b$:return

10300 rem flood fill
10305 sa%=1024:ta%=8192:se%=2024:gosub 10950
10320 sc%=8192:ch%=32:fc%=bc%:sl%=9472:sh%=9472
10400 ad%=sc%+40*y%+x%
10410 gosub 10700
10430 if sh%<=sl% then return
10440 ad%=256*h%+l%
10450 sl%=sl%+2:h%=peek(sl%+1):l%=peek(sl%)
10460 if peek(ad%)>ch% then 10430
10470 ad%=ad%-1
10480 if peek(ad%)=ch% then 10470
10490 ad%=ad%+1:u%=0:d%=0
10520 poke ad%,fc%
10530 ad%=ad%-40
10540 if peek(ad%)>ch% then u%=0:goto 10560
10550 if u%=0 then gosub 10700:u%=-1
10560 ad%=ad%+80
10570 if peek(ad%)>ch% then d%=0:goto 10590
10580 if d%=0 then gosub 10700:d%=-1
10590 ad%=ad%-39
10600 if peek(ad%)=ch% then 10520
10610 goto 10430

10699 rem push
10700 z%=ad%/256:poke sh%+1,z%:z%=ad% and 255:poke sh%,z%
10702 h%=peek(sl%+1):l%=peek(sl%)
10705 sh%=sh%+2
10710 gosub 28500
10720 return

10950 rem copy
10951 rem [lda sa%!; sta 63; lda sa%!+1; sta 64]
10952 rem [lda ta%!; sta 65; lda ta%!+1; sta 66; ldx #0]
10953 rem [lda (63,x); sta (65,x);inc 63; inc 65; bne 10955!]
10954 rem [inc 64; inc 66]
10955 rem [lda 64; cmp se%!+1; bne 10953!]
10956 rem [lda 63; cmp se%!; bne 10953!]
10957 rem [jmp 10990!]
10970 poke ta%,peek(sa%):ta%=ta%+1:sa%=sa%+1
10980 if sa%<se% then 10970
10990 return

17000 rem move line enemy
17005 if le%=ps% then kf%=1:return
17010 gosub 18000
17015 pv%=le%:gosub 3600:x%=x%
17020 poke 53255,y%-1
17030 if x%>255 then poke 53254,x%-255:poke 53264,peek(53264) or 8:goto 17060
17040 poke 53254,x%:poke 53264,peek(53264) and 247
17060 return

18000 rem process target for line enemy
18001 if le%=lt% then lt%=0
18002 cv%=rnd(1)>0.01
18004 if lt%>0 then if cv% then 18100
18005 if cv% then 18020
18010 if lt%<1500 then lt%=1984:goto 18040
18015 lt%=1024
18020 if le%>1500 then lt%=1024:goto 18040
18030 lt%=1984
18040 lt%=lt%+rnd(1)*40
18100 yd%=40:if lt%<=1500 then yd%=-40
18110 xd%=1:if (lt% and 1)=1 then xd%=-1
18115 x%=lt%-le%:if abs(x%)<40 then xd%=sgn(x%)
18120 cv%=le%+yd%:gosub 18500
18130 if yd%=5 then 18145
18140 cv%=le%+xd%:gosub 18500:if yd%=5 then 18145
18142 cv%=le%-xd%:gosub 18500
18145 if cv%>2023 or cv%<1024 then 18200
18150 if cv%=ps% then kf%=1:le%=cv%
18160 if yd%=5 then le%=cv%
18200 if l0%=le% then l1%=0:lt%=0
18210 l0%=l1%:l1%=le%:return

18500 rem color below line enemy
18510 if peek(cv%)=32 then yd%=1:return
18520 yd%=(peek(cv%+54272) and 15)
18530 if yd%=2 then yd%=5
18540 return

19000 rem check joystick
19010 jo%=peek(56320)
19015 if jo%=127 then ts=0:goto 19040
19020 if ti>=ts+1 then ts=ti:goto 19040
19030 jo%=127
19040 return

20000 rem copy a$ into sprite sp%
20005 a$=right$("   "+a$,3)
20010 poke 56334,peek(56334) and 254
20020 poke 1,peek(1) and 251
20030 for i=1 to 3:c$=mid$(a$,i,1)
20040 i%=sp%-1+i:ch=53248+asc(c$)*8:ai%=0
20050 poke i%,peek(ch)
20060 ch=ch+1:i%=i%+3:ai%=ai%+1
20070 if ai%<8 then 20050 
20075 next
20080 poke 1,peek(1) or 4
20090 poke 56334,peek(56334) or 1
20100 return

22000 rem remove incomplete polygons
22005 if bl%=0 then poke 54272+os%,5:return
22010 i%=1064
22020 if peek(i%)<>dc% then 22050
22030 ct=i%+54272:cv%=peek(ct) and 2
22040 if cv%=2 then poke i%,32:poke ct,1
22050 i%=i%+1:if i%<1984 then 22020
22120 return

23000 rem check for track collision
23005 if bl%=0 or nc%=1 then tc%=0:return
23010 cv%=peek(ps%)
23020 tc%=(cg%<>5 and cv%=bc%) or (cg%=7 and cv%=dc%)
23030 return

24000 rem (re-)fill borders
24050 for i=55296 to 55335:poke i,5:next
24060 for i=56256 to 56295:poke i,5:next
24070 for i=55336 to 56216 step 40:poke i,5:next
24080 for i=55375 to 56255 step 40:poke i,5:next
24090 for i=1024 to 1063:poke i,bc%:next
24100 for i=1984 to 2023:poke i,bc%:next
24110 for i=1064 to 1944 step 40:poke i,bc%:next
24120 for i=1103 to 1983 step 40:poke i,bc%:next
24130 return

25000 rem intro screen
25010 poke 53280,0:poke 53281,0:poke 646,1:poke 53269,0
25020 print chr$(147);
25030 y%=3:a$="kidelyneen":gosub 26000
25070 poke 646,5:y%=8:a$="the evil kidney-chicken-mutant":gosub 26000
25080 y%=9:a$="wants to kill you, his creator!":gosub 26000
25090 y%=10:a$="try to wall him in before he gets you":gosub 26000
25100 y%=11:a$="or you'll become chicken feed!":gosub 26000
25120 poke 646,12:y%=23:a$="egonolsen/2023":gosub 26000
25130 y%=24:a$="compiled with mospeed":gosub 26000:gosub 39600
25400 gosub 28500:get a$:if a$="" and peek(56320)=127 then 25400
25410 for i=0 to 25:print:next
25420 return

26000 rem center text in a$, y pos in y%
26010 x%=20-len(a$)/2
26020 gosub 34500
26030 print a$;:return

27000 rem init sound routine
27010 dim vt%(2),vl(2),vw%(2):vc%=0:ac%=0
27020 si=54272:poke si+24,0
27030 for i=si to si+24:poke i,0:next
27040 poke si+24,15:return

28000 rem play sound
28005 ic%=0:gosub 28500
28010 if vw%(vc%)=0 then 28100
28020 vc%=vc%+1:ic%=ic%+1
28030 if vc%=3 then vc%=0
28040 if ic%=3 then return
28050 goto 28010
28100 tt=ti:sb=si+vc%*7
28110 poke sb+5,at%*16+dd%
28120 poke sb+6,el%*16+rl%
28130 poke sb,lq%:poke sb+1,hq%
28140 vw%(vc%)=wf%:vl(vc%)=tt:poke si+24,15:poke sb+4,wf%+1
28150 pt%=pt%+pt%:vt%(vc%)=pt%:ac%=ac%+1
28160 if im%=0 then return
28170 tt=ti:if tt-vl(vc%)<pt% then 28170
28180 poke sb+4,wf%:vw%(vc%)=0:ac%=ac%-1
28190 vc%=vc%+1:if vc%=3 then vc%=0
28200 return

28500 rem check sound playback
28502 if ac%=0 then return
28505 ts=tt:tt=ti:if ts>tt then vw%(0)=0:vw%(1)=0:vw%(2)=0
28510 for hh=0 to 2:if vw%(hh)=0 or tt-vl(hh)<vt%(hh) then 28540
28520 poke si+hh*7+4,vw%(hh):vw%(hh)=0:ac%=ac%-1
28540 next:return

34500 rem set cursor at x%,y%
34510 poke 781,y%:poke 782,x%:poke 783,0:sys 65520
34520 return

39500 rem game over sound
39510 at%=5:dd%=17:el%=4:rl%=4:lq%=180:hq%=15
39520 wf%=16:pt%=40:im%=0:gosub 28000
39530 at%=10:dd%=13:el%=3:rl%=3:lq%=180:hq%=12
39540 wf%=16:pt%=45:im%=0:gosub 28000
39550 return

39600 rem whoop sound
39610 at%=9:dd%=8:el%=0:rl%=0:lq%=180:hq%=5
39620 wf%=16:pt%=30:im%=0:gosub 28000:return

39650 rem fire sound
39660 at%=1:dd%=8:el%=0:rl%=0:lq%=180:hq%=5
39670 wf%=128:pt%=30:im%=0:gosub 28000:return

39850 rem chicken sound
39860 at%=5:dd%=0:el%=3:rl%=1:lq%=180:hq%=13
39870 wf%=32:pt%=11:im%=0:gosub 28000:return

39880 rem short beep sound
39885 at%=1:dd%=1:el%=4:rl%=2:lq%=180:hq%=22
39890 wf%=16:pt%=6:im%=1:gosub 28000:return

40000 rem init sprites
40020 poke 53269,0:poke 53248,0:poke 53249,0
40022 poke 53250,32:poke 53251,60
40024 poke 53252,32:poke 53253,60:poke 53264,4
40030 for i=832 to 832+63: read y%: poke i,y%: next
40035 for i=896 to 1022:poke i,0:next
40040 poke 53287,13: poke 53288,10:poke 53289,0
40050 poke 2040,13:poke 2041,14:poke 2042,15:poke 2043,144
40060 poke 53276,8:poke 53277,6:poke 53271,6
40065 poke 53254,0:poke 53255,0:poke 53290,15
40070 for i=9216 to 9216+63: read y%: poke i,y%: next
40075 poke 53285,2:poke 53286,7
40086 poke 53269,15:return
40090 data 0,0,0,0,48,0,0,254,28,3,238,62,7,254,126,4
40100 data 252,254,9,255,254,18,127,158,52,255,156,63,255,252,63,255
40110 data 254,15,199,255,1,207,255,3,231,177,3,247,96,3,255,64
40120 data 0,255,192,0,127,0,0,0,0,0,0,0,0,0,0,13
41010 data 0,0,0,0,0,0,0,0,0,0,0,0,0,44,0,0
41020 data 47,0,0,190,0,0,186,0,0,186,0,2,185,0,2,249
41030 data 0,3,169,0,2,233,0,2,169,0,2,171,0,2,100,0
41040 data 0,148,0,0,0,0,0,0,0,0,0,0,0,0,0,129
