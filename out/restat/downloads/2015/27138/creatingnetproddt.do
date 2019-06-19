* This script contains the code to merge the discounted network variables needed for the script "creating_discounted_prod_sample.do" of the on-line appendix in Ductor, L., Fafchamps, M., Goyal S. and M. van der Leij. Social Networks and Research Output. The Review of Economics and Statistics.
* Important: before running this script, you need to obtain all the discounted network variables running the script "Allnetworkvariables_dt.R". 

set more off
/*netproddt 1y*/

foreach i in 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_1y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt1y
rename vgnetprod2 netprod2dt1y
rename vgdeg degreedt1y
rename vgneiq1fsdt neiq1fsdt1y
drop v1
sort auth year
order auth year
save networkdt`i'_1y,replace
}

use networkdt1970_1y, clear
save networkdt_1y, replace
foreach i in 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt1y netprod2dt1y degreedt1y neiq1fsdt1y using networkdt`i'_1y,sort
drop _merge
}
save networkdt_1y, replace

/*netproddt 2y*/

foreach i in 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_2y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt2y
rename vgnetprod2 netprod2dt2y
rename vgdeg degreedt2y
rename vgneiq1fsdt neiq1fsdt2y
drop v1
sort auth year
order auth year
save networkdt`i'_2y,replace
}

use networkdt1971_2y, clear
save networkdt_2y, replace
foreach i in 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt2y netprod2dt2y degreedt2y neiq1fsdt2y using networkdt`i'_2y,sort
drop _merge
}
save networkdt_2y, replace

/*netproddt 3y*/

foreach i in 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_3y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt3y
rename vgnetprod2 netprod2dt3y
rename vgdeg degreedt3y
rename vgneiq1fsdt neiq1fsdt3y
drop v1
sort auth year
order auth year
save networkdt`i'_3y,replace
}

use networkdt1972_3y, clear
save networkdt_3y, replace
foreach i in 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt3y netprod2dt3y degreedt3y neiq1fsdt3y using networkdt`i'_3y,sort
drop _merge
}
save networkdt_3y, replace

/*netproddt 4y*/

foreach i in 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_4y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt4y
rename vgnetprod2 netprod2dt4y
rename vgdeg degreedt4y
rename vgneiq1fsdt neiq1fsdt4y
drop v1
sort auth year
order auth year
save networkdt`i'_4y,replace
}

use networkdt1973_4y, clear
save networkdt_4y, replace
foreach i in 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt4y netprod2dt4y degreedt4y  neiq1fsdt4y using networkdt`i'_4y,sort
drop _merge
}
save networkdt_4y, replace

/*netproddt 5y*/

foreach i in 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_5y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt5y
rename vgnetprod2 netprod2dt5y
rename vgdeg degreedt5y
rename vgneiq1fsdt neiq1fsdt5y
drop v1
sort auth year
order auth year
save networkdt`i'_5y,replace
}

use networkdt1974_5y, clear
save networkdt_5y, replace
foreach i in 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt5y netprod2dt5y degreedt5y neiq1fsdt5y using networkdt`i'_5y,sort
drop _merge
}
save networkdt_5y, replace

/*netproddt 6y*/

foreach i in 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_6y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt6y
rename vgnetprod2 netprod2dt6y
rename vgdeg degreedt6y
rename vgneiq1fsdt neiq1fsdt6y
drop v1
sort auth year
order auth year
save networkdt`i'_6y,replace
}

use networkdt1975_6y, clear
save networkdt_6y, replace
foreach i in 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt6y netprod2dt6y degreedt6y neiq1fsdt6y using networkdt`i'_6y,sort
drop _merge
}
save networkdt_6y, replace


/*netproddt 7y*/

foreach i in 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_7y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt7y
rename vgnetprod2 netprod2dt7y
rename vgdeg degreedt7y
rename vgneiq1fsdt neiq1fsdt7y
drop v1
sort auth year
order auth year
save networkdt`i'_7y,replace
}

use networkdt1976_7y, clear
save networkdt_7y, replace
foreach i in 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt7y netprod2dt7y degreedt7y neiq1fsdt7y using networkdt`i'_7y,sort
drop _merge
}
save networkdt_7y, replace

/*netproddt 8y*/

foreach i in 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_8y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt8y
rename vgnetprod2 netprod2dt8y
rename vgdeg degreedt8y
rename vgneiq1fsdt neiq1fsdt8y
drop v1
sort auth year
order auth year
save networkdt`i'_8y,replace
}

use networkdt1977_8y, clear
save networkdt_8y, replace
foreach i in 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt8y netprod2dt8y degreedt8y neiq1fsdt8y using networkdt`i'_8y,sort
drop _merge
}
save networkdt_8y, replace

/*netproddt 9y*/

foreach i in 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_9y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt9y
rename vgnetprod2 netprod2dt9y
rename vgdeg degreedt9y
rename vgneiq1fsdt neiq1fsdt9y
drop v1
sort auth year
order auth year
save networkdt`i'_9y,replace
}

use networkdt1978_9y, clear
save networkdt_9y, replace
foreach i in 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt9y netprod2dt9y degreedt9y neiq1fsdt9y using networkdt`i'_9y,sort
drop _merge
}
save networkdt_9y, replace

/*netproddt 10y*/

