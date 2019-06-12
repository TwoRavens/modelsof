****CREATE FIGURES 2-4, 8-11****

/* set data directory */
global filepath "DIRECTORY MASKED"

*LOAD DATA WITH OUTCOME VARIABLE VALUES SUMMARIZED BY VOTE SHARE BIN*
clear
use "$filepath\rd_graph_ln_diff_wages.dta"
sort bin_cpu_share 
gen ln_diff_wage_pre_coarse = .
gen N_pre_coarse = .
order bin_cpu_share ln_diff_wage_pre_coarse N_pre_coarse
gen ln_diff_wage_coarse=.
gen N_coarse=.
order bin_cpu_share ln_diff_wage_pre_coarse N_pre_coarse ln_diff_wage_coarse N_coarse
ren N_coarse ln_diff_wage_coarse_
ren ln_diff_wage_coarse N_coarse
save "$filepath\rd_graph_ln_diff_wages.dta", replace
clear
use "$filepath\rd_graph_ln_diff_wages.dta"

*COMPENSATION

**CALCULATE STANDARD ERROR VALUES BY BIN
*by vote share

**POST-ELECTION
gen sd_mne_main = 0
order avg_diff_wage_share N_share sd_mne_main
replace sd = 0.0904122 if bin_share==1
replace sd = 0.199449 if bin_share==2
replace sd = 0.1017265 if bin_share==3
replace sd = 0.2029051 if bin_share==4
replace sd = 0.1892081 if bin_share==5
replace sd = 0.3142093 if bin_share==6
replace sd = 0.2499597 if bin_share==7
replace sd = 0.2782405 if bin_share==8
replace sd = 0.2596994 if bin_share==9
replace sd = 0.2044717 if bin_share==10
replace sd = 0.277072 if bin_share==11
replace sd = 0.2542455 if bin_share==12
replace sd = 0.1815319 if bin_share==13
replace sd = 0.2977264 if bin_share==14
replace sd = 0.2242148 if bin_share==15
replace sd = 0.3412348 if bin_share==16
replace sd = 0.2339017 if bin_share==17
replace sd = 0.1120207 if bin_share==18
replace sd = 0.1668897 if bin_share==19
replace sd = 0.1502056 if bin_share==20
gen se_main = sd/sqrt(N_share)
**PRE-ELECTION
gen sd_mne_pre = 0
replace sd_mne_pre = 0.1680765 if bin_share==1
replace sd_mne_pre = 0.0406416 if bin_share==2
replace sd_mne_pre = 0.1353066 if bin_share==3
replace sd_mne_pre = 0.2323046 if bin_share==4
replace sd_mne_pre = 0.157447 if bin_share==5
replace sd_mne_pre = 0.2360255 if bin_share==6
replace sd_mne_pre = 0.1347588 if bin_share==7
replace sd_mne_pre = 0.1327165 if bin_share==8
replace sd_mne_pre = 0.1669221 if bin_share==9
replace sd_mne_pre = 0.1748039 if bin_share==10
replace sd_mne_pre = 0.1435277 if bin_share==11
replace sd_mne_pre = 0.1389743 if bin_share==12
replace sd_mne_pre = 0.1271522 if bin_share==13
replace sd_mne_pre = 0.1516448 if bin_share==14
replace sd_mne_pre = 0.2715666 if bin_share==15
replace sd_mne_pre = 0.1324984 if bin_share==16
replace sd_mne_pre = 0.1607354 if bin_share==17
replace sd_mne_pre = 0.1067178 if bin_share==18
replace sd_mne_pre = 0.1076533 if bin_share==19
replace sd_mne_pre = 0.1721561 if bin_share==20
gen se_mne_pre = sd_mne_pre/sqrt(N_share_pre)

** CREATE FIGURE 3(A) (CHANGES IN LOG COMPENSATION BY VOTE SHARE)
serrbar ln_diff_wage_pre se_mne_pre union_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title("Pre-election") ylabel(-.3(.1).4) name(pre_wage_mne, replace) nodraw
serrbar avg_diff_wage_share se_main union_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title("Post-election") ylabel(-.3(.1).4) name(post_wage_mne, replace) nodraw
graph combine pre_wage_mne post_wage_mne, cols(2) title(Change in Average Employee Compensation) subtitle(Multinational Enterprise Sample) 

