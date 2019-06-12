//SET WORKING DIRECTORY:
//cd **directory path**

use dcacw, clear

set scheme s1mono

xtset compmonth

//the following lines are necessary for the rug plot in Figure 3
preserve
gen conspct = conrate if comptag==1 
keep conspct
keep if conspct!=.
replace conspct = conspct * 100
save company_conrates, replace
restore

//FIGURE 1
hist conrate if comptag==1, freq xtitle("Proportion of a unit's soldiers that are conscripts", ///
	size(large)) xlabel(#11, labsize(large)) ylabel(#6, labsize(large)) ytitle("Frequency", size(large)) 
graph export "Figure 1.tif", replace

//FIGURE 2
preserve
keep if comptag==1
egen conrate_c = std(conrate)
egen comfrag_c = std(comfrag)
egen jobfrag_c = std(jobfrag)
egen agevar_c = std(agevar)
egen unionpol_c = std(unionpol)
collapse (mean) conrate_c comfrag_c jobfrag_c agevar_c unionpol_c, by(month)
twoway (connected conrate_c month, msymbol(circle)) ///
	(connected comfrag_c month, msymbol(circle_hollow)) (connected jobfrag_c month, msymbol(X)) ///
	(connected agevar_c month, msymbol(square)) (connected unionpol_c month, msymbol(T)) ,  xscale(range(0 8)) ylabel(-.6(.2).2, labsize(large)) ///  
	xlabel(1 "January" 3 "March" 5 "May" 7 "July", labsize(large)) xtitle("")  ytitle("Mean across companies" "(standardized)", size(large)) ///
	legend(order(1 "Proportion conscripts" 2 "County heterogeneity" 3 "Job heterogeneity" 4 "Age variation" 5 "Union polarization"))
graph export "Figure 2.tif", replace
restore


//TABLE 1
//the next line is merely here to generate "in_sample"
quietly regress deserted conscript hasaff ///
	c.conrate_mc##c.sh_std unionpol_mc ///
	i.tenure
gen in_sample=1 if e(sample)

su deserted deserted_alt if in_sample==1

preserve
collapse (first) conscript hasaff if in_sample==1, by(id)
su conscript hasaff
restore

su conrate unionpol sh_std if comptag==1


//TEXT CLAIMS ABOUT DESERTION AND DISAPPEARANCE RATE

preserve
gen disap = 0
replace disap = 1 if deserted==1 & deserted_alt==0
collapse (mean) deserted deserted_alt disap (first) deathrate, by(compmonth)
su deserted deserted_alt disap
restore


//TABLE 2

quietly xtlogit deserted conscript hasaff ///
	c.conrate_mc##c.sh_std unionpol_mc  ///
	i.tenure 
estimates store mod1

estout mod1, cells(b(star fmt(3)) se(fmt(3))) stats(N ll bic sigma_u) starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001)


//REJECTING THE NULL OF NO TENURE DEPENDENCE
quietly xtlogit deserted conscript hasaff ///
	c.conrate_mc##c.sh_std unionpol_mc 
estimates store mod1_notime
lrtest mod1 mod1_notime

//MARGINS
estimates restore mod1
margins, expression(1/(1+exp(-predict(xb)))) at(conrate_mc =(-.4995585 .5004416))
margins, expression(1/(1+exp(-predict(xb)))) at(conscript = (0 1))
margins, expression(1/(1+exp(-predict(xb)))) at(hasaff = (0 1))
margins, expression(1/(1+exp(-predict(xb)))) at(unionpol_mc = (-.5067739 .3835875))


//FIGURE 3

