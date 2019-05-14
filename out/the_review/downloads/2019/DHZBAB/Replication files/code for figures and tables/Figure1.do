clear all
set scheme s1color
use FNIdataset

// for labels
drop ethnicgroup
gen ethnicgroup="German" if german==1
replace ethnicgroup="Italian" if italian==1
replace ethnicgroup="Irish" if irish==1
replace ethnicgroup="Belgian" if belgian==1
replace ethnicgroup="French" if french==1
replace ethnicgroup="Swiss" if swiss==1
replace ethnicgroup="Portuguese" if portuguese==1
replace ethnicgroup="English" if english==1
replace ethnicgroup="Scottish" if scottish==1
replace ethnicgroup="Welsh" if welsh==1
replace ethnicgroup="Danish" if danish==1
replace ethnicgroup="Norwegian" if norwegian==1
replace ethnicgroup="Swedish" if swedish==1
replace ethnicgroup="Finnish" if finnish==1
replace ethnicgroup="Austrian" if austrian==1
replace ethnicgroup="Russian" if russian==1

graph bar (mean) FNI, over(ethnicgroup, label(angle(vertical))) plotregion(style(none)) ysca(titlegap(2)) ///
		 ylabel(, nogrid labsize(small)) ytitle("Mean Foreign Name Index", size(small))  ///
		 bar(1, color(dknavy)) bar(2, color(dknavy)) bar(3, color(dknavy))
