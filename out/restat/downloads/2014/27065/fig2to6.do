clear all
set more off
set memory 100m
local temp: tempfile
set scheme s1color


gen firms=.
save `temp', replace
quietly forvalues firms = 4/5 {
insheet using `firms'firms-stochastic-update.txt, tab clear
for num 1/5 \ any 0.067 0.242 0.383 0.242 0.067: global probX = Y
for num 1/`firms': gen kxX = xX_k1*${prob1} + xX_k2*${prob2} + xX_k3*${prob3} + xX_k4*${prob4} + xX_k5*${prob5}
for num 1/`firms': gen KxiX=round(xiX*10,1)
drop x*
gen firms=`firms'
append using `temp'
save `temp', replace
}

for num 1/5: format kxX %4.0f

save temp, replace
use temp, clear

local firms=5
keep if firms==`firms'

*******************************************************************
* Figure2: own-innovation vs. onw-xi
gen Sx1=kx1
egen Mx =rmean(kx*)
egen Mxi=rmean(Kxi*)
label var Sx1 "symmetric firms"
label var kx1 "Leader"
label var kx`firms' "Laggard"
label var Mx  "average innovation"
#delimit ;
twoway 
(scatter Sx1 Kxi1 if Kxi1==Kxi`firms', mcolor(navy) msize(large)  msymbol(S) c(solid) lc(navy) lwidth(medium)) 
(scatter kx1 Kxi1, sort                mcolor(gs0)  msize(medium) msymbol(o)) 
(scatter Mx  Mxi ,                     mcolor(gs0)  msize(small)  msymbol(p))
(scatter kx`firms' Kxi`firms', sort    mcolor(gs8)  msize(medium) msymbol(o))
, xlabel(-15(5)15) xtitle("Quality (relative to outside good)", margin(small)) ytitle("Innovation", margin(small)) ;
#delimit cr

for num 1 3 `firms': table KxiX, c(min kxX max kxX)

*******************************************************************
* Figure3
egen Txi=rsum(Kxi*)
for num 1/5: gen Txi_X=(Txi-KxiX)/4
label var kx3 "  "
label var kx2 "  "
label var kx4 "  "
*ylabel(450(50)615)
#delimit ;
twoway 
(scatter kx1 Txi_1 if Kxi1==0, msymbol(o) mcolor(gs0)) 
(scatter kx2 Txi_2 if Kxi2==0, msymbol(o) mcolor(gs5)) 
(scatter kx3 Txi_3 if Kxi3==0, msymbol(o) mcolor(gs8)) 
(scatter kx4 Txi_4 if Kxi4==0, msymbol(o) mcolor(gs10))
(scatter kx5 Txi_5 if Kxi5==0, msymbol(o) mcolor(gs13)) 
, xlabel(-15(5)15) ylabel(200(10)250) legend(rows(1))
ytitle("Innovation", margin(small)) xtitle("Average quality of rivals (own quality = 0)", margin(small));
#delimit cr

for num 1/5: summ kxX if KxiX==0

for num 1/5: summ kxX if KxiX==0 & Txi_X== 4
for num 1/5: summ kxX if KxiX==0 & Txi_X== 0 
for num 1/5: summ kxX if KxiX==0 & Txi_X==-4

/*
*******************************************************************
* Figure4
egen SDxi=rsd(Kxi*)
for num 1/5: gen SDxi_X=  ( ( 5*(SDxi^2) - (KxiX-Mxi)^2 )/4 )^(.5)

gen GAPxi12 = Kxi1-Kxi2
gen GAPxi45 = Kxi4-Kxi5
format SDxi_1 %2.0f

contour kx3 GAPxi12 Kxi2 if Kxi3==0 & Kxi2==-Kxi4 & GAPxi12==GAPxi45, scheme(s1mono) ccuts(214 216 218 220 222 224 226) ccolors(gs15 gs15 gs13 gs11 gs8 gs5 gs0 gs0) xtitle("Quality gap with firm 2 (+) and firm 4 (-)", margin(small)) ytitle("Additional quality gap with firm 1 and firm 5", margin(small))
/*
twoway contour kx3   Kxi1  Kxi2   if Kxi3==0 & Kxi4==-Kxi2 & Kxi5==-Kxi1, scheme(s1mono) ccuts(487 493 498 504 509 514 520) ccolors(gs15 gs15 gs13 gs11 gs8 gs5 gs0) xtitle("Quality gap with firm 2 (and firm 4)", margin(small)) ytitle("Quality gap with firm 1 (and firm 5)", margin(small))
twoway contour kx1 SDxi_1 GAPxi12 if Kxi1==0 & Txi==-28                 , scheme(s1mono) ccuts(542 552 561 570 579 588)     ccolors(gs15 gs15 gs13 gs11 gs8 gs5 gs0) xtitle("Quality gap with nearest rival", margin(small)) ytitle("Standard deviation of rivals' quality", margin(small))
twoway contour kx1 SDxi_1 GAPxi12 if Kxi1==8 & Txi==-20                 , scheme(s1mono) ccuts(350 358 366 374 382 390)     ccolors(gs15 gs15 gs13 gs11 gs8 gs5 gs0) xtitle("Quality gap with nearest rival", margin(small)) ytitle("Standard deviation of rivals' quality", margin(small))
* laggard, seems pretty similar at different levels
* laggard: could use GAPxi5=(Kxi3+Kxi4)/2 - Kxi5, more interesting, but more erratic patterns
* at Txi=0 shows rotating of lines more clearly
twoway contour kx5 SDxi_5 GAPxi45 if Kxi5==-8 & Txi==20                 , scheme(s1mono) ccuts( 71  72  73  74  75  76)     ccolors(gs15 gs13 gs11 gs8 gs5 gs0 gs0) xtitle("Quality gap with nearest rival", margin(small)) ytitle("Standard deviation of rivals' quality", margin(small))
twoway contour kx5 SDxi_5 GAPxi45 if Kxi5==0  & Txi==28                 , scheme(s1mono) ccuts(455 457 459 461 463 465 467)     ccolors(gs15 gs15 gs13 gs11 gs8 gs5 gs0) xtitle("Quality gap with nearest rival", margin(small)) ytitle("Standard deviation of rivals' quality", margin(small))
*/
* check maximum range holding xi & Txi constant:
forvalues xi = 1(1)5 {
	for num 0/14: egen  MaxF`xi'xiX=max(kx`xi') if Kxi`xi'==X, by(Txi)
	for num 0/14: egen  MinF`xi'xiX=min(kx`xi') if Kxi`xi'==X, by(Txi)
	for num 0/14: egen mMaxF`xi'xiX=mean(MaxF`xi'xiX), by(Txi)
	for num 0/14: egen mMinF`xi'xiX=mean(MinF`xi'xiX), by(Txi)
	}
