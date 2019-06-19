
/* IS INFORMATION POWER? USING MOBILE PHONES AND FREE NEWSPAPERS DURING AN ELECTION IN MOZAMBIQUE */
/* JENNY AKER, PAUL COLLIER, PEDRO VICENTE */

/* Last revised: April 2016 */

clear all

/* USER CHANGE DIRECTORY OF WORK HERE */
cd ""

capture log close
log using codevoteduc.log, replace

set memory 700m
set maxvar 32767
set matsize 8000
set more off

use mozdata.dta

set more off

global treat="civiceduc hotline verdade"
global prov="pr1 pr2 pr3"

****************************************************************
*****  PRODUCING Z-SCORES AND INDICES OF SURVEY VARIABLES  *****
****************************************************************

*info

global info="knowelect knowdurpres knowassem2009 knowabst knowcand"

foreach i in $info {

sum `i' if time==0 & control==1
matrix define auxm0=r(mean)
matrix define auxs0=r(sd)
scalar define m`i'0=auxm0[1,1]
scalar define sd`i'0=auxs0[1,1]
sum `i' if time==1 & control==1
matrix define auxm1=r(mean)
matrix define auxs1=r(sd)
scalar define m`i'1=auxm1[1,1]
scalar define sd`i'1=auxs1[1,1]
capture drop m`i'
gen m`i'=.
replace m`i'=m`i'0 if time==0
replace m`i'=m`i'1 if time==1
capture drop sd`i'
gen sd`i'=.
replace sd`i'=sd`i'0 if time==0
replace sd`i'=sd`i'1 if time==1
matrix drop auxm0 auxm1 auxs0 auxs1

}

foreach i in $info {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=(`i'-m`i')/(sd`i')

gen zzsc`i'=zsc`i'

sum zsc`i' if time==0 & control==1
matrix define auxm=r(mean)
scalar define m1`i'=auxm[1,1]
replace zzsc`i'=m1`i' if zsc`i'==. & time==0 & control==1

sum zsc`i' if time==1 & control==1
matrix define auxm=r(mean)
scalar define m2`i'=auxm[1,1]
replace zzsc`i'=m2`i' if zsc`i'==. & time==1 & control==1

sum zsc`i' if time==0 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m3`i'=auxm[1,1]
replace zzsc`i'=m3`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==0

sum zsc`i' if time==1 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m4`i'=auxm[1,1]
replace zzsc`i'=m4`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==0

sum zsc`i' if time==0 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m5`i'=auxm[1,1]
replace zzsc`i'=m5`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==1

sum zsc`i' if time==1 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m6`i'=auxm[1,1]
replace zzsc`i'=m6`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==1

sum zsc`i' if time==0 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m7`i'=auxm[1,1]
replace zzsc`i'=m7`i' if zsc`i'==. & time==0 & hotline==1 & lazy==0

sum zsc`i' if time==1 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m8`i'=auxm[1,1]
replace zzsc`i'=m8`i' if zsc`i'==. & time==1 & hotline==1 & lazy==0

sum zsc`i' if time==0 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m9`i'=auxm[1,1]
replace zzsc`i'=m9`i' if zsc`i'==. & time==0 & hotline==1 & lazy==1

sum zsc`i' if time==1 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m10`i'=auxm[1,1]
replace zzsc`i'=m10`i' if zsc`i'==. & time==1 & hotline==1 & lazy==1

sum zsc`i' if time==0 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m11`i'=auxm[1,1]
replace zzsc`i'=m11`i' if zsc`i'==. & time==0 & verdade==1 & lazy==0

sum zsc`i' if time==1 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m12`i'=auxm[1,1]
replace zzsc`i'=m12`i' if zsc`i'==. & time==1 & verdade==1 & lazy==0

sum zsc`i' if time==0 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m13`i'=auxm[1,1]
replace zzsc`i'=m13`i' if zsc`i'==. & time==0 & verdade==1 & lazy==1

sum zsc`i' if time==1 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m14`i'=auxm[1,1]
replace zzsc`i'=m14`i' if zsc`i'==. & time==1 & verdade==1 & lazy==1

}

capture drop zzscinfo
gen zzscinfo=(zzscknowelect+zzscknowdurpres+zzscknowassem2009+zzscknowabst+zzscknowcand)/5
replace zzscinfo=. if zscknowelect==. & zscknowdurpres==. & zscknowassem2009==. & zscknowabst==. & zscknowcand==.

*cne

global cne="indepcne trustcne"

foreach i in $cne {

sum `i' if time==0 & control==1
matrix define auxm0=r(mean)
matrix define auxs0=r(sd)
scalar define m`i'0=auxm0[1,1]
scalar define sd`i'0=auxs0[1,1]
sum `i' if time==1 & control==1
matrix define auxm1=r(mean)
matrix define auxs1=r(sd)
scalar define m`i'1=auxm1[1,1]
scalar define sd`i'1=auxs1[1,1]
capture drop m`i'
gen m`i'=.
replace m`i'=m`i'0 if time==0
replace m`i'=m`i'1 if time==1
capture drop sd`i'
gen sd`i'=.
replace sd`i'=sd`i'0 if time==0
replace sd`i'=sd`i'1 if time==1
matrix drop auxm0 auxm1 auxs0 auxs1

}

foreach i in $cne {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=(`i'-m`i')/(sd`i')

}

*confusion

global confusion="realbuildwho1 realbuildwho2 realbuildwho5 realbuildwho7"

foreach i in $confusion {

sum `i' if time==0 & control==1
matrix define auxm0=r(mean)
matrix define auxs0=r(sd)
scalar define m`i'0=auxm0[1,1]
scalar define sd`i'0=auxs0[1,1]
sum `i' if time==1 & control==1
matrix define auxm1=r(mean)
matrix define auxs1=r(sd)
scalar define m`i'1=auxm1[1,1]
scalar define sd`i'1=auxs1[1,1]
capture drop m`i'
gen m`i'=.
replace m`i'=m`i'0 if time==0
replace m`i'=m`i'1 if time==1
capture drop sd`i'
gen sd`i'=.
replace sd`i'=sd`i'0 if time==0
replace sd`i'=sd`i'1 if time==1
matrix drop auxm0 auxm1 auxs0 auxs1

}

foreach i in $confusion {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=(`i'-m`i')/(sd`i')

gen zzsc`i'=zsc`i'

sum zsc`i' if time==0 & control==1
matrix define auxm=r(mean)
scalar define m1`i'=auxm[1,1]
replace zzsc`i'=m1`i' if zsc`i'==. & time==0 & control==1

sum zsc`i' if time==1 & control==1
matrix define auxm=r(mean)
scalar define m2`i'=auxm[1,1]
replace zzsc`i'=m2`i' if zsc`i'==. & time==1 & control==1

sum zsc`i' if time==0 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m3`i'=auxm[1,1]
replace zzsc`i'=m3`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==0

sum zsc`i' if time==1 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m4`i'=auxm[1,1]
replace zzsc`i'=m4`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==0

sum zsc`i' if time==0 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m5`i'=auxm[1,1]
replace zzsc`i'=m5`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==1

sum zsc`i' if time==1 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m6`i'=auxm[1,1]
replace zzsc`i'=m6`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==1

sum zsc`i' if time==0 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m7`i'=auxm[1,1]
replace zzsc`i'=m7`i' if zsc`i'==. & time==0 & hotline==1 & lazy==0

sum zsc`i' if time==1 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m8`i'=auxm[1,1]
replace zzsc`i'=m8`i' if zsc`i'==. & time==1 & hotline==1 & lazy==0

sum zsc`i' if time==0 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m9`i'=auxm[1,1]
replace zzsc`i'=m9`i' if zsc`i'==. & time==0 & hotline==1 & lazy==1

sum zsc`i' if time==1 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m10`i'=auxm[1,1]
replace zzsc`i'=m10`i' if zsc`i'==. & time==1 & hotline==1 & lazy==1

sum zsc`i' if time==0 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m11`i'=auxm[1,1]
replace zzsc`i'=m11`i' if zsc`i'==. & time==0 & verdade==1 & lazy==0

sum zsc`i' if time==1 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m12`i'=auxm[1,1]
replace zzsc`i'=m12`i' if zsc`i'==. & time==1 & verdade==1 & lazy==0

sum zsc`i' if time==0 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m13`i'=auxm[1,1]
replace zzsc`i'=m13`i' if zsc`i'==. & time==0 & verdade==1 & lazy==1

sum zsc`i' if time==1 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m14`i'=auxm[1,1]
replace zzsc`i'=m14`i' if zsc`i'==. & time==1 & verdade==1 & lazy==1

}

capture drop zzscconfusion
gen zzscconfusion=(zzscrealbuildwho1+zzscrealbuildwho2+zzscrealbuildwho5+zzscrealbuildwho7)/4
replace zzscconfusion=. if zscrealbuildwho1==. & zscrealbuildwho2==. & zscrealbuildwho5==. & zscrealbuildwho7==.

*fraud

global fraud="freefair2004 freefair2009 vcount2009"

foreach i in $fraud {

sum `i' if time==0 & control==1
matrix define auxm0=r(mean)
matrix define auxs0=r(sd)
scalar define m`i'0=auxm0[1,1]
scalar define sd`i'0=auxs0[1,1]
sum `i' if time==1 & control==1
matrix define auxm1=r(mean)
matrix define auxs1=r(sd)
scalar define m`i'1=auxm1[1,1]
scalar define sd`i'1=auxs1[1,1]
capture drop m`i'
gen m`i'=.
replace m`i'=m`i'0 if time==0
replace m`i'=m`i'1 if time==1
capture drop sd`i'
gen sd`i'=.
replace sd`i'=sd`i'0 if time==0
replace sd`i'=sd`i'1 if time==1
matrix drop auxm0 auxm1 auxs0 auxs1

}

global fraudminus="freefair2004 freefair2009 vcount2009"

foreach i in $fraudminus {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=-(`i'-m`i')/(sd`i')

}

*votbuying

global votbuying="vb2009diff freefair2009_3"

foreach i in $votbuying {

sum `i' if time==0 & control==1
matrix define auxm0=r(mean)
matrix define auxs0=r(sd)
scalar define m`i'0=auxm0[1,1]
scalar define sd`i'0=auxs0[1,1]
sum `i' if time==1 & control==1
matrix define auxm1=r(mean)
matrix define auxs1=r(sd)
scalar define m`i'1=auxm1[1,1]
scalar define sd`i'1=auxs1[1,1]
capture drop m`i'
gen m`i'=.
replace m`i'=m`i'0 if time==0
replace m`i'=m`i'1 if time==1
capture drop sd`i'
gen sd`i'=.
replace sd`i'=sd`i'0 if time==0
replace sd`i'=sd`i'1 if time==1
matrix drop auxm0 auxm1 auxs0 auxs1

}

global votbuyingplus="vb2009diff"
global votbuyingminus="freefair2009_3"

foreach i in $votbuyingplus {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=(`i'-m`i')/(sd`i')

gen zzsc`i'=zsc`i'

sum zsc`i' if time==0 & control==1
matrix define auxm=r(mean)
scalar define m1`i'=auxm[1,1]
replace zzsc`i'=m1`i' if zsc`i'==. & time==0 & control==1

sum zsc`i' if time==1 & control==1
matrix define auxm=r(mean)
scalar define m2`i'=auxm[1,1]
replace zzsc`i'=m2`i' if zsc`i'==. & time==1 & control==1

sum zsc`i' if time==0 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m3`i'=auxm[1,1]
replace zzsc`i'=m3`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==0

sum zsc`i' if time==1 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m4`i'=auxm[1,1]
replace zzsc`i'=m4`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==0

sum zsc`i' if time==0 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m5`i'=auxm[1,1]
replace zzsc`i'=m5`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==1

sum zsc`i' if time==1 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m6`i'=auxm[1,1]
replace zzsc`i'=m6`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==1

sum zsc`i' if time==0 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m7`i'=auxm[1,1]
replace zzsc`i'=m7`i' if zsc`i'==. & time==0 & hotline==1 & lazy==0

sum zsc`i' if time==1 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m8`i'=auxm[1,1]
replace zzsc`i'=m8`i' if zsc`i'==. & time==1 & hotline==1 & lazy==0

sum zsc`i' if time==0 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m9`i'=auxm[1,1]
replace zzsc`i'=m9`i' if zsc`i'==. & time==0 & hotline==1 & lazy==1

sum zsc`i' if time==1 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m10`i'=auxm[1,1]
replace zzsc`i'=m10`i' if zsc`i'==. & time==1 & hotline==1 & lazy==1

sum zsc`i' if time==0 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m11`i'=auxm[1,1]
replace zzsc`i'=m11`i' if zsc`i'==. & time==0 & verdade==1 & lazy==0

sum zsc`i' if time==1 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m12`i'=auxm[1,1]
replace zzsc`i'=m12`i' if zsc`i'==. & time==1 & verdade==1 & lazy==0

sum zsc`i' if time==0 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m13`i'=auxm[1,1]
replace zzsc`i'=m13`i' if zsc`i'==. & time==0 & verdade==1 & lazy==1

sum zsc`i' if time==1 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m14`i'=auxm[1,1]
replace zzsc`i'=m14`i' if zsc`i'==. & time==1 & verdade==1 & lazy==1

}

foreach i in $votbuyingminus {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=-(`i'-m`i')/(sd`i')

gen zzsc`i'=zsc`i'

sum zsc`i' if time==0 & control==1
matrix define auxm=r(mean)
scalar define m1`i'=auxm[1,1]
replace zzsc`i'=m1`i' if zsc`i'==. & time==0 & control==1

sum zsc`i' if time==1 & control==1
matrix define auxm=r(mean)
scalar define m2`i'=auxm[1,1]
replace zzsc`i'=m2`i' if zsc`i'==. & time==1 & control==1

sum zsc`i' if time==0 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m3`i'=auxm[1,1]
replace zzsc`i'=m3`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==0

sum zsc`i' if time==1 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m4`i'=auxm[1,1]
replace zzsc`i'=m4`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==0

sum zsc`i' if time==0 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m5`i'=auxm[1,1]
replace zzsc`i'=m5`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==1

sum zsc`i' if time==1 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m6`i'=auxm[1,1]
replace zzsc`i'=m6`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==1

sum zsc`i' if time==0 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m7`i'=auxm[1,1]
replace zzsc`i'=m7`i' if zsc`i'==. & time==0 & hotline==1 & lazy==0

sum zsc`i' if time==1 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m8`i'=auxm[1,1]
replace zzsc`i'=m8`i' if zsc`i'==. & time==1 & hotline==1 & lazy==0

sum zsc`i' if time==0 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m9`i'=auxm[1,1]
replace zzsc`i'=m9`i' if zsc`i'==. & time==0 & hotline==1 & lazy==1

sum zsc`i' if time==1 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m10`i'=auxm[1,1]
replace zzsc`i'=m10`i' if zsc`i'==. & time==1 & hotline==1 & lazy==1

sum zsc`i' if time==0 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m11`i'=auxm[1,1]
replace zzsc`i'=m11`i' if zsc`i'==. & time==0 & verdade==1 & lazy==0

sum zsc`i' if time==1 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m12`i'=auxm[1,1]
replace zzsc`i'=m12`i' if zsc`i'==. & time==1 & verdade==1 & lazy==0

sum zsc`i' if time==0 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m13`i'=auxm[1,1]
replace zzsc`i'=m13`i' if zsc`i'==. & time==0 & verdade==1 & lazy==1

sum zsc`i' if time==1 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m14`i'=auxm[1,1]
replace zzsc`i'=m14`i' if zsc`i'==. & time==1 & verdade==1 & lazy==1

}

capture drop zzscvotbuying
gen zzscvotbuying=(zzscvb2009diff+zzscfreefair2009_3)/2
replace zzscvotbuying=. if zscvb2009diff==. & zscfreefair2009_3==.

