*****************************************************************
* Replication Code for Tables and Estimates 2                   *
*  "Personnel Politics: Elections, Clientelistic Competition,   *
*         and Teacher Hiring in Indonesia"                      *
*               Jan Pierskalla & Audrey Sacks                   *
*****************************************************************

clear
cd "~/Dropbox/Replication_Personnel/"

use "data_teacher_private.dta"  

* Note: the data for this analysis is based on government teacher censuses and cannot be shared publicly.
* Full data have been made available to the editor for verification purposes only.


* Table 3
eststo:areg certified election_year_lead1 election_year election_year_l elected_leader_l incumbency poverty_pc_l rev_total_pc_l rev_natural_pc_l lpop_l lgdppc_l age gender i.emp_type i.high_edu i.year,absorb(school_id) cluster(kode)
esttab using "~/Dropbox/Replication_Personnel/main_table_3.tex",replace se scalars(N) label title(Teacher Certification, FE-OLS, Teacher Certification) mtitles("Certification") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear







