* This script contains the code to obtain the main database in Ductor, L., Fafchamps, M., Goyal S. and M. van der Leij. Social Networks and Research Output. The Review of Economics and Statistics.
* Important: before running this code, you need to obtain all the network variables running the script "Allnetworkvariables.R". 

log using creatingdatabase.log, replace
insheet using "networkdatac.csv", clear

/*CREATING THE SAMPLE: Adjusted by the journal quality impact factor*/
/*Constructing the panel*/
gen t=_n
reshape long auth, i(t) 

sort auth year 
drop t _j 

by auth year: egen sprod=sum(prod)
by auth year: egen mpages=mean(pages)
by auth year:egen mnauthors=mean(nauthors)

drop prod articleid journalid pages nauthors
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

foreach i in prod mpages mnauthors{
	replace `i'=0 if `i'==.
}

drop if year>1999
sum
tsset auth year, yearly

/*Creating the restricted productivity*/
gen cprod5=prod+L.prod+L2.prod+L3.prod+L4.prod
bys auth: gen cprod=sum(prod)
gen cprodl5=L5.cprod
order auth year prod cprod5 cprod cprodl5

/*Creating variable: number of years since the last publication*/

gen z=0 if prod>0
replace z=z[_n-1]+1 if prod==0
rename z nopapers

save prod_nodt, replace

/*Creating experience variable*/

gen t=(year-ystar)+1
order auth year t
save prod_nodt, replace

/*Generating a variable to define two different groups of observation, the model 
will be estimated in group 1 while the predictions are evaluated using group 2*/
bys auth: gen n=_n
drop if n>1
gen random = runiform() /*creating a random variable from an uniform*/
sort random 
generate group = group(2)
keep auth year group
save group_ndnp,replace /*Dataset with authors and their corresponding groups*/
clear all
use prod_nodt
joinby auth year using group_ndnp.dta, unmatched(master) 
drop _merge
bys auth: gen n=_n
foreach i in year{
	replace group=group[_n-1] if n>1  /*Filling the group variable for each author for the rest of observations*/
}
drop n
save prod_nodt,replace

/*Creating future productivity variables*/
sort auth year
gen prodf3=F.prod+F2.prod+F3.prod
gen prodf5=prodf3+F4.prod+F5.prod

gen lprodf3l=log(prod+L.prod+L2.prod+1)
gen lprodf3l2=L.lprodf3l
gen lprodf3l3=L2.lprodf3l
gen lprodf3l4=L3.lprodf3l
gen lprodf3l5=L4.lprodf3l
gen lprodf3l6=L5.lprodf3l
gen lprodf3l7=L6.lprodf3l
gen lprodf3l8=L7.lprodf3l
gen lprodf3l9=L8.lprodf3l
gen lprodf3l10=L9.lprodf3l
gen lprodf3l11=L10.lprodf3l
gen lprodf3l12=L11.lprodf3l
gen lprodf3l13=L12.lprodf3l
gen lprodf3l14=L13.lprodf3l
gen lprodf3l15=L14.lprodf3l
gen lprodf3l16=L15.lprodf3l

save prod_nodt,replace


/*Adding network variables*/


/*This code merge all the network period variables into the main dataset*/
/* 1 year networks*/
foreach i in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_1y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree1y
rename vgnetprod netprod1y
rename vgnetprod2 netprod21y
rename vgdeg2 degree21y
rename vgneiq1fs neiq1fs1y
drop v1
sort auth year
order auth year
save network`i'_1y,replace
}

use network1970_1y, clear
save network_1y, replace
foreach i in 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree1y netprod1y netprod21y using network`i'_1y,sort
drop _merge
}
save network_1y, replace

