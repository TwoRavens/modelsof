use "POSVAR_clean.dta"

********************************************************************************
* FIGURE 1
********************************************************************************

***** calculate % countries hosting >= 10,000 refugees each year 

gen host_10k = 1 if refpop >= 10000
	replace host_10k = 0 if refpop < 10000
	codebook host_10k

bysort year: egen total_host_10k = total(host_10k) 


***** generate variable for "violence against refugees" 

* according to text, this includes:  
	* govt violence against refugees = govagainstref
	* civilian violence against refugees = civagainstref
	* NSA violence against refugees = nsaagainstref
	* terrorism against refugees = terroragainstref 
* I'm assuming I just sum these? 

gen viol_against_ref =  govagainstref + civagainstref + nsaagainstref + terroragainstref 

* create a dummy 

gen viol_against_ref_dummy = 1 if viol_against_ref !=0 
	replace viol_against_ref_dummy = 0 if viol_against_ref==0 
	
* count number of countries with any violence 

bysort year: egen num_viol_against = total(viol_against_ref_dummy)

* calculate in proportion to countries with >= 10k refugees each year 

gen prop_viol_against = 100*(num_viol_against / total_host_10k) 


***** generate variable for "violence by refugees" 
* according to text, this includes: 
	* refugee on refugee violence = refonref
	* refugee violence against civilians = refagainstciv
	* ref violence against government = refagainstgov 
	* terrorism by refugees = terrorbyref
	* refugee riots = refriot
	* ref recruitment by NSAs = nsarecruitref 
	
gen ref_viol = refonref + refagainstciv + refagainstgov + terrorbyref + refriot + nsarecruitref

* create a dummy 

gen ref_viol_dummy = 1 if ref_viol !=0 
	replace ref_viol_dummy = 0 if ref_viol==0 

* count number of countries with any violence 

bysort year: egen num_viol_by = total(ref_viol_dummy) 

* calculate in proportion to countries with >= 10k refugees each year 

gen prop_viol_by = 100*(num_viol_by / total_host_10k)
	

***** make the figure 

twoway (line prop_viol_against year, lcolor(black)) ///
		(line prop_viol_by year, lcolor(black) lpattern(dash)) ///
	,  ytitle("Percentage of countries (in %)") xtitle("Year") ///
	graphregion(fcolor(white)) ///
	legend(label(1 "Violence against refugees") label(2 "Violence by refugees")) 




********************************************************************************
* FIGURE 6 
********************************************************************************

***** generate variables 

* proportion countries with terrorism against refugees 

gen terror_against_dummy = 1 if terroragainstref !=0 
	replace terror_against_dummy = 0 if terroragainstref==0 
	
bysort year: egen num_terror_against = total(terror_against_dummy)
	
gen prop_terror_against = 100*(num_terror_against / total_host_10k) 

* proportion countries with terrorism by refugees 
	
gen terror_by_dummy = 1 if terrorbyref !=0
	replace terror_by_dummy = 0 if terrorbyref==0 
	
bysort year: egen num_terror_by = total(terror_by_dummy)
	
gen prop_terror_by = 100*(num_terror_by / total_host_10k) 

***** make the figure 

twoway (line prop_terror_against year, lcolor(black)) ///
		(line prop_terror_by year, lcolor(black) lpattern(dash)) ///
	,  ytitle("Percentage of countries (in %)") xtitle("Year") ///
	graphregion(fcolor(white)) ///
	legend(label(1 "Terrorism against refugees") label(2 "Terrorism by refugees")) 




********************************************************************************
* FIGURE 8 
********************************************************************************

* anti-refugee gov violence (govagainstref)
* anti-refugee civ violence (civagainstref) 

***** generate variables 

* proportion countries with gov violence against refugees 

gen govagainstref_dummy = 1 if govagainstref !=0 
	replace govagainstref_dummy = 0 if govagainstref==0 
	
bysort year: egen num_govagainstref = total(govagainstref_dummy)
	
gen prop_govagainstref = 100*(num_govagainstref / total_host_10k) 

* proportion countries with civ violence against refugees 

gen civagainstref_dummy = 1 if civagainstref !=0 
	replace civagainstref_dummy = 0 if civagainstref==0 
	
bysort year: egen num_civagainstref = total(civagainstref_dummy)
	
gen prop_civagainstref = 100*(num_civagainstref / total_host_10k)
 

***** make the figure 

twoway (line prop_govagainstref year, lcolor(black)) ///
		(line prop_civagainstref year, lcolor(black) lpattern(dash)) ///
	,  ytitle("Percentage of countries (in %)") xtitle("Year") ///
	graphregion(fcolor(white)) ///
	legend(label(1 "Government violence") label(2 "Civilian violence")) 