**CALCULATE SEs FOR PRE-ELECTION COMPENSATION
gen sd_pre_comp = 0
replace sd_pre_comp = 0.270647 if bin_share==1
replace sd_pre_comp = 0.2698949 if bin_share==2
replace sd_pre_comp = 0.5061928 if bin_share==3
replace sd_pre_comp = 0.4866183 if bin_share==4
replace sd_pre_comp = 0.4286143 if bin_share==5
replace sd_pre_comp = 0.4454278 if bin_share==6
replace sd_pre_comp = 0.4562372 if bin_share==7
replace sd_pre_comp = 0.4404024 if bin_share==8
replace sd_pre_comp = 0.4133885 if bin_share==9
replace sd_pre_comp = 0.3742397 if bin_share==10
replace sd_pre_comp = 0.4393053 if bin_share==11
replace sd_pre_comp = 0.4096412 if bin_share==12
replace sd_pre_comp = 0.403662 if bin_share==13
replace sd_pre_comp = 0.3309757 if bin_share==14
replace sd_pre_comp = 0.5263626 if bin_share==15
replace sd_pre_comp = 0.4945489 if bin_share==16
replace sd_pre_comp = 0.634835 if bin_share==17
replace sd_pre_comp = 0.355439 if bin_share==18
replace sd_pre_comp = 0.6157909 if bin_share==19
replace sd_pre_comp = 0.7836795 if bin_share==20
gen se_pre_comp = sd_pre_comp/sqrt(n_pre_ln_wage)

** CREATE FIGURE 10 (PRE-ELECTION AVERAGE EMPLOYEE COMPENSATION)
serrbar pre_ln_wage_def se_pre_comp union_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title(Pre-Election Average Employee Compensation) subtitle(Multinational Enterprise Sample) 

**CALCULATE SEs FOR PRE-ELECTION EMPLOYMENT
gen sd_pre_emp = 0
replace sd_pre_emp =  1.876209 if bin_share==1
replace sd_pre_emp = .2586421 if bin_share==2
replace sd_pre_emp =  1.579936  if bin_share==3
replace sd_pre_emp = 1.505476 if bin_share==4
replace sd_pre_emp =  1.611703 if bin_share==5
replace sd_pre_emp =  1.622971 if bin_share==6
replace sd_pre_emp = 1.373463 if bin_share==7
replace sd_pre_emp = 1.651243 if bin_share==8
replace sd_pre_emp =  1.600604 if bin_share==9
replace sd_pre_emp = 1.688012 if bin_share==10
replace sd_pre_emp = 1.590323 if bin_share==11
replace sd_pre_emp = 1.4845 if bin_share==12
replace sd_pre_emp =  1.824164 if bin_share==13
replace sd_pre_emp = 1.833684 if bin_share==14
replace sd_pre_emp = 1.404421 if bin_share==15
replace sd_pre_emp =  1.915142 if bin_share==16
replace sd_pre_emp = 1.714313 if bin_share==17
replace sd_pre_emp =  1.402336  if bin_share==18
replace sd_pre_emp = 2.712462 if bin_share==19
replace sd_pre_emp = 2.244844 if bin_share==20
gen se_pre_emp = sd_pre_emp/sqrt(n_pre_ln_emp)
** CREATE FIGURE 8 (PRE-ELECTION AVERAGE EMPLOYMENT)
serrbar pre_ln_emp se_pre_emp union_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title(Pre-Election Employment) subtitle(Multinational Enterprise Sample) 

