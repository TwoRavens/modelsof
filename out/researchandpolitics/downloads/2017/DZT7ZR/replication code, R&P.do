use "/*pathway*/replication data, R&P.dta"



********
*Define sample
********
reg polit_soph b1.voteprob_if_no_fine_AU time_on_camp_min totallinks polls_treatment 
gen samp = 1 if e(sample)

********
*Set Version
********
version 13.1


************************************************
************************************************
************************************************
************************************************
************************************************
*FIGURE 2
************************************************
************************************************
************************************************
************************************************
************************************************
*first, generate variables to use in area plots
kdensity time_on_camp_min if samp == 1, bw(.6) gen(x_values_time_on_camp_min density_values_time_on_camp_min)
kdensity totallinks if samp == 1, bw(1.3) gen(x_values_totallinks density_values_totallinks)

*then make density plots
twoway ///
	(area density_values_time_on_camp_min x_values_time_on_camp_min if samp == 1, fcolor(gs7*.9)  fintensity(100) lcolor(gs7*.9) lwidth(medthick)) ///
	, scheme(s1mono)  ///
	xtitle("Number of Minutes Spent Gathering Information") ///
	ytitle("Density") ylabel(0(.1).4) yscale(range(0 .4)) ///
	name(time_on_camp_min_density, replace)
	
twoway ///
	(area density_values_totallinks x_values_totallinks if samp == 1, fcolor(gs7*.9)  fintensity(100) lcolor(gs7*.9) lwidth(medthick)) ///
	, scheme(s1mono)  ///
	xtitle("Number of Information Links Accessed") ///
	ytitle("Density") ylabel(0(.1).4) yscale(range(0 .4)) ///
	name(totallinks_density, replace)
	
graph combine time_on_camp_min_density totallinks_density ///
		, 	rows(1) iscale(1.1) scale(1) xsize(8)  ///
			graphregion(margin(zero)) scheme(s1color)  
			
drop x_values* density_values*

	

************************************************
************************************************
************************************************
************************************************
************************************************
*Is Assignment to Treatment Groups Predicted by Covariates?
************************************************
************************************************
************************************************
************************************************
************************************************


logit polls_treatment polit_soph b1.voteprob_if_no_fine_AU age education female income if samp==1


	
************************************************
************************************************
************************************************
************************************************
************************************************
*FIGURES 3 AND 4
************************************************
************************************************
************************************************
************************************************
************************************************


********
*Time Spent on Campaign
********
reg time_on_camp_min b1.voteprob_if_no_fine_AU if samp == 1
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans post
estimates store time_on_camp_min_no_soph
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Minutes Spent Gathering Information" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(black) msize(large) xlabel(-1.5(.5).5)   ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(11) scale(1.5) ///
	name(time_on_camp_min_no_soph, replace) title("Without Control for Political Sophistication")


	
********
*Number of Links Accessed 
********
*create exposure variable, as those in the treatment groups saw 21 links and those in the control saw 20
gen exposure = .
replace exposure = 20 if polls_treatment == 0
replace exposure = 21 if polls_treatment == 1

nbreg totallinks b1.voteprob_if_no_fine_AU if samp == 1, exposure(exposure)
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans predict(n) post
estimates store totallinks_no_soph
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Information Links Accessed" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(black) msize(large) xlabel(-4(1)1)   ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(11) scale(1.5) ///
	name(totallinks_no_soph, replace)  title("Without Control for Political Sophistication")
 
drop exposure

			

********
*Time Spent on Campaign, With Control for Political Sophistication
********
reg time_on_camp_min b1.voteprob_if_no_fine_AU polit_soph if samp == 1
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans post
estimates store time_on_camp_min_with_soph
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Minutes Spent Gathering Information" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(gs7) msize(large) xlabel(-1.5(.5).5)    ///
	ciopts(lpattern(solid) lcolor(gs7*.9)) xsize(11) scale(1.5) ///
	name(time_on_camp_min_with_soph, replace)  title("With Control for Political Sophistication")


	
********
*Number of Links Accessed, With Control for Political Sophistication 
********
*create exposure variable, as those in the treatment groups saw 21 links and those in the control saw 20
gen exposure = .
replace exposure = 20 if polls_treatment == 0
replace exposure = 21 if polls_treatment == 1


