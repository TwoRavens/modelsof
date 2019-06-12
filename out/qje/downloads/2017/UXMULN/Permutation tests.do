
set more off
clear *


cap cd "~/Dropbox/Projects/The Demand for Status/Final_data_QJE"



/************************

Table 1

************************/
set matsize 5000
clear*

use Datasets/Experiment1.dta, clear

keep if exclude==0

gen Group=1 if Platinum_upgrade==0 & Platinum_upgrade_merit==0
replace Group=2 if Platinum_upgrade==1
replace Group=3 if Platinum_upgrade_merit==1



reg decision platinum, robust
local beta1=_b[platinum]

reg decision platinum i.strata caller_* credit_limit female muslim jakarta age, robust
local beta2=_b[platinum]


mat R=J(5000,17,.)

set seed 1

forvalues n=1(1)5000 {


quietly {

gen temp=runiform()

* Generate permutation taking into account stratification
xtile temp_1=temp if strata==1, nq(290)
gen T1=temp_1<=100 if strata==1 
gen T2=temp_1<=194&T1==0 if strata==1 

xtile temp_2=temp if strata==2, nq(296)
replace T1=temp_2<=100 if strata==2
replace T2=temp_2<=208&T1==0 if strata==2 

xtile temp_3=temp if strata==3, nq(44)
replace T1=temp_3<=13 if strata==3
replace T2=temp_3<=27&T1==0 if strata==3 

xtile temp_4=temp if strata==4, nq(74)
replace T1=temp_4<=24 if strata==4
replace T2=temp_4<=46&T1==0 if strata==4

xtile temp_5=temp if strata==5, nq(74)
replace T1=temp_5<=26 if strata==5
replace T2=temp_5<=48&T1==0 if strata==5

xtile temp_6=temp if strata==6, nq(57)
replace T1=temp_6<=18 if strata==6
replace T2=temp_6<=41&T1==0 if strata==6


gen T=T1+T2

reg decision T, robust
mat R[`n',1]=_b[T]

reg decision T i.strata caller_* credit_limit female muslim jakarta, robust
mat R[`n',2]=_b[T]

drop T* temp* 
}
di `n'

}

clear
set more off
svmat R

gen p1=R1^2>(`beta1')^2

gen p2=R2^2>(`beta2')^2

summ p*



/************************

Table 3

************************/
set matsize 5000

clear*


use Datasets/Experiment2.dta, clear
 
keep if exclude==0

reg Y T, robust
local beta=_b[T]

reg Y T  credit_limit income age  female muslim jakarta, robust
local beta_controls=_b[T]


mat R=J(5000,2,.)


set seed 1

forvalues n=1(1)5000 {

preserve

quietly {
gen temp1=runiform()
xtile temp2=temp1, nq(93)

gen T_permutation=temp2<=42

reg Y T_permutation, robust
mat R[`n',1]=_b[T_permutation]

reg Y T_permutation  credit_limit income age  female muslim jakarta, robust
mat R[`n',2]=_b[T_permutation]
}

di `n'
restore


}


clear
set more off
svmat R


gen p1=R1^2>(`beta')^2

gen p2=R2^2>(`beta_controls')^2


summ p*


/************************

Table 4

************************/

use Datasets/mTurk.dta, clear


regress rose  self,  r
local rosemberg=_b[self]

regress rose  self  race_* female age married i.education i.income ,  r
local rosemberg_controls=_b[self]


forvalues x=1(1)5 {

regress demand_armani_offer`x' self ,  r
local beta`x'=_b[self]

}

forvalues x=1(1)5 {

regress demand_armani_offer`x' self race_* female age married i.education i.income,  r
local beta_controls`x'=_b[self]

}


tab self


mat R=J(5000,12,.)

set seed 1

forvalues n=1(1)5000 {

preserve

quietly {

gen temp1=runiform()
xtile temp2=temp1, nq(405)
gen T=temp2<=201 

regress rose  T,  r
mat R[`n',1]=_b[T]

forvalues x=1(1)5 {

	regress demand_armani_offer`x'  T ,  r
	mat R[`n',1+`x']=_b[T]

}

regress rose  T  race_* female age married i.education i.income,   r
mat R[`n',7]=_b[T]

forvalues x=1(1)5 {

	regress demand_armani_offer`x'  T  race_* female age married i.education i.income,  r
	mat R[`n',7+`x']=_b[T]

}


}

di `n'
restore


}

clear
set more off
svmat R

gen p_rosemberg=R1^2>(`rosemberg')^2

gen p_beta1=R2^2>(`beta1')^2

gen p_beta2=R3^2>(`beta2')^2

gen p_beta3=R4^2>(`beta3')^2

gen p_beta4=R5^2>(`beta4')^2

gen p_beta5=R6^2>(`beta5')^2



gen p_rosemberg_control=R7^2>(`rosemberg_controls')^2

gen p_beta_control1=R8^2>(`beta_controls1')^2

gen p_beta_control2=R9^2>(`beta_controls2')^2

gen p_beta_control3=R10^2>(`beta_controls3')^2

gen p_beta_control4=R11^2>(`beta_controls4')^2

gen p_beta_control5=R12^2>(`beta_controls5')^2

summ p*, separator(0)




/************************

Table A.3

************************/


clear *
use Datasets/Experiment1.dta, clear

keep if exclude==0

* Income cutoff=300
gen X1=inlist(strata,3,4,5,6)

gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age , robust
local col1_1=_b[platinum_X1]
local col1_2=_b[platinum_X0]
local col1_3= _b[platinum_X1]-_b[platinum_X0]

drop *X*

* Income cutoff=500
gen X1=inlist(strata,5,6)

gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age , robust
local col2_1=_b[platinum_X1]
local col2_2=_b[platinum_X0]
local col2_3= _b[platinum_X1]-_b[platinum_X0]

drop *X*


* Female
gen X1=female==1
gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age , robust

local col3_1=_b[platinum_X1]
local col3_2=_b[platinum_X0]
local col3_3= _b[platinum_X1]-_b[platinum_X0]

drop *X*

* Age
xtile age2= age, nq(2)
gen X1=age2==2
gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age , robust

local col4_1=_b[platinum_X1]
local col4_2=_b[platinum_X0]
local col4_3=_b[platinum_X1]-_b[platinum_X0]

drop *X*



mat R=J(5000,17,.)

set seed 1

forvalues n=1(1)5000 {


quietly {

gen temp=runiform()

xtile temp_1=temp if strata==1, nq(290)
gen T1=temp_1<=100 if strata==1 
gen T2=temp_1<=194&T1==0 if strata==1 

xtile temp_2=temp if strata==2, nq(296)
replace T1=temp_2<=100 if strata==2
replace T2=temp_2<=208&T1==0 if strata==2 

xtile temp_3=temp if strata==3, nq(44)
replace T1=temp_3<=13 if strata==3
replace T2=temp_3<=27&T1==0 if strata==3 

xtile temp_4=temp if strata==4, nq(74)
replace T1=temp_4<=24 if strata==4
replace T2=temp_4<=46&T1==0 if strata==4

xtile temp_5=temp if strata==5, nq(74)
replace T1=temp_5<=26 if strata==5
replace T2=temp_5<=48&T1==0 if strata==5

xtile temp_6=temp if strata==6, nq(57)
replace T1=temp_6<=18 if strata==6
replace T2=temp_6<=41&T1==0 if strata==6


drop platinum*

gen platinum=T1+T2


* Income cutoff=300
gen X1=inlist(strata,3,4,5,6)

gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age  , robust
mat R[`n',1]=_b[platinum_X1]
mat R[`n',2]=_b[platinum_X0]
mat R[`n',3]= _b[platinum_X1]-_b[platinum_X0]

drop *X*


* Income cutoff=500
gen X1=inlist(strata,5,6)

gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age  , robust
mat R[`n',4]=_b[platinum_X1]
mat R[`n',5]=_b[platinum_X0]
mat R[`n',6]= _b[platinum_X1]-_b[platinum_X0]

drop *X*

* Female
gen X1=female==1
gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age  , robust
mat R[`n',7]=_b[platinum_X1]
mat R[`n',8]=_b[platinum_X0]
mat R[`n',9]= _b[platinum_X1]-_b[platinum_X0]

drop *X*


* Age
gen X1=age2==2
gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)


reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age  , robust
mat R[`n',10]=_b[platinum_X1]
mat R[`n',11]=_b[platinum_X0]
mat R[`n',12]= _b[platinum_X1]-_b[platinum_X0]

drop *X*


drop T*  temp* 
}
di `n'

}


clear
set more off
svmat R


gen col1_1=R1^2>(`col1_1')^2
gen col1_2=R2^2>(`col1_2')^2
gen col1_3=R3^2>(`col1_3')^2

gen col2_1=R4^2>(`col2_1')^2
gen col2_2=R5^2>(`col2_2')^2
gen col2_3=R6^2>(`col2_3')^2

gen col3_1=R7^2>(`col3_1')^2
gen col3_2=R8^2>(`col3_2')^2
gen col3_3=R9^2>(`col3_3')^2

gen col4_1=R10^2>(`col4_1')^2
gen col4_2=R11^2>(`col4_2')^2
gen col4_3=R12^2>(`col4_3')^2

summ col*, separator(3)





/************************

Figure A.7

************************/


clear*

use Datasets/Experiment3.dta, clear

keep if  exclude == 0


reg takeup plat_pstv if plat_ntrl+plat_pstv==1, robust
local beta1=_b[plat_pstv]

reg takeup plat_pstv income credit_limit  age  female muslim jakarta caller_* if plat_ntrl+plat_pstv==1, robust
local beta2=_b[plat_pstv]


reg takeup upgr_pstv if upgr_ntrl + upgr_pstv ==1, robust
local beta3=_b[upgr_pstv]


reg takeup upgr_pstv  income credit_limit  age  female muslim jakarta caller_* if upgr_ntrl + upgr_pstv ==1, robust
local beta4=_b[upgr_pstv]


tab plat_pstv if plat_ntrl+plat_pstv==1
tab upgr_pstv if upgr_ntrl+upgr_pstv==1



mat R=J(5000,4,.)

set seed 1

forvalues n=1(1)5000 {

preserve

quietly {



gen temp1=runiform()
xtile temp2=temp1 if plat_ntrl+plat_pstv==1, nq(77)
gen T=temp2<=34 if plat_ntrl+plat_pstv==1

drop temp2
xtile temp2=temp1 if upgr_ntrl+upgr_pstv==1, nq(90)
replace T=temp2<=44 if upgr_ntrl+upgr_pstv==1

reg takeup T if plat_ntrl+plat_pstv==1, robust
mat R[`n',1]=_b[T]

reg takeup T income credit_limit  age  female muslim jakarta caller_* if plat_ntrl+plat_pstv==1, robust
mat R[`n',2]=_b[T]

reg takeup T if upgr_ntrl + upgr_pstv ==1, robust
mat R[`n',3]=_b[T]


reg takeup T  income credit_limit  age  female muslim jakarta caller_* if upgr_ntrl + upgr_pstv ==1, robust
mat R[`n',4]=_b[T]

}

di `n'
restore


}

clear
set more off
svmat R

gen p1=R1^2>(`beta1')^2

gen p2=R2^2>(`beta2')^2

gen p3=R3^2>(`beta3')^2

gen p4=R4^2>(`beta4')^2

summ p*











