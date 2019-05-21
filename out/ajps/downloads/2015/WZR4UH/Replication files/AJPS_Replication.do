*************************************************************************************
/*
replication file "Do better monitoring institutions increase leadership quality in community organizations? Evidence from Uganda"
American Journal of Political Science

Author: Guy Grossman
Date: August 12, 2013

*/

capture log close
clear all
set more off
macro drop _all
version 12.1

**********************************************************************************
cd "/Users/guy/Dropbox/Candidacy.selection/AJPS/3rd submission/Replication files"
use "dc_level.dta"

**********************************************************************************
**********************************************************************************
**********************************************************************************

* 1. Relationship between PG value and manager effort and ability (Figure 1)

**********************************************************************************
**********************************************************************************
**********************************************************************************

graph twoway (lfitci imbulk_a_memb effortA , clwidth(thick)) ///
             (scatter imbulk_a_memb effortA ) ///
             ,ylabel(, labsize(2.5)) ysca(r(0(.2)1) titlegap(2)) ylabel(0(.2)1) ///
              ytitle("Mean Share of Members' Coffee Sold in Bulk") xtitle("Manager Effort") ///
              legend(ring(0) pos(5) order(2 "linear fit" 1 "95% CI")) ///
              xlabel(, labsize(2.5)) xsca(r(-2(1)2)titlegap(2)) xlabel(-2(1)2) scheme(s1color) name(EFFORT)
              

graph twoway (lfitci imbulk_a_memb m_z_ability , clwidth(thick)) ///
             (scatter imbulk_a_memb m_z_ability ) ///
             ,ylabel(, labsize(2.5)) ysca(r(0(.2)1) titlegap(2)) ylabel(0(.2)1) ///
              ytitle("Mean Share of Members' Coffee Sold in Bulk") xtitle("Manager Ability") ///
              legend(ring(0) pos(5) order(2 "linear fit" 1 "95% CI")) ///
              xlabel(, labsize(2.5)) xsca(r(-2(.5)1.5)titlegap(2)) xlabel(-2(.5)1.5) scheme(s1color) name(ABILITY)

graph combine ABILITY EFFORT, ycommon title("Public Goods Value and Manager's Quality") altshrink scheme(lean1)

**********************************************************************************
**********************************************************************************
**********************************************************************************

* 2. Test of the Discipline Effect (Table 1)
* 	 Ho: Monitoring has a positive impact on manager's effort 

**********************************************************************************
**********************************************************************************
**********************************************************************************

* define controls
	global strata s2 s3 s4 s5
	global control c_nmembers50 c_agedc c_elf_memb vrule

*ssc inst estout
eststo clear
	eststo m1: xtmixed effortA z_monitoringA || strata:, 
	eststo m2: xtmixed effortA z_monitoringA $control || strata:, 
	eststo m3: xtmixed effortA c.z_monitoringA##c.z_nag_pio $control  || strata:, 
	eststo m4: xtmixed effortA c.z_monitoringA##c.z_nag_pio c.z_monitoringA##c.m_z_ability c.z_nag_pio##c.m_z_ability $control || strata:, 
	esttab m1 m2 m3 m4, b(2) se(2) star(* 0.1) 


**********************************************************************************
**********************************************************************************
**********************************************************************************

* 3. Test of the Self-selection Effect (Table 2)
* 	 Ho: interaction between Private Income Opportunities (PIO) and Monitoring is negative 

**********************************************************************************
**********************************************************************************
**********************************************************************************

* define controls for mean, max, min and SD of the entire pool of representatives
	global repsabil mean_reps_ability max_reps_ability min_reps_ability sd_reps_ability
 
