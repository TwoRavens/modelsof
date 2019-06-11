********************************************************************
********************************************************************
********************************************************************
********************************************************************
******** Do File for Replication of 						******** 
******** Cassese, Erin C & Mirya R. Holman 					******** 
******** Party and Gender Stereotypes in Campaign Attacks 	******** 
******** Political Behavior 								******** 
********************************************************************
********************************************************************
*********************************************************************
*********************************************************************
set more off 

* Study 1: Basic tests, SUR, & Wald Tests to Evaluate Differences Across Parties - Trait Study Data 

* You will need to replace w your own file paths.
use "Trait Attack Study Data.dta"


* Variable Construction

**** cleaning *** 

recode citizen 2 = 0
recode gender 2=1 1=0
recode hispanic 2 = 0
recode check2 2=0

recode vote_patricia 7=1 6=2 5=3 3=5 2=6 1=7
recode vote_patrick 7=1 6=2 5=3 3=5 2=6 1=7
recode vote_hepner  7=1 6=2 5=3 3=5 2=6 1=7
recode vote_hepner2 7=1 6=2 5=3 3=5 2=6 1=7
recode favor_patricia  7=1 6=2 5=3 3=5 2=6 1=7
recode favor_patrick 7=1 6=2 5=3 3=5 2=6 1=7
recode favor_hepner  7=1 6=2 5=3 3=5 2=6 1=7
recode favor_hepner2  7=1 6=2 5=3 3=5 2=6 1=7
recode leader_patricia  7=1 6=2 5=3 3=5 2=6 1=7
recode leader_patrick 7=1 6=2 5=3 3=5 2=6 1=7
recode  leader_hepner  7=1 6=2 5=3 3=5 2=6 1=7
recode leader_hepner2  7=1 6=2 5=3 3=5 2=6 1=7


gen comm_agen = 0
replace comm_agen = 1 if female_d_agen == 1 | male_d_agen == 1 | male_r_agen == 1 | female_r_agen == 1
replace comm_agen = 2 if female_r_comm == 1 | female_d_comm == 1 | male_d_comm == 1 |  male_r_comm == 1
tab comm_agen
recode comm_agen 0=.
replace comm_agen = 0 if male_r_control == 1 | male_d_control == 1 | female_d_control == 1 | female_r_control == 1
tab comm_agen

gen female = 0
replace female = 1 if female_d_comm == 1 |  female_r_comm == 1 | female_r_agen == 1 | female_d_agen == 1 | female_d_control == 1 | female_r_control == 1
replace female = . if comm_agen == .


gen male = 0
replace male = 1 if female == 0


gen condition = .
replace condition = 1 if female_d_comm == 1
replace condition = 2 if female_r_comm == 1
replace condition = 3 if female_r_agen == 1
replace condition = 4 if female_d_agen == 1
replace condition = 5 if female_d_control == 1
replace condition = 6 if female_r_control == 1
replace condition = 7 if male_d_comm == 1
replace condition = 8 if male_r_comm == 1
replace condition = 9 if male_r_agen == 1
replace condition = 10 if male_d_agen == 1
replace condition = 11 if male_d_control == 1
replace condition = 12 if male_r_control == 1
replace condition = . if comm_agen == .

gen republican = 0
replace republican = 1 if condition == 2 | condition == 3 | condition == 6 | condition == 8 | condition == 9 | condition == 12
gen democrat = 0
replace democrat = 1 if condition == 1 | condition == 4 | condition == 5 | condition == 7 | condition == 10 | condition == 11


**** generating combition variables across the conditions ****

egen vote1 = rowtotal (vote_patricia vote_patrick)
egen vote2 = rowtotal (vote_hepner vote_hepner2)
egen favor1 = rowtotal (favor_patricia favor_patrick)
egen favor2 = rowtotal (favor_hepner favor_hepner2)
egen ideo1 = rowtotal (ideo_patricia ideo_patrick)
egen ideo2 = rowtotal (ideo_hepner ideo_hepner2)
egen leader1 = rowtotal (leader_patricia leader_patrick)
egen leader2 = rowtotal (leader_hepner leader_hepner2)

*** resp characteristics ****

gen r_dem = 0
replace r_dem = 1 if pid <4
gen r_rep = 0
replace r_rep = 1 if pid >4
rename race_other race_other_text
gen white = 0
replace white = 1 if race == 1
gen black = 0
replace black = 1 if race == 2
gen asian = 0
replace asian = 1 if race == 3
gen race_other = 0
replace race_other = 1 if race >= 4

recode reg_vote 3 = . 2=0
recode vote_2012 3 = . 2=0 

gen liberal = 0
replace liberal = 1 if ideology <4
gen conservative = 0
replace conservative = 1 if ideology >4

**** creating standardized composites for trait evaluations  ****


gen trait1r_patricia = (9-trait1_patricia) 

sum trait1r_patricia 
gen ztrait1_patricia = (trait1r_patricia-r(mean))/r(sd)

sum trait2_patricia 
gen ztrait2_patricia = (trait2_patricia-r(mean))/r(sd)

sum trait3_patricia 
gen ztrait3_patricia = (trait3_patricia-r(mean))/r(sd)

sum trait4_patricia 
gen ztrait4_patricia = (trait4_patricia-r(mean))/r(sd)

sum trait5_patricia 
gen ztrait5_patricia = (trait5_patricia-r(mean))/r(sd)

sum assertive_patricia
gen zassertive_patricia = (assertive_patricia-r(mean))/r(sd)

sum tough_patricia
gen ztough_patricia = (tough_patricia-r(mean))/r(sd)

sum aggressive_patricia 
gen zaggressive_patricia = (aggressive_patricia-r(mean))/r(sd)

sum masculine_patricia 
gen zmasculine_patricia = (masculine_patricia-r(mean))/r(sd)

sum active_patricia 
gen zactive_patricia = (active_patricia-r(mean))/r(sd)

sum confident_patricia
gen zconfident_patricia = (confident_patricia-r(mean))/r(sd)

sum warm_patricia 
gen zwarm_patricia = (warm_patricia-r(mean))/r(sd)

sum feminine_patricia
gen zfeminine_patricia = (feminine_patricia-r(mean))/r(sd)

sum sensitive_patricia 
gen zsensitive_patricia = (sensitive_patricia-r(mean))/r(sd)

sum cautious_patricia 
gen zcautious_patricia = (cautious_patricia-r(mean))/r(sd)


