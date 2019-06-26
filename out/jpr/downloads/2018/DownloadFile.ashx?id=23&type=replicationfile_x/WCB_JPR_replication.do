******************************************************************************************************************
***REPLICATION FOR "Where, when, and how does the UN work to prevent civil war in self-determiantion disputes?"***
******************************************************************************************************************

*set a working directory to which tables can be exported

cd ""

sort kgcid year

*Table 3
eststo clear
*basic relogit, no ongoing conflict
eststo:logit acdcivilwar1 logfactions prevconcessions_l l_loggdppc l_democracy kin prevcivwar yrsnocivilwar  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit anydirectaction prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform


**APPENDIX**

*Figure A1: ROC Plots

relogit anydirectaction yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict A, xb
relogit anydirectaction logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict B, xb
relogit anydirectaction prevcivwar nbr_intra other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict C, xb
roccomp anydirectaction A B C, graph scheme(s1color) plot1opts(msymbol(i) lpattern(dot) lwidth(vthick) lcolor(black)) plot2opts(msymbol(i) lpattern(dash) lwidth(vthick) lcolor(gs6)) plot3opts(msymbol(i) lpattern(solid) lwidth(vthick) lcolor(gs12) title("Any UN Action")) summary
graph save roc_anydirectaction, replace

drop A B C
relogit dir_diplo_any yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict A, xb
relogit dir_diplo_any logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict B, xb
relogit dir_diplo_any prevcivwar nbr_intra other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict C, xb
roccomp dir_diplo_any A B C, graph scheme(s1color) plot1opts(msymbol(i) lpattern(dot) lwidth(vthick) lcolor(black)) plot2opts(msymbol(i) lpattern(dash) lwidth(vthick) lcolor(gs6)) plot3opts(msymbol(i) lpattern(solid) lwidth(vthick) lcolor(gs12) title("Diplomacy")) summary
graph save roc_dir_diplo_any, replace

drop A B C
relogit dir_force_new_any yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict A, xb
relogit dir_force_new_any logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict B, xb
relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict C, xb
roccomp dir_force_new_any A B C, graph scheme(s1color) plot1opts(msymbol(i) lpattern(dot) lwidth(vthick) lcolor(black)) plot2opts(msymbol(i) lpattern(dash) lwidth(vthick) lcolor(gs6)) plot3opts(msymbol(i) lpattern(solid) lwidth(vthick) lcolor(gs12) title("New Force")) summary
graph save roc_dir_force_new_any, replace

drop A B C
relogit dir_condemn_any yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict A, xb
relogit dir_condemn_any logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict B, xb
relogit dir_condemn_any prevcivwar nbr_intra other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
predict C, xb
roccomp dir_condemn_any A B C, graph scheme(s1color) plot1opts(msymbol(i) lpattern(dot) lwidth(vthick) lcolor(black)) plot2opts(msymbol(i) lpattern(dash) lwidth(vthick) lcolor(gs6)) plot3opts(msymbol(i) lpattern(solid) lwidth(vthick) lcolor(gs12) title("Condemnations")) summary
graph save roc_dir_condemn_any, replace

graph combine roc_anydirectaction.gph roc_dir_diplo_any.gph roc_dir_force_new_any.gph roc_dir_condemn_any.gph, col(2) row(2) saving(roc_combined, replace) scheme(s1color) iscale(0.4)
graph export roc_combined.pdf, replace

*Table A3: no previous conflict
eststo clear

eststo:logit acdcivilwar1 logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar  if ongoingcivilwar==0 & prevcivwar==0, cluster(kgcid)
eststo:relogit anydirectaction nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar borders if ongoingcivilwar==0  & prevcivwar==0 & p5_ally_of_p5==0, cluster(kgcid)
eststo:relogit dir_diplo_any nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar borders  if ongoingcivilwar==0  & prevcivwar==0 & p5_ally_of_p5==0, cluster(kgcid)
eststo:relogit dir_force_new_any nbr_intra other_civwar_incountry  logfactions l_loggdppc l_democracy yrsnocivilwar coldwar borders if ongoingcivilwar==0  & prevcivwar==0 & p5_ally_of_p5==0 & kin==1 & prevconcessions_l==0, cluster(kgcid)
eststo:relogit dir_condemn_any nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar borders  if ongoingcivilwar==0  & prevcivwar==0 & p5_ally_of_p5==0, cluster(kgcid)

esttab _all using wcb_noPREV.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A4: analysis w/lag and no lag of neighboring 

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra l_nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra l_nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra l_nbr_intra other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra l_nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_lag_nbr.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A5: exlcude dispute-years where there is some other ciivl war in country

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 & other_civwar_incountry==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 & other_civwar_incountry==0, cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 & other_civwar_incountry==0, cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 & other_civwar_incountry==0, cluster(kgcid)