*violence

capture gen competd=competitiondiff

global violence="carefuldiff competd destroy2009diff freefair2009_4 competition intimgen2009 intim2009prewhofre"

foreach i in $violence {

sum `i' if time==0 & control==1
matrix define auxm0=r(mean)
matrix define auxs0=r(sd)
scalar define m`i'0=auxm0[1,1]
scalar define sd`i'0=auxs0[1,1]
sum `i' if time==1 & control==1
matrix define auxm1=r(mean)
matrix define auxs1=r(sd)
scalar define m`i'1=auxm1[1,1]
scalar define sd`i'1=auxs1[1,1]
capture drop m`i'
gen m`i'=.
replace m`i'=m`i'0 if time==0
replace m`i'=m`i'1 if time==1
capture drop sd`i'
gen sd`i'=.
replace sd`i'=sd`i'0 if time==0
replace sd`i'=sd`i'1 if time==1
matrix drop auxm0 auxm1 auxs0 auxs1

}

global violenceplus="carefuldiff competd destroy2009diff competition intimgen2009 intim2009prewhofre"
global violenceminus="freefair2009_4"

foreach i in $violenceplus {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=(`i'-m`i')/(sd`i')

gen zzsc`i'=zsc`i'

sum zsc`i' if time==0 & control==1
matrix define auxm=r(mean)
scalar define m1`i'=auxm[1,1]
replace zzsc`i'=m1`i' if zsc`i'==. & time==0 & control==1

sum zsc`i' if time==1 & control==1
matrix define auxm=r(mean)
scalar define m2`i'=auxm[1,1]
replace zzsc`i'=m2`i' if zsc`i'==. & time==1 & control==1

sum zsc`i' if time==0 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m3`i'=auxm[1,1]
replace zzsc`i'=m3`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==0

sum zsc`i' if time==1 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m4`i'=auxm[1,1]
replace zzsc`i'=m4`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==0

sum zsc`i' if time==0 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m5`i'=auxm[1,1]
replace zzsc`i'=m5`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==1

sum zsc`i' if time==1 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m6`i'=auxm[1,1]
replace zzsc`i'=m6`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==1

sum zsc`i' if time==0 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m7`i'=auxm[1,1]
replace zzsc`i'=m7`i' if zsc`i'==. & time==0 & hotline==1 & lazy==0

sum zsc`i' if time==1 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m8`i'=auxm[1,1]
replace zzsc`i'=m8`i' if zsc`i'==. & time==1 & hotline==1 & lazy==0

sum zsc`i' if time==0 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m9`i'=auxm[1,1]
replace zzsc`i'=m9`i' if zsc`i'==. & time==0 & hotline==1 & lazy==1

sum zsc`i' if time==1 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m10`i'=auxm[1,1]
replace zzsc`i'=m10`i' if zsc`i'==. & time==1 & hotline==1 & lazy==1

sum zsc`i' if time==0 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m11`i'=auxm[1,1]
replace zzsc`i'=m11`i' if zsc`i'==. & time==0 & verdade==1 & lazy==0

sum zsc`i' if time==1 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m12`i'=auxm[1,1]
replace zzsc`i'=m12`i' if zsc`i'==. & time==1 & verdade==1 & lazy==0

sum zsc`i' if time==0 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m13`i'=auxm[1,1]
replace zzsc`i'=m13`i' if zsc`i'==. & time==0 & verdade==1 & lazy==1

sum zsc`i' if time==1 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m14`i'=auxm[1,1]
replace zzsc`i'=m14`i' if zsc`i'==. & time==1 & verdade==1 & lazy==1

}

foreach i in $violenceminus {

capture drop zsc`i'

capture drop zzsc`i'

gen zsc`i'=-(`i'-m`i')/(sd`i')

gen zzsc`i'=zsc`i'

sum zsc`i' if time==0 & control==1
matrix define auxm=r(mean)
scalar define m1`i'=auxm[1,1]
replace zzsc`i'=m1`i' if zsc`i'==. & time==0 & control==1

sum zsc`i' if time==1 & control==1
matrix define auxm=r(mean)
scalar define m2`i'=auxm[1,1]
replace zzsc`i'=m2`i' if zsc`i'==. & time==1 & control==1

sum zsc`i' if time==0 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m3`i'=auxm[1,1]
replace zzsc`i'=m3`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==0

sum zsc`i' if time==1 & civiceduc==1 & lazy==0
matrix define auxm=r(mean)
scalar define m4`i'=auxm[1,1]
replace zzsc`i'=m4`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==0

sum zsc`i' if time==0 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m5`i'=auxm[1,1]
replace zzsc`i'=m5`i' if zsc`i'==. & time==0 & civiceduc==1 & lazy==1

sum zsc`i' if time==1 & civiceduc==1 & lazy==1
matrix define auxm=r(mean)
scalar define m6`i'=auxm[1,1]
replace zzsc`i'=m6`i' if zsc`i'==. & time==1 & civiceduc==1 & lazy==1

sum zsc`i' if time==0 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m7`i'=auxm[1,1]
replace zzsc`i'=m7`i' if zsc`i'==. & time==0 & hotline==1 & lazy==0

sum zsc`i' if time==1 & hotline==1 & lazy==0
matrix define auxm=r(mean)
scalar define m8`i'=auxm[1,1]
replace zzsc`i'=m8`i' if zsc`i'==. & time==1 & hotline==1 & lazy==0

sum zsc`i' if time==0 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m9`i'=auxm[1,1]
replace zzsc`i'=m9`i' if zsc`i'==. & time==0 & hotline==1 & lazy==1
*sum zzsc`i' if time==0 & hotline==1 & lazy==1

sum zsc`i' if time==1 & hotline==1 & lazy==1
matrix define auxm=r(mean)
scalar define m10`i'=auxm[1,1]
replace zzsc`i'=m10`i' if zsc`i'==. & time==1 & hotline==1 & lazy==1

sum zsc`i' if time==0 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m11`i'=auxm[1,1]
replace zzsc`i'=m11`i' if zsc`i'==. & time==0 & verdade==1 & lazy==0

sum zsc`i' if time==1 & verdade==1 & lazy==0
matrix define auxm=r(mean)
scalar define m12`i'=auxm[1,1]
replace zzsc`i'=m12`i' if zsc`i'==. & time==1 & verdade==1 & lazy==0

sum zsc`i' if time==0 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m13`i'=auxm[1,1]
replace zzsc`i'=m13`i' if zsc`i'==. & time==0 & verdade==1 & lazy==1

sum zsc`i' if time==1 & verdade==1 & lazy==1
matrix define auxm=r(mean)
scalar define m14`i'=auxm[1,1]
replace zzsc`i'=m14`i' if zsc`i'==. & time==1 & verdade==1 & lazy==1

}

capture drop zzscviolence
gen zzscviolence=(zzsccarefuldiff+zzsccompetd+zzscdestroy2009diff+zzscfreefair2009_4+zzsccompetition+zzscintimgen2009+zzscintim2009prewhofre)/7
replace zzscviolence=. if zsccarefuldiff==. & zsccompetd==. & zscdestroy2009diff==. & zscfreefair2009_4==. & zsccompetition==. & zscintimgen2009==. & zscintim2009prewhofre==.

********************************
*****  TABLES A3: BALANCE  *****
********************************

*******************************************
*****  BALANCE OF EA CHARACTERISTICS  *****
*******************************************

capture egen eadrop = mean(drops2), by(ea time)

global ea1="schoolbuild policesta electricity water sewer health recreation temple meetroom road eadrop"

foreach i in $ea1 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & v==1
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & v==1
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & v==1
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & v==1
	test civiceduc hotline verdade
	scalar define f`i'=r(p)
	display f`i'
	
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

global list2=""
matrix define fpvalue=(fschoolbuild \ fpolicesta \ felectricity \ fwater \ fsewer \ fhealth \ frecreation \ ftemple \ fmeetroom \ froad \ feadrop)
matrix rownames fpvalue = "schoolbuild" "policesta" "electricity" "water" "sewer" "health" "recreation" "temple" "meetroom" "road" "eadrop"
global list2="$list2" + " fpvalue"
xml_tab $list2, save(balance.xml) append sheet("fpvalue ea") 
estimates clear

***************************************************************
*****  BALANCE OF INDIVIDUAL DEMOGRAPHIC CHARACTERISTICS  *****
***************************************************************

global demo1="sex age head housen single marriedunion noschl informalschl lit prim5y sec10y"
global demo2="chang macua lomue chuabo chironga maconde"
global demo3="cathol protest muslim"
global demo4="job agric com art man assal tea puboff stud dom"
global demo5="house land cattle cel expenditure"
global demo6="netmean_dist"

set more off

foreach i in $demo1 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $demo2 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $demo3 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $demo4 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $demo5 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $demo6 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

global list2=""
matrix define fpvalue_1=(fsex_1 \ fage_1 \ fhead_1 \ fhousen_1 \ fsingle_1 \ fmarriedunion_1 \ fnoschl_1 \ finformalschl_1 \ flit_1 \ fprim5y_1 \ fsec10y_1 \ fchang_1 \ fmacua_1 \ flomue_1 \ fchuabo_1 \ fchironga_1 \ fmaconde_1 \ fcathol_1 \ fprotest_1 \ fmuslim_1 \ fjob_1 \ fagric_1 \ fcom_1 \ fart_1 \ fman_1 \ fassal_1 \ ftea_1 \ fpuboff_1 \ fstud_1 \ fdom_1 \ fhouse_1 \ fland_1 \ fcattle_1 \ fcel_1 \ fexpenditure_1 \ fnetmean_dist_1)
matrix rownames fpvalue_1 = "sex" "age" "head" "housen" "single" "marriedunion" "noschl" "informalschl" "lit" "prim5y" "sec10y" "chang" "macua" "lomue" "chuabo" "chironga" "maconde" "cathol" "protest" "muslim" "job" "agric" "com" "art" "man" "assal" "tea" "puboff" "stud" "dom" "house" "land" "cattle" "cel" "expenditure" "netmean_dist"
matrix define fpvalue_4=(fsex_4 \ fage_4 \ fhead_4 \ fhousen_4 \ fsingle_4 \ fmarriedunion_4 \ fnoschl_4 \ finformalschl_4 \ flit_4 \ fprim5y_4 \ fsec10y_4 \ fchang_4 \ fmacua_4 \ flomue_4 \ fchuabo_4 \ fchironga_4 \ fmaconde_4 \ fcathol_4 \ fprotest_4 \ fmuslim_4 \ fjob_4 \ fagric_4 \ fcom_4 \ fart_4 \ fman_4 \ fassal_4 \ ftea_4 \ fpuboff_4 \ fstud_4 \ fdom_4 \ fhouse_4 \ fland_4 \ fcattle_4 \ fcel_4 \ fexpenditure_4 \ fnetmean_dist_4)
matrix fpvalue= (fpvalue_1, fpvalue_4)
global list2="$list2" + " fpvalue"
xml_tab $list2, save(balance.xml) append sheet("fpvalue demo") 
estimates clear

**********************************************
*****  BALANCE OF OFFICIAL RESULTS 2004  *****
**********************************************

set more off

global ballot1="voterspres04 bsturnoutpres04 bsguebas04 bsdhlakama04 bsnullpres04 bsblankpres04"
global ballot2="bsturnoutparl04 bsfrelimo04 bsrenamo04 bsnullparl04 bsblankparl04"
global ballot3="voterspres09"

foreach i in $ballot1 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & v==1
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & v==1
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & v==1
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & v==1
	test civiceduc hotline verdade
	scalar define f`i'=r(p)
	display f`i'
	
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $ballot2 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & v==1
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & v==1
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & v==1
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & v==1
	test civiceduc hotline verdade
	scalar define f`i'=r(p)
	display f`i'
	
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $ballot3 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & v==1
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & v==1
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & v==1
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & v==1
	test civiceduc hotline verdade
	scalar define f`i'=r(p)
	display f`i'
	
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

global list=""
matrix define fpvalue=(fvoterspres04 \ fbsturnoutpres04 \ fbsguebas04 \ fbsdhlakama04 \ fbsnullpres04 \ fbsblankpres04 \ fbsturnoutparl04 \ fbsfrelimo04 \ fbsrenamo04 \ fbsnullparl04 \ fbsblankparl04 \ fvoterspres09)
matrix rownames fpvalue = "voterspres04" "bsturnoutpres04" "bsguebas04" "bsdhlakama04" "bsnullpres04" "bsblankpres04" "bsturnoutparl04" "bsfrelimo04" "bsrenamo04" "bsnullparl04" "bsblankparl04" "voterspres09"
global list="$list" + " fpvalue"
xml_tab $list, save(balance.xml) append sheet("fpvalue ballots") 
estimates clear

*************************************************
*****  BALANCE OF BASELINE SURVEY OUTCOMES  *****
*************************************************

capture gen zsctcne=zsctrustcne
capture gen zsccne=zscindepcne
capture gen zscff4=zscfreefair2004
capture gen zsccount=zscvcount2009
capture gen zscff9_3=zscfreefair2009_3
capture gen zscff9_4=zscfreefair2009_4

set more off

global votint="turnoutresp guebas2 dlakhama2 simango2 frelimo2 renamo2"
global votpast="turnout2004 guebas20042	dlakhama20042 frelimo20042 renamo20042"
global survey="zsctcne zsccne zscff4 zsccount zscff9_3 zscff9_4"

