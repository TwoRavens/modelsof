*******************************
** ProcessSurveyDataForFigure1.do
**
** Make Figure 1 tabulations. The graphic is produced in Excel.
**
** Survey data are from the November 2010 "Perceptions of the Voting Experience" survey discussed in the text. Please see the SI for more details.
**
*******************************
clear
set matsize 800
set more off
use SurveyData.dta, clear

** Voter type indicator
recode yal001 (6=1) (1/5=0) (*=.), gen(nonvoter)
label var nonvoter "Non-voter (never voted=1)"

** Recode and Marginals
foreach i in 19 20 18 23{
* hyp indexes hypothetical voter variables
local hyp=`i'+20
recode yal0`i' (1=1) (2=0) (3=.5) (*=.)
recode yal0`hyp' (1=1) (2=0) (3=.5) (*=.)
* create a single measure of perception of interest and tab it to generate response indicators
gen merge_yal0`i'=yal0`i'
replace merge_yal0`i'=yal0`hyp' if yal0`hyp'!=. & merge_yal0`i'==.
tab merge_yal0`i', gen(dum_yal0`i'_)
}

* loop through variables of interest and summarize response indicators and put them in a matrix
foreach i in 19 20 18 23{
sum dum_yal0`i'_3 [aw=weight] if nonvoter==0
matrix means_`i'=r(mean)
sum dum_yal0`i'_3 [aw=weight] if nonvoter==1
matrix means_`i'_nonvoter=r(mean)

sum dum_yal0`i'_2 [aw=weight] if nonvoter==0
matrix means_`i'=means_`i',r(mean)
sum dum_yal0`i'_2 [aw=weight] if nonvoter==1
matrix means_`i'_nonvoter=means_`i'_nonvoter,r(mean)

sum dum_yal0`i'_1 [aw=weight] if nonvoter==0
matrix means_`i'=means_`i',r(mean)
sum dum_yal0`i'_1 [aw=weight] if nonvoter==1
matrix means_`i'_nonvoter=means_`i'_nonvoter,r(mean)

* test whether nonvoter predicts outcome
mlogit merge_yal0`i' nonvoter [aw=weight], r
matrix means_`i'=means_`i',(chi2tail(e(df_m), e(chi2)))
matrix means_`i'_nonvoter=means_`i'_nonvoter,.

* stack matrix rows
if `i'==19{
matrix means=means_`i'\means_`i'_nonvoter
}
else{
matrix means=means\means_`i'\means_`i'_nonvoter
}
}

* This is the matrix used in the excel spreadsheet
* Each pair of rows is a single survey item, where the first row in the pair is the tabulation of responses by category among ever-voters and the second is the same for never-voters
* (cut and paste into excel)
matrix list means
