version 10.1
clear
set memory 10m
set more off
use transue_recoded.dta
set matsize 150

#delimit ;

capture log close;
log using treat1.log, replace;

/**************************
** Duration of Treatment 1
**************************/

svyoprobit ef6 ref6a ref6b rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rf4aXref6a rf4aXref6b rf4bXref6a
rf4bXref6b rf4cXref6a rf4cXref6b rf4aXbXref6a rf4aXbXref6b rf4aXcXref6a rf4aXcXref6b rf4bXcXref6a
rf4bXcXref6b rf4aXbXcXref6a rf4aXbXcXref6b, subpop(white) ;

svyprobit jobs rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rjob rf4aXrjob rf4bXrjob rf4cXrjob
rf4aXbXrjob rf4aXcXrjob rf4bXcXrjob rf4aXbXcXrjob, subpop(white) ;

svyoprobit hse2 rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rhs1 rf4aXrhs1 rf4bXrhs1 rf4cXrhs1
rf4aXbXrhs1 rf4aXcXrhs1 rf4bXcXrhs1 rf4aXbXcXrhs1 rhs2 rf4aXrhs2 rf4bXrhs2 rf4cXrhs2 rf4aXbXrhs2 rf4aXcXrhs2
rf4bXcXrhs2 rf4aXbXcXrhs2 if hous==1 | hous==3, subpop(white) ;

svyprobit set rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rst1 rf4aXrst1 rf4bXrst1 rf4cXrst1 rf4aXbXrst1 
rf4aXcXrst1 rf4bXcXrst1 rf4aXbXcXrst1  rst2 rf4aXrst2 rf4bXrst2 rf4cXrst2 rf4aXbXrst2 rf4aXcXrst2 rf4bXcXrst2 
rf4aXbXcXrst2 rst1X2 rf4aXrst1X2 rf4bXrst1X2 rf4cXrst1X2 rf4aXbXrst1X2 rf4aXcXrst1X2 rf4bXcXrst1X2 
rf4aXbXcXrst1X2, subpop(white) ;

svyprobit tax rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rtx1 rf4aXrtx1 rf4bXrtx1 rf4cXrtx1 rf4aXbXrtx1 
rf4aXcXrtx1 rf4bXcXrtx1 rf4aXbXcXrtx1  rtx2 rf4aXrtx2 rf4bXrtx2 rf4cXrtx2 rf4aXbXrtx2 rf4aXcXrtx2 rf4bXcXrtx2 
rf4aXbXcXrtx2 rtx1X2 rf4aXrtx1X2 rf4bXrtx1X2 rf4cXrtx1X2 rf4aXbXrtx1X2 rf4aXcXrtx1X2 rf4bXcXrtx1X2 
rf4aXbXcXrtx1X2, subpop(white) ;

svyprobit home rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rhm1 rf4aXrhm1 rf4bXrhm1 rf4cXrhm1 rf4aXbXrhm1 
rf4aXcXrhm1 rf4bXcXrhm1 rf4aXbXcXrhm1 rhm2 rf4aXrhm2 rf4bXrhm2 rf4cXrhm2 rf4aXbXrhm2 rf4aXcXrhm2 rf4bXcXrhm2 
rf4aXbXcXrhm2, subpop(white) ;

svyoprobit ang6 rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rag6 rf4aXrag6 rf4bXrag6 rf4cXrag6 rf4aXbXrag6 
rf4aXcXrag6 rf4bXcXrag6 rf4aXbXcXrag6, subpop(white) ;

svyoprobit list rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rlst1 rf4aXrlst1 rf4bXrlst1 rf4cXrlst1 rf4aXbXrlst1 
rf4aXcXrlst1 rf4bXcXrlst1 rf4aXbXcXrlst1 rlst2 rf4aXrlst2 rf4bXrlst2 rf4cXrlst2 rf4aXbXrlst2 rf4aXcXrlst2 
rf4bXcXrlst2 rf4aXbXcXrlst2 , subpop(white) ;

svyoprobit cand rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rcnd rf4aXrcnd rf4bXrcnd rf4cXrcnd rf4aXbXrcnd 
rf4aXcXrcnd rf4bXcXrcnd rf4aXbXcXrcnd , subpop(white) ;

