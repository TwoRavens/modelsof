*********************************************************** Final Replication Models                       		 ** Authors: Michael G. Findley & Joseph K. Young   		 ** Date: 3/19/09		                             		 ** Project: Terrorism, Democracy, and Credible Commitment ***********************************************************

use findley_young_repdata_isq_2011.dta

**********************************
* Table 2, Column 1, Base Model  *
**********************************nbreg domestic j polity2l polity2lsquare tti2 cap lpop gdpenl domesticSpatialLag, cluster(cowcode) nolog irr
*************************************************
* Table 2, Column 2, Electoral System Measures  *
*************************************************
* with electoral system measures (from golder (2005), electoral studies)
nbreg domestic j polity2l polity2lsquare tti2 cap lpop gdpenl domesticSpatialLag maj pr mixed, cluster(cowcode) nolog irr


******************************************
* Table 2, Column 3, Alt Regime Measure  *
*******************************************with unified democracy score (from melton, meserve, pemstein, ajps)nbreg domestic j mmpMean mmpSd tti2 cap   lpop gdpenl  domesticSpatialLag , cluster(cowcode) nolog irr

*******************************************
* Robustness Checks/Sensitivity Analyses  *
*******************************************

**************************************
* Appendix                           * 
* Table 1, Column 1, w/o Ind. Jud.   *
**************************************
nbreg domestic polity2l polity2lsquare tti2 cap lpop gdpenl domesticSpatialLag, cluster(cowcode) nolog irr

**************************************
* Appendix                           * 
* Table 1, Column 2, Base Model	     *
**************************************
nbreg domestic j polity2l polity2lsquare tti2 cap lpop gdpenl domesticSpatialLag, cluster(cowcode) nolog irr

**************************************
* Appendix                           * 
* Table 1, Column 3, Lagged DV       *
**************************************
nbreg domestic j polity2l polity2lsquare tti2 cap lpop gdpenl domesticSpatialLag domesticLag, cluster(cowcode) nolog irr

********************
* Appendix         * 
* Table 2          *
********************
zinb domestic j polity2l polity2lsquare tti2 cap   lpop gdpenl domesticSpatialLag, inflate(j polity2l polity2lsquare tti2 cap lpop gdpenl domesticSpatialLag) cluster(cowcode) nolog irr
