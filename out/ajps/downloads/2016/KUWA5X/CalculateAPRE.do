////////////////
//  PREAMBLE  //
////////////////
version 11
capture log close
clear
set more off
set matsize 800
set mem 500m 

/*	program:	CalculateAPRE.do
	task:		Calculates the APRE by different measures for the Civil Rights Votes.
				An alternative way to do this is at the congress-level, which is a better
				way to handle movement in ideal points in DW-NOMINATE and the Adjusted
				or One-Congress-at-a-Time scores. This does not make an important difference.
	project:	A House Divided? 
	author:		Bateman, Clinton, and Lapinski */


**************************** SETUP **************************

cd "ReplicationFiles"

use "AppendixFiles\CounterFactualVotes", clear
*** Henderson of North Carolina is incorrectly coded for the 51st Congress
*** Civil Rights votes. 

drop if congress == 51 & icpsrlegis==4312
**************************************************************

*** Load and merge the different scores
rename icpsrlegis icpsrLegis

merge 1:1 icpsrLegis congress using "AppendixFiles\CombinedLegisIdealOneCongressTimeCivilRights.dta" , keepusing(agnosticd1 constrainedd1) nogen

rename icpsrLegis icpsrlegis


merge 1:1 icpsrlegis congress using "AppendixFiles\AdjustedCivilRightsIdealEstimates45to109.dta" , keepusing(adjustD1)
replace adjustD1=adjustD1*-1
drop if _merge!=3
drop _merge	

*** Set the roll calls to 1 or 0
qui foreach x of varlist V* {
	replace `x' = . if `x' ==0 | `x'>=7 
	replace `x' = 0 if `x' ==4 | `x'==5 | `x'==6
	replace `x' = 1 if `x' ==2 | `x'==3
}

*** Loop through all of the roll calls, running a probit regression
*** using the different scores, calculating the PRE (ssc install pre)
*** and extracting the information
matrix a = J(500,10,.)
levelsof congress, local(congress)

local rollcall = 1
qui foreach x of varlist V* {

		matrix a[`rollcall',1]=`rollcall'
		capture probit `x' civilRightsAgn 
		if _rc==0 {
			capture pre
			qui local preuncon = r(pre)
			di in yellow "Agnostic PRE:" in green `preuncon'
		}
		else {
			qui local preuncon = .
		}
		matrix a[`rollcall',2]=`preuncon'
		
		capture probit `x' civilRightsCons 
		if _rc==0 {
			capture pre
			qui local precon = r(pre)
			di in yellow "Constrained PRE:" in green `precon'
		}
		else {
			qui local precon = .
		}
		matrix a[`rollcall',3]=`precon'

		capture probit `x' dwnom1 dwnom2 
		if _rc==0 {
			capture pre
			qui local predwn = r(pre)
			di in yellow "DWNOM PRE:" in green `predwn'
		}
		else {
			qui local predwn = .
		}
		matrix a[`rollcall',4]=`predwn'	

		capture probit `x' dwnom1 
		if _rc==0 {
			capture pre
			qui local predwn1 = r(pre)
			di in yellow "DWNOM1stdim PRE:" in green `predwn1'
		}
		else {
			qui local predwn1 = .
		}
		matrix a[`rollcall',5]=`predwn1'	

		capture probit `x' dwnom2 
		if _rc==0 {
			capture pre
			qui local predwn2 = r(pre)
			di in yellow "DWNOM2ndim PRE:" in green `predwn2'
		}
		else {
			qui local predwn2 = .
		}
		matrix a[`rollcall',6]=`predwn2'	
	
		capture probit `x' adjustD1 
		if _rc==0 {
			capture pre
			qui local preadjust = r(pre)
			di in yellow "Adjusted PRE:" in green `preadjust'
		}
		else {
			qui local preadjust = .
		}
		matrix a[`rollcall',7]=`preadjust'

		capture probit `x' agnosticd1 
		if _rc==0 {
			capture pre
			qui local preagncbyc = r(pre)
			di in yellow "One-Congress-Time (Baseline) PRE:" in green `preagncbyc'
		}
		else {
			qui local preagncbyc = .
		}
		matrix a[`rollcall',8]=`preagncbyc'

		capture probit `x' constrainedd1 
		if _rc==0 {
			capture pre
			qui local preconstcbyc = r(pre)
			di in yellow "One-Congress-Time (Constrained) PRE:" in green `preconstcbyc'
		}
		else {
			qui local preconstcbyc = .
		}
		matrix a[`rollcall',9]=`preconstcbyc'
		
	noisily di in yellow "ROLLCALLS COMPLETED:  " in red `rollcall'
	local rollcall = `rollcall'+1
	}