svyoprobit arst rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rars rf4aXrars rf4bXrars rf4cXrars rf4aXbXrars 
rf4aXcXrars rf4bXcXrars rf4aXbXcXrars, subpop(white) ;

svyoprobit drug rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rdr1 rf4aXrdr1 rf4bXrdr1 rf4cXrdr1 rf4aXbXrdr1 
rf4aXcXrdr1 rf4bXcXrdr1 rf4aXbXcXrdr1  rdr2 rf4aXrdr2 rf4bXrdr2 rf4cXrdr2 rf4aXbXrdr2 rf4aXcXrdr2 rf4bXcXrdr2 
rf4aXbXcXrdr2 rdr1X2 rf4aXrdr1X2 rf4bXrdr1X2 rf4cXrdr1X2 rf4aXbXrdr1X2 rf4aXcXrdr1X2 rf4bXcXrdr1X2 
rf4aXbXcXrdr1X2, subpop(white) ;

svyoprobit wmom rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rwm1 rf4aXrwm1 rf4bXrwm1 rf4cXrwm1 rf4aXbXrwm1 
rf4aXcXrwm1 rf4bXcXrwm1 rf4aXbXcXrwm1  rwm2 rf4aXrwm2 rf4bXrwm2 rf4cXrwm2 rf4aXbXrwm2 rf4aXcXrwm2 rf4bXcXrwm2 
rf4aXbXcXrwm2 rwm1X2 rf4aXrwm1X2 rf4bXrwm1X2 rf4cXrwm1X2 rf4aXbXrwm1X2 rf4aXcXrwm1X2 rf4bXcXrwm1X2 
rf4aXbXcXrwm1X2, subpop(white) ;

svyoprobit wmk rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rwm1 rf4aXrwm1 rf4bXrwm1 rf4cXrwm1 rf4aXbXrwm1 
rf4aXcXrwm1 rf4bXcXrwm1 rf4aXbXcXrwm1  rwm2 rf4aXrwm2 rf4bXrwm2 rf4cXrwm2 rf4aXbXrwm2 rf4aXcXrwm2 rf4bXcXrwm2 
rf4aXbXcXrwm2 rwm1X2 rf4aXrwm1X2 rf4bXrwm1X2 rf4cXrwm1X2 rf4aXbXrwm1X2 rf4aXcXrwm1X2 rf4bXcXrwm1X2 
rf4aXbXcXrwm1X2, subpop(white) ;

svyoprobit imm rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rimm rf4aXrimm rf4bXrimm rf4cXrimm rf4aXbXrimm 
rf4aXcXrimm rf4bXcXrimm rf4aXbXcXrimm, subpop(white) ;

svyoprobit poor rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rpor1 rf4aXrpor1 rf4bXrpor1 rf4cXrpor1 rf4aXbXrpor1 
rf4aXcXrpor1 rf4bXcXrpor1 rf4aXbXcXrpor1 rpor2 rf4aXrpor2 rf4bXrpor2 rf4cXrpor2 rf4aXbXrpor2 rf4aXcXrpor2 rf4bXcXrpor2 
rf4aXbXcXrpor2, subpop(white) ;

svyprobit univ rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc runv rf4aXrunv rf4bXrunv rf4cXrunv rf4aXbXrunv 
rf4aXcXrunv rf4bXcXrunv rf4aXbXcXrunv, subpop(white) ;

svyprobit quot rf4a rf4b rf4c rf4aXb rf4aXc rf4bXc rf4aXbXc rqt1 rf4aXrqt1 rf4bXrqt1 rf4cXrqt1 rf4aXbXrqt1 
rf4aXcXrqt1 rf4bXcXrqt1 rf4aXbXcXrqt1 rqt2 rf4aXrqt2 rf4bXrqt2 rf4cXrqt2 rf4aXbXrqt2 rf4aXcXrqt2 rf4bXcXrqt2 
rf4aXbXcXrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat2.log, replace ;

/**************************
** Duration of Treatment 2: ref6a ref6b
**************************/
svyprobit jobs ref6a ref6b rjob ref6aXrjob ref6bXrjob, subpop(white) ;

svyoprobit hse2 ref6a ref6b rhs1 ref6aXrhs1 ref6bXrhs1 rhs2 ref6aXrhs2 ref6bXrhs2, subpop(white) ;