esttab _all using wcb_no_other_civwar_instate.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A6: other UNSC actions on RHS

eststo clear

eststo:relogit dir_diplo_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders dir_condemn_any dir_force_new_any  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders dir_condemn_any dir_diplo_any if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders dir_diplo_any dir_force_new_any if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing_other_RHS.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A7: Exclude short periods of peace

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra  other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 & civwar_pyrs>=3, cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra  other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar  p5_ally_of_p5 borders if ongoingcivilwar==0 & civwar_pyrs>=3, cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar if ongoingcivilwar==0 & p5_ally_of_p5==0 & civwar_pyrs>=3, cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra  other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 & civwar_pyrs>=3, cluster(kgcid)

esttab _all using wcb_noongoing_noshortpeace.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A8: UN prior intervention in dispute

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra  other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  l_un_cumulative if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra  other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  l_un_cumulative if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  l_un_cumulative if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra  other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  l_un_cumulative if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing_UNSC_hist.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A9: Moving average of past civil wars in state

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra l_ma_othersdwar_3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra l_ma_othersdwar_3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra l_ma_othersdwar_3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra l_ma_othersdwar_3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing_p5_past_sd.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A10: Moving average of past nearby civil wars

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra l_ma_nbr3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra l_ma_nbr3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra l_ma_nbr3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra l_ma_nbr3 other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing_p5_past_nbr.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A11: Alternative Coding of UNSC Actions to Exclude Actions in Year of Civil War Onset

eststo clear

eststo:relogit anydirectactionB prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_anyB prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_anyB prevcivwar nbr_intra other_civwar_incountry   logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_anyB prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_nbr_actionsB.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A12: Alternative Coding of Ongoing Civil War

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingB==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingB==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingB==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingB==0 , cluster(kgcid)

esttab _all using wcb_nbr_ongoingB.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A13: Including Civil War Propensity Score

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra other_civwar_incountry  coldwar p5_ally_of_p5 borders l_civwarhat if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra other_civwar_incountry  coldwar p5_ally_of_p5 borders l_civwarhat  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  coldwar p5_ally_of_p5 borders l_civwarhat if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra other_civwar_incountry  coldwar p5_ally_of_p5 borders l_civwarhat if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing_civwarhat.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A14: Nearby Civil War Recoded with Only Adjacent States w/Close Capitals

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra_restrictive other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders_restrictive if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra_restrictive other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders_restrictive  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra_restrictive other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders_restrictive if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra_restrictive other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders_restrictive  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_nbr_restrict.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A15: Only Territorial Civil Wars in Nearby Civil Wars Indicator

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_terr other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_terr other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_terr other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_terr other_civwar_incountry logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_nbr_terr.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A16: Trade Relationship of Home Country to P-5 States

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc   l_democracy kin yrsnocivilwar coldwar log_UK_trade log_US_trade log_France_trade log_PRC_trade log_Russia_trade borders  if ongoingcivilwar==0 & p5==0, cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar log_UK_trade log_US_trade log_France_trade log_PRC_trade log_Russia_trade borders  if ongoingcivilwar==0 & p5==0, cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar log_UK_trade log_US_trade log_France_trade log_PRC_trade log_Russia_trade borders if ongoingcivilwar==0 & p5==0, cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar log_UK_trade log_US_trade log_France_trade log_PRC_trade log_Russia_trade borders  if ongoingcivilwar==0 & p5==0, cluster(kgcid)

esttab _all using wcb_p5_trade.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform

*Table A17: Controlling for whether another SD group in the state has ever been violent

**SD movement *ever been violent**

eststo clear

eststo:relogit anydirectaction prevcivwar nbr_intra SD_ever_violent_dummy other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_diplo_any prevcivwar nbr_intra SD_ever_violent_dummy other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_force_new_any prevcivwar nbr_intra SD_ever_violent_dummy other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders   if ongoingcivilwar==0 , cluster(kgcid)
eststo:relogit dir_condemn_any prevcivwar nbr_intra SD_ever_violent_dummy other_civwar_incountry  logfactions prevconcessions_l l_loggdppc  l_democracy kin yrsnocivilwar coldwar p5_ally_of_p5 borders  if ongoingcivilwar==0 , cluster(kgcid)

esttab _all using wcb_noongoing_past_other_SD_ever.csv, se parentheses  replace  star(+ 0.10 * 0.05) eform