eststo clear	
foreach var in dscq35c dscq35b sf222_mean monitoringA{
	eststo `var'1: xtmixed m_z_ability c.z_`var'##c.z_nag_pio n_reps $repsabil || strata:, 
	eststo `var'2: xtmixed m_z_ability c.z_`var'##c.z_nag_pio n_reps $repsabil $control  || strata:, 
esttab `var'*, b(2) se(2) star(* 0.1) 
}

**********************************************************************************
**********************************************************************************
**********************************************************************************

* 4. Change in members' wealth since joining group (Table 3)

**********************************************************************************
**********************************************************************************
**********************************************************************************
 center imbulk_a_memb isd03b_memb, standardize

gen effort_ability =m_z_ability*effortA

foreach var in c_imbulk_a_memb c_isd03b_memb{
	eststo `var'1: reg z_welfinc_memb `var' $control $strata, robust
	eststo `var'2: ivreg2 z_welfinc_memb (`var' = m_z_ability effortA effort_ability) $control $strata, first
	eststo `var'3: reg3 (z_welfinc_memb `var' $control $strata ) (`var' c.m_z_ability##c.effortA $control $strata) (effortA c.monitoringA##c.z_nag_pio $control $strata) (m_z_ability c.z_nag_pio##c.monitoringA $strata $control n_reps $repsabil)
	}

**********************************************************************************
**********************************************************************************
**********************************************************************************

* Kamuli and Mubende comparison

**********************************************************************************
**********************************************************************************
**********************************************************************************
foreach var in isd03b_memb isb01_memb isb06_memb isb31_memb z_edu_memb m_z_ability z_ability_reps effortA nag_pio monitoringA monitoringF monitoringA{
	tabstat `var', by(strata)
	reg `var' b2.strata
	margins i.strata
	ttest `var' if strata==2 | strata==5, by(strata) une
}


gen mubende=1 if strata==2
replace mubende=0 if strata==5
lab define mubende 0 "Kamuli" 1 "Mubende"
lab value mubende mubende
tab mubende

foreach var in m_z_ability z_ability_reps z_edu_memb z_nag_pio effortA monitoringA{
ttest `var', by(mubende) unequal
}



**********************************************************************************
**********************************************************************************
**********************************************************************************

* Balance test by monitoring institutions (SI, Table 1)

**********************************************************************************
**********************************************************************************
**********************************************************************************

* Define global for covariates balance
	global balance1 male_memb age_memb z_edu_memb z_wealth_memb church_memb local_memb isb01_memb isb04b_mem male_reps age_reps z_edu_reps z_wealth_reps church_reps local_reps isb01_reps isb04b_reps 
	global balance2 agedc dsbq8b dseq88 dseq95 vrule 
	global balance3 eduattain_scounty literacy_scounty fgt0 fgt1 gin populationdensity 

su $balance1 $balance2 $balance3

*1. Individual level differences 
eststo clear
foreach x in  monitoringA sf222_mean dscq35c dscq35b{
	local count = 1
	foreach y in $balance1 $balance2 $balance3{
		qui reg `y' `x', vce(cl strata)
		mat A = r(table)
		mat B`count' = (A[1,1] , A[4,1])
		local ++count
		}
	mat `x' = B1\B2\B3\B4\B5\B6\B7\B8\B9\B10\B11\B12\B13\B14\B15\B16\B17\B18\B19\B20\B21\B22\B23\B24\B25\B26\B27
	}
	
mat result = monitoringA, sf222_mean, dscq35c, dscq35b
mat rownames result = $balance1 $balance2 $balance3
mat colnames result = Index(b) Index(p) Monitor(b) Monitor(p) Audit(b) Audit(p) Finance(b) Finance(c)
mat list result

outtable using Candidacy.selection/Analysis/tables/balance1 , label format(%12.3f) mat(result) nobox center replace

mat drop _all


* APEP Field Trainer
bys dsbq9: gen IDbytrain=_n
table IDbytrain dsbq9, c(mean monitoringA)
scatter monitoringA dsbq9, msymbol(c) scheme(lean1) xlabel(1(1)9) title("Monitroing by Field Trainer")

* between versus within field trainer variation in monitoring // between variation is two times larger than within variation
xtset dsbq9
xtreg monitoringA, mle

* field trainer and finance committee
table dsbq9 dscq35b

cd "/Users/guy/Dropbox/Candidacy.selection/Analysis/tables/"

# delimit;
tabout dsbq9 dscq35b using "TrainerFinance.tex",
cells(freq col cum) format(0 1) clab(No. Col_% Cum_%) replace 
style(tex) bt cl1(2-10) cl2(2-4 5-7 8-10) font(bold) 
topf(top.tex) botf(bot.tex) topstr(14cm) botstr();

capture log close


