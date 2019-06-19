*** Generating the tables
clear all
cd "DOD_HRB_files_directory" 

* Tables are created using dod_hrb_data. 
use dod_hrb_data, clear
keep if male==1

outsum domestic_abuse hit_spouse hit_children p_thrtnd_to_leave high_stress_rlsnshp heated_ff_argument ina_rlsnship combat_fire  death_enemy wounding ally_hurt ptsdstat psychill suicide bingedrk drgea30 army marine navy af  paygroup_1 paygroup_2 paygroup_3 paygroup_4 paygroup_5 paygroup_6  agec rwhite rblack  rother hispanicS educ_somecollege educ_college 			 using T1, replace	title(Table 1. Mean Risk Behaivor by Deployment Status) ctitle(All)

global controls  "army marine navy af region paygroup_2 paygroup_3 paygroup_4 paygroup_5 paygroup_6 army_command_2 army_command_3 army_command_4 army_command_5 navy_command_1 navy_command_2 navy_command_3 navy_command_4   marine_command_1 marine_command_2 af_command_1 af_command_2 af_command_3 af_command_4 af_command_5 af_command_6 af_command_7 num_combat  educ_highschool educ_somecollege educ_college agec age_square rblack rother hispanicS"

*Table 4
reg domestic_abuse		combat_fire $controls ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T4A: DOD Full Sample)  replace 
reg hit_spouse			combat_fire $controls ,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls ,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls ,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls ,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append

reg domestic_abuse		combat_fire $controls  if army==1,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4B, adds("Dependent Variable Mean", depvarmean) keep(combat_fire)word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T4B: DOD, Army)  replace 
reg hit_spouse			combat_fire $controls  if army==1,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4B, adds("Dependent Variable Mean", depvarmean) keep(combat_fire)word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if army==1,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4B, adds("Dependent Variable Mean", depvarmean) keep(combat_fire)word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if army==1,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4B, adds("Dependent Variable Mean", depvarmean) keep(combat_fire)word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if army==1,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4B, adds("Dependent Variable Mean", depvarmean) keep(combat_fire)word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if army==1,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4B, adds("Dependent Variable Mean", depvarmean) keep(combat_fire)word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append


reg domestic_abuse		combat_fire $controls  if marine==1,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T4C: DOD,Marines)  replace 
reg hit_spouse			combat_fire $controls  if marine==1,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if marine==1,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if marine==1,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if marine==1,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if marine==1,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append


reg domestic_abuse		combat_fire $controls  if navy==1,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4D,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T4D: DOD, Navy)  replace 
reg hit_spouse			combat_fire $controls  if navy==1,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4D,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if navy==1,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4D,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if navy==1,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4D,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if navy==1,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4D,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if navy==1,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4D,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append



reg domestic_abuse		combat_fire $controls  if af==1,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4E,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T4E: DOD Full Sample, Air Force)  replace 
reg hit_spouse			combat_fire $controls  if af==1,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4E,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if af==1,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4E,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if af==1,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4E,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if af==1,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4E,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if af==1,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4E,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append


reg domestic_abuse		combat_fire $controls  if ina_rlsnship==1,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4F,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T4F: DOD In a Relationship Sample)  replace 
reg hit_spouse			combat_fire $controls  if ina_rlsnship==1,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4F,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if ina_rlsnship==1,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4F,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if ina_rlsnship==1,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4F,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if ina_rlsnship==1,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4F,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if ina_rlsnship==1,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T4F,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append




****Table 5
reg domestic_abuse		death_enemy $controls ,   cluster(stratum) 
outreg2    		death_enemy				using T5Brow1,keep(death_enemy) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T5B row2: DOD killed)  replace 
reg hit_spouse			death_enemy $controls ,   cluster(stratum) 
outreg2    		death_enemy				using T5Brow1,keep(death_enemy) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		death_enemy $controls ,   cluster(stratum) 
outreg2    		death_enemy				using T5Brow1,keep(death_enemy) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	death_enemy $controls ,   cluster(stratum) 
outreg2    		death_enemy				using T5Brow1,keep(death_enemy) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	death_enemy $controls ,   cluster(stratum) 
outreg2    		death_enemy				using T5Brow1,keep(death_enemy) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	death_enemy $controls ,   cluster(stratum)
outreg2    		death_enemy				using T5Brow1,keep(death_enemy) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append


