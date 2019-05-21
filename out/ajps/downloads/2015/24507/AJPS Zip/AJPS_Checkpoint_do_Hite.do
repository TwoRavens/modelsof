****************
Program Name: AJPS_Checkpoint_do_Hite.do
Author: Nancy Hite
Project: West Bank Checkpoint 

Purpose: /* To quickly re-run figures from paper     */

Files Used:
use " C:\Users\NHITE01\Dropbox\Checkpoint Project\Checkpoint_Effect_DATA_AJPS.dta "


************************************************************************************************************
************************************ Main Analysis ************************************
************************************************************************************************************
**  the following code will provide you the same statatistics to rebuild our figures
*** note some of the figures were constructed with multiple programs,


*************	
***Figure 1:  Balance Checks for Opinion Measures and Demographics 2008
*************

** secular_nonviolent_index  distrust_of_israel  militancy extremism  two_state fatah_hamas_sum Religion_Ideology Religion_Behavior  age_group  wealth gender 

** to generate values in chart 
 foreach x of  varlist  secular_nonviolent_index  distrust_of_israel  militancy extremism  two_state fatah_hamas_sum Religion_Ideology Religion_Behavior  age_group  wealth gender {
xi: reg `x'  ZA if psample==2008
outreg2 using figure1.xls, nolabel append  
}
 

 sum militancy  distrust_of_israel two_state Party_Ideology Fatah_Hamas
 
 *************	
***Figure 4-8:  Main findings
*************
*** using militancy Extreme_avg distrust_of_israel  willingness_for_compromise  secular_nonviolent_index fatah_hamas_sum  Not_voting_avg checkpoint_influence
 

 by Z_C2009 ZA: sum  militancy Extreme_avg  distrust_of_israel willingness_for_compromise  secular_nonviolent_index  fatah_hamas_pcand

 foreach x of  varlist  militancy Extreme_avg distrust_of_israel  willingness_for_compromise  secular_nonviolent_index fatah_hamas_sum  Not_voting_avg checkpoint_influence
xi: reg `x'    difftimeplace ZA Sample2009
outreg2 using figure4_6.xls, nolabel append  
}

collapse (mean) pid -  fatah_hamas_sum, by (Z_C2009 ZA)

**************	
***Figure 9:  Just Zatara
*************


twoway (connected militancy Z_C2009 if ZA==1),  title(Diff-Diff: Militancy)   legend(on title())
twoway (connected extremism Z_C2009 if ZA==1),  title(Diff-Diff: Extremism )   legend(on title())
twoway (connected distrust_of_israel  Z_C2009 if ZA==1),  title(Diff-Diff: Distrust of Israel)   legend(on title())
twoway (connected willingness_for_compromise Z_C2009 if ZA==1),  title(Diff-Diff: Two_State)   legend(on title())
twoway (connected secular_nonviolent_index   Z_C2009 if ZA==1),  title(Diff-Diff: Secular/Non-Violent)   legend(on title())
twoway (connected  fatah_hamas_pcand  Z_C2009 if ZA==1),  title(Diff-Diff: Fatah v Hamas)   legend(on title())
twoway (connected  fatah_hamas_pcand  Z_C2009 if ZA==1),  title(Diff-Diff: Fatah v Hamas)   legend(on title())

 foreach x of  varlist  militancy Extreme_avg  secular_nonviolent_index fatah_hamas_sum  Not_voting_avg checkpoint_influence {
reg `x'    Sample2009
outreg2 using figure4_6.xls, nolabel append  
}

foreach x of  varlist  militancy extremism distrust_of_israel willingness_for_compromise secular_nonviolent_index fatah_hamas_sum {
reg `x'  Sample2009  if ZA==1
outreg2 using figure4_6.xls, nolabel 
append  
}


**************	
***Figure 10:  Humiliation Analysis
*************

xi: reg militancy  difftimeplace  ch_problem1 ZA Sample2009 
outreg2 using figure14.xls, nolabel append  

xi: reg militancy  difftimeplace ZA ch_problem2 Sample2009 
outreg2 using figure14.xls, nolabel append  

xi: reg militancy  difftimeplace ZA  ch_problem3 Sample2009 
outreg2 using figure14.xls, nolabel append  
xi: reg militancy  difftimeplace ZA ch_problem4 Sample2009 
outreg2 using figure14.xls, nolabel append  
xi: reg militancy  difftimeplace ZA ch_problem5 Sample2009 
outreg2 using figure14.xls, nolabel append  
xi: reg militancy  difftimeplace ZA ch_problem6 Sample2009 
outreg2 using figure14.xls, nolabel append  

sort ZA Sample2009 psq48
by ZA Sample2009 psq48: sum militancy




**********************************
** Main Variable Construction
************************************


*** Militancy *********

** psq7,psq8,psq9

*** Extremism*********

*** psq73,psq74, psq75, psq76

gen ext_no_respondq1= 1 if  psq73==.
replace  ext_no_respondq1= 0 if  psq73!=.

gen ext_no_respondq2= 1 if  psq74==.
replace  ext_no_respondq2= 0 if  psq74!=.

