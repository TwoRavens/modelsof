use "Data_programs/Data/CountryData.dta", clear


* Fig 5

preserve
gen type=1 if kinship_score>=.25
replace type=2 if kinship_score<.25

collapse s_diff_trust_out_in s_religion_hell s_values_uniform s_mfq_disgusting s_diff_shame_guilt_overall s_gps_punish_revenge (semean) se_s_diff_trust_out_in=s_diff_trust_out_in se_s_religion_hell=s_religion_hell se_s_values_uniform=s_values_uniform se_s_mfq_disgusting=s_mfq_disgusting se_s_diff_shame_guilt_overall=s_diff_shame_guilt_overall se_s_gps_punish_revenge=s_gps_punish_revenge, by(type)

stack s_diff_trust_out_in se_s_diff_trust_out_in type s_religion_hell se_s_religion_hell type s_values_uniform se_s_values_uniform type s_mfq_disgusting se_s_mfq_disgusting type s_diff_shame_guilt_overall se_s_diff_shame_guilt_overall type s_gps_punish_revenge se_s_gps_punish_revenge type, into(mean se type)

gen upper=mean+se
gen lower=mean-se
rename _ stack

gen order=1 if stack==1 & type==1
replace order=2 if stack==1 & type==2

replace order=4 if stack==2 & type==1
replace order=5 if stack==2 & type==2

replace order=7 if stack==3 & type==1
replace order=8 if stack==3 & type==2

replace order=10 if stack==4 & type==1
replace order=11 if stack==4 & type==2

replace order=13 if stack==5 & type==1
replace order=14 if stack==5 & type==2

replace order=16 if stack==6 & type==1
replace order=17 if stack==6 & type==2


graph twoway (bar mean order if stack==1 & type==1,color(navy)) (bar mean order if stack==1 & type==2, color(maroon)) (bar mean order if stack==2 & type==1,color(navy)) (bar mean order if stack==2 & type==2, color(maroon)) (bar mean order if stack==3 & type==1,color(navy)) (bar mean order if stack==3 & type==2, color(maroon)) (bar mean order if stack==4 & type==1,color(navy)) (bar mean order if stack==4 & type==2, color(maroon)) (bar mean order if stack==5 & type==1,color(navy)) (bar mean order if stack==5 & type==2, color(maroon)) (bar mean order if stack==6 & type==1,color(navy)) (bar mean order if stack==6 & type==2, color(maroon))   (rcap upper lower order, lcolor(black) xtitle("") yline(0,lcolor(black) lpattern(dash)) xlabel(1.5 `""{it:Δ Trust}" "{it:In- vs. out-group}""' 4.5 `""{it:Belief in}" "{it:hell}""' 7.5 `""{it:Communal vs.}" "{it:universal values}""' 10.5 "{it:Disgust}" 13.5 `""{it:Shame vs.}" "{it:guilt}""' 16.5 `""{it:Revenge vs.}" "{it:altr. punishm.}""') title("Contemporary moral systems") ytitle("Average ± s.e.m. (z-scores)") ylabel(-1 -.5 0 .5) legend(order(1 2) label(1 "Tight") label(2 "Loose")) graphregion(fcolor(white) lcolor(white)))
graph export Source_files/Figs/Overview_country.pdf, replace
restore