for num 0/14: egen MAxiX=rmax(mMaxF1xiX mMaxF2xiX mMaxF3xiX mMaxF4xiX mMaxF5xiX)
for num 0/14: egen MIxiX=rmax(mMinF1xiX mMinF2xiX mMinF3xiX mMinF4xiX mMinF5xiX)
for num 0/14: gen RATX=MAxiX/MIxiX
summ RAT*

*/
***********************************
* Figure 5: adding firms

for num 2/5: gen SXx=kx1 if Kxi1==KxiX & firms==X
drop Txi
egen Txi=rsum(Kxi*)
twoway (line S2x S3x S4x S5x Kxi1, nodraw                   lcolor(gs14 gs10 gs0) lwidth(thick thick medthick) sort), legend(cols(3)) xlabel(-15(5)15)
twoway (line S3x S4x S5x Txi if Txi>=-60&Txi<=60, nodraw lcolor(gs14 gs10 gs0) lwidth(thick thick medthick) sort), legend(cols(3)) xlabel(-60(20)60)

use temp, clear
keep if (firms==4) | (firms==5 & Kxi5==-14)
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx1=kx1/kx1[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx2=kx2/kx2[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx3=kx3/kx3[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx4=kx4/kx4[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx1=kx1-kx1[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx2=kx2-kx2[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx3=kx3-kx3[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx4=kx4-kx4[_n-1]
egen MINratx4=min(ratx4),  by(Kxi4)
egen MAXratx4=max(ratx4),  by(Kxi4)
egen Mratx4  =mean(ratx4), by(Kxi4)
twoway (line Mratx4 MINratx4 MAXratx4 Kxi4, nodraw sort)
twoway (scatter ratx4 Kxi4 if Kxi4>-14, nodraw sort) (scatter ratx1 Kxi1 if Kxi1>-14),  xlabel(-15(5)15)
twoway (scatter ratx4 Kxi4            , nodraw sort) (scatter ratx1 Kxi1           )
* looks just the same with N=4
*scatter ratx3 Txi if Kxi3==-14
*twoway (scatter ratx3 Kxi3, sort yaxis(1) msymbol(X) mcolor(gs0)) (scatter ratx1 Kxi1, msymbol(X) mcolor(gs12)) (scatter difx1 Kxi1, yaxis(2) msymbol(O) mcolor(gs12)) (scatter difx3 Kxi3, yaxis(2) msymbol(O) mcolor(gs0)), xlabel(-15(5)15)  ylabel(-125 -100 -75 -50 -25 0, axis(2)) ylabel(0.7 0.8 0.9 , axis(1))
twoway (scatter ratx4 Kxi4 if Kxi4>-14, nodraw msymbol(O) mcolor(gs14)) (scatter ratx1 Kxi1 if Kxi1>-14, msymbol(O) mcolor(gs0)), xlabel(-15(5)15) ylabel(0.80 0.82 0.84 0.86 0.88 0.90) name(ratF5, replace) legend(off)
twoway (scatter difx4 Kxi4,    nodraw         msymbol(O) mcolor(gs14)) (scatter difx1 Kxi1,             msymbol(O) mcolor(gs0)), xlabel(-15(5)15) ylabel(-60 -40 -20 0)                 name(difF5, replace) legend(label(1 "firm 4") label(2 "firm 1"))


use temp, clear
keep if (firms==4) | (firms==5 & Kxi1==14)
gen kx0=kx1
for num 1/4 \ num 2/5: replace KxiX=KxiY if firms==5   /* 1 is old-leader, with N=4, new leader is #0 */
for num 1/4 \ num 2/5: replace kxX =kxY  if firms==5
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx1=kx1/kx1[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx2=kx2/kx2[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx3=kx3/kx3[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen ratx4=kx4/kx4[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx1=kx1-kx1[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx2=kx2-kx2[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx3=kx3-kx3[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 (firms): gen difx4=kx4-kx4[_n-1]
twoway (scatter ratx4 Kxi4 if Kxi4>-14, nodraw msymbol(O) mcolor(gs14)) (scatter ratx1 Kxi1 if Kxi1>-14, msymbol(O) mcolor(gs0)), xlabel(-15(5)15) ylabel(0.80 0.82 0.84 0.86 0.88 0.90) name(ratF1, replace) legend(off)
twoway (scatter difx4 Kxi4,     nodraw        msymbol(O) mcolor(gs14)) (scatter difx1 Kxi1,             msymbol(O) mcolor(gs0)), xlabel(-15(5)15) ylabel(-60 -40 -20 0)                 name(difF1, replace) legend(label(1 "firm 4") label(2 "firm 1"))
* figure also looks similar, but with deaper drop in patenting

use temp, clear
keep if (firms==4) | (firms==5 & Kxi3==0)
for num 5 4 \ num 4 3: replace KxiX=KxiY if firms==4  /* bottom 2 under N=4 shift down 2 places with new firm at xi=0 */
for num 5 4 \ num 4 3: replace kxX =kxY  if firms==4
replace Kxi3=0 if firms==4
replace kx3 =. if firms==4
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen ratx1=kx1/kx1[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen ratx2=kx2/kx2[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen ratx4=kx4/kx4[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen ratx5=kx5/kx5[_n-1] 
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen difx1=kx1-kx1[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen difx2=kx2-kx2[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen difx4=kx4-kx4[_n-1]
bysort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 (firms): gen difx5=kx5-kx5[_n-1]
twoway (scatter ratx5 Kxi5  if Kxi5>-14, nodraw msymbol(O) mcolor(gs14)) (scatter ratx4 Kxi4  if Kxi4>-14, msymbol(T) mcolor(gs10)) (scatter ratx2 Kxi2  if Kxi2>-14, msymbol(T) mcolor(gs8)) (scatter ratx1 Kxi1 if Kxi1>-14, msymbol(O) mcolor(gs0)), xlabel(-15(5)15) ylabel(0.80 0.82 0.84 0.86 0.88 0.90) name(ratF3, replace) legend(off)
twoway (scatter difx5 Kxi5,     nodraw         msymbol(O) mcolor(gs14)) (scatter difx4 Kxi4,              msymbol(T) mcolor(gs10)) (scatter difx2 Kxi2,              msymbol(T) mcolor(gs8)) (scatter difx1 Kxi1,             msymbol(O) mcolor(gs0)), xlabel(-15(5)15) ylabel(-60 -40 -20 0)                 name(difF3, replace) legend(rows(1) label(1 "firm 4") label(2 "firm 3") label(3 "firm 2") label(4 "firm 1"))
graph combine ratF5 ratF3 ratF1 difF5 difF3 difF1, row(2)


**********************************************************
*Figure6: histogram with new firm
use temp, clear
keep if firms==4
drop kx5 Kxi5 firms
egen Tx4=rsum(kx*)
egen Mx4=rmean(kx*)
drop kx*

gen weight1=.
replace weight1=1  if  Kxi1==Kxi4
replace weight1=4  if (Kxi1==Kxi3 | Kxi2==Kxi4)              & weight1==.
replace weight1=6  if (Kxi1==Kxi2 &              Kxi3==Kxi4) & weight1==.
replace weight1=12 if (Kxi1==Kxi2 | Kxi2==Kxi3 | Kxi3==Kxi4) & weight1==.
replace weight1=24 if                                          weight1==.

sort Kxi1 Kxi2 Kxi3 Kxi4
compress
local temp: tempfile
save `temp', replace

insheet using mkt_st_weights-update.csv, clear delimit(";")
for num 1/4: gen KxiX=2*(kkxiX-7)
rename s100000 weight2
drop kk*
capture drop s*
compress
drop if Kxi1==.
sort  Kxi1 Kxi2 Kxi3 Kxi4
merge Kxi1 Kxi2 Kxi3 Kxi4 using `temp', update
drop _merge
save `temp', replace

* generate weights for entry distribution of firm5 --> distribution of firm3
capture drop new*
kdensity Kxi3 [weight=weight1], nodraw bwidth(1.5) at(Kxi3)  gen(newx1 newy1)
kdensity Kxi3 [weight=weight2], nodraw bwidth(1.5) at(newx1) gen(newx2 newy2)
line newy1 newy2 Kxi3, nodraw sort
bysort Kxi3: replace newy1=.  if _n>1
bysort Kxi3: replace newy2=. if _n>1
for var newy1 newy2: egen TX=sum(X)
for var newy1 newy2:  gen FX=round(100*X/TX)
table Kxi3, c(sum Fnewy1 sum Fnewy2) row

clear
local newfile: tempfile
gen Kxi5=.
save `newfile', replace

forvalues new = -14(2)14 {
	use `temp', clear
	gen Kxi5=`new'
	append using `newfile'
	save `newfile', replace
}

gen enter_in_center=1 if Kxi5==0
gen entryweight3=.
gen entryweight4=.
for num -14(2)14 \ any 2 6 9 11 12 12 11 10  9 7 5 3 2 1 0: replace entryweight3=Y if Kxi5==X
for num -14(2)14 \ any 0 0 0  2  9 22 30 24 11 2 0 0 0 0 0: replace entryweight4=Y if Kxi5==X
gen weight3 = ceil(weight2 * entryweight3/100)
gen weight4 = ceil(weight2 * entryweight4/100)
gen weight5 = ceil(weight2 * (entryweight3+entryweight4)/50)

for num 1/5: gen newxiX=.
                       replace newxi1=Kxi5 if Kxi5> Kxi1
for num 2/5 \ num 1/4: replace newxiX=KxiY if Kxi5> Kxi1
                       replace newxi1=Kxi1 if Kxi5<=Kxi1 & Kxi5>Kxi2
                       replace newxi2=Kxi5 if Kxi5<=Kxi1 & Kxi5>Kxi2
for num 3/5 \ num 2/4: replace newxiX=KxiY if Kxi5<=Kxi1 & Kxi5>Kxi2
for num 1/2          : replace newxiX=KxiX if Kxi5<=Kxi2 & Kxi5>Kxi3
                       replace newxi3=Kxi5 if Kxi5<=Kxi2 & Kxi5>Kxi3
for num 4/5 \ num 3/4: replace newxiX=KxiY if Kxi5<=Kxi2 & Kxi5>Kxi3
for num 1/3          : replace newxiX=KxiX if Kxi5<=Kxi3 & Kxi5>Kxi4
                       replace newxi4=Kxi5 if Kxi5<=Kxi3 & Kxi5>Kxi4
                       replace newxi5=Kxi4 if Kxi5<=Kxi3 & Kxi5>Kxi4
for num 1/4          : replace newxiX=KxiX if Kxi5<=Kxi4 
                       replace newxi5=Kxi5 if Kxi5<=Kxi4 

drop Kxi*
renpfix newxi Kxi
sort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5
save `newfile', replace

use temp, clear
keep if firms==5
egen Tx5=rsum(kx*)
egen Mx5=rmean(kx*)
drop kx*
sort Kxi1 Kxi2 Kxi3 Kxi4 Kxi5
merge Kxi1 Kxi2 Kxi3 Kxi4 Kxi5 using `newfile'
gen Txratio=Tx5/Tx4
gen Mxratio=Mx5/Mx4

sort Txratio
for num 1/5: replace weightX=1 if weightX==0 in 1
*gsort -Txratio
for num 1/5: replace weightX=1 if weightX==0 & (Txratio>=1.4795 & Txratio<=1.4805)
histogram Txratio if Txratio>.88&Txratio<1.48 [weight=weight1], nodraw start(0.88) bin(10) percent xlabel(0.88 1    1.12 1.24 1.36 1.48) xtitle("Ratio of aggregate innovation: N=5 versus N=4", margin(medium)) title("(a) Using uniform distribution of firm quality") name(Thist1, replace)
histogram Txratio if Txratio>.88&Txratio<1.48 [weight=weight2], nodraw start(0.88) bin(10) percent xlabel(0.88 1    1.12 1.24 1.36 1.48) xtitle("Ratio of aggregate innovation with additional firm present", margin(medium)) name(Thist2, replace)
histogram Txratio if Txratio>.88&Txratio<1.48&enter_in_center==1 [weight=weight2], nodraw start(0.88) bin(10) percent xlabel(0.88 1    1.12 1.24 1.36 1.48) xtitle("Ratio of aggregate innovation with additional firm present", margin(medium)) name(Thist2b, replace)
histogram Txratio if Txratio>.88&Txratio<1.48 [weight=weight3], nodraw start(0.88) bin(10) percent xlabel(0.88 1    1.12 1.24 1.36 1.48) xtitle("Ratio of aggregate innovation with additional firm present", margin(medium)) name(Thist3, replace)
histogram Txratio if Txratio>.88&Txratio<1.48 [weight=weight4], nodraw start(0.88) bin(10) percent xlabel(0.88 1    1.12 1.24 1.36 1.48) xtitle("Ratio of aggregate innovation with additional firm present", margin(medium)) name(Thist4, replace)
histogram Txratio if Txratio>.88&Txratio<1.48 [weight=weight5], nodraw start(0.88) bin(10) percent xlabel(0.88 1    1.12 1.24 1.36 1.48) xtitle("Ratio of aggregate innovation: N=5 versus N=4", margin(medium)) title("(b) Using simulated distribution of firm quality") name(Thist5, replace)

graph combine Thist1 Thist5, ycommon ysize(3) rows(1)


