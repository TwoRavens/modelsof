 
clear
set memory 700m

****COMPUTE THE INDICES OF CONCENTRATION

/*
use export.dta
save export2.dta, replace



*** COMPUTE THE NUMBER OF NEW PRODUCT WITH ALTERNATIVE DEFINITION

**** BESEDES AND PRUSA DEFINITION 

foreach i of numlist 1989/2005 {
rename Exportvalue`i' Exportvalue

** STATUS

local j = `i' - 1
gen Pre= Exportvalue`j'
local k =`i' + 1
gen Post= Exportvalue`k'

gen Status=1
replace Status=2 if Pre==0 &  Exportvalue~=0 & Post~=0 
replace Status=3 if Pre~=0
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
replace New`i' = . if Exportvalue`j'== . 
replace VNew`i' = . if Exportvalue`j'== . 

drop S
compress


}

save New_1period.dta, replace

collapse New1989 New1990 New1991 New1992 New1993 New1994 New1995 New1996 New1997 New1998 New1999 New2000 New2001 New2002 New2003 New2004 New2005 VNew1989 VNew1990 VNew1991 VNew1992 VNew1993 VNew1994 VNew1995 VNew1996 VNew1997 VNew1998 VNew1999 VNew2000 VNew2001 VNew2002 VNew2003 VNew2004 VNew2005, by(reporter)
		 

reshape long New VNew, i(reporter) j(year)
sort reporter year
save New_1period.dta, replace



**** CADOT CARRERE AND SK DEFINITION 

use export2.dta, clear

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

collapse New1990 New1991 New1992 New1993 New1994 New1995 New1996 New1997 New1998 New1999 New2000 New2001 New2002 New2003 New2004 VNew1990 VNew1991 VNew1992 VNew1993 VNew1994 VNew1995 VNew1996 VNew1997 VNew1998 VNew1999 VNew2000 VNew2001 VNew2002 VNew2003 VNew2004 , by(reporter)
		 

reshape long New VNew, i(reporter) j(year)
sort reporter year
save New_2period.dta, replace
*/

**** KLINGER AND LEDERMAN DEFINITION


******************************************************************************
* New product 1997

use export2.dta, clear
keep if Exportvalue1988 == 0 & Exportvalue1989 == 0 & Exportvalue1990 == 0 
keep if Exportvalue1996 > 12.300 & Exportvalue1997 > 12.300 
drop if Exportvalue1991 == 0 & Exportvalue1992== 0 & Exportvalue1993 == 0
drop if Exportvalue1992 == 0 & Exportvalue1993 == 0 & Exportvalue1994 == 0
drop if Exportvalue1993 == 0 & Exportvalue1994 == 0 & Exportvalue1995 == 0

egen new97 = count(Exportvalue1997), by(reporter)
egen Vnew97 = sum (Exportvalue1997), by(reporter)
drop  Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997  Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004  Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL97, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL97.dta
drop _merge
save export2.dta, replace
save KLyear, replace

******************************************************************************
* New product 1998

use export2.dta, clear
keep if Exportvalue1989 == 0 & Exportvalue1990 == 0 & Exportvalue1991 == 0 
keep if Exportvalue1997 > 12.300 & Exportvalue1998 > 12.300 
drop if Exportvalue1992 == 0 & Exportvalue1993== 0 & Exportvalue1994 == 0
drop if Exportvalue1993 == 0 & Exportvalue1994 == 0 & Exportvalue1995 == 0
drop if Exportvalue1994 == 0 & Exportvalue1995 == 0 & Exportvalue1996 == 0
drop if new97 ~= .

egen new98 = count(Exportvalue1998), by(reporter)
egen Vnew98 = sum (Exportvalue1998), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997 Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004 Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL98, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL98.dta
drop _merge 
save export2.dta, replace
*drop new97 Vnew97 
save KLyear, replace

******************************************************************************
* New product 1999

use export2.dta, clear
keep if Exportvalue1990 == 0 & Exportvalue1991 == 0 & Exportvalue1992 == 0 
keep if Exportvalue1998 > 12.300 & Exportvalue1999 > 12.300 
drop if Exportvalue1993 == 0 & Exportvalue1994== 0 & Exportvalue1995 == 0
drop if Exportvalue1994 == 0 & Exportvalue1995 == 0 & Exportvalue1996 == 0
drop if Exportvalue1995 == 0 & Exportvalue1996 == 0 & Exportvalue1997 == 0
drop if new97 ~= .
drop if new98 ~= .

egen new99 = count(Exportvalue1999), by(reporter)
egen Vnew99 = sum (Exportvalue1999), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997 Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004 Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL99, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL99.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 Vnew97 Vnew98 
save KLyear, replace

******************************************************************************
* New product 2000