alpha ztrait2_patricia ztrait3_patricia ztrait4_patricia ztrait5_patricia zwarm_patricia zfeminine_patricia zsensitive_patricia zcautious_patricia
egen zfem_traits_patricia = rowmean (ztrait2_patricia ztrait3_patricia ztrait4_patricia ztrait5_patricia zwarm_patricia zfeminine_patricia zsensitive_patricia zcautious_patricia)
sum zfem_traits_patricia
replace zfem_traits_patricia = (zfem_traits_patricia-r(mean))/r(sd)
sum zfem_traits_patricia
alpha ztrait1_patricia zassertive_patricia ztough_patricia zaggressive_patricia zmasculine_patricia zactive_patricia zconfident_patricia
egen zmas_traits_patricia = rowmean (ztrait1_patricia zassertive_patricia ztough_patricia zaggressive_patricia zmasculine_patricia zactive_patricia zconfident_patricia)
sum zmas_traits_patricia
replace zmas_traits_patricia = (zmas_traits_patricia-r(mean))/r(sd)
sum zmas_traits_patricia

gen trait1r_patrick = (9-trait1_patrick)

sum trait1r_patrick 
gen ztrait1_patrick = (trait1r_patrick-r(mean))/r(sd)

sum trait2_patrick 
gen ztrait2_patrick = (trait2_patrick-r(mean))/r(sd)

sum trait3_patrick 
gen ztrait3_patrick = (trait3_patrick-r(mean))/r(sd)

sum trait4_patrick 
gen ztrait4_patrick = (trait4_patrick-r(mean))/r(sd)

sum trait5_patrick 
gen ztrait5_patrick = (trait5_patrick-r(mean))/r(sd)

sum assertive_patrick
gen zassertive_patrick = (assertive_patrick-r(mean))/r(sd)

sum tough_patrick
gen ztough_patrick = (tough_patrick-r(mean))/r(sd)

sum aggressive_patrick 
gen zaggressive_patrick = (aggressive_patrick-r(mean))/r(sd)

sum masculine_patrick 
gen zmasculine_patrick = (masculine_patrick-r(mean))/r(sd)

sum active_patrick 
gen zactive_patrick = (active_patrick-r(mean))/r(sd)

sum confident_patrick
gen zconfident_patrick = (confident_patrick-r(mean))/r(sd)

sum warm_patrick 
gen zwarm_patrick = (warm_patrick-r(mean))/r(sd)

sum feminine_patrick
gen zfeminine_patrick = (feminine_patrick-r(mean))/r(sd)

sum sensitive_patrick 
gen zsensitive_patrick = (sensitive_patrick-r(mean))/r(sd)

sum cautious_patrick 
gen zcautious_patrick = (cautious_patrick-r(mean))/r(sd)

alpha ztrait2_patrick ztrait3_patrick ztrait4_patrick ztrait5_patrick zwarm_patrick zfeminine_patrick zsensitive_patrick zcautious_patrick
egen zfem_traits_patrick = rowmean (ztrait2_patrick ztrait3_patrick ztrait4_patrick ztrait5_patrick zwarm_patrick zfeminine_patrick zsensitive_patrick zcautious_patrick)
sum zfem_traits_patrick
replace zfem_traits_patrick = (zfem_traits_patrick-r(mean))/r(sd)
sum zfem_traits_patrick
alpha ztrait1_patrick zassertive_patrick ztough_patrick zaggressive_patrick zmasculine_patrick zactive_patrick zconfident_patrick
egen zmas_traits_patrick = rowmean (ztrait1_patrick zassertive_patrick ztough_patrick zaggressive_patrick zmasculine_patrick zactive_patrick zconfident_patrick)
sum zmas_traits_patrick
replace zmas_traits_patrick = (zmas_traits_patrick-r(mean))/r(sd)
sum zmas_traits_patrick

*** combined traits *** 

gen femtraits_combined=zfem_traits_patricia
replace femtraits_combined=zfem_traits_patrick if zfem_traits_patricia==.
gen mastraits_combined=zmas_traits_patricia
replace mastraits_combined=zmas_traits_patrick if zmas_traits_patricia==.


*** generating dummy variables of each type of attack  ****

gen communal = 0
replace communal = 1 if comm_agen == 2
replace communal = . if comm_agen == 1

gen agentic = 0
replace agentic = 1 if comm_agen == 1
replace agentic = . if comm_agen == 2

*** interactions between type of attack and the gender and party of the candidate  ****

gen communal2 = communal
recode communal2 .=0

gen agentic2 = agentic
recode agentic2 .=0

gen vote_combined=vote_patricia
replace vote_combined=vote_patrick if vote_combined==.

recode female_d_agen .=0
recode male_d_agen  .=0
recode male_r_agen  .=0
recode female_r_agen  .=0
recode female_r_comm  .=0
recode male_d_comm  .=0
recode male_r_comm  .=0
reg vote_combined female_d_agen male_d_agen male_r_agen female_r_agen female_r_comm male_d_comm male_r_comm 


** generating interactions 
gen agentic_cond=1 if comm_agen==1
replace agentic_cond=0 if comm_agen==0 | comm_agen==2
gen communal_cond=1 if comm_agen==2 
replace communal_cond=0 if comm_agen==0 | comm_agen==1
gen agentic_female=agentic_cond*female
gen communal_female=communal_cond*female 

gen leader_combined=leader_patrick
replace leader_combined=leader_patricia if leader_patrick==.
gen zleader_combined=(leader_combined-3.96893)/1.33465 

gen favor_combined=favor_patrick
replace favor_combined=favor_patricia if favor_patrick==.
gen zfavor_combined=(favor_combined-3.82448)/1.409022

gen agentic_republican=agentic_cond*republican
gen communal_republican=communal_cond*republican 
gen agentic_democrat=agentic_cond*democrat
gen communal_democrat=communal_cond*democrat 

*** labeling variables *** 


label variable femtraits_combined "Female traits"
label variable mastraits_combined "Male traits"
label variable communal_cond "Feminine Trait Attack"
label variable agentic_cond "Masculine Trait Attack"
label variable republican "Republican candidate"
label variable agentic_republican  "Republican candidate * Masculine Trait Attack"
label variable communal_republican  "Republican candidate * Feminine Trait Attack"
label variable agentic_democrat  "Democrat candidate * Masculine Trait Attack"
label variable communal_democrat  "Democrat candidate * Feminine Trait Attack"
label variable zfavor_combined "Favorability" 
label variable zleader_combined "Leadership evaluation" 
label variable agentic2 "Masc. Trait Attack"
label variable communal2 "Fem. Trait Attack" 

