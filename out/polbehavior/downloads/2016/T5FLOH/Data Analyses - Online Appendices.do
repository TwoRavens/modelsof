******************************************************
************** Data Analyses: Online Appendices 
************** The following do file provides the code
************** for the the various analyses reported in the online appendices. 
************** The data cleaning files must be run first. 
************** Analyess are provied by topic,
************** with both datasets represented. 
**************************************
**************************************
**************************************



					*********Online Appendix A******
*****Randomization Tests*****

*Study 1
	eststo clear
	eststo: ologit condition i.gender i.race income educ age ideology dream_imp pid1 trust_mean interest
	esttab using randomcheck_full12.rtf, se pr2 star(+ 0.10 * 0.05 * 0.01)
	eststo clear


*Study 2
	eststo clear
	eststo: ologit condition i.gender ib3.race age educ1 income interest cynic_mean pid pid_imp ideology_gen
	eststo: ologit condition i.gender ib3.race age educ1 income interest cynic_mean pid pid_imp ideology_econ ideology_social
	esttab using random_full10.rtf, label onecell pr2 se scalars(ll_0 ll chi2) star(+ 0.10 * 0.05 ** 0.01) 
	eststo clear

****Manipulation Checks*****

*Study 1
	*Coding Correctness
	gen correct = . 
	replace correct = 1  if position == 1 & condition == 2
	replace correct = 1  if position == 1 & condition == 3
	replace correct = 1  if position == 1 & condition == 6
	replace correct = 1  if position == 1 & condition == 7
	replace correct = 1  if position == 1 & condition == 10
	replace correct = 1  if position == 1 & condition == 11
	replace correct =  0 if position == 2 & condition == 2
	replace correct =  0 if position == 2 & condition == 3
	replace correct =  0 if position == 2 & condition == 6
	replace correct =  0 if position == 2 & condition == 7
	replace correct =  0 if position == 2 & condition == 10
	replace correct =  0 if position == 2 & condition == 11
	replace correct =  1 if position == 2 & condition == 1
	replace correct =  1 if position == 2 & condition == 4
	replace correct =  1 if position == 2 & condition == 5
	replace correct =  1 if position == 2 & condition == 8
	replace correct =  1 if position == 2 & condition == 9
	replace correct =  1 if position == 2 & condition == 12
	replace correct =  0 if position == 1 & condition == 1
	replace correct =  0 if position == 1 & condition == 4
	replace correct =  0 if position == 1 & condition == 5
	replace correct =  0 if position == 1 & condition == 8
	replace correct =  0 if position == 1 & condition == 9
	replace correct =  0 if position == 1 & condition == 12
	label def corrA 1 "Correct" 0 "Incorrect"
	label values correct corrA
	label var corr "Correct on Manip. Check"
	
	
	label var position "Candidate A's Most Recent Position"
	label def posi 1 "Opposes the Dream Act" 2 "Supports the Dream Act"
	label values position pos

	gen recent_pro = . 
	replace recent_pro = 1 if condition == 1
	replace recent_pro = 1 if condition == 4
	replace recent_pro = 1 if condition == 5
	replace recent_pro = 1 if condition == 8
	replace recent_pro = 1 if condition == 9
	replace recent_pro = 1 if condition == 12
	replace recent_pro = 0 if condition == 2
	replace recent_pro = 0 if condition == 3
	replace recent_pro = 0 if condition == 6
	replace recent_pro = 0 if condition == 7
	replace recent_pro = 0 if condition == 10
	replace recent_pro = 0 if condition == 11
	label var recent_pro "Candidate Most Recent Position = Pro"
	label def recen 1 "Yes, Pro" 0 "No, Con"
	label values recent_pro recen

	*Tables in Appendix
	tab correct
	by condition, sort: tab correct
	by recent_pro, sort: tab correct
	by same_pos, sort: tab correct
	
	eststo clear
	eststo: logit correct i.inconsistent i.account1 i.recent_pro i.dream1
	eststo: logit correct i.inconsistent i.account1 i.recent_pro i.dream1 ideology pid1 dream_imp interest
	eststo: logit correct i.inconsistent i.account1 i.recent_pro##i.dream1 ideology pid1 dream_imp interest
	esttab using MANIP_S1.rtf, pr2 se onecell nobaselevels label star(+ 0.10 * 0.05 ** 0.01)
	eststo clear