gen ext_no_respondq3= 1 if  psq75==.
replace  ext_no_respondq3= 0 if  psq75!=.

gen ext_no_respondq4= 1 if  psq76==.
replace  ext_no_respondq4= 0 if  psq76!=.

gen ext_any_no_res = 0
replace ext_any_no_res = 1 if ext_no_respondq1== 1 
replace ext_any_no_res = 1 if ext_no_respondq2== 1 
replace ext_any_no_res = 1 if ext_no_respondq3== 1 
replace ext_any_no_res = 1 if ext_no_respondq4== 1 

gen Extreme_avg = .
replace Extreme_avg = (psq73+ psq74 +psq75+ psq76)/4 if ext_any_no_res == 0

replace Extreme_avg = (psq73+ psq74 +psq75)/3 if ext_no_respondq1!= 1 & ext_no_respondq2!= 1 & ext_no_respondq3!= 1 & ext_no_respondq4== 1


replace Extreme_avg = (psq73+ psq74 +psq76)/3 if ext_no_respondq1!= 1 & ext_no_respondq2!= 1 & ext_no_respondq3== 1 & ext_no_respondq4!= 1
replace Extreme_avg = (psq76+ psq74 +psq75)/3 if ext_no_respondq1== 1 & ext_no_respondq2!= 1 & ext_no_respondq3!= 1 & ext_no_respondq4!= 1
replace Extreme_avg = (psq73+ psq75 +psq76)/3 if ext_no_respondq1!= 1 & ext_no_respondq2== 1 & ext_no_respondq3!= 1 & ext_no_respondq4!= 1

replace Extreme_avg = (psq73+ psq75)/2 if  ext_no_respondq1!= 1 & ext_no_respondq2== 1 & ext_no_respondq3!= 1 & ext_no_respondq4== 1
replace Extreme_avg = (psq73+ psq76 )/2 if  ext_no_respondq1!= 1 & ext_no_respondq2== 1 & ext_no_respondq3== 1 & ext_no_respondq4!= 1
replace Extreme_avg = (psq73+ psq74 )/2 if  ext_no_respondq1!= 1 & ext_no_respondq2!= 1 & ext_no_respondq3== 1 & ext_no_respondq4== 1
replace Extreme_avg = (psq74+ psq76 )/2 if  ext_no_respondq1== 1 & ext_no_respondq2!= 1 & ext_no_respondq3== 1 & ext_no_respondq4!= 1
replace Extreme_avg = (psq74+ psq75)/2 if  ext_no_respondq1== 1 & ext_no_respondq2!= 1 & ext_no_respondq3!= 1 & ext_no_respondq4== 1
replace Extreme_avg = (psq75+ psq76)/2 if  ext_no_respondq1== 1 & ext_no_respondq2== 1 & ext_no_respondq3!= 1 & ext_no_respondq4!= 1

replace Extreme_avg =  psq73 if  ext_no_respondq1!= 1 & ext_no_respondq2== 1 & ext_no_respondq3== 1 & ext_no_respondq4== 1
replace Extreme_avg =  psq76 if  ext_no_respondq1== 1 & ext_no_respondq2== 1 & ext_no_respondq3== 1 & ext_no_respondq4!= 1
replace Extreme_avg =  psq75 if  ext_no_respondq1== 1 & ext_no_respondq2== 1 & ext_no_respondq3!= 1 & ext_no_respondq4== 1
replace Extreme_avg =  psq74 if  ext_no_respondq1== 1 & ext_no_respondq2!= 1 & ext_no_respondq3== 1 & ext_no_respondq4== 1


*****

*Extremism 
*psq73 psq74 psq75 psq76



 ************distrust_of_israel***********  

* psq21 psq22

*** two_state_test  

*psq18 psq19 psq20


************secular_nonviolent ***********
** secular/non violent = 4
** non-secular/ violent  = 0

*psq85 psq83

********
**Fatah = 0 and Hamas = 1
*****

*psq85 psq83


********** Voting
** psq83,  psq85

gen not_voteq1 = 1 if  psq83==12
replace not_voteq1 = 0 if  psq83!=12

gen undecidedq1 = 1 if  psq83==13
replace undecidedq1 = 0 if  psq83!=13

gen refusalq1 = 1 if  psq83==14
replace refusalq1 = 0 if  psq83!=14

gen missing_q1 = 1 if  psq83==.
replace missing_q1 = 0 if  psq83!=.


gen not_voteq2 = 1 if  psq85==8
replace not_voteq2 = 0 if  psq85!=8

gen undecidedq2 = 1 if  psq85==9
replace undecidedq2 = 0 if  psq85!=9

gen refusalq2 = 1 if  psq85==10
replace refusalq2 = 0 if  psq85!=10

gen missing_q2 = 1 if  psq85==.
replace missing_q2 = 0 if  psq85!=.

gen Not_voting =  .
replace Not_voting = not_voteq1 + not_voteq2 

gen Not_voting_avg =  .
replace Not_voting_avg = (Not_voting/2)


********************
*** checkpoint effect question
**  psq48  = ch_problem1 -ch_problem6












