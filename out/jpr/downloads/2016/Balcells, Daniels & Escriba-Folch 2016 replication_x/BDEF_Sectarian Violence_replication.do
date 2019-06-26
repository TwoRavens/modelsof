
***************************************************************************************
**The Determinants of Low-Intensity Intergroup Violence: The Case of Northern Ireland**
**Laia Balcells, Lesley Ann Daniels, and Abel Escribà-Folch**
**Journal of Peace Research**
***************************************************************************************


xtset wardcode_num year
sort wardcode_num year


****Models reported in Tables I and II****

***TABLE 1***

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death catholics_pc i.year i.lgdcode_num, cluster(wardcode)
est store sect1

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death protestants_pc i.year i.lgdcode_num, cluster(wardcode)
est store sect2

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death c.catholics_pc##c.catholics_pc i.year i.lgdcode_num, cluster(wardcode)
est store sect3

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death c.protestants_pc##c.protestants_pc i.year i.lgdcode_num, cluster(wardcode)
est store sect4

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity i.year i.lgdcode_num, cluster(wardcode)
est store sect5

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity log_othercrime log_peacewalls n_mean_viol number_neighbors i.year i.lgdcode_num, cluster(wardcode)
est store sect6


esttab sect* using Table1_NI.rtf, b(3) se(3) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear

***TABLE 2 neighbor models***

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
est store n1

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death log_othercrime n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
est store n2

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_max_prot i.year i.lgdcode_num, cluster(wardcode)
est store n3

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors i.cath50##c.n_neigh_50 i.year i.lgdcode_num, cluster(wardcode)
est store n4

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot parity i.year i.lgdcode_num, cluster(wardcode)
est store n5

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors log_peacewalls c.catholics_pc##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
est store n6

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot##c.log_peacewalls i.year i.lgdcode_num, cluster(wardcode)
est store n7


esttab n* using Table2_NI.rtf, b(3) se(3) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


****Tables in the Appendix****


**Table A2**

nbreg  sect_viol_all parity, cluster(wardcode)
est store nc1

nbreg  sect_viol_all parity i.year i.lgdcode_num, cluster(wardcode)
est store nc2

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity, cluster(wardcode)
est store nc3

nbreg  sect_viol_all c.catholics_pc##c.n_mean_prot, cluster(wardcode)
est store nc4

nbreg  sect_viol_all c.catholics_pc##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
est store nc5

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot, cluster(wardcode)
est store nc6


esttab nc* using TableA2_NI.rtf, b(a2) se(a2) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


**Table A3**

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death polarization i.year i.lgdcode_num, cluster(wardcode)
est store ap1

nbreg  sect_viol_all log_sq_km log_pop_annual unemp_pc log_death c.parity##c.male_16_39_pc i.year i.lgdcode_num, cluster(wardcode)
est store ap2

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc log_death c.parity##c.unemp_pc i.year i.lgdcode_num, cluster(wardcode)
est store ap3

nbreg  sect_viol_all log_sq_km log_pop_annual urban male_16_39_pc housing_benefit_claimants_pc unemp_pc log_death parity i.year i.lgdcode_num, cluster(wardcode)
est store ap4

nbreg  sect_viol_all log_sq_km  log_pop_annual urban border_roi male_16_39_pc housing_benefit_claimants_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_p##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
est store ap5

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors i.cath60##c.n_neigh_60 i.year i.lgdcode_num, cluster(wardcode)
est store ap6

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.protestants_pc##c.n_mean_cath i.year i.lgdcode_num, cluster(wardcode)
est store ap7

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors log_peacewalls c.catholics_pc##c.n_mean_prot republican loyalist i.year i.lgdcode_num, cluster(wardcode)
est store ap8

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.catholics_pc##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
est store ap9

esttab ap* using TableA3_NI.rtf, b(a2) se(a2) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


**Table A4**

nbreg sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death c.log_peacewalls##c.parity log_othercrime log_peacewalls n_mean_viol number_neighbors i.year i.lgdcode_num, cluster(wardcode)
est store seg1