svyprobit set ref6a ref6b rst1 ref6aXrst1 ref6bXrst1 rst2 ref6aXrst2 ref6bXrst2 rst1X2 ref6aXrst1X2 
ref6bXrst1X2, subpop(white) ;

svyprobit tax ref6a ref6b rtx1 ref6aXrtx1 ref6bXrtx1 rtx2 ref6aXrtx2 ref6bXrtx2 rtx1X2 ref6aXrtx1X2 
ref6bXrtx1X2, subpop(white) ;

svyprobit home ref6a ref6b rhm1 ref6aXrhm1 ref6bXrhm1 rhm2 ref6aXrhm2 ref6bXrhm2, subpop(white) ;

svyoprobit ang6 ref6a ref6b rag6 ref6aXrag6 ref6bXrag6, subpop(white) ;

svyoprobit list ref6a ref6b rlst1 ref6aXrlst1 ref6bXrlst1 rlst2 ref6aXrlst2 ref6bXrlst2, subpop(white) ;

svyoprobit cand ref6a ref6b rcnd ref6aXrcnd ref6bXrcnd, subpop(white) ;

svyoprobit arst ref6a ref6b rars ref6aXrars ref6bXrars, subpop(white) ;

svyoprobit drug ref6a ref6b rdr1 ref6aXrdr1 ref6bXrdr1 rdr2 ref6aXrdr2 ref6bXrdr2 rdr1X2 ref6aXrdr1X2 
ref6bXrdr1X2, subpop(white) ;

svyoprobit wmom ref6a ref6b rwm1 ref6aXrwm1 ref6bXrwm1 rwm2 ref6aXrwm2 ref6bXrwm2 rwm1X2 ref6aXrwm1X2 
ref6bXrwm1X2, subpop(white) ;

svyoprobit wmk ref6a ref6b rwm1 ref6aXrwm1 ref6bXrwm1 rwm2 ref6aXrwm2 ref6bXrwm2 rwm1X2 ref6aXrwm1X2 
ref6bXrwm1X2, subpop(white) ;

svyoprobit imm ref6a ref6b rimm ref6aXrimm ref6bXrimm, subpop(white) ;

svyoprobit poor ref6a ref6b rpor1 ref6aXrpor1 ref6bXrpor1 rpor2 ref6aXrpor2 ref6bXrpor2, subpop(white) ;

svyprobit univ ref6a ref6b runv ref6aXrunv ref6bXrunv, subpop(white) ;

svyprobit quot ref6a ref6b rqt1 ref6aXrqt1 ref6bXrqt1 rqt2 ref6aXrqt2 ref6bXrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat3.log, replace ;

/**************************
** Duration of Treatment 3: rjob
**************************/

svyoprobit hse2 rjob rhs1 rjobXrhs1 rhs2 rjobXrhs2, subpop(white) ;

svyprobit set rjob rst1 rjobXrst1 rst2 rjobXrst2 rst1X2 rjobXrst1X2, subpop(white) ;

svyprobit tax rjob rtx1 rjobXrtx1 rtx2 rjobXrtx2 rtx1X2 rjobXrtx1X2, subpop(white) ;

svyprobit home rjob rhm1 rjobXrhm1 rhm2 rjobXrhm2, subpop(white) ;

svyoprobit ang6 rjob rag6 rjobXrag6, subpop(white) ;

svyoprobit list rjob rlst1 rjobXrlst1 rlst2 rjobXrlst2, subpop(white) ;

svyoprobit cand rjob rcnd rjobXrcnd, subpop(white) ;

svyoprobit arst rjob rars rjobXrars, subpop(white) ;

svyoprobit drug rjob rdr1 rjobXrdr1 rdr2 rjobXrdr2 rdr1X2 rjobXrdr1X2, subpop(white) ;

svyoprobit wmom rjob rwm1 rjobXrwm1 rwm2 rjobXrwm2 rwm1X2 rjobXrwm1X2, subpop(white) ;

svyoprobit wmk rjob rwm1 rjobXrwm1 rwm2 rjobXrwm2 rwm1X2 rjobXrwm1X2, subpop(white) ;

svyoprobit imm rjob rimm rjobXrimm, subpop(white) ;

svyoprobit poor rjob rpor1 rjobXrpor1 rpor2 rjobXrpor2, subpop(white) ;

svyprobit univ rjob runv rjobXrunv, subpop(white) ;

