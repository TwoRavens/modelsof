

global dir "C:\Users\jgw12\Dropbox\Research\Migration\Remit Protest\EMW-AJPS-Verification-Files"
cd "$dir"
* Get KA open data *  downloaded from http://web.pdx.edu/~ito/Chinn-Ito_website.htm on 01.20.2016
	use chinn-ito-original, clear
	gen cowcode=.
	rename country_name country
	qui do cowcodes
	replace cow = 437  if country=="C?e d'Ivoire"
	tab country if cow==.
	drop if cow==.
	sum 
	sort cow year
	save ka-merge, replace

	* Get CIRI data *
	insheet using ciri-original.csv, clear /* CIRI Data 1981_2011 2014.04.14  (downloaded from http://www.humanrightsdata.com/p/data-documentation.html on 2.3.2016 */  
	rename cow cowcode
	drop if ctry =="Yemen" & year<1991
	drop if ctry =="Yemen Arab Republic" & year>=1991
	drop if ctry =="Russia" & year<1992
	drop if ctry =="Soviet Union" & year>=1992
	drop if ctry =="Serbia and Montenegro" & (year<1992 | year>2005)
	drop if ctry =="Serbia and Montenegro" & year>=2000 & year<=2002
	drop if ctry =="Yugoslavia, Federal Republic of" & (year<2000 | year>2002)
	drop if ctry =="Yugoslavia" & year>=1992
	drop if ctry =="Yugoslavia" & year>=1992
	recode cow (.=345) if ctry=="Serbia" & year>2005
	recode cow (679=678) if ctry =="Yemen" & year>=1991
	drop if cowcode==.
	rename ctry ciri_ctry
	rename formov  ciri_formov
	rename dommov  ciri_dommov
	keep cow year ciri*
	sort cow year
	save ciri-merge, replace

	* Get UNHCR refugee data *
	use unhcr-original, clear
	gen cowcode =.
	qui do cowcodes
	drop if country == "Serbia and Montenegro"
	recode cow (.= 145) if country=="Bolivia (Plurinational State of)"
	recode cow (.= 437) if country=="Côte d'Ivoire" 
	recode cow (.= 731) if country=="Dem. People's Rep. of Korea" 
	recode cow (.= 490) if country=="Dem. Rep. of the Congo"
	recode cow (.= 630) if country=="Islamic Rep. of Iran"
	recode cow (.= 812) if country=="Lao People's Dem. Rep."
	recode cow (.= 732) if country=="Rep. of Korea"
	recode cow (.= 345) if country=="Serbia (and Kosovo: S/RES/1244 (1999))"
	recode cow (.= 652) if country=="Syrian Arab Rep."
	recode cow (.= 510) if country=="United Rep. of Tanzania"
	recode cow (.= 101) if country=="Venezuela (Bolivarian Republic of)"
	recode cow (.= 316) if country=="Czech Rep."
	tab country if cow==.
	drop if cow==.
	rename country unhcr_country
	sort cow year
	save unhcr-merge, replace

	* Get WDI data *
	insheet using wdi-original.csv, clear    /*  WDI data downloaded on 01.20.2016  */
	drop if time =="Data from database: World Development Indicators" | time=="Last Updated: 12/22/2015"
	rename time year
	destring year, replace
	rename countryname country

	* Merge GDP deflator *
	sort year
	merge year using gdpdeflator
	drop _merge
	gen cowcode=.
	qui do cowcodes
	replace cow=626 if country=="South Sudan"

	* Get rich OECD remittance trend and drop OECD rich countries *
	gen oecd=(personalremittancesreceivedcurre/gdpdeflator) if country=="High income: OECD"   	/* get constant dollars for OECD for instrument */
	gen oecd_gr=gdppercapitagrowthannualnygdppca if country=="High income: OECD"   				/* get OECD growth */
	bysort year: egen maxbyyear = max(oecd)  		/* carry to all observations, by year */
	bysort year: egen max1byyear = max(oecd_gr)  	/* carry to all observations, by year */
	drop if cow==900 | cow== 305 | cow==  211 | cow==  20 | cow== 155 | cow== 316 | cow== 390 | /*
	*/ cow== 366 | cow== 375 | cow== 220 | cow== 255 | cow== 350 | cow== 310 | cow== 395 | cow== 205 /*
	*/ | cow== 666 | cow== 325 | cow== 740 | cow== 732 | cow== 212 | cow== 210 | cow== 920 | cow== 385 /*
	*/ | cow== 290 | cow== 235 | cow== 317 | cow== 349 | cow== 230 | cow== 380 | cow== 225| cow== 200 | cow== 2
	tab country if cow==.
	drop if cow==.
	sum cow year
	 
	* Real remittances with no denominator *
	gen r =(personalremittancesreceivedcurre/gdpdeflator)   /* get constant dollars, observation year remittances */
	tsset cow year
	tssmooth ma remit=r, window(2 0 0)  /* remit , 2-year lagged MA */
	tsset cow year
	tssmooth ma richremit = maxbyyear, window(2 0 0)
	tssmooth ma richgrow = max1byyear, window(2 0 0)
	replace remit = ln(remit)   /* log transform for better distribution */
	gen remit_c = ln(r)  /* log transform for better distribution */
	*replace remit = ((remit^($box)-1)/$box)   /* Box-Cox transform for better distribution */
	*gen remit_c = ((r^($box)-1)/$box)  /* Box-Cox transform for better distribution */
	sum remit remit_c
	hist remit, bin(100)
	drop maxbyyear r

	* Remittances as a share of GDP *
	global box = .12
	tsset cow year
	tssmooth ma remit_gdp = personalremittancesreceivedofgdp, window(2 0 0) /* lagged 2-year MA */ 
	replace remit_gdp = 6+ (((remit_gdp)^($box)-1)/$box)  /* Box-Cox transform for better distribution */
	hist remit_gdp, bin(100)
	gen remit_gdp_c = 6+ (((personalremittancesreceivedofgdp)^($box)-1)/$box)  /* Box-Cox transform for better distribution */

	* Remittances per capita *
	gen r =(personalremittancesreceivedcurre/gdpdeflator)/populationtotalsppoptotl
	tsset cow year 
	tssmooth ma remit_pc = r, window(2 0 0) /* lagged 2-year MA */ 
	replace remit_pc = 6.5 + ((remit_pc^($box)-1)/$box)  /* Box-Cox transform for better distribution */
	hist remit_pc

	* Create WDI variables *
	tsset cow year
	gen pop = ln(populationtotalsppoptotl*1000)  /* log population, lagged 1 year */
	gen gdp = ln(gdppercapitaconstant2005usnygdpp) /* log constant gdp per capita, lagged 1 year */
	gen age = agedependencyratioofworkingagepo
	gen gr = gdppercapitagrowthannualnygdppca/100  /* current-year growth */
	gen fdi  = ln(1+abs(foreigndirectinvestmentnetinflow))
	replace fdi = fdi*-1 if foreigndirectinvestmentnetinflow<0
	gen imr = ln(mortalityrateinfantper1000livebi)
	gen aid = ln(abs(netodareceivedofgnidtodaodatgnzs)+1)
	replace aid = 0 if netodareceivedofgnidtodaodatgnzs<0
	gen trade =ln(1+tradeof)
	recode generalgovernmentfinalconsumptio (0=.)
	gen spend = ln(1+generalgovernmentfinalconsumptio)
	gen urban = urbanpopulationoftotalspurbtotli
	replace urbanpopulationgrowthannualspurb=-10 if urbanpopulationgrowthannualspurb<-10  /* Cambodia 1975 has -187% */ 
	replace urbanpopulationgrowthannualspurb=20 if urbanpopulationgrowthannualspurb>20 & urbanpopulationgrowthannualspurb~=.  /* Cambodia 1975 has -187% */ 
	gen urbgr = ln(1+abs(urbanpopulationgrowthannualspurb))
	replace urbgr=urbgr*-1 if urbanpopulationgrowthannualspurb<0
	gen rents = ln(1+oilrentsofgdpnygdppetrrtzs)
	gen emp_male =employmenttopopulationratioages1
	gen emp_all = v8
	gen labor_male = v16
	gen migr = netmigration/1000000
	forval i = 1/4 {
		tsset cow year
		replace migr = l.migr if migr==. & l.migr~=.  /* carry forward for 4 years after each data point */
	}
		* 1-year lag *
	local var = "pop gdp age gr fdi imr aid trade spend urban urbgr migr rents emp_male emp_all labor_male"
	foreach x of local var {
		 tsset cow year
		 gen l1`x'=l.`x'
	}
		* 2-lagged MA *
	tssmooth ma l12gr = gr, window(2 0 0)    /* lagged 2-year growth ave */
	replace l12gr =l12gr*100             
	tssmooth ma l12aid = aid, window(2 0 0)    /* lagged 2-year aid ave */


	* Merge GWF regimes *
	recode cow (316 = 315) if year<1994  /* Czech Republic */
	* no WDI data on East Germany, South Vietnam, South Yemen, Taiwan 
	sort cow year
	merge cow year using GWF_AllPoliticalRegimes
	tab _merge
	drop if _merge==2 | year<1960
	drop _merge
	 
	* Merge PRIO conflict *
	sort cow year
	merge cow year using prio-mergeB
	tab _merge
	tab prio_country if _merge==2 & year>1959
	drop if _merge==2 | year<1960
	drop _merge
	gen conflict  =   prio_conflict_int==2 & prio_conflict_intra>0  /* large-scale violence */
	gen l1conflict  = prio_lconflict_int==2 & prio_lconflict_intra>0  /* large-scale violence */
	recode post2 post1 (.=0)
	sort cow
	save temp, replace
	 
	* Merge rugged data for instrument *
	use rugged_data, clear
	gen cowcode = .
	qui do cowcodes
	replace cowcode =490  if country=="Democratic Republic of the Congo"
	replace cowcode =101  if country=="Venezuela (Bolivarian Republic of)"
	replace cowcode =731  if country=="Democratic People's Republic of Korea"
	replace cowcode =510  if country=="United Republic of Tanzania"
	replace cowcode =732  if country=="Republic of Korea"
	tab country if cow==.
	drop if cow==. 
	drop if country=="Saint Lucia" | country=="Saint Kitts and Nevis" | country=="Cape Verde" | country=="Nauru" | country=="Micronesia, Federated States of"
	sort cow 
	merge cow using temp
	tab _merge
	drop _merge
	sort cow year

	* Merge Ross oil data *
	merge cow year using ross-merge
	tab _merge
	drop _merge 
	sort cow year
	 
	* Merge protest data *
	merge cow year using latentdata
	drop if year<1960
	tab _merge
	drop _merge

	* Merge KA open * 
	sort cow year
	merge cow year using ka-merge
	tab _merge 
	drop if _merge==2
	drop _merge

	* Merge UNHCR refugees * 
	sort cow year
	merge cow year using unhcr-merge
	tab _merge 
	tab unhcr_country if _merge==2
	drop if _merge==2
	tsset cow year
	gen l1ref = ln(1+l.refugees)
	drop _merge 

	* Merge movement data *
	sort cow year
	merge cow year using ciri-merge
	tab _merge if year>=1981 & year<=2010
	tab gwf_country if _merge==1 & year>=1981 & year<2012
	drop if _merge==2
	drop _merge
	recode ciri_for ciri_dom (-77=.) (-66=.)
	tsset cow year
	gen l1move  = l.ciri_for

	* Merge neighbor protest * 
	sort cow year
	merge cow year using neighbor-protest
	tab _merge 
	drop if _merge==2
	drop _merge

	* Merge elections *
	sort cow year 
	merge cow year using nelda-merge
	tab _merge if year>1975
	drop if _merge==2
	drop _merge

	* Time variables *
	gen time = year-1975
	gen time2 =time^2
	gen period = .
	replace period =1 if year<1986
	replace period =2 if year>=1986 & year<1991
	replace period =3 if year>=1991 & year<1996
	replace period =4 if year>=1996 & year<2001
	replace period =5 if year>=2001 & year<2006
	replace period =6 if year>=2006 
	tab period if remit~=. & gwf_duration~=.

	* KA open variable *
	gen ka = ka_open
	tsset cow year
	gen l1ka = l1.ka

	* Neighbor protest variables *
	gen l1nbr5 = neighbor_mean5
	gen l1nbr7 = neighbor_mean7
	gen l1nbr9 = neighbor_mean9

	* Election variables *
	recode nelda_election nelda_relection nelda_irelection /*
	*/ nelda_mparty nelda_incumb nelda_boycott nelda_exec nelda_parl (.=0) if gwf_duration~=.
	gen elec = nelda_election==1 & nelda_mparty==1
	tsset cow year
	gen elec3 = elec==1 | f.elec==1 | l.elec==1

	* Political regimes *
	tab country if gwf_non=="" & year<2011
	gen dict = gwf_non=="NA" 
	
