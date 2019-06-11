
clear
	*set mem 2g
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"

***create income file for fill population
odbc load, exec("select  ink=DispInk,  p_id=Person_LopNr from P0624_Lisa_2003") dsn("P0624") clear
gen year=2003
save temp, replace
odbc load, exec("select  ink=DispInk04,  p_id=Person_LopNr from P0624_Lisa_2007") dsn("P0624") clear
gen year=2007
append using temp
save temp, replace

odbc load, exec("select ink=DispInk04,  p_id=Person_LopNr from P0624_Lisa_2011") dsn("P0624") clear
gen year=2011
append using temp

save income_2003_2011, replace
		
*load data on siblings	
odbc load, exec("select * from BioSyskon") dsn("P0624") clear
*keep only siblings with the same mother and fatehr
keep if Syskon=="Helsyskon"
		
ren LopNr p_id 
*generate family id
egen fam_id= group(p_id)

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
*match with politician data. Note that we only keep data for those htat have a sibling
joinby p_id  using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(none)
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
*discard all years but the first in the election period
keep if year==electionyear+1
keep p_id LopNr_BioSyskon Syskontyp electionyear elected   fam_id
*only keep municipal politicians lected in 2002 2006 and 2010
keep if elected==1 & (electionyear==2002|electionyear==2006|electionyear==2010)
*give each sibling of a politicians a number starting at 1
bysort p_id electionyear: egen rank=rank (LopNr_Bio)

*reshape the data into wide form, each sibling of a politicians has its own variable number
reshape wide LopNr_BioSyskon@, j(rank) i(p_id electionyear)

* the politician is given an id number with rank 0	
gen LopNr_BioSyskon0= p_id 

*reshape the data set so that each individual in the data set has its own identifier	 
reshape long  LopNr_BioSyskon@, j(rank) i(p_id  electionyear)
		
drop elected p_id Syskontyp rank
	
	
ren LopNr_BioSysko p_id
keep if p_id!=.
*drop duplicates so that each inidiviual only appears once everyyear
duplicates drop  p_id electionyear, force
		
*join data on whose elected so that we know who the politicians are
joinby p_id electionyear using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\elected 1991-2010.dta", unmatched(master)

*add data on birthyear and sex
 joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(none)

ren Fodelse birthyear
ren Kon sex
	
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
replace year=electionyear+1
*add income data
joinby p_id year  using "income_2003_2011", unmatched(master)
drop _merge
*add data on income percentiles
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
joinby birthyear sex year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\inc_pct_panel sex birthyear 1990-2012.dta", unmatched(master) _merge(_merge)
drop _merge

*assign each individual to an income percentile	
gen polpct = .
forvalues n = 2(1)100 {
	local i=`n'-1
	replace polpct = `n' if ink <= p`n' & ink>p`i' & ink!=.					
}
			

replace polpct = 1 if ink<=p1
drop p1-p100

*make the histograms
			
histogram polpct if elected==1,  width(5) start(0) title(Elected Politicians)  xtitle(Income Percentile)  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(, angle(horizontal))

graph save hist_elected, replace

histogram polpct if  elected!=1 ,  width(5) start(0) title(Siblings of Elected Politicians) xtitle(Income Percentile)  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(, angle(horizontal))

graph save hist_sib_elected, replace

**Now repeat the process for mayors
odbc load, exec("select * from BioSyskon") dsn("P0624") clear
 keep if Syskon=="Helsyskon"
		
ren LopNr p_id 
egen fam_id= group(p_id)

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
joinby p_id  using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(none)
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
keep if year==electionyear+1
keep p_id LopNr_BioSyskon Syskontyp electionyear chair   fam_id

keep if chair==1 &  (electionyear==2002|electionyear==2006|electionyear==2010)
bysort p_id electionyear: egen rank=rank (LopNr_Bio  )

reshape wide LopNr_BioSyskon@, j(rank) i(p_id electionyear)

gen LopNr_BioSyskon0= p_id 
reshape long  LopNr_BioSyskon@, j(rank) i(p_id  electionyear)
		
drop p_id Syskontyp rank
ren LopNr_BioSysko p_id
 keep if p_id!=.
duplicates drop  p_id electionyear, force
joinby p_id electionyear using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\elected 1991-2010.dta", unmatched(master)
joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(none)
ren Fodelse birthyear
ren Kon sex
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
replace year=electionyear+1
joinby p_id year  using "income_2003_2011", unmatched(master)
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
joinby birthyear sex year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\inc_pct_panel sex birthyear 1990-2012.dta", unmatched(master) _merge(_merge)
drop _merge
			
joinby birthyear sex using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\income percentiles 2011.dta", unmatched(master) _merge(_merge)

gen polpct = .
forvalues n = 2(1)100 {
	local i=`n'-1
	replace polpct = `n' if ink <= p`n' & ink>p`i' & ink!=.
	}
			

