/*Table 3 in Hegre, Oneal, and Russett, "Trade Does Promote Peace: New Simultaneous Estimates of the Reciprocal Effects 
of Trade and Conflict," Journal of Peace Research, 2010 47(6):763-774; conflict eqn based on Oneal and Russett (2005) and trade 
eqn on Long (2008): 12-03-2010*/


use HOR_JPR_table3

desc 
summ

gen dyadid=(statea*1000)+stateb

/*calc peace years for fatal MIDs*/
btscs fatal year dyadid, gen(py) nspline(3)

sort statea stateb year

keep if year>1949 & year<2001

gen smldem=polity_a if polity_a<=polity_b & polity_b~=.
replace smldem=polity_b if polity_b<polity_a & polity_a~=.
gen lrgdem=polity_b if polity_a<=polity_b & polity_b~=.
replace lrgdem=polity_a if polity_b<polity_a & polity_a~=.
drop polity*

/*calculate probability of winning and size using CINCs*/
gen lrgcap=cap_b if cap_a<=cap_b & cap_b~=.  
replace lrgcap=cap_a if cap_b<cap_a & cap_a~=.  
gen pwin_cap=lrgcap/(cap_a+cap_b)

gen lnlrgcap=ln(lrgcap)

gen smlrgdp=rgdp_a if rgdp_a<=rgdp_b & rgdp_b~=.
replace smlrgdp=rgdp_b if rgdp_b<rgdp_a & rgdp_a~=.
gen lrgrgdp=rgdp_b if rgdp_a<=rgdp_b & rgdp_b~=.  
replace lrgrgdp=rgdp_a if rgdp_b<rgdp_a & rgdp_a~=.  

/*take ln of rgdps*/
gen lnsmlrgdp=ln(smlrgdp)
gen lnlrgrgdp=ln(lrgrgdp)

/*take ln of sum of rgdps*/
gen lnsumrgdps=ln(smlrgdp+lrgrgdp)

/*calculate ln of populations*/
gen smlpop=tpop_a if tpop_a<=tpop_b & tpop_b~=.
replace smlpop=tpop_b if tpop_b<tpop_a & tpop_a~=.
gen lrgpop=tpop_b if tpop_a<=tpop_b & tpop_b~=.  
replace lrgpop=tpop_a if tpop_b<tpop_a & tpop_a~=.  

gen lnsmlpop=ln(smlpop)
gen lnlrgpop=ln(lrgpop)

/*take ln of sum of pops*/
gen lnsumpops=ln(smlpop+lrgpop)

sort statea stateb year

gen logdstab=ln(distance)

gen dircont=1 if contig<6
replace dircont=0 if contig==6


gen jtdem=1 if smldem>6 & lrgdem>6
replace jtdem=0 if jtdem==.

capture xi: i.year

#del ;
keep lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem allies Iyear*
	fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* state* year PTA
	lnsumrgdps lnsumpops s_wt_glo;
#del cr

/*HH's code for revised systsize: lnNt*/
sort year statea
capture drop Nt
by year statea: egen Nt= count(stateb) if statea==2 
replace Nt = Nt + 1 
replace Nt = Nt[_n-1] if statea!=2 & year==year[_n-1] 
gen lnNt = ln(Nt)
drop Nt 
summ lnNt 
replace lnNt = lnNt - 4.3175 
replace lnNt = 0 if dircont == 1
sort statea stateb year

