*STATA DO FILE FOR ANALYSIS OF FOLLOW-UP SURVEY EXPERIMENT - "BACKING OUT OR BACKING IN? COMMITMENT AND CONSISTENCY IN AUDIENCE COSTS THEORY"



*** PART I: PRELIMINARIES
clear all
set more off
version 13

*Set to relevant work directory where replication files are saved.
*For example:
cd "C:\Users\EndUser\Dropbox\Commitment and Consistency\Manuscript\AJPS Submission\Replication Files\AJPS Replication Files\"

*Open data set for main survey
use "commitment_followup.dta", clear




**** PART II: MAIN RESULTS

**TABLE E.1 summarizing number of respondents for each experimental group.
tab group



**Generate raw values to be used in results reported in TABLES E.2, E.3, E.4
proportion approve3, over(group)



**TABLE E.2: Domestic Political Consequences of Being Inconsistent, Follow-up Survey

*Table E.2a) Stay out vs. Back out
prtesti 102	 0.5588235  100  0.15   

*Table E.2b) Go in vs. Back in
prtesti 101  0.4752475  101	 0.3069307



**TABLE E.3: Domestic Political Consequences of Being Inconsistent When ///
	*Citing New Information (Outcome = No Force), Follow-up Survey

*Stay out vs. Back out/New Intel & Expert Consensus 
prtesti  102  0.5588235   102  0.5294118

*Stay out vs. Back out/New Intel Only
prtesti 102	 0.5588235   101  0.4752475

*Stay out vs. Back out/Expert Consensus Only
prtesti 102  0.5588235   99	 0.4242424



**TABLE E.4: Domestic Political Consequences of Being Inconsistent When ///
	*Citing New Information (Outcome = Use Force), Follow-up Survey

*Go in vs. Back in/New Intel & Expert Consensus
prtesti 101  0.4752475   101  0.5445545

*Go in vs. Back in/New Intel Only
prtesti 101  0.4752475   98  0.377551

*Go in vs. Back in/Expert Consensus
prtesti 101  0.4752475   97  0.2886598



*** PART III: OTHER RESULTS IN FOOTNOTES

**Results in FN.30**
*Morality outcome
proportion moralpres3, over(group)

*Stay out vs. Back out
prtesti 102	 0.5196078   100  0.26
*Stay out vs. Back out/New Intel & Expert Consensus 
prtesti 102	 0.5196078   102  0.5294118   
*Stay out vs. Back out/New Intel Only
prtesti 102	 0.5196078   101  0.4455446   
*Stay out vs. Back out/Expert Consensus Only
prtesti 102  0.5196078   99	 0.4545455  

*Go in vs. Back in
prtesti 101  0.5148515   101  0.3564356
*Go in vs. Back in/New Intel & Expert Consensus
prtesti 101	 0.5148515   101  0.4851485
*Go in vs. Back in/New Intel Only
prtesti 101	 0.5148515   98  0.4081633
*Go in vs. Back in/Expert Consensus Only
prtesti 101	 0.5148515   97  0.3917526



**END OF REPLICATION ANALYSIS FOR FOLLOW-UP SURVEY**
