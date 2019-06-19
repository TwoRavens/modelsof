clear
set memory 700m

**** CADOT CARRERE AND SK DEFINITION 

use export.dta, clear

foreach i of numlist 1990/2004 {

rename Exportvalue`i' Exportvalue


** STATUT

local j1 = `i' - 1
local j2 = `i' - 2
gen Pre= (Exportvalue`j1'+ Exportvalue`j2')


local k1 =`i' + 1
local k2 =`i' + 2
gen Post= (Exportvalue`k1'+ Exportvalue`k2')


gen Status=1
 
replace Status=2 if Pre==0 &  Exportvalue~=0 & Exportvalue`k1'~=0 & Exportvalue`k2'~=0 
replace Status=3 if Pre~=0
replace Status=3 if Pre==0 &  Exportvalue~=0 & Post~=0 & Status ~= 2
label var Status "1=non exported / 2=new exports / 3=trad exports"
drop Pre Post


rename  Exportvalue ExportvalueA
replace ExportvalueA = 0 if Status==1

ren ExportvalueA Exportvalue`i'
ren Status Status`i'


** NUMBER OF NEW LINES

gen S=0
replace S=1 if  Status`i'==2
egen New`i'=sum( S), by( reporter)
drop S
gen S=0
replace S=Exportvalue`i' if  Status`i'==2
egen VNew`i'=sum(S), by( reporter)
replace New`i' = . if Exportvalue`j1'== . | Exportvalue`j2'==.
replace VNew`i' = . if Exportvalue`j1'== . | Exportvalue`j2'==.
 
drop S
compress


}

save New_2period.dta, replace


********************************** 
* Do theil decomposition with only 2 groups: active/unactive

use New_2period.dta, clear

gen n = 4991 

foreach i of numlist 1990/2004 {

sort reporter
egen TotalExport`i' =sum(Exportvalue`i'), by(reporter)
compress


** THEIL REDUCED

by reporter: gen mu`i' = TotalExport`i'/n
by reporter: gen mi`i' = Exportvalue`i'/mu`i'
egen Te`i' = sum(mi`i'*ln(mi`i')), by (reporter)
by reporter: gen Tred`i' = Te`i'/n


** THEIL BETWEEN    

replace Status`i'= 3 if Status`i'== 2
egen Sj`i' = sum(Exportvalue`i'), by (reporter Status`i') 
egen nj`i' = count(Exportvalue`i'), by (reporter Status`i') 
by reporter: gen muj`i' =  Sj`i'/nj`i'
by reporter: gen Tbj`i' = (nj`i'/n)*(muj`i'/mu`i')*ln(muj`i'/mu`i')

by reporter: gen Tb1`i' = Tbj`i'/nj`i'
egen T_between`i' = sum(Tb1`i'), by (reporter)


** THEIL WITHIN      


by reporter: gen shj`i' = (nj`i'/n)*(muj`i'/mu`i')
by reporter: gen Swj`i' = (Exportvalue`i'/muj`i')
egen Twja`i' = sum(Swj`i'*ln(Swj`i')), by (reporter Status`i')
by reporter: gen Twj`i' = Twja`i'/nj`i'


by reporter: gen Twht`i' = shj`i'*Twj`i'
by reporter: gen Tb2`i' = Twht`i'/nj`i'
egen T_within`i' = sum(Tb2`i'), by (reporter)

replace Tred`i' = . if New`i' == .
replace T_between`i' = . if New`i' == .
replace T_within`i' = . if New`i' == .


drop  mu`i' mi`i' Te`i' Sj`i' nj`i' muj`i' Tbj`i' Tb1`i' shj`i' Swj`i' Twja`i' Twj`i' Twht`i' Tb2`i' 
}

collapse  Tred1990 T_between1990 T_within1990 Tred1991 T_between1991 T_within1991 Tred1992 T_between1992 T_within1992 Tred1993 T_between1993 T_within1993 Tred1994 T_between1994 T_within1994 Tred1995 T_between1995 T_within1995 Tred1996 T_between1996 T_within1996 Tred1997 T_between1997 T_within1997 Tred1998 T_between1998 T_within1998 Tred1999 T_between1999 T_within1999 Tred2000 T_between2000 T_within2000 Tred2001 T_between2001 T_within2001 Tred2002 T_between2002 T_within2002 Tred2003 T_between2003 T_within2003 Tred2004 T_between2004 T_within2004   , by(reporter)
		 

reshape long Tred T_between T_within, i(reporter) j(year)
replace Tred = . if Tred == 0
replace T_between = . if T_between == 0
replace T_within = . if T_within == 0
sort reporter year
save Tred.dta, replace

use Diversification.dta, replace
sort reporter year
merge reporter year using Tred.dta 
drop if _merge == 2
drop _merge

gen reduced= 0
replace reduced=1 if Tred ~= .


label var Tred "export Theil - reduced sample"
label var T_between "export Theil between"
label var T_within "export Theil within"
label var  reduced "Dummy for reduced/Theil decomposition sample"

save diversification.dta, replace