gen state2=1 if statea==2 | stateb==2
replace state2=0 if state2==.
gen state20=1 if statea==20 | stateb==20
replace state20=0 if state20==.
gen state40=1 if statea==40 | stateb==40
replace state40=0 if state40==.
gen state41=1 if statea==41 | stateb==41
replace state41=0 if state41==.
gen state42=1 if statea==42 | stateb==42
replace state42=0 if state42==.
gen state51=1 if statea==51 | stateb==51
replace state51=0 if state51==.
gen state52=1 if statea==52 | stateb==52
replace state52=0 if state52==.
gen state70=1 if statea==70 | stateb==70
replace state70=0 if state70==.
gen state90=1 if statea==90 | stateb==90
replace state90=0 if state90==.
gen state91=1 if statea==91 | stateb==91
replace state91=0 if state91==.
gen state92=1 if statea==92 | stateb==92
replace state92=0 if state92==.
gen state93=1 if statea==93 | stateb==93
replace state93=0 if state93==.
gen state94=1 if statea==94 | stateb==94
replace state94=0 if state94==.
gen state95=1 if statea==95 | stateb==95
replace state95=0 if state95==.
gen state100=1 if statea==100 | stateb==100
replace state100=0 if state100==.
gen state101=1 if statea==101 | stateb==101
replace state101=0 if state101==.
gen state110=1 if statea==110 | stateb==110
replace state110=0 if state110==.
gen state130=1 if statea==130 | stateb==130
replace state130=0 if state130==.
gen state135=1 if statea==135 | stateb==135
replace state135=0 if state135==.
gen state140=1 if statea==140 | stateb==140
replace state140=0 if state140==.

compress

