set more off
use psid_data

macro define controls "age age2 male i.MS_curr_status i.R_hd_mntn1_ i.Ch_tot_nmbr_brth_17_ i.FC_tot_nmbr_fu i.Ed_cllge_dgree_hd"
macro define controls2 "age age2 male i.MS_curr_status i.R_hd_mntn1_ i.Ch_tot_nmbr_brth_17_ i.FC_tot_nmbr_fu lma350 lma320 i.Ed_cllge_dgree_hd"


*Appendix Table A6 (summary statistics)

sum Inc_fam_money_ age male white_hd married   Ch_tot_nmbr_brth_17_ FC_tot_nmbr_fu 
sum Inc_fam_money_ age male white_hd married   Ch_tot_nmbr_brth_17_ FC_tot_nmbr_fu if lfamincpp1~=. & lfaminc~=. & lma380~=. & state~=. & year~=.
sum Inc_fam_money_ age male white_hd married   Ch_tot_nmbr_brth_17_ FC_tot_nmbr_fu if lfuture4~=. & lfaminc~=. & lma380~=. & state~=. & year~=.


*TABLE 3

*PANEL A

xi:areg lfamincpp1 lfaminc lma380  $controls i.year ,a(state) cluster(state)
xi:areg lfamincpp1 lfaminc lma380  $controls2 i.year ,a(state) cluster(state)

xi:areg lfamincpp1 lfaminc lma380  $controls2 i.year ,a(fam_id) cluster(state)
xi:areg lfamincpp2 lfaminc lma380  $controls i.year ,a(state) cluster(state)

xi:areg lfamincpp2 lfaminc lma380  $controls2 i.year ,a(state) cluster(state)
xi:areg lfamincpp2 lfaminc lma380  $controls2 i.year i.state ,a(fam_id) cluster(state)

xi:areg lfamincpp4 lfaminc lma380  $controls i.year ,a(state) cluster(state)
xi:areg lfamincpp4 lfaminc lma380  $controls2 i.year ,a(state) cluster(state)

xi:areg lfuture lfaminc lma380  $controls i.year ,a(state) cluster(state)
xi:areg lfuture lfaminc lma380  $controls2 i.year ,a(state) cluster(state)

xi:areg lfuture4 lfaminc lma380  $controls i.year ,a(state) cluster(state)
xi:areg lfuture4 lfaminc lma380  $controls2 i.year ,a(state) cluster(state)

xi:areg sdlfuture4 lfaminc lma380  $controls i.year ,a(state) cluster(state)
xi:areg sdlfuture4 lfaminc lma380  $controls2 i.year ,a(state) cluster(state)

*panel B

xi:areg lfamincpp1 lfaminc lma390  $controls i.year ,a(state) cluster(state)
xi:areg lfamincpp1 lfaminc lma390  $controls2 i.year ,a(state) cluster(state)

xi:areg lfamincpp1 lfaminc lma390  $controls2 i.year ,a(fam_id) cluster(state)
xi:areg lfamincpp2 lfaminc lma390  $controls i.year ,a(state) cluster(state)

xi:areg lfamincpp2 lfaminc lma390  $controls2 i.year ,a(state) cluster(state)
xi:areg lfamincpp2 lfaminc lma390  $controls2 i.year i.state ,a(fam_id) cluster(state)

xi:areg lfamincpp4 lfaminc lma390  $controls i.year ,a(state) cluster(state)
xi:areg lfamincpp4 lfaminc lma390  $controls2 i.year ,a(state) cluster(state)

xi:areg lfuture lfaminc lma390  $controls i.year ,a(state) cluster(state)
xi:areg lfuture lfaminc lma390  $controls2 i.year ,a(state) cluster(state)

xi:areg lfuture4 lfaminc lma390  $controls i.year ,a(state) cluster(state)
xi:areg lfuture4 lfaminc lma390  $controls2 i.year ,a(state) cluster(state)

xi:areg sdlfuture4 lfaminc lma390  $controls i.year ,a(state) cluster(state)
xi:areg sdlfuture4 lfaminc lma390  $controls2 i.year ,a(state) cluster(state)


