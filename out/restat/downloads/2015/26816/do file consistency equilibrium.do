
use "data.dta", clear

* Generating variables
do "creating variables.do"


* CONSISTENT EQUILIBRIUM PLAY AGENTS
* Mixed strategies counted as consistent 

gen c_own=0 if agent==1 
replace c_own=1 if 	 agent==1 & maintreatment==1 & ///
				((highbonus==0 & goodsignal==0)| ///
				(highbonus==1 & goodsignal==0 & effort_own==0) | ///
				(highbonus==0 & goodsignal==1 & effort_own==1) | ///
				(highbonus==1 & goodsignal==1 & effort_own==0)) 
replace c_own=1 if 	agent==1 & controltreatment==1 & ///
				((goodsignal==0 & effort_own==0)| ///
				(goodsignal==1 & effort_own==1)) 


gen c_joint=0 if agent==1 
replace c_joint=1 if 	 agent==1 &  maintreatment==1 & ///
				((highbonus==0 & goodsignal==0)| ///
				(highbonus==1 & goodsignal==0 & effort_joint==1) | ///
				(highbonus==0 & goodsignal==1 & effort_joint==1) | ///
				(highbonus==1 & goodsignal==1 & effort_joint==1)) 
replace c_joint=1 if 	 agent==1 & controltreatment==1 & ///
				((goodsignal==0 & highbonus==0 & effort_joint==0)| ///
				((goodsignal==1 | highbonus==1) & effort_joint==1)) 


gen c_joint_own=0 if agent==1 
replace c_joint_own=1 if agent==1 & c_own==1 & c_joint==1

 
bys subjectid controltreatment: egen temp1=mean(c_own)
bys subjectid controltreatment: egen temp2=mean(c_joint) 
bys subjectid controltreatment: egen temp3=mean(c_joint_own) 

bys subjectid controltreatment: egen c_own_it=max(temp1)
bys subjectid controltreatment: egen c_joint_it=max(temp2)
bys subjectid controltreatment: egen c_joint_own_it=max(temp3)

bys subjectid controltreatment : egen temp991=mean(c_own) if secondhalf==0
bys subjectid controltreatment : egen temp992=mean(c_own) if secondhalf==1
bys subjectid controltreatment : egen temp993=mean(c_joint) if secondhalf==0
bys subjectid controltreatment : egen temp994=mean(c_joint) if secondhalf==1
bys subjectid controltreatment : egen temp9930=mean(c_joint_own) if secondhalf==0
bys subjectid controltreatment : egen temp9940=mean(c_joint_own) if secondhalf==1

bys subjectid controltreatment : egen c_own_itp1=max(temp991)
bys subjectid controltreatment : egen c_own_itp2=max(temp992)

bys subjectid controltreatment : egen c_joint_itp1=max(temp993)
bys subjectid controltreatment : egen c_joint_itp2=max(temp994)

bys subjectid controltreatment : egen c_joint_own_itp1=max(temp9930)
bys subjectid controltreatment : egen c_joint_own_itp2=max(temp9940)

drop temp*


* CONSISTENT EQUILIBRIUM PLAY PRINCIPALS
* Mixed strategies counted as consistent 

gen c_bonus=.
replace c_bonus=0 if 	principal==1 
replace c_bonus=1 if 	principal==1 & maintreatment==1 & ///
				(highcosts==1 | (highcosts==0 & highbonus==0))
replace c_bonus=1 if 	principal==1 & controltreatment==1 & ///
				(highbonus==0)


gen c_wage=.
replace c_wage=0 if principal==1
replace c_wage=1 if principal==1 & wage5==0 & wage10==0

gen c_bonus_wage=.
replace c_bonus_wage=0 if principal==1
replace c_bonus_wage=1 if principal==1 & c_bonus==1 & c_wage==1



bys subjectid controltreatment : egen temp1=mean(c_bonus) 
bys subjectid controltreatment : egen temp3=mean(c_wage) 
bys subjectid controltreatment : egen temp4=mean(c_bonus_wage)


bys subjectid controltreatment : egen temp991=mean(c_bonus) if  secondhalf==0
bys subjectid controltreatment : egen temp992=mean(c_bonus) if   secondhalf==1
bys subjectid controltreatment : egen temp993=mean(c_wage) if   secondhalf==0
bys subjectid controltreatment : egen temp994=mean(c_wage) if  secondhalf==1
bys subjectid controltreatment : egen temp9914=mean(c_bonus_wage) if secondhalf==0
bys subjectid controltreatment : egen temp9915=mean(c_bonus_wage) if secondhalf==1

bys subjectid controltreatment : egen c_bonus_it=max(temp1)
bys subjectid controltreatment : egen c_bonus_itp1=max(temp991)
bys subjectid controltreatment : egen c_bonus_itp2=max(temp992)

bys subjectid controltreatment : egen c_wage_it=max(temp3)
bys subjectid controltreatment : egen c_wage_itp1=max(temp993)
bys subjectid controltreatment : egen c_wage_itp2=max(temp994)

