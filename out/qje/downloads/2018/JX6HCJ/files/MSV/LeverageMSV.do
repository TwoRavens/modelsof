global N = 164
matrix Q = J($N,10,.)
matrix QQ = J($N,10,.)
matrix QQQ = J($N,10,.)
matrix YN = J($N,1,.)

global cluster = "unique_05"

global i = 1
global j = 1

use DatMSV1, clear

mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"
mac def C2006_vars1zm  "z_tvip_06m z_language_06m z_memory_06m z_social_06m z_behavior_06m"
mac def C2006_vars2zm  "z_grmotor_06m z_finmotor_06m z_legmotor_06m z_height_06m z_weight_06m"
mac def C2008_vars1zm  "z_tvip_08m z_language_08m z_memory_08m z_martians_08m  z_social_08m z_behavior_08m"
mac def C2008_vars2zm  "z_grmotor_08m z_finmotor_08m z_legmotor_08m z_height_08m z_weight_08m"
mac def Cvars_06zm "$C2006_vars1zm $C2006_vars2zm"
mac def Cvars_08zm "$C2008_vars1zm $C2008_vars2zm"

mac def controls6 "CEDAD* male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6h "s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05  MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip lnpce_05"

*Define shortened controls that eliminate drops
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6ha "s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip lnpce_05"

*Table 3 - 2006 and 2008 panels
foreach x in $Cvars_06z $Cvars_08z {
	mycmd (T) areg `x' T male, robust cluster(unique_05)  absorb(age_transfer1)
	mycmd (T) areg `x' T $controls6a, robust cluster(unique_05) absorb(age_transfer1)
	}

matrix S = J(3,10,0)
matrix S[1,1] = J(1,10,1/10)
matrix S[2,1] = J(1,5,1/5)
matrix S[3,6] = J(1,5,1/5)

matrix SS = J(6,10,0)
matrix SS[1,1] = J(1,10,1/10)
matrix SS[2,1] = J(1,5,1/5)
matrix SS[3,6] = J(1,5,1/5)
matrix SS[4,1] = (1/5,0,1/5,0,0,0,0,1/5,1/5,1/5)
matrix SS[5,1] = (1/2,0,1/2)
matrix SS[6,8] = (1/3,1/3,1/3)

*Table 4 
*Row 1  
foreach x of global Cvars_06z {
	mycmd (T) suest `x' T male , absorb(age_transfer1)
	}
global i = $i - 10
global j = $j - 10
matrix QQ[$i,1] = S*QQ[$i..$i+9,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+9,1...]
global i = $i + 3
global j = $j + 3

*Rows 2 & 3
foreach x of global Cvars_06z {
	mycmd (T) suest `x' T $controls6a , absorb(age_transfer1)
	}
global i = $i - 10
global j = $j - 10
matrix QQ[$i,1] = SS*QQ[$i..$i+9,1...]
matrix QQQ[$i,1] = SS*QQQ[$i..$i+9,1...]
global i = $i + 6
global j = $j + 6

*Row 4 
foreach x of global Cvars_06zm {
	mycmd (T) suest `x' T $controls6a , absorb(age_transfer1)
	}
global i = $i - 10
global j = $j - 10
matrix QQ[$i,1] = S*QQ[$i..$i+9,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+9,1...]
global i = $i + 3
global j = $j + 3

*Row 5 
foreach x of global Cvars_06z {
	mycmd (T) suest `x' T $controls6a if  titmom_06 == 1 & mominhouse_06 == 1, absorb(age_transfer1)
	}

global i = $i - 10
global j = $j - 10
matrix QQ[$i,1] = S*QQ[$i..$i+9,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+9,1...]
global i = $i + 3
global j = $j + 3

matrix S = J(3,11,0)
matrix S[1,1] = J(1,11,1/11)
matrix S[2,1] = J(1,6,1/6)
matrix S[3,7] = J(1,5,1/5)

matrix SS = J(6,11,0)
matrix SS[1,1] = J(1,11,1/11)
matrix SS[2,1] = J(1,6,1/6)
matrix SS[3,7] = J(1,5,1/5)
matrix SS[4,1] = (1/6,0,1/6,1/6,0,0,0,0,1/6,1/6,1/6)
matrix SS[5,1] = (1/3,0,1/3,1/3)
matrix SS[6,9] = (1/3,1/3,1/3)

*Row 6 
foreach x of global Cvars_08z {
	mycmd (T) suest `x' T male , absorb(age_transfer1)
	}
global i = $i - 11
global j = $j - 11
matrix QQ[$i,1] = S*QQ[$i..$i+10,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+10,1...]
global i = $i + 3
global j = $j + 3

*Rows 7 & 8
foreach x of global Cvars_08z {
	mycmd (T) suest `x' T $controls6a , absorb(age_transfer1)
	}
global i = $i - 11
global j = $j - 11
matrix QQ[$i,1] = SS*QQ[$i..$i+10,1...]
matrix QQQ[$i,1] = SS*QQQ[$i..$i+10,1...]
global i = $i + 6
global j = $j + 6

*Row 9 
foreach x of global Cvars_08zm {
	mycmd (T) suest `x' T $controls6a , absorb(age_transfer1)
	}
global i = $i - 11
global j = $j - 11
matrix QQ[$i,1] = S*QQ[$i..$i+10,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+10,1...]
global i = $i + 3
global j = $j + 3

*Row 10 
foreach x of global Cvars_08z {
	mycmd (T) suest `x' T $controls6a if titmom_08 == 1 & mominhouse_08 == 1, absorb(age_transfer1)
	}
