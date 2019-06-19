	clear all
	set more off
	set mem 1g

	
	Creates: Table 1, 2, 3, 4, 5, and 6, as well as Figure 1 and 2
	For detailed variable and source descriptions, see the Data Appendix
	Public-domain data is in city_geo_data.dta  

	global path1 "C:\Shops"
	cd "$path1"

	*************************************************
	** CREATE RADIUS DATA 
	*************************************************

	* Prep 2 mi Radius Data
	tempfile data_in_progress
	save `data_in_progress', replace emptyok

	foreach x in beds book dept elec {
	di "`x'"
	use "collapsed\`x'_within2.dta",clear
	renvars  sum_number* sum_sales_vol*, subst("sum_" "")
	keep min_id_l store year defunct sales_vol* number_emp*  numstores*
	destring min_id_l, replace
	append using `data_in_progress'
	duplicates drop
	save `data_in_progress',replace
	}

	
	*********************************
	* Prep 3 Mi Stuff
	*********************************
	u "collapsed\pool_within3.dta", clear
	destring min_id_l year, replace
	keep min_id_l year  number_emp sales_vol numstores store
	renvars  number_emp sales_vol numstores \ number_emp_3 sales_vol_3 numstores_3
	sort min_id_l year
	merge 1:1 min_id_l year using `data_in_progress', nogen
	save `data_in_progress', replace

	***************
	* 2003 Data
	u "pre_data\2003data",clear
	sort min_id_l
	append using `data_in_progress'
	
	*************************************
	** Create NAME FILTER ****************
	*************************************

	* Drop Stores Captured in Error
	#delimit ;
	local filter_terms "AIRPORT ARCHIVES ACCOUNTING SALON CARPET CONSTRUCTION CRICKET CUSTOM DEBRA DIST ENERGY FINAN FLOOR FULFILLMENT FURNI JUNIOR MOBILE
	 MACONEE OUTLET PORTRAIT REGION REALTY ROAD SVC SERVICE TELEMARKETING WALDEN";
	#delimit cr

	foreach x in `filter_terms' {
	drop if strpos(coname,"`x'")>0
	}

	* Create Store Labels
	g       store="compusa"  if coname=="COMPUSA" | coname=="COMP USA" | coname=="COMP USA INC"| coname=="COMPUSA INC"
	replace store="mervyn"   if coname=="MERVYNS"| coname=="MERVYN'S" | strpos(coname,"MERVYN")>0
	replace store="linens"   if strpos(coname,"LINEN")>0 & strpos(coname,"THING")>0
	replace store="kohls"    if coname=="KOHL'S"| coname=="KOHL'S DEPARTMENT STORE"
	replace store="circuit"  if coname=="CIRCUIT CITY" | strpos(coname,"CIRCUIT CITY")>0
	replace store="borders"  if strpos(coname,"BORDERS")>0 
	replace store="bestbuy"  if coname=="BEST BUY" | strpos(coname,"BESTBUY")>0 | strpos(coname,"BEST BUY")>0
	replace store="bedbath"  if strpos(coname,"BED BATH & BEYOND")>0 | coname=="BEB BATH & BEYOND" | coname=="BETH BATH & BEYOND"
	replace store="barnes"   if strpos(coname,"BARNES & NOBLE")>0  | strpos(coname,"BARNES NOBLE")>0 
	replace store="jcpenney" if strpos(coname,"J C PENNEY")>0
	drop if store==""
	
		
	* Create Comparable Set of Geographic Locations for Department Stores
	levelsof state if store="mervyn", local(dept_state)
	g to_drop=0
	replace to_drop=1 if  (store=="kohls"|store=="jcpenney"|store=="mervyn") 
	foreach x in `dept_state' {
	replace to_drop=0 if  (store=="kohls"|store=="jcpenney"|store=="mervyn")  & state=="`x'"
	}
	drop if to_drop==1
	drop to_drop

	* Create Defunct Var
	g defunct=0
	replace defunct =1 if store=="circuit"|store=="compusa"|store=="borders"|store=="mervyns"|store=="linens" 
	
	* Create Store Type Var
	g type="book"	    if store=="borders" | store=="barnes"
	replace type="elec" if store=="circuit"|store=="compusa"|store=="bestbuy"
	replace type="dept" if store=="kohls"|store=="mervyns" | store=="jcpenney"
	replace type="bath" if store=="linens"|store=="bedbath"
	tsset min_id_l year
	save `data_in_progress', replace


	tsset min_id_l year

     * Merge in Zip Code Data
	rename min_id_l locnum
	merge m:1 locnum using "bigbox_zipcode_data", nogen keep(match)
	rename locnum min_id_l

	******************** Data Quality Filter

	* Drop if Larger Radii Has Fewer Stores than Smaller Ones
	drop if numstores_5>numstores_1 | numstores_1>numstores_2 | numstores_2>numstores_3
	
	local l1_store_min=40
	local l1_emp_min=300
	
	* Create a Store Count for Radii in Early Years
	foreach x in 3 6 7 {
	g counter200`x'= 0
	replace counter200`x'=numstores_1 if year ==200`x'
	egen mins`x'=max(counter200`x'), by (min_id_l)
	}



	**************************************************
	** Table 1
	**************************************************

	tsset
	foreach x in 5 1 2 3 {
	g dlnstore_`x'  = ln( numstores_`x' )-ln(L.numstores_`x' )
	eststo:  areg dlnstore_`x' defunct if year==2007 & L.numstores_`x'>`l1_store_min', a(type) cl(zip)
	g dlnemp_`x'    = ln( number_emp_`x')-ln(L.number_emp_`x')
	eststo:  areg dlnemp_`x' defunct   if year==2007 & L.numstores_`x'>`l1_emp_min', a(type) cl(zip)
	}
	
	foreach x in 5 1 2 3 {
	* Adjust for  Data Format 
	qui summ numstores_`x' if year==2003, d
	local l4_store_min = r(p5)
	eststo:  areg d4lnstore_`x' defunct if year==2007 & L4.numstores_`x'>`l4_store_min' & abs(d4lnstore_`x')<`l1_store_min'/100 , a(type) cl(zip)
	
	qui summ numstores_`x' if year==2003, d
	local l4_emp_min = r(p5)
	eststo:  areg d4lnemp_`x'   defunct if year==2007 & L4.numstores_`x'>`l4_emp_min' & abs(d4lnemp_`x' )<`l1_store_min'/100 , a(type) cl(zip)
	}
	
	esttab using table1.csv, replace se star(* 0.10 ** 0.05 *** 0.01)
	
	keep if mins7>`l1_store_min' & year>=2007


*****************************************************
		* Table 2
***************************************************** 
	drop if defunct==.
	g bankrupt =0
	replace bankrupt= 1 if year>2007 & defunct==1
	replace bankrupt=0 if year<2010  & store=="borders"

	g year_since = year-2008 
	replace year_since = year-2010 if store=="borders"
	replace year_since = 0 if defunct==0
	
	egen type_year=group(year type)

	tab type_year ,g(tys)
	tab year, g(yy)
	
	eststo clear 

	
	g one=1
	egen  identy=group(zip type)
	egen total_ident=count(one), by(identy)
	g unique=total_ident==7

	local depvars_fract "25 5 1 2"
foreach x in `depvars_fract' {

	cap g lnstore`x'=ln(numstores_`x')
	cap g   lnemp`x'=ln(number_emp_`x')

	eststo: areg lnstore`x' tys* bankrupt, a(min_id_l) cl(zip)
	eststo: areg lnemp`x'   tys* bankrupt, a(min_id_l) cl(zip)
	
	eststo: reg2hdfe lnstore`x' tys*     bankrupt, id1(min_id_l) id2(zipyear) cluster(zip)
	eststo: reg2hdfe lnemp`x'   tys*     bankrupt, id1(min_id_l) id2(zipyear) cluster(zip)
	
	
	eststo: areg lnstore`x' tys* bankrupt if unique==1, a(min_id_l) cl(zip)
	eststo: areg lnemp`x'   tys* bankrupt if unique==1, a(min_id_l) cl(zip)

}
esttab using table2.csv, replace se star(* 0.10 ** 0.05 *** 0.01)
eststo clear


