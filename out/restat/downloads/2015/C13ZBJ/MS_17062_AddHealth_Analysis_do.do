clear all
***A directory must be assigned

cd "Add_health_files_directory" 
* Tables are created using addhealth_data. 
use addhealth_data, clear

*Table 1
outsum violenttp_ly shk_prtn_ly injrdprtnr_ly  trusted_prtnr1_2 prnt_lstnd1_2 ina_rlsnshp	mil_combat combat_ff combat_noff killed wounded saw_aco_killed  PTSD chn_strss_scl   suicd_thgth  binge any_drug30days  mil_army mil_mcorps mil_navy mil_airf  DS_RR1-DS_RR6 ageiny rwhite rblack rother hispanic educ_scv C4VAR039 using T1addhealth, replace	title(Table_1. Key variables) ctitle(All)




*Appendix Table 1
outsum wave1_sff_12m  abuse_phy  H1RR1_dum2 w1_heightinch w1_weight   rel_protestan rel_catholic rel_ochris rel_other  ageiny ageiny2  rblack rother hispanic  educ_scv C4VAR039   no_hlthins ppvt_w1  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7 				       parent_married parent_divsepwid				        momedhs moedmabovehs    				 sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up  if mil_combat==1					using Appendix_1_AddHealth, replace	title(Table_1. Key variables) ctitle(CS=1)
outsum wave1_sff_12m  abuse_phy  H1RR1_dum2 w1_heightinch w1_weight   rel_protestan rel_catholic rel_ochris rel_other  ageiny ageiny2  rblack rother hispanic  educ_scv C4VAR039   no_hlthins ppvt_w1  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7 				       parent_married parent_divsepwid				        momedhs moedmabovehs    				 sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up  if mil_combat==0 	using Appendix_1_AddHealth, append ctitle(CS=0)

outsum wave1_sff_12m  abuse_phy  H1RR1_dum2 w1_heightinch w1_weight   rel_protestan rel_catholic rel_ochris rel_other  ageiny ageiny2  rblack rother hispanic  educ_scv C4VAR039   no_hlthins ppvt_w1  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7 				       parent_married parent_divsepwid				        momedhs moedmabovehs    				 sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up  if combat_ff==1		using Appendix_1_AddHealth, append ctitle(CE=1)
outsum wave1_sff_12m  abuse_phy  H1RR1_dum2 w1_heightinch w1_weight   rel_protestan rel_catholic rel_ochris rel_other  ageiny ageiny2  rblack rother hispanic  educ_scv C4VAR039   no_hlthins ppvt_w1  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7 				       parent_married parent_divsepwid				        momedhs moedmabovehs    				 sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up  if combat_ff==0		using Appendix_1_AddHealth, append ctitle(CE=0)

outsum wave1_sff_12m  abuse_phy  H1RR1_dum2 w1_heightinch w1_weight   rel_protestan rel_catholic rel_ochris rel_other  ageiny ageiny2  rblack rother hispanic  educ_scv C4VAR039   no_hlthins ppvt_w1  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7 				       parent_married parent_divsepwid				        momedhs moedmabovehs    				 sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up  if combat_ff==0	& mil_combat==1 using Appendix_1_AddHealth, append ctitle(CS=1 & CE=0)

*** Accounting for missing observations on control variables in regression estimates. 
replace wave1_sff_12m=0 if wave1_sff_12m==.
replace abuse_phy=0 if abuse_phy==.
replace H1RR1_dum2=0 if H1RR1_dum3==1

replace w1_heightinch=0 if w1_heightinch==.
replace w1_weight=0 if w1_weight==.

replace rel_norel=0 if mis_rel==1
replace rel_protestan=0 if mis_rel==1
replace rel_catholic=0 if mis_rel==1
replace rel_ochris=0 if mis_rel==1
replace rel_other=0 if mis_rel==1

replace rblack=0 if mis_race==1
replace rother=0 if mis_race==1
replace hispanic=0 if mis_hispanic==1

replace no_hlthins=0 if mis_no_hlthins==1

replace ppvt_w1=0 if mis_ppvt_w1==1