/*Variables in the Giant component*/
foreach i in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_1y.csv",clear
gen gc1y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc1y
rename vgcbet bet1y
rename vgccl clos1y
rename vgcev ev1y
drop v1
sort auth year
order auth year
save networkgc`i'_1y,replace
}

use networkgc1970_1y, clear
save networkgc_1y, replace
foreach i in 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc1y bet1y clos1y ev1y using networkgc`i'_1y,sort
drop _merge
}
save networkgc_1y, replace

use prod_nodt, clear
joinby auth year using network_1y, unmatched(master)
drop _merge
joinby auth year using networkgc_1y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree1y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree21y netprod1y netprod21y bet1y clos1y ev1y gc1y{
replace `i'=0 if missing(`i') 
}

save prodndnp_1y, replace

set more off
/* 2 year networks*/
foreach i in 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_2y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree2y
rename vgnetprod netprod2y
rename vgnetprod2 netprod22y
rename vgdeg2 degree22y
rename vgneiq1fs neiq1fs2y
drop v1
sort auth year
order auth year
save network`i'_2y,replace
}

use network1971_2y, clear
save network_2y, replace
foreach i in 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree2y netprod2y netprod22y using network`i'_2y,sort
drop _merge
}
save network_2y, replace

/*Variables in the Giant component*/
foreach i in 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_2y.csv",clear
gen gc2y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc2y
rename vgcbet bet2y
rename vgccl clos2y
rename vgcev ev2y
drop v1
sort auth year
order auth year
save networkgc`i'_2y,replace
}

use networkgc1971_2y, clear
save networkgc_2y, replace
foreach i in 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc2y bet2y clos2y ev2y using networkgc`i'_2y,sort
drop _merge
}
save networkgc_2y, replace

use prodndnp_1y, clear
joinby auth year using network_2y, unmatched(master)
drop _merge
joinby auth year using networkgc_2y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree2y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree22y netprod2y netprod22y neiq1fs2y degreegc2y bet2y clos2y ev2y gc2y{
replace `i'=0 if missing(`i') 
}

save prodndnp_2y, replace

/*3 years*/
set more off
foreach i in 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_3y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree3y
rename vgnetprod netprod3y
rename vgnetprod2 netprod23y
rename vgdeg2 degree23y
rename vgneiq1fs neiq1fs3y
drop v1
sort auth year
order auth year
save network`i'_3y,replace
}

use network1972_3y, clear
save network_3y, replace
foreach i in 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree3y netprod3y netprod23y using network`i'_3y,sort
drop _merge
}
save network_3y, replace

/*Variables in the Giant component*/
foreach i in 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_3y.csv",clear
gen gc3y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc3y
rename vgcbet bet3y
rename vgccl clos3y
rename vgcev ev3y
drop v1
sort auth year
order auth year
save networkgc`i'_3y,replace
}

use networkgc1972_3y, clear
save networkgc_3y, replace
foreach i in 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc3y bet3y clos3y ev3y using networkgc`i'_3y,sort
drop _merge
}
save networkgc_3y, replace

use prodndnp_2y, clear
joinby auth year using network_3y, unmatched(master)
drop _merge
joinby auth year using networkgc_3y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree3y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree23y netprod3y netprod23y neiq1fs3y degreegc3y bet3y clos3y ev3y gc3y{
replace `i'=0 if missing(`i') 
}
save prodndnp_3y, replace

/*4 years*/
set more off
foreach i in 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_4y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree4y
rename vgnetprod netprod4y
rename vgnetprod2 netprod24y
rename vgdeg2 degree24y
rename vgneiq1fs neiq1fs4y
drop v1
sort auth year
order auth year
save network`i'_4y,replace
}

use network1973_4y, clear
save network_4y, replace
foreach i in 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree4y netprod4y netprod24y using network`i'_4y,sort
drop _merge
}
save network_4y, replace

