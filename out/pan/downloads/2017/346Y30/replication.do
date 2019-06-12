/*
Replication Do-File
Manuscript: The potential of online sampling for studying political activists around the world and across time.
Author: Kai Jäger

*/


*Install Coefplot Package
ssc install coefplot


*Change working directory
cd "\Facebook_sampling\replication"

*****************************
*** afd_party_results.dta ***
*****************************

use "afd_party_results.dta", clear

*** Results for Table 1, AfD Members

mean referenda if referenda !=99

mean gender_quotas if gender_quotas !=99

mean gender_ms if gender_ms !=99

mean minimum_wage if minimum_wage !=99

mean ttip if ttip !=99

mean luckepetry


****************
*** afd1.dta ***
****************

use "afd1.dta", clear

mean gender if vote ==7
mean gender if membership ==8

mean age if vote ==7
mean age if membership ==8

tab party_meeting_2w if vote ==7
tab party_meeting_2w  if membership ==8

tab campaigning_2w if vote ==7
tab campaigning_2w  if membership ==8

mean free_trade_2w if membership ==8
mean free_trade_2w if vote ==7


*** Results for Table 1, FB Sample: AfD Members and AfD Supporters
mean referenda_2w if membership ==8
mean referenda_2w if vote ==7

mean gender_quotas_2w if membership ==8
mean gender_quotas_2w if vote ==7

mean gender_ms_2w if membership ==8
mean gender_ms_2w if vote ==7

mean minimum_wage_2w if membership ==8
mean minimum_wage_2w if vote ==7

mean like_usa_2w if membership ==8
mean like_usa_2w if vote ==7


****************
*** afd2.dta ***
****************

use "afd2.dta", clear

*** Results for Table 1, FB Sample: AfD Members and AfD Supporters
mean luckepetry_imp if member ==1
mean luckepetry_imp if vote_afd_alfa ==1


***************
*** spd.dta ***
***************

use "spd.dta", clear


mean  z1age if  sample ==1
estimates store s1
mean  z1age if  sample ==0
estimates store s2
mean  z1age if  sample ==0 [aw=weight]
estimates store s3

mean  z1public_office if  sample ==1
estimates store s4
mean  z1public_office if  sample ==0
estimates store s5
mean  z1public_office if  sample ==0 [aw=weight]
estimates store s6

mean  z1university if  sample ==1
estimates store s7
mean  z1university if  sample ==0
estimates store s8
mean  z1university if  sample ==0 [aw=weight]
estimates store s9

mean  z1gender if  sample ==1
estimates store s10
mean  z1gender if  sample ==0
estimates store s11
mean  z1gender if  sample ==0 [aw=weight]
estimates store s12

mean  z1leftright_self if  sample ==1
estimates store s13
mean  z1leftright_self if  sample ==0
estimates store s14
mean  z1leftright_self if  sample ==0 [aw=weight]
estimates store s15

mean  z1leftright_spd if  sample ==1
estimates store s16
mean  z1leftright_spd if  sample ==0
estimates store s17
mean  z1leftright_spd if  sample ==0 [aw=weight]
estimates store s18

mean  z1econ_freedom_index if  sample ==1
estimates store s19
mean  z1econ_freedom_index if  sample ==0
estimates store s20
mean  z1econ_freedom_index if  sample ==0 [aw=weight]
estimates store s21

mean  z1efi_factor if  sample ==1
estimates store s22
mean  z1efi_factor if  sample ==0
estimates store s23
mean  z1efi_factor if  sample ==0 [aw=weight]
estimates store s24

mean  z1cosmopolitan_index if  sample ==1
estimates store s25
mean  z1cosmopolitan_index if  sample ==0
estimates store s26
mean  z1cosmopolitan_index if  sample ==0 [aw=weight]
estimates store s27

mean  z1leftlibertarian_index if  sample ==1
estimates store s28
mean  z1leftlibertarian_index if  sample ==0
estimates store s29
mean  z1leftlibertarian_index if  sample ==0 [aw=weight]
estimates store s30

*** Figure 1 (unedited display)

coefplot s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23 s24 s25 s26 s27 s28 s29 s30, xline(0) nokey

