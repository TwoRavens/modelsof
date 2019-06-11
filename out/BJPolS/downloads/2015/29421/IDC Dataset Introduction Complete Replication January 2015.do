/************************
This file replicates all of the tables in:
Strøm, Kaare, Scott Gates, Benjamin A.T. Graham and Håvard Strand. “Inclusion, Dispersion, and Constraint: Powersharing in the World’s States, 1975-2010.” 
**************************/
clear
set mem 500m
capture log close
pause on
set more off


/****************************
Change the directory
*****************************/
cap cd "/Users/bengraham1/Dropbox/Collaborative Research/Powersharing/Dataset Introduction Paper/Replication data and codebooks (posted versions)/"

/****************************
Load the Data
*****************************/
use "IDC_country-year_v1_0.dta", clear

cap drop inclusive dispersive constraining /*this drops the three indices that this section of the file creates*/

/******************************
Recode missing values, iteregnum periods, and N/As to zero
*******************************/
foreach var in subed subtax subpolice stconst state_dummy1 state_dummy2 /*
*/relconstd relconstp milleg partynoethnic jconst jrevman jtenure_dummy1 jtenure_dummy2/*
*/ gcnew mveto resseats miman resman {
recode `var' -44 -77 . = 0
}

/***************************
Conduct the confirmatory factor analysis 
to create Table 1 in the paper
****************************/
factor subed subtax subpolice stconst state_dummy1 state_dummy2 /* 
*/relconstd relconstp milleg partynoethnic jconst jrevman jtenure_dummy1 jtenure_dummy2/* 
*/ gcnew mveto resseats miman resman 

rotate, factors(3)
pause

/************************
Now Create the Individual Indices
*************************/

factor subed subtax subpolice stconst state_dummy1 state_dummy2
rotate, factors(1)
predict dispersive

*pause

factor relconstd relconstp milleg partynoethnic jconst jrevman jtenure_dummy1 jtenure_dummy2
rotate, factors(1)
predict constraining

*pause

factor gcnew mveto resseats miman resman
rotate, factors(1)
predict inclusive

label var dispersive "Dispersive Powersharing"
label var constraining "Constraining Powersharing"
label var inclusive "Inclusive Powersharing"


/******************************
Now Create the Appendix Tables
*******************************/
ssc install sutex
ssc install corrtex
use "IDC_country-year_v1_0.dta", clear


label var subed "Subnational Education"
label var subtax "Subnational Tax"
label var subpolice "Subnational Police"
label var stconst "Constituency Alignment"
label var state_dummy1 "State Elections_1"
label var state_dummy2 "State Elections_2"
label var relconstp "Rel. Protect (Practice)"
label var relconstd "Rel Protect (Discrim)"
label var milleg "Military Leg. Ban"
label var partynoethnic "Ethnic Party Ban"
label var jconst "Judicial Constitution"
label var jrevman "Judicial Review"
label var jtenure_dummy1 "Judicial Tenure_1"
label var jtenure_dummy2 "Judicial Tenure_2"
label var gcnew "GC or Unity"
label var mveto "Mutual Veto"
label var resseats "Reserved Seats"
label var miman "Inclusive Military"
label var resman "Reserved Exec Positions"


/***********************
Change N/A's and intergnums to missing
***********************/
foreach var in subed subtax subpolice stconst state_dummy1 state_dummy2 /*
*/relconstd relconstp milleg partynoethnic jconst jrevman jtenure_dummy1 jtenure_dummy2/*
*/ gcnew mveto resseats miman resman {
recode `var' -44 -77 = .
}

/************************
Create Table A2 
Note: To look nice, in LaTex this must be 
a sideways table in footnotesize
with shortened column titles
*************************/
corrtex subed subtax subpolice stconst state_dummy1 state_dummy2 /* 
*/relconstd relconstp milleg partynoethnic jconst jrevman jtenure_dummy1 jtenure_dummy2/* 
*/ gcnew mveto resseats miman resman, file("big_correlation_table.tex") replace title("All Pairwise Correlations") dig(2)
pause

/************************
Create Table A1 
*************************/

label var subed "Subnational Education Authority"
label var subtax "Subnational Tax Authority"
label var subpolice "Subnational Police Authority"
label var stconst "Constituency Alignment"
label var state_dummy1 "State Elections_1"
label var state_dummy2 "State Elections_1"
label var relconstp "Religion Protected (Practice)"
label var relconstd "Religion Protected (Discrimination)"
label var milleg "Military Legislator Ban"
label var partynoethnic "Ethnic Party Ban"
label var jconst "Judicial Constitution"
label var jrevman "Judicial Review"
label var jtenure_dummy1 "Judicial Tenure_1"
label var jtenure_dummy2 "Judicial Tenure_2"
label var gcnew "Mandated GC or Unity"
label var mveto "Mutual Veto"
label var resseats "Reserved Seats"
label var miman "Inclusive Military"
label var resman "Reserved Executive Positions"

sutex inclusive dispersive constraining subed subtax subpolice stconst state_dummy1 state_dummy2 /* 
*/relconstd relconstp milleg partynoethnic jconst jrevman jtenure_dummy1 jtenure_dummy2/* 
*/ gcnew mveto resseats miman resman, file("summarystats_table.tex") replace title("Summary Statistics") labels minmax






capture: log close
exit
