******************************************************************************************************************************** This do-file runs all the regressions except Table 1-Column 5 for "Media-Driven Polarization. Evidence from the US" ********************************************************************************************************************************

************************************************************************* Load state-level media data from Campante & Do *************************************************************************
clear all
use "${path}/CampanteDo_MainData.dta", clear
* keep only the 2000 year of the panel dataset
keep if year==2000
* keep useful variables
keep fips pc1_gwahr pc1_swahr
* Save new dataset as temporary file
save "{path}/temp.dta", replace

************************************************************************* Load & Merge 2008 ANES data *************************************************************************
clear all
use "${path}/ANES_2008.dta", clear
* Genere year variabe = 2008
gen year=2008
* Rename state fips: V081201b
rename V081201b fips
* Merge ANES and state-level media data
merge m:1 fips using "${path}/temp.dta"
drop _merge
save "{path}/ANES_2008.dta", replace
erase "{path}/temp.dta"
* Keep only useful variables
keep fips pc1_gwahr pc1_swahr V083069 V083069x V083098a V083303 V083001a V083001b ///
V083021c V085019 V083021d V083025b V085012 V085023 V081104 V083249 V083218x ///
V081107 V081101 V082003b V082025 V081203b V081204 V085036x V085036b V085024 V085193 ///
V083020c V085187a V085187b V085201a V085201f V085033 V085034 V083079d V083080d ///
V085151d V085152d V085066 V085067 V085120a V085121a V085123a V085151b V085151b ///
V085123a V085121a V085120a V085066 V085067

************************************************************************* Genere variables of interest *************************************************************************

* Genere Ideological variables***********************
* Genere "ideologic1" var. based on the 7-point scale
	* Notes: V083069: pre-election summary self plcmnt lib-con scale/  ==> 1 (lib) to 7 (cons)
	* Notes: We take pre-election (V083069) rather than post-election (V085084) self-placement as there was no post-elections interview for quite a lot of responsents of the pre-election wave
	* Clean: replace "Refused", "Don't know", "Haven't thought much about it"
	replace V083069=. if V083069==-7|V083069==-8|V083069==-9
	* Genere ideological voters variable
	gen 	ideologic1=1 if V083069==1|V083069==7
	replace	ideologic1=0 if V083069==2|V083069==3|V083069==4|V083069==5|V083069==6
* Genere "ideologic2": alternative var. based on the 7-point scale. Considers "liberal" and "conservative" as ideological
	gen 	ideologic2=ideologic1
	replace ideologic2=1 if V083069==2|V083069==6

* Genere Information/interest variables********************************
* Genere "info": V083303 "PRE IWR OBS: R level of information" from 1=very high to 5=very low
	* clean missing
	replace V083303 =. if V083303==-4
	gen 	info=1 if V083303==1|V083303==2
	replace info=0 if V083303==3|V083303==4|V083303==5
	* Genere "info2"
	gen 	info2=info
	replace	info2=1 if V083303==3
* Genere continuous info
	gen 	info_c=6-V083303 if V083303~=.

* Genere "interest" based on V083001a & V083001b
	* V083001a "[VERSION A] Interested in following campaigns"
	* V083001b "[VERSION B] Interested in following campaigns"
	* clean
	replace V083001a=. if V083001a==-1
	replace V083001b=. if V083001b==-1|V083001b==-9
	gen 	interest=1 if V083001a==1|            V083001b==1|V083001b==2
	replace interest=0 if V083001a==3|V083001a==5|V083001b==3|V083001b==4|V083001b==5
	* gener "interest2"
	gen 	interest2=interest
	replace	interest2=1 if V083001a==3 |		  V083001b==3
	* Genere continuous interest
	gen 	interest_c=6-V083303 if V083303~=.
	replace	interest_c=6-V083001b if V083001b~=.

* Genere "follow"
	*V085193 "CSES: How closely did R follow the election campaign"
	*clean
	replace V085193=. if V085193<0
	gen 	follow=1 if V085193==1|V085193==2
	replace follow=0 if V085193==3|V085193==4
* Genere continuous follow
	gen 	follow_c=5-V085193 if V085193~=.

* Genere "local_news"
	*V083020c "[OLD] Attention to local news"
	*clean
	replace V083020c=. if V083020c<0
	gen 	local_news=1 if V083020c==1|V083020c==2
	replace local_news=0 if V083020c==3|V083020c==4|V083020c==5