**CALCULATE STANDARD ERROR VALUES BY BIN
*by votes margin
**POST-ELECTION
gen sd_vote = 0
order avg_diff_wage_share N_share sd_mne_main
replace sd_vote = 0.1767472 if margin_of_victory==-10
replace sd_vote = 0.1971458 if margin_of_victory==-9
replace sd_vote = 0.176001 if margin_of_victory==-8
replace sd_vote = 0.1149121 if margin_of_victory==-7
replace sd_vote = 0.2709167 if margin_of_victory==-6
replace sd_vote = 0.1938266 if margin_of_victory==-5
replace sd_vote = 0.12465 if margin_of_victory==-4
replace sd_vote = 0.0826757 if margin_of_victory==-3
replace sd_vote = 0.1686183 if margin_of_victory==-2
replace sd_vote = 0.1653755 if margin_of_victory==-1
replace sd_vote = 0.2030878 if margin_of_victory==0
replace sd_vote = 0.1088233 if margin_of_victory==1
replace sd_vote = 0.260194 if margin_of_victory==2
replace sd_vote = 0.2947176 if margin_of_victory==3
replace sd_vote = 0.2033902 if margin_of_victory==4
replace sd_vote = 0.2815378 if margin_of_victory==5
replace sd_vote = 0.1335967 if margin_of_victory==6
replace sd_vote = 0.3204973 if margin_of_victory==7
replace sd_vote = 0.1185205  if margin_of_victory==8
replace sd_vote = 0.059658 if margin_of_victory==9
replace sd_vote = 0.1518341 if margin_of_victory==10
gen se_vote = sd_vote/sqrt(N_votes)
*PRE-ELECTION
gen sd_mne_pre_vote = 0
replace sd_mne_pre_vote = 0.1125033 if margin_of_victory==-10
replace sd_mne_pre_vote = 0.0979611 if margin_of_victory==-9
replace sd_mne_pre_vote = 0.176001 if margin_of_victory==-8
replace sd_mne_pre_vote = 0.0861236 if margin_of_victory==-7
replace sd_mne_pre_vote = 0.1491067 if margin_of_victory==-6
replace sd_mne_pre_vote = 0.1487062 if margin_of_victory==-5
replace sd_mne_pre_vote = 0.158827 if margin_of_victory==-4
replace sd_mne_pre_vote = 0.1505431 if margin_of_victory==-3
replace sd_mne_pre_vote = 0.0650029 if margin_of_victory==-2
replace sd_mne_pre_vote = 0.1212935 if margin_of_victory==-1
replace sd_mne_pre_vote = 0.1802935 if margin_of_victory==0
replace sd_mne_pre_vote = 0.1119157 if margin_of_victory==1
replace sd_mne_pre_vote = 0.0712841 if margin_of_victory==2
replace sd_mne_pre_vote = 0.0923117 if margin_of_victory==3
replace sd_mne_pre_vote = 0.0831116 if margin_of_victory==4
replace sd_mne_pre_vote = 0.0779742 if margin_of_victory==5
replace sd_mne_pre_vote = 0.0943768 if margin_of_victory==6
replace sd_mne_pre_vote = 0.0928432 if margin_of_victory==7
replace sd_mne_pre_vote = 0.0745429  if margin_of_victory==8
replace sd_mne_pre_vote = 0.2665287 if margin_of_victory==9
replace sd_mne_pre_vote = 0.1982978 if margin_of_victory==10
gen se_pre_vote = sd_mne_pre_vote/sqrt(N_votes_pre)

*CREATE FIGURE 4(A) (CHANGE IN AVERAGE LOG COMPENSATION, BY VOTE TALLY)
serrbar avg_diff_wage_pre_votes se_pre_vote margin_of if abs(margin_of)<=10, xlabel(-10(5)10) scale(1.96) xline(0) ytitle("") xtitle("union votes margin", height(5)) title("Pre-election") ylabel(-.2(.1).3) name(pre_wage_mne_vote, replace)
serrbar avg_diff_wage_votes se_vote margin_of if abs(margin_of)<=10, xlabel(-10(5)10) scale(1.96) xline(0) ytitle("") xtitle("union votes margin", height(5)) title("Post-election") ylabel(-.2(.1).3) name(post_wage_mne_vote, replace)
graph combine pre_wage_mne_vote post_wage_mne_vote, cols(2) title(Change in Average Employee Compensation) subtitle(Multinational Enterprise Sample)

**COMPUSTAT DATA
*COMPENSATION

**CALCULATE STANDARD ERROR VALUES BY BIN
*by vote share

**POST-ELECTION
gen sd_cpu_share_pre = 0
order avg_diff_wage_share N_share sd_mne_main
replace sd_cpu_share = 0.1355893 if bin_cpu_share==1
replace sd_cpu_share = 0.1203974 if bin_cpu_share==2
replace sd_cpu_share = 0.1089546 if bin_cpu_share==3
replace sd_cpu_share = 0.1074782 if bin_cpu_share==4
replace sd_cpu_share = 0.1268779 if bin_cpu_share==5
replace sd_cpu_share = 0.3722478 if bin_cpu_share==6
replace sd_cpu_share = 0.2782478 if bin_cpu_share==7
replace sd_cpu_share = 0.1688532 if bin_cpu_share==8
replace sd_cpu_share = 0.107248 if bin_cpu_share==9
replace sd_cpu_share = 0.1175863 if bin_cpu_share==10
gen se_cpu_share = sd_cpu_share/sqrt(N_cpu_share)

