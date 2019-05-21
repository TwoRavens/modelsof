* ------------------------
* this file contains commands necessary to reproduce the statistical output and
* figures in
*	Wolford, Scott. "The Problem of Shared Victory: War-Winning Coalitions
*		and Postwar Peace." Journal of Politics
* for further information, please contact the author at swolford@austin.utexas.edu
* or whatever email address is indicated at http://www.scott-wolford.com/
* ------------------------

* open the data file
use wolford_sharedvictory.dta

*stset the data
stset survival, origin(peace) failure(war_start) id(warnum)

* Model 1 (full sample)
stcox lognum cow_allies great cinc cinc_loser prewar land revisionist loglength, nohr
estat phtest, d
estat ic

* Figure 3
stcurve, hazard at1(cow_allies=25) at2(cow_allies=75) at3(cow_allies=100) noboundary range(0 15000)
* Figure 4
stcurve, hazard at1(lognum=.69314718) at2(lognum=1.7917595) at3(lognum=2.3025851) noboundary range(0 15000)
* Figure 5
stcurve, hazard at1(great=0) at2(great=1) noboundary range(0 15000)

* Model 2 (without Napoleon)
stcox lognum cow_allies great cinc cinc_loser prewar land revisionist loglength if warnum>0, nohr
estat phtest, d
estat ic

* Model 3, (without Ifni War)
stcox lognum cow_allies great cinc cinc_loser prewar land revisionist loglength if warnum~=158, nohr
estat phtest, d
estat ic

clear