*** Graph editing code
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.plotregion.yscale.curmin = 0.3
gr_edit .yaxis1.plotregion.yscale.curmax = 10.7
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 1 1 `"Age"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 2 2 `"Seeking Public Office"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 3 3 `"University Degree"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 4 4 `"Female"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 5 5 `"Left-Right Self-Placement"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 6 6 `"Left-Right SPD Placement"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 7 7 `"Economic Freedom Index"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 8 8 `"EFI - Factor-based Items"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 9 9 `"Cosmopolitan Index"', tickset(major)
gr_edit .yaxis1.major.num_rule_ticks = 0
gr_edit .yaxis1.edit_tick 10 10 `"Left-Libertarian Index"', tickset(major)
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot3.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot5.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot5.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot6.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot6.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot7.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot8.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot8.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot9.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot10.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot10.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot10.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot11.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot11.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot12.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot12.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot13.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot14.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot14.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot15.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot16.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot16.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot16.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot17.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot17.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot18.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot18.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot19.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot20.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot20.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot21.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot22.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot22.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot22.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot23.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot23.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot24.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot24.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot25.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot26.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot26.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot27.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot28.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot28.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot28.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot29.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot29.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot30.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot30.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot31.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot32.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot32.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot33.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot34.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot34.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot34.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot35.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot35.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot36.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot36.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot37.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot38.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot38.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot39.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot40.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot40.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot40.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot41.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot41.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot42.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot42.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot43.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot44.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot44.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot45.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot46.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot46.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot46.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot47.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot47.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot48.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot48.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot49.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot50.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot50.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot51.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot52.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot52.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot52.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot53.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot53.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot54.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot54.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot55.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot56.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot56.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot57.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot58.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plot58.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plot58.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plot59.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot59.style.editstyle area(linestyle(pattern(shortdash))) editcopy
gr_edit .plotregion1.plot60.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plot60.style.editstyle marker(linestyle(color(black))) editcopy


********************
*** thailand.dta ***
********************

use "thailand.dta", clear


*** Inter-Group Comparison
mean  z1age if ptp_vote ==1 & sample ==0
estimates store s1_red
mean  z1age if dem_vote ==1 & sample ==0
estimates store s1_dem
mean  z1age if pad_support ==1 & sample ==0
estimates store s1_pad
mean  z1age if ptp_vote ==1 & sample ==1
estimates store s1_red2
mean  z1age if dem_vote ==1 & sample ==1
estimates store s1_dem2
mean  z1age if pad_support ==1 & sample ==1
estimates store s1_pad2

mean  z1university if ptp_vote ==1 & sample ==0
estimates store s2_red
mean  z1university if dem_vote ==1 & sample ==0
estimates store s2_dem
mean  z1university if pad_support ==1 & sample ==0
estimates store s2_pad
mean  z1university if ptp_vote ==1 & sample ==1
estimates store s2_red2
mean  z1university if dem_vote ==1 & sample ==1
estimates store s2_dem2
mean  z1university if pad_support ==1 & sample ==1
estimates store s2_pad2

mean  z1gender if ptp_vote ==1 & sample ==0
estimates store s3_red
mean  z1gender if dem_vote ==1 & sample ==0
estimates store s3_dem
mean  z1gender if pad_support ==1 & sample ==0
estimates store s3_pad
mean  z1gender if ptp_vote ==1 & sample ==1
estimates store s3_red2
mean  z1gender if dem_vote ==1 & sample ==1
estimates store s3_dem2
mean  z1gender if pad_support ==1 & sample ==1
estimates store s3_pad2

mean  z1retract_border_claims if ptp_vote ==1 & sample ==0
estimates store s4_red
mean  z1retract_border_claims if dem_vote ==1 & sample ==0
estimates store s4_dem
mean  z1retract_border_claims if pad_support ==1 & sample ==0
estimates store s4_pad
mean  z1retract_border_claims if ptp_vote ==1 & sample ==1
estimates store s4_red2
mean  z1retract_border_claims if dem_vote ==1 & sample ==1
estimates store s4_dem2
mean  z1retract_border_claims if pad_support ==1 & sample ==1
estimates store s4_pad2

