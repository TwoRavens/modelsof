/*---------------------------------------------------------------HC_rev_dfig_withinmkt.do

Stuart Craig
Last updated 20180816
*/

timestamp, output
cap mkdir dfig_withinmkt
cd dfig_withinmkt

foreach proc in knr kmri {
	if "`proc'"=="ip" continue
	use ${ddHC}/HC_hdata_`proc'.dta, clear
	
	// Key for titles (we don't use anymore)
	loc procedure ""
	if "`proc'"=="hip" loc procedure "Hip Replacement"
	if "`proc'"=="knr" loc procedure "Knee Replacement"
	if "`proc'"=="delc" loc procedure "Cesarean Section"
	if "`proc'"=="delv" loc procedure "Vaginal Delivery"
	if "`proc'"=="ptca" loc procedure "PTCA"
	if "`proc'"=="col" loc procedure "Colonoscopy"
	if "`proc'"=="kmri" loc procedure "Lower Limb MRI"
	
	// Create the price measures
	cap drop raw_facprice
	cap drop raw_facmedprice
	cap drop adj_facprice
	cap drop adj_facmedprice
	qui gen adj_facprice	= adj_price
	qui gen adj_facmedprice	= medprice // no risk adj here
	if "`proc'"=="ip" qui replace adj_facmedprice = prov_pps
	cap gen raw_phyprice	= adj_plus_phy // won't happen for IP
	if _rc==0 pindex raw_phyprice, generate(adj_phyprice)
	
	foreach v of varlist adj_* {
		qui gen u_`v' = `v'
		qui gen p50_`v' = `v'
	}
	
	// 2011 data only
	keep if ep_adm_y==2011
	collapse (mean) u_* (p50) p50_* (first) prov_hrr* [aw=prov_vol], by(prov_e_npi) fast
	
	// Save count list
	cap drop hcount
	qui egen hcount = count(prov_hrrnum), by(prov_hrrnum)
	keep if hcount>4 // exclusion up front
	preserve
		keep hcount prov_hrr*
		bys prov_hrrnum: keep if _n==1
		save temp_hrrcount_`proc'.dta, replace
	restore
	
	// Scaling parameters
	qui summ u_adj_facprice
	loc max = r(max)
	loc interval = round(`max'/4,1000)
	loc max = `interval'*4
	loc aint = `interval'
	loc amax = `max'

	// Just main HRRs with no titles
	loc hrr 356 // can loop over HRRs here as well
	preserve
		keep if prov_hrrnum==`hrr'
		
		// pass the loop if it's a prohibitively small market
		qui count
		assert r(N)>4 // 5+ hospitals
		if _rc!=0 {
			restore
			continue
		}
		// Pull city and state for whatever HRR we're using
		qui levelsof prov_hrrcity, loc(city)
		loc city = `city'
		qui levelsof prov_hrrstate, loc(st)
		loc st = `st'
	
		// Do it without titles
		qui summ u_adj_facmedprice, mean
		loc med = r(mean)
		qui summ u_adj_facprice
		loc priv = r(mean)
		loc mean: di %6.0fc `=`priv''
		loc mean "$`mean'"
		loc mm = substr(string(r(max)/r(min)),1,4)
		loc cv = substr(string(r(sd)/r(mean)),1,4)
		if substr("`cv'",1,1)=="." loc cv = "0`cv'"
		cap drop g
		qui egen g = gini(u_adj_facprice)
		qui summ g, mean
		loc g = substr(string(r(mean)),1,4)
		if substr("`g'",1,1)=="." loc g = "0`g'"
		
		qui summ u_adj_facprice, d
		loc rat9010: di %3.2f r(p90)/r(p10)
		
	// Within-mkt figure
		cap drop overmed
		qui gen overmed = u_adj_facprice - u_adj_facmedprice
		cap drop undermed
		qui gen undermed = u_adj_facprice if overmed<0
		qui replace u_adj_facmedprice = u_adj_facmedprice - undermed if overmed<0
		qui replace overmed=0 if overmed<0
		drop if overmed==.|u_adj_facmedprice==.
		graph bar undermed u_adj_facmedprice overmed, over(prov_e_npi, sort(u_adj_facprice) label(nolabel)) stack ///
			title("  Mean: `mean'" "  CoV: `cv'" "  p90/p10 Ratio: `rat9010'" "  Max/Min Ratio: `mm'", position(11) ring(0) size(vlarge))  ///
			bar(1, color("${red}")) bar(2, color("${blu}") fintensity(30)) bar(3, color("${red}")) ///
			yline(`priv', lc("${red}") lstyle(solid) lw(medium)) ///
			yline(`med', lc("${blu}") lstyle(solid) lw(medium)) ///
			ytitle("Price ($)", size(medlarge)) ylabel(0(`aint')`amax') /* title("`procedure'", pos(12)) */ ///
			legend(order(1 "Negotiated Price" 2 "Medicare Reimbursement Rate" )) // legend(off)
		graph export  HC_rev_withinmkt_`proc'_`=subinstr("`city'"," ","_",.)'_legend.png, as(png) replace
		// Again without legend
		graph bar undermed u_adj_facmedprice overmed, over(prov_e_npi, sort(u_adj_facprice) label(nolabel)) stack ///
			title("  Mean: `mean'" "  CoV: `cv'" "  p90/p10 Ratio: `rat9010'" "  Max/Min Ratio: `mm'", position(11) ring(0) size(vlarge))  ///
			bar(1, color("${red}")) bar(2, color("${blu}") fintensity(30)) bar(3, color("${red}")) ///
			yline(`priv', lc("${red}") lstyle(solid) lw(medium)) ///
			yline(`med', lc("${blu}") lstyle(solid) lw(medium)) ///
			ytitle("Price ($)", size(medlarge)) ylabel(0(`aint')`amax') /* title("`procedure'", pos(12)) */ ///
			legend(off)
		graph export  HC_rev_withinmkt_`proc'_`=subinstr("`city'"," ","_",.)'.png, as(png) replace
		
	// B/W for publication
		graph bar undermed u_adj_facmedprice overmed, over(prov_e_npi, sort(u_adj_facprice) label(nolabel)) stack ///
			title("  Mean: `mean'" "  CoV: `cv'" "  p90/p10 Ratio: `rat9010'" "  Max/Min Ratio: `mm'", position(11) ring(0) size(vlarge))  ///
			bar(1, color(gs5)) bar(2, color(gs10) fintensity(30)) bar(3, color(gs5)) ///
			yline(`priv', lc(gs5) lstyle(solid) lw(medium)) ///
			yline(`med', lc(gs10) lstyle(solid) lw(medium)) ///
			ytitle("Price ($)", size(medlarge)) ylabel(0(`aint')`amax') /* title("`procedure'", pos(12)) */ ///
			legend(order(1 "Negotiated Price" 2 "Medicare Reimbursement Rate" )) // legend(off)
		graph export  HC_pub_withinmkt_`proc'_`=subinstr("`city'"," ","_",.)'_legend.tif, replace width(5000)
		// Again without legend
		graph bar undermed u_adj_facmedprice overmed, over(prov_e_npi, sort(u_adj_facprice) label(nolabel)) stack ///
			title("  Mean: `mean'" "  CoV: `cv'" "  p90/p10 Ratio: `rat9010'" "  Max/Min Ratio: `mm'", position(11) ring(0) size(vlarge))  ///
			bar(1, color(gs5)) bar(2, color(gs10) fintensity(30)) bar(3, color(gs5)) ///
			yline(`priv', lc(gs5) lstyle(solid) lw(medium)) ///
			yline(`med', lc(gs10) lstyle(solid) lw(medium)) ///
			ytitle("Price ($)", size(medlarge)) ylabel(0(`aint')`amax') /* title("`procedure'", pos(12)) */ ///
			legend(off)
		graph export  HC_pub_withinmkt_`proc'_`=subinstr("`city'"," ","_",.)'.tif, replace width(5000)
		
	restore
}
exit
