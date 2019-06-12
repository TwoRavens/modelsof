**********************************************
* ISQ Data Archive File
* Microfoundations of International Community
* MAIN DOCUMENT
**********************************************

* Open Microfoundations Dataset

use "MicrofoundationsIntCommunityISQ.dta"

*************************************************************************
* FIGURE 2: Distribution of destination countries across control and treatment 
*************************************************************************

* For chart, see accompanying Excel file; for CHI2 see below

tabulate hostcountryname treatment, chi2

*************************************************************************
* TABLE 1: Descriptive Statistics
*************************************************************************

* Generate Sample Means and Standard Deviations(Total)

summ gender income political international priorexposure parent hostfam freshman sophomore junior senior

* Generate Sample Means and Standard Deviations(Control Group Only)

summ gender income political international priorexposure parent hostfam freshman sophomore junior senior, if treatment==0

* Generate Sample Means and Standard Deviations(Treatment Group Only)

summ gender income political international priorexposure parent hostfam freshman sophomore junior senior, if treatment==1

* Generate Difference in Means Across Control and Treatment (Raw Means)

regress gender treatment
regress income treatment
regress political treatment
regress international treatment
regress priorexposure treatment
regress parent treatment
regress hostfam treatment if hostfam!=3 // Excludes "Don't Know" from control group
regress freshman treatment
regress sophomore treatment
regress junior treatment
regress senior treatment

* Generate Difference in Means Across Control and Treatment (Controlling for University Fixed Effects)

regress gender treatment flor-welles
regress income treatment flor-welles
regress political treatment flor-welles
regress international treatment flor-welles
regress priorexposure treatment flor-welles
regress parent treatment flor-welles
regress hostfam treatment flor-welles // Excludes "Don't Know" from control group
regress freshman treatment flor-welles
regress sophomore treatment flor-welles
regress junior treatment flor-welles
regress senior treatment flor-welles

***************************************************************************************
* TABLE 2: Effects of Studying Abroad on belief in shared international community (H1)
***************************************************************************************

* a. Generate Regression Estimates of Effect of Studying Abroad on Belief in Shared Values

regress sharevalue treatment // Column 1: Base Model (OLS)
regress sharevalue treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit

* b. Generate Regression Estimates of Effect of Studying Abroad on Belief in Shared Understandings

regress shareunderst treatment // Column 1: Base Model (OLS)
regress shareunderst treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit

* c. Generate Regression Estimates of Effect of Studying Abroad on Warmth Toward Host Country

regress Q24 treatment if Q24<101 // Column 1: Base Model (OLS) (Excludes answers out of range--above 100 degrees of warmth)
regress Q24 treatment flor-welles if Q24<101 // Column 2: Add University Fixed Effects (OLS)
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q24<101 // Column 3: Add Full Set of Controls (OLS)
// Column 4: Ordered probit not applicable because of large outcome space of dependent variable (too many "categories" and better treated as continuous)


* d. Generate Regression Estimates of Effect of Studying Abroad on Generalized Trust

regress trust treatment // Column 1: Base Model (OLS)
regress trust treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit


* e. Generate Regression Estimates of Effect of Studying Abroad on Situational Trust

regress laptop treatment if laptop!=5 // Column 1: Base Model (OLS) (Excludes "Don't Know")
regress laptop treatment flor-welles if laptop!=5 // Column 2: Add University Fixed Effects (OLS)
regress laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if laptop!=5 // Column 3: Add Full Set of Controls (OLS)
oprobit laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if laptop!=5 // Column 4: Ordered Probit


***************************************************************************************
* TABLE 3: Effects of studying abroad on perceptions of threat posed by study abroad country (H2)
***************************************************************************************

* a. Generate Regression Estimates of Effect of Studying Abroad on Perception of Economic Threat

regress Q21_rec treatment // Column 1: Base Model (OLS)
regress Q21_rec treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit


* b. Generate Regression Estimates of Effect of Studying Abroad on Perception of Conventional Military Threat

regress Q22_rec treatment // Column 1: Base Model (OLS)
regress Q22_rec treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit


* c. Generate Regression Estimates of Effect of Studying Abroad on Perception of Nuclear Threat

regress Q23_rec treatment // Column 1: Base Model (OLS)
regress Q23_rec treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit

***************************************************************************************
* TABLE 4: Effects of studying abroad on nationlism (H3)
***************************************************************************************

* a. Generate Regression Estimates of Effect of Studying Abroad on Nationalism

regress nationalism treatment // Column 1: Base Model (OLS)
regress nationalism treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit

* b. Generate Regression Estimates of Effect of Studying Abroad on Pride in America

regress natpride treatment // Column 1: Base Model (OLS)
regress natpride treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit


* c. Generate Regression Estimates of Effect of Studying Abroad on Feeling of warmth toward American culture

regress Q31 treatment if Q31!=101 // Column 1: Base Model (OLS) (Excludes answers out of range--above 100 degrees of warmth)
regress Q31 treatment flor-welles if Q31!=101 // Column 2: Add University Fixed Effects (OLS)
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q31!=101 // Column 3: Add Full Set of Controls (OLS)
// Column 4: Ordered probit not applicable because of large outcome space of dependent variable (too many "categories" and better treated as continuous)


* d. Generate Regression Estimates of Effect of Studying Abroad on Belief in American national cohesion

regress Q26_rec treatment // Column 1: Base Model (OLS)
regress Q26_rec treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit


* e. Generate Regression Estimates of Effect of Studying Abroad on Identification with the American nation

regress Q41a_rec treatment if Q41a!=8 // Column 1: Base Model (OLS) (Excludes "Don't Know")
regress Q41a_rec treatment flor-welles if Q41a!=8 // Column 2: Add University Fixed Effects (OLS)
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q41a!=8 // Column 3: Add Full Set of Controls (OLS)
oprobit Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q41a!=8 // Column 4: Ordered Probit


* f. Generate Regression Estimates of Effect of Studying Abroad on Belief in American national superiority

regress natsuperiority treatment // Column 1: Base Model (OLS) 
regress natsuperiority treatment flor-welles // Column 2: Add University Fixed Effects (OLS)
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 3: Add Full Set of Controls (OLS)
oprobit natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 4: Ordered Probit

***************************************************************************************
* TABLE 5: Measurement details and summary statistics for dependent variables
***************************************************************************************

* Shared International Community (H1)

foreach var in sharevalue shareunderst Q24 trust laptop {

	summ `var'
	tabulate treatment, summarize(`var')


}

* Threat Perception (H2)

foreach var in Q21_rec Q22_rec Q23_rec {

	summ `var'
	tabulate treatment, summarize(`var')


}

* Nationalism (H3)


foreach var in nationalism natpride Q31 Q26_rec Q41a_rec natsuperiority {

	summ `var'
	tabulate treatment, summarize(`var')


}