*pre
gen sd_cpu_share_pre = 0
replace sd_cpu_share_pre = 0.0636542 if bin_cpu_share==1
replace sd_cpu_share_pre = 0.0804828 if bin_cpu_share==2
replace sd_cpu_share_pre = 0.067044 if bin_cpu_share==3
replace sd_cpu_share_pre = 0.0940574 if bin_cpu_share==4
replace sd_cpu_share_pre = 0.126453 if bin_cpu_share==5
replace sd_cpu_share_pre = 0.0931484 if bin_cpu_share==6
replace sd_cpu_share_pre = 0.068842 if bin_cpu_share==7
replace sd_cpu_share_pre = 0.097943 if bin_cpu_share==8
replace sd_cpu_share_pre = 0.0458143 if bin_cpu_share==9
replace sd_cpu_share_pre = 0.0933742 if bin_cpu_share==10
gen se_cpu_share_pre = sd_cpu_share_pre/sqrt(N_cpu_pre_share)

*CREATE GRAPH 3 (B) (CHANGES IN LOG COMPENSATION BY VOTE SHARE)
serrbar ln_diff_wage_cpu_pre_share se_cpu_share_pre u_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title("Pre-election") ylabel(-.2(.1).2) name(pre_wage_cpu, replace) 
serrbar ln_diff_wage_cpu_share se_cpu_share u_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title("Post-election") name(post_wage_cpu, replace)
graph combine pre_wage_cpu post_wage_cpu, cols(2) title(Change in Average Employee Compensation) subtitle(Compustat Sample)

**CALCULATE STANDARD ERROR VALUES BY BIN
*by votes margin

*PRE-ELECTION
gen sd_cpu_votes_pre = 0
replace sd_cpu_votes_pre = 0.0302151 if margin_cpu==-40
replace sd_cpu_votes_pre = 0.058535 if margin_cpu==-30
replace sd_cpu_votes_pre = 0.1180993  if margin_cpu==-20
replace sd_cpu_votes_pre = 0.1546525 if margin_cpu==-10
replace sd_cpu_votes_pre = 0.0749318 if margin_cpu==0
replace sd_cpu_votes_pre = 0.0906419 if margin_cpu==10
replace sd_cpu_votes_pre = 0.0918896 if margin_cpu==20
replace sd_cpu_votes_pre = 0.07505 if margin_cpu==30
replace sd_cpu_votes_pre = 0.0483729 if margin_cpu==40
gen se_cpu_votes_pre = sd_cpu_votes_pre/sqrt(N_cpu_pre_vote)

*POST-ELECTION
gen sd_cpu_votes = 0
replace sd_cpu_votes = 0.1014699 if margin_cpu==-40
replace sd_cpu_votes = 0.1314563 if margin_cpu==-30
replace sd_cpu_votes = 0.1517985  if margin_cpu==-20
replace sd_cpu_votes = 0.0973639 if margin_cpu==-10
replace sd_cpu_votes = 0.0753813 if margin_cpu==0
replace sd_cpu_votes = 0.3550701 if margin_cpu==10
replace sd_cpu_votes = 0.1973596 if margin_cpu==20
replace sd_cpu_votes = 0.4380576 if margin_cpu==30
replace sd_cpu_votes = 0.0872284 if margin_cpu==40
gen se_cpu_votes = sd_cpu_votes/sqrt(N_cpu_vote)

*CREATE FIGURE 4(B) (CHANGE IN AVERAGE LOG COMPENSATION, BY VOTE TALLY)
serrbar ln_diff_wage_pre_cpu_vote se_cpu_votes_pre margin_cpu, scale(1.96) xline(0) ytitle("") xtitle("union votes margin", height(5)) title("Pre-election") ylabel(-.2(.1).7) name(pre_wage_cpu_vote, replace) 
serrbar ln_diff_wage_cpu_vote se_cpu_votes margin_cpu, scale(1.96) xline(0) ytitle("") xtitle("union votes margin", height(5)) title("Post-election") ylabel(-.2(.1).7) name(post_wage_cpu_vote, replace)
graph combine pre_wage_cpu_vote post_wage_cpu_vote, cols(2) title(Change in Average Employee Compensation) subtitle(Compustat Sample)

