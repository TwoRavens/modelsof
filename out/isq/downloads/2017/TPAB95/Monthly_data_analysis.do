* Article title: "Categories, Creditworthiness and Contagion: How Investors' Shortcuts Affect Sovereign Debt Markets"
*
* Journal: International Studies Quarterly
*
* Authors:  Sarah Brooks, Ohio State University
*          	Layna Mosley, University of North Carolina, Chapel Hill
*           Raphael Cunha, Ohio State University
*
*
* This replication code is for the part of the statistical analysis that uses monthly data
* (Tables 1, 2, and 3 of the main text and Tables A6, A7, A8, A9, A12, and A13 of the Data Appendix).
*
* This Stata do-file is for use with the accompanying dataset saved as "monthly_data.dta".


*Stata version:
version 11.2

**********************
*** PREPARING DATA ***
**********************

*Preparing data for dynamic plots in R
gen d_cdslong = d.cdslong
gen l_cdslong = l.cdslong
gen d_sspread = d.sspread
gen l_sspread = l.sspread

gen d_cdsfitchnosignsdiff = d.cdsfitchnosignsdiff
gen l_cdsfitchnosignsdiff = l.cdsfitchnosignsdiff
gen d_sspreadfitchnosignsdiff = d.sspreadfitchnosignsdiff
gen l_sspreadfitchnosignsdiff = l.sspreadfitchnosignsdiff
gen d_fitchnosigns = d.fitchnosigns
gen l_fitchnosigns = l.fitchnosigns

gen d_cdsfitchdiff = d.cdsfitchdiff
gen l_cdsfitchdiff = l.cdsfitchdiff
gen d_fitchrating = d.fitchrating
gen l_fitchrating = l.fitchrating
gen d_sspreadfitchdiff = d.sspreadfitchdiff
gen l_sspreadfitchdiff = l.sspreadfitchdiff
gen d_fitchlettercdsdiff = d.fitchlettercdsdiff
gen l_fitchlettercdsdiff = l.fitchlettercdsdiff
gen l_fitchletter = l.fitchletter
gen d_fitchletter = d.fitchletter
gen d_fitchallcdsdiff = d.fitchallcdsdiff
gen l_fitchallcdsdiff = l.fitchallcdsdiff
gen l_fitchall = l.fitchall
gen d_fitchall = d.fitchall
gen d_fitchinvgradecdsdiff = d.fitchinvgradecdsdiff
gen l_fitchinvgradecdsdiff = l.fitchinvgradecdsdiff
gen l_fitchinvgrade = l.fitchinvgrade
gen d_fitchinvgrade = d.fitchinvgrade
gen d_cdsregiondiff = d.cdsregiondiff 
gen l_cdsregiondiff = l.cdsregiondiff
gen l_cdsmscidiff = l.cdsmscidiff
gen d_cdsmscidiff = d.cdsmscidiff
gen l_msci = l.msci
gen d_msci = d.msci
gen l_cdsftsediff = l.cdsftsediff
gen d_cdsftsediff = d.cdsftsediff
gen l_ftsecat = l.ftsecat
gen d_ftsecat = d.ftsecat
gen l_sspreadfitchalldiff = l.sspreadfitchalldiff
gen d_sspreadfitchalldiff = d.sspreadfitchalldiff
gen l_sspreadfitchinvdiff = l.sspreadfitchinvdiff
gen d_sspreadfitchinvdiff = d.sspreadfitchinvdiff
gen l_sspreadfitchletterdiff = l.sspreadfitchletterdiff
gen d_sspreadfitchletterdiff = d.sspreadfitchletterdiff
gen l_sspreadregiondiff = l.sspreadregiondiff
gen d_sspreadregiondiff = d.sspreadregiondiff 
gen l_sspreadftsediff = l.sspreadftsediff
gen d_sspreadftsediff = d.sspreadftsediff
gen l_sspreadmscidiff = l.sspreadmscidiff
gen d_sspreadmscidiff = d.sspreadmscidiff

gen l_msci_new = l.msci_new
gen d_msci_new = d.msci_new
gen l_ftsecat_new = l.ftsecat_new
gen d_ftsecat_new = d.ftsecat_new

gen l_energyindex = l.energyindex
gen l_months_to_election = l.months_to_election
gen d_stock = d.stock
gen l_stock = l.stock
gen d_usmkt = d.usmkt
gen l_usmkt = l.usmkt
gen l_ig = l.ig
gen l_hy = l.hy
gen l_trsy = l.trsy
gen l_eqprem = l.eqprem
gen l_volprem = l.volprem
gen l_termprem = l.termprem
gen d_bondflo = d.bondflo
gen l_bondflo = l.bondflo
gen d_fxrate = d.fxrate
gen l_fxrate = l.fxrate
gen l_debtgni = l.debtgni
gen l_inflation = l.inflation
gen l_budgetbal = l.budgetbal
gen l_gdpcapusd = l.gdpcapusd
gen d_usprime = d.usprime
gen l_usprime = l.usprime
gen l_democracy = l.democracy
gen l_kaopen = l.kaopen
gen l_cab = l.cab


**************************
*** SUMMARY STATISTICS ***
**************************