estimates restore mod1
preserve
drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b6*0 +			///AFFPOL=0 (I.E. MEAN)
	b7*0 +			///TENURE =0
	b8*0 +			///TENURE =0
	b9*0 +			///TENURE =0
	b10*0 +			///TENURE =0
	b11*1 +			///CONSTANT
	b12*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b3*(`a')			///
		+ b4 * -.8185877 				/// sh_std = 25th percentile
		+ b5 * -.8185877 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b3*(`a')			///
		+ b4 * 1.14244 				///sh_std = 75th percentile
		+ b5 * 1.14244 * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
append using company_conrates
gen pipe = "|"
gen where = -.012
twoway (line diff_hat conspct in 1/40, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct in 1/40, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct in 1/40, clpattern(dash) clwidth(thin) clcolor(black)) ///
	   (scatter where conspct in 41/151, msymbol(none) mlabel(pipe) mlabpos(0)), ///
			xtitle("% Conscripts")	///
			ytitle("Effect of heterogeneity on probability of desertion" "(shift from 25th to 75th percentile)") ///
			yline(0, lcol(gs10)) ///
			legend(off) ///
			saving(fig3, replace)
graph export "Figure 3.tif", replace
restore




//****MATERIAL FOR ONLINE APPENDIX****

//TABLE A1

gen promote = .
replace promote = 0 if month == 1 & in1 ==1 & in3==1 & rnum3 >= rnum1
replace promote = 1 if month == 1 & in1 ==1  & in3==1 & rnum3 < rnum1
replace promote = 0 if month == 3 & in3==1 & in5==1 & rnum5 >= rnum3
replace promote = 1 if month == 3 & in3==1 & in5==1 & rnum5 < rnum3
replace promote = 0 if month == 5 & in5==1 & in7==1 & rnum7 >= rnum5
replace promote = 1 if month == 5 & in5==1 & in7==1 & rnum7 < rnum5

gen stayed = 0 if month==1 & in1==1
replace stayed = 1 if month==1 & in1==1 & in3==1
replace stayed = 0 if month==3 & in3==1
replace stayed = 1 if month==3 & in3==1 & in5==1
replace stayed = 0 if month==5 & in5==1
replace stayed = 1 if month==5 & in5==1 & in7==1

bysort compmonth: egen totalstayed = sum(stayed)
bysort compmonth: egen size_nomis = count(stayed)
gen turnover = 1-totalstayed/size_nomis if size_nomis !=0

xtlogit promote conscript hasaff conrate_mc turnover i.tenure 



//TABLE A2

//model from paper
quietly xtlogit deserted conscript hasaff ///
	c.conrate_mc##c.sh_std unionpol_mc  ///
	i.tenure 
estimates store mod1


//stricter coding of dependent variable
quietly xtlogit deserted_alt conscript hasaff ///
	c.conrate_mc##c.sh_std unionpol_mc  ///
	i.tenure 
estimates store moda2


//the experience of combat

quietly xtlogit deserted conscript hasaff  ///
	c.conrate_mc##c.sh_std unionpol_mc ///
	deathratelag  ///
	i.tenure
estimates store moda3

quietly xtlogit deserted conscript hasaff  ///
	c.conrate_mc##c.sh_std unionpol_mc ///
	casratelag  ///
	i.tenure
estimates store moda4

//disaggregating social heterogeneity
quietly xtlogit deserted conscript hasaff ///
	unionpol_mc c.conrate_mc##c.comfrag_mc c.conrate_mc##c.jobfrag_mc c.conrate_mc##c.agevar_mc ///
	i.tenure
estimates store moda5


estout mod1 moda2 moda3 moda4 moda5, cells(b(star fmt(3)) se(fmt(3))) stats(N ll bic sigma_u) starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001)


//FIGURE A1A

