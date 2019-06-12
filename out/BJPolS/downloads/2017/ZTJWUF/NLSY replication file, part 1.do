****
****
****	NLSY Replication File, Part 1
****
****
****	Health and Voting in Young Adulthood	
****
****	Ojeda and Pacheco
****
****	BJPS 2017
****
****
****
****	Table of Contents
****
****	- Working directory/data read in
****
****	- Time-invariant HEALTH variables 
****
****	- Correlation of health variables
****
****	- Time-invariant CONTROL variables
****
****	- Saving and merging data
****
****	- Long data data prep
****
****	- Saving final data
****


cd "put pathname here"
use "nlsy97_wide.dta", clear


******************************************************************************
********* Section 1: Data Prep

**
** Time-invariant HEALTH variables

/*Here we create time invariant variables based on the wide data
that can later be merged into a reshaped data in the long format*/

* Birth year
gen year18=byear97+18

*Chronic diagnosses/physical limitations
gen limit02=0
replace limit02=1 if chronic_limit1_02>1 | chronic_limit2_02>1 | chronic_limit3_02>1 | chronic_limit4_02>1 | chronic_limit5_02>1 | chronic_limit6_02>1 | chronic_limit7_02>1 | chronic_limit8_02>1 | chronic_limit9_02>1 
gen limit08=0
replace limit08=1 if chronic_limit1_08>1 | chronic_limit2_08>1 | chronic_limit3_08>1 | chronic_limit4_08>1 | chronic_limit5_08>1 | chronic_limit6_08>1 | chronic_limit8_08>1 | chronic_limit9_08>1 

*Without asthma
gen limit_noa02=0
replace limit_noa02=1 if chronic_limit2_02>1 | chronic_limit3_02>1 | chronic_limit4_02>1 | chronic_limit5_02>1 | chronic_limit6_02>1 | chronic_limit7_02>1 | chronic_limit8_02>1 | chronic_limit9_02>1 
gen limit_noa08=0
replace limit_noa08=1 if chronic_limit2_08>1 | chronic_limit3_08>1 | chronic_limit4_08>1 | chronic_limit5_08>1 | chronic_limit6_08>1 | chronic_limit8_08>1 | chronic_limit9_08>1 

*SRHS
gen srhs04=health_self04

*Depression
alpha cesd1_00 cesd2_00 cesd3_00 cesd4_00 cesd5_00, std detail gen(depress00)
alpha cesd1_02 cesd2_02 cesd3_02 cesd4_02 cesd5_02, std detail gen(depress02)
alpha cesd1_04 cesd2_04 cesd3_04 cesd4_04 cesd5_04, std detail gen(depress04)
alpha cesd1_06 cesd2_06 cesd3_06 cesd4_06 cesd5_06, std detail gen(depress06)
alpha cesd1_08 cesd2_08 cesd3_08 cesd4_08 cesd5_08, std detail gen(depress08)
alpha cesd1_10 cesd2_10 cesd3_10 cesd4_10 cesd5_10, std detail gen(depress10)

gen depress_dif = (depress10-depress04)/depress04


**
** Correlation of Health Measures (2002)
pwcorr depress02 health_self02 limit02 [aw=weight_panel02]
tab health_self02 [aw=weight_panel02], sum(depress02)
tab health_self02 [aw=weight_panel02], sum(limit02)


**
** Time-invariant CONTROL Variables 

*Parental education
alpha educ_biomom educ_biodad educ_resmom educ_resdad, std detail gen(parented)

**Marital status
drop married04
gen married04=0
replace married04=1 if marital04==3 | marital04==4

gen divorce04=0
replace divorce04=1 if marital04==5 | marital04==6 | marital04==7| marital04==8

*Parenthood
gen parent04=child04

*School GPA
gen gpa=school_gpa99

*Residential migration
gen migrate04=migrate_dum04

*Family income
gen inc96 = inc10_96


**
** Saving and merging data

*Saving for long-format reshape
save "nlsy97_time_invariant2.dta", replace

*Saving time-invariant variables to merge into long data
keep case_id gpa educ04 age04 limit02 limit08 depress04 parented ///
 parent04 pol_int04 srhs04 married04 divorce04 migrate04 inc96 limit_noa02 limit_noa08
sort case_id
save "nlsy97_time_invariant.dta", replace

*Reshaping DEPRESSION data into long format
use "nlsy97_time_invariant2.dta", clear
reshape long depress, i(case_id) j(year,string)

gen year2 = .
replace year2 = 1994 if year == "94"
replace year2 = 1995 if year == "95"
replace year2 = 1996 if year == "96"
replace year2 = 1997 if year == "97"
replace year2 = 1998 if year == "98"
replace year2 = 1999 if year == "99"
replace year2 = 2000 if year == "00"
replace year2 = 2001 if year == "01"
replace year2 = 2002 if year == "02"
replace year2 = 2003 if year == "03"
replace year2 = 2004 if year == "04"
replace year2 = 2005 if year == "05"
replace year2 = 2006 if year == "06"
replace year2 = 2007 if year == "07"
replace year2 = 2008 if year == "08"
replace year2 = 2009 if year == "09"
replace year2 = 2010 if year == "10"
replace year2 = 2011 if year == "11"
drop year
rename year2 year
sort case_id year
order case_id year, first

