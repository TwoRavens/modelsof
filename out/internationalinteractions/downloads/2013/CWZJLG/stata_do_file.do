version 10

set matsize 500
set more off

sort id year
tsset id year

set more off

preserve

collapse (max) DDD DDR DRD DRR RRR RRD RDR RDD (max) unittax CorpIncTaxRate TotPersIncTaxRate PhD_1000pop EduExp, by(statecode year)

collapse (sum) DDD DDR DRD DRR RRR RRD RDR RDD (mean) unittax CorpIncTaxRate TotPersIncTaxRate PhD_1000pop EduExp, by(statecode)

tabstat DDD- RDD, stat(sum)

restore

preserve

keep if UnifRep==1 | UnifDem==1  
collapse (max) UnifRep UnifDem unittax CorpIncTaxRate TotPersIncTaxRate PhD_1000pop EduExp, by(statecode year)

ttest CorpIncTaxRate , by( UnifRep)
sort UnifRep unittax
by UnifRep: tab unittax
ttest unittax , by( UnifRep)
ttest TotPersIncTaxRate , by( UnifRep)
ttest EduExp , by( UnifRep)
ttest PhD_1000pop , by( UnifRep)

restore


tssmooth ma flow3ma=FDIflow, window(1 1 1)

xtpcse flow3ma L.(UnifRep  flow3ma  GrStateProd   GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7 if UnifRep==1 | UnifDem==1, pairwise corr(ar1)
outreg2 using tab1.rtf, nolabel ctitle("PCSE1") word symbol(***, **, *) alpha(0.01, 0.05, 0.10) title("Unified Republican government and FDI flow") replace

xtpcse flow3ma L.(UnifRep  flow3ma CorpIncTaxRate TotPersIncTaxRate unittax GrStateProd GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7 if UnifRep==1 | UnifDem==1, pairwise corr(ar1)
outreg2 using tab1.rtf , nolabel ctitle("PCSE2") word symbol(***, **, *) alpha(0.01, 0.05, 0.10)

xtpcse flow3ma L.(UnifRep  flow3ma   CorpIncTaxRate TotPersIncTaxRate  unittax  EduExp PhD_1000pop GrStateProd   GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7 if UnifRep==1 | UnifDem==1, pairwise corr(ar1)
outreg2 using tab1.rtf, nolabel ctitle("PCSE3") word symbol(***, **, *) alpha(0.01, 0.05, 0.10)

xtreg flow3ma L.(UnifRep  flow3ma   CorpIncTaxRate TotPersIncTaxRate  unittax  EduExp PhD_1000pop GrStateProd   GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7 if UnifRep==1 | UnifDem==1, fe
outreg2 using tab1.rtf, nolabel ctitle("FE") word symbol(***, **, *) alpha(0.01, 0.05, 0.10)



xtpcse flow3ma L.(Unified  flow3ma GrStateProd   GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7, pairwise corr(ar1)
outreg2 using tab2.rtf, nolabel ctitle("PCSE1") word symbol(***, **, *) alpha(0.01, 0.05, 0.10) title("Unified government and FDI flow") replace

xtpcse flow3ma L.(Unified  flow3ma CorpIncTaxRate TotPersIncTaxRate unittax GrStateProd GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7, pairwise corr(ar1)
outreg2 using tab2.rtf , nolabel ctitle("PCSE2") word symbol(***, **, *) alpha(0.01, 0.05, 0.10)

xtpcse flow3ma L.(Unified  flow3ma   CorpIncTaxRate TotPersIncTaxRate  unittax  EduExp PhD_1000pop GrStateProd GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7, pairwise corr(ar1)
outreg2 using tab2.rtf, nolabel ctitle("PCSE3") word symbol(***, **, *) alpha(0.01, 0.05, 0.10)

xtreg flow3ma L.(Unified  flow3ma   CorpIncTaxRate TotPersIncTaxRate  unittax  EduExp PhD_1000pop GrStateProd GSPgrowth  AvHrPay unemployd union) SouthStates time time2 _Icountry_2 _Icountry_3 _Icountry_4 _Icountry_5 _Icountry_6 _Icountry_7, fe
outreg2 using tab2.rtf, nolabel ctitle("FE") word symbol(***, **, *) alpha(0.01, 0.05, 0.10)


exit 