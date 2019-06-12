
clear all
set more off

use "JakielaOzierRestatReplicationData"


// Table 1:  OLS Regressions of the Impact of the Post-Election Crisis on Risk Preferences

** Column 1
reg riskcount post, r cluster(monthindex) 

** Column 2
reg riskcount post female youngest oldest maxgrade evermarried, r cluster(monthindex) 

** Column 3
xi:  reg riskcount post i.interviewer, r cluster(monthindex) 

** Column 4
xi:  reg riskcount post i.month, r cluster(monthindex) 

** Column 5
xi:  reg riskcount post female youngest oldest maxgrade evermarried i.interviewer i.month, r cluster(monthindex) 


// Table 2:  OLS Regressions of the Impact of the Post-Election Crisis Alternate Measures of Risk Aversion

** Column 1
reg risktolerant post female youngest oldest maxgrade evermarried, r cluster(monthindex)

** Column 2
reg mostaverse post female youngest oldest maxgrade evermarried, r cluster(monthindex)

** Column 3
reg card2choice post female youngest oldest maxgrade evermarried, r cluster(monthindex)

** Column 4
reg card3choice post female youngest oldest maxgrade evermarried, r cluster(monthindex)

** Column 5
reg card4choice post female youngest oldest maxgrade evermarried, r cluster(monthindex)

** Column 6
reg card5choice post female youngest oldest maxgrade evermarried, r cluster(monthindex)

** Column 7
reg card6choice post female youngest oldest maxgrade evermarried, r cluster(monthindex)


// Table 3:  IV Regressions of the Impact of the Post-Election Crisis on Risk Preferences

** Panel A:  dep var = number of risky choices

** Column 1
ivregress 2sls riskcount (post = wave2), r cluster(monthindex)

** Column 2
ivregress 2sls riskcount female maxgrade youngest oldest evermarr (post = wave2), r cluster(monthindex)

** Column 3
xi:  ivregress 2sls riskcount i.interviewer (post = wave2), r cluster(monthindex)

** Column 4
xi:  ivregress 2sls riskcount i.month (post = wave2), r cluster(monthindex)

** Column 5
xi:  ivregress 2sls riskcount female maxgrade youngest oldest evermarr i.interviewer i.month (post = wave2), r cluster(monthindex)


** Panel B:  dep var =  risk neutral or risk loving

local depvar "riskneutral"

** Column 1
ivregress 2sls risktolerant (post = wave2), r cluster(monthindex)

** Column 2
ivregress 2sls risktolerant female maxgrade youngest oldest evermarr (post = wave2), r cluster(monthindex)

** Column 3
xi:  ivregress 2sls risktolerant i.interviewer (post = wave2), r cluster(monthindex)

** Column 4
xi:  ivregress 2sls risktolerant i.month (post = wave2), r cluster(monthindex)

** Column 5 
xi:  ivregress 2sls risktolerant female maxgrade youngest oldest evermarr i.interviewer i.month (post = wave2), r cluster(monthindex)


** Panel C:  dep var =  most risk averse

** Column 1
ivregress 2sls mostaverse (post = wave2), r cluster(monthindex)

** Column 2
ivregress 2sls mostaverse female maxgrade youngest oldest evermarr (post = wave2), r cluster(monthindex)

** Column 3
xi:  ivregress 2sls mostaverse i.interviewer (post = wave2), r cluster(monthindex)

** Column 4
xi:  ivregress 2sls mostaverse i.month (post = wave2), r cluster(monthindex)

** Column5
xi:  ivregress 2sls mostaverse female maxgrade youngest oldest evermarr i.interviewer i.month (post = wave2), r cluster(monthindex)


** First stage F-stats for bottom of table 

** Column 1
quietly reg post wave2, r cluster(monthindex)
test wave2

** Column 2
quietly reg post wave2 female maxgrade youngest oldest evermarr, r cluster(monthindex)
test wave2

** Column 3
quietly xi:  reg post wave2 i.interviewer, r cluster(monthindex)
test wave2

** Column 4
quietly xi:  reg post wave2 i.month, r cluster(monthindex)
test wave2

 ** Column 5
quietly xi:  reg post wave2 female maxgrade youngest oldest evermarr i.interviewer i.month, r cluster(monthindex)
test wave2