****Study 2

*PID*
	label var manip_pid "PID Manip Check"
	label def mani 1 "Rep" 2 "Dem"
	label values manip_pid mani
	tab manip_pid

	gen manip_pid_corr = .
	replace manip_pid_corr = 1  if cond_party == 0 & manip_pid == 1
	replace manip_pid_corr = 1  if cond_party == 1 & manip_pid == 2
	replace manip_pid_corr =  0 if cond_party == 0 & manip_pid == 2
	replace manip_pid_corr =  0 if cond_party == 1 & manip_pid == 1
	label var manip_pid_corr "PID Manip Check: Correct"
	label def correct 1 "Correct" 0 "Incorrect" 
	label values manip_pid_corr correct
	tab manip_pid_corr

	by condition, sort: tab manip_pid_corr
	by cond_party1, sort: tab manip_pid_corr


*Committee*		
	gen manip_comm_corr = . 
	replace manip_comm_corr = 1 if manip_comm == 1
	replace manip_comm_corr = 0 if manip_comm >= 2 & manip_comm <= 5
	label var manip_comm_corr "Committee Manip. Check: Correct"
	label values manip_comm_corr correct
	tab manip_comm_corr
	by condition, sort: tab manip_comm_corr
	by cond_party1, sort: tab manip_comm_corr

	eststo clear
	eststo: logit manip_pid_corr i.condition1##i.cond_party
	eststo: logit manip_comm_corr i.condition
	esttab, pr2 se label star(+ 0.10 * 0.05 ** 0.01)
	eststo clear


					*********Online Appendix B******
					
***Bonferroni Adjusted Differences
	*Study 1
		oneway eval incon_acc4
		contrast r.incon_acc4, mcompare(bonferroni)
		contrast rb2.incon_acc4, mcompare(bonferroni)
	*Study 2
		oneway eval condition1
		contrast r.condition1, mcompare(bonferroni)
		contrast rb3.condition1, mcompare(bonferroni)
					
***Audience Characteristics and Treatments (Tables OB4-5  ) 

	*Study 1
		*Analyses and Figure
			drop _est_*
			eststo clear
			eststo: regress eval i.incon_acc4##i.pos
			margins 1b.incon_acc4 2.incon_acc4 3.incon_acc4 4.incon_acc4, at(pos==1) post
			estimates store SAME
			
			regress eval i.incon_acc4##i.pos
			margins 1b.incon_acc4 2.incon_acc4 3.incon_acc4 4.incon_acc4, at(pos==2) post
			estimates store DIFF	
			
			regress eval i.incon_acc4##i.pos
			margins 1b.incon_acc4 2.incon_acc4 3.incon_acc4 4.incon_acc4, at(pos==3) post
			estimates store NEI
			
			esttab using Study1_IssueAgreeMod.rtf, se ar2 onecell label star(+ 0.10 * 0.05 ** 0.01)
			eststo clear
		
		coefplot SAME, bylabel("Same Position" "as Cand. A") ||  ///
			DIFF, bylabel("Different Position" "as Cand. A") || NEI, bylabel("Respondent Answered" "Neither") || , ///
			mlab mlabpos(12) mlabsize(small) format(%9.2g) scheme(s1mono)  legend(rows(1)) xline(0, lpattern(dash)) ///
			coeflabel(1.incon_acc4="Consistent" 2.incon_acc4=`""Repositioned" "No Just.""' ///
			3.incon_acc4=`""Repositioned" "Soc. Fairness""' 4.incon_acc4=`""Repositioned" "Comp. Ends.""', labsize(small)) level(95 90) ///
			byopts(title("Study 1" "Evaluations by Condition and Issue Agreement") cols(3))
			graph save Graph "Study 1 - Eval by Prox (separate).gph"
			
	
	*Study 2
		*Analyses and Figure
			eststo clear
			eststo: regress eval i.condition1##i.cond_party1
			margins condition1, at(cond_party1=(1)) post
			estimates store SAME

			regress eval i.condition1##i.cond_party1
			margins condition1, at(cond_party1=(2)) post
			estimates store DIFF

			regress eval i.condition1##i.cond_party1
			margins condition1, at(cond_party1=(3)) post
			estimates store NEI
			esttab using Study2_CoPartisanMod.rtf, se ar2 onecell label star(+ 0.10 * 0.05 ** 0.01) 
			eststo clear
			
			coefplot SAME, bylabel("Co-Partisan" "to Rep. A") || ///
				DIFF, bylabel("Different Party" "from Rep. A") || /// 
				NEI, bylabel("Respondent is" "an Independent") 	|| , ///
				mlab mlabpos(12) mlabsize(small) format(%9.2g) scheme(s1mono) xline(0, lpattern(dash)) legend(rows(1)) ///
				coeflabel(1.condition1="Baseline" 2.conditionn1="Consistent" 3.condition1=`""Repositioned" "No Just.""'  ///
				4.condition1=`""Repositioned" "New Info""' 5.condition1=`""Repositioned" "P. Fairness.""') ///
				byopts(cols(3) title("Study 2" "Evaluations by Condition and Co-Partisanship"))
				*graph save*
				*graph combine with study 1, scheme(s1mono), rows(2))
	

