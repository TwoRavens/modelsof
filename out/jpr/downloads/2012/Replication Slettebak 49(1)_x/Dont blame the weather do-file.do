


* REPLICATION DATA FOR SLETTEBAK (2012): DON'T BLAME THE WEATHER! CLIMATE-RELATED NATURAL DISASTERS AND CIVIL CONFLICT



* Table I:

/* For Nel and Righarts (2008) original dataset, see:
Philip Nel and Marjolein Righarts, 2008-04-18, "Replication Data for Nel and Righarts: "Natural Disasters and the Risk of Violent Civil Conflict"", 
http://dvn.iq.harvard.edu/dvn/dv/isq/faces/study/StudyPage.xhtml?studyId=23502&versionNumber=1	*/
	
use /* Insert location of Nel and Righarts' original dataset here */	
do  /* Insert location of Nel and Righarts' original do-file here */

tsset state year

g l_imr = l.imr			/* Lagging the infant mortality variables one year */
g l_imr_sq = l.imr^2

relogit vccall allclim_pc  l_imr  l_imr_sq mixed gdpgro brevity
relogit vccall allclim_pc  l_imr  l_imr_sq mixed gdpgro brevity totpopln



* Table II:

use /* Insert location of replication dataset here */

logit onset warl gdpenl lpopl1 lmtnest ncontig Oil nwstate instab_fl polity2l ethfrac relfrac, nolog
logit onset25neo  py_incidence_neo gdpint_ln lpop1_ln lmtnest_int ncontig_int Oil_comp newstate instab_comp mixed55 ethfrac_int relfrac_int 		 i.year, cl(cowcode) nolog
logit onset25neo  py_incidence_neo gdpint_ln lpop1_ln lmtnest_int ncontig_int 		   newstate instab_comp mixed55 ethfrac_int relfrac_int climatic i.year, cl(cowcode) nolog
logit onset25neo  py_incidence_neo gdpint_ln lpop1_ln lmtnest_int ncontig_int 		   newstate instab_comp mixed55 ethfrac_int relfrac_int climatic_bin i.year, cl(cowcode) nolog
logit onset25neo  py_incidence_neo gdpint_ln lpop1_ln lmtnest_int ncontig_int 		   newstate instab_comp mixed55 ethfrac_int relfrac_int storm flood drought massmov_wet heat cold wildfire i.year, cl(cowcode) nolog 
logit onset25neo  py_incidence_neo gdpint_ln lpop1_ln lmtnest_int ncontig_int 		   newstate instab_comp mixed55 ethfrac_int relfrac_int climatic_bin climbinXpop i.year, cl(cowcode) nolog