replace pictgry2=0 if pictgry2==. 
replace pictgry3=0 if pictgry3==. 
replace pictgry4=0 if pictgry4==. 
replace pictgry5=0 if pictgry5==. 
replace pictgry6=0 if pictgry6==. 
replace pictgry7=0 if pictgry7==. 


replace parent_married=0   if mis_parent_marital==1
replace parent_divsepwid=0 if mis_parent_marital==1

replace abuse_phy=0 if abuse_phy==.


replace momedhs=0 if momedhs==.
replace moedmabovehs=0 if moedmabovehs==.

replace sibling1=0 if sibling1==.
replace sibling2=0 if sibling2==.
replace sibling3=0 if sibling3==.
replace sibling4=0 if sibling4==.
replace sibling5up=0 if sibling5==.




global mltry_controls2 " mil_current mil_mnths2 mil_mnths3 mil_mnths4 rr2 rr3 rr4 rr5 rr6 rr7 rr8 rr9 mil_army mil_navy mil_airf mil_mcorps mil_nguard mil_onlyafter9_11 $acc_dummies" 

global controls_Table2     	"w1_heightinch mis_w1_heightinch w1_weight  mis_w1_weight rel_protestan rel_catholic rel_ochris rel_other mis_rel	 ageiny ageiny2  rblack rother hispanic mis_race mis_hispanic educ_scv C4VAR039  mis_educ no_hlthins mis_no_hlthins  ppvt_w1 mis_ppvt_w1 pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7   mis_parent_income parent_married parent_divsepwid  mis_parent_marital	momedhs moedmabovehs  mis_momeducaction mis_numberofsiblings sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up"
global test_controls_Table2   "w1_heightinch					 w1_weight    			  rel_protestan rel_catholic rel_ochris rel_other			 ageiny ageiny2  rblack rother hispanic			 			  educ_scv C4VAR039   		  no_hlthins				 ppvt_w1 			 pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7 				       parent_married parent_divsepwid				        momedhs moedmabovehs    									  sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up"



*******ESTIMATING COMBAT SERVICE ON OBSERVABLES************
reg mil_combat  wave1_sff_12m mis_wave1_sff_12m abuse_phy mis_abuse_phy H1RR1_dum2 H1RR1_dum3	$controls_Table2 $mltry_controls2,   robust cluster(SCID) 
test $test_controls_Table2
	sca ftest1=r(F)
	sca pval1=r(p )
test  parent_married parent_divsepwid  
	sca ftest2=r(F)
	sca pval2=r(p )
test momedhs moedmabovehs
	sca ftest3=r(F)
	sca pval3=r(p )
test rblack rother hispanic    
	sca ftest5=r(F)
	sca pval5=r(p )
test educ_scv C4VAR039
	sca ftest6=r(F)
	sca pval6=r(p )
test rel_protestan rel_catholic rel_ochris rel_other
	sca ftest7=r(F)
	sca pval7=r(p )
test  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7
	sca ftest8=r(F)
	sca pval8=r(p )	
test  sibling1 sibling2 sibling3 sibling4 sibling5up	
	sca ftest9=r(F)
	sca pval9=r(p )	
test  c1to2 c3up		
	sca ftest10=r(F)
	sca pval10=r(p )	
outreg2 using T2, keep(wave1_sff_12m   abuse_phy	H1RR1_dum2	$test_controls_Table2) addstat("F-test all", ftest1,"F-test all pva",pval1, "F-test prnt mrtal", ftest2,"F-test prnt mrtal pval",pval2, "F-test momed", ftest3,"F-test momed pval",pval3,  "F-test race", ftest5,"F-test race pval",pval5, "F-test educ", ftest6,"F-test educ pval",pval6, "F-test religion", ftest7,"F-test religion pval",pval7, "F-test prnt income", ftest8,"F-test prnt income pval",pval8, "F-test siblings", ftest9,"F-test siblings pval",pval9, "F-test children", ftest10,"F-test children pval",pval10) word excel label nocons  bdec(3) sdec(3) title(Table 2) ctitle(Combat - FS) replace 



reg combat_ff  wave1_sff_12m mis_wave1_sff_12m abuse_phy mis_abuse_phy  H1RR1_dum2 H1RR1_dum3	$controls_Table2 $mltry_controls2,   robust cluster(SCID) 
test $test_controls_Table2
	sca ftest1=r(F)
	sca pval1=r(p )