svyprobit quot rjob rqt1 rjobXrqt1 rqt2 rjobXrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat4a.log, replace ;

/**************************
** Duration of Treatment 4a: rhs1 rhs2.
** Not all respondents got this treatment. Depends upon answer to "hous".
**************************/

svyprobit set rhs1 rhs2 rst1 rhs1Xrst1 rhs2Xrst1 rst2 rhs1Xrst2 rhs2Xrst2 rst1X2 rhs1Xrst1X2 
rhs2Xrst1X2 if hous==1 | hous==3, subpop(white) ;

svyprobit tax rhs1 rhs2 rtx1 rhs1Xrtx1 rhs2Xrtx1 rtx2 rhs1Xrtx2 rhs2Xrtx2 rtx1X2 rhs1Xrtx1X2 
rhs2Xrtx1X2 if hous==1 | hous==3, subpop(white) ;

svyprobit home rhs1 rhs2 rhm1 rhs1Xrhm1 rhs2Xrhm1 rhm2 rhs1Xrhm2 rhs2Xrhm2 if hous==1 | hous==3, subpop(white) ;

svyoprobit ang6 rhs1 rhs2 rag6 rhs1Xrag6 rhs2Xrag6 if hous==1 | hous==3, subpop(white) ;

svyoprobit list rhs1 rhs2 rlst1 rhs1Xrlst1 rhs2Xrlst1 rlst2 rhs1Xrlst2 rhs2Xrlst2 if hous==1 | hous==3, subpop(white) ;

svyoprobit cand rhs1 rhs2 rcnd rhs1Xrcnd rhs2Xrcnd if hous==1 | hous==3, subpop(white) ;

svyoprobit arst rhs1 rhs2 rars rhs1Xrars rhs2Xrars if hous==1 | hous==3, subpop(white) ;

svyoprobit drug rhs1 rhs2 rdr1 rhs1Xrdr1 rhs2Xrdr1 rdr2 rhs1Xrdr2 rhs2Xrdr2 rdr1X2 rhs1Xrdr1X2 
rhs2Xrdr1X2 if hous==1 | hous==3, subpop(white) ;

svyoprobit wmom rhs1 rhs2 rwm1 rhs1Xrwm1 rhs2Xrwm1 rwm2 rhs1Xrwm2 rhs2Xrwm2 rwm1X2 rhs1Xrwm1X2 
rhs2Xrwm1X2 if hous==1 | hous==3, subpop(white) ;

svyoprobit wmk rhs1 rhs2 rwm1 rhs1Xrwm1 rhs2Xrwm1 rwm2 rhs1Xrwm2 rhs2Xrwm2 rwm1X2 rhs1Xrwm1X2 
rhs2Xrwm1X2 if hous==1 | hous==3, subpop(white) ;

svyoprobit imm rhs1 rhs2 rimm rhs1Xrimm rhs2Xrimm if hous==1 | hous==3, subpop(white) ;

svyoprobit poor rhs1 rhs2 rpor1 rhs1Xrpor1 rhs2Xrpor1 rpor2 rhs1Xrpor2 rhs2Xrpor2 if hous==1 | hous==3, subpop(white) ;

svyprobit univ rhs1 rhs2 runv rhs1Xrunv rhs2Xrunv if hous==1 | hous==3, subpop(white) ;

svyprobit quot rhs1 rhs2 rqt1 rhs1Xrqt1 rhs2Xrqt1 rqt2 rhs1Xrqt2 rhs2Xrqt2 if hous==1 | hous==3, subpop(white) ;

log close; 

capture log close ;
log using treat4.log, replace ;

/**************************
** Duration of Treatment 4: rst1, rst2, rst1X2
**************************/

svyprobit tax rst1 rst2 rst1X2 rtx1 rst1Xrtx1 rst2Xrtx1 rst1X2Xrtx1 rtx2 rst1Xrtx2 rst2Xrtx2 
rst1X2Xrtx2 rtx1X2 rst1Xrtx1X2 rst2Xrtx1X2 rst1X2Xrtx1X2, subpop(white) ;

svyprobit home rst1 rst2 rst1X2 rhm1 rst1Xrhm1 rst2Xrhm1 rst1X2Xrhm1 rhm2 rst1Xrhm2 rst2Xrhm2 
rst1X2Xrhm2, subpop(white) ;

