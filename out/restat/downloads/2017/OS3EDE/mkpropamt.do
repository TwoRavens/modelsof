capture log close
log using mkpropamt.log , replace

use acs0407withzip.dta , clear

keep zipcode proptax income year statecode
keep if year==2005
drop if statecode=="PR"

drop year
rename proptax proptax2004
* i.e. proptax amount is for the preceding year
rename income income2004

rename zipcode prop_zip
sort prop_zip
* get rid of any duplicates
drop if prop_zip==prop_zip[_n-1]

save proptaxamt2004.dta , replace

log close
exit
