set more off

/* load auxiliary programs */
  run programs.do

/* command to use in first level analysis */
  local cmd="probit"
local options="robust"

cap set mem 200m

use csesmod1and2_small, clear
sort A1006
merge A1006 using macro

/* drop some countries */
  dropc 0

/* drop observations with age missing */
  drop if A2001==.


keep simple A1006 A2001 A2002 A2003 A2012 A3031 A1010_1

tempfile temp
save `temp', replace


use `temp', clear
*Recenter variables close to the grand medians (a 40 years old woman)
gen  age1=(A2001-40)/10
gen age2=((A2001-40)^2)/100
gen education =A2003-5
gen male=A2002
recode male 2=0 101=.
gen income=A2012-3


/* the tlevel command constructs a dataset with the estimates and standard errirs for the specified model for each country */
  
  /* get dataset for the two stage analysis */  
  
  /*using means */
  tlevel (simple), command(reg) options(robust) saving(meanreg) by(A1006) wt([aw=A1010_1])


/* using probit with other individual level variables */
  tlevel (simple education age? male), command(`cmd') options(robust) saving(results) by(A1006) wt([aw=A1010_1]) ftest(age1 age2)



/* baseeduc is a categorical variable with the education levels into three groups (see paper for details */
  drop if A2003==.
gen baseeduc=.
replace baseeduc=1 if A2003<=4
replace baseeduc=2 if A2003==5|A2003==6
replace baseeduc=3 if A2003>=7

/* construct datasets with separate estimates for each education group */
  capture noisily tlevel (simple), command(reg) options(robust) saving(baseeduc) by(A1006 baseeduc)  wt([aw=A1010_1])


use `temp', clear
*file for graphs on education
gen education =A2003
gen age1=(A2001-20)/10
gen age2=((A2001-20)^2)/100
gen male=A2002-1
global vars="education male age1 age2"
loop education 8 1
save alleducM20, replace

use `temp', clear
*file for graphs on education
gen education =A2003
gen age1=(A2001-20)/10
gen age2=((A2001-20)^2)/100
gen male=A2002-2
global vars="education male age1 age2"
loop education 8 1
save alleducF20, replace

use `temp', clear
*file for graphs on education
gen education =A2003
gen age1=(A2001-40)/10
gen age2=((A2001-40)^2)/100
gen male=A2002-2
global vars="education male age1 age2"
loop education 8 1
save alleducF40, replace

use `temp', clear
*file for graphs on education
gen education =A2003
gen age1=(A2001-40)/10
gen age2=((A2001-40)^2)/100
gen male=A2002-1
global vars="education male age1 age2"
loop education 8 1
save alleducM40, replace

use `temp', clear
*file for graphs on education
gen education =A2003
gen age1=(A2001-60)/10
gen age2=((A2001-60)^2)/100
gen male=A2002-2
global vars="education male age1 age2"
loop education 8 1
save alleducF60, replace


use `temp', clear
*file for graphs on education
gen education =A2003
gen age1=(A2001-60)/10
gen age2=((A2001-60)^2)/100
gen male=A2002-1
global vars="education male age1 age2"
loop education 8 1
save alleducM60, replace
