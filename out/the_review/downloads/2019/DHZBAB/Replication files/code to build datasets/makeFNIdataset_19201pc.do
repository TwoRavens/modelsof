clear all
tempfile mainfile full

*-------------------------------------------------------------------------------
* Use as input the appended 1920 1% and 1930 5% IPUMS datasets
*-------------------------------------------------------------------------------

*keep men
keep if sex==1

* clean first names
split namefrst, gen(name)
gen firstname=name1 if length(name1)>2
replace firstname=name2 if length(name2)>2&length(name1)<=2
drop name1 name2 name3 name4 name5

replace firstname=subinstr(firstname,`"""',"",.)
replace firstname=subinstr(firstname,"@","",.)
replace firstname=subinstr(firstname,"(","",.)
replace firstname=subinstr(firstname,")","",.)
replace firstname=subinstr(firstname,"*","",.)
replace firstname=subinstr(firstname,"?","",.)
drop if firstname=="INFANT"|firstname=="REVEREND"|firstname=="UNNAMED"|firstname==`"BABY"'
drop if regexm(firstname,"MRS")==1|regexm(firstname,"---")==1

egen nameid=group(firstname)

gen birthyear=year-age

* identify Germans
gen german=(bpl==453|fbpl==453|mbpl==453)

save `full', replace

egen total=count(pernum)

save `mainfile', replace

* compute birthyear-specific foreign name index (German name index, GNI) for Germans
forval by=1850/1930 {
	use `mainfile', clear
	collapse (count) pernum (first) firstname sex if birthyear<`by', by(german nameid)
	reshape wide pernum, i(nameid) j(german)
	replace pernum1=0 if pernum1==.
	replace pernum0=0 if pernum0==.

	gen count_name=pernum0+pernum1

	egen count_germans=total(pernum1)
	egen count_nongermans=total(pernum0)

	ren pernum0 count_name_nongermans
	ren pernum1 count_name_germans

	drop if count_name<15

	gen pg=count_name_germans/count_germans
	gen png=count_name_nongermans/count_nongermans

	gen GNI=(pg/(pg+png))*100

	keep nameid firstname GNI sex
	gen birthyear=`by'
	tempfile GNI_`by'
	save `GNI_`by'', replace
}


* append GNIs for all birthyears and nationalities
use `GNI_1850', clear
forval y=1851/1930 {
	append using `GNI_`y''
}

* merge with original dataset contaning additional variables
merge 1:m firstname birthyear using `full'
drop if _merge==1
drop _merge

* keep Germans born in US, 1880 or later
keep if german==1&bpl<100&birthyear>=1880

save FNIdataset_19201pc, replace