keep case_id year depress
sort case_id year
save "nlsy97_time_varying_depress.dta", replace


*Merging TIME-INVARIANT and long DEPRESSION/POLITICAL ENGAGEMENT data with LONG data
use "nlsy97_long.dta", clear 
merge m:1 case_id using "nlsy97_time_invariant.dta"
drop _merge
sort case_id year
drop if year == .
by case_id year: gen dup = cond(_N==1,0,_n)
tab dup
merge 1:1 case_id year using "nlsy97_time_varying_depress.dta"


****
**** Long data data prep
****

*Election variables
gen election=.
replace election=0 if year==2004
replace election=1 if year==2006
replace election=2 if year==2008
replace election=3 if year==2010

drop if election==.

gen midterm=0
replace midterm=1 if election==1 | election==3

*Age (centering at 22)
gen cage04=age04-22
gen cage=age-22

*Education (centering 2004 status at 12 years)
gen ceduc04=educ04-12
gen ceduc=educ-12

*Depression (mean-centering)
gen cdepress04=depress04-.000132
gen cdepress=depress-.0000958

*Parental education (mean-centering)
gen cparented=parented--.0368932

*Fixing marital status
drop married
gen married=0
replace married=1 if marital==3 | marital==4

gen divorce=0
replace divorce=1 if marital==5 | marital==6 | marital==7| marital==8

*Fixing race
gen black=0
replace black=1 if race==2

gen other=0
replace other=1 if race>=3

*School GPA (mean-centering)
gen cgpa=gpa-2.818408

*Parenthood
gen parent=child


**
** HEALTH VARIABLES

*SRHS

/*four categories of health
0=excellent/verygood
1=good
2=fair
3=poor
*/

gen health04=.
replace health04=0 if srhs04==4 | srhs04==3
replace health04=1 if srhs04==2
replace health04=2 if srhs04==1
replace health04=3 if srhs04==0

rename health_self srhs
gen health=.
replace health=0 if srhs==4 | srhs==3
replace health=1 if srhs==2
replace health=2 if srhs==1
replace health=3 if srhs==0

recode health04 health (0=4) (1=3)(2=2) (3=1) (4=0)


**
** SAVING FINAL DATA
label drop _all
keep case_id black other female cparented inc96 cgpa cage04 ///
ceduc04 ceduc pol_int04 pol_int married04 married divorce04 ///
divorce parent04 parent migrate04 migrate_dum election midterm ///
limit02 limit08 cdepress04 cdepress health04 health limit_noa02 limit_noa08 pol_vote
saveold "dataforr_12.dta", version(12) replace
saveold "dataforr_12_new.dta", version(12) replace


****
**** Graphs of Results
****

**
** VOTER TURNOUT GRAPH

clear
set obs 4
gen year = .
replace year = 2004 if _n == 1
replace year = 2006 if _n == 2
replace year = 2008 if _n == 3
replace year = 2010 if _n == 4

gen turnout = .
replace turnout = 58.47 if _n == 1
replace turnout = 35.62 if _n == 2
replace turnout = 63.61 if _n == 3
replace turnout = 43.17 if _n == 4

gen turnout_str = "."
replace turnout_str = "58%" if _n == 1
replace turnout_str = "36%" if _n == 2
replace turnout_str = "64%" if _n == 3
replace turnout_str = "43%" if _n == 4

gen turnout1 = .
replace turnout1 = 58.47 if _n == 1

gen turnout2 = .
replace turnout2 = 35.62 if _n == 2

gen turnout3 = .
replace turnout3 = 63.61 if _n == 3

gen turnout4 = .
replace turnout4 = 43.17 if _n == 4

gen n_var = .
replace n_var = 1 if _n == 1
replace n_var = 2.2 if _n == 2
replace n_var = 3.4 if _n == 3
replace n_var = 4.6 if _n == 4