* Genere continuous local_news_c
	gen 	local_news_c=6-V083020c if V083020c~=.

* Genere Media variables*****************
* Genere "read_paper"
	* Notes: V083021c "[OLD] Did R read about campaign in newspaper"
	* Notes:V085019  "[NEW] Read about Presidential campaign in newspaper"
	* clean for refused, dont know and INAP
	replace V083021c=. if V083021c<0
	replace V085019=. if V085019<0
	gen 	read_paper=1 if V083021c==1|V085019==1
	replace read_paper=0 if V083021c==5|V085019==5

* Genere "attention_paper"
	* Notes: V083021d "[OLD] Attention to newspaper articles"
	* Notes: V083025b "[NEW] Attention to printed newspaper news"
	* clean for INAP
	replace V083021d =. if V083021d<0
	replace V083025b =. if V083025b<0
	gen 	attention_paper=1 if V083021d==1|V083021d==2|V083025b==1|V083025b==2
	replace attention_paper=0 if V083021d==3|V083021d==4|V083021d==5|V083025b==3|V083025b==4|V083025b==5
	* Genere "attention_paper2"
	gen 	attention_paper2=attention_paper
	replace	attention_paper2=1 if V083021d==3 |						 V083025b==3
	* Genere continuous attention_paper_c
	gen 	attention_paper_c=6-V083021d if V083021d~=.
	replace	attention_paper_c=6-V083025b if V083025b~=.
 
* Genere "attention_news" => *post-election variable*
	*V085012 "[OLD] General attention to Presidential campaign news"
	*V085023 "[NEW] General attention to Presidential campaign news"
	replace V085012=. if V085012<0
	replace V085023=. if V085023<0
	gen 	attention_news=1 if V085012==1|V085012==2|V085023==1|V085023==2
	replace attention_news=0 if V085012==3|V085012==4|V085012==5|V085023==3|V085023==4|V085023==5
	* genere "attention_news2"
	gen attention_news2=attention_news
	replace attention_news2=1 if V085012==3 | 					 V085023==3
	* Genere continuous attention_news_c
	gen 	attention_news_c=6-V085012 if V085012~=.
	replace	attention_news_c=6-V085023 if V085023~=.

* Genere "trust_media"
	*V085024  "A4. How often trust the media to report news fairly"
	replace V085024=. if V085024<0
	gen 	trust_media=1 if V085024==1|V085024==2
	replace trust_media=0 if V085024==3|V085024==4


* Genere political involvement variables***********************
* Genere "turnout"
	*V085036x "C1x. SUMMARY: R VOTE TURNOUT [OLD and NEW]"
	replace V085036x=. if V083020c<0
	rename V085036x turnout
	label var turnout "turnout"
	*V085036b "C1b1. [NEW] R usually vote during the past 6 years"

*V085201a "R4a. DHS: Has R ever: joined a protest march or rally"
	gen 	protest=1 if V085201a==1
	replace protest=0 if V085201a==5

*V085201f "R4f. DHS: Has R ever: gave money to social/polit org"
	gen 	contrib_org=1 if V085201f==1
	replace contrib_org=0 if V085201f==5

*V085033 "R contribute money to specific candidate campaign"
	gen 	contrib_camp=1 if V085033==1
	replace contrib_camp=0 if V085033==5

*V085034 "R contribute money to political party"
	gen 	contrib_party=1 if V085034==1
	replace contrib_party=0 if V085034==5

	* pre-elect
*V083079d: "[VERSION C] Have no say about what govt does"
*V083080d: "[VERSION D] Have no say about what govt does"
	gen 	no_say_gov=1 if V083079d==1|V083079d==2|			V083080d==1|V083080d==2
	replace no_say_gov=0 if V083079d==3|V083079d==4|V083079d==5|V083080d==3|V083080d==4|V083080d==5

	* post-elec
*V085151d: "[VERSION C] Say about what govt does
*V085152d: "M2b4. [VERSION D] Say about what govt does"
	gen 	no_say_gov2=1 if V085151d ==1| V085151d ==2|			V085152d ==1| V085152d ==2
	replace no_say_gov2=0 if V085151d ==3| V085151d ==4| V085151d ==5| V085152d ==3| V085152d ==4| V085152d ==5


* Genere political knowledge variables*********************
* V085066 "E1a. Know party with most members in House before election"
	gen		house=. if V085066<0
	replace	house=1 if V085066==1
	replace	house=0 if V085066==5
	replace	house=0 if V085066==-8

