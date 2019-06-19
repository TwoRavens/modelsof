/*Note 1: Annual raw data for each year between 1995 to 2010 comes from the Annual Manufacturing Survey (AMS) available at DANE's data processing center. Save this do file and the dataset "control.dta" with the AMS raw data and run the do file. */
/*Note 2: The data is available in SAS, before running this do file export all raw data files to stata*/
********************************************************************************
clear all
set more off
cd "\\bdatos_server\SALA DE PROCESAMIENTO\TC6_UNIVERSIDAD CASTILLA\SANDRA ROZO\ENTRA\Stata_files\" /*set preferred folder path*/

************************************
**Output Prices Data Base **********
************************************
forvalues i=95(1)99 {
use mpio-`i'.dta, clear             
duplicates drop nordest, force
save mpio-`i'.dta, replace
use p-`i'.dta, clear                
merge m:1 nordest using mpio-`i'.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=19`i'
keep dpto mpio year nordemp nordest codigo vuv vup valorv
save p19`i'.dta, replace
}

use mpio-00.dta, clear
duplicates drop nordest, force
save mpio-00.dta, replace
use p-00.dta, clear
merge m:1 nordest using mpio-00.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=2000
keep dpto mpio year nordemp nordest codigo vuv vup valorv
save p2000.dta, replace

forvalues i=1(1)9 {
use mpio-0`i'.dta, clear
duplicates drop nordest, force
save mpio-0`i'.dta, replace
use p-0`i'.dta, clear
merge m:1 nordest using mpio-0`i'.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=200`i'
keep dpto mpio year nordemp nordest codigo vuv vup valorv
save p200`i'.dta, replace
}

use mpio-10.dta, clear
duplicates drop nordest, force
save mpio-10.dta, replace
use p-10.dta, clear
merge m:1 nordest using mpio-10.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=2010
keep dpto mpio year nordemp nordest codigo vuv vup valorv
save p2010.dta, replace

forvalues i=2001(1)2007{
use p`i'.dta, clear
drop if codigo=="OP"
g cod=real(codigo)
drop codigo
rename cod codigo
save p`i'.dta, replace
}

use p2010.dta, clear
drop if vup=="OP"
g vq=real(vup)
drop vup
rename vq vup
save p2010.dta, replace

use p1995.dta, clear
save prices.dta, replace
forvalues i=1996(1)2010{
merge m:m mpio dpto year using p`i'.dta
drop _merge
save prices.dta, replace
erase p`i'.dta
}
erase p1995.dta

merge m:m dpto mpio using divipola.dta     
drop if _merge==2
drop _merge mpio dpto
rename divipola muncod
drop if nordest==.
drop if _merge==2
drop _merge 
save out_prices.dta, replace

use out_prices.dta, clear
merge m:m nordemp using industry		  
drop if _merge==2
drop _merge
rename sector prod_cod
save op, replace

*******************
**Merging Controls*
*******************
merge m:m muncod year using controls.dta   
drop if _merge==2
drop _merge
g lvuv=log(vuv)
save op.dta, replace
erase "out_prices"

************************************************
**Input Prices Data Base ***********************
************************************************
forvalues i=95(1)99 {
use mpio-`i'.dta, clear
duplicates drop nordest, force
save mpio-`i'.dta, replace
use m-`i'.dta, clear					
merge m:1 nordest using mpio-`i'.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=19`i'
keep mpio dpto year nordest codmate vuc valorcom 
save m19`i'.dta, replace
}

use mpio-00.dta, clear
duplicates drop nordest, force
save mpio-00.dta, replace
use m-00.dta, clear
merge m:1 nordest using mpio-00.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=2000
keep mpio dpto year nordest codmate vuc valorcom 
save m2000.dta, replace

forvalues i=1(1)9 {
use mpio-0`i'.dta, clear
duplicates drop nordest, force
save mpio-0`i'.dta, replace
use m-0`i'.dta, clear
merge m:1 nordest using mpio-0`i'.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=200`i'
keep mpio dpto year nordest codmate vuc valorcom 
save m200`i'.dta, replace
}

use mpio-10.dta, clear
duplicates drop nordest, force
save mpio-10.dta, replace
use m-10.dta, clear
merge m:1 nordest using mpio-10.dta
drop if _merge==2
drop _merge
drop if mpio==.
g year=2010
keep mpio dpto year nordest codmate vuc valorcom  
save m2010.dta, replace

forvalues i=2001(1)2007{
use m`i'.dta, clear
drop if codmate=="OP"
g cod=real(codmate)
drop codmate
rename cod codmate
save m`i'.dta, replace
}

use m1995.dta, clear
save iprices.dta, replace
forvalues i=1996(1)2010{
use iprices.dta, clear
merge m:m mpio dpto year using m`i'.dta
drop if _merge==2
drop _merge
save iprices.dta, replace
}

merge m:m dpto mpio using divipola.dta
drop if _merge==2
drop _merge
rename divipola muncod
drop mpio dpto

merge m:m nordemp using industry
drop if _merge==2
drop _merge
rename sector prod_cod
save inp_prices, replace

*******************
**Merging Controls*
*******************
merge m:1 muncod year using controls
drop if _merge==2
drop _merge
g lvuc=log(vuc)
save ip.dta, replace
erase "inp_prices"
