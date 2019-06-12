version 10.1
clear
set memory 10m
set more off
use "91RaceAndPolv3.dta"
set matsize 150


/*========================== RECODE EXPERIMENT VARIABLES =====================*/

/*** --------(1)--------------
	support for poverty programs
	0 = stongly opposed
	1 = somewhat opposed
	2 = somewhat in favor
	3 = stongly in favor ***/
	
recode ef4 7=0 5=1 3=2 1=3 8=. 9=.

/* job/welfare */
recode rf4a 1=0 2=1
/* immigrants/blacks */
recode rf4b 2=0
/* want to work/troubled jobs */
recode rf4c 1=0 2=1


/*** --------(2)-----------------
	support for anti-discrimination laws
	0 = stongly opposed
	1 = somewhat opposed
	2 = somewhat in favor
	3 = stongly in favor ***/
	
recode ef6 7=0 5=1 3=2 1=3 8=. 9=.

/* blacks/asian/women- Create 2 group dummies, blacks as omitted group */
gen ref6a=0
replace ref6a=1 if ref6==2
gen ref6b=0
replace ref6b=1 if ref6==3

/*** --------(3)-----------------
	Gov't help to get job
	0 = gov't do more or keep same
	1 = blacks take care of themselves ***/
recode jobs 1=0 5=1 7=0 8=. 9=.

recode rjob 1=0 2=1

/*** --------(4)-----------------
	Opinion about X for blacks in suburbs
	0 = stongly opposed
	1 = somewhat opposed
	2 = somewhat in favor
	3 = stongly in favor ***/
recode hse2 7=0 5=1 3=2 1=3 8=. 9=.

gen rhs1=0
replace rhs1=1 if rhs==1
gen rhs2=0
replace rhs2=1 if rhs==2

/*** --------(5)-----------------
	Federal contracts to blacks
	0 = bad idea
	1 = good idea ***/
recode set 5=0 8=. 9=.

recode rst1 1=0 2=1
recode rst2 1=0 2=1


/*** --------(6)-----------------
	Rasie taxes for schools
	0 = no
	1 = yes ***/
recode tax 5=0 8=. 9=.

recode rtx1 1=0 2=1
recode rtx2 1=0 2=1

/*** --------(7)-----------------
	Open housing
	0 = Gov't stay out
	1 = Gov't make effort ***/
recode home 1=0 5=1 8=. 9=.

/* neutral/property rights/role of gov't
	Generate 2 dummies */
gen rhm1=0
replace rhm1=1 if rhom==2
gen rhm2=0
replace rhm2=1 if rhom==3

/*** --------(8)-----------------
	Welfare too lazy - anger ***/
recode ang6 98=. 99=.

/* man/black man */
recode rag6 1=0 2=1

/*** --------(9)----------------- ***/
recode list 8=. 9=.

/* basic/black family/black leaders
	Generate 2 dummies - basic is omitted dummy */
gen rlst1=0
replace rlst1=1 if rlst==2
gen rlst2=0
replace rlst2=1 if rlst==3

/*** --------(10)-----------------
	Elect black w/w/o accent 
	0 = not at all likely
	1 = somewhat unlikely
	2 = somewhat likely
	3 = very likely ***/
recode cand 7=0 5=1 3=2 1=3 8=. 9=.

/* with accent/without accent */
recode rcnd 2=0

/*** --------(11)-----------------
	Police overract to drunk in X
	0 = not at all likely
	1 = somewhat unlikely
	2 = somewhat likely
	3 = very likely ***/

recode arst 7=0 5=1 3=2 1=3 8=. 9=.

/* fancy NYC restaurant/black area of NYC */
recode rars 1=0 2=1

/*** --------(12)-----------------
	Drug search
	0 = definitely not reasonable
	1 = probably not reasonable
	2 = probably reasonable
	3 = definitely not reasonable ***/
recode drug 7=0 5=1 3=2 1=3 8=. 9=.

/* rdr1 = white/black
   rdr2 = well-dressed and behaved/foul language */
recode rdr1 1=0 2=1
recode rdr2 1=0 2=1


/*** --------(13)-----------------
	Welfare mother look for job
	0 = not at all likely
	1 = somewhat unlikely
	2 = somewhat likely
	3 = very likely ***/
recode wmom 7=0 5=1 3=2 1=3 8=. 9=.

/* rwm1 = white/black
   rwm2 = drop out/graduate */
recode rwm1 2=0
recode rwm2 2=0

/*** Second welfare mom experiment question
	Welfare mother will have more kids
	0 = not at all likely
	1 = somewhat unlikely
	2 = somewhat likely
	3 = very likely ***/
recode wmk 7=0 5=1 3=2 1=3 8=. 9=.


/*** --------(14)-----------------
	Work way up
	0 = disagree strongly
	1 = disagree somewhat
	2 = agree somewhat
	3 = agree strongly */
recode imm 7=0 5=1 3=2 1=3 8=. 9=.

/* european/blacks */
recode rimm 2=0

/*** --------(15)-----------------
	Gov't assist vs. work
	0 = disagree strongly
	1 = disagree somewhat
	2 = agree somewhat
	3 = agree strongly */
recode poor 7=0 5=1 3=2 1=3 8=. 9=.

/* poor people/blacks/poor blacks
	Generate 2 dummies - just poor is omitted dummy */
gen rpor1=0
replace rpor1=1 if rpor==2
gen rpor2=0
replace rpor2=1 if rpor==3

/*** --------(16)-----------------
	Black pref to university admissions
	0 = opposed
	1 = in favor ***/
recode univ 5=0 8=. 9=.

/* preference/extra effort */
recode runv 1=0 2=1