test  parent_married parent_divsepwid  
	sca ftest2=r(F)
	sca pval2=r(p )
test  momedhs moedmabovehs
	sca ftest3=r(F)
	sca pval3=r(p )
test rblack rother hispanic    
	sca ftest5=r(F)
	sca pval5=r(p )
test educ_scv C4VAR039
	sca ftest6=r(F)
	sca pval6=r(p )
test rel_protestan rel_catholic rel_ochris rel_other
	sca ftest7=r(F)
	sca pval7=r(p )
test  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7
	sca ftest8=r(F)
	sca pval8=r(p )	
test  sibling1 sibling2 sibling3 sibling4 sibling5up	
	sca ftest9=r(F)
	sca pval9=r(p )	
test  c1to2 c3up		
	sca ftest10=r(F)
	sca pval10=r(p )	
outreg2 using T2,keep(wave1_sff_12m   abuse_phy	H1RR1_dum2	$test_controls_Table2 ) addstat("F-test all", ftest1,"F-test all pva",pval1, "F-test prnt mrtal", ftest2,"F-test prnt mrtal pval",pval2, "F-test momed", ftest3,"F-test momed pval",pval3,  "F-test race", ftest5,"F-test race pval",pval5, "F-test educ", ftest6,"F-test educ pval",pval6, "F-test religion", ftest7,"F-test religion pval",pval7, "F-test prnt income", ftest8,"F-test prnt income pval",pval8, "F-test siblings", ftest9,"F-test siblings pval",pval9, "F-test children", ftest10,"F-test children pval",pval10) word excel label nocons  bdec(3) sdec(3) ctitle(Combat FF - FS) append 
 

reg combat_ff wave1_sff_12m mis_wave1_sff_12m abuse_phy mis_abuse_phy  H1RR1_dum2 H1RR1_dum3	$controls_Table2 $mltry_controls2  if mil_combat==1,   robust cluster(SCID) 
test $test_controls_Table2
	sca ftest1=r(F)
	sca pval1=r(p )
test  parent_married parent_divsepwid  
	sca ftest2=r(F)
	sca pval2=r(p )
test  momedhs moedmabovehs
	sca ftest3=r(F)
	sca pval3=r(p )
test rblack rother hispanic    
	sca ftest5=r(F)
	sca pval5=r(p )
test educ_scv C4VAR039
	sca ftest6=r(F)
	sca pval6=r(p )
test rel_protestan rel_catholic rel_ochris rel_other
	sca ftest7=r(F)
	sca pval7=r(p )
test  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7
	sca ftest8=r(F)
	sca pval8=r(p )	
test  sibling1 sibling2 sibling3 sibling4 sibling5up	
	sca ftest9=r(F)
	sca pval9=r(p )	
test  c1to2 c3up		
	sca ftest10=r(F)
	sca pval10=r(p )	
outreg2	using T2, keep(wave1_sff_12m   abuse_phy	H1RR1_dum2	$test_controls_Table2) addstat("F-test all", ftest1,"F-test all pva",pval1, "F-test prnt mrtal", ftest2,"F-test prnt mrtal pval",pval2, "F-test momed", ftest3,"F-test momed pval",pval3,  "F-test race", ftest5,"F-test race pval",pval5, "F-test educ", ftest6,"F-test educ pval",pval6, "F-test religion", ftest7,"F-test religion pval",pval7, "F-test prnt income", ftest8,"F-test prnt income pval",pval8, "F-test siblings", ftest9,"F-test siblings pval",pval9, "F-test children", ftest10,"F-test children pval",pval10) word excel label nocons  bdec(3) sdec(3) ctitle(Combat FF - CS) append 

reg combat_ff  wave1_sff_12m mis_wave1_sff_12m  abuse_phy mis_abuse_phy  H1RR1_dum2 H1RR1_dum3	$controls_Table2  $mltry_controls2 if combat_noff==0,   robust cluster(SCID)  
test $test_controls_Table2
	sca ftest1=r(F)
	sca pval1=r(p )
test  parent_married parent_divsepwid  
	sca ftest2=r(F)
	sca pval2=r(p )
