*do file for Timothy M. Peterson, "Sending a Message: The Reputation Effect of US Sanction Threat Behavior."
*please contact me at timothy.peterson@okstate.edu with any questions or comments.

*NOTE: directories will need to be updated. Also, output tables from outreg2 need a lot of reorganization to resemble the final tables in the manuscript.




*TABLE 1: aggregate threats and issue context models

*Model 1
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ acceptance/final_all_threats.dta"

cmp (target_capit_threat= new_all_imp_dum new_all_sbd_dum bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo polinfthreat containmilthreat destabthrear releasethreat dstratthreat badallythreat prolifthreat envirothreat tradethreat reformthreat electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov ), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table1, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all new_all_imp_dum=0 new_all_sbd_dum=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.1463783-.4124003)/.4124003


*Model 2
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ acceptance/final_no_trade_threats.dta"

cmp (target_capit_threat= new_all_imp_dum new_all_sbd_dum bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo polinfthreat containmilthreat destabthrear releasethreat dstratthreat badallythreat prolifthreat envirothreat reformthreat electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table1, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all new_all_imp_dum=0 new_all_sbd_dum=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.0759617-.4515779 )/.4515779 


*Model 3
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ acceptance/final_all_threats.dta"

cmp (target_capit_threat= issue_imp issue_sbd bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo electionprox papprov ) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table1, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all issue_imp=0 issue_sbd=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.1823724-.3495343)/.3495343


*Model 4
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ acceptance/final_no_trade_threats.dta"

cmp (target_capit_threat= issue_imp issue_sbd bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo  electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table1, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all issue_imp=0 issue_sbd=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.1837226-.4563755)/.4563755



*TABLE 2: sender context and target context models.

*Model 5
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ acceptance/final_all_threats.dta"
cmp (target_capit_threat= sender_imp sender_sbd bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo polinfthreat containmilthreat destabthrear releasethreat dstratthreat badallythreat prolifthreat envirothreat tradethreat reformthreat electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table2, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)


*Model 6
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ R&R/Context coding/final model data/excluding trade threats/final_no_trade_threats.dta", replace
cmp (target_capit_threat= sender_imp sender_sbd bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo polinfthreat containmilthreat destabthrear releasethreat dstratthreat badallythreat prolifthreat envirothreat reformthreat electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table2, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all sender_sbd=0 sender_imp=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.2967375-.3899594)/.3899594


*Model 7
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ acceptance/final_all_threats.dta"
cmp (target_capit_threat= target_imp target_sbd bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo polinfthreat containmilthreat destabthrear releasethreat dstratthreat badallythreat prolifthreat envirothreat tradethreat reformthreat electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table2, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all target_imp=0 target_sbd=(0(1)1)) predict(pr eq(target_capit_threat))
disp  (.1655619-.3128864)/.3128864

margins , at((median) _all target_sbd=0 target_imp=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.4919944-.3128864)/.3128864


*Model 8
use "/Users/Tim/Documents/Working Papers/Sending a Message/ISQ R&R/Context coding/final model data/excluding trade threats/final_no_trade_threats.dta", replace
cmp (target_capit_threat= target_imp target_sbd bspecif_fill instit_fill expshare2 polity22 lndist s_wt_glo polinfthreat containmilthreat destabthrear releasethreat dstratthreat badallythreat prolifthreat envirothreat reformthreat electionprox papprov) (threatissued = new_all_imp_dum new_all_sbd_dum expshare2 polity22 lndist s_wt_glo threatyr ty2 ty3 ford carter reagan1 reagan2 bush clinton1 clinton2 electionprox papprov), ind($cmp_probit*threatissued $cmp_probit) cluster(ccode2)

outreg2 using table2, tex(nopretty) bdec(3) alpha(0.01, 0.05, 0.1)

margins , at((median) _all target_imp=0 target_sbd=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.002907-.0336356)/.0336356

margins , at((median) _all target_sbd=0 target_imp=(0(1)1)) predict(pr eq(target_capit_threat))
disp (.1656017-.0336356)/.0336356