*** Loop through all of the roll calls, running a probit regression
*** using the different scores, generating a predicted probability of
*** voting yea, and calculate the proportion of members whose votes were
*** correctly predicted.
matrix b = J(500,25,.)	
local rollcall = 1
foreach x of varlist V* {
		matrix b[`rollcall',1]=`rollcall'
		capture probit `x' civilRightsAgn 
		qui if _rc==2000 {
			count if civilRightsAgn!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',2] = `dem'
			matrix b[`rollcall',3] = `dem'
			matrix b[`rollcall',4] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',2] = `dem'
			matrix b[`rollcall',3] = `correct'
			matrix b[`rollcall',4] = `incorrect'
			qui drop yhat
		}
		
		capture probit `x' civilRightsCons 
		qui if _rc==2000 {
			count if civilRightsCons!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',5] = `dem'
			matrix b[`rollcall',6] = `dem'
			matrix b[`rollcall',7] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',5] = `dem'
			matrix b[`rollcall',6] = `correct'
			matrix b[`rollcall',7] = `incorrect'
			qui drop yhat	
		}
		
		capture probit `x' dwnom1 dwnom2 
		qui if _rc==2000 { 
			count if dwnom1!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',8] = `dem'
			matrix b[`rollcall',9] = `dem'
			matrix b[`rollcall',10] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=.
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',8] = `dem'
			matrix b[`rollcall',9] = `correct'
			matrix b[`rollcall',10] = `incorrect'
			qui drop yhat
		}	

		capture probit `x' dwnom1 
		qui if _rc==2000 {
			count if dwnom1!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',11] = `dem'
			matrix b[`rollcall',12] = `dem'
			matrix b[`rollcall',13] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',11] = `dem'
			matrix b[`rollcall',12] = `correct'
			matrix b[`rollcall',13] = `incorrect'
			qui drop yhat
		}	
		
		capture probit `x' dwnom2 
		qui if _rc==2000 {
			count if dwnom1!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',14] = `dem'
			matrix b[`rollcall',15] = `dem'
			matrix b[`rollcall',16] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',14] = `dem'
			matrix b[`rollcall',15] = `correct'
			matrix b[`rollcall',16] = `incorrect'
			qui drop yhat
		}
		
		capture probit `x' adjustD1 
		qui if _rc==2000 {
			count if adjustD1!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',17] = `dem'
			matrix b[`rollcall',18] = `dem'
			matrix b[`rollcall',19] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',17] = `dem'
			matrix b[`rollcall',18] = `correct'
			matrix b[`rollcall',19] = `incorrect'
			qui drop yhat
		}

		capture probit `x' agnosticd1 
		qui if _rc==2000 {
			count if agnosticd1!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',20] = `dem'
			matrix b[`rollcall',21] = `dem'
			matrix b[`rollcall',22] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',20] = `dem'
			matrix b[`rollcall',21] = `correct'
			matrix b[`rollcall',22] = `incorrect'
			qui drop yhat
		}

		capture probit `x' constrainedd1 
		qui if _rc==2000 {
			count if constrainedd1!=. & `x'!=. 
			local dem = r(N)
			matrix b[`rollcall',23] = `dem'
			matrix b[`rollcall',24] = `dem'
			matrix b[`rollcall',25] = 0
		}
		else {
			qui predict yhat 
			qui count if `x'!=. 
			local dem = r(N)
			qui count if (yhat >=0.5 & `x' ==1 ) ///
				| (yhat<0.5 & `x'==0) 
			local correct = r(N)
			qui count if (yhat >=0.5 & `x' ==0 ) ///
				| (yhat<0.5 & `x'==1) 
			local incorrect = r(N)
			matrix b[`rollcall',23] = `dem'
			matrix b[`rollcall',24] = `correct'
			matrix b[`rollcall',25] = `incorrect'
			qui drop yhat
		}
		
	di in yellow "ROLLCALLS COMPLETED:  " in red `rollcall'
	local rollcall = `rollcall'+1
	}



*** Get summary statistics 
matrix colnames a = "rollcall" "PREAgn" "PREConst" "PREDWNOM" ///
	"PREDWNOM1" "PREDWNOM2" "PREAdjust" "PREAgnCongbyCong" "PREConstCongbyCong" "congress"
matrix colnames b = "rollcall1" "NAgn" "CorrAgn" "IncorrAgn" ///
	"NCons" "CorrCons" "IncorrCons" "NDWNOM" "CorrDWNOM" "IncorrDWNOM" ///
	"NDWNOM1" "CorrDWNOM1" "IncorrDWNOM1" "NDWNOM2" "CorrDWNOM2" "IncorrDWNOM2" ///
	"NAdjust" "CorrAdjust" "IncorrAdjust" ///
	"NAgnCongbyCong" "CorrAgnCongbyCong" "IncorrAgnCongbyCong"  ///
	"NConstCongbyCong" "CorrConstCongbyCong" "IncorrConstCongbyCong"
keep V*
*ssc install descsave
descsave, norestore
keep name
rename name Vote
gen rollcall = _n
tempfile temp1
save `temp1'
	
clear
svmat a, names(col)
svmat b, names(col)
qui gen PerCorrAgn = CorrAgn/NAgn
qui gen PerCorrCons = CorrCons/NCons
qui gen PerCorrDWNOM = CorrDWNOM/NDWNOM
qui gen PerCorrDWNOM1 = CorrDWNOM1/NDWNOM1
qui gen PerCorrDWNOM2 = CorrDWNOM2/NDWNOM2
qui gen PerCorrAdjust = CorrAdjust/NAdjust
qui gen PerCorrAgnCongbyCong = CorrAgnCongbyCong/NAgnCongbyCong
qui gen PerCorrConsCongbyCong = CorrConstCongbyCong/NConstCongbyCong

drop if rollcall==.
merge 1:1 rollcall using `temp1', keepusing(Vote) nogen

drop rollcall1
rename rollcall vote
rename Vote rollcall
label variable PREAgn "Proportional Reduction in Error, Agnostic Constant Scores"
label variable PREConst "Proportional Reduction in Error, Imputed Votes Constant Scores"
label variable PREDWNOM "Proportional Reduction in Error, DW-NOMINATE"
label variable PREDWNOM1 "Proportional Reduction in Error, DW-NOMINATE 1st Dim."
label variable PREDWNOM2 "Proportional Reduction in Error, DW-NOMINATE 2nd Dim."
label variable PREAdjust "Proportional Reduction in Error, GLS-Adjusted Scores"
label variable PREAgnCongbyCong "Proportional Reduction in Error, Nokken-Poole Technique, Agnostic"
label variable PREConstCongbyCong "Proportional Reduction in Error, Nokken-Poole Technique, Constrained"
label variable PREAgnCongbyCong "Proportional Reduction in Error, Nokken-Poole Technique, Agnostic"
label variable congress "Congress"
label variable NAgn "Number of Votes, Agnostic Scores"
label variable CorrAgn "Number of Correctly Predicted Votes, Agnostic Scores"
label variable IncorrAgn "Number of Incorrectly Predicted Votes, Agnostic Scores"
label variable NCons "Number of Votes, Constrained Scores"
label variable CorrCons "Number of Correctly Predicted Votes, Constrained Scores"
label variable IncorrCons "Number of Incorrectly Predicted Votes, Constrained Scores"
label variable NDWNOM "Number of Votes, DW-NOMINATE Scores"
label variable CorrDWNOM "Number of Correctly Predicted Votes, DW-NOMINATE Scores"
label variable IncorrDWNOM "Number of Incorrectly Predicted Votes, DW-NOMINATE Scores"
label variable NDWNOM1 "Number of Votes, DW-NOMINATE Scores - 1st Dim"
label variable CorrDWNOM1 "Number of Correctly Predicted Votes, DW-NOMINATE Scores - 1st Dim"
label variable IncorrDWNOM1 "Number of Incorrectly Predicted Votes, DW-NOMINATE Scores - 1st Dim"
label variable NDWNOM2 "Number of Votes, DW-NOMINATE Scores - 2nd Dim"
label variable CorrDWNOM2 "Number of Correctly Predicted Votes, DW-NOMINATE Scores - 2nd Dim"
label variable IncorrDWNOM2 "Number of Incorrectly Predicted Votes, DW-NOMINATE Scores - 2nd Dim"
label variable NAdjust "Number of Votes, GLS-Adjusted Scores"
label variable CorrAdjust "Number of Correctly Predicted Votes, GLS-Adjusted Scores"
label variable IncorrAdjust "Number of Incorrectly Predicted Votes, GLS-Adjusted Scores"
label variable NAgnCongbyCong "Number of Votes, Nokken-Poole Technique Agnostic Scores"
label variable CorrAgnCongbyCong "Number of Correctly Predicted Votes, Nokken-Poole Technique Agnostic Scores"
label variable IncorrAgnCongbyCong "Number of Incorrectly Predicted Votes, Nokken-Poole Technique Agnostic Scores"
label variable NConstCongbyCong "Number of Votes, Nokken-Poole Technique Imputed Votes Constrained Scores"
label variable CorrConstCongbyCong "Number of Correctly Predicted Votes, Nokken-Poole Technique Imputed Votes Constrained Scores"
label variable IncorrConstCongbyCong "Number of Incorrectly Predicted Votes, Nokken-Poole Technique Imputed Votes Constrained Scores"
label variable PerCorrAgn "Percent of Votes Correctly Predicted, Agnostic Scores"
label variable PerCorrCons "Percent of Votes Correctly Predicted, Constrained Scores"
label variable PerCorrDWNOM "Percent of Votes Correctly Predicted, DW-NOMINATE"
label variable PerCorrDWNOM1 "Percent of Votes Correctly Predicted, DW-NOMINATE, 1st Dim"
label variable PerCorrDWNOM2 "Percent of Votes Correctly Predicted, DW-NOMINATE, 2nd Dim"
label variable PerCorrAdjust "Percent of Votes Correctly Predicted, GLS-Adjusted Scores"
label variable PerCorrAgnCongbyCong "Percent of Votes Correctly Predicted, Nokken-Poole Technique Agnostic Scores"
label variable PerCorrConsCongbyCong "Percent of Votes Correctly Predicted, Nokken-Poole Technique Imputed Votes Constrained Scores"
label variable rollcall "Roll Call Number and Congress VXX_YY (XX rollcall; YY Congress)"
order rollcall 
drop vote
*** Get summary statistics of PRE and percent correctly predicted
tabstat PerCorr* if PerCorrAgn!=. & PerCorrCons!=. & PerCorrDWNOM!=.
tabstat PRE* if PREAgn!=. & PREConst!=. & PREDWNOM!=.

save "AppendixFiles\APRECivilRightsFinal.dta", replace

