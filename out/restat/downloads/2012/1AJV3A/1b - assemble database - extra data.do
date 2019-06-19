
use "$datapath\kpgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\94extra.dta", replace 

use "$datapath\lpgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\95extra.dta", replace 

use "$datapath\mpgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\96extra.dta", replace 

use "$datapath\npgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\97extra.dta", replace 

use "$datapath\opgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\98extra.dta", replace 

use "$datapath\ppgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\99extra.dta", replace 

use "$datapath\qpgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\00extra.dta", replace 

use "$datapath\rpgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\01extra.dta", replace 

use "$datapath\spgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\02extra.dta", replace 

use "$datapath\tpgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\03extra.dta", replace 

use "$datapath\upgen.dta", clear
save "$datapath\GiavazziMcMahonReStat\04extra.dta", replace 

capture program drop person_income90
program define person_income90
local i=94
while `i'<=99 {
		use "$datapath\GiavazziMcMahonReStat\\`i'extra.dta", clear
		keep  hhnr hhnrakt persnr oeffd`i' nation`i' lfs`i' stib`i' labgro`i' labnet`i' impgro`i' impnet`i'
		rename hhnr hhnum
		rename persnr pnum
		rename hhnrakt new_hhnum`i'
		rename oeffd`i' CS_`i'
		rename nation`i' nationality`i'
		rename lfs`i' lab_force`i'
		rename stib`i' occupation_`i'
		rename labgro`i' gross_inc`i'
		rename labnet`i' net_inc`i' 
		rename impgro`i' gross_flag`i'
		rename impnet`i' net_flag`i'
		generate hhnum`i'=hhnum
		replace hhnum`i'=new_hhnum`i' if new_hhnum`i'~=hhnum
		sort hhnum`i'
		save "$datapath\GiavazziMcMahonReStat\\`i'extra.dta", replace 
		local i=`i'+1
		}
		end

person_income90 

capture program drop person_income00
program define person_income00
local i=0
while `i'<=4 {
		use "$datapath\GiavazziMcMahonReStat\\0`i'extra.dta", clear
		keep  hhnr hhnrakt persnr oeffd0`i' nation0`i' lfs0`i' stib0`i' labgro0`i' labnet0`i' impgro0`i' impnet0`i'
		rename hhnr hhnum
		rename persnr pnum
		rename hhnrakt new_hhnum0`i'
		rename oeffd0`i' CS_0`i'
		rename nation0`i' nationality0`i'
		rename lfs0`i' lab_force0`i'
		rename stib0`i' occupation_0`i'
		rename labgro0`i' gross_inc0`i'
		rename labnet0`i' net_inc0`i' 
		rename impgro0`i' gross_flag0`i'
		rename impnet0`i' net_flag0`i'
		generate hhnum0`i'=hhnum
		replace hhnum0`i'=new_hhnum0`i' if new_hhnum0`i'~=hhnum
		sort hhnum0`i'
		save "$datapath\GiavazziMcMahonReStat\\0`i'extra.dta", replace 
		local i=`i'+1
		}
		end

person_income00 