/*** --------(17)-----------------
	Job quotas for blacks
	0 = gov't should stay out
	1 = quota requirement ***/
recode quot 5=0 8=. 9=.

/* blank/underrepresented/discriminate
	Generate 2 dummies - baseline is omitted dummy */
gen rqt1=0
replace rqt1=1 if rqt==2
gen rqt2=0
replace rqt2=1 if rqt==3


/*===================INTERACTION VARIABLES=====================================*/

/*===(2)=====*/

gen rf4aXb = rf4a*rf4b
gen rf4aXc = rf4a*rf4c
gen rf4bXc = rf4b*rf4c
gen rf4aXbXc = rf4a*rf4b*rf4c

gen rf4aXref6a = rf4a*ref6a
gen rf4aXref6b = rf4a*ref6b
gen rf4bXref6a = rf4b*ref6a
gen rf4bXref6b = rf4b*ref6b
gen rf4cXref6a = rf4c*ref6a
gen rf4cXref6b = rf4c*ref6b

gen rf4aXbXref6a = rf4a*rf4b*ref6a
gen rf4aXbXref6b = rf4a*rf4b*ref6b
gen rf4aXcXref6a = rf4a*rf4c*ref6a
gen rf4aXcXref6b = rf4a*rf4c*ref6b
gen rf4bXcXref6a = rf4b*rf4c*ref6a
gen rf4bXcXref6b = rf4b*rf4c*ref6b
gen rf4aXbXcXref6a = rf4a*rf4b*rf4c*ref6a
gen rf4aXbXcXref6b = rf4a*rf4b*rf4c*ref6b

/*===(3)=====*/

gen rf4aXrjob = rf4a*rjob
gen rf4bXrjob = rf4b*rjob
gen rf4cXrjob = rf4c*rjob

gen rf4aXbXrjob = rf4aXb*rjob
gen rf4aXcXrjob = rf4aXc*rjob
gen rf4bXcXrjob = rf4bXc*rjob
gen rf4aXbXcXrjob = rf4aXbXc*rjob

*******

gen ref6aXrjob = ref6a*rjob
gen ref6bXrjob = ref6b*rjob

/*===(4)====*/

gen rf4aXrhs1 = rf4a*rhs1
gen rf4bXrhs1 = rf4b*rhs1
gen rf4cXrhs1 = rf4c*rhs1

gen rf4aXbXrhs1 = rf4aXb*rhs1
gen rf4aXcXrhs1 = rf4aXc*rhs1
gen rf4bXcXrhs1 = rf4bXc*rhs1
gen rf4aXbXcXrhs1 = rf4aXbXc*rhs1

gen rf4aXrhs2 = rf4a*rhs2
gen rf4bXrhs2 = rf4b*rhs2
gen rf4cXrhs2 = rf4c*rhs2

gen rf4aXbXrhs2 = rf4aXb*rhs2
gen rf4aXcXrhs2 = rf4aXc*rhs2
gen rf4bXcXrhs2 = rf4bXc*rhs2
gen rf4aXbXcXrhs2 = rf4aXbXc*rhs2

*************

gen ref6aXrhs1 = ref6a*rhs1
gen ref6bXrhs1 = ref6b*rhs1

gen ref6aXrhs2 = ref6a*rhs2
gen ref6bXrhs2 = ref6b*rhs2

************

gen rjobXrhs1 = rjob*rhs1
gen rjobXrhs2 = rjob*rhs2

/*=====(5)======*/

gen rst1X2 = rst1*rst2

gen rf4aXrst1 = rf4a*rst1
gen rf4bXrst1 = rf4b*rst1
gen rf4cXrst1 = rf4c*rst1

gen rf4aXbXrst1 = rf4aXb*rst1
gen rf4aXcXrst1 = rf4aXc*rst1
gen rf4bXcXrst1 = rf4bXc*rst1
gen rf4aXbXcXrst1 = rf4aXbXc*rst1

gen rf4aXrst2 = rf4a*rst2
gen rf4bXrst2 = rf4b*rst2
gen rf4cXrst2 = rf4c*rst2

gen rf4aXbXrst2 = rf4aXb*rst2
gen rf4aXcXrst2 = rf4aXc*rst2
gen rf4bXcXrst2 = rf4bXc*rst2
gen rf4aXbXcXrst2 = rf4aXbXc*rst2

gen rf4aXrst1X2 = rf4a*rst1X2
gen rf4bXrst1X2 = rf4b*rst1X2
gen rf4cXrst1X2 = rf4c*rst1X2

gen rf4aXbXrst1X2 = rf4aXb*rst1X2
gen rf4aXcXrst1X2 = rf4aXc*rst1X2
gen rf4bXcXrst1X2 = rf4bXc*rst1X2
gen rf4aXbXcXrst1X2 = rf4aXbXc*rst1X2


*************
gen ref6aXrst1 = ref6a*rst1
gen ref6bXrst1 = ref6b*rst1

gen ref6aXrst2 = ref6a*rst2
gen ref6bXrst2 = ref6b*rst2

gen ref6aXrst1X2 = ref6a*rst1X2
gen ref6bXrst1X2 = ref6b*rst1X2

*********

gen rjobXrst1 = rjob*rst1
gen rjobXrst2 = rjob*rst2
gen rjobXrst1X2 = rjob*rst1X2

*************

gen rhs1Xrst1 = rhs1*rst1
gen rhs2Xrst1 = rhs2*rst1

gen rhs1Xrst2 = rhs1*rst2
gen rhs2Xrst2 = rhs2*rst2

gen rhs1Xrst1X2 = rhs1*rst1X2
gen rhs2Xrst1X2 = rhs2*rst1X2


/*============(6)==========*/

gen rtx1X2 = rtx1*rtx2