sort min_id_l year
merge 1:1 min_id_l year using foot_traffic_vars
egen minstores=min(numstores_`x'), by(min_id_l)
drop if minstores<30
	
foreach x in 11 21 22 23 31 33 42 44 45 48 49 51 52 53 54 55 56 61 62 71 72 81 92 99 {
replace is_a_store`x'=0 if is_a_store`x'==.
}
	
	g ln_retail = ln( is_a_store44+ is_a_store45)

	#delimit;
	g ln_defnot = ln( is_a_store11+ is_a_store21+ is_a_store22+ is_a_store23+ is_a_store31+
	is_a_store32+ is_a_store33+ is_a_store42+ is_a_store48+ is_a_store49+ is_a_store51+
	is_a_store55+is_a_store56+ is_a_store92+ is_a_store99);
	#delimit cr
	
	**************OY!!!!!****************!!!!!
	g lnNonComp = ln( numstores_no_comp_`j'+1)
	g lnComp = ln( numstores_comp_`j'+1)
	g lnEnt = ln(numstores_entrant_`j'+1)
	replace lnEnt=. if year==2006
	replace numstores_incumbent_1=numstores_incumbent_1-1 if defunct==1 & bankrupt==0
	g lnInc = ln(numstores_incumbent_`j'+1)
	replace lnInc=. if year==2006
	
	rename state place_state
	sort place_state year
	merge m:1 place_state year using "$path1\internet\internet"
	tsset
	replace HH_int_p=F.HH_int_p if year==2006
	replace HH_int_p=.5*(F.HH_int_p+L.HH_int_p) if year==2008
	egen medI=median(HH_int_p)
	g high_pen=HH_int_p>medI 
	replace high_pen=. if HH_int_p==.
	
	eststo: areg ln_retail tys* bankrupt, a(min_id_l) cl(zip)
	eststo: areg ln_defnot tys* bankrupt if ln_retail!=., a(min_id_l) cl(zip)

	eststo: areg lnNonComp tys* bankrupt, a(min_id_l) cl(zip)
	eststo: areg lnComp tys* bankrupt, a(min_id_l) cl(zip)

	eststo: areg lnEnt tys* bankrupt, a(min_id_l) cl(zip)
	eststo: areg lnInc tys* bankrupt, a(min_id_l) cl(zip)

	eststo: areg  lnstore5 tys* bankrupt if high_pen==1, a(min_id_l) cl(zip)
	eststo: areg  lnstore5 tys* bankrupt  if high_pen==0, a(min_id_l) cl(zip)

esttab using "$path1\table3.csv", replace se star(* 0.10 ** 0.05 *** 0.01)

***********************
* Figure 1
*************************
		areg lnstore1 tys* yrs1-yrs3 yrs5-yrs10 , a(min_id_l) cl(zip)
		regsave yrs1-yrs3 yrs5-yrs10 using for_es, ci replace
		save `data_in_progress', replace

		u for_es,clear
		g date=substr(var,4,length(var)-3)
		destring date, replace
		replace date=date-4
		local newobs=_N+1
		set obs `newobs'
		replace date=0 if _n==_N
		replace coef=0 if _n==_N
		replace ci_lower=0 if _n==_N
		replace ci_upper=0 if _n==_N
		sort date
		g axx=0
		#delimit ;
		twoway (rarea  ci_lower ci_upper date, color(gs14)  ) 
		(sc  coef date, mcolor(navy) xline(0, lcolor(red) lpattern(dash)))
		 (line axx date, lcolor(gs12))  ,
		 legend(off) graphregion(fcolor(white)) xlabel(-3 (1) 6)
		 xtitle("Years From Chain Closure") ytitle("Log Establishment within 1 Mile");
		 graph save figure_1, replace
 


**************************************************
use `data_in_progress',clear
rename store inprog_store
keep min_id_l year bankrupt lnstore1 lnemp1 type inprog_store defunct
rename min_id_l locnum
sort locnum year

merge m:1 locnum using "$path1\city_data\city_correspondence",nogen keep(match)
sort city16 state year
merge m:1 city16 state year using "$path1\city_data\all_city_data", nogen keep(match)

sort locnum
merge m:1 locnum using "$path1\city_data\fips_correspondence", nogen keep(match)
rename state place_state
sort  place_state place_fips

save `data_in_progress', replace

u "$path1\city_data\place_geo", clear
keep  place_state place_fips  max_length_mi perimeter_mi max_width_mi area_sqmi cxh_area
sort  place_state place_fips
merge 1:m  place_state place_fips using `data_in_progress', nogen keep(match)


**************************************************
** City Level Regressions
**************************************************
* Create Compactness Measures for Cities
		g square   =  max_width_mi *max_length_mi 
		g ratio    =  area_sqmi/square
		g pp       = 4*3.141* area_sqmi/( perimeter_mi^2)
		g reock    = area_sqmi/(3.141*0.5*max(max_width_mi,max_length_mi)^2)
		g schwartz = perimeter_mi/( 2*3.141*sqrt( area_sqmi/3.141))
		g crat     = area_sqmi/ cxh_area
		factor ratio pp reock schwartz crat, pcf
		predict compactness

g lnstore =ln(bus)
g lnemp= ln(number_emp)
egen placeid=group(place_state place_fips)

tsset locnum year
	egen type_year=group(year type)
	tab type_year ,g(tys)
	tab year, g(yy)
	

g interaction = compactness*bankrupt

foreach y in lnstore lnemp lnstore1 lnemp1{
eststo: areg `y'   tys*      bankrupt , a(locnum) cl(placeid)
eststo: areg `y'   tys*  `x' bankrupt interaction, a(locnum) cl(placeid)
}

esttab using table4.csv, replace se star(* 0.10 ** 0.05 *** 0.01)
eststo clear


*****************
* Table 5
*****************

clear all
u "$path1\city_data\place_geo",clear

g square=  max_width_mi *max_length_mi 
g ratio =  area_sqmi/square
g pp=4*3.141* area_sqmi/( perimeter_mi^2)
g reock=area_sqmi/(3.141*0.5*max(max_width_mi,max_length_mi)^2)
g schwartz=perimeter_mi/( 2*3.141*sqrt( area_sqmi/3.141))
g crat= area_sqmi/ cxh_area
factor ratio pp reock schwartz crat, pcf
predict compactness
replace compactness=. if abs(compactness)>4

sort  place_state place_fips
merge 1:m place_state place_fips using "$path1\ICMA\subsidy_all", nogen keep(match)
sort place_state place_fips
merge m:1 place_state place_fips using "$path1\city_data\demographics", nogen keep(match)
merge m:1 place_state place_fips using "$path1\msa_link\countylink", nogen keep(match)
sort place_state cnty_fips
merge m:1 place_state cnty_fips using "$path1\msa_link\csa", nogen keep(match)

egen countyid=group(cnty_fips place_state)
egen placeid=group(place_fips place_state)
replace csatitle="Non CSA"+place_state if csatitle==""



local foci "agg man ret ins res tor war tec oth"
g totalfoci=0

foreach x in `foci' {
replace totalfoci=`x'_focus+totalfoci
}

