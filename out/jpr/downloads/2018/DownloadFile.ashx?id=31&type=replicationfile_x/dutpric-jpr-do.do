// Bryan Rooney and Matt DiLorenzo
// 7/12/2017
// dr_dyadic_data_11212015.dta do file
// Domestic Uncertainty, Third-Party Resolve, and International Conflict

use "dr_dyadic_data.dta", clear

gen decade= year/10
replace decade=floor(decade)

label var mid_dummy "MID Onset"
label var sols_count_all " SOLS Changes in Potential Intervenors"
label var ally_count_total "Ally Count"
label var stalemate "Probability of Stalemate"
label var past_mids "Past MIDs"
label var mindem "Minimum Democracy Score "
label var contiguity "Contiguity "
label var zero_allies "Zero Allies"
label var hh_mid_dummy "High Hostility MID Onset"
label var sols_count_shared "Shared SOLS Changes"
label var sols_count_exclusive "Exclusive SOLS Changes"
label var peace_years_mid "Peace Years"
label var sols_count_shared_dem  "SOLS Changes- Democracies (Shared)"
label var sols_count_exclusive_dem "SOLS Changes- Democracies (Exclusive)"
label var sols_count_shared_aut "SOLS Changes- Autocracies (Shared)"
label var sols_count_exclusive_aut "SOLS Changes- Autocracies (Exclusive)"
label var mid_count "Count of MIDs"
label var sols_shared_dummy "Shared SOLS Change (Dummy)"
label var sols_exclusive_dummy "Exclusive SOLS Change (Dummy)"
label var wars "War Onset"
label var regtrans_count_all "Regime Transitions"
label var regtrans_count_shared "Regime Transitions (Shared)"
label var regtrans_count_exclusive "Regime Transitions (Exclusive)"
label var leadertrans_count_all "Leader Transitions"
label var leadertrans_count_shared  "Leader Transitions (Shared)"
label var leadertrans_count_exclusive  "Leader Transitions (Exclusive)"


//Tables
eststo: logit mid_dummy sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_exclusive sols_count_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using Table1.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear


eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using Table2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Figures
//Table 1 Model 2 - Range of SOLS exclusive Changes
set scheme s1mono
logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive=(0(1)10)) post
marginsplot, legend(off) ti("Predicted probability of MID in dyad") ///
ytitle("Predicted probability of MID onset") xtitle("SOLS changes in exclusive allies") 

//Table 1 Model 2- Mean to 2SD Above mean exclusive sols changes
logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive=(.5839552 3.2416312)) post
marginsplot, legend(off) ti("Predicted probability of MID in dyad") ///
ytitle("Predicted probability of MID onset") xtitle("SOLS changes in exclusive allies") 

//Table 1 Model 2- range of exclusive ally Changes (Substantive)
logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive=(0(1)10))

//Table 1 Model 2- Mean to 2SD Above mean (Substantive effect) exclusive ally Changes
logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive=(.5839552 3.2416312)) pwcompare

//Table 2 Model 1 - Range of exclusive autocratic ally Changes
logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive_aut=(0(1)5))
marginsplot, legend(off) ti("Predicted probability of MID in dyad") ///
ytitle("Predicted probability of MID onset") xtitle("SOLS changes in exclusive non-democratic allies")

//Table 2 Model 1 - Range of exclusive autocratic ally Changes (substantive)
logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive_aut=(0(1)5))

//Table 2 Model 1 - Mean to 2SD Above mean (Substantive effect) exclusive autocratic ally Changes
logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive_aut=(.0922175 .8629279)) pwcompare

//Table 2 Model 1 - Range of exclusive democratic ally Changes
logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
margins, atmeans at(sols_count_exclusive_dem=(0(1)10))
marginsplot, legend(off) ti("Predicted probability of MID in dyad") ///
ytitle("Predicted probability of MID onset") xtitle("SOLS changes in exclusive democratic allies")

//Table 1 Model 5- HH Mids range and mean plus 2sd
logit hh_mid_dummy sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.year, cluster(rivdyad)
margins, atmeans at(sols_count_sideb_exclusive=(0(1)10))
margins, atmeans at(sols_count_sideb_exclusive=(.2919776 2.1741918)) pwcompare

//Table 2 Model 4- HH Mids range and mean plus 2sd
logit hh_mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.year, cluster(rivdyad)
margins, atmeans at(sols_count_sideb_exclusive_aut=(0(1)10))
margins, atmeans at(sols_count_sideb_exclusive_aut=(.0922175 .8629279)) pwcompare

//RegTrans
eststo: logit mid_dummy sols_count_exclusive sols_count_shared  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy ally_count_total stalemate  past_mids mindem contiguity peace_years_mid regtrans_count_shared regtrans_count_exclusive, cluster(rivdyad)
eststo: logit mid_dummy leadertrans_count_shared leadertrans_count_exclusive   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using AppendixRegLeadTransNonDir.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//War
eststo: logit wars sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad) 
eststo: logit wars sols_count_shared sols_count_exclusive  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid , cluster(rivdyad) 
eststo: logit wars sols_count_shared_dem sols_count_exclusive_dem  sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid , cluster(rivdyad)
esttab using AppendixWarNonDir.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Years
eststo: logit mid_dummy sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if year>1945, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if year>1945, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if year>1945, cluster(rivdyad)
esttab using AppendixYearsNonDir.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Non Linear
gen sols_count_sq=sols_count_all*sols_count_all
gen sols_count_shsq= sols_count_shared*sols_count_shared
gen sols_count_exsq=sols_count_exclusive*sols_count_exclusive
gen sols_count_sdsq= sols_count_shared_dem*sols_count_shared_dem
gen sols_count_edsq=sols_count_exclusive_dem*sols_count_exclusive_dem
gen sols_count_sa=sols_count_shared_aut*sols_count_shared_aut
gen sols_count_ea= sols_count_exclusive_aut*sols_count_exclusive_aut