svyoprobit ang6 rst1 rst2 rst1X2 rag6 rst1Xrag6 rst2Xrag6 rst1X2Xrag6, subpop(white) ;

svyoprobit list rst1 rst2 rst1X2 rlst1 rst1Xrlst1 rst2Xrlst1 rst1X2Xrlst1 rlst2 rst1Xrlst2 
rst2Xrlst2 rst1X2Xrlst2, subpop(white) ;

svyoprobit cand rst1 rst2 rst1X2 rcnd rst1Xrcnd rst2Xrcnd rst1X2Xrcnd, subpop(white) ;

svyoprobit arst rst1 rst2 rst1X2 rars rst1Xrars rst2Xrars rst1X2Xrars, subpop(white) ;

svyoprobit drug rst1 rst2 rst1X2 rdr1 rst1Xrdr1 rst2Xrdr1 rst1X2Xrdr1 rdr2 rst1Xrdr2 rst2Xrdr2 
rst1X2Xrdr2 rdr1X2 rst1Xrdr1X2 rst2Xrdr1X2 rst1X2Xrdr1X2, subpop(white) ;

svyoprobit wmom rst1 rst2 rst1X2 rwm1 rst1Xrwm1 rst2Xrwm1 rst1X2Xrwm1 rwm2 rst1Xrwm2 rst2Xrwm2 
rst1X2Xrwm2 rwm1X2 rst1Xrwm1X2 rst2Xrwm1X2 rst1X2Xrwm1X2, subpop(white) ;

svyoprobit wmk rst1 rst2 rst1X2 rwm1 rst1Xrwm1 rst2Xrwm1 rst1X2Xrwm1 rwm2 rst1Xrwm2 rst2Xrwm2 
rst1X2Xrwm2 rwm1X2 rst1Xrwm1X2 rst2Xrwm1X2 rst1X2Xrwm1X2, subpop(white) ;

svyoprobit imm rst1 rst2 rst1X2 rimm rst1Xrimm rst2Xrimm rst1X2Xrimm, subpop(white) ;

svyoprobit poor rst1 rst2 rst1X2 rpor1 rst1Xrpor1 rst2Xrpor1 rst1X2Xrpor1 rpor2 rst1Xrpor2 
rst2Xrpor2 rst1X2Xrpor2, subpop(white) ;

svyprobit univ rst1 rst2 rst1X2 runv rst1Xrunv rst2Xrunv rst1X2Xrunv, subpop(white) ;

svyprobit quot rst1 rst2 rst1X2 rqt1 rst1Xrqt1 rst2Xrqt1 rst1X2Xrqt1 rqt2 rst1Xrqt2 rst2Xrqt2 rst1X2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat5.log, replace ;

/**************************
** Duration of Treatment 5: rtx1, rtx2, and rtx1X2
**************************/

svyprobit home rtx1 rtx2 rtx1X2 rhm1 rtx1Xrhm1 rtx2Xrhm1 rtx1X2Xrhm1 rhm2 rtx1Xrhm2 rtx2Xrhm2 
rtx1X2Xrhm2, subpop(white) ;

svyoprobit ang6 rtx1 rtx2 rtx1X2 rag6 rtx1Xrag6 rtx2Xrag6 rtx1X2Xrag6, subpop(white) ;

svyoprobit list rtx1 rtx2 rtx1X2 rlst1 rtx1Xrlst1 rtx2Xrlst1 rtx1X2Xrlst1 rlst2 rtx1Xrlst2 
rtx2Xrlst2 rtx1X2Xrlst2, subpop(white) ;

svyoprobit cand rtx1 rtx2 rtx1X2 rcnd rtx1Xrcnd rtx2Xrcnd rtx1X2Xrcnd, subpop(white) ;

svyoprobit arst rtx1 rtx2 rtx1X2 rars rtx1Xrars rtx2Xrars rtx1X2Xrars, subpop(white) ;

svyoprobit drug rtx1 rtx2 rtx1X2 rdr1 rtx1Xrdr1 rtx2Xrdr1 rtx1X2Xrdr1 rdr2 rtx1Xrdr2 rtx2Xrdr2 
rtx1X2Xrdr2 rdr1X2 rtx1Xrdr1X2 rtx2Xrdr1X2 rtx1X2Xrdr1X2, subpop(white) ;