gen rf4aXrtx1 = rf4a*rtx1
gen rf4bXrtx1 = rf4b*rtx1
gen rf4cXrtx1 = rf4c*rtx1
gen rf4aXbXrtx1 = rf4aXb*rtx1
gen rf4aXcXrtx1 = rf4aXc*rtx1
gen rf4bXcXrtx1 = rf4bXc*rtx1
gen rf4aXbXcXrtx1 = rf4aXbXc*rtx1

gen rf4aXrtx2 = rf4a*rtx2
gen rf4bXrtx2 = rf4b*rtx2
gen rf4cXrtx2 = rf4c*rtx2
gen rf4aXbXrtx2 = rf4aXb*rtx2
gen rf4aXcXrtx2 = rf4aXc*rtx2
gen rf4bXcXrtx2 = rf4bXc*rtx2
gen rf4aXbXcXrtx2 = rf4aXbXc*rtx2

gen rf4aXrtx1X2 = rf4a*rtx1X2
gen rf4bXrtx1X2 = rf4b*rtx1X2
gen rf4cXrtx1X2 = rf4c*rtx1X2
gen rf4aXbXrtx1X2 = rf4aXb*rtx1X2
gen rf4aXcXrtx1X2 = rf4aXc*rtx1X2
gen rf4bXcXrtx1X2 = rf4bXc*rtx1X2
gen rf4aXbXcXrtx1X2 = rf4aXbXc*rtx1X2

***************

gen ref6aXrtx1 = ref6a*rtx1
gen ref6bXrtx1 = ref6b*rtx1
gen ref6aXrtx2 = ref6a*rtx2
gen ref6bXrtx2 = ref6b*rtx2
gen ref6aXrtx1X2 = ref6a*rtx1X2
gen ref6bXrtx1X2 = ref6b*rtx1X2

**************

gen rjobXrtx1 = rjob*rtx1
gen rjobXrtx2 = rjob*rtx2
gen rjobXrtx1X2 = rjob*rtx1X2

***********

gen rhs1Xrtx1 = rhs1*rtx1
gen rhs1Xrtx2 = rhs1*rtx2
gen rhs1Xrtx1X2 = rhs1*rtx1X2

gen rhs2Xrtx1 = rhs2*rtx1
gen rhs2Xrtx2 = rhs2*rtx2
gen rhs2Xrtx1X2 = rhs2*rtx1X2

***********

gen rst1Xrtx1 = rst1*rtx1
gen rst1Xrtx2 = rst1*rtx2
gen rst1Xrtx1X2 = rst1*rtx1X2
gen rst2Xrtx1 = rst2*rtx1
gen rst2Xrtx2 = rst2*rtx2
gen rst2Xrtx1X2 = rst2*rtx1X2
gen rst1X2Xrtx1 = rst1X2*rtx1
gen rst1X2Xrtx2 = rst1X2*rtx2
gen rst1X2Xrtx1X2 = rst1X2*rtx1X2

/*=========(7)============*/

gen rf4aXrhm1 = rf4a*rhm1
gen rf4bXrhm1 = rf4b*rhm1
gen rf4cXrhm1 = rf4c*rhm1
gen rf4aXbXrhm1 = rf4aXb*rhm1
gen rf4aXcXrhm1 = rf4aXc*rhm1
gen rf4bXcXrhm1 = rf4bXc*rhm1
gen rf4aXbXcXrhm1 = rf4aXbXc*rhm1

gen rf4aXrhm2 = rf4a*rhm2
gen rf4bXrhm2 = rf4b*rhm2
gen rf4cXrhm2 = rf4c*rhm2
gen rf4aXbXrhm2 = rf4aXb*rhm2
gen rf4aXcXrhm2 = rf4aXc*rhm2
gen rf4bXcXrhm2 = rf4bXc*rhm2
gen rf4aXbXcXrhm2 = rf4aXbXc*rhm2

*************

gen ref6aXrhm1 = ref6a*rhm1
gen ref6bXrhm1 = ref6b*rhm1

gen ref6aXrhm2 = ref6a*rhm2
gen ref6bXrhm2 = ref6b*rhm2

***************

gen rjobXrhm1 = rjob*rhm1
gen rjobXrhm2 = rjob*rhm2

**************

gen rhs1Xrhm1 = rhs1*rhm1
gen rhs1Xrhm2 = rhs1*rhm2

gen rhs2Xrhm1 = rhs2*rhm1
gen rhs2Xrhm2 = rhs2*rhm2

**************

gen rst1Xrhm1 = rst1*rhm1
gen rst1Xrhm2 = rst1*rhm2
gen rst2Xrhm1 = rst2*rhm1
gen rst2Xrhm2 = rst2*rhm2
gen rst1X2Xrhm1 = rst1X2*rhm1
gen rst1X2Xrhm2 = rst1X2*rhm2

************

gen rtx1Xrhm1 = rtx1*rhm1
gen rtx1Xrhm2 = rtx1*rhm2
gen rtx2Xrhm1 = rtx2*rhm1
gen rtx2Xrhm2 = rtx2*rhm2
gen rtx1X2Xrhm1 = rtx1X2*rhm1
gen rtx1X2Xrhm2 = rtx1X2*rhm2

/*========(8)==========*/

gen rf4aXrag6 = rf4a*rag6
gen rf4bXrag6 = rf4b*rag6
gen rf4cXrag6 = rf4c*rag6
gen rf4aXbXrag6 = rf4aXb*rag6
gen rf4aXcXrag6 = rf4aXc*rag6
gen rf4bXcXrag6 = rf4bXc*rag6
gen rf4aXbXcXrag6 = rf4aXbXc*rag6

*******

