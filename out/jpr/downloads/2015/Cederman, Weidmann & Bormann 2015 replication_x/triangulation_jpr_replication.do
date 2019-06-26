// Lars-Erik Cederman, Nils B Weidmann & Nils-Christian Bormann
// Triangulating Horizontal Inequality: Toward Improved Conflict Analysis
// Journal of Peace Research
// Replication File

********************************************************************************
clear
clear matrix
set mem 1000m
version 13
/* Set your working directory */
//capture cd ""



********************************************************************************
// Data
use jpr_triangulation_repdata.dta

// Variables
label variable onset_do_flag "Onset"
label variable low1_nh "Low (G-Econ)"
label variable high1_nh "High (G-Econ)"
label variable low1_nl "Low (nightlights)"
label variable high1_nl "High (nightlights)"
label variable low1_spatial_5050 "Low (50/50 mix)"
label variable high1_spatial_5050 "High (50/50 mix)"
label variable low1_spatial "Low (nuanced mix)"
label variable high1_spatial "High (nuanced mix)"
label variable low1_huber "Low (surveys)"
label variable high1_huber "High (surveys)"
label variable low1_5050 "Low (average spatial/surveys)"
label variable high1_5050 "High (average spatial/surveys)"
label variable low1_nhnl "Low (spatial only, nuanced mix)"
label variable high1_nhnl "High (spatial only, nuanced mix)"
label variable low1 "Low(surveys/nuanced spatial mix 1)"
label variable high1 "High (surveys/nuanced spatial mix 1))"
label variable low2 "Low(surveys/nuanced spatial mix 2)"
label variable high2 "High (surveys/nuanced spatial mix 2)"
label variable low3 "Low(surveys/nuanced spatial mix 3)"
label variable high3 "High (surveys/nuanced spatial mix 3)"
label variable low1_area "Low (area-weighted average spatial/surveys)"
label variable high1_area "High (area-weighted average spatial/surveys)"
label variable low1_overlap "Low (overlap-weighted average spatial/surveys)"
label variable high1_overlap "High (overlap-weighted average spatial/surveys)"
label variable excluded "Excluded"
label variable family_downgraded2 "Downgraded"
label variable b "Relative group size"
label variable b2 "Relative group size$^2$"
label variable family_warhist "Postwar"
label variable ln_rgdppc_lag "GDP (log, t-1)"
label variable ln_pop "Population (log)"
label variable c_incidence_flagl "Ongoing conflict"
label variable pys_family "Peace years"
label variable inc_spline1 "spline1"
label variable inc_spline2 "spline2"
label variable inc_spline3 "spline3"
label variable urban "Urban settlements"
label variable nb_eth_incidence_flag "Neighb. Ethnic Conflict"
label variable nb_all_incidence_flag "Neighb. Conflict"
label variable lamerica "Lat. America"
label variable eeurop "East. Europe"
label variable ssafrica "Sub-Saharan Africa"
label variable nafrme "Middle East"
label variable asia "Asia"

********************************************************************************
// Analysis Main Paper

** Table I
sort cncat
by cncat: sum lineq_nl if year==1992
by cncat: sum lineq_nh if year==1992


** Table II
sort cowgroupid year
// Model 1: Nordhaus only
logit onset_do_flag low1_nh high1_nh excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant==1 & status_monop==0 & status_dominant==0 & year>1990 & pop500k==1, ///
		nolog cluster(cowcode)

// Model 2: Nightlights only
logit onset_do_flag low1_nl high1_nl excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant==1 & status_monop==0 & status_dominant==0 & year>1990 & pop500k==1, ///
		nolog cluster(cowcode)

// Model 3: Nordhaus - Nightlights (50-50)
logit onset_do_flag low1_spatial_5050 high1_spatial_5050 excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant==1 & status_monop==0 & status_dominant==0 & year>1990 & pop500k==1, ///
		nolog cluster(cowcode)

// Model 4: Spatial only (nuanced mix)
logit onset_do_flag low1_nhnl high1_nhnl excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant==1 & status_monop==0 & status_dominant==0 & year>1990, ///
		nolog cluster(cowcode)

** Table III
// Model 4: Spatial only (nuanced mix)
logit onset_do_flag low1_nhnl high1_nhnl excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant==1 & status_monop==0 & status_dominant==0 & year>1990, ///
		nolog cluster(cowcode)

// Model 5: Survey only
logit onset_do_flag low1_huber high1_huber excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & year>1990, ///
		nolog cluster(cowcode)

// Model 6: Mix 50-50%
logit onset_do_flag low1_5050 high1_5050 excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & year>1990, ///
		nolog cluster(cowcode)

// Model 7: Mix (Nordhaus quality categories: 90, 80, 50, 20, 10)
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 b ///
		family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop pys_family inc_spline* ///
		if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & year>1990, ///
		nolog cluster(cowcode)


** Figure 3
quietly margins, at(low1_overlap=(1(0.5)6))
marginsplot, recastci(rarea) title("P(Conflict) for poorer groups") ///
		ytitle("P(Conflict)") scheme(s2mono) yscale(range(0 0.04))

