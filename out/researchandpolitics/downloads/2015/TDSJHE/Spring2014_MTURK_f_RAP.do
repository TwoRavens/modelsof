clear all
set seed 0210
use "N:\Personal Research - Desirability of pork\Spring 2014 Exp Mturk\Spring2014_MTURK_f.dta", clear
*
*

qui {
drop v4 v5 v7
replace non_fl = 0 if non_fl==. 
label variable non_fl `"lat/long data says not from FL"'
*
destring zip, replace
replace non_fl = 1 if zip<30000 | zip >39000

*
gen male = 1 if sex_1 ==1
replace male=0 if male==.
order male, after(zip)
drop sex_1 sex_2
*
gen pid_dem = pid1_rep //1 = very strong rep, 2 less
replace pid_dem=7 if pid1_dem==1 //strong dem
replace pid_dem=6 if pid1_dem==2 //less str dem
replace pid_dem=3 if pid1_ind==1 //lean rep
replace pid_dem=5 if pid1_ind==2 //lean dem
replace pid_dem=4 if pid1_ind==3 //neither, middle
*
gen pid_dem7 = .
label variable pid_dem7 `"7 very strong dem, 1 very strong rep, 7-pt"'
replace pid_dem7 = 7 if pid1_dem==1
replace pid_dem7 = 6 if pid1_dem==2
replace pid_dem7 = 5 if pid1_ind==2
replace pid_dem7 = 4 if pid1_ind==3
replace pid_dem7 = 3 if pid1_ind==1
replace pid_dem7 = 2 if pid1_rep==2
replace pid_dem7 = 1 if pid1_rep==1
*
gen pid_dem5 = pid_dem
label variable pid_dem5 `"5 very strong dem, 1 very strong rep, 5-pt"'
recode pid_dem5 (7=5) (6=4) (4=3) (5=4) (3=2) 
*
rename interest interest_pol
label variable interest_pol `"how interested in politics, 5=extremely, 1 not at all"'
rename knowpol know_pol
label variable know_pol `"how knowledgeable about politics, 5=extremely, 1 not at all"'
label variable follownews `"how reg follow news about politics? 5= extr reg, 1=not at all"'
*
recode knowchrist (2=0) (3=0) (4=0)
recode knowvp (1=0) (2=1) (3=0) (4=0)
recode knoweuro (2=0) (3=0) (4=0)
recode know_china (1=0) (2=0) (3=1) (4=0)
gen polknow = (knowchrist+ knowvp +knoweuro +know_china)
label variable polknow `"4 political knowledge questions, 4 max, 0 min"'
*
recode rubio_gen (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
rename rubio_gen rubio_gen_fav 
recode rub_job1 (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
rename rub_job1 rubio_gen_job
*
recode rubio_mil (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
rename rubio_mil rubio_mil_fav
recode rub_job2 (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
rename rub_job2 rubio_mil_job
*
recode views_rubi (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
rename views_rubi rubio_ctrl_fav
recode rub_job3 (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
rename rub_job3 rubio_ctrl_job
*RUBIO Dep vars
egen rubio_fav = rowfirst(rubio_gen_fav rubio_mil_fav rubio_ctrl_fav)
egen rubio_job = rowfirst(rubio_gen_job rubio_mil_job rubio_ctrl_job)
*
gen rubio_gen =.
replace rubio_gen= 1 if rubio_gen_fav~=.
replace rubio_gen=0 if rubio_gen==.
gen rubio_mil =.
replace rubio_mil=1 if rubio_mil_fav~=.
replace rubio_mil=0 if rubio_mil==.
gen rubio_ctrl = .
replace rubio_ctrl = 1 if rubio_ctrl_fav~=.
replace rubio_ctrl=0 if rubio_ctrl==.
*
label variable rubio_fav `"views of rubio, all conditions, 7=extreme fav"'
label variable rubio_job `"views of rubio for job, all conditions, 7=max"'
label variable rubio_gen `"general pork condition, rubio=1"'
label variable rubio_mil `"military pork condition, rubio = 1"'
label variable rubio_ctrl `"control for rubio, no pork, =1"'
*
recode nelon_gen (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
recode nel_job1 (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
recode nel_educ (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
recode nel_job2 (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
recode nelson_ctr (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
recode nel_job3 (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
*
egen nelson_fav =rowfirst(nelon_gen nel_educ nelson_ctr)
egen nelson_job =rowfirst(nel_job1 nel_job2 nel_job3)
*
gen nelson_gen =.
replace nelson_gen=1 if nelon_gen~=.
replace nelson_gen=0 if nelson_gen==.
gen nelson_educ=.
replace nelson_educ=1 if nel_educ~=.
replace nelson_educ=0 if nelson_educ==.
gen nelson_ctrl=.
replace nelson_ctrl=1 if nelson_ctr~=.
replace nelson_ctrl=0 if nelson_ctrl==.
*
label variable nelson_fav `"views of nelson, all conditions, 7 max"'
label variable nelson_job `"views of nelsons job, all conditions, 7 max"'
label variable nelson_gen `"general pork treatment, nelson =1"'
label variable nelson_educ `"educ pork treatment, nelson=1"'
label variable nelson_ctrl `"control condition, nelson =1"'
*
rename anim2 animals
rename anim1 animals_important //5 max important
recode animals (1=0) (2=1) //member of family with animals
*
rename agri1 agricul
rename agri2 agricul_important
*
rename higher1 higher_support //5 max
gen highered = higher_support
recode highered (5=1) (4=1) (3=0) (2=0) (1=0) //binary
*alternative higher ed that includes 3
gen highered3 = higher_support
recode highered3 (5=1) (4=1) (3=1) (2=0) (1=0) //binary
*
rename def2 defense 
rename def1 defense_important //5 max important
recode defense (1=0) (2=1)
*
gen def = defense_important
recode def (5=1) (4=1) (3=0) (2=0) (1=0)
label variable def `"1 = defense is important 0 if not (collapsed from 4&5 =1, other 0)"'
gen def2 = defense_important
recode def2 (5=1) (4=1) (3=1) (2=0) (1=0)
label variable def2 `"1 = defense is important 0 if not (collapsed from 3&4&5 =1, other 0)"'
*
recode vote_reg (2=1) (1=0)
rename age  temp
gen age = 2014-temp
recode college (2=1) (1=0)
label variable college `"1= yes currently enrolled in college"'
*
label variable race `"1=white, 2=blk, 3=asian,4=native am, 5= hispan,6=other/mix"'
label variable educ `"1=HS or less, 2=1year college, ... 7= more than 5 yrs colege"'
label variable vote_reg `"1=yes, 0=no"'
*
*time

gen double start = clock(startdate, "MDYhm")
gen double end = clock(enddate, "MDYhm")
gen timediff = end-start
gen slowpoke = 0
replace slowpoke = 1 if timediff>=1260000
}
* RUBIO and NELSON merged variables
*can they be merged? mann-whitney
alpha rubio_fav rubio_job //yes .924
alpha nelson_fav nelson_job //yes .9334
pwcorr nelson_fav nelson_job, sig
pwcorr rubio_fav rubio_job, sig
*generate the dep vars
gen rubio = (rubio_fav+rubio_job)/2
gen nelson = (nelson_fav+nelson_job)/2


*****************************************
*	the MODELS 	Sen. NELSON     *
******************************
***** MODEL 1 BELOW *****
gen collXnelson = college*nelson_educ
reg nelson nelson_gen nelson_educ college collXnelson
est sto coll
test nelson_gen = nelson_educ+college+collXnelson
***** MODEL 2 BELOW ******
gen higheredXnel = highered*nelson_educ
reg nelson nelson_gen nelson_educ highered higheredXnel
est sto high
test nelson_gen = nelson_educ+highered+higheredXnel
*
estout coll high, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
*
*************************************************
* Sen. RUBIO		 THE MODELS
*********************************************************
*
*coding of military affil. and defense important
gen defimportXrubio = rubio_mil*def
gen defimport2Xrubio = rubio_mil*def2
*******************************
*   			 THE MODEL 				**
******************************
reg rubio rubio_gen rubio_mil def defimportXrubio //military affiliation
est sto rubiomil
*
reg rubio rubio_gen rubio_mil def2 defimport2Xrubio //military important
est sto rubiodef
*
estout rubiomil rubiodef, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
* FOR FIRGURE*************
set seed 0210
qui estsimp reg rubio rubio_gen rubio_mil def defimportXrubio, sims(2000)
setx min
simqi, fd(ev) changex(rubio_gen 0 1) //general -.0522 se .2900
simqi, fd(ev) changex(rubio_mil 0 1) //not in mil got treatment; 0.1505 se .4201
simqi, fd(ev) changex(rubio_mil 0 1 def 0 1 defimportXrubio 0 1) //in mil, treatment 2.4599 se .3843
*
drop b*
set seed 0210
qui estsimp reg rubio rubio_gen rubio_mil def2 defimport2Xrubio, sims(2000) //military important
setx min
simqi, fd(ev) changex(rubio_gen 0 1) //general -.1319 se .2969
simqi, fd(ev) changex(rubio_mil 0 1) //not in mil got treatment; -.8036 se .5955
simqi, fd(ev) changex(rubio_mil 0 1 def2 0 1 defimport2Xrubio 0 1) //in mil, treatment 2.0407 se .4657
*
*
****** hyp 3 f-test ******
*test equilency
reg rubio rubio_gen rubio_mil def defimportXrubio
test rubio_gen=rubio_mil+def+defimportXrubio //diff 1,156 f 46.32 .0000
*
reg rubio rubio_gen rubio_mil def2 defimport2Xrubio
test rubio_gen = rubio_mil +def2 +defimport2Xrubio //dif 1,156 23.45 0.000
*
***************************************************
*Supplemental and Appendix for Nelson
*****************************************************
*demographics
sum nelson pid_dem5 college collXnelson male polknow age educ race highered ///
highered3 
*with higher ed support being 3, 4 and 5
gen highered3Xnel = highered3*nelson_educ
reg nelson nelson_gen nelson_educ highered3 highered3Xnel
est sto high3
**party X treatment interactions 5-point
gen genI  = pid_dem5*nelson_gen //general treatment *party ID
gen educI = pid_dem5*nelson_educ //education treatment * party ID
gen collI = college*pid_dem5 //college enrolled * party ID
gen highI = highered*pid_dem5 //higher ed is important * party ID
gen coll_nel_pidI = college*nelson_educ*pid_dem5 //3-way interaction for college
gen high_nel_pidI = highered*nelson_educ*pid_dem5 // 3-way interaction for higher ed
*first to test the college enrolled and party ID interactions
reg nelson nelson_gen nelson_educ college collXnelson pid_dem5 genI educI collI coll_nel_pidI
est sto collegeI
estsimp reg nelson nelson_gen nelson_educ college collXnelson pid_dem5 genI educI collI coll_nel_pidI, sims(2000) 
/*signifcant, but the constitutient variables aren't, so let's test the MGFX */
setx min
setx nelson_educ 1 college 1 collXnelson 1 
simqi, fd(ev) changex(pid_dem5 1 5 educI 1 5 coll_nel_pidI 1 5)
/* we can see the confidence intervals around these estimates show that 
there is not significant difference between Dems and Repubs */
*and for higher ed, 5-point
reg nelson nelson_gen nelson_educ highered higheredXnel pid_dem5 genI educI highI high_nel_pidI //not significant
est sto higherI
estout collegeI higherI, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
*
*disaggregate the dep var into two
*NELSON
global vars nelson_gen nelson_educ college collXnelson 
reg nelson $vars //original
reg nelson_fav $vars
est sto NelFav
reg nelson_job $vars
est sto NelJob
estout NelFav NelJob, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
* 
*disaggregate the dependent variable
reg nelson_fav nelson_gen nelson_educ college collXnelson
est sto fav
reg nelson_job nelson_gen nelson_educ college collXnelson
est sto job
*disaggregate for higher education 
reg nelson_fav nelson_gen nelson_educ highered higheredXnel
est sto fav2
reg nelson_job nelson_gen nelson_educ highered higheredXnel
est sto job2
*ordered probit models - Nelson
oprobit nelson nelson_gen nelson_educ college collXnelson
est sto ordered
oprobit nelson_fav nelson_gen nelson_educ college collXnelson
est sto order_fav
oprobit nelson_job nelson_gen nelson_educ college collXnelson
est sto order_job
estout fav job fav2 job2 ordered order_fav order_job, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
*
*test equilency
reg nelson nelson_gen nelson_educ college collXnelson 
test nelson_gen=nelson_educ+college+collXnelson //diff 1,154 5.60 0.0192
*
reg nelson nelson_gen nelson_educ highered higheredXnel
test nelson_gen = nelson_educ+highered+higheredXnel //dif 1,155 7.21 0.0080
*
*ensure random assignment - NELSON
*Hotelling’s T-squared test of whether a set of means is zero or, alternatively, equal between two groups.
hotelling pid_dem5 race educ male follownews interest_pol know_pol, by(nelson_gen)
hotelling pid_dem5 race educ male follownews interest_pol know_pol, by(nelson_educ)
hotelling pid_dem5 race educ male follownews interest_pol know_pol, by(nelson_ctrl)
mprobit pid_dem5 nelson_gen nelson_educ, base(4)
*to get an F test of the null that all means are the same...this is the same as above //
*just hit dis e(F) and notice the F statistic is the same
probit nelson_gen pid_dem5 know_pol interest_pol male num_survey race defense college vote_reg follownews 
est sto g
probit nelson_educ pid_dem5 know_pol interest_pol male num_survey race defense college vote_reg follownews 
est sto e
probit nelson_ctrl pid_dem5 know_pol interest_pol male num_survey race defense college vote_reg follownews 
est sto c
estout g e c , style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(* 0.05 ** 0.01 *** 0.001) delimiter(;)
***************************************
* MGFX *
****************************************************
set seed 0210
*
*mgfx
estsimp reg nelson nelson_gen nelson_educ college collXnelson, sims(2500)
setx nelson_gen 0 nelson_educ 0 college 0 collXnelson 0
simqi, fd(ev) changex(nelson_educ 0 1)
simqi, fd(ev) changex(nelson_educ 0 1 college 0 1 collXnelson 0 1)
*for the figure: 1.157067 se = 0.39999
*educ NOT in college = -.0226455 .2787447
*general: .188213 .262194

/* confirm with margins command
reg nelson nelson_gen i.nelson_educ i.college i.college#i.nelson_educ
margins, at(nelson_gen=(0) college=(1) nelson_educ=(1))
margins, at(nelson_gen=(0) college=(0) nelson_educ=(0)) //yep
*/
*mgfx higher ed
drop b1-b5
drop b6
estsimp reg nelson nelson_gen nelson_educ highered higheredXnel, sims(2500)
setx nelson_gen 0 nelson_educ 0 highered 0 higheredXnel 0
simqi, fd(ev) changex(nelson_educ 0 1)
simqi, fd(ev) changex(nelson_educ 0 1 highered 0 1 higheredXnel 0 1)
*figure: 1.260615 se = 0.0405824
*educ NOT higher ed = -.10909 .281995
* general: .1458005 .258945

***********************************
* APPENDIX - Rubio 
***********************************
gen rubio_genI = rubio_gen*pid_dem5
gen rubio_milI = rubio_mil*pid_dem5
gen defI = def*pid_dem5
gen def2I = def2*pid_dem5
gen threeway_serve = rubio_mil*pid_dem5*def
gen threeway_important = rubio_mil*pid_dem5*def2
*
reg rubio rubio_gen rubio_mil def defimportXrubio pid_dem5 rubio_genI rubio_milI defI threeway_serve //not significant
est sto serveI
reg rubio rubio_gen rubio_mil def2 defimport2Xrubio pid_dem5 rubio_genI rubio_milI def2I threeway_important //not significant
est sto importI

estout serveI importI , style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(* 0.05 ** 0.01 *** 0.001) delimiter(;)
*
drop b*
estsimp reg rubio $rubio_pork defimportXrubio pid_dem5 rubio_genI rubio_milI threeway_serve, sims(2000)
setx min
simqi, fd(ev) changex(pid_dem5 1 5 rubio_milI 1 5 threeway_serve 1 5) //in treatment, Rep to Dem
*
drop b*
estsimp reg rubio $rubio_pork defimport2Xrubio pid_dem5 rubio_genI rubio_milI threeway_important, sims(2000)
setx min
simqi, fd(ev) changex(pid_dem5 1 5 rubio_milI 1 5 threeway_important 1 5) //in treatment, Rep to Dem

*
*disaggregate rubio dep var
*rubio_fav+rubio_job
reg rubio_fav rubio_gen rubio_mil def defimportXrubio //military afflication
est sto rubiofav_mil
reg rubio_job rubio_gen rubio_mil def defimportXrubio //military afflication
est sto rubiojob_mil
*national defense
reg rubio_fav rubio_gen rubio_mil def2 defimport2Xrubio //military important
est sto rubiofav_def
reg rubio_job rubio_gen rubio_mil def2 defimport2Xrubio //military important
est sto rubiojob_def
estout rubiofav_mil rubiojob_mil rubiofav_def rubiojob_def, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
*
*ordered rubio
reg rubio rubio_gen rubio_mil def defimportXrubio //military afflication
est sto rubio1
oprobit rubio rubio_gen rubio_mil def defimportXrubio
est sto rubio1o
reg rubio rubio_gen rubio_mil def2 defimport2Xrubio //military important
est sto rubio2
oprobit rubio rubio_gen rubio_mil def2 defimport2Xrubio
est sto rubio2o
estout rubio1 rubio1o rubio2 rubio2o, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)

* 
*Random assignment Rubio
*RUIBO
hotelling pid_dem5 race educ male follownews interest_pol know_pol, by(rubio_gen)
hotelling pid_dem5 race educ male follownews interest_pol know_pol, by(rubio_mil)
hotelling pid_dem5 race educ male follownews interest_pol know_pol, by(rubio_ctrl)
*to get an F test of the null that all means are the same...this is the same as above //
*just hit dis e(F) and notice the F statistic is the same
probit rubio_gen pid_dem5 know_pol interest_pol male num_survey race defense college vote_reg follownews 
est sto x
probit rubio_mil pid_dem5 know_pol interest_pol male num_survey race defense college vote_reg follownews 
est sto y
probit rubio_ctrl pid_dem5 know_pol interest_pol male num_survey race defense college vote_reg follownews 
est sto z
estout x y z , style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(* 0.05 ** 0.01 *** 0.001) delimiter(;)
*
*summary stats rubio
sum rubio rubio_fav rubio_job rubio_gen rubio_mil rubio_ctrl pid_dem5 def def2
