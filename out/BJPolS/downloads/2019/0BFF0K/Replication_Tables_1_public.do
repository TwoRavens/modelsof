*****************************************************************
* Replication Code for Tables and Estimates                     *
*  "Personnel Politics: Elections, Clientelistic Competition,   *
*         and Teacher Hiring in Indonesia"                      *
*               Jan Pierskalla & Audrey Sacks                   *
*****************************************************************

clear
cd "~/Dropbox/Replication_Personnel/"

use "district_data_public.dta"  

* Note: these public version of the data exclude any variables based on the govenrnment teacher census for privacy reasons
* Affected variables: lpns, lnon_pns, pns_sh, lschool_hired, lcontract_other, lcert, lcert2, cert_sh, pns, non_pns, school_hired, contract_other, lschools
* Full data have been made available to the editor for verification purposes only.

** Table 1
xtset kode_neil

eststo:xtreg lpns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lschool_hired election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lcontract_other election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/main_table_1.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(PNS)" "log(Non PNS)" "PNS Share" "log(School)" "log(Other)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Table 2
fvset base 2008 year
eststo:xtreg lcert ltotal_teach election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lcert2 ltotal_teach election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg cert_sh election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/main_table_2.tex",replace se scalars(N) label title(Teacher Certification, FE-OLS) mtitles ("log(Certified+1)" "log(Certified)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Table 3
* See Replication_Tables_2_public