***Motives and Overall Evaluations (Tables OB ) 
		*Study 1*
			eststo clear
			eststo: regress eval helpmotives_f polmotives_f 
			eststo: regress eval helpmotives_f polmotives_f i.race i.gender age income educ trust_mean pid1 
			esttab using Study1_Motives_Eval.rtf, se ar2 onecell label star(+ 0.10 * 0.05 ** 0.01)
			eststo clear
		*Study 2
			eststo clear
			eststo: regress eval political_motives representation_motives policy_motives
			eststo: regress eval political_motives representation_motives policy_motives ib3.race i.gender educ age cynic_mean pid
			esttab using Study2_Motives_Eval.rtf, ci ar2 onecell label star(+ 0.10 * 0.05 ** 0.01)
			eststo clear


***Replication with Consistent + Justification (Study 1)***
		eststo clear 
		eststo: regress eval i.inconsistent i.account1
		eststo: regress eval i.inconsistent##i.account1
		margins, dydx(inconsistent) by(account1)
		esttab	using Study1_rep.rtf, onecell label nobaselevels star(+ 0.10 * 0.05 ** 0.01) ar2 se
		eststo clear
			

***Replication with Individual Items
	*replication with individual items
		*Study 1*
			eststo clear
			eststo: regress therm i.incon_acc4
			eststo: regress honest1 i.incon_acc4
			eststo: regress intel i.incon_acc4
			eststo: regress open1 i.incon_acc4
			eststo: regress compass i.incon_acc4
			esttab using Study1___indiv_items.rtf, p onecell label star(+ 0.10 * 0.05 ** 0.01) ar2 
			eststo clear
		
					
		*Study 2*
			eststo clear
			eststo: regress therm i.condition1 i.cond_party
			eststo: regress leader i.condition1 i.cond_party
			eststo: regress open i.condition1 i.cond_party
			eststo: regress intelligent i.condition1 i.cond_party
			esttab using Study2_indiv_items.rtf, p onecell label star(+ 0.10 * 0.05 ** 0.01) ar2
			eststo clear

		
			eststo clear
			eststo: regress therm i.condition1##i.cond_party1
			eststo: regress leader i.condition1##i.cond_party1
			eststo: regress open i.condition1##i.cond_party1
			eststo: regress intelligent i.condition1##i.cond_party1
			esttab , p ar2
			


				*******Online Appendix C: Account Satisfaction and Matching***
