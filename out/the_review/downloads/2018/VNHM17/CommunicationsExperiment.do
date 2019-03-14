****************************************************************************************
* Replication Code: Communications Experimental Results
* Communications survey experiment results as discussed in the text
* This code created: 6/13/18
****************************************************************************************

*
* Load analysis file 
*

use "replicationdata.dta", clear

*
* Communications survey experiment results
*

* Outcomes:
* conjoint_1 = "How LIKELY are you to mention these letters to your Member?"
* conjoint_2 = "How SIGNIFICANT would these letters be in your advice to your Member about their position on the bill?"
* conjoint_3 = "How REPRESENTATIVE do you think these letters are of your constituents’ opinions?"

* Treatments:
* cid_1 = "constituents"
* cid_2 = "employees of a large company based in your constituency"
* cid_3 = "members of a non-profit citizens group"

* Recode into binary outcome ("very or somewhat")

foreach var of varlist conjoint_1 conjoint_2 conjoint_3{
	recode `var' (1/2=0) (3/4=1), gen(`var'_bin)
}

* Summary statistics

table conjointidentity, c(mean conjoint_1 mean conjoint_2 mean conjoint_3)
table conjointidentity, c(mean conjoint_1_bin mean conjoint_2_bin mean conjoint_3_bin)

* Regression results (1-4 scale) - comparing employees and citizens group to constituents

reg conjoint_1 cid_2 cid_3, cluster(office)
reg conjoint_2 cid_2 cid_3, cluster(office)
reg conjoint_3 cid_2 cid_3, cluster(office)

* Regression results (1-4 scale) - comparing employees against citizens group and constituents

reg conjoint_1 cid_2, cluster(office) 
reg conjoint_2 cid_2, cluster(office) 
reg conjoint_3 cid_2, cluster(office) 

* Regression results (0/1 scale) - comparing employees and citizens group to constituents

reg conjoint_1_bin cid_2 cid_3, cluster(office)
reg conjoint_2_bin cid_2 cid_3, cluster(office)
reg conjoint_3_bin cid_2 cid_3, cluster(office)

* Regression results (0/1 scale) - comparing employees against citizens group and constituents

reg conjoint_1_bin cid_2, cluster(office) 
reg conjoint_2_bin cid_2, cluster(office) 
reg conjoint_3_bin cid_2, cluster(office) 

