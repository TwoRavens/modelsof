* This file provides the syntax needed to replicate the analysis in
* "From Melos to Baghdad: Explaining Resistance to Militarized Challenges 
* from More Powerful States"

* There are two replication files, "ICBanalysis.dta," containing the
* data needed to replicate our analysis of the ICB dataset, and "MIDanalysis,"
* which has the data needed to replicate our analysis of the MID data.

* This syntax will replicate the analysisn of the MID data in Table 3
* Table 3, model 1
heckprob recip3 polity2_s lntpop_t regime territory vetoplayers_t military_t allybalance powerbalance contig, select(demand=polity2_s lntpop_t vetoplayers_t military_t powerbalance allybalance cinc_s syscon contig peaceyrs _prefail _spline1 _spline2 _spline3)
* Table 3, model 2
heckprob recip3 polity2_s lntpop_t regime territory polity2_t1 military_t allybalance powerbalance contig, select(demand=polity2_s lntpop_t polity2_t1 military_t powerbalance allybalance cinc_s syscon contig peaceyrs _prefail _spline1 _spline2 _spline3)
* Table 3, model 3
heckprob recip3 polity2_s lntpop_t ethfrac_t lmtnest_t regime territory polity2_t1 military_t allybalance powerbalance contig, select(demand=polity2_s lntpop_t ethfrac_t lmtnest_t polity2_t1 military_t powerbalance allybalance cinc_s syscon contig peaceyrs _prefail _spline1 _spline2 _spline3)
* Table 3, model 4
heckprob recip3 lntpop_t regime territory military_t allybalance powerbalance contig, select(demand=lntpop_t military_t powerbalance allybalance cinc_s syscon contig peaceyrs _prefail _spline1 _spline2 _spline3)

* This syntax will replicate the analysis of ICB crises in Tables 4 and 5
* Table 4, model 1:
logit resist polity22 lntpop_1 extreme territorial military vetoplayers powerbalance allybalance mobilize useforce contig
* Table 4, model 2: 
logit resist polity22 lntpop_1 extreme territorial military polity21 powerbalance allybalance mobilize useforce contig
* Table 4, model 3: 
logit resist polity22 lntpop_1 ethfrac lmtnest extreme territorial military polity21 powerbalance allybalance mobilize useforce contig

* Table 5
ologit action extreme territorial powerbalance allybalance contig