twoway(bar turnout1 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(bar turnout2 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(bar turnout3 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(bar turnout4 n_var, barwidth(0.75) lcolor(black) color(gs4)) ///
		(scatter turnout n_var, msymbol(i) mlabel(turnout_str) mlabposition(12) mlabsize(3)), ///
		title("Figure 1: Reported Turnout in Each Election, NLSY97") ///
		legend(off) ///
		yscale(off) ///
		ylabel(0 10 20 30 40 50 60 70 80, labsize(2.5) angle(horizontal) nogrid) ///
		xlabel(1 "2004" 2.2 "2006" 3.4 "2008" 4.6 "2010", notick angle(45) labgap(3)) ///
		xtitle("") ///
		scheme(s2mono) graphregion(fcolor(white))
		





**
** DEPRESSION GRAPH

clear
set obs 4
gen year = .
replace year = 2004 if _n == 1
replace year = 2006 if _n == 2
replace year = 2008 if _n == 3
replace year = 2010 if _n == 4
	
gen worsen = .
replace worsen = 0.132806264 if _n == 1		
replace worsen = 0.023248025 if _n == 2	
replace worsen = 0.116365633 if _n == 3	
replace worsen = 0.020056381 if _n == 4			

gen improve = .
replace improve = 0.132806264 if _n == 1		
replace improve = 0.042425926 if _n == 2	
replace improve = 0.313336239 if _n == 3	
replace improve = 0.116619418 if _n == 4	

gen no_change = .
replace no_change = 0.132806264 if _n == 1		
replace no_change = 0.031452228 if _n == 2	
replace no_change = 0.196875689 if _n == 3	
replace no_change = 0.049411691 if _n == 4	

gen worsen100 = worsen*100
gen improve100 = improve*100
gen no_change100 = no_change*100

graph twoway (line worsen year, color(black) lwidth(medthick)) ///
		(line improve year, color(black) lwidth(medthick)) ///
		(line no_change year, color(black) lwidth(medthick)) ///
		(scatter worsen year, msize(large) mfcolor(white) mlcolor(black)  msymbol(O)) ///
		(scatter improve year, msize(large) mfcolor(white) mlcolor(black)  msymbol(O)) ///
		(scatter no_change year, msize(large) mfcolor(white) mlcolor(black) msymbol(O)), ///
		legend(col(3) order(2 3 1) lab(2 "Improves by 2 SD") lab(3 "No change") lab(1  "Worsens by 2 SD")) ///
		title("Figure 2: Predicted Probabilities of Voting" "Across Levels of Depression and Change in Depression") ///
		ytitle("", size(4)) ///
		ylabel(0 .05 .10 .15 .20 .25 .30 .35, labsize(3) angle(horizontal)) ///
		xlabel(2003 " " 2004 2006 2008 2010 2011 " ", labsize(3) notick) ///
		xtitle("") ///
		yscale(titlegap(3)) ///
		scheme(s2mono) graphregion(fcolor(white)) ///
		text(.17 2004 "Average" "Depression")




**
** SRHS INTERACTION GRAPH

clear
set obs 32

gen parent_ed = .
replace parent_ed = -3.8 if _n == 1
replace parent_ed = -3.6 if _n == 2
replace parent_ed = -3.4 if _n == 3
replace parent_ed = -3.2 if _n == 4
replace parent_ed = -3 if _n == 5
replace parent_ed = -2.8 if _n == 6 
replace parent_ed = -2.6 if _n == 7
replace parent_ed = -2.4 if _n == 8
replace parent_ed = -2.2 if _n == 9
replace parent_ed = -2 if _n == 10
replace parent_ed = -1.8 if _n == 11
replace parent_ed = -1.6 if _n == 12
replace parent_ed = -1.4 if _n == 13
replace parent_ed = -1.2 if _n == 14
replace parent_ed = -1 if _n == 15
replace parent_ed = -0.8 if _n == 16
replace parent_ed = -0.6 if _n == 17
replace parent_ed = -0.4 if _n == 18
replace parent_ed = -0.2 if _n == 19
replace parent_ed = 0 if _n == 20
replace parent_ed = 0.2 if _n == 21
replace parent_ed = 0.4 if _n == 22
replace parent_ed = 0.6 if _n == 23
replace parent_ed = 0.8 if _n == 24
replace parent_ed = 1 if _n == 25
replace parent_ed = 1.2 if _n == 26
replace parent_ed = 1.4 if _n == 27
replace parent_ed = 1.6 if _n == 28
replace parent_ed = 1.8 if _n == 29
replace parent_ed = 2 if _n == 30
replace parent_ed = 2.2 if _n == 31
replace parent_ed = 2.4 if _n == 32

gen exc_exc = .
replace exc_exc = 	0.099176666	if _n == 	1
replace exc_exc = 	0.103187619	if _n == 	2
replace exc_exc = 	0.107341457	if _n == 	3
replace exc_exc = 	0.111641692	if _n == 	4
replace exc_exc = 	0.116091795	if _n == 	5
replace exc_exc = 	0.120695183	if _n == 	6
replace exc_exc = 	0.1254552	if _n == 	7
replace exc_exc = 	0.13037511	if _n == 	8
replace exc_exc = 	0.135458077	if _n == 	9
replace exc_exc = 	0.14070715	if _n == 	10
replace exc_exc = 	0.146125249	if _n == 	11
replace exc_exc = 	0.151715142	if _n == 	12
replace exc_exc = 	0.157479434	if _n == 	13
replace exc_exc = 	0.163420544	if _n == 	14
replace exc_exc = 	0.169540687	if _n == 	15
replace exc_exc = 	0.175841854	if _n == 	16
replace exc_exc = 	0.182325796	if _n == 	17
replace exc_exc = 	0.188993998	if _n == 	18
replace exc_exc = 	0.195847663	if _n == 	19
replace exc_exc = 	0.202887692	if _n == 	20
replace exc_exc = 	0.210114662	if _n == 	21
replace exc_exc = 	0.21752881	if _n == 	22
replace exc_exc = 	0.225130011	if _n == 	23
replace exc_exc = 	0.232917758	if _n == 	24
replace exc_exc = 	0.240891151	if _n == 	25
replace exc_exc = 	0.249048876	if _n == 	26
replace exc_exc = 	0.25738919	if _n == 	27
replace exc_exc = 	0.265909908	if _n == 	28
replace exc_exc = 	0.274608393	if _n == 	29
replace exc_exc = 	0.283481541	if _n == 	30
replace exc_exc = 	0.292525778	if _n == 	31
replace exc_exc = 	0.301737052	if _n == 	32

gen exc_poor = .
replace exc_poor = 	0.31917599	if _n == 	1
replace exc_poor = 	0.297921289	if _n == 	2
replace exc_poor = 	0.29188703	if _n == 	3
replace exc_poor = 	0.285925216	if _n == 	4
replace exc_poor = 	0.280037017	if _n == 	5
replace exc_poor = 	0.27422351	if _n == 	6
replace exc_poor = 	0.268485683	if _n == 	7
replace exc_poor = 	0.262824438	if _n == 	8
replace exc_poor = 	0.257240588	if _n == 	9
replace exc_poor = 	0.251734858	if _n == 	10
replace exc_poor = 	0.246307891	if _n == 	11
replace exc_poor = 	0.240960244	if _n == 	12
replace exc_poor = 	0.235692393	if _n == 	13
replace exc_poor = 	0.230504734	if _n == 	14
replace exc_poor = 	0.225397585	if _n == 	15
replace exc_poor = 	0.220371185	if _n == 	16
replace exc_poor = 	0.215425701	if _n == 	17
replace exc_poor = 	0.210561228	if _n == 	18
replace exc_poor = 	0.205777788	if _n == 	19
replace exc_poor = 	0.201075338	if _n == 	20
replace exc_poor = 	0.196453767	if _n == 	21
replace exc_poor = 	0.191912904	if _n == 	22
replace exc_poor = 	0.187452514	if _n == 	23
replace exc_poor = 	0.183072306	if _n == 	24
replace exc_poor = 	0.178771931	if _n == 	25
replace exc_poor = 	0.174550988	if _n == 	26
replace exc_poor = 	0.170409025	if _n == 	27
replace exc_poor = 	0.166345541	if _n == 	28
replace exc_poor = 	0.162359989	if _n == 	29
replace exc_poor = 	0.158451779	if _n == 	30
replace exc_poor = 	0.154620279	if _n == 	31
replace exc_poor = 	0.150864819	if _n == 	32

gen poor_exc = .
replace poor_exc = 	0.009746497	if _n == 	1
replace poor_exc = 	0.011320292	if _n == 	2
replace poor_exc = 	0.013117065	if _n == 	3
replace poor_exc = 	0.015194641	if _n == 	4
replace poor_exc = 	0.017595413	if _n == 	5
replace poor_exc = 	0.020367664	if _n == 	6
replace poor_exc = 	0.02356622	if _n == 	7
replace poor_exc = 	0.027253107	if _n == 	8
replace poor_exc = 	0.031498192	if _n == 	9
replace poor_exc = 	0.036379785	if _n == 	10
replace poor_exc = 	0.04198513	if _n == 	11
replace poor_exc = 	0.048410749	if _n == 	12
replace poor_exc = 	0.055762538	if _n == 	13
replace poor_exc = 	0.064155518	if _n == 	14
replace poor_exc = 	0.073713133	if _n == 	15
replace poor_exc = 	0.084565936	if _n == 	16
replace poor_exc = 	0.096849533	if _n == 	17
replace poor_exc = 	0.110701614	if _n == 	18
replace poor_exc = 	0.126257945	if _n == 	19
replace poor_exc = 	0.143647218	if _n == 	20
replace poor_exc = 	0.16298473	if _n == 	21
replace poor_exc = 	0.184364979	if _n == 	22
replace poor_exc = 	0.207853409	if _n == 	23
replace poor_exc = 	0.233477704	if _n == 	24
replace poor_exc = 	0.261219269	if _n == 	25
replace poor_exc = 	0.291005665	if _n == 	26
replace poor_exc = 	0.322704941	if _n == 	27
replace poor_exc = 	0.356122802	if _n == 	28
replace poor_exc = 	0.391003455	if _n == 	29
replace poor_exc = 	0.427034671	if _n == 	30
replace poor_exc = 	0.463857199	if _n == 	31
replace poor_exc = 	0.501078098	if _n == 	32

gen poor_poor = .
replace poor_poor = 	0.040225092	if _n == 	1
replace poor_poor = 	0.04051626	if _n == 	2
replace poor_poor = 	0.043576408	if _n == 	3
replace poor_poor = 	0.046856399	if _n == 	4
replace poor_poor = 	0.050370271	if _n == 	5
replace poor_poor = 	0.054132692	if _n == 	6
replace poor_poor = 	0.058158936	if _n == 	7
replace poor_poor = 	0.062464865	if _n == 	8
replace poor_poor = 	0.067066892	if _n == 	9
replace poor_poor = 	0.071981936	if _n == 	10
replace poor_poor = 	0.077227366	if _n == 	11
replace poor_poor = 	0.082820924	if _n == 	12
replace poor_poor = 	0.088780644	if _n == 	13
replace poor_poor = 	0.095124741	if _n == 	14
replace poor_poor = 	0.101871494	if _n == 	15
replace poor_poor = 	0.109039101	if _n == 	16
replace poor_poor = 	0.116645518	if _n == 	17
replace poor_poor = 	0.124708277	if _n == 	18
replace poor_poor = 	0.133244286	if _n == 	19
replace poor_poor = 	0.142269598	if _n == 	20
replace poor_poor = 	0.151799175	if _n == 	21
replace poor_poor = 	0.161846622	if _n == 	22
replace poor_poor = 	0.172423912	if _n == 	23
replace poor_poor = 	0.183541093	if _n == 	24
replace poor_poor = 	0.195205989	if _n == 	25
replace poor_poor = 	0.2074239	if _n == 	26
replace poor_poor = 	0.220197296	if _n == 	27
replace poor_poor = 	0.233525527	if _n == 	28
replace poor_poor = 	0.247404547	if _n == 	29
replace poor_poor = 	0.261826659	if _n == 	30
replace poor_poor = 	0.2767803	if _n == 	31
replace poor_poor = 	0.29224986	if _n == 	32

foreach var of varlist exc_exc exc_poor poor_exc poor_poor{
gen `var'100 = `var'*100
}
*

graph twoway (line exc_exc parent_ed, color(black) lwidth(medthick)) ///
		(line exc_poor parent_ed, color(black) lwidth(medthick)) ///
		(line poor_exc parent_ed, color(black) lwidth(medthick)) ///
		(line poor_poor parent_ed, color(black) lwidth(medthick)), ///
		legend(col(2) order(4 3 2 1) lab(1 "Excellent-to-Excellent") lab(2 "Excellent-to-Poor") lab(3 "Poor-to-Excellent") lab(4 "Poor-to-Poor")) ///
		title("Figure 3: Predicted Probabilities of Voting" "Across Levels of SRHS and Parental Education") ///
		ytitle("", size(4)) ///
		ylabel(0 .1 .2 .3 .4 .5, labsize(3) angle(horizontal)) ///
		xlabel(-3.8 "Low" 0 "Average" 2.4 "High", labsize(3) notick) ///
		xtitle("Parental Education", size(4)) ///
		yscale(titlegap(3)) ///
		xscale(titlegap(3)) ///
		scheme(s2mono) graphregion(fcolor(white))

		
		
**
** SRHS INTERACTION GRAPH UPDATED

clear
set obs 32

gen parent_ed = .
replace parent_ed = -3.8 if _n == 1
replace parent_ed = -3.6 if _n == 2
replace parent_ed = -3.4 if _n == 3
replace parent_ed = -3.2 if _n == 4
replace parent_ed = -3 if _n == 5
replace parent_ed = -2.8 if _n == 6 
replace parent_ed = -2.6 if _n == 7
replace parent_ed = -2.4 if _n == 8
replace parent_ed = -2.2 if _n == 9
replace parent_ed = -2 if _n == 10
replace parent_ed = -1.8 if _n == 11
replace parent_ed = -1.6 if _n == 12
replace parent_ed = -1.4 if _n == 13
replace parent_ed = -1.2 if _n == 14
replace parent_ed = -1 if _n == 15
replace parent_ed = -0.8 if _n == 16
replace parent_ed = -0.6 if _n == 17
replace parent_ed = -0.4 if _n == 18
replace parent_ed = -0.2 if _n == 19
replace parent_ed = 0 if _n == 20
replace parent_ed = 0.2 if _n == 21
replace parent_ed = 0.4 if _n == 22
replace parent_ed = 0.6 if _n == 23
replace parent_ed = 0.8 if _n == 24
replace parent_ed = 1 if _n == 25
replace parent_ed = 1.2 if _n == 26
replace parent_ed = 1.4 if _n == 27
replace parent_ed = 1.6 if _n == 28
replace parent_ed = 1.8 if _n == 29
replace parent_ed = 2 if _n == 30
replace parent_ed = 2.2 if _n == 31
replace parent_ed = 2.4 if _n == 32

gen exc_poor_main = .
replace exc_poor_main =	0.046119233	if _n == 	1
replace exc_poor_main =	0.052700696	if _n == 	2
replace exc_poor_main =	0.060162133	if _n == 	3
replace exc_poor_main =	0.068603465	if _n == 	4
replace exc_poor_main =	0.078130736	if _n == 	5
replace exc_poor_main =	0.08885488	if _n == 	6
replace exc_poor_main =	0.100889914	if _n == 	7
replace exc_poor_main =	0.114350464	if _n == 	8
replace exc_poor_main =	0.129348535	if _n == 	9
replace exc_poor_main =	0.145989477	if _n == 	10
replace exc_poor_main =	0.164367137	if _n == 	11
replace exc_poor_main =	0.184558287	if _n == 	12
replace exc_poor_main =	0.206616478	if _n == 	13
replace exc_poor_main =	0.230565606	if _n == 	14
replace exc_poor_main =	0.256393607	if _n == 	15
replace exc_poor_main =	0.284046781	if _n == 	16
replace exc_poor_main =	0.31342536	if _n == 	17
replace exc_poor_main =	0.344380934	if _n == 	18
replace exc_poor_main =	0.376716318	if _n == 	19
replace exc_poor_main =	0.410188266	if _n == 	20
replace exc_poor_main =	0.444513231	if _n == 	21
replace exc_poor_main =	0.479376012	if _n == 	22
replace exc_poor_main =	0.514440832	if _n == 	23
replace exc_poor_main =	0.549364062	if _n == 	24
replace exc_poor_main =	0.583807585	if _n == 	25
replace exc_poor_main =	0.617451704	if _n == 	26
replace exc_poor_main =	0.650006579	if _n == 	27
replace exc_poor_main =	0.681221349	if _n == 	28
replace exc_poor_main =	0.710890416	if _n == 	29
replace exc_poor_main =	0.738856696	if _n == 	30
replace exc_poor_main =	0.765011961	if _n == 	31
replace exc_poor_main =	0.789294659	if _n == 	32

gen exc_poor_lower = .
replace exc_poor_lower =	0.007019332	if _n == 	1
replace exc_poor_lower =	0.008869561	if _n == 	2
replace exc_poor_lower =	0.01119924	if _n == 	3
replace exc_poor_lower =	0.014128043	if _n == 	4
replace exc_poor_lower =	0.01780294	if _n == 	5
replace exc_poor_lower =	0.022402943	if _n == 	6
replace exc_poor_lower =	0.028143772	if _n == 	7
replace exc_poor_lower =	0.035281782	if _n == 	8
replace exc_poor_lower =	0.044116009	if _n == 	9
replace exc_poor_lower =	0.054986585	if _n == 	10
replace exc_poor_lower =	0.068266884	if _n == 	11
replace exc_poor_lower =	0.084345704	if _n == 	12
replace exc_poor_lower =	0.103594606	if _n == 	13
replace exc_poor_lower =	0.126314377	if _n == 	14
replace exc_poor_lower =	0.15265414	if _n == 	15
replace exc_poor_lower =	0.182498124	if _n == 	16
replace exc_poor_lower =	0.21532308	if _n == 	17
replace exc_poor_lower =	0.250056484	if _n == 	18
replace exc_poor_lower =	0.285036122	if _n == 	19
replace exc_poor_lower =	0.318270088	if _n == 	20
replace exc_poor_lower =	0.348104412	if _n == 	21
replace exc_poor_lower =	0.373884007	if _n == 	22
replace exc_poor_lower =	0.395953919	if _n == 	23
replace exc_poor_lower =	0.415118253	if _n == 	24
replace exc_poor_lower =	0.43217391	if _n == 	25
replace exc_poor_lower =	0.44773663	if _n == 	26
replace exc_poor_lower =	0.462237898	if _n == 	27
replace exc_poor_lower =	0.475969974	if _n == 	28
replace exc_poor_lower =	0.489129703	if _n == 	29
replace exc_poor_lower =	0.501850456	if _n == 	30
replace exc_poor_lower =	0.51422345	if _n == 	31
replace exc_poor_lower =	0.526311609	if _n == 	32

gen exc_poor_upper = .
replace exc_poor_upper =	0.248510131	if _n == 	1
replace exc_poor_upper =	0.256974781	if _n == 	2
replace exc_poor_upper =	0.265674296	if _n == 	3
replace exc_poor_upper =	0.27461761	if _n == 	4
replace exc_poor_upper =	0.283815904	if _n == 	5
replace exc_poor_upper =	0.293283437	if _n == 	6
replace exc_poor_upper =	0.303038721	if _n == 	7
replace exc_poor_upper =	0.313106181	if _n == 	8
replace exc_poor_upper =	0.323518569	if _n == 	9
replace exc_poor_upper =	0.334320528	if _n == 	10
replace exc_poor_upper =	0.345573945	if _n == 	11
replace exc_poor_upper =	0.357366155	if _n == 	12
replace exc_poor_upper =	0.369822735	if _n == 	13
replace exc_poor_upper =	0.383127688	if _n == 	14
replace exc_poor_upper =	0.397555255	if _n == 	15
replace exc_poor_upper =	0.4135186	if _n == 	16
replace exc_poor_upper =	0.431637101	if _n == 	17
replace exc_poor_upper =	0.452802941	if _n == 	18
replace exc_poor_upper =	0.478163259	if _n == 	19
replace exc_poor_upper =	0.508838804	if _n == 	20
replace exc_poor_upper =	0.545288535	if _n == 	21
replace exc_poor_upper =	0.586739905	if _n == 	22
replace exc_poor_upper =	0.631326433	if _n == 	23
replace exc_poor_upper =	0.676787955	if _n == 	24
replace exc_poor_upper =	0.721081922	if _n == 	25
replace exc_poor_upper =	0.76265876	if _n == 	26
replace exc_poor_upper =	0.800508071	if _n == 	27
replace exc_poor_upper =	0.834100931	if _n == 	28
replace exc_poor_upper =	0.863292861	if _n == 	29
replace exc_poor_upper =	0.888218082	if _n == 	30
replace exc_poor_upper =	0.909191641	if _n == 	31
replace exc_poor_upper =	0.926628308	if _n == 	32

gen poor_exc_main = .
replace poor_exc_main = 	0.613709218	if _n ==	1
replace poor_exc_main = 	0.606845067	if _n ==	2
replace poor_exc_main = 	0.599938454	if _n ==	3
replace poor_exc_main = 	0.592991887	if _n ==	4
replace poor_exc_main = 	0.586007935	if _n ==	5
replace poor_exc_main = 	0.578989227	if _n ==	6
replace poor_exc_main = 	0.571938446	if _n ==	7
replace poor_exc_main = 	0.564858329	if _n ==	8
replace poor_exc_main = 	0.557751658	if _n ==	9
replace poor_exc_main = 	0.550621258	if _n ==	10
replace poor_exc_main = 	0.543469995	if _n ==	11
replace poor_exc_main = 	0.536300766	if _n ==	12
replace poor_exc_main = 	0.529116501	if _n ==	13
replace poor_exc_main = 	0.521920152	if _n ==	14
replace poor_exc_main = 	0.514714692	if _n ==	15
replace poor_exc_main = 	0.507503111	if _n ==	16
replace poor_exc_main = 	0.500288405	if _n ==	17
replace poor_exc_main = 	0.493073579	if _n ==	18
replace poor_exc_main = 	0.485861637	if _n ==	19
replace poor_exc_main = 	0.478655578	if _n ==	20
replace poor_exc_main = 	0.471458391	if _n ==	21
replace poor_exc_main = 	0.464273051	if _n ==	22
replace poor_exc_main = 	0.457102512	if _n ==	23
replace poor_exc_main = 	0.449949706	if _n ==	24
replace poor_exc_main = 	0.442817532	if _n ==	25
replace poor_exc_main = 	0.43570886	if _n ==	26
replace poor_exc_main = 	0.428626517	if _n ==	27
replace poor_exc_main = 	0.42157329	if _n ==	28
replace poor_exc_main = 	0.414551919	if _n ==	29
replace poor_exc_main = 	0.407565091	if _n ==	30
replace poor_exc_main = 	0.400615439	if _n ==	31
replace poor_exc_main = 	0.393705539	if _n ==	32

gen poor_exc_lower = .
replace poor_exc_lower = 	0.236714478	if _n ==	1
replace poor_exc_lower = 	0.246331912	if _n ==	2
replace poor_exc_lower = 	0.256171091	if _n ==	3
replace poor_exc_lower = 	0.266218841	if _n ==	4
replace poor_exc_lower = 	0.27645885	if _n ==	5
replace poor_exc_lower = 	0.286870979	if _n ==	6
replace poor_exc_lower = 	0.297430309	if _n ==	7
replace poor_exc_lower = 	0.308105809	if _n ==	8
replace poor_exc_lower = 	0.318858408	if _n ==	9
replace poor_exc_lower = 	0.329638166	if _n ==	10
replace poor_exc_lower = 	0.340380008	if _n ==	11
replace poor_exc_lower = 	0.350997165	if _n ==	12
replace poor_exc_lower = 	0.36137088	if _n ==	13
replace poor_exc_lower = 	0.371334014	if _n ==	14
replace poor_exc_lower = 	0.380644878	if _n ==	15
replace poor_exc_lower = 	0.388946355	if _n ==	16
replace poor_exc_lower = 	0.395707409	if _n ==	17
replace poor_exc_lower = 	0.400159938	if _n ==	18
replace poor_exc_lower = 	0.401296946	if _n ==	19
replace poor_exc_lower = 	0.398082108	if _n ==	20
replace poor_exc_lower = 	0.389948518	if _n ==	21
replace poor_exc_lower = 	0.377220666	if _n ==	22
replace poor_exc_lower = 	0.360943703	if _n ==	23
replace poor_exc_lower = 	0.342337182	if _n ==	24
replace poor_exc_lower = 	0.322428133	if _n ==	25
replace poor_exc_lower = 	0.301969687	if _n ==	26
replace poor_exc_lower = 	0.281487768	if _n ==	27
replace poor_exc_lower = 	0.261346059	if _n ==	28
replace poor_exc_lower = 	0.241796226	if _n ==	29
replace poor_exc_lower = 	0.223011572	if _n ==	30
replace poor_exc_lower = 	0.205108897	if _n ==	31
replace poor_exc_lower = 	0.188162955	if _n ==	32

gen poor_exc_upper = .
replace poor_exc_upper = 	0.890576091	if _n ==	1
replace poor_exc_upper = 	0.879362995	if _n ==	2
replace poor_exc_upper = 	0.8671951	if _n ==	3
replace poor_exc_upper = 	0.854032761	if _n ==	4
replace poor_exc_upper = 	0.839844089	if _n ==	5
replace poor_exc_upper = 	0.824607427	if _n ==	6
replace poor_exc_upper = 	0.80831422	if _n ==	7
replace poor_exc_upper = 	0.790972334	if _n ==	8
replace poor_exc_upper = 	0.77260995	if _n ==	9
replace poor_exc_upper = 	0.753280262	if _n ==	10
replace poor_exc_upper = 	0.733067385	if _n ==	11
replace poor_exc_upper = 	0.712094214	if _n ==	12
replace poor_exc_upper = 	0.690533561	if _n ==	13
replace poor_exc_upper = 	0.668624804	if _n ==	14
replace poor_exc_upper = 	0.646699665	if _n ==	15
replace poor_exc_upper = 	0.625221948	if _n ==	16
replace poor_exc_upper = 	0.604844172	if _n ==	17
replace poor_exc_upper = 	0.586468152	if _n ==	18
replace poor_exc_upper = 	0.571243648	if _n ==	19
replace poor_exc_upper = 	0.560355153	if _n ==	20
replace poor_exc_upper = 	0.554519195	if _n ==	21
replace poor_exc_upper = 	0.553558338	if _n ==	22
replace poor_exc_upper = 	0.556568	if _n ==	23
replace poor_exc_upper = 	0.562459138	if _n ==	24
replace poor_exc_upper = 	0.57032209	if _n ==	25
replace poor_exc_upper = 	0.579505506	if _n ==	26
replace poor_exc_upper = 	0.58956792	if _n ==	27
replace poor_exc_upper = 	0.600211801	if _n ==	28
replace poor_exc_upper = 	0.611233059	if _n ==	29
replace poor_exc_upper = 	0.622487784	if _n ==	30
replace poor_exc_upper = 	0.633871345	if _n ==	31
replace poor_exc_upper = 	0.64530533	if _n ==	32

graph twoway (rarea exc_poor_lower exc_poor_upper parent_ed, color(gs14)) ///
		(rarea poor_exc_lower poor_exc_upper parent_ed, color(gs10)) ///
		(line exc_poor_main parent_ed, color(black) lwidth(medthick)) ///
		(line exc_poor_lower parent_ed, color(black) lwidth(medthick) lpattern(shortdash)) ///
		(line exc_poor_upper parent_ed, color(black) lwidth(medthick) lpattern(shortdash)) ///
		(scatter exc_poor_main parent_ed, mfcolor(white) mlcolor(black) msymbol(O)) ///
		(line poor_exc_main parent_ed, color(black) lwidth(medthick)) ///
		(line poor_exc_lower parent_ed, color(black) lwidth(medthick) lpattern(shortdash)) ///
		(line poor_exc_upper parent_ed, color(black) lwidth(medthick) lpattern(shortdash)) ///
		(scatter poor_exc_main parent_ed, mfcolor(white) mlcolor(black) msymbol(S)), ///
		legend(col(2) order(6 10) lab(6 "Excellent-to-Poor") lab(10 "Poor-to-Excellent") region(style(none)) position(12) ring(0) rows(1) symxsize(5)) ///
		title("Figure 3: Predicted Probabilities of Voting" "Across Levels of SRHS and Parental Education") ///
		ytitle("", size(4)) ///
		ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.0, nogrid labsize(3) angle(horizontal)) ///
		xlabel(-3.8 "Low" 0 "Average" 2.4 "High", labsize(3) notick) ///
		xtitle("Parental Education", size(4)) ///
		yscale(titlegap(3)) ///
		xscale(titlegap(3)) ///
		scheme(s1mono) graphregion(fcolor(white))
