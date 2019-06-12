*This is a do-file to replicate Table 9 (and footnote 42) of Costinot, Donaldson, Kyle and Williams (QJE, 2019)


***Preamble***

capture log close
*Set log
log using "${log_dir}tab9.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}data_for_price_on_distance.dta", clear
preserve
***Prepare data***

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry



****** Column (2) *********

reghdfe lnprice lndist, absorb(mol#corp#gbd) vce(cluster dest_country)
*Save variables as scalars
scalar TabIXColILNDistVal = round(_b[lndist], 0.001)
scalar TabIXColILNDistSE = round(_se[lndist], 0.001)
scalar TabIXColIRsq = round(e(r2_a), 0.001)
scalar TabIXColIObs = e(N)



****** Column (1) *********

*Prepare data
restore
use "${finalsavedir}main_final_dataset.dta"

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

reghdfe lnsales lndist, absorb(dest_country#gbd sales_country#gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabIXColIILNDistVal = round(_b[lndist], 0.001)
scalar TabIXColIILNDistSE = round(_se[lndist], 0.001)
scalar TabIXColIIRsq = round(e(r2_a), 0.001)
scalar TabIXColIIObs = e(N)




****** Footnote 42 -  clustering on destination country only
reghdfe lnsales lndist, absorb(dest_country#gbd sales_country#gbd) vce(cluster dest_country)
*Save variables as scalars
scalar TabIXColIILNDistSEDestCluster = round(_se[lndist], 0.001)


scalar list

log close