gen state145=1 if statea==145 | stateb==145
replace state145=0 if state145==.
gen state150=1 if statea==150 | stateb==150
replace state150=0 if state150==.
gen state155=1 if statea==155 | stateb==155
replace state155=0 if state155==.
gen state160=1 if statea==160 | stateb==160
replace state160=0 if state160==.
gen state165=1 if statea==165 | stateb==165
replace state165=0 if state165==.
gen state200=1 if statea==200 | stateb==200
replace state200=0 if state200==.
gen state205=1 if statea==205 | stateb==205
replace state205=0 if state205==.
gen state210=1 if statea==210 | stateb==210
replace state210=0 if state210==.
gen state211=1 if statea==211 | stateb==211
replace state211=0 if state211==.
gen state212=1 if statea==212 | stateb==212
replace state212=0 if state212==.
gen state220=1 if statea==220 | stateb==220
replace state220=0 if state220==.
gen state225=1 if statea==225 | stateb==225
replace state225=0 if state225==.
gen state230=1 if statea==230 | stateb==230
replace state230=0 if state230==.
gen state235=1 if statea==235 | stateb==235
replace state235=0 if state235==.
gen state260=1 if statea==260 | stateb==260
replace state260=0 if state260==.
gen state265=1 if statea==265 | stateb==265
replace state265=0 if state265==.
gen state290=1 if statea==290 | stateb==290
replace state290=0 if state290==.
gen state305=1 if statea==305 | stateb==305
replace state305=0 if state305==.
gen state310=1 if statea==310 | stateb==310
replace state310=0 if state310==.
gen state315=1 if statea==315 | stateb==315
replace state315=0 if state315==.
gen state317=1 if statea==317 | stateb==317
replace state317=0 if state317==.
gen state325=1 if statea==325 | stateb==325
replace state325=0 if state325==.
gen state339=1 if statea==339 | stateb==339
replace state339=0 if state339==.
gen state343=1 if statea==343 | stateb==343
replace state343=0 if state343==.
gen state344=1 if statea==344 | stateb==344
replace state344=0 if state344==.
gen state345=1 if statea==345 | stateb==345
replace state345=0 if state345==.
gen state346=1 if statea==346 | stateb==346
replace state346=0 if state346==.
gen state349=1 if statea==349 | stateb==349
replace state349=0 if state349==.
gen state350=1 if statea==350 | stateb==350
replace state350=0 if state350==.
gen state352=1 if statea==352 | stateb==352
replace state352=0 if state352==.
gen state355=1 if statea==355 | stateb==355
replace state355=0 if state355==.
gen state359=1 if statea==359 | stateb==359
replace state359=0 if state359==.
gen state360=1 if statea==360 | stateb==360
replace state360=0 if state360==.
gen state365=1 if statea==365 | stateb==365
replace state365=0 if state365==.
gen state366=1 if statea==366 | stateb==366
replace state366=0 if state366==.
gen state367=1 if statea==367 | stateb==367
replace state367=0 if state367==.
gen state368=1 if statea==368 | stateb==368
replace state368=0 if state368==.
gen state369=1 if statea==369 | stateb==369
replace state369=0 if state369==.
gen state370=1 if statea==370 | stateb==370
replace state370=0 if state370==.
gen state371=1 if statea==371 | stateb==371
replace state371=0 if state371==.
gen state372=1 if statea==372 | stateb==372
replace state372=0 if state372==.
gen state373=1 if statea==373 | stateb==373
replace state373=0 if state373==.
gen state375=1 if statea==375 | stateb==375
replace state375=0 if state375==.
gen state380=1 if statea==380 | stateb==380
replace state380=0 if state380==.
gen state385=1 if statea==385 | stateb==385
replace state385=0 if state385==.
gen state390=1 if statea==390 | stateb==390
replace state390=0 if state390==.
gen state395=1 if statea==395 | stateb==395
replace state395=0 if state395==.
gen state404=1 if statea==404 | stateb==404
replace state404=0 if state404==.
gen state411=1 if statea==411 | stateb==411
replace state411=0 if state411==.
gen state420=1 if statea==420 | stateb==420
replace state420=0 if state420==.
gen state432=1 if statea==432 | stateb==432
replace state432=0 if state432==.
gen state433=1 if statea==433 | stateb==433
replace state433=0 if state433==.
gen state434=1 if statea==434 | stateb==434
replace state434=0 if state434==.
gen state435=1 if statea==435 | stateb==435
replace state435=0 if state435==.
gen state436=1 if statea==436 | stateb==436
replace state436=0 if state436==.
gen state437=1 if statea==437 | stateb==437
replace state437=0 if state437==.
gen state438=1 if statea==438 | stateb==438
replace state438=0 if state438==.
gen state439=1 if statea==439 | stateb==439
replace state439=0 if state439==.
gen state450=1 if statea==450 | stateb==450
replace state450=0 if state450==.
gen state451=1 if statea==451 | stateb==451
replace state451=0 if state451==.
gen state452=1 if statea==452 | stateb==452
replace state452=0 if state452==.
gen state461=1 if statea==461 | stateb==461
replace state461=0 if state461==.
gen state471=1 if statea==471 | stateb==471
replace state471=0 if state471==.
gen state475=1 if statea==475 | stateb==475
replace state475=0 if state475==.
gen state481=1 if statea==481 | stateb==481
replace state481=0 if state481==.
gen state482=1 if statea==482 | stateb==482
replace state482=0 if state482==.
gen state483=1 if statea==483 | stateb==483
replace state483=0 if state483==.
gen state484=1 if statea==484 | stateb==484
replace state484=0 if state484==.
gen state490=1 if statea==490 | stateb==490
replace state490=0 if state490==.
gen state500=1 if statea==500 | stateb==500
replace state500=0 if state500==.
gen state501=1 if statea==501 | stateb==501
replace state501=0 if state501==.
gen state510=1 if statea==510 | stateb==510
replace state510=0 if state510==.
gen state516=1 if statea==516 | stateb==516
replace state516=0 if state516==.
gen state517=1 if statea==517 | stateb==517
replace state517=0 if state517==.
gen state520=1 if statea==520 | stateb==520
replace state520=0 if state520==.
gen state522=1 if statea==522 | stateb==522
replace state522=0 if state522==.

compress