***Moderation by Post-Test Account Satisfaction
	*predicting satisfaction
		*study 1
		eststo clear
		eststo: regress satis_c trust_mean ideology pid interest educ dream_imp i.race
		esttab using Study1_satis.rtf, ar2 onecell label star(+ 0.10 * 0.05 ** 0.01)
		eststo clear
		*study 2
		eststo clear
		eststo: regress satis cynic_mean ideology_gen pid i.cond_party1 interest educ1 pid_imp 
		eststo: regress satis cynic_mean ideology_gen  i.cond_party1 interest educ1 pid_imp 
		esttab using Study2.satis.rtf, ar2 onecell label star(+ 0.10 * 0.05 ** 0.01)
		eststo clear
		
	*Persuasion
		*Study 1
			eststo clear
			eststo: regress dream_reverse1 c.satis_c##i.pos2
			margins pos2, at(satis_c=(1(1)7)) saving(NC, replace)
			eststo: regress dream_reverse1 c.satis_c##i.pos2 dream_imp ideology pid1 i.race 
			margins pos2, at(satis_c=(1(1)7)) saving(C, replace)
			esttab using ST1_PERS_SAT.rtf, ar2 se onecell label star(+ 0.10 * 0.05 ** 0.01)
			eststo clear
			combomarginsplot NC C, by(pos2) scheme(s1mono) ///
				xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7") xtitle(Account Satisfaction) ///
				labels("No Controls" "Controls") 
		
	*Motives
		*Study 1
			eststo clear
			eststo: regress polmotives_f c.satis_c
			eststo: regress polmotives_f c.satis_c c.trust_mean c.interest c.pid1 c.ideology c.dream_imp i.gender i.race c.age 
			eststo: regress helpmotives_f c.satis_c
			eststo: regress helpmotives_f c.satis_c c.trust_mean c.interest c.pid1 c.ideology c.dream_imp i.gender i.race c.age 
			esttab using S1_SAT_MOTIVES.rtf, ar2 se star(+ 0.10 * 0.05 ** 0.01) onecell label
			eststo clear
		*Study 2
			eststo clear
			eststo: regress political_motives c.satis 
			eststo: regress political_motives c.satis i.cond_party1 c.cynic_mean c.interest c.pid c.ideology_gen i.gender ib3.race c.age
			eststo: regress political_motives c.satis##i.cond_party1 c.cynic_mean c.interest c.pid c.ideology_gen i.gender ib3.race c.age
			
			eststo: regress representation_motives c.satis 
			eststo: regress representation_motives c.satis i.cond_party1 c.cynic_mean c.interest c.pid c.ideology_gen i.gender ib3.race c.age
			eststo: regress representation_motives c.satis##i.cond_party1 c.cynic_mean c.interest c.pid c.ideology_gen i.gender ib3.race c.age

			eststo: regress policy_motives c.satis 
			eststo: regress policy_motives c.satis i.cond_party1 c.cynic_mean c.interest c.pid c.ideology_gen i.gender ib3.race c.age
			eststo: regress policy_motives c.satis##i.cond_party1 c.cynic_mean c.interest c.pid c.ideology_gen i.gender ib3.race c.age
			
			esttab using ST2_MOTIVES_S.rtf,  ar2 se star(+ 0.10 * 0.05 ** 0.01) onecell label
			eststo clear
			
			
	
				
***Matching Analyses***	

