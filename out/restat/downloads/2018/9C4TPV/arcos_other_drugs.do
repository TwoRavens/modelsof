clear
set more off

/* find most likely dates for breaks in other drug series */
local likely_break = 1

if `likely_break' == 1 {

	use ../florida_arcos_trends/Evans_drugs_seven
	replace state="NEW YORK" if state=="NEWYORK"
	replace state="NEW JERSEY" if state=="NEWJERSEY"
	replace state="NEW HAMPSHIRE" if state=="NEWHAMPSHIRE"
	replace state="NEW MEXICO" if state=="NEWMEXICO"
	replace state="DISTRICT OF COLUMBIA" if state=="DC"
	replace state="NORTH CAROLINA" if state=="NORTHCAROLINA"
	replace state="NORTH DAKOTA" if state=="NORTHDAKOTA"
	replace state="SOUTH CAROLINA" if state=="SOUTHCAROLINA"
	replace state="SOUTH DAKOTA" if state=="SOUTHDAKOTA"
	replace state="WEST VIRGINIA" if state=="WESTVIRGINIA"
	replace state="RHODE ISLAND" if state=="RHODEISLAND"
	drop population FLORIDA _merge codeine methadone
	sort state year quarter
	save ../florida_arcos_trends/evans_drugs_seven_a, replace
	clear

	use ../florida_arcos_trends/opioids_together
	sort state year quarter

	merge 1:1 state year quarter using ../florida_arcos_trends/evans_drugs_seven_a

	*construct the dummies used in analysis
	keep if year>=2004 & year<2015
	gen florida=fips==12
	sort florida year quarter
	rename Pentobarbital pentobarbital

	collapse (sum) oxycodone hydrocodone ///
	oxymorphone morphine codeine fentanyl hydromorphone meperdine ///
	population, by(year quarter date)

	replace meperdine = . if year<2006
	replace hydromorphone = . if year<2006
	replace oxymorphone = . if year<2006

	foreach x of varlist oxycodone hydrocodone oxymorphone morphine codeine fentanyl ///
	hydromorphone meperdine {
		gen pc_`x' = `x'/(population/1000)
	}

	** set things up for later calculations/use
	quietly summ date if year==2008 & quarter==3
	local startnum = r(mean)
	quietly summ date if year==2012 & quarter==3
	local endnum = r(mean)
	quietly summ date if year==2004 & quarter==1
	local firstnum = r(mean)
	quietly summ date if year==2014 & quarter==4
	local lastnum = r(mean)
	quietly summ date if year==2006 & quarter==1
	local firstnum_6 = r(mean)


	tempfile main
	qui save `main' , replace 

	foreach x of varlist oxycodone hydrocodone oxymorphone morphine codeine fentanyl ///
	hydromorphone meperdine {

		capture postclose breakers
		postfile breakers trend sse Fstat pval r2 startf endf using ./break_`x'.dta, replace

		forvalues b = `startnum'(1)`endnum' { 
			display `b'
			use `main', replace 
			gen trend = date
			gen z=trend-`b'
			gen post=trend>=`b'
			gen zpost1=post*z
			gen zpost2=zpost1*zpost1
			gen zpre1=(1-post)*z
			gen zpre2=zpre1*zpre1
			reg pc_`x' zpre1 zpre2 zpost1 zpost2, vce(robust)
			local sse=e(rss)
			local rs2=e(r2)
			test (zpre1=zpost1) (zpre2=zpost2)
			local rF = r(F)
			local ppval = r(p)
			if "`x'" == "meperdine" | "`x'" == "hydromorphone" | "`x'" == "oxymorphone" {
				local startf = (`startnum' - `firstnum_6')/(`lastnum'-`firstnum_6' +1)
				local endf = (`endnum' - `firstnum_6')/(`lastnum'-`firstnum_6' +1)
			}
			else  {
				local startf = (`startnum' - `firstnum')/(`lastnum'-`firstnum' +1)
				local endf = (`endnum' - `firstnum')/(`lastnum'-`firstnum' +1)
			}
			post breakers (`b') (`sse') (`rF') (`ppval') (`rs2') (`startf') (`endf')
		}
		postclose breakers
	}


	** gather the break dates for each series
	foreach x of varlist oxycodone hydrocodone oxymorphone morphine codeine fentanyl ///
	hydromorphone meperdine {
		use break_`x', clear
		sort sse
		keep if _n==1
		drop sse
		gen drug = "`x'"
		*tempfile `x'_date
		save `x'_date, replace
	}

	use hydrocodone_date.dta, clear
	foreach x in oxycodone oxymorphone morphine codeine fentanyl ///
		hydromorphone meperdine {
		append using "`x'_date.dta"
	}
	gen lambda = endf*(1-startf)/( startf*(1-endf))
	** now get the critical value for 5% from Andrews table
	quietly {
			gen ubnd = .
			gen lbnd = .
			replace ubnd = 5.44 if inrange(lambda,3.45,5.44)
			replace ubnd = 9 if inrange(lambda,5.44,9)
			replace ubnd = 16 if inrange(lambda,9,16)
			replace ubnd = 32.11 if inrange(lambda,16,32.11)
			replace lbnd = 3.45 if inrange(lambda,3.45,5.44)
			replace lbnd = 5.44 if inrange(lambda,5.44,9)
			replace lbnd = 9 if inrange(lambda,9,16)
			replace lbnd = 16 if inrange(lambda,16,32.11)
			
			gen lambda_frac = ((lambda-lbnd)/(ubnd-lbnd)) 
			
			local bounds 7.05 7.51 7.93 8.45 8.85
			
			gen cvalue = .
			replace cvalue = lambda_frac*(7.51-7.05) + 7.05 if inrange(lambda,3.45,5.44)
			replace cvalue = lambda_frac*(7.93-7.51) + 7.51  if inrange(lambda,5.44,9)
			replace cvalue = lambda_frac*(8.45-7.93) + 7.93  if inrange(lambda,9,16)
			replace cvalue = lambda_frac*(8.85-8.45) + 8.45  if inrange(lambda,16,32.11)
	}

	format trend %tq

	list
}
