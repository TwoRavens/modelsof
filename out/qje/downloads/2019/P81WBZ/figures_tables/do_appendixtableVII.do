/* Barjamovic-Chaney-Cosar-Hortacsu, QJE, Appendix Table VII, columns 5-8 of panel A and B*/
clear
capture log close _all

cd "/Users/ke.3747/Dropbox/Research/BCH_AssyrianTrade_local/BCCH_replication_package/figures_tables"
capture erase temp_main.dta
/**************************************************************/
// ancient L*T^1/theta estimates
qui do "do_ancientTs_appendixtableVII.do"
save temp_main.dta,replace

// Matching of ancient sites with modern districts
qui do "do_match_ancient_modern_cities_appendixtableVII.do" // Note: similarly, comment out line 15 and enable line 15  which imports the results from the native gravity regression 
merge 1:1 anccity using temp_main // all should merge!!
drop _merge
save temp_main.dta,replace

// Adding the geographic controls
qui do "do_ancient_city_characteristics_appendixtableVII.do" // Note: similarly, comment out line 8 and enable line 9  which imports the results from the native gravity regression
merge 1:1 anccity using temp_main.dta
drop _merge
/**************************************************************/
gsort -modernpop2
replace modernpop2 = modernpop2[_n-1] if modernpop2==. // winsorize at the smallest population level. robust to skipping this line and dropping the two cities without a modern town within the set radius

gen lnPop        = ln(modernpop2)  // Consistent with the baseline.
gen lnTa         = ln(T_anc)
gen lnRugged     = ln(TRI)
gen lnCrop       = ln(cropsuit)
gen lnRomanRoad  = ln(DFcrossings1)  // Roman roads, measure 1 and 2, robust to using measure 2 (DFcrossings1). See data prep file do_ancient_city_characteristics.do
gen lnRoadw      = ln(wcrossings) // natural road scores

/****************/
/* Regressions  */
/****************/
qui{
*keep if validity == 0 & anccity != "Mamma" // Enable for lost cities only, excludes Mamma (Appendix Table VII, columns 7-8)

// Appendix Table VII panel B: Determinants of ancient size
qui reg  lnTa  lnRoadw, robust 
estimates store m1
qui reg  lnTa  lnRoadw lnRugged, robust 
estimates store m2

label var lnRugged "\$\log\left(Ruggedness\right)\$" 
label var lnRoadw "\$\log\left(Natural Roads\right)\$" 

noi esttab m1 m2, compress noconstant  p starlevels(* 0.10 ** 0.05 *** 0.01)  stats(N r2,fmt(%9.0g %9.3f))

// Appendix Table VII panel A: Persistence of Economic Activity across 4000 Year
qui reg  lnPop lnTa, robust
estimates store m1
qui reg  lnPop  lnTa lnCrop, robust 
estimates store m2

label var lnTa "\$\log\left(Pop T^{1/\theta}|_{ancient} \right)\$" 
label var lnCrop "\$\log\left( (Crop Yield \right)\$" 

noi esttab m1 m2, compress noconstant  p starlevels(* 0.10 ** 0.05 *** 0.01)  stats(N r2,fmt(%9.0g %9.3f))

}

/***/
erase temp_main.dta
/***/



