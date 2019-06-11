***********************
***********************
*
*	Replication Do File for SPPQ  "Social Capital, Racial Context and 
*	Incarcerations in the American States" 
*	Daniel P. Hawes - Kent State University
*
*	Models were run using Stata 12.1 MP
* 	
************************
************************




*TABLE 1 - Summary Statistics 


use "http://dx.doi.org/10.15139/S3/SMKJFZ"
xtset fips year

*Crime models referenced in footnote 3, but not included in paper
xtpcse D.VCRate_Total D.SC8609_ma D.racialdiversity  d.ln_pctblk d.govideo d.totdempct d.women_leg d.gsppc_k d.unemp d.pov_rtfull d.bwpovratio d.eduattain_ma d.bwcolratio d.divorcerate d.felonspc d.blk_leg d.threestrikes d.GTClear d.darrest2 
xtpcse D.PCRate_Total D.SC8609_ma D.racialdiversity  d.ln_pctblk d.govideo d.totdempct d.women_leg d.gsppc_k d.unemp d.pov_rtfull d.bwpovratio d.eduattain_ma d.bwcolratio d.divorcerate d.felonspc d.blk_leg d.threestrikes d.GTClear d.darrest2 


* OLS model to establish full sample for summary statistics 
reg ln_prison_BWratio SC8609_ma racialdiversity ln_pctblk  VCRate_Total PCRate_Total govideo totdempct women_leg blk_leg /*
*/threestrikes GTClear darrest2 gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc

*TABLE 1 - Summary Statistics for cases in the full sample used (1143 cases)
sum jprison_totalrt prison_whtrt prison_blkrt prison_BWratio SC8609_ma racialdiversity pop_pctblk  VCRate_Total PCRate_Total govideo /*
*/totdempct women_leg blk_leg threestrikes GTClear darrest2 gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio /*
*/ divorcerate felonspc if e(sample)


*TABLE2 - Models 1-3 (Total, White and Black Incarceration Rates)
*install xtsur package from http://fmwww.bc.edu/RePEc/bocode/x if not installed 
xtsur (jprison_totalrt SC8609_ma racialdiversity ln_pctblk  VCRate_Total PCRate_Total govideo totdempct women_leg blk_leg threestrikes GTClear darrest2  /*
*/gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc)(prison_whtrt SC8609_ma racialdiversity ln_pctblk /*
*/ VCRate_Total PCRate_Total govideo totdempct women_leg blk_leg threestrikes GTClear darrest2  gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio /*
*/divorcerate felonspc)(prison_blkrt SC8609_ma racialdiversity ln_pctblk  VCRate_Total PCRate_Total govideo totdempct women_leg blk_leg /*
*/threestrikes GTClear darrest2  gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc)

*TABLE2 - Model 4 Logged Black/White Ratio Model
xtpcse ln_prison_BWratio SC8609_ma racialdiversity ln_pctblk  VCRate_Total PCRate_Total govideo totdempct women_leg blk_leg threestrikes GTClear darrest2 /*
*/ gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc


*TABLE 3 - Error Correction Model (Long-Term Effects)
gen disequ_lnBWPSC2 = (l.ln_prison_BWratio-l.SC8609_ma)
lab var disequ_lnBWPSC2 "Disequilibrium Rate"
xtpcse d.ln_prison_BWratio d.SC8609_ma l.SC8609_ma disequ_lnBWPSC2 racialdiversity ln_pctblk  VCRate_Total PCRate_Total govideo /*
*/ totdempct women_leg  blk_leg threestrikes GTClear darrest2 gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc


*TABLE 4 - Interaction between Social Capital x Diversity
xtpcse ln_prison_BWratio SC8609_ma racialdiversity SC_RD ln_pctblk  VCRate_Total PCRate_Total govideo totdempct women_leg /*
*/ blk_leg threestrikes GTClear darrest2 gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc

*FIGURE 1  

*install grinter.pkg from  grinter from http://myweb.uiowa.edu/fboehmke/stata if not already installed 
*Alternatively, Brambor, Clark and Golder's (2006) code could be used to create interaction graphs (http://mattgolder.com/interactions)

grinter SC8609_ma, inter(SC_RD) const02(racialdiversity) yline(0) kdensity nomean 


*TABLE 4 - Interaction between Social Capital x % Black 
xtpcse ln_prison_BWratio SC8609_ma ln_pctblk ln_SC_PBLK   racialdiversity VCRate_Total PCRate_Total govideo totdempct women_leg /*
*/ blk_leg threestrikes GTClear darrest2 gsppc_k unemp pov_rtfull bwpovratio eduattain_ma bwcolratio divorcerate felonspc

*FIGURE 2 Interaction
grinter SC8609_ma, inter(ln_SC_PBLK) const02(ln_pctblk) yline(0) kdensity nomean

************************************************************





