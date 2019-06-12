
**  Replication file for Table 2 from Crescenzi and Kadera, 2015. 
**  "Built to Last: Understanding the Link between Democracy and Conflict
**  in the International System."

**  This is a response piece. Original Article: Gartzke, Erik and Alex Weisiger. 
**  2014 ‚"Under Construction:  Development, Democracy, and Difference as 
**  Determinants of Systemic Liberal Peace,‚Äù International Studies Quarterly 
**  58(2):130-145.

** Original Gartzke & Weisiger Replication Files can be found here:
** http://thedata.harvard.edu/dvn/dv/weisiger

* Analyses in Crescenzi & Kadera was performed using STATA 13.1

use "crescenzi-kadera-2015-ISQ-Table2.dta"

set more off

*MODEL A, also MODEL 5 in G&W*
nbreg fat1 polave diff1 pcenerg sysdepstate states year, nolog robust


*MODEL B, also MODEL 6 in G&W*
*nbreg fat1 polave polave2 diff1 pcenerg states year, nolog robust
nbreg fat1 c_polave c_polave_sq diff1 pcenerg states year, nolog robust
*reported centered model, results substantively equivalent*

*MODEL C, Replacing polity average with dempower*
*nbreg fat1 dempower dempower2 diff1 pcenerg sysdepstate states year, nolog robust
nbreg fat1 c_dempower c_dempower_sq diff1 pcenerg sysdepstate states year, nolog robust


*MODEL D, Replacing polity average with Democratic Community
* Notes: regstrength is the Democratic Community variable developed in 
* Kadera, Crescenzi & Shannon, AJPS 2003. 

*cannot run this with G&W's "diff1" variable, due to multicollinearity
corr regstrength diff1
*correlated at 0.7699* 

nbreg fat1 regstrength pcenerg states year, nolog robust

*MODEL E, Adding nonlinear term
nbreg fat1 c_regstrength c_regstrsq pcenerg states year, nolog robust

*Here is a version with systemic trade, which reduces the N to 113.*
*change in sample size is due to trade data starting later.*

*MODEL F: adding trade
nbreg fat1 regstrength pcenerg sysdepstate states year, nolog robust


** Replication of Table 3 is done with a different dataset






