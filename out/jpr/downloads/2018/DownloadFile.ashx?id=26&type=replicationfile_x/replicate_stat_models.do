*
* Michael F Joseph and Michael Poznansky
* "Media Technology, Covert Action, and the Politics of Exposure"
* Journal of Peace Research, forthcoming
*

cd "REPLACE ME WITH FILE PATH" 
use "replication_df.dta" 

*NOTES: 
*(1) This do file assumes that the n+cov_ov vars were already generated and that some log transoformations were performed;
*(2) Use all of these mlogits for the ladder plot data.

* TABLE 2 (the main MNL model in the paper)
mlogit n_co_ov_ag  mdi any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest time time2 time3 if year < 1991, base(1)
outreg2 using Main1, 10pct tex(frag) replace

* The coefficients from these models are used to make the ladder plot in the paper. See the csv file - "ladderplot" it is simply the coefficients and CIs from these models. 
mlogit n_co_ov_ag  telephli any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest time time2 time3 if year < 1991, base(1)
mlogit n_co_ov_ag  radioli any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest time time2 time3 if year < 1991, base(1)
mlogit n_co_ov_ag  newsli any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest time time2 time3 if year < 1991, base(1)
mlogit n_co_ov_ag  tvli any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest time time2 time3 if year < 1991, base(1)
mlogit n_co_ov_ag  mdi any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest time time2 time3 if year < 1991, base(1)


* TABLE 4 (the selection model presented in paper)
heckprobit  cov_ov_ag mdi any_conflict lnrus_distance lnus_trade lnussr_trade russian_ally alliance_us pf_vb polity2  mtnest if year < 1991  , select(intervention_ag =  mdi polity2 any_conflict lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb mtnest)
outreg2 using Main2, 10pct tex(frag) replace

**********
*APPENDIX*
**********

* APPENDIX, TABLE 3 (summary statistics for main independent variables)

sutex radioli telephl tvli newsli mdi

* APPENDIX, TABLE 4 (summary statistics for control variables)

sutex any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest

* APPENDIX, TABLE 5 (two IV probits, one for each compatison)

ivprobit cov_no any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest (radioli = speaker_pop) if year < 1991, vce(cluster year)
outreg2 using Appendix, 10pct tex(frag) replace
ivprobit cov_ov any_conflict lnarea lnCINC lnrus_distance lnus_trade lnussr_trade lndistance russian_ally alliance_us lngdp indprod1 school01 pf_vb polity2 mtnest (radioli = speaker_pop) if year < 1991, vce(cluster year)
outreg2 using Appendix, 10pct tex(frag) append