*** descriptive statistics *** 


tabulate race
tabulate edu 
sum gender age 
tabulate income 

tabulate pid 
tabulate ideology

*** balance checks *** 

mlogit condition age gender pid income edu race 


*** manipulation check *** 

tab check1
oneway check1 condition, tab
tab check2
oneway check2 condition, tab
tab check3 
oneway check3 condition, tab 


tab check1 if democrat == 1
oneway check1 condition  if democrat == 1, tab
tab check2  if democrat == 1
oneway check2 condition if democrat == 1, tab
tab check3  if democrat == 1
oneway check3 condition if democrat == 1, tab 


tab check1 if democrat == 1
oneway check1 condition if republican == 1, tab
tab check2  if democrat == 1
oneway check2 condition if republican == 1, tab
tab check3  if democrat == 1
oneway check3 condition if republican == 1, tab 


*** Hypothesis 1: Do these attacks work? *** 

*** Figure 1 Models & Contrasts

eststo clear
quietly eststo femtraits: reg femtraits_combined agentic2 communal2 
test agentic2=communal2
quietly eststo mastraits: reg mastraits_combined agentic2 communal2
test agentic2=communal2
quietly eststo vote: reg vote_combined agentic2 communal2 
test agentic2 = communal2

eststo clear
quietly eststo femtraits: reg femtraits_combined agentic2 communal2 
quietly eststo mastraits: reg mastraits_combined agentic2 communal2
quietly eststo vote: reg vote_combined agentic2 communal2 
test agentic2 = communal2
coefplot (femtraits, label(Fem. Traits)) (mastraits, label(Masc. Traits)) (vote, label(Vote)) ///
	|| , drop(_cons) xline(0)   legend (position (6)) legend (row(1))  ysize(4.15) xsize (3.25) saving (Figure1_study1, replace)
graph export Figure1_study1.eps, replace 
graph export Figure1_study1.tif, width(1800)replace 

*** hypothesis 2: does party shape effectiveness?*** 
*** Figure 2 Models & Contrasts


quietly eststo femtraits_democrat: reg femtraits_combined agentic2 communal2 if democrat == 1
quietly eststo femtraits_republican:  reg femtraits_combined agentic2 communal2 if republican == 1
quietly eststo mastraits_democrat: reg mastraits_combined agentic2 communal2 if democrat == 1
quietly eststo mastraits_republican:  reg mastraits_combined agentic2 communal2 if republican == 1
quietly eststo vote_democrat: reg vote_combined agentic2 communal2 if democrat == 1
test agentic2 = communal2
quietly eststo vote_republican: reg vote_combined agentic2 communal2 if republican == 1
test agentic2 = communal2


quietly eststo femtraits_democrat: reg femtraits_combined agentic2 communal2 if democrat == 1
quietly eststo femtraits_republican:  reg femtraits_combined agentic2 communal2 if republican == 1
quietly eststo mastraits_democrat: reg mastraits_combined agentic2 communal2 if democrat == 1
quietly eststo mastraits_republican:  reg mastraits_combined agentic2 communal2 if republican == 1
quietly eststo vote_democrat: reg vote_combined agentic2 communal2 if democrat == 1
test agentic2 = communal2
quietly eststo vote_republican: reg vote_combined agentic2 communal2 if republican == 1
test agentic2 = communal2


coefplot (femtraits_democrat, label (Dem. Cand.)) 	(femtraits_republican,  label (Rep. Cand.))	, bylabel(Feminine Traits) || (mastraits_democrat)	(mastraits_republican), bylabel(Masculine Traits) || (vote_democrat)(vote_republican), bylabel(Vote)  ///
	|| , drop(_cons) xline(0) legend(rows(1)) byopts(cols(1)) ysize(5.25) xsize (4)  saving (Figure2_study1, replace)
	graph display, ysize(5.07) xsize (4)
graph export Figure2_study1.eps, replace 

* Feminine Traits by Cand. Party
quietly eststo est1: reg femtraits_combined agentic2 communal2 if democrat == 1
quietly eststo est2:  reg femtraits_combined agentic2 communal2 if republican == 1
suest est1 est2
test [est1_mean]agentic2=[est2_mean]agentic2
test [est1_mean]communal2=[est2_mean]communal2



* Masculine Traits by Cand Party 
quietly eststo est3: reg mastraits_combined agentic2 communal2 if democrat == 1
quietly eststo est4:  reg mastraits_combined agentic2 communal2 if republican == 1
suest est3 est4
test [est3_mean]agentic2=[est4_mean]agentic2
test [est3_mean]communal2=[est4_mean]communal2



* Vote by Cand Party 
quietly eststo est5: reg vote_combined agentic2 communal2 if democrat == 1
quietly eststo est6: reg vote_combined agentic2 communal2 if republican == 1
suest est5 est6
test [est5_mean]agentic2=[est6_mean]agentic2
test [est5_mean]communal2=[est6_mean]communal2
eststo clear

*** hypothesis 3: do attacks matter by gender of candidate *** 

*** Figure 3 Models and Contrasts

quietly eststo femtraits_female: reg femtraits_combined agentic2 communal2 if female == 1
quietly eststo femtraits_male:  reg femtraits_combined agentic2 communal2 if male == 1
quietly eststo mastraits_female: reg mastraits_combined agentic2 communal2 if female == 1
quietly eststo mastraits_male:  reg mastraits_combined agentic2 communal2 if male == 1


quietly eststo femtraits_female: reg femtraits_combined agentic2 communal2 if female == 1
quietly eststo femtraits_male:  reg femtraits_combined agentic2 communal2 if male == 1
quietly eststo mastraits_female: reg mastraits_combined agentic2 communal2 if female == 1
quietly eststo mastraits_male:  reg mastraits_combined agentic2 communal2 if male == 1
quietly eststo vote_female: reg vote_combined agentic2 communal2 if female == 1
test agentic2 = communal2
quietly eststo vote_male: reg vote_combined agentic2 communal2 if male == 1
test agentic2 = communal2


