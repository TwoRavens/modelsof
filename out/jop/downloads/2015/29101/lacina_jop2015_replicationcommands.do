****************************
* Replication commands for 
* ``Periphery versus periphery: The Stakes of Separatist War,'' Bethany Lacina, Journal of Politics, 2015
****************************

****Set memory*****
set mem 500m

*****Macros for control variables*****
global Controls Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc Ldiffpop lpop ldist lrgdp lcpop spline*
global Controls2 Lanoc Ldemoc lpop ldist lrgdp lcpop spline*

*****Program used to create Table 5*****
capture program drop vuong
program vuong
preserve 
set more off
quietly{
keep if territorial==1
logit seponset `1'
gen aux1=e(sample)
logit seponset `2'
gen aux2=e(sample)
keep if aux1==1 & aux2==1
}
logit seponset `1'
quietly{
scalar define dm1 = e(df_m)
scalar define ll_pvp = e(ll)
predict p1
}
logit seponset `2'
quietly{
scalar define dm2 = e(df_m) 
scalar define ll_cvp = e(ll)
predict p2
gen one = (seponset*ln(p1/p2))+((1-seponset)*ln((1-p1)/(1-p2)))
egen temp = sum(one)
sum temp
scalar define mean1 = temp in 1
scalar define mean2 = (mean1)*(1/r(N))
gen diff=(one-mean2)^2
egen temp2 = sum(diff)
sum temp2
scalar define sigma2 = temp2 in 1
scalar define sigma = sqrt(sigma2) 
scalar define llrchm0 = (ll_pvp - ll_cvp)-((dm1/2)*ln(e(N))-(dm2/2)*ln(e(N)))
scalar define lldiff = (ll_pvp - ll_cvp)
scalar define Vuong = llrchm0/sigma
scalar define pvalue = 2*(1-normprob(abs(Vuong)))
}
scalar list ll_cvp ll_pvp Vuong pvalue
restore
end

*****Load data*****
use "lacina_jop2015_replication.dta", clear
notes

******TABLE 2*******

bysort relpowcategory: summ seponset if territorial==1
summ seponset if territorial==1

ttest seponset if (relpowcategory==1|relpowcategory==2) & territorial==1, by(relpowcategory)

ttest seponset if (relpowcategory==3|relpowcategory==2) & territorial==1, by(relpowcategory)

ttest seponset if (relpowcategory==5|relpowcategory==6) & territorial==1, by(relpowcategory)

*****TABLE 3 & TABLE 4******

*Model 1
qui: logit seponset $Controls if territorial==1
estimates store m1
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls if territorial==1, or cluster(cowcode)
lrtest m1 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 2
qui: logit seponset $Controls lineq2 oil if territorial==1
estimates store m1b
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 oil if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 oil if territorial==1, or cluster(cowcode)
lrtest m1b m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 3
qui: logit seponset $Controls low high oil if territorial==1
estimates store m1c
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls low high oil if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls low high oil if territorial==1, or cluster(cowcode)
lrtest m1c m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****TABLE 5/TABLE A2******

vuong "Lindisadv Lindom Lexex Lexdisadv Lexdom" "lineq2 oil" 
vuong "Lindisadv Lindom Lexex Lexdisadv Lexdom" "low high oil"  

*******************************
*******Online Appendix*********
*******************************

*****TABLE A1*****
summ seponset Linadv Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 oil low high if e(sample)

*****TABLE A3******
qui: logit seponset Lexcluded Ldeter Lgrieve $Controls if territorial==1
estimates store m2
summ Lgrieve Ldeter Lexcluded if e(sample)

*****TABLE A4******
*Model 7
logit seponset Lgrieve Ldeter Lexcluded $Controls if territorial==1, or cluster(cowcode)
lrtest m1 m2

*Model 8
logit seponset Lgrieve Ldeter Lexcluded $Controls lineq2 oil if territorial==1, or cluster(cowcode)
qui: logit seponset Lgrieve Ldeter Lexcluded $Controls lineq2 oil if territorial==1
estimates store m2
lrtest m1b m2

*Model 9
logit seponset Lgrieve Ldeter Lexcluded $Controls low high oil if territorial==1, or cluster(cowcode)
qui: logit seponset Lgrieve Ldeter Lexcluded $Controls low high oil if territorial==1
estimates store m2
lrtest m1c m2

*****TABLE A5********
*Model 10 & 11
vuong "Lgrieve Ldeter" "lineq2 oil"

*Model 12
vuong "Lgrieve Ldeter" "low high oil"

*Model 13 & 14
vuong "Lgrieve Ldeter Lexcluded" "lineq2 oil Lexcluded"

*Model 15
vuong "Lgrieve Ldeter Lexcluded" "low high oil Lexcluded"

