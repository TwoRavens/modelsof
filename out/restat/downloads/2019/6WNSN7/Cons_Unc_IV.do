*This program performs IV estimation 
*The program is run for the project on consumption uncertainty and precautionary saving using DNB data
*November 2018 - Dimitris Christelis, Dimitris Georgarakos, Tullio Jappelli, Maarten van Rooij

*set trace on
version 12.1
clear all
macro drop _all
set more off
set maxvar 10000
set seed 123456

*ATTENTION - ATTENTION - ATTENTION 
*The following lines definee the file path. Please adapt to own computer.
do "c:/foldp/foldp.do"
global projf "${foldp}/DNB_survey_consumption/ConGrowth/Replication"

*Estimation method
global method IV

*Global of date and time
global stdate $S_DATE 
global sttime $S_TIME
noisily display "Begin program at ${sttime} on ${stdate}"   /* time stamp */

*Definition of output
global outv w005_hpconch_nyr 
global fout: word 1 of ${outv}
global outno: word count ${outv}

*Definition of specifications
global spf1 age fem dwave2 dwave3 dreg2 dreg3 dreg4 dreg5 hhsize couple 

*Global and number of specifications
global spec 1 
global fsp: word 1 of ${spec}
global nsp = 1

*Number of elements in the largest specification
global nc${nsp}: word count ${spf${nsp}}

*Cluster variable
local clustv "nohhold"

*Weight variable
global wgt ""

*Tolerance
sca tolr = 1e-6

*Significance level
sca sigl = 0.05

*Local of additional results to show
global addsc nobs R2_adj F_test endog_pv AR_pv
*weak_chistat weak_chip weak_lb weak_ub
global naddsc: word count ${addsc}

*Global of column names
global col co se ts pv ci_low ci_high
global ncol: word count ${col}

*Number of blanks between results
global nb = 3

*Global of bootstra replications
global bsn = 1000

*Filnename suffix
local sf

*Reading the data
use "${projf}/Data/Data_cons_uncertainty.dta", clear

*Dropping if treatment or instrument under the split triangular distribution
*are missing
qui drop if w005_hmsptri_sqcgr>=. | w005_hsdsptri_incgr>=.

qui save "${projf}/Programs/temp1.dta", replace

*Loop over expectation distributions (split triangular, simple triangular)
foreach dist in sptri trio {

*Log file
cap log close
log using "${projf}/Programs/${method}/Cons_Unc_${method}_boot${bsn}_`dist'`sf'.log", replace


*Global of treatments
global treatv w005_hm`dist'_sqcgr 
global ftv: word 1 of ${treatv}
global tno: word count ${treatv}

*Global of instruments
global instr w005_hsd`dist'_incgr 

*Loop over outcomes
forvalues on = 1/$outno {
   global on = `on'
   global out: word `on' of ${outv}
   
   *Global of winsorization
   if "${out}"=="w005_hpconch_nyr" {
      global ol w005
   }

   *Loop over treatment variables
   forvalues tv=1/$tno {
      global tv=`tv'
      global treat: word `tv' of ${treatv}

      if "${treat}"=="w005_hm`dist'_sqcgr" {
         global tl spucgr
      }

      *Loop over specifications 
      foreach k in $spec {
         global k = `k'
            
            use "${projf}/Programs/temp1.dta", clear

            *Dropping missing values
            local mvl ${out} ${spf`k'} ${treat} ${instr}
            foreach var in `mvl' {
               qui drop if `var'==.
            }

            di "Results for outcome ${out}, treatm. ${treat}, IV `mth', spec.`k'"
 

               di in yellow "Conventional IV regression"
               
               local sd = 1234 + `k'+1

               sort nohhold
               ivregress liml ${out} ${spf`k'} (${treat} = ${instr}), vce(bootstrap, cluster(`clustv') ///
                  reps(${bsn}) seed(`sd'))
               *saving("${projf}/Data/temp1.dta", replace)) 
                  
               mat olco = e(b)
               mat olvar = e(V)
               sca nobs = e(N)
               global nc=colsof(olvar)
               sca R2_adj = e(r2_a)
               local exogv `e(exogr)'
               global l2 `exogv'

               *AR test
               di in yellow "Anderson-Rubin test of significance"
               
               set seed `sd'
               boottest ${treat}, ar nograph reps(${bsn})
               sca AR = r(z)
               sca AR_pv = r(p)

               *First stage regression
               di in yellow "F-test first stage"
               
               sort nohhold
               regress ${treat} ${instr} `exogv',  vce(bootstrap, cluster(`clustv') reps(${bsn}) ///
                  seed(`sd')) 
               
               qui predict double resid, resid
               mat V=e(V)
               scal varinstr = V[1,1]
               sca F_test = _b[${instr}]^2/varinstr
               qui test ${instr}
               sca F2 = r(chi2)
               assert (F_test-F2)<1e-3

               *Hausman test for endogeneity
               di in yellow "Hausman test for endogeneity"
               
               sort nohhold
               regress ${out} ${treat} `exogv' resid, vce(bootstrap, cluster(`clustv') ///
                  reps(${bsn}) seed(`sd'))
               
               qui test resid
               sca endog = r(chi2)
               sca endog_pv = r(p)
            
               *Program that puts results in a matrix
               do "${projf}/Programs/${method}/Cons_Unc_${method}_calc.do"
            
         *Combining horizontally the results over specifications
         if `k'==${fsp} {
             mat A_t`tv'_o`on' = A_sp`k'_t`tv'_o`on'
         }
         else if `k'!=${fsp} {
             mat A_t`tv'_o`on' = (A_t`tv'_o`on',A_sp`k'_t`tv'_o`on')
         }
         mat drop A_sp`k'_t`tv'_o`on'

      *End of loop over specifications
      }

      *Combining vertically the results over treatments
      if "${treat}"=="${ftv}" {
          mat A_o`on' = A_t`tv'_o`on'
      }
      else if "${treat}"!="${ftv}" {
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
mat2txt, mat(A_all) saving("${projf}/Results/${method}/Results_${method}_boot${bsn}_`dist'`sf'.txt") replace format(%15.6f) ///      
  title("Results for method ${method}, $S_DATE, $S_TIME")      
mat drop _all

cap log close

*End of loop over distributions
} 

erase "${projf}/Programs/temp1.dta"

*Time stamp
noisily display "Program started at: ${sttime} of ${stdate}"      /* beginning time stamp */
noisily display "Program finished at: $S_TIME of $S_DATE"       /*ending time stamp*/       

cap log close
