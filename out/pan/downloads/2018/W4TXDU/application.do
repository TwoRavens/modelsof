clear all

use application.dta, replace

ivregress 2sls log_HRVOTE ( log_tot_trade = lag_log_energ_prod ) log_cinc us_aid100 log_tot_ustrade Joint_Dem_Dum pts_score dummy2004 country_1-country_41, robust first
estimates store m1
ivregress 2sls log_HRVOTE ( log_tot_trade = Wx_log ) log_cinc us_aid100 log_tot_ustrade Joint_Dem_Dum pts_score dummy2004 country_1-country_41, robust first
estimates store m2
ivregress 2sls log_HRVOTE ( log_tot_trade = xhat ) log_cinc us_aid100 log_tot_ustrade Joint_Dem_Dum pts_score dummy2004 country_1-country_41, robust first
estimate store m3

estout m1 m2 m3 , varlabels(log_tot_trade "Trade Flows" log_cinc "National Capability" us_aid100 "US Aid/GDP" log_tot_ustrade "US Trade" Joint_Dem_Dum "Regime" pts_score "Human Rights" dummy2004 "Post-2003" _cons "Constant") cells(b(star fmt(a2)) se(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N , fmt(0) labels("Number Obs." )) nolz style(tex) drop(country*) 

reg log_tot_trade lag_log_energ_prod log_cinc us_aid100 log_tot_ustrade Joint_Dem_Dum pts_score dummy2004 country_1-country_41, robust
estimates store m1
reg log_tot_trade Wx_log log_cinc us_aid100 log_tot_ustrade Joint_Dem_Dum pts_score dummy2004 country_1-country_41, robust
estimates store m2
reg log_tot_trade xhat log_cinc us_aid100 log_tot_ustrade Joint_Dem_Dum pts_score dummy2004 country_1-country_41, robust
estimate store m3

estout m1 m2 m3 , varlabels(log_tot_trade "Trade Flows" log_cinc "National Capability" us_aid100 "US Aid/GDP" log_tot_ustrade "US Trade" Joint_Dem_Dum "Regime" pts_score "Human Rights" dummy2004 "Post-2003" _cons "Constant") cells(b(star fmt(a2)) se(par fmt(%4.3f))) starlevels( * .1 ** .05 *** .01) stats(N , fmt(0) labels("Number Obs." )) nolz style(tex) drop(country*) 





