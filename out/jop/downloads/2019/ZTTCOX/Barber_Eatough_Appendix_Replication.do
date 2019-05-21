use "Barber_Eatough_Replication_JOP.dta", clear 

*ROBUSTNESS - omit unions
areg share_nonincumbent i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 & substr(CODE5A, 1, 1) != "L", absorb(CODE5A) cluster(contributor_ext_id)
areg avgdistrictmargin i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 & substr(CODE5A, 1, 1) != "L", absorb(CODE5A) cluster(contributor_ext_id)
areg share_majority i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 & substr(CODE5A, 1, 1) != "L", absorb(CODE5A) cluster(contributor_ext_id)
areg share_chair i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 & substr(CODE5A, 1, 1) != "L", absorb(CODE5A) cluster(contributor_ext_id)

*ROBUSTNESS - Include small donation groups
areg share_nonincumbent i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles, absorb(CODE5A) cluster(contributor_ext_id)
areg avgdistrictmargin i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles, absorb(CODE5A) cluster(contributor_ext_id)
areg share_majority i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles, absorb(CODE5A) cluster(contributor_ext_id)
areg share_chair i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles, absorb(CODE5A) cluster(contributor_ext_id)

*ROBUSTNESS - no F.E.
reg share_nonincumbent politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, cluster(contributor_ext_id)
reg avgdistrictmargin politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, cluster(contributor_ext_id)
reg share_majority politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, cluster(contributor_ext_id)
reg share_chair politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, cluster(contributor_ext_id)

*ROBUSTNESS - weighted by donation amount
areg share_nonincumbent i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 [aweight = log_donations], absorb(CODE5A) cluster(contributor_ext_id)
areg avgdistrictmargin i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 [aweight = log_donations], absorb(CODE5A) cluster(contributor_ext_id)
areg share_majority i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 [aweight = log_donations], absorb(CODE5A) cluster(contributor_ext_id)
areg share_chair i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4 [aweight = log_donations], absorb(CODE5A) cluster(contributor_ext_id)

*ROBUSTNESS - share future majority and incumbent majority
areg share_majority_future i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)
areg share_majority_future_incumbent i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)
areg share_majority_incumbent i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)

*ROBUSTNESS - Aggregate up to CODE5A level and run regressions there
egen code5_cycle = concat(CODE5A CYCLE)
bys code5_cycle: egen code5_nonincumbentdonate = sum(nonincumbdonate)  if numberofdonations > 1
bys code5_cycle: egen code5_incumbentdonate = sum(icumbdonate)  if numberofdonations > 1
gen code5_share_nonincumbent = 100*code5_nonincumbentdonate / (code5_nonincumbentdonate + code5_incumbentdonate)

bys code5_cycle: egen code5_avgdistcompete = mean(avgdistrictmargin) if numberofdonations > 1

bys code5_cycle: egen code5_chairdonate = sum(chairdonate)  if numberofdonations > 1
bys code5_cycle: egen code5_donations = sum(donations)  if numberofdonations > 1
gen code5_share_chair = 100*code5_chairdonate / (code5_chairdonate + code5_donations)

bys code5_cycle: egen code5_majoritydonate = sum(majoritydonate)  if numberofdonations > 1
gen code5_share_majority = 100*code5_majoritydonate / (code5_majoritydonate + code5_donations)

bys code5_cycle: gen code5_n = _n == 1
areg code5_share_nonincumbent politicization numgroups log_groupmoney log_articles if code5_n == 1, absorb(CYCLE) cluster(code5_cycle)
areg code5_avgdistcompete politicization numgroups log_groupmoney log_articles if code5_n == 1, absorb(CYCLE) cluster(code5_cycle)
areg code5_share_majority politicization numgroups log_groupmoney log_articles if code5_n == 1, absorb(CYCLE) cluster(code5_cycle)
areg code5_share_chair politicization numgroups log_groupmoney log_articles if code5_n == 1, absorb(CYCLE) cluster(code5_cycle)