xtile popbin= pop2010, nq(10)
tab popbin, g(pbin)
replace q2cretbase=0 if q2cretbase==.

tab year, g(ydum)
cap g lninc=ln(inc2010)
cap g lnhv=ln( house_value2010)
g lndol=ln(dollars)

eststo clear
eststo: reg  q2cretfocus ydum*      					 		 compactness area_sqmi, cl(place_state) 
eststo: reg  q2cretfocus ydum*  lndol totalfoci					 compactness area_sqmi, cl(place_state)  
eststo: reg q2cretfocus  ydum*  q2cretbase salestax  			 compactness area_sqmi, cl(place_state) 
eststo: areg q2cretfocus ydum*  pbin* lnhv pover non_eng         compactness area_sqmi,a(place_state) cl(place_state)
eststo: areg q2cretfocus ydum* 				 					 compactness area_sqmi,a(csatitle) cl(place_state)
esttab using "$path1\table5.csv", replace se star(* 0.10 ** 0.05 *** 0.01)



*******


*************************************
* Mall Data 
**************************************
u ICMA/subsidy_all,clear
keep year place_state place_fips ret_focus
duplicates drop
sort place_state place_fips
tempfile a
save `a', replace

u "$path1\city_data\mall_matched, clear
rename state place_state
sort place_state place_fips
merge 1:m place_state place_fips using `a', keep(match)
tab year, g(ydum)
eststo clear
eststo: reg malldummy ydum* ret_focus,cl(place_state)


