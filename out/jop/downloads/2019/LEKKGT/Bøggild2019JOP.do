 ******************************************************************************************************
 ******************************************************************************************************
 ********* 					Replication code for Bøggild (JOP)		 						***********
 *********	Politicians as Party Hacks: Party Loyalty and Public Distrust in Politicians	***********
 ********* 								April 2019				 							***********
 ******************************************************************************************************
 ******************************************************************************************************

 ***Operationalizations of all variables are reported in the main text or the Online Appendix




 
					*****Analyses reported in main text*****


***Figure 1

**Proportions across groups (upper panels)
proportion groups_delegate_partisan if sample == 1
proportion groups_delegate_partisan if sample == 2
proportion groups_delegate_partisan if sample == 3

*Testing for significant differences in preferences for delegate representation between Denmark and US/UK
logit prefer_delegate_partisan ib(3).sample

**Correlations with trust in politicians (lower panels, full models also reported in Table B1, Online Appendix B)
reg trust_anes ib(2).groups_delegate_partisan age gender i.education pol_soph incumbent_support_strength if sample == 1
margins ib(2).groups_delegate_partisan

reg trust_anes ib(2).groups_delegate_partisan age gender i.education pol_soph incumbent_support_strength if sample == 2
margins ib(2).groups_delegate_partisan

reg trust_anes ib(2).groups_delegate_partisan age gender i.education pol_soph incumbent_support_strength if sample == 3
margins ib(2).groups_delegate_partisan





***Figure 2

**Proportions across groups (upper panels)
proportion groups_trustee_partisan if sample == 1
proportion groups_trustee_partisan if sample == 2
proportion groups_trustee_partisan if sample == 3

reg trust_anes ib(2).groups_trustee_partisan age gender i.education pol_soph incumbent_support_strength if sample == 1
margins ib(2).groups_trustee_partisan

reg trust_anes ib(2).groups_trustee_partisan age gender i.education pol_soph incumbent_support_strength if sample == 2 
margins ib(2).groups_trustee_partisan

reg trust_anes ib(2).groups_trustee_partisan age gender i.education pol_soph incumbent_support_strength if sample == 3 
margins ib(2).groups_trustee_partisan





***Figure 3

**Left-hand panel: Effect of partisan relative to delegate condition on trust in politician (Experiment 1) 
reg trust_politician party_disloyalty_loyalty if exp_1_2 == 1 & sample == 1
estimates store US_delegate

reg trust_politician party_disloyalty_loyalty if exp_1_2 == 1 & sample == 2
estimates store UK_delegate

reg trust_politician party_disloyalty_loyalty if exp_1_2 == 1 & sample == 3
estimates store DK_delegate

*Testing for different effect sizes across countries (Experiment 1)
reg trust_politician c.party_disloyalty_loyalty##i.sample if exp_1_2 == 1 & sample < 3
reg trust_politician c.party_disloyalty_loyalty##ib(3).sample if exp_1_2 == 1


**Right-hand panel: Effect of partisan relative to trustee condition on trust in politician (Experiment 2) 
reg trust_politician party_disloyalty_loyalty if exp_1_2 == 2 & sample == 1
estimates store US_trustee

reg trust_politician party_disloyalty_loyalty if exp_1_2 == 2 & sample == 2
estimates store UK_trustee

reg trust_politician party_disloyalty_loyalty if exp_1_2 == 2 & sample == 3
estimates store DK_trustee


coefplot US_delegate UK_delegate DK_delegate, bylabel(Partisan relative to delegate condition) || US_trustee UK_trustee DK_trustee, bylabel(Partisan relative to trustee condition) drop(_cons) ciopts(recast(rcap)) mlabel format(%9.2g) mlabposition(12)mlabgap(*2)

**Replications using surveys 4 and 5 (reported in main text)

*Survey 4 (UK Sample)
reg trust_politician party_disloyalty_loyalty if exp_1_2 == 1 & sample == 4
reg trust_politician party_disloyalty_loyalty if exp_1_2 == 2 & sample == 4

*Survey 5 (MTurk Sample)
reg trust_politician party_disloyalty_loyalty if exp_1_2 == 1 & sample == 5