use export2.dta, clear
keep if Exportvalue1991 == 0 & Exportvalue1992 == 0 & Exportvalue1993 == 0 
keep if Exportvalue1999 > 12.300 & Exportvalue2000 > 12.300 
drop if Exportvalue1994 == 0 & Exportvalue1995== 0 & Exportvalue1996 == 0
drop if Exportvalue1995 == 0 & Exportvalue1996 == 0 & Exportvalue1997 == 0
drop if Exportvalue1996 == 0 & Exportvalue1997 == 0 & Exportvalue1998 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .

egen new00 = count(Exportvalue2000), by(reporter)
egen Vnew00 = sum (Exportvalue2000), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997 Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004  Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL00, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL00.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 Vnew97 Vnew98 Vnew99 
save KLyear, replace

******************************************************************************
* New product 2001

use export2.dta, clear
keep if Exportvalue1992 == 0 & Exportvalue1993 == 0 & Exportvalue1994 == 0 
keep if Exportvalue2000 > 12.300 & Exportvalue2001 > 12.300 
drop if Exportvalue1995 == 0 & Exportvalue1996 == 0 & Exportvalue1997 == 0
drop if Exportvalue1996 == 0 & Exportvalue1997 == 0 & Exportvalue1998 == 0
drop if Exportvalue1997 == 0 & Exportvalue1998 == 0 & Exportvalue1999 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .
drop if new00 ~= .

egen new01 = count(Exportvalue2001), by(reporter)
egen Vnew01 = sum (Exportvalue2001), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997  Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004 Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL01, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL01.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 new00 Vnew97 Vnew98 Vnew99 Vnew00 
save KLyear, replace

******************************************************************************
* New product 2002

use export2.dta, clear
keep if Exportvalue1993 == 0 & Exportvalue1994 == 0 & Exportvalue1995 == 0 
keep if Exportvalue2001 > 12.300 & Exportvalue2002 > 12.300 
drop if Exportvalue1996 == 0 & Exportvalue1997 == 0 & Exportvalue1998 == 0
drop if Exportvalue1997 == 0 & Exportvalue1998 == 0 & Exportvalue1999 == 0
drop if Exportvalue1998 == 0 & Exportvalue1999 == 0 & Exportvalue2000 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .
drop if new00 ~= .
drop if new01 ~= .

egen new02 = count(Exportvalue2002), by(reporter)
egen Vnew02 = sum (Exportvalue2002), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997 Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004  Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL02, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL02.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 new00 new01 Vnew97 Vnew98 Vnew99 Vnew00 Vnew01 
save KLyear, replace

******************************************************************************
* New product 2003

use export2.dta, clear
keep if Exportvalue1994 == 0 & Exportvalue1995 == 0 & Exportvalue1996 == 0 
keep if Exportvalue2002 > 12.300 & Exportvalue2003 > 12.300 
drop if Exportvalue1997 == 0 & Exportvalue1998 == 0 & Exportvalue1999 == 0
drop if Exportvalue1998 == 0 & Exportvalue1999 == 0 & Exportvalue2000 == 0
drop if Exportvalue1999 == 0 & Exportvalue2000 == 0 & Exportvalue2001 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .
drop if new00 ~= .
drop if new01 ~= .
drop if new02 ~= .

egen new03 = count(Exportvalue2003), by(reporter)
egen Vnew03 = sum (Exportvalue2003), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997 Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004  Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL03, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL03.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 new00 new01 new02 Vnew97 Vnew98 Vnew99 Vnew00 Vnew01 Vnew02 
save KLyear, replace

******************************************************************************
* New product 2004

use export2.dta, clear
keep if Exportvalue1995 == 0 & Exportvalue1996 == 0 & Exportvalue1997 == 0 
keep if Exportvalue2003 > 12.300 & Exportvalue2004 > 12.300 
drop if Exportvalue1998 == 0 & Exportvalue1999 == 0 & Exportvalue2000 == 0
drop if Exportvalue1999 == 0 & Exportvalue2000 == 0 & Exportvalue2001 == 0
drop if Exportvalue2000 == 0 & Exportvalue2001 == 0 & Exportvalue2002 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .
drop if new00 ~= .
drop if new01 ~= .
drop if new02 ~= .
drop if new03 ~= .

egen new04 = count(Exportvalue2004), by(reporter)
egen Vnew04 = sum (Exportvalue2004), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997  Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004 Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL04, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL04.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 new00 new01 new02 new03 Vnew97 Vnew98 Vnew99 Vnew00 Vnew01 Vnew02 Vnew03 
save KLyear, replace

******************************************************************************
* New product 2005

use export2.dta, clear
keep if Exportvalue1996 == 0 & Exportvalue1997 == 0 & Exportvalue1998 == 0 
keep if Exportvalue2004 > 12.300 & Exportvalue2005 > 12.300 
drop if Exportvalue1999 == 0 & Exportvalue2000 == 0 & Exportvalue2001 == 0
drop if Exportvalue2000 == 0 & Exportvalue2001 == 0 & Exportvalue2002 == 0
drop if Exportvalue2001 == 0 & Exportvalue2002 == 0 & Exportvalue2003 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .
drop if new00 ~= .
drop if new01 ~= .
drop if new02 ~= .
drop if new03 ~= .
drop if new04 ~= .

