clear all
cd "DOD_HRB_files_directory" 

* Preparing the DOD HRB data for the analysis. 
use 2008_HRB_Adjusted.dta, clear

** Extracting the variables to be used in the analysis. 

keep deploylife ptsdstat edq120_b education marital gender  drgea30 race hispanic Service deployyear edq159 psychill bingedrk edq20_m edq20_n edq18 region edq2 edq3 /*
    */ edq4 edq5 paygroup edq20_p edq111 edq20_s agec edq165_b edq165_e edq159 edq165_h edq165_q edq165_i edq14 enlist stratum edq160 edq161


**** Edit Key Variables
drop if deploylife==2
drop if deploylife<0
sum deploylife

replace ptsdstat = 0 if ptsdstat == 2 
replace ptsdstat = . if ptsdstat == -8
**create ptsd into binary variable 


generate suicide = .
replace suicide = 0 if edq120_b == 2
replace suicide = 1 if edq120_b == 1
*edq120_b: If you ever sieriously considered suicide within the past year
**Suicide variable for past 12 months

generate educ_less_highschool = 0
replace educ_less_highschool = 1 if education == 1 | education == 2
generate educ_highschool = 0
replace educ_highschool = 1 if education == 3 
generate educ_somecollege = 0
replace educ_somecollege = 1 if education == 4 | education == 5 | education == 6 
generate educ_college = 0
replace educ_college = 1 if education == 7 | education == 8 | education == 9
**creates new variables for educatrion level

generate married = .
replace married = 1 if marital == 1
replace married = 0 if marital == 2 | marital == 3 | marital == 4 | marital == 5
generate single = . 
replace single = 1 if marital == 2 | marital == 3
replace single = 0 if marital == 1 | marital == 4 | marital == 5
generate divorced = .
replace divorced = 1 if marital == 4 | marital == 5
replace divorced = 0 if marital == 1 | marital == 2 | marital == 3 
**Creating dummy variables for marital status

replace gender = 0 if gender == 2
rename gender male
**convert GENDER into dummy variable MALE with =1 being male and  =0 being female

replace drgea30 = 0 if drgea30 == 2
replace drgea30 = . if drgea30 == -8
** converting DRGEA12 variable into binary response - drug use of illicit substances Except Steroids, Sexual Enhancers, Analgesics

generate race_white = 0
replace race_white = 1 if race == 1
generate race_black = 0 
replace race_black = 1 if race == 2
generate race_asian = 0
replace race_asian = 1 if race == 4
*Asian (e.g., Asian Indian, Chinese, Filipino, Japanese, Korean, Vietnamese)
generate race_other = 0
replace race_other = 1 if race == 6 | race == 5 | race == 3 | race_asian==1
**create dummy variables for all other races (Native American, Hispanic, Eskimo, ect.)


generate army = 0
replace army = 1 if Service == 1
generate navy = 0
replace navy = 1 if Service == 2
generate marine = 0
replace marine = 1 if Service == 3
generate af = 0
replace af = 1 if Service == 4
generate cg = 0
replace cg = 1 if Service == 5
**create dummy variables for each branch of service

drop if cg == 1
**Drop all Coast Guard observations from analysis


replace deploylife = 0 if deploylife == 2
replace deploylife = . if deploylife == -8
**creates deploylife into dummy variable where =1 means deployed in lifetime, =0 means not deployed in lifetime

replace deployyear = 0 if deployyear == 2
replace deployyear = . if deployyear == -8
**creates deployyear into dummy variable where =1 meand seployed in past year, =0 means not deployed in last year

generate september_11 = 0
replace september_11 = 1 if edq159 >= 2 & edq159 <= 6
*Creates variable that stats whether an individual has been on a combat deployment since 911
**Specifically: How many combat deployments (including peacekeeping missions) have you been on since September 11, 2001? 



*rename edq164 longest_deployment
*replace longest_deployment = . if longest_deployment == 19 | longest_deployment == -6 | longest_deployment == -8
** EDQ164 how long was your longest deployment

