
* This do file:
	* Does the balance test for Tuungane vs control
	* We use 2012 data because we don't have baseline. 
	* But we'll use variables that change little over time,
	* or those that ask about before the start of Tuungane

	* Only thing to change in this document is the working directly
	
	clear
	clear mata
	set mem 1000m
	set more off

	cd "C:\Users\Peter\Dropbox\drc_womenempowerment\03_analysis"
	
* **************************************************************************
* Prepare data
* **************************************************************************

* Puts 2012 survey data together

	use DRC2012_ABD_VILL_v2.dta
	merge 1:n IDV using DRC2012_ABD_INDIV_v2
	drop _m
	merge 1:n IDS using DRC2012_D_ROSTER_v2
	drop _m
	merge n:1 IDV using TUUNGANE_v2

* Only DML:
	keep if IDS_TYPES=="DML"

	egen tag=tag(IDV)
	
* **************************************************************************
* Prep village level variables
* **************************************************************************

* Individuals: Distance: mine, police post, chiefdomHQ
	foreach var of varlist qe013_i_mine_hrs qe013_i_mine_mns qe013_j_post_hrs qe013_j_post_mns qe013_k_chef_chefferie_hrs qe013_k_chef_chefferie_mns{
		tab `var'
		replace `var'=. if `var'<0
	}
	g distance_mineX = round(qe013_i_mine_hrs + qe013_i_mine_mns/60) if (qe013_i_mine_hrs!=. & qe013_i_mine_mns!=.)	
	by IDV, sort: egen distance_mine=mean(distance_mineX)
	g distance_postX = round(qe013_j_post_hrs + qe013_j_post_mns/60) if (qe013_j_post_hrs!=. & qe013_j_post_mns!=.)	
	by IDV, sort: egen distance_post=mean(distance_postX)
	g distance_chiefhqX = round(qe013_k_chef_chefferie_hrs + qe013_k_chef_chefferie_mns/60) if (qe013_k_chef_chefferie_hrs!=. & qe013_k_chef_chefferie_mns!=.)	
	by IDV, sort: egen distance_chiefhq=mean(distance_chiefhqX)

* Chief: Public goods present in July 2006
	foreach var of varlist cq023_a1_wells_2006 cq024_a1_schools_2006 cq025_a1_cliniques_2006 cq026_a1_churches_2006 cq027_a1_halls_2006{
		tab `var'
*		replace `var'=0 if `var'==-8
		replace `var'=. if `var'<0
	}	
		
* Chief: Migration into the village in 2006
	foreach var of varlist cq0136_idp_2006 cq0137_idp_returned_2006 cq0138_refugie_2006 cq0139_refugie_repat_2006{
		tab `var'
		replace `var'=. if `var'<0
		replace `var'=. if `var'>200
	}

* ELF
	g grA=(cq013_a_group_percentage/100)^2 
	g grB=(cq013_b_group_percentage/100)^2 
	g grC=(cq013_c_group_percentage/100)^2 
	g grD=(cq013_d_group_percentage/100)^2 
	g grE=(cq013_e_group_percentage/100)^2 
	g grF=(cq013_f_group_percentage/100)^2
	replace grB=0 if grB==. & grA!=.
	replace grC=0 if grC==. & grA!=.
	replace grD=0 if grD==. & grA!=.
	replace grE=0 if grE==. & grA!=.
	replace grF=0 if grF==. & grA!=.
	g elf = 1- (grA+grB+grC+grD+grE+grF)	
	replace elf=. if (cq013_a_group_percentage==. & cq013_b_group_percentage==. & cq013_c_group_percentage==. & cq013_d_group_percentage==. & cq013_e_group_percentage==. & cq013_f_group_percentage==.)
	replace elf=. if (cq013_a_group_percentage==0 & cq013_b_group_percentage==0 & cq013_c_group_percentage==0 & cq013_d_group_percentage==0 & cq013_e_group_percentage==0 & cq013_f_group_percentage==0)
	drop gr*
	tab elf

