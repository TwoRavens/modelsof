*****************************************************
** Data Preperation BJPS Aaldering and Van der Pas **
*****************************************************

net install scheme_tufte.pkg
net install st0085_2.pkg
ssc inst egenmore	

use "...\Replication File - Content Analysis Data.dta", clear

* deleting empty observation 
drop if name_fileid=="NA"
rename name_fileid DisplayName

* Recode visibility and namecount
assert namecount!=. & visibility==. |  namecount==. & visibility!=.
replace visibility = namecount if visibility==.
order visibility, before(crapos)
drop namecount

* Distinguishing between Ministers and Leaders
gen function = 1
replace function = 0 if regex(leader,"Balkenende")
replace function = 0 if regex(leader,"Buma") 
replace function = 0 if regex(leader,"Verhagen") 
replace function = 0 if regex(leader,"Bos") 
replace function = 0 if regex(leader,"Cohen") 
replace function = 0 if regex(leader,"Samsom") 
replace function = 0 if regex(leader,"Zalm")
replace function = 0 if regex(leader,"Rutte") 
replace function = 0 if regex(leader,"Marijnissen") 
replace function = 0 if regex(leader,"Kant") 
replace function = 0 if regex(leader,"Roemer") 
replace function = 0 if regex(leader,"Halsema") 
replace function = 0 if regex(leader,"Sap") 
replace function = 0 if regex(leader,"Rouvoet") 
replace function = 0 if regex(leader,"Slob") 
replace function = 0 if regex(leader,"Pechtold") 
replace function = 0 if regex(leader,"Vlies") 
replace function = 0 if regex(leader,"Staaij") 
replace function = 0 if regex(leader,"Thieme") 
replace function = 0 if regex(leader,"Wilders") 
replace function = 0 if regex(leader,"Verdonk") 
label define funct 0 "leader" 1 "minister"
label values function funct
encode leader, gen(politici)

* Correction: Van der Vlies and Van der Staaij
replace leader = "Van der Vlies" if regex(leader,"Vlies")
replace leader = "Van der Staaij" if regex(leader,"Staaij")

* Combining with metadata
merge m:1 DisplayName using "...\Replication File - Meta Data.dta", keep(matched) nogen	
// the articles that do not have metadata are being excluded (6527 articles, while we have 366295 articles that can be matched)

duplicates drop 					
rename DATUM date
drop if date==.
drop month day year yq ym yw newspaper Geldigkrant
rename newspapergoed newspaper

*** Selection of correct period and function for each politician 
drop if regex(leader,"Balkenende") & date>td(14oct2010)
drop if regex(leader,"Buma") & date<td(12oct2010)
drop if regex(leader,"Verhagen") & date<td(22feb2007)
replace function=1 if date>=td(22feb2007) & date<=td(14oct2010) & regex(leader,"Verhagen")
drop if regex(leader,"Bos") & date>td(25apr2010)
drop if regex(leader,"Cohen") & (date<td(25apr2010) | date>td(20feb2012))
drop if regex(leader,"Samsom") & date<td(16mar2012)
drop if regex(leader,"Zalm") & date>td(22feb2007)
drop if regex(leader,"Marijn") & date>td(17jun2008)
drop if regex(leader,"Kant") & (date<td(20jun2008) | date>td(04mar2010))
drop if regex(leader,"Roemer") & date<td(05mar2010)
drop if regex(leader,"Halsema") & date>td(17dec2010)
drop if regex(leader,"Sap") & date<td(17dec2010)
drop if regex(leader,"Rouvoet") & date>td(14may2011)
drop if regex(leader,"Slob") & date<td(14may2011)
drop if regex(leader,"Vlies") & date>td(14may2011)
drop if regex(leader,"Staaij") & date<td(27mar2010)
drop if regex(leader,"Verdonk") & ((date>td(22feb2007) & date<td(17oct2007))|(date>td(10jun2010)) )
replace function=1 if date<=td(22feb2007) & regex(leader,"Verdonk")

