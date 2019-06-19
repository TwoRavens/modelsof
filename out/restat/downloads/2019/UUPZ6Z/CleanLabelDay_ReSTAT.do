
* make labels for peer overlap
gen labelclean=label

* make consistent
replace labelclean=subinstr(labelclean,"AMIkids","AMI",1)
replace labelclean=subinstr(labelclean," - ","-",.)
replace labelclean=subinstr(labelclean,"C B I S","CBIS",.)
replace labelclean=subinstr(labelclean,"-AMI-","-AMI ",.)
replace labelclean=subinstr(labelclean,"County","",.)
replace labelclean=subinstr(labelclean,"-SOP"," SOP",.)

foreach x in 0 1 2{
foreach y  in 0 1 2 3 4 5 6 7 8 9{
replace labelclean=subinstr(labelclean,"`x'`y' " ,"`x'`y'th ",.)
replace labelclean=subinstr(labelclean,"`x'`y'st " ,"`x'`y'th ",.)
replace labelclean=subinstr(labelclean,"`x'`y'nd " ,"`x'`y'th ",.)
}
}


replace labelclean=subinstr(labelclean,"Gainsville","Gainesville",.)
replace labelclean=subinstr(labelclean,"Miami-Dade","Miami Dade",.)
replace labelclean=subinstr(labelclean," Manatee "," Manatee",.)
replace labelclean=subinstr(labelclean," Sarasota "," Sarasota",.)
replace labelclean=subinstr(labelclean," Program","",.)
replace labelclean=subinstr(labelclean,"16th Circuit-A Postive Step","16th Circuit-APS",.)

* get rid of non-AMI Post Commitment program
gen AMI=regexm(labelclean,"AMI")
drop if AMI==0 & PCP03==1

* get rid of programs which don't show up as day programs
drop ones
gen ones=1
bysort labelclean: egen totalz=total(ones)
bysort labelclean: egen totalday=total(day)
gen percday=totalday/totalz
drop if percday==0
drop ones totalz totalday percday

* gen label factor variable
encode labelclean, gen(labelfac61)

