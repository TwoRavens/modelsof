

*1. Set in CD and open data 

cd "..."

use "Choosing_crook.dta", clear

*2. Run do file to recode variables
do "...\Choosing_crook_recode.do"

*3. Drop runners (The 10 percentile that took less time to answer) 
drop if timer1_3<15 | timer2_3<10| timer3_3<9 

*4. Set scheme
set scheme s1color


*5. Start with analysis

***** Relative punishment hypothesis*****

**Average marginal component effects  

reg voteprob i.woman  i.differentp i.lowqualities i.weakperfor i.corruption, vce(cl gid)  
margins, dydx(*) post
est store m1 

*Figure 1 
coefplot m1, drop(?cons) xline(0)
coefplot (m1, label(Main Effects)), drop(?cons) xline(0)


*Table A2
outreg2 [m1] using AMCE_tableA2.xml, excel replace ///
title("Table A2. Average marginal component effects M1") ///
addnote( "Standard errors are clustered by respondent") ///
stats(coef se ci_low ci_high) side auto (3)




***** Conditional punishment hypothesis*****


*Table 2:  Predicted probabilities and the relative reduction of corruption 

*Partisanship 
reg  voteprob i.woman  i.highqualities i.strongperfor i.samep##i.corrupt, vce(cl gid) 
margins i.samep#i.corrupt

*Economic performance
reg  voteprob i.woman i.samep i.highqualities i.strongperfor##i.corrupt, vce(cl gid)
margins i.strongperfor#i.corrupt

*Probabity of voting (example in manuscript) 

reg  voteprob i.woman i.samep##i.corruption##i.strongperfor##i.highqualities, vce(cl gid) 
margins i.samep#i.corruption#i.strongperfor#i.highqualities


*Table 3: Derivatives expressed as a semi- elasticity

*Partisanship
reg  voteprob i.woman i.highqualities i.strongperfor i.samep##i.corrupt, vce(cl gid)  
margins, eydx (corrupt) at (samep = (0 1))
margins r.i.samep, eydx(corrupt)

*Economic performance
reg  voteprob i.woman  i.samep i.highqualities i.strongperfor##i.corrupt, vce(cl gid)  
margins, eydx (corrupt) at (strongperfor = (0 1))
margins r.i.strongperfor, eydx(corrupt)




*****Appendix A*****

** 1.	Robustness check of relative weight hypothesis
 
*Figure A1: Average marginal component effects (No partisanship)

reg voteprob i.woman  i.copartisanship i.lowqualities i.weakperfor i.corruption, vce(cl gid)  
margins, dydx(*) post
est store m2 
coefplot m2, drop(?cons) xline(0)
coefplot (m2, label(Main Effects)), drop(?cons) xline(0)

*Table A3. Average marginal component effects (No partisanship)
outreg2 [m2] using AMCE_tableA3.xml, excel replace ///
title("TABLE A. Average marginal component effects M2") ///
addnote( "Standard errors are clustered by respondent") ///
stats(coef se ci_low ci_high) side auto (3)


*Figure A2: Average marginal component effects (Party preferences)

reg voteprob i.woman  i.partypref3 i.lowqualities i.weakperfor i.corruption, vce(cl gid)  
margins, dydx(*) post
est store m3 
coefplot m3, drop(?cons) xline(0)
coefplot (m3, label(Main Effects)), drop(?cons) xline(0)


*Table A4. Average marginal component effects with party preferences 

outreg2 [m3] using AMCE_tableA4.xml, excel replace ///
title("TABLE A. Average marginal component effects M3") ///
addnote( "Standard errors are clustered by respondent") ///
stats(coef se ci_low ci_high) side auto (3)



**2. Robustness check of the conditional punishment hypothesis

*Table A5:  Predicted probabilities and the relative reduction of corruption(Model with both interactions) 

*Partisanship
reg  voteprob i.woman  i.highqualities i.samep##i.corrupt i.strongperfor##i.corrupt, vce(cl gid) 
margins i.samep#i.corrupt