drop if regex(leader,"Ballin") & (date<td(22sep2006) | date>td(14oct2010))
drop if regex(leader,"Bot") & date>td(22feb2007)
drop if regex(leader,"Cramer") & (date<td(22feb2007) | date>td(23feb2010))
drop if regex(leader,"Jager") & date<td(23feb2010)
drop if regex(leader,"Dekker") & date>td(21sep2006)
drop if regex(leader,"Donner") & ((date>td(21sep2006) & date<td(22feb2007)) | (date>td(16dec2011)) ) 
drop if regex(leader,"Eurlings") & (date<td(22feb2007) | date>td(14oct2010))
drop if regex(leader,"Geus") & date>td(22feb2007)
drop if regex(leader,"Hillen") & date<td(14oct2010)
drop if regex(leader,"Hoogervorst") & date>td(22feb2007)
drop if regex(leader,"Huizinga") & (date<td(23feb2010) | date>td(14oct2010))
drop if regex(leader,"Kamp") & (date>td(22feb2007) & date<td(14oct2010))
drop if regex(leader,"Klink") & (date<td(22feb2007) | date>td(14oct2010) )
drop if regex(leader,"Koender") & (date<td(22feb2007) | date> td(23feb2010))
drop if regex(leader,"Leers") & date<td(14oct2010)
drop if regex(leader,"Nicolai") & date>td(22feb2007)
drop if regex(leader,"Opstelten") & date<td(14oct2010)
drop if regex(leader,"Peijs") & date>td(22feb2007)
drop if regex(leader,"Plasterk") & (date<td(22feb2007) | date>td(23feb2010) )
drop if regex(leader,"Remkes") & date>td(22feb2007)
drop if regex(leader,"Rosenthal") & date<td(14oct2010)
drop if regex(leader,"Schippers") & date<td(14oct2010)
drop if regex(leader,"Schultz") & date<td(14oct2010)
drop if regex(leader,"Spies") & date<td(16dec2011)
drop if regex(leader,"Horst") & (date<td(22feb2007) | date> td(23feb2010))
drop if regex(leader,"Ardenne") & date>td(22feb2007)
drop if regex(leader,"Bijsterveldt") & date<td(14oct2010)
drop if regex(leader,"Hoeven") & date>td(14oct2010)
drop if regex(leader,"Laan") & (date<td(14nov2008) | date>td(23feb2010) )
drop if regex(leader,"Middelkoop") & (date<td(22feb2007) | date>td(14oct2010) )
drop if regex(leader,"Veerman") & date>td(22feb2007)
drop if regex(leader,"Verburg") & (date<td(22feb2007) | date>td(14oct2010) )
drop if regex(leader,"Vogelaar") & (date<td(22feb2007) | date>td(14nov2008) )
drop if regex(leader,"Wijn") & date>td(22feb2007)
drop if regex(leader,"Winsemius") & (date<td(22sep2006) | date>td(22feb2007) )

* Add political experience and budget minimsters
gen shortname = lower(word(leader,-1))
replace shortname="nicolaï" if shortname=="nicolai"
replace shortname="haegen" if shortname=="schultz"
gen month = mofd(date)
gen week = wofd(date)
format month %tm
format week %tw
merge m:1 shortname month using "...\Replication File - Minister Experience and Budget.dta"

drop if _merge==2

* Code partysize
capture drop partysize
gen partysize=.

*CDA
qui replace partysize=44 if regex(leader,"Balkenende") & date<td(23nov2006)
qui replace partysize=41 if regex(leader,"Balkenende") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=21 if regex(leader,"Balkenende") & date>td(09jun2010)
qui replace partysize=44 if regex(leader,"Buma") & date<td(23nov2006)
qui replace partysize=41 if regex(leader,"Buma") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=21 if regex(leader,"Buma") & date>td(09jun2010)
qui replace partysize=44 if regex(leader,"Verhagen") & date<td(23nov2006)
qui replace partysize=41 if regex(leader,"Verhagen") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=21 if regex(leader,"Verhagen") & date>td(09jun2010)
  