foreach i in 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_10y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt10y
rename vgnetprod2 netprod2dt10y
rename vgdeg degreedt10y
rename vgneiq1fsdt neiq1fsdt10y
drop v1
sort auth year
order auth year
save networkdt`i'_10y,replace
}

use networkdt1979_10y, clear
save networkdt_10y, replace
foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt10y netprod2dt10y degreedt10y neiq1fsdt10y using networkdt`i'_10y,sort
drop _merge
}
save networkdt_10y, replace


/*netproddt 11y*/

foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_11y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt11y
rename vgnetprod2 netprod2dt11y
rename vgdeg degreedt11y
rename vgneiq1fsdt neiq1fsdt11y
drop v1
sort auth year
order auth year
save networkdt`i'_11y,replace
}

use networkdt1980_11y, clear
save networkdt_11y, replace
foreach i in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt11y netprod2dt11y degreedt11y neiq1fsdt11y using networkdt`i'_11y,sort
drop _merge
}
save networkdt_11y, replace

/*netproddt 12y*/

foreach i in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_12y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt12y
rename vgnetprod2 netprod2dt12y
rename vgdeg degreedt12y
rename vgneiq1fsdt neiq1fsdt12y
drop v1
sort auth year
order auth year
save networkdt`i'_12y,replace
}

use networkdt1981_12y, clear
save networkdt_12y, replace
foreach i in 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt12y netprod2dt12y degreedt12y neiq1fsdt12y using networkdt`i'_12y,sort
drop _merge
}
save networkdt_12y, replace

/*netproddt 13y*/

foreach i in 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_13y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt13y
rename vgnetprod2 netprod2dt13y
rename vgdeg degreedt13y
rename vgneiq1fsdt neiq1fsdt13y
drop v1
sort auth year
order auth year
save networkdt`i'_13y,replace
}

use networkdt1982_13y, clear
save networkdt_13y, replace
foreach i in 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt13y netprod2dt13y degreedt13y neiq1fsdt13y using networkdt`i'_13y,sort
drop _merge
}
save networkdt_13y, replace

/*netproddt 14y*/

foreach i in 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_14y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt14y
rename vgnetprod2 netprod2dt14y
rename vgdeg degreedt14y
rename vgneiq1fsdt neiq1fsdt14y
drop v1
sort auth year
order auth year
save networkdt`i'_14y,replace
}

use networkdt1983_14y, clear
save networkdt_14y, replace
foreach i in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt14y netprod2dt14y degreedt14y neiq1fsdt14y using networkdt`i'_14y,sort
drop _merge
}
save networkdt_14y, replace

/*netproddt 15y*/

foreach i in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 {
insheet using "networkdt`i'_15y.csv",clear
gen year=`i'
rename vgauth auth
rename vgnetprod netproddt15y
rename vgnetprod2 netprod2dt15y
rename vgdeg degreedt15y
rename vgneiq1fsdt neiq1fsdt15y
drop v1
sort auth year
order auth year
save networkdt`i'_15y,replace
}

use networkdt1984_15y, clear
save networkdt_15y, replace
foreach i in 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999{
merge auth year netproddt15y netprod2dt15y degreedt15y neiq1fsdt15y using networkdt`i'_15y,sort
drop _merge
}
save networkdt_15y, replace

use networkdt_1y, clear
joinby auth year using networkdt_2y, unmatched(both)
drop _merge
joinby auth year using networkdt_3y, unmatched(both)
drop _merge
joinby auth year using networkdt_4y, unmatched(both)
drop _merge
joinby auth year using networkdt_5y, unmatched(both)
drop _merge
joinby auth year using networkdt_6y, unmatched(both)
drop _merge
joinby auth year using networkdt_7y, unmatched(both)
drop _merge
joinby auth year using networkdt_8y, unmatched(both)
drop _merge
joinby auth year using networkdt_9y, unmatched(both)
drop _merge
joinby auth year using networkdt_10y, unmatched(both)
drop _merge
joinby auth year using networkdt_11y, unmatched(both)
drop _merge
joinby auth year using networkdt_12y, unmatched(both)
drop _merge
joinby auth year using networkdt_13y, unmatched(both)
drop _merge
joinby auth year using networkdt_14y, unmatched(both)
drop _merge
joinby auth year using networkdt_15y, unmatched(both)
drop _merge

/*replacing missing by zeros*/
foreach i in netproddt1y netproddt2y netproddt3y netproddt4y netproddt5y netproddt6y netproddt7y netproddt8y netproddt9y netproddt10y netproddt11y netproddt12y netproddt13y netproddt14y netproddt15y {
replace `i'=0 if missing(`i')
}
foreach i in netprod2dt1y netprod2dt2y netprod2dt3y netprod2dt4y netprod2dt5y netprod2dt6y netprod2dt7y netprod2dt8y netprod2dt9y netprod2dt10y netprod2dt11y netprod2dt12y netprod2dt13y netprod2dt14y netprod2dt15y {
replace `i'=0 if missing(`i')
}
foreach i in degreedt1y degreedt2y degreedt3y degreedt4y degreedt5y degreedt6y degreedt7y degreedt8y degreedt9y degreedt10y degreedt11y degreedt12y degreedt13y degreedt14y degreedt15y {
replace `i'=0 if missing(`i')
}

save networkdt.dta, replace