test  momedhs moedmabovehs
	sca ftest3=r(F)
	sca pval3=r(p )
test rblack rother hispanic    
	sca ftest5=r(F)
	sca pval5=r(p )
test educ_scv C4VAR039
	sca ftest6=r(F)
	sca pval6=r(p )
test rel_protestan rel_catholic rel_ochris rel_other
	sca ftest7=r(F)
	sca pval7=r(p )
test  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7
	sca ftest8=r(F)
	sca pval8=r(p )	
test  sibling1 sibling2 sibling3 sibling4 sibling5up	
	sca ftest9=r(F)
	sca pval9=r(p )	
test  c1to2 c3up		
	sca ftest10=r(F)
	sca pval10=r(p )	
outreg2  		using T2,keep(wave1_sff_12m   abuse_phy	H1RR1_dum2	$test_controls_Table2) addstat("F-test all", ftest1,"F-test all pva",pval1, "F-test prnt mrtal", ftest2,"F-test prnt mrtal pval",pval2, "F-test momed", ftest3,"F-test momed pval",pval3,  "F-test race", ftest5,"F-test race pval",pval5, "F-test educ", ftest6,"F-test educ pval",pval6, "F-test religion", ftest7,"F-test religion pval",pval7, "F-test prnt income", ftest8,"F-test prnt income pval",pval8, "F-test siblings", ftest9,"F-test siblings pval",pval9, "F-test children", ftest10,"F-test children pval",pval10) word excel label nocons  bdec(3) sdec(3) ctitle(Combat FF - FF + NC sample) append 










global military_controls  " mil_current mil_mnths2 mil_mnths3 mil_mnths4 rr2 rr3 rr4 rr5 rr6 rr7 rr8 rr9 mil_army mil_navy mil_airf mil_mcorps mil_nguard mil_onlyafter9_11 $acc_dummies" 
global non_military_controls        "w1_heightinch mis_w1_heightinch w1_weight  mis_w1_weight  rel_protestan rel_catholic rel_ochris rel_other mis_rel	male ageiny ageiny2  rblack rother hispanic mis_race mis_hispanic educ_scv C4VAR039  no_hlthins mis_no_hlthins  ppvt_w1  mis_ppvt_w1  pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7   mis_parent_income parent_married parent_divsepwid  mis_parent_marital	momedhs moedmabovehs  mis_momeducaction mis_numberofsiblings sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up"
global output "mil_combat combat_ff combat_noff"


* Table 3 
reg violenttp_ly mil_combat			$military_controls ,   robust cluster(SCID) 
outreg2	using T3A_row1, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) title(Table T3A_row1: Combat vs. Non-combat Full Sample Military Controls Only)  replace 
reg shk_prtn_ly mil_combat			$military_controls ,   robust cluster(SCID) 
outreg2  using T3A_row1, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(slphitkickprtnr) append 
reg injrdprtnr_ly mil_combat				$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row1, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(injuredprtnr) append 
reg trusted_prtnr1_2 mil_combat				$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row1, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg prnt_lstnd1_2 mil_combat				$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row1, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 

reg violenttp_ly mil_combat		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row2, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) title(Table T3A_row2: Combat vs. Non-combat Full Sample Military Controls Only + Non Military )  replace 
reg shk_prtn_ly mil_combat		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row2, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(slphitkickprtnr) append 
reg injrdprtnr_ly mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row2, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(injuredprtnr) append 
reg trusted_prtnr1_2 mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row2, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg prnt_lstnd1_2 mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row2, keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 


*** Adding pre-deployment firefight, physical maltreatment, and relationship status. 
global non_military_controls     "wave1_sff_12m mis_wave1_sff_12m  abuse_phy mis_abuse_phy H1RR1_dum2 H1RR1_dum3	 w1_heightinch mis_w1_heightinch w1_weight  mis_w1_weight  rel_protestan rel_catholic rel_ochris rel_other mis_rel	male ageiny ageiny2  rblack rother hispanic mis_race mis_hispanic educ_scv C4VAR039  mis_educ no_hlthins mis_no_hlthins  ppvt_w1 mis_ppvt_w1 pictgry2 pictgry3 pictgry4 pictgry5 pictgry6 pictgry7   mis_parent_income parent_married parent_divsepwid  mis_parent_marital	momedhs moedmabovehs  mis_momeducaction mis_numberofsiblings sibling1 sibling2 sibling3 sibling4 sibling5up c1to2 c3up"