*********************************
u "$path1\city_data\place_geo",clear
replace name=upper(name)
rename name city16 
duplicates tag city16 place_state, gen(dup_tag)
drop if dup_tag>0 
drop dup_tag
sort city16 place_state
tempfile a
save `a', replace

u "$path1\city_data\malldata_distance.dta",clear
rename mallcity city16
rename mallstate place_state
replace city16=upper(city16)
sort city16 place_state
g mall =1
g mall_within2=  distance<2*1609.34
g mall_far2=  distance>=2*1609.34 
collapse (sum) mall mall_within2 mall_far2, by (city16 place_state)
sort city16 place_state
merge 1:m city16 place_state using `a', keep(2 3)
replace mall =0 if _merge==2
replace mall_within2 =0 if _merge==2
replace mall_far2 =0 if _merge==2


g malldummy = mall>0 & mall!=.
g mallwithin2dummy=mall_within2>0 
g mallfar2dummy=mall_far2>0 


drop _merge
g lnmall = ln(mall)
egen placeid=group(place_fips place_state)


g square=  max_width_mi *max_length_mi 
g ratio =  area_sqmi/square
g pp=4*3.141* area_sqmi/( perimeter_mi^2)
g reock=area_sqmi/(3.141*0.5*max(max_width_mi,max_length_mi)^2)
g schwartz=perimeter_mi/( 2*3.141*sqrt( area_sqmi/3.141))
g crat= area_sqmi/ cxh_area
factor ratio pp reock schwartz crat, pcf
predict compactness


