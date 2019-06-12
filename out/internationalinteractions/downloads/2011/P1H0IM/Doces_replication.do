 tsset panelvar year
*column 1 table 1
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq gdp_gr logrelcohort logpop coldwar L5.cbr_cdr_un,corr(ar1) pairwise
*column 2 
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq gdp_gr logrelcohort logpop coldwar,corr(ar1) pairwise
*column 3
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq gdp_gr logrelcohort logpop ,corr(ar1) pairwise
*column 4
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq gdp_gr logrelcohort ,corr(ar1) pairwise
*column 5
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq gdp_gr ,corr(ar1) pairwise
*column 6
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq,corr(ar1) pairwise
*column 7
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc ,corr(ar1) pairwise
*column 8
xtpcse  logbirths  logtrade polity2 CEDAW ,corr(ar1) pairwise
*column 9
xtpcse  logbirths  logtrade polity2,corr(ar1) pairwise
*column 10
xtpcse  logbirths  logtrade,corr(ar1) pairwise
*column 11
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc loggdppcsq L5.cbr_cdr_un,corr(ar1) pairwise
*column 12
xtpcse  logbirths  logtrade polity2 CEDAW loggdppc L5.cbr_cdr_un,corr(ar1) pairwise



