gen ref6aXrag6 = ref6a*rag6
gen ref6bXrag6 = ref6b*rag6

*******

gen rjobXrag6 = rjob*rag6

*******

gen rhs1Xrag6 = rhs1*rag6
gen rhs2Xrag6 = rhs2*rag6

********

gen rst1Xrag6 = rst1*rag6
gen rst2Xrag6 = rst2*rag6
gen rst1X2Xrag6 = rst1X2*rag6

********

gen rtx1Xrag6 = rtx1*rag6
gen rtx2Xrag6 = rtx2*rag6
gen rtx1X2Xrag6 = rtx1X2*rag6

**********

gen rhm1Xrag6 = rhm1*rag6
gen rhm2Xrag6 = rhm2*rag6

/*========(9)==========*/

gen rf4aXrlst1 = rf4a*rlst1
gen rf4bXrlst1 = rf4b*rlst1
gen rf4cXrlst1 = rf4c*rlst1
gen rf4aXbXrlst1 = rf4aXb*rlst1
gen rf4aXcXrlst1 = rf4aXc*rlst1
gen rf4bXcXrlst1 = rf4bXc*rlst1
gen rf4aXbXcXrlst1 = rf4aXbXc*rlst1

gen rf4aXrlst2 = rf4a*rlst2
gen rf4bXrlst2 = rf4b*rlst2
gen rf4cXrlst2 = rf4c*rlst2
gen rf4aXbXrlst2 = rf4aXb*rlst2
gen rf4aXcXrlst2 = rf4aXc*rlst2
gen rf4bXcXrlst2 = rf4bXc*rlst2
gen rf4aXbXcXrlst2 = rf4aXbXc*rlst2

*************

gen ref6aXrlst1 = ref6a*rlst1
gen ref6bXrlst1 = ref6b*rlst1
gen ref6aXrlst2 = ref6a*rlst2
gen ref6bXrlst2 = ref6b*rlst2

***************

gen rjobXrlst1 = rjob*rlst1
gen rjobXrlst2 = rjob*rlst2

**************

gen rhs1Xrlst1 = rhs1*rlst1
gen rhs1Xrlst2 = rhs1*rlst2

gen rhs2Xrlst1 = rhs2*rlst1
gen rhs2Xrlst2 = rhs2*rlst2

**************

gen rst1Xrlst1 = rst1*rlst1
gen rst1Xrlst2 = rst1*rlst2
gen rst2Xrlst1 = rst2*rlst1
gen rst2Xrlst2 = rst2*rlst2
gen rst1X2Xrlst1 = rst1X2*rlst1
gen rst1X2Xrlst2 = rst1X2*rlst2

************

gen rtx1Xrlst1 = rtx1*rlst1
gen rtx1Xrlst2 = rtx1*rlst2
gen rtx2Xrlst1 = rtx2*rlst1
gen rtx2Xrlst2 = rtx2*rlst2
gen rtx1X2Xrlst1 = rtx1X2*rlst1
gen rtx1X2Xrlst2 = rtx1X2*rlst2

**************

gen rhm1Xrlst1 = rhm1*rlst1
gen rhm1Xrlst2 = rhm1*rlst2
gen rhm2Xrlst1 = rhm2*rlst1
gen rhm2Xrlst2 = rhm2*rlst2

*********

gen rag6Xrlst1 = rag6*rlst1
gen rag6Xrlst2 = rag6*rlst2


/*========(10)==========*/

gen rf4aXrcnd = rf4a*rcnd
gen rf4bXrcnd = rf4b*rcnd
gen rf4cXrcnd = rf4c*rcnd
gen rf4aXbXrcnd = rf4aXb*rcnd
gen rf4aXcXrcnd = rf4aXc*rcnd
gen rf4bXcXrcnd = rf4bXc*rcnd
gen rf4aXbXcXrcnd = rf4aXbXc*rcnd

**********

gen ref6aXrcnd = ref6a*rcnd
gen ref6bXrcnd = ref6b*rcnd

*******

gen rjobXrcnd = rjob*rcnd

*******

gen rhs1Xrcnd = rhs1*rcnd
gen rhs2Xrcnd = rhs2*rcnd

********

gen rst1Xrcnd = rst1*rcnd
gen rst2Xrcnd = rst2*rcnd
gen rst1X2Xrcnd = rst1X2*rcnd

********

gen rtx1Xrcnd = rtx1*rcnd
gen rtx2Xrcnd = rtx2*rcnd
gen rtx1X2Xrcnd = rtx1X2*rcnd

**********

gen rhm1Xrcnd = rhm1*rcnd
gen rhm2Xrcnd = rhm2*rcnd

*******

gen rag6Xrcnd = rag6*rcnd

********

gen rlst1Xrcnd = rlst1*rcnd
gen rlst2Xrcnd = rlst2*rcnd

/*========(11)==========*/

gen rf4aXrars = rf4a*rars
gen rf4bXrars = rf4b*rars
gen rf4cXrars = rf4c*rars
gen rf4aXbXrars = rf4aXb*rars
gen rf4aXcXrars = rf4aXc*rars
gen rf4bXcXrars = rf4bXc*rars
gen rf4aXbXcXrars = rf4aXbXc*rars

***********

gen ref6aXrars = ref6a*rars
gen ref6bXrars = ref6b*rars

*******

gen rjobXrars = rjob*rars

*******

gen rhs1Xrars = rhs1*rars
gen rhs2Xrars = rhs2*rars

********

gen rst1Xrars = rst1*rars
gen rst2Xrars = rst2*rars
gen rst1X2Xrars = rst1X2*rars

********

gen rtx1Xrars = rtx1*rars
gen rtx2Xrars = rtx2*rars
gen rtx1X2Xrars = rtx1X2*rars

**********

gen rhm1Xrars = rhm1*rars
gen rhm2Xrars = rhm2*rars

******

gen rag6Xrars = rag6*rars

*******

gen rlst1Xrars = rlst1*rars
gen rlst2Xrars = rlst2*rars

********

gen rcndXrars = rcnd*rars

/*========(12)==========*/

gen rdr1X2 = rdr1*rdr2

gen rf4aXrdr1 = rf4a*rdr1
gen rf4bXrdr1 = rf4b*rdr1
gen rf4cXrdr1 = rf4c*rdr1
gen rf4aXbXrdr1 = rf4aXb*rdr1
gen rf4aXcXrdr1 = rf4aXc*rdr1
gen rf4bXcXrdr1 = rf4bXc*rdr1
gen rf4aXbXcXrdr1 = rf4aXbXc*rdr1

gen rf4aXrdr2 = rf4a*rdr2
gen rf4bXrdr2 = rf4b*rdr2
gen rf4cXrdr2 = rf4c*rdr2
gen rf4aXbXrdr2 = rf4aXb*rdr2
gen rf4aXcXrdr2 = rf4aXc*rdr2
gen rf4bXcXrdr2 = rf4bXc*rdr2
gen rf4aXbXcXrdr2 = rf4aXbXc*rdr2

gen rf4aXrdr1X2 = rf4a*rdr1X2
gen rf4bXrdr1X2 = rf4b*rdr1X2
gen rf4cXrdr1X2 = rf4c*rdr1X2
gen rf4aXbXrdr1X2 = rf4aXb*rdr1X2
gen rf4aXcXrdr1X2 = rf4aXc*rdr1X2
gen rf4bXcXrdr1X2 = rf4bXc*rdr1X2
gen rf4aXbXcXrdr1X2 = rf4aXbXc*rdr1X2

**********

gen ref6aXrdr1 = ref6a*rdr1
gen ref6bXrdr1 = ref6b*rdr1
gen ref6aXrdr2 = ref6a*rdr2
gen ref6bXrdr2 = ref6b*rdr2
gen ref6aXrdr1X2 = ref6a*rdr1X2
gen ref6bXrdr1X2 = ref6b*rdr1X2

***************

gen rjobXrdr1 = rjob*rdr1
gen rjobXrdr2 = rjob*rdr2
gen rjobXrdr1X2 = rjob*rdr1X2

**************

gen rhs1Xrdr1 = rhs1*rdr1
gen rhs1Xrdr2 = rhs1*rdr2

gen rhs2Xrdr1 = rhs2*rdr1
gen rhs2Xrdr2 = rhs2*rdr2

gen rhs1Xrdr1X2 = rhs1*rdr1X2
gen rhs2Xrdr1X2 = rhs2*rdr1X2

**************

gen rst1Xrdr1 = rst1*rdr1
gen rst1Xrdr2 = rst1*rdr2
gen rst2Xrdr1 = rst2*rdr1
gen rst2Xrdr2 = rst2*rdr2
gen rst1X2Xrdr1 = rst1X2*rdr1
gen rst1X2Xrdr2 = rst1X2*rdr2

gen rst1Xrdr1X2 = rst1*rdr1X2
gen rst2Xrdr1X2 = rst2*rdr1X2
gen rst1X2Xrdr1X2 = rst1X2*rdr1X2

************

gen rtx1Xrdr1 = rtx1*rdr1
gen rtx1Xrdr2 = rtx1*rdr2
gen rtx2Xrdr1 = rtx2*rdr1
gen rtx2Xrdr2 = rtx2*rdr2
gen rtx1X2Xrdr1 = rtx1X2*rdr1
gen rtx1X2Xrdr2 = rtx1X2*rdr2

gen rtx1Xrdr1X2 = rtx1*rdr1X2
gen rtx2Xrdr1X2 = rtx2*rdr1X2
gen rtx1X2Xrdr1X2 = rtx1X2*rdr1X2

**************

gen rhm1Xrdr1 = rhm1*rdr1
gen rhm1Xrdr2 = rhm1*rdr2
gen rhm2Xrdr1 = rhm2*rdr1
gen rhm2Xrdr2 = rhm2*rdr2

gen rhm1Xrdr1X2 = rhm1*rdr1X2
gen rhm2Xrdr1X2 = rhm2*rdr1X2

*********

gen rag6Xrdr1X2 = rag6*rdr1X2
gen rag6Xrdr2 = rag6*rdr2
gen rag6Xrdr1 = rag6*rdr1

********

gen rlst1Xrdr1 = rlst1*rdr1
gen rlst1Xrdr2 = rlst1*rdr2
gen rlst2Xrdr1 = rlst2*rdr1
gen rlst2Xrdr2 = rlst2*rdr2

gen rlst1Xrdr1X2 = rlst1*rdr1X2
gen rlst2Xrdr1X2 = rlst2*rdr1X2

************

gen rcndXrdr1X2 = rcnd*rdr1X2
gen rcndXrdr2 = rcnd*rdr2
gen rcndXrdr1 = rcnd*rdr1

**********

gen rarsXrdr1X2 = rars*rdr1X2
gen rarsXrdr2 = rars*rdr2
gen rarsXrdr1 = rars*rdr1

/*========(13)==========*/

gen rwm1X2 = rwm1*rwm2

gen rf4aXrwm1 = rf4a*rwm1
gen rf4bXrwm1 = rf4b*rwm1
gen rf4cXrwm1 = rf4c*rwm1
gen rf4aXbXrwm1 = rf4aXb*rwm1
gen rf4aXcXrwm1 = rf4aXc*rwm1
gen rf4bXcXrwm1 = rf4bXc*rwm1
gen rf4aXbXcXrwm1 = rf4aXbXc*rwm1