/*Variables in the Giant component*/
foreach i in 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_4y.csv",clear
gen gc4y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc4y
rename vgcbet bet4y
rename vgccl clos4y
rename vgcev ev4y
drop v1
sort auth year
order auth year
save networkgc`i'_4y,replace
}

use networkgc1973_4y, clear
save networkgc_4y, replace
foreach i in 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc4y bet4y clos4y ev4y using networkgc`i'_4y,sort
drop _merge
}
save networkgc_4y, replace

use prodndnp_3y, clear
joinby auth year using network_4y, unmatched(master)
drop _merge
joinby auth year using networkgc_4y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree4y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree24y netprod4y netprod24y neiq1fs4y degreegc4y bet4y clos4y ev4y gc4y{
replace `i'=0 if missing(`i') 
}
save prodndnp_4y, replace

/*5 years*/
set more off
foreach i in 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_5y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree5y
rename vgnetprod netprod5y
rename vgnetprod2 netprod25y
rename vgdeg2 degree25y
rename vgneiq1fs neiq1fs5y
drop v1
sort auth year
order auth year
save network`i'_5y,replace
}

use network1974_5y, clear
save network_5y, replace
foreach i in 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree5y netprod5y netprod25y using network`i'_5y,sort
drop _merge
}
save network_5y, replace

/*Variables in the Giant component*/
foreach i in 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_5y.csv",clear
gen gc5y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc5y
rename vgcbet bet5y
rename vgccl clos5y
rename vgcev ev5y
drop v1
sort auth year
order auth year
save networkgc`i'_5y,replace
}

use networkgc1974_5y, clear
save networkgc_5y, replace
foreach i in 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc5y bet5y clos5y ev5y using networkgc`i'_5y,sort
drop _merge
}
save networkgc_5y, replace

use prodndnp_4y, clear
joinby auth year using network_5y, unmatched(master)
drop _merge
joinby auth year using networkgc_5y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree5y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree25y netprod5y netprod25y neiq1fs5y degreegc5y bet5y clos5y ev5y gc5y{
replace `i'=0 if missing(`i') 
}
save prodndnp_5y, replace


/*6 years*/
set more off
foreach i in 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_6y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree6y
rename vgnetprod netprod6y
rename vgnetprod2 netprod26y
rename vgdeg2 degree26y
rename vgneiq1fs neiq1fs6y
drop v1
sort auth year
order auth year
save network`i'_6y,replace
}

use network1975_6y, clear
save network_6y, replace
foreach i in 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree6y netprod6y netprod26y using network`i'_6y,sort
drop _merge
}
save network_6y, replace

/*Variables in the Giant component*/
foreach i in 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_6y.csv",clear
gen gc6y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc6y
rename vgcbet bet6y
rename vgccl clos6y
rename vgcev ev6y
drop v1
sort auth year
order auth year
save networkgc`i'_6y,replace
}

use networkgc1975_6y, clear
save networkgc_6y, replace
foreach i in 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc6y bet6y clos6y ev6y using networkgc`i'_6y,sort
drop _merge
}
save networkgc_6y, replace

use prodndnp_5y, clear
joinby auth year using network_6y, unmatched(master)
drop _merge
joinby auth year using networkgc_6y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree6y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree26y netprod6y netprod26y neiq1fs6y degreegc6y bet6y clos6y ev6y gc6y{
replace `i'=0 if missing(`i') 
}
save prodndnp_6y, replace


/*7 years*/
set more off
foreach i in 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_7y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree7y
rename vgnetprod netprod7y
rename vgnetprod2 netprod27y
rename vgdeg2 degree27y
rename vgneiq1fs neiq1fs7y
drop v1
sort auth year
order auth year
save network`i'_7y,replace
}

use network1976_7y, clear
save network_7y, replace
foreach i in 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree7y netprod7y netprod27y using network`i'_7y,sort
drop _merge
}
save network_7y, replace