replace psychill = 0 if psychill == 2
replace psychill = . if psychill == -8


replace bingedrk = . if bingedrk == -8
replace bingedrk = 0 if bingedrk == 2
**creates bingedrk into binary variable where bingedrinking is 
**defined as consuming five or more drinks (four or more for women) 
**on the same occasion at least once during the past 30 days

generate domestic_abuse = 0
replace domestic_abuse = 1 if edq20_m == 1 | edq20_m == 2 | edq20_m == 3 | edq20_n == 1 | edq20_n == 2 | edq20_n == 3
**creates domestic violence variable from hitting spouse, fiance, boyfriend/girlfriend, or child once or more 
** in the past 12 months for any reason besides discipline 

ta edq20_m
replace edq20_m=. if edq20_m<0
gen hit_spouse=0 if edq20_m~=. 
replace hit_spouse=1 if edq20_m~=. & edq20_m<4

replace edq20_n=. if edq20_n<0
gen hit_children=0 if edq20_n~=. 
replace hit_children=1 if edq20_n~=. & edq20_n<4
 

*ta edq17
*replace edq17=. if edq17<0
*gen single_parent=0 if edq17~=. 
*replace single_parent=1 if edq17~=. & edq17==1
*ta edq17 
*ta single_parent

replace edq18=. if edq18<0
ta edq18

gen living_with_children=0 if edq18~=. 
replace living_with_children=1 if edq18==1
ta edq18 

* single_parent living_with_children

replace region = 0 if region == 2
** region is binary variable in which =1 means CONUS and =0 means OCONUS/AFLOATS

replace edq2 = . if edq2 == -8 | edq2 == -9
rename edq2 army_command
**  1	US Army Forces Command (FORSCOM)		
**	2	US Army Training and Doctrine Command (TRADOC)		
**	3	US Army Europe		697	2.4	4.9
**	4	US Army Pacific		700	2.5	4.3
**	5	8th Army

generate army_command_1 = 0
replace army_command_1 = 1 if army_command == 1
**  1	US Army Forces Command (FORSCOM)
generate army_command_2 = 0
replace army_command_2 = 1 if army_command == 2
**	2	US Army Training and Doctrine Command (TRADOC)	
generate army_command_3 = 0
replace army_command_3 = 1 if army_command == 3
**	3	US Army Europe
generate army_command_4 = 0
replace army_command_4 = 1 if army_command == 4
**	4	US Army Pacific
generate army_command_5 = 0
replace army_command_5 = 1 if army_command == 5
**	5	8th Army

replace edq3 = . if edq3 == -8 | edq3 == -9
rename edq3 navy_command
**  1	U.S. Fleet Forces Command (FFC)		
**	2	Commander Pacific Forces (CPF)		
**	3	Naval Medical Command (NMC)		
**	4	Commander Naval Installations Command (CNIC)

generate navy_command_1 = 0
replace navy_command_1 = 1 if navy_command == 1
generate navy_command_2 = 0
replace navy_command_2 = 1 if navy_command == 2
generate navy_command_3 = 0
replace navy_command_3 = 1 if navy_command == 3
generate navy_command_4 = 0
replace navy_command_4 = 1 if navy_command == 4
**  1	U.S. Fleet Forces Command (FFC)		
**	2	Commander Pacific Forces (CPF)		
**	3	Naval Medical Command (NMC)		
**	4	Commander Naval Installations Command (CNIC)

replace edq4 = . if edq4 == -8 | edq4 == -9
rename edq4 marine_command
**  1	MCI East		
**	2	MCI West

generate marine_command_1 = 0
replace marine_command_1 = 1 if marine_command == 1
generate marine_command_2 = 0
replace marine_command_2 = 1 if marine_command == 2
**  1	MCI East		
**	2	MCI West

