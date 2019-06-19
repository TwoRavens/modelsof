
clear all
set more off
capture log close
set mat 5000



cd "C:\Users\rujia\Dropbox\coalmine\restat"

********Figure 1 is a map of coal production********
**************Figure 2****************************
use Coalmine.dta, clear
drop if native==.
drop if leader_id==.

gen ln_output = log(prod0)

gen prod0_normalized=prod0/10000
label var prod0_normalized "Output"


label var ln_output "ln Output"

order native

capture drop switch_indicator

bysort prov_id: gen switch_indicator=native[_n]-native[_n-1]

order switch_indicator

drop if switch_indicator==.

gen switch2native=(switch_indicator==1)

gen switch2nonnative=(switch_indicator==-1)

gen switch0=(switch_indicator==1)

bysort year: egen switchtonative=sum(switch2native)
bysort year: egen switchtononnative=sum(switch2nonnative)
bysort year: gen noswitch=22- switchtonative-switchtononnative
*bysort year: gen noswitch=sum(switch0)

order  switchtonative  switchtononnative  noswitch

keep if prov_id==1
#delimit ;
graph twoway (scatter switchtonative year, lcolor(black) lwidth(medthick) lpattern(dash) mcolor(black) msize(small)  msymbol(+)) 
(scatter switchtononnative year, lcolor(black) lwidth(medthick) lpattern(longdash_dot) mcolor(black) msize(large)  ms(oh)) 
(scatter noswitch year, lcolor(black) lwidth(medthick) mcolor(black) msize(small) msymbol(diamond)),
graphregion(color(white))
xline(1997.8 2000.7, lpat(dash) lcolor(black))   ytitle (# provinces) 
 text(23 1999.3  "# Non-switch") 
yscale(range(0 30))
legend(row (1) size(normal)) scheme(mono) ;


graph export draft/Figure2_Switches.png, replace; 


********Figure 3 visulize the results in Table 5****

****Figure A1 distribution of #deaths 
use Coalmine.dta, clear
drop if native==.
drop if leader_id==.

hist death if death<50, bin(50)

**Figure A2 is the yearly price of coal**

******Figure A3****



bysort year: egen deathrate_native=mean (deathrate) if native==1

bysort year: egen deathrate_nonnative=mean (deathrate) if native==0

bysort year: egen deathrate_mean=mean (deathrate)




*(connect  deathrate_mean year, lcolor(black) lwidth(medthick) mcolor(black) msize(medium) msymbol(x)) 

#delimit ;

twoway 
(connect deathrate_native year, lcolor(black) lwidth(medthick) lpattern(solid) mcolor(black) msize(medium)  msymbol(circle)) (connect deathrate_nonnative year, lcolor(black) lwidth(medthick) lpattern(longdash_dot) mcolor(black) msize(large)  ms(oh)), 
graphregion(color(white))
xline(1997.8 2000.7, lpat(dash))  text(6 1999.3  "Decentralized")  ytitle (Average Death Rates) 
legend (row (1)  size(small)) legend(label (1 "Native") label (2 "Non-native"));

graph export draft/Comparison.png, replace;