foreach i in $votint {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $votpast {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}

foreach i in $survey {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_10
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & drops2==0, cluster(ea)
	estimates store `i'_11
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & drops2==0, cluster(ea)
	estimates store `i'_12
	regress `i' civiceduc hotline verdade if time==0 & drops2==0, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_4=r(p)
	display f`i'_4

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3" + " `i'_10" + " `i'_11" + " `i'_12"
	xml_tab $list1, below save(balance.xml) append sheet("bal `i'")
	estimates clear

}
global votint="turnoutresp guebas2 dlakhama2 simango2 frelimo2 renamo2"
global votpast="turnout2004 guebas20042	dlakhama20042 frelimo20042 renamo20042"
global survey="zsctcne zsccne zscff4 zsccount zscff9_3 zscff9_4"

global list2=""
matrix define fpvalue_1=(fturnoutresp_1 \ fguebas2_1 \ fdlakhama2_1 \ fsimango2_1 \ ffrelimo2_1 \ frenamo2_1 \ fturnout2004_1 \ fguebas20042_1 \ fdlakhama20042_1 \ ffrelimo20042_1 \ frenamo20042_1 \ fzsctcne_1 \ fzsccne_1 \ fzscff4_1 \ fzsccount_1 \ fzscff9_3_1 \ fzscff9_4_1)
matrix rownames fpvalue_1 = "turnoutresp" "guebas2" "dlakhama2" "simango2" "frelimo2" "renamo2" "turnout2004" "guebas20042" "dlakhama20042" "frelimo20042" "renamo20042" "zsctcne" "zsccne" "zscff4" "zsccount" "zscff9_3" "zscff9_4"
matrix define fpvalue_4=(fturnoutresp_4 \ fguebas2_4 \ fdlakhama2_4 \ fsimango2_4 \ ffrelimo2_4 \ frenamo2_4 \ fturnout2004_4 \ fguebas20042_4 \ fdlakhama20042_4 \ ffrelimo20042_4 \ frenamo20042_4 \ fzsctcne_4 \ fzsccne_4 \ fzscff4_4 \ fzsccount_4 \ fzscff9_3_4 \ fzscff9_4_4)
matrix fpvalue= (fpvalue_1, fpvalue_4)
global list2="$list2" + " fpvalue"
xml_tab $list2, save(balance.xml) append sheet("fpvalue baseout") 
estimates clear

*******************************************************************
*****  TABLE 1 AND OA TABLE 4: REGRESSIONS OF BALLOT RESULTS  *****
*******************************************************************

global out1="bsturnoutpres09 bsturnoutparl09" 
global out2="bsnullpres09 bsnullparl09"
global out3="bsblankpres09 bsblankparl09"
global out4="bsguebas09 bsdhlakama09 bssimango09"
global out5="bsfrelimo09 bsrenamo09"

global ea="count2009 policesta policesta_miss sewer sewer_miss recreation recreation_miss road road_miss"

global list1=""
global list2=""

foreach i in $out1 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2
	
	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsturnoutpres09_2, m_bsturnoutpres09_3, m_bsturnoutparl09_2, m_bsturnoutparl09_3 \ t1_bsturnoutpres09_2, t1_bsturnoutpres09_3, t1_bsturnoutparl09_2, t1_bsturnoutparl09_3 \ t2_bsturnoutpres09_2, t2_bsturnoutpres09_3, t2_bsturnoutparl09_2, t2_bsturnoutparl09_3 \ t3_bsturnoutpres09_2, t3_bsturnoutpres09_3, t3_bsturnoutparl09_2, t3_bsturnoutparl09_3 \ t4_bsturnoutpres09_2, t4_bsturnoutpres09_3, t4_bsturnoutparl09_2, t4_bsturnoutparl09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ballots.xml") replace sheet("out1") 
xml_tab $list2, save("outputregs_ballots.xml") append sheet("out1 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $out2 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2
	
	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3

	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsnullpres09_2, m_bsnullpres09_3, m_bsnullparl09_2, m_bsnullparl09_3 \ t1_bsnullpres09_2, t1_bsnullpres09_3, t1_bsnullparl09_2, t1_bsnullparl09_3 \ t2_bsnullpres09_2, t2_bsnullpres09_3, t2_bsnullparl09_2, t2_bsnullparl09_3 \ t3_bsnullpres09_2, t3_bsnullpres09_3, t3_bsnullparl09_2, t3_bsnullparl09_3 \ t4_bsnullpres09_2, t4_bsnullpres09_3, t4_bsnullparl09_2, t4_bsnullparl09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ballots.xml") append sheet("out2") 
xml_tab $list2, save("outputregs_ballots.xml") append sheet("out2 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $out3 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2
	
	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsblankpres09_2, m_bsblankpres09_3, m_bsblankparl09_2, m_bsblankparl09_3 \ t1_bsblankpres09_2, t1_bsblankpres09_3, t1_bsblankparl09_2, t1_bsblankparl09_3 \ t2_bsblankpres09_2, t2_bsblankpres09_3, t2_bsblankparl09_2, t2_bsblankparl09_3 \ t3_bsblankpres09_2, t3_bsblankpres09_3, t3_bsblankparl09_2, t3_bsblankparl09_3 \ t4_bsblankpres09_2, t4_bsblankpres09_3, t4_bsblankparl09_2, t4_bsblankparl09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ballots.xml") append sheet("out3") 
xml_tab $list2, save("outputregs_ballots.xml") append sheet("out3 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $out4 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2
	
	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsguebas09_2, m_bsguebas09_3, m_bsdhlakama09_2, m_bsdhlakama09_3, m_bssimango09_2, m_bssimango09_3 \ t1_bsguebas09_2, t1_bsguebas09_3, t1_bsdhlakama09_2, t1_bsdhlakama09_3, t1_bssimango09_2, t1_bssimango09_3 \ t2_bsguebas09_2, t2_bsguebas09_3, t2_bsdhlakama09_2, t2_bsdhlakama09_3, t2_bssimango09_2, t2_bssimango09_3 \ t3_bsguebas09_2, t3_bsguebas09_3, t3_bsdhlakama09_2, t3_bsdhlakama09_3, t3_bssimango09_2, t3_bssimango09_3 \ t4_bsguebas09_2, t4_bsguebas09_3, t4_bsdhlakama09_2, t4_bsdhlakama09_3, t4_bssimango09_2, t4_bssimango09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ballots.xml") append sheet("out4") 
xml_tab $list2, save("outputregs_ballots.xml") append sheet("out4 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $out5 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2

	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsfrelimo09_2, m_bsfrelimo09_3, m_bsrenamo09_2, m_bsrenamo09_3 \ t1_bsfrelimo09_2, t1_bsfrelimo09_3, t1_bsrenamo09_2, t1_bsrenamo09_3 \ t2_bsfrelimo09_2, t2_bsfrelimo09_3, t2_bsrenamo09_2, t2_bsrenamo09_3 \ t3_bsfrelimo09_2, t3_bsfrelimo09_3, t3_bsrenamo09_2, t3_bsrenamo09_3 \ t4_bsfrelimo09_2, t4_bsfrelimo09_3, t4_bsrenamo09_2, t4_bsrenamo09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ballots.xml") append sheet("out5") 
xml_tab $list2, save("outputregs_ballots.xml") append sheet("out5 stats") 
estimates clear

*******************************************
*****  OA TABLES 5: LASSO ROBUSTNESS  *****
*******************************************

set more off

global ea_all="count2009 schoolbuild policesta electricity water sewer health recreation temple meetroom road"

lars bsturnoutpres09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 schoolbuild schoolbuild_miss policesta policesta_miss electricity electricity_miss health health_miss recreation recreation_miss meetroom meetroom_miss"

	regress bsturnoutpres09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_1
	sum bsturnoutpres09 if e(sample) & control == 1
	scalar define m_l_1=r(mean)
	display m_l_1
	test civiceduc = hotline
	scalar define t1_l_1=r(p)
	display t1_l_1
	test civiceduc = verdade
	scalar define t2_l_1=r(p)
	display t2_l_1
	test hotline = verdade
	scalar define t3_l_1=r(p)
	display t3_l_1
	test civiceduc hotline verdade
	scalar define t4_l_1=r(p)
	display t4_l_1

lars bsturnoutparl09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 schoolbuild schoolbuild_miss electricity electricity_miss health health_miss recreation recreation_miss meetroom meetroom_miss"

	regress bsturnoutparl09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_2
	sum bsturnoutparl09 if e(sample) & control == 1
	scalar define m_l_2=r(mean)
	display m_l_2
	test civiceduc = hotline
	scalar define t1_l_2=r(p)
	display t1_l_2
	test civiceduc = verdade
	scalar define t2_l_2=r(p)
	display t2_l_2
	test hotline = verdade
	scalar define t3_l_2=r(p)
	display t3_l_2
	test civiceduc hotline verdade
	scalar define t4_l_2=r(p)
	display t4_l_2

*lars bsnullpres09 $ea_all if v==1 & time==1, a(lasso)
*does not work, same as for bsturnoutpres09
global ea_lasso="count2009 schoolbuild schoolbuild_miss policesta policesta_miss electricity electricity_miss health health_miss recreation recreation_miss meetroom meetroom_miss"

	regress bsnullpres09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_3
	sum bsnullpres09 if e(sample) & control == 1
	scalar define m_l_3=r(mean)
	display m_l_3
	test civiceduc = hotline
	scalar define t1_l_3=r(p)
	display t1_l_3
	test civiceduc = verdade
	scalar define t2_l_3=r(p)
	display t2_l_3
	test hotline = verdade
	scalar define t3_l_3=r(p)
	display t3_l_3
	test civiceduc hotline verdade
	scalar define t4_l_3=r(p)
	display t4_l_3

*lars bsnullparl09 $ea_all if v==1 & time==1, a(lasso)
*does not work, same as for bsturnoutparl09
global ea_lasso="count2009 schoolbuild schoolbuild_miss electricity electricity_miss health health_miss recreation recreation_miss meetroom meetroom_miss"

	regress bsnullparl09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_4
	sum bsnullparl09 if e(sample) & control == 1
	scalar define m_l_4=r(mean)
	display m_l_4
	test civiceduc = hotline
	scalar define t1_l_4=r(p)
	display t1_l_4
	test civiceduc = verdade
	scalar define t2_l_4=r(p)
	display t2_l_4
	test hotline = verdade
	scalar define t3_l_4=r(p)
	display t3_l_4
	test civiceduc hotline verdade
	scalar define t4_l_4=r(p)
	display t4_l_4

lars bsblankpres09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 electricity electricity_miss water water_miss sewer sewer_miss health health_miss recreation recreation_miss temple temple_miss meetroom meetroom_miss road road_miss"

	regress bsblankpres09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_5
	sum bsblankpres09 if e(sample) & control == 1
	scalar define m_l_5=r(mean)
	display m_l_5
	test civiceduc = hotline
	scalar define t1_l_5=r(p)
	display t1_l_5
	test civiceduc = verdade
	scalar define t2_l_5=r(p)
	display t2_l_5
	test hotline = verdade
	scalar define t3_l_5=r(p)
	display t3_l_5
	test civiceduc hotline verdade
	scalar define t4_l_5=r(p)
	display t4_l_5

lars bsblankparl09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 electricity electricity_miss"

	regress bsblankparl09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_6
	sum bsblankparl09 if e(sample) & control == 1
	scalar define m_l_6=r(mean)
	display m_l_6
	test civiceduc = hotline
	scalar define t1_l_6=r(p)
	display t1_l_6
	test civiceduc = verdade
	scalar define t2_l_6=r(p)
	display t2_l_6
	test hotline = verdade
	scalar define t3_l_6=r(p)
	display t3_l_6
	test civiceduc hotline verdade
	scalar define t4_l_6=r(p)
	display t4_l_6

lars bsguebas09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 electricity electricity_miss health health_miss recreation recreation_miss meetroom meetroom_miss road road_miss"

	regress bsguebas09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_7
	sum bsguebas09 if e(sample) & control == 1
	scalar define m_l_7=r(mean)
	display m_l_7
	test civiceduc = hotline
	scalar define t1_l_7=r(p)
	display t1_l_7
	test civiceduc = verdade
	scalar define t2_l_7=r(p)
	display t2_l_7
	test hotline = verdade
	scalar define t3_l_7=r(p)
	display t3_l_7
	test civiceduc hotline verdade
	scalar define t4_l_7=r(p)
	display t4_l_7

lars bsdhlakama09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 schoolbuild schoolbuild_miss policesta policesta_miss electricity electricity_miss water water_miss sewer sewer_miss health health_miss recreation recreation_miss meetroom meetroom_miss"

	regress bsdhlakama09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_8
	sum bsdhlakama09 if e(sample) & control == 1
	scalar define m_l_8=r(mean)
	display m_l_8
	test civiceduc = hotline
	scalar define t1_l_8=r(p)
	display t1_l_8
	test civiceduc = verdade
	scalar define t2_l_8=r(p)
	display t2_l_8
	test hotline = verdade
	scalar define t3_l_8=r(p)
	display t3_l_8
	test civiceduc hotline verdade
	scalar define t4_l_8=r(p)
	display t4_l_8

lars bssimango09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 schoolbuild schoolbuild_miss policesta policesta_miss water water_miss sewer sewer_miss health health_miss recreation recreation_miss meetroom meetroom_miss road road_miss"

	regress bssimango09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_9
	sum bssimango09 if e(sample) & control == 1
	scalar define m_l_9=r(mean)
	display m_l_9
	test civiceduc = hotline
	scalar define t1_l_9=r(p)
	display t1_l_9
	test civiceduc = verdade
	scalar define t2_l_9=r(p)
	display t2_l_9
	test hotline = verdade
	scalar define t3_l_9=r(p)
	display t3_l_9
	test civiceduc hotline verdade
	scalar define t4_l_9=r(p)
	display t4_l_9

lars bsfrelimo09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 electricity electricity_miss sewer sewer_miss health health_miss recreation recreation_miss meetroom meetroom_miss road road_miss"

	regress bsfrelimo09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_10
	sum bsfrelimo09 if e(sample) & control == 1
	scalar define m_l_10=r(mean)
	display m_l_10
	test civiceduc = hotline
	scalar define t1_l_10=r(p)
	display t1_l_10
	test civiceduc = verdade
	scalar define t2_l_10=r(p)
	display t2_l_10
	test hotline = verdade
	scalar define t3_l_10=r(p)
	display t3_l_10
	test civiceduc hotline verdade
	scalar define t4_l_10=r(p)
	display t4_l_10

lars bsrenamo09 $ea_all if v==1 & time==1, a(lasso)
global ea_lasso="count2009 schoolbuild schoolbuild_miss policesta policesta_miss electricity electricity_miss water water_miss sewer sewer_miss health health_miss recreation recreation_miss meetroom meetroom_miss"

	regress bsrenamo09 $treat $prov $ea_lasso if v==1 & time==1
	estimates store l_11
	sum bsrenamo09 if e(sample) & control == 1
	scalar define m_l_11=r(mean)
	display m_l_11
	test civiceduc = hotline
	scalar define t1_l_11=r(p)
	display t1_l_11
	test civiceduc = verdade
	scalar define t2_l_11=r(p)
	display t2_l_11
	test hotline = verdade
	scalar define t3_l_11=r(p)
	display t3_l_11
	test civiceduc hotline verdade
	scalar define t4_l_11=r(p)
	display t4_l_11

global list1=""
global list2=""

global list1="$list1" + " l_1" + " l_2" + " l_3" + " l_4" + " l_5" + " l_6" + " l_7" + " l_8" + " l_9" + " l_10" + " l_11"
matrix define means=(m_l_1, m_l_2, m_l_3, m_l_4, m_l_5, m_l_6, m_l_7, m_l_8, m_l_9, m_l_10, m_l_11 \ t1_l_1, t1_l_2, t1_l_3, t1_l_4, t1_l_5, t1_l_6, t1_l_7, t1_l_8, t1_l_9, t1_l_10, t1_l_11 \ t2_l_1, t2_l_2, t2_l_3, t2_l_4, t2_l_5, t2_l_6, t2_l_7, t2_l_8, t2_l_9, t2_l_10, t2_l_11 \ t3_l_1, t3_l_2, t3_l_3, t3_l_4, t3_l_5, t3_l_6, t3_l_7, t3_l_8, t3_l_9, t3_l_10, t3_l_11 \ t4_l_1, t4_l_2, t4_l_3, t4_l_4, t4_l_5, t4_l_6, t4_l_7, t4_l_8, t4_l_9, t4_l_10, t4_l_11)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ballots.xml") append sheet("lasso") 
xml_tab $list2, save("outputregs_ballots.xml") append sheet("lasso stats") 
estimates clear

************************************************
*****  REGRESSIONS OF INDIVIDUAL BEHAVIOR  *****
************************************************

********************************
*****  INDIVIDUAL TURNOUT  *****
********************************

*tresp

* needs turnoutquest (original survey self-reported turnout question)
capture drop tresp
gen tresp=.
replace tresp=. if time==1 & (turnoutquest==1 | turnoutquest==2)
replace tresp=0 if time==1 & (turnoutquest==3 | turnoutquest==4)
replace tresp=1 if time==1 & turnoutquest==5

*intt

* needs turnoutquest, tintquestion (interviewer assessment question), dropselecquest (said did not vote in one of the questions after self-reported turnout question)
capture drop intt
gen intt=.
replace intt=. if time==1 & (turnoutquest==1 | turnoutquest==2)
replace intt=0 if time==1 & (turnoutquest==3 | turnoutquest==4 | (turnoutquest==5 & tintquestion==. & dropselecquest!=.))
replace intt=tintquestion if time==1 & turnoutquest==5 & tintquestion!=.
replace intt=intt/7 if time==1

*tfinger

* needs turnoutquest, tfinger1 (showed inked finger question), dropselecquest
capture drop tfinger
gen tfinger=.
replace tfinger=. if time==1 & (turnoutquest==1 | turnoutquest==2)
replace tfinger=0 if time==1 & (turnoutquest==3 | turnoutquest==4 | (turnoutquest==5 & tfinger1==. & dropselecquest!=.) | (turnoutquest==5 & tfinger1>1))
replace tfinger=1 if time==1 & turnoutquest==5 & tfinger1==1

*tseen

* needs turnoutquest, tfinger2 (survey question on inked finger is inked or duration of inked finger if not inked), dropselecquest
capture drop tseen
gen tseen=.
replace tseen=. if time==1 & (turnoutquest==1 | turnoutquest==2)
replace tseen=0 if time==1 & (turnoutquest==3 | turnoutquest==4 | (turnoutquest==5 & tfinger2==. & dropselecquest!=.) | (turnoutquest==5 & tfinger2==999) | (turnoutquest==5 & tfinger2<998))
replace tseen=1 if time==1 & turnoutquest==5 & tfinger2==998

*dayselec

* needs dayselecpost
capture drop pt_dayselec
xtile pt_dayselec = dayselecpost if time==1, nq(100)

save mozdata_aux.dta, replace

************************************************************************************************
*****  OA TABLE 8, OA TABLE 10 (PART), AND OA TABLE 11: REGRESSIONS OF INDIVIDUAL TURNOUT  *****
************************************************************************************************

global turnout1="tresp intt"
global turnout2="tfinger tseen"

global ea="post post_miss health health_miss"
global controls="sex age single divor protest com prof tea comform dom econfood house llomue chitsua living"

global list1=""
global list2=""

foreach i in $turnout1 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_tresp_2_1, m_tresp_3_1, m_intt_2_1, m_intt_3_1 \ t_tresp_2_1_1, t_tresp_3_1_1, t_intt_2_1_1, t_intt_3_1_1 \ t_tresp_2_1_2, t_tresp_3_1_2, t_intt_2_1_2, t_intt_3_1_2 \ t_tresp_2_1_3, t_tresp_3_1_3, t_intt_2_1_3, t_intt_3_1_3 \ t_tresp_2_1_4, t_tresp_3_1_4, t_intt_2_1_4, t_intt_3_1_4 \ t_tresp_2_5, t_tresp_3_5, t_intt_2_5, t_intt_3_5 \ t_tresp_2_6, t_tresp_3_6, t_intt_2_6, t_intt_3_6 \ t_tresp_2_7, t_tresp_3_7, t_intt_2_7, t_intt_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_turnoutcarta.xml") replace sheet("turnout 1") 
xml_tab $list2, save("outputregs_turnoutcarta.xml") append sheet("turnout 1 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $turnout2 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_tfinger_2_1, m_tfinger_3_1, m_tseen_2_1, m_tseen_3_1 \ t_tfinger_2_1_1, t_tfinger_3_1_1, t_tseen_2_1_1, t_tseen_3_1_1 \ t_tfinger_2_1_2, t_tfinger_3_1_2, t_tseen_2_1_2, t_tseen_3_1_2 \ t_tfinger_2_1_3, t_tfinger_3_1_3, t_tseen_2_1_3, t_tseen_3_1_3 \ t_tfinger_2_1_4, t_tfinger_3_1_4, t_tseen_2_1_4, t_tseen_3_1_4 \ t_tfinger_2_5, t_tfinger_3_5, t_tseen_2_5, t_tseen_3_5 \ t_tfinger_2_6, t_tfinger_3_6, t_tseen_2_6, t_tseen_3_6 \ t_tfinger_2_7, t_tfinger_3_7, t_tseen_2_7, t_tseen_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_turnoutcarta.xml") append sheet("turnout 2") 
xml_tab $list2, save("outputregs_turnoutcarta.xml") append sheet("turnout 2 stats") 
estimates clear

global turnout2="tseen"

global list1=""
global list2=""

foreach i in $turnout2 {

	xi: regress `i' $treat $prov i.dayselec if time==1, cluster(ea)
	estimates store `i'_0_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_0_1=r(mean)
	display m_`i'_0_1
	test civiceduc = hotline
	scalar define t_`i'_0_1_1=r(p)
	display t_`i'_0_1_1
	test civiceduc = verdade
	scalar define t_`i'_0_1_2=r(p)
	display t_`i'_0_1_2
	test hotline = verdade
	scalar define t_`i'_0_1_3=r(p)
	display t_`i'_0_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_0_1_4=r(p)
	display t_`i'_0_1_4

	regress `i' $treat $prov $ea $controls i.dayselec if time==1, cluster(ea)
	estimates store `i'_0_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_0_2=r(mean)
	display m_`i'_0_2
	test civiceduc = hotline
	scalar define t_`i'_0_2_1=r(p)
	display t_`i'_0_2_1
	test civiceduc = verdade
	scalar define t_`i'_0_2_2=r(p)
	display t_`i'_0_2_2
	test hotline = verdade
	scalar define t_`i'_0_2_3=r(p)
	display t_`i'_0_2_3
	test civiceduc hotline verdade
	scalar define t_`i'_0_2_4=r(p)
	display t_`i'_0_2_4

	regress `i' $treat $prov if time==1 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_1_1=r(mean)
	display m_`i'_1_1
	test civiceduc = hotline
	scalar define t_`i'_1_1_1=r(p)
	display t_`i'_1_1_1
	test civiceduc = verdade
	scalar define t_`i'_1_1_2=r(p)
	display t_`i'_1_1_2
	test hotline = verdade
	scalar define t_`i'_1_1_3=r(p)
	display t_`i'_1_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_1_1_4=r(p)
	display t_`i'_1_1_4

	regress `i' $treat $prov $ea $controls if time==1 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_1_2=r(mean)
	display m_`i'_1_2
	test civiceduc = hotline
	scalar define t_`i'_1_2_1=r(p)
	display t_`i'_1_2_1
	test civiceduc = verdade
	scalar define t_`i'_1_2_2=r(p)
	display t_`i'_1_2_2
	test hotline = verdade
	scalar define t_`i'_1_2_3=r(p)
	display t_`i'_1_2_3
	test civiceduc hotline verdade
	scalar define t_`i'_1_2_4=r(p)
	display t_`i'_1_2_4
	
	regress `i' $treat $prov if time==1 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov $ea $controls if time==1 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_2=r(mean)
	display m_`i'_2_2
	test civiceduc = hotline
	scalar define t_`i'_2_2_1=r(p)
	display t_`i'_2_2_1
	test civiceduc = verdade
	scalar define t_`i'_2_2_2=r(p)
	display t_`i'_2_2_2
	test hotline = verdade
	scalar define t_`i'_2_2_3=r(p)
	display t_`i'_2_2_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_2_4=r(p)
	display t_`i'_2_2_4

	global list1="$list1" + " `i'_0_1" + " `i'_0_2" + " `i'_1_1" + " `i'_1_2" + " `i'_2_1" + " `i'_2_2"	
	}

matrix define means=(m_tseen_0_1, m_tseen_0_2, m_tseen_1_1, m_tseen_1_2, m_tseen_2_1, m_tseen_2_2 \ t_tseen_0_1_1, t_tseen_0_2_1, t_tseen_1_1_1, t_tseen_1_2_1, t_tseen_2_1_1, t_tseen_2_2_1 \ t_tseen_0_1_2, t_tseen_0_2_2, t_tseen_1_1_2, t_tseen_1_2_2, t_tseen_2_1_2, t_tseen_2_2_2 \ t_tseen_0_1_3, t_tseen_0_2_3, t_tseen_1_1_3, t_tseen_1_2_3, t_tseen_2_1_3, t_tseen_2_2_3 \ t_tseen_0_1_4, t_tseen_0_2_4, t_tseen_1_1_4, t_tseen_1_2_4, t_tseen_2_1_4, t_tseen_2_2_4)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_turnoutcarta.xml") append sheet("turnout 2 rob 1") 
xml_tab $list2, save("outputregs_turnoutcarta.xml") append sheet("turnout 2 rob 1 stats") 
estimates clear

*******************************************************************************************************
*****  OA TABLES 9: BALANCE FOR SURVEY HALVES (ROBUSTNESS FOR REGRESSIONS OF INDIVIDUAL TURNOUT)  *****
*******************************************************************************************************

sort time obsid
forvalues i=1(1)1766 {
replace pt_dayselec=pt_dayselec[1766+`i'] in `i' 
}

global demo1="sex age head housen single marriedunion noschl informalschl lit prim5y sec10y"
global demo2="chang macua lomue chuabo chironga maconde"
global demo3="cathol protest muslim"
global demo4="job agric com art man assal tea puboff stud dom"
global demo5="house land cattle cel expenditure"
global demo6="netmean_dist"

*half1

foreach i in $demo1 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 1")
	estimates clear

}

foreach i in $demo2 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 1")
	estimates clear

}

foreach i in $demo3 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 1")
	estimates clear

}

foreach i in $demo4 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 1")
	estimates clear

}

foreach i in $demo5 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 1")
	estimates clear

}