reg domestic_abuse		wounding $controls ,   cluster(stratum) 
outreg2    		wounding				using T5Brow2,keep(wounding) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T5B row2: DOD Wounded)  replace 
reg hit_spouse			wounding $controls ,   cluster(stratum) 
outreg2    		wounding				using T5Brow2,keep(wounding) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		wounding $controls ,   cluster(stratum)
outreg2    		wounding				using T5Brow2,keep(wounding) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	wounding $controls ,   cluster(stratum) 
outreg2    		wounding				using T5Brow2,keep(wounding) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	wounding $controls ,   cluster(stratum) 
outreg2    		wounding				using T5Brow2,keep(wounding) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	wounding $controls ,   cluster(stratum)
outreg2    		wounding				using T5Brow2,keep(wounding) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append



reg domestic_abuse		ally_hurt $controls ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		ally_hurt				using T5Brow3,keep(ally_hurt) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T5B row3: DOD Ally Hurt/Killer)  replace 
reg hit_spouse			ally_hurt $controls ,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		ally_hurt				using T5Brow3,keep(ally_hurt) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		ally_hurt $controls ,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		ally_hurt				using T5Brow3,keep(ally_hurt) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	ally_hurt $controls ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		ally_hurt				using T5Brow3,keep(ally_hurt) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	ally_hurt $controls ,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		ally_hurt				using T5Brow3,keep(ally_hurt) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	ally_hurt $controls ,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		ally_hurt				using T5Brow3,keep(ally_hurt) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append

*Table 6

reg domestic_abuse		combat_fire $controls  if enlisted==1,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T6A: DOD Enlisted Sample)  replace 
reg hit_spouse			combat_fire $controls  if enlisted==1,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if enlisted==1,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if enlisted==1,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if enlisted==1,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if enlisted==1,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6A,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append


reg domestic_abuse		combat_fire $controls  if enlisted==0,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T6B: DOD Officer Sample)  replace 
reg hit_spouse			combat_fire $controls  if enlisted==0,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if enlisted==0,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if enlisted==0,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if enlisted==0,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if enlisted==0,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append


*** Table 6C- female sample estimates
use dod_hrb_data, clear
keep if male==0


global controls  "army marine navy af region paygroup_2 paygroup_3 paygroup_4 paygroup_5 paygroup_6 army_command_2 army_command_3 army_command_4 army_command_5 navy_command_1 navy_command_2 navy_command_3 navy_command_4   marine_command_1 marine_command_2 af_command_1 af_command_2 af_command_3 af_command_4 af_command_5 af_command_6 af_command_7 num_combat  educ_highschool educ_somecollege educ_college agec age_square rblack rother hispanicS"

reg domestic_abuse		combat_fire $controls  if male==0,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T6C: DOD Female Sample)  replace 
reg hit_spouse			combat_fire $controls  if male==0 ,   cluster(stratum) 
sum hit_spouse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_spouse) append 
reg hit_children		combat_fire $controls  if male==0 ,   cluster(stratum) 
sum hit_children if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(hit_children) append
reg high_stress_rlsnshp	combat_fire $controls  if male==0 ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(high_stress_rlsnshp) append
reg heated_ff_argument	combat_fire $controls  if male==0 ,   cluster(stratum) 
sum heated_ff_argument if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(heated_ff_argument) append
reg p_thrtnd_to_leave	combat_fire $controls  if male==0 ,   cluster(stratum)
sum p_thrtnd_to_leave if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T6C,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(p_thrtnd_to_leave) append



use dod_hrb_data, clear
keep if male==1

