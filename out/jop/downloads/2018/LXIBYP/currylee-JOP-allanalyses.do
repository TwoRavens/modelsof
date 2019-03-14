*************************************************************************************
**** What is Regular Order Worth? Partisan Lawmaking and Congressional Processes ****
** James M. Curry & Frances E. Lee **
*************************************

** Commands to replicate tables and figures **

use "currylee-JOP-data.dta", clear

****************
**** FIG. 1 ****
****************
* pre-formatted

* bill development indexes over time
egen hcommmean = mean(hcomm_index), by(cong)
egen scommmean = mean(scomm_index), by(cong)
egen allcommmean = mean(allcomm_index), by(cong)
line allcommmean hcommmean scommmean cong, title("Unorthodox Development") xtitle("Congress") yscale(range(0 .8)) ylabel(0(.2).8) xscale(range(100 114)) xlabel(100(2)114) legend(position(6) rows(1) order(1 "All" 2 "House" 3 "Senate")) saving(commmeans, replace)
* bill management indexes over time
egen hfloormean = mean(hfloor_index), by(cong)
egen sfloormean = mean(sfloor_index), by(cong)
egen allfloormean = mean(allfloor_index), by(cong)
line allfloormean hfloormean sfloormean cong, title("Unorthdox Management") xtitle("Congress") yscale(range(0 .8)) ylabel(0(.2).8) xscale(range(100 114)) xlabel(100(2)114) legend(position(6) rows(1) order(1 "All" 2 "House" 3 "Senate")) saving(floormeans, replace)
*combine
gr combine commmeans.gph floormeans.gph


*****************
**** TABLE 1 ****
*****************
eststo: mixed house1_percmin hcomm_index hfloor_index approps || _all: R.cong || major:
eststo: meqrlogit house1_pv50 hcomm_index hfloor_index approps || _all: R.cong || major:
eststo: meqrlogit house1_pv90 hcomm_index hfloor_index approps || _all: R.cong || major:
eststo: mixed housef_percmin allcomm_index allfloor_index approps || _all: R.cong || major:
eststo: meqrlogit housef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major:
eststo: meqrlogit housef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear 


****************
**** FIG. 2 ****
****************
* pre-formatted