foreach i in $demo6 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>0 & pt_dayselec<50, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 1")
	estimates clear

}

global list2=""
matrix define fpvalue_1=(fsex_1 \ fage_1 \ fhead_1 \ fhousen_1 \ fsingle_1 \ fmarriedunion_1 \ fnoschl_1 \ finformalschl_1 \ flit_1 \ fprim5y_1 \ fsec10y_1 \ fchang_1 \ fmacua_1 \ flomue_1 \ fchuabo_1 \ fchironga_1 \ fmaconde_1 \ fcathol_1 \ fprotest_1 \ fmuslim_1 \ fjob_1 \ fagric_1 \ fcom_1 \ fart_1 \ fman_1 \ fassal_1 \ ftea_1 \ fpuboff_1 \ fstud_1 \ fdom_1 \ fhouse_1 \ fland_1 \ fcattle_1 \ fcel_1 \ fexpenditure_1 \ fnetmean_dist_1)
matrix rownames fpvalue_1 = "sex" "age" "head" "housen" "single" "marriedunion" "noschl" "informalschl" "lit" "prim5y" "sec10y" "chang" "macua" "lomue" "chuabo" "chironga" "maconde" "cathol" "protest" "muslim" "job" "agric" "com" "art" "man" "assal" "tea" "puboff" "stud" "dom" "house" "land" "cattle" "cel" "expenditure" "netmean_dist"
matrix fpvalue= (fpvalue_1)
global list2="$list2" + " fpvalue"
xml_tab $list2, save(balance_halves.xml) append sheet("fpvalue demo 1") 
estimates clear

*half2

foreach i in $demo1 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 2")
	estimates clear

}

foreach i in $demo2 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 2")
	estimates clear

}

foreach i in $demo3 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 2")
	estimates clear

}

foreach i in $demo4 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 2")
	estimates clear

}

foreach i in $demo5 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 2")
	estimates clear

}

foreach i in $demo6 {

	global list1=""

	regress `i' civiceduc if time==0 & hotline==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_1
	regress `i' hotline if time==0 & civiceduc==0 & verdade==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_2
	regress `i' verdade if time==0 & civiceduc==0 & hotline==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	estimates store `i'_3
	regress `i' civiceduc hotline verdade if time==0 & pt_dayselec>=50 & pt_dayselec<=100, cluster(ea)
	test civiceduc hotline verdade
	scalar define f`i'_1=r(p)
	display f`i'_1

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"
	xml_tab $list1, below save(balance_halves.xml) append sheet("bal `i' 2")
	estimates clear

}

global list2=""
matrix define fpvalue_1=(fsex_1 \ fage_1 \ fhead_1 \ fhousen_1 \ fsingle_1 \ fmarriedunion_1 \ fnoschl_1 \ finformalschl_1 \ flit_1 \ fprim5y_1 \ fsec10y_1 \ fchang_1 \ fmacua_1 \ flomue_1 \ fchuabo_1 \ fchironga_1 \ fmaconde_1 \ fcathol_1 \ fprotest_1 \ fmuslim_1 \ fjob_1 \ fagric_1 \ fcom_1 \ fart_1 \ fman_1 \ fassal_1 \ ftea_1 \ fpuboff_1 \ fstud_1 \ fdom_1 \ fhouse_1 \ fland_1 \ fcattle_1 \ fcel_1 \ fexpenditure_1 \ fnetmean_dist_1)
matrix rownames fpvalue_1 = "sex" "age" "head" "housen" "single" "marriedunion" "noschl" "informalschl" "lit" "prim5y" "sec10y" "chang" "macua" "lomue" "chuabo" "chironga" "maconde" "cathol" "protest" "muslim" "job" "agric" "com" "art" "man" "assal" "tea" "puboff" "stud" "dom" "house" "land" "cattle" "cel" "expenditure" "netmean_dist"
matrix fpvalue= (fpvalue_1)
global list2="$list2" + " fpvalue"
xml_tab $list2, save(balance_halves.xml) append sheet("fpvalue demo 2") 
estimates clear

************************************************************************
*****  TABLE 2 AND OA TABLE 10 (PART): REGRESSIONS OF OPEN LETTER  *****
************************************************************************

global carta="carta"

global ea="market market_miss"
global controls="sex age divor school protest relig com tea econfood econmedic chitsua"

global list1=""
global list2=""

foreach i in $carta {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2" + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_carta_2_1, m_carta_3_1 \ t_carta_2_1_1, t_carta_3_1_1 \ t_carta_2_1_2, t_carta_3_1_2 \ t_carta_2_1_3, t_carta_3_1_3 \ t_carta_2_1_4, t_carta_3_1_4 \ t_carta_2_5, t_carta_3_5 \ t_carta_2_6, t_carta_3_6 \ t_carta_2_7, t_carta_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_turnoutcarta.xml") append sheet("carta") 
xml_tab $list2, save("outputregs_turnoutcarta.xml") append sheet("carta stats") 
estimates clear

***********************************************************
*****  OA TABLE 12: REGRESSIONS OF INDIVIDUAL VOTING  *****
***********************************************************

global voting1="guebas2"
global voting2="dlakhama2"
global voting3="simango2"
global voting4="frelimo2"
global voting5="renamo2"

global ea="post post_miss health health_miss police police_miss"
global controls="sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living"

global list1=""
global list2=""

