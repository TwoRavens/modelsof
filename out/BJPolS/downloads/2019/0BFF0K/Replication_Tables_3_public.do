*****************************************************************
* Replication Code for Tables and Estimates 3                   *
*  "Personnel Politics: Elections, Clientelistic Competition,   *
*         and Teacher Hiring in Indonesia"                      *
*               Jan Pierskalla & Audrey Sacks                   *
*****************************************************************


clear
cd "~/Dropbox/Replication_Personnel/"

use "student_data_private.dta"  

* Note: the data for this analysis is based on prviate student-level data, collected by de Ree et al. (2018) and cannot be shared publicly.
* Full data have been made available to the editor for verification purposes only.


* set control variables
global controls "gender edu_parent assets SD"
global controls2 "gender edu_parent assets SD incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc gini rev_total_pc2 lpop poverty_pc lgdppc"

* Appendix Table 15
xtset id_district
eststo:xtreg nMAT_score lnon_pns $controls2, r cluster(id_district)
eststo:xtreg nIPA_score lnon_pns $controls2, r cluster(id_district)
eststo:xtreg nBIN_score lnon_pns $controls2, r cluster(id_district)
eststo:xtreg nBIG_score lnon_pns $controls2,r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_15.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score" "Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear



* Appendix Table 16
xtset num_id
eststo:xtreg nMAT_score i.election_year i.year,fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year i.year,fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year i.year,fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year i.year,fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_16.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 17
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="BENGKULU",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="BENGKULU",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="BENGKULU",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="BENGKULU",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_17.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 18
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="GOWA",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="GOWA",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="GOWA",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="GOWA",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_18.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 19
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="LAMONGAN",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="LAMONGAN",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="LAMONGAN",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="LAMONGAN",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_19.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 20
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="MALUKU",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="MALUKU",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="MALUKU",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="MALUKU",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_20.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 21
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="OGAN ILIR",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="OGAN ILIR",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="OGAN ILIR",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="OGAN ILIR",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_21.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 22
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="SEMARANG",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="SEMARANG",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="SEMARANG",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="SEMARANG",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_22.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 23
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="TOLI TOLI",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="TOLI TOLI",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="TOLI TOLI",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="TOLI TOLI",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_23.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 24
xtset num_id
eststo:xtreg nMAT_score i.election_year $controls i.year if control==1 | name_district=="TUBAN",fe r cluster(id_district)
eststo:xtreg nIPA_score i.election_year $controls i.year if control==1 | name_district=="TUBAN",fe r cluster(id_district)
eststo:xtreg nBIN_score i.election_year $controls i.year if control==1 | name_district=="TUBAN",fe r cluster(id_district)
eststo:xtreg nBIG_score i.election_year $controls i.year if control==1 | name_district=="TUBAN",fe r cluster(id_district)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_24.tex",replace se scalars(N) label title(Student Test Scores, OLS) mtitles("Math Score" "Science Score" "Bahasa Score" "English Score") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

