gen rf4aXrwm2 = rf4a*rwm2
gen rf4bXrwm2 = rf4b*rwm2
gen rf4cXrwm2 = rf4c*rwm2
gen rf4aXbXrwm2 = rf4aXb*rwm2
gen rf4aXcXrwm2 = rf4aXc*rwm2
gen rf4bXcXrwm2 = rf4bXc*rwm2
gen rf4aXbXcXrwm2 = rf4aXbXc*rwm2

gen rf4aXrwm1X2 = rf4a*rwm1X2
gen rf4bXrwm1X2 = rf4b*rwm1X2
gen rf4cXrwm1X2 = rf4c*rwm1X2
gen rf4aXbXrwm1X2 = rf4aXb*rwm1X2
gen rf4aXcXrwm1X2 = rf4aXc*rwm1X2
gen rf4bXcXrwm1X2 = rf4bXc*rwm1X2
gen rf4aXbXcXrwm1X2 = rf4aXbXc*rwm1X2

**********

gen ref6aXrwm1 = ref6a*rwm1
gen ref6bXrwm1 = ref6b*rwm1
gen ref6aXrwm2 = ref6a*rwm2
gen ref6bXrwm2 = ref6b*rwm2
gen ref6aXrwm1X2 = ref6a*rwm1X2
gen ref6bXrwm1X2 = ref6b*rwm1X2

***************

gen rjobXrwm1 = rjob*rwm1
gen rjobXrwm2 = rjob*rwm2
gen rjobXrwm1X2 = rjob*rwm1X2

**************

gen rhs1Xrwm1 = rhs1*rwm1
gen rhs1Xrwm2 = rhs1*rwm2

gen rhs2Xrwm1 = rhs2*rwm1
gen rhs2Xrwm2 = rhs2*rwm2

gen rhs1Xrwm1X2 = rhs1*rwm1X2
gen rhs2Xrwm1X2 = rhs2*rwm1X2

**************

gen rst1Xrwm1 = rst1*rwm1
gen rst1Xrwm2 = rst1*rwm2
gen rst2Xrwm1 = rst2*rwm1
gen rst2Xrwm2 = rst2*rwm2
gen rst1X2Xrwm1 = rst1X2*rwm1
gen rst1X2Xrwm2 = rst1X2*rwm2

gen rst1Xrwm1X2 = rst1*rwm1X2
gen rst2Xrwm1X2 = rst2*rwm1X2
gen rst1X2Xrwm1X2 = rst1X2*rwm1X2

************

gen rtx1Xrwm1 = rtx1*rwm1
gen rtx1Xrwm2 = rtx1*rwm2
gen rtx2Xrwm1 = rtx2*rwm1
gen rtx2Xrwm2 = rtx2*rwm2
gen rtx1X2Xrwm1 = rtx1X2*rwm1
gen rtx1X2Xrwm2 = rtx1X2*rwm2

gen rtx1Xrwm1X2 = rtx1*rwm1X2
gen rtx2Xrwm1X2 = rtx2*rwm1X2
gen rtx1X2Xrwm1X2 = rtx1X2*rwm1X2

**************

gen rhm1Xrwm1 = rhm1*rwm1
gen rhm1Xrwm2 = rhm1*rwm2
gen rhm2Xrwm1 = rhm2*rwm1
gen rhm2Xrwm2 = rhm2*rwm2

gen rhm1Xrwm1X2 = rhm1*rwm1X2
gen rhm2Xrwm1X2 = rhm2*rwm1X2

*********

gen rag6Xrwm1X2 = rag6*rwm1X2
gen rag6Xrwm2 = rag6*rwm2
gen rag6Xrwm1 = rag6*rwm1

********

gen rlst1Xrwm1 = rlst1*rwm1
gen rlst1Xrwm2 = rlst1*rwm2
gen rlst2Xrwm1 = rlst2*rwm1
gen rlst2Xrwm2 = rlst2*rwm2

gen rlst1Xrwm1X2 = rlst1*rwm1X2
gen rlst2Xrwm1X2 = rlst2*rwm1X2

************

gen rcndXrwm1X2 = rcnd*rwm1X2
gen rcndXrwm2 = rcnd*rwm2
gen rcndXrwm1 = rcnd*rwm1

**********

gen rarsXrwm1X2 = rars*rwm1X2
gen rarsXrwm2 = rars*rwm2
gen rarsXrwm1 = rars*rwm1

*********

gen rdr1Xrwm1 = rdr1*rwm1
gen rdr1Xrwm2 = rdr1*rwm2
gen rdr1Xrwm1X2 = rdr1*rwm1X2
gen rdr2Xrwm1 = rdr2*rwm1
gen rdr2Xrwm2 = rdr2*rwm2
gen rdr2Xrwm1X2 = rdr2*rwm1X2
gen rdr1X2Xrwm1 = rdr1X2*rwm1
gen rdr1X2Xrwm2 = rdr1X2*rwm2
gen rdr1X2Xrwm1X2 = rdr1X2*rwm1X2

/*========(14)==========*/

gen rf4aXrimm = rf4a*rimm
gen rf4bXrimm = rf4b*rimm
gen rf4cXrimm = rf4c*rimm
gen rf4aXbXrimm = rf4aXb*rimm
gen rf4aXcXrimm = rf4aXc*rimm
gen rf4bXcXrimm = rf4bXc*rimm
gen rf4aXbXcXrimm = rf4aXbXc*rimm

********

gen ref6aXrimm = ref6a*rimm
gen ref6bXrimm = ref6b*rimm

*******

gen rjobXrimm = rjob*rimm

*******