* REL_ELF
	g grA=(cq014_a_catholic/100)^2 
	g grB=(cq014_b_protestant/100)^2 
	g grC=(cq014_c_muslim/100)^2 
	g grD=(cq014_d_jehova/100)^2 
	g grE=(cq014_e_kimbanguiste/100)^2 
	g grF=(cq014_g_other_religion/100)^2
	replace grB=0 if grB==. & grA!=.
	replace grC=0 if grC==. & grA!=.
	replace grD=0 if grD==. & grA!=.
	replace grE=0 if grE==. & grA!=.
	replace grF=0 if grF==. & grA!=.
	g relfrac = 1- (grA+grB+grC+grD+grE+grF)	
	replace relfrac=. if (cq013_a_group_percentage==. & cq013_b_group_percentage==. & cq013_c_group_percentage==. & cq013_d_group_percentage==. & cq013_e_group_percentage==. & cq013_f_group_percentage==.)
	replace relfrac=. if (cq013_a_group_percentage==0 & cq013_b_group_percentage==0 & cq013_c_group_percentage==0 & cq013_d_group_percentage==0 & cq013_e_group_percentage==0 & cq013_f_group_percentage==0)
	drop gr*

* Pricipal activity in the village 
	summ cq015_agriculture cq015_breeding cq015_commerce cq015_fish cq015_industrial cq015_mining cq015_other cq015_other_services	

* Previous chief
	tab cq045_dob_former_chief if tag==1
	replace cq045_dob_former_chief=. if cq045_dob_former_chief<0 
	* replace cq045_dob_former_chief=. if cq045_dob_former_chief<1900
	* replace cq045_dob_former_chief=2012-cq045_dob_former_chief
	
	g prevchief_demo=1 if cq048_how_former_chief=="4 Elected by inhabitants" | cq048_how_former_chief=="5 Plebiscite by inhabitants"
	replace prevchief_demo=0 if cq048_how_former_chief=="1 Elderly choose" | cq048_how_former_chief=="2 King and other chiefs" | cq048_how_former_chief=="3 Inherited" | cq048_how_former_chief=="7 Selected by pol or trad leadership" | cq048_how_former_chief=="6 By force"

	* 6=died due to natural causes
	tab cq050_why_end
	replace cq050_why_end=. if cq050_why_end<0
	g prevchief_died=0 if cq050_why_end!=.
	replace prevchief_died=1 if cq050_why_end==6
	
* **************************************************************************
* Prep individual level variables
* **************************************************************************
	
	* Gender
	tab qf007_gender
	g gender = qf007_gender
	
	* Age
	tab qf009_birthyear
	replace qf009_birthyear=. if qf009_birthyear<0
	g age = 2011-qf009_birthyear
	* Take top 1% out:
	sum age, detail
	replace age=. if age>`r(p99)'
		
* **************************************************************************
* Balance
* **************************************************************************

	* Initialize output:	
	est clear
		eststo: reg IDV IDS
		estout using "BALANCE_SUM.xls", replace keep(IDS) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(NOTHING)
		estout using "BALANCE_REG.xls", replace keep(IDS) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(NOTHING)
	est clear
	
** Village
	foreach var of varlist distance_mine distance_post distance_chiefhq cq045_dob_former_chief prevchief_demo prevchief_died elf relfrac cq015_agriculture cq015_breeding cq015_commerce cq015_fish cq015_industrial cq015_mining cq015_other cq015_other_services cq023_a1_wells_2006 cq024_a1_schools_2006 cq025_a1_cliniques_2006 cq026_a1_churches_2006 cq027_a1_halls_2006 cq0136_idp_2006 cq0137_idp_returned_2006 cq0138_refugie_2006 cq0139_refugie_repat_2006{
	estpost summarize `var' if TUUNGANE==1 & tag==1
		estout using "BALANCE_SUM.xls", append cells(mean(fmt(2)) sd(fmt(2)))
		estpost summarize `var' if TUUNGANE==0 & tag==1
		estout using "BALANCE_SUM.xls", append cells(mean(fmt(2)) sd(fmt(2)))
		est clear
		eststo: regress `var' TUUNGANE if tag==1
		estout using "BALANCE_REG.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01) title(`var')
		est clear
	}
	
** Individual
	foreach var of varlist gender age{
		estpost summarize `var' if TUUNGANE==1 
		estout using "BALANCE_SUM.xls", append cells(mean(fmt(2)) sd(fmt(2)))
		estpost summarize `var' if TUUNGANE==0 
		estout using "BALANCE_SUM.xls", append cells(mean(fmt(2)) sd(fmt(2)))
		est clear
		eststo: regress `var' TUUNGANE
		estout using "BALANCE_REG.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01) title(`var')
		est clear
	}
	
												* END *
												