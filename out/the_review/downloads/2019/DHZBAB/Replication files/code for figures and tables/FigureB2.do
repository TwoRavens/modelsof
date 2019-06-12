* create petition counts by year
use ILPAdataset, clear
tempfile petitions
egen id=fill(1 2 3)
collapse (count) id if picno_pet!="", by(year_pet)
ren year_pet year
drop if year==.
ren id doc_1
save `petitions', replace

* create declaration counts by year
use ILPAdataset, clear
tempfile declarations
egen id=fill(1 2 3)
collapse (count) id if picno_decl!="", by(year_decl)
ren year_decl year
drop if year==.
ren id doc_2
save `declarations', replace

* create certificate counts by year
use ILPAdataset, clear
egen id=fill(1 2 3)
collapse (count) id if entryname_certificate!="", by(arrivalyr)
ren arrivalyr year
drop if year==.
ren id doc_3

* merge all datasets and reshape
merge 1:1 year using `petitions'
drop _merge
merge 1:1 year using `declarations'
drop _merge

foreach x in 1 2 3 {
	replace doc_`x'=0 if doc_`x'==.
}

reshape long doc_, i(year) j(doctype)
ren doc_ number

graph bar number,stack over(doctype, nolabel) over(year, label(angle(vertical) labsize(vsmall))) plotregion(style(none)) ysca(titlegap(2)) ///
		 ylabel(, nogrid labsize(small)) ytitle("Number of documents", size(small))  ///
		 asyvars bar(1,color(dknavy)) bar(2,color(emidblue)) bar(3,color(ltblue)) ///
		 legend(cols(3) size(small) label(1 "Petitions") label(2 "Declarations") label(3 "Certificates")) ///
		 
		 
		 

		 
