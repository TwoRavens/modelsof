** Change to your directory
cd "Representation/Replication"

** Load 2008 data
use "2008 data replication.dta"

* VARIABLES
* rhousevote = Voted for Republican House candidate (0/1)
* r_adv_abs = Republican spatial advantage
* pid3 = indicator for partisanship
	* 0 = Independent
	* 1 = Republican
	* 2 = Democrat
* incumbent_party = Incumbent party (-1=Dem;0=open;+1=Rep)
* toss = indicator for Toss-up district
* spending_balance2008 = Spending imbalance
* total_spending_millions2008 = Total campaign spending (millions)


** Table 3, Columns 1 and 2
logit rhousevote  c.r_adv_abs i.pid3   incumbent_party  [pw=weight],cl(stdist)
logit rhousevote  c.r_adv_abs##i.pid3   incumbent_party  [pw=weight],cl(stdist)
* Use results from Column 2 to generate predicted probabilities for Figure 1
margins,at(r_adv_abs=(-3(0.25)3) pid3=0 incumbent_party=0) 
margins,at(r_adv_abs=(-3(0.25)3) pid3=1 incumbent_party=0)
margins,at(r_adv_abs=(-3(0.25)3) pid3=2 incumbent_party=0) 


** Table 4, Columns 1-3
logit rhousevote  c.r_adv_abs##c.toss spending_balance2008 total_spending_millions2008 spending_balance2008  i.pid3   incumbent_party  [pw=weight],cl(stdist)
logit rhousevote  c.r_adv_abs##c.total_spending_millions2008 spending_balance2008 toss i.pid3   incumbent_party  toss    [pw=weight],cl(stdist)
logit rhousevote  c.r_adv_abs##c.spending_balance2008 total_spending_millions2008 spending_balance2008 toss i.pid3   incumbent_party  toss    [pw=weight],cl(stdist)


clear

** Load 2010 data
use "2010 data replication.dta"

* VARIABLES
* rhousevote = Voted for Republican House candidate (0/1)
* r_adv_abs = Republican spatial advantage
* pid3 = indicator for partisanship
	* 0 = Independent
	* 1 = Republican
	* 2 = Democrat
* incumbent_party = Incumbent party (-1=Dem;0=open;+1=Rep)
* toss = indicator for Toss-up district
*  unbalanced = Spending imbalance
* total_spending_millions = Total campaign spending (millions)


* Table 3, Columns 3-4

logit rhousevote  c.r_adv_abs i.pid3    incumbent_party [pw=weight],cl(stdist)
logit rhousevote  c.r_adv_abs##i.pid3    incumbent_party [pw=weight],cl(stdist)
* Use results from this model to generate predicted probabilities for Figure 1
margins,at(r_adv_abs=(-3(0.25)3) pid3=0 incumbent_party=0) 
margins,at(r_adv_abs=(-3(0.25)3) pid3=1 incumbent_party=0)
margins,at(r_adv_abs=(-3(0.25)3) pid3=2 incumbent_party=0) 


* Table 4, Columns 4-6

logit rhousevote  c.r_adv_abs##c.toss i.pid3    incumbent_party   total_spend_million  unbalanced [pw=weight],cl(stdist)
logit rhousevote  c.r_adv_abs##c. total_spend_million toss i.pid3    incumbent_party   total_spend_million  unbalanced [pw=weight],cl(stdist)
logit rhousevote  c.r_adv_abs##c.unbalanced total_spend_million toss i.pid3    incumbent_party   total_spend_million  unbalanced [pw=weight],cl(stdist)

