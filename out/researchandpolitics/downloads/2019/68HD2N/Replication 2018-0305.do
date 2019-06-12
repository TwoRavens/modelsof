/* 
Replication files for:															
Title: ``Reassessing the Fulfillment of Alliance Commitments in War''
Journal: Research and Politics	
Authors: Molly Berkemeier and Matthew Fuhrmann		
Date: 5 March 2018		
*/

*Open the dataset
use "BerkemeierFuhrmannRAP2018_0303.dta", clear

********************************************************************************
*Figure 1
********************************************************************************

*Identify total number of relevant alliance performance opportunities
tab dnaLLM //430 of 576 cases are ``DNA.'' 146 observations (576-430) are relevant.

*Identify number of alliance performance opportunities that are fulfilled
tab honorLLM // 73 commitments fulfilled

*Calculate compliance rate
disp 73/146
tab violateLLM // 50%

********************************************************************************
*Figure 2
********************************************************************************

*1816-1944

*Identify total number of relevant alliance performance opportunities
tab sample // 204 total observations.
tab dnaLLM if sample==1 // 112 ``DNA.'' 92 observations (204-112) are relevant.

*Identify number of alliance performance opportunities that are fulfilled
tab honorLLM if sample==1 // 61 commitments fulfilled

*Calculate compliance rate
disp 61/92 // 66.30%

*1945-2003

*Identify total number of relevant alliance performance opportunities
tab sample // 372 total observations.
tab dnaLLM if sample==0 // 318 ``DNA.'' 54 observations (372-318) are relevant.

*Identify number of alliance performance opportunities that are fulfilled
tab honorLLM if sample==0 // 12 commitments fulfilled

*Calculate compliance rate
disp 12/54 // 22.22%

********************************************************************************
*Table 1
********************************************************************************

list warid warname atopid honorLLM if sample==0 & dnaLLM~=1
list atopid defense offense neutral nonagg if sample==0 & dnaLLM~=1

********************************************************************************
*Other figures mentioned in the paper
********************************************************************************

*Identify compliance rates by commitment type

tab honorLLM if defense==1 // 42/102=41.18%
	*Total defense pact observations: 301
	*Defense pacts DNA: 199
	*Total defense alliance performance opportunities: 102 (301-199)

tab honorLLM if offense==1 // 31/42=73.81%
	*Total offense pact observations: 73
	*Offense pacts DNA: 31
	*Total offense pact alliance performance opportunities: 42 (73-31)

tab honorLLM if neutral==1 // 35/45=77.78%
	*Total neutrality pact observations: 80
	*Neutrality pact DNA: 35
	*Total neutrality alliance performance opportunities: 45 (80-35)

tab honorLLM if nonagg==1 // 18/49=36.73%
	*Total nonaggression pact observations: 263
	*Nonaggression pact DNA: 214
	*Total nonaggression alliance performance opportunities: 49 (263-214)

*Identify the number of neutrality and offense pacts pre- and post-1945
g neu_offense=0
replace neu_offense=1 if neutral==1
replace neu_offense=1 if offense==1
tab neu_offense sample if dnaLLM~=1, column

*Identify defense pact compliance pre- and post-1945
tab defense if dnaLLM~=1 & sample==1
tab defense if dnaLLM~=1 & sample==0
tab honorLLM defense if dnaLLM~=1 & sample==1, column //36/59=61.02
tab honorLLM defense if dnaLLM~=1 & sample==0, column // 6/43=13.95







