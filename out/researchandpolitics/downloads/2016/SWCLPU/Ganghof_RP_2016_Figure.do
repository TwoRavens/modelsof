***Ganghof 2016, Combining Proportional and Majoritarian Democracy: An Institutional Design Proposal
***Figure

***Load Chapel/Hill 2014 Data [dataset means]
use "http://chesdata.eu/2014/2014_CHES_dataset_means.dta", clear

*Keep german parties
keep if cname=="ger"

*english party names
replace party_name="Left" if party_name=="Linke"
replace party_name="Greens" if party_name=="Grunen"
replace party_name="Pirates" if party_name=="Piraten"

*drop very small parties (<2% of the vote)
drop if party_name=="NPD" | party_name=="DieTier"

*parties that missed the 5% threshold
gen threshmiss = party_name=="Pirates" | party_name=="AfD" | party_name=="FDP"

label var galtan "Liberalism/Authoritarianism (galtan)"
label var lrecon "Economic policy (lrecon)"

local sharedop "mlabel(party_name) msize(medlarge)  mlabs(medium)"
local to "size(small)"
local tothresh "c(gs7)"

tw (scatter  galtan lrecon  if threshmiss, `sharedop' mlabpos(9) m(Oh) mc(gs7) mlabc(gs7)) ///
   (scatter  galtan lrecon  if threshmiss==0, `sharedop'  m(O) mc(black) mlabc(black)) ///
   ,text(1.5 2.6 "(2.2/0)", `to' `tothresh') text(1.7 4.1 "(8.4/10.0)", `to' )  text(3 7.5 "(4.8/0)", `to' `tothresh')  text(8.2 7.9  "(4.6/0)", `to' `tothresh') ///
    text(5.5 6.2 "(34.1/40.4)", `to') text(4.4 1.5 "(8.6/10.1)", `to')  text(3.7 4 "(25.7/30.6)", `to')  text(7.4 6.5 "(7.4/8.9)", `to') ///
   scheme(s1mono) legend(off) ylabel(0(2)10) xlabel(0(2)10) 
   
exit