egen new05 = count(Exportvalue2005), by(reporter)
egen Vnew05 = sum (Exportvalue2005), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997  Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004 Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL05, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL05.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 new00 new01 new02 new03 new04 Vnew97 Vnew98 Vnew99 Vnew00 Vnew01 Vnew02 Vnew03 Vnew04 
save KLyear, replace

******************************************************************************
* New product 2006

use export2.dta, clear
keep if Exportvalue1997 == 0 & Exportvalue1998 == 0 & Exportvalue1999 == 0 
keep if Exportvalue2005 > 12.300 & Exportvalue2006 > 12.300 
drop if Exportvalue2000 == 0 & Exportvalue2001 == 0 & Exportvalue2002 == 0
drop if Exportvalue2001 == 0 & Exportvalue2002 == 0 & Exportvalue2003 == 0
drop if Exportvalue2002 == 0 & Exportvalue2003 == 0 & Exportvalue2004 == 0
drop if new97 ~= .
drop if new98 ~= .
drop if new99 ~= .
drop if new00 ~= .
drop if new01 ~= .
drop if new02 ~= .
drop if new03 ~= .
drop if new04 ~= .
drop if new05 ~= .

egen new06 = count(Exportvalue2006), by(reporter)
egen Vnew06 = sum (Exportvalue2006), by(reporter)
drop Exportvalue1991 Exportvalue1990 Exportvalue1989 Exportvalue1988 Exportvalue1997 Exportvalue1998 Exportvalue2006 Exportvalue2005 Exportvalue2004 Exportvalue1996 Exportvalue1995 Exportvalue1994 Exportvalue1993 Exportvalue1992 Exportvalue2003 Exportvalue2002 Exportvalue2001 Exportvalue2000 Exportvalue1999
sort reporter product
save KL06, replace

use export2.dta, clear
sort reporter product
merge reporter product using KL06.dta
drop _merge 
save export2.dta, replace
*drop new97 new98 new99 new00 new01 new02 new03 new04 new05 Vnew97 Vnew98 Vnew99 Vnew00 Vnew01 Vnew02 Vnew03 Vnew04 Vnew05 
save KLyear, replace



erase KL06.dta 
erase KL05.dta 
erase KL04.dta  
erase KL03.dta  
erase KL02.dta  
erase KL01.dta  
erase KL00.dta  
erase KL99.dta  
erase KL98.dta  
erase KL97.dta 

foreach i of numlist 97/99 {
rename new`i' New19`i'
rename Vnew`i' VNew19`i'
}

rename new00 New2000
rename new01 New2001
rename new02 New2002
rename new03 New2003
rename new04 New2004
rename new05 New2005
rename new06 New2006
rename Vnew00 VNew2000
rename Vnew01 VNew2001
rename Vnew02 VNew2002
rename Vnew03 VNew2003
rename Vnew04 VNew2004
rename Vnew05 VNew2005
rename Vnew06 VNew2006

save KLyear, replace

collapse  New1997 New1998 New1999 New2000 New2001 New2002 New2003 New2004 New2005 New2006 VNew1997 VNew1998 VNew1999 VNew2000 VNew2001 VNew2002 VNew2003 VNew2004 VNew2005 VNew2006, by(reporter)
		 

reshape long New VNew, i(reporter) j(year)
replace New = 0 if New ==.
replace VNew = 0 if VNew ==.
sort reporter year
save New_KL.dta, replace

erase KLyear.dta 
erase export2.dta 



use New_1period.dta
rename New New_1period
rename VNew VNew_1period
sort reporter year
save, replace

use New_2period.dta, replace
rename New New_2period
rename VNew VNew_2period
sort reporter year
save, replace

use New_KL.dta, replace
rename New New_KL
rename VNew VNew_KL
sort reporter year
save, replace


use Diversification.dta, replace
sort reporter year
merge reporter year using New_1period.dta 
drop if _merge == 2
drop _merge
sort reporter year
merge reporter year using New_2period.dta
drop if _merge == 2
drop _merge
sort reporter year
merge reporter year using New_KL.dta
drop if _merge == 2
drop _merge
sort reporter year

label var  New_1period "Nber of New lines - BP def"
label var  VNew_1period "Value of New lines - BP def"
label var  New_2period "Nber of New lines - CCSK def"
label var  VNew_2period "Value of New lines - CCSK def"
label var   New_KL "Nber of New lines - KL def"
label var   VNew_KL "Value of New lines - KL def"

save Diversification.dta, replace

erase New_KL.dta
erase New_2period.dta
erase New_1period.dta