replace polpct = 1 if ink<=p1
drop p1-p100
			
histogram polpct if elected==1,  width(5) start(0) title(Mayors)  xtitle(Income Percentile)  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(, angle(horizontal))

graph save hist_mayor, replace

histogram polpct if  elected!=1 , width(5) start(0) title(Siblings of Mayors) xtitle(Income Percentile)  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(, angle(horizontal))

graph save hist_sib_mayor, replace

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"

	
*Finally repaeat the process for parliamentarians
		
odbc load, exec("select * from BioSyskon") dsn("P0624") clear
keep if Syskon=="Helsyskon"

ren LopNr p_id 
egen fam_id= group(p_id)

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
joinby p_id  using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(none)
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
keep if year==electionyear+1
keep p_id LopNr_BioSyskon Syskontyp electionyear elected  elec_parl fam_id

keep if elec_parl==1 &   (electionyear==2002|electionyear==2006|electionyear==2010)
bysort p_id electionyear: egen rank=rank (LopNr_Bio  )
reshape wide LopNr_BioSyskon@, j(rank) i(p_id electionyear)
gen LopNr_BioSyskon0= p_id 
	 
reshape long  LopNr_BioSyskon@, j(rank) i(p_id  electionyear)
		
drop elec_parl p_id Syskontyp rank elected

ren LopNr_BioSysko p_id
keep if p_id!=.
duplicates drop  p_id electionyear, force
		
joinby p_id electionyear using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\elected parl 82_10.dta" , unmatched(master)
drop if electionyear<2000
			    
ren Fodelse birthyear
ren Kon sex
ren elec_parl elected

drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
replace year=electionyear+1
	
joinby p_id year  using "income_2003_2011", unmatched(master)
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
joinby birthyear sex year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\inc_pct_panel sex birthyear 1990-2012.dta", unmatched(master) _merge(_merge)
drop _merge
		
gen polpct = .
forvalues n = 2(1)100 {
	local i=`n'-1
	replace polpct = `n' if ink <= p`n' & ink>p`i' & ink!=.
}
replace polpct = 1 if ink<=p1
drop p1-p100
			
histogram polpct if elected==1,  width(5) start(0) title(Parliamentarians)  xtitle(Income Percentile)  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(, angle(horizontal))

graph save hist_parl, replace

histogram polpct if  elected!=1 , width(5) start(0) title(Siblings of Parliamentarians) xtitle(Income Percentile)  ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ylabel(, angle(horizontal))

graph save hist_sib_parl, replace

graph combine "hist_elected.gph" "hist_sib_elected.gph"  ///
"hist_mayor.gph" "hist_sib_mayor.gph" /// 
"hist_parl.gph" "hist_sib_parl.gph"  ///
, ycommon ysize(20) xsize(20) iscale(.6) scheme(s1mono) col(2) row(3) title("Politicians Siblings of Politicians")

		
