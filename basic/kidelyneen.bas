10 gosub 500:gosub 1000:gosub 40000
20 gosub 8300:gosub 8200
30 gosub 2000
40 end

500 rem preinit
510 dim ac%(3):sd%=40:li%=3
520 print chr$(8);chr$(142);:i=rnd(0)
530 return

1000 rem reinit
1005 poke 646,1:print chr$(147);
1010 poke 53280,11:poke 53281,11:bc%=224:dc%=160
1030 ps%=1043:ft%=126:ed%=0:ie%=1:ec%=0:mf=0.7:zp%=0:pj%=0:oj%=0
1040 x%=rnd(1)*20+10:y%=5+rnd(1)*15:qp%=y%*40+x%+1024
1050 gosub 24000
1080 return

1200 rem calculate percentage
1210 pc=(ft%-126)/874:return

1500 rem copy back from buffer
1510 sa%=8192:se%=9192:ta%=1024
1520 gosub 10950:return

1800 rem check game over
1810 gosub 1200:if pc>=mf then gosub 1900:return
1815 rem return: rem uncomment to disable enemy
1820 if kf%<>1 then return
1825 gosub 8500:ps%=pr%:if pr%=-1 then ps%=1043
1830 li%=li%-1:gosub 8200
1840 kf%=0:bl%=0:jo%=0:if li%=0 then 1950
1850 gosub 22000:return

1900 rem epic win sequence
1910 for i=0 to 10:for p=0 to 255:poke 53281,p:next p,i
1920 sd%=sd%-4:if sd%<5 then sd%=5
1930 jo%=0:gosub 1000:
1940 gosub 8300:return

1950 rem epic death sequence
1960 for i=0 to 1000:poke 53280,i and 1:next i
1970 run

1999 rem player movement, main game loop
2000 pm%=ps%:bl%=0:kf%=0:pr%=-1:pj%=0:oj%=0
2002 gosub 2200::cf%=0
2003 pp%=peek(ps%):poke ps%,dc%:poke ct,2
2005 gosub 7000:jo%=peek(56320)
2010 gosub 1800:if jo%=0 then 2000
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
3210 ps%=ps%-1:if int((ps%-1024)/40)<int((po%-1024)/40) then ps%=po%
3215 bf%=3:gosub 2500
3220 goto 2040

3300 rem right
3305 if bl%=3 then nc%=1:goto 2040
3310 ps%=ps%+1:if int((ps%-1024)/40)>int((po%-1024)/40) then ps%=po%
3315 bf%=4:gosub 2500
3320 goto 2040

3500 rem calc x/y
3510 pv%=pv%-1024
3520 y%=pv%/40:x%=pv%-(y%*40)
3530 return

3600 rem calc x/y of sprites
3610 gosub 3500
3620 x%=x%*8+16:y%=y%*8+45
3630 return

4000 rem fill
4010 poke 53280,15:gosub 24000
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
7002 ed%=ed%-1+(bl%>0)*5:if ed%>0 then return
7005 ed%=sd%:gosub 7500
7010 pv%=qp%:gosub 3600
7020 poke 53249,y%
7030 if x%>255 then poke 53248,x%-255:poke 53264,5:goto 7050
7040 poke 53248,x%:poke 53264,4
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
7525 ec%=ec%-1:if ax%>=2 then nq%=nq%-sgn(xd%)
7530 if ay%>=2 then nq%=nq%-sgn(yd%)*40
7540 if peek(nq%-1)>32 then gosub 8000:goto 7600
7550 if peek(nq%+1)>32 then gosub 8000:goto 7600
7560 if peek(nq%-40)>32 then gosub 8000:goto 7600
7570 if peek(nq%+40)>32 then gosub 8000
7600 qp%=nq%
7610 if pj%=qp% then oj%=oj%+1:if oj%=10 then ec%=1:return
7620 pj%=qp%:oj%=0:return

8000 rem enemy collision
8010 ct=nq%+54272
8020 nq%=qp%
8030 if (peek(ct-1) and 15)=7 then kf%=1
8040 if (peek(ct+1) and 15)=7 then kf%=1
8050 if (peek(ct-40) and 15)=7 then kf%=1
8060 if (peek(ct+40) and 15)=7 then kf%=1
8070 ec%=ec%+10:if ec%>280 then ec%=-100
8080 return

8200 rem print lives
8210 a$=str$(li%):a$=chr$(83)+":"+mid$(a$,2)
8220 sp%=896:gosub 20000
8230 return

8300 rem print completion
8310 gosub 1200
8320 a$=str$(int(pc*100))+"%":a$=mid$(a$,2)
8330 sp%=960:gosub 20000
8340 return

8500 rem death animation
8540 for i=0 to 3:ac%(i)=ps%:next:gosub 8800
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
8860 return

10300 rem flood fill
10305 sa%=1024:ta%=8192:se%=2024:gosub 10950
10320 sc%=8192:ch%=32:fc%=bc%
10400 ad%=sc%+40*y%+x%
10410 h%=ad%/256:h$=chr$(h%)
10420 l$=chr$(ad%-256*h%)
10430 if h$="" then return
10440 ad%=256*asc(h$)+asc(l$)
10450 h$=right$(h$,len(h$)-1):l$=right$(l$,len(l$)-1)
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
10700 z%=ad%/256:z$=chr$(z%):h$=h$+z$:l$=l$+chr$(ad%-256*z%)
10710 return

10950 rem copy
10960 poke ta%,peek(sa%):ta%=ta%+1:sa%=sa%+1
10980 if sa%<se% then 10960
10990 return

20000 rem copy a$ into sprite sp%
20005 a$=right$("   "+a$,3)
20010 poke 56334, peek(56334) and 254
20020 poke 1, peek(1) and 251
20030 for i=1 to 3:c$=mid$(a$,i,1)
20040 i%=sp%-1+i:ch=53248+asc(c$)*8:ai%=0
20050 poke i%,peek(ch)
20060 ch=ch+1:i%=i%+3:ai%=ai%+1
20070 if ai%<8 then 20050 
20075 next
20080 poke 1, peek(1) or 4
20090 poke 56334, peek(56334) or 1
20100 return

22000 rem remove incomplete polygons
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

40000 rem init sprite
40020 poke 53269,0:poke 53248,0:poke 53249,0
40022 poke 53250,32:poke 53251,60
40024 poke 53252,32:poke 53253,60
40026 poke 53264,4
40030 for i=832 to 832+63: read y%: poke i,y%: next
40040 poke 53287,13: poke 53288,10:poke 53289,0
40050 poke 2040,13:poke 2041,14:poke 2042,15
40060 poke 53276,0
40070 poke 53277,6
40080 poke 53271,6
40085 for i=896 to 1022:poke i,0:next
40086 poke 53269,7:return
40090 data 0,0,0,0,48,0,0,254,28,3,238,62,7,254,126,4
40100 data 252,254,9,255,254,18,127,158,52,255,156,63,255,252,63,255
40110 data 254,15,199,255,1,207,255,3,231,177,3,247,96,3,255,64
40120 data 0,255,192,0,127,0,0,0,0,0,0,0,0,0,0,13