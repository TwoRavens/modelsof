/*
The programs and data files replicate the descriptive statistics and the estimation results in the paper

	Hornok, Cec’lia and Mikl—s Koren, forthcoming. ÒPer-Shipment Costs and the Lumpiness of International Trade.Ó Review of Economics and Statistics.

Please cite the above paper when using these programs.

For your convenience, we reproduce some of the data resources here. Although all of these are widely available macroeconomic data, please check with the data vendors whether you have the right to use them.

Our software and data are provided AS IS, and we assume no liability for their use or misuse. 

If you have any questions about replication, please contact Mikl—s Koren at korenm@ceu.hu.
*/

*** Runs the estimations creating Tables 3-7. Output is exhibit/table*.xls.

set more off
local spain data/derived/spain_export_2009_with_gravity.dta
local usa data/derived/usa_export_2009_with_gravity.dta

use `usa', clear

*****************************************
* Table 3: Estimates for U.S. exports
*****************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lx day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table3.xls, se bracket coefastr bdec(3) adjr2 replace
areg ln day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table3.xls, se bracket coefastr bdec(3) adjr2 append
areg lv day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table3.xls, se bracket coefastr bdec(3) adjr2 append
areg lx lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table3.xls, se bracket coefastr bdec(3) adjr2 append
areg ln lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table3.xls, se bracket coefastr bdec(3) adjr2 append
areg lv lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table3.xls, se bracket coefastr bdec(3) adjr2 append


*****************************************************
* Table 5: Detailed decomposition regressions - U.S.
*****************************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lh day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 replace
areg lnh day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lq day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lp day `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lh lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lnh lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lq lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lp lcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost `controls' using exhibit/table5_us.xls, se bracket coefastr bdec(3) adjr2 append


********************************************************
* Table 6: Regressions with two procedural costs - U.S.
********************************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lh adminday transitday `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 adminday transitday `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 replace
areg lnh adminday transitday `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 adminday transitday `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lq adminday transitday `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 adminday transitday `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lp adminday transitday `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 adminday transitday `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lh ladmincost ltransitcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lnh ladmincost ltransitcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lq ladmincost ltransitcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lp ladmincost ltransitcost `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_us.xls, se bracket coefastr bdec(3) adjr2 append



* define bec groups	
gen byte food = (bec>=111 & bec<=122)
gen byte ind = (bec==21 | bec==22)
gen byte captran = (bec==41 | bec==51 | bec==521 | bec==522)
gen byte parts = (bec==42 | bec==53)
gen byte dur = bec==61
gen byte sdur = bec==62
gen byte ndur = bec==63

* interactions with bec groups
foreach v of varlist food ind captran parts dur sdur ndur {
	gen day_`v' = day * `v'
	gen lcost_`v' = lcost * `v'
}

*********************************************
* Table 7: Product-specific estimates - U.S.
*********************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lx day_f day_i day_c day_p day_d day_s day_n `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day_f day_i day_c day_p day_d day_s day_n `controls' using exhibit/table7_us.xls, se bracket coefastr bdec(3) adjr2 replace
areg ln day_f day_i day_c day_p day_d day_s day_n `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day_f day_i day_c day_p day_d day_s day_n `controls' using exhibit/table7_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lv day_f day_i day_c day_p day_d day_s day_n `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 day_f day_i day_c day_p day_d day_s day_n `controls' using exhibit/table7_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lx lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' using exhibit/table7_us.xls, se bracket coefastr bdec(3) adjr2 append
areg ln lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' using exhibit/table7_us.xls, se bracket coefastr bdec(3) adjr2 append
areg lv lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' if kg==1, a(prodmode) cluster(cty_hs2)
	outreg2 lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' using exhibit/table7_us.xls, se bracket coefastr bdec(3) adjr2 append


	
use `spain', clear	
*****************************************
* Table 4: Estimates for Spanish exports
*****************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lx day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table4.xls, se bracket coefastr bdec(3) adjr2 replace
areg ln day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table4.xls, se bracket coefastr bdec(3) adjr2 append
areg lv day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table4.xls, se bracket coefastr bdec(3) adjr2 append
areg lx lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table4.xls, se bracket coefastr bdec(3) adjr2 append
areg ln lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table4.xls, se bracket coefastr bdec(3) adjr2 append
areg lv lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table4.xls, se bracket coefastr bdec(3) adjr2 append

*****************************************************
* Table 5: Detailed decomposition regressions - Spain
*****************************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lh day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 replace
areg lnh day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lq day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lp day `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lh lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lnh lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lq lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lp lcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost `controls' using exhibit/table5_es.xls, se bracket coefastr bdec(3) adjr2 append


********************************************************
* Table 6: Regressions with two procedural costs - Spain
********************************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lh adminday transitday `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 adminday transitday `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 replace
areg lnh adminday transitday `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 adminday transitday `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lq adminday transitday `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 adminday transitday `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lp adminday transitday `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 adminday transitday `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lh ladmincost ltransitcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lnh ladmincost ltransitcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lq ladmincost ltransitcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lp ladmincost ltransitcost `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 ladmincost ltransitcost `controls' using exhibit/table6_es.xls, se bracket coefastr bdec(3) adjr2 append
	

* define bec groups
gen byte food = (bec>=111 & bec<=122)
gen byte ind = (bec==210 | bec==220)
gen byte captran = (bec==410 | bec==510 | bec==521 | bec==522)
gen byte parts = (bec==420 | bec==530)
gen byte dur = bec==610
gen byte sdur = bec==620
gen byte ndur = bec==630

* interactions with bec groups
foreach v of varlist food ind captran parts dur sdur ndur {
	gen day_`v' = day * `v'
	gen lcost_`v' = lcost * `v'
}

*********************************************
* Table 7: Product-specific estimates - Spain
*********************************************
local controls lgdp lgdppc ldistwces island landlocked fta col45 comlang_off
areg lx day_f day_i day_c day_p day_d day_s day_n `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day_f day_i day_c day_p day_d day_s day_n `controls' using exhibit/table7_es.xls, se bracket coefastr bdec(3) adjr2 replace
areg ln day_f day_i day_c day_p day_d day_s day_n `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day_f day_i day_c day_p day_d day_s day_n `controls' using exhibit/table7_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lv day_f day_i day_c day_p day_d day_s day_n `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 day_f day_i day_c day_p day_d day_s day_n `controls' using exhibit/table7_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lx lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' using exhibit/table7_es.xls, se bracket coefastr bdec(3) adjr2 append
areg ln lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' using exhibit/table7_es.xls, se bracket coefastr bdec(3) adjr2 append
areg lv lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' if eu27!=1, a(prodmode) cluster(cty_cn2)
	outreg2 lcost_f lcost_i lcost_c lcost_p lcost_d lcost_s lcost_n `controls' using exhibit/table7_es.xls, se bracket coefastr bdec(3) adjr2 append


