************************************************************************************
************************************************************************************
*              Commitment to political ideology is a luxury only students 
*               can afford: A distributive justice experiment:
*                           Cordoba+Bilbao; 2014
************************************************************************************
************************************************************************************
capture log close
set more off

use DBMU_JEPS.dta, clear

log using DBMU_JEPS.log, replace

************************************************************************************
* Table 1: See below after reshape
************************************************************************************

************************************************************************************
* Footnote 11: See below after reshape
************************************************************************************

************************************************************************************
* Linear Restriction Test on page 9: H0: AEE = 0 for Unemployed: 
* See below after reshape
************************************************************************************

************************************************************************************
* Linear Restriction Test on page 9: Joint significance of all leri variables: 
* See below after reshape
************************************************************************************

************************************************************************************
* Figure 1. The effect of ideology on the acknowledgement of entitlement:
* See below after reshape
************************************************************************************

************************************************************************************
* Linear Restriction Tests on page 11: Test for AEE at each possible value of leri
* See below after reshape
************************************************************************************



************************************************************************************
* Table A.1: Participants and treatment assignment
************************************************************************************
ta female 
ta female if unemployed==1 
ta female if employed==1 
ta female if student==1 
 
mean(age) 
mean(age) if unemployed==1 
mean(age) if employed==1 
mean(age) if student==1 

mean(yed) 
mean(yed) if unemployed==1 
mean(yed) if employed==1 
mean(yed) if student==1 

mean(leri) 
mean(leri) if unemployed==1 
mean(leri) if employed==1 
mean(leri) if student==1 

ta Cordoba 
ta Cordoba if unemployed==1 
ta Cordoba if employed==1 
ta Cordoba if student==1 

ta earned 
ta earned if unemployed==1 
ta earned if employed==1 
ta earned if student==1 


************************************************************************************
* Figure A.1: Distribution of Left-right
************************************************************************************
hist(leri), discrete width(1) percent xlabel(1(1)10)




// Creating initial values for self to use in Part 5 of Supplementary Materials
gen initiii=init1 if rank==1
replace initiii=init2 if rank==2
replace initiii=init3 if rank==3
replace initiii=init4 if rank==4


// Creating a variable so that later we can try clustering @ the session level
gen city=Cordoba+1
gen sesnum=(city*100)+session


**************************************************************************
*  Reshape: Convert data from wide to long                              
**************************************************************************
reshape long init final, i(id) j(grank)

gen self=.
replace self=1 if rank==grank
replace self=0 if rank>grank
replace self=0 if rank<grank

gen initj=init
gen initi=init if self==1

gen finalij=final
gen finalii=final if self==1

* Interactions for main model
gen initje=initj*earned
gen leri_e=leri*earned
gen leri_initj=leri*initj
gen leri_initje=leri*earned*initj
gen unempe=unemployed*earned
gen unemp_initj=unemployed*initj
gen unemp_initje=unemployed*initje



************************************************************************************
* Table 1: Regression analysis of the effect of ideology and employment status on 
* distributive preferences
************************************************************************************

// Column 1: Full Sample
regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje if self==0&blue<44, cluster(id)

// Column 2: Employed
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&employed==1, cluster(id)

// Column 3: Unemployed
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&unemployed==1, cluster(id)

// Column 4: Students
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==1, cluster(id)



************************************************************************************
* Footnote 11: Including an indicator var. for students and its interactions
************************************************************************************
gen student_e=student*earned
gen student_initj=student*initj
gen student_initje=student*initje

regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje student student_e student_initj student_initje if self==0&blue<44, cluster(id)
test student student_e student_initj student_initje

* Excluding decisions of students from Model 1:
regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==0, cluster(id)



************************************************************************************
* Linear Restriction Tests on page 9
************************************************************************************
* Null Hypothesis: AEE = 0 for Unemployed
regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje if self==0&blue<44, cluster(id)
test initje + unemp_initje = 0
test initje + unemp_initje + leri_initje = 0

* Joint significance of all leri variables
regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje if self==0&blue<44, cluster(id)
test leri leri_e leri_initj leri_initje


************************************************************************************
* Figure 1. The effect of ideology on the acknowledgement of entitlement. 
************************************************************************************

