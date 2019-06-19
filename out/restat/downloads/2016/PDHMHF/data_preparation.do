



*******************************************************************************************************
****This do file creates DYADS of attendees 
********************************************************************************************************

clear
use "participant_idlist"

keep participant_id

gen file = 1


egen num_id_x = seq()

save ids_only, replace

rename participant_id y_participant_id

drop num_id_x
egen num_id_y = seq()

***create dyads
joinby file using ids_only

rename participant_id x_participant_id

sort x_participant_id

drop file

order x_participant_id y_participant_id num_id_x num_id_y
sort x_participant_id y_participant_id 

***drop same person dyads
drop if x_participant_id==y_participant_id


*****now merge back with other info

rename x_participant_id participant_id
merge m:1 participant_id using attendees_final, keepusing(room   night  gender  superexpert imager new_inst rank clinicalarea ///
 campus )
drop if _merge==2
drop _merge


foreach variable in room   night  gender superexpert imager new_inst rank  clinicalarea  campus    {
rename `variable' x_`variable'
}
rename participant_id x_participant_id


rename y_participant_id participant_id
merge m:1 participant_id using attendees_final , keepusing(room  night  gender superexpert imager new_inst rank clinicalarea   ///
campus )
drop if _merge==2
drop _merge



foreach variable in room  night gender  superexpert imager new_inst rank  clinicalarea  campus   {
rename `variable' y_`variable'
}
rename participant_id y_participant_id


/*************** Merge with outcome variable: coapplication on a grant or concept application***************/

merge 1:1 x_participant_id y_participant_id using "attendee_dyads", keepusing(coapplicant)
drop if _merge==2
replace coapplicant=0 if coapplicant==.
drop _merge

merge 1:1 x_participant_id y_participant_id using "attendee_concept_dyads", keepusing(coconceptapplicant)
drop if _merge==2
replace coconceptapplicant=0 if coconceptapplicant==.
drop _merge

/***************** Merge with information on who copublished before the experiment  *****************/
merge 1:1 x_participant_id y_participant_id using "previouscoauthor", keepusing(previouscoauthor)
drop if _merge==2
drop _merge
replace previouscoauthor=0 if previouscoauthor==.




/***************** Keep only half of the symmetric observations *****************/
/************** since the links are not directed, observation (i,j) is effectively a duplicate of observation (j,i) **********/
/************* only one of the two is retained ****************/
 
drop if num_id_x>num_id_y

/**********************************/



sort x_participant_id y_participant_id 


/***************** Create various pair-level variables********************/

gen any_coapplicant = 0
replace any_coapplicant = 1 if (coconceptapplicant==1|coapplicant==1)

gen same_night=0
replace same_night=1 if x_night==y_night

gen same_room=0
replace same_room=1 if x_room==y_room & x_night==y_night

foreach n in x y {
gen `n'_female = 0 
replace `n'_female = 1 if `n'_gender=="F" 
}

gen one_female=0
replace one_female=1 if x_gender=="M" & y_gender=="F"
replace one_female=1 if x_gender=="F" & y_gender=="M"

gen both_female=0
replace both_female=1 if x_gender=="F" & y_gender=="F"

gen both_imager=0
replace both_imager=1 if y_imager==1 & x_imager==1

gen both_clinician=0
replace both_clinician=1 if y_imager==0 & x_imager==0

gen one_imager=0
replace one_imager=1 if y_imager==1 & x_imager==0
replace one_imager=1 if y_imager==0 & x_imager==1

gen same_inst=0
replace same_inst=1 if x_new_inst==y_new_inst

gen same_campus=0
replace same_campus=1 if x_campus==y_campus

gen both_longwood = 0
replace both_longwood=1 if x_campus=="Longwood" & y_campus=="Longwood"

gen same_gender = 0
replace same_gender=1 if x_gender==y_gender

gen same_imag_clin = 0
replace same_imag_clin=1 if (y_imager==1 & x_imager==1)|(y_imager==0 & x_imager==0)