*******************************************************************
************ Latent protest - Banks protest comparison ************
*******************************************************************
 		* Time period correlations for protest data *
		gen corr=.
		gen n =_n
 		local lo = 1961
		local hi = 1965
		forval i = 1/9 {
			qui corr banks_protest_count mean5 if year>=`lo' & year<=`hi',  
			local v = r(rho)
			replace corr= `v' if _n==`i'
			local hi = `hi'+5
			local lo = `lo'+5
		}
		corr banks_protest_count mean5 if year>=1976
		local v = r(rho)
		replace corr= `v' if _n==10	
		twoway (bar corr n if _n<=10, title(Correlation between Banks count and Latent measure, size(medium)) /*
		*/ ytitle(Correlation coefficient) xtitle(Period) barw(.8)   ylab(.4 (.1) 0.6, glcolor(gs14)) /*
		*/ xlab(1 "1961-65"  2 "1966-70" 3 "1971-75"  4 "1976-80" 5 "1981-85"  6 "1986-90" 7 "1991-95"  /*
		*/ 8 "1996-2000" 9 "2001-05"  10 "2006-10", angle(45)))	
		graph export "$dir\protest-time-correlation.pdf", as(pdf) replace	
		gen xmean5=mean5
		qui sum xmean5

		local min = r(min)
		local max = r(max)
	
		local var = "xmean5"
		foreach v of local var {
			replace `v' = (`v'+abs(`min')) /(`max'-`min')
		}
		twoway (line banks_protest_count year if cow==616 & year>=1960 & year<=2010, ytitle(Banks count, axis(1))/* 
		*/ ylab(0 (1) 5, axis(1) glcolor(gs15)) ) /* 
		*/ (line xmean5 year if cow==616 & year>=1960 & year<=2010,xlab(1960(10)2010) lcolor(blue) ylab(0.5 (.1) .8, axis(2)) yaxis(2) /*
		*/ ytitle(Rescaled latent count, axis(2)) xtitle(Year) title(Protest in {bf:Tunisia})/*
		*/ legend(lab(1 "Banks count") lab(2 "Latent count mean")pos(11) ring(0) size(small) col(1)) ysize(1) xsize(2))
		graph export "$dir\protest-tunisia-correlation.pdf", as(pdf) replace	
		
		drop xmean5 corr n
