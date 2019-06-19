clear 
set memory 300m 
set more off
/* cd "E:\occdist\reg_gender"  */
cd "C:\Users\kp\Documents\thesis_topic occdist\reg_gender" 

foreach xobs in 100 200 {

foreach sx in M F {
clear
foreach yr in  00 90 80 {
clear
log using "Feb_2011_Revisions\log_wage\IV_`sx'_wg_3clust_omb_obs`xobs'_`yr'.log", replace  
use `sx'_census`yr'_imm.dta 
keep if metpop_country>= `xobs'
drop metpop_imm metpop_imm_wt metpop_total_wt p_imm p_imm_wt  metpop_country_wt p_metpop_imm_wt p_metpop_imm p_metpop_total_wt p_metpop_total metoccpop_imm metoccpop_imm_wt metoccpop_total_wt metoccpop_total p_country_imm_occmet_wt p_country_total_occmet_wt p_country_imm_occmet imm_old5_met_wt imm_old5_met country_old5_met_wt country_old5_met old5_wt old5 p_old5_occmet_wt p_old5_occmet imm_old5_occmet_wt imm_old5_occmet p_immold5_occmet_wt p_immold5_occmet p_occ_old_imm_met_wt p_occ_old_imm_met cntry_wt cntry p_occ_imm_met_wt p_occ_imm_met metoccpop_nat metoccpop_nat_wt 

set matsize 500 

table  imm_new5 
table  bpl imm_new5, row col 

keep if imm_new5==1 
sort occ1990 pwmetro bpl 
merge occ1990 pwmetro bpl using `sx'_census`yr'_rank_edu.dta 
drop if _merge==2 
drop _merge 


generate occpop1=0 if rank_oldimm_occ<100000 
replace occpop1=1 if rank_oldimm_occ==1 
generate occpop2=0 if rank_oldimm_occ<100000 
replace occpop2=1 if rank_oldimm_occ==1|rank_oldimm_occ==2 
generate occpop3=0 if rank_oldimm_occ<100000 
replace occpop3=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3 
generate occpop4=0 if rank_oldimm_occ<100000 
replace occpop4=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4 
generate occpop5=0 if rank_oldimm_occ<100000 
replace occpop5=1 if rank_oldimm_occ==1|rank_oldimm_occ==2|rank_oldimm_occ==3|rank_oldimm_occ==4|rank_oldimm_occ==5 

generate occpop1_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop1_wt=1 if rank_oldimm_occ_wt==1 
generate occpop2_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop2_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2 
generate occpop3_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop3_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3 
generate occpop4_wt=0 if rank_oldimm_occ_wt<100000 
replace occpop4_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4
generate occpop5_wt=0 if rank_oldimm_occ_wt<100000
replace occpop5_wt=1 if rank_oldimm_occ_wt==1|rank_oldimm_occ_wt==2|rank_oldimm_occ_wt==3|rank_oldimm_occ_wt==4|rank_oldimm_occ_wt==5

table rank_oldimm_occ if rank_oldimm_occ<=5  & rank_oldimm_occ>=1, contents( freq mean p_occ_old_countrymet )

table occpop1, contents( freq mean p_occ_old_countrymet )
table occpop2, contents( freq mean p_occ_old_countrymet )
table occpop3, contents( freq mean p_occ_old_countrymet )
table occpop4, contents( freq mean p_occ_old_countrymet )
table occpop5, contents( freq mean p_occ_old_countrymet )

summarize p_occ_old_countrymet

generate age2=age^2
generate english=1 if  speakeng==2|speakeng==3|speakeng==4|speakeng==5
replace english=0 if speakeng==1|speakeng==6

if `yr'==80 {
generate edu=1 if educrec>=0 & educrec<=6
replace edu=2 if educrec==7
replace edu=3 if educrec==8
replace edu=5 if educrec==9
}
else {
generate edu=1 if educ99>=0 & educ99<=9
replace edu=2 if educ99==10
replace edu=3 if educ99==11
replace edu=4 if educ99==12| educ99==13
replace edu=5 if educ99==14
replace edu=6 if educ99==15| educ99==16| educ99==17
}

label define edu 1 "no diploma" 2 "High School" 3 "Some College" 4 "Associates Degree" 5 "College" 6 "Graduate Degree"
label values edu edu

generate cntry_met = metpop_country / metpop_total 

/* merge in iv variables*/
if `yr'==00 {
local ivyr "90"
}
if `yr'==90 {
local ivyr "80"
}
if `yr'==80 {
local ivyr "70"
}

sort occ1990 pwmetro bpl
merge occ1990 pwmetro bpl using `sx'_census`ivyr'_occdist.dta
drop if _merge==2
drop _merge


tabulate edu, gen(edu)
tabulate marst, gen(marst)
generate male=0 if sex==2
replace male=1 if sex==1

generate wage_hr= (incwage/ wkswork1)/ uhrswork 
generate wage_wk=wage_hr*uhrswork 
generate ft=0 if uhrswork>0 & uhrswork<35 
replace ft=1 if uhrswork>=35 & uhrswork<1000000 

xtile ptilewage1000_hr= wage_hr, nq(1000) 
drop if ptilewage1000_hr==1000 
drop if ptilewage1000_hr==1 
xtile ptilewage1000_wk= wage_wk, nq(1000) 
drop if ptilewage1000_wk==1000 
drop if ptilewage1000_wk==1 

generate lnwage_hr= ln(wage_hr)
generate lnwage_wk= ln(wage_wk)


/*       x variables:           */
/*       p_occ_old_countrymet (% of old immigrants of e in that occ by met)  */
/*       p_native_occ (% of all old immigrants in that occ by met) */
/*       p_occ_met (% all natives in that occ by met)*/

gen str4 metrostring=string(pwmetro, "%04.0f")
gen str4 occstring=string( occ1990, "%03.0f")
gen str4 bplstring=string(bpl, "%03.0f")
generate clust_omb= metrostring+ occstring+ bplstring
destring ( clust_omb), replace

/*****************  IV ******************/
if `yr'==80 {
local controls "age age2 english edu2 edu3 edu4 mean_occ_edu marst2 marst3 marst4 marst5 marst6"
}
else {
local controls "age age2 english edu2 edu3 edu4 edu5 edu6 mean_occ_edu marst2 marst3 marst4 marst5 marst6"
}
forvalues pop= 1(1)5 { 
	generate occpop=occpop`pop'
	generate occpop_distc=occpop`pop'*p_occ_old_countrymet 

	

	/* endogenous: occpop1  p_native_occ  p_occ_met  cntry_met */
	/* instruments: p_occ_countrymet90 p_native_occ90 p_occ_met90 cntry_met90 */

	display ""
	display ""
	display "for popular occuption: `pop'"
	display ""

	/** ln hour wage */
	xi:  ivclust lnwage_hr  `controls' i.bpl i.pwmetro i.region (occpop  p_native_occ p_occ_met cntry_met =  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwg_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwg_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/**ln hour wage interaction*/
	xi:  ivclust lnwage_hr  `controls' i.bpl i.pwmetro i.region (occpop_distc p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwgint_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwgint_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/** ln weekly wage */
	xi:  ivclust lnwage_wk  `controls' i.bpl i.pwmetro i.region (occpop p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwg_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwg_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/**ln weekly wage interaction*/
	xi:  ivclust lnwage_wk  `controls' i.bpl i.pwmetro i.region (occpop_distc p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwgint_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwgint_obs`xobs'_3clust_omb.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}	


	/*============== no mex ==============*/
	display ""
	display "Excluding Mexicans, for popular occuption: `pop'"
	display ""
	display ""

	xi:  ivclust lnwage_hr  `controls' i.bpl i.pwmetro i.region (occpop p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  if bpl!=200 , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwg_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwg_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/**ln hour wage interaction*/
	xi:  ivclust lnwage_hr  `controls' i.bpl i.pwmetro i.region (occpop_distc p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  if bpl!=200  , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwgint_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_hrwgint_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/** ln weekly wage */
	xi:  ivclust lnwage_wk  `controls' i.bpl i.pwmetro i.region (occpop p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  if bpl!=200 , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwg_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwg_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}
	/**ln weekly wage interaction*/
	xi:  ivclust lnwage_wk  `controls' i.bpl i.pwmetro i.region (occpop_distc p_native_occ p_occ_met cntry_met=  p_occ_countrymet`ivyr' p_native_occ`ivyr' p_occ_met`ivyr' cntry_met_`ivyr')  if bpl!=200 , clst(pwmetro occ1990 bpl)
	if `pop'==1 & `yr'==00 {
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwgint_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket replace
	}
	else { 
	outreg occpop_distc p_native_occ p_occ_met cntry_met `controls' using "Feb_2011_Revisions\reg_wage_output\IV_`sx'_wkwgint_obs`xobs'_3clust_omb_nomex.xls", bdec(3) rdec(3) sigsymb(**,*,+) 10pct coefastr ctitle(occpop) bracket append
	}	


	drop occpop occpop_distc      
 	}  /*forvarlues pop */

log close

} /* foreach yr */
} /* foreach sx */
} /* foreach xobs */

