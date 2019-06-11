use ../Data/Individual.dta, clear


*** Generate coefficients

capture drop rank
drop if ison==.
drop if patience==. & risktaking==. & trust==.

sort country
egen rank = group(ison)


foreach j in patience risktaking posrecip negrecip altruism trust{
foreach i in age age_sqr gender math{
gen `j'_`i'_p_value=.
gen `j'_`i'_sig=0
gen `j'_`i'_coeff=0
}

foreach k of numlist 1/76 {
	egen `j'_stand_`k'=std(`j') if rank==`k'
	reg `j'_stand_`k' age age_sqr gender math if rank == `k', robust
	
	foreach i in age age_sqr gender math{
		replace `j'_`i'_p_value=(2 * ttail(e(df_r), abs(_b[`i']/_se[`i']))) if rank==`k'
		replace `j'_`i'_sig=1 if `j'_`i'_p_value<0.1 & rank==`k'
		replace `j'_`i'_sig=2 if `j'_`i'_p_value<0.05 & rank==`k'
		replace `j'_`i'_sig=3 if `j'_`i'_p_value<0.01 & rank==`k'
		replace `j'_`i'_coeff=_b[`i'] if rank==`k'
		}
	}
}




collapse (mean) ison patience* risktaking* altruism* posrecip* negrecip* trust* age gender (sd) sd_patience=patience sd_risktaking=risktaking sd_posrecip=posrecip sd_negrecip=negrecip sd_altruism=altruism sd_trust=trust, by(country)


********* Output figures

gen a=0



**** Figure 3

sort patience_gender_coeff
egen patience_rank_gender = group(patience_gender_coeff)
twoway (lfit a patience_rank_gender) (scatter patience_gender_coeff patience_rank_gender if patience_gender_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.45 .4)) ylabel(-.4 -.2 0 .2 .4)) (scatter patience_gender_coeff patience_rank_gender if patience_gender_sig==2,msymbol(Dh) mcolor(blue)) (scatter patience_gender_coeff patience_rank_gender if patience_gender_sig==1,msymbol(Th) mcolor(magenta)) (scatter patience_gender_coeff patience_rank_gender if patience_gender_sig==0), title("{it:Patience}") legend(off) ytitle("Coefficient on female") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort risktaking_gender_coeff
egen risktaking_rank_gender = group(risktaking_gender_coeff)
twoway (lfit a risktaking_rank_gender) (scatter risktaking_gender_coeff risktaking_rank_gender if risktaking_gender_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.45 .4)) ylabel(-.4 -.2 0 .2 .4)) (scatter risktaking_gender_coeff risktaking_rank_gender if risktaking_gender_sig==2,msymbol(Dh) mcolor(blue)) (scatter risktaking_gender_coeff risktaking_rank_gender if risktaking_gender_sig==1,msymbol(Th) mcolor(magenta)) (scatter risktaking_gender_coeff risktaking_rank_gender if risktaking_gender_sig==0), title("{it:Risk taking}") legend(off) ytitle("Coefficient on female") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort posrecip_gender_coeff
egen posrecip_rank_gender = group(posrecip_gender_coeff)
twoway (lfit a posrecip_rank_gender) (scatter posrecip_gender_coeff posrecip_rank_gender if posrecip_gender_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.45 .4)) ylabel(-.4 -.2 0 .2 .4)) (scatter posrecip_gender_coeff posrecip_rank_gender if posrecip_gender_sig==2,msymbol(Dh) mcolor(blue)) (scatter posrecip_gender_coeff posrecip_rank_gender if posrecip_gender_sig==1,msymbol(Th) mcolor(magenta)) (scatter posrecip_gender_coeff posrecip_rank_gender if posrecip_gender_sig==0), title("{it:Pos. reciprocity}") legend(off) ytitle("Coefficient on female") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort negrecip_gender_coeff
egen negrecip_rank_gender = group(negrecip_gender_coeff)
twoway (lfit a negrecip_rank_gender) (scatter negrecip_gender_coeff negrecip_rank_gender if negrecip_gender_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.45 .4)) ylabel(-.4 -.2 0 .2 .4)) (scatter negrecip_gender_coeff negrecip_rank_gender if negrecip_gender_sig==2,msymbol(Dh) mcolor(blue)) (scatter negrecip_gender_coeff negrecip_rank_gender if negrecip_gender_sig==1,msymbol(Th) mcolor(magenta)) (scatter negrecip_gender_coeff negrecip_rank_gender if negrecip_gender_sig==0), title("{it:Neg. reciprocity}") legend(off) ytitle("Coefficient on female") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort altruism_gender_coeff
egen altruism_rank_gender = group(altruism_gender_coeff)
twoway (lfit a altruism_rank_gender) (scatter altruism_gender_coeff altruism_rank_gender if altruism_gender_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.45 .4)) ylabel(-.4 -.2 0 .2 .4)) (scatter altruism_gender_coeff altruism_rank_gender if altruism_gender_sig==2,msymbol(Dh) mcolor(blue)) (scatter altruism_gender_coeff altruism_rank_gender if altruism_gender_sig==1,msymbol(Th) mcolor(magenta)) (scatter altruism_gender_coeff altruism_rank_gender if altruism_gender_sig==0), title("{it:Altruism}") legend(off) ytitle("Coefficient on female") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort trust_gender_coeff
egen trust_rank_gender = group(trust_gender_coeff)
twoway (lfit a trust_rank_gender) (scatter trust_gender_coeff trust_rank_gender if trust_gender_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.45 .4)) ylabel(-.4 -.2 0 .2 .4)) (scatter trust_gender_coeff trust_rank_gender if trust_gender_sig==2,msymbol(Dh) mcolor(blue)) (scatter trust_gender_coeff trust_rank_gender if trust_gender_sig==1,msymbol(Th) mcolor(magenta)) (scatter trust_gender_coeff trust_rank_gender if trust_gender_sig==0), title("{it:Trust}") legend(off) ytitle("Coefficient on female") xtitle("Countries") graphregion(fcolor(white) lcolor(white))








***** Figure 4


sort patience_math_coeff
egen patience_rank_math = group(patience_math_coeff)
twoway (lfit a patience_rank_math) (scatter patience_math_coeff patience_rank_math if patience_math_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.1 .2)) ylabel(-.1 -.05 0 .05 .1 .15 .2)) (scatter patience_math_coeff patience_rank_math if patience_math_sig==2,msymbol(Dh) mcolor(blue)) (scatter patience_math_coeff patience_rank_math if patience_math_sig==1,msymbol(Th) mcolor(magenta)) (scatter patience_math_coeff patience_rank_math if patience_math_sig==0), title("{it:Patience}") legend(off) ytitle("Coefficient on math skills") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort risktaking_math_coeff
egen risktaking_rank_math = group(risktaking_math_coeff)
twoway (lfit a risktaking_rank_math) (scatter risktaking_math_coeff risktaking_rank_math if risktaking_math_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.1 .2)) ylabel(-.1 -.05 0 .05 .1 .15 .2)) (scatter risktaking_math_coeff risktaking_rank_math if risktaking_math_sig==2,msymbol(Dh) mcolor(blue)) (scatter risktaking_math_coeff risktaking_rank_math if risktaking_math_sig==1,msymbol(Th) mcolor(magenta)) (scatter risktaking_math_coeff risktaking_rank_math if risktaking_math_sig==0), title("{it:Risk taking}") legend(off) ytitle("Coefficient on math skills") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort posrecip_math_coeff
egen posrecip_rank_math = group(posrecip_math_coeff)
twoway (lfit a posrecip_rank_math) (scatter posrecip_math_coeff posrecip_rank_math if posrecip_math_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.1 .2)) ylabel(-.1 -.05 0 .05 .1 .15 .2)) (scatter posrecip_math_coeff posrecip_rank_math if posrecip_math_sig==2,msymbol(Dh) mcolor(blue)) (scatter posrecip_math_coeff posrecip_rank_math if posrecip_math_sig==1,msymbol(Th) mcolor(magenta)) (scatter posrecip_math_coeff posrecip_rank_math if posrecip_math_sig==0), title("{it:Pos. reciprocity}") legend(off) ytitle("Coefficient on math skills") xtitle("Countries") graphregion(fcolor(white) lcolor(white))

sort negrecip_math_coeff
egen negrecip_rank_math = group(negrecip_math_coeff)
twoway (lfit a negrecip_rank_math) (scatter negrecip_math_coeff negrecip_rank_math if negrecip_math_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.1 .2)) ylabel(-.1 -.05 0 .05 .1 .15 .2)) (scatter negrecip_math_coeff negrecip_rank_math if negrecip_math_sig==2,msymbol(Dh) mcolor(blue)) (scatter negrecip_math_coeff negrecip_rank_math if negrecip_math_sig==1,msymbol(Th) mcolor(magenta)) (scatter negrecip_math_coeff negrecip_rank_math if negrecip_math_sig==0), title("{it:Neg. reciprocity}") legend(off) ytitle("Coefficient on math skills") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort altruism_math_coeff
egen altruism_rank_math = group(altruism_math_coeff)
twoway (lfit a altruism_rank_math) (scatter altruism_math_coeff altruism_rank_math if altruism_math_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.1 .2)) ylabel(-.1 -.05 0 .05 .1 .15 .2)) (scatter altruism_math_coeff altruism_rank_math if altruism_math_sig==2,msymbol(Dh) mcolor(blue)) (scatter altruism_math_coeff altruism_rank_math if altruism_math_sig==1,msymbol(Th) mcolor(magenta)) (scatter altruism_math_coeff altruism_rank_math if altruism_math_sig==0), title("{it:Altruism}") legend(off) ytitle("Coefficient on math skills") xtitle("Countries") graphregion(fcolor(white) lcolor(white))


sort trust_math_coeff
egen trust_rank_math = group(trust_math_coeff)
twoway (lfit a trust_rank_math) (scatter trust_math_coeff trust_rank_math if trust_math_sig==3,msymbol(Oh) mcolor(red) xscale(range(1 76)) xlabel(1 20 40 60 76) yscale(range(-.1 .2)) ylabel(-.1 -.05 0 .05 .1 .15 .2)) (scatter trust_math_coeff trust_rank_math if trust_math_sig==2,msymbol(Dh) mcolor(blue)) (scatter trust_math_coeff trust_rank_math if trust_math_sig==1,msymbol(Th) mcolor(magenta)) (scatter trust_math_coeff trust_rank_math if trust_math_sig==0), title("{it:Trust}") legend(off) ytitle("Coefficient on math skills") xtitle("Countries") graphregion(fcolor(white) lcolor(white))





