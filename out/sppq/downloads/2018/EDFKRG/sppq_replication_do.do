****** The following analyses were carried out using STATA 14.2 *******

*** Commands used to adjust campaign expenditure data and log all necessary ///
*** variables (all already defined in dataset) ***

gen cme_pc=cm_expend/population
gen cme2=cme_pc+.01
gen log_cme=log(cme2)

gen promote2=total_race_promote + .01
gen log_promote=log(promote2)

gen attack2=total_race_attack + .01
gen log_attack=log(attack2)

gen total_ads2=total_race_ads + .01
gen log_total_ads = log(total_ads2)

*** Figure 1 (left-hand panel) ***

graph bar (mean) rolloff, over(year_count)

*** Figure 1 (right-hand panel) ***

graph bar (mean) vote_percent, over(year_count)

*** Figure 2 (left-hand panel) ***

graph bar (mean) cm_expenditures, over(year_count)

*** Figure 2 (right-hand panel) ***

graph bar (mean) total_race_ads, over(year_count)

*** Table 1 ***

sum rolloff vote_percent log_cme log_total_ads log_attack log_promote ///
	opposition district midterm primary never professional y2010

*** Table 2, Model 1 ***

mixed rolloff opposition log_cme log_total district primary  ///
	never_retained midterm professional y2010 || court_id:	
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_cme=(-4.61(.1).9)) 
	margins, at(log_total_ads=(-4.61(.1).8))
	margins, at(opposition=(0(1)1))
	margins, at(midterm=(0(1)1))
	margins, at(y2010=(0(1)1))

*** Table 2, Model 2 ***

mixed rolloff opposition log_cme log_pro log_attack  district primary  ///
	never_retained midterm professional y2010 || court_id:	
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_attack=(-4.61(.1)-1.44))
	margins, at(y2010=(0(1)1))

*** Table 3, Model 1 ***

mixed vote_percent opposition log_cme log_total district primary ///
	never_retained midterm professional y2010 || court_id:
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_total_ads=(-4.61(.1).8))
	margins, at(opposition=(0(1)1))
	margins, at(midterm=(0(1)1))
	margins, at(y2010=(0(1)1))
	
*** Table 3, Model 2 ***

mixed vote_percent opposition log_cme log_attack log_promo district primary ///
	never_retained midterm professional y2010 || court_id:
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_cme=(-4.61(.1).9)) 
	margins, at(log_attack=(-4.61(.1)-1.44))
	margins, at(opposition=(0(1)1))
	margins, at(midterm=(0(1)1))
	margins, at(profession=(.39(.01).73))
	margins, at(y2010=(0(1)1))
	
*** Table 4, Model 1 ***

mixed vote_percent i.opposition##c.log_cme log_total district primary ///
	never_retained midterm professional y2010 || court_id:
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_cme=(-4.61(.1).9))
	margins opposition, at(log_cme=(0))
	margins opposition if opposition==1, at(log_cme=(-4.61(.1).9))
	margins, at(log_total_ads=(-4.61(.1).8))
	margins, at(midterm=(0(1)1))
	margins, at(y2010=(0(1)1))

*** Figure 3 ***

margins opposition, at(log_cme=(-4.6(4)11.4))
marginsplot

*** Table 4, Model 2 ***	
		
mixed vote_percent i.opposition##c.log_cme log_att log_pro district primary  ///
	never_retained midterm professional y2010 || court_id:	
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_cme=(-4.61(.1).9))
	margins opposition, at(log_cme=(0))
	margins, at(log_attack=(-4.61(.1)-1.44))
	margins, at(midterm=(0(1)1))
	margins, at(profession=(.39(.01).73))
	margins, at(y2010=(0(1)1))
	
*** Table A.2, Model 1 ***

mixed rolloff opposition log_cme log_total district primary  ///
	never_retained midterm professional y2010 if merit==1 || court_id:	
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_total_ads=(-4.61(.1).8))
	margins, at(midterm=(0(1)1))
	margins, at(y2010=(0(1)1))

*** Table A.2, Model 2 ***

mixed rolloff opposition log_cme log_pro log_attack  district primary  ///
	never_retained midterm professional y2010 if merit==1 || court_id:	
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_attack=(-4.61(.1)-1.44))
	margins, at(y2010=(0(1)1))

*** Table A.3, Model 1 ***

mixed vote_percent opposition log_cme log_total district primary ///
	never_retained midterm professional y2010 if merit==1 || court_id:
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
	
	margins, at(log_total_ads=(-4.61(.1).8))
	margins, at(opposition=(0(1)1))
	margins, at(midterm=(0(1)1))
	margins, at(profession=(.39(.01).73))
	margins, at(y2010=(0(1)1))

*** Table A.3, Model 2 ***
	
mixed vote_percent opposition log_cme log_attack log_promo district primary ///
	never_retained midterm professional y2010 if merit==1 || court_id:
	
	*Marginal Effects 
	*Take difference between first and last observation
	*Note that if one standard deviation less than an observation's mean is 
	*below a variable's minimum, its minimum is used instead. 
		
	margins, at(log_cme=(-4.61(.1).9))
	margins, at(log_attack=(-4.61(.1)-1.44))
	margins, at(opposition=(0(1)1))
	margins, at(midterm=(0(1)1))
	margins, at(profession=(.39(.01).73))
	margins, at(y2010=(0(1)1))