mean  z1econ_freedom_index if ptp_vote ==1 & sample ==0
estimates store s5_red
mean  z1econ_freedom_index if dem_vote ==1 & sample ==0
estimates store s5_dem
mean  z1econ_freedom_index if pad_support ==1 & sample ==0
estimates store s5_pad
mean  z1econ_freedom_index if ptp_vote ==1 & sample ==1
estimates store s5_red2
mean  z1econ_freedom_index if dem_vote ==1 & sample ==1
estimates store s5_dem2
mean  z1econ_freedom_index if pad_support ==1 & sample ==1
estimates store s5_pad2

mean  z1taxcuts_over_redistr if ptp_vote ==1 & sample ==0
estimates store s6_red
mean  z1taxcuts_over_redistr if dem_vote ==1 & sample ==0
estimates store s6_dem
mean  z1taxcuts_over_redistr if pad_support ==1 & sample ==0
estimates store s6_pad
mean  z1taxcuts_over_redistr if ptp_vote ==1 & sample ==1
estimates store s6_red2
mean  z1taxcuts_over_redistr if dem_vote ==1 & sample ==1
estimates store s6_dem2
mean  z1taxcuts_over_redistr if pad_support ==1 & sample ==1
estimates store s6_pad2

mean  z1prefer_econ_dev if ptp_vote ==1 & sample ==0
estimates store s7_red
mean  z1prefer_econ_dev if dem_vote ==1 & sample ==0
estimates store s7_dem
mean  z1prefer_econ_dev if pad_support ==1 & sample ==0
estimates store s7_pad
mean  z1prefer_econ_dev if ptp_vote ==1 & sample ==1
estimates store s7_red2
mean  z1prefer_econ_dev if dem_vote ==1 & sample ==1
estimates store s7_dem2
mean  z1prefer_econ_dev if pad_support ==1 & sample ==1
estimates store s7_pad2

mean  z1electoral_dem_index if ptp_vote ==1 & sample ==0
estimates store s8_red
mean  z1electoral_dem_index if dem_vote ==1 & sample ==0
estimates store s8_dem
mean  z1electoral_dem_index if pad_support ==1 & sample ==0
estimates store s8_pad
mean  z1electoral_dem_index if ptp_vote ==1 & sample ==1
estimates store s8_red2
mean  z1electoral_dem_index if dem_vote ==1 & sample ==1
estimates store s8_dem2
mean  z1electoral_dem_index if pad_support ==1 & sample ==1
estimates store s8_pad2

mean  z1checksbalances_index if ptp_vote ==1 & sample ==1
estimates store s9_red2
mean  z1checksbalances_index if dem_vote ==1 & sample ==1
estimates store s9_dem2
mean  z1checksbalances_index if pad_support ==1 & sample ==1
estimates store s9_pad2

mean  z1imp_econ_growth if ptp_vote ==1 & sample ==1
estimates store s10_red2
mean  z1imp_econ_growth if dem_vote ==1 & sample ==1
estimates store s10_dem2
mean  z1imp_econ_growth if pad_support ==1 & sample ==1
estimates store s10_pad2

mean  z1imp_econ_inequality if ptp_vote ==1 & sample ==1
estimates store s11_red2
mean  z1imp_econ_inequality if dem_vote ==1 & sample ==1
estimates store s11_dem2
mean  z1imp_econ_inequality if pad_support ==1 & sample ==1
estimates store s11_pad2

mean  z1imp_corruption if ptp_vote ==1 & sample ==1
estimates store s12_red2
mean  z1imp_corruption if dem_vote ==1 & sample ==1
estimates store s12_dem2
mean  z1imp_corruption if pad_support ==1 & sample ==1
estimates store s12_pad2

mean  z1imp_rulelaw if ptp_vote ==1 & sample ==1
estimates store s13_red2
mean  z1imp_rulelaw if dem_vote ==1 & sample ==1
estimates store s13_dem2
mean  z1imp_rulelaw if pad_support ==1 & sample ==1
estimates store s13_pad2

mean  z1imp_monarchy if ptp_vote ==1 & sample ==1
estimates store s14_red2
mean  z1imp_monarchy if dem_vote ==1 & sample ==1
estimates store s14_dem2
mean  z1imp_monarchy if pad_support ==1 & sample ==1
estimates store s14_pad2

