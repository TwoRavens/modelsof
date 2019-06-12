/*do file name: clean.do*/


use merge, clear
*Sample: County of fujian in the year 2008*


/*drop the students which we can not identify their subjects: arts or sciences*/
destring originaltype, replace
drop if   originaltype==4
drop if   originaltype==16
drop if   originaltype==92
drop if   originaltype==99



gen type=1
replace type=0 if originaltype==11
replace type=0 if originaltype==13
replace type=0 if originaltype==14

/*generate month*/
gen byear=substr( birth,1,4)
gen bmonth=substr( birth,5,2)
gen bday=substr( birth,7,2)
destring byear  bmonth bday, replace
gen month= 6-bmonth+(2008- byear)*12

gen female = gender == 0

/*Generating percentile ranks*/
foreach i in "total" "chinese" "math" "integrate" "english"{
cumul `i', equal by(type) gen(`i'_rank_all)
cumul g`i', equal by(type) gen(g`i'_rank_all)
}



gen dgtotal_rank_all = gtotal_rank_all - total_rank_all


**Score differences**

foreach var of varlist total chinese math integrate english total_rank_all chinese_rank_all math_rank_all integrate_rank_all english_rank_all{ 
gen d`var' = g`var' - `var'
}

*Using zscores with type specific mean and sd*
foreach var of varlist total chinese math integrate english gtotal gchinese gmath gintegrate genglish{
egen z`var'_1 = std(`var') if type==1
egen z`var'_0 = std(`var') if type==0
gen z`var' = .
replace z`var' = z`var'_1 if type==1
replace z`var' = z`var'_0 if type==0
}

foreach var of varlist total chinese math integrate english{
gen dz`var' = zg`var' - z`var'
}

*Re-standardizing score differentials to be mean zero, standard deviation 1*

foreach i in "total" "chinese" "math" "integrate" "english"{
egen zdz`i' = std(dz`i')
}



/*generate cutoff points
0 to 3, 4 to 10, 11 to 20
*/

gen cutoff3=0
replace cutoff3=1 if total>=537 & total<=543 & type==1
replace cutoff3=1 if total>=467 & total<=473 & type==1
replace cutoff3=1 if total>=567 & total<=573 & type==0
replace cutoff3=1 if total>=497 & total<=503 & type==0

gen cutoff3_v2=0
replace cutoff3_v2=1 if total>=537 & total<=543 & type==1
replace cutoff3_v2=1 if total>=467 & total<=473 & type==1
*replace cutoff3_v2=1 if total>=417 & total<=423 & type==1
*replace cutoff3_v2=1 if total>=297 & total<=303 & type==1

replace cutoff3_v2=1 if total>=567 & total<=573 & type==0
replace cutoff3_v2=1 if total>=497 & total<=503 & type==0
*replace cutoff3_v2=1 if total>=457 & total<=463 & type==0
*replace cutoff3_v2=1 if total>=337 & total<=343 & type==0

gen cutoff5=0
replace cutoff5=1 if total>=535 & total<=545 & type==1
replace cutoff5=1 if total>=465 & total<=475 & type==1
replace cutoff5=1 if total>=565 & total<=575 & type==0
replace cutoff5=1 if total>=495 & total<=505 & type==0

gen cutoff5_v2=0
replace cutoff5_v2=1 if total>=535 & total<=545 & type==1
replace cutoff5_v2=1 if total>=465 & total<=475 & type==1
replace cutoff5_v2=1 if total>=415 & total<=425 & type==1
*replace cutoff5_v2=1 if total>=295 & total<=305 & type==1

replace cutoff5_v2=1 if total>=565 & total<=575 & type==0
replace cutoff5_v2=1 if total>=495 & total<=505 & type==0
replace cutoff5_v2=1 if total>=455 & total<=465 & type==0
*replace cutoff5_v2=1 if total>=335 & total<=345 & type==0

gen cutoff410 = 0
replace cutoff410=1 if total>=544 & total<=550 & type==1
replace cutoff410=1 if total>=530 & total<=536 & type==1
replace cutoff410=1 if total>=474 & total<=480 & type==1
replace cutoff410=1 if total>=460 & total<=466 & type==1
replace cutoff410=1 if total>=574 & total<=580 & type==0
replace cutoff410=1 if total>=560 & total<=566 & type==0
replace cutoff410=1 if total>=504 & total<=510 & type==0
replace cutoff410=1 if total>=490 & total<=496 & type==0

gen cutoff610=0
replace cutoff610=1 if total>=546 & total<=550 & type==1
replace cutoff610=1 if total>=530 & total<=534 & type==1
replace cutoff610=1 if total>=476 & total<=480 & type==1
replace cutoff610=1 if total>=460 & total<=464 & type==1
replace cutoff610=1 if total>=576 & total<=580 & type==0
replace cutoff610=1 if total>=560 & total<=564 & type==0
replace cutoff610=1 if total>=506 & total<=510 & type==0
replace cutoff610=1 if total>=490 & total<=494 & type==0