*****TABLE A6*******
qui: logit seponset $Controls if territorial==1
summ lrgdpxineq2 lrgdpxlow lrgdpxhigh Lautonxlineq2 Lautonxoil Lautonxlow Lautonxhigh ///
Lfed Lethnofederal LfedxLauton LfedxLauton_y LfedxLautonxLauton_y LefedxLauton LefedxLauton_y LefedxLautonxLauton_y ///
Lcbcoeth Lcbegip Lcbwar ldistb onborder olap_potentialmig ///
cntryfrac Lpotclaimsnv cspline_cntrypyrs1 ///
pcolap allolap_x allnspline1 ///
if e(sample)

*****TABLE A7-A8***********

*Model 16
qui: logit seponset spline* if territorial==1
estimates store m0
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom spline* if territorial==1, or
estimates store m2
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 17
set more off
qui: logit seponset $Controls i.cowcode if territorial==1
estimates store m0
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls i.cowcode if territorial==1, or
estimates store m2
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****TABLE A9-A10********

*Model 18
qui: logit seponset $Controls lineq2 lrgdpxineq2 oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 lrgdpxineq2 oil if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 lrgdpxineq2 oil if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 19
qui: logit seponset $Controls low high oil lrgdpxhigh lrgdpxlow if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls low high oil lrgdpxhigh lrgdpxlow if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls low high oil lrgdpxhigh lrgdpxlow if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****Table A11-A12********

*Model 20
qui: logit seponset $Controls2 Lautonomy Lautonomy_y Ldiffpop lineq2 oil Lautonxlineq2 Lautonxoil if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls2 Lautonomy Lautonomy_y Ldiffpop lineq2 oil Lautonxlineq2 Lautonxoil if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls2 Lautonomy Lautonomy_y Ldiffpop lineq2 oil Lautonxlineq2 Lautonxoil if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 21
qui: logit seponset $Controls2 Lautonomy Lautonomy_y Ldiffpop low high oil Lautonxlow Lautonxhigh Lautonxoil if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls2 Lautonomy Lautonomy_y Ldiffpop low high oil Lautonxlow Lautonxhigh Lautonxoil if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls2 Lautonomy  Lautonomy_y Ldiffpop low high oil Lautonxlow Lautonxhigh Lautonxoil if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****Table A13-A14********

*Model 22
qui: logit seponset $Controls Lfed if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lfed if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lfed if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 23
qui: logit seponset $Controls Lethnofed if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lethnofed if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lethnofed if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 24
qui: logit seponset $Controls Lfed Lfedx* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lfed Lfedx* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lfed Lfedx* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 25
qui: logit seponset $Controls Lethnofederal Lefedx* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lethnofederal Lefedx* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lethnofederal Lefedx* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****Table A15-A16********

*Model 26
qui: logit seponset $Controls Lcbcoeth  if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lcbcoeth  if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lcbcoeth if territorial==1 , or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 27
qui: logit seponset $Controls Lcbegip Lcbwar if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lcbegip Lcbwar if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lcbegip Lcbwar if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 28
qui: logit seponset Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop  Ldiffpop lrgdp lcpop ldistb spline* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop Ldiffpop lrgdp lcpop ldistb spline* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop Ldiffpop lrgdp lcpop ldistb spline* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 29
qui: logit seponset Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop Ldiffpop lrgdp lcpop onborder spline* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop Ldiffpop lrgdp lcpop onborder spline* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop Ldiffpop lrgdp lcpop onborder spline* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 30
qui: logit seponset $Controls olap_potentialmig if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls olap_potentialmig if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls olap_potentialmig if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****Table A17-A18********

*Model 31
qui: logit seponset $Controls cntryfrac if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls cntryfrac if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls cntryfrac  if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 32
qui: logit seponset $Controls Lpotclaimsnv if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lpotclaimsnv if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls Lpotclaimsnv if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 33
qui: logit seponset Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc lpop ldist Ldiffpop lrgdp lcpop cspline* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist Ldiffpop lrgdp lcpop cspline* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist Ldiffpop lrgdp lcpop cspline* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****Table A19-A20*******

*Model 34
qui: logit seponset Lanoc Ldemoc  lpop ldist pcolap lrgdp lcpop spline* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist pcolap lrgdp lcpop spline* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist pcolap lrgdp lcpop spline* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 35
qui: logit seponset Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist allolap_x lrgdp lcpop spline* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist allolap_x lrgdp lcpop spline* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist allolap_x lrgdp lcpop spline* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 36
qui: logit seponset Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist Ldiffpop lrgdp lcpop allnspline* if territorial==1
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist Ldiffpop lrgdp lcpop allnspline* if territorial==1
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom Lautonomy Lautonomy_y LautonxLauton_y Lanoc Ldemoc  lpop ldist Ldiffpop lrgdp lcpop allnspline* if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*****Table A21-A23*******
*Summary statistics for new variables 
qui: logit seponset Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2  if territorial==1
estimates store m0
summ Linadv_mpop Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop if e(sample)