global i = $i - 11
global j = $j - 11
matrix QQ[$i,1] = S*QQ[$i..$i+10,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+10,1...]
global i = $i + 3
global j = $j + 3

*Table 5 
mycmd (T) regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

********************************

*Part 2: Table 8

use DatMSV2, clear
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

*These lines missing from do file for this table, can't execute without them
mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"

matrix S = J(3,10,0)
matrix S[1,1] = J(1,10,1/10)
matrix S[2,1] = J(1,5,1/5)
matrix S[3,6] = J(1,5,1/5)

*Table 6

*Row 1
foreach x of global Cvars_06z {
 	mycmd (T) suest `x' T male, absorb(age_transfer1)
	}
global i = $i - 10
global j = $j - 10
matrix QQ[$i,1] = S*QQ[$i..$i+9,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+9,1...]
global i = $i + 3
global j = $j + 3

*Row 2
foreach x of global Cvars_06z {
	mycmd (T) suest `x' T $controls6a, absorb(age_transfer1)  
	}
global i = $i - 10
global j = $j - 10
matrix QQ[$i,1] = S*QQ[$i..$i+9,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+9,1...]
global i = $i + 3
global j = $j + 3

matrix S = J(3,11,0)
matrix S[1,1] = J(1,11,1/11)
matrix S[2,1] = J(1,6,1/6)
matrix S[3,7] = J(1,5,1/5)

*Row 3
foreach x of global Cvars_08z {
	mycmd (T) suest `x' T male, absorb(age_transfer1)
	}
global i = $i - 11
global j = $j - 11
matrix QQ[$i,1] = S*QQ[$i..$i+10,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+10,1...]
global i = $i + 3
global j = $j + 3

*Row 4
foreach x of global Cvars_08z {
	mycmd (T) suest `x' T $controls6a, absorb(age_transfer1)  
	}
global i = $i - 11
global j = $j - 11
matrix QQ[$i,1] = S*QQ[$i..$i+10,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+10,1...]
global i = $i + 3
global j = $j + 3

********************************

*Part 3: Table 8

use DatMSV3, clear

mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss tvip_05_miss tvip_05_inter height_05_miss height_05_inter weight_05_miss weight_05_inter bweight_miss bweight_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

mac def C2008_vars1fz  "z_propfood_08  z_prstap_f_08  z_pranimalprot_f_08 z_prfruitveg_f_08"
mac def C2008_vars2sz  "z_a3lapiz_08 z_a3stories_08  z_nrhourread_08 z_e1bp3_toy"
mac def C2008_vars3hz  "z_weighted_08 z_vitamiron_08 z_s4p7_parasite_i_08 z_s4p39_daysbed_i_08"
mac def C2008_vars4ez  "z_a13cesd_08 z_e5home_08  "
mac def Cvars_08z "$C2008_vars1fz $C2008_vars2sz $C2008_vars3hz $C2008_vars4ez"
mac def C2006_vars1fz  "z_propfood_06 z_prstap_f_06  z_pranimalprot_f_06 z_prfruitveg_f_06"
mac def C2006_vars2sz  "z_a3lapiz_06 z_a3stories_06  z_nrhourread_06 z_a3toy6M"
mac def C2006_vars3hz  "z_weighted_06 z_vitamiron_06 z_s4p7_parasite_i_06 z_s4p39_06"
mac def C2006_vars4ez  "z_a13cesd_06 z_a14home_06 "
mac def Cvars_06z "$C2006_vars1fz $C2006_vars2sz $C2006_vars3hz $C2006_vars4ez"


matrix S = J(19,14,0)
matrix S[1,1] = I(14)
matrix S[15,1] = (J(1,12,1/16), J(1,2,1/8))
matrix S[16,1] = (1/4,1/4,1/4,1/4)
matrix S[17,5] = (1/4,1/4,1/4,1/4)
matrix S[18,9] = (1/4,1/4,1/4,1/4)
matrix S[19,13] = (1/2,1/2)

*Table 8

*2008 - column 1 
foreach x of global Cvars_08z {
 	mycmd (T) suest `x' T $controls6a if sample08==1, absorb(age_transfer1)
	}
global i = $i - 14
global j = $j - 14
matrix QQ[$i,1] = S*QQ[$i..$i+13,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+13,1...]
global i = $i + 19
global j = $j + 19

*2008 - column 2 
foreach x of global Cvars_08z {
	mycmd (T) suest `x' T $controls6a ln_pce08 ln_pce08sq if sample08==1, absorb(age_transfer1)
	}
global i = $i - 14
global j = $j - 14
matrix QQ[$i,1] = S*QQ[$i..$i+13,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+13,1...]
global i = $i + 19
global j = $j + 19

*2006 - column 1 
foreach x of global Cvars_06z {
  	mycmd (T) suest `x' T $controls6a if sample06==1, absorb(age_transfer1)
	}
global i = $i - 14
global j = $j - 14
matrix QQ[$i,1] = S*QQ[$i..$i+13,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+13,1...]
global i = $i + 19
global j = $j + 19

*2006 - column 2 
foreach x of global Cvars_06z {
  	mycmd (T) suest `x' T $controls6a ln_pce06 ln_pce06sq if sample06==1, absorb(age_transfer1)
	}
global i = $i - 14
global j = $j - 14
matrix QQ[$i,1] = S*QQ[$i..$i+13,1...]
matrix QQQ[$i,1] = S*QQQ[$i..$i+13,1...]
global i = $i + 19
global j = $j + 19