reg violenttp_ly mil_combat		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row3,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(violenttp_ly) title(Table T3A_row3: Combat vs. Non-combat Full Sample Military Controls Only + Non Military + Lagged Violence )  replace 
reg shk_prtn_ly mil_combat		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row3,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(slphitkickprtnr) append 
reg injrdprtnr_ly mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row3,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(injuredprtnr) append 
reg trusted_prtnr1_2 mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row3,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg prnt_lstnd1_2 mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3A_row3,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 



reg violenttp_ly combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3B,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) title(Table T3B: Combat FF + Combat NoFF vs. Non-combat Full Sample Military Controls Only + Non Military + Lagged Violence )  replace 
reg shk_prtn_ly combat_ff combat_noff	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3B,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(slphitkickprtnr) append 
reg injrdprtnr_ly combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3B,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(injuredprtnr) append 
reg trusted_prtnr1_2 combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3B,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg prnt_lstnd1_2 combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T3B,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 



*Table 3C
reg violenttp_ly combat_ff combat_noff				$non_military_controls	$military_controls  if ina_rlsnshp==1,   robust cluster(SCID) 
outreg2 using T3C,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(violenttp_ly)  title(T3C: Combat vs. Non-combat Full Sample Military Controls Only + Non Military + Lagged Violence  in a relationship sample)  replace  
reg shk_prtn_ly combat_ff combat_noff				$non_military_controls	$military_controls  if ina_rlsnshp==1,   robust cluster(SCID) 
outreg2 using T3C,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(slphitkickprtnr) append 
reg injrdprtnr_ly combat_ff combat_noff			$non_military_controls	$military_controls  if ina_rlsnshp==1,   robust cluster(SCID) 
outreg2 using T3C,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(injuredprtnr) append 
reg trusted_prtnr1_2 combat_ff combat_noff			$non_military_controls	$military_controls  if ina_rlsnshp==1,   robust cluster(SCID) 
outreg2 using T3C,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg prnt_lstnd1_2 combat_ff combat_noff			$non_military_controls	$military_controls  if ina_rlsnshp==1,   robust cluster(SCID) 
outreg2 using T3C,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 


*Estimating
global controls_ols_like_DODHRB      "ageiny ageiny2 $r_race  educ_scv C4VAR039 mis_educ"
global mltry_controls_like_DODHRB  " mil_current mil_mnths2 mil_mnths3 mil_mnths4 rr2 rr3 rr4 rr5 rr6 rr7 rr8 rr9 mil_army mil_navy mil_airf mil_mcorps mil_nguard mil_onlyafter9_11 " 


reg violenttp_ly combat_ff combat_noff			$controls_ols_like_DODHRB	$mltry_controls_like_DODHRB,   robust cluster(SCID) 
sum violenttp_ly if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T3D,keep(combat_ff combat_noff) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) title(Table 3D. Effect of Combat Using DOD HRB Survey Controls)  replace 

reg shk_prtn_ly combat_ff combat_noff			$controls_ols_like_DODHRB	$mltry_controls_like_DODHRB,   robust cluster(SCID) 
sum shk_prtn_ly if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T3D,keep(combat_ff combat_noff) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(slphitkickprtnr) append 

reg injrdprtnr_ly combat_ff combat_noff		$controls_ols_like_DODHRB	$mltry_controls_like_DODHRB,   robust cluster(SCID) 
sum injrdprtnr_ly if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T3D,keep(combat_ff combat_noff) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(injuredprtnr) append 

reg trusted_prtnr1_2 combat_ff combat_noff		$controls_ols_like_DODHRB	$mltry_controls_like_DODHRB,   robust cluster(SCID) 
sum trusted_prtnr1_2 if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T3D,keep(combat_ff combat_noff) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 

reg prnt_lstnd1_2 combat_ff combat_noff		   $controls_ols_like_DODHRB	$mltry_controls_like_DODHRB,   robust cluster(SCID) 
sum prnt_lstnd1_2 if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T3D,keep(combat_ff combat_noff) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 