/*Variables in the Giant component*/
foreach i in 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_7y.csv",clear
gen gc7y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc7y
rename vgcbet bet7y
rename vgccl clos7y
rename vgcev ev7y
drop v1
sort auth year
order auth year
save networkgc`i'_7y,replace
}

use networkgc1976_7y, clear
save networkgc_7y, replace
foreach i in 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc7y bet7y clos7y ev7y using networkgc`i'_7y,sort
drop _merge
}
save networkgc_7y, replace

use prodndnp_6y, clear
joinby auth year using network_7y, unmatched(master)
drop _merge
joinby auth year using networkgc_7y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree7y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree27y netprod7y netprod27y neiq1fs7y degreegc7y bet7y clos7y ev7y gc7y{
replace `i'=0 if missing(`i') 
}
save prodndnp_7y, replace



/*8 years*/
set more off
foreach i in 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_8y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree8y
rename vgnetprod netprod8y
rename vgnetprod2 netprod28y
rename vgdeg2 degree28y
rename vgneiq1fs neiq1fs8y
drop v1
sort auth year
order auth year
save network`i'_8y,replace
}

use network1977_8y, clear
save network_8y, replace
foreach i in 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree8y netprod8y netprod28y using network`i'_8y,sort
drop _merge
}
save network_8y, replace

/*Variables in the Giant component*/
foreach i in 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_8y.csv",clear
gen gc8y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc8y
rename vgcbet bet8y
rename vgccl clos8y
rename vgcev ev8y
drop v1
sort auth year
order auth year
save networkgc`i'_8y,replace
}

use networkgc1977_8y, clear
save networkgc_8y, replace
foreach i in 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc8y bet8y clos8y ev8y using networkgc`i'_8y,sort
drop _merge
}
save networkgc_8y, replace

use prodndnp_7y, clear
joinby auth year using network_8y, unmatched(master)
drop _merge
joinby auth year using networkgc_8y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree8y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree28y netprod8y netprod28y neiq1fs8y degreegc8y bet8y clos8y ev8y gc8y{
replace `i'=0 if missing(`i') 
}
save prodndnp_8y, replace


/*9 years*/
set more off
foreach i in 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_9y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree9y
rename vgnetprod netprod9y
rename vgnetprod2 netprod29y
rename vgdeg2 degree29y
rename vgneiq1fs neiq1fs9y
drop v1
sort auth year
order auth year
save network`i'_9y,replace
}

use network1978_9y, clear
save network_9y, replace
foreach i in 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree9y netprod9y netprod29y using network`i'_9y,sort
drop _merge
}
save network_9y, replace

/*Variables in the Giant component*/
foreach i in 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_9y.csv",clear
gen gc9y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc9y
rename vgcbet bet9y
rename vgccl clos9y
rename vgcev ev9y
drop v1
sort auth year
order auth year
save networkgc`i'_9y,replace
}

use networkgc1978_9y, clear
save networkgc_9y, replace
foreach i in 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc9y bet9y clos9y ev9y using networkgc`i'_9y,sort
drop _merge
}
save networkgc_9y, replace

use prodndnp_8y, clear
joinby auth year using network_9y, unmatched(master)
drop _merge
joinby auth year using networkgc_9y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree9y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree29y netprod9y netprod29y neiq1fs9y degreegc9y bet9y clos9y ev9y gc9y{
replace `i'=0 if missing(`i') 
}
save prodndnp_9y, replace


/*10 years*/
set more off
foreach i in 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_10y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree10y
rename vgnetprod netprod10y
rename vgnetprod2 netprod210y
rename vgdeg2 degree210y
rename vgneiq1fs neiq1fs10y
drop v1
sort auth year
order auth year
save network`i'_10y,replace
}

use network1979_10y, clear
save network_10y, replace
foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree10y netprod10y netprod210y using network`i'_10y,sort
drop _merge
}
save network_10y, replace

