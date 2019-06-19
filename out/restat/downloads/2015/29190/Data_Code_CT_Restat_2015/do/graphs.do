


clear all

use $Output_final/main_ct
qui tab country, gen(iccode)
qui tab year,gen(time)
tsset ccode year


*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*FIGURE A1: Examples
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

*El Salvador
qui twoway(tsline pr if country=="El Salvador" & year>=1965,xtitle("") lwidth(medthick) ylabel(#4, labsize(vsmall)) ytitle("3y Avg. Price Growth",size(small)) lcolor(red))(tsline d_pol2_rob if country=="El Salvador" & year>=1965,/*
*/ lpattern(shortdash) lwidth(medthick) xlabel(1965(10)2010, labsize(vsmall)) ytitle("Polity Change", axis(2) size(small)) lcolor(blue) yaxis(2)ylabel(-6(3)6,axis(2) labsize(vsmall)) legend(off) title("El Salvador (Coffee: 6.5%)",size(small))), scheme(s1color)

*Iran
qui twoway(tsline pr if country=="Iran (Islamic Republic of)" & year>=1965,xtitle("")  ylabel(-0.25(0.25)1, labsize(vsmall)) ytitle("3y Avg. Price Growth",size(small)) lwidth(medthick) lcolor(red))/*
*/(tsline d_pol2_rob if country=="Iran (Islamic Republic of)" & year>=1965,xtitle("")ytitle("Polity Change", axis(2) size(small)) lpattern(shortdash) xlabel(1965(10)2010, labsize(vsmall)) lcolor(blue) lwidth(medthick) yaxis(2)ylabel(-10(5)10,axis(2) labsize(vsmall)) legend(off) title("Iran (Oil: 20.6%)",size(small))), scheme(s1color)

*Thailand
qui twoway(tsline pr if country=="Thailand" & year>=1965,xtitle("") lwidth(medthick) ylabel(#4, labsize(vsmall)) ytitle("3y Avg. Price Growth",size(small)) lcolor(red))(tsline d_pol2_rob if country=="Thailand" & year>=1965,/*
*/ lpattern(shortdash) lwidth(medthick) xlabel(1965(10)2010, labsize(vsmall)) ytitle("Polity Change", axis(2) size(small)) lcolor(blue) yaxis(2)ylabel(-15(5)10,axis(2) labsize(vsmall)) legend(off) title("Thailand (Rice: 2.3%)",size(small))), scheme(s1color)

*Sudan
qui twoway(tsline pr if country=="Sudan" & year>=1965,xtitle("") lwidth(medthick) ylabel(-0.2(0.2)0.4, labsize(vsmall)) ytitle("3y Avg. Price Growth",size(small))  /*xtitle("Year",size(small)height(5))*/  lcolor(red))/*
*/(tsline d_pol2_rob if country=="Sudan" & year>=1965, lpattern(shortdash) lwidth(medthick) xlabel(1965(10)2010, labsize(vsmall)) ytitle("Polity Change", axis(2) size(small)) lcolor(blue) yaxis(2)ylabel(-15(5)10,axis(2) labsize(vsmall)) legend(off) title("Sudan (Cotton: 3.3%)",size(small))), scheme(s1color)




  
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*FIGURE A2: Selected spot/futures graphs 
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gen Spot_index=price
gen Futures_index=fut_1y

*oil
qui twoway(tsline Spot if country=="Ecuador",lwidth(medthick) lcolor(red) ylabel(0(100)300, labsize(tiny))xlabel(1965(10)2010, labsize(tiny)) legend(cols(1) position(11) ring(0)) xtitle("") )(tsline Future if country=="Ecuador",lwidth(medthick) lpattern(shortdash) lcolor(blue)), title("Oil",size(small)) scheme(s1color)

*copper
qui twoway(tsline Spot if country=="Chile",lwidth(medthick) lcolor(red) ylabel(0(100)400, labsize(tiny))xlabel(1965(10)2010, labsize(tiny)) legend(off)  xtitle("") )(tsline Future if country=="Chile",lwidth(medthick) lpattern(shortdash) lcolor(blue)), title("Copper",size(small)) scheme(s1color)

*coffee
qui twoway(tsline Spot if country=="Brazil",lwidth(medthick) lcolor(red) ylabel(0(100)300, labsize(tiny))xlabel(1965(10)2010, labsize(tiny)) legend(off)  xtitle("") )(tsline Future if country=="Brazil",lwidth(medthick) lpattern(shortdash) lcolor(blue)), title("Coffee",size(small)) scheme(s1color)

*cocoa
qui twoway(tsline Spot if country=="Ivory Coast",lwidth(medthick) lcolor(red) ylabel(0(100)400, labsize(tiny))xlabel(1965(10)2010, labsize(tiny)) legend(off)  xtitle("") )(tsline Future if country=="Ivory Coast",lwidth(medthick) lpattern(shortdash) lcolor(blue)), title("Cocoa",size(small)) scheme(s1color)

*wheat
qui twoway(tsline Spot if country=="France",lwidth(medthick) lcolor(red) ylabel(0(100)300, labsize(tiny))xlabel(1965(10)2010, labsize(tiny))  legend(off) xtitle("") )(tsline Future if country=="France",lwidth(medthick)  lpattern(shortdash)lcolor(blue)), title("Wheat",size(small)) scheme(s1color)

*rice
qui twoway(tsline Spot if country=="Thailand",lwidth(medthick) lcolor(red) ylabel(0(100)400, labsize(tiny))xlabel(1965(10)2010, labsize(tiny)) legend(off) xtitle("") )(tsline Future if country=="Thailand",lwidth(medthick) lpattern(shortdash) lcolor(blue)), title("Rice",size(small)) scheme(s1color)





*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*FIGURE A3: Endogenous break
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

forvalues i=1(1)19 {
gen au`i'=1 if pl4+10<=`i' & pl4!=.
gen de`i'=1 if pl4+10>`i'  & pl4!=. 
replace de`i'=0 if de`i'==. & pl4!=.
replace au`i'=0 if au`i'==. & pl4!=.

gen prd`i'=pr*de`i'
gen pra`i'=pr*au`i'

reg d_pol2_rob prd`i' pra`i' de`i' time* iccode*,  cluster(ccode)
predict e`i',res
gen e`i'_sq=(e`i')^2
egen rss`i'=sum(e`i'_sq)
drop e`i' e`i'_sq
}


keep in 1
reshape long rss,i(ccode) j(try)
gen n2=_n-10

label var rss "Residual Sum of the Squares"
label var n2 "Threshold for Democracy"

twoway(scatter rss n2, xlabel(-9 "-9" -8"-8" -7"-7" -6"-6" -5"-5" -4"-4" -3"-3" -2"-2" -1"-1" 0 1 2 3 4 5 6 7 8 9  , labsize(vsmall)) ylabel(13500(100)13900,labsize(vsmall)) xtitle(,m(medlarge))ytitle(,m(medlarge))),scheme(s1mono)





*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
*FIGURE 3: Graph bins
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*



clear all

use $Output_final/main_ct
qui tab country, gen(iccode)
qui tab year,gen(time)
tsset ccode year

cd $Output_intm


gen bin=1 if pl4==-10 |pl4==-9|pl4==-8
replace bin=2 if pl4==-7 | pl4==-6
replace bin=3 if pl4==-5 |pl4==-4|pl4==-3 |pl4==-2|pl4==-1|pl4==0 
replace bin=4 if pl4==1 |pl4==2|pl4==3 |pl4==4|pl4==5 
replace bin=5 if pl4==6 |pl4==7
replace bin=6 if pl4==8 |pl4==9|pl4==10
tab bin


capture erase fig3.dta
tempname hdle
*STORE COEFFICIENT, STANDARD ERRORS AND NUMBER OF OBSERVATIONS 
postfile `hdle' b_pr se_pr e_N using fig3
 
qui forv j=1(1)6{
reg d_pol2_rob pr iccode* time* if bin==`j', cluster(code) 
post `hdle' (_b[pr]) (_se[pr]) (e(N))
}
save new_database_jit,replace 
postclose `hdle'

use fig3, clear


*YOU OBTAIN 6 BINS: EXPAND THEM TO OBTAIN GRAPH
gen n=_n
expand 3 if n==1
expand 2 if n==2
expand 6 if n==3
expand 5 if n==4
expand 2 if n==5
expand 3 if n==6


sort n
gen pl4=_n-11
 
 
*GENERATE UPPER AND LOWER BOUND 
gen t=b_pr/se_pr
gen band=se_pr*1.95
gen up=b_pr+band
gen down=b_pr-band


twoway (scatter b_pr pl4 if pl4==-9|pl4==-7|pl4==-3|pl4==3|pl4==7|pl4==9 [aweight=e_N],msize(medium) xlabel(-10(1)10, labsize(small))) (scatter b_pr pl4 if pl4==-9|pl4==-7|pl4==-3|pl4==3|pl4==7|pl4==9 ,msymbol(i))/*
*/ (scatter b_pr pl4 if pl4==-9|pl4==-7|pl4==-3|pl4==3|pl4==7|pl4==9, xtitle(Polity at t-4) mlabgap(*4) mlab(e_N) mlabpos(6) mlabsize(vsmall) msymbol(i) legend(off) xline(0, lcolor(black) lpattern(dash)) )/*
*/ (scatter up pl4 if pl4>=-10 & pl4<=-8, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/ (scatter up pl4 if pl4>=-7 & pl4<=-6, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter up pl4 if pl4>=-5 & pl4<=-1, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter up pl4 if pl4>=1 & pl4<=5, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter up pl4 if pl4>=6 & pl4<=7, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter up pl4 if pl4>=8 & pl4<=10, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin) ylabel(-4(1)3)/*
*/ text(-1 -9 "1st Bin [-10,-8]", size(vsmall))text(-1.5 -6.5 "2nd Bin [-7,-6]", size(vsmall))/*
*/text(-4 -3 "3rd Bin [-5,0]", size(vsmall))text(-2.4 3 "4th Bin [1,5]", size(vsmall))text(-0.5 7 "5th Bin [6,7]", size(vsmall))text(-0.8 9 "6th Bin [8,10]",size(vsmall))/*
*/ title("Estimated Coefficient at different bins.", size(small) position(11) ring(0)))/*
*/ (scatter down pl4 if pl4>=-10 & pl4<=-8, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/ (scatter down pl4 if pl4>=-7 & pl4<=-6, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter down pl4 if pl4>=-5 & pl4<=-1, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter down pl4 if pl4>=1 & pl4<=5, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter down pl4 if pl4>=6 & pl4<=7, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin))/*
*/(scatter down pl4 if pl4>=8 & pl4<=10, connect(l) lpattern(dash) lcolor(black) msymbol(i) mcolor(black) lwidth(thin)), scheme(sj)



