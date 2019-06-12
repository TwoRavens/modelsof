	
***First define the income percentiles for 1979in the whole population	
clear

odbc load, exec("select p_id=LopNr_PersonNr, income=DISPINK_79 from IoT_1979") dsn("P0624") clear
gen year =1979

*Add data on birthyear and sex
joinby p_id using "Birthyear_sex.dta" , unmatched(master)
	 
ren FodelseAr birthyear /* trim non-eligible persons from the population */
gen age = year-birthyear
drop if age<18
count
ren Kon sex
		
	


	
* compute population percentiles by gender and birthyear
	
bysort birthyear sex: egen p1 = pctile(income), p(1)
				
forvalues n = 2(1)99 {		
	bysort birthyear sex: egen p`n' = pctile(income), p(`n')						
}
		*
bysort birthyear sex: egen p100 = max(income)

***collapse data to the level of birthyear and sex	
collapse (max) p*, by(birthyear sex year) 
		
	
save inc_pct_1979 replace

* reload data on incomes in 1979	
clear

odbc load, exec("select p_id=LopNr_PersonNr, income=DISPINK_79 from IoT_1979") dsn("P0624") clear
gen year =1979

*merge data on childrens id
joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\parents_long.dta", unmatched(none)

*merge data on birth year and sex
joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta" , unmatched(master)
	 
ren FodelseAr birthyear /* trim non-eligible persons from the population */
gen age = year-birthyear
drop if age<18
ren Kon sex
drop _merge

*add data on income percentile
joinby birthyear sex year using "inc_pct_1979.dta", unmatched(master) 
gen parpct = .

* Assign individuals to income percentiles
replace parpct = 1 if income <= p1  & income!=.
		
forvalues n = 2(1)100 {			
	local i=`n'-1
	replace parpct = `n' if income <= p`n' & income>p`i' & income!=.
				
}
ren parpct parpct_
		
keep parpct  year parent pol_id

duplicates drop  year  parent pol_id, force

**reshapre the data in such a way that we hace seperate variables for each mother and fater, makking the child the unit of observation
reshape wide parpct_, i(year pol_id) j(parent) string
	
ren pol_id p_id
save "Parents income 1979.dta", replace
	
		
		
		
		
	
	
 