*PVDA   
qui replace partysize=42 if regex(leader,"Bos") & date<td(23nov2006)
qui replace partysize=33 if regex(leader,"Bos") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=30 if regex(leader,"Bos") & date>td(09jun2010)
qui replace partysize=42 if regex(leader,"Cohen") & date<td(23nov2006)
qui replace partysize=33 if regex(leader,"Cohen") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=30 if regex(leader,"Cohen") & date>td(09jun2010)
qui replace partysize=42 if regex(leader,"Samsom") & date<td(23nov2006)
qui replace partysize=33 if regex(leader,"Samsom") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=30 if regex(leader,"Samsom") & date>td(09jun2010)
  
*VVD    
qui replace partysize=28 if regex(leader,"Rutte") & date<td(23nov2006)
qui replace partysize=22 if regex(leader,"Rutte") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=31 if regex(leader,"Rutte") & date>td(09jun2010)
qui replace partysize=28 if regex(leader,"Zalm") & date<td(23nov2006)
qui replace partysize=22 if regex(leader,"Zalm") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=31 if regex(leader,"Zalm") & date>td(09jun2010)
  
*SP     
qui replace partysize=9  if regex(leader,"Marijnissen") & date<td(23nov2006)
qui replace partysize=25 if regex(leader,"Marijnissen") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=15 if regex(leader,"Marijnissen") & date>td(09jun2010)
qui replace partysize=9  if regex(leader,"Kant") & date<td(23nov2006)
qui replace partysize=25 if regex(leader,"Kant") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=15 if regex(leader,"Kant") & date>td(09jun2010)
qui replace partysize=9  if regex(leader,"Roemer") & date<td(23nov2006)
qui replace partysize=25 if regex(leader,"Roemer") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=15 if regex(leader,"Roemer") & date>td(09jun2010)
  
*GL     
qui replace partysize=8  if regex(leader,"Halsema") & date<td(23nov2006)
qui replace partysize=7  if regex(leader,"Halsema") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=10 if regex(leader,"Halsema") & date>td(09jun2010)
qui replace partysize=8  if regex(leader,"Sap") & date<td(23nov2006)
qui replace partysize=7  if regex(leader,"Sap") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=10 if regex(leader,"Sap") & date>td(09jun2010)
                            
*D66                        
qui replace partysize=6  if regex(leader,"Pechtold") & date<td(23nov2006)
qui replace partysize=3  if regex(leader,"Pechtold") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=10 if regex(leader,"Pechtold") & date>td(09jun2010)
                            
*CU                         
qui replace partysize=3  if regex(leader,"Rouvoet") & date<td(23nov2006)
qui replace partysize=6  if regex(leader,"Rouvoet") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=5  if regex(leader,"Rouvoet") & date>td(09jun2010)
qui replace partysize=3  if regex(leader,"Slob") & date<td(23nov2006)
qui replace partysize=6  if regex(leader,"Slob") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=5  if regex(leader,"Slob") & date>td(09jun2010)
                            
*SGP                        
qui replace partysize=2  if regex(leader,"Vlies") & date<td(23nov2006)
qui replace partysize=2  if regex(leader,"Vlies") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=2  if regex(leader,"Vlies") & date>td(09jun2010)
qui replace partysize=2  if regex(leader,"Staaij") & date<td(23nov2006)
qui replace partysize=2  if regex(leader,"Staaij") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=2  if regex(leader,"Staaij") & date>td(09jun2010)
  
*PVDD   
qui replace partysize=0  if regex(leader,"Thieme") & date<td(23nov2006)
qui replace partysize=2  if regex(leader,"Thieme") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=2  if regex(leader,"Thieme") & date>td(09jun2010)
  
*PVV    
qui replace partysize=0  if regex(leader,"Wilders") & date<td(23nov2006)
qui replace partysize=9  if regex(leader,"Wilders") & date>td(22nov2006) & date<td(10jun2010)
qui replace partysize=24 if regex(leader,"Wilders") & date>td(09jun2010)

*TON
qui replace partysize=1 if regex(leader,"Verdonk") & date>td(17oct2007) & date<td(10jun2010)
* Verdonk vertekent statistiek met veel aandacht in media en officieel maar 1 zetel, daarom hier gemiddelde aantal zetels over periode in peilingen van Peil.nl
qui replace partysize=8 if regex(leader,"Verdonk") & date>td(17oct2007) & date<td(10jun2010)