gen rhs1Xrimm = rhs1*rimm
gen rhs2Xrimm = rhs2*rimm

********

gen rst1Xrimm = rst1*rimm
gen rst2Xrimm = rst2*rimm
gen rst1X2Xrimm = rst1X2*rimm

********

gen rtx1Xrimm = rtx1*rimm
gen rtx2Xrimm = rtx2*rimm
gen rtx1X2Xrimm = rtx1X2*rimm

**********

gen rhm1Xrimm = rhm1*rimm
gen rhm2Xrimm = rhm2*rimm

******

gen rag6Xrimm = rag6*rimm

*******

gen rlst1Xrimm = rlst1*rimm
gen rlst2Xrimm = rlst2*rimm

********

gen rcndXrimm = rcnd*rimm

*******

gen rarsXrimm = rars*rimm

********

gen rdr1Xrimm = rdr1*rimm
gen rdr2Xrimm = rdr2*rimm
gen rdr1X2Xrimm = rdr1X2*rimm

********

gen rwm1Xrimm = rwm1*rimm
gen rwm2Xrimm = rwm2*rimm
gen rwm1X2Xrimm = rwm1X2*rimm

/*========(15)==========*/

gen rf4aXrpor1 = rf4a*rpor1
gen rf4bXrpor1 = rf4b*rpor1
gen rf4cXrpor1 = rf4c*rpor1
gen rf4aXbXrpor1 = rf4aXb*rpor1
gen rf4aXcXrpor1 = rf4aXc*rpor1
gen rf4bXcXrpor1 = rf4bXc*rpor1
gen rf4aXbXcXrpor1 = rf4aXbXc*rpor1

gen rf4aXrpor2 = rf4a*rpor2
gen rf4bXrpor2 = rf4b*rpor2
gen rf4cXrpor2 = rf4c*rpor2
gen rf4aXbXrpor2 = rf4aXb*rpor2
gen rf4aXcXrpor2 = rf4aXc*rpor2
gen rf4bXcXrpor2 = rf4bXc*rpor2
gen rf4aXbXcXrpor2 = rf4aXbXc*rpor2

*******

gen ref6aXrpor1 = ref6a*rpor1
gen ref6bXrpor1 = ref6b*rpor1
gen ref6aXrpor2 = ref6a*rpor2
gen ref6bXrpor2 = ref6b*rpor2

***************

gen rjobXrpor1 = rjob*rpor1
gen rjobXrpor2 = rjob*rpor2

**************

gen rhs1Xrpor1 = rhs1*rpor1
gen rhs1Xrpor2 = rhs1*rpor2

gen rhs2Xrpor1 = rhs2*rpor1
gen rhs2Xrpor2 = rhs2*rpor2

**************

gen rst1Xrpor1 = rst1*rpor1
gen rst1Xrpor2 = rst1*rpor2
gen rst2Xrpor1 = rst2*rpor1
gen rst2Xrpor2 = rst2*rpor2
gen rst1X2Xrpor1 = rst1X2*rpor1
gen rst1X2Xrpor2 = rst1X2*rpor2

************

gen rtx1Xrpor1 = rtx1*rpor1
gen rtx1Xrpor2 = rtx1*rpor2
gen rtx2Xrpor1 = rtx2*rpor1
gen rtx2Xrpor2 = rtx2*rpor2
gen rtx1X2Xrpor1 = rtx1X2*rpor1
gen rtx1X2Xrpor2 = rtx1X2*rpor2

**************

gen rhm1Xrpor1 = rhm1*rpor1
gen rhm1Xrpor2 = rhm1*rpor2
gen rhm2Xrpor1 = rhm2*rpor1
gen rhm2Xrpor2 = rhm2*rpor2

*********

gen rag6Xrpor1 = rag6*rpor1
gen rag6Xrpor2 = rag6*rpor2

********

gen rlst1Xrpor1 = rlst1*rpor1
gen rlst1Xrpor2 = rlst1*rpor2
gen rlst2Xrpor1 = rlst2*rpor1
gen rlst2Xrpor2 = rlst2*rpor2

************

gen rcndXrpor1 = rcnd*rpor1
gen rcndXrpor2 = rcnd*rpor2

**********

gen rarsXrpor1 = rars*rpor1
gen rarsXrpor2 = rars*rpor2

*********

gen rdr1Xrpor1 = rdr1*rpor1
gen rdr1Xrpor2 = rdr1*rpor2
gen rdr2Xrpor1 = rdr2*rpor1
gen rdr2Xrpor2 = rdr2*rpor2
gen rdr1X2Xrpor1 = rdr1X2*rpor1
gen rdr1X2Xrpor2 = rdr1X2*rpor2

*********

gen rwm1Xrpor1 = rwm1*rpor1
gen rwm1Xrpor2 = rwm1*rpor2
gen rwm2Xrpor1 = rwm2*rpor1
gen rwm2Xrpor2 = rwm2*rpor2
gen rwm1X2Xrpor1 = rwm1X2*rpor1
gen rwm1X2Xrpor2 = rwm1X2*rpor2

*********

gen rimmXrpor1 = rimm*rpor1
gen rimmXrpor2 = rimm*rpor2

/*========(16)==========*/

gen rf4aXrunv = rf4a*runv
gen rf4bXrunv = rf4b*runv
gen rf4cXrunv = rf4c*runv
gen rf4aXbXrunv = rf4aXb*runv
gen rf4aXcXrunv = rf4aXc*runv
gen rf4bXcXrunv = rf4bXc*runv
gen rf4aXbXcXrunv = rf4aXbXc*runv

*********

gen ref6aXrunv = ref6a*runv
gen ref6bXrunv = ref6b*runv

*******

gen rjobXrunv = rjob*runv

