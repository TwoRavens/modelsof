* IV variable construction before Analysis*

*Partyid
gen democrat2 = 0
replace democrat2 = 1 if partyid==1
gen republican2 = 0
replace republican2 = 1 if partyid==2

*Recreate a 7-point partyid
*7 strong dem; 6 dem; 5 lean dem; 4 ind; 3 lean rep; 2 rep; 1 strong rep
*Equivalent to created variable "party7", which ranges from -3 to 3
gen partyid7 = .
*Strong Dem
replace partyid7 = 7 if partyid==1 & strdpart==1
*Dem
replace partyid7 = 6 if partyid==1 & strdpart==2
*Lean Dem 
replace partyid7 = 5 if partyid==3 & indparty==2
*Independent
replace partyid7 = 4 if partyid==3 & indparty==3
*Lean Rep
replace partyid7 = 3 if partyid==3 & indparty==1
*Rep
replace partyid7 = 2 if partyid==2 & strdpart==2
*Strong Rep
replace partyid7 = 1 if partyid==2 & strdpart==1


*Sex
gen male2 = 0
replace male2 = 1 if sex==1

*Household income
*Mark refused as missing
recode hhinc (8=.)


*Go back to home country to drop DK/na)
recode trgoback (3=.)
recode trgoback (4=.)

*K3A Big Interests drop dk/na*
recode bigintst (9=.)

*K3B Say in Government drop dk/na*
recode sayso (9=.)

*K3C Politics Complitcated drop dk/na*
recode complic (9=.)

*K3D No Contact with Government drop dk/na*
recode nocontac (9=.)


*For Relymed to drop dk/other*
recode relymed (4=.)


*New Rely on English med dummy*
gen relyeng = 0
replace relyeng = 1 if relymed==1
replace relyeng =. if relymed==.

*Variable labels
lab var psize10g "Large Protest"
lab var countp30_small "No. of Protests"
lab var reduc "Education"
lab var age "Age"
lab var male "Male"
lab var firstgen "First Gen"
lab var pctinus "% of Life in U.S."
lab var langspan "Spanish Pref"
lab var mexican "Mexican"
lab var prican "Puerto Rican"
lab var cuban "Cuban"
lab var dominican "Dominican"
lab var salvadoran "Salvadoran"
lab var watchnew "Watch News"
lab var readpapr "Read Paper"
lab var relyeng "English Media"


*MODELS USED IN MAIN AJPS ANALYSIS**
* MAIN models with 10gprotests and County only small and Media**
ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng


*INTERACTIONS
*Interaction between protest variables and media consumption

gen pbig_relyeng = psize10g*relyeng
gen psmall_relyeng = countp30_small*relyeng


*Big Protest and English Media
reg bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng pbig_relyeng
grinter psize10g, inter(pbig_relyeng) con(relyeng)
reg sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng pbig_relyeng
grinter psize10g, inter(pbig_relyeng) con(relyeng)
reg complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng pbig_relyeng
grinter psize10g, inter(pbig_relyeng) con(relyeng)
reg nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng pbig_relyeng
grinter psize10g, inter(pbig_relyeng) con(relyeng)
reg govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng pbig_relyeng
grinter psize10g, inter(pbig_relyeng) con(relyeng)

*Small Protest and English Media (Nothing substantive)
reg bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng psmall_relyeng
grinter psize10g, inter(psmall_relyeng) con(relyeng)
reg sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng psmall_relyeng
grinter psize10g, inter(psmall_relyeng) con(relyeng)
reg complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng psmall_relyeng
grinter psize10g, inter(psmall_relyeng) con(relyeng)
reg nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng psmall_relyeng
grinter psize10g, inter(psmall_relyeng) con(relyeng)
reg govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng psmall_relyeng
grinter psize10g, inter(psmall_relyeng) con(relyeng)



*SUBSTANTIVE EFFECTS

*Big interests
estsimp ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng
plotfds, outcome(4) clevel(95) ///
	discrete(psize10g male firstgen langspan mexican prican cuban dominican salvadoran relyeng) continuous(countp30_small reduc age pctinus watchnew readpapr) ///
	changex(min max) label xline(0) ///
	sort(bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng) ///
	msymbol(O) msize(medium) mcolor(black) ylabel(, labsize(small)) /// 
	title("") ///
	note("First differences for continuous variables represent a change from min to max value." "Variables with a * are dichotmous - FD is a change from 0 to 1.")