* recode double function
recode doublefunction (.=0)
replace function = 2 if doublefunction==1

* gender party leaders
replace gender = "f" if regex(leader,"Sap") |  regex(leader,"Verdonk") | regex(leader,"Halsema") | regex(leader,"Kant") | regex(leader,"Thieme") | regex(leader,"Cramer")  | regex(leader,"Huizinga") | regex(leader,"Schultz") | regex(leader,"Spies") | regex(leader,"Horst") | regex(leader,"Hoeven") | regex(leader,"Verburg") | regex(leader,"Vogelaar")
replace gender = "m" if regex(leader,"Vlies") | regex(leader,"Bos") | regex(leader,"Buma") | regex(leader,"Cohen") | regex(leader,"Jager") | regex(leader,"Ballin") | regex(leader,"Donner")  | regex(leader,"Eurlings") | regex(leader,"Klink") | regex(leader,"Koenders") | regex(leader,"Leers") | regex(leader,"Marijnissen") | regex(leader,"Pechtold") | regex(leader,"Plasterk") | regex(leader,"Roemer") | regex(leader,"Rouvoet") | regex(leader,"Rutte") | regex(leader,"Samsom") | regex(leader,"Slob") | regex(leader,"Middelkoop") | regex(leader,"Wilders") | regex(leader,"Winsemius") | regex(leader,"Verhagen") | regex(leader,"Staaij")

* tota of traits
egen totpos = rowtotal(*pos)
egen totneg = rowtotal(*neg)

* total per trait
egen polcraftotaal = rowtotal(cra*)
egen vigtotaal = rowtotal(vig*)
egen inttotaal = rowtotal(int*)
egen commtotaal = rowtotal(com*)
egen contotaal = rowtotal(con*)

** Descriptive information on content analysis
egen totalvis = total(visibility)
tab totalvis

egen totaltotal1 = rowtotal(totpos totneg)
egen totaltotal2 = total (totaltotal1)
tab totaltotal2

* campaign period
gen campaign = 0
replace campaign = 1 if (date>=(td(12sep2012)-28) & date<=td(12sep2012))
replace campaign = 1 if (date>=(td(09jun2010)-28) & date<=td(09jun2010))
replace campaign = 1 if (date>=(td(22nov2006)-28) & date<=td(22nov2006))

save "...\Replication File 3 - Aaldering and Van der Pas - BJPS (article level).dta", replace

* Collapse to weeks
collapse (sum) mentions=visibility (count) visibility=visibility (mean) crapos craneg vigpos vigneg intpos intneg compos comneg conpos conneg totpos totneg polcraftotaal vigtotaal inttotaal commtotaal contotaal totaltotal1 ministry_none expenditure revenu total expenditure_recode revenu_recode total_recode experience_mpyears experience_juniormin experience_seniormin experience_leader doublefunction function partysize (first) gender minister_specifics ministry_acronym cabinet month week campaign, by(date leader)
collapse (mean) visibility mentions crapos craneg vigpos vigneg intpos intneg compos comneg conpos conneg totpos totneg polcraftotaal vigtotaal inttotaal commtotaal contotaal totaltotal1 ministry_none expenditure revenu total expenditure_recode revenu_recode total_recode experience_mpyears experience_juniormin experience_seniormin experience_leader doublefunction function partysize (first) gender minister_specifics ministry_acronym cabinet campaign, by(week leader)

recode function doublefunction (0/.49999999999=0) (.5/1.499999999=1) (1.5/2=2)
drop if leader==""
gen sex = 0 if gender=="m"
replace sex = 1 if gender!="m"
label define sexes 1 "Female" 0 "Male"
label values sex sexes
encode leader, gen(leadernr)
xtset leadernr week

* units for dependent variables: number of articles per week, traits %
replace visibility = visibility * (365/52)
foreach trait of varlist crapos craneg vigpos vigneg intpos intneg compos comneg conpos conneg totpos totneg polcraftotaal vigtotaal inttotaal commtotaal contotaal totaltotal1 {
	replace `trait' = `trait'*100
}

save "...\Replication File 2 - Aaldering and Van der Pas - BJPS (main analyses).dta", replace


