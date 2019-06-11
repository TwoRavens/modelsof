global cluster = ""

use DatDKR, clear

global i = 1
global j = 1
*Table 4
forvalues k = 1/3 {
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_lr04) areg anyfert_plus`k'_05 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
forvalues k = 1/3 {
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05, absorb(school)
	mycmd (safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg anyfert_plus`k'_05 safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo demo house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 thatch_roof_04 mud_floor_04 std5parent, absorb(school)
	}
*Table 7
foreach X in remind_bought_ftd remind_plan_ftd remind_planorbuy_ftd {
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 sbsk1 sbsk1_demo, absorb(school)
	mycmd (reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04) areg `X' reminder safi_sr04 choice subsidy fullprice buy buy_safi_sr04 safi_lr04 house_ever_anyfert_05 gender_05 mud_walls_04 educ_04 incomeK_04 sbsk1 sbsk1_demo, absorb(school)
	}