*** Panel A: Employed ***
* The individual slopes for the Earned Treatment are:
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&employed==1, cluster(id)
forval i=1/10 {
display "leri=`i', earned slope="
display _b[initj]+_b[initje]+_b[leri_initj]*`i'+_b[leri_initje]*`i'
}
 
* The individual slopes for the Random Treatment are:
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&employed==1, cluster(id)
forval i=1/10 {
display "leri=`i', random slope="
display _b[initj]+_b[leri_initj]*`i'
}

 
*** Panel B: Unemployed ***
* The individual slopes for the Earned Treatment are:
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&unemployed==1, cluster(id)
forval i=1/10 {
display "leri=`i', earned slope="
display _b[initj]+_b[initje]+_b[leri_initj]*`i'+_b[leri_initje]*`i'
}
 
* The individual slopes for the Random Treatment are:
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&unemployed==1, cluster(id)
forval i=1/10 {
display "leri=`i', random slope="
display _b[initj]+_b[leri_initj]*`i'
} 


*** Panel C: Students ***
* The individual slopes for the Earned Treatment are:
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==1, cluster(id)
forval i=1/10 {
display "leri=`i', earned slope="
display _b[initj]+_b[initje]+_b[leri_initj]*`i'+_b[leri_initje]*`i'
}

