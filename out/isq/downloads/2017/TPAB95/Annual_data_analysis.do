* Article title: "Categories, Creditworthiness and Contagion: How Investors' Shortcuts Affect Sovereign Debt Markets"
*
* Journal: International Studies Quarterly
*
* Authors:  Sarah Brooks, Ohio State University
*          	Layna Mosley, University of North Carolina, Chapel Hill
*           Raphael Cunha, Ohio State University
*
*
* This replication code is for the part of the statistical analysis that uses annual data
* (Tables A3 & A4 of the Data Appendix).
*
* This Stata do-file is for use with the accompanying dataset saved as "annual_data.dta".


*Stata version:
version 11.2


**************************
*** SUMMARY STATISTICS ***
**************************

*TABLE A3. Summary Statistics: Annual Data

sum sspread debtgni maturity inflation budgetbal gdpcapusd fitchrating kaopen system yearcurnt ///
left right oppright oppleft usprime


****************************
*** ANNUAL DATA ANALYSIS ***
****************************

*TABLE A4. Explaining Annual Changes in Sovereign Bond Spreads

*Region
xi: xtgls d.sspread l.sspread l.sspreadregiondiff d.sspreadregiondiff i.region l.govcon d.govcon l.debtgni d.debtgni l.maturity ///
d.maturity l.inflation d.inflation l.budgetbal d.budgetbal l.democracy d.democracy l.kaopen d.kaopen l.left l.right ///
l.oppright l.oppleft l.system l.usprime d.usprime l.time l.yearcurnt d.yearcurnt i.conum, ///
p(h) c(ar1) force

*Risk Rating
xi: xtgls d.sspread l.sspread d.sspreadfitchdiff l.sspreadfitchdiff l.fitchrating d.fitchrating l.govcon d.govcon l.debtgni d.debtgni l.maturity ///
d.maturity l.inflation d.inflation l.budgetbal d.budgetbal l.democracy d.democracy l.kaopen d.kaopen l.left l.right ///
l.oppright l.oppleft l.system l.usprime d.usprime l.time l.yearcurnt d.yearcurnt i.conum, ///
p(h) c(ar1) force

*MSCI
xi: xtgls d.sspread l.sspread d.sspreadmscidiff l.sspreadmscidiff l.msci d.msci l.govcon d.govcon l.debtgni d.debtgni l.maturity ///
d.maturity l.inflation d.inflation l.budgetbal d.budgetbal l.democracy d.democracy l.kaopen d.kaopen l.left l.right ///
l.oppright l.oppleft l.system l.usprime d.usprime l.time l.yearcurnt d.yearcurnt i.conum, ///
p(h) c(ar1) force

*FTSE
xi: xtgls d.sspread l.sspread d.sspreadftsediff l.sspreadftsediff l.ftsecat d.ftsecat l.govcon d.govcon l.debtgni d.debtgni l.maturity ///
d.maturity l.inflation d.inflation l.budgetbal d.budgetbal l.democracy d.democracy l.kaopen d.kaopen l.left l.right ///
l.oppright l.oppleft l.system l.usprime d.usprime l.time l.yearcurnt d.yearcurnt i.conum, ///
p(h) c(ar1) force

