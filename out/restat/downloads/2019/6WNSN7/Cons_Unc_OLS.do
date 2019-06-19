*This program performs OLS estimation
*The program is run for the project on consumption uncertainty and precautionary saving using DNB data
*November 2018 - Dimitris Christelis, Dimitris Georgarakos, Tullio Jappelli, Maarten van Rooij

*set trace on
version 12.1
clear all
macro drop _all
set more off
set matsize 5000
set maxvar 20000
set seed 123456

*ATTENTION - ATTENTION - ATTENTION 
*The following lines define the file path. Please adapt to own computer
do "c:/foldp/foldp.do"
global projf "${foldp}/DNB_survey_consumption/ConGrowth/Replication"

*Method
global method OLS


global stdate $S_DATE 
global sttime $S_TIME
noisily display "Begin program at ${sttime} on ${stdate}"   /* time stamp */

local clustv "nohhold"

*Definition of output
global outv w005_hpconch_nyr /*hpconch_nyr*/ 
global outno: word count ${outv}
 
*Definition of specifications
global spf1 age fem dwave2 dwave3 dreg2 dreg3 dreg4 dreg5 hhsize couple  


*Number of specifications
global nsp = 1
global fsp = 1

*Number of elements in the largest specification
global nc${nsp}: word count ${spf${nsp}}

*Weight variable
global wgt ""

*Tolerance
sca tolr = 1e-6

*Significance level
sca sigl = 0.05

*Number of bootstrap replications
global bsn=1000

*Global of filename suffix
global sf

*Local of additional results to show
global addsc nobs R2 adj_R2
global actsc nobs e(r2) e(r2_a)
global naddsc: word count ${addsc}
global nactsc: word count ${actsc}
assert ${naddsc}==${nactsc}

*Global of column names
global col co se ts pv ci_low ci_high
global ncol: word count ${col}

*Number of blanks between results
global nb = 3

*Reading the data
use "${projf}/Data/Data_cons_uncertainty.dta", clear

*Keeping only obs for which the split triangular info is not missing, so as to keep the samples
*of the same size
keep if w005_hmsptri_sqcgr<.

qui save "${projf}/Programs/temp1.dta", replace

*Loop over expectation distributions (split triangular, simple triangular)
foreach dist in sptri trio {

*log 
cap log close
log using "${projf}/Programs/${method}/Cons_Unc_${method}_`dist'`sf'.log", replace

*Global of treatments
global tlist w005_hm`dist'_sqcgr 
global ftv: word 1 of ${tlist}
global tno: word count ${tlist}

*Loop over outcomes
forvalues on = 1/$outno {
   global on = `on'
   global out: word `on' of ${outv}
   global fout: word 1 of ${outv}
   
   *Global of winsorization
   if "${out}"=="w005_hpconch_nyr" {
      global ol w005
   }
   
   *Loop over treatment variables
   forvalues tv=1/$tno {
      global tv=`tv'
      global treat: word `tv' of ${tlist}

      *Loop over specifications 
      forvalues k=$nsp/$nsp {
         global k = `k'
         
         use "${projf}/Programs/temp1.dta", clear

         *Dropping missing values
         local mvl ${out} ${spf`k'} ${treat} 
         foreach var in `mvl' {
            qui drop if `var'==.
         }

         di "Results for outcome ${out}, treatm. ${treat}, ${method}, spec.`k'"
               
         *Running robust regression
         local nseed = 1234
         set seed `nseed'

         regress ${out} ${treat} ${spf`k'}, vce(bootstrap, cluster(`clustv') reps(${bsn}))

*set trace on 
         *Program that puts results in a matrix
         qui do "${projf}/Programs/${method}/Cons_Unc_${method}_calc.do"
         
         *Combining horizontally the results over specifications
         if `k'==$fsp {
             mat A_t`tv'_o`on' = A_sp`k'_t`tv'_o`on'
         }
         else if `k'>$fsp {
             mat A_t`tv'_o`on' = (A_t`tv'_o`on',A_sp`k'_t`tv'_o`on')
         }
         mat drop A_sp`k'_t`tv'_o`on'

      *End of loop over specifications
      }

      *Combining vertically the results over treatments
      if "${treat}"=="$ftv" {
          mat A_o`on' = A_t`tv'_o`on'
      }
      else if "${treat}"!="$ftv" {
          mat A_o`on' = (A_o`on'\A_t`tv'_o`on')
      }
      mat drop A_t`tv'_o`on'

   *End of loop over treatment variables below
   }

   *Combining vertically the results over outcomes
   if "${out}"=="${fout}" {
      mat A_all = A_o`on'
   }
   else if "${out}"!="${fout}" {
       mat A_all = (A_all\A_o`on')
   }
   mat drop A_o`on'

*End of loop over outcomes below
}


*Saving the matrix of results
mat2txt, mat(A_all) saving("${projf}/Results/${method}/Results_${method}_b${bsn}_`dist'`sf'.txt") replace format(%15.6f) ///      
  title("Results for method ${method}, $S_DATE, $S_TIME")      
mat drop _all

cap log close

*End of loop over distributions below
}

erase "${projf}/Programs/temp1.dta"

*Time stamp
noisily display "Program started at: ${sttime} of ${stdate}"      /* beginning time stamp */
noisily display "Program finished at: $S_TIME of $S_DATE"       /*ending time stamp*/       

cap log close