coefplot (femtraits_female, label (Female Cand.)) 	(femtraits_male, label (Male Cand.))	, bylabel(Feminine Traits) || (mastraits_female)(mastraits_male), bylabel(Masculine Traits) || (vote_female)(vote_male), bylabel(Vote) ///
	|| , drop(_cons) xline(0)  legend(rows(1)) byopts(cols(1)) ysize(5.25) xsize (4)  saving (Figure3_study1, replace)
graph export Figure3_study1.eps, replace 
graph export Figure3_study1.tif, width(1800)replace 

quietly eststo vote_female: reg vote_combined agentic2 communal2 if female == 1
test agentic2 = communal2

quietly eststo vote_male: reg vote_combined agentic2 communal2 if male == 1
test agentic2 = communal2

* Fem Traits by Cand Gender
quietly eststo est6: reg femtraits_combined agentic2 communal2 if female == 1
quietly eststo est7:  reg femtraits_combined agentic2 communal2 if male == 1
suest est6 est7
test [est6_mean]agentic2=[est7_mean]agentic2
test [est6_mean]communal2=[est7_mean]communal2

* Masc Traits by Cand Gender
quietly eststo est8: reg mastraits_combined agentic2 communal2 if female == 1
quietly eststo est9:  reg mastraits_combined agentic2 communal2 if male == 1
suest est8 est9
test [est8_mean]agentic2=[est9_mean]agentic2
test [est8_mean]communal2=[est9_mean]communal2

* Vote Choice by Cand Gender

quietly eststo est10: reg vote_combined agentic2 communal2 if female == 1
quietly eststo est11: reg vote_combined agentic2 communal2 if male == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

*** hypothesis 4: do attacks matter by party AND gender *** 

* Figure 4 Models and Contrasts 

quietly eststo femtraits_female_dem: reg femtraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo femtraits_male_dem:  reg femtraits_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo mastraits_female_dem: reg mastraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo mastraits_male_dem:  reg mastraits_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo femtraits_female_rep: reg femtraits_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo femtraits_male_rep:  reg femtraits_combined agentic2 communal2 if male == 1  & republican == 1
quietly eststo mastraits_female_rep: reg mastraits_combined agentic2 communal2 if female == 1  & republican == 1
quietly eststo mastraits_male_rep:  reg mastraits_combined agentic2 communal2 if male == 1	 & republican == 1
quietly eststo vote_female_dem: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
test agentic2 = communal2
quietly eststo vote_male_dem:  reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
test agentic2 = communal2
quietly eststo vote_female_rep: reg vote_combined agentic2 communal2 if female == 1 & republican == 1
test agentic2 = communal2
quietly eststo vote_male_rep:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1
test agentic2 = communal2

quietly eststo femtraits_female_dem: reg femtraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo femtraits_male_dem:  reg femtraits_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo mastraits_female_dem: reg mastraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo mastraits_male_dem:  reg mastraits_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo femtraits_female_rep: reg femtraits_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo femtraits_male_rep:  reg femtraits_combined agentic2 communal2 if male == 1  & republican == 1
quietly eststo mastraits_female_rep: reg mastraits_combined agentic2 communal2 if female == 1  & republican == 1
quietly eststo mastraits_male_rep:  reg mastraits_combined agentic2 communal2 if male == 1	 & republican == 1
quietly eststo vote_female_dem: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
test agentic2 = communal2
quietly eststo vote_male_dem:  reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
test agentic2 = communal2
quietly eststo vote_female_rep: reg vote_combined agentic2 communal2 if female == 1 & republican == 1
test agentic2 = communal2
quietly eststo vote_male_rep:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1
test agentic2 = communal2
coefplot (femtraits_female_dem,  label (Female Dem.)) 	(femtraits_male_dem,  label (Male Dem.)) (femtraits_female_rep, label (Female Rep.)) (femtraits_male_rep,  label (Male Rep.)), bylabel(Feminine Traits) || (mastraits_female_dem)(mastraits_male_dem)(mastraits_female_rep)(mastraits_male_rep), bylabel(Masculine Traits) || (vote_female_dem)	(vote_male_dem)	(vote_female_rep)(vote_male_rep), bylabel (Vote) ///
	|| , drop(_cons) xline(0)  legend(rows(1)) byopts(cols(1)) ysize(5.25) xsize (4) saving (Figure4_study1, replace)
graph export Figure4_study1.eps, replace 
graph export Figure4_study1.tif, width(1800)replace 	

*Femtraits - dem male to dem female 
quietly eststo est12: reg femtraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est13: reg femtraits_combined agentic2 communal2 if male == 1 & democrat == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Femtraits -  dem female to rep female
quietly eststo est12: reg femtraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est13: reg femtraits_combined agentic2 communal2 if female == 1 & republican == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Femtraits -  dem female to rep male
quietly eststo est12: reg femtraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est13: reg femtraits_combined agentic2 communal2 if male == 1 & republican == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Fem traits -  rep female to rep male
quietly eststo est12: reg femtraits_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo est13: reg femtraits_combined agentic2 communal2 if male == 1 & republican == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Masc traits - dem male to dem female 
quietly eststo est12: reg mastraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est13: reg mastraits_combined agentic2 communal2 if male == 1 & democrat == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Masc traits -  dem female to rep female
quietly eststo est12: reg mastraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est13: reg mastraits_combined agentic2 communal2 if female == 1 & republican == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Masc traits -  dem female to rep male
quietly eststo est12: reg mastraits_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est13: reg mastraits_combined agentic2 communal2 if male == 1 & republican == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

*Masc traits -  re female to rep male
quietly eststo est12: reg mastraits_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo est13: reg mastraits_combined agentic2 communal2 if male == 1 & republican == 1
suest est12 est13
test [est12_mean]agentic2=[est13_mean]agentic2
test [est12_mean]communal2=[est13_mean]communal2
eststo clear

* Vote- fem dem and male dem
quietly eststo est14: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est15:  reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
suest est14 est15 
test [est14_mean]agentic2=[est15_mean]agentic2
test [est14_mean]communal2=[est15_mean]communal2
eststo clear

* Vote - fem dem to fem rep
quietly eststo est14: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est15:  reg vote_combined agentic2 communal2 if female == 1 & republican == 1
suest est14 est15 
test [est14_mean]agentic2=[est15_mean]agentic2
test [est14_mean]communal2=[est15_mean]communal2
eststo clear