global controls  "army marine navy af region paygroup_2 paygroup_3 paygroup_4 paygroup_5 paygroup_6 army_command_2 army_command_3 army_command_4 army_command_5 navy_command_1 navy_command_2 navy_command_3 navy_command_4   marine_command_1 marine_command_2 af_command_1 af_command_2 af_command_3 af_command_4 af_command_5 af_command_6 af_command_7 num_combat  educ_highschool educ_somecollege educ_college agec age_square rblack rother hispanicS"

*Table 7
reg ptsdstat	combat_fire 	$controls ,   cluster(stratum) 
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row1,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(ptsdstat) title(T7A_row1: DOD FS)  replace 
reg suicide		combat_fire		$controls ,   cluster(stratum) 
sum suicide if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row1,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(suicide) append 
reg psychill	combat_fire		$controls ,   cluster(stratum) 
sum psychill if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row1,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(psychill) append 
reg bingedrk	combat_fire		$controls ,   cluster(stratum) 
sum bingedrk if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row1,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(bingedrk) append 
reg drgea30		combat_fire		$controls ,   cluster(stratum) 
sum drgea30 if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row1,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(drgea30) append 



reg ptsdstat	combat_fire 	$controls if army==1,   cluster(stratum) 
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row2,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(ptsdstat) title(T7A_row2: DOD Army)  replace 
reg suicide		combat_fire		$controls if army==1 ,   cluster(stratum) 
sum suicide if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row2,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(suicide) append 
reg psychill	combat_fire		$controls if army==1 ,   cluster(stratum) 
sum psychill if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row2,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(psychill) append 
reg bingedrk	combat_fire		$controls if army==1 ,   cluster(stratum) 
sum bingedrk if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row2,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(bingedrk) append 
reg drgea30		combat_fire		$controls  if army==1,   cluster(stratum) 
sum drgea30 if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row2,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(drgea30) append 

reg ptsdstat	combat_fire 	$controls if marine==1,   cluster(stratum) 
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row3,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(ptsdstat) title(T7A_row3: DOD Marines)  replace 
reg suicide		combat_fire		$controls if marine==1 ,   cluster(stratum) 
sum suicide if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row3,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(suicide) append 
reg psychill	combat_fire		$controls if marine==1 ,   cluster(stratum) 
sum psychill if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row3,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(psychill) append 
reg bingedrk	combat_fire		$controls if marine==1 ,   cluster(stratum) 
sum bingedrk if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row3,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(bingedrk) append 
reg drgea30		combat_fire		$controls  if marine==1,   cluster(stratum) 
sum drgea30 if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row3,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(drgea30) append 


reg ptsdstat	combat_fire 	$controls if navy==1,   cluster(stratum) 
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row4,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(ptsdstat) title(T7A_row4: DOD Navy)  replace 
reg suicide		combat_fire		$controls if navy==1 ,   cluster(stratum) 
sum suicide if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row4,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(suicide) append 
reg psychill	combat_fire		$controls if navy==1 ,   cluster(stratum) 
sum psychill if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row4,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(psychill) append 
reg bingedrk	combat_fire		$controls if navy==1 ,   cluster(stratum) 
sum bingedrk if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row4,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(bingedrk) append 
reg drgea30		combat_fire		$controls  if navy==1,   cluster(stratum) 
sum drgea30 if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row4,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(drgea30) append 



reg ptsdstat	combat_fire 	$controls if af==1,   cluster(stratum) 
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row5,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(ptsdstat) title(T7A_row5: DOD Air Force)  replace 
reg suicide		combat_fire		$controls if af==1 ,   cluster(stratum) 
sum suicide if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row5,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(suicide) append 
reg psychill	combat_fire		$controls if af==1 ,   cluster(stratum) 
sum psychill if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row5,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(psychill) append 
reg bingedrk	combat_fire		$controls if af==1 ,   cluster(stratum) 
sum bingedrk if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row5,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(bingedrk) append 
reg drgea30		combat_fire		$controls  if af==1,   cluster(stratum) 
sum drgea30 if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire				using T7A_row5,keep(combat_fire) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(drgea30) append