* Appendix Table 2
estpost summarize pns non_pns school_hired contract_other election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l if new_district2==0
esttab using "~/Dropbox/Replication_Personnel/appendix_table_2.tex", cells("count(fmt(2)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs nonumber label title("Summary statistics") replace
eststo clear 


* Appendix Table 3
* see R-code file

* Appendix Table 4
* same as Table 1


* Appendix Table 5
eststo:xtreg lpns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lnon_pns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg pns_sh election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lschool_hired election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lcontract_other election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_5.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(PNS)" "log(Non PNS)" "PNS Share" "log(School)" "log(Other)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 6
set matsize 5000
eststo:nbreg pns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year i.kode_neil if new_district2==0,r cluster(kode_neil)
eststo:nbreg non_pns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year i.kode_neil if new_district2==0,r cluster(kode_neil)
eststo:nbreg school_hired election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year i.kode_neil if new_district2==0,r cluster(kode_neil)
eststo:nbreg contract_other election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year i.kode_neil if new_district2==0,r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_6.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("PNS" "Non PNS" "School" "Other" "PNS" "Non PNS" "School" "Other") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 7
eststo:xtreg lschools election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lschools election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_7.tex",replace se scalars(N) label title(Number of Schools, FE-OLS) mtitles("log(Schools)" "log(Schools)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 8
* same as Table 2


* Appendix Table 9
fvset base 2008 year
eststo:xtreg lcert ltotal_teach election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg lcert2 ltotal_teach election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
eststo:xtreg cert_sh election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_9.tex",replace se scalars(N) label title(Teacher Certification, FE-OLS) mtitles ("log(Certified+1)" "log(Certified)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 10
fvset base 2008 year
eststo:xtreg lcert ltotal_teach election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l  quota i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lcert2 ltotal_teach election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l  quota i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg cert_sh election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l  quota i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_10.tex",replace se scalars(N) label title(Teacher Certification, FE-OLS) mtitles ("log(Certified+1)" "log(Certified)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 11
* add job change model


* Appendix Table 12
eststo:xtreg lnon_pns i.election_year##c.golkar_sh_99 election_year_lead1##c.golkar_sh_99 election_year_l##c.golkar_sh_99 incumbency elected_leader_l##c.golkar_sh_99  services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh i.election_year##c.golkar_sh_99 election_year_lead1##c.golkar_sh_99 election_year_l##c.golkar_sh_99 incumbency elected_leader_l##c.golkar_sh_99  services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns i.election_year##c.pdip_sh_99 election_year_lead1##c.pdip_sh_99 election_year_l##c.pdip_sh_99 incumbency elected_leader_l##c.pdip_sh_99 services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh i.election_year##c.pdip_sh_99 election_year_lead1##c.pdip_sh_99 election_year_l##c.pdip_sh_99 incumbency elected_leader_l##c.pdip_sh_99 services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_12.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(Non PNS)" "PNS Share" "log(Non PNS)" "PNS Share") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 13
eststo:xtreg lnon_pns i.election_year##c.golkar_diff election_year_lead1##c.golkar_diff election_year_l##c.golkar_diff golkar_diff incumbency elected_leader_l##c.golkar_diff  services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh i.election_year##c.golkar_diff election_year_lead1##c.golkar_diff election_year_l##c.golkar_diff golkar_diff incumbency elected_leader_l##c.golkar_diff  services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_13.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(Non PNS)" "PNS Share" "log(Non PNS)" "PNS Share") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 14
eststo:xtreg lnon_pns i.incumbency##election_year_lead1 i.incumbency##i.election_year i.incumbency##election_year_l i.incumbency##elected_leader_l golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh i.incumbency##election_year_lead1 i.incumbency##i.election_year i.incumbency##election_year_l i.incumbency##elected_leader_l golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns c.poverty_pc_l##election_year_lead1 c.poverty_pc_l##i.election_year c.poverty_pc_l##election_year_l c.poverty_pc_l##elected_leader_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh c.poverty_pc_l##election_year_lead1 c.poverty_pc_l##i.election_year c.poverty_pc_l##election_year_l c.poverty_pc_l##elected_leader_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns i.kota##election_year_lead1 i.kota##i.election_year i.kota##election_year_l i.kota##elected_leader_l c.poverty_pc_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh i.kota##election_year_lead1 i.kota##i.election_year i.kota##election_year_l i.kota##elected_leader_l c.poverty_pc_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns i.i_jawa##election_year_lead1 i.i_jawa##i.election_year i.i_jawa##election_year_l i.i_jawa##elected_leader_l c.poverty_pc_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh i.i_jawa##election_year_lead1 i.i_jawa##i.election_year i.i_jawa##election_year_l i.i_jawa##elected_leader_l c.poverty_pc_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns c.gdp_growth##election_year_lead1 c.gdp_growth##i.election_year c.gdp_growth##election_year_l c.gdp_growth##elected_leader_l c.poverty_pc_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh c.gdp_growth##election_year_lead1 c.gdp_growth##i.election_year c.gdp_growth##election_year_l c.gdp_growth##elected_leader_l c.poverty_pc_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_14.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(Non-PNS)" "PNS Share" "log(Non-PNS)" "PNS Share" "log(Non-PNS)" "PNS Share" "log(Non-PNS)" "PNS Share" "log(Non-PNS)" "PNS Share") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


* Appendix Table 15
* see Replication_Tables_3.do

* Appendix Table 16
* see Replication_Tables_3.do

* Appendix Table 17
* see Replication_Tables_3.do

* Appendix Table 18
* see Replication_Tables_3.do

* Appendix Table 19
* see Replication_Tables_3.do

* Appendix Table 20
* see Replication_Tables_3.do

* Appendix Table 21
* see Replication_Tables_3.do

* Appendix Table 22
* see Replication_Tables_3.do

* Appendix Table 23
* see Replication_Tables_3.do

* Appendix Table 24
* see Replication_Tables_3.do


* Appendix Table 25
eststo:xtreg lpns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lschool_hired election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lcontract_other election_year_lead1 election_year election_year_l elected_leader_l incumbency golkar_share_all pdip_share_all rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_25.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(PNS)" "log(Non PNS)" "PNS Share" "log(School)" "log(Other)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

* Appendix Table 26
* see R-script

* Appendix Table 27
eststo:xtreg lpns election_year_lead1 election_year election_year_l elected_leader_l ltotalexp_all_pc incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lnon_pns election_year_lead1 election_year election_year_l elected_leader_l ltotalexp_all_pc incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg pns_sh election_year_lead1 election_year election_year_l elected_leader_l ltotalexp_all_pc incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lschool_hired election_year_lead1 election_year election_year_l elected_leader_l ltotalexp_all_pc incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
eststo:xtreg lcontract_other election_year_lead1 election_year election_year_l elected_leader_l ltotalexp_all_pc incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
esttab using "~/Dropbox/Replication_Personnel/appendix_table_27.tex",replace se scalars(N) label title(Teacher Hiring, FE-OLS) mtitles("log(PNS)" "log(Non PNS)" "PNS Share" "log(School)" "log(Other)") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear


*************************************
*** Explore Substantive Effects
************************************

* these estimate serve as inputs for Figure 1 and 2
xtreg lnon_pns i.election_year_lead1 i.election_year i.election_year_l i.elected_leader_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
margins i.election_year
margins i.elected_leader_l

xtreg lpns i.election_year_lead1 i.election_year i.election_year_l i.elected_leader_l i.incumbency golkar_share_all pdip_share_all services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
margins i.election_year
margins i.elected_leader_l


* these estimate serve as inputs for Figure 3
xtreg lnon_pns i.election_year##c.golkar_sh_99 election_year_lead1##c.golkar_sh_99 election_year_l##c.golkar_sh_99 incumbency elected_leader_l##c.golkar_sh_99  services_provision rev_natural_pc_l gini_l rev_total_pc2_l lpop_l poverty_pc_l lgdppc_l i.year if new_district2==0,fe r cluster(kode_neil)
margins i.election_year, noestimcheck at(golkar_sh_99=(.1045 .6138)) 