quietly eststo est14: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est15:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1
suest est14 est15 
test [est14_mean]agentic2=[est15_mean]agentic2
test [est14_mean]communal2=[est15_mean]communal2
eststo clear

quietly eststo est14: reg vote_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo est15:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1
suest est14 est15 
test [est14_mean]agentic2=[est15_mean]agentic2
test [est14_mean]communal2=[est15_mean]communal2
eststo clear


* Study 2: Issue Study Data 

clear 
set more off 

use "Issue Attack Study Data.dta"


**** cleaning *** 

recode citizen 2 = 0
recode gender 2=1 1=0
recode hispanic 2 = 0
recode check2 2=0

recode vote_patricia 7=1 6=2 5=3 3=5 2=6 1=7
recode vote_patrick 7=1 6=2 5=3 3=5 2=6 1=7
recode vote_hepner  7=1 6=2 5=3 3=5 2=6 1=7
recode vote_hepner2 7=1 6=2 5=3 3=5 2=6 1=7
recode favor_patricia  7=1 6=2 5=3 3=5 2=6 1=7
recode favor_patrick 7=1 6=2 5=3 3=5 2=6 1=7
recode favor_hepner  7=1 6=2 5=3 3=5 2=6 1=7
recode favor_hepner2  7=1 6=2 5=3 3=5 2=6 1=7
recode leader_patricia  7=1 6=2 5=3 3=5 2=6 1=7
recode leader_patrick 7=1 6=2 5=3 3=5 2=6 1=7
recode  leader_hepner  7=1 6=2 5=3 3=5 2=6 1=7
recode leader_hepner2  7=1 6=2 5=3 3=5 2=6 1=7


gen comm_agen = 0
replace comm_agen = 1 if female_d_agen == 1
replace comm_agen = 1 if male_d_agen == 1
replace comm_agen = 1 if male_r_agen == 1
replace comm_agen = 1 if female_r_agen == 1
replace comm_agen = 2 if female_r_comm == 1
replace comm_agen = 2 if female_d_comm == 1
replace comm_agen = 2 if male_d_comm == 1
replace comm_agen = 2 if male_r_comm == 1
tab comm_agen
recode comm_agen 0=.
replace comm_agen = 0 if male_r_control == 1
replace comm_agen = 0 if male_d_control == 1
replace comm_agen = 0 if female_d_control == 1
replace comm_agen = 0 if female_r_control == 1
tab comm_agen

gen female = 0
replace female = 1 if female_d_comm == 1
replace female = 1 if female_r_comm == 1
replace female = 1 if female_r_agen == 1
replace female = 1 if female_d_agen == 1
replace female = 1 if female_d_control == 1
replace female = 1 if female_r_control == 1
replace female = . if comm_agen == .

gen condition = .
replace condition = 1 if female_d_comm == 1
replace condition = 2 if female_r_comm == 1
replace condition = 3 if female_r_agen == 1
replace condition = 4 if female_d_agen == 1
replace condition = 5 if female_d_control == 1
replace condition = 6 if female_r_control == 1
replace condition = 7 if male_d_comm == 1
replace condition = 8 if male_r_comm == 1
replace condition = 9 if male_r_agen == 1
replace condition = 10 if male_d_agen == 1
replace condition = 11 if male_d_control == 1
replace condition = 12 if male_r_control == 1
replace condition = . if comm_agen == .

gen republican = 0
replace republican = 1 if condition == 2
replace republican = 1 if condition == 3
replace republican = 1 if condition == 6
replace republican = 1 if condition == 8
replace republican = 1 if condition == 9
replace republican = 1 if condition == 12

gen democrat = 0
replace democrat = 1 if condition == 1
replace democrat = 1 if condition == 4
replace democrat = 1 if condition == 5
replace democrat = 1 if condition == 7
replace democrat = 1 if condition == 10
replace democrat = 1 if condition == 11


gen male = 0
replace male = 1 if female == 0


mlogit condition citizen age pid ideology gender interest_politics reg_vote vote_2012 hispanic income education n_children

**** generating combination variables across the conditions ****

egen vote1 = rowtotal ( vote_patricia vote_patrick)
egen vote2 = rowtotal ( vote_hepner vote_hepner2)
egen favor1 = rowtotal ( favor_patricia favor_patrick)
egen favor2 = rowtotal ( favor_hepner favor_hepner2)
egen ideo1 = rowtotal ( ideo_patricia ideo_patrick)
egen ideo2 = rowtotal ( ideo_hepner ideo_hepner2)
egen leader1 = rowtotal ( leader_patricia leader_patrick)
egen leader2 = rowtotal ( leader_hepner leader_hepner2)

gen vote_combined=vote_patricia
replace vote_combined=vote_patrick if vote_combined==.


*** resp characteristics ****

gen r_dem = 0
replace r_dem = 1 if pid <4
gen r_rep = 0
replace r_rep = 1 if pid >4
rename race_other race_other_text
gen white = 0
replace white = 1 if race == 1
gen black = 0
replace black = 1 if race == 2
gen asian = 0
replace asian = 1 if race == 3
gen race_other = 0
replace race_other = 1 if race >= 4

recode reg_vote 3 = . 2=0
recode vote_2012 3 = . 2=0 

gen liberal = 0
replace liberal = 1 if ideology <4
gen conservative = 0
replace conservative = 1 if ideology >4


gen communal = 0
replace communal = 1 if comm_agen == 2
replace communal = . if comm_agen == 1

gen agentic = 0
replace agentic = 1 if comm_agen == 1
replace agentic = . if comm_agen == 2
gen communal2 = communal
recode communal2 .=0

gen agentic2 = agentic
recode agentic2 .=0

*********** factor analysis of issue capacity ***********

factor education_patricia natsec_patricia crime_patricia welfare_patricia trans_patricia budget_patricia child_patricia tax_patricia health_patricia immigration_patricia
rotate, varimax horst blanks(.3)
predict patricia_isfactor1 patricia_isfactor2

factor education_patrick natsec_patrick crime_patrick welfare_patrick trans_patrick budget_patrick child_patrick tax_patrick health_patrick immigration_patrick
rotate, varimax horst blanks(.3)
predict patrick_isfactor1 patrick_isfactor2


**** creating standardized composite ****


gen ztrait1_patricia = (trait1_patricia-r(mean))/r(sd)

sum trait2_patricia 
gen ztrait2_patricia = (trait2_patricia-r(mean))/r(sd)

sum trait3_patricia 
gen ztrait3_patricia = (trait3_patricia-r(mean))/r(sd)

sum trait4_patricia 
gen ztrait4_patricia = (trait4_patricia-r(mean))/r(sd)

alpha ztrait2_patricia ztrait3_patricia ztrait4_patricia 
egen zfem_traits_patricia = rowmean (ztrait2_patricia ztrait3_patricia ztrait4_patricia)
sum zfem_traits_patricia
replace zfem_traits_patricia = (zfem_traits_patricia-r(mean))/r(sd)
sum zfem_traits_patricia

gen ztrait1_patrick = (trait1_patrick-r(mean))/r(sd)

sum trait2_patrick 
gen ztrait2_patrick = (trait2_patrick-r(mean))/r(sd)

sum trait3_patrick 
gen ztrait3_patrick = (trait3_patrick-r(mean))/r(sd)

sum trait4_patrick 
gen ztrait4_patrick = (trait4_patrick-r(mean))/r(sd)


alpha ztrait2_patrick ztrait3_patrick ztrait4_patrick 
egen zfem_traits_patrick = rowmean (ztrait2_patrick ztrait3_patrick ztrait4_patrick )
sum zfem_traits_patrick
replace zfem_traits_patrick = (zfem_traits_patrick-r(mean))/r(sd)
sum zfem_traits_patrick

oneway zfem_traits_patricia comm_agen, tab
oneway zfem_traits_patrick comm_agen, tab

oneway zfem_traits_patricia condition, tab
oneway zfem_traits_patrick condition, tab



*** generating composite of issue competence ****

sum education_patricia
gen zeducation_patricia = (education_patricia-r(mean))/r(sd)

sum welfare_patricia 
gen zwelfare_patricia = (welfare_patricia-r(mean))/r(sd)

sum child_patricia 
gen zchild_patricia= (child_patricia-r(mean))/r(sd)

sum health_patricia 
gen zhealth_patricia = (health_patricia-r(mean))/r(sd)

egen zfem_issues_patricia = rowmean (zeducation_patricia zwelfare_patricia zchild_patricia zhealth_patricia )

sum natsec_patricia
gen znatsec_patricia = (natsec_patricia-r(mean))/r(sd)

sum crime_patricia 
gen zcrime_patricia = (crime_patricia-r(mean))/r(sd)

sum trans_patricia 
gen ztrans_patricia= (trans_patricia-r(mean))/r(sd)

sum budget_patricia  
gen zbudget_patricia  = (budget_patricia-r(mean))/r(sd)

sum tax_patricia  
gen ztax_patricia  = (tax_patricia-r(mean))/r(sd)

sum immigration_patricia  
gen zimmigration_patricia  = (immigration_patricia-r(mean))/r(sd)

egen zmas_issues_patricia = rowmean (zimmigration_patricia ztax_patricia zbudget_patricia ztrans_patricia zcrime_patricia znatsec_patricia)
egen zmas2_issues_patricia = rowmean (zimmigration_patricia  zcrime_patricia znatsec_patricia)

sum education_patrick
gen zeducation_patrick = (education_patrick-r(mean))/r(sd)

sum welfare_patrick 
gen zwelfare_patrick = (welfare_patrick-r(mean))/r(sd)

sum child_patrick 
gen zchild_patrick= (child_patrick-r(mean))/r(sd)

sum health_patrick 
gen zhealth_patrick = (health_patrick-r(mean))/r(sd)

egen zfem_issues_patrick = rowmean (zeducation_patrick zwelfare_patrick zchild_patrick zhealth_patrick )

sum natsec_patrick
gen znatsec_patrick = (natsec_patrick-r(mean))/r(sd)

sum crime_patrick 
gen zcrime_patrick = (crime_patrick-r(mean))/r(sd)

sum trans_patrick 
gen ztrans_patrick= (trans_patrick-r(mean))/r(sd)

sum budget_patrick  
gen zbudget_patrick  = (budget_patrick-r(mean))/r(sd)

sum tax_patrick  
gen ztax_patrick  = (tax_patrick-r(mean))/r(sd)

sum immigration_patrick  
gen zimmigration_patrick  = (immigration_patrick-r(mean))/r(sd)

egen zmas_issues_patrick = rowmean (zimmigration_patrick ztax_patrick zbudget_patrick ztrans_patrick zcrime_patrick znatsec_patrick)
egen zmas2_issues_patrick = rowmean (zimmigration_patrick zcrime_patrick znatsec_patrick)


sum zfem_issues_patricia zmas_issues_patricia zfem_issues_patrick zmas_issues_patrick

oneway zfem_issues_patricia comm_agen, tab
oneway zmas_issues_patricia comm_agen, tab

oneway zfem_issues_patrick comm_agen, tab
oneway zmas_issues_patrick comm_agen, tab

oneway zfem_issues_patricia condition, tab
oneway zmas_issues_patricia condition, tab

oneway zfem_issues_patrick condition, tab
oneway zmas_issues_patrick condition, tab

oneway zmas2_issues_patricia condition, tab
oneway zmas2_issues_patrick condition, tab

gen control = 0
replace control = 1 if comm_agen == 0

drop zmas_issues_patrick
drop zmas_issues_patricia
egen zmas_issues_patrick = rmean (ztax_patrick zcrime_patrick znatsec_patrick)
egen zmas_issues_patricia = rmean (ztax_patricia zcrime_patricia znatsec_patricia)
gen masissues_combined= zmas_issues_patrick
replace masissues_combined = zmas_issues_patricia if masissues_combined==.


drop zfem_issues_patrick
drop zfem_issues_patricia
egen zfem_issues_patrick = rmean ( zeducation_patrick zwelfare_patrick zchild_patrick zhealth_patrick )
egen zfem_issues_patricia = rmean ( zeducation_patricia zwelfare_patricia zchild_patricia zhealth_patricia )
gen femissues_combined= zfem_issues_patrick
replace femissues_combined = zfem_issues_patricia if femissues_combined==.

gen femtraits_combined=zfem_traits_patricia
replace femtraits_combined=zfem_traits_patrick if zfem_traits_patricia==.


gen agentic_cond=1 if comm_agen==1
replace agentic_cond=0 if comm_agen==0 | comm_agen==2
gen communal_cond=1 if comm_agen==2 
replace communal_cond=0 if comm_agen==0 | comm_agen==1

