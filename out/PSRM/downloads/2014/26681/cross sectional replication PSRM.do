use "cross sectional replication.dta",clear

** Table 2 **
reg chall_share incumbent_extremity quality2  i.year  log_spending_diff inc_pres inparty first_term,cl(cluster3)