nbreg totallinks b1.voteprob_if_no_fine_AU polit_soph if samp == 1, exposure(exposure)
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans predict(n) post
estimates store totallinks_with_soph
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Information Links Accessed" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(gs7) msize(large) xlabel(-4(1)1)    ///
	ciopts(lpattern(solid) lcolor(gs7*.9)) xsize(11) scale(1.5) ///
	name(totallinks_with_soph, replace)  title("With Control for Political Sophistication")
 
drop exposure



********
*FIGURE 3: Time Spent on Campaign
********
graph combine time_on_camp_min_no_soph time_on_camp_min_with_soph ///
		, 	rows(2) iscale(.65) scale(1) xsize(7) ///
			graphregion(margin(zero)) scheme(s1color)  xcommon 	

********
*FIGURE 4: Number of Links Accessed
********
graph combine totallinks_no_soph totallinks_with_soph ///
		, 	rows(2) iscale(.65) scale(1) xsize(7) ///
			graphregion(margin(zero)) scheme(s1color)  xcommon 	
			
		
		


		
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
*SUPPLEMENTAL MATERIAL
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************
************************************************************************************************

		
	
********
*FIGURE A.1: Differences in Political Sophistication According to Voter Compulsion
********
reg polit_soph b1.voteprob_if_no_fine_AU if samp == 1
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans post
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Political Sophistication" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(black) msize(large)    ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(13) scale(1.5) 
	
********
*Figure A.2: Differences in Satisfaction with Democracy According to Voter Compulsion
********
logit sat_dich b1.voteprob_if_no_fine_AU if samp == 1
margins, dydx(voteprob_if_no_fine_AU) predict(p) level(90) atmeans post
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Pr(Fairly or Very Satisfied with Democracy)" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(black) msize(large)    ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(13) scale(1.5) 


********
*Figure A.3: Previous Vote Choice According to Voter Compulsion
********
mlogit vote_choice_AU_prev_elec b1.voteprob_if_no_fine_AU if samp==1, base(3)
margins, dydx(voteprob_if_no_fine_AU) level(90) predict(pr outcome(1)) atmeans post
estimates store Green

mlogit vote_choice_AU_prev_elec b1.voteprob_if_no_fine_AU if samp==1, base(3)
margins, dydx(voteprob_if_no_fine_AU) level(90) predict(pr outcome(2)) atmeans post
estimates store Labor

mlogit vote_choice_AU_prev_elec b1.voteprob_if_no_fine_AU if samp==1, base(3)
margins, dydx(voteprob_if_no_fine_AU) level(90) predict(pr outcome(3)) atmeans post
estimates store Liberal

mlogit vote_choice_AU_prev_elec b1.voteprob_if_no_fine_AU if samp==1, base(3)
margins, dydx(voteprob_if_no_fine_AU) level(90) predict(pr outcome(4)) atmeans post
estimates store National

mlogit vote_choice_AU_prev_elec b1.voteprob_if_no_fine_AU if samp==1, base(3)
margins, dydx(voteprob_if_no_fine_AU) level(90) predict(pr outcome(5)) atmeans post
estimates store Other

mlogit vote_choice_AU_prev_elec b1.voteprob_if_no_fine_AU if samp==1, base(3)
margins, dydx(voteprob_if_no_fine_AU) level(90) predict(pr outcome(98)) atmeans post
estimates store Abstained

	
coefplot ///
	(Green, mcolor(green) ciopts(lcolor(green*.9))) ///
	,	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
		grid(glcolor(gray*.2) glpattern(dash)) ///
		xtitle("Difference in Pr(Voted for Green Party)" "Relative to Voluntary Voters") level(90)	///
		recast(scatter) mcolor(black) msize(medium) title("Green Party")  xsize(11) scale(1.5)  ///
		name(Green, replace)
			
coefplot ///
	(Labor, mcolor(red) ciopts(lcolor(red*.9))) ///
	,	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
		grid(glcolor(gray*.2) glpattern(dash)) ///
		xtitle("Difference in Pr(Voted for Labor Party)" "Relative to Voluntary Voters") level(90)	///
		recast(scatter) mcolor(black) msize(medium)    title("Labor Party")   xsize(11) scale(1.5) ///
		name(Labor, replace)
			
coefplot ///
	(Liberal, mcolor(blue) ciopts(lcolor(blue*.9))) ///
	,	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
		grid(glcolor(gray*.2) glpattern(dash)) ///
		xtitle("Difference in Pr(Voted for Liberal Party)" "Relative to Voluntary Voters") level(90)	///
		recast(scatter) mcolor(black) msize(medium)   title("Liberal Party")  xsize(11) scale(1.5)  ///
		name(Liberal, replace)
			
