/**************************************************
Purpose: Replication data
Publication: "Do States Circumvent Constitutional Supermajority Voting Requirements to Raise Taxes?"
Journal: Forthcoming, State Politics & Policy Quarterly
Author: Soomi Lee
Contact: slee4@laverne.edu
Date: May 8, 2018 
State level panel data: 49 states from 1960 to 2008 (Nebraska excluded)

* Note to users 
1. Change directory: users set the default directory to the folder on their computer where the replication files were downloaded to. 
2. Install the user written package "estout" for eststo and esttab commands. To install, ssc install estout.

***************************************************/

* import data
use "repdata.dta", replace

**********************************************************
******** FIGURE 1. linear combination/ post estimation
**********************************************************
* set panel
xtset code year 
* control variables
global xlist lpop dratio egrowth demlow demup governor divided idec ideg elimit 
* estmating the baseline (replicating model 5 in Table 2)
reg ttax1k smvrd c.smvryr##c.smvryr $xlist statedum* i.year i.code if code!=2 & code!=4, vce(cluster code)
qui margins, at(smvrd=1 smvryr=(0/25)) 
marginsplot

**********************************************************
***** Figure 2 *******************************************
**********************************************************
* Panel A. Fee burden
/* computing averages of annual fee burden by supermajority rule status
* computed variables already exist in the dataset.
* fee1k1=mean of fee burden of the states with the supermajority rule
* fee1k0=mean of fee burden of the states without the supermajority rule
by year, sort: egen fee1k1=mean(fee1k) if smvrd==1 
	label var fee1k1 "mean of fee1k for smvrd==1 by year"
by year, sort: egen fee1k0=mean(fee1k) if smvrd==0
	label var fee1k0 "mean of fee1k for smvrd==1 by year" */
* create the graph
twoway (line fee1k1 fee1k0 year, sort title("Panel A. Fee Burden") scheme(s2mono))
* save the graph
graph save Graph "fig2pa.gph", replace

* Panel B: Ta-to-fee ratio
/* computing averages of annual tax-to-fee ratio by supermajority rule status
* computed variables already exist in the dataset.
* t2f1=mean of tax-to-ratio of the states with the supermajority rule
* t2f0=mean of tax-to-ratio of the states without the supermajority rule
by year, sort: egen t2f1=mean(tax2fee) if smvrd==1
	label var t2f1 "mean of tax2fee for smvrd==1 by year"
by year, sort: egen t2f0=mean(tax2fee) if smvrd==0
	label var t2f0 "mean of tax2fee for smvrd==0 by year" */
	* create the graph
twoway (line t2f0 t2f1 year, sort title("Panel B. Tax-to-Fee Ratio") scheme(s2mono))
* save the graph
graph save Graph "fig2pb.gph"

* combine the two graphs
graph combine "fig2pa.gph" "fig2pb.gph"

* end of do file