gen combat_not_killed=0 if killed~=.
replace combat_not_killed=1 if killed==0 & mil_combat==1


gen combat_not_wounded=0 if wounded~=.
replace combat_not_wounded=1 if wounded==0 & mil_combat==1


gen combat_not_saw_ac_k=0 if saw_aco_killed~=.
replace combat_not_saw_ac_k=1 if saw_aco_killed==0 & mil_combat==1

replace saw_aco_killed=0 if saw_aco_killed==. 
replace killed=0 if killed==. 
replace wounded=0 if wounded==. 



label var killed "Killed Someone"
label var wounded "Wounded or Injured"
label var saw_aco_killed "Witnessed Death of Ally" 

label var combat_not_killed "Combat No Killing"
label var combat_not_wounded "Combat No Wounding"
label var combat_not_saw_ac_k "Combat No Seeing Ally Dead" 


*Table 5
reg violenttp_ly killed			combat_not_killed		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row1,keep(killed combat_not_killed) word excel label nocons  bdec(3) sdec(3) ctitle(threat_ly) title(Table T5A_row1: Robustness with Alternatte Combat Measures)  replace 

reg injrdprtnr_ly killed			combat_not_killed		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row1,keep(killed combat_not_killed) word excel label nocons  bdec(3) sdec(3) ctitle(injrdprtnr_ly) append 

reg shk_prtn_ly killed			combat_not_killed		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row1,keep(killed combat_not_killed) word excel label nocons  bdec(3) sdec(3) ctitle(hit_ly) append 


reg trusted_prtnr1_2 killed		combat_not_killed			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row1,keep(killed combat_not_killed) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 

reg prnt_lstnd1_2 killed		combat_not_killed			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row1,keep(killed combat_not_killed) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 


reg violenttp_ly wounded		combat_not_wounded	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row2,keep(wounded combat_not_wounded) word excel label nocons  bdec(3) sdec(3) ctitle(threat_ly) title(Table T5A_row2: Robustness with wounded)  replace 

reg shk_prtn_ly wounded		combat_not_wounded	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row2,keep(wounded combat_not_wounded) word excel label nocons  bdec(3) sdec(3) ctitle(Hit_ly) append 

reg injrdprtnr_ly 	wounded		combat_not_wounded		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row2,keep(wounded combat_not_wounded) word excel label nocons  bdec(3) sdec(3) ctitle(injury_ly) append 

reg trusted_prtnr1_2 	wounded		combat_not_wounded		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row2,keep(wounded combat_not_wounded) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 

reg prnt_lstnd1_2 	wounded		combat_not_wounded		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T5A_row2,keep(wounded combat_not_wounded) word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 



reg violenttp_ly saw_aco_killed	combat_not_saw_ac_k	$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum violenttp_ly if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T5A_row3,keep(saw_aco_killed	combat_not_saw_ac_k)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(threat_ly) title(Table T5A_row3: Robustness with Saw Ally Killed)  replace 

reg shk_prtn_ly saw_aco_killed	combat_not_saw_ac_k	$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum shk_prtn_ly if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T5A_row3,keep(saw_aco_killed	combat_not_saw_ac_k)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Hit_ly) append 

reg injrdprtnr_ly saw_aco_killed	combat_not_saw_ac_k			$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum injrdprtnr_ly if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T5A_row3,keep(saw_aco_killed	combat_not_saw_ac_k)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(injury_ly) append 

reg trusted_prtnr1_2 saw_aco_killed	combat_not_saw_ac_k			$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum trusted_prtnr1_2 if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T5A_row3,keep(saw_aco_killed	combat_not_saw_ac_k)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 

reg prnt_lstnd1_2 saw_aco_killed	combat_not_saw_ac_k			$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum prnt_lstnd1_2 if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T5A_row3,keep(saw_aco_killed	combat_not_saw_ac_k)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(prnt_lstnd1_2) append 


