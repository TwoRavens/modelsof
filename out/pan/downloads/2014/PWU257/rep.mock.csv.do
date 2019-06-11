
************************************************************************************************************************
* REPLICATION FOR MOCK TABLES ILLUSTRATED IN TABLE 1 of HSW 2012
************************************************************************************************************************
* NOTE THAT THE MOCK REPORT SOUGHT TO PROVIDE THE STRUCTURE FOR SUBSEQUENT ANALYSIS. ESTIMATES PRODUCED HERE ARE BASED 
* ON INCOMPLETE AND UNCLEANED DATA AND IN SOME INSTANCES MAKE USE OF GENERATED DATA FOR THE PURPOSE OF ILLUSTRATION. 
* ALL TREATMENT DATA IS DELIBERATELY SIMULATED AND REPLICATION IS GOOD UP ONLY TO A RESHUFFLING OF THE TREATMENT VARIABLE
************************************************************************************************************************

clear

************************************************************************************************************************
* Mock Table 23: BENEFITS SPREAD
************************************************************************************************************************

* Prepare
	insheet using repdata\rQR3.csv

* Generate Dependent Variables: Coded as elections etc if *any* group indicates this method used
	egen stdev_benefits=mdev(qr003bis_value), by(idv)
	collapse stdev, by(idv)

* Random Treatment Variable: For DUMMY analysis only.
	g TUUNGANE = uniform()>.5

* Placeholder for Propensity Weight
	g WEIGHT = 1

* Results
	sum stdev 
	reg stdev TUUNGANE [weight=WEIGHT]


************************************************************************************************************************
** Mock Table 6: Influence of TUUNGANE on Selection Mechanisms
************************************************************************************************************************

clear

* Prepare
	insheet using  repdata\rB33.csv

* Generate Dependent Variables: Coded as elections etc if *any* group indicates this method used
	gen ELECTIONS2 			= (b_33_election_project_men>0 &  b_33_election_project_men!=.) | (b_33_election_project_women>0 &  b_33_election_project_women!=.) 
	gen ELECTIONS_LOTT_CON2 = (b_33_election_project_men>0 &  b_33_election_project_men!=.) | (b_33_election_project_women>0 &  b_33_election_project_women!=.) | (b_33_lottery_project_men>0 &  b_33_lottery_project_men!=.) |(b_33_lottery_project_women>0 & b_33_lottery_project_women!=0) | (b_33_consensus_project_men>0 & b_33_consensus_project_men!=.) | (b_33_consensus_project_women>0 & b_33_consensus_project_women!=.)

* Random Treatment Variable: For DUMMY analysis only.
	g TUUNGANE = uniform()>.5

* Placeholder for Propensity Weight
	g WEIGHT = 1

* Results
	sum ELECTIONS2  ELECTIONS_LOTT_CON2 
	mean ELECTIONS2  ELECTIONS_LOTT_CON2 	[weight=WEIGHT] 
	reg  ELECTIONS2  TUUNGANE  				[weight=WEIGHT]
	reg  ELECTIONS_LOTT_CON2 TUUNGANE 		[weight=WEIGHT]  


	
************************************************************************************************************************
** Mock Table 15: # Complaints
************************************************************************************************************************
clear

* Prepare
	insheet using repdata\rQR26.csv
	egen SUM_PRIV_COMPLAINTS  = rsum(qr026a_length qr026b_rapid_behavior qr026c_unimportant qr026d_reduced_help qr026e_no_influence qr026f_disagreement qr026g_steps qr026h_lack_info qr026i_fund_misuse qr026j_allocation qr026k_conflicts qr026l_controled_chef qr026m_unrepresented)

* Place holder for control variable
	gen  da109_not_verifiable = uniform()*400

* Random Treatment Variable: For DUMMY analysis only.
	g TUUNGANE = uniform()>.5

* Placeholder for Propensity * Sampling Weight
	g WEIGHT = 1

* Results
	sum SUM_PRIV_COMPLAINTS
	mean SUM_PRIV_COMPLAINTS   [weight=WEIGHT]
	reg  SUM_PRIV_COMPLAINTS   TUUNGANE  da109_not_verifiable [weight=WEIGHT], cluster(idv)


************************************************************************************************************************
* Mock Table 35: SCHOOL
************************************************************************************************************************
clear

* Prepare
	insheet using repdata\rQF.csv

* Random Treatment Variable: For DUMMY analysis only.
	g TUUNGANE = uniform()>.5

* Placeholder for Propensity * Sampling Weight
	g WEIGHT = 1

* Results (Note marginal difference in *overall mean* as reported in mock report) 
	sum qf014_days_school
	mean qf014_days_school [weight=WEIGHT]
	mean qf014_days_school [weight=WEIGHT] if qf007_gender==0
	mean qf014_days_school [weight=WEIGHT] if qf007_gender==1
	reg qf014_days_school  TUUNGANE [weight=WEIGHT], cluster(idv)
	reg qf014_days_school  TUUNGANE [weight=WEIGHT] if qf007_gender==0, cluster(idv)
	reg qf014_days_school  TUUNGANE [weight=WEIGHT] if qf007_gender==1, cluster(idv)

exit