/*Variables in the Giant component*/
foreach i in 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_10y.csv",clear
gen gc10y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc10y
rename vgcbet bet10y
rename vgccl clos10y
rename vgcev ev10y
drop v1
sort auth year
order auth year
save networkgc`i'_10y,replace
}

use networkgc1979_10y, clear
save networkgc_10y, replace
foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc10y bet10y clos10y ev10y using networkgc`i'_10y,sort
drop _merge
}
save networkgc_10y, replace

use prodndnp_9y, clear
joinby auth year using network_10y, unmatched(master)
drop _merge
joinby auth year using networkgc_10y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree10y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree210y netprod10y netprod210y neiq1fs10y degreegc10y bet10y clos10y ev10y gc10y{
replace `i'=0 if missing(`i') 
}
save prodndnp_10y, replace


/*11 years*/
set more off
foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_11y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree11y
rename vgnetprod netprod11y
rename vgnetprod2 netprod211y
rename vgdeg2 degree211y
rename vgneiq1fs neiq1fs11y
drop v1
sort auth year
order auth year
save network`i'_11y,replace
}

use network1980_11y, clear
save network_11y, replace
foreach i in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree11y netprod11y netprod211y using network`i'_11y,sort
drop _merge
}
save network_11y, replace

/*Variables in the Giant component*/
foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_11y.csv",clear
gen gc11y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc11y
rename vgcbet bet11y
rename vgccl clos11y
rename vgcev ev11y
drop v1
sort auth year
order auth year
save networkgc`i'_11y,replace
}

use networkgc1980_11y, clear
save networkgc_11y, replace
foreach i in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc11y bet11y clos11y ev11y using networkgc`i'_11y,sort
drop _merge
}
save networkgc_11y, replace

use prodndnp_10y, clear
joinby auth year using network_11y, unmatched(master)
drop _merge
joinby auth year using networkgc_11y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree11y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree211y netprod11y netprod211y neiq1fs11y degreegc11y bet11y clos11y ev11y gc11y{
replace `i'=0 if missing(`i') 
}
save prodndnp_11y, replace


/*12 years*/
set more off
foreach i in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_12y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree12y
rename vgnetprod netprod12y
rename vgnetprod2 netprod212y
rename vgdeg2 degree212y
rename vgneiq1fs neiq1fs12y
drop v1
sort auth year
order auth year
save network`i'_12y,replace
}

use network1981_12y, clear
save network_12y, replace
foreach i in 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree12y netprod12y netprod212y using network`i'_12y,sort
drop _merge
}
save network_12y, replace

/*Variables in the Giant component*/
foreach i in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_12y.csv",clear
gen gc12y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc12y
rename vgcbet bet12y
rename vgccl clos12y
rename vgcev ev12y
drop v1
sort auth year
order auth year
save networkgc`i'_12y,replace
}

use networkgc1981_12y, clear
save networkgc_12y, replace
foreach i in 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc12y bet12y clos12y ev12y using networkgc`i'_12y,sort
drop _merge
}
save networkgc_12y, replace

use prodndnp_11y, clear
joinby auth year using network_12y, unmatched(master)
drop _merge
joinby auth year using networkgc_12y, unmatched(master)
drop _merge

/*Replacing missing values*/
foreach i in degree212y netprod12y netprod212y neiq1fs12y degreegc12y bet12y clos12y ev12y gc12y{
replace `i'=0 if missing(`i') 
}
save prodndnp_12y, replace



/*13 years*/
set more off
foreach i in 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_13y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree13y
rename vgnetprod netprod13y
rename vgnetprod2 netprod213y
rename vgdeg2 degree213y
rename vgneiq1fs neiq1fs13y
drop v1
sort auth year
order auth year
save network`i'_13y,replace
}

use network1982_13y, clear
save network_13y, replace
foreach i in 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree13y netprod13y netprod213y using network`i'_13y,sort
drop _merge
}
save network_13y, replace