coefplot ///
	(National, mcolor(yellow*1.5) ciopts(lcolor(yellow*1.35))) ///
	,	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
		grid(glcolor(gray*.2) glpattern(dash)) ///
		xtitle("Difference in Pr(Voted for National Party)" "Relative to Voluntary Voters") level(90)	///
		recast(scatter) mcolor(black) msize(medium)    title("National Party")  xsize(11) scale(1.5)  ///
		name(National, replace)
		
coefplot ///
	(Other, mcolor(black) ciopts(lcolor(black*.9))) ///
	,	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
		grid(glcolor(gray*.2) glpattern(dash)) ///
		xtitle("Difference in Pr(Voted for Others)" "Relative to Voluntary Voters") level(90)	///
		recast(scatter) mcolor(black) msize(medium)   title("Others")  xsize(11) scale(1.5)  ///
		name(Other, replace)
		
coefplot ///
	(Abstained, mcolor(pink) ciopts(lcolor(pink*.9))) ///
	,	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
		grid(glcolor(gray*.2) glpattern(dash)) ///
		xtitle("Difference in Pr(Abstained)" "Relative to Voluntary Voters") level(90)	///
		recast(scatter) mcolor(black) msize(medium)   title("Abstained")  xsize(11) scale(1.5)  ///
		name(Abstained, replace)


graph combine Green Labor Liberal National Other Abstained ///
		, 	rows(3) iscale(.55) scale(1)	xsize(10) ///
			graphregion(margin(zero)) scheme(s1color)  xcommon 	



