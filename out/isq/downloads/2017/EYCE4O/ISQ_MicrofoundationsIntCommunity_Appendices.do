**********************************************
* ISQ Data Archive File
* Microfoundations of International Community
* APPENDICES
**********************************************

* Open Microfoundations Dataset

use "MicrofoundationsIntCommunityISQ.dta"


*************************************************************************
* Appendix 2: Distribution of college major categories across control and treatment 
*************************************************************************

* For chart, see accompanying Excel file; for CHI2 see below

tabulate majorcategory_rev treatment, chi2

*************************************************************************
* Appendix 3: Selection into treatment
*************************************************************************

* Table A3.1: F-Test results

foreach var in gender income international priorexposure parent hostfam {

	regress treatment `var'

}

regress treatment flor-welles
regress treatment sophomore-senior
regress treatment majorcategory_rev2-majorcategory_rev10
regress treatment myregion2-myregion7
regress treatment sophomore-senior flor-welles majorcategory_rev2-majorcategory_rev10 myregion2-myregion7
regress treatment Australia-Vietnam

* Table A3.2: Selection into treatment

regress treatment gender
regress treatment gender income
regress treatment gender income international
regress treatment gender income international priorexposure
regress treatment gender income international priorexposure parent
regress treatment gender income international priorexposure parent hostfam
regress treatment gender income international priorexposure parent hostfam flor-welles
regress treatment gender income international priorexposure parent hostfam flor-welles sophomore-senior
regress treatment gender income international priorexposure parent hostfam flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10
regress treatment gender income international priorexposure parent hostfam flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7

*************************************************************************
* Appendix 4: Extended results with controls added stepwise
*************************************************************************

* Table A4.1. Effects of studying abroad on belief in shared international community (H1)

* a. Shared Values

regress sharevalue treatment // Column 1: Base Model (OLS)
regress sharevalue treatment flor-welles // Column 2: Add university fixed effects
regress sharevalue treatment flor-welles sophomore-senior // Column 3: Control for class year
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* b. Shared Understandings

regress shareunderst treatment // Column 1: Base Model (OLS)
regress shareunderst treatment flor-welles // Column 2: Add university fixed effects
regress shareunderst treatment flor-welles sophomore-senior // Column 3: Control for class year
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* c. Warmth toward culture of host country

regress Q24 treatment if Q24<101 // Column 1: Base Model (OLS)
regress Q24 treatment flor-welles if Q24<101 // Column 2: Add university fixed effects
regress Q24 treatment flor-welles sophomore-senior if Q24<101 // Column 3: Control for class year
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if Q24<101 // Column 4: Control for major
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if Q24<101 // Column 5: Control for host country region 
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if Q24<101 // Column 6: Control for host country 
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q24<101 // Column 7: Add rest of controls
oprobit Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  if Q24<101 // Column 8: Ordered probit

* d. Generalized trust

regress trust treatment // Column 1: Base Model (OLS)
regress trust treatment flor-welles // Column 2: Add university fixed effects
regress trust treatment flor-welles sophomore-senior // Column 3: Control for class year
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* e. Situational trust

regress laptop treatment // Column 1: Base Model (OLS)
regress laptop treatment flor-welles // Column 2: Add university fixed effects
regress laptop treatment flor-welles sophomore-senior // Column 3: Control for class year
regress laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit laptop treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* Table A4.2. Effects of studying abroad on perceptions of threat posed by study abroad country (H2)

* a. Economic Threat

regress Q21_rec treatment // Column 1: Base Model (OLS)
regress Q21_rec treatment flor-welles // Column 2: Add university fixed effects
regress Q21_rec treatment flor-welles sophomore-senior // Column 3: Control for class year
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* b. Conventional Military Threat

regress Q22_rec treatment // Column 1: Base Model (OLS)
regress Q22_rec treatment flor-welles // Column 2: Add university fixed effects
regress Q22_rec treatment flor-welles sophomore-senior // Column 3: Control for class year
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* c. Nuclear Threat

regress Q23_rec treatment // Column 1: Base Model (OLS)
regress Q23_rec treatment flor-welles // Column 2: Add university fixed effects
regress Q23_rec treatment flor-welles sophomore-senior // Column 3: Control for class year
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* Table A4.3. Effects of studying abroad on nationalism (H3)

* a. Nationalism

regress nationalism treatment // Column 1: Base Model (OLS)
regress nationalism flor-welles // Column 2: Add university fixed effects
regress nationalism treatment flor-welles sophomore-senior // Column 3: Control for class year
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* b. Pride in America

regress natpride treatment // Column 1: Base Model (OLS)
regress natpride flor-welles // Column 2: Add university fixed effects
regress natpride treatment flor-welles sophomore-senior // Column 3: Control for class year
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit

* c. Feeling of warmth toward American culture

regress Q31 treatment if Q31!=101 // Column 1: Base Model (OLS)
regress Q31 flor-welles if Q31!=101 // Column 2: Add university fixed effects
regress Q31 treatment flor-welles sophomore-senior if Q31!=101 // Column 3: Control for class year
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if Q31!=101 // Column 4: Control for major
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if Q31!=101 // Column 5: Control for host country region 
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if Q31!=101 // Column 6: Control for host country 
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q31!=101 // Column 7: Add rest of controls
// oprobit Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q31!=101 // Column 8: Ordered probit


* d. Belief in American national cohesion

regress Q26_rec treatment // Column 1: Base Model (OLS)
regress Q26_rec flor-welles // Column 2: Add university fixed effects
regress Q26_rec treatment flor-welles sophomore-senior // Column 3: Control for class year
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit


* e. Identification with the American nation

regress Q41a_rec treatment if Q41a!=8 // Column 1: Base Model (OLS)
regress Q41a_rec flor-welles if Q41a!=8 // Column 2: Add university fixed effects
regress Q41a_rec treatment flor-welles sophomore-senior if Q41a!=8 // Column 3: Control for class year
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if Q41a!=8 // Column 4: Control for major
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if Q41a!=8 // Column 5: Control for host country region 
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if Q41a!=8 // Column 6: Control for host country 
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q41a!=8 // Column 7: Add rest of controls
oprobit Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q41a!=8 // Column 8: Ordered probit


* f. Belief in American national superiority

regress natsuperiority treatment // Column 1: Base Model (OLS)
regress natsuperiority flor-welles // Column 2: Add university fixed effects
regress natsuperiority treatment flor-welles sophomore-senior // Column 3: Control for class year
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 // Column 4: Control for major
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 // Column 5: Control for host country region 
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam // Column 6: Control for host country 
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam // Column 7: Add rest of controls
oprobit natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam  // Column 8: Ordered probit


*************************************************************************
* Appendix 5: Robust clustered standard errors
*************************************************************************

* "clustervar" refers to university affiliation (clustering by university)

* Table A5.1. Effects of studying abroad on belief in shared international community (H1) 

* a. Belief in shared values

regress sharevalue treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress sharevalue treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress sharevalue treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit sharevalue treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit

* b. Belief in shared understandings

regress shareunderst treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress shareunderst treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress shareunderst treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit shareunderst treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit

* c. Warmth toward culture of host country

regress Q24 treatment if Q24<101, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q24 treatment flor-welles if Q24<101, cluster(clustervar) // Column 2: Add university fixed effects
regress Q24 treatment flor-welles sophomore-senior if Q24<101, cluster(clustervar) // Column 3: Control for class year
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if Q24<101, cluster(clustervar) // Column 4: Control for major
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if Q24<101, cluster(clustervar) // Column 5: Control for host country region 
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if Q24<101, cluster(clustervar) // Column 6: Control for host country 
regress Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q24<101, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q24 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q24<101, cluster(clustervar) // Column 8: Ordered probit


* d. Generalized trust

regress trust treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress trust treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress trust treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit trust treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit


* e. Situational trust

regress laptop treatment if laptop!=5, cluster(clustervar) // Column 1: Base Model (OLS)
regress laptop  treatment flor-welles if laptop!=5, cluster(clustervar) // Column 2: Add university fixed effects
regress laptop  treatment flor-welles sophomore-senior if laptop!=5, cluster(clustervar) // Column 3: Control for class year
regress laptop  treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if laptop!=5, cluster(clustervar) // Column 4: Control for major
regress laptop  treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if laptop!=5, cluster(clustervar) // Column 5: Control for host country region 
regress laptop  treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if laptop!=5, cluster(clustervar) // Column 6: Control for host country 
regress laptop  treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if laptop!=5, cluster(clustervar) // Column 7: Add rest of controls
oprobit laptop  treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if laptop!=5, cluster(clustervar) // Column 8: Ordered probit

* Table A5.2. Effects of studying abroad on perceptions of threat posed by study abroad country (H2)

* a. Economic threat

regress Q21_rec treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q21_rec treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress Q21_rec treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q21_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit


* b. Conventional military threat

regress Q22_rec treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q22_rec treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress Q22_rec treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q22_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit

* c. Nuclear threat

regress Q23_rec treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q23_rec treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress Q23_rec treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q23_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit


* Table A5.3. Effects of studying abroad on nationalism (H3)

* a. Nationalism

regress nationalism treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress nationalism treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress nationalism treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit nationalism treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit

* b. Pride in America

regress natpride treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress natpride treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress natpride treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit natpride treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit


* c. Feeling of warmth toward American culture

regress Q31 treatment if Q31<101, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q31 treatment flor-welles if Q31<101, cluster(clustervar) // Column 2: Add university fixed effects
regress Q31 treatment flor-welles sophomore-senior if Q31<101, cluster(clustervar) // Column 3: Control for class year
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if Q31<101, cluster(clustervar) // Column 4: Control for major
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if Q31<101, cluster(clustervar) // Column 5: Control for host country region 
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if Q31<101, cluster(clustervar) // Column 6: Control for host country 
regress Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q31<101, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q31 treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q31<101, cluster(clustervar) // Column 8: Ordered probit


* d. Belief in American national cohesion

regress Q26_rec treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q26_rec treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress Q26_rec treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q26_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit


* e. Identification with the American nation

regress Q41a_rec treatment if Q41a_rec!=8, cluster(clustervar) // Column 1: Base Model (OLS)
regress Q41a_rec treatment flor-welles if Q41a_rec!=8, cluster(clustervar) // Column 2: Add university fixed effects
regress Q41a_rec treatment flor-welles sophomore-senior if Q41a_rec!=8, cluster(clustervar) // Column 3: Control for class year
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 if Q41a_rec!=8, cluster(clustervar) // Column 4: Control for major
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7 if Q41a_rec!=8, cluster(clustervar) // Column 5: Control for host country region 
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam if Q41a_rec!=8, cluster(clustervar) // Column 6: Control for host country 
regress Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q41a_rec!=8, cluster(clustervar) // Column 7: Add rest of controls
oprobit Q41a_rec treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam if Q41a_rec!=8, cluster(clustervar) // Column 8: Ordered probit


* f. Belief in American national superiority

regress natsuperiority treatment, cluster(clustervar) // Column 1: Base Model (OLS)
regress natsuperiority treatment flor-welles, cluster(clustervar) // Column 2: Add university fixed effects
regress natsuperiority treatment flor-welles sophomore-senior, cluster(clustervar) // Column 3: Control for class year
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10, cluster(clustervar) // Column 4: Control for major
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 myregion2-myregion7, cluster(clustervar) // Column 5: Control for host country region 
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam, cluster(clustervar) // Column 6: Control for host country 
regress natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 7: Add rest of controls
oprobit natsuperiority treatment flor-welles sophomore-senior majorcategory_rev2-majorcategory_rev10 Australia-Vietnam gender income international priorexposure parent hostfam, cluster(clustervar) // Column 8: Ordered probit

*************************************************************************
* Appendix 6: Matching by propensity score
*************************************************************************

* Randomly sort data

gen rand=uniform()
sort rand

* Table A6.1. Effects of studying abroad on belief in shared international community (H1)

* a. Belief in shared values

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(sharevalue)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(sharevalue)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(sharevalue)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(sharevalue)

* b. Belief in shared understandings

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(shareunderst)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(shareunderst)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(shareunderst)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(shareunderst)


* c. Warmth toward culture of host country

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q24<101, logit out(Q24)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q24<101, common logit out(Q24)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q24<101, common noreplace logit out(Q24)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q24<101, noreplace logit out(Q24)


* d. Generalized trust

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(trust)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(trust)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(trust)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(trust)


* e. Situational trust

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if laptop!=5, logit out(laptop)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if laptop!=5, common logit out(laptop)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if laptop!=5, common noreplace logit out(laptop)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if laptop!=5, noreplace logit out(laptop)

* Table A6.2. Effects of studying abroad on perceptions of threat from study abroad country (H2)

* a. Economic threat

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(Q21_rec)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(Q21_rec)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(Q21_rec)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(Q21_rec)

* b. Conventional military threat

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(Q22_rec)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(Q22_rec)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(Q22_rec)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(Q22_rec)


* c. Nuclear threat

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(Q23_rec)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(Q23_rec)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(Q23_rec)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(Q23_rec)

* Table A6.3. Effects of studying abroad on nationalism (H3)

* a. Nationalism

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(nationalism)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(nationalism)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(nationalism)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(nationalism)


* b. Pride in America

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(natpride)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(natpride)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(natpride)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(natpride)


* c. Feelings of warmth toward American culture

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q31!=101, logit out(Q31)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q31!=101, common logit out(Q31)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q31!=101, common noreplace logit out(Q31)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q31!=101, noreplace logit out(Q31)


* d. Belief in American national cohesion

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(Q26_rec)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(Q26_rec)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(Q26_rec)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(Q26_rec)


* e. Identification with the American nation

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q41a!=8, logit out(Q41a_rec)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q41a!=8, common logit out(Q41a_rec)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q41a!=8, common noreplace logit out(Q41a_rec)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7 if Q41a!=8, noreplace logit out(Q41a_rec)


* f. Belief in American national superiority

// Stata default: no common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, logit out(natsuperiority)
// Common support required and with replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common logit out(natsuperiority)
// Common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, common noreplace logit out(natsuperiority)
// *No* common support required and *without* replacement
psmatch2 treatment gender income international priorexposure parent hostfam sophomore-senior majorcategory_rev2-majorcategory_rev10 flor-welles myregion2-myregion7, noreplace logit out(natsuperiority)

*************************************************************************
* Appendix 7: Additional Robustness Checks
*************************************************************************

* For graph, see accompanying Excel file