*Study 1
	*Creating the Data Set*
		gen satis_binary = .
		replace satis_binary = 1 if satis_c >=5 & satis_c <= 7
		replace satis_binary = 0 if satis_c >=1 & satis_c <= 3
		label def satb 1 "Satisfied" 0 "Dissatisfied"
		label values satis_binary satb
		label var satis_binary "Satisfaction with Account"
		drop if satis_binary == . 
		*save as new dataset
		
	*Creating the matching weights
		tabulate ideology_3, gen(ideol)
		label var ideol1 "Liberal"
		label var ideol2 "Moderate"
		label var ideol3 "Conservative"
		
		imb trust_mean ideol2 ideol3 interest educ , treatment(satis_binary)
		cem trust_mean ideol2 ideol3 interest educ , tr(satis_binary) 
		
	*Persuasion
		*Table OC
		drop _est_*
		eststo clear
		eststo: regress dream_reverse1 i.pos2##i.satis_binary [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store ALL
		eststo: regress dream_reverse1 i.pos2##i.satis_binary if ideology_3 == 1 [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store LIB
		eststo: regress dream_reverse1 i.pos2##i.satis_binary if ideology_3 == 2 [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store MOD
		eststo: regress dream_reverse1 i.pos2##i.satis_binary if ideology_3 == 3 [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store CON
		esttab using Study1_Match__Pers_NC.rtf, ar2 se onecell label star(+ 0.10 * 0.05 ** 0.01) 
		eststo clear
		
		*Table OC
		eststo clear				
		eststo: regress dream_reverse1 i.pos2##i.satis_binary pid1 age educ i.race i.gender [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store ALL_C
		eststo: regress dream_reverse1 i.pos2##i.satis_binary pid1 age educ i.race i.gender if ideology_3 == 1 [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store LIB_C
		eststo: regress dream_reverse1 i.pos2##i.satis_binary pid1 age educ i.race i.gender  if ideology_3 == 2 [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store MOD_C
		eststo: regress dream_reverse1 i.pos2##i.satis_binary pid1 age educ i.race i.gender if ideology_3 == 3 [iweight = cem_weights]
		margins, dydx(satis_binary) by(pos2) post
		estimates store CON_C
		esttab using Study1_Match_Pers_C.rtf, ar2 se onecell label star(+ 0.10 * 0.05 ** 0.01) 
		eststo clear
		
		*Figure 
			coefplot ALL_C || LIB_C || MOD_C || CON_C  || , ///
				headings(2.pos2="{bf:Societal Fairness}" 4.pos2="{bf:Comp. of Ends}") ///
				coeflabel(2.pos2="Support to Oppose" 3.pos2="Oppose to Support" ///
					4.pos2="Support to Oppose" 5.pos2="Oppose to Support" ) ///
					mlab mlabpos(2) format(%9.2g) xline(0, lpattern(dash)) /// 
					byopts(title(Diff. Between Satisfied and Dissatisfied)) ///
					scheme(s1mono)
		
			
			
					
		***Motives*
			drop _est_*
			eststo clear
			eststo: regress polmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender [iweight = cem_weights]
			margins, dydx(satis_binary) by(account2) post
			estimates store T1
			
			eststo: regress helpmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender [iweight = cem_weights]
			margins, dydx(satis_binary) by(account2) post
			estimates store T2
			
				
			 
			eststo: regress polmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender if pos == 1 [iweight = cem_weights] 
			margins, dydx(satis_binary) by(account2) post
			estimates store T3
			
			 
			eststo: regress helpmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender if pos == 1 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account2) post
			estimates store T4
			
			
			
			 
			eststo: regress polmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender if pos == 2 [iweight = cem_weights] 
			margins, dydx(satis_binary) by(account2) post
			estimates store T5
			
			 
			eststo: regress helpmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender if pos == 2 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account2) post
			estimates store T6
			
				
			 
			eststo: regress polmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender if pos == 3 [iweight = cem_weights] 
			margins, dydx(satis_binary) by(account2) post
			estimates store T7
			
			 
			eststo: regress helpmotives_f i.satis_binary##i.account2 pid1 age educ i.race i.gender if pos == 3 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account2) post
			estimates store T8
			esttab using Study1__Matched_Motives.rtf, onecell label nobaselevels ar2 se star(+ 0.10 * 0.05 ** 0.01) 
			eststo clear
			
				
			coefplot (T1, label(Political Motives)) (T2 , label(Representation Motives) symbol(T)), bylabel(All Respondents) || ///
				T3 T4, bylabel(Issue Agreement) || T5 T6, bylabel(Issue Disagreement) || T7 T8, bylabel(Neither) || , ///
				mlab mlabpos(2) format(%9.2g) scheme(s1mono) xline(0, lpattern(dash)) byopts(title(Study 1: Satisfaction's Effects on Motive Beliefs))
				graph save "Study 1 - Motives - Matched.gph"


	*Study 2: Motives
		*Create the dataset
			gen satis_binary = .
			replace satis_binary = 1 if satis >=5 & satis <= 7
			replace satis_binary = 0 if satis >=1 & satis <= 3
			label def satb 1 "Satisfied" 0 "Dissatisfied"
			label values satis_binary satb
			label var satis_binary "Satisfaction with Account"
			*drop if satis_binary == . 
			
		*Creating the Matching weights in the new dataset
			tabulate cond_party1, gen(cp)
			label var cp1 "Same Party as R"
			label var cp2 "Diff Party as R" 
			label var cp3 "R is Ind"
			tabulate ideology_gen, gen(ideol)
			label var ideol1 "Liberal" 
			label var ideol2 "Moderate"
			label var ideol3 "Conservative"
			tabulate pid_3cat, gen(pid_)
			label var pid_1 "Democrats" 
			label var pid_2 "Republicans" 
			label var pid_3 "Independents"
			
			imb cynic_mean cp2 pid_imp  interest, treat(satis_binary)
			cem cynic_mean cp2 pid_imp  interest, treat(satis_binary)
	
		*Analyses
			drop _est_*
			eststo clear
			eststo: regress political_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T1	
			
			eststo: regress representation_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T2
			
			eststo: regress policy_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T3	
			
			eststo clear
			eststo: regress political_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ if cond_party1 == 1 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T4
			
			eststo: regress representation_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ if cond_party1 == 1  [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T5
			
			eststo: regress policy_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ  if cond_party1 == 1  [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T6	
			esttab using Study2_motives_matched1b.rtf, onecell nobaselevels label ar2 se star(+ 0.10 * 0.05 ** 0.01) 
			eststo clear
					
			eststo clear
			eststo: regress political_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ if cond_party1 == 2 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T7
			
			eststo: regress representation_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ if cond_party1 == 2 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T8
			
			eststo: regress policy_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ  if cond_party1 == 2  [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T9
			
			
			eststo clear
			eststo: regress political_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ if cond_party1 == 3 [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T10
			
			eststo: regress representation_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ if cond_party1 == 3  [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T11
			
			eststo: regress policy_motives i.satis_binary##i.account pid_3cat cynic_mean ideology_gen age i.gender educ  if cond_party1 == 3  [iweight = cem_weights]
			margins, dydx(satis_binary) by(account) post
			estimates store T12
			esttab using  Study2_motives_matched2.rtf, onecell nobaselevels label ar2 se star(+ 0.10 * 0.05 ** 0.01) 
			eststo clear
			
			coefplot (T1, label(Political Motives)) (T2, label(Representation Motives) symbol(T)) (T3, label(Policy Motives) symbol(S)), bylabel(All Respondents) || ///
				T4 T5 T6, bylabel(Co-Partisans) || T7 T8 T9, bylabel(Non Co-Partisans) || T10 T11 T12 , bylabel(Independents) || , ///
				mlab mlabpos(2) format(%9.2g) scheme(s1mono) xline(0, lpattern(dash)) byopts(title(Study 2))  legend(rows(1))  ///
				coeflabel(1.account=`""Personal" "Fairness""')
				graph save "Study 2 - Motives Matched.gph"
				
			graph combine "Study 1 - Motives - Matched.gph" "Study 2 - Motives - Matched.gph" , scheme(s1mono)




				*******Online Appendix D: Controlling for Covariates; Moderation
				
*Controllinng for other variables
	*Study 1
		eststo clear
		eststo: regress eval i.incon_acc4 pid1 ideology dream_imp trust_mean i.gender i.race age educ income 
		esttab using Study1__withcontrols.rtf, onecell label star(+ 0.10 * 0.05 ** 0.01) ar2 se
		eststo clear

	*Study 2
		eststo clear
		eststo: regress eval i.condition1 i.cond_party pid ideology_gen cynic_mean i.gender ib3.race  age educ income 
		eststo: regress eval i.condition1 i.cond_party1 pid ideology_gen cynic_mean i.gender ib3.race  age educ income 
		esttab using Study2__withcontrols.rtf, onecell label star(+ 0.10 * 0.05 ** 0.01) ar2 se nobaselevels
		
*Moderation by demographics
	*Study 1
		eststo clear
		eststo: regres eval i.incon_acc4##c.educ
		eststo: regress eval i.incon_acc4##c.pid1
		esttab using Study1_mod.rtf, onecell label ar2 se star(+ 0.10 * 0.05 ** 0.01) nobaselevels
	*study 2
		eststo clear
		eststo: regress eval i.condition1##c.educ1 i.cond_party
		eststo: regress eval i.condition1##c.pid i.cond_party
		eststo: regress eval i.condition1##c.ideology_gen  i.cond_party
		eststo: regress eval i.condition1##c.age i.cond_party
		esttab using Study2_mod.rtf, onecell label ar2 se star(+ 0.10 * 0.05 ** 0.01) nobaselevels
		eststo clear
		
