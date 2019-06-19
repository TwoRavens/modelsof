* This file is used to generate table 1*

/*********Table 1: summary statistics and correlation**********/

/*Panel A*/
use data1.dta, clear
tabstat  ipp1 christian british, stats(mean sd min p25  p50 p75 max n)  col(stat)

use data2.dta, clear 
tabstat ipp2 incorrupt credit  gdpgrow university   metropolis, stats(mean sd min p25  p50 p75 max n)  col(stat)

/*Panel B and Panel C*/
use hightech.dta, clear
tabstat   pnewdebt   pnewexternal  rdasset innovation   newsalep   patentdummy salegrow intangible roa leverage  newdebtasset  newexternalasset newinternalasset lnrdstock logasset logage , stats(mean sd min p25  p50 p75 max n)  col(stat)

pwcorr  ipp1 ipp2 christian british incorrupt  credit gdpgrow university  metropolis,sig
