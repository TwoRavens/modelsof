/*-------------------------------------------------HC_rev_crosssec_price_comp.do

Stuart Craig
Last updated	20180816
*/


	timestamp, output
	cap mkdir crosssec
	cd crosssec
	cap mkdir comp
	cd comp

	foreach proc in ip {
		use ${ddHC}/HC_hdata_`proc'.dta, clear
		keep if adj_price<.&merge_year>2007

		foreach lhs of varlist adj_price  {
			cap drop logprice
			gen logprice = log(1+`lhs')
			eststo clear
			
			// Generate baseline covariates
			makex, log
			drop x_mdt*
			
			// Construct alternate competition measures
			cap drop hhi_var
			qui gen hhi_var=.
			qui replace hhi_var = syshhi_10m if mci_urgeo=="LURBAN"
			qui replace hhi_var = syshhi_20m if mci_urgeo=="OURBAN"
			qui replace hhi_var = syshhi_30m if mci_urgeo=="RURAL"
			cap drop hhi_q4
			qui egen hhi_q4 = xtile(syshhi_15m), by(ep_adm_y) nq(4)
			forval q=1/4 {
				cap drop hhi_q4_`q'
				qui gen hhi_q4_`q' = hhi_q4==`q'
			}
			drop hhi_q4_1
			// Separate regression for different radii and competitor count
			foreach v of varlist syshhi_5m syshhi_15m syshhi_30m hhi_var hcount15 {
				cap drop comp_measure
				qui gen comp_measure = `v'
				if strpos("`v'","hhi")>0 qui replace comp_measure = log(1 + 10000*comp_measure)
				eststo: reghdfe logprice comp_measure x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
				estadd local comp_measure "`v'"
			}
			// Q1-Q4 (Q1 is the base)
			eststo: reghdfe logprice hhi_q4_4 hhi_q4_3 hhi_q4_2 x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
			// Q4 against everything else
			eststo: reghdfe logprice hhi_q4_4 x_*, absorb(prov_hrrnum ep_adm_y) vce(cluster prov_hrrnum)
			
			esttab * using HC_rev_crosssec_price_comp_`proc'_`lhs'.csv, ///
				replace  star(* .1 ** .05 *** .01)  ///
				b(%4.3f) se(%4.3f) scalar(r2) obslast lab 
			
		}	
	}
exit

