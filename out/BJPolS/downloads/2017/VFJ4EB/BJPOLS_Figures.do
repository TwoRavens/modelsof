
**************************************
*** OWNERSHIP*SALIENCE INTERACTION ***
**************************************

** SOTU **
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

foreach x of numlist 0/60 {
quietly xtpcse speechshare_ rank_gov_lcompetence_ i.pelectioncycle mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
lincomest rank_gov_lcompetence_+(mip_rankcomp_*`x')
parmest, label format(estimate min95 max95 p %8.5f) list(parm label estimate min95 max95 p, clean noobs) saving("tf`x'", replace)
}

dsconcat "tf1" "tf2" "tf3" "tf4" "tf5" "tf6" "tf7" "tf8" "tf9" "tf10" "tf11" "tf12" "tf13" "tf14" "tf15" "tf16" "tf17" "tf18" "tf19" "tf20" "tf21" "tf22" "tf23" "tf24" "tf25" "tf26" "tf27" "tf28" "tf29" "tf30" "tf31" "tf32" "tf33" "tf34" "tf35" "tf36" "tf37" "tf38" "tf39" "tf40" "tf41" "tf42" "tf43" "tf44" "tf45" "tf46" "tf47" "tf48" "tf49" "tf50" "tf51" "tf52" "tf53" "tf54" "tf55" "tf56" "tf57" "tf58" "tf59" "tf60" 
gen count=_n

format estimate min95 max95 %8.1f

drop if count>50
* 
twoway line estimate count, /*
*/ clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/ || line estimate count, /*
*/ clpattern(dash) clcolor(black) clwidth(medthick) /* 
*/ || line min95 count,  /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ || line max95 count, /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ title("") /*
*/ xtitle("Issue Salience") /*
*/ ytitle("Marginal Effect") /*
*/ ytick(-5(2.5)15) /*
*/ ylabel(-5(2.5)15) /*
*/ xtick(0(5)50) /*
*/ xlabel(0(5)50) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(,angle(horizontal)) /*
*/ legend(off)  

graph export BJPOLS_FIG_1a.tif, width(2000)

** MILAWS **
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

foreach x of numlist 0/60 {
quietly xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
lincomest rank_cong_lcompetence_+(mip_congrankcomp_*`x')
parmest, label format(estimate min95 max95 p %8.5f) list(parm label estimate min95 max95 p, clean noobs) saving("tf`x'", replace)
}

dsconcat "tf1" "tf2" "tf3" "tf4" "tf5" "tf6" "tf7" "tf8" "tf9" "tf10" "tf11" "tf12" "tf13" "tf14" "tf15" "tf16" "tf17" "tf18" "tf19" "tf20" "tf21" "tf22" "tf23" "tf24" "tf25" "tf26" "tf27" "tf28" "tf29" "tf30" "tf31" "tf32" "tf33" "tf34" "tf35" "tf36" "tf37" "tf38" "tf39" "tf40" "tf41" "tf42" "tf43" "tf44" "tf45" "tf46" "tf47" "tf48" "tf49" "tf50" "tf51" "tf52" "tf53" "tf54" "tf55" "tf56" "tf57" "tf58" "tf59" "tf60" 
gen count=_n

format estimate min95 max95 %8.1f

drop if count>50
* 
twoway line estimate count, /*
*/ clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/ || line estimate count, /*
*/ clpattern(dash) clcolor(black) clwidth(medthick) /* 
*/ || line min95 count,  /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ || line max95 count, /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ title("") /*
*/ xtitle("Issue Salience") /*
*/ ytitle("Marginal Effect") /*
*/ ytick(-5(2.5)15) /*
*/ ylabel(-5(2.5)15) /*
*/ xtick(0(5)50) /*
*/ xlabel(0(5)50) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(,angle(horizontal)) /*
*/ legend(off) 

graph export BJPOLS_FIG_2a.tif, width(2000)

************************************
* OWNERSHIP*POPULARITY INTERACTION *
************************************

** SOTU **
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year

foreach x of numlist 0/70 {
quietly xtpcse speechshare_ i.pelectioncycle rank_gov_lcompetence_ mipshare_int_ mip_rankcomp_ gov_vote vot_rankcomp_ divided mip_div_ rankcomp_div_ mip_rankcomp_div_, correlation(psar1)
lincomest rank_gov_lcompetence_+(vot_rankcomp_*`x')
parmest, label format(estimate min95 max95 p %8.5f) list(parm label estimate min95 max95 p, clean noobs) saving("tf`x'", replace)
}

dsconcat "tf1" "tf2" "tf3" "tf4" "tf5" "tf6" "tf7" "tf8" "tf9" "tf10" "tf11" "tf12" "tf13" "tf14" "tf15" "tf16" "tf17" "tf18" "tf19" "tf20" "tf21" "tf22" "tf23" "tf24" "tf25" "tf26" "tf27" "tf28" "tf29" "tf30" "tf31" "tf32" "tf33" "tf34" "tf35" "tf36" "tf37" "tf38" "tf39" "tf40" "tf41" "tf42" "tf43" "tf44" "tf45" "tf46" "tf47" "tf48" "tf49" "tf50" "tf51" "tf52" "tf53" "tf54" "tf55" "tf56" "tf57" "tf58" "tf59" "tf60" "tf61" "tf62" "tf63" "tf64" "tf65" "tf66" "tf67" "tf68" "tf69" "tf70" "tf71" "tf72" "tf73" "tf74" "tf75" 
gen count=_n

format estimate min95 max95 %8.1f
drop if count<30
drop if count>70
* 
twoway line estimate count, /*
*/ clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/ || line estimate count, /*
*/ clpattern(dash) clcolor(black) clwidth(medthick) /* 
*/ || line min95 count,  /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ || line max95 count, /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ title("") /*
*/ xtitle("Popularity") /*
*/ ytitle("Marginal Effect") /*
*/ ytick(-5(2.5)5) /*
*/ ylabel(-5(2.5)5) /*
*/ xtick(30(5)70) /*
*/ xlabel(30(5)70) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(,angle(horizontal)) /*
*/ legend(off) 

graph export BJPOLS_FIG_1b.tif, width(2000)

** MILAWS **
use BJPOLS_Data_US.dta, clear
sort year majortopic
xtset majortopic year
gen rank_cong_lcompetence_time_=rank_cong_lcompetence_*year

foreach x of numlist 0/70 {
quietly xtpcse milawsshare_ i.electioncycle rank_cong_lcompetence_ mipshare_int_ mip_congrankcomp_ cong_gov_vote vot_congrankcomp_ divided mip_div_ congrankcomp_div_ mip_congrankcomp_div_, correlation(psar1)
lincomest rank_cong_lcompetence_+(vot_congrankcomp_*`x')
parmest, label format(estimate min95 max95 p %8.5f) list(parm label estimate min95 max95 p, clean noobs) saving("tf`x'", replace)
}

dsconcat "tf1" "tf2" "tf3" "tf4" "tf5" "tf6" "tf7" "tf8" "tf9" "tf10" "tf11" "tf12" "tf13" "tf14" "tf15" "tf16" "tf17" "tf18" "tf19" "tf20" "tf21" "tf22" "tf23" "tf24" "tf25" "tf26" "tf27" "tf28" "tf29" "tf30" "tf31" "tf32" "tf33" "tf34" "tf35" "tf36" "tf37" "tf38" "tf39" "tf40" "tf41" "tf42" "tf43" "tf44" "tf45" "tf46" "tf47" "tf48" "tf49" "tf50" "tf51" "tf52" "tf53" "tf54" "tf55" "tf56" "tf57" "tf58" "tf59" "tf60" "tf61" "tf62" "tf63" "tf64" "tf65" "tf66" "tf67" "tf68" "tf69" "tf70" "tf71" "tf72" "tf73" "tf74" "tf75" 
gen count=_n

format estimate min95 max95 %8.1f
drop if count<30
drop if count>70
* 
twoway line estimate count, /*
*/ clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/ || line estimate count, /*
*/ clpattern(dash) clcolor(black) clwidth(medthick) /* 
*/ || line min95 count,  /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ || line max95 count, /*
*/ clpattern(dot) clcolor(black) clwidth(medium) /*
*/ , scheme(s2mono) /*
*/ graphregion(color(white)) /*
*/ title("") /*
*/ xtitle("Popularity") /*
*/ ytitle("Marginal Effect") /*
*/ ytick(-5(2.5)5) /*
*/ ylabel(-5(2.5)5) /*
*/ xtick(30(5)70) /*
*/ xlabel(30(5)70) /*
*/ xscale(titlegap(2)) /*
*/ ylabel(,angle(horizontal)) /*
*/ legend(off) 

graph export BJPOLS_FIG_2b.tif, width(2000)