foreach i in $voting1 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1, cluster(ea)
	estimates store `i'_4_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_4_1=r(mean)
	display m_`i'_4_1
	test civiceduc = hotline
	scalar define t_`i'_4_1_1=r(p)
	display t_`i'_4_1_1
	test civiceduc = verdade
	scalar define t_`i'_4_1_2=r(p)
	display t_`i'_4_1_2
	test hotline = verdade
	scalar define t_`i'_4_1_3=r(p)
	display t_`i'_4_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_4_1_4=r(p)
	display t_`i'_4_1_4

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0, cluster(ea)
	estimates store `i'_4_2
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0
	estimates store `i'_4_2a
	
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_4_3
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1)
	estimates store `i'_4_3a

	suest `i'_4_2a `i'_4_3a, cluster(ea)
	test [`i'_4_2a_mean]civiceduc=[`i'_4_3a_mean]civiceduc	
	scalar define t_`i'_4_5=r(p)
	display t_`i'_4_5
	test [`i'_4_2a_mean]hotline=[`i'_4_3a_mean]hotline	
	scalar define t_`i'_4_6=r(p)
	display t_`i'_4_6
	test [`i'_4_2a_mean]verdade=[`i'_4_3a_mean]verdade
	scalar define t_`i'_4_7=r(p)
	display t_`i'_4_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_4_1" + " `i'_2_2" + " `i'_3_2" + " `i'_4_2"  + " `i'_2_3" + " `i'_3_3" + " `i'_4_3"
	
	}

matrix define means=(m_guebas2_2_1, m_guebas2_3_1, m_guebas2_4_1 \ t_guebas2_2_1_1, t_guebas2_3_1_1, t_guebas2_4_1_1 \ t_guebas2_2_1_2, t_guebas2_3_1_2, t_guebas2_4_1_2 \ t_guebas2_2_1_3, t_guebas2_3_1_3, t_guebas2_4_1_3 \ t_guebas2_2_1_4, t_guebas2_3_1_4, t_guebas2_4_1_4 \ t_guebas2_2_5, t_guebas2_3_5, t_guebas2_4_5 \ t_guebas2_2_6, t_guebas2_3_6, t_guebas2_4_6 \ t_guebas2_2_7, t_guebas2_3_7, t_guebas2_4_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_voting.xml") replace sheet("voting 1") 
xml_tab $list2, save("outputregs_voting.xml") append sheet("voting 1 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $voting2 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1, cluster(ea)
	estimates store `i'_4_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_4_1=r(mean)
	display m_`i'_4_1
	test civiceduc = hotline
	scalar define t_`i'_4_1_1=r(p)
	display t_`i'_4_1_1
	test civiceduc = verdade
	scalar define t_`i'_4_1_2=r(p)
	display t_`i'_4_1_2
	test hotline = verdade
	scalar define t_`i'_4_1_3=r(p)
	display t_`i'_4_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_4_1_4=r(p)
	display t_`i'_4_1_4

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0, cluster(ea)
	estimates store `i'_4_2
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0
	estimates store `i'_4_2a
	
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_4_3
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1)
	estimates store `i'_4_3a

	suest `i'_4_2a `i'_4_3a, cluster(ea)
	test [`i'_4_2a_mean]civiceduc=[`i'_4_3a_mean]civiceduc	
	scalar define t_`i'_4_5=r(p)
	display t_`i'_4_5
	test [`i'_4_2a_mean]hotline=[`i'_4_3a_mean]hotline	
	scalar define t_`i'_4_6=r(p)
	display t_`i'_4_6
	test [`i'_4_2a_mean]verdade=[`i'_4_3a_mean]verdade
	scalar define t_`i'_4_7=r(p)
	display t_`i'_4_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_4_1" + " `i'_2_2" + " `i'_3_2" + " `i'_4_2"  + " `i'_2_3" + " `i'_3_3" + " `i'_4_3"
	
	}

matrix define means=(m_dlakhama2_2_1, m_dlakhama2_3_1, m_dlakhama2_4_1 \ t_dlakhama2_2_1_1, t_dlakhama2_3_1_1, t_dlakhama2_4_1_1 \ t_dlakhama2_2_1_2, t_dlakhama2_3_1_2, t_dlakhama2_4_1_2 \ t_dlakhama2_2_1_3, t_dlakhama2_3_1_3, t_dlakhama2_4_1_3 \ t_dlakhama2_2_1_4, t_dlakhama2_3_1_4, t_dlakhama2_4_1_4 \ t_dlakhama2_2_5, t_dlakhama2_3_5, t_dlakhama2_4_5 \ t_dlakhama2_2_6, t_dlakhama2_3_6, t_dlakhama2_4_6 \ t_dlakhama2_2_7, t_dlakhama2_3_7, t_dlakhama2_4_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_voting.xml") append sheet("voting 2") 
xml_tab $list2, save("outputregs_voting.xml") append sheet("voting 2 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $voting3 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1, cluster(ea)
	estimates store `i'_4_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_4_1=r(mean)
	display m_`i'_4_1
	test civiceduc = hotline
	scalar define t_`i'_4_1_1=r(p)
	display t_`i'_4_1_1
	test civiceduc = verdade
	scalar define t_`i'_4_1_2=r(p)
	display t_`i'_4_1_2
	test hotline = verdade
	scalar define t_`i'_4_1_3=r(p)
	display t_`i'_4_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_4_1_4=r(p)
	display t_`i'_4_1_4

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0, cluster(ea)
	estimates store `i'_4_2
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0
	estimates store `i'_4_2a
	
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_4_3
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1)
	estimates store `i'_4_3a

	suest `i'_4_2a `i'_4_3a, cluster(ea)
	test [`i'_4_2a_mean]civiceduc=[`i'_4_3a_mean]civiceduc	
	scalar define t_`i'_4_5=r(p)
	display t_`i'_4_5
	test [`i'_4_2a_mean]hotline=[`i'_4_3a_mean]hotline	
	scalar define t_`i'_4_6=r(p)
	display t_`i'_4_6
	test [`i'_4_2a_mean]verdade=[`i'_4_3a_mean]verdade
	scalar define t_`i'_4_7=r(p)
	display t_`i'_4_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_4_1" + " `i'_2_2" + " `i'_3_2" + " `i'_4_2"  + " `i'_2_3" + " `i'_3_3" + " `i'_4_3"
	
	}

matrix define means=(m_simango2_2_1, m_simango2_3_1, m_simango2_4_1 \ t_simango2_2_1_1, t_simango2_3_1_1, t_simango2_4_1_1 \ t_simango2_2_1_2, t_simango2_3_1_2, t_simango2_4_1_2 \ t_simango2_2_1_3, t_simango2_3_1_3, t_simango2_4_1_3 \ t_simango2_2_1_4, t_simango2_3_1_4, t_simango2_4_1_4 \ t_simango2_2_5, t_simango2_3_5, t_simango2_4_5 \ t_simango2_2_6, t_simango2_3_6, t_simango2_4_6 \ t_simango2_2_7, t_simango2_3_7, t_simango2_4_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_voting.xml") append sheet("voting 3") 
xml_tab $list2, save("outputregs_voting.xml") append sheet("voting 3 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $voting4 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1, cluster(ea)
	estimates store `i'_4_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_4_1=r(mean)
	display m_`i'_4_1
	test civiceduc = hotline
	scalar define t_`i'_4_1_1=r(p)
	display t_`i'_4_1_1
	test civiceduc = verdade
	scalar define t_`i'_4_1_2=r(p)
	display t_`i'_4_1_2
	test hotline = verdade
	scalar define t_`i'_4_1_3=r(p)
	display t_`i'_4_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_4_1_4=r(p)
	display t_`i'_4_1_4

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0, cluster(ea)
	estimates store `i'_4_2
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0
	estimates store `i'_4_2a
	
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_4_3
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1)
	estimates store `i'_4_3a

	suest `i'_4_2a `i'_4_3a, cluster(ea)
	test [`i'_4_2a_mean]civiceduc=[`i'_4_3a_mean]civiceduc	
	scalar define t_`i'_4_5=r(p)
	display t_`i'_4_5
	test [`i'_4_2a_mean]hotline=[`i'_4_3a_mean]hotline	
	scalar define t_`i'_4_6=r(p)
	display t_`i'_4_6
	test [`i'_4_2a_mean]verdade=[`i'_4_3a_mean]verdade
	scalar define t_`i'_4_7=r(p)
	display t_`i'_4_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_4_1" + " `i'_2_2" + " `i'_3_2" + " `i'_4_2"  + " `i'_2_3" + " `i'_3_3" + " `i'_4_3"
		
	}

matrix define means=(m_frelimo2_2_1, m_frelimo2_3_1, m_frelimo2_4_1 \ t_frelimo2_2_1_1, t_frelimo2_3_1_1, t_frelimo2_4_1_1 \ t_frelimo2_2_1_2, t_frelimo2_3_1_2, t_frelimo2_4_1_2 \ t_frelimo2_2_1_3, t_frelimo2_3_1_3, t_frelimo2_4_1_3 \ t_frelimo2_2_1_4, t_frelimo2_3_1_4, t_frelimo2_4_1_4 \ t_frelimo2_2_5, t_frelimo2_3_5, t_frelimo2_4_5 \ t_frelimo2_2_6, t_frelimo2_3_6, t_frelimo2_4_6 \ t_frelimo2_2_7, t_frelimo2_3_7, t_frelimo2_4_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_voting.xml") append sheet("voting 4") 
xml_tab $list2, save("outputregs_voting.xml") append sheet("voting 4 stats") 
estimates clear

global list1=""
global list2=""

foreach i in $voting5 {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1, cluster(ea)
	estimates store `i'_4_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_4_1=r(mean)
	display m_`i'_4_1
	test civiceduc = hotline
	scalar define t_`i'_4_1_1=r(p)
	display t_`i'_4_1_1
	test civiceduc = verdade
	scalar define t_`i'_4_1_2=r(p)
	display t_`i'_4_1_2
	test hotline = verdade
	scalar define t_`i'_4_1_3=r(p)
	display t_`i'_4_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_4_1_4=r(p)
	display t_`i'_4_1_4

	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0, cluster(ea)
	estimates store `i'_4_2
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & lazy==0
	estimates store `i'_4_2a
	
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_4_3
	xi: regress `i' $treat $prov $ea $controls i.interviewer if time==1 & (lazy==1|control==1)
	estimates store `i'_4_3a

	suest `i'_4_2a `i'_4_3a, cluster(ea)
	test [`i'_4_2a_mean]civiceduc=[`i'_4_3a_mean]civiceduc	
	scalar define t_`i'_4_5=r(p)
	display t_`i'_4_5
	test [`i'_4_2a_mean]hotline=[`i'_4_3a_mean]hotline	
	scalar define t_`i'_4_6=r(p)
	display t_`i'_4_6
	test [`i'_4_2a_mean]verdade=[`i'_4_3a_mean]verdade
	scalar define t_`i'_4_7=r(p)
	display t_`i'_4_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_4_1" + " `i'_2_2" + " `i'_3_2" + " `i'_4_2"  + " `i'_2_3" + " `i'_3_3" + " `i'_4_3"
		
	}

matrix define means=(m_renamo2_2_1, m_renamo2_3_1, m_renamo2_4_1 \ t_renamo2_2_1_1, t_renamo2_3_1_1, t_renamo2_4_1_1 \ t_renamo2_2_1_2, t_renamo2_3_1_2, t_renamo2_4_1_2 \ t_renamo2_2_1_3, t_renamo2_3_1_3, t_renamo2_4_1_3 \ t_renamo2_2_1_4, t_renamo2_3_1_4, t_renamo2_4_1_4 \ t_renamo2_2_5, t_renamo2_3_5, t_renamo2_4_5 \ t_renamo2_2_6, t_renamo2_3_6, t_renamo2_4_6 \ t_renamo2_2_7, t_renamo2_3_7, t_renamo2_4_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_voting.xml") append sheet("voting 5") 
xml_tab $list2, save("outputregs_voting.xml") append sheet("voting 5 stats") 
estimates clear

*******************************************************************
*****  TABLE 3: REGRESSIONS OF ELECTORAL PROBLEMS - EA LEVEL  *****
*******************************************************************

global out1="serious_inc serious_int"
global out2="eday_inc camp_inc viol_inc"

global ea="count2009 policesta policesta_miss sewer sewer_miss recreation recreation_miss road road_miss"

global list1=""
global list2=""

foreach i in $out1 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2
	
	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_serious_inc_2, m_serious_inc_3, m_serious_int_2, m_serious_int_3 \ t1_serious_inc_2, t1_serious_inc_3, t1_serious_int_2, t1_serious_int_3 \ t2_serious_inc_2, t2_serious_inc_3, t2_serious_int_2, t2_serious_int_3 \ t3_serious_inc_2, t3_serious_inc_3, t3_serious_int_2, t3_serious_int_3 \ t4_serious_inc_2, t4_serious_inc_3, t4_serious_int_2, t4_serious_int_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_problems.xml") replace sheet("anyprob") 
xml_tab $list2, save("outputregs_problems.xml") append sheet("anyprob stats") 
estimates clear

global list1=""
global list2=""

foreach i in $out2 {

	regress `i' $treat $prov if v==1 & time==1
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	test civiceduc = hotline
	scalar define t1_`i'_2=r(p)
	display t1_`i'_2
	test civiceduc = verdade
	scalar define t2_`i'_2=r(p)
	display t2_`i'_2
	test hotline = verdade
	scalar define t3_`i'_2=r(p)
	display t3_`i'_2
	test civiceduc hotline verdade
	scalar define t4_`i'_2=r(p)
	display t4_`i'_2
	
	regress `i' $treat $prov $ea if v==1 & time==1
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3
	test civiceduc = hotline
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test civiceduc = verdade
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test hotline = verdade
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test civiceduc hotline verdade
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_eday_inc_2, m_eday_inc_3, m_camp_inc_2, m_camp_inc_3, m_viol_inc_2, m_viol_inc_3 \ t1_eday_inc_2, t1_eday_inc_3, t1_camp_inc_2, t1_camp_inc_3, t1_viol_inc_2, t1_viol_inc_3 \ t2_eday_inc_2, t2_eday_inc_3, t2_camp_inc_2, t2_camp_inc_3, t2_viol_inc_2, t2_viol_inc_3 \ t3_eday_inc_2, t3_eday_inc_3, t3_camp_inc_2, t3_camp_inc_3, t3_viol_inc_2, t3_viol_inc_3 \ t4_eday_inc_2, t4_eday_inc_3, t4_camp_inc_2, t4_camp_inc_3, t4_viol_inc_2, t4_viol_inc_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_problems.xml") append sheet("specprob") 
xml_tab $list2, save("outputregs_problems.xml") append sheet("specprob stats") 
estimates clear

***************************************************************************************
*****  TABLES 4 AND OA TABLE 10 (PART): REGRESSIONS OF MEDIATOR SURVEY OUTCOMES  *****
***************************************************************************************

global ea="post post_miss health health_miss"
global controls="sex age single divor protest com prof tea comform dom econfood house llomue chitsua living"

*info

global final="zzscinfo"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zzscinfo_2_1, m_zzscinfo_3_1 \ t_zzscinfo_2_1_1, t_zzscinfo_3_1_1 \ t_zzscinfo_2_1_2, t_zzscinfo_3_1_2 \ t_zzscinfo_2_1_3, t_zzscinfo_3_1_3 \ t_zzscinfo_2_1_4, t_zzscinfo_3_1_4 \ t_zzscinfo_2_5, t_zzscinfo_3_5 \ t_zzscinfo_2_6, t_zzscinfo_3_6 \ t_zzscinfo_2_7, t_zzscinfo_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("info") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("info stats") 
estimates clear

*trustcne

global final="zsctrustcne"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zsctrustcne_2_1, m_zsctrustcne_3_1 \ t_zsctrustcne_2_1_1, t_zsctrustcne_3_1_1 \ t_zsctrustcne_2_1_2, t_zsctrustcne_3_1_2 \ t_zsctrustcne_2_1_3, t_zsctrustcne_3_1_3 \ t_zsctrustcne_2_1_4, t_zsctrustcne_3_1_4 \ t_zsctrustcne_2_5, t_zsctrustcne_3_5 \ t_zsctrustcne_2_6, t_zsctrustcne_3_6 \ t_zsctrustcne_2_7, t_zsctrustcne_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("trustcne") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("trustcne stats") 
estimates clear

*indepcne

global final="zscindepcne"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zscindepcne_2_1, m_zscindepcne_3_1 \ t_zscindepcne_2_1_1, t_zscindepcne_3_1_1 \ t_zscindepcne_2_1_2, t_zscindepcne_3_1_2 \ t_zscindepcne_2_1_3, t_zscindepcne_3_1_3 \ t_zscindepcne_2_1_4, t_zscindepcne_3_1_4 \ t_zscindepcne_2_5, t_zscindepcne_3_5 \ t_zscindepcne_2_6, t_zscindepcne_3_6 \ t_zscindepcne_2_7, t_zscindepcne_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("indepcne") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("indepcne stats") 
estimates clear

*confusion

global final="zzscconfusion"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zzscconfusion_2_1, m_zzscconfusion_3_1 \ t_zzscconfusion_2_1_1, t_zzscconfusion_3_1_1 \ t_zzscconfusion_2_1_2, t_zzscconfusion_3_1_2 \ t_zzscconfusion_2_1_3, t_zzscconfusion_3_1_3 \ t_zzscconfusion_2_1_4, t_zzscconfusion_3_1_4 \ t_zzscconfusion_2_5, t_zzscconfusion_3_5 \ t_zzscconfusion_2_6, t_zzscconfusion_3_6 \ t_zzscconfusion_2_7, t_zzscconfusion_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("confusion") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("confusion stats") 
estimates clear

*freefair2009

global final="zscfreefair2009"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zscfreefair2009_2_1, m_zscfreefair2009_3_1 \ t_zscfreefair2009_2_1_1, t_zscfreefair2009_3_1_1 \ t_zscfreefair2009_2_1_2, t_zscfreefair2009_3_1_2 \ t_zscfreefair2009_2_1_3, t_zscfreefair2009_3_1_3 \ t_zscfreefair2009_2_1_4, t_zscfreefair2009_3_1_4 \ t_zscfreefair2009_2_5, t_zscfreefair2009_3_5 \ t_zscfreefair2009_2_6, t_zscfreefair2009_3_6 \ t_zscfreefair2009_2_7, t_zscfreefair2009_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("freefair2009") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("freefair2009 stats") 
estimates clear

*vcount2009

global final="zscvcount2009"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zscvcount2009_2_1, m_zscvcount2009_3_1 \ t_zscvcount2009_2_1_1, t_zscvcount2009_3_1_1 \ t_zscvcount2009_2_1_2, t_zscvcount2009_3_1_2 \ t_zscvcount2009_2_1_3, t_zscvcount2009_3_1_3 \ t_zscvcount2009_2_1_4, t_zscvcount2009_3_1_4 \ t_zscvcount2009_2_5, t_zscvcount2009_3_5 \ t_zscvcount2009_2_6, t_zscvcount2009_3_6 \ t_zscvcount2009_2_7, t_zscvcount2009_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("vcount2009") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("vcount2009 stats") 
estimates clear

*votbuying

global final="zzscvotbuying"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zzscvotbuying_2_1, m_zzscvotbuying_3_1 \ t_zzscvotbuying_2_1_1, t_zzscvotbuying_3_1_1 \ t_zzscvotbuying_2_1_2, t_zzscvotbuying_3_1_2 \ t_zzscvotbuying_2_1_3, t_zzscvotbuying_3_1_3 \ t_zzscvotbuying_2_1_4, t_zzscvotbuying_3_1_4 \ t_zzscvotbuying_2_5, t_zzscvotbuying_3_5 \ t_zzscvotbuying_2_6, t_zzscvotbuying_3_6 \ t_zzscvotbuying_2_7, t_zzscvotbuying_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("votbuying") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("votbuying stats") 
estimates clear

*violence

global final="zzscviolence"

global list1=""
global list2=""

foreach i in $final {

	regress `i' $treat $prov if time==1, cluster(ea)
	estimates store `i'_2_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2_1=r(mean)
	display m_`i'_2_1
	test civiceduc = hotline
	scalar define t_`i'_2_1_1=r(p)
	display t_`i'_2_1_1
	test civiceduc = verdade
	scalar define t_`i'_2_1_2=r(p)
	display t_`i'_2_1_2
	test hotline = verdade
	scalar define t_`i'_2_1_3=r(p)
	display t_`i'_2_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_2_1_4=r(p)
	display t_`i'_2_1_4

	regress `i' $treat $prov if time==1 & lazy==0, cluster(ea)
	estimates store `i'_2_2
	regress `i' $treat $prov if time==1 & lazy==0
	estimates store `i'_2_2a
	
	regress `i' $treat $prov if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_2_3
	regress `i' $treat $prov if time==1 & (lazy==1|control==1)
	estimates store `i'_2_3a

	suest `i'_2_2a `i'_2_3a, cluster(ea)
	test [`i'_2_2a_mean]civiceduc=[`i'_2_3a_mean]civiceduc	
	scalar define t_`i'_2_5=r(p)
	display t_`i'_2_5
	test [`i'_2_2a_mean]hotline=[`i'_2_3a_mean]hotline	
	scalar define t_`i'_2_6=r(p)
	display t_`i'_2_6
	test [`i'_2_2a_mean]verdade=[`i'_2_3a_mean]verdade
	scalar define t_`i'_2_7=r(p)
	display t_`i'_2_7

	regress `i' $treat $prov $ea $controls if time==1, cluster(ea)
	estimates store `i'_3_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3_1=r(mean)
	display m_`i'_3_1
	test civiceduc = hotline
	scalar define t_`i'_3_1_1=r(p)
	display t_`i'_3_1_1
	test civiceduc = verdade
	scalar define t_`i'_3_1_2=r(p)
	display t_`i'_3_1_2
	test hotline = verdade
	scalar define t_`i'_3_1_3=r(p)
	display t_`i'_3_1_3
	test civiceduc hotline verdade
	scalar define t_`i'_3_1_4=r(p)
	display t_`i'_3_1_4

	regress `i' $treat $prov $ea $controls if time==1 & lazy==0, cluster(ea)
	estimates store `i'_3_2
	regress `i' $treat $prov $ea $controls if time==1 & lazy==0
	estimates store `i'_3_2a
	
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1), cluster(ea)
	estimates store `i'_3_3
	regress `i' $treat $prov $ea $controls if time==1 & (lazy==1|control==1)
	estimates store `i'_3_3a

	suest `i'_3_2a `i'_3_3a, cluster(ea)
	test [`i'_3_2a_mean]civiceduc=[`i'_3_3a_mean]civiceduc	
	scalar define t_`i'_3_5=r(p)
	display t_`i'_3_5
	test [`i'_3_2a_mean]hotline=[`i'_3_3a_mean]hotline	
	scalar define t_`i'_3_6=r(p)
	display t_`i'_3_6
	test [`i'_3_2a_mean]verdade=[`i'_3_3a_mean]verdade
	scalar define t_`i'_3_7=r(p)
	display t_`i'_3_7
	
	global list1="$list1" + " `i'_2_1" + " `i'_3_1" + " `i'_2_2" + " `i'_3_2"  + " `i'_2_3" + " `i'_3_3"
	
	}

matrix define means=(m_zzscviolence_2_1, m_zzscviolence_3_1 \ t_zzscviolence_2_1_1, t_zzscviolence_3_1_1 \ t_zzscviolence_2_1_2, t_zzscviolence_3_1_2 \ t_zzscviolence_2_1_3, t_zzscviolence_3_1_3 \ t_zzscviolence_2_1_4, t_zzscviolence_3_1_4 \ t_zzscviolence_2_5, t_zzscviolence_3_5 \ t_zzscviolence_2_6, t_zzscviolence_3_6 \ t_zzscviolence_2_7, t_zzscviolence_3_7)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_survey.xml") append sheet("violence") 
xml_tab $list2, save("outputregs_survey.xml") append sheet("violence stats") 
estimates clear

***********************************
*****  OA TABLE 7: AB CHECKS  *****
***********************************

clear all
set more off

*R3

use moz_r3_data.dta, replace

*province

gen ourprov=0
replace ourprov=1 if REGION==300 | REGION==302 | REGION==307 | REGION==310
tab REGION if ourprov==1

*district

encode DISTRICT, gen(dist)
tab dist

*ea

egen ea_full=concat(URBRUR dist)
encode ea_full, gen(ea)
drop ea_full
tab ea

*gender

gen gender=CURRINT
replace gender=0 if CURRINT==2
sum gender

*age

gen age=Q1
replace age=. if age==998 | age==999 | age==-1
sum age
gen midage=1
replace midage=0 if age<30 | age>50
replace midage=. if age==.
sum midage

*hhead

gen hhead=Q2
replace hhead=. if hhead==9 | hhead==998 | hhead==-1
sum hhead

*celluse N/A

*education (0-9)

gen educ=Q90
replace educ=. if Q90==99 | Q90==998 | Q90==-1
sum educ

*property

gen book=Q93A
replace book=. if Q93A==9 | Q93A==998 | Q93A==-1
sum book

gen radio=Q93B
replace radio=. if Q93B==9 | Q93B==998 | Q93B==-1
sum radio

gen tv=Q93C
replace tv=. if Q93C==9 | Q93C==998 | Q93C==-1
sum tv

gen bike=Q93D
replace bike=. if Q93D==9 | Q93D==998 | Q93D==-1
sum bike

gen mbike=Q93E
replace mbike=. if Q93E==9 | Q93E==998 | Q93E==-1
sum mbike

gen motor=Q93F
replace motor=. if Q93F==9 | Q93F==998 | Q93F==-1
sum motor

*job

gen job=.
replace job=1 if Q94==2 | Q94==3 | Q94==4 | Q94==5
replace job=0 if Q94==0 | Q94==1
sum job

*interest (0-3)

gen interest=Q16
replace interest=. if interest==9 | interest==998 | interest==-1
sum interest

*turnout04

gen turnout=0
replace turnout=1 if Q30==1
replace turnout=. if Q30==. | Q30==9 | Q30==998 | Q30==-1
sum turnout

keep ourprov DISTRICT ea gender age midage hhead educ radio tv mbike motor job interest turnout

gen celluse=.

replace motor=1 if mbike==1
drop mbike

label drop ea

save moz_r3_data_r, replace

*R4

use moz_r4_data.dta, replace

*province

capture gen ourprov=0
replace ourprov=1 if REGION==540 | REGION==542 | REGION==547 | REGION==550
tab REGION if ourprov==1

*district

encode DISTRICT, gen(dist)
tab dist

*ea

gen ea=EANUMB_AB
tab ea

*gender

gen gender=THISINT
replace gender=0 if THISINT==2
sum gender

*age

gen age=Q1
replace age=. if age==999
sum age
gen midage=1
replace midage=0 if age<30 | age>50
replace midage=. if age==.
sum midage

*hhead

gen hhead=Q2
replace hhead=. if hhead==9 | hhead==-1
sum hhead

*celluse

capture drop celluse
gen celluse=0
replace celluse=1 if Q88A>2
replace celluse=. if Q88A==9
sum celluse

*education (0-9)

gen educ=Q89
replace educ=. if Q89==99 | Q89==998 | Q89==-1
tab educ

*property

gen radio=Q92A
replace radio=. if Q92A==9 | Q92A==998 | Q92A==-1
sum radio

gen tv=Q92B
replace tv=. if Q92B==9 | Q92B==998 | Q92B==-1
sum tv

gen motor=Q92C
replace motor=. if Q92C==9 | Q92C==998 | Q92C==-1
sum motor

*job

gen job=.
replace job=1 if Q94==2 | Q94==3 | Q94==4 | Q94==5
replace job=0 if Q94==0 | Q94==1
sum job

*interest (0-3)

gen interest=Q13
replace interest=. if interest==9
tab interest

*turnout04

gen turnout=0
replace turnout=1 if Q23D==1
replace turnout=. if Q23D==-1 | Q23D==0 | Q23D==9
sum turnout

keep ourprov DISTRICT ea gender age midage hhead celluse educ radio tv motor job interest turnout

replace ea=ea+1000

save moz_r4_data_r, replace

*R5

use moz_r5_data.dta, replace

*province

gen ourprov=0
replace ourprov=1 if REGION==540 | REGION==542 | REGION==547 | REGION==549
tab REGION if ourprov==1

*district

encode DISTRICT, gen(dist)
tab dist

*ea

egen ea_full=concat(dist EA_SVC_A EA_SVC_B EA_SVC_C EA_SVC_D EA_FAC_A EA_FAC_B EA_FAC_C EA_FAC_D EA_FAC_E EA_SEC_A EA_SEC_B EA_SEC_C EA_SEC_D EA_SEC_E EA_ROAD)
encode ea_full, gen (ea)
drop ea_full
tab ea

*gender

gen gender=THISINT
replace gender=0 if THISINT==2
sum gender

*age

gen age=Q1
replace age=. if age==999
sum age
gen midage=1
replace midage=0 if age<30 | age>50
replace midage=. if age==.
sum midage

*hhead N/A

*celluse

capture drop celluse
gen celluse=0
replace celluse=1 if Q92>0
replace celluse=. if Q92==9
replace celluse=0 if celluse!=0 & Q93A==0 & Q93B==0 & Q93C==0
sum celluse

*education (0-9)

gen educ=Q97
replace educ=. if Q97==99 | Q97==998 | Q97==-1
tab educ

*property

gen radio=Q90A
replace radio=. if Q90A==9 | Q90A==998 | Q90A==-1
sum radio

gen tv=Q90B
replace tv=. if Q90B==9 | Q90B==998 | Q90B==-1
sum tv

gen motor=Q90C
replace motor=. if Q90C==9 | Q90C==998 | Q90C==-1
sum motor

*job

gen job=.
replace job=1 if Q96==2 | Q96==3
replace job=0 if Q96==0 | Q96==1
tab job

*interest (0-3)

gen interest=Q14
replace interest=. if interest==9 | interest==-1
tab interest

*turnout09

gen turnout=0
replace turnout=1 if Q27==1
replace turnout=. if Q27==8 | Q27==0 | Q27==6 | Q27==9
sum turnout

keep ourprov DISTRICT ea gender age midage celluse educ radio tv motor job interest turnout

gen hhead=.

label drop ea

replace ea=ea+2000

save moz_r5_data_r, replace

*join datasets

use moz_r3_data_r, replace

numlabel ,add

gen round=3

append using moz_r4_data_r

replace round=4 if round==.

append using moz_r5_data_r

replace round=5 if round==.

replace DISTRICT=strupper(DISTRICT)

replace DISTRICT="ALTO MOLOCUE" if DISTRICT=="ALTO-MOLOCUE"
replace DISTRICT="ALTO MOLOCUE" if DISTRICT=="ALTO MOLOCUÃ©"
replace DISTRICT="CHIUTA" if DISTRICT=="CHIÃºTA"
replace DISTRICT="DISTRITO URBANO 1" if DISTRICT=="D. URBANO Nº 1"
replace DISTRICT="DISTRITO URBANO 4" if DISTRICT=="D. URBANO Nº 4"
replace DISTRICT="DISTRITO URBANO 5" if DISTRICT=="D. URBANO Nº 5"
replace DISTRICT="DISTRITO URBANO 2" if DISTRICT=="D.URB Nº2"
replace DISTRICT="DISTRITO URBANO 3" if DISTRICT=="D.URB.Nº3"
replace DISTRICT="DISTRITO URBANO 3" if DISTRICT=="DISTRITO URBANO N 3"
replace DISTRICT="DISTRITO URBANO 4" if DISTRICT=="DISTRITO URBANO N 4"
replace DISTRICT="DISTRITO URBANO 5" if DISTRICT=="DISTRITO URBANO N 5"
replace DISTRICT="ILHA DE MOCAMBIQUE" if DISTRICT=="ILHA DE MOÇAMBIQUE"
replace DISTRICT="CIDADE DE INHAMBANE" if DISTRICT=="INHAMBANE CITY"
replace DISTRICT="MANHICA" if DISTRICT=="MANHIÇA"
replace DISTRICT="CIDADE DA MATOLA" if DISTRICT=="MATOLA"
replace DISTRICT="CIDADE DA MATOLA" if DISTRICT=="MATOLA CIDADE"
replace DISTRICT="CIDADE DA MATOLA" if DISTRICT=="MATOLA CITY"
replace DISTRICT="CIDADE DA MAXIXE" if DISTRICT=="MAXIXE"
replace DISTRICT="MOCIMBOA DA PRAIA" if DISTRICT=="MOCÍMBOA DA PRAIA"
replace DISTRICT="MOSSURIZE" if DISTRICT=="MUSSURIZE"
replace DISTRICT="NACALA PORTO" if DISTRICT=="NACALA - PORTO"
replace DISTRICT="CIDADE DE NAMPULA" if DISTRICT=="NAMPULA"
replace DISTRICT="CIDADE DE PEMBA" if DISTRICT=="PEMBA CIDADE"
replace DISTRICT="CIDADE DE QUELIMANE" if DISTRICT=="QUELIMANE"
replace DISTRICT="CIDADE DE TETE" if DISTRICT=="TETE"
replace DISTRICT="CIDADE DE TETE" if DISTRICT=="TETE CIDADE"
replace DISTRICT="VILANCULOS" if DISTRICT=="VILANKULO"
replace DISTRICT="CIDADE DE XAI-XAI" if DISTRICT=="XAI-XAI"

encode DISTRICT, gen(dist)
tab dist

*regs

gen hheadcelluse=hhead*celluse

global out="turnout"

global list1=""
global list2=""

foreach i in $out {

	reg `i' hhead, cluster(dist)
	estimates store `i'_2_1
	sum `i' if e(sample) == 1
	scalar define m_`i'_2_1=r(mean)
	reg `i' celluse, cluster(dist)
	estimates store `i'_3_1
	sum `i' if e(sample) == 1
	scalar define m_`i'_3_1=r(mean)
	reg `i' hheadcelluse, cluster(dist)
	estimates store `i'_4_1
	sum `i' if e(sample) == 1
	scalar define m_`i'_4_1=r(mean)

	xi: reg `i' hhead gender i.educ radio tv motor job i.round i.dist, cluster(dist)
	estimates store `i'_2_2
	sum `i' if e(sample) == 1
	scalar define m_`i'_2_2=r(mean)
	xi: reg `i' hhead gender i.educ radio tv motor job i.round i.dist if ourprov==1, cluster(dist)
	estimates store `i'_2_3
	sum `i' if e(sample) == 1
	scalar define m_`i'_2_3=r(mean)

	xi: reg `i' celluse gender i.educ radio tv motor job i.round i.dist, cluster(dist)
	estimates store `i'_3_2
	sum `i' if e(sample) == 1
	scalar define m_`i'_3_2=r(mean)
	xi: reg `i' celluse gender i.educ radio tv motor job i.round i.dist if ourprov==1, cluster(dist)
	estimates store `i'_3_3
	sum `i' if e(sample) == 1
	scalar define m_`i'_3_3=r(mean)

	xi: reg `i' hheadcelluse gender i.educ radio tv motor job i.round i.dist, cluster(dist)
	estimates store `i'_4_2
	sum `i' if e(sample) == 1
	scalar define m_`i'_4_2=r(mean)
	xi: reg `i' hheadcelluse gender i.educ radio tv motor job i.round i.dist if ourprov==1, cluster(dist)
	estimates store `i'_4_3
	sum `i' if e(sample) == 1
	scalar define m_`i'_4_3=r(mean)

	global list1="$list1" +" `i'_2_1" + " `i'_3_1" + " `i'_4_1" + " `i'_2_2" + " `i'_2_3"+ " `i'_3_2" + " `i'_3_3" + " `i'_4_2" + " `i'_4_3"	

	}

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_ab.xml") append sheet("ab turnout") 

matrix define means=(m_turnout_2_1, m_turnout_3_1, m_turnout_4_1, m_turnout_2_2, m_turnout_2_3, m_turnout_3_2, m_turnout_3_3, m_turnout_4_2, m_turnout_4_3)
global list2="$list2" + " means"

xml_tab $list2, save("outputregs_ab.xml") append sheet("ab stats") 
estimates clear

sum hheadcelluse if ourprov==1
*0.27

*0.73a+0.27b=0.44
*b=a+0.13
*b=(0.44-(0.27*0.13))+0.13=0.54

*****************************************
*****  OA TABLES 16: CONTAMINATION  *****
*****************************************

clear all
set more off

use "mozdata.dta", replace

global disttreat="cemind hmind vmind"
global out1="bsturnoutpres09 bsturnoutparl09 bsguebas09"
global out2="bsdhlakama09 bsfrelimo09 bsrenamo09"

global list1=""
global list2=""

foreach i in $out1 {

	regress `i' cemind if v==1 & time==1 & civiceduc==0 & hotline==0 & verdade==0
	estimates store `i'_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_1=r(mean)
	display m_`i'_1
	regress `i' hmind if v==1 & time==1 & civiceduc==0 & hotline==0 & verdade==0
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	regress `i' vmind if v==1 & time==1 & civiceduc==0 & hotline==0 & verdade==0
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3

	suest `i'_1 `i'_2 `i'_3
	test [`i'_1_mean]cemind=[`i'_2_mean]hmind	
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test [`i'_1_mean]cemind=[`i'_3_mean]vmind	
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test [`i'_2_mean]hmind=[`i'_3_mean]vmind	
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test [`i'_1_mean]cemind [`i'_2_mean]hmind [`i'_3_mean]vmind	
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
	
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsturnoutpres09_1, m_bsturnoutpres09_2, m_bsturnoutpres09_3, m_bsturnoutparl09_1, m_bsturnoutparl09_2, m_bsturnoutparl09_3, m_bsguebas09_1, m_bsguebas09_2, m_bsguebas09_3 \ 999, 999, t1_bsturnoutpres09_3, 999, 999, t1_bsturnoutparl09_3, 999, 999, t1_bsguebas09_3 \ 999, 999, t2_bsturnoutpres09_3, 999, 999, t2_bsturnoutparl09_3, 999, 999, t2_bsguebas09_3 \ 999, 999, t3_bsturnoutpres09_3, 999, 999, t3_bsturnoutparl09_3, 999, 999, t3_bsguebas09_3 \ 999, 999, t4_bsturnoutpres09_3, 999, 999, t4_bsturnoutparl09_3, 999, 999, t4_bsguebas09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_contam.xml") replace sheet("out1") 
xml_tab $list2, save("outputregs_contam.xml") append sheet("out_means1") 
estimates clear

global list1=""
global list2=""

foreach i in $out2 {

	regress `i' cemind if v==1 & time==1 & civiceduc==0 & hotline==0 & verdade==0
	estimates store `i'_1
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_1=r(mean)
	display m_`i'_1
	regress `i' hmind if v==1 & time==1 & civiceduc==0 & hotline==0 & verdade==0
	estimates store `i'_2
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	regress `i' vmind if v==1 & time==1 & civiceduc==0 & hotline==0 & verdade==0
	estimates store `i'_3
	sum `i' if e(sample) & control == 1
	scalar define m_`i'_3=r(mean)
	display m_`i'_3

	suest `i'_1 `i'_2 `i'_3
	test [`i'_1_mean]cemind=[`i'_2_mean]hmind	
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test [`i'_1_mean]cemind=[`i'_3_mean]vmind	
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test [`i'_2_mean]hmind=[`i'_3_mean]vmind	
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test [`i'_1_mean]cemind [`i'_2_mean]hmind [`i'_3_mean]vmind	
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3
		
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_bsdhlakama09_1, m_bsdhlakama09_2, m_bsdhlakama09_3, m_bsfrelimo09_1, m_bsfrelimo09_2, m_bsfrelimo09_3, m_bsrenamo09_1, m_bsrenamo09_2, m_bsrenamo09_3 \ 999, 999, t1_bsdhlakama09_3, 999, 999, t1_bsfrelimo09_3, 999, 999, t1_bsrenamo09_3 \ 999, 999, t2_bsdhlakama09_3, 999, 999, t2_bsfrelimo09_3, 999, 999, t2_bsrenamo09_3 \ 999, 999, t3_bsdhlakama09_3, 999, 999, t3_bsfrelimo09_3, 999, 999, t3_bsrenamo09_3 \ 999, 999, t4_bsdhlakama09_3, 999, 999, t4_bsfrelimo09_3, 999, 999, t4_bsrenamo09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_contam.xml") append sheet("out2") 
xml_tab $list2, save("outputregs_contam.xml") append sheet("out_means2") 
estimates clear

*province-wide

clear all
set more off

use mozballotfulldata.dta, replace

global ce="ce_dist"
global h="h_dist"
global v="v_dist"

global out1="eaturnoutpres09 eaturnoutparl09 eaguebas09"
global out2="eadhlakama09 eafrelimo09 earenamo09"

global list1=""
global list2=""

foreach i in $out1 {

	regress `i' $ce if (experim==. & cell==1) | (civiceduc==0 & hotline==0 & verdade==0)
	estimates store `i'_1
	sum `i' if e(sample)
	scalar define m_`i'_1=r(mean)
	display m_`i'_1
	regress `i' $h if (experim==. & cell==1) | (civiceduc==0 & hotline==0 & verdade==0)
	estimates store `i'_2
	sum `i' if e(sample)
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	regress `i' $v if (experim==. & cell==1) | (civiceduc==0 & hotline==0 & verdade==0)
	estimates store `i'_3
	sum `i' if e(sample)
	scalar define m_`i'_3=r(mean)
	display m_`i'_3

	suest `i'_1 `i'_2 `i'_3
	test [`i'_1_mean]ce_dist=[`i'_2_mean]h_dist	
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test [`i'_1_mean]ce_dist=[`i'_3_mean]v_dist	
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test [`i'_2_mean]h_dist=[`i'_3_mean]v_dist	
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test [`i'_1_mean]ce_dist [`i'_2_mean]h_dist [`i'_3_mean]v_dist	
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_eaturnoutpres09_1, m_eaturnoutpres09_2, m_eaturnoutpres09_3, m_eaturnoutparl09_1, m_eaturnoutparl09_2, m_eaturnoutparl09_3, m_eaguebas09_1, m_eaguebas09_2, m_eaguebas09_3 \ 999, 999, t1_eaturnoutpres09_3, 999, 999, t1_eaturnoutparl09_3, 999, 999, t1_eaguebas09_3 \ 999, 999, t2_eaturnoutpres09_3, 999, 999, t2_eaturnoutparl09_3, 999, 999, t2_eaguebas09_3 \ 999, 999, t3_eaturnoutpres09_3, 999, 999, t3_eaturnoutparl09_3, 999, 999, t3_eaguebas09_3 \ 999, 999, t4_eaturnoutpres09_3, 999, 999, t4_eaturnoutparl09_3, 999, 999, t4_eaguebas09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_contam.xml") append sheet("all_out1") 
xml_tab $list2, save("outputregs_contam.xml") append sheet("all_out_means1") 
estimates clear

global list1=""
global list2=""

foreach i in $out2 {

	regress `i' $ce if (experim==. & cell==1) | (civiceduc==0 & hotline==0 & verdade==0)
	estimates store `i'_1
	sum `i' if e(sample)
	scalar define m_`i'_1=r(mean)
	display m_`i'_1
	regress `i' $h if (experim==. & cell==1) | (civiceduc==0 & hotline==0 & verdade==0)
	estimates store `i'_2
	sum `i' if e(sample)
	scalar define m_`i'_2=r(mean)
	display m_`i'_2
	regress `i' $v if (experim==. & cell==1) | (civiceduc==0 & hotline==0 & verdade==0)
	estimates store `i'_3
	sum `i' if e(sample)
	scalar define m_`i'_3=r(mean)
	display m_`i'_3

	suest `i'_1 `i'_2 `i'_3
	test [`i'_1_mean]ce_dist=[`i'_2_mean]h_dist	
	scalar define t1_`i'_3=r(p)
	display t1_`i'_3
	test [`i'_1_mean]ce_dist=[`i'_3_mean]v_dist	
	scalar define t2_`i'_3=r(p)
	display t2_`i'_3
	test [`i'_2_mean]h_dist=[`i'_3_mean]v_dist	
	scalar define t3_`i'_3=r(p)
	display t3_`i'_3
	test [`i'_1_mean]ce_dist [`i'_2_mean]h_dist [`i'_3_mean]v_dist	
	scalar define t4_`i'_3=r(p)
	display t4_`i'_3

	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"

}

matrix define means=(m_eadhlakama09_1, m_eadhlakama09_2, m_eadhlakama09_3, m_eafrelimo09_1, m_eafrelimo09_2, m_eafrelimo09_3, m_earenamo09_1, m_earenamo09_2, m_earenamo09_3 \ 999, 999, t1_eadhlakama09_3, 999, 999, t1_eafrelimo09_3, 999, 999, t1_earenamo09_3 \ 999, 999, t2_eadhlakama09_3, 999, 999, t2_eafrelimo09_3, 999, 999, t2_earenamo09_3 \ 999, 999, t3_eadhlakama09_3, 999, 999, t3_eafrelimo09_3, 999, 999, t3_earenamo09_3 \ 999, 999, t4_eadhlakama09_3, 999, 999, t4_eafrelimo09_3, 999, 999, t4_earenamo09_3)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("outputregs_contam.xml") append sheet("all_out2") 
xml_tab $list2, save("outputregs_contam.xml") append sheet("all_out_means2") 
estimates clear

**********************************
*****  ATTRITION ROBUSTNESS  *****
**********************************

clear all
set more off

use mozdata, replace

*********************************************************
*****  OA TABLE 14: CHARACTERISTICS OF PANEL DROPS  *****
*********************************************************

global demo1="sex age head housen single marriedunion noschl informalschl lit prim5y sec10y"
global demo2="chang macua lomue chuabo chironga maconde cathol protest muslim"
global demo3="job agric com art man assal tea puboff stud dom house land cattle cel expenditure"

foreach i in $demo1 {

	global list=""

	regress `i' drops2 if time==0, cluster(ea)
	estimates store `i'_1

	global list="$list" + " `i'_1"
	xml_tab $list, below save(attrition.xml) append sheet("drops `i'")
	estimates clear

}

foreach i in $demo2 {

	global list=""

	regress `i' drops2 if time==0, cluster(ea)
	estimates store `i'_1

	global list="$list" + " `i'_1"
	xml_tab $list, below save(attrition.xml) append sheet("drops `i'")
	estimates clear

}

foreach i in $demo3 {

	global list=""

	regress `i' drops2 if time==0, cluster(ea)
	estimates store `i'_1

	global list="$list" + " `i'_1"
	xml_tab $list, below save(attrition.xml) append sheet("drops `i'")
	estimates clear

}

**********************************************
*****  OA TABLE 15: MULTIPLE IMPUTATION  *****
**********************************************

clear all
set more off

use mozdata_aux, replace

drop if time==0

keep tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 civiceduc hotline verdade pr1 pr2 pr3 time lazy control ea post post_miss health health_miss market market_miss police police_miss sex age single divor school norelig protest relig com prof tea comform dom econfood econmedic house oven lchang llomue lchuabo lchitewe lronga chitsua living
sum tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 civiceduc hotline verdade pr1 pr2 pr3 time lazy control ea post post_miss health health_miss market market_miss police police_miss sex age single divor school norelig protest relig com prof tea comform dom econfood econmedic house oven lchang llomue lchuabo lchitewe lronga chitsua living

*aggregate dummies

gen marital=single
replace marital=2 if divor==1

gen religion=norelig
replace religion=2 if protest==1

gen occupation=com
replace occupation=2 if prof==1
replace occupation=3 if tea==1
replace occupation=4 if comform==1
replace occupation=5 if dom==1

sum marital religion occupation

*imputation
mi set mlong
mi ice tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 pr1 pr2 pr3 post post_miss health health_miss market market_miss police police_miss sex age single divor school norelig protest relig com prof tea comform dom econfood econmedic house oven lchang llomue lchuabo lchitewe lronga chitsua living marital religion occupation, add(10) seed(1139) eqdrop(sex: tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, age: tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, single: divor tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, divor: single tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, marital: single divor tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, school: tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, norelig: protest relig tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, protest: norelig relig tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, religion: norelig protest relig tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, relig: norelig protest tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, com: prof tea comform dom tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, prof: com tea comform dom tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, tea: com prof comform dom tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, comform: com prof tea dom tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, dom: com prof tea comform tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, occupation: com prof tea comform dom tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, econfood: econmedic tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, econmedic: econfood tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, house: oven tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, oven: house tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, lchang: llomue lchuabo lchitewe lronga tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, llomue: lchang lchuabo lchitewe lronga tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, lchuabo: lchang llomue lchitewe lronga tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, lchitewe: lchang llomue lchuabo lronga tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, lronga: lchang llomue lchuabo lchitewe tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, chitsua: tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation, living: tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2 marital religion occupation) eq(tresp: pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, tfinger: pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, tseen: pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, intt: pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, carta: pr1 pr2 pr3 market market_miss sex age divor school protest relig com tea econfood econmedic chitsua, guebas2: pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, dlakhama2: pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, simango2: pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, frelimo2: pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, renamo2: pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living) cmd(marital religion occupation:mlogit, school relig econfood econmedic living:ologit)  passive(com:occupation==1 \ prof:occupation==2 \ tea:occupation==3 \ comform:occupation==4 \ dom:occupation==5) substitute(occupation:com prof tea comform dom) cycles(5)

mi xtset, clear

*estimation

*targeted and untargeted together

global list1=""
global list2=""

mi estimate, dots: regress tresp civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
estimates store tresp

mi estimate, dots: mean tresp if control==1
matrix define aux=e(b_mi)
scalar define m_tresp=aux[1,1]
display m_tresp

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress tresp civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_tresp=r(p)
display t1_tresp

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress tresp civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_tresp=r(p)
display t2_tresp

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress tresp civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_tresp=r(p)
display t3_tresp

mi test civiceduc hotline verdade
scalar define t4_tresp=r(p)
display t4_tresp

mi estimate, dots: regress tfinger civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
estimates store tfinger

mi estimate, dots: mean tfinger if control==1
matrix define aux=e(b_mi)
scalar define m_tfinger=aux[1,1]
display m_tfinger

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress tfinger civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_tfinger=r(p)
display t1_tfinger

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress tfinger civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_tfinger=r(p)
display t2_tfinger

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress tfinger civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_tfinger=r(p)
display t3_tfinger

mi test civiceduc hotline verdade
scalar define t4_tfinger=r(p)
display t4_tfinger

mi estimate, dots: regress tseen civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
estimates store tseen

mi estimate, dots: mean tseen if control==1
matrix define aux=e(b_mi)
scalar define m_tseen=aux[1,1]
display m_tseen

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress tseen civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_tseen=r(p)
display t1_tseen

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress tseen civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_tseen=r(p)
display t2_tseen

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress tseen civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_tseen=r(p)
display t3_tseen

mi test civiceduc hotline verdade
scalar define t4_tseen=r(p)
display t4_tseen

mi estimate, dots: regress intt civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
estimates store intt

mi estimate, dots: mean intt if control==1
matrix define aux=e(b_mi)
scalar define m_intt=aux[1,1]
display m_intt

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress intt civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_intt=r(p)
display t1_intt

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress intt civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_intt=r(p)
display t2_intt

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress intt civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss sex age single divor protest com prof tea comform dom econfood house llomue chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_intt=r(p)
display t3_intt

mi test civiceduc hotline verdade
scalar define t4_intt=r(p)
display t4_intt

mi estimate, dots: regress carta civiceduc hotline verdade pr1 pr2 pr3 market market_miss sex age divor school protest relig com tea econfood econmedic chitsua, cluster(ea)
estimates store carta

mi estimate, dots: mean carta if control==1
matrix define aux=e(b_mi)
scalar define m_carta=aux[1,1]
display m_carta

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress carta civiceduc hotline verdade pr1 pr2 pr3 market market_miss sex age divor school protest relig com tea econfood econmedic chitsua, cluster(ea)
mi testtransform diff
scalar define t1_carta=r(p)
display t1_carta

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress carta civiceduc hotline verdade pr1 pr2 pr3 market market_miss sex age divor school protest relig com tea econfood econmedic chitsua, cluster(ea)
mi testtransform diff
scalar define t2_carta=r(p)
display t2_carta

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress carta civiceduc hotline verdade pr1 pr2 pr3 market market_miss sex age divor school protest relig com tea econfood econmedic chitsua, cluster(ea)
mi testtransform diff
scalar define t3_carta=r(p)
display t3_carta

mi test civiceduc hotline verdade
scalar define t4_carta=r(p)
display t4_carta

mi estimate, dots: regress guebas2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
estimates store guebas2

mi estimate, dots: mean guebas2 if control==1
matrix define aux=e(b_mi)
scalar define m_guebas2=aux[1,1]
display m_guebas2

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress guebas2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_guebas2=r(p)
display t1_guebas2

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress guebas2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_guebas2=r(p)
display t2_guebas2

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress guebas2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_guebas2=r(p)
display t3_guebas2

mi test civiceduc hotline verdade
scalar define t4_guebas2=r(p)
display t4_guebas2

mi estimate, dots: regress dlakhama2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
estimates store dlakhama2

mi estimate, dots: mean dlakhama2 if control==1
matrix define aux=e(b_mi)
scalar define m_dlakhama2=aux[1,1]
display m_dlakhama2

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress dlakhama2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_dlakhama2=r(p)
display t1_dlakhama2

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress dlakhama2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_dlakhama2=r(p)
display t2_dlakhama2

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress dlakhama2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_dlakhama2=r(p)
display t3_dlakhama2

mi test civiceduc hotline verdade
scalar define t4_dlakhama2=r(p)
display t4_dlakhama2

mi estimate, dots: regress simango2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
estimates store simango2

mi estimate, dots: mean simango2 if control==1
matrix define aux=e(b_mi)
scalar define m_simango2=aux[1,1]
display m_simango2

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress simango2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_simango2=r(p)
display t1_simango2

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress simango2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_simango2=r(p)
display t2_simango2

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress simango2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_simango2=r(p)
display t3_simango2

mi test civiceduc hotline verdade
scalar define t4_simango2=r(p)
display t4_simango2

mi estimate, dots: regress frelimo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
estimates store frelimo2

mi estimate, dots: mean frelimo2 if control==1
matrix define aux=e(b_mi)
scalar define m_frelimo2=aux[1,1]
display m_frelimo2

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress frelimo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_frelimo2=r(p)
display t1_frelimo2

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress frelimo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_frelimo2=r(p)
display t2_frelimo2

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress frelimo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_frelimo2=r(p)
display t3_frelimo2

mi test civiceduc hotline verdade
scalar define t4_frelimo2=r(p)
display t4_frelimo2

mi estimate, dots: regress renamo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
estimates store renamo2

mi estimate, dots: mean renamo2 if control==1
matrix define aux=e(b_mi)
scalar define m_renamo2=aux[1,1]
display m_renamo2

mi estimate (diff: _b[civiceduc]-_b[hotline]), saving(miest, replace): regress renamo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t1_renamo2=r(p)
display t1_renamo2

mi estimate (diff: _b[civiceduc]-_b[verdade]), saving(miest, replace): regress renamo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t2_renamo2=r(p)
display t2_renamo2

mi estimate (diff: _b[hotline]-_b[verdade]), saving(miest, replace): regress renamo2 civiceduc hotline verdade pr1 pr2 pr3 post post_miss health health_miss police police_miss sex age single divor norelig protest com prof comform econfood house oven lchang llomue lchuabo lchitewe lronga chitsua living, cluster(ea)
mi testtransform diff
scalar define t3_renamo2=r(p)
display t3_renamo2

mi test civiceduc hotline verdade
scalar define t4_renamo2=r(p)
display t4_renamo2

global list1="$list1" + " tresp(b_mi V_mi)" + " tfinger(b_mi V_mi)" + " tseen(b_mi V_mi)" + " intt(b_mi V_mi)" + " carta(b_mi V_mi)" + " guebas2(b_mi V_mi)" + " dlakhama2(b_mi V_mi)" + " simango2(b_mi V_mi)" + " frelimo2(b_mi V_mi)" + " renamo2(b_mi V_mi)" 
	
matrix define means=(m_tresp, m_tfinger, m_tseen, m_intt, m_carta, m_guebas2, m_dlakhama2, m_simango2, m_frelimo2, m_renamo2 \ t1_tresp, t1_tfinger, t1_tseen, t1_intt, t1_carta, t1_guebas2, t1_dlakhama2, t1_simango2, t1_frelimo2, t1_renamo2 \ t2_tresp, t2_tfinger, t2_tseen, t2_intt, t2_carta, t2_guebas2, t2_dlakhama2, t2_simango2, t2_frelimo2, t2_renamo2 \ t3_tresp, t3_tfinger, t3_tseen, t3_intt, t3_carta, t3_guebas2, t3_dlakhama2, t3_simango2, t3_frelimo2, t3_renamo2 \ t4_tresp, t4_tfinger, t4_tseen, t4_intt, t4_carta, t4_guebas2, t4_dlakhama2, t4_simango2, t4_frelimo2, t4_renamo2)
global list2="$list2" + " means"

xml_tab $list1, below stats(r2_a N) nolabel save("attrition.xml") append sheet("mi") 
xml_tab $list2, save("attrition.xml") append sheet("mi stats") 
estimates clear

************************************
*****  OA TABLE 13: LEE BOUNDS *****
************************************

clear all
set more off

use mozdata_aux, replace

global out="tresp tfinger tseen intt carta guebas2 dlakhama2 simango2 frelimo2 renamo2"

capture gen idrops2=.
replace idrops2=1 if drops2==0
replace idrops2=0 if drops2==1

sum idrops2 if time==1 & control==1
scalar define n_control=r(N)
*452
sum idrops2 if time==1 & civiceduc==1
scalar define n_civiceduc=r(N)
*449
sum idrops2 if time==1 & hotline==1
scalar define n_hotline=r(N)
*436
sum idrops2 if time==1 & verdade==1
scalar define n_verdade=r(N)
*429

foreach i in $out {

	global list1=""

	capture gen `i'_control=`i' if time==1 & control==1
	capture gen `i'_civiceduc=`i' if time==1 & civiceduc==1
	capture gen `i'_hotline=`i' if time==1 & hotline==1
	capture gen `i'_verdade=`i' if time==1 & verdade==1

	sum `i'_control
	scalar define m_`i'_control=r(mean)

	sum `i'_civiceduc
	scalar define m_`i'_civiceduc=r(mean)
	scalar define m_`i'_1=m_`i'_civiceduc-m_`i'_control
	ttest `i'_civiceduc=`i'_control, unpaired
	scalar define se_`i'_1=r(se)
	scalar define p_`i'_1=r(p)
	leebounds `i' civiceduc if time==1 & hotline==0 & verdade==0, select(idrops2)
	estimates store `i'_1
	sum `i' if e(sample)==1 & control==1
	scalar define n_`i'_1_1=r(N)/n_control
	sum `i' if e(sample)==1 & civiceduc==1
	scalar define n_`i'_1_2=r(N)/n_civiceduc

	sum `i'_hotline
	scalar define m_`i'_hotline=r(mean)
	scalar define m_`i'_2=m_`i'_hotline-m_`i'_control
	ttest `i'_hotline=`i'_control, unpaired
	scalar define se_`i'_2=r(se)
	scalar define p_`i'_2=r(p)
	leebounds `i' hotline if time==1 & civiceduc==0 & verdade==0, select(idrops2)
	estimates store `i'_2
	sum `i' if e(sample)==1 & control==1
	scalar define n_`i'_2_1=r(N)/n_control
	sum `i' if e(sample)==1 & hotline==1
	scalar define n_`i'_2_2=r(N)/n_hotline

	sum `i'_verdade
	scalar define m_`i'_verdade=r(mean)
	scalar define m_`i'_3=m_`i'_verdade-m_`i'_control
	ttest `i'_verdade=`i'_control, unpaired
	scalar define se_`i'_3=r(se)
	scalar define p_`i'_3=r(p)
	leebounds `i' verdade if time==1 & civiceduc==0 & hotline==0, select(idrops2)
	estimates store `i'_3
	sum `i' if e(sample)==1 & control==1
	scalar define n_`i'_3_1=r(N)/n_control
	sum `i' if e(sample)==1 & verdade==1
	scalar define n_`i'_3_2=r(N)/n_verdade
	
	global list1="$list1" + " `i'_1" + " `i'_2" + " `i'_3"

	xml_tab $list1, below stats(N Nsel) nolabel save("attrition.xml") append sheet("lee `i'") 
	estimates clear

}

global list2=""

matrix define means=(m_tresp_1, m_tfinger_1, m_tseen_1, m_intt_1, m_carta_1, m_guebas2_1, m_dlakhama2_1, m_simango2_1, m_frelimo2_1, m_renamo2_1 \ se_tresp_1, se_tfinger_1, se_tseen_1, se_intt_1, se_carta_1, se_guebas2_1, se_dlakhama2_1, se_simango2_1, se_frelimo2_1, se_renamo2_1 \ p_tresp_1, p_tfinger_1, p_tseen_1, p_intt_1, p_carta_1, p_guebas2_1, p_dlakhama2_1, p_simango2_1, p_frelimo2_1, p_renamo2_1 \ m_tresp_2, m_tfinger_2, m_tseen_2, m_intt_2, m_carta_2, m_guebas2_2, m_dlakhama2_2, m_simango2_2, m_frelimo2_2, m_renamo2_2 \ se_tresp_2, se_tfinger_2, se_tseen_2, se_intt_2, se_carta_2, se_guebas2_2, se_dlakhama2_2, se_simango2_2, se_frelimo2_2, se_renamo2_2 \ p_tresp_2, p_tfinger_2, p_tseen_2, p_intt_2, p_carta_2, p_guebas2_2, p_dlakhama2_2, p_simango2_2, p_frelimo2_2, p_renamo2_2 \ m_tresp_3, m_tfinger_3, m_tseen_3, m_intt_3, m_carta_3, m_guebas2_3, m_dlakhama2_3, m_simango2_3, m_frelimo2_3, m_renamo2_3 \ se_tresp_3, se_tfinger_3, se_tseen_3, se_intt_3, se_carta_3, se_guebas2_3, se_dlakhama2_3, se_simango2_3, se_frelimo2_3, se_renamo2_3 \ p_tresp_3, p_tfinger_3, p_tseen_3, p_intt_3, p_carta_3, p_guebas2_3, p_dlakhama2_3, p_simango2_3, p_frelimo2_3, p_renamo2_3 \ n_tresp_1_1, n_tfinger_1_1, n_tseen_1_1, n_intt_1_1, n_carta_1_1, n_guebas2_1_1, n_dlakhama2_1_1, n_simango2_1_1, n_frelimo2_1_1, n_renamo2_1_1 \ n_tresp_1_2, n_tfinger_1_2, n_tseen_1_2, n_intt_1_2, n_carta_1_2, n_guebas2_1_2, n_dlakhama2_1_2, n_simango2_1_2, n_frelimo2_1_2, n_renamo2_1_2 \ n_tresp_2_1, n_tfinger_2_1, n_tseen_2_1, n_intt_2_1, n_carta_2_1, n_guebas2_2_1, n_dlakhama2_2_1, n_simango2_2_1, n_frelimo2_2_1, n_renamo2_2_1 \ n_tresp_2_2, n_tfinger_2_2, n_tseen_2_2, n_intt_2_2, n_carta_2_2, n_guebas2_2_2, n_dlakhama2_2_2, n_simango2_2_2, n_frelimo2_1_1, n_renamo2_2_2 \ n_tresp_3_1, n_tfinger_3_1, n_tseen_3_1, n_intt_3_1, n_carta_3_1, n_guebas2_3_1, n_dlakhama2_3_1, n_simango2_3_1, n_frelimo2_3_1, n_renamo2_3_1 \ n_tresp_3_2, n_tfinger_3_2, n_tseen_3_2, n_intt_3_2, n_carta_3_2, n_guebas2_3_2, n_dlakhama2_3_2, n_simango2_3_2, n_frelimo2_3_2, n_renamo2_3_2)
global list2="$list2" + " means"

xml_tab $list2, save("attrition.xml") append sheet("lee stats") 
estimates clear

log close