eststo: reg  malldummy 			area_sqmi  		compactness,               		 cl(place_state)
eststo: reg  lnmall    			area_sqmi  		compactness,   	         	 	 cl(place_state)
eststo: reg  mallwithin2dummy    area_sqmi  	compactness,   	         	 	 cl(place_state)
eststo: reg  mallfar2dummy       area_sqmi  	compactness,   	         	 	 cl(place_state)
eststo: reg  lnmstore  area_sqmi  		compactness,           			  cl(place_state)

u "$path1\city_data\BID",clear
g square=  max_width_mi *max_length_mi 
g ratio =  area_sqmi/square
g pp=4*3.141* area_sqmi/( perimeter_mi^2)
g reock=area_sqmi/(3.141*0.5*max(max_width_mi,max_length_mi)^2)
g schwartz=perimeter_mi/( 2*3.141*sqrt( area_sqmi/3.141))
g crat= area_sqmi/ cxh_area
factor ratio pp reock schwartz crat, pcf
predict compactness

eststo: reg  bid area_sqmi  					compactness,               		 cl(place_state)

esttab using table6.csv, replace se star(* 0.10 ** 0.05 *** 0.01)


*******************
* Figure 2
*******************

local types "department electronics furnishings"
foreach x in `types' {
di "`x'"
use "$path1\nielsen\\`x'_monthly_storelevel.dta", clear
keep if  only_near_defunct==1 &  only_near_operating==0
egen firstmonth=min(yearmonth), by( household_id)
egen lastmonth=max(yearmonth), by( household_id)
g window=lastmonth-firstmonth
keep if window>=48  & window!=.

collapse (sum)  totalvisits, by( visited_store_on_bigbox_day yearmonth)
reshape wide  totalvisits, i(yearmonth) j(visited_store_on_bigbox_day)
g ratio= totalvisits1/( totalvisits1+ totalvisits0)
sc ratio yearmonth 
graph save total_`x', replace
}




foreach x in `types' {
di "`x'"
use "$path1\nielsen\\`x'_monthly_storelevel.dta", clear
keep if  only_near_defunct==1 &  only_near_operating==0
egen firstmonth=min(yearmonth), by( household_id)
egen lastmonth=max(yearmonth), by( household_id)
g window=lastmonth-firstmonth
keep if window>=48  & window!=.

collapse (sum)  totalvisits, by( visited_store_on_bigbox_day yearmonth household_id)
reshape wide  totalvisits, i(yearmonth household_id) j(visited_store_on_bigbox_day)
replace totalvisits0=0 if totalvisits0==.
replace totalvisits1=0 if totalvisits1==.

g total_trips=totalvisits1+totalvisits0
g ratio= totalvisits1/total_trips

tab yearmonth, g(ydum)
areg ratio ydum1-ydum73 [pw=total_trips],a(household_id)
gen predictedratio = _b[_cons]
forv j=1/73 {
replace predictedratio =predictedratio+ _b[ydum`j']*ydum`j'
}
collapse (mean) predictedratio ratio [w=total_trips], by(yearmonth)
sc predictedratio yearmonth 

graph save wfixedeffects_`x', replace

}

