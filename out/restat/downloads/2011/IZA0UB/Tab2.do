program drop _all

/* THIS PROGRAM SHOWS MEAN COMPARISONS BETWEEN DOMESTIC AND FOREIGN FIRMS IN TABLE 2; IC-STATA ver. 10.1.
   NOTE: 
   - All the source and results files are saved at single directory: C:\RESTAT\ 
   - AT the end the data are restricted only to domestic firms and file used in regression analysis: data1.dta is generated */


program define MEANS
clear all
set more off
set memory 80m
set matsize 800
use  C:\RESTAT\mean_comparisons.dta, replace
log using C:\RESTAT\Tab2.log, replace



              tsset firm year


/* COMPARE MEANS BETW DOMESTIC AND FOREIGN FIRMS */

display" Domestic firms: FOR_all=0; Foreign firms: FOR_all==1"


ttest growth, by(FOR_all)
ttest mktshare , by(FOR_all)
ttest mktsh_US2,  by(FOR_all)
ttest employ, by(FOR_all)
ttest operatin, by(FOR_all)
ttest KL, by(FOR_all)
ttest intangib , by(FOR_all)
ttest tasset, by(FOR_all)
ttest intang, by(FOR_all)
ttest sales, by(FOR_all)
ttest addedval, by(FOR_all)
ttest retass, by(FOR_all)
ttest liquidit, by(FOR_all)
ttest solvency, by(FOR_all)
ttest CFR, by(FOR_all)
ttest profitma, by(FOR_all)


log close
end

