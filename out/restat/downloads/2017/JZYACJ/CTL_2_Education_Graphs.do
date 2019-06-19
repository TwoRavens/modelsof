
local inout Census_Tax_Linkage\Data

use "`inout'\CensusTax_Education.dta", clear
merge m:1 census06 id using "`inout'\Predicted_Education.dta", keep(3) keepusing(hsgrad_plus_hat) nogen
gen hsgrad_plus_gen=(hsgrad_plus_hat>0.75)

gen saverate=rsprate+penrate

summarize saverate, detail
keep if saverate>=r(p1) & saverate<=r(p99)

*-----------------------------------
*1) Low versus high actual education
*-----------------------------------

preserve
egen grp_ageschl=group(age hsgrad_plus)
collapse age hsgrad_plus saverate, by(grp_ageschl)
replace saverate=saverate*100
list saverate age if hsgrad_plus==0, noobs clean
list saverate age if hsgrad_plus==1, noobs clean

graph twoway (scatter saverate age if hsgrad_plus==0, connect(direct) lcolor(gray) lpattern(solid) msize(small) mcolor(gs5) msymbol(O)) (scatter saverate age if hsgrad_plus==1, connect(direct) lcolor(gray) lpattern(dash) msize(small) mcolor(gs5) msymbol(Oh)), xscale(r(20(10)72)) xlabel(20(10)72, labgap(2) tposition(inside) format(%12.0gc)) xtitle("Age", margin(0 0 0 2)) xline(72, lwidth(thin) lcolor(black)) yscale(r(-2(4)14)) ylabel(-2(4)14, labgap(2) angle(horizontal) noticks glcolor(gs13) format(%9.1f)) yline(14, lwidth(thin) lcolor(black)) ytitle("") graphregion(color(white)) bgcolor(white) plotregion(margin(0)) title("Savings rate", justification(left) placement(west) margin(-8 0 5 0) tstyle(body)) legend(order(1 "Low" 2 "High") region(lcolor(white))) scale(1.2)
graph export SaveRate_by_Educ.eps, replace

restore

*--------------------------------------
*2) Low versus high predicted education
*--------------------------------------

preserve
egen grp_ageschl=group(age hsgrad_plus_gen)
collapse age hsgrad_plus_gen saverate, by(grp_ageschl)
replace saverate=saverate*100
list saverate age if hsgrad_plus_gen==0, noobs clean
list saverate age if hsgrad_plus_gen==1, noobs clean

graph twoway (scatter saverate age if hsgrad_plus_gen==0, connect(direct) lcolor(gray) lpattern(solid) msize(small) mcolor(gs5) msymbol(O)) (scatter saverate age if hsgrad_plus_gen==1, connect(direct) lcolor(gray) lpattern(dash) msize(small) mcolor(gs5) msymbol(Oh)), xscale(r(20(10)72)) xlabel(20(10)72, labgap(2) tposition(inside) format(%12.0gc)) xtitle("Age", margin(0 0 0 2)) xline(72, lwidth(thin) lcolor(black)) yscale(r(-2(4)14)) ylabel(-2(4)14, labgap(2) angle(horizontal) noticks glcolor(gs13) format(%9.1f)) yline(14, lwidth(thin) lcolor(black)) ytitle("") graphregion(color(white)) bgcolor(white) plotregion(margin(0)) title("Savings rate", justification(left) placement(west) margin(-8 0 5 0) tstyle(body)) legend(order(1 "Low" 2 "High") region(lcolor(white))) scale(1.2)
graph export SaveRate_by_PrEduc.eps, replace

restore
preserve

*-------------------------------------
*3) Various levels of actual education
*-------------------------------------

gen hsdropout=((hlos<6 & census06==0) | (hcdd<2 & census06==1))
gen hsgrad=((hlos==6 & census06==0) | (hcdd==2 & census06==1))
gen tradecert=((hlos==7 & census06==0) | ((hcdd==3|hcdd==4) & census06==1))
gen somepse=(((hlos>=8 & hlos<=17) & census06==0) | ((hcdd>=5 & hcdd<=8) & census06==1))

gen hsgrad_tradecert=(hsgrad==1|tradecert==1)

egen grp_schl=group(hsdropout hsgrad_tradecert somepse univgrad_plus)
egen grp_ageschl=group(age grp_schl)

collapse age hsdropout hsgrad_tradecert somepse univgrad_plus saverate, by(grp_ageschl)
replace saverate=saverate*100
list saverate age if hsdropout==1, noobs clean
list saverate age if hsgrad_tradecert==1, noobs clean
list saverate age if somepse==1, noobs clean
list saverate age if univgrad_plus==1, noobs clean

graph twoway (scatter saverate age if hsdropout==1, connect(direct) lcolor(gray) lpattern(solid) msize(small) mcolor(gs5) msymbol(O)) (scatter saverate age if hsgrad_tradecert==1, connect(direct) lcolor(gray) lpattern(dash) msize(small) mcolor(gs5) msymbol(Oh)) (scatter saverate age if somepse==1, connect(direct) lcolor(gray) lpattern(solid) msize(small) mcolor(gs5) msymbol(T)) (scatter saverate age if univgrad_plus==1, connect(direct) lcolor(gray) lpattern(dash) msize(small) mcolor(gs5) msymbol(Sh)), xscale(r(20(10)72)) xlabel(20(10)72, labgap(2) tposition(inside) format(%12.0gc)) xtitle("Age", margin(0 0 0 2)) xline(72, lwidth(thin) lcolor(black)) yscale(r(-2(4)14)) ylabel(-2(4)14, labgap(2) angle(horizontal) noticks glcolor(gs13) format(%9.1f)) yline(14, lwidth(thin) lcolor(black)) ytitle("") graphregion(color(white)) bgcolor(white) plotregion(margin(0)) title("Savings rate", justification(left) placement(west) margin(-8 0 5 0) tstyle(body)) legend(order(1 "High school dropout" 2 "High school or trades" 3 "Some college" 4 "University graduate") region(lcolor(white))) scale(1.2)
graph export SaveRate_by_Educ_4grps.eps, replace

restore

exit