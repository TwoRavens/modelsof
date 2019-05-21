use "Barber_Eatough_Replication_JOP.dta", clear 

*number of unique groups
bys contributor_ext_id: gen n = _n == 1
browse contributor_ext_id if n == 1
*12,153

*only political groups
browse contributor_ext_id if politicization == . & n == 1
*6,888

*only non political groups
browse contributor_ext_id if politicization != . & n == 1
*5,265

*all group-cycles
browse contributor_ext_id
*37,339

*only political groups
browse contributor_ext_id if politicization == .
*14,301

*only non political groups
browse contributor_ext_id if politicization != .
*23,038

*non-political group-cycles that gave at least 5 in an electoral cycle
browse contributor_ext_id if politicization != . & numberofdonations > 4
*17,938 different group-years

sum avgdistrictmargin if numberofdonations > 4 & politicization != .
tab CODE5A if avgdistrictmargin < 10 & numberofdonations > 4 & politicization != .
* 144
tab CODE5A if avgdistrictmargin > 35 & numberofdonations > 4 & politicization != .
* 6332
tab CODE5A if numberofdonations > 4 & politicization != .

sum share_majority if numberofdonations > 4 & politicization != .
tab CODE5A if share_majority == 100 & numberofdonations > 4 & politicization != .
* 932
tab CODE5A if share_majority == 0 & numberofdonations > 4 & politicization != .
* 727

sum share_chair if numberofdonations > 4 & politicization != .

*********
*TABLE 1
sum politicization, d

areg share_nonincumbent politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CYCLE) cluster(contributor_ext_id)
areg share_nonincumbent i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)
margins, at((asobserved) _all politicization = (5.653728 35.08082)) 

areg avgdistrictmargin politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CYCLE) cluster(contributor_ext_id)
areg avgdistrictmargin i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)
margins, at((asobserved) _all politicization = (5.653728 35.08082)) 

areg share_majority politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CYCLE) cluster(contributor_ext_id)
areg share_majority i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)
margins, at((asobserved) _all politicization = (5.653728 35.08082)) 

areg share_chair politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CYCLE) cluster(contributor_ext_id)
areg share_chair i.CYCLE politicization log_num_donations log_donations numgroups log_groupmoney log_articles if numberofdonations > 4, absorb(CODE5A) cluster(contributor_ext_id)
margins, at((asobserved) _all politicization = (5.653728 35.08082)) 




