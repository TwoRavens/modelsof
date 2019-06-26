*DO FILE TO REPLICATE ANALYSIS FROM 
*“INTERNATIONAL LAW, MILITARY EFFECTIVENESS, AND PUBLIC SUPPORT FOR DRONE STRIKES"


version 13


*Specify relevant directory where replication files are stored



**TESS/GFK EXPERIMENT (SEPTEMBER 2013)**
use "drones_tess.dta", clear


*Table C1 comparing sample to Current Population Survey (CPS) benchmarks
tab1 male ppagecat ppeducat income6 married white region 


*Balance check
mlogit group ppagecat ppeducat white male income6 married partyid7 ideology7 polint military activist


*Overall support for drones across all respondents
tab drones3, mis

*Support for drones, separated by each treatment condition
proportion drones3, over(group)



*FIGURE 1. SUPPORT FOR DRONE STRIKES, BY TREATMENT CONDITION
*Commands used to generate data for Figure 1.
*Values saved in "drones_fig1.dta". See "drones_figures.do" for commands used to generate actual figure.
*First Differences for each treatment group relative to the control.
*Sovereignty
prtest drones2 if control==1 | unsov==1, by(group)
prtest drones2 if control==1 | hrwsov==1, by(group)
prtest drones2 if control==1 | govtsov==1, by(group)
*Civilians
prtest drones2 if control==1 | unciv==1, by(group)
prtest drones2 if control==1 | hrwciv==1, by(group)
prtest drones2 if control==1 | govtciv==1, by(group)
*Effectiveness
prtest drones2 if control==1 | uneff==1, by(group)
prtest drones2 if control==1 | hrweff==1, by(group)
prtest drones2 if control==1 | govteff==1, by(group)



*TABLE II. ANALYSIS OF ISSUES, SOURCES, AND SUPPORT FOR DRONE STRIKES
oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff ///
	male ppagecat ppeducat income6 partyid7 polint military activist
*Wald test for equality of coefficients between Govt, UN, and NGO across each treatment condition
test unsov = govtsov
test hrwsov = govtsov
test unsov = hrwsov
test unciv = govtciv
test hrwciv = govtciv
test unciv = hrwciv
test uneff = govteff
test hrweff = govteff
test uneff = hrweff

*Evaluating several potential conditional effects.
*In order to facilitate the analysis given the large number of treatments, conditional effects
	*were evaluated by sub-sampling across the relevant individual characteristic.
*Partisanship
	*Republicans
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 polint military activist if partyid7>4
	*Democrats
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 polint military activist if partyid7<4
*Political Ideology
	*Conservatives
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 polint military activist if ideology7>4
	*Liberals
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 polint military activist if ideology7<4
*Political Interest
	*High
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 military activist if polint>=3
	*Low
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 military activist if polint<=2
*Political Activism
	*Activist
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff ///
		male ppagecat ppeducat income6 partyid7 polint military if activist==1
	*Non-activist
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 polint military if activist==0
*Military Experience
	*Veteran
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 polint activist if military==1
	*Civilian
	oprobit drones unsov hrwsov govtsov unciv hrwciv govtciv uneff hrweff govteff  ///
		male ppagecat ppeducat income6 partyid7 polint activist if military==0

	

*FIGURE 2. CREDIBILITY OF SOURCE, BY ISSUE FRAME
*Commands used to generate data for Figure 2.
*Values saved in "drones_fig2.dta". See "drones_figures.do" for commands used to generate actual figure.
*Overall
bys elite: tab credible2
*By each issue frame
*International Law - Sovereignty
bys elite: tab credible2 if lawsov==1
*International Law - Civilians
bys elite: tab credible2 if lawciv==1
*Effectiveness
bys elite: tab credible2 if effect==1

*Separated by Partisan Identification
*Republicans
bys elite: tab credible2 if lawsov==1 & partyid7>4
bys elite: tab credible2 if lawciv==1 & partyid7>4
bys elite: tab credible2 if effect==1 & partyid7>4
*Democrats
bys elite: tab credible2 if lawsov==1 & partyid7<4
bys elite: tab credible2 if lawciv==1 & partyid7<4
bys elite: tab credible2 if effect==1 & partyid7<4




**AMAZON MECHANICAL TURK (MTURK) FOLLOW-UP EXPERIMENT (NOVEMBER 2013)**
use "drones_mturk.dta", clear

*Table C1 comparing sample to Current Population Survey (CPS) benchmarks
*Note that income and married not asked
tab1 male agecat educ white region 


*Balance tests
mlogit group male agecat educ region white partyid7 ideology7 polint4 military activist


*Create normalized version of each variable so that on a common scale between 0 and 1.
sum drones5 moral standing5 recruit5 special5
gen drones_S = (drones5 - 1)/4
gen standing_S = (standing5 - 1)/4
gen recruit_S = (recruit5 - 1)/4
gen special_S = (special5 - 1)/4
sum drones_S moral standing_S recruit_S special_S 


*FIGURE 3. CIVILIAN DEATHS, POTENTIAL MEDIATORS, AND SUPPORT FOR DRONE STRIKES
*Commands used to generate data for Figure 3.
*Values saved in "drones_fig3.dta". See "drones_figures.do" for commands used to generate actual figure.
*Difference-in-means tests for the main support for drones dependent variable, as well as each mediator.
*Support for Drones
ttest drones_S, by(group)
*Morally Wrong
ttest moral, by(group)
*U.S. Image
ttest standing_S, by(group)
*Recruit Militants
ttest recruit_S, by(group)
*Special Forces
ttest special_S, by(group)


*Regression Models on the main support for drones dependent variable, and each of the 
	*potential mediators respectively.
*Drones
oprobit drones5 group ///
	male agecat educ partyid7 polint4 military activist, nolog 
*Morally Wrong
logit moral group ///
	male agecat educ partyid7 polint4 military activist, nolog 
*U.S. Image
oprobit standing5 group ///
	male agecat educ partyid7 polint4 military activist, nolog 
*Recruit Militants
oprobit recruit5 group ///
	male agecat educ partyid7 polint4 military activist, nolog 
*Special Forces
oprobit special5 group ///
	male agecat educ partyid7 polint4 military activist, nolog 


