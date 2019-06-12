**Replication file for Murdie, Amanda and Craig Stapley. "Why Target the 'Good Guys'? The Determinants of Terrorism Against NGOs." International Interactions.
*Documentation for datasets used provided in text of manuscript.
***Please feel free to contact us if you have any questions about the dataset or do file - we are happy to help!  amandamurdie@gmail.com or murdiea@missouri.edu 


***Tables in Manuscript

***Table 1 

xtnbreg NGOtarget lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table1, replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table1 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table1 , append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table1 , append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")


***Table 2


xtnbreg NGOtarget DHROsec  polity2  conflictatall   lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table2 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget DHROsec  polity2  conflictatall   lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table2 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd DHROsec  polity2  conflictatall   lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table2, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd DHROsec   polity2  conflictatall   lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table2 , append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")

***Figures in Manuscript (Note: we did change the color of the lines for publication)

***Figure 1


logit  NGOtargetd Llnhrfilled  lnLnonhrINGO2 polity2  conflictatall   lnpop lngdp   physint  US    lnnonNGO2, robust


drop durat* 

prgen Llnhrfilled , from (0) to (4.67) generate(durat) rest(median) ci 

label variable duratp1 "Probability of NGO Attack " 

label variable duratx "Human Rights INGOs (ln)"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"


twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none) yaxis(1)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(non) yaxis(1)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none) yaxis(1)) (kdensity Llnhrfilled if e(sample), yaxis(2))

***Figure 2 

logit  NGOtargetd Llnhrfilled  lnLnonhrINGO2 polity2  conflictatall   lnpop lngdp   physint  US    lnnonNGO2, robust

drop duraz*

prgen lnLnonhrINGO2 , from (0) to (8.15) generate(duraz) rest(median) ci 

label variable durazp1 "Probability of NGO Attack " 

label variable durazx "Other INGOs (ln)"  

label variable durazp1lb "95% lower limit" 

label variable durazp1ub "95% upper limit"
*can I overlay histogram on to prob????


twoway (connected durazp1 durazx, lpattern(solid) lwidth(medthick) msymbol(none) yaxis(1)) (connected durazp1lb durazx, lpattern(dash) lwidth(thin) msymbol(non) yaxis(1)) (connected  durazp1ub durazx, lpattern(dash) lwidth(thin) msymbol(none) yaxis(1)) (kdensity lnLnonhrINGO2 if e(sample), yaxis(2))


*****Tables from the online appendix



*HRspecific NGO Attacks - Table R1 

xtnbreg HRspecificattack lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table6, replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb HRspecificattack  lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table6, append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")


xtgee HRspecificattackd  lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table6, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  HRspecificattackd lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table6, append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")





*nonHR specific attacks - Table R2

xtnbreg nonHRspecificattack lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table7, replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb nonHRspecificattack lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table7, append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")


xtgee nonHRspecificattackd   lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table7, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  nonHRspecificattackd lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table7, append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")




*Advocacy and Nonadvocacy NGOs - Table R3



xtnbreg NGOtarget advocacy lnLnonhrenv    polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table5 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget advocacy lnLnonhrenv   polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table5, append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd advocacy  lnLnonhrenv  polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table5 , append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd advocacy    lnLnonhrenv polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table5, append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")


*Environmental, HR, and Other - Table R4



xtnbreg NGOtarget lnLenvfilled lnLhrfilled lnLnonhrenv    polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table4, replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget lnLenvfilled  lnLhrfilled lnLnonhrenv   polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table4, append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLenvfilled lnLhrfilled  lnLnonhrenv  polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table4, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd lnLenvfilled lnLhrfilled    lnLnonhrenv polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using  Table4, append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")


*without physint and ingo count - Tables R5 & R6



xtnbreg NGOtarget lnLhrfilled  polity2  conflictatall   intervention lnpop lngdp   US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table3 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget lnLhrfilled  polity2  conflictatall  intervention  lnpop lngdp     US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table3 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLhrfilled polity2  conflictatall  intervention  lnpop lngdp   US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table3 , append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd lnLhrfilled   polity2  conflictatall  intervention  lnpop lngdp   US  lnnonNGO2
outreg2 using Table3 , append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")

*****

xtnbreg NGOtarget DHROsec  polity2  conflictatall   lnpop lngdp    US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table2 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget DHROsec  polity2  conflictatall   lnpop lngdp    US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table2 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd DHROsec  polity2  conflictatall   lnpop lngdp   US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table2, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd DHROsec   polity2  conflictatall   lnpop lngdp    US  lnnonNGO2
outreg2 using Table2 , append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")

*interact with physint - Tables R7 and R8


 xtnbreg NGOtarget lnLhrfilledXphysint lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table8, replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget lnLhrfilledXphysint lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table8, append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLhrfilledXphysint lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table8, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd lnLhrfilledXphysint lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table8, append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")

*****interact with Dphysint 


 xtnbreg NGOtarget lnLhrfilledXDphysint lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   Dphysint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table9 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget lnLhrfilledXDphysint lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   Dphysint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table9 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLhrfilledXDphysint lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   Dphysint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table9, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd lnLhrfilledXDphysint lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   Dphysint  US  lnnonNGO2
outreg2 using Table9 , append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")


*Omit Peacekeepers - Table R9


xtnbreg noPeaceNGO lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table12 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb noPeaceNGO lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table12 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table12 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

relogit  NGOtargetd lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table12 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")


*NonIslam attacks - Table R10 


xtnbreg nonIslam  lnLhrfilled lnLnonhrINGO2 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table10 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb nonIslam  lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using  Table10 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")


xtgee nonIslamd lnLhrfilled lnLnonhrINGO2 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table10, append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit nonIslamd lnLhrfilled lnLnonhrINGO2  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table10, append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")

*Islam indicator - Table R11 

xtnbreg NGOtarget lnLhrfilled lnLnonhrINGO2  lp_muslim80 polity2  conflictatall   intervention lnpop lngdp   physint US    lnnonNGO2, pa corr(ar1) force robust
outreg2 using Table11 , replace word excel label bdec(5) title("Determinants of NGO Attacks") ctitle ("GEE Negative Binomial Model")

zinb NGOtarget lnLhrfilled lnLnonhrINGO2  lp_muslim80 polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2  , inflate(  lnnonNGO2) probit robust 
outreg2 using Table11 , append word excel label bdec(5)  ctitle ("Zero-Inflated Negative Binomial Model")

xtgee NGOtargetd lnLhrfilled lnLnonhrINGO2  lp_muslim80 polity2  conflictatall  intervention  lnpop lngdp   physint  US    lnnonNGO2, family(binomial)  corr(ar1) force robust
outreg2 using Table11 , append word excel label bdec(5)  ctitle ("GEE Logit for Dichotomous Dependent Variable")

relogit  NGOtargetd lnLhrfilled lnLnonhrINGO2  lp_muslim80  polity2  conflictatall  intervention  lnpop lngdp   physint  US  lnnonNGO2
outreg2 using Table11 , append word excel label bdec(5)  ctitle ("Rare Events Logit for Dichotomous Dependent Variable")




