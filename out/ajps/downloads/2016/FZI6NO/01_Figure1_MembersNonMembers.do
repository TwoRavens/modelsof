clear all
cd "~/Dropbox/EconNationalism_Union/UnionInformation/ReplicationPackage"
use "UnionInformation_ReplicationData.dta"

recode naics (336 = 1) (332 = 2) (325 = 3) (311 = 4) (517 = 5) (236 = 6) (621 = 7) (611 = 8) (623 = 9), gen(naics_id)

label define industry 1 "Transportation Equipment" 2 "Fabricated Metal" ///
	3 "Chemical Manufacturing" 4 "Food Manufacturing" 5 "Telecommunication" 6 "Building Construction" ///
	7 "Ambulatory Health Care" 8 "Education" 9 "Nursing/Residential Care"
	
label values naics_id industry

gen trade_reduction=0 /* creating DVs */
replace trade_reduction = 1 if trade4 == 4 | trade4==5

gen trade_self=0 /* creating DVs */
replace trade_self= 1 if trade1 == 4 | trade1 == 5

gen trade_us=0 /* creating DVs */
replace trade_us = 1 if trade3 == 4 | trade3 == 5

* Average Support for Trade Reduction by Union Membership & Industry
bysort naics_id: egen trade_avg_level_u = mean(trade_reduction) if union_member == 1
bysort naics_id: egen trade_avg_level_n = mean(trade_reduction) if union_member == 0
bysort naics_id: egen trade_avg_level_u2 = mean(trade_avg_level_u)
bysort naics_id: egen trade_avg_level_n2 = mean(trade_avg_level_n)

* Negative View on Trade on Self by Union Membership & Industry 
bysort naics_id: egen trade_avg_self_u = mean(trade_self) if union_member == 1
bysort naics_id: egen trade_avg_self_n = mean(trade_self) if union_member == 0
bysort naics_id: egen trade_avg_self_u2 = mean(trade_avg_self_u)
bysort naics_id: egen trade_avg_self_n2 = mean(trade_avg_self_n)

* Negative View on Trade on US by Union Membership & Industry 
bysort naics_id: egen trade_avg_us_u = mean(trade_us) if union_member == 1
bysort naics_id: egen trade_avg_us_n = mean(trade_us) if union_member == 0
bysort naics_id: egen trade_avg_us_u2 = mean(trade_avg_us_u)
bysort naics_id: egen trade_avg_us_n2 = mean(trade_avg_us_n)

duplicates drop naics_id, force

* Drop Industries with Few Union Members 
drop if naics == 334 | naics == 518 | naics == 523

* Keep Relevant Variables
keep naics_id  *u2 *n2 

expand 3
sort naics_id  
by naics_id: gen id = _n

* Trade View by Union Members
gen trade_view_u = trade_avg_level_u2 if id == 1
replace trade_view_u = trade_avg_self_u2 if id == 2
replace trade_view_u = trade_avg_us_u2 if id == 3

* Trade View by Non-Union Members 
gen trade_view_n = trade_avg_level_n2 if id == 1
replace trade_view_n = trade_avg_self_n2 if id == 2
replace trade_view_n = trade_avg_us_n2 if id == 3

gen id_description = "Trade Level (%)" if id == 1
replace id_description = "Trade on Self (%)" if id == 2
replace id_description = "Trade on US (%)" if id == 3

keep naics_id trade_view_u trade_view_n id id_description

graph dot (mean) trade_view_u trade_view_n, over(naics_id) marker(1, mcolor(black) msize(medlarge) msymbol(triangle)) marker(2, mcolor(gs10) msize(medlarge) msymbol(triangle)) ylabel(0(0.2)0.6) legend(cols(2) region(fcolor(white) lcolor(white))) by(, graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) ///
 legend(order(1 "Union Member" 2 "Non-Union Member")) by(id_description, cols(3)) subtitle(, fcolor(white) lcolor(white)) sort(naics_id) ysize(4) xsize(8)
gr_edit .plotregion1.grpaxis[2].draw_view.setstyle, style(no)
gr_edit .plotregion1.grpaxis[3].draw_view.setstyle, style(no)

