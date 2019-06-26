/*Table 4 in Hegre, Oneal, and Russett, "Trade Does Promote Peace: New Simultaneous Estimates of the Reciprocal Effects 
of Trade and Conflict," Journal of Peace Research, 2010 47(6):763-774; conflict eqn based on Oneal and Russett (2005) 
and trade eqn on Long (2008), using Long's data for trade equation: 12-03-2010*/


set mem 300m
set matsize 700

/*
*from Long's replication file:
* This do file contains the analysis for Table 1 of "Bilateral Trade and Rational Expectations of Armed Conflict" and all 
* additional analysis referred to in the article.

insheet using "C:\SIMUL\LONG\Long_ISQ_2008 replication data.out"

desc
summ 

compress

save "C:\SIMUL\LONG\ArmedConflict_BilateralTrade.dta", replace
*/

use "C:\SIMUL\LONG\ArmedConflict_BilateralTrade.dta"

summ

/*select one directed dyad for each pair to create nondirected dyad; they are symmetrical*/
keep if ccode1<ccode2

ren ccode1 statea
ren ccode2 stateb

sort statea stateb year

summ

/*make data conform to BR's determinations*/
/*Long has data for 260 1984-90 only, no data for 255*/
li state* year if statea==2 & stateb==260 
li state* year if statea==2 & stateb==255 

/*recode to be consistent with BR's determination*/
replace statea=315 if statea==316 & year>1992
replace stateb=315 if stateb==316 & year>1992

replace statea=678 if statea==679 & year>1990
replace stateb=678 if stateb==679 & year>1990

sort statea stateb year

summ

save long_nondirect, replace


use HOR_JPR_table3

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

sort statea stateb year

merge statea stateb year using c:\simul\long\long_nondirect
tab _m
/*merge is flawless*/
keep if _m==1 | _m==3
drop _m

/*identify smaller and larger GDPs*/
gen lgdp_s=lgdp1 if lgdp1<lgdp2
replace lgdp_s=lgdp2 if lgdp2<lgdp1
gen lgdp_l=lgdp2 if lgdp1<lgdp2
replace lgdp_l=lgdp1 if lgdp2<lgdp1

/*identify smaller and larger GDPpcs*/
gen lgdppc_s=lgdppc1 if lgdppc1<lgdppc2
replace lgdppc_s=lgdppc2 if lgdppc2<lgdppc1
gen lgdppc_l=lgdppc2 if lgdppc1<lgdppc2
replace lgdppc_l=lgdppc1 if lgdppc2<lgdppc1

#del ;
gen mn_lprsicf=.5*(lprsicf1+lprsicf2);
gen mn_lprsecf=.5*(lprsecf1+lprsecf2);
gen mn_doarmcf=.5*(doarmcf1+doarmcf2);
gen mn_moarmcf=.5*(moarmcf1+moarmcf2);

/*RESULTS FOR TABLE 4*/
cdsimeq (lnrtrade lgdp_s lgdp_l lgdppc_s lgdppc_l logdstab dircont jdem allies lns 
	wtopta mn_doarmcf mn_moarmcf mn_lprsicf mn_lprsecf strival)
      (fatal smldem lrgdem dircont logdstab pwin_cap allies lnlrgcap py _spline*), nof;

exit;
