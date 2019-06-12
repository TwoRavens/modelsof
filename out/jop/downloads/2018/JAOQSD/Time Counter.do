* Creating a duration (time) variable 
* Users should install btscs.ado file in their personal "ado" directory
* Refer https://www.prio.org/Data/Stata-Tools/

*************************************************************;
*                  Creating Time Counters                   *;
*************************************************************;

use "/Users/wooaesil/Dropbox/UC Merced/WooCon - JOP/JOP/Final Submission/Replication Files/woocon16dic.dta"


btscs CoupsBi year ccode, generate(spellcount) f 
gen spellcount2=spellcount*spellcount
gen spellcount3=spellcount2*spellcount
rename spellcount ctr
rename spellcount2 ctr2
rename spellcount3 ctr3
drop _frstfl _prefail _tuntilf

btscs AntiGovDemBi year ccode, generate(spellcount) f 
gen spellcount2=spellcount*spellcount
gen spellcount3=spellcount2*spellcount
rename spellcount dtr
rename spellcount2 dtr2
rename spellcount3 dtr3
drop _frstfl _prefail _tuntilf


btscs RiotsBi year ccode, generate(spellcount) f 
gen spellcount2=spellcount*spellcount
gen spellcount3=spellcount2*spellcount
rename spellcount rtr
rename spellcount2 rtr2
rename spellcount3 rtr3
drop _frstfl _prefail _tuntilf

save "/Users/wooaesil/Dropbox/UC Merced/WooCon - JOP/JOP/Final Submission/Replication Files/polywoocon16dic.dta"