gen state530=1 if statea==530 | stateb==530
replace state530=0 if state530==.
gen state531=1 if statea==531 | stateb==531
replace state531=0 if state531==.
gen state540=1 if statea==540 | stateb==540
replace state540=0 if state540==.
gen state541=1 if statea==541 | stateb==541
replace state541=0 if state541==.
gen state551=1 if statea==551 | stateb==551
replace state551=0 if state551==.
gen state552=1 if statea==552 | stateb==552
replace state552=0 if state552==.
gen state553=1 if statea==553 | stateb==553
replace state553=0 if state553==.
gen state560=1 if statea==560 | stateb==560
replace state560=0 if state560==.
gen state565=1 if statea==565 | stateb==565
replace state565=0 if state565==.
gen state570=1 if statea==570 | stateb==570
replace state570=0 if state570==.
gen state571=1 if statea==571 | stateb==571
replace state571=0 if state571==.
gen state572=1 if statea==572 | stateb==572
replace state572=0 if state572==.
gen state580=1 if statea==580 | stateb==580
replace state580=0 if state580==.
gen state581=1 if statea==581 | stateb==581
replace state581=0 if state581==.
gen state590=1 if statea==590 | stateb==590
replace state590=0 if state590==.
gen state600=1 if statea==600 | stateb==600
replace state600=0 if state600==.
gen state615=1 if statea==615 | stateb==615
replace state615=0 if state615==.
gen state616=1 if statea==616 | stateb==616
replace state616=0 if state616==.
gen state620=1 if statea==620 | stateb==620
replace state620=0 if state620==.
gen state625=1 if statea==625 | stateb==625
replace state625=0 if state625==.
gen state630=1 if statea==630 | stateb==630
replace state630=0 if state630==.
gen state640=1 if statea==640 | stateb==640
replace state640=0 if state640==.
gen state645=1 if statea==645 | stateb==645
replace state645=0 if state645==.
gen state651=1 if statea==651 | stateb==651
replace state651=0 if state651==.
gen state652=1 if statea==652 | stateb==652
replace state652=0 if state652==.
gen state660=1 if statea==660 | stateb==660
replace state660=0 if state660==.
gen state663=1 if statea==663 | stateb==663
replace state663=0 if state663==.
gen state666=1 if statea==666 | stateb==666
replace state666=0 if state666==.
gen state670=1 if statea==670 | stateb==670
replace state670=0 if state670==.
gen state678=1 if statea==678 | stateb==678
replace state678=0 if state678==.
gen state680=1 if statea==680 | stateb==680
replace state680=0 if state680==.
gen state690=1 if statea==690 | stateb==690
replace state690=0 if state690==.
gen state692=1 if statea==692 | stateb==692
replace state692=0 if state692==.
gen state694=1 if statea==694 | stateb==694
replace state694=0 if state694==.
gen state696=1 if statea==696 | stateb==696
replace state696=0 if state696==.
gen state698=1 if statea==698 | stateb==698
replace state698=0 if state698==.
gen state700=1 if statea==700 | stateb==700
replace state700=0 if state700==.
gen state701=1 if statea==701 | stateb==701
replace state701=0 if state701==.
gen state702=1 if statea==702 | stateb==702
replace state702=0 if state702==.
gen state703=1 if statea==703 | stateb==703
replace state703=0 if state703==.
gen state704=1 if statea==704 | stateb==704
replace state704=0 if state704==.
gen state705=1 if statea==705 | stateb==705
replace state705=0 if state705==.
gen state710=1 if statea==710 | stateb==710
replace state710=0 if state710==.
gen state712=1 if statea==712 | stateb==712
replace state712=0 if state712==.
gen state713=1 if statea==713 | stateb==713
replace state713=0 if state713==.
gen state731=1 if statea==731 | stateb==731
replace state731=0 if state731==.
gen state732=1 if statea==732 | stateb==732
replace state732=0 if state732==.
gen state740=1 if statea==740 | stateb==740
replace state740=0 if state740==.
gen state750=1 if statea==750 | stateb==750
replace state750=0 if state750==.
gen state760=1 if statea==760 | stateb==760
replace state760=0 if state760==.
gen state770=1 if statea==770 | stateb==770
replace state770=0 if state770==.
gen state771=1 if statea==771 | stateb==771
replace state771=0 if state771==.
gen state775=1 if statea==775 | stateb==775
replace state775=0 if state775==.
gen state780=1 if statea==780 | stateb==780
replace state780=0 if state780==.
gen state790=1 if statea==790 | stateb==790
replace state790=0 if state790==.
gen state800=1 if statea==800 | stateb==800
replace state800=0 if state800==.
gen state811=1 if statea==811 | stateb==811
replace state811=0 if state811==.
gen state812=1 if statea==812 | stateb==812
replace state812=0 if state812==.
gen state816=1 if statea==816 | stateb==816
replace state816=0 if state816==.
gen state817=1 if statea==817 | stateb==817
replace state817=0 if state817==.
gen state820=1 if statea==820 | stateb==820
replace state820=0 if state820==.
gen state830=1 if statea==830 | stateb==830
replace state830=0 if state830==.
gen state840=1 if statea==840 | stateb==840
replace state840=0 if state840==.
gen state850=1 if statea==850 | stateb==850
replace state850=0 if state850==.
gen state900=1 if statea==900 | stateb==900
replace state900=0 if state900==.
gen state910=1 if statea==910 | stateb==910
replace state910=0 if state910==.
gen state920=1 if statea==920 | stateb==920
replace state920=0 if state920==.
gen state950=1 if statea==950 | stateb==950
replace state950=0 if state950==.

