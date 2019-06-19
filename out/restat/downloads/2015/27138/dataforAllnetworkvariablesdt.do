* This script contains the code to create the main two datasets to be used in the script "Allnetworkvariablesdt.R" in Ductor, L., Fafchamps, M., Goyal S. and M. van der Leij. Social Networks and Research Output. The Review of Economics and Statistics.

insheet using "networkdatac.csv"

/****************Creating the file networkdatacdt.csv*************/

replace pages=50 if pages>50 /*2307 changes*/
bys journalid: egen mjo=mean(pages)
gen mpages=pages/mjo
gen prod50=(mpages*prod)/nauthors
drop prod cprod lprod lcprod qlprod qcprod mjo mpages cprodd qprod
rename prod50 prod
outsheet using "networkdatacdt.csv", comma replace 



/****************Creating qntdt_fullsample.csv***************/


gen t=_n
reshape long auth, i(t) 
sort auth year 
drop t _j 
rename prod proddt
by auth year: egen sprod=sum(proddt)
by auth year: egen mpages=mean(pages)
by auth year:egen mnauthors=mean(nauthors)
drop proddt articleid journalid pages nauthors
rename sprod proddt 
duplicates drop  /*Dropping duplicates: 600779 observations deleted*/
drop if missing(auth)  /*Dropping missing values for authors: 30 observations deleted*/
save prod_dt,replace /*Saving the productivity variable discounted*/

egen ystart=min(year), by(auth) /*first year publication*/
egen yend=max(year), by(auth) /*last year publication*/
sort auth year 
save prod_dt, replace

/* generate a list of all author idcodes in the data */
collapse (mean) year, by(auth)
keep auth
save authorlist, replace

/* create a file with each author by year, and identify the beginning
   and end of publishing career */

clear
set obs 33
gen year=_n+1968
tab year
cross using authorlist
more
sort auth year
merge auth year using prod_dt, sort
tab _merge
drop _merge
compress

egen mystart=mean(ystart), by(auth)
drop if year<mystart
egen myend=mean(yend), by(auth)
drop ystart yend
rename mystart ystart
rename myend yend

foreach i in prod mpages mnauthors{
	replace `i'=0 if `i'==.
}

drop if year>1999
sum
tsset auth year, yearly

/*Creating the restricted productivity*/
gen cprod5dt=proddt+L.proddt+L2.proddt+L3.proddt+L4.proddt
bys auth: gen cproddt=sum(proddt)
gen cprodl5dt=L5.cproddt
order auth year prod cprod5dt cproddt cprodl5dt


save prod_dt, replace
_pctile cprod5dt if cprod5dt!=., p(50, 80, 90, 95, 99)

return list 

/*Creating the quantiles*/
gen qntdt = 1 if (cprod5dt>=r(r5)) & cprod5dt!=. 
replace qntdt = 2 if (cprod5dt<r(r5) & cprod5dt>=r(r4)) & cprod5dt!=.
replace qntdt = 3 if (cprod5dt<r(r4) & cprod5dt>=r(r3)) & cprod5dt!=.
replace qntdt = 4 if (cprod5dt<r(r3) & cprod5dt>=r(r2)) & cprod5dt!=.
replace qntdt = 5 if (cprod5dt<r(r2) & cprod5dt>=r(r1)) & cprod5dt!=.


/*Notice that the quantiles are not defined for the first four academic years*/
/*Defining the quantiles for the first four years depending on the productivity of the first academic year*/
tab qnt

gen t=(year-ystar)+1
gen prodfa=proddt if t==1
_pctile prodfa, p(50, 80, 90, 95, 99)
gen qnty = 1 if (prodfa>=r(r5)) & prodfa!=. 
replace qnty = 2 if (prodfa<r(r5) & prodfa>=r(r4)) & prodfa!=.
replace qnty = 3 if (prodfa<r(r4) & prodfa>=r(r3)) & prodfa!=.
replace qnty = 4 if (prodfa<r(r3) & prodfa>=r(r2)) & prodfa!=.
replace qnty = 5 if (prodfa<r(r2) & prodfa>=r(r1)) & prodfa!=.
replace qnty = 6 if prodfa<r(r1) & prodfa!=.

bys auth: egen mqnty=max(qnty)
drop qnty
replace qntdt=mqnty if qntdt==.
drop mqnty prodfa
keep auth year qntdt
outsheet using "qntdt_fullsample.csv", comma replace 

