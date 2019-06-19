* This script contains the code to obtain the discounted productivity variables used to replicate table 14 in Ductor, L., Fafchamps, M., Goyal S. and M. van der Leij. Social Networks and Research Output. The Review of Economics and Statistics.
* Important: before running this script, you need to obtain all the discounted network variables running the script "Allnetworkvariables.R" and "creatingproddt.do", you also need the main dataset "prodndnp_fullsample.dta". 


log using creatingprod_nd.log, replace
insheet using "networkdatac.csv"

/*CREATING THE DISCOUNTED PRODUCTIVITY VARIABLE*/
replace pages=50 if pages>50 /*2307 changes*/
bys journalid: egen mjo=mean(pages)
gen mpages=pages/mjo
gen prod50=(mpages*prod)/nauthors
drop prod cprod lprod lcprod qlprod qcprod mjo mpages cprodd qprod

/*Constructing the panel*/
gen t=_n
reshape long auth, i(t) 

sort auth year 
drop t _j 
rename prod50 proddt
by auth year: egen sprod=sum(proddt)
by auth year: egen mpages=mean(pages)
by auth year:egen mnauthors=mean(nauthors)

drop proddt articleid journalid pages nauthors
rename sprod proddt 
duplicates drop  /*Dropping duplicates: 600779 observations deleted*/
drop if missing(auth)  /*Dropping missing values for authors*/
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

*sum

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


/*Creating future productivity variables*/
sort auth year
gen prodf3dt=F.proddt+F2.proddt+F3.proddt
gen prodf5dt=F.proddt+F2.proddt+F3.proddt+F4.proddt+F5.proddt

gen lprodf3ldt=log(proddt+L.proddt+L2.proddt+1)
gen lprodf3l2dt=L.lprodf3ldt
gen lprodf3l3dt=L2.lprodf3ldt
gen lprodf3l4dt=L3.lprodf3ldt
gen lprodf3l5dt=L4.lprodf3ldt
gen lprodf3l6dt=L5.lprodf3ldt
gen lprodf3l7dt=L6.lprodf3ldt
gen lprodf3l8dt=L7.lprodf3ldt
gen lprodf3l9dt=L8.lprodf3ldt
gen lprodf3l10dt=L9.lprodf3ldt
gen lprodf3l11dt=L10.lprodf3ldt
gen lprodf3l12dt=L11.lprodf3ldt
gen lprodf3l13dt=L12.lprodf3ldt
gen lprodf3l14dt=L13.lprodf3ldt
gen lprodf3l15dt=L14.lprodf3ldt
gen lprodf3l16dt=L15.lprodf3ldt
gen lprodf3l17dt=L16.lprodf3ldt
gen lprodf3l18dt=L17.lprodf3ldt
gen lprodf3l19dt=L18.lprodf3ldt
gen lprodf3l20dt=L19.lprodf3ldt
gen lprodf3l21dt=L20.lprodf3ldt
gen lprodf3l22dt=L21.lprodf3ldt
gen lprodf3l23dt=L22.lprodf3ldt
gen lprodf3l24dt=L23.lprodf3ldt

save prod_dt,replace


/*Creating new quantiles*/


_pctile cprod5dt if cprod5dt!=., p(50, 80, 90, 95, 99)

return list 


gen qntdt = 1 if (cprod5dt>=r(r5)) & cprod5dt!=. 
replace qntdt = 2 if (cprod5dt<r(r5) & cprod5dt>=r(r4)) & cprod5dt!=.
replace qntdt = 3 if (cprod5dt<r(r4) & cprod5dt>=r(r3)) & cprod5dt!=.
replace qntdt = 4 if (cprod5dt<r(r3) & cprod5dt>=r(r2)) & cprod5dt!=.
replace qntdt = 5 if (cprod5dt<r(r2) & cprod5dt>=r(r1)) & cprod5dt!=.
compress
drop mpages mnauthors ystart yend t
save prod_dt,replace

/* Joining the main database to the discounted data*/
use prodndnp_fullsample.dta, clear 
joinby auth year using prod_dt, unmatched(master)

gen lprodf3dt=log(prodf3dt+1)
gen lcprod5dt=log(cprod5dt+1)
gen lcprodl5dt=log(cprodl5dt+1)


