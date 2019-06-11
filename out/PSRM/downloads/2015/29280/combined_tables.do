clear
set more off
use "PATH\africa.dta",clear
tsset cowcode year, yearly

*TABLE 1 RESULTS

tabulate elewindow_100 cwsambinit_2005, row col chi2
tabulate elewindow_100 cwsambinit_2005 if year<1990, row col chi2
tabulate elewindow_100 cwsambinit_2005 if year>1989, row col chi2

tabulate elewindow_90 cwsambinit_2005, row col chi2
tabulate elewindow_90 cwsambinit_2005 if year<1990, row col chi2
tabulate elewindow_90 cwsambinit_2005 if year>1989, row col chi2

tabulate elewindow_50 cwsambinit_2005, row col chi2
tabulate elewindow_50 cwsambinit_2005 if year<1990, row col chi2
tabulate elewindow_50 cwsambinit_2005 if year>1989, row col chi2

tabulate elewindow_100 prio_25, row col chi2
tabulate elewindow_100 prio_25 if year<1990, row col chi2
tabulate elewindow_100 prio_25 if year>1989, row col chi2

tabulate elewindow_90 prio_25, row col chi2
tabulate elewindow_90 prio_25 if year<1990, row col chi2
tabulate elewindow_90 prio_25 if year>1989, row col chi2

tabulate elewindow_50 prio_25, row col chi2
tabulate elewindow_50 prio_25 if year<1990, row col chi2
tabulate elewindow_50 prio_25 if year>1989, row col chi2

*TABLE 2 RESULTS

*1) All Parties Less than 100% of Vote

probit cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 i.elewindow_100 if year > 1989, cluster(cowcode) 
margins elewindow_100
margins, dydx(elewindow_100) 


*2) All Parties Less than 90% of Vote

probit cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 i.elewindow_90 if year > 1989, cluster(cowcode) 
margins elewindow_90
margins, dydx(elewindow_90) 

*3) All Parties Less than 50% of Vote

probit cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 i.elewindow_50 if year > 1989, cluster(cowcode)
margins elewindow_50
margins, dydx(elewindow_50) 


*TABLE 3 RESULTS

*1) All Parties Less than 100% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 elewindow_100) (elewindow_100 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)
ivregress 2sls cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 (elewindow_100 = n_anympelec_100_africa military civilian democracy inher_parties acc_nheads_reg odwp) if year > 1989
estat firststage
estat overid


*2) All Parties Less than 90% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 elewindow_90) (elewindow_90 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)
ivregress 2sls cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 (elewindow_90 = n_anympelec_100_africa military civilian democracy inher_parties acc_nheads_reg odwp) if year > 1989
estat firststage
estat overid


*3) All Parties Less than 50% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 elewindow_50) (elewindow_50 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)
ivregress 2sls cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 (elewindow_50 = n_anympelec_100_africa military civilian democracy inher_parties acc_nheads_reg odwp) if year > 1989
estat firststage
estat overid


*TABLE 4 RESULTS

*PEACEKEEPING

*1) All Parties Less than 100% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 mdpk elewindow_100) (elewindow_100 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*2) All Parties Less than 90% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 mdpk elewindow_90) (elewindow_90 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*3) All Parties Less than 50% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 mdpk elewindow_50) (elewindow_50 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)


*POWERSHARING

*1) All Parties Less than 100% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 psa elewindow_100) (elewindow_100 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*2) All Parties Less than 90% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 psa elewindow_90) (elewindow_90 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*1) All Parties Less than 50% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 psa elewindow_50) (elewindow_50 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)


*PREVIOUS WARS

*1) All Parties Less than 100% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 cw_count elewindow_100) (elewindow_100 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*2) All Parties Less than 90% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 cw_count elewindow_90) (elewindow_90 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*3) All Parties Less than 50% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 cw_count elewindow_50) (elewindow_50 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*PRIO

*1) All Parties Less than 100% of Vote

biprobit (cwprioinit_1000 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwprio_1000 psa elewindow_100) (elewindow_100 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*2) All Parties Less than 90% of Vote

biprobit (cwprioinit_1000 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwprio_1000 psa elewindow_90) (elewindow_90 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*3) All Parties Less than 50% of Vote

biprobit (cwprioinit_1000 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwprio_1000 psa elewindow_50) (elewindow_50 = n_anympelec_100_africa military civilian democracy ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

clear
use "PATH\nondemocracies.dta",clear

*AFRICAN NONDEMOCRACIES

*1) All Parties Less than 100% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 psa elewindow_100) (elewindow_100 = n_anympelec_100_africa military civilian ef l.oil inher_parties acc_nheads_reg odwp) if africa==1 & year > 1989, cluster(cowcode)

*2) All Parties Less than 90% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 psa elewindow_90) (elewindow_90 = n_anympelec_100_africa military civilian ef l.oil inher_parties acc_nheads_reg odwp) if africa==1 & year > 1989, cluster(cowcode)

*3) All Parties Less than 50% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 psa elewindow_50) (elewindow_50 = n_anympelec_100_africa military civilian ef l.oil inher_parties acc_nheads_reg odwp) if africa==1 & year > 1989, cluster(cowcode)


*GLOBAL NONDEMOCRACIES 

*1) All Parties Less than 100% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 elewindow_100) (elewindow_100 = n_anympelec_100_global military civilian ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*2) All Parties Less than 90% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 elewindow_90) (elewindow_90 = n_anympelec_100_global military civilian ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)

*3) All Parties Less than 50% of Vote

biprobit (cwsambinit_2005 l.gdppc_maddison l.gdppcg_maddison l.pop_maddison l.oil ef mtn musl l.cwsamb_2005 elewindow_50) (elewindow_50 = n_anympelec_100_global military civilian ef l.oil inher_parties acc_nheads_reg odwp) if year > 1989, cluster(cowcode)