bys subjectid controltreatment : egen c_bonus_wage_it=max(temp4)
bys subjectid controltreatment : egen c_bonus_wage_itp1=max(temp9914)
bys subjectid controltreatment : egen c_bonus_wage_itp2=max(temp9915)


drop temp* 
bys round_role: egen bonus_main_lowcosts_rr=mean(highbonus) if maintreatment==1 & principal==1 & highcosts==0
bys round_role: egen bonus_main_highcosts_rr=mean(highbonus) if maintreatment==1 & principal==1 & highcosts==1
bys round_role: egen bonus_control_rr=mean(highbonus) if principal==1 & maintreatment==0 

bys subjectid: egen temp891=mean(highbonus) if maintreatment==1 & principal==1 & highcosts==0
bys subjectid: egen temp892=mean(highbonus) if maintreatment==1 & principal==1 & highcosts==1
bys subjectid: egen temp893=mean(highbonus) if principal==1 & maintreatment==0 

bys subjectid: egen bonus_main_lowcosts_i=mean(temp891) 
bys subjectid: egen bonus_main_highcosts_i=mean(temp892) 
bys subjectid: egen bonus_control_i=mean(temp893) 


*==========================================

* Table 5: consistency


*===========================================

* Column 1
bys controlt: sum   c_bonus_it c_wage_it   c_joint_it c_own_it  c_bonus_wage_it  c_joint_own_it if flagsubjecttreatment==1 

* Column 3: test equality first and second half
gen increasec_bonusit = 100*(c_bonus_itp2- c_bonus_itp1 )
gen increasec_wageit = 100*(c_wage_itp2 -c_wage_itp1)
gen increasec_bonus_wageit =100*( c_bonus_wage_itp2 -c_bonus_wage_itp1  )
gen increasec_jointit = 100*(c_joint_itp2-c_joint_itp1  )
gen increasec_ownit = 100*(c_own_itp2-c_own_itp1)
gen increasec_joint_ownit =100*( c_joint_own_itp2-c_joint_own_itp1  )

bys controlt: sum increasec_bonusit increasec_wageit increasec_jointit  increasec_ownit increasec_bonus_wageit  increasec_joint_ownit if flagsubjecttreatment==1

signrank increasec_bonusit=0 if flagsubjecttreatment==1 & maintr==1
signrank  increasec_wageit=0 if flagsubjecttreatment==1 & maintr==1
signrank increasec_jointit=0 if flagsubjecttreatment==1 & maintr==1
signrank   increasec_ownit=0 if flagsubjecttreatment==1 & maintr==1

signrank increasec_bonus_wageit=0 if flagsubjecttreatment==1 & maintr==1
signrank  increasec_joint_ownit =0 if flagsubjecttreatment==1 & maintr==1

signrank increasec_bonusit=0 if flagsubjecttreatment==1 & maintr==0
signrank  increasec_wageit=0 if flagsubjecttreatment==1 & maintr==0
signrank increasec_jointit=0 if flagsubjecttreatment==1 & maintr==0
signrank   increasec_ownit=0 if flagsubjecttreatment==1 & maintr==0

signrank increasec_bonus_wageit=0 if flagsubjecttreatment==1 & maintr==0
signrank  increasec_joint_ownit =0 if flagsubjecttreatment==1 & maintr==0



* =============================

*		DATA FOR FIGURE 6

* =============================

egen c_subject_meanR=rmean(c_own c_joint c_bonus c_wage) 
bys subjectid maintreatment: egen temp716=mean(c_subject_meanR) 
bys subjectid maintreatment: egen temp717=mean(c_subject_meanR) if secondhalf==0
bys subjectid maintreatment: egen c_subject_meanFH=max(temp717)
bys subjectid maintreatment: egen temp718=mean(c_subject_meanR) if secondhalf==1
bys subjectid maintreatment: egen c_subject_meanSH=max(temp718)
bys subjectid maintreatment: gen c_subject_diffFSH=c_subject_meanSH-c_subject_meanFH

xtile quantilec_subject_meanFHM=c_subject_meanFH if maint==1, n(4)
xtile quantilec_subject_meanFHC=c_subject_meanFH if maint==0, n(4)

bys  quantilec_subject_meanFHM: sum c_subject_meanFH if flagsubjecttreatmentpart==1 & maint==1
bys  quantilec_subject_meanFHM: sum c_subject_meanSH if flagsubjecttreatmentpart==1 & maint==1
bys  quantilec_subject_meanFHC: sum c_subject_meanFH if flagsubjecttreatmentpart==1 & maint==0
bys  quantilec_subject_meanFHC: sum c_subject_meanSH if flagsubjecttreatmentpart==1 & maint==0


* claim in section 4.4 about percentage participants for whom all decisions are correct
bys maintreatment: tab c_subject_meanFH if flagsubjecttreatmentpart==1
bys maintreatment: tab c_subject_meanSH if flagsubjecttreatmentpart==1
