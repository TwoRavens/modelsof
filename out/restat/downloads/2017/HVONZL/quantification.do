//
// Two-sided Heterogeneity and Trade : Quantification
// 

// This file exports data to Matlab which is Section 5 of the paper


use $wdata/imports, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) custid (sum) value, by(foretak abland year)

// Keep top 30 markets
merge m:1 abland using /tmp/top30, keep(match master)
drop _merge
save /tmp/tmp_cust_firm, replace

use /tmp/tmp_cust_firm, clear
merge m:1 foretak year using "capital_database", keepusing(drinnt prodinnsats)
drop if _merge==1 // outside manufacturing
drop if _merge==2 // Non-importers
drop _merge
replace prodinnsats = prodinnsats*1000 // Use same units as trade data (1 NOK)
replace drinnt = drinnt*1000 // Use same units as trade data (1 NOK)

encode abland, gen(cty)
egen firmdest = group(foretak abland)
tsset firmdest year
gen L_hat = custid/l.custid
gen R_hat = value/l.value
gen P_hat = prodinnsats/l.prodinnsats
gen R2_hat = R_hat/P_hat
gen L2_hat = L_hat


// Drop firms with negative or missing intermediate purchases
gen tmp = prodinnsats<0 | prodinnsats==.
egen tmp2 = max(tmp), by(foretak cty)
drop if tmp2==1
drop tmp tmp2

// Keep only firm-destinations with positive purchases in both 2008 and 2009
gen tmp = year==2008 | year==2009
egen tmp2 = sum(tmp), by(firmdest)
keep if tmp2==2
drop tmp tmp2
keep if year==2008 | year==2009

// Trade shares
egen totimp = total(value), by(foretak year)
gen pi = value/totimp
gen piNO = (prodinnsats-(totimp))/prodinnsats
replace piNO=0 if piNO<0 // A few obs <0 and >1
replace piNO=1 if piNO>1

sort firmdest year
tsset firmdest year
gen lpi = l.pi
gen lpiNO = l.piNO
gen lcustid = l.custid

keep if year==2009
keep foretak cty abland year L_hat L2_hat R_hat R2_hat pi lpi piNO lpiNO drinnt lcustid
sort foretak cty year
format foretak %10.0f
save /tmp/tmp, replace

use /tmp/tmp, clear
keep foretak cty L2_hat 
reshape wide L2_hat,  i(foretak) j(cty)
outfile L2_* using "$path/matlab/calib_firmL_manuf2", comma wide replace noquote

use /tmp/tmp, clear
keep foretak cty lcustid 
reshape wide lcustid,  i(foretak) j(cty)
outfile lcustid* using "$path/matlab/calib_firmCustid_manuf2", comma wide replace noquote

use /tmp/tmp, clear
keep foretak cty R2_hat 
reshape wide R2_hat,  i(foretak) j(cty)
outfile R2_* using "$path/matlab/calib_firmR_manuf2", comma wide replace noquote

use /tmp/tmp, clear
keep foretak cty lpi 
reshape wide lpi,  i(foretak) j(cty)
outfile lpi* using "$path/matlab/calib_firmpi_manuf2", comma wide replace noquote

use /tmp/tmp, clear
contract foretak lpiNO drinnt
outfile lpiNO drinnt using "$path/matlab/calib_firmpiNO_manuf2", comma wide replace noquote

use /tmp/tmp, clear
contract cty abland
sort cty abland
outfile abland using "$path/matlab/countries_manuf2", comma wide replace noquote

