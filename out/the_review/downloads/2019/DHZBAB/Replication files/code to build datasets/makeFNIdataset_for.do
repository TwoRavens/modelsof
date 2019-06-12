* start from complete count 1930 census 
* datafile is very large, so only need to keep following variables: namefrst year birthyr bpl fbpl mbpl sex pernum

* keep men only
keep if sex==1 

* clean first names
split namefrst, gen(name) limit(2)
gen firstname=name1 if length(name1)>2
replace firstname=name2 if length(name2)>2&length(name1)<=2
drop name1 name2 name3 name4 name5

replace firstname=subinstr(firstname,`"""',"",.)
replace firstname=subinstr(firstname,"@","",.)
replace firstname=subinstr(firstname,"(","",.)
replace firstname=subinstr(firstname,")","",.)
replace firstname=subinstr(firstname,"*","",.)
replace firstname=subinstr(firstname,"?","",.)
drop if regexm(firstname,"\?")==1
drop if firstname=="INFANT"|firstname=="REVEREND"|firstname=="WIDOW"|firstname=="UNNAMED"|firstname==`"BABY"'|firstname==`"SWEETIE"'
drop if regexm(firstname,"MRS")==1|regexm(firstname,"---")==1

egen nameid=group(firstname)

* code nationalities
gen german=(bpl==453)
gen italian=(bpl==434)
gen irish=(bpl==414) 
gen belgian=(bpl==420) 
gen french=(bpl==421) 
gen swiss=(bpl==426) 
gen portuguese=(bpl==436) 
gen english=(bpl==410) 
gen scottish=(bpl==411) 
gen welsh=(bpl==412) 
gen danish=(bpl==400) 
gen norwegian=(bpl==404) 
gen swedish=(bpl==405) 
gen finnish=(bpl==401) 
gen austrian=(bpl==450) 
gen russian=(bpl==465)

tempfile mainfile
save `mainfile'

* compute nationality-birthyear-specific foreign name index for each major nationality
foreach nat in german italian irish belgian french swiss portuguese english scottish welsh danish norwegian swedish finnish austrian russian {
	local b `nat' 
	forval by=1850/1930 {
		use `mainfile', clear
		gen ethnic=`b'
		collapse (count) pernum (first) firstname sex if birthyr<`by', by(ethnic nameid)
		reshape wide pernum, i(nameid) j(ethnic)
		replace pernum1=0 if pernum1==.
		replace pernum0=0 if pernum0==.
	
		gen count_name=pernum0+pernum1
	
		egen count_ethnic=total(pernum1)
		egen count_nonethnic=total(pernum0)
	
		ren pernum0 count_name_nonethnic
		ren pernum1 count_name_ethnic
	
		drop if count_name<15	// drop very rare names
	
		gen pg=count_name_ethnic/count_ethnic
		gen png=count_name_nonethnic/count_nonethnic
	
		gen FNI_`b'=(pg/(pg+png))*100
	
		keep nameid firstname FNI_`b'  
		gen birthyr=`by'
		tempfile FNI_`by'_`b'
		save FNI_`by'_`b', replace
	
	}
}

* append FNIs for all birthyears and nationalities
use FNI_1850_german, clear
forval y=1851/1930 {
	append using FNI_`y'_german
}
foreach bp in italian irish belgian french swiss portuguese english scottish welsh danish norwegian swedish finnish austrian russian {
	forval y=1850/1930 {
		append using FNI_`y'_`bp'
	}
}
collapse (firstnm) FNI_*, by(firstname birthyr)
save FNIall, replace

* load 1930 complete count

* for this part of the code only need second generation immigrants 
keep if nativity==2|nativity==3|nativity==4

* keep men
keep if sex==1

* clean first names, same procedure as above
split namefrst, gen(name) limit(2)
gen firstname=name1 if length(name1)>2
replace firstname=name2 if length(name2)>2&length(name1)<=2
drop name1 name2 name3 name4 name5

replace firstname=subinstr(firstname,`"""',"",.)
replace firstname=subinstr(firstname,"@","",.)
replace firstname=subinstr(firstname,"(","",.)
replace firstname=subinstr(firstname,")","",.)
replace firstname=subinstr(firstname,"*","",.)
replace firstname=subinstr(firstname,"?","",.)
drop if regexm(firstname,"\?")==1
drop if firstname=="INFANT"|firstname=="REVEREND"|firstname=="WIDOW"|firstname=="UNNAMED"|firstname==`"BABY"'|firstname==`"SWEETIE"'
drop if regexm(firstname,"MRS")==1|regexm(firstname,"---")==1

egen nameid=group(firstname)

* merge with FNI by firstname and birthyr
merge m:1 firstname birthyr using FNIall
keep if _merge==3
drop _merge

* code nationalities based on father's birthplace
gen german=(bpl==453|fbpl==453)
gen italian=(bpl==434|fbpl==434)
gen irish=(bpl==414|fbpl==414) 
gen belgian=(bpl==420|fbpl==420) 
gen french=(bpl==421|fbpl==421) 
gen swiss=(bpl==426|fbpl==426) 
gen portuguese=(bpl==436|fbpl==436) 
gen english=(bpl==410|fbpl==410) 
gen scottish=(bpl==411|fbpl==411) 
gen welsh=(bpl==412|fbpl==412) 
gen danish=(bpl==400|fbpl==400) 
gen norwegian=(bpl==404|fbpl==404) 
gen swedish=(bpl==405|fbpl==405) 
gen finnish=(bpl==401|fbpl==401) 
gen austrian=(bpl==450|fbpl==450) 
gen russian=(bpl==465|fbpl==465)

* for nantionality fixed effects in regressions
gen ethnicgroup=1 if german==1
replace ethnicgroup=2 if italian==1
replace ethnicgroup=3 if irish==1
replace ethnicgroup=4 if belgian==1
replace ethnicgroup=5 if french==1
replace ethnicgroup=6 if swiss==1
replace ethnicgroup=7 if portuguese==1
replace ethnicgroup=8 if english==1
replace ethnicgroup=9 if scottish==1
replace ethnicgroup=10 if welsh==1
replace ethnicgroup=11 if danish==1
replace ethnicgroup=12 if norwegian==1
replace ethnicgroup=13 if swedish==1
replace ethnicgroup=14 if finnish==1
replace ethnicgroup=15 if austrian==1
replace ethnicgroup=16 if russian==1

* collapse all nationality-specific FNIs into one variable
gen FNI=.
foreach b in german italian irish belgian french swiss portuguese english scottish welsh danish norwegian swedish finnish austrian russian   {
	replace FNI=FNI_`b' if `b'==1
	drop FNI_`b'
}

* drop cases with missing first name
drop if firstname==""

* keep those born in US, 1880 or later
keep if german==1|italian==1|irish==1|belgian==1|french==1|swiss==1|portuguese==1| ///
	english==1| scottish==1| welsh==1| danish==1| norwegian==1| swedish==1| ///
	finnish==1| austrian==1| russian==1
keep if bpl<100&birthyr>=1880

save FNIdataset_for, replace