*******************************************************************************************************************
	* Set sample: Dictatorships and Democracy, 1976-2010 *
	egen caseid = group(gwf_case)
	keep if gwf_non=="NA"  | gwf_non=="democracy" | gwf_non=="provisional"
	drop if year<1976 | year>2010
	sum mean5 
	gen Protest = (mean5-r(mean))/(r(sd))  /* Standardized Protest variable */
	sort cow year

	merge cow year using nbrprotest
	tab _merge
	tsset cow year
	gen l1xnbr5 =l.nbrprotest
	sum l1xnbr5
	replace l1xnbr5= (l1xnbr5-r(mean))/(r(sd))
	keep  cow year case period time*  dist_coast richremit richremit richgrow Protest mean5 mean3 mean7 l1xnbr5 banks_protest_count dict ///
		l1gdp l1pop l1nbr5 l12gr l1migr elec3 l1conflict l1trade l1aid l1ka l1oil l1move l1ref  ///
		remit remit_c remit_gdp remit_pc  gwf_non gwf_duration gwf_case gwf_country ///
		foreigndirectinvestmentnetinflow  netodareceivedofgnidtodaodatgnzs personalremittancesreceivedofgdp  oilrentsofgdpnygdppetrrtzs
	sort cow year
	saveold temp-macro, replace version(12)
	
	erase temp.dta
	erase unhcr-merge.dta
	erase ciri-merge.dta
	erase ka-merge.dta
	