* V085067 "E1b. Know party with most members in Senate before election"
	gen		senate=. if V085067<0
	replace	senate=1 if V085067==1
	replace	senate=0 if V085067==5
	replace	senate=0 if V085067==-8

* V085120a "Office recognition probe: Speaker of the House"
	gen 	speaker=0 if V085120a==1
	replace	speaker=1 if V085120a==5
	replace	speaker=. if V085120a==-2

* V085121a "J3b1. Office recognition probe: Vice-President"
	gen 	vice_pres=0 if V085121a==1
	replace	vice_pres=1 if V085121a==5
	replace	vice_pres=. if V085121a==-2


************************************************************************* Genere control variables *************************************************************************
rename V081104 age
rename V083249 income
rename V083218x educ
	label var educ education
rename V081107 household
gen male=1 if V081101==1
replace male=0 if V081101==2
*V082003b "PreAdmin.3b. No. days til election: Pre-election IW end date"
rename V082003b til_elec
rename V082025 urban

* dummies to produce:
	*V081203b "Corrected Congressional district number"
	*V081204 "Census Region"
qui tab V081204, gen(region_)
qui tab fips, gen(state_)

* genere macro
local indiv_cov age income educ male household urban til_elec

* genere interactions
foreach x of varlist educ til_elec info interest read_paper attention_paper attention_news ///
					 info2 interest2 attention_paper2 attention_news2 trust_media ///
					 info_c interest_c follow_c local_news_c attention_paper_c attention_news_c {
	gen `x'_gwahr=`x'*pc1_gwahr
	gen `x'_swahr=`x'*pc1_swahr
	}

************************************************************************* Label variables *************************************************************************
label var ideologic2 "Polarization"
label var interest_c "Interest"
label var read_paper "Read paper"
label var interest_c_gwahr "Media x Interest"
label var read_paper_gwahr "Media x Read paper"

************************************************************************* Table 1. Polarization and Media Coverage *************************************************************************
	* Column 1
	prob ideologic2 interest_c interest_c_gwahr `indiv_cov' state_*
	outreg2 using tab1.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X", Sample, "full") label replace
	* Column 2
	prob ideologic2 read_paper read_paper_gwahr `indiv_cov' state_*
	outreg2 using tab1.doc, nocons keep(read_paper read_paper_gwahr) addtext(Individual controls, "X", State dummies,"X", Sample, "full") label
	* Column 3
	prob ideologic2 interest_c interest_c_gwahr `indiv_cov' state_* if V083069<=4
	outreg2 using tab1.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X", Sample, "liberals") label 
	* Column 4
	prob ideologic2 interest_c interest_c_gwahr `indiv_cov' state_* if V083069>=4
	outreg2 using tab1.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X", Sample, "conserv.") label 
	* Column 6 => See the do-file "ANES_2000_placebo_reg"




************************************************************************* Table 2. Money Contribution and Media Coverage ************************************************************************* 
	* Column 1
	prob contrib_camp interest_c interest_c_gwahr `indiv_cov' state_*
	outreg2 using tab2.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X") label replace
	* Column 2
	prob contrib_party interest_c interest_c_gwahr `indiv_cov' state_*
	outreg2 using tab2.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X") label
	* Column 3
	prob contrib_org interest_c interest_c_gwahr `indiv_cov' state_*
	outreg2 using tab2.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X") label

************************************************************************* Table 3. Political Knowledge and Media Coverage *************************************************************************
	* Column 1
	prob house interest_c interest_c_gwahr `indiv_cov' state_*
	outreg2 using tab3.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X") label replace
	* Column 2
	prob senate interest_c interest_c_gwahr `indiv_cov' state_* 
	outreg2 using tab3.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X") label
	* Column 3
	prob speaker interest_c interest_c_gwahr `indiv_cov' state_* 
	outreg2 using tab3.doc, nocons keep(interest_c interest_c_gwahr) addtext(Individual controls, "X", State dummies,"X") label

************************************************************************* Figure 2. Marginal effect of Campaign Interest on Polarization according to State Media *************************************************************************
	rename pc1_gwahr Media
	rename ideologic2 Polarization
	prob Polarization c.interest_c##c.Media `indiv_cov'
	margins, dydx(interest_c) at(Media=(-3 (1) 10)) vsquish
	marginsplot, recast(line)  yline(0) name(marg) title(" ")

************************************************************************* End *************************************************************************
