conren style 3

log using Table1.log, replace
set mem 1500m

local PrivateDataLocation = "enroll.dta"

***Summary Statistics: Of our Selected Sample
	use PrivateData/NovDec09AllChoices.dta
	
	gen bronze=1 if tierChosen=="BRONZE" | tierChosen=="BRONZE PLUS"
	gen silver=1 if tierChosen=="SILVER" | tierChosen=="SILVER PLUS" | tierChosen=="SILVER SELECT"
	gen gold=1 if tierChosen=="GOLD"
	
	replace bronze=0 if bronze==.
	replace silver=0 if silver==.
	replace gold=0 if gold==.

	****Simple form of sum stats
		tabstat bronze silver gold if choseThisPlan==1, column(stats) stats(mean N)
		tab carrierChosen if choseThisPlan==1
		tabstat age_self if choseThisPlan==1 , stats(mean N sd semean q)
		tab gender if choseThisPlan==1
		tab dep_count if choseThisPlan==1
		tabstat predictedPremium  if choseThisPlan==1,  stats(mean N sd semean q)
clear


***Summary Statistics: Of the new enrollees only Sample
	use PrivateData/NovDec09FirstChoices.dta
	
	gen bronze=1 if tierChosen=="BRONZE" | tierChosen=="BRONZE PLUS"
	gen silver=1 if tierChosen=="SILVER" | tierChosen=="SILVER PLUS" | tierChosen=="SILVER SELECT"
	gen gold=1 if tierChosen=="GOLD"
	
	replace bronze=0 if bronze==.
	replace silver=0 if silver==.
	replace gold=0 if gold==.

	****Simple form of sum stats
		tabstat bronze silver gold if choseThisPlan==1, column(stats) stats(mean N)
		tab carrierChosen if choseThisPlan==1
		tabstat age_self if choseThisPlan==1 , stats(mean N sd semean q)
		tab gender if choseThisPlan==1
		tab dep_count if choseThisPlan==1
		tabstat predictedPremium  if choseThisPlan==1,  stats(mean N sd semean q)
clear


***Summary Statistics of the Total New enrollees, 2007-2009
	use `PrivateDataLocation'
	
	***Keep people whenever they add in (will include some inertia, but that is appropriate for full sample)
	***We are comparing our selected sample to "everyone" 
	keep if tx_abbr=="ADD" 

	
	rename plan tierChosen
	
	gen bronze=1 if tierChosen=="BRONZE" | tierChosen=="BRONZE PLUS"
	gen silver=1 if tierChosen=="SILVER" | tierChosen=="SILVER PLUS" | tierChosen=="SILVER SELECT"
	gen gold=1 if tierChosen=="GOLD"
	gen YAP=1 if tierChosen=="YAP"
	
	replace bronze=0 if bronze==.
	replace silver=0 if silver==.
	replace gold=0 if gold==.
	replace YAP=0 if YAP==.

		
	******Summary Stats
		tabstat bronze silver gold YAP , column(stats) stats(mean N)
		tab carrier 
		tabstat age  , stats(mean N sd semean q)
		tab gender 
		tab dep_count 
		sum dep_count
		tabstat mo_prem  ,  stats(mean N sd semean q)

log close