mean  imp_cambodia_conflict if ptp_vote ==1 & sample ==1
mean  imp_cambodia_conflict if dem_vote ==1 & sample ==1
mean  imp_cambodia_conflict if pad_support ==1 & sample ==1

tab military_coup if ptp_vote ==1 & sample ==1
tab military_coup if dem_vote ==1 & sample ==1
tab military_coup if pad_support ==1 & sample ==1

*** Figure 2 (unedited display)

coefplot s1_red s1_dem s1_pad  s2_red s2_dem s2_pad  s3_red s3_dem s3_pad  s4_red s4_dem s4_pad  s5_red s5_dem s5_pad  s6_red s6_dem s6_pad  s7_red s7_dem s7_pad  s8_red s8_dem s8_pad || s1_red2 s1_dem2 s1_pad2  s2_red2 s2_dem2 s2_pad2  s3_red2 s3_dem2 s3_pad2  s4_red2 s4_dem2 s4_pad2  s5_red2 s5_dem2 s5_pad2  s6_red2 s6_dem2 s6_pad2  s7_red2 s7_dem2 s7_pad2  s8_red2 s8_dem2 s8_pad2 s9_red2 s9_dem2 s9_pad2  s10_red2 s10_dem2 s10_pad2  s11_red2 s11_dem2 s11_pad2  s12_red2 s12_dem2 s12_pad2  s13_red2 s13_dem2 s13_pad2  s14_red2 s14_dem2 s14_pad2, xline(0) nokey

