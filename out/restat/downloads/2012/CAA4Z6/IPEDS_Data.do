****************************************************************************************
* This file imports data provided by the IPEDS data system 
* (see http://nces.ed.gov/ipeds/datacenter/, cleans the variables, and outputs 
* a data file which can be merged with the NACUBO endowment data.
****************************************************************************************

cd "Directory_Path"

*** revenue stdevs
insheet using IPEDS_Rev_Data.txt

gen nefi=all_rev-endow_rev
bysort unitid: nefi_growth=(nefi-nefi[_n-1])/nefi[_n-1]

gen nefi_fte=nefi/fte_student
bysort unitid: nefi_growth_fte=(nefi_fte-nefi_fte[_n-1])/nefi_fte[_n-1]

bysort unitid: egen sd_all_rev=sd(nefi_growth)
bysort unitid: egen fte_sd=sd(nefi_growth_fte)
save Rev_Stdev.dta, replace

*** Get correlations
merge year using CRSP_VW.dta
save Rev_Corr.dta, replace
statsby corr_crsp_vs=r(rho), by(unitid): corr nefi_growth crsp_vw
save Rev_Corr.dta, replace

*** Get average private gifts

use Gifts_CPI_Adjusted.dta, clear

bysort unitid: egen iped_avg_allyrs=mean(ipeds_priv_ggc)
gen ln_iped_avg_allyrs=ln(iped_avg_allyrs)

drop if year!=2002
save Avg_Priv_Gifts.dta, replace

*** Combine all of the ipeds variables into a single cross-section

insheet using IPEDS_Main.txt
save IPEDS_Main.dta, replace

sort unitid
merge 1:1 unitid using Rev_Stdev
save IPEDS_Main.dta, replace

merge 1:1 unitid using Rev_Corr
save IPEDS_Main.dta, replace

merge 1:1 unitid using Avg_Priv_Gifts
save IPEDS_Main.dta, replace

*** Merge in federal research spending from The Center dataset
merge 1:1 unitid using Fed_Research.dta
save IPEDS_Main.dta, replace

**** Generate variables

gen Pub_Priv=(CNTLAFFI!=1)
gen prop_admit=(admssnm+admssnw)/(applcnm+applcnw)
gen debt_to_assets=total_debt/total_assets
gen res_nefi_ratio=Fed_Res_Spending/nefi
gen doctoral=(Carnegie==15 | Carnegie==16)
gen masters=(Carnegie==21 | Carnegie==22)
gen bach_la=(Carnegie==31)
gen bach_gen=(Carnegie==32 | Carnegie==33)

gen perc_tuition = tuition/nefi
gen perc_govt = govt_approp/nefi
gen perc_priv_gift = priv_ggc/nefi
gen perc_pub_gift = pub_ggc/nefi

save IPEDS_Main.dta, replace