svyoprobit wmom rtx1 rtx2 rtx1X2 rwm1 rtx1Xrwm1 rtx2Xrwm1 rtx1X2Xrwm1 rwm2 rtx1Xrwm2 rtx2Xrwm2 
rtx1X2Xrwm2 rwm1X2 rtx1Xrwm1X2 rtx2Xrwm1X2 rtx1X2Xrwm1X2, subpop(white) ;

svyoprobit wmk rtx1 rtx2 rtx1X2 rwm1 rtx1Xrwm1 rtx2Xrwm1 rtx1X2Xrwm1 rwm2 rtx1Xrwm2 rtx2Xrwm2 
rtx1X2Xrwm2 rwm1X2 rtx1Xrwm1X2 rtx2Xrwm1X2 rtx1X2Xrwm1X2, subpop(white) ;

svyoprobit imm rtx1 rtx2 rtx1X2 rimm rtx1Xrimm rtx2Xrimm rtx1X2Xrimm, subpop(white) ;

svyoprobit poor rtx1 rtx2 rtx1X2 rpor1 rtx1Xrpor1 rtx2Xrpor1 rtx1X2Xrpor1 rpor2 rtx1Xrpor2 
rtx2Xrpor2 rtx1X2Xrpor2, subpop(white) ;

svyprobit univ rtx1 rtx2 rtx1X2 runv rtx1Xrunv rtx2Xrunv rtx1X2Xrunv, subpop(white) ;

svyprobit quot rtx1 rtx2 rtx1X2 rqt1 rtx1Xrqt1 rtx2Xrqt1 rtx1X2Xrqt1 rqt2 rtx1Xrqt2 rtx2Xrqt2 rtx1X2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat6.log, replace ;

/**************************
** Duration of Treatment 6: rhm1 and rhm2
**************************/

svyoprobit ang6 rhm1 rhm2 rag6 rhm1Xrag6 rhm2Xrag6 , subpop(white) ;

svyoprobit list rhm1 rhm2 rlst1 rhm1Xrlst1 rhm2Xrlst1 rlst2 rhm1Xrlst2 rhm2Xrlst2, subpop(white) ;

svyoprobit cand rhm1 rhm2 rcnd rhm1Xrcnd rhm2Xrcnd, subpop(white) ;

svyoprobit arst rhm1 rhm2 rars rhm1Xrars rhm2Xrars, subpop(white) ;

svyoprobit drug rhm1 rhm2 rdr1 rhm1Xrdr1 rhm2Xrdr1 rdr2 rhm1Xrdr2 rhm2Xrdr2 rdr1X2 rhm1Xrdr1X2 rhm2Xrdr1X2, subpop(white) ;

svyoprobit wmom rhm1 rhm2 rwm1 rhm1Xrwm1 rhm2Xrwm1 rwm2 rhm1Xrwm2 rhm2Xrwm2 rwm1X2 rhm1Xrwm1X2 rhm2Xrwm1X2, subpop(white) ;

svyoprobit wmk rhm1 rhm2 rwm1 rhm1Xrwm1 rhm2Xrwm1 rwm2 rhm1Xrwm2 rhm2Xrwm2 rwm1X2 rhm1Xrwm1X2 rhm2Xrwm1X2, subpop(white) ;

svyoprobit imm rhm1 rhm2 rimm rhm1Xrimm rhm2Xrimm, subpop(white);

svyoprobit poor rhm1 rhm2 rpor1 rhm1Xrpor1 rhm2Xrpor1 rpor2 rhm1Xrpor2 rhm2Xrpor2, subpop(white);

svyprobit univ rhm1 rhm2 runv rhm1Xrun rhm2Xrunv, subpop(white) ;

svyprobit quot rhm1 rhm2 rqt1 rhm1Xrqt1 rhm2Xrqt1 rqt2 rhm1Xrqt2 rhm2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat7.log, replace ;

/**************************
** Duration of Treatment 7: rag6
**************************/

svyoprobit list rag6 rlst1 rag6Xrlst1 rlst2 rag6Xrlst2, subpop(white) ;

svyoprobit cand rag6 rcnd rag6Xrcnd, subpop(white) ;

svyoprobit arst rag6 rars rag6Xrars, subpop(white) ;

