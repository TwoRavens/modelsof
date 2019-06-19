
local inout Census_Tax_Linkage\Data

use "`inout'\CensusTax_Crowdout.dta", clear

gen othinc=totinc-(empinc+cqppympe)
gen hsgrad_plus_gen=(hsgrad_plus_hat>0.75)

*--------------------
*1) Employment income
*--------------------

twoway__histogram_gen empinc if hsgrad_plus==0, percent bin(60) gen(x h)
list x h if x!=. & h!=., noobs clean
drop x h
twoway__histogram_gen empinc if hsgrad_plus==1, percent bin(60) gen(x h)
list x h if x!=. & h!=., noobs clean
drop x h
twoway (histogram empinc if hsgrad_plus==0, bin(60) fc(white) lc(black) percent) (histogram empinc if hsgrad_plus==1, gap(50) fc(gray) lc(black) bin(60) percent), legend(order(1 "Low" 2 "High") region(lcolor(white))) plotregion(margin(b=0)) xlabel(-9000(4500)9150, labgap(2) tposition(inside) format(%12.0gc)) xscale(r(-9000(4500)9150)) xline(9150, lwidth(thin) lcolor(black)) xtitle("Employment income relative to the kink", margin(0 0 0 2)) yscale(r(0(0.5)2.5)) ylabel(0(0.5)2.5, labgap(2) angle(horizontal) noticks glcolor(gs13) format(%9.1f)) yline(2.5, lwidth(thin) lcolor(black)) ytitle("") graphregion(color(white)) bgcolor(white) plotregion(margin(0)) title("Percent", justification(left) placement(west) margin(-8 0 5 0) tstyle(body)) scale(1.2)
graph export Histograms_EmpInc_byEduc.eps, replace

*----------------------------------
*2) Workplace pension contributions
*----------------------------------

twoway__histogram_gen penadj if hsgrad_plus==0 & penadj>0 & penadj<=10000, percent bin(60) gen(x h)
list x h if x!=. & h!=., noobs clean
drop x h
twoway__histogram_gen penadj if hsgrad_plus==1 & penadj>0 & penadj<=10000, percent bin(60) gen(x h)
list x h if x!=. & h!=., noobs clean
drop x h
twoway (histogram penadj if hsgrad_plus==0 & penadj>0 & penadj<=10000, bin(60) fc(white) lc(black) percent) (histogram penadj if hsgrad_plus==1 & penadj>0 & penadj<=10000, gap(50) fc(gray) lc(black) bin(60) percent), legend(order(1 "Low" 2 "High") region(lcolor(white))) plotregion(margin(b=0)) xlabel(0(2500)10150, labgap(2) tposition(inside) format(%12.0gc)) xscale(r(0(2500)10150)) xline(10150, lwidth(thin) lcolor(black)) xtitle("Workplace pension contributions", margin(0 0 0 2)) yscale(r(0(2)6)) ylabel(0(2)6, labgap(2) angle(horizontal) noticks glcolor(gs13) format(%9.0f)) yline(6, lwidth(thin) lcolor(black)) ytitle("") graphregion(color(white)) bgcolor(white) plotregion(margin(0)) title("Percent", justification(left) placement(west) margin(-8 0 5 0) tstyle(body)) scale(1.2)
sort hsgrad_plus
graph export Histograms_RPP_byEduc.eps, replace

*------------------------------
*3) Voluntary retirement saving
*------------------------------

twoway__histogram_gen rspcont if hsgrad_plus==0 & rspcont>0 & rspcont<=10000, percent bin(60) gen(x h)
list x h if x!=. & h!=., noobs clean
drop x h
twoway__histogram_gen rspcont if hsgrad_plus==1 & rspcont>0 & rspcont<=10000, percent bin(60) gen(x h)
list x h if x!=. & h!=., noobs clean
drop x h
twoway (histogram rspcont if hsgrad_plus==0 & rspcont>0 & rspcont<=10000, bin(60) fc(white) lc(black) percent) (histogram rspcont if hsgrad_plus==1 & rspcont>0 & rspcont<=10000, gap(50) fc(gray) lc(black) bin(60) percent), legend(order(1 "Low" 2 "High") region(lcolor(white))) plotregion(margin(b=0)) xlabel(0(2500)10150, labgap(2) tposition(inside) format(%12.0gc)) xscale(r(0(2500)10150)) xline(10150, lwidth(thin) lcolor(black)) xtitle("Voluntary retirement saving", margin(0 0 0 2)) yscale(r(0(3)12)) ylabel(0(3)12, labgap(2) angle(horizontal) noticks glcolor(gs13) format(%9.0f)) yline(12, lwidth(thin) lcolor(black)) ytitle("") graphregion(color(white)) bgcolor(white) plotregion(margin(0)) title("Percent", justification(left) placement(west) margin(-8 0 5 0) tstyle(body)) scale(1.2)
graph export Histograms_RSP_byEduc.eps, replace

exit