*Model 37
qui: logit seponset Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 if territorial==1
estimates store m2
logit seponset Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2  if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_mpop
test Lindom_mpop=Lindisadv_mpop
test Lexdom_mpop=Lexdisadv_mpop

*Model 38
qui: logit seponset Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 lineq2 oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 lineq2 oil if territorial==1
estimates store m2
logit seponset Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 lineq2 oil  if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_mpop
test Lindom_mpop=Lindisadv_mpop
test Lexdom_mpop=Lexdisadv_mpop

*Model 39
qui: logit seponset Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 low high oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 low high oil if territorial==1
estimates store m2
logit seponset Lindisadv_mpop Lindom_mpop Lexex_mpop Lexdisadv_mpop Lexdom_mpop Lautonomy Lautonomy_mpop LautonxLauton_mpop Ldiffpop_mpop $Controls2 low high oil  if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_mpop
test Lindom_mpop=Lindisadv_mpop
test Lexdom_mpop=Lexdisadv_mpop

*****Table A24-A26*******
*Summary statistics for new variables 
qui: logit seponset Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 if territorial==1
estimates store m0
summ Linadv_alln Lindisadv_alln Lindom_alln Lexex_alln Lexdisadv_alln Lexdom_alln Lautonomy_alln LautonxLauton_alln Ldiffpop_alln if e(sample)

*Model 40
qui: logit seponset Lindisadv_alln Lindom_alln Lexex_alln Lexdisadv_alln Lexdom_alln Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 if territorial==1
estimates store m2
logit seponset Lindisadv_alln Lindom_alln Lexex_alln Lexdisadv_alln Lexdom_alln Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_alln
test Lindom_alln=Lindisadv_alln
test Lexdom_alln=Lexdisadv_alln

*Model 41
qui: logit seponset Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 lineq2 oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv_alln Lindom_alln Lexex_alln Lexdisadv_alln Lexdom_alln Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 lineq2 oil if territorial==1
estimates store m2
logit seponset Lindisadv_alln Lindom_alln Lexex_alln Lexdisadv_alln Lexdom_alln Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 lineq2 oil if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_alln
test Lindom_alln=Lindisadv_alln
test Lexdom_alln=Lexdisadv_alln

*Model 42
qui: logit seponset Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 low high oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv_alln Lindom_alln Lexdom_alln Lexdisadv_alln Lexex_alln Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 low high oil if territorial==1
estimates store m2
logit seponset Lindisadv_alln Lindom_alln Lexdom_alln Lexdisadv_alln Lexex_alln Lautonomy Lautonomy_alln LautonxLauton_alln Ldiffpop_alln $Controls2 low high oil if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_alln
test Lindom_alln=Lindisadv_alln
test Lexdom_alln=Lexdisadv_alln

*****Table A27-A29*******
*Summary statistics for new variables 
qui: logit seponset Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 if territorial==1
estimates store m0
summ Linadv_mp Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp  Lautonomy_mp LautonxLauton_mp Ldiffpop_mp if e(sample)

*Model 43
qui: logit seponset Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp  Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 if territorial==1
estimates store m2
logit seponset Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2  if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_mp
test Lindom_mp=Lindisadv_mp
test Lexdom_mp=Lexdisadv_mp

*Model 44
qui: logit seponset Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 lineq2 oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 lineq2 oil if territorial==1
estimates store m2
logit seponset Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 lineq2 oil if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_mp
test Lindom_mp=Lindisadv_mp
test Lexdom_mp=Lexdisadv_mp

*Model 45
qui: logit seponset Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 low high oil if territorial==1
estimates store m0
qui: logit seponset Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 low high oil if territorial==1
estimates store m2
logit seponset Lindisadv_mp Lindom_mp Lexex_mp  Lexdisadv_mp Lexdom_mp Lautonomy Lautonomy_mp LautonxLauton_mp Ldiffpop_mp $Controls2 low high oil  if territorial==1, or cluster(cowcode)
lrtest m0 m2
test Lindisadv_mp
test Lindom_mp=Lindisadv_mp
test Lexdom_mp=Lexdisadv_mp

*****Table A30-A32*******
*Summary statistics including migrant, urban and dispersed groups
qui:  logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls
estimates store m2
summ seponset Linadv Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 oil low high if e(sample)

*Model 46
qui: logit seponset $Controls
estimates store m0
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 47
qui: logit seponset $Controls lineq2 oil
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 oil
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls lineq2 oil, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

*Model 48
qui: logit seponset $Controls low high oil
estimates store m0
qui: logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls low high oil
estimates store m2
logit seponset Lindisadv Lindom Lexex Lexdisadv Lexdom $Controls low high oil, or cluster(cowcode)
lrtest m0 m2
test Lindisadv
test Lindom=Lindisadv
test Lexdom=Lexdisadv

