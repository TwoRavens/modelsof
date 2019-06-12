*Calculate values for tables
*Mihaly Fazekas
*Gabor Kocsis
*****************

***First need to run calculate_cri.do

***Load in CRI data
use "..\data\cri_data.dta", clear

***Table 1
logit singleb binew_corr_nocft ib6.anb_csector i.anb_type i.year ib31.country ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1
margins, dydx (binew_corr_nocft) post noestimcheck

logit singleb binew_procedure ib6.anb_csector i.anb_type i.year ib31.country ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1
margins, dydx (binew_procedure) post noestimcheck

logit singleb binew_wnonpr ib6.anb_csector i.anb_type i.year ib31.country ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1
margins, dydx (binew_wnonpr) post noestimcheck

logit singleb binew_submp ib6.anb_csector i.anb_type i.year ib31.country ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1
margins, dydx (binew_submp) post noestimcheck

logit singleb binew_decp ib6.anb_csector i.anb_type i.year ib31.country ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1
margins, dydx (binew_decp) post noestimcheck

logit singleb binew_corr_nocft binew_procedure binew_wnonpr binew_submp binew_decp ib6.anb_csector i.anb_type i.year ib31.country ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1
margins, dydx (binew_corr_nocft binew_procedure binew_wnonpr binew_submp binew_decp) post noestimcheck

***Table 2
*CRI
reg relprice cri_neu_bi_new ib79.country if mcvfilter_ok==1 & relprice <= 1 & anb_country!="CH"
reg relprice cri_neu_bi_new ib6.anb_csector i.anb_type ib79.country i.year ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1 & relprice <= 1 & anb_country!="CH"

*Singleb
reg relprice singleb ib79.country if mcvfilter_ok==1 & relprice <= 1 & anb_country!="CH"
reg relprice singleb ib6.anb_csector i.anb_type ib79.country i.year ib45.ca_cpv_div lca_contract_value if mcvfilter_ok==1 & relprice <= 1 & anb_country!="CH"

***Table C1
sum if mcvfilter_ok==1 & anb_country!="CH"

***Table C2
tab ca_procedure if mcvfilter_ok==1  & anb_country!="CH", missing

***Table D1
sum lca_contract_value if mcvfilter_ok==1  & anb_country!="CH"

***Table D2
tab anb_type if mcvfilter_ok==1  & anb_country!="CH", missing

***Table D3
tab anb_csector if mcvfilter_ok==1  & anb_country!="CH", missing

***Table D4
tab year if anb_country!="CH" & mcvfilter_ok==1 & year<2015 & year>2007

***Table D5
tab ca_cpv_div if mcvfilter_ok==1 & anb_country!="CH"

***Table D6
tab anb_country if mcvfilter_ok==1 & anb_country!="CH"


***Load in macro data
use "..\data\bjpols_replication_macro.dta", clear

***Table B1 and B2
correlate wgi_coc_2013 cpi_2013 gci107_2013 singleb cri_neu_bi
correlate eurobaro374_2013 singleb cri_neu_bi

correlate wgi_coc_2013 cpi_2013 gci107_2013 cri_neuc1_bi
correlate wgi_coc_2013 cpi_2013 gci107_2013 cri_neuc2_bi
correlate wgi_coc_2013 cpi_2013 gci107_2013 cri_neuc3_bi
correlate wgi_coc_2013 cpi_2013 gci107_2013 cri_neuc4_bi
correlate wgi_coc_2013 cpi_2013 gci107_2013 cri_neuc5_bi
correlate wgi_coc_2013 cpi_2013 gci107_2013 cri_neuc6_bi

correlate eurobaro374_2013 cri_neuc1_bi
correlate eurobaro374_2013 cri_neuc2_bi
correlate eurobaro374_2013 cri_neuc3_bi
correlate eurobaro374_2013 cri_neuc4_bi
correlate eurobaro374_2013 cri_neuc5_bi
correlate eurobaro374_2013 cri_neuc6_bi