estimates restore mod1
preserve
drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b6*0 +			///AFFPOL=0 (I.E. MEAN)
	b7*0 +			///TENURE =0
	b8*0 +			///TENURE =0
	b9*0 +			///TENURE =0
	b10*0 +			///TENURE =0
	b11*1 +			///CONSTANT
	b12*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b3*(`a')			///
		+ b4 * -.8185877 				/// sh_std = 25th percentile
		+ b5 * -.8185877 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b3*(`a')			///
		+ b4 * 1.14244 				///sh_std = 75th percentile
		+ b5 * 1.14244 * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle("Effect of heterogeneity on probability of desertion" "(shift from 25th to 75th percentile)") ///
			yline(0, lcol(gs10)) ///
			legend(off) ///
			fxsize(80) ///
			title("1A. Main definition of desertion") ///
			saving(figa1acombine, replace)

restore

//FIGURE A1B
estimates restore moda2
preserve
drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b6*0 +			///AFFPOL=0 (I.E. MEAN)
	b7*0 +			///TENURE =0
	b8*0 +			///TENURE =0
	b9*0 +			///TENURE =0
	b10*0 +			///TENURE =0
	b11*1 +			///CONSTANT
	b12*0			// VARIANCE IN CONSTANTS


	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b3*(`a')			///
		+ b4 * -.8185877 				/// sh_std = 25th percentile
		+ b5 * -.8185877 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b3*(`a')			///
		+ b4 * 1.14244 				///sh_std = 75th percentile
		+ b5 * 1.14244 * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle(" ") ///
			ylabel(none) ///
			yline(0, lcol(gs10)) ///
			legend(off) ///
			title("1B. Strict definition of desertion") ///
			fxsize(80) ///
			saving(figa1bcombine, replace)
restore

//FIGURE A1 COMBINED
graph combine figa1acombine.gph figa1bcombine.gph, ycommon xsize(7) imargin(tiny) iscale(1) ///
	saving(figa1, replace)
graph export "Figure A1.tif", replace



//FIGURE A2

//Counties
estimates restore moda5
preserve
drawnorm b1-b18, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b3*0 +			///UNIONPOL=0 (I.E. MEAN)
	b13*0 +			///TENURE =0
	b14*0 +			///TENURE =0
	b15*0 +			///TENURE =0
	b16*0 +			///TENURE =0
	b17*1 +			///CONSTANT
	b18*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b4*(`a')			///
		+ b5 * -.048875 				/// comfrag = 25th percentile
		+ b6 * -.048875 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b4*(`a')			///
		+ b5 * .0883784 				/// comfrag = 75th percentile
		+ b6 * .0883784 * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle("Effect of heterogeneity on probability of desertion" "(shift from 25th to 75th percentile)") ///
			yline(0, lcol(gs10)) ///
			fxsize(80) ///
			legend(off) ///
			title("2A. Hometowns") ///
			saving(figa2acombine, replace)
restore

//Jobs
estimates restore moda5
preserve
drawnorm b1-b18, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b3*0 +			///UNIONPOL=0 (I.E. MEAN)
	b13*0 +			///TENURE =0
	b14*0 +			///TENURE =0
	b15*0 +			///TENURE =0
	b16*0 +			///TENURE =0
	b17*1 +			///CONSTANT
	b18*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b4*(`a')			///
		+ b8 * -.0265002 				/// jobfrag = 25th percentile
		+ b9 * -.0265002 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b4*(`a')			///
		+ b8 * .0420573  				///jobfrag = 75th percentile
		+ b9 * .0420573  * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle(" ") ///
			ylabel(none) ///
			fxsize(80) ///
			yline(0, lcol(gs10)) ///
			legend(off) ///
			title("2B. Occupations") ///
			saving(figa2bcombine, replace)
restore


//Ages

estimates restore moda5
preserve
drawnorm b1-b18, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b3*0 +			///UNIONPOL=0 (I.E. MEAN)
	b13*0 +			///TENURE =0
	b14*0 +			///TENURE =0
	b15*0 +			///TENURE =0
	b16*0 +			///TENURE =0
	b17*1 +			///CONSTANT
	b18*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b4*(`a')			///
		+ b11 * -.0510167 				/// agevar = 25th percentile
		+ b12 * -.0510167 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b4*(`a')			///
		+ b11 *  .0409944   				///agevar = 75th percentile
		+ b12 *  .0409944   * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi conspct if diff_hi <=.04, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle(" ") ///
			ylabel(none) ///			
			yline(0, lcol(gs10)) ///
			legend(off) ///
			fxsize(80) ///
			title("2C. Ages") ///
			saving(figa2ccombine, replace)
restore

//FIGURE A2 COMBINED
graph combine figa2acombine.gph figa2bcombine.gph figa2ccombine.gph, rows (1) ycommon xsize(10) imargin(tiny) iscale(1) ///
	saving(figa2, replace)
graph export "Figure A2.tif", replace






//TABLE A3
quietly xtlogit deserted conscript hasaff ///
	c.sh_std c.conrate_mc##c.unionpol_mc  ///
	i.tenure 
estimates store moda6
	
quietly xtlogit deserted conscript hasaff ///
	c.conrate_mc##c.sh_std##c.unionpol_mc  ///
	i.tenure 
estimates store moda7	

estout moda6 moda7, cells(b(star fmt(3)) se(fmt(3))) stats(N ll bic sigma_u) starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001)


//FIGURE A3
estimates restore moda6
preserve
drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b7*0 +			///TENURE =0
	b8*0 +			///TENURE =0
	b9*0 +			///TENURE =0
	b10*0 +			///TENURE =0
	b11*1 +			///CONSTANT
	b12*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b4*(`a')			///
		+ b5 *   -.1284474  				/// unionpol = 25th percentile
		+ b6 * -.1284474  * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b4*(`a')			///
		+ b5 *  .1797506    				///unionpol = 75th percentile
		+ b6 *  .1797506   * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle("Effect of union polarization on probability of desertion" "(shift from 25th to 75th percentile)") ///
			yline(0, lcol(gs10)) ///
			legend(off)
graph export "Figure A3.tif", replace
restore




//FIGURE A4
estimates restore mod1
preserve
drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b6*0 +			///AFFPOL=0 (I.E. MEAN)
	b7*0 +			///TENURE =0
	b8*0 +			///TENURE =0
	b9*0 +			///TENURE =0
	b10*0 +			///TENURE =0
	b11*1 +			///CONSTANT
	b12*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b3*(`a')			///
		+ b4 * -.8185877 				/// sh_std = 25th percentile
		+ b5 * -.8185877 * (`a')			///
		+ x_b_controls
	gen x_betahat1 = b3*(`a')			///
		+ b4 * 1.14244 				///sh_std = 75th percentile
		+ b5 * 1.14244 * (`a'	)		///
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100
twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			ytitle("Effect of heterogeneity on probability of desertion" "(shift from 25th to 75th percentile)") ///
			yline(0, lcol(gs10)) ///
			legend(off) ///
			fxsize(80) ///
			title("4A. With interaction") ///
			saving(figa4acombine, replace)
restore


quietly xtlogit deserted conscript hasaff ///
	conrate_mc sh_std unionpol_mc ///
	i.tenure
estimates store moda8
estimates restore moda8
preserve
drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi a using sim , replace
gen x_b_controls = 	///
	b1*1 +			///CONSCRIPT=1
	b2*0 +			///HASAFF=0
	b5*0 +			///AFFPOL=0 (I.E. MEAN)
	b6*0 +			///TENURE =0
	b7*0 +			///TENURE =0
	b8*0 +			///TENURE =0
	b9*0 +			///TENURE =0
	b10*1 +			///CONSTANT
	b11*0			// VARIANCE IN CONSTANTS

	

forvalues a= -.4995585(.025).5004415{				//lets conscription rate vary across its range
	gen x_betahat0 = b3*(`a')			///
		+ b4 * -.8185877 				/// sh_std = 25th percentile
		+ x_b_controls
	gen x_betahat1 = b3*(`a')			///
		+ b4 * 1.14244 				///sh_std = 75th percentile
		+ x_b_controls
	gen prob0 = exp(x_betahat0) / (1+ exp(x_betahat0))
	gen prob1 = exp(x_betahat1) / (1+ exp(x_betahat1))
	gen diff=prob1-prob0
	egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
	_pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`diff_hat') (`diff_lo') (`diff_hi') (`a')
	drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat

}
postclose mypost

use sim, clear
gen N = _n-1
gen conspct = N/40*100

twoway (line diff_hat conspct, clwidth(medium) clcolor(black)) ///
       (line diff_lo  conspct, clpattern(dash) clwidth(thin) clcolor(black)) ///
       (line diff_hi  conspct, clpattern(dash) clwidth(thin) clcolor(black)), ///
			xtitle("% Conscripts")	///
			yline(0, lcol(gs10)) ///
			legend(off) ///
			fxsize(80) ///
			title("4B. Without interaction") ///
			saving(figa4bcombine, replace)
restore

graph combine figa4acombine.gph figa4bcombine.gph, ycommon xsize(7) imargin(tiny) iscale(1) ///
	saving(figa4, replace)
graph export "Figure A4.tif", replace