svyoprobit drug rag6 rdr1 rag6Xrdr1 rdr2 rag6Xrdr2 rdr1X2 rag6Xrdr1X2, subpop(white) ;

svyoprobit wmom rag6 rwm1 rag6Xrwm1 rwm2 rag6Xrwm2 rwm1X2 rag6Xrwm1X2, subpop(white) ;

svyoprobit wmk rag6 rwm1 rag6Xrwm1 rwm2 rag6Xrwm2 rwm1X2 rag6Xrwm1X2, subpop(white) ;

svyoprobit imm rag6 rimm rag6Xrimm, subpop(white) ;

svyoprobit poor rag6 rpor1 rag6Xrpor1 rpor2 rag6Xrpor2, subpop(white) ;

svyprobit univ rag6 runv rag6Xrunv, subpop(white) ;

svyprobit quot rag6 rqt1 rag6Xrqt1 rqt2 rag6Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat8.log, replace ;

/**************************
** Duration of Treatment 8: rlst1 and rlst2
**************************/

svyoprobit cand rlst1 rlst2 rcnd rlst1Xrcnd rlst2Xrcnd, subpop(white) ;

svyoprobit arst rlst1 rlst2 rars rlst1Xrars rlst2Xrars, subpop(white) ;

svyoprobit drug rlst1 rlst2 rdr1 rlst1Xrdr1 rlst2Xrdr1 rdr2 rlst1Xrdr2 rlst2Xrdr2 rdr1X2 
rlst1Xrdr1X2 rlst2Xrdr1X2, subpop(white) ;

svyoprobit wmom rlst1 rlst2 rwm1 rlst1Xrwm1 rlst2Xrwm1 rwm2 rlst1Xrwm2 rlst2Xrwm2 rwm1X2 
rlst1Xrwm1X2 rlst2Xrwm1X2, subpop(white) ;

svyoprobit wmk rlst1 rlst2 rwm1 rlst1Xrwm1 rlst2Xrwm1 rwm2 rlst1Xrwm2 rlst2Xrwm2 rwm1X2 
rlst1Xrwm1X2 rlst2Xrwm1X2, subpop(white) ;

svyoprobit imm rlst1 rlst2 rimm rlst1Xrimm rlst2Xrimm, subpop(white);

svyoprobit poor rlst1 rlst2 rpor1 rlst1Xrpor1 rlst2Xrpor1 rpor2 rlst1Xrpor2 rlst2Xrpor2, subpop(white);

svyprobit univ rlst1 rlst2 runv rlst1Xrun rlst2Xrunv, subpop(white) ;

svyprobit quot rlst1 rlst2 rqt1 rlst1Xrqt1 rlst2Xrqt1 rqt2 rlst1Xrqt2 rlst2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat9.log, replace ;

/**************************
** Duration of Treatment 9: rcnd
**************************/

svyoprobit arst rcnd rars rcndXrars, subpop(white) ;

svyoprobit drug rcnd rdr1 rcndXrdr1 rdr2 rcndXrdr2 rdr1X2 rcndXrdr1X2, subpop(white) ;

svyoprobit wmom rcnd rwm1 rcndXrwm1 rwm2 rcndXrwm2 rwm1X2 rcndXrwm1X2, subpop(white) ;

svyoprobit wmk rcnd rwm1 rcndXrwm1 rwm2 rcndXrwm2 rwm1X2 rcndXrwm1X2, subpop(white) ;

svyoprobit imm rcnd rimm rcndXrimm, subpop(white) ;

svyoprobit poor rcnd rpor1 rcndXrpor1 rpor2 rcndXrpor2, subpop(white) ;

svyprobit univ rcnd runv rcndXrunv, subpop(white) ;

svyprobit quot rcnd rqt1 rcndXrqt1 rqt2 rcndXrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat10.log, replace ;

/**************************
** Duration of Treatment 10: rars
**************************/

svyoprobit drug rars rdr1 rarsXrdr1 rdr2 rarsXrdr2 rdr1X2 rarsXrdr1X2, subpop(white) ;

svyoprobit wmom rars rwm1 rarsXrwm1 rwm2 rarsXrwm2 rwm1X2 rarsXrwm1X2, subpop(white) ;

svyoprobit wmk rars rwm1 rarsXrwm1 rwm2 rarsXrwm2 rwm1X2 rarsXrwm1X2, subpop(white) ;

