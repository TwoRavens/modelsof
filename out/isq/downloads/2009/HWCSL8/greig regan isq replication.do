** Replication file for J. Michael Greig and Patrick M. Regan (2008) "When Do They Say Yes?
** An Analysis of the Willingness to Offer and Accept Mediation in Civil Wars", International Studies Quarterly
**
** If you have any questions about the data or analysis, please contact the authors:  Greig (greig@unt.edu), Regan (pregan@binghamton.edu)
********************


clear
set mem 64m
use "C:\tables\greig regan replication data.dta"
heckprob accepted trade_leverage leverage_dummy lndeaths duration duration2 ethnic territory sum_acceptances reputation3_prop historic milint econint majpow, sel(mediation_offer = trade_interest interest_dummy defense_pact lndistance_allmissing lndistancedummy historic sum_acceptances other_accept_lastyr prev_milint prev_econint accept_lastyr) robust