* House Initial - % minority
mixed house1_percmin hcomm_index hfloor_index approps || _all: R.cong || major:
margins, at(hcomm_index=(0(.1)1)) post
est store hcomm1rice
mixed house1_percmin hcomm_index hfloor_index approps || _all: R.cong || major:
margins, at(hfloor_index=(0(.1)1)) post
est store hfloor1rice
coefplot hcomm1rice hfloor1rice, ///
	at xtitle("process unorthodoxy") title("% minority party support - Initial passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(h1rice, replace)
* House Initial - 50% party vote
meqrlogit house1_pv50 hcomm_index hfloor_index approps || _all: R.cong || major:
margins, at(hcomm_index=(0(.1)1)) predict(mu fixedonly) post
est store hcomm1pv50
meqrlogit house1_pv50 hcomm_index hfloor_index approps || _all: R.cong || major:
margins, at(hfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store hfloor1pv50
coefplot hcomm1pv50 hfloor1pv50, ///
	at xtitle("process unorthodoxy") title("50% party vote - Initial passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(h1pv50, replace)
* House Initial - 90% party vote
meqrlogit house1_pv90 hcomm_index hfloor_index approps || _all: R.cong || major:
margins, at(hcomm_index=(0(.1)1)) predict(mu fixedonly) post
est store hcomm1pv90
meqrlogit house1_pv90 hcomm_index hfloor_index approps || _all: R.cong || major:
margins, at(hfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store hfloor1pv90
coefplot hcomm1pv90 hfloor1pv90, ///
	at xtitle("process unorthodoxy") title("90% party vote - Initial passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(h1pv90, replace)
* House Final - % minority
mixed housef_percmin allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allcomm_index=(0(.1)1)) post
est store hcommfrice
mixed housef_percmin allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allfloor_index=(0(.1)1)) post
est store hfloorfrice
coefplot hcommfrice hfloorfrice, ///
	at xtitle("process unorthodoxy") title("% minority party support - Final passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(hfrice, replace)
* House Final - 50% party vote
meqrlogit housef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allcomm_index=(0(.1)1)) predict(mu fixedonly) post
est store hcommfpv50
meqrlogit housef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store hfloorfpv50
coefplot hcommfpv50 hfloorfpv50, ///
	at xtitle("process unorthodoxy") title("50% party vote - Final passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(hfpv50, replace)
* House Final - 90% party vote
meqrlogit housef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allcomm_index=(0(.1)1)) predict(mu fixedonly) post
est store hcommfpv90
meqrlogit housef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store hfloorfpv90
coefplot hcommfpv90 hfloorfpv90, ///
	at xtitle("process unorthodoxy") title("90% party vote - Final passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(hfpv90, replace)
* combine
gr combine h1rice.gph h1pv50.gph h1pv90.gph hfrice.gph hfpv50.gph hfpv90.gph 


*****************
**** TABLE 2 ****
*****************
eststo: mixed senate1_percmin scomm_index sfloor_index approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv50 scomm_index sfloor_index approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv90 scomm_index sfloor_index approps || _all: R.cong || major:
eststo: mixed senatef_percmin allcomm_index allfloor_index approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear


****************
**** FIG. 3 ****
****************
* pre-formatted

* Senate Initial - Rice Index
mixed senate1_percmin scomm_index sfloor_index approps || _all: R.cong || major:
margins, at(scomm_index=(0(.1)1)) post
est store scomm1rice
mixed senate1_percmin scomm_index sfloor_index approps || _all: R.cong || major:
margins, at(sfloor_index=(0(.1)1)) post
est store sfloor1rice
coefplot scomm1rice sfloor1rice, ///
	at xtitle("process unorthodoxy") title("% minority party support - Initial passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(s1rice, replace)
* Senate Initial - 50% party vote
meqrlogit senate1_pv50 scomm_index sfloor_index approps || _all: R.cong || major:
margins, at(scomm_index=(0(.1)1)) predict(mu fixedonly) post
est store scomm1pv50
meqrlogit senate1_pv50 scomm_index sfloor_index approps || _all: R.cong || major:
margins, at(sfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store sfloor1pv50
coefplot scomm1pv50 sfloor1pv50, ///
	at xtitle("process unorthodoxy") title("50% party vote - Initial passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(s1pv50, replace)
* Senate Initial - 90% party vote
meqrlogit senate1_pv90 scomm_index sfloor_index approps || _all: R.cong || major:
margins, at(scomm_index=(0(.1)1)) predict(mu fixedonly) post
est store scomm1pv90
meqrlogit senate1_pv90 scomm_index sfloor_index approps || _all: R.cong || major:
margins, at(sfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store sfloor1pv90
coefplot scomm1pv90 sfloor1pv90, ///
	at xtitle("process unorthodoxy") title("90% party vote - Initial passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(s1pv90, replace)
* Senate Final - Rice Index
mixed senatef_percmin allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allcomm_index=(0(.1)1)) post
est store scommfrice
mixed senatef_percmin allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allfloor_index=(0(.1)1)) post
est store sfloorfrice
coefplot scommfrice sfloorfrice, ///
	at xtitle("process unorthodoxy") title("% minority party support - Final passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(sfrice, replace)
* Senate Final - 50% party vote
meqrlogit senatef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allcomm_index=(0(.1)1)) predict(mu fixedonly) post
est store scommfpv50
meqrlogit senatef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store sfloorfpv50
coefplot scommfpv50 sfloorfpv50, ///
	at xtitle("process unorthodoxy") title("50% party vote - Final passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(sfpv50, replace)
* Senate Final - 90% party vote
meqrlogit senatef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allcomm_index=(0(.1)1)) predict(mu fixedonly) post
est store scommfpv90
meqrlogit senatef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major:
margins, at(allfloor_index=(0(.1)1)) predict(mu fixedonly) post
est store sfloorfpv90
coefplot scommfpv90 sfloorfpv90, ///
	at xtitle("process unorthodoxy") title("90% party vote - Final passage") ///
	yscale(range(0 1)) ylabel(0(.5)1) lwidth(*1) connect(l) legend(position(6) rows(2)) plotlabels("Bill development" "Bill management") saving(sfpv90, replace)
* combined
gr combine s1rice.gph s1pv50.gph s1pv90.gph sfrice.gph sfpv50.gph sfpv90.gph 


************************************
*** SUPPLEMENTAL APPENDIX MODELS ***
************************************

* Table A1
eststo: reg house1_percmin hcomm_index hfloor_index approps i.cong i.major
eststo: logit house1_pv50 hcomm_index hfloor_index approps i.cong, cluster(major)
eststo: logit house1_pv90 hcomm_index hfloor_index approps, cluster(major)
eststo: reg housef_percmin allcomm_index allfloor_index approps i.cong i.major
eststo: logit housef_pv50 allcomm_index allfloor_index approps i.cong, cluster(major)
eststo: logit housef_pv90 allcomm_index allfloor_index approps, cluster(major)
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A2
eststo: reg senate1_percmin scomm_index sfloor_index approps i.cong i.major
eststo: logit senate1_pv50 scomm_index sfloor_index approps, cluster(major)
eststo: logit senate1_pv90 scomm_index sfloor_index approps, cluster(major)
eststo: reg senatef_percmin allcomm_index allfloor_index approps i.cong i.major
eststo: logit senatef_pv50 allcomm_index allfloor_index approps, cluster(major)
eststo: logit senatef_pv90 allcomm_index allfloor_index approps, cluster(major)
esttab, se star(* 0.05 ** 0.01)
eststo clear

* Table A3
eststo: mixed house1_percmin h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj approps || _all: R.cong || major:
eststo: meqrlogit house1_pv50 h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj approps || _all: R.cong || major:
eststo: meqrlogit house1_pv90 h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj approps || _all: R.cong || major:
eststo: mixed housef_percmin h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj no_conference approps || _all: R.cong || major:
eststo: meqrlogit housef_pv50 h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj no_conference approps || _all: R.cong || major:
eststo: meqrlogit housef_pv90 h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj no_conference approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A4
eststo: mixed senate1_percmin s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv50 s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv90 s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj approps || _all: R.cong || major:
eststo: mixed senatef_percmin h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj no_conference approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv50 h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj no_conference approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv90 h_nocommhearings h_nocommreport houseruleclosed h_layover72 h_postcommadj s_nocommhearings s_nocommreport s_filltree s_clotureinvoked s_postcommadj no_conference approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A5
eststo: mixed housef_percmin irt_billdev_1pl irt_billman_1pl approps || _all: R.cong || major:
eststo: meqrlogit housef_pv50 irt_billdev_1pl irt_billman_1pl approps || _all: R.cong || major:
eststo: meqrlogit housef_pv90 irt_billdev_1pl irt_billman_1pl approps || _all: R.cong || major:
eststo: mixed senatef_percmin irt_billdev_1pl irt_billman_1pl approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv50 irt_billdev_1pl irt_billman_1pl approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv90 irt_billdev_1pl irt_billman_1pl approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A6
eststo: mixed housef_percmin allcomm_index allfloor_index approps || _all: R.cong || major: if cong<107
eststo: mixed housef_percmin allcomm_index allfloor_index approps || _all: R.cong || major: if cong>106
eststo: meqrlogit housef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major: if cong<107
eststo: meqrlogit housef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major: if cong>106
** - NO 90% Party Votes pre-2000 -- eststo: meqrlogit housef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major: if cong<107
eststo: meqrlogit housef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major: if cong>106
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A7
eststo: mixed senatef_percmin allcomm_index allfloor_index approps || _all: R.cong || major: if cong<107
eststo: mixed senatef_percmin allcomm_index allfloor_index approps || _all: R.cong || major: if cong>106
eststo: meqrlogit senatef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major: if cong<107
eststo: meqrlogit senatef_pv50 allcomm_index allfloor_index approps || _all: R.cong || major: if cong>106
** - NO 90% Party Votes pre-2000 -- eststo: meqrlogit senatef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major: if cong<107
eststo: meqrlogit senatef_pv90 allcomm_index allfloor_index approps || _all: R.cong || major: if cong>106
esttab, se star(* 0.05 ** 0.01)
eststo clear

* Table A8
eststo: mixed house1_percmin hcomm_index hfloor_index_2 approps || _all: R.cong || major:
eststo: meqrlogit house1_pv50 hcomm_index hfloor_index_2 approps || _all: R.cong || major:
eststo: meqrlogit house1_pv90 hcomm_index hfloor_index_2 approps || _all: R.cong || major:
eststo: mixed housef_percmin allcomm_index allfloor_index_2 approps || _all: R.cong || major:
eststo: meqrlogit housef_pv50 allcomm_index allfloor_index_2 approps || _all: R.cong || major:
eststo: meqrlogit housef_pv90 allcomm_index allfloor_index_2 approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A9
eststo: mixed senate1_percmin scomm_index sfloor_index approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv50 scomm_index sfloor_index approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv90 scomm_index sfloor_index approps || _all: R.cong || major:
eststo: mixed senatef_percmin allcomm_index allfloor_index_2 approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv50 allcomm_index allfloor_index_2 approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv90 allcomm_index allfloor_index_2 approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear

* Table A10
eststo: mixed house1_percmin anyhcommunorth anyhfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit house1_pv50 anyhcommunorth anyhfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit house1_pv90 anyhcommunorth anyhfloorunorth approps || _all: R.cong || major:
eststo: mixed housef_percmin anycommunorth anyfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit housef_pv50 anycommunorth anyfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit housef_pv90 anycommunorth anyfloorunorth approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A11
eststo: mixed senate1_percmin anyscommunorth anysfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv50 anyscommunorth anysfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit senate1_pv90 anyscommunorth anysfloorunorth approps || _all: R.cong || major:
eststo: mixed senatef_percmin anycommunorth anyfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv50 anycommunorth anyfloorunorth approps || _all: R.cong || major:
eststo: meqrlogit senatef_pv90 anycommunorth anyfloorunorth approps || _all: R.cong || major:
esttab, se star(* 0.05 ** 0.01)
eststo clear

* Table A12
eststo: reg house1_percmin hcomm_index hfloor_index approps dividedgov dividedchambers house_maj_seat housepolar i.major
eststo: logit house1_pv50 hcomm_index hfloor_index approps dividedgov dividedchambers house_maj_seat housepolar, cluster(major)
eststo: logit house1_pv90 hcomm_index hfloor_index approps dividedgov dividedchambers house_maj_seat housepolar, cluster(major)
eststo: reg housef_percmin allcomm_index allfloor_index approps dividedgov dividedchambers house_maj_seat housepolar i.major
eststo: logit housef_pv50 allcomm_index allfloor_index approps dividedgov dividedchambers house_maj_seat housepolar, cluster(major)
eststo: logit housef_pv90 allcomm_index allfloor_index approps dividedgov dividedchambers house_maj_seat housepolar, cluster(major)
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A13
eststo: reg senate1_percmin scomm_index sfloor_index approps dividedgov dividedchambers senate_maj_seat senatepolar i.major
eststo: logit senate1_pv50 scomm_index sfloor_index approps dividedgov dividedchambers senate_maj_seat senatepolar, cluster(major)
eststo: logit senate1_pv90 scomm_index sfloor_index approps dividedgov dividedchambers senate_maj_seat senatepolar, cluster(major)
eststo: reg senatef_percmin allcomm_index allfloor_index approps dividedgov dividedchambers senate_maj_seat senatepolar i.major
eststo: logit senatef_pv50 allcomm_index allfloor_index approps dividedgov dividedchambers senate_maj_seat senatepolar, cluster(major)
eststo: logit senatef_pv90 allcomm_index allfloor_index approps dividedchambers senate_maj_seat senatepolar, cluster(major)
esttab, se star(* 0.05 ** 0.01)
eststo clear

* Table A14
eststo: mixed house1_percmin hcomm_index hfloor_index approps || _all: R.cong
eststo: meqrlogit house1_pv50 hcomm_index hfloor_index approps || _all: R.cong
eststo: meqrlogit house1_pv90 hcomm_index hfloor_index approps || _all: R.cong
eststo: mixed housef_percmin allcomm_index allfloor_index approps || _all: R.cong
eststo: meqrlogit housef_pv50 allcomm_index allfloor_index approps || _all: R.cong
eststo: meqrlogit housef_pv90 allcomm_index allfloor_index approps || _all: R.cong
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A15
eststo: mixed senate1_percmin scomm_index sfloor_index approps || _all: R.cong
eststo: meqrlogit senate1_pv50 scomm_index sfloor_index approps || _all: R.cong
eststo: meqrlogit senate1_pv90 scomm_index sfloor_index approps || _all: R.cong
eststo: mixed senatef_percmin allcomm_index allfloor_index approps || _all: R.cong
eststo: meqrlogit senatef_pv50 allcomm_index allfloor_index approps || _all: R.cong
eststo: meqrlogit senatef_pv90 allcomm_index allfloor_index approps || _all: R.cong
esttab, se star(* 0.05 ** 0.01)
eststo clear

* Table A16
eststo: reg house1_percmin hcomm_index hfloor_index approps i.cong
eststo: logit house1_pv50 hcomm_index hfloor_index approps i.cong
eststo: logit house1_pv90 hcomm_index hfloor_index approps, cluster(cong)
eststo: reg housef_percmin allcomm_index allfloor_index approps i.cong 
eststo: logit housef_pv50 allcomm_index allfloor_index approps i.cong
eststo: logit housef_pv90 allcomm_index allfloor_index approps
esttab, se star(* 0.05 ** 0.01)
eststo clear 

* Table A17
eststo: reg senate1_percmin scomm_index sfloor_index approps i.cong
eststo: logit senate1_pv50 scomm_index sfloor_index approps, cluster(cong)
eststo: logit senate1_pv90 scomm_index sfloor_index approps, cluster(cong)
eststo: reg senatef_percmin allcomm_index allfloor_index approps i.cong
eststo: logit senatef_pv50 allcomm_index allfloor_index approps, cluster(cong)
eststo: logit senatef_pv90 allcomm_index allfloor_index approps, cluster(cong)
esttab, se star(* 0.05 ** 0.01)
eststo clear