* The individual slopes for the Random Treatment are:
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==1, cluster(id)
forval i=1/10 {
display "leri=`i', random slope="
display _b[initj]+_b[leri_initj]*`i'
}


************************************************************************************
* Linear Restriction Tests on page 11: Test for AEE at each possible value of leri:
* Unemployed, Students
************************************************************************************

* When performing this and other sets of linear restriction tests relating to specific 
* values of leri_i we use the Benjamini-Hochbergís (1995) false discovery rate (FDR) 
* procedure to correct for multiple comparisons. We worked through the adjustments in 
* an Excel file using FDRs of 0.05 and 0.10.



************************************************************************************
* Linear Restriction Tests: Section 4 of Supplementary Materials 
************************************************************************************

* 1) Testing linearity in initj

* Creating dummies for each value of initj (with one as reference)
gen yj2=1 if initj>.2 & initj<.25
replace yj2=0 if initj<=.2 | initj>=.25
gen yj3=1 if initj>.25 & initj<.35
replace yj3=0 if initj<=.25 | initj>=.35
gen yj4=1 if initj>.35
replace yj4=0 if initj<=.35
 
* Now interacting these dummies with E, leri, leri*E, unemployed, unemployed*E: 
gen yj2e=yj2*earned
gen yj3e=yj3*earned
gen yj4e=yj4*earned
 
gen leri_yj2= leri*yj2
gen leri_yj3= leri*yj3
gen leri_yj4= leri*yj4
 
gen leri_yj2e= leri*yj2e
gen leri_yj3e= leri*yj3e
gen leri_yj4e= leri*yj4e

gen unemp_yj2= unemployed*yj2
gen unemp_yj3= unemployed*yj3
gen unemp_yj4= unemployed*yj4
 
gen unemp_yj2e= unemployed*yj2e
gen unemp_yj3e= unemployed*yj3e
gen unemp_yj4e= unemployed*yj4e

regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje yj3 yj4 yj3e yj4e leri_yj3 leri_yj4 leri_yj3e leri_yj4e unemp_yj3 unemp_yj4 unemp_yj3e unemp_yj4e if self==0&blue<44, cluster(id)
test yj3 yj4 yj3e yj4e leri_yj3 leri_yj4 leri_yj3e leri_yj4e unemp_yj3 unemp_yj4 unemp_yj3e unemp_yj4e


* 2) Test for linearity in leri

* Squaring leri and interacting it with E, initj, initj*E 
gen lerisq=leri*leri
gen lerisq_e=lerisq*earned
gen lerisq_initj=lerisq*initj
gen lerisq_initje=lerisq*initje

regress finalij earned initj initje unemployed unempe unemp_initj unemp_initje leri leri_e leri_initj leri_initje lerisq lerisq_e lerisq_initj lerisq_initje if self==0&blue<44, cluster(id)
test lerisq lerisq_e lerisq_initj lerisq_initje



************************************************************************************
* Table A.2: Regression Analysis of Selfishness
************************************************************************************

* Creating interaction terms
gen initie=initi*earned
gen leri_initi=leri*initi
gen leri_initie=leri*initie
gen unemp_initi =unemployed*initi
gen unemp_initie=unemployed*initi*earned

// Column 1: Continuous dependant variable
regress finalii earned initi initie leri leri_e leri_initi leri_initie unemployed unempe unemp_initi unemp_initie if self==1, cluster(id)
test leri leri_e leri_initi leri_initie
test unemployed unempe unemp_initi unemp_initie

// Column 2: Binary dependant variable
regress selfish earned initi initie leri leri_e leri_initi leri_initie unemployed unempe unemp_initi unemp_initie if self==1, cluster(id)
test leri leri_e leri_initi leri_initie
test unemployed unempe unemp_initi unemp_initie



************************************************************************************
* Table A.3: Re-estimation of the effect of ideology and employment status on 
* distributive preferences accounting for clustering non-parametrically and at 
* different levels 
************************************************************************************

// Column 1: Full Sample
* At the individual level (reported in curved brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje unemployed unempe unemp_initj unemp_initje if self==0&blue<44, cluster(id) bootcluster(id) reps(1000) seed(1)

* At the session level (reported in square brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje unemployed unempe unemp_initj unemp_initje if self==0&blue<44, cluster(sesnum) bootcluster(sesnum) reps(1000) seed(1)


// Column 2: Employed
* At the individual level (reported in curved brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&employed==1, cluster(id) bootcluster(id) reps(1000) seed(1)

* At the session level (reported in square brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&employed==1, cluster(sesnum) bootcluster(sesnum) reps(1000) seed(1)


// Column 3: Unemployed
* At the individual level (reported in curved brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&unemployed==1, cluster(id) bootcluster(id) reps(1000) seed(1)

* At the session level (reported in square brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&unemployed==1, cluster(sesnum) bootcluster(sesnum) reps(1000) seed(1)


// Column 4: Students
* At the individual level (reported in curved brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==1, cluster(id) bootcluster(id) reps(1000) seed(1)

* At the session level (reported in square brackets)
cgmwildboot finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==1, cluster(sesnum) bootcluster(sesnum) reps(1000) seed(1)



************************************************************************************
* Table A.4: Re-estimation of the effect of ideology and student status on 
* distributive preferences
************************************************************************************

// Column 1: No controls
regress finalij earned initj initje leri leri_e leri_initj leri_initje if self==0&blue<44&student==1, cluster(id)

// Column 2: Age
*demeaning age
egen mage=mean(age) 
gen agedm=age-mage

gen age_e=agedm*earned
gen age_initj=agedm*initj
gen age_initje=agedm*initje

regress finalij earned initj initje leri leri_e leri_initj leri_initje agedm age_e age_initj age_initje if self==0&blue<44&student==1, cluster(id)
test agedm age_e age_initj age_initje


// Column 3: Bilbao
*generating interactions
gen Bilbao=Cordoba==0
gen Bilbao_e=Bilbao*earned
gen Bilbao_initj=Bilbao*initj
gen Bilbao_initje=Bilbao*initje

regress finalij earned initj initje leri leri_e leri_initj leri_initje Bilbao Bilbao_e Bilbao_initj Bilbao_initje if self==0&blue<44&student==1, cluster(id)
test Bilbao Bilbao_e Bilbao_initj Bilbao_initje


// Column 4: Female
*generating interactions
gen female_e=female*earned
gen female_initj=female*initj
gen female_initje=female*initje

regress finalij earned initj initje leri leri_e leri_initj leri_initje female female_e female_initj female_initje if self==0&blue<44&student==1, cluster(id)
test female female_e female_initj female_initje


// Column 5: Education (years)
*demeaning education
egen myed=mean(yed) 
gen yeddm=yed-myed

gen yed_e=yeddm*earned
gen yed_initj=yeddm*initj
gen yed_initje=yeddm*initje

regress finalij earned initj initje leri leri_e leri_initj leri_initje yeddm yed_e yed_initj yed_initje if self==0&blue<44&student==1, cluster(id)
test yeddm yed_e yed_initj yed_initje


log close
