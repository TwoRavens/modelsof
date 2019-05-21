* Create Table 1 from KVP data
use KVPJOPrep
replace disputes_before = 4 if disputes_before >= 4
bysort longitudinal_treatment: tab disputes_before anydispaft , r
* T-tests for differences in rates in Table 1
prtest anydispaft if disputes_before == 0 , by( longitudinal_treatment)
prtest anydispaft if disputes_before > 0 , by( longitudinal_treatment)

* Create risk ratios for Figure 2 from JL data after matching
clear
* First, calculate odds ratios for initiators without defensive alliance
* without controls and then with.
use LeedsJohnsonJOPrep
keep if pchalally == 0
cem jdem(#0) pchaloff(#0) pchalneu(#0) contig(#0) c_majpow(#0) t_majpow(#0) rivalyears(#0) midcount (#0) ptargoff(#0) ptargneu(#0), tr( ptargdef )
logit dispute ptargdef [iweight=cem_weights], or
logit dispute ptargdef if year <= 1945 [iweight=cem_weights], or
logit dispute ptargdef if year > 1945 [iweight=cem_weights], or
logit dispute ptargdef jdem pchaloff pchalneu contig c_majpow t_majpow rivalyears midcount ptargoff ptargneu [iweight=cem_weights], or
logit dispute ptargdef jdem pchaloff pchalneu contig c_majpow t_majpow rivalyears midcount ptargoff ptargneu [iweight=cem_weights] if year <= 1945, or
logit dispute ptargdef jdem pchaloff pchalneu contig c_majpow t_majpow rivalyears midcount ptargoff ptargneu [iweight=cem_weights] if year > 1945, or

* Second, calculate odds ratios for initiators with defensive alliance without
* controls and then with
use LeedsJohnsonJOPrep, clear
keep if pchalally == 1
cem jdem(#0) pchaloff(#0) pchalneu(#0) contig(#0) c_majpow(#0) t_majpow(#0) rivalyears(#0) midcount (#0) ptargoff(#0) ptargneu(#0), tr( ptargdef )
logit dispute ptargdef [iweight=cem_weights], or
logit dispute ptargdef if year <= 1945 [iweight=cem_weights], or
logit dispute ptargdef if year > 1945 [iweight=cem_weights], or
logit dispute ptargdef jdem pchaloff pchalneu contig c_majpow t_majpow rivalyears midcount ptargoff ptargneu [iweight=cem_weights], or
logit dispute ptargdef jdem pchaloff pchalneu contig c_majpow t_majpow rivalyears midcount ptargoff ptargneu [iweight=cem_weights] if year <= 1945, or
logit dispute ptargdef jdem pchaloff pchalneu contig c_majpow t_majpow rivalyears midcount ptargoff ptargneu [iweight=cem_weights] if year > 1945, or

* Wahoo! You're done (after you pull all the coefficients together into one table...).
