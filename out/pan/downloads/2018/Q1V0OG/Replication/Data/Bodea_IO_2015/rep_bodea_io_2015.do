clear all
set more off
cd "~/Dropbox/Interaction Paper/Data/Included/Bodea_IO_2015/"

use "data/cb_rh_iodata.dta", clear
foreach var of varlist lninfl logdm2 lngdp dgdp_k openness fiscal_balance wdgdpdefl {
	bysort cowcode (year): g L_`var'=`var'[_n-1]
}
saveold "data/temp.dta", replace


/* Table 1 column 2; Figure 2 top */
use "data/temp.dta", clear
xtreg logdm2  l.logdm2 l.lngdp l.dgdp_k l.openness c.lvaw##c.polity2_cen xrdum l.fiscal_balance pres_only leg_only pres_leg i.region ib4.decade  if sample ,  fe cl(cowcode) 
keep if e(sample)
saveold "rep_bodea_io_2015a.dta", replace

/*  Figure 4 bottom */
use "data/temp.dta", clear
xtreg logdm2  l.logdm2 l.lngdp l.dgdp_k l.openness c.lvaw##c.FH_trans  xrdum l.fiscal_balance  pres_only leg_only pres_leg i.region  ib4.decade if sample  ,  fe cl(cowcode) 
keep if e(sample)
saveold "rep_bodea_io_2015b.dta", replace

/* Table 1 column 6; Figure 4 top */
use "data/temp.dta", clear
xtreg lninfl l.lninfl l.logdm2 l.lngdp l.dgdp_k l.openness c.lvaw##c.polity2_cen xrdum l.fiscal_balance pres_only leg_only pres_leg i.region l.wdgdpdefl /*ib4.decade*/ if sample ,  fe cl(cowcode) 
keep if e(sample)
saveold "rep_bodea_io_2015c.dta", replace

/*  Figure 4 bottom */
use "data/temp.dta", clear
xtreg lninfl l.lninfl l.logdm2 l.lngdp l.dgdp_k l.openness c.lvaw##c.FH_trans xrdum l.fiscal_balance  pres_only leg_only pres_leg i.region l.wdgdpdefl if sample  ,  fe cl(cowcode) 
keep if e(sample)
saveold "rep_bodea_io_2015d.dta", replace