gen big_room=0
replace big_room=1 if x_room==204 & y_room==204



***clean up rank
foreach n in x y {
replace `n'_rank = "Postdoctoral Fellow" if `n'_rank=="Postdoctoral fellow"
}


foreach n in x y {
gen `n'_postdoc = 0 
replace `n'_postdoc = 1 if `n'_rank=="Postdoctoral Fellow"
replace `n'_postdoc = 1 if `n'_rank=="Research Associate"
*recode other category - they seem to be clinical fellows, which is more like research assoc.
replace `n'_postdoc = 1 if `n'_rank=="Other"
}


gen onepostdoc = 0 
replace onepostdoc = 1 if x_postdoc==1 & y_postdoc==0
replace onepostdoc = 1 if x_postdoc==0 & y_postdoc==1


gen bothpostdoc = 0
replace bothpostdoc = 1 if x_postdoc==1 & y_postdoc==1


gen same_clinicalarea=0
replace same_clinicalarea=1 if x_clinicalarea==y_clinicalarea & x_clinicalarea!=""


***interactions

foreach var in   same_campus    ///
  one_imager both_imager both_longwood onepostdoc bothpostdoc  ///
  both_female one_female both_clinician same_clinicalarea same_inst {
gen same_room_X_`var'=same_room*`var'
}

gen same_room_X_previouscoau = same_room * previouscoauthor



*****encode vars

encode x_new_inst, gen(x_inst_num)
encode y_new_inst, gen(y_inst_num)

encode x_rank, gen(x_rank_num)
encode y_rank, gen(y_rank_num)


****code night

foreach n in 31 1 2 {
gen dum_`n' = 0
replace dum_`n' = 1 if x_night==`n'
}




****label variables
label var same_room "Same Room"
label var same_room_X_previouscoau "Same Rm X Prev Coau"

label var previouscoauthor "Previous Coauthor"
label var one_female "One is female"
label var both_female "Both are female"
label var same_room_X_one_female "Same Rm X One female"
label var same_room_X_both_female "Same Rm X Both female"

label var x_imager "X imager"
label var y_imager "Y imager"
label var x_inst_num "X inst"
label var y_inst_num "Y inst"
label var x_rank_num "X rank"
label var y_rank_num "Y rank"

label var same_room_X_same_clinicalarea "Same Rm X Same Clin Area"
label var same_clinicalarea "Same Clinical Area (SOI)"

label var same_room_X_same_campus "Same Rm X Same Campus"
label var same_room_X_one_imager "Same Rm X One imager"
label var same_room_X_both_imager "Same Rm X Both imager"

label var same_campus "Same Campus"
label var same_inst "Same Hospital"


label var onepostdoc "One postdoc"
label var same_room_X_onepostdoc "Same Rm X 1 postdoc"
label var same_room_X_bothpostdoc "Same Rm X Both postdocs"
label var one_imager "One Imager-One Clinician"
label var bothpostdoc "Both postdocs"
label var both_imager "Both imagers"
label var both_longwood "Both Longwood Campus"
label var same_room_X_both_longwood "Same Rm X Both Longwood"
label var dum_31 "Night 1"
label var dum_1 "Night 2"
label var dum_2 "Night 3"



sort x_participant_id y_participant_id


/************** Restricting the sample to participants attending on the same night *********/

keep if same_night==1

/************** Excluding pairs with one or two students from the analysis sample *********/

drop if x_rank=="Undergraduate Student"
drop if y_rank=="Undergraduate Student"


drop if x_rank=="Graduate Student"
drop if y_rank=="Graduate Student"



save dyad_ready, replace


clear


use dyad_ready


egen x_participantidnum=group(x_participant_id)
egen y_participantidnum=group(y_participant_id)

keep any_coapplicant same_room same_night dum_1 dum_2 x_night y_night x_room y_room x_participantidnum y_participantidnum

save "dyad_ready_public", replace



*******************************************************
***End of data prep
*******************************************************


