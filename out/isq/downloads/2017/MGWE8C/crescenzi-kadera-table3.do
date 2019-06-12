**  Replication file for Table 3 from Crescenzi and Kadera, 2014. 
**  "Built to Last: Understanding the Link between Democracy and Conflict
**  in the International System."

**  This is a response piece. Original Article: Gartzke, Erik and Alex Weisiger. 
**  2014 ‚"Under Construction:  Development, Democracy, and Difference as 
**  Determinants of Systemic Liberal Peace,‚Äù International Studies Quarterly 
**  58(2):130-145.

** Original Gartzke & Weisiger Replication Files can be found here:
** http://thedata.harvard.edu/dvn/dv/weisiger

* Analyses in Crescenzi & Kadera was performed using STATA 13.1

use "crescenzi-kadera-2015-ISQ-Table3.dta"


*MODEL A, also MODEL 5 in G&W*

* original code for Model 14
*relogit deadlyl polave pcenerg diff1 demloi engypop dydiff logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)

* we generated a squared term using the polity average variable provided by G&W
*gen polavesq = polave*polave

*TABLE 3*

*Model G: Model 14 replicated.*
*note: relogit does not work in STATA 13.1, but the results are nearly identical.
logit deadlyl polave pcenerg diff1 demloi engypop dydiff logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)

*Model H: Adding a squared term to "systemic democracy"*
*note: we center any variable before squaring it here, but uncentered models are also provided. 
*      the results are substantively equivalent across all models.

*logit deadlyl polave polavesq pcenerg diff1 demloi engypop dydiff logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)
logit deadlyl c_polave c_polavesq pcenerg diff1 demloi engypop dydiff logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)

*Model I: Demcom and DemCom^2*
*note: regstrength is the Democratic Community variable developed in 
* Kadera, Crescenzi & Shannon, AJPS 2003. It is the only variable added to this analysis. The rest of the variables are used directly from 
* G&W replication files.

*logit deadlyl regstrength regstrsq pcenerg demloi engypop logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)
logit deadlyl c_regstrength c_regstrengthsq pcenerg demloi engypop logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)


*Model J: dropping the dyadic difference variable*
*logit deadlyl polave polavesq pcenerg diff1 demloi engypop logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)
logit deadlyl c_polave c_polavesq pcenerg diff1 demloi engypop logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)

*NOTE: we could also use demcom here, but need to drop pcenerg bc it is redundant*
*logit deadlyl c_regstrength c_regstrsq diff1 demloi engypop logdist cntgdumy allydumy capratio onemajor deadyrs deadyer*, cluster(dyadid)
*results are similar*


