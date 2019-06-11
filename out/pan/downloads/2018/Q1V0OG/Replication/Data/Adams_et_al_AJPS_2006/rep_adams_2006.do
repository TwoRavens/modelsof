/******************************************/
/* Replication File for Adams et al. 2006 */
/******************************************/


set matsize 400

cd "~/Dropbox (MIT)/interaction paper/Data/Included/Adams_et_al_AJPS_2006/" 


/******** Table 1 ************/
/* page 519*/

use adams_2006, clear

tsset partnum electnum

regress pshift2 vshift idparty idvshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)

keep if e(sample)==1 //drop none
saveold rep_adams_2006, replace