replace edq5 = . if edq5 == -8 | edq5 == -9
rename edq5 af_command
**	1	Air Combat Command (ACC)		
**	2	Air Education and Training Command (AETC)		
**	3	Air Force Materiel Command (AFMC)		
**	4	Air Force Space Command (AFSPC)		
**	5	Air Mobility Command (AMC)		
**	6	Pacific Air Forces (PACAF)		
**	7	US Air Forces Europe (USAFE)		

generate af_command_1 = 0
replace af_command_1 = 1 if af_command == 1
generate af_command_2 = 0
replace af_command_2 = 1 if af_command == 2
generate af_command_3 = 0
replace af_command_3 = 1 if af_command == 3
generate af_command_4 = 0
replace af_command_4 = 1 if af_command == 4
generate af_command_5 = 0
replace af_command_5 = 1 if af_command == 5
generate af_command_6 = 0
replace af_command_6 = 1 if af_command == 6
generate af_command_7 = 0
replace af_command_7 = 1 if af_command ==7
**	1	Air Combat Command (ACC)		
**	2	Air Education and Training Command (AETC)		
**	3	Air Force Materiel Command (AFMC)		
**	4	Air Force Space Command (AFSPC)		
**	5	Air Mobility Command (AMC)		
**	6	Pacific Air Forces (PACAF)		
**	7	US Air Forces Europe (USAFE)		

*replace edq163_a = 0 if edq163_a == 2
*replace edq163_a = . if edq163_a == -6 | edq163_a == -8
*rename edq163_a non_deploy
**binary value for non deployable individuals

generate paygroup_1 = 0
replace paygroup_1 = 1 if paygroup == 1
**E1-E3
generate paygroup_2 = 0
replace paygroup_2 = 1 if paygroup == 2
**E4-E6
generate paygroup_3 = 0
replace paygroup_3 = 1 if paygroup == 3
**E7-E9
generate paygroup_4 = 0
replace  paygroup_4 = 1 if paygroup == 4
**W1-W5
generate paygroup_5 = 0
replace paygroup_5 = 1 if paygroup == 5
**O1-O3
generate paygroup_6 = 0
replace paygroup_6 = 1 if paygroup == 6
**O4-O10

generate p_thrtnd_to_leave = 0
replace p_thrtnd_to_leave = 1 if edq20_p == 1 | edq20_p == 2 | edq20_p == 3 
replace p_thrtnd_to_leave = . if edq20_p == -8 | edq20_p == -6
*Dummy variable generated from EDQ20_P in which it is 1
*if spouse has asked observation to leave once or more in the last 12 months

generate high_stress_rlsnshp = 0
replace high_stress_rlsnshp = 1 if edq111 == 1
replace high_stress_rlsnshp = . if edq111 == -6 | edq111 == -8
*Dummy variable constructed from edq111 in which it is a 1 if
*the observation has experienced a lot of stress in the past 12 months
*because of relationship


generate heated_ff_argument = 0
replace heated_ff_argument = 1 if edq20_s == 1 | edq20_s == 2 | edq20_s == 3
replace heated_ff_argument = . if edq20_s == -6 | edq20_s == -8
*dummy variable for whether observation has gotten into a heated argument with friends and family more than once in the past 12 months

generate age_square = 0 
replace age_square = agec*agec
*Age variable

**Combat Variables

generate combat_fire = .
replace combat_fire = 0 if edq165_b == 5 & edq165_e == 5
replace combat_fire = 1 if edq165_b >= 1 & edq165_b <= 4
replace combat_fire = 1 if edq165_e >= 1 & edq165_b <= 4
*edq 165_e :  My unit fired on the enemy. 
*edq 165_b :  I, or members of my unit, received incoming fire from small arms, artillery, rockets, or mortars.
**Overall:  I experienced a firefight

generate num_combat = . 
replace num_combat = 0 if edq159 == 1
replace num_combat = 1 if edq159 == 2
replace num_combat = 2 if edq159 == 3
replace num_combat = 3 if edq159 == 4
replace num_combat = 4 if edq159 == 5
replace num_combat = 5 if edq159 == 6
**renames and reorders categorical variable for Number of combat deployments since september 11