gen cutoff1120=0
replace cutoff1120=1 if total>=551 & total<=560 & type==1
replace cutoff1120=1 if total>=520 & total<=529 & type==1
replace cutoff1120=1 if total>=481 & total<=490 & type==1
replace cutoff1120=1 if total>=450 & total<=459 & type==1
replace cutoff1120=1 if total>=581 & total<=590 & type==0
replace cutoff1120=1 if total>=550 & total<=559 & type==0
replace cutoff1120=1 if total>=511 & total<=520 & type==0
replace cutoff1120=1 if total>=480 & total<=489 & type==0

gen cutoff1115=0
replace cutoff1115=1 if total>=551 & total<=555 & type==1
replace cutoff1115=1 if total>=525 & total<=529 & type==1
replace cutoff1115=1 if total>=481 & total<=485 & type==1
replace cutoff1115=1 if total>=455 & total<=459 & type==1
replace cutoff1115=1 if total>=581 & total<=585 & type==0
replace cutoff1115=1 if total>=555 & total<=559 & type==0
replace cutoff1115=1 if total>=511 & total<=515 & type==0
replace cutoff1115=1 if total>=485 & total<=489 & type==0

gen cutoff1620=0
replace cutoff1620=1 if total>=556 & total<=560 & type==1
replace cutoff1620=1 if total>=520 & total<=524 & type==1
replace cutoff1620=1 if total>=486 & total<=490 & type==1
replace cutoff1620=1 if total>=450 & total<=454 & type==1
replace cutoff1620=1 if total>=586 & total<=590 & type==0
replace cutoff1620=1 if total>=550 & total<=554 & type==0
replace cutoff1620=1 if total>=516 & total<=520 & type==0
replace cutoff1620=1 if total>=480 & total<=484 & type==0


gen cutoff10=cutoff5+cutoff610

gen notnearcutoff = 1 - cutoff3 - cutoff410 - cutoff1120

**Creating a graph based on positive/negative distance from reference cut-off**

capture drop cutoff3p cutoff3n
gen cutoff3p = 0
gen cutoff3n = 0
replace cutoff3p=1 if total>=540 & total<=543 & type==1
replace cutoff3p=1 if total>=470 & total<=473 & type==1
replace cutoff3p=1 if total>=570 & total<=573 & type==0
replace cutoff3p=1 if total>=500 & total<=503 & type==0
replace cutoff3n=1 if total>=537 & total<540 & type==1
replace cutoff3n=1 if total>=467 & total<470 & type==1
replace cutoff3n=1 if total>=567 & total<570 & type==0
replace cutoff3n=1 if total>=497 & total<500 & type==0

gen cutoff5p=0
gen cutoff5n=0
replace cutoff5p=1 if total>=540 & total<=545 & type==1
replace cutoff5p=1 if total>=470 & total<=475 & type==1
replace cutoff5p=1 if total>=570 & total<=575 & type==0
replace cutoff5p=1 if total>=500 & total<=505 & type==0
replace cutoff5n=1 if total>=535 & total<=540 & type==1
replace cutoff5n=1 if total>=465 & total<=470 & type==1
replace cutoff5n=1 if total>=565 & total<=570 & type==0
replace cutoff5n=1 if total>=495 & total<=500 & type==0

gen cutoff410p = 0
gen cutoff410n = 0
replace cutoff410p=1 if total>=544 & total<=550 & type==1
replace cutoff410n=1 if total>=530 & total<=536 & type==1
replace cutoff410p=1 if total>=474 & total<=480 & type==1
replace cutoff410n=1 if total>=460 & total<=466 & type==1
replace cutoff410p=1 if total>=574 & total<=580 & type==0
replace cutoff410n=1 if total>=560 & total<=566 & type==0
replace cutoff410p=1 if total>=504 & total<=510 & type==0
replace cutoff410n=1 if total>=490 & total<=496 & type==0

gen cutoff610p=0
gen cutoff610n=0
replace cutoff610p=1 if total>=546 & total<=550 & type==1
replace cutoff610n=1 if total>=530 & total<=534 & type==1
replace cutoff610p=1 if total>=476 & total<=480 & type==1
replace cutoff610n=1 if total>=460 & total<=464 & type==1
replace cutoff610p=1 if total>=576 & total<=580 & type==0
replace cutoff610n=1 if total>=560 & total<=564 & type==0
replace cutoff610p=1 if total>=506 & total<=510 & type==0
replace cutoff610n=1 if total>=490 & total<=494 & type==0

gen cutoff1120p=0
gen cutoff1120n=0
replace cutoff1120p=1 if total>=551 & total<=560 & type==1
replace cutoff1120n=1 if total>=520 & total<=529 & type==1
replace cutoff1120p=1 if total>=481 & total<=490 & type==1
replace cutoff1120n=1 if total>=450 & total<=459 & type==1
replace cutoff1120p=1 if total>=581 & total<=590 & type==0
replace cutoff1120n=1 if total>=550 & total<=559 & type==0
replace cutoff1120p=1 if total>=511 & total<=520 & type==0
replace cutoff1120n=1 if total>=480 & total<=489 & type==0



save merge_clean, replace