*** Table 8
gen mis_bingedrk=0
replace mis_bingedrk=1 if bingedrk==.
replace bingedrk=0 if bingedrk==.

gen mis_drgea30=0
replace mis_drgea30=1 if drgea30==.
replace drgea30=0 if drgea30==.

gen mis_ptsdstat=0
replace mis_ptsdstat=1 if ptsdstat==.
replace ptsdstat=0 if ptsdstat==.

gen mis_suicide=0
replace mis_suicide=1 if suicide==.
replace suicide=0 if suicide==.

gen mis_psychill=0
replace mis_psychill=1 if psychill==.
replace psychill=0 if psychill==.


****

sum  ptsdstat mis_ptsdstat suicide mis_suicide psychill mis_psychill bingedrk mis_bingedrk drgea30 mis_drgea30 

reg domestic_abuse		combat_fire $controls ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8A,keep(combat_fire			ptsdstat suicide  psychill  bingedrk drgea30) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) title(T8A: DOD Full Sample Channels)  replace 
reg domestic_abuse		combat_fire  ptsdstat mis_ptsdstat suicide mis_suicide psychill mis_psychill  $controls ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8A,keep(combat_fire			ptsdstat suicide  psychill  bingedrk drgea30) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) append 
reg domestic_abuse		combat_fire  bingedrk mis_bingedrk drgea30 mis_drgea30 $controls ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8A,keep(combat_fire			ptsdstat suicide  psychill  bingedrk drgea30) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) append 
reg domestic_abuse		combat_fire  ptsdstat mis_ptsdstat suicide mis_suicide psychill mis_psychill bingedrk mis_bingedrk drgea30 mis_drgea30 $controls ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8A,keep(combat_fire			ptsdstat suicide  psychill  bingedrk drgea30) adds("Dependent Variable Mean", depvarmean) word excel label nocons  bdec(3) sdec(3) ctitle(Dmsct abuse) append 


reg high_stress_rlsnshp		combat_fire $controls ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Rlsnshp Strss) title(T8B: DOD Full Sample Channels)  replace 
reg high_stress_rlsnshp		combat_fire  ptsdstat mis_ptsdstat suicide mis_suicide psychill mis_psychill  $controls ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Rlsnshp Strss) append 
reg high_stress_rlsnshp		combat_fire  bingedrk mis_bingedrk drgea30 mis_drgea30 $controls ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Rlsnshp Strss) append 
reg high_stress_rlsnshp		combat_fire  ptsdstat mis_ptsdstat suicide mis_suicide psychill mis_psychill bingedrk mis_bingedrk drgea30 mis_drgea30 $controls ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T8B,keep(combat_fire) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3) ctitle(Rlsnshp Strss) append 


*Table 9
 
replace edq161=. if edq161<0
replace edq160=. if edq160<0

gen combat_deployed_12m=0 if edq160~=. 
replace  combat_deployed_12m=1 if edq160~=. & edq160>=2

gen non_combat_deployed_12m=0 if edq161~=. 
replace  non_combat_deployed_12m=1 if edq161~=. & edq161>=2

gen deploy12m=. 
replace deploy12m=1 if combat_deployed_12m==1
replace deploy12m=1 if non_combat_deployed_12m==1


gen combat_length12m=. 
replace combat_length12m=0 if edq160==1
replace combat_length12m=1 if edq160==2
replace combat_length12m=2 if edq160==3
replace combat_length12m=3.5 if edq160==4
replace combat_length12m=5.5 if edq160==5
replace combat_length12m=7.5 if edq160==6
replace combat_length12m=9.5 if edq160==7
replace combat_length12m=11.5 if edq160==8

gen		non_combat_length12m=. 
replace non_combat_length12m=0 		if edq161==1
replace non_combat_length12m=1 		if edq161==2
replace non_combat_length12m=2 		if edq161==3
replace non_combat_length12m=3.5 	if edq161==4
replace non_combat_length12m=5.5 	if edq161==5
replace non_combat_length12m=7.5 	if edq161==6
replace non_combat_length12m=9.5 	if edq161==7
replace non_combat_length12m=11.5	if edq161==8

