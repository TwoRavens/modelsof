*cd "C:\Users\Sara.Chatfield\Dropbox\faces war\Replication Files - JOP"

* Lausten and Petersen Replication *

use "Little and LP Replication Data.dta"
ttest LP_noconflict == LP_conflict, unpaired
clear

* Little et. al. Replication *

use "Little and LP Replication Data.dta"
ttest L_peace == L_war, unpaired
clear

* Figure 1 *

use "Senate.dta"
twoway (scatter voteshareR domadvR if war ==1, mcolor(red) msymbol(circle))(scatter voteshareR domadvR if war ==0, mcolor(blue) msymbol(diamond_hollow)), ytitle(Republican Vote Share) xtitle(Facial Dominance (negative values indicate a more dominant Republican)) by(, title(Facial Dominance and Republican Vote Share by Year)) by(year, legend(off)) legend(off) || lfit  voteshareR domadvR
clear

* Table 1 *

use "Senate.dta"

	* Model 1 - All Races
	regress  voteshareR domadvR war wardom

	* Model 2 - All Races
	
	regress voteshareR domadvR wardom incumbentR incumbentD Republican i.year

	* Model 1 - Male Only Races
	
	drop if genderR == 1
	drop if genderD == 1
	regress  voteshareR domadvR war wardom

	* Model 2 - Male Only Races
	
	regress voteshareR domadvR wardom incumbentR incumbentD Republican i.year

clear

* Table 2 *

	* Experiment 2 Results 
	
	use "AMT_experiment.dta", clear
	g control_war =control == 1 &war== 1
	g party_war =party == 1 &war== 1
	g gay_war =gay == 1 &war== 1
	
	regress vote control control_war party party_war gay gay_war if LP==1,noc
	test _b[control_war] = _b[party_war]
	test _b[control_war] = _b[gay_war]

	regress vote control control_war party party_war gay gay_war if Little==1,noc
	test _b[control_war] = _b[party_war]
	test _b[control_war] = _b[gay_war]
	
	
	
	
	clear
	
	* Experiment 3 Results 
	
	use "SSI_experiment.dta"
	g control_war =control == 1 &war== 1
	g party_war =party == 1 &war== 1
	g gay_war =gay == 1 &war== 1
	g econ_war = econ == 1 & war == 1
	
	
	regress vote control control_war party party_war gay gay_war econ econ_war if LP==1,noc
	test _b[control_war] = _b[party_war]
	test _b[control_war] = _b[gay_war]
	test _b[control_war] = _b[econ_war]

	regress vote control control_war party party_war gay gay_war econ econ_war if Little==1,noc
	test _b[control_war] = _b[party_war]
	test _b[control_war] = _b[gay_war]
	test _b[control_war] = _b[econ_war]
	
	tab1 control  party  gay  econ if LP==1 & vote !=.   //  number of conditions
	tab1 control  party  gay  econ if Little==1 & vote !=.

	clear


