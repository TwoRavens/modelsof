use "/Users/narangn/Dropbox/Work/Working Papers/Nuclear Umbrella Paper ISA/GDPData from Hegre Oneil Russet/HOR_JPR_table3.dta"
sort statea year
collapse (first) cap_a cap_b tpop_a tpop_b allies polity_a polity_b contig distance fatal lnrtrade rgdp_a rgdp_b PTA s_wt_glo, by (statea year) 
rename statea ccode
sort ccode year
save "/Users/narangn/Dropbox/alliance_portfolios/Covariates requested in IO Reviews/GDP data state year from HOR.dta"

merge 1:1 ccode year using "/Users/narangn/Dropbox/alliance_portfolios/Covariates requested in IO Reviews/MilitaryExpenditureCapability.dta"
rename ccode state
sort state year
drop cap_b tpop_b polity_b contig distance lnrtrade rgdp_b
save "/Users/narangn/Dropbox/alliance_portfolios/Covariates requested in IO Reviews/GDP_POP_CINC_formergeingontoAllyportfolio.dta"