sort statea stateb year
compress

save temp, replace

ren statea ccode1
ren stateb ccode2

drop state2

/*probit only, for comparison of estimated coeffs*/
probit fatal lnrtrade smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt

/*following states had no fatal disputes so must be dropped from simultaneous estimation*/
drop if state41==1
drop if state42==1
drop if state52==1
drop if state110==1
drop if state140==1
drop if state145==1
drop if state165==1
drop if state205==1
drop if state225==1
drop if state305==1
drop if state317==1
drop if state349==1
drop if state359==1
drop if state366==1
drop if state367==1
drop if state369==1
drop if state370==1
drop if state375==1
drop if state380==1
drop if state411==1
drop if state420==1
drop if state434==1
drop if state516==1
drop if state522==1
drop if state553==1
drop if state570==1
drop if state572==1
drop if state580==1
drop if state581==1
drop if state590==1
drop if state712==1
drop if state760==1
drop if state780==1
drop if state830==1
drop if state910==1
drop if state950==1

drop state41 
drop state42 
drop state52 
drop state110 
drop state140 
drop state145 
drop state165 
drop state205 
drop state225 
drop state305 
drop state317 
drop state349 
drop state359 
drop state366 
drop state367 
drop state369 
drop state370 
drop state375 
drop state380 
drop state411 
drop state420 
drop state434 
drop state516 
drop state522 
drop state553 
drop state570 
drop state572 
drop state580 
drop state581 
drop state590 
drop state712 
drop state760 
drop state780 
drop state830 
drop state910 
drop state950 

/*probit only, for comparison of estimated coeffs*/
probit fatal lnrtrade smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt

/*RESULTS FOR FIRST TWO COLUMNS IN TABLE 3*/
/*no state* or year* indicators, cdsimeq sample; lnNt included in both, Long's rat expect variables plus py*/
#del ;
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem allies PTA s_wt_glo py _spline* lnNt)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

/*RESULTS FOR SECOND TWO COLUMNS IN TABLE 3*/
/*state* and year* indicators in trade eqn, lnNt in both, all rat expect variables*/
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem allies PTA  s_wt_glo py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;


/*ROBUSTNESS TESTS*/

/*keep PTA, Iyear*, state*, py & _spline*; drop each of three other rational choice variables in Trade equation*/
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont allies PTA  s_wt_glo py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem PTA  s_wt_glo py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem allies PTA  py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

/*drop two of three other rational choice variables in Trade equation*/
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem PTA  py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont allies PTA  py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont PTA  s_wt_glo py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

/*drop three*/
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont PTA  py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt), nof nos;

/*1 with minimum variables in C*/
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem allies PTA  s_wt_glo py _spline* lnNt Iyear* state*)
	(fatal dircont logdstab pwin_cap lnlrgcap py _spline* lnNt), nof nos;

/*ADDITIONAL TEST*/
/*state* and year* indicators in conflict as well as trade eqn, lnNt in both, all rat expect variables*/
cdsimeq (lnrtrade lnsmlrgdp lnlrgrgdp lnsmlpop lnlrgpop logdstab dircont jtdem allies PTA s_wt_glo py _spline* lnNt Iyear* state*)
	(fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline* lnNt Iyear* state*), nof nos;


exit;