********
*FIGURE B.1: Time Spent on Campaign, IPW
********			
teffects ipw (time_on_camp_min) (voteprob_if_no_fine_AU age education female income polit_soph i.satdemoc i.vote_choice_AU_prev_elec, mlogit) if samp == 1, aequations atet level(90)
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("ATET on Number of Minutes Spent Gathering Information" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(red) msize(large) xlabel(-1.5(.5).5)    ///
	ciopts(lpattern(solid) lcolor(red*.5)) xsize(11) scale(1.5) ///
	coeflabels(  ///
	r2vs1.voteprob_if_no_fine_AU = "Slightly Compelled Voters"  ///
	r3vs1.voteprob_if_no_fine_AU = "Moderately Compelled Voters"  ///
	r4vs1.voteprob_if_no_fine_AU = "Strongly Compelled Voters"  ///
	) 

********
*FIGURE B.2: Number of Links Accessed, IPW
********
*ipwra used to execute ipw, as it allows for the Poisson link and a control for the election simulation to which one was subject (to proxy exposure) 
teffects ipwra (totallinks i.electionnum, poisson) (voteprob_if_no_fine_AU age education female income polit_soph i.satdemoc i.vote_choice_AU_prev_elec, mlogit) if samp == 1, aequations atet level(90)
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("ATET on Number of Information Links Accessed" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(red) msize(large) xlabel(-4(1)1)    ///
	ciopts(lpattern(solid) lcolor(red*.5)) xsize(11) scale(1.5) ///
	coeflabels(  ///
	r2vs1.voteprob_if_no_fine_AU = "Slightly Compelled Voters"  ///
	r3vs1.voteprob_if_no_fine_AU = "Moderately Compelled Voters"  ///
	r4vs1.voteprob_if_no_fine_AU = "Strongly Compelled Voters"  ///
	) 	
	


************************************************
*FIGURES C.2 AND C.3
************************************************


gen C = "C" //*Generate variables that serve as marker labels
gen T = "T"

********
*FIGURE C.2: Time Spent on Campaign
********
reg time_on_camp_min b1.voteprob_if_no_fine_AU##i.polls_treatment  if samp == 1 
margins, dydx(voteprob_if_no_fine_AU) level(90) at(polls_treatment = (0)) atmeans post
estimates store control
reg time_on_camp_min b1.voteprob_if_no_fine_AU##i.polls_treatment  if samp == 1 
margins, dydx(voteprob_if_no_fine_AU) level(90) at(polls_treatment = (1)) atmeans post
estimates store treatment
coefplot 	(control, mlabcolor(black) mlabel(C) mlabsize(tiny) mlabcolor(white) msymbol(circle) msize(vlarge)  mlabposition(0) mcolor(black) ciopts(lcolor(black*.9))) ///
			(treatment, mlabcolor(black) mlabel(T) mlabsize(tiny) msymbol(circle) msize(vlarge) mfcolor(white) mlabposition(0) mcolor(black) ciopts(lcolor(black*.9))) ///
	, scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Minutes Spent Gathering Information" "Relative to Voluntary Voters") level(90)	///
	recast(scatter)    ///
	legend(order(2 "Control Group: No Polls" 4 "Treatment Group: Polls") rows(2) size(medsmall)) ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(11) scale(1.5) 

	
********
*FIGURE C.3: Number of Links Accessed 
********
*create exposure variable, as those in the treatment groups saw 21 links and those in the control saw 20
gen exposure = .
replace exposure = 20 if polls_treatment == 0
replace exposure = 21 if polls_treatment == 1


nbreg totallinks b1.voteprob_if_no_fine_AU##i.polls_treatment  if samp == 1 , exposure(exposure)
margins, dydx(voteprob_if_no_fine_AU) level(90)  at(polls_treatment = (0)) atmeans predict(n) post
estimates store control
nbreg totallinks b1.voteprob_if_no_fine_AU##i.polls_treatment  if samp == 1 , exposure(exposure)
margins, dydx(voteprob_if_no_fine_AU) level(90)  at(polls_treatment = (1)) atmeans predict(n) post
estimates store treatment
coefplot 	(control, mlabcolor(black) mlabel(C) mlabsize(tiny) mlabcolor(white) msymbol(circle) msize(vlarge)  mlabposition(0) mcolor(black) ciopts(lcolor(black*.9))) ///
			(treatment, mlabcolor(black) mlabel(T) mlabsize(tiny) msymbol(circle) msize(vlarge) mfcolor(white) mlabposition(0) mcolor(black) ciopts(lcolor(black*.9))) ///
	, scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Information Links Accessed" "Relative to Voluntary Voters") level(90)	///
	recast(scatter)   ///
	legend(order(2 "Control Group: No Polls" 4 "Treatment Group: Polls") rows(2) size(medsmall)) ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(11) scale(1.5) 
	

drop exposure

drop C T


********
*Figure D.1: Time Spent Gathering Political Information and Voter Compulsion, Poisson Regression
********
*Without Sophistication
poisson time_on_camp_min b1.voteprob_if_no_fine_AU if samp == 1, robust
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans post
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Minutes Spent Gathering Information" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(black) msize(large) xlabel(-1.5(.5).5)   ///
	ciopts(lpattern(solid) lcolor(black*.9)) xsize(11) scale(1.5) ///
	name(pois_time_on_camp_min_no_soph, replace) title("Without Control for Political Sophistication")

*With Sophistication
poisson time_on_camp_min b1.voteprob_if_no_fine_AU polit_soph if samp == 1, robust
margins, dydx(voteprob_if_no_fine_AU) level(90) atmeans post
coefplot,  ///
	scheme(s1color) xline(0, lpattern(dash) lcolor(black*.5)) ///
	grid(glcolor(gray*.2) glpattern(dash)) ///
	xtitle("Difference in Expected Number of Minutes Spent Gathering Information" "Relative to Voluntary Voters") level(90)	///
	recast(scatter) mcolor(gs7) msize(large) xlabel(-1.5(.5).5)    ///
	ciopts(lpattern(solid) lcolor(gs7*.9)) xsize(11) scale(1.5) ///
	name(pois_time_on_camp_min_with_soph, replace)  title("With Control for Political Sophistication")

*Combine Graphs With and Without Control for Sophistication

graph combine pois_time_on_camp_min_no_soph pois_time_on_camp_min_with_soph ///
		, 	rows(2) iscale(.65) scale(1) xsize(7) ///
			graphregion(margin(zero)) scheme(s1color)  xcommon 
			
			
			
********			
*Table E.1: Time Spent Gathering Political Information and Voter Compulsion			
********			
reg time_on_camp_min b1.voteprob_if_no_fine_AU if samp == 1 //*Model 1
reg time_on_camp_min b1.voteprob_if_no_fine_AU polit_soph if samp == 1  //*Model 2
			
			
********			
*Table E.2: The Amount of Political Information Gathered and Voter Compulsion
********	
gen exposure = .
replace exposure = 20 if polls_treatment == 0
replace exposure = 21 if polls_treatment == 1

nbreg totallinks b1.voteprob_if_no_fine_AU if samp == 1, exposure(exposure) //*Model 1
nbreg totallinks b1.voteprob_if_no_fine_AU polit_soph if samp == 1, exposure(exposure) //*Model 2


drop exposure