* Table 7
reg PTSD combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum PTSD if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T7B,keep($output) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(ptsd) title(Table T7B: Estimates of mediators)  replace 
reg suicd_thgth combat_ff combat_noff 	$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum suicd_thgth if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T7B,keep($output) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(suicide) append 
reg chn_strss_scl combat_ff combat_noff 	$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum chn_strss_scl if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T7B,keep($output) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(stress) append 
reg binge combat_ff combat_noff 	$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum binge if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T7B,keep($output) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(binging) append 
reg any_drug30days combat_ff combat_noff 	$non_military_controls	$military_controls ,   robust cluster(SCID) 
sum any_drug30days if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T7B,keep($output) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(drugs) append 



gen mis_suicd_thgth=0
replace mis_suicd_thgth=1 if suicd_thgth==. 
replace suicd_thgth=0 if suicd_thgth==. 

gen mis_PTSD=0
replace mis_PTSD=1 if PTSD==. 
replace PTSD=0 if PTSD==. 

gen mis_chn_strss_scl=0
replace mis_chn_strss_scl =1 if chn_strss_scl ==. 
replace chn_strss_scl =0 if chn_strss_scl ==. 

gen mis_binge =0
replace mis_binge =1 if binge ==. 
replace binge =0 if binge ==. 

gen mis_any_drug30days=0
replace mis_any_drug30days =1 if any_drug30days ==. 
replace any_drug30days =0 if any_drug30days ==. 


*Table 8. 
reg violenttp_ly combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8C,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) title(Table T8C.violenttp_ly )  replace 
reg violenttp_ly combat_ff combat_noff	PTSD suicd_thgth chn_strss_scl 	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8C,keep(combat_ff combat_noff)word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) append 
reg violenttp_ly combat_ff combat_noff	binge any_drug30days	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8C,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) append 
reg violenttp_ly combat_ff combat_noff	PTSD suicd_thgth chn_strss_scl binge any_drug30days		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8C,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3) ctitle(violnttoprtnr) append 


reg trusted_prtnr1_2 combat_ff combat_noff		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8D,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) title(Table T8D.trusted_prtnr1_2 )  replace 
reg trusted_prtnr1_2 combat_ff combat_noff	PTSD suicd_thgth chn_strss_scl 	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8D,keep(combat_ff combat_noff)word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg trusted_prtnr1_2 combat_ff combat_noff	binge any_drug30days	$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8D,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 
reg trusted_prtnr1_2 combat_ff combat_noff	PTSD suicd_thgth chn_strss_scl binge any_drug30days		$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using T8D,keep(combat_ff combat_noff)word excel label nocons  bdec(3) sdec(3) ctitle(trusted_prtnr1_2) append 


**Appendix Table 2- 
reg ina_rlsnshp mil_combat			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using AT2A_addhealth,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(ina_rlsnshp) title(Appendix Table 2A: Estimates of Relationship Status) replace
reg ina_rlsnshp combat_ff combat_noff			$non_military_controls	$military_controls ,   robust cluster(SCID) 
outreg2 using AT2A_addhealth,keep($output) word excel label nocons  bdec(3) sdec(3) ctitle(ina_rlsnshp) append 


reg violenttp_ly combat_ff combat_noff	$non_military_controls	$military_controls if mil_current==1,   robust cluster(SCID) 
outreg2 using AT2B_addhealth,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3)    ctitle(current=1) title(Appendix Table 2- Panel B. Add Health Effect of Combat Exposure on Domestic Violence, by Timing of Service)  replace 

reg violenttp_ly combat_ff combat_noff	$non_military_controls	$military_controls if time_since_discharce>=1 & time_since_discharce~=.,   robust cluster(SCID) 
outreg2 using AT2B_addhealth,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3)   ctitle(discharged>=1) append

reg violenttp_ly combat_ff combat_noff	$non_military_controls	$military_controls if time_since_discharce<4 &  time_since_discharce>=0 & time_since_discharce~=.,   robust cluster(SCID) 
outreg2 using AT2B_addhealth,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3)   ctitle(discharged<4)  append 

reg violenttp_ly combat_ff combat_noff	$non_military_controls	$military_controls if time_since_discharce>=4 & time_since_discharce~=.,   robust cluster(SCID) 
outreg2 using AT2B_addhealth,keep(combat_ff combat_noff) word excel label nocons  bdec(3) sdec(3)   ctitle(discharged>=3) appen