/*Variables in the Giant component*/
foreach i in 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_13y.csv",clear
gen gc13y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc13y
rename vgcbet bet13y
rename vgccl clos13y
rename vgcev ev13y
drop v1
sort auth year
order auth year
save networkgc`i'_13y,replace
}

use networkgc1982_13y, clear
save networkgc_13y, replace
foreach i in 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc13y bet13y clos13y ev13y using networkgc`i'_13y,sort
drop _merge
}
save networkgc_13y, replace

use prodndnp_12y, clear
joinby auth year using network_13y, unmatched(master)
drop _merge
joinby auth year using networkgc_13y, unmatched(master)
drop _merge

/*Replacing missing values*/
foreach i in degree213y netprod13y netprod213y neiq1fs13y degreegc13y bet13y clos13y ev13y gc13y{
replace `i'=0 if missing(`i') 
}
save prodndnp_13y, replace

/*14 years*/
set more off
foreach i in 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_14y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree14y
rename vgnetprod netprod14y
rename vgnetprod2 netprod214y
rename vgdeg2 degree214y
rename vgneiq1fs neiq1fs14y
drop v1
sort auth year
order auth year
save network`i'_14y,replace
}

use network1983_14y, clear
save network_14y, replace
foreach i in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree14y netprod14y netprod214y using network`i'_14y,sort
drop _merge
}
save network_14y, replace

/*Variables in the Giant component*/
foreach i in 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_14y.csv",clear
gen gc14y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc14y
rename vgcbet bet14y
rename vgccl clos14y
rename vgcev ev14y
drop v1
sort auth year
order auth year
save networkgc`i'_14y,replace
}

use networkgc1983_14y, clear
save networkgc_14y, replace
foreach i in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc14y bet14y clos14y ev14y using networkgc`i'_14y,sort
drop _merge
}
save networkgc_14y, replace

use prodndnp_13y, clear
joinby auth year using network_14y, unmatched(master)
drop _merge
joinby auth year using networkgc_14y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree14y==0  /*all network variables should be zero or missing*/

/*Replacing missing values*/
foreach i in degree214y netprod14y netprod214y neiq1fs14y degreegc14y bet14y clos14y ev14y gc14y{
replace `i'=0 if missing(`i') 
}
save prodndnp_14y, replace



/*15 years*/
set more off
foreach i in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
insheet using "network`i'_15y.csv",clear
gen year=`i'
rename vgauth auth
rename vgdeg degree15y
rename vgnetprod netprod15y
rename vgnetprod2 netprod215y
rename vgdeg2 degree215y
rename vgneiq1fs neiq1fs15y
drop v1
sort auth year
order auth year
save network`i'_15y,replace
}

use network1984_15y, clear
save network_15y, replace
foreach i in 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degree15y netprod15y netprod215y using network`i'_15y,sort
drop _merge
}
save network_15y, replace

/*Variables in the Giant component*/
foreach i in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkgc`i'_15y.csv",clear
gen gc15y=1
gen year=`i'
rename vgcauth auth
rename vgcdeg degreegc15y
rename vgcbet bet15y
rename vgccl clos15y
rename vgcev ev15y
drop v1
sort auth year
order auth year
save networkgc`i'_15y,replace
}

use networkgc1984_15y, clear
save networkgc_15y, replace
foreach i in 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year degreegc15y bet15y clos15y ev15y using networkgc`i'_15y,sort
drop _merge
}
save networkgc_15y, replace

use prodndnp_14y, clear

joinby auth year using network_15y, unmatched(master)
drop _merge
joinby auth year using networkgc_15y, unmatched(master)
drop _merge

/*checking inconsistencies*/
sum if degree15y==0  /*all network variables should be zero or missing*/
save prodndnp_15y, replace

/*Creating log(x+1) variables*/
foreach i in 1y 2y 3y 4y 5y 6y 7y 8y 9y 10y 11y 12y 13y 14y 15y{
gen lclos`i'=log(clos`i'+1) 
gen lbet`i'= log(bet`i'+1) 
gen lnetprod`i'=log(netprod`i'+1)  
gen lnetprod2`i'=log(netprod2`i'+1)  
drop clos`i'
drop bet`i'
drop netprod`i'
drop netprod2`i'
}
gen lcprod=log(cprod+1)
gen lprodf5=log(prodf5+1)
foreach i in cprod5 cprodl5 prodf3{
gen l`i'=log(`i'+1)
}

