* Bivariate Probit Selection Models 

set more off 

set seed 123456789

preserve

drop if year < 1946

* Tabel 4, Model 7 ACC: 1946 - 2000, all disputes, power interaction

heckprob cowrecipx acc1nomvx lndistance majmaj minmaj majmin powerratio allies  ///
s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1, ///
select(initoriginal = acc1nomvx lndistance majmaj minmaj majmin powerratio  acc1nomvxpower ///
allies s_wt_glo s_ld_1 s_ld_2 contig400 peaceyears1 _spline1 _spline2 _spline3) ///
cluster(ddyadid)

restore

* Table 4, Model 8: ACC, 1816-2000, all disputes

set more off

preserve

heckprob cowrecipx acc1nomvx lndistance majmaj minmaj majmin powerratio allies  ///
s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1, ///
select(initoriginal = acc1nomvx lndistance majmaj minmaj majmin powerratio  acc1nomvxpower ///
allies s_wt_glo s_ld_1 s_ld_2 contig400 peaceyears1 _spline1 _spline2 _spline3) ///
cluster(ddyadid)

restore



* Models not reported in the paper 

* Different measure of ACC

preserve

gen acc1power = acc1*powerratio 

drop if year < 1946

* Model 7b ACC: 1946 - 2000, all disputes, power interaction

heckprob cowrecipx acc1 lndistance majmaj minmaj majmin powerratio allies  ///
s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1, ///
select(initoriginal = acc1 lndistance majmaj minmaj majmin powerratio  acc1power ///
allies s_wt_glo s_ld_1 s_ld_2 contig400 peaceyears1 _spline1 _spline2 _spline3) ///
cluster(ddyadid)

restore

* Model 8b: ACC, 1816-2000, all disputes

set more off

preserve

gen acc1power = acc1*powerratio 

heckprob cowrecipx acc1 lndistance majmaj minmaj majmin powerratio allies  ///
s_wt_glo s_ld_1 s_ld_2 contig400 terr1 regime1 policy1 other1, ///
select(initoriginal = acc1nomvx lndistance majmaj minmaj majmin powerratio  acc1power ///
allies s_wt_glo s_ld_1 s_ld_2 contig400 peaceyears1 _spline1 _spline2 _spline3) ///
cluster(ddyadid)

restore