quietly margins, at(high1_overlap=(1(0.5)5))
marginsplot, recastci(rarea) title("P(Conflict) for richer groups") /// 
		ytitle("P(Conflict)") scheme(s2mono) yscale(range(0 0.06))


********************************************************************************
// Analysis Online Appendix

** Table A-IV
// Model A1: only groups with urban settlements
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
					b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop /// 
					pys_family inc_spline* ///
					if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990 & urban == 1, nolog cluster(cowcode)

// Model A2: only groups without urban settlements
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
					b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop /// 
					pys_family inc_spline* ///
					if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990 & urban == 0, nolog cluster(cowcode)
					
** Table A-V
// Model A3: neighboring ethnic civil war incidence
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
					b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop /// 
					pys_family inc_spline* nb_eth_incidence_flag ///
					if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990, nolog cluster(cowcode)

// Model A4: neighboring all civil war incidence
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
					b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop /// 
					pys_family inc_spline* nb_all_incidence_flag ///
					if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990, nolog cluster(cowcode)

// Model A5: regional dummies
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
					b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop /// 
					pys_family inc_spline* lamerica eeurop ssafrica nafrme asia ///
					if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990, nolog cluster(cowcode)

** Table A-VI
//Model A6: multinomial logit
mlogit onset_do_mlog_flag low1_overlap high1_overlap excluded family_downgraded2 ///
				b b2 family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop ///
				pys_family inc_spline* /// 
				if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
				year>1990, nolog cluster(cowcode)


** Table A-VII
// Test for extreme values
* richer groups
list countryname group cowgroupid low1_overlap high1_overlap ///
	if onset_do_flag == 1 & high1_overlap > 2.9 & low1_overlap!=. & high1_overlap!=.

* poorer groups
list countryname group cowgroupid low1_overlap high1_overlap ///
	if onset_do_flag == 1 & low1_overlap > 3.5 & low1_overlap!=. & high1_overlap!=.
	

// Model A7: Drop Chechens and Ijaw from Nigeria
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
				b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop ///
				pys_family inc_spline* ///
				if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990 & cowgroupid!=36516000 & cowgroupid!=47503000, ///
				nolog cluster(cowcode)

// Model A8: Drop Bakongo from Angola
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
				b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop ///
				pys_family inc_spline* ///
				if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990 & cowgroupid!=54001000, nolog cluster(cowcode)

// Model A9: Spatial models with overlapping settlement groups
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
				b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop  ///
				pys_family inc_spline* ///
				if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990 & overlap<0.01, nolog cluster(cowcode)
					
// Model A10: Spatial models without overlapping settlement groups (small overlap allowed)
logit onset_do_flag low1_overlap high1_overlap excluded family_downgraded2 ///
				b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop  ///
				pys_family inc_spline* ///
				if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990 & overlap>=0.01, nolog cluster(cowcode)


** Table A-VIII				
// Model A11: Spatial mix 2 - standard (.166, .334, .5, .667, .834) w/ surveys
logit onset_do_flag low2 high2 excluded family_downgraded2 ///
			  b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop  ///
			  pys_family inc_spline* ///
			  if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990, nolog cluster(cowcode)
					
// Model A12: Spatial mix 3 (.2, .4, .5, .6, .8) w/ surveys 
logit onset_do_flag low3 high3 excluded family_downgraded2 ///
			  b family_warhist c_incidence_flagl ln_rgdppc_lag ln_pop  ///
			  pys_family inc_spline* ///
			  if isrelevant==1 & status_monop==0 & status_dominant==0 & ///
					year>1990, nolog cluster(cowcode)					

** Table A-IX			
// Model A13: interaction effects
logit onset_do_flag c.low1_overlap##excluded c.high1_overlap##excluded ///
			family_downgraded2 b b2 family_warhist c_incidence_flagl ///
			ln_rgdppc_lag ln_pop pys_family inc_spline* ///
			if isrelevant==1 & status_monop==0 & status_dominant==0 & year>1990, ///
			nolog cluster(cowcode)

** Figure A-4: Plotting interaction
quietly margins if excluded==1, dydx(low1_overlap) at(low1_overlap=(1(0.5)5))
marginsplot, title("P(Conflict) for poorer excluded groups") ytitle("P(Conflict)") ///
	recastci(rarea) scheme(s2mono)   

quietly margins if excluded==0, dydx(low1_overlap) at(low1_overlap=(1(0.5)5))
marginsplot, title("P(Conflict) for poorer included groups") ytitle("P(Conflict)") ///
	recastci(rarea) scheme(s2mono) yscale(range(-0.02 0.08)) ylabel(-.02 0 0.02 0.04 .06 .08)
			
// Model A14: Static analysis				
gen onset_dummy = onset_do_flag
replace onset_dummy = 0 if onset_dummy == .

bys cowgroupid: egen onset1991=max(onset_dummy) if year>=1991
logit onset1991 low1_overlap high1_overlap excluded b family_warhist ///
					ln_rgdppc_lag ln_pop if isrelevant==1 & status_monop==0 & ///
						status_dominant==0 & year==1991, nolog cluster(cowcode)