*Economic performance
reg  voteprob i.woman  i.highqualities i.samep##i.corrupt i.strongperfor##i.corrupt, vce(cl gid)
margins i.strongperfor#i.corrupt



*Table A6: Derivatives expressed as a semi- elasticity (Model with both interactions) *Partisanship
reg  voteprob i.woman i.highqualities  i.samep##i.corrupt i.strongperfor##i.corrupt , vce(cl gid)  
margins, eydx (corrupt) at (samep = (0 1))
margins r.i.samep, eydx(corrupt)


*Economic performance
reg  voteprob i.woman i.highqualities i.samep##i.corrupt i.strongperfor##i.corrupt, vce(cl gid)  
margins, eydx (corrupt) at (strongperfor = (0 1))
margins r.i.strongperfor, eydx(corrupt)


**3. Conditional punishment of gender and education and managerial experience
*Table A7:  Predicted probabilities and the relative reduction of corruption 

*Gender
reg voteprob i.highqualities i.samep i.strongperfor i.woman##i.corrupt, vce(cl gid) 
margins i.woman#i.corrupt

*Education and managerial Education
reg  voteprob i.woman i.samep i.strongperfor i.highqualities##i.corrupt, vce(cl gid)
margins i.highqualities#i.corrupt

*Table A8: Derivatives expressed as a semi- elasticity 
*Gender
reg  voteprob i.highqualities i.samep i.woman##i.corrupt , vce(cl gid)  
margins, eydx (corrupt) at (woman = (0 1))
margins r.i.woman, eydx(corrupt)

* Education and Managerial experience
reg  voteprob i.woman i.highqualities i.samep i.strongperfor i.highqualities##i.corrupt, vce(cl gid)  
margins, eydx (corrupt) at (highqualities = (0 1))
margins r.i.highqualities, eydx(corrupt)




****4.	Further Robustness checks 
***4.1	Analysis with individual fixed effects 

**Figure A3: Average marginal component effects (with fixed effects)


xtset id 
xtreg voteprob i.woman  i.differentp i.lowqualities i.weakperfor i.corruption, fe
margins, dydx(*) post
est store m1fe 
coefplot m1fe, drop(?cons) xline(0)
coefplot (m1fe, label(Main Effects)), drop(?cons) xline(0)


**Table A9. Average marginal component effects (with fixed effects)
outreg2 [m1fe] using AMCE_table1fe.xml, excel replace ///
title("Table A. Average marginal component effects (fixed effects)") ///
addnote( "Standard errors are clustered by respondent") ///
stats(coef se ci_low ci_high) side auto (3)

**Table A11:  Predicted probabilities and the relative reduction of corruption (with fixed effects)
*Partisanship
xtreg  voteprob i.woman  i.highqualities i.strongperfor i.samep##i.corrupt, fe 
margins i.samep#i.corrupt

*Economic performance
xtreg  voteprob i.woman i.samep i.highqualities i.strongperfor##i.corrupt, fe
margins i.strongperfor#i.corrupt

**Table A12: Derivatives expressed as a semi- elasticity (fixed effects)

*Partisanship
xtreg  voteprob i.woman i.highqualities i.strongperfor i.samep##i.corrupt, fe
margins, eydx (corrupt) at (samep = (0 1))
margins r.i.samep, eydx(corrupt)

*Econmic performance
xtreg  voteprob i.woman  i.samep i.highqualities i.strongperfor##i.corrupt, fe  
margins, eydx (corrupt) at (strongperfor = (0 1))
margins r.i.strongperfor, eydx(corrupt)

***4.2	Analysis only using the data of the first task 
**Figure A5: Average marginal component effects (first task)

reg voteprob i.woman  i.differentp i.lowqualities i.weakperfor i.corruption if round==1, vce(cl gid)  
margins, dydx(*) post
est store m1r1 
coefplot m1r1, drop(?cons) xline(0)
coefplot (m1r1, label(Main Effects)), drop(?cons) xline(0)

**Table A13. Average marginal component effects (first task)

