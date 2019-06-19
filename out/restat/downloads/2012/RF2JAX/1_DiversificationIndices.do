
clear
set memory 700m

****BALANCED

foreach i of numlist 1988/2006 {

use base`i'.dta, clear

count
sort  product
merge product using  HS04991.dta
tab _merge
drop if _merge==1
drop _merge
fillin  reporter  product
tab  reporter
replace year=`i' if _fillin==1
replace Export=0 if _fillin==1
drop _fillin
drop if reporter==""

save Balanced`i'.dta, replace
}


****COMPUTE THE INDICES OF CONCENTRATION

use Balanced1988.dta, clear
drop reportername year productname
rename Export Exportvalue1988
sort reporter product
save export.dta, replace


foreach i of numlist 1989/2006 {

use Balanced`i'.dta, clear
rename Export Exportvalue`i'
drop reportername year productname
sort reporter product
merge reporter product using export.dta
drop _merge
sort reporter product
save export.dta, replace

}


use export.dta, clear
save export2.dta, replace


gen n = 4991 
gen chapter=substr(product,1,2)

foreach i of numlist 1988/2006 {
sort reporter

** TOTAL EXPORTS PER COUNTRY

egen TotalExport`i' =sum(Exportvalue`i'), by(reporter)
compress


** THEIL

by reporter: gen mu`i' = TotalExport`i'/n
by reporter: gen mi`i' = Exportvalue`i'/mu`i'
egen Te`i' = sum(mi`i'*ln(mi`i')), by (reporter)
by reporter: gen T`i' = Te`i'/n


** GINI

sort reporter Exportvalue`i'
by reporter: gen si`i' = sum(Exportvalue`i'/TotalExport`i')
egen Y`i' = sum((si`i'+si`i'[_n-1])/n), by (reporter)
by reporter: gen Gini`i' = abs(1-Y`i')

** HERFINDAHL  

by reporter: gen si2`i' = (Exportvalue`i'/TotalExport`i')^2
egen HHI`i' = sum(si2`i'), by (reporter)


** NUMBER OF ACTIVE LINES

gen Z=0
replace Z=1 if Exportvalue`i'>0
egen Nber`i' = sum(Z), by (reporter)

** SHARE OF OIL

egen sp`i'=sum(Exportvalue`i') if chapter=="26" |chapter=="27", by(reporter)
egen st`i'=sum( Exportvalue`i'), by(reporter)
gen Soil`i'=sp`i'/st`i'



drop  mu`i' mi`i' Te`i' si`i' Y`i' si2`i' Z sp`i' st`i' 
}


	
collapse T1988 T1989 T1990 T1991 T1992 T1993 T1994 T1995 T1996 T1997 T1998 T1999 T2000 T2001 T2002 T2003 T2004 T2005 T2006 Nber1988 Nber1989 Nber1990 Nber1991 Nber1992 Nber1993 Nber1994 Nber1995 Nber1996 Nber1997 Nber1998 Nber1999 Nber2000 Nber2001 Nber2002 Nber2003 Nber2004 Nber2005 Nber2006 HHI1988 HHI1989 HHI1990 HHI1991 HHI1992 HHI1993 HHI1994 HHI1995 HHI1996 HHI1997 HHI1998 HHI1999 HHI2000 HHI2001 HHI2002 HHI2003 HHI2004 HHI2005 HHI2006 Gini1988 Gini1989 Gini1990 Gini1991 Gini1992 Gini1993 Gini1994 Gini1995 Gini1996 Gini1997 Gini1998 Gini1999 Gini2000 Gini2001 Gini2002 Gini2003 Gini2004 Gini2005 Gini2006 Soil1988 Soil1989 Soil1990 Soil1991 Soil1992 Soil1993 Soil1994 Soil1995 Soil1996 Soil1997 Soil1998 Soil1999 Soil2000 Soil2001 Soil2002 Soil2003 Soil2004 Soil2005 Soil2006 TotalExport1988 TotalExport1989 TotalExport1990 TotalExport1991 TotalExport1992 TotalExport1993 TotalExport1994 TotalExport1995 TotalExport1996 TotalExport1997 TotalExport1998 TotalExport1999 TotalExport2000 TotalExport2001 TotalExport2002 TotalExport2003 TotalExport2004 TotalExport2005 TotalExport2006 , by(reporter) 

reshape long Nber TotalExport Gini HHI T Soil, i(reporter) j(year)
drop if T == 0
sort reporter year

label var T "export Theil - overall"
label var Nber "Number of active lines per country - overall"
label var Gini "export Gini - overall"
label var HHI "export Herfindahl-Hirschmann - overall"
label var TotalExport "Total exports value per country year"
label var Soil "Share of oil in total export, chapters 26 and 27"



save Diversification.dta, replace

use pop.dta
sort reporter year
save, replace

use GDP.dta
sort reporter year
save, replace

use Diversification.dta, clear
sort reporter year
merge reporter year using pop.dta
drop _merge
sort reporter year
merge reporter year using GDP.dta
drop _merge
sort reporter year
label var pop "population"
label var GDPpcppp "GDP per capita, PPP (constant 2005 international $)"
save Diversification.dta, replace








