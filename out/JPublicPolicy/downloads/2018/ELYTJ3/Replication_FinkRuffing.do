*** Replication_FinkRuffing
*** do-file for the replication of the analyses in Fink/Ruffing, “Going beyond dyadic consultation relationships: Information exchange in multi-step participation procedures”, Journal of Public Policy




*** Table 4

local dv text_percentchanged
local arguments jur pol tec econ ecol med
local control new length Amprion Tennet Hertz
local outregoptions1 using Table4, title(Table4)  addstat(adjustedR2, e(r2_a)) nocons auto(2) bdec(2) word
local regoption if startnetz == 0 & n == 1

reg `dv' no_submissions_tso `control' `regoption'
outreg2 no_submissions_tso `control' `outregoptions1' ctitle(all)


foreach iv in `arguments' {
reg `dv' no_submissions_tso no_submissions_tso_`iv' `control' `regoption'
outreg2 no_submissions_tso no_submissions_tso_`iv' `outregoptions1'  ctitle(`iv') 


}


*** Table 5


local dv fna_approval
local control new length Amprion Tennet Hertz
local outregoptions using Table5, title(Table5)  addstat(PseudoR2, e(r2_p), log-likelihood, e(ll)) nocons auto(2) bdec(2) word 
local regoption if projectcode_nep1 ~= "P25"
local arguments jur pol tec econ ecol med 


logit `dv' no_submissions_tso_m no_submissions_fna `control'   `regoption'
outreg2 no_submissions_tso_m no_submissions_fna `control'  `outregoptions' ctitle(all)


foreach iv in `arguments' {
logit `dv' no_submissions_tso_m no_submissions_fna no_submissions_tso_`iv' no_submissions_fna_`iv'  `control' `regoption'
outreg2 no_submissions_tso_m no_submissions_fna no_submissions_tso_`iv' no_submissions_fna_`iv' `control'    `outregoptions' ctitle(`iv') 


}


*** Figure 3

logit fna_approval no_submissions_tso_m no_submissions_fna no_submissions_tso_ecol no_submissions_fna_ecol new length Amprion Tennet Hertz if projectcode_nep1 ~= "P25"
margins , at(no_submissions_tso_ecol = (0(1)5))
marginsplot, ytitle(Probability of approval of project) xtitle(Number of submissions with ecological arguments in the TSO consultation) yscale(range(0 1)) ylabel(0(.1)1)


*** Table 6

local dv sup_assessment
local control 
local outregoptions using table6, title(table6)  addstat(PseudoR2, e(r2_p), log-likelihood, e(ll), cutpoint1, _b[/cut1], cutpoint2, _b[/cut2]) nocons auto(2) bdec(2) word 
local regoption if projectcode_nep1 ~= "P25"


oprobit `dv' no_submissions_tso_ecol `control'   `regoption'
outreg2 no_submissions_tso_ecol `control'  `outregoptions' ctitle(1)

oprobit `dv' no_submissions_tso_ecol no_submissions_fna_ecol `control'   `regoption'
outreg2 sum_arg no_submissions_fna_ecol `control'  `outregoptions' ctitle(2)



*** Table 8 (Appendix) Table 4 using multilevel models instead of TSO dummies. 




local dv text_percentchanged
local arguments jur pol tec econ ecol med
local control new length 
local outregoptions1 using Table8, title(Table8) nocons auto(2) bdec(2) addstat(sd(withinTSOs), e(sigma_e), sd(betweenTSOs), e(sigma_u))  word onecol
local regoption if startnetz == 0 & n == 1


xtreg `dv' no_submissions_tso `control' `regoption' , i(tsoid) mle
outreg2 no_submissions_tso `control' `outregoptions1' ctitle(all)


foreach iv in `arguments' {
xtreg `dv' no_submissions_tso no_submissions_tso_`iv' `control' `regoption' , i(tsoid) mle
outreg2 no_submissions_tso no_submissions_tso_`iv' `outregoptions1'  ctitle(`iv') 


}



*** Table 9 (Appendix). Table 4 using actor type instead of arguments



local dv text_percentchanged
local actors cit ci comp ia ea local land
local control new length Amprion Tennet Hertz
local outregoptions1 using Table9, title(Table9)  addstat(adjustedR2, e(r2_a)) nocons auto(2) bdec(2) word
local regoption if startnetz == 0 & n == 1

reg `dv' no_submissions_tso `control' `regoption'
outreg2 no_submissions_tso `control' `outregoptions1' ctitle(all)



foreach iv in `actors' {
reg `dv' no_submissions_tso no_submissions_tso_`iv' `control' `regoption'
outreg2 no_submissions_tso no_submissions_tso_`iv' `outregoptions1'  ctitle(`iv') 


}


*** Table 10 (Appendix) Table 4 using Levensthtein distance instead of percentage of words changed. Project P25 omitted. 


local dv levenshtein
local arguments jur pol tec econ ecol med
local control new length Amprion Tennet Hertz
local outregoptions1 using Table10, title(Table10)  addstat(adjustedR2, e(r2_a)) nocons auto(2) bdec(2) word
local regoption if startnetz == 0 & n == 1 & projectcode_nep1 ~= "P25"

reg `dv' no_submissions_tso `control' `regoption'
outreg2 no_submissions_tso `control' `outregoptions1' ctitle(all)



foreach iv in `arguments' {
reg `dv' no_submissions_tso no_submissions_tso_`iv' `control' `regoption'
outreg2 no_submissions_tso no_submissions_tso_`iv' `outregoptions1'  ctitle(`iv') 


}




*** Table 11 (Appendix): Table 5 using actor type instead of arguments


local dv fna_approval
local actors cit ci local land kreis
local control new length Amprion Tennet Hertz
local outregoptions using Table11, title(Table 11)  addstat(PseudoR2, e(r2_p), log-likelihood, e(ll)) nocons auto(2) bdec(2) word 
local regoption if projectcode_nep1 ~= "P25"


logit `dv' no_submissions_tso no_submissions_fna `control'   `regoption'
outreg2 no_submissions_tso no_submissions_fna `control'  `outregoptions' ctitle(all)



foreach iv in `actors' {
logit `dv'  no_submissions_tso no_submissions_fna no_submissions_tso_`iv' no_submissions_fna_`iv'  `control' `regoption'
outreg2 no_submissions_tso no_submissions_fna no_submissions_tso_`iv' no_submissions_fna_`iv'  `control'    `outregoptions' ctitle(`iv') 


}


*** Table 12 (Appendix) Table 5 without the outlier (the extremely contentious Korridor A) 


local dv fna_approval
local control new length Amprion Tennet Hertz
local outregoptions using Table12, title(Table12)  addstat(PseudoR2, e(r2_p), log-likelihood, e(ll)) nocons auto(2) bdec(2) word 
local regoption if projectcode_nep1 ~= "P25" & no_submissions_fna < 2100
local arguments jur pol tec econ ecol med 


logit `dv' no_submissions_tso_m no_submissions_fna `control'   `regoption'
outreg2 no_submissions_tso_m no_submissions_fna `control'  `outregoptions' ctitle(all)


foreach iv in `arguments' {
logit `dv' no_submissions_tso_m no_submissions_fna no_submissions_tso_`iv' no_submissions_fna_`iv'  `control' `regoption'
outreg2 no_submissions_tso_m no_submissions_fna no_submissions_tso_`iv' no_submissions_fna_`iv' `control'    `outregoptions' ctitle(`iv') 


}