*******

gen rhs1Xrunv = rhs1*runv
gen rhs2Xrunv = rhs2*runv

********

gen rst1Xrunv = rst1*runv
gen rst2Xrunv = rst2*runv
gen rst1X2Xrunv = rst1X2*runv

********

gen rtx1Xrunv = rtx1*runv
gen rtx2Xrunv = rtx2*runv
gen rtx1X2Xrunv = rtx1X2*runv

**********

gen rhm1Xrunv = rhm1*runv
gen rhm2Xrunv = rhm2*runv

******

gen rag6Xrunv = rag6*runv

*******

gen rlst1Xrunv = rlst1*runv
gen rlst2Xrunv = rlst2*runv

********

gen rcndXrunv = rcnd*runv

*******

gen rarsXrunv = rars*runv

********

gen rdr1Xrunv = rdr1*runv
gen rdr2Xrunv = rdr2*runv
gen rdr1X2Xrunv = rdr1X2*runv

********

gen rwm1Xrunv = rwm1*runv
gen rwm2Xrunv = rwm2*runv
gen rwm1X2Xrunv = rwm1X2*runv

********

gen rimmXrunv = rimm*runv

*********

gen rpor1Xrunv = rpor1*runv
gen rpor2Xrunv = rpor2*runv

/*========(17)==========*/

gen rf4aXrqt1 = rf4a*rqt1
gen rf4bXrqt1 = rf4b*rqt1
gen rf4cXrqt1 = rf4c*rqt1
gen rf4aXbXrqt1 = rf4aXb*rqt1
gen rf4aXcXrqt1 = rf4aXc*rqt1
gen rf4bXcXrqt1 = rf4bXc*rqt1
gen rf4aXbXcXrqt1 = rf4aXbXc*rqt1

gen rf4aXrqt2 = rf4a*rqt2
gen rf4bXrqt2 = rf4b*rqt2
gen rf4cXrqt2 = rf4c*rqt2
gen rf4aXbXrqt2 = rf4aXb*rqt2
gen rf4aXcXrqt2 = rf4aXc*rqt2
gen rf4bXcXrqt2 = rf4bXc*rqt2
gen rf4aXbXcXrqt2 = rf4aXbXc*rqt2

*********

gen ref6aXrqt1 = ref6a*rqt1
gen ref6bXrqt1 = ref6b*rqt1
gen ref6aXrqt2 = ref6a*rqt2
gen ref6bXrqt2 = ref6b*rqt2

***************

gen rjobXrqt1 = rjob*rqt1
gen rjobXrqt2 = rjob*rqt2

**************

gen rhs1Xrqt1 = rhs1*rqt1
gen rhs1Xrqt2 = rhs1*rqt2

gen rhs2Xrqt1 = rhs2*rqt1
gen rhs2Xrqt2 = rhs2*rqt2

**************

gen rst1Xrqt1 = rst1*rqt1
gen rst1Xrqt2 = rst1*rqt2
gen rst2Xrqt1 = rst2*rqt1
gen rst2Xrqt2 = rst2*rqt2
gen rst1X2Xrqt1 = rst1X2*rqt1
gen rst1X2Xrqt2 = rst1X2*rqt2

************

gen rtx1Xrqt1 = rtx1*rqt1
gen rtx1Xrqt2 = rtx1*rqt2
gen rtx2Xrqt1 = rtx2*rqt1
gen rtx2Xrqt2 = rtx2*rqt2
gen rtx1X2Xrqt1 = rtx1X2*rqt1
gen rtx1X2Xrqt2 = rtx1X2*rqt2

**************

gen rhm1Xrqt1 = rhm1*rqt1
gen rhm1Xrqt2 = rhm1*rqt2
gen rhm2Xrqt1 = rhm2*rqt1
gen rhm2Xrqt2 = rhm2*rqt2

*********

gen rag6Xrqt1 = rag6*rqt1
gen rag6Xrqt2 = rag6*rqt2

********

gen rlst1Xrqt1 = rlst1*rqt1
gen rlst1Xrqt2 = rlst1*rqt2
gen rlst2Xrqt1 = rlst2*rqt1
gen rlst2Xrqt2 = rlst2*rqt2

************

gen rcndXrqt1 = rcnd*rqt1
gen rcndXrqt2 = rcnd*rqt2

**********

gen rarsXrqt1 = rars*rqt1
gen rarsXrqt2 = rars*rqt2

*********

gen rdr1Xrqt1 = rdr1*rqt1
gen rdr1Xrqt2 = rdr1*rqt2
gen rdr2Xrqt1 = rdr2*rqt1
gen rdr2Xrqt2 = rdr2*rqt2
gen rdr1X2Xrqt1 = rdr1X2*rqt1
gen rdr1X2Xrqt2 = rdr1X2*rqt2

*********

gen rwm1Xrqt1 = rwm1*rqt1
gen rwm1Xrqt2 = rwm1*rqt2
gen rwm2Xrqt1 = rwm2*rqt1
gen rwm2Xrqt2 = rwm2*rqt2
gen rwm1X2Xrqt1 = rwm1X2*rqt1
gen rwm1X2Xrqt2 = rwm1X2*rqt2

*********

gen rimmXrqt1 = rimm*rqt1
gen rimmXrqt2 = rimm*rqt2

********

gen rpor1Xrqt1 = rpor1*rqt1
gen rpor1Xrqt2 = rpor1*rqt2
gen rpor2Xrqt1 = rpor2*rqt1
gen rpor2Xrqt2 = rpor2*rqt2

*********

gen runvXrqt1 = runv*rqt1
gen runvXrqt2 = runv*rqt2

****************
** END *********
****************

sort caseid

save transue_recoded.dta, replace