gen agentic_republican=agentic_cond*republican
gen communal_republican=communal_cond*republican 

gen leader_combined=leader_patrick
replace leader_combined=leader_patricia if leader_patrick==.
gen zleader_combined=(leader_combined-3.96893)/1.33465 

gen favor_combined=favor_patrick
replace favor_combined=favor_patricia if favor_patrick==.
gen zfavor_combined=(favor_combined-3.82448)/1.409022


label variable femissues_combined "Female Issue Comp"
label variable masissues_combined "Male Issue Comp"
label variable communal_cond "Education Issue Attack"
label variable agentic_cond "Law and Order Issue Attack"
label variable republican "Republican candidate"
label variable agentic_republican  "Republican candidate * Masculine Issue Attack"
label variable communal_republican  "Republican candidate * Feminine Issue Attack"
label variable zfavor_combined "Favorability" 
label variable zleader_combined "Leadership evaluation" 
label variable agentic2 "Masc. Issue Attack"
label variable communal2 "Fem. Issue Attack" 

*** descriptive statistics for appendix  *** 


tabulate race
tabulate education
sum gender age 
tabulate income 

tabulate pid 
tabulate ideology

*** balance checks *** 

mlogit condition age gender pid income education race 


*** manipulation check *** 

tab check1
oneway check1 condition, tab
tab check2
oneway check2 condition, tab
tab check3 
oneway check3 condition, tab 


tab check1 if democrat == 1
oneway check1 condition  if democrat == 1, tab
tab check2  if democrat == 1
oneway check2 condition if democrat == 1, tab
tab check3  if democrat == 1
oneway check3 condition if democrat == 1, tab 


tab check1 if democrat == 1
oneway check1 condition if republican == 1, tab
tab check2  if democrat == 1
oneway check2 condition if republican == 1, tab
tab check3  if democrat == 1
oneway check3 condition if republican == 1, tab 



** hypothesis 1: do these attacks matter? *** 

* Figure 1 Models and Contrasts

eststo clear
reg femissues_combined agentic2 communal2 
test agentic2=communal2
reg masissues_combined agentic2 communal2
test agentic2=communal2
reg vote_combined agentic2 communal2 
test agentic2  = communal2 

eststo clear
quietly eststo femissues: reg femissues_combined agentic2 communal2 
quietly eststo masissues: reg masissues_combined agentic2 communal2
quietly eststo vote: reg vote_combined agentic2 communal2 
test agentic2  = communal2 

esttab using figure1_study2.rtf, nogap se b(%9.2f) starlevels(^ .10 * .05 ** .01 *** .001) r2(%9.2f) title("H1 Any effect" )label compress replace
coefplot (femissues, label(Fem. Issue Comp.)) (masissues, label(Masc. Issue Comp.)) (vote, label(Vote)) ///
	|| , drop(_cons) xline(0)  legend(position(6)) legend (row(1)) ysize(4.15) xsize (3.25)  saving (Figure1_study2, replace)
graph export Figure1_study2.eps, replace 
graph export Figure1_study2.tif, width(1800)replace 


*** hypothesis 2: do the attacks matter by party? *** 
* Figure 2 Models and Contrasts

eststo clear
reg femissues_combined agentic2 communal2 if democrat == 1
test agentic2  = communal2
reg femissues_combined agentic2 communal2 if republican == 1
test agentic2  = communal2
reg masissues_combined agentic2 communal2 if democrat == 1
test agentic2  = communal2
reg masissues_combined agentic2 communal2 if republican == 1
test agentic2  = communal2
reg vote_combined agentic2 communal2 if democrat == 1
test agentic2 = communal2
reg vote_combined agentic2 communal2 if republican == 1
test agentic2  = communal2


quietly eststo est1: reg femissues_combined agentic2 communal2 if democrat == 1
quietly eststo est2:  reg femissues_combined agentic2 communal2 if republican == 1
suest est1 est2
test [est1_mean]agentic2=[est2_mean]agentic2
test [est1_mean]communal2=[est2_mean]communal2

quietly eststo est3: reg masissues_combined agentic2 communal2 if democrat == 1
quietly eststo est4:  reg masissues_combined agentic2 communal2 if republican == 1
suest est3 est4
test [est3_mean]agentic2=[est4_mean]agentic2
test [est3_mean]communal2=[est4_mean]communal2

quietly eststo est5: reg vote_combined agentic2 communal2 if democrat == 1
quietly eststo est6: reg vote_combined agentic2 communal2 if republican == 1
suest est5 est6
test [est5_mean]agentic2=[est6_mean]agentic2
test [est5_mean]communal2=[est6_mean]communal2

eststo clear
quietly eststo femissues_democrat: reg femissues_combined agentic2 communal2 if democrat == 1
test agentic2  = communal2
quietly eststo femissues_republican:  reg femissues_combined agentic2 communal2 if republican == 1
test agentic2  = communal2
quietly eststo masissues_democrat: reg masissues_combined agentic2 communal2 if democrat == 1
test agentic2  = communal2
quietly eststo masissues_republican:  reg masissues_combined agentic2 communal2 if republican == 1
test agentic2  = communal2
quietly eststo vote_democrat: reg vote_combined agentic2 communal2 if democrat == 1
test agentic2 = communal2
quietly eststo vote_republican:  reg vote_combined agentic2 communal2 if republican == 1
test agentic2  = communal2

esttab using figure2_study2.rtf, nogap se b(%9.2f) starlevels(^ .10 * .05 ** .01 *** .001) r2(%9.2f) title("H2 Party x Attack" )label compress replace
coefplot (femissues_democrat, label (Dem. Cand.)) (femissues_republican,  label (Rep. Cand.))	, bylabel(Fem. Issue Comp.) || (masissues_democrat)	(masissues_republican)	, bylabel(Masc. Issue Comp.) || (vote_democrat)(vote_republican)	, bylabel(Vote) ///
	|| , drop(_cons) xline(0)  legend(rows(1)) byopts(cols(1)) ysize(5.25) xsize (4) saving (Figure2_study2, replace)
graph export Figure2_study2.eps, replace 
graph export Figure2_study2.tif, width(1800) replace 
*** hypothesis 3: do these attacks matter by gender *** 
* Figure 3 Models and Contrasts 