gen num_combat2=. 
replace num_combat2=0 if edq159 == 1
replace num_combat2=1 if edq159 == 2
replace num_combat2=2 if edq159 == 3
replace num_combat2=3.5 if edq159 == 4
replace num_combat2=5.5 if edq159 == 5
replace num_combat2=8 if edq159 == 6
 
gen num_combat3=num_combat2
replace  num_combat3=10 if  num_combat3==8

ta combat_fire, sum( num_combat3)

generate death_enemy = .
replace death_enemy = 0 if edq165_h == 5
replace death_enemy = 1 if edq165_h >= 1 & edq165_h <= 4
*edq165_h:  I was responsigble for the death or serious injury of an enemy
**Overall: Responsible for Death/Serious injury of an enemy

generate ally_hurt = .
replace ally_hurt = 0 if edq165_i == 5
replace ally_hurt = 1 if edq165_i >= 1 & edq165_i <= 4
**edq165_i: I witnessed members of my unit or an ally unit being seriously wounded or killed

*generate human_remains = . 
*replace human_remains = 0 if edq165_k == 5
*replace human_remains = 1 if edq165_k >= 1 & edq165_k <= 4
**edq165_k: I saw human dead bodies and/or human remains

generate wounding = . 
replace wounding = 0 if edq165_q == 5
replace wounding = 1 if edq165_q >= 1 & edq165_q <= 4
**edq165_q : Thinking about all of your deployments (combat and noncombat), how many times have you had each of the following experiences?  I was wounded in comba


ta edq14
replace edq14=. if edq14<1
gen ina_rlsnship=0 if edq14~=.
replace ina_rlsnship=1 if edq14==1 | edq14==2

*ta edq15
*replace edq15=. if edq15<1

*gen active_spouse=0 if edq15~=.
*replace active_spouse=1 if edq15==1 | edq15==2




drop if combat_fire==.
sum domestic_abuse hit_spouse hit_children p_thrtnd_to_leave high_stress_rlsnshp  heated_ff_argument

sum race_white race_black race_asian race_other
gen rwhite=0 if race~=. 
replace rwhite=1 if race==1

gen rblack=0 if race~=. 
replace rblack=1 if race==2

gen rother=0 if race~=. 
replace rother=1 if race>=3 & race~=. 

gen hispanicS=0
replace hispanicS=1 if hispanic~=. & hispanic>=2


gen enlisted=0 
replace enlisted=1 if enlist==1 




drop if num_combat==. 

gen data_test=.
replace data_test=1 if domestic_abuse~=. | hit_spouse~=. | hit_children~=. | high_stress_rlsnshp~=. | heated_ff_argument~=. | p_thrtnd_to_leave~=. 

label var domestic_abuse "Any Abuse"
label var hit_spouse "Partner Abuse"
label var hit_children "child Abuse"
label var p_thrtnd_to_leave "Break up"
label var high_stress_rlsnshp "Relationship Stress"
label var heated_ff_argument "Argument"
label var ina_rlsnship "Relationship"

label var combat_fire "Combat Exposure"
label var death_enemy "Killed Someone"
label var wounding "Wounded or Injured"
label var wounding "Witnessed Death of Ally"

label var ptsdstat "PTSD Screening"
label var psychill "Psychological Stress"
label var suicide "Suicidal Ideation"
label var bingedrk "Any Binge Drinking"
label var drgea30 "Drug Use"
label var army "Army"
label var marine "Marines"
label var navy "Navy"
label var af "Air Force" 

label var paygroup_1 "Rank E1-E3"
label var paygroup_2 "Rank E4-E6" 
label var paygroup_3 "Rank E7-E9" 
label var paygroup_4 "Rank W1-W5" 
label var paygroup_5 "Rank O1-O3" 
label var paygroup_6 "Rank O4-O10"  
label var agec "Age"
label var rwhite "White"
label var rblack "Black" 
label var rother "Other Race"
label var hispanicS "Hispanic"
label var educ_somecollege "Some College"
label var educ_college "College and Above" 


save dod_hrb_data, replace


