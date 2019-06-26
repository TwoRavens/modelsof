*Table I. Global food prices and urban unrest in Africa and Asia, 1961Ð2010*

nbreg f_protests_riots fpi_deflated democ anoc ussr year cfe*, cluster(year)
nbreg f_protests_riots fpi_deflated fpi_deflated_democ fpi_deflated_anoc democ anoc ussrbreakup year cfe*, cluster(year)
nbreg f_protests_riots fpi_deflated fpi_deflated_democ fpi_deflated_anoc fpi_deflated_gdp oilpricebp oilpricebp_democ oilpricebp_anoc democ anoc log_rgdpch grgdpch openk log_xrat ussrbreakup year cfe*, cluster(year)
nbreg f_protests_riots fpi_deflated fpi_deflated_democ fpi_deflated_anoc fpi_deflated_gdp oilpricebp oilpricebp_democ oilpricebp_anoc democ anoc log_rgdpch grgdpch openk log_xrat citypopgr1 lncitypop ussrbreakup year cfe*, cluster(year)
nbreg f_protests_riots fpi_deflated fpi_deflated_democ fpi_deflated_anoc fpi_deflated_gdp oilpricebp oilpricebp_democ oilpricebp_anoc democ anoc log_rgdpch grgdpch openk log_xrat ussrbreakup year cfe* if nra_covt!=., cluster(year)
nbreg f_protests_riots fpi_deflated fpi_deflated_democ fpi_deflated_anoc fpi_deflated_gdp oilpricebp oilpricebp_democ oilpricebp_anoc nra_covt nra_democ nra_anoc democ anoc log_rgdpch grgdpch openk log_xrat ussrbreakup year cfe*, cluster(year)

*Table II. Regime type and nominal rates of assistance to agriculture, 1962Ð2010*
xtreg f.nra_covt democ anoc log_rgdpch grgdpch fpi_deflated fpi_deflated_changeest log_xrat openk yearfe* year if citycode~=7701 & citycode~=7702 & citycode~=7501 & citycode~=7502, re vce(robust)
xtreg f.nra_covt democ anoc log_rgdpch grgdpch fpi_deflated fpi_deflated_changeest log_xrat openk yearfe* year if citycode~=7701 & citycode~=7702 & citycode~=7501 & citycode~=7502, fe vce(robust)
xtpcse f.nra_covt democ anoc log_rgdpch grgdpch fpi_deflated fpi_deflated_changeest log_xrat openk yearfe* year if citycode~=7701 & citycode~=7702 & citycode~=7501 & citycode~=7502
xtpcse f.nra_covt democ anoc log_rgdpch grgdpch fpi_deflated fpi_deflated_changeest log_xrat openk yearfe* year if citycode~=7701 & citycode~=7702 & citycode~=7501 & citycode~=7502, corr(psar1)

*Note: excluded panels are to exclude separate estimates for different cities within countries.*