***Figure 4

**Left-hand panel: Effect of partisan relative to delegate condition (Experiment 1) on trust in politician across shared party identification with politicians (Full model reported in Table H1, Online Appendix H)
reg trust_politician c.party_disloyalty_loyalty##c.shared_party if exp_1_2 == 1, robust
margins, dydx(party_disloyalty_loyalty) at(shared_party=(0(0.20)1)) level(95)
marginsplot , recast(line) recastci(rline)  ciopts(lpattern(dash))  yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Identification with politician's party") ytitle("Marginal effect on trust in politician") title("")  scheme(s1mono) 


**Right-hand panel: Effect of partisan relative to trustee condition (Experiment 2) on trust in politician across shared party identification with politicians (Full model reported in Table H2, Online Appendix H)
reg trust_politician c.party_disloyalty_loyalty##c.shared_party if exp_1_2 == 2, robust
margins, dydx(party_disloyalty_loyalty) at(shared_party=(0(0.20)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Identification with politician's party") ytitle("Marginal effect on trust in politician") title("")  scheme(s1mono) 





					*****Analyses reported in online appendix*****

					
					
***Online Appendix B (Full regression models for Figures 1 and 2 in main text)

**Table B1
reg trust_anes ib(2).groups_delegate_partisan age gender i.education pol_soph incumbent_support_strength if sample == 1
eststo modelus

reg trust_anes ib(2).groups_delegate_partisan age gender i.education pol_soph incumbent_support_strength if sample == 2
eststo modeluk

reg trust_anes ib(2).groups_delegate_partisan age gender i.education pol_soph incumbent_support_strength if sample == 3
eststo modeldk

reg trust_anes ib(2).groups_delegate_partisan age gender i.education incumbent_support_strength if sample == 6 & cue_non_dem_rep != 1 & cue_non_dem_rep != 2
eststo modelmturk

esttab using tableb1.rtf, r2 obslast nolines onecell se


**Table B2
eststo clear

reg trust_anes ib(2).groups_trustee_partisan age gender i.education pol_soph incumbent_support_strength if sample == 1
eststo modelus1

reg trust_anes ib(2).groups_trustee_partisan age gender i.education pol_soph incumbent_support_strength if sample == 2 
eststo modeluk1

reg trust_anes ib(2).groups_trustee_partisan age gender i.education pol_soph incumbent_support_strength if sample == 3 
eststo modeldk1

reg trust_anes ib(2).groups_trustee_partisan age gender i.education incumbent_support_strength if sample == 6 & cue_non_dem_rep != 1 & cue_non_dem_rep != 2
eststo modelmturk

esttab using tableb2.rtf, r2 obslast nolines onecell se


					
					
					
***Online Appendix C (randomization checks)

**Table C1

bys party_disloyalty_loyalty: sum age if sample == 1 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum age if sample == 2 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum age if sample == 3 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum age if sample == 4 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum age if sample == 5 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum age if sample == 6 & exp_1_2 == 1

bys party_disloyalty_loyalty: sum gender if sample == 1 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum gender if sample == 2 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum gender if sample == 3 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum gender if sample == 4 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum gender if sample == 5 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum gender if sample == 6 & exp_1_2 == 1

bys party_disloyalty_loyalty: sum education if sample == 1 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum education if sample == 2 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum education if sample == 3 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum education if sample == 4 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum education if sample == 5 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum education if sample == 6 & exp_1_2 == 1

bys party_disloyalty_loyalty: sum pol_sop if sample == 1 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum pol_sop if sample == 2 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum pol_sop if sample == 3 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum pol_sop if sample == 4 & exp_1_2 == 1

bys party_disloyalty_loyalty: sum trust_anes if sample == 1 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum trust_anes if sample == 2 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum trust_anes if sample == 3 & exp_1_2 == 1
bys party_disloyalty_loyalty: sum trust_anes if sample == 6 & exp_1_2 == 1



**Table C2
bys party_disloyalty_loyalty: sum age if sample == 1 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum age if sample == 2 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum age if sample == 3 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum age if sample == 4 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum age if sample == 5 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum age if sample == 6 & exp_1_2 == 2

bys party_disloyalty_loyalty: sum gender if sample == 1 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum gender if sample == 2 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum gender if sample == 3 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum gender if sample == 4 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum gender if sample == 5 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum gender if sample == 6 & exp_1_2 == 2

bys party_disloyalty_loyalty: sum education if sample == 1 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum education if sample == 2 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum education if sample == 3 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum education if sample == 4 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum education if sample == 5 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum education if sample == 6 & exp_1_2 == 2

bys party_disloyalty_loyalty: sum pol_sop if sample == 1 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum pol_sop if sample == 2 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum pol_sop if sample == 3 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum pol_sop if sample == 4 & exp_1_2 == 2

bys party_disloyalty_loyalty: sum trust_anes if sample == 1 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum trust_anes if sample == 2 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum trust_anes if sample == 3 & exp_1_2 == 2
bys party_disloyalty_loyalty: sum trust_anes if sample == 6 & exp_1_2 == 2




***Online Appendix F (Effects of partisan representation on policy support)

**Figure F1

reg policy_support party_disloyalty_loyalty if exp_1_2 == 1 & sample == 1
estimates store US_delegate

reg policy_support party_disloyalty_loyalty if exp_1_2 == 1 & sample == 2
estimates store UK_delegate

reg policy_support party_disloyalty_loyalty if exp_1_2 == 1 & sample == 3
estimates store DK_delegate

reg policy_support party_disloyalty_loyalty if exp_1_2 == 1 & sample == 6
estimates store MTurk_delegate


reg policy_support party_disloyalty_loyalty if exp_1_2 == 2 & sample == 1
estimates store US_trustee

reg policy_support party_disloyalty_loyalty if exp_1_2 == 2 & sample == 2
estimates store UK_trustee

reg policy_support party_disloyalty_loyalty if exp_1_2 == 2 & sample == 3
estimates store DK_trustee

reg policy_support party_disloyalty_loyalty if exp_1_2 == 2 & sample == 6
estimates store MTurk_trustee

coefplot US_delegate UK_delegate DK_delegate MTurk_delegate, bylabel(Partisan relative to delegate condition) || US_trustee UK_trustee DK_trustee MTurk_trustee, bylabel(Partisan relative to trustee condition) drop(_cons) ciopts(recast(rcap)) mlabel format(%9.2g) mlabposition(12)mlabgap(*2)





***Online Appendix G (Replication of effect of partisan representation on trust in politician with MTurk sample)

reg trust_politician party_disloyalty_loyalty if exp_1_2 == 1 & sample == 6 
estimates store MTurk_delegate

reg trust_politician party_disloyalty_loyalty if exp_1_2 == 2 & sample == 6  
estimates store MTurk_trustee

coefplot MTurk_delegate, bylabel(Partisan relative to delegate condition) || MTurk_trustee, bylabel(Partisan relative to trustee condition) drop(_cons) ciopts(recast(rcap)) mlabel format(%9.2g) mlabposition(12)mlabgap(*2)





***Online Appendix H (Effects of partisan representation on trust across levels of identiciation with politician's party)

**Table H1
reg trust_politician c.party_disloyalty_loyalty##c.shared_party if exp_1_2 == 1, robust

**Table H2
reg trust_politician c.party_disloyalty_loyalty##c.shared_party if exp_1_2 == 2, robust





***Online Appendix I (Effects of partisan representation across Independent and non-Independent respondents)

*Table I1
reg trust_politician c.party_disloyalty_loyalty##c.other_independents if exp_1_2 == 1, robust
reg trust_politician c.party_disloyalty_loyalty##c.other_independents if exp_1_2 == 2, robust





***Online Appendix J (Effects of partisan representation on trust across levels of identification with incumbent party)

**Table J1
eststo clear

reg trust_anes age gender i.education pol_soph ib(2).groups_delegate_partisan##c.incumbent_support_strength  if sample == 1, robust
eststo modelus

reg trust_anes age gender i.education pol_soph ib(2).groups_delegate_partisan##c.incumbent_support_strength  if sample == 2, robust
eststo modeluk

reg trust_anes age gender i.education pol_soph ib(2).groups_delegate_partisan##c.incumbent_support_strength  if sample == 3, robust
eststo modeldk

reg trust_anes age gender i.education ib(2).groups_delegate_partisan##c.incumbent_support_strength   if sample == 6 & cue_non_dem_rep != 1 & cue_non_dem_rep != 2, robust
eststo modelmturk

esttab using tablej1.rtf, r2 obslast nolines onecell se


**Table J2
eststo clear

reg trust_anes age gender i.education pol_soph ib(2).groups_trustee_partisan##c.incumbent_support_strength  if sample == 1, robust
eststo modelus1

reg trust_anes age gender i.education pol_soph ib(2).groups_trustee_partisan##c.incumbent_support_strength  if sample == 2, robust
eststo modeluk1

reg trust_anes age gender i.education pol_soph ib(2).groups_trustee_partisan##c.incumbent_support_strength  if sample == 3, robust
eststo modeldk1

reg trust_anes age gender i.education ib(2).groups_trustee_partisan##c.incumbent_support_strength  if sample == 6 & cue_non_dem_rep != 1 & cue_non_dem_rep != 2, robust
eststo modelmturk1

esttab using tablej2.rtf, r2 obslast nolines onecell se


**Table J3
eststo clear

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 1 & exp_1_2 == 1, robust
eststo  model1

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 2 & exp_1_2 == 1, robust
eststo  model2

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 3 & exp_1_2 == 1, robust
eststo  model3

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 4 & exp_1_2 == 1, robust
eststo  model4

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 5 & exp_1_2 == 1, robust
eststo  model5

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 6 & exp_1_2 == 1, robust
eststo  model6

esttab using tablej3.rtf, r2 obslast nolines onecell se



**Table J4
eststo clear

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 1 & exp_1_2 == 2, robust
eststo model1

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 2 & exp_1_2 == 2, robust
eststo  model2

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 3 & exp_1_2 == 2, robust
eststo  model3

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 4 & exp_1_2 == 2, robust
eststo  model4

reg trust_politician c.party_disloyalty_loyalty##c.incumbent_support_strength if sample == 6 & exp_1_2 == 2, robust
eststo  model6

esttab using tablej4.rtf, r2 obslast nolines onecell se





***Online Appendix K (Effects of partisan representation on trust in politician across prior trust in politicians)

**Figure K1

reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 1 & exp_1_2 == 1
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)


reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 2 & exp_1_2 == 1
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)


reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 3 & exp_1_2 == 1
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)

reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 6 & exp_1_2 == 1
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)


**Figure K2

reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 1 & exp_1_2 == 2
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)

reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 2 & exp_1_2 == 2
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)

reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 3 & exp_1_2 == 2
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)

reg trust_politician c.party_disloyalty_loyalty##c.trust_anes if sample == 6 & exp_1_2 == 2
margins, dydx(party_disloyalty_loyalty) at(trust_anes=(0(0.10)1)) level(95)
marginsplot , recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#5) legend(on label(1 "95% confidence interval") label(2 "Marginal effect")) xtitle("Prior trust in politicians") ytitle("Marginal effect on trust in politician") title("") scheme(s1mono)





***Online Appendix L (Delegate vs. trustee representation and associations with trust in politicians)

**Proportions across groups (upper panels)
proportion groups_delegate_trustee if sample == 1
proportion groups_delegate_trustee if sample == 2
proportion groups_delegate_trustee if sample == 3

**Correlations with trust in politicians (lower panels)
reg trust_anes ib(2).groups_delegate_trustee age gender i.education pol_soph incumbent_support_strength if sample == 1
margins ib(2).groups_delegate_trustee

reg trust_anes ib(2).groups_delegate_trustee age gender i.education pol_soph incumbent_support_strength if sample == 2
margins ib(2).groups_delegate_trustee

reg trust_anes ib(2).groups_delegate_trustee age gender i.education pol_soph incumbent_support_strength if sample == 3
margins ib(2).groups_delegate_trustee