svyoprobit imm rars rimm rarsXrimm, subpop(white) ;

svyoprobit poor rars rpor1 rarsXrpor1 rpor2 rarsXrpor2, subpop(white) ;

svyprobit univ rars runv rarsXrunv, subpop(white) ;

svyprobit quot rars rqt1 rarsXrqt1 rqt2 rarsXrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat11.log, replace ;

/**************************
** Duration of Treatment 11: rdr1, rdr2, rdr1X2
**************************/

svyoprobit wmom rdr1 rdr2 rdr1X2 rwm1 rdr1Xrwm1 rdr2Xrwm1 rdr1X2Xrwm1 rwm2 rdr1Xrwm2 rdr2Xrwm2 
rdr1X2Xrwm2 rwm1X2 rdr1Xrwm1X2 rdr2Xrwm1X2 rdr1X2Xrwm1X2, subpop(white) ;

svyoprobit wmk rdr1 rdr2 rdr1X2 rwm1 rdr1Xrwm1 rdr2Xrwm1 rdr1X2Xrwm1 rwm2 rdr1Xrwm2 rdr2Xrwm2 
rdr1X2Xrwm2 rwm1X2 rdr1Xrwm1X2 rdr2Xrwm1X2 rdr1X2Xrwm1X2, subpop(white) ;

svyoprobit imm rdr1 rdr2 rdr1X2 rimm rdr1Xrimm rdr2Xrimm rdr1X2Xrimm, subpop(white) ;

svyoprobit poor rdr1 rdr2 rdr1X2 rpor1 rdr1Xrpor1 rdr2Xrpor1 rdr1X2Xrpor1 rpor2 rdr1Xrpor2 
rdr2Xrpor2 rdr1X2Xrpor2, subpop(white) ;

svyprobit univ rdr1 rdr2 rdr1X2 runv rdr1Xrunv rdr2Xrunv rdr1X2Xrunv, subpop(white) ;

svyprobit quot rdr1 rdr2 rdr1X2 rqt1 rdr1Xrqt1 rdr2Xrqt1 rdr1X2Xrqt1 rqt2 rdr1Xrqt2 rdr2Xrqt2 rdr1X2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat12.log, replace ;

/**************************
** Duration of Treatment 12: rwm1, rwm2, rwm1X2
**************************/

svyoprobit imm rwm1 rwm2 rwm1X2 rimm rwm1Xrimm rwm2Xrimm rwm1X2Xrimm, subpop(white) ;

svyoprobit poor rwm1 rwm2 rwm1X2 rpor1 rwm1Xrpor1 rwm2Xrpor1 rwm1X2Xrpor1 rpor2 rwm1Xrpor2 
rwm2Xrpor2 rwm1X2Xrpor2, subpop(white) ;

svyprobit univ rwm1 rwm2 rwm1X2 runv rwm1Xrunv rwm2Xrunv rwm1X2Xrunv, subpop(white) ;

svyprobit quot rwm1 rwm2 rwm1X2 rqt1 rwm1Xrqt1 rwm2Xrqt1 rwm1X2Xrqt1 rqt2 rwm1Xrqt2 rwm2Xrqt2 rwm1X2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat13.log, replace ;

/**************************
** Duration of Treatment 13: rwm1, rwm2, rwm1X2
**************************/

svyoprobit poor rimm rpor1 rimmXrpor1 rpor2 rimmXrpor2, subpop(white) ;

svyprobit univ rimm runv rimmXrunv, subpop(white) ;

svyprobit quot rimm rqt1 rimmXrqt1 rqt2 rimmXrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat14.log, replace ;

/**************************
** Duration of Treatment 14: rpor1 and rpor2
**************************/

svyprobit univ rpor1 rpor2 runv rpor1Xrun rpor2Xrunv, subpop(white) ;

svyprobit quot rpor1 rpor2 rqt1 rpor1Xrqt1 rpor2Xrqt1 rqt2 rpor1Xrqt2 rpor2Xrqt2, subpop(white) ;

log close; 

capture log close ;
log using treat15.log, replace ;

/**************************
** Duration of Treatment 15: runv
**************************/

svyprobit quot runv rqt1 runvXrqt1 rqt2 runvXrqt2, subpop(white) ;

log close;

