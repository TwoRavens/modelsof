clear all
cd "~/Dropbox/EconNationalism_Union/UnionInformation/ReplicationPackage"
use "UnionInformation_ReplicationData.dta"

gen union_protection="Govt. Employees" if union_name=="American Federation of Government Employees (AFGE)"
replace union_protection="Teachers" if union_name=="American Federation of Teachers (AFT)"
replace union_protection="CWA" if union_name=="Communication Workers of America (CWA)"
replace union_protection="AFSCME" if union_name=="Federation of St./Cty./Mun. (AFSCME)"
replace union_protection="IBEW" if union_name=="IBEW"
replace union_protection="IAM:Machinists" if union_name=="Machinists (IAM)"
replace union_protection="NEA" if union_name=="National Education Association (NEA)"
replace union_protection="Service Employees" if union_name=="Service Employees Intl Union (SEIU)"
replace union_protection="Teamsters" if union_name=="Teamsters"
replace union_protection="Auto Workers" if union_name=="United Auto Workers (UAW)"
replace union_protection="Carpenters" if union_name=="United Brotherhood of Carpenters"
replace union_protection="UFCW" if union_name=="United Food and Commercial Workers"
replace union_protection="Steelworkers" if union_name=="United Steelworkers (USW)"
replace union_protection="IFPTE" if union_name=="IFPTE"

* Share of Unions Members Who Say Unions Have Multiple Communications about Trade with Members
gen union_trade_frequency = 0 if union4 == 5 | union4 == 4 
replace union_trade_frequency = 1 if union4 == 1 | union4==2 | union4==3 
bysort union_protection: egen d_union_trade_frequency = mean(union_trade_frequency)
label var d_union_trade_frequency ""

* Share of Unions Members Who Think Their Unions are Protectionist
gen union_trade_reduction = 0 if union2 == 1 | union2 == 2 | union2 ==3
replace union_trade_reduction = 1 if union2 == 4 | union2 == 5
bysort union_protection: egen d_union_trade_reduction = mean(union_trade_reduction)

* Share of Unions Members Who Are Familiar with Union's View on Trade 
gen union_familiar = 0 if union3 == 3 | union3 == 4
replace union_familiar = 1 if union3 == 1 | union3 == 2
bysort union_protection: egen d_union_familiar = mean(union_familiar)
label var d_union_familiar ""

drop if union_score ==.
label var union_score "Union's Protectionism Score"
duplicates drop union_protection, force

gen union_id = _n
	
keep union_id union_score union_protection union_name d_union_trade_reduction d_union_familiar d_union_trade_frequency
	
* Lowess

twoway (scatter union_score d_union_trade_frequency, mcolor(black) msymbol(circle) msize(small)) (lowess union_score d_union_trade_frequency, lpattern(shortdash) lcolor(gs10)), fysize(70) fxsize(110) legend(off) xtitle("Multiple Communications" "on Trade in Past Year (%)") yline(0 3 4 5 6 8 9 13 15 19 20 22, lwidth(vthin) lcolor(gs13)) ylabel(none, labels valuelabel) legend(region(fcolor(white) margin(zero) lcolor(white) lwidth(none) lpattern(solid)) bmargin(medium)) graphregion(fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) ylabel(13 "Carpenters" 22 "Teamsters" 7 "IBEW" 4 "United Food/Commercial" 15 "United Auto Workers" 20 "Steelworkers" 19 "IAM:Machinists" 8 "IFPTE" 9 "Communication Workers" 5 "Service Employees" 0 "Federation of Teachers" 1 "Natl Education Assn" 3 "State/County/Municipal" 6 "Govt Employees", labels angle(horizontal) valuelabel noticks) 
graph save Graph "ByUnionCommunication_L_Sub1.gph", replace

twoway (scatter union_score d_union_familiar, mcolor(black) msymbol(circle) msize(small)) (lowess union_score d_union_familiar, lpattern(shortdash) lcolor(gs10)), xscale(range(0 1)) xlabel(0(0.2)1) fysize(70) fxsize(70) legend(off) xtitle("Familiar with" "Union's View on Trade (%)") yline(0 3 4 5 6 8 9 13 15 19 20 22, lwidth(vthin) lcolor(gs13)) ylabel(none, labels valuelabel) legend(region(fcolor(white) margin(zero) lcolor(white) lwidth(none) lpattern(solid)) bmargin(medium)) graphregion(fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) /* ylabel(13 "Carpenters" 22 "Teamsters" 7 "IBEW" 4 "United Food/Commercial" 15 "United Auto Workers" 20 "Steelworkers" 19 "IAM:Machinists" 8 "IFPTE" 9 "Communication Workers" 5 "Service Employees" 0 "Federation of Teachers" 1 "Natl Education Assn" 3 "State/County/Municipal" 6 "Govt Employees", labels angle(horizontal) valuelabel noticks)*/
graph save Graph "ByUnionCommunication_L_Sub2.gph", replace

twoway (scatter union_score d_union_trade_reduction, mcolor(black) msymbol(circle) msize(small)) (lowess union_score d_union_trade_reduction, lpattern(shortdash) lcolor(gs10)), xscale(range(0 1)) xlabel(0(0.2)1) fysize(70) fxsize(70) legend(off) xtitle("Members' Perception of" "Union as Protectionist (%)") yline(0 3 4 5 6 8 9 13 15 19 20 22, lwidth(vthin) lcolor(gs13)) ylabel(none, labels valuelabel) legend(region(fcolor(white) margin(zero) lcolor(white) lwidth(none) lpattern(solid)) bmargin(medium)) graphregion(fcolor(white) ifcolor(white) color(white) lcolor(white) ilcolor(white)) /* ylabel(13 "Carpenters" 22 "Teamsters" 7 "IBEW" 4 "United Food/Commercial" 15 "United Auto Workers" 20 "Steelworkers" 19 "IAM:Machinists" 8 "IFPTE" 9 "Communication Workers" 5 "Service Employees" 0 "Federation of Teachers" 1 "Natl Education Assn" 3 "State/County/Municipal" 6 "Govt Employees", labels angle(horizontal) valuelabel noticks)*/ 
graph save Graph "ByUnionCommunication_L_Sub3.gph", replace

graph combine ByUnionCommunication_L_Sub1.gph ByUnionCommunication_L_Sub2.gph ByUnionCommunication_L_Sub3.gph, cols(3) ysize(4) xsize(7.5)


