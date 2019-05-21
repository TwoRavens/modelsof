
* Requires estout package: http://repec.org/bocode/e/estout/index.html
*Estimation*

***** Results for Table 1: Inclusion of Dispute Resolution Mechanism
eststo clear
probit dispute pea gov_lr_vpdistance coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

probit dispute pea gov_lr_vpdistance coa_seatstrength_sd words spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa region, vce(cluster state)
eststo

probit dispute pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

probit dispute pea c.gov_lr_vpdistance##c.coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo

***  Obtain probabibilities for Figure 2 and save as .csv file.
***  Figure 2: Probability of Dispute Resolution Mechanism

margins, at(coa_seatstrength_sd=(0(.28).56) gov_lr_vpdistance=(0.5(.5)6.5))

matrix m_lr=r(b)
matrix m_lr0=m_lr[1,1..13]'
matrix m_lr28=m_lr[1,14..26]'
matrix m_lr56=m_lr[1,27..39]'
matrix at=r(at)
matrix v=vecdiag(r(V))'
matmap v se, map(sqrt(@))
matrix se0=se[1..13,1]
matrix se28=se[14..26,1]
matrix se56=se[27..39,1]
matrix lb0=m_lr0-1.96*se0
matrix ub0=m_lr0+1.96*se0
matrix lb28=m_lr28-1.96*se28
matrix ub28=m_lr28+1.96*se28
matrix lb56=m_lr56-1.96*se56
matrix ub56=m_lr56+1.96*se56
matrix lr=m_lr0,lb0,ub0,m_lr28,lb28,ub28,m_lr56,lb56,ub56,at[1..13,"gov_lr_vpdistance"]
matrix colnames lr =  lr0_b lr0_lb lr0_ub lr28_b lr28_lb lr28_ub lr56_b lr56_lb lr56_ub lr
matrix list lr
*mat2txt2 lr using "disp_lr.csv", comma replace


/* save latex output
esttab using "LJAD_fig1.tex", label nodepvars scalars("N \sc Observations" "ll \sc Log Likelihood" "chi2 $\chi^2$")  booktabs title(\sc Inclusion of Dispute Resolution Mechanism: Probit ) ///
	replace coeflabels(_cons "\sc Constant" N "test" c.gov_lr_vpdistance#c.coa_seatstrength_sd "\sc Range*Seat Share S.D." )  ///
	p cells(b(fmt(a2) star) p(par fmt(a2))) ///
	drop()  ///
	order(gov_lr_vpdistance coa_seatstrength_sd c.gov_lr_vpdistance#c.coa_seatstrength_sd words pea spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa) star(* 0.10 ** 0.05 *** 0.01)
*/


********************************************************************************************************************************
**** Number of words (coalition governance) in coalition agreement	(TABLE 2)
********************************************************************************************************************************

eststo clear
nbreg a_words_coalition	pea gov_lr_vpdistance coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

nbreg a_words_coalition	pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words  year prev_coa region, vce(cluster state)
eststo

nbreg a_words_coalition	pea gov_lr_vpdistance coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo

nbreg a_words_coalition	pea c.gov_lr_vpdistance##c.coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo


*** Graph marginal effects: Fig 2, panel A	
margins, dydx(gov_lr_vpdistance) at(coa_seatstrength_sd=(0(.05).56))
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) xtitle(`"{fontface "Garamond":Portfolio Share S.D.}"') ///
	ytitle(`"{fontface "Garamond":No. Words}"') title("") yline(0, lwidth(thin))
*** Uncomment to save graph
*graph export coalition_m_ideol.png, replace

* Uncomment 'mat2txt2' command to save marginal effects & CIs in .csv file
matrix m_lr=r(b)'
matrix at=r(at)
matrix v=vecdiag(r(V))'
matmap v se, map(sqrt(@))
matrix lb=m_lr-1.96*se
matrix ub=m_lr+1.96*se
matrix lr=m_lr,lb,ub,at[1..12,"coa_seatstrength_sd"]
matrix colnames lr =  lr_b lr_lb lr_ub seatsd
matrix list lr
*mat2txt2 lr using "proc_lr.csv", comma replace



*** Graph marginal effects: Fig 2, panel A	
margins, dydx(coa_seatstrength_sd) at(gov_lr_vpdistance=(0.5(.5)6.5))
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) xtitle(`"{fontface "Garamond":Ideological Range}"') ///
	ytitle(`"{fontface "Garamond":No. Words}"') title("") title("") yline(0, lwidth(thin))	
*** Uncomment to save graph	
*graph export coalition_m_seat.png, replace

* Uncomment 'mat2txt2' command to save marginal effects & CIs in .csv file
matrix m_lr=r(b)'
matrix at=r(at)
matrix v=vecdiag(r(V))'
matmap v se, map(sqrt(@))
matrix lb=m_lr-1.96*se
matrix ub=m_lr+1.96*se
matrix lr=m_lr,lb,ub,at[1..13,"gov_lr_vpdistance"]
matrix colnames lr =  s_b s_lb s_ub lr
matrix list lr
*mat2txt2 lr using "proc_seat.csv", comma replace

/* save latex output
esttab using "wordscoal_pea.tex", label nodepvars scalars("N \sc Observations" "ll \sc Log Likelihood" "chi2 $\chi^2$")  booktabs title(\sc Length of Coalition Agreement (Governance): \\ Negative Binomial Regression \label{fig:res1}) ///
	replace coeflabels(_cons "\sc Constant" N "test" c.gov_lr_vpdistance#c.coa_seatstrength_sd "\sc Range*Seat Share S.D." )  ///
	p cells(b(fmt(a2) star) p(par fmt(a2))) ///
	drop()  ///
	order(gov_lr_vpdistance coa_seatstrength_sd c.gov_lr_vpdistance#c.coa_seatstrength_sd pea spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa) star(* 0.10 ** 0.05 *** 0.01)
*/



*******************************************************************************************	
*** Tables in Appendix
*******************************************************************************************

***** Appendix: Table 3: Descriptive statistics

label var a_words_coalition "\sc Agreement Length: Governance"
sum gov_lr_vpdistance coa_seatstrength_sd words a_words_coalition prev_coa region


***** Appendix: Table 4: Inclusion of Coalition Committee
eststo clear
probit  a_coalcom_dispute_settlem pea gov_lr_vpdistance  coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

probit  a_coalcom_dispute_settlem  pea gov_lr_vpdistance coa_seatstrength_sd words spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa region, vce(cluster state)
eststo

probit  a_coalcom_dispute_settlem pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

probit  a_coalcom_dispute_settlem pea c.gov_lr_vpdistance##c.coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo

/* save latex output
esttab using "dispute_cc.tex", label nodepvars scalars("N \sc Observations" "ll \sc Log Likelihood" "chi2 $\chi^2$")  booktabs title(\sc Inclusion of Dispute Resolution Mechanism: Probit ) ///
	replace coeflabels(_cons "\sc Constant" N "test" c.gov_lr_vpdistance#c.coa_seatstrength_sd "\sc Range*Seat Share S.D." )  ///
	p cells(b(fmt(a2) star) p(par fmt(a2))) ///
	drop()  ///
	order(gov_lr_vpdistance coa_seatstrength_sd c.gov_lr_vpdistance#c.coa_seatstrength_sd words pea spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa) star(* 0.10 ** 0.05 *** 0.01)
*/
	
	
***** Appendix: Table 5: Number of Dispute Resolution Mechanism (0,1,2)
*gen dispute_sum=a_coalcom_dispute_settlem+a_dispute_settlement_other

eststo clear
nbreg  dispute_sum pea gov_lr_vpdistance coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

nbreg  dispute_sum pea gov_lr_vpdistance coa_seatstrength_sd words spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa region, vce(cluster state)
eststo

nbreg  dispute_sum pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

nbreg  dispute_sum pea c.gov_lr_vpdistance##c.coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo

/* save latex output
esttab using "dispute_sum.tex", label nodepvars scalars("N \sc Observations" "ll \sc Log Likelihood" "chi2 $\chi^2$")  booktabs title(\sc Inclusion of Dispute Resolution Mechanism: Probit ) ///
	replace coeflabels(_cons "\sc Constant" N "test" c.gov_lr_vpdistance#c.coa_seatstrength_sd "\sc Range*Seat Share S.D." )  ///
	p cells(b(fmt(a2) star) p(par fmt(a2))) ///
	drop()  ///
	order(gov_lr_vpdistance coa_seatstrength_sd c.gov_lr_vpdistance#c.coa_seatstrength_sd words spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa) star(* 0.10 ** 0.05 *** 0.01)
*/


***** Appendix: Table 6: Share of Coalition Agreement (Governance)

eststo clear
reg sh_gov_w pea gov_lr_vpdistance coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

reg sh_gov_w pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words  year prev_coa region, vce(cluster state)
eststo

reg sh_gov_w pea gov_lr_vpdistance coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo

reg sh_gov_w pea c.gov_lr_vpdistance##c.coa_seatstrength_sd spd_gov gru_gov fdp_gov pds_gov cdu_gov words year prev_coa region, vce(cluster state)
eststo

/* save latex output
esttab using "sh_wordscoal_pea.tex", label nodepvars scalars("N \sc Observations" "ll \sc Log Likelihood" "chi2 $\chi^2$" "r2 R$^2$")  booktabs title(\sc Share of Coalition Agreement (Governance): \\ OLS \label{tab:shwordsgov}) ///
	replace coeflabels(_cons "\sc Constant" N "test" c.gov_lr_vpdistance#c.coa_seatstrength_sd "\sc Range*Seat Share S.D." )  ///
	p cells(b(fmt(a2) star) p(par fmt(a2))) ///
	drop()  ///
	order(gov_lr_vpdistance coa_seatstrength_sd c.gov_lr_vpdistance#c.coa_seatstrength_sd pea spd_gov gru_gov fdp_gov pds_gov cdu_gov year prev_coa) star(* 0.10 ** 0.05 *** 0.01)
*/

	
***** Appendix: Table 7: Inclusion of Dispute Resolution Mechanism
***** Probit Model, Control for Manifesto Length
 
eststo clear
probit dispute pea gov_lr_vpdistance coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

probit dispute pea gov_lr_vpdistance coa_seatstrength_sd words words_tot_mani year prev_coa region, vce(cluster state)
eststo

probit dispute pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words year prev_coa region, vce(cluster state)
eststo

probit dispute pea c.gov_lr_vpdistance##c.coa_seatstrength_sd words_tot_mani words year prev_coa region, vce(cluster state)
eststo

/* save latex output
esttab using "dispute_pea_R3cmp.tex", label nodepvars scalars("N \sc Observations" "ll \sc Log Likelihood" "chi2 $\chi^2$")  booktabs title(\sc JOP R3 req: Inclusion of Dispute Resolution Mechanism: Probit ) ///
	replace coeflabels(_cons "\sc Constant" N "test" c.gov_lr_vpdistance#c.coa_seatstrength_sd "\sc Range*Seat Share S.D." )  ///
	p cells(b(fmt(a2) star) p(par fmt(a2))) ///
	drop()  ///
	order(gov_lr_vpdistance coa_seatstrength_sd c.gov_lr_vpdistance#c.coa_seatstrength_sd words pea year prev_coa) star(* 0.10 ** 0.05 *** 0.01)
*/