/*Replacing missing*/
foreach i in lprodf3ldt lprodf3l2dt lprodf3l3dt lprodf3l4dt lprodf3l5dt lprodf3l6dt lprodf3l7dt lprodf3l8dt lprodf3l9dt lprodf3l10dt lprodf3l11dt lprodf3l12dt lprodf3l13dt lprodf3l14dt lprodf3l15dt lprodf3l16dt lprodf3l17dt lprodf3l18dt lprodf3l19dt lprodf3l20dt lprodf3l21dt lprodf3l22dt lprodf3l23dt lprodf3l24dt{
replace `i'=0 if missing(`i')
}
replace lnetproddt5y=0 if missing(lnetproddt5y)



drop netproddt5y netprod2dt5y lprodf3l lprodf3l2 lprodf3l3 lprodf3l4 lprodf3l5 lprodf3l6 lprodf3l7 lprodf3l8 lprodf3l9 lprodf3l10 lprodf3l11 lprodf3l12 lprodf3l13 lprodf3l14 lprodf3l15 lprodf3l16 cprod5 cprod cprodl5 prod neiq11y neiq12y neiq13y neiq14y neiq15y neiq16y neiq17y neiq18y neiq19y neiq110y neiq111y neiq112y neiq113y neiq114y neiq115y lnetprod1y lnetprod21y lnetprod2y lnetprod22y lnetprod3y lnetprod23y lnetprod24y lnetprod4y lnetprod5y lnetprod25y lnetprod6y lnetprod26y lnetprod7y lnetprod27y lnetprod28y lnetprod8y lnetprod9y lnetprod29y lnetprod10y lnetprod210y lnetprod11y lnetprod211y lnetprod12y lnetprod212y lnetprod13y lnetprod213y lnetprod14y lnetprod214y lnetprod15y lnetprod215y lcprod lprodf5 lcprod5 lcprodl5 lnetprod3yf3 lnetprod23yf3 neiq1fs1y neiq13yf3 neiq1fs2y neiq1fs3y neiq1fs4y neiq1fs5y neiq1fs6y neiq1fs7y neiq1fs8y neiq1fs9y neiq1fs10y neiq1fs11y neiq1fs12y neiq1fs13y neiq1fs14y neiq1fs15y _merge
 

order auth year t tsq lcprod5dt lcprodl5dt lprodf3dt lprodf3ldtdt-lprodf3ldt24dt proddt prodf5dt qntdt cproddt cprod5dt cprodl5dt mnauthors ystart yend nopapers group prodf3 degree1y degree2y degree3y degree4y degree5y degree6y degree7y degree8y degree9y degree10y degree11y degree12y degree13y degree14y degree15y degree21y degree22y degree23y degree24y degree25y degree26y degree27y degree28y degree29y degree210y degree211y degree212y degree213y degree214y degree215y gc1y gc2y gc3y gc4y gc5y gc6y gc7y gc8y gc9y gc10y gc11y gc12y gc13y gc14y gc15y lnetproddt5y lnetprod2dt5y lbet1y lbet2y lbet3y lbet4y lbet5y lbet6y lbet7y lbet8y lbet9y lbet10y lbet11y lbet12y lbet13y lbet14y lbet15y

sort auth year

/*Merging the discounted network variables*/
joinby auth year using networkdt, unmatched(master)
drop _merge

foreach i in netproddt1y netproddt2y netproddt3y netproddt4y netproddt5y netproddt6y netproddt7y netproddt8y netproddt9y netproddt10y netproddt11y netproddt12y netproddt13y netproddt14y netproddt15y {
replace `i'=0 if missing(`i')
gen l`i'=log(`i'+1)
drop `i'
}
foreach i in netprod2dt1y netprod2dt2y netprod2dt3y netprod2dt4y netprod2dt5y netprod2dt6y netprod2dt7y netprod2dt8y netprod2dt9y netprod2dt10y netprod2dt11y netprod2dt12y netprod2dt13y netprod2dt14y netprod2dt15y {
replace `i'=0 if missing(`i')
gen l`i'=log(`i'+1)
drop `i'
}
foreach i in degreedt1y degreedt2y degreedt3y degreedt4y degreedt5y degreedt6y degreedt7y degreedt8y degreedt9y degreedt10y degreedt11y degreedt12y degreedt13y degreedt14y degreedt15y {
replace `i'=0 if missing(`i')
}
foreach i in neiq1fsdt1y neiq1fsdt2y neiq1fsdt3y neiq1fsdt4y neiq1fsdt5y neiq1fsdt6y neiq1fsdt7y neiq1fsdt8y neiq1fsdt9y neiq1fsdt10y neiq1fsdt11y neiq1fsdt12y neiq1fsdt13y neiq1fsdt14y neiq1fsdt15y {
replace `i'=0 if missing(`i')
}

save prodndnp_fullsample_dt.dta, replace