gen deploymentlenght1m=combat_length12m+non_combat_length12m

global controls2  "army marine navy af region paygroup_2 paygroup_3 paygroup_4 paygroup_5 paygroup_6 army_command_2 army_command_3 army_command_4 army_command_5 navy_command_1 navy_command_2 navy_command_3 navy_command_4   marine_command_1 marine_command_2 af_command_1 af_command_2 af_command_3 af_command_4 af_command_5 af_command_6 af_command_7  educ_highschool educ_somecollege educ_college agec age_square race_black race_other"

label var combat_deployed_12m "Combat Service in the Past 12 Months"
label var deploymentlenght1m "Deployment Lenght in Months in the Past 12 Months"

gen cm_3to6_past12m=0 if  deploymentlenght1m~=. & deploy12m==1
replace cm_3to6_past12m=1 if  deploymentlenght1m~=. & deploy12m==1 & deploymentlenght1m>=3 & deploymentlenght1m<=6

gen cm_7up_past12m=0 if  deploymentlenght1m~=. & deploy12m==1
replace cm_7up_past12m=1 if  deploymentlenght1m~=. & deploy12m==1 & deploymentlenght1m>6 

 

****
****
****cm_3to6_past12m cm_7up_past12m
 
 
 label var combat_fire "Combat Exposure"
 label var num_combat3 "Number of Post-9/11 Deployments"
 label var cm_3to6_past12m "Deployed 3-6 Months in Last Year"
 label var cm_7up_past12m "Deployed 7+ Months in Last Year"
 

reg domestic_abuse		combat_fire $controls2 if num_combat~=. ,   cluster(stratum) 
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire	using T9A,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3)  title(T9A. Domestic Abuse)  replace 
reg domestic_abuse		num_combat3 $controls2 if num_combat~=. ,   cluster(stratum) 
outreg2    		combat_fire num_combat3	using T9A,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m) word excel label nocons  bdec(3) sdec(3)    append 
reg domestic_abuse	combat_fire	num_combat3 $controls2 if num_combat~=. ,   cluster(stratum) 
test combat_fire	num_combat3
	sca ftest=r(F)
	sca pval=r(p )
outreg2    		combat_fire num_combat3	using T9A,addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)    append 

reg domestic_abuse combat_fire  $controls2 if deploy12m==1 & num_combat~=. & cm_3to6_past12m~=. ,   cluster(stratum)
sum domestic_abuse if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9A,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3)   append 
reg domestic_abuse cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1 & num_combat~=.  ,   cluster(stratum)
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9A,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m) word excel label nocons  bdec(3) sdec(3)   append 
reg domestic_abuse combat_fire cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1  & num_combat~=. ,   cluster(stratum)
test combat_fire cm_3to6_past12m cm_7up_past12m
	sca ftest=r(F)
	sca pval=r(p )
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9A, addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 
reg domestic_abuse combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1 & num_combat~=.  ,   cluster(stratum)
test combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m
	sca ftest=r(F)
	sca pval=r(p )
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9A,addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 



reg ptsdstat		combat_fire $controls2 if num_combat~=. ,   cluster(stratum) 
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2 using T9B,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m) adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3)  title(T9B. PTSD)  replace 
reg ptsdstat		num_combat3 $controls2 if num_combat~=. ,   cluster(stratum) 
outreg2	using T9B,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m) word excel label nocons  bdec(3) sdec(3)    append 
reg ptsdstat	combat_fire	num_combat3 $controls2 if num_combat~=. ,   cluster(stratum) 
test combat_fire	num_combat3
	sca ftest=r(F)
	sca pval=r(p )
outreg2    		combat_fire num_combat3	using T9B,addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)    append 

