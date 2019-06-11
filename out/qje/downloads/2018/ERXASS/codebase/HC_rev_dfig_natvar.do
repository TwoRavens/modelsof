/* --------------------------------------------------------------------HC_rev_dfig_natvar.do
Creates national variation graphs/tables for every procedure

Stuart Craig
Last updated 	20180816
*/

timestamp, output
cap mkdir dfig_natvar
cd dfig_natvar
	
foreach proc of global proclist {
	cap confirm file HC_dfig_rev_natvar_`proc'.csv
	if _rc!=0 {
		if "`proc'"=="ip" continue
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		
		cap drop price
		cap drop medicare
		rename medprice medicare
		rename adj_price price
		
		// Keep 2011 only
		keep if ep_adm_y==2011
		keep if price<.
		collapse (mean) price medicare [aw=prov_vol] , by(prov_e_npi) fast
		
		pfixdrop g_
		qui gen g_price = price
		qui gen g_medprice = medicare
		qui gen g_overmed = g_price-g_medprice
		qui gen g_undermed = g_price if g_overmed<0
		qui replace g_medprice = g_medprice - g_undermed if g_overmed<0
		qui replace g_overmed = 0 if g_overmed<0
		di "`proc'"
		graph bar (asis) g_undermed g_medprice g_overmed, over(prov_e_npi, sort(price) label(nolabel)) stack ///
			b2title("Providers", size(medlarge)) note("Ordered by Private Price") ylabel(, labsize(medium)) ///
			bar(1, color("${red}")) bar(2, color(gs11) fintensity(50) lw(none) lp(blank)) bar(3, color("${red}")) ///
			legend(order(2 "Medicare Reimbursement Rate" 3 "Negotiated Price") size(medlarge)) note("")
		graph export HC_rev_dfig_natvar_`proc'_psort.png, as(png) replace
		// Do it again for the publication (grey)
		graph bar (asis) g_undermed g_medprice g_overmed, over(prov_e_npi, sort(price) label(nolabel)) stack ///
			b2title("Providers", size(medlarge)) note("Ordered by Private Price") ylabel(, labsize(medium)) ///
			bar(1, color(gs4)) bar(2, color(gs12) lw(medthick))  bar(3, color(gs4)) ///
			legend(order(2 "Medicare Reimbursement Rate" 3 "Negotiated Price") size(medlarge)) note("")
		graph export HC_pub_dfig_natvar_`proc'_psort.png, as(png) replace
		graph export HC_pub_dfig_natvar_`proc'_psort.tif, as(tif) replace width(5000)
		
		// Here we make the table of descriptives
		foreach t in mean sd min max p25 p75 p10 p90 {
			qui gen prv_`t' = price
			qui gen pub_`t'  = medicare
		}
		qui egen prv_gini = gini(price)
		qui egen pub_gini = gini(medicare)
		gen N=1
		collapse (sum) N (mean) *mean *gini (sd) *sd (min) *min (max) *max (p25) *p25 (p75) *p75 (p10) *p10 (p90) *p90, fast
		
		// Round, calculate distance and ratio measures
		qui d, varlist
		foreach v in `r(varlist)' {
			if substr("`v'",-4,4)=="gini" qui replace `v' = round(`v',.01)
			else qui replace `v' = round(`v')
		}
		foreach t in pub prv {
			qui gen `t'_cv 		= round(`t'_sd/`t'_mean,.01)
			qui gen `t'_p90p10r	= round(`t'_p90/`t'_p10,.01)
			qui gen `t'_p75p25r	= round(`t'_p75/`t'_p25,.01)
			qui gen `t'_p75p25d	= string(`t'_p25) + " - " + string(`t'_p75)
			qui gen `t'_p90p10d = string(`t'_p10) + " - " + string(`t'_p90)
			qui gen `t'_minmax	= string(`t'_min) + " - " + string(`t'_max)
		}
		keep *mean *minmax *p??p??? *cv *gini N
		// Reshape the data
		qui d, varlist
		foreach v in `r(varlist)' {
			cap confirm numeric var `v'
			if _rc==0 {
				cap drop temp
				rename `v' temp
				qui gen `v' = string(temp)
			}
		}
		cap drop temp
		cap drop i
		qui gen i = .
		reshape long prv_ pub_, i(i) j(stat) s
		
		qui replace i =1 if stat=="mean"
		qui replace i =2 if stat=="minmax"
		qui replace i =3 if stat=="p90p10d"
		qui replace i =4 if stat=="p75p25d"
		qui replace i =5 if stat=="p90p10r"
		qui replace i =6 if stat=="p75p25r"
		qui replace i =7 if stat=="cv"
		qui replace i =8 if stat=="gini"
		sort i
		outsheet using HC_rev_dfig_natvar_`proc'.csv, comma replace
	}
}
exit