*** Graph editing code
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.subtitle[1].style.editstyle fillcolor(gs15) editcopy
gr_edit .plotregion1.subtitle[1].style.editstyle linestyle(color(gs15)) editcopy
gr_edit .plotregion1.subtitle[1].text = {}
gr_edit .plotregion1.subtitle[1].text.Arrpush 2011
gr_edit .plotregion1.subtitle[2].text = {}
gr_edit .plotregion1.subtitle[2].text.Arrpush 2012
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 1 1 `"Age"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 2 2 `"University Degree"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 3 3 `"Female"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 4 4 `"Retract Border Claims"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 5 5 `"Economic Freedom Index"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 6 6 `"Tax Cuts over Redistribution"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 7 7 `"Prefer Econ. Development"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 8 8 `"Electoral Democracy Index"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 9 9 `"Checks-and-Balances Index"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 10 10 `"Salient: Econ. Growth"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 11 11 `"Salient: Econ. Inequality"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 12 12 `"Salient: Corruption"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 13 13 `"Salient: Rule of Law"', tickset(major)
gr_edit .plotregion1.yaxis1[1].major.num_rule_ticks = 0
gr_edit .plotregion1.yaxis1[1].edit_tick 14 14 `"Salient: Defend Monarchy"', tickset(major)
gr_edit .plotregion1.yaxis1[1].plotregion.yscale.curmin = 0.3
gr_edit .plotregion1.yaxis1[1].plotregion.yscale.curmax = 14.7
gr_edit .plotregion1.yaxis1[2].plotregion.yscale.curmin = 0.3
gr_edit .plotregion1.yaxis1[2].plotregion.yscale.curmax = 14.7
gr_edit .plotregion1.plotregion1[1].plot1.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot2.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot2.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot2.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot3.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot4.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot4.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot5.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot6.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot6.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot7.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot8.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot8.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot8.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot9.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot10.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot10.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot11.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot12.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot12.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot13.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot14.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot14.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot14.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot15.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot16.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot16.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot17.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot18.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot18.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot19.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot20.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot20.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot20.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot21.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot22.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot22.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot23.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot24.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot24.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot25.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot26.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot26.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot26.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot27.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot28.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot28.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot29.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot30.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot30.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot31.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot32.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot32.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot32.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot33.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot34.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot34.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot35.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot36.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot36.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot37.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot38.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot38.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot38.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot39.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot40.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot40.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot41.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot42.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot42.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot43.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot44.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot44.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot44.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot45.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot46.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot46.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot47.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot48.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot48.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot49.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot50.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot50.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot50.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot51.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot52.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot52.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot53.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot54.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot54.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot55.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot56.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot56.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot56.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot57.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot58.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot58.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot59.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot60.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot60.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot61.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot62.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot62.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot62.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot63.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot64.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot64.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot65.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot66.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot66.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot67.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot68.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot68.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot68.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot69.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot70.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot70.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot71.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot72.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot72.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot73.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot74.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot74.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot74.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot75.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot76.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot76.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot77.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot78.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot78.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot79.style.editstyle area(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot80.style.editstyle marker(symbol(triangle)) editcopy
gr_edit .plotregion1.plotregion1[1].plot80.style.editstyle marker(fillcolor(gs10)) editcopy
gr_edit .plotregion1.plotregion1[1].plot80.style.editstyle marker(linestyle(color(gs10))) editcopy
gr_edit .plotregion1.plotregion1[1].plot81.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot82.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plotregion1[1].plot82.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot83.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plotregion1[1].plot84.style.editstyle marker(fillcolor(white)) editcopy
gr_edit .plotregion1.plotregion1[1].plot84.style.editstyle marker(linestyle(color(black))) editcopy


*** Subsample Robustness Test

mean  taxcuts_over_redistr if ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if gender ==1 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if gender ==1 & ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if gender ==0 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if gender ==0 & ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if university ==0 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if university ==0 & ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if university ==1 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if university ==1 & ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if age > 17 & age < 30 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if age > 17 & age < 30 & ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if age > 29 & age < 50 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if age > 29 & age < 50 & ptp_vote ==1 & sample ==1

mean  taxcuts_over_redistr if age > 49 & age < 93 & ptp_vote ==1 & sample ==0
mean  taxcuts_over_redistr if age > 49 & age < 93 & ptp_vote ==1 & sample ==1

*** Figure 3 (unedited display)

**********************************
*** ptp subsamples figure3.dta ***
**********************************

use "ptp subsamples figure3.dta", clear

serrbar mean se  subgroups, scale (1.96)

*** Graph editing code
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(black))) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(black))) editcopy
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush `"Mean score"'
gr_edit .yaxis1.title.text.Arrpush `"More money for the poor (1) vs. tax cuts (5)"'
gr_edit .xaxis1.title.draw_view.setstyle, style(no)
gr_edit .xaxis1.major.num_rule_ticks = 5
gr_edit .xaxis1.edit_tick 1 0 `"0"', custom tickset(major) editstyle(tickstyle(show_labels(no)) tickstyle(show_ticks(no)) )
gr_edit .xaxis1.major.num_rule_ticks = 4
gr_edit .xaxis1.edit_tick 2 4 `"4"', custom tickset(major) editstyle(tickstyle(show_labels(no)) tickstyle(show_ticks(no)) )
gr_edit .xaxis1.major.num_rule_ticks = 3
gr_edit .xaxis1.edit_tick 1 2 `"2"', custom tickset(major) editstyle(tickstyle(show_labels(no)) tickstyle(show_ticks(no)) )
gr_edit .xaxis1.major.num_rule_ticks = 2
gr_edit .xaxis1.edit_tick 1 6 `"6"', custom tickset(major) editstyle(tickstyle(show_labels(no)) tickstyle(show_ticks(no)) )
gr_edit .xaxis1.major.num_rule_ticks = 1
gr_edit .xaxis1.edit_tick 1 8 `"8"', custom tickset(major) editstyle(tickstyle(show_labels(no)) tickstyle(show_ticks(no)) )
gr_edit .xaxis1.add_ticks 0.5 `"All"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 1.5 `"Female"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 2.5 `"Male"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 3.5 `"No degree"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 4.5 `"Uni degree"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 5.5 `"Age 18-29"', custom tickset(major)editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 6.5 `"Age 30-49"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
gr_edit .xaxis1.add_ticks 7.5 `"Age 50+"', custom tickset(major) editstyle(tickstyle(textstyle(size(vsmall))) )
//