**CALCULATE SEs FOR PRE-ELECTION COMPENSATION
gen sd_pre_cpu_wage = 0
replace sd_pre_cpu_wage = 0.1995199 if bin_cpu_share==1
replace sd_pre_cpu_wage = 0.5394824 if bin_cpu_share==2
replace sd_pre_cpu_wage = 0.304487 if bin_cpu_share==3
replace sd_pre_cpu_wage = 0.331158 if bin_cpu_share==4
replace sd_pre_cpu_wage = 0.4100721 if bin_cpu_share==5
replace sd_pre_cpu_wage = 0.2679419 if bin_cpu_share==6
replace sd_pre_cpu_wage = 0.4266025 if bin_cpu_share==7
replace sd_pre_cpu_wage = 0.328451  if bin_cpu_share==8
replace sd_pre_cpu_wage = 0.2518597 if bin_cpu_share==9
replace sd_pre_cpu_wage = 0.4529285 if bin_cpu_share==10
gen se_pre_cpu_wage = sd_pre_cpu_wage/sqrt(n_pre_wagecpu)

** CREATE FIGURE 11 (PRE-ELECTION AVERAGE EMPLOYEE COMPENSATION)
serrbar pre_ln_wage_cpu se_pre_cpu_wage u_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title(Pre-Election Average Employee Compensation) subtitle(Compustat Sample) 

**CALCULATE SEs FOR PRE-ELECTION EMPLOYMENT
gen sd_pre_cpu_emp = 0
replace sd_pre_cpu_emp =  2.075392 if bin_cpu_share==1
replace sd_pre_cpu_emp =  1.794638 if bin_cpu_share==2
replace sd_pre_cpu_emp =  1.926287 if bin_cpu_share==3
replace sd_pre_cpu_emp = 1.729125  if bin_cpu_share==4
replace sd_pre_cpu_emp =  1.912722  if bin_cpu_share==5
replace sd_pre_cpu_emp =   1.931081 if bin_cpu_share==6
replace sd_pre_cpu_emp = 1.577822 if bin_cpu_share==7
replace sd_pre_cpu_emp = 1.679479 if bin_cpu_share==8
replace sd_pre_cpu_emp =  1.933693 if bin_cpu_share==9
replace sd_pre_cpu_emp = 2.125981 if bin_cpu_share==10
gen se_pre_cpu_emp = sd_pre_cpu_emp/sqrt(n_pre_ln_emp_cpu)

** CREATE FIGURE 9 (PRE-ELECTION AVERAGE EMPLOYMENT)
serrbar pre_ln_emp_cpu se_pre_cpu_emp u_vote_share, scale(1.96) xline(.5) ytitle("") xtitle("union vote share", height(5)) title(Pre-Election Employment) subtitle(Compustat Sample)  

**************LINE GRAPHS
*CREATE FIGURE 2(A) (AVERAGE EMPLOYEE COMPENSATION, ELECTIONS DECIDED BY <= 20%)
twoway connected wage_winners_mne_20d wage_losers_mne_20d t_, xlabel(-5(1)5) xline(0, lcolor(black) lpattern(dash))  title(Average Employee Compensation over Time) ytitle("log (compensation)", height(5)) xtitle("years since union election", height(5)) legend(label(1 "close union winners") label(2 "close union losers")) subtitle(Multinational Enterprise Sample (elections decided by 20% or less)) ylabel(3.7(.1)4.1)

*CREATE FIGURE 2(B) (AVERAGE EMPLOYEE COMPENSATION, ELECTIONS DECIDED BY <= 20%)
twoway connected wage_winners_mne15 wage_losers_mne15 t_, xlabel(-5(1)5) xline(0, lcolor(black) lpattern(dash)) title(Average Employee Compensation over Time) ytitle("log (compensation)", height(5)) xtitle("years since union election", height(5)) legend(label(1 "close union winners") label(2 "close union losers")) subtitle(Multinational Enterprise Sample (elections decided by 15% or less)) ylabel(3.7(.1)4.1)

