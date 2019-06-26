
/**************************************************************************

This Stata do file produces the regression results reported in 

Collier, Paul, Anke Hoeffler, and Mans Soderbom (2008). "Post-Conflict Risks," Journal of Peace Research.

Please cite this paper when using the data.

Thank you.

Mans Soderbom, University of Gothenburg
February 2008.

**************************************************************************/

use c:\peacedur\revisions_jpr\chs_postconflictrisk08, clear

/* Update, July 2010: 
An earlier version of this do file inadvertently omitted information about the entry year for each post-conflict episode. As a consequence, 
the results reported in the paper could not be replicated. This problem can be solved by adding three lines identifying the entry
year of each episode, and modifying the stset command accordingly. 
*/

/*** new lines begin here ***/
sort warnumb pdur
ge entryr=pdur-365
by warnumb: ge fentryr=entryr[1]

stset pdur, id(warnumb) f(pcens) en(fentryr)
/*** The regressions below now give results identical to those reported in the paper. ***/


/* BASELINE MODEL: column 1 */

streg lpcgdp_2 dy_1  poldum p_m auton auton_m ebox ldiaspc diaspc_m ethnic ethnic_m lexpend absent no_un_data d2, nohr dist(exponential)


/* column 2 */

streg lpcgdp_2 dy_1  poldum p_m auton auton_m E1st E1st_1 E2etc E2etc_1 ldiaspc diaspc_m ethnic ethnic_m lexpend absent no_un_data d2, nohr dist(exponential)

/* column 3 */

streg lpcgdp_2 dy_1  poldum p_m auton auton_m ebox1st ebox2etc ldiaspc diaspc_m ethnic ethnic_m lexpend absent no_un_data d2, nohr dist(exponential)

/* ref model with efw added: column 4 */

streg lpcgdp_2 dy_1  poldum p_m auton auton_m ebox Iefw Iefw_m ldiaspc diaspc_m ethnic ethnic_m lexpend absent no_un_data d2, nohr dist(exponential)

/* Run these lines to list all cases (Appendix A) */
/*
sort warnumb year

by warnumb: ge first=_n==1
by warnumb: ge last =_n==_N

keep if first==1 | last==1

sort warnumb year
by warnumb: ge STARTYR=year[_n-1]
by warnumb: replace STARTYR=year if first==1 & last==1
ge ENDYR=year if last==1

ge peacedur=pdur/365	/*duration of peace, in years */

list country wstart PSTART PEND peacedur pcens if e(sample)==1 & last==1, sep(0) noobs nod

count if e(sample)==1 & last==1
drop peacedur
*/
exit