outreg2 [m1r1] using AMCE_table1round1.xml, excel replace ///
title("TABLE A12. Average marginal component effects (first task)") ///
addnote( "Standard errors are clustered by respondent.") ///
stats(coef se ci_low ci_high) side auto (3)

**Table A14:  Predicted probabilities and the relative reduction of corruption (first task)

*Partisanship
reg  voteprob i.woman  i.highqualities i.strongperfor i.samep##i.corrupt if round==1, vce(cl gid) 
margins i.samep#i.corrupt

*Economic performance
reg voteprob i.woman i.samep i.highqualities i.strongperfor##i.corrupt if round==1, vce(cl gid)
margins i.strongperfor#i.corrupt

**Table A15: Derivatives expressed as a semi- elasticity

*Partisanship
reg  voteprob i.woman i.highqualities i.strongperfor i.samep##i.corrupt if round==1, vce(cl gid)  
margins, eydx (corrupt) at (samep = (0 1))
margins r.i.samep, eydx(corrupt)


*Economic performance
reg  voteprob i.woman  i.samep i.highqualities i.strongperfor##i.corrupt if round==1, vce(cl gid)  
margins, eydx (corrupt) at (strongperfor = (0 1))
margins r.i.strongperfor, eydx(corrupt)



***4.3	Relative weight hypothesis with forced choice as dependent variable 

**Figure A6: Average marginal component effects (DV= Forced choice)

reg Y i.woman  i.differentp i.lowqualities i.weakperfor i.corruption, vce(cl gid)  
margins, dydx(*) post
est store m1forced 
coefplot m1forced, drop(?cons) xline(0)
coefplot (m1forced, label(Main Effects)), drop(?cons) xline(0)


**Table A16. Average marginal component effect (DV= Forced choice)
outreg2 [m1forced] using AMCE_table1forced.xml, excel replace ///
title("TABLE A. Average marginal component effects(forced chice)") ///
addnote( "Standard errors are clustered by respondent") ///
stats(coef se ci_low ci_high) side auto (3)

**Table A17:  Predicted probabilities and relative reduction of corruption

*Partisanship
reg  Y i.woman  i.highqualities i.strongperfor i.samep##i.corrupt, vce(cl gid) 
margins i.samep#i.corrupt

*Economic performance
reg Y i.woman i.samep i.highqualities i.strongperfor##i.corrupt, vce(cl gid)
margins i.strongperfor#i.corrupt


**Table A18: Derivatives expressed as a semi- elasticity (forced choice)

*Partisanship
reg  Y i.woman i.highqualities i.strongperfor i.samep##i.corrupt, vce(cl gid)  
margins, eydx (corrupt) at (samep = (0 1))
margins r.i.samep, eydx(corrupt)


*Economic performance
reg  Y i.woman  i.samep i.highqualities i.strongperfor##i.corrupt, vce(cl gid)  
margins, eydx (corrupt) at (strongperfor = (0 1))
margins r.i.strongperfor, eydx(corrupt)


*******Appendix B*****

***Table B2. Randomization Test. Mlogit Regression Model. Dependent Variable:Corruption Treatment

 
mlogit corruption i.gender age studies income unemployed ideol polsoph i.satisfdemo3 b6.partyidr 
  
eststo: mlog corruption i.gender age studies income unemployed ideol polsoph i.satisfdemo3 b6.partyidr  
esttab using Mlogit_tableB2.rtf, nolabel unstack nomti onecell wide noomitted nogap ///
label  nonumbers  ///
starlevels(* 0.05 ** 0.01 *** 0.001) ///
b(2) se(2) sca(chi2 p) obslast /// 
addnote("Note: Dependent Variable: Corruption treatment. Base category: Honest") ///
varlabels(_cons Constant  gender "Gender" age "Age" studies "Education" income "Income" unemployed "Unemployed" ideol "Ideology" polsoph "Political sophistication" ///
satisfdemo3 "Satisfaction with democracy" i.partyidr "Party id") replace 



