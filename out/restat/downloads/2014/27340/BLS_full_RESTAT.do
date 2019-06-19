//This do file simulates BLS index construction using 2003 sample. 
// Jiro Yoshida
// 2014.2.1
// modified 2014.02.06

cd "C:\Users\juy18\Downloads\rent_index"
log using BLS_full, replace smcl

clear
*set mem 64m
set matsize 1000
set more off
set type double

// --------------------------------------------------
// Method: Comupte sample average rent (implicitly weighted by $ amount) first, 
//  and then compute rent growth rates
use 11MSAs, clear

//to shorten the length of unit_id to 40 characters,
recast str40  unit_id

drop s2003

sort msa unit_id first_month_lease
egen unit_id_num = group(unit_id)
duplicates tag  unit_id_num, gen(numrep)



//construct rent series for each unit
quietly summarize leasemonth
local monfirst=r(min)
local monlast=r(max)
forvalues k = `monfirst'/`monlast' {
	gen month`k' = .
	replace month`k'=rent if first_month_lease <= `k' & last_month_lease >= `k'
	replace month`k'=month`k'[_n-1] if unit_id_num==unit_id_num[_n-1] & month`k'==.
}
// maintain only the last observation for the same unit 
// because the last observation contains all rent sequences including previous leases
drop if unit_id_num== unit_id_num[_n+1]

// computing mean rent for each MSA

// compute the MSA mean rent for the first 5 months
local monfirst5=`monfirst'+5
forvalues k = `monfirst'/`monfirst5' {
	egen msa_mean_rent`k' = mean(month`k'), by(msa)
	egen numpropf`k' = sum(month`k'<.), by(msa)
}

// compute the MSA mean rent using the units that had a lease payment 6 months before
local monfirst6=`monfirst'+6
forvalues k = `monfirst6'/`monlast' {
	local j = `k'-6
	egen msa_mean_rent`k' = mean(month`k') if month`j'<., by(msa)
	egen numpropf`k' = sum(month`k'<.) if month`j'<., by(msa)
	gen g_rent`k'=.
	capture noisily replace g_rent`k'=(msa_mean_rent`k'/msa_mean_rent`j')^(1/6) if month`j'<.
	// make the value of g_rent identical for each MSA
	sort msa g_rent`k'
	replace g_rent`k'=g_rent`k'[_n+1] if msa==msa[_n+1] & g_rent`k'==. & g_rent`k'[_n+1]<. 
	replace g_rent`k'=g_rent`k'[_n-1] if msa==msa[_n-1] & g_rent`k'==. & g_rent`k'[_n-1]<. 
	sort msa numpropf`k'
	replace numpropf`k'=numpropf`k'[_n+1] if msa==msa[_n+1] & numpropf`k'==. & numpropf`k'[_n+1]<. 
	replace numpropf`k'=numpropf`k'[_n-1] if msa==msa[_n-1] & numpropf`k'==. & numpropf`k'[_n-1]<. 
}

order g_rent* numpro*, last
sort msa g_rent*
duplicates drop msa g_rent*, force
drop month* msa_mean*

// constructing BLS indexes

gen ind`monfirst5'=1
forvalues k = `monfirst6'/`monlast' {
	local i = `k'-1
	gen ind`k'=1 if g_rent`k'==.
	replace ind`k'=ind`i'*g_rent`k' if g_rent`k'<.
}
// normalize the index by the value of month 552 (2006m1)
forvalues k = `monfirst5'/`monlast' {
	gen BLSFull`k' = ind`k'/ind552-1 if ind`k'<.
}

levelsof msa, local(msalevel) 
// dropping unnecessary variables
drop ind*  tag resident_id pmt_rank pmt_rec pmt_series property_id movein_date city state zip rent pmt_year pmt_month pmt_date msa_name temp group pos  m_date p_mth last_activity_date unit_id first_month_lease num_pmt last_month_lease leasemonth leasequarter leaseyear lnrent unit_id_num numrep
*drop BLSFull605

// switching rows and columns and obtain BLSFull's as variables
reshape long g_rent BLSFull numpropf, i(msa_name4) j(month)
drop msa_name4 g_rent
reshape wide BLSFull numpropf, i(month) j(msa)
format %tm month
label variable BLSFull12060 "Atlanta" 
label variable BLSFull14460 "Boston"
label variable BLSFull19100 "Dallas"
label variable BLSFull19820 "Detroit"
label variable BLSFull26420 "Houston"
label variable BLSFull31100 "Los_Angeles"
label variable BLSFull33100 "Miami"
label variable BLSFull35620 "New_York"
label variable BLSFull41860 "San_Francisco"
label variable BLSFull42660 "Seattle"
label variable BLSFull47900 "Washington"

label variable numpropf12060 "Atlanta" 
label variable numpropf14460 "Boston"
label variable numpropf19100 "Dallas"
label variable numpropf19820 "Detroit"
label variable numpropf26420 "Houston"
label variable numpropf31100 "Los_Angeles"
label variable numpropf33100 "Miami"
label variable numpropf35620 "New_York"
label variable numpropf41860 "San_Francisco"
label variable numpropf42660 "Seattle"
label variable numpropf47900 "Washington"

// trim indexes to match the starting time with RRI 
replace BLSFull12060=. if month<(1999-1960)*12 //  "BLSFull Atlanta" 
replace BLSFull14460=. if month<(2003-1960)*12 //  "BLSFull Boston"
replace BLSFull19100=. if month<(1999-1960)*12 //  "BLSFull Dallas"
replace BLSFull19820=. if month<(2002-1960)*12 //  "BLSFull Detroit"
replace BLSFull26420=. if month<(2000-1960)*12 //  "BLSFull Houston"
replace BLSFull31100=. if month<(2003-1960)*12 //  "BLSFull Los_Angeles"
replace BLSFull33100=. if month<(2003-1960)*12 //  "BLSFull Miami"
replace BLSFull35620=. if month<(2003-1960)*12 //  "BLSFull New_York"
replace BLSFull41860=. if month<(2005-1960)*12 //  "BLSFull San_Francisco"
replace BLSFull42660=. if month<(2002-1960)*12 //  "BLSFull Seattle"
replace BLSFull47900=. if month<(2003-1960)*12 //  "BLSFull Washington"

order month BLSFull*, first

// drawing graphs
foreach m of local msalevel{
	twoway (connected BLSFull`m' month, msymbol(O) yscale(range(-0.4 0.5)))
	graph export BLSFull_`m'.png, replace
}


// generating another time index

gen d = dofm(month)
gen y = year(d)
gen q = quarter(d)
gen time = y + (q-1)/4

drop y q
order time, first

save BLS_full_1, replace

gen m= month(d)
keep if m==1|m==4|m==7|m==10
drop m d

save BLS_full_q, replace


log close