/*Replacing missing by zeros*/

foreach i in lprodf3l lprodf3l2 lprodf3l3 lprodf3l4 lprodf3l5 lprodf3l6 lprodf3l7 lprodf3l8 lprodf3l9 lprodf3l10 lprodf3l11 lprodf3l12 lprodf3l13 lprodf3l14 lprodf3l15{
replace `i'=0 if missing(`i')
}
foreach i in 1y 2y 3y 4y 5y 6y 7y 8y 9y 10y 11y 12y 13y 14y 15y{
replace lclos`i'=0 if missing(lclos`i') 
replace lbet`i'=0 if missing(lbet`i') 
replace lnetprod`i'=0 if missing(lnetprod`i')
replace lnetprod2`i'=0 if missing(lnetprod2`i') 
replace degree`i'=0 if missing(degree`i')
replace degree2`i'=0 if missing(degree2`i') 
replace neiq1fs`i'=0 if missing(neiq1fs`i')
replace gc`i'=0 if missing(gc`i')
}


/*Creating future network variables for the SUR model*/

gen lnetprod3yf3=F3.lnetprod3y
gen lnetprod23yf3=F3.lnetprod23y
gen degree3yf3=F3.degree3y
gen degree23yf3=F3.degree23y
gen gc3yf3=F3.gc3y
gen lbet3yf3=F3.lbet3y
gen lclos3yf3=F3.lclos3y
gen neiq1fs3yf3=F3.neiq1fs3y
gen neiq1fsfs3yf3=F3.neiq1fsfs3y

save prodndnp_fullsample, replace



/******************CREATING QUANTILES PER AUTHOR FOR FIGURE 7********************/

*histogram lcprod5, fraction

_pctile cprod5 if cprod5!=., p(50, 80, 90, 95, 99)

return list 


gen qnt = 1 if (cprod5>=r(r5)) & cprod5!=. 
replace qnt = 2 if (cprod5<r(r5) & cprod5>=r(r4)) & cprod5!=.
replace qnt = 3 if (cprod5<r(r4) & cprod5>=r(r3)) & cprod5!=.
replace qnt = 4 if (cprod5<r(r3) & cprod5>=r(r2)) & cprod5!=.
replace qnt = 5 if (cprod5<r(r2) & cprod5>=r(r1)) & cprod5!=.

tab qnt
bys qnt: sum qnt group prodf3 cprod5 t 
compress

/*Defining the labels*/


label variable prod "Current output"
label variable cprod5 "Cumulative output from t-4 to t"
label variable cprodl5 "Cumulative output from t0 to t-5"
label variable lcprod5 "Log(Cumulative output from t-4 to t)"
label variable lcprodl5 "Log(Cumulative output from t0 to t -5)"
label variable cprod "Total Cumulative output"
label variable lcprod "Log(Total Cumulative output+1)"
label variable prodf3 "Average forward output from t to t+2"
label variable prodf5 "Average forward output from t to t+4"
label variable lprodf3 "Log(Average forward output from t to t+2+1)"
label variable lprodf5 "Log(Average forward output from t to t+4+1)"
label variable group "Number of the group to which the observation belongs"
label variable qnt "Quantile"
label variable mnauthors "Average number of authors per article working with i at period t"
label variable t "Career time"
label variable tsq "Career time squared"
label variable year "Year"
label variable auth "Author"