nbreg sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc c.log_death##c.parity log_othercrime log_peacewalls n_mean_viol number_neighbors i.year i.lgdcode_num, cluster(wardcode)
est store seg2

esttab seg* using TableA4_NI.rtf, b(a2) se(a2) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


**Table A5**

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity i.year i.lgdcode_num if belfast==0 & derry==0, cluster(wardcode)
est store b1

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot i.year i.lgdcode_num if belfast==0 & derry==0, cluster(wardcode)
est store b2

esttab b* using TableA5_NI.rtf, b(a2) se(a2) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


**Table A6**

zinb  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity, inflate(log_death parity) cluster(wardcode)
est store zi1

zinb  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_p##c.n_mean_prot, inflate(log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_p##c.n_mean_prot) cluster(wardcode)
est store zi2

zinb  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_p##c.n_mean_prot i.year i.lgdcode_num, inflate(log_sq_km  log_pop_annual unemp_pc log_death n_mean_viol c.catholics_p##c.n_mean_prot i.year i.lgdcode_num) cluster(wardcode)
est store zi3

esttab zi* using TableA6_NI.rtf, b(a2) se(a2) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


**Table A7**

xtnbreg sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity i.year, re
est store xt1

xtnbreg sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity i.year, fe
est store xt2

nbreg sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity i.year i.wardcode_num, cluster(wardcode)
est store xt3

xtnbreg sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot i.year, re
est store xt4

xtnbreg sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot i.year, fe
est store xt5

nbreg sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_pc##c.n_mean_prot i.year i.wardcode_num, cluster(wardcode)
est store xt6

esttab xt* using TableA7_NI.rtf, b(a2) se(a2) scalars(ll) star(+ 0.10 * 0.05 ** 0.01) nogaps replace

estimates clear


****FIGURES****

**Figure 1**

bysort year: egen violence_year=mean(sect_viol_all)
bysort year: egen violence_year_total=total(sect_viol_all)

twoway (connect violence_year_total year if year>=2005 & year<2013, sort yaxis(1)) (connect violence_year year if year>=2005 & year<2013, sort yaxis(2)), scheme(s2manual) legend(col(1) ring(0))


**Figure 3**

nbreg  sect_viol_all log_sq_km log_pop_annual male_16_39_pc unemp_pc log_death parity i.year i.lgdcode_num, cluster(wardcode)
margins, at(parity=(0(0.1)1))
marginsplot


**Figure 4**

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_p##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
margins, dydx(n_mean_prot) at(catholics_pc=(0(10)100))
marginsplot


**FIGURE 5**

nbreg  sect_viol_all log_sq_km  log_pop_annual male_16_39_pc unemp_pc log_death n_mean_viol number_neighbors c.catholics_p##c.n_mean_prot i.year i.lgdcode_num, cluster(wardcode)
margins, at(catholics_pc=(0(10)100) n_mean_prot=(0(10)100))

return list

matrix predictions=r(at), r(b)'
clear
svmat  predictions
rename predictions8 cath
rename predictions9 neighbor_prot
rename predictions44 violence

twoway (contour violence cath neighbor_prot, format(%4.0g) ccuts(0(1)26))


***Figures in the Appendix***


**Figure A2**

bysort wardcode_num: egen mean_viol=mean(sect_viol_all)
gen l_mean_viol=ln(1+mean_viol)

twoway (scatter l_mean_viol log_death)(lfit l_mean_viol log_death) (scatter l_mean_viol log_death if belfast==0 & derry==0)(lfit l_mean_viol log_death if belfast==0 & derry==0) if year==2005


**Figures A3**

scatter catholics_pc protestants_pc if year>=2005 & year<=2012
scatter parity polarization if year>=2005 & year<=2012

**Figures A4**

scatter parity catholics_pc if year>=2005 & year<=2012
scatter parity protestants_pc if year>=2005 & year<=2012
































