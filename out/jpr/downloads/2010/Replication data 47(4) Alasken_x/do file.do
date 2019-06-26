

///Generate 0 -1 rate from political rights index//
gen dem_pr = ((political_rights_index*-1)+7)/6


//generate variables//
gen oil_share =(oil_wb* crudeoilannualaverageworldpricet/ gdpcurrentusd)*100
replace oil_share = 0 if oil_wb==0
gen lrgdpl =log( rgdpl)
gen lpop=log(population)
gen coast_share= coastline_length_km/ (coastline_length_km+land_boundaries_km)
tsset cnr period2
tab period2, gen (Iperiod2)



//Table 2//
preserve
keep if period2!=.

quietly {

reg  dem_pr L.dem_pr L.oil_share Iperiod2*, cluster(cnr)
est store base1
reg  dem_pr L.dem_pr L.lrgdpl L.oil_share Iperiod2*, cluster(cnr)
est store base2
reg  dem_pr L.dem_pr L.lrgdpl L.lpop L.oil_share Iperiod2*, cluster(cnr)
est store base3
reg  dem_pr L.dem_pr L.lrgdpl L.lpop L.oil_share L.avg_schooling Iperiod2*, cluster(cnr)
est store base4
reg  dem_pr L.dem_pr L.lrgdpl L.lpop L.oil_share L.avg_schooling L.openc muslim  years_indep  latitude coast_share  Iperiod2*, cluster(cnr)
est store base5

}
estout * , style(tab) ///
		cells(b(fmt(%10.3f)) se(fmt(%10.3f) par star)) ///
		stats(r2 cluster N chi2 p, fmt(%10.3f %10.3f %10.3f %10.0f %10.0f %10.3f %10.3f))  ///
		starlevels(* 0.10 ** 0.05 *** 0.01) varwidth(15) modelwidth(10) delimiter("")  ///
		drop(Iperiod2*)

restore
est clear



***Table 2***


preserve
keep if period2!=.


quietly {


reg dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2*, robust cluster(cnr)
est store base1
xtreg  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2*, fe cluster(cnr)
est store base2
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod2*) robust nol
est store base3
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod2*) robust two nol
est store base4
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod2*) robust
est store base5
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod2*) robust two
est store base6
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2* if opec==0, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod2*) robust
est store base7
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod2* if opec==0, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod2*) robust two
est store base8

}
estout * , style(tab) ///
		cells(b(fmt(%10.3f)) se(fmt(%10.3f) par star)) ///
		stats(r2 N N_g AR hansen, fmt(%10.3f %10.3f %10.3f %10.0f %10.0f %10.3f %10.3f))  ///
		starlevels(* 0.10 ** 0.05 *** 0.01) varwidth(15) modelwidth(10) delimiter("")  ///
		drop(Iperiod2*)

restore
est clear



***Table 3***


preserve
keep if period2!=.

quietly {


xtabond2  dem_pr L.dem_pr  L.oil_share L.avg_schooling L.lrgdpl L.lpop L.openc Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_share L.lrgdpl) iv( L.openc L.lpop Iperiod2*) robust
est store base1
xtabond2  dem_pr L.dem_pr  L.oil_share L.avg_schooling L.lrgdpl L.lpop L.openc Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_share L.lrgdpl) iv( L.openc L.lpop Iperiod2*) robust two
est store base2

}
estout * , style(tab) ///
		cells(b(fmt(%10.3f)) se(fmt(%10.3f) par star)) ///
		stats(r2 N N_g AR1, fmt(%10.3f %10.3f %10.3f %10.0f %10.0f %10.3f %10.3f))  ///
		starlevels(* 0.10 ** 0.05 *** 0.01) varwidth(15) modelwidth(10) delimiter("")  ///
		drop(Iperiod2*)

restore
est clear



***Table 4***

//generate new oil variables//
preserve
gen log_oil_share=log(oil_share)
gen oil_pop=(oil_wb*(7.33)*oilprice_barrol_2005usd)/population
gen oil_pop_1000=oil_pop/1000
gen log_oil_pop=log(oil_pop)

keep if period2!=.


quietly {


xtabond2  dem_pr L.dem_pr L.oil_pop_1000 L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.oil_pop_1000) iv(Iperiod2*) robust
est store base1
xtabond2  dem_pr L.dem_pr L.log_oil_pop L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.log_oil_pop) iv(Iperiod2*) robust
est store base2
xtabond2  dem_pr L.dem_pr L.log_oil_share L.avg_schooling Iperiod2*, gmm(L.dem_pr L.avg_schooling L.log_oil_share) iv(Iperiod2*) robust
est store base3


}
estout * , style(tab) ///
		cells(b(fmt(%10.3f)) se(fmt(%10.3f) par star)) ///
		stats(r2 N N_g AR1, fmt(%10.3f %10.3f %10.3f %10.0f %10.0f %10.3f %10.3f))  ///
		starlevels(* 0.10 ** 0.05 *** 0.01) varwidth(20) modelwidth(10) delimiter("")  ///
		drop(Iperiod*)

restore
est clear





***Table A.2***


//column (1)//
preserve
tsset cnr period4
tab period4, gen (Iperiod4)
keep if period4!=.
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod4*, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod4*) robust
restore

//column (2)//
preserve
tsset cnr period7
tab period7, gen (Iperiod7)
keep if period7!=.
xtabond2  dem_pr L.dem_pr L.oil_share L.avg_schooling Iperiod7*, gmm(L.dem_pr L.avg_schooling L.oil_share) iv(Iperiod7*) robust
restore




****Outlier test****
***change argument if cnr!=1 for all cnr***
preserve
keep if period2!=.



quietly {

xtabond2  dem L.dem L.oil_share L.avg_schooling Iperiod* if cnr!=1, gmm(L.dem L.avg_schooling L.oil_share) iv(Iperiod*) robust
est store base1

}
estout * , style(tab) ///
		cells(b(fmt(%10.3f)) se(fmt(%10.3f) par star)) ///
		stats(r2 N N_g AR1, fmt(%10.3f %10.3f %10.3f %10.0f %10.0f %10.3f %10.3f))  ///
		starlevels(* 0.10 ** 0.05 *** 0.01) varwidth(20) modelwidth(10) delimiter("")  ///
		drop(Iperiod*)


restore
est clear