reg ptsdstat combat_fire  $controls2 if deploy12m==1 & num_combat~=. & cm_3to6_past12m~=.  ,   cluster(stratum)
sum ptsdstat if e(sample)==1
	sca depvarmean=r(mean)
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9B,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m) adds("Dependent Variable Mean", depvarmean)   word excel label nocons  bdec(3) sdec(3)   append 
reg ptsdstat cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1 & num_combat~=.  ,   cluster(stratum)
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9B,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 
reg ptsdstat combat_fire cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1  & num_combat~=. ,   cluster(stratum)
test combat_fire cm_3to6_past12m cm_7up_past12m
	sca ftest=r(F)
	sca pval=r(p )
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9B, addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 
reg ptsdstat combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1  & num_combat~=. ,   cluster(stratum)
test combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m
	sca ftest=r(F)
	sca pval=r(p )
outreg2    		combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m	using T9B,addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 



reg high_stress_rlsnshp		combat_fire $controls2 if num_combat~=. ,   cluster(stratum) 
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2	using T9C,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3)  title(T9C. high_stress_rlsnshp)  replace 
reg high_stress_rlsnshp		num_combat3 $controls2 if num_combat~=. ,   cluster(stratum) 
outreg2 using T9C,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)    append 
reg high_stress_rlsnshp	combat_fire	num_combat3 $controls2 if num_combat~=. ,   cluster(stratum) 
test combat_fire	num_combat3
	sca ftest=r(F)
	sca pval=r(p )
outreg2 	using T9C,addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)    append 

reg high_stress_rlsnshp combat_fire  $controls2 if deploy12m==1  & num_combat~=.  & cm_3to6_past12m~=.,   cluster(stratum)
sum high_stress_rlsnshp if e(sample)==1
	sca depvarmean=r(mean)
outreg2 	using T9C, keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  adds("Dependent Variable Mean", depvarmean)  word excel label nocons  bdec(3) sdec(3)   append 
reg high_stress_rlsnshp cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1  & num_combat~=. ,   cluster(stratum)
outreg2 using T9C,keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 
reg high_stress_rlsnshp combat_fire cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1 & num_combat~=.  ,   cluster(stratum)
test combat_fire cm_3to6_past12m cm_7up_past12m
	sca ftest=r(F)
	sca pval=r(p )
outreg2 using T9C, addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 
reg high_stress_rlsnshp combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m  $controls2 if deploy12m==1 & num_combat~=.  ,   cluster(stratum)
test combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m
	sca ftest=r(F)
	sca pval=r(p )
outreg2 using T9C,addstat("Joint Significance F-test", ftest,"F-test P-Value",pval) keep(combat_fire num_combat3 cm_3to6_past12m cm_7up_past12m)  word excel label nocons  bdec(3) sdec(3)   append 


*Appendix Table 2

reg ina_rlsnship	combat_fire 	$controls ,   cluster(stratum)
outreg2    		combat_fire				using AT2_panelA_DoDHRB,keep(combat_fire) word excel label nocons  bdec(3) sdec(3) ctitle(ina_rlsnship) append replace title(Appendix Table 2. In a Relationship and Living with Children)
reg living_with_children	combat_fire 	$controls ,   cluster(stratum)
outreg2    		combat_fire				using AT2_panelA_DoDHRB,keep(combat_fire) word excel label nocons  bdec(3) sdec(3) ctitle(living_with_children) append


reg domestic_abuse		combat_fire $controls2 if num_combat~=. & deploy12m==1 ,   cluster(stratum) 
outreg2    		using AT2B_dodhrb,keep(combat_fire) word excel label nocons  bdec(3) sdec(3)  title(AT2B_dodhrb. Effect of Combat Exposure by Timing of Deployment)  ctitle(Deployment in Last Year) replace 
reg domestic_abuse		combat_fire $controls2 if num_combat~=. & deploy12m~=1 ,   cluster(stratum) 
outreg2    		using AT2B_dodhrb,keep(combat_fire) word excel label nocons  bdec(3) sdec(3)   ctitle(Deployment Prior to Last Year)append 
