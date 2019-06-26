* Designing foreign policy: Voters, special interest groups, and economic sanctions
* JPR Replication do-file
* Elena McLean and Taehee Whang 
* 2014/02/26




*** Tables I-II

*** Selection stage: DV = Sanctions 
probit sanction   salience_dummy3 social_glob alliance contig gdppc lncaprat target_democracy if sanctepisode==1 & polity21>6, robust cluster(sender) nolog

*** Outcome stage: DV = Target costs
probit    targetcostsdum  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob  targetcostsdum  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 social_glob   alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
ologit    targetcosts  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanction==1 & polity21>6, robust cluster(sender) nolog

*** Outcome stage: DV = Targeted sanctions
probit      targetedsanctions   export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob    targetedsanctions   export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 social_glob   alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog

*** Outcome stage: DV = Export sanctions
probit   x_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob x_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 social_glob   alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog

*** Outcome stage: DV = Aid sanctions
probit   aid_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob aid_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 social_glob   alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog




*** Robustness check 1: Social globalization replaced with Information flows (Table A3)

*** Selection stage: DV = Sanctions 
probit sanction   salience_dummy3 info_flows alliance contig gdppc lncaprat target_democracy if sanctepisode==1 & polity21>6, robust cluster(sender) nolog
*** Outcome stage: DV = Target costs
probit    targetcostsdum  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob  targetcostsdum  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 info_flows alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
ologit    targetcosts  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanction==1 & polity21>6, robust cluster(sender) nolog
*** Outcome stage: DV = Targeted sanctions
probit      targetedsanctions   export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob    targetedsanctions   export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 info_flows alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
*** Outcome stage: DV = Export sanctions
probit   x_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob x_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 info_flows  alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
*** Outcome stage: DV = Aid sanctions
probit   aid_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob aid_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  salience_dummy3 info_flows  alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog




*** Robustness check 2: Voter awareness identity and Social globalization replaced with Voter awareness issue (Table A4)

*** Selection stage: DV = Sanctions 
probit sanction   voter_awareness_issue alliance contig gdppc lncaprat target_democracy if sanctepisode==1 & polity21>6, robust cluster(sender) nolog
*** Outcome stage: DV = Target costs
probit    targetcostsdum  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob  targetcostsdum  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanctepisode==1 &  polity21>6, select( sanction =  voter_awareness_issue  alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
ologit    targetcosts  export_sector_opposition alliance contig gdppc lncaprat target_democracy if sanction==1 & polity21>6, robust cluster(sender) nolog
*** Outcome stage: DV = Targeted sanctions
probit      targetedsanctions   export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob    targetedsanctions   export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  voter_awareness_issue  alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
*** Outcome stage: DV = Export sanctions
probit   x_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob x_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  voter_awareness_issue  alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog
*** Outcome stage: DV = Aid sanctions
probit   aid_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanction==1 & polity21>6, robust cluster(sender) nolog
heckprob aid_sanction_all  export_sector_opposition alliance contig gdppc lncaprat target_democracy if  sanctepisode==1 &  polity21>6, select( sanction =  voter_awareness_issue  alliance contig gdppc lncaprat target_democracy) robust cluster(sender) nolog