*TABLE 1. Summary Statistics: Monthly Data

sum cdslong sspread usmkt trsy ig hy eqprem volprem termprem stockflo bondflo fxrate debtgni ///
maturity inflation budgetbal gdpcapusd democracy kaopen system fitchrating usprime left right


*****************************
*** MONTHLY DATA ANALYSIS ***
*****************************

*TABLE 2. Explaining Monthly Changes in Credit Default Swap Prices

*Model (1)
xi: xtgls d.cdslong l.cdslong l.cdsregiondiff d.cdsregiondiff i.region ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Model (2)
xi: xtgls d.cdslong l.cdslong  l.cdsfitchnosignsdiff d.cdsfitchnosignsdiff l.fitchnosigns d.fitchnosigns ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Model (3)
xi: xtgls d.cdslong l.cdslong l.cdsftsediff d.cdsftsediff l.ftsecat d.ftsecat ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Model (4)
xi: xtgls d.cdslong l.cdslong l.cdsmscidiff d.cdsmscidiff l.msci d.msci ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force


*TABLE 3. Explaining Monthly Changes in Sovereign Bond Spreads

*Model (5)
xi: xtgls d.sspread l.sspread l.sspreadregiondiff d.sspreadregiondiff ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum i.region, ///
p(h) c(ar1) force

*Model (6)
xi: xtgls d.sspread l.sspread l.sspreadfitchnosignsdiff d.sspreadfitchnosignsdiff l.fitchnosigns d.fitchnosigns ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Model (7)
xi: xtgls d.sspread l.sspread l.sspreadftsediff d.sspreadftsediff l.ftsecat d.ftsecat ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Model (8)
xi: xtgls d.sspread l.sspread l.sspreadmscidiff d.sspreadmscidiff l.msci d.msci ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force



*****************************************
*** ROBUSTNESS CHECKS (DATA APPENDIX) ***
*****************************************

*TABLE A6. Explaining Monthly Changes in CDS Prices (Including Month Fixed Effects)

*Region
xi: xtgls d.cdslong l.cdslong l.cdsregiondiff d.cdsregiondiff i.region ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force

*Risk Rating
xi: xtgls d.cdslong l.cdslong l.cdsfitchnosignsdiff d.cdsfitchnosignsdiff l.fitchnosigns d.fitchnosigns ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force

*FTSE
xi: xtgls d.cdslong l.cdslong l.cdsftsediff d.cdsftsediff l.ftsecat d.ftsecat ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force

*MSCI
xi: xtgls d.cdslong l.cdslong l.cdsmscidiff d.cdsmscidiff l.msci d.msci ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force


*TABLE A7. Explaining Monthly Changes in Sovereign Bond Spreads (Including Month Fixed Effects)*Region
xi: xtgls d.sspread l.sspread l.sspreadregiondiff d.sspreadregiondiff i.region ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force

*Risk Rating
xi: xtgls d.sspread l.sspread l.sspreadfitchnosignsdiff d.sspreadfitchnosignsdiff l.fitchnosigns d.fitchnosigns ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force

*FTSE
xi: xtgls d.sspread l.sspread l.sspreadftsediff d.sspreadftsediff l.ftsecat d.ftsecat ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force

*MSCI
xi: xtgls d.sspread l.sspread l.sspreadmscidiff d.sspreadmscidiff l.msci d.msci ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
i.time i.conum, ///
p(h) c(ar1) force


*TABLE A8. Explaining Monthly Changes in CDS Prices (Alternative Measures of the Risk Rating Peer Diffusion Variable)
*Risk Rating (Fitch - All)
xi: xtgls d.cdslong l.cdslong l.fitchallcdsdiff d.fitchallcdsdiff l.fitchall d.fitchall ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Risk Rating (Fitch - Investment Grade)
xi: xtgls d.cdslong l.cdslong l.fitchinvgradecdsdiff d.fitchinvgradecdsdiff l.fitchinvgrade d.fitchinvgrade ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force


*TABLE A9. Explaining Monthly Changes in Sovereign Bond Spreads (Alternative Measures of the Fitch Risk Rating Peer Diffusion Variable)

*Risk Rating (Fitch - All)
xi: xtgls d.sspread l.sspread l.sspreadfitchalldiff d.sspreadfitchalldiff l.fitchall d.fitchall ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force

*Risk Rating (Fitch - Investment Grade)
xi: xtgls d.sspread l.sspread l.sspreadfitchinvdiff d.sspreadfitchinvdiff l.fitchinvgrade d.fitchinvgrade ///
l.debtgni l.budgetbal l.cab l.inflation l.gdpcapusd l.kaopen l.fxrate d.fxrate l.democracy l.months_to_election ///
l.usprime d.usprime l.usmkt d.usmkt  l.ig l.hy l.trsy l.volprem l.eqprem l.termprem l.stock d.stock l.bondflo d.bondflo l.energyindex ///
time i.conum, ///
p(h) c(ar1) force


*Correlation Matrices for Peer-Group Diffusion Terms (TABLES A12 & A13)
corr cdsfitchdiff cdsregiondiff cdsftsediff cdsmscidiff
corr sspreadfitchdiff sspreadregiondiff sspreadftsediff sspreadmscidiff


