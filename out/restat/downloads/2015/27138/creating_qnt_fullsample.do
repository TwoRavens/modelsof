* This script contains the code to obtain the file qnt_fullsample to be used in the script "Allnetworkvariables.R" in Ductor, L., Fafchamps, M., Goyal S. and M. van der Leij. Social Networks and Research Output. The Review of Economics and Statistics.

insheet using "networkdatac.csv, clear

/*CREATING THE SAMPLE: Adjusted by the journal quality impact factor*/
/*Constructing the panel*/
gen t=_n
reshape long auth, i(t) 

sort auth year 
drop t _j 

by auth year: egen sprod=sum(prod)

drop prod articleid journalid 
rename sprod prod 
duplicates drop  /*Dropping duplicates: 600793 observations deleted*/
drop if missing(auth)  /*Dropping missing values for authors: 30 observations deleted*/
save prod_nodt,replace /*Saving the productivity variable no discounted*/


egen ystart=min(year), by(auth) /*first year publication*/
egen yend=max(year), by(auth) /*last year publication*/

sort auth year 
save prod_nodt, replace

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
merge auth year using prod_nodt, sort
tab _merge
drop _merge
compress

*sum

egen mystart=mean(ystart), by(auth)
drop if year<mystart

egen myend=mean(yend), by(auth)

drop ystart yend
rename mystart ystart
rename myend yend

drop if year>1999
sum
tsset auth year, yearly

/*Creating the restricted productivity*/
gen cprod5=prod+L.prod+L2.prod+L3.prod+L4.prod
bys auth: gen cprod=sum(prod)
gen cprodl5=L5.cprod
order auth year prod cprod5 cprod cprodl5


save prod_nodt, replace

/*Creating experience variable*/

gen t=(year-ystar)+1
order auth year t
save prod_nodt, replace


/******************CREATING QUANTILES PER AUTHOR********************/

*histogram lcprod5, fraction

_pctile cprod5 if cprod5!=., p(50, 80, 90, 95, 99)

return list 


gen qnt = 1 if (cprod5>=r(r5)) & cprod5!=. 
replace qnt = 2 if (cprod5<r(r5) & cprod5>=r(r4)) & cprod5!=.
replace qnt = 3 if (cprod5<r(r4) & cprod5>=r(r3)) & cprod5!=.
replace qnt = 4 if (cprod5<r(r3) & cprod5>=r(r2)) & cprod5!=.
replace qnt = 5 if (cprod5<r(r2) & cprod5>=r(r1)) & cprod5!=.


/*Notice that the quantiles are not defined for the first four academic years*/
/*Defining the quantiles for the first four years depending on the productivity of the first academic year*/
tab qnt
gen prodfa=prod if t==1
_pctile prodfa, p(50, 80, 90, 95, 99)
gen qnty = 1 if (prodfa>=r(r5)) & prodfa!=. 
replace qnty = 2 if (prodfa<r(r5) & prodfa>=r(r4)) & prodfa!=.
replace qnty = 3 if (prodfa<r(r4) & prodfa>=r(r3)) & prodfa!=.
replace qnty = 4 if (prodfa<r(r3) & prodfa>=r(r2)) & prodfa!=.
replace qnty = 5 if (prodfa<r(r2) & prodfa>=r(r1)) & prodfa!=.
replace qnty = 6 if prodfa<r(r1) & prodfa!=.
bys auth: egen mqnty=max(qnty)
drop qnty
replace qnt=mqnty if qnt==.
drop mqnty prodfa
compress
keep auth year qnt
outsheet using "qnt_fullsample.csv", comma replace 


