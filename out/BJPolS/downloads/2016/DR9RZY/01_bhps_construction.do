log using $log/bhps_construction , replace


/*	01_bhps_construction.do :

	This do file merges waves 1-18 of the British Household Panel Survey (BHPS). 
	
 -- In a given wave, we only keep obs for whom both indiv AND hhold is available.  (Only keep if _merge==3.)  
	In very rare cases, all indiv information is missing for a given hid, or hhold information is missing for a pid.

 -- Wave-specific notes:
	>> Wave 9  (prefix "i") and following: sample size is larger due to Scotland and Wales Extension Samples [II.2.2]
	>> Wave 11 (prefix "k") and following: includes substantial new sample in Northern Ireland, the Northern Ireland Household Panel [II.2.3]
	>> Wave 12 (prefix "l") and following: sample size decreases due to end of ECHP sub-sample [II.2.1]
	
 -- The final products of this do-file are all individual level datasets:
		complete_bhps.dta : combines indresp, hhresp, and xw datasets
		indallcomplete: non-surveyed hhold members
		egoaltcomplete.dta: relationships 
		complete_bhps_youth.dta : combines youth, hhresp, and xw datasets  */



local waveprefixes a b c d e f g h i j k l m n o p q r



/* Part ONE: xw datasets
		These are variables constructed by BHPS (that is, not simply survey responses) and often include their best guess of 
		an individual's time-invariant characteristics.  */
  
use $rawdta/xwavedat , clear
merge 1:1 pid using $rawdta/xwlsten.dta , nogenerate
merge 1:1 pid using $rawdta/xwaveid.dta , nogenerate
rename * xw_*
rename xw_pid pid	
compress
tempfile xwavedatasets
save `xwavedatasets'
	
	
/* Part TWO: indall  */

local i=1
foreach prefix of local waveprefixes {

	tempfile `prefix'indallcomplete 

		/* Save indall datasets */
	use $rawdta/`prefix'indall, clear 
	renpfix `prefix' 
	if `"`prefix'"'=="p" rename id pid /* We don't want to remove the "p" in pid for wave p */  
	gen wave=`i'
	save ``prefix'indallcomplete'
	local ++i	
		}
		
		/* Append the waves ... can also use -merge- in place of -append- */
	foreach prefix of local waveprefixes {
		if `"`prefix'"'=="a" use ``prefix'indallcomplete' 
		else append using ``prefix'indallcomplete'
	}
	
replace age=. if age<0	
replace buno=pno if inrange(butype,9,17)  /* Fix errors in benefit unit head.  3 individuals have been assigned the wrong buno */

save $cleandta/indallcomplete, replace

	
	
	
/* Part THREE: Household (hhresp) and Individual (indresp).  We first merge hhold and indiv for each wave, then append all waves. */

foreach prefix of local waveprefixes {

	tempfile `prefix'indrespcomplete `prefix'hhrespcomplete `prefix'hholdindivcomplete

		/* Indiv datasets */
	
	use $rawdta/`prefix'indresp, clear 
	rename `prefix'* *
	if `"`prefix'"'=="p" {
		rename id pid /* We don't want to remove the "p" in pid for wave p */  
		recode hlhti (-1=8) (-2=9)  
			/* Height information for wave 16 was incorrectly inputted.  We follow the recommendation of BHPS user support.  
			   In response to our inquiry, they advise to recode the value -1 to 8 and -2 to 9.  
			   For reference, see https://www.understandingsociety.ac.uk/support/issues/48           */
		}
	save ``prefix'indrespcomplete'
		
		/* Household datasets */
	
	use $rawdta/`prefix'hhresp, clear 
	rename `prefix'* *
	save ``prefix'hhrespcomplete'

		/* Merging hhold and indiv */
	
	merge 1:m hid using ``prefix'indrespcomplete'	
	count if _merge==1
	local notany=r(N)
	disp "There are `notany' hholds in wave `prefix' in which no indiv information exists"
	count if _merge==2
	local notany=r(N)
	disp "There are `notany' indivs in wave `prefix' for whom no hhold information exists"
	keep if _merge==3
	drop _merge
    gen waveletter="`prefix'" 
	save ``prefix'hholdindivcomplete'
}

	/* Append the waves ... can also use -merge- in place of -append- */

foreach prefix of local waveprefixes {
	if `"`prefix'"'=="a" use ``prefix'hholdindivcomplete' 
	else append using ``prefix'hholdindivcomplete'
}

egen wave=group(waveletter)

	/* Merge xw datasets to completely assemble dataset */

merge m:1 pid using `xwavedatasets'
list pid if _merge==1
keep if _merge==3  /* Keeping only observations for which we have xw_ and political information.
					  We drop one person pid is listed who has no information in xw_ but is in indresp for waves l,m,n,o. */
drop _merge


gen bhps=1  /* for use when merging bhps data with ukhls */
gen ukhls=0 /* for use when merging bhps data with ukhls */
compress
save $cleandta/complete_bhps, replace	


/* Part FOUR: egoalt  */

local i=1
foreach prefix of local waveprefixes {
	tempfile `prefix'egoalt

		/* Save egoalt datasets */
	use $rawdta/`prefix'egoalt, clear 
	renpfix `prefix' 
	if `"`prefix'"'=="p" rename id pid /* We don't want to remove the "p" in pid for wave p */  
	gen wave=`i'
	save ``prefix'egoalt'
	local ++i	
		}
		
		/* Append the waves ... can also use -merge- in place of -append- */
foreach prefix of local waveprefixes {
	if `"`prefix'"'=="a" use ``prefix'egoalt' 
	else append using ``prefix'egoalt'
	}

	save $cleandta/egoaltcomplete, replace


	
	
/* Part FIVE: Youth datasets (conducted from wave d onward) */

local i=4
local excluding a b c
local youthwaveprefixes : list waveprefixes - excluding

foreach prefix of local youthwaveprefixes {
	tempfile `prefix'youth

	use $rawdta/`prefix'youth, clear
	rename `prefix'* *
	if `"`prefix'"'=="p" rename id pid /* We don't want to remove the "p" in pid for wave p */  
	gen wave=`i'
	merge m:1 hid using ``prefix'hhrespcomplete'
	drop if _merge==2  /* Keep hholds for which we have a youth */
	drop _merge
	save ``prefix'youth'	
	local ++i
}

	/* Append the waves ... can also use -merge- in place of -append- */

foreach prefix of local youthwaveprefixes {
	if `"`prefix'"'=="d" use ``prefix'youth' , clear
	else append using ``prefix'youth'
}
	
	/* Merge xw datasets to completely assemble dataset */

merge m:1 pid using `xwavedatasets'
keep if _merge==3  /* Keeping only observations for which we have xw_ and other information */
drop _merge

merge 1:1 pid wave using $cleandta/indallcomplete , keepusing(buno)
drop if _merge==2
drop _merge

compress
save $cleandta/complete_bhps_youth , replace


	
log close
exit