eststo clear 
reg femissues_combined agentic2 communal2 if female == 1
reg femissues_combined agentic2 communal2 if male == 1
reg masissues_combined agentic2 communal2 if female == 1
reg masissues_combined agentic2 communal2 if male == 1
reg vote_combined agentic2 communal2 if female == 1
test agentic2  = communal2
reg vote_combined agentic2 communal2 if male == 1
test agentic2  = communal2


quietly eststo est6: reg femissues_combined agentic2 communal2 if female == 1
quietly eststo est7:  reg femissues_combined agentic2 communal2 if male == 1
suest est6 est7
test [est6_mean]agentic2=[est7_mean]agentic2
test [est6_mean]communal2=[est7_mean]communal2

quietly eststo est8: reg masissues_combined agentic2 communal2 if female == 1
quietly eststo est9:  reg masissues_combined agentic2 communal2 if male == 1
suest est8 est9
test [est8_mean]agentic2=[est9_mean]agentic2
test [est8_mean]communal2=[est9_mean]communal2

quietly eststo est10: reg vote_combined agentic2 communal2 if female == 1
quietly eststo est11: reg vote_combined agentic2 communal2 if male == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2


	
eststo clear 
quietly eststo femissues_female: reg femissues_combined agentic2 communal2 if female == 1
quietly eststo femissues_male:  reg femissues_combined agentic2 communal2 if male == 1
quietly eststo masissues_female: reg masissues_combined agentic2 communal2 if female == 1
quietly eststo masissues_male:  reg masissues_combined agentic2 communal2 if male == 1
quietly eststo vote_female: reg vote_combined agentic2 communal2 if female == 1
test agentic2  = communal2
quietly eststo vote_male:  reg vote_combined agentic2 communal2 if male == 1
test agentic2  = communal2

esttab using figure3_study2.rtf, nogap se b(%9.2f) starlevels(^ .10 * .05 ** .01 *** .001) r2(%9.2f) title("H3 Gender x Attack" )label compress replace
coefplot (femissues_female, label (Female Cand.)) 	(femissues_male, label (Male Cand.)), bylabel(Feminine) || (masissues_female)(masissues_male), bylabel(Masculine) || (vote_female)(vote_male), bylabel(Vote) ///
	|| , drop(_cons) xline(0)  legend(rows(1)) byopts(cols(1)) ysize(5.25) xsize (4) saving (Figure3_study2, replace)
graph export Figure3_study2.eps, replace 
graph export Figure3_study2.tif, width(1800)replace 
*** hypothesis 4: do these attacks matter by party x gender? *** 

* Figure 4 Models and Contrasts 

eststo clear 
reg femissues_combined agentic2 communal2 if female == 1 & democrat == 1
reg femissues_combined agentic2 communal2 if male == 1 & democrat == 1

reg masissues_combined agentic2 communal2 if female == 1 & democrat == 1
reg masissues_combined agentic2 communal2 if male == 1 & democrat == 1

reg femissues_combined agentic2 communal2 if female == 1 & republican == 1
reg femissues_combined agentic2 communal2 if male == 1  & republican == 1

reg masissues_combined agentic2 communal2 if female == 1  & republican == 1
reg masissues_combined agentic2 communal2 if male == 1	 & republican == 1

eststo clear
quietly eststo est10: reg femissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg femissues_combined agentic2 communal2 if male == 1 & democrat == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg femissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg femissues_combined agentic2 communal2 if male == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg femissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg femissues_combined agentic2 communal2 if female == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg masissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg masissues_combined agentic2 communal2 if male == 1 & democrat == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg masissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg masissues_combined agentic2 communal2 if male == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg masissues_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo est11:  reg masissues_combined agentic2 communal2 if female == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg masissues_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo est11:  reg masissues_combined agentic2 communal2 if male == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear 
quietly eststo femissues_female_dem: reg femissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo femissues_male_dem:  reg femissues_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo masissues_female_dem: reg masissues_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo masissues_male_dem:  reg masissues_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo femissues_female_rep: reg femissues_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo femissues_male_rep:  reg femissues_combined agentic2 communal2 if male == 1  & republican == 1
quietly eststo masissues_female_rep: reg masissues_combined agentic2 communal2 if female == 1  & republican == 1
quietly eststo masissues_male_rep:  reg masissues_combined agentic2 communal2 if male == 1	 & republican == 1

quietly eststo vote_female_dem: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo vote_male_dem:  reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo vote_female_rep: reg vote_combined agentic2 communal2 if female == 1 & republican == 1
quietly eststo vote_male_rep:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1

esttab using figure4_study2.rtf, nogap se b(%9.2f) starlevels(^ .10 * .05 ** .01 *** .001) r2(%9.2f) title("H4 Gender x Party x Attack" )label compress replace

coefplot (femissues_female_dem, label (Female Dem.)) (femissues_male_dem, label (Male Dem.))	(femissues_female_rep, label (Female Rep.))	(femissues_male_rep, label (Male Rep.))	, bylabel(Fem. Issue Comp.) || (masissues_female_dem)(masissues_male_dem)(masissues_female_rep)(masissues_male_rep), bylabel(Masc. Issue Comp.) || (vote_female_dem) (vote_male_dem) (vote_female_rep) (vote_male_rep), bylabel(Vote) ///
	|| , drop(_cons) xline(0)  legend(rows(1)) byopts(cols(1)) ysize(5.25) xsize (4) saving (Figure4_study2, replace)
graph export Figure4_study2.eps, replace 
graph export Figure4_study2.tif, width(1800)replace 
	
reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
test agentic2 = communal2
reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
test agentic2 = communal2
reg vote_combined agentic2 communal2 if female == 1 & republican == 1
test agentic2 = communal2
reg vote_combined agentic2 communal2 if male == 1 & republican == 1
test agentic2 = communal2


eststo clear
quietly eststo est10: reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo est11:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg vote_combined agentic2 communal2 if female == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg vote_combined agentic2 communal2 if female == 1 & democrat == 1
quietly eststo est11:  reg vote_combined agentic2 communal2 if male == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2

eststo clear
quietly eststo est10: reg vote_combined agentic2 communal2 if male == 1 & democrat == 1
quietly eststo est11:  reg vote_combined agentic2 communal2 if female == 1 & republican == 1
suest est10 est11
test [est10_mean]agentic2=[est11_mean]agentic2
test [est10_mean]communal2=[est11_mean]communal2


*** ~ fin~ *** 