*No Say in Govt
estsimp ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng, dropsims
plotfds, outcome(4) clevel(95) ///
	discrete(psize10g male firstgen langspan mexican prican cuban dominican salvadoran relyeng) continuous(countp30_small reduc age pctinus watchnew readpapr) ///
	changex(min max) label xline(0) ///
	sort(bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng) ///
	msymbol(O) msize(medium) mcolor(black) ylabel(, labsize(small)) /// 
	title("") ///
	note("First differences for continuous variables represent a change from min to max value." "Variables with a * are dichotmous - FD is a change from 0 to 1.")

*Politics is Complicated
estsimp ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng, dropsims
plotfds, outcome(4) clevel(95) ///
	discrete(psize10g male firstgen langspan mexican prican cuban dominican salvadoran relyeng) continuous(countp30_small reduc age pctinus watchnew readpapr) ///
	changex(min max) label xline(0) ///
	sort(bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng) ///
	msymbol(O) msize(medium) mcolor(black) ylabel(, labsize(small)) /// 
	title("") ///
	note("First differences for continuous variables represent a change from min to max value." "Variables with a * are dichotmous - FD is a change from 0 to 1.")

**ADDITIONAL MODELS contained in SI**


*INCLUDE INCOME **
ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng hhinc
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng hhinc
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng hhinc
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng hhinc
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng hhinc
eststo

*Generate table
esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Income Included)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt") ///
	/* addnotes("Line 1" "Line 2") */

eststo clear


*INCLUDE INCOME BUT IMPUTE REFUSED ANSWERS**
*Declare and set data as imputed
mi set mlong

*Register variable to be imputed
mi register imputed hhinc age pctinus relyeng
	
*Estimate imputation
mi impute mvn hhinc age pctinus relyeng =  ///
	/* bigintst sayso complic nocontac govtrust */ ///
	psize10g countp30_small reduc male firstgen langspan mexican prican cuban dominican salvadoran watchnew readpapr, ///
	add(5) rseed(97196)

*age and pctinus are continuous so don't need to do anything
*hhinc is categorical and relyeng is binary -> *Since mvn approach assumes imputed variables are continuous, need to make these categorical again.
sum hhinc relyeng
*Relyeng is binary -> make copy
gen relyeng2 = relyeng
replace relyeng2 = 0 if relyeng<0.5 & relyeng!=.
replace relyeng2 = 1 if relyeng>=0.5 & relyeng!=.
tab relyeng2, mis
*Income
gen hhinc2 = hhinc
replace hhinc2 = 1 if hhinc<1.5 & hhinc!=.
replace hhinc2 = 2 if hhinc>=1.5 & hhinc<2.5 & hhinc!=.
replace hhinc2 = 3 if hhinc>=2.5 & hhinc<3.5 & hhinc!=.
replace hhinc2 = 4 if hhinc>=3.5 & hhinc<4.5 & hhinc!=.
replace hhinc2 = 5 if hhinc>=4.5 & hhinc<5.5 & hhinc!=.
replace hhinc2 = 6 if hhinc>=5.5 & hhinc<6.5 & hhinc!=.
replace hhinc2 = 7 if hhinc>=6.5 & hhinc!=.

*Run models using imputed data
mi estimate: ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng2 hhinc2
eststo
mi estimate: ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng2 hhinc2
eststo
mi estimate: ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng2 hhinc2
eststo
mi estimate: ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng2 hhinc2
eststo
mi estimate: ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng2 hhinc2
eststo

esttab e(b_mi, tr) using table1, csv keep(psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran ///
	watchnew readpapr relyeng2 hhinc2) replace


**INCLUDE PARTY**
*Using 7-point party measure -> higher values is more democrat
ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng partyid7
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng partyid7
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng partyid7
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng partyid7
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng partyid7
eststo

esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Partisanship Included)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt") ///
	addnotes("Partisanship measured using a 7-point scale where higher values indicate greater association as a Democrat.")
eststo clear



**INCLUDE DISCRIMINATION References SSQ Sanchez 2011 Perceived Disc- General Group Discrimination measure -LATDISC*
*generated latdisc2 to recode don't know to missing*
gen latdisc2=latdisc
recode latdisc2 (5=.)

ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng latdisc2
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng latdisc2
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng latdisc2
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng latdisc2
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng latdisc2
eststo

esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Latino Discrimination Included)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt") ///
	addnotes("Latino Discrimination based on question about individual beliefs that Latinos can get ahead in the US if they work hard, where higher values indicate a lower level of perceived discrimination.")
eststo clear


*Restrict analysis to only include observations during and after protest period
*i.e. exclude all observations where interview took place before first protest (i.e. Feb 14, 2006).
*Create a dummy for Feb 14th (first recorded protest)
gen bef_feb14 = 0
replace bef_feb14 = 1 if date<td(14feb2006)

ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng if bef_feb14==0
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng if bef_feb14==0
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng if bef_feb14==0
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng if bef_feb14==0
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng if bef_feb14==0
eststo

esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Limited to Survey Respondents Interviewed After Protests Started)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt") ///
	addnotes("Excludes all respondents surveyed before February 14, 2006, which is the date of the first recorded protest in the Immigration Protest Data Set.")
	eststo clear



**INTERACTION 1st GEN with SMALL PROTEST VARIABLE**
*Create interaction terms
gen firstgen_psmall = firstgen*countp30_small

ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng firstgen_psmall
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng firstgen_psmall
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng firstgen_psmall
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng firstgen_psmall
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng firstgen_psmall
eststo

esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Including First Generation x Small Protests Interaction)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt")
eststo clear


**INTERACT LINKED FATE with PROTEST VARIABLES*
gen linkfate = rgfate
recode linkfate (5=.)
gen rgcom2 = rgcom
recode rgcom2 (5=.)
gen rgpcom2 = rgpcom
recode rgpcom2 (5=.)

*Create interaction terms of Latino linked fate/commonality with protest variables
gen linkfate_pbig = linkfate*psize10g
gen linkfate_psmall = linkfate*countp30_small
gen rgcom2_pbig = rgcom2*psize10g
gen rgcom2_psmall = rgcom2*countp30_small
gen rgpcom2_pbig = rgpcom2*psize10g
gen rgpcom2_psmall = rgpcom2*countp30_small


*Linked Fate x Big Protest Models
ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_pbig
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_pbig
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_pbig
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_pbig
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_pbig
eststo

esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Including Latino Linked Fate x Large Protest Interaction)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt")
eststo clear



*Linked Fate x Small Protest Models
ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_psmall
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_psmall
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_psmall
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_psmall
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban dominican salvadoran watchnew readpapr relyeng linkfate linkfate_psmall
eststo

esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Including Latino Linked Fate x Small Protests Interaction)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt")
eststo clear

 

* Create Regional Variable instead of National Origin Group Controls**
gen SouthAmerican= 0
replace SouthAmerican=1 if ancestry==1 | ancestry==2 |ancestry==3 | ancestry== 4 | ancestry== 8 ancestry== 15 | ancestry== 16 | ancestry== 19 | ancestry== 20

gen CentralAmerican= 0
replace CentralAmerican=1 if ancestry== 5 | ancestry== 9 | ancestry==10 | ancestry== 11 |ancestry== 13 | ancestry== 14 

* Models with National orgin control Mexican Prican Cuban and then Central American Control *

ologit bigintst psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban CentralAmerican watchnew readpapr relyeng
eststo
ologit sayso psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban CentralAmerican watchnew readpapr relyeng
eststo
ologit complic psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban CentralAmerican watchnew readpapr relyeng
eststo
ologit nocontac psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban CentralAmerican watchnew readpapr relyeng
eststo
ologit govtrust psize10g countp30_small reduc age male firstgen pctinus langspan mexican prican cuban CentralAmerican watchnew readpapr relyeng
eststo

*Generate table
esttab using table1, csv replace b(a3) se star (+ 0.10 * 0.05 ** 0.01) ///
	pr2(a3) scalars(ll chi2) compress lines nogaps ///
	title("Table S#: Analysis of the Effects of Immigrants Rights Marches on Attitudes towards Government (Central American)") ///
	mtitles("Big Interests Dominate" "No Say in Govt" "Politics is Complicated" "Avoid Contact with Govt" "Trust in Govt") ///
	/* addnotes("Line 1" "Line 2") */