label var sols_count_sq "SOLS Changes Squared"
label var sols_count_exsq "Exclusive SOLS Changes Squared"
label var sols_count_shsq "Shared SOLS Changes Squared"
label var sols_count_sdsq  "SOLS Changes- Democracies (Shared) Squared"
label var sols_count_edsq "SOLS Changes- Democracies (Exclusive) Squared"
label var sols_count_sa "SOLS Changes- Autocracies (Shared) Squared"
label var sols_count_ea "SOLS Changes- Autocracies (Exclusive) Squared"

eststo: logit mid_dummy sols_count_all sols_count_sq  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_exsq sols_count_shared sols_count_shsq   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_sdsq sols_count_exclusive_dem sols_count_edsq sols_count_shared_aut sols_count_sa sols_count_exclusive_aut sols_count_ea  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using AppendixNonLinNonDir.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Directed
use "dr_dir_dyadic_data_11212015.dta", clear

eststo: logit mid_dummy sols_count_sideb  ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using Table1.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

eststo: logit mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut  ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.year, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.year if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.year, cluster(rivdyad)
esttab using Table2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

eststo: nbreg mid_count sols_count_sideb  ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: nbreg mid_count sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: nbreg mid_count sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: nbreg mid_count sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: nbreg hh_mid_count sols_count_sideb_exclusive sols_count_shared    ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using Table1ct.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

eststo: nbreg mid_count sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: nbreg mid_count sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut  ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: nbreg mid_count sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: nbreg hh_mid_count sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using Table2ct.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

eststo: logit mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut  ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_shared_dem sols_count_sideb_exclusive_dem sols_count_shared_aut sols_count_sideb_exclusive_aut   ally_count_sideb stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using Table2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Appendix: Count
eststo: nbreg mid_count sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: nbreg mid_count sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: nbreg mid_count sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: nbreg mid_count sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: nbreg hh_mid_count sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid , cluster(rivdyad)
esttab using AppendixNonDirectedTable1.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

eststo: nbreg mid_count sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: nbreg mid_count sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: nbreg mid_count sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: nbreg hh_mid_count sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using AppendixNonDirectedTable2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear


//Appendix: ICB

eststo: logit icb_dummy sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit icb_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit icb_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit icb_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit icb_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
esttab using ICBTable1.tex, se(3) star(+ 0.10 * 0.05 ** .01) label replace
eststo clear

eststo: logit icb_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit icb_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit icb_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit icb_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
esttab using ICBTable2.tex, se(3) star(+ 0.10 * 0.05 ** .01) label replace
eststo clear

//Appendix: Defense

use "dutpric-dyadic-defense-11272016.dta", clear
gen decade= year/10
replace decade=floor(decade)

//Tables
eststo: logit mid_dummy sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_exclusive sols_count_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using DefenseTable1.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear


eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using DefenseTable2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Offense

use "dutpric-dyadic-offense-11272016.dta", clear
gen decade= year/10
replace decade=floor(decade)


//Tables
eststo: logit mid_dummy sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_exclusive sols_count_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using OffenseTable1.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear


eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using OffenseTable2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear


//Major Powers

use "dutpric-dyadic-major-powers-only-12192016.dta", clear
gen decade= year/10
replace decade=floor(decade)

//Tables
eststo: logit mid_dummy sols_count_all  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_exclusive sols_count_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_exclusive sols_count_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using MajorPow1.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear


eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy sols_count_shared_dem sols_count_exclusive_dem sols_count_shared_aut sols_count_exclusive_aut   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
esttab using MajorPow2.tex, se star(* 0.10 ** 0.05 *** .01) label replace
eststo clear

//Time Since Last Change

use "dutpric-dyadic-with-time-since-last-sols-01102017.dta", clear
gen decade= year/10
replace decade=floor(decade)

//Tables

eststo: logit mid_dummy t_since_sols_ex  t_since_sols_shared    ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
eststo: logit mid_dummy t_since_sols_ex  t_since_sols_shared  ally_count_total stalemate  past_mids mindem contiguity peace_years_mid if zero_allies==0, cluster(rivdyad)
eststo: logit mid_dummy t_since_sols_ex  t_since_sols_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade, cluster(rivdyad)
eststo: logit mid_dummy t_since_sols_ex  t_since_sols_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid i.decade if zero_allies==0, cluster(rivdyad)
eststo: logit hh_mid_dummy t_since_sols_ex  t_since_sols_shared   ally_count_total stalemate  past_mids mindem contiguity peace_years_mid, cluster(rivdyad)
esttab using TimeSinceSols1.tex, se star(\dagger 0.10 * 0.05 ** .01) label replace
eststo clear