label variable lprodf3l "Log(Average output from t to t-2)"
label variable lprodf3l2 "lag of Log(Average output from t to t-2)"
label variable lprodf3l3 "2 lag of Log(Average output from t to t-2)"
label variable lprodf3l4 "3 lag of Log(Average output from t to t-2)"
label variable lprodf3l5 "4 lag of Log(Average output from t to t-2)"
label variable lprodf3l6 "5 lag of Log(Average output from t to t-2)"
label variable lprodf3l7 "6 lag of Log(Average output from t to t-2)"
label variable lprodf3l8 "7 lag of Log(Average output from t to t-2)"
label variable lprodf3l9 "8 lag of Log(Average output from t to t-2)"
label variable lprodf3l10 "9 lag of Log(Average output from t to t-2)"
label variable lprodf3l11 "10 lag of Log(Average output from t to t-2)"
label variable lprodf3l12 "11 lag of Log(Average output from t to t-2)"
label variable lprodf3l13 "12 lag of Log(Average output from t to t-2)"
label variable lprodf3l14 "13 lag of Log(Average output from t to t-2)"
label variable lprodf3l15 "14 lag of Log(Average output from t to t-2)"
label variable lprodf3l16 "15 lag of Log(Average output from t to t-2)"
label variable nopapers "Number of years since the last publication"
label variable ystart "Year of the first publication"
label variable yend "Year of the last publication"
foreach i in 1y 2y 3y 4y 5y 6y 7y 8y 9y 10y 11y 12y 13y 14y 15y{
label variable lbet`i' "Log(betweenness+1) `i'"
label variable lclos`i' "Log(closeness+1) `i'"
label variable lnetprod`i' "Log(netprod+1) `i'"
label variable lnetprod2`i' "Log(netprod2+1) `i'"
label variable degree`i' "Degree `i'"
label variable degree2`i' "Neighbors degree `i'"
label variable neiq1fs`i' "Top 1 coauthors dummy variable using the full sample of authors `i'"
label variable gc`i' "Dummy giant component variable `i'"
}
drop degreegc4y ev4y degreegc2y ev2y ev3y degreegc3y degreegc4y ev4y degreegc5y ev5y degreegc6y ev6y degreegc7y ev7y degreegc8y ev8y degreegc9y ev9y degreegc10y ev10y degreegc11y ev11y degreegc12y ev12y degreegc13y ev13y degreegc14y ev14y degreegc15y ev15y
drop mpages
drop lprodf3l14 lprodf3l15 lprodf3l16
order auth year t tsq lcprod5 lcprodl5 lprodf3 lprodf3l-lprodf3l13 prod prodf5 qnt cprod cprod5 cprodl5 mnauthors ystart yend nopapers group prodf3 degree1y degree2y degree3y degree4y degree5y degree6y degree7y degree8y degree9y degree10y degree11y degree12y degree13y degree14y degree15y degree21y degree22y degree23y degree24y degree25y degree26y degree27y degree28y degree29y degree210y degree211y degree212y degree213y degree214y degree215y gc1y gc2y gc3y gc4y gc5y gc6y gc7y gc8y gc9y gc10y gc11y gc12y gc13y gc14y gc15y lnetprod1y lnetprod2y lnetprod3y lnetprod4y lnetprod5y lnetprod6y lnetprod7y lnetprod8y lnetprod9y lnetprod10y lnetprod11y lnetprod12y lnetprod13y lnetprod14y lnetprod15y lnetprod21y lnetprod22y lnetprod23y lnetprod24y lnetprod25y lnetprod26y lnetprod27y lnetprod28y lnetprod29y lnetprod210y lnetprod211y lnetprod212y lnetprod213y lnetprod214y lnetprod215y lbet1y lbet2y lbet3y lbet4y lbet5y lbet6y lbet7y lbet8y lbet9y lbet10y lbet11y lbet12y lbet13y lbet14y lbet15y
sort auth year
tab year, g(y)
tab t, g(t)
save prodndnp_fullsample, replace


