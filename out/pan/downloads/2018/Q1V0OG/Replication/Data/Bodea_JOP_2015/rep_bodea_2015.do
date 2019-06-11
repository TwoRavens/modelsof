clear all
set more off
cd "~/Dropbox (MIT)/Interaction Paper/Data/Included/Bodea_JOP_2015/"

/* to replicate Table 1*/

use "bh_jopdata.dta", clear

/*** FDI */
** Model 7 - All countries, no interaction
xtreg fdiinflow year c.llvaw polity2_cen l.( dffrus dfxreserves openness dgdp_k lngdppc fiscal_balance capital_controls  lninfl  signyearfill) xrdum if tag==1 & l.tag==1, cl(cowcode) fe

** Model 8 - Non-OECD, no interaction
xtreg fdiinflow year c.llvaw polity2_cen l.( dffrus dfxreserves openness dgdp_k lngdppc fiscal_balance capital_controls  lninfl  signyearfill) xrdum  if oecd==0 & tag==1 & l.tag==1, cl(cowcode) fe


** Model 9 - Non-OECD, CBI*Polity /* interaction -- key */
xtreg fdiinflow year  c.llvaw##c.polity2_cen  l.( dffrus dfxreserves openness dgdp_k lngdppc fiscal_balance capital_controls  lninfl  signyearfill) xrdum  if oecd==0 & tag==1 & l.tag==1, cl(cowcode) fe

/* save */
foreach var of varlis dffrus dfxreserves openness dgdp_k lngdppc fiscal_balance capital_controls  lninfl  signyearfill {
  bysort cowcode (year): g l_`var'=`var'[_n-1]
}
keep if e(sample)
areg fdiinflow, a(cowcode)
predict  fdiinflow_res, res /*within residuals*/
keep fdiinflow fdiinflow_res year  llvaw polity2_cen  l_dffrus l_dfxreserves l_openness l_dgdp_k l_lngdppc l_fiscal_balance l_capital_controls  l_lninfl  l_signyearfill xrdum cowcode
saveold rep_bodea_2015a, replace

/*check*/
xtreg fdiinflow_res year  c.llvaw##c.polity2_cen  l_dffrus l_dfxreserves l_openness l_dgdp_k l_lngdppc l_fiscal_balance l_capital_controls  l_lninfl  l_signyearfill xrdum, cl(cowcode) fe


/*** 10 YEAR BONDS */
use "bh_jopdata.dta", clear

** Model 13 - All countries, no interaction
    xtreg real_10yrate  c.llvaw polity2_cen l.(dffrus dfxreserves openness wdgdpdefl dgdp_k lngdppc fiscal_balance capital_controls lngdp lninfl ) xrdum year  if abs(real_10yrate)<50 & abs(l.real_10yrate)<50, cl(cowcode) fe


** Model 14 - Non-OECD, no interaction
xtreg real_10yrate c.llvaw polity2_cen l.(dffrus dfxreserves openness wdgdpdefl dgdp_k lngdppc fiscal_balance capital_controls lngdp lninfl ) xrdum year   if abs(real_10yrate)<50 & oecd==0 & abs(l.real_10yrate)<50 , cl(cowcode) fe


** Model 15 - Non-OECD, CBI*Polity /*interaction -- key*/
xtreg real_10yrate  c.llvaw##c.polity2_cen l.(dffrus dfxreserves openness wdgdpdefl dgdp_k lngdppc fiscal_balance capital_controls lngdp lninfl ) xrdum year if abs(real_10yrate)<50 & oecd==0  & abs(l.real_10yrate)<50, cl(cowcode) fe

/* save */
foreach var of varlis dffrus dfxreserves openness wdgdpdefl dgdp_k lngdppc fiscal_balance capital_controls lngdp lninfl {
  bysort cowcode (year): g l_`var'=`var'[_n-1]
}
keep if e(sample)
areg real_10yrate, a(cowcode)
predict  real_10yrate_res, res /*within residuals*/
keep real_10yrate llvaw real_10yrate_res polity2_cen l_dffrus l_dfxreserves l_openness l_wdgdpdefl l_dgdp_k l_lngdppc l_fiscal_balance l_capital_controls l_lngdp l_lninfl xrdum cowcode year
saveold rep_bodea_2015b, replace  

/*check*/
xtreg real_10yrate_res  c.llvaw##c.polity2_cen l_dffrus l_dfxreserves l_openness l_wdgdpdefl l_dgdp_k l_lngdppc l_fiscal_balance l_capital_controls l_lngdp l_lninfl xrdum year, cl(cowcode) fe
