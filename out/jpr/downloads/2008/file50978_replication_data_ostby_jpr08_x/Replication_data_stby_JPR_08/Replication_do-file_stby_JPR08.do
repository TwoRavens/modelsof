
* REPLICATION DATA 
* Article: 'Polarization, Horizontal Inequalities and Violent Civil Conflict'
* Journal: Journal of Peace Research 2008, vol. 45 no. 2, pp. 143-162
* Author: Gudrun Østby


use "H:\Gudrun_papers\POL_HI_CONF_JPR\REPLICATION DATA\Replication_data_ØstbyJPR08_panel.dta", clear
set more off

*Table I
pwcorr HIlsETHN_ed_e ecpol_1_ed_e egr_ed_e pol_ethn_1_ed_e, sig obs 
pwcorr HIlsETHN_as_e ecpol_1_as_e egr_as_e pol_ethn_1_as_e, sig obs

*Table II
logit  up_onsetp Gini_as_e  l_rgdp96pc_ln  l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp Gini_ed_e  l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp ecpol_1_as_e l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp ecpol_1_ed_e l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp egr_as_e l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp egr_ed_e l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp pol_mrq_ethn_e l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)

*Table III
logit  up_onsetp HIlsETHN_as_e  l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp HIlsETHN_ed_e  l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp pol_ethn_1_as_e  l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)
logit  up_onsetp pol_ethn_1_ed_e  l_rgdp96pc_ln l_pop_ln  peaceyrs _spline*, cl(gwno)


use "H:\Gudrun_papers\POL_HI_CONF_JPR\REPLICATION DATA\Replication_data_ØstbyJPR08_cross-section.dta", clear
set more off

*Table IV
nbreg   up_incid_cs ecpol_1_as_cs rgdp96pc_ln_cs pop_ln_cs  up_inc5, exp(year)
nbreg   up_incid_cs ecpol_1_ed_cs rgdp96pc_ln_cs pop_ln_cs  up_inc5, exp(year)
nbreg   up_incid_cs egr_as_cs rgdp96pc_ln_cs pop_ln_cs  up_inc5, exp(year)
nbreg   up_incid_cs egr_ed_cs rgdp96pc_ln_cs pop_ln_cs  up_inc5, exp(year)
nbreg   up_incid_cs HIlsETHN_ed_cs rgdp96pc_ln_cs pop_ln_cs  up_inc5, exp(year)

use "H:\Gudrun_papers\POL_HI_CONF_JPR\REPLICATION DATA\Replication_data_ØstbyJPR08_panel.dta", clear
set more off

*Appendix B 
sum up_onsetp up_onsetall Gini_as_e Gini_ed_e ecpol_1_as_e ecpol_1_ed_e egr_as_e egr_ed_e pol_mrq_ethn_e ///
HIlsETHN_as_e HIlsETHN_ed_e pol_ethn_1_as_e pol_ethn_1_ed_e l_rgdp96pc_ln  l_pop_ln, sep(0)

use "H:\Gudrun_papers\POL_HI_CONF_JPR\REPLICATION DATA\Replication_data_ØstbyJPR08_cross-section.dta", clear
set more off

*Appendix C
sum up_incid_cs up_inc5 year Gini_as_cs Gini_ed_cs ecpol_1_as_cs ecpol_1_ed_cs egr_as_cs egr_ed_cs pol_mrq_ethn_cs ///
HIlsETHN_as_cs HIlsETHN_ed_cs pol_ethn_1_as_cs pol_ethn_1_ed_cs rgdp96pc_ln_cs pop_ln_cs


