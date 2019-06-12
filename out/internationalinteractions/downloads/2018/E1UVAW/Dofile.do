
**International Interactions DoFile**
**Keels and Kinney**
**Updated 7/30/2018**

**Descriptive Statistics**
sum polwing strong_ties weak_link legal inmedia party_media strong_media weak_media rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_cl fh_pr post2000

**Table II: Main Models**

nbreg attack polwing legal inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
outreg2 using myreg.doc, replace ctitle(Model 1) auto(2) label

nbreg attack polwing legal party_media inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
outreg2 using myreg.doc, append ctitle(Model 2) auto(2) label

nbreg attack strong_ties weak_link inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
outreg2 using myreg.doc, append ctitle(Model 3) auto(2) label

nbreg attack strong_ties weak_link strong_media weak_media inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
outreg2 using myreg.doc, append ctitle(Model 4) auto(2) label

**Figure 1**
quietly nbreg attack polwing legal party_media inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
grinter polwing, inter(party_media) const02(inmedia) equation(attack) saving(marginal-polwing, replace) scheme(s2mono) clevel(95) yline(0) nomeantext

**Figure 2**
quietly nbreg attack strong_ties weak_link strong_media weak_media inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
grinter strong_ties, inter(strong_media) const02(inmedia) equation(attack) saving(marginal-polwing, replace) scheme(s2mono) clevel(95) yline(0) nomeantext
grinter weak_link, inter(weak_media) const02(inmedia) equation(attack) saving(marginal-polwing, replace) scheme(s2mono) clevel(95) yline(0) nomeantext

graph combine "C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\Second Round Revision\Graph_strongties.gph""C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\Second Round Revision\Graph_looseties.gph", title(Terrorism by Rebel Groups)

**Marginal Effects**
quietly nbreg attack polwing legal party_media inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
margins, atmeans at(polwing=1 party_media=1 inmedia==1 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 
margins, atmeans at(polwing=1 party_media=2 inmedia==2 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 
margins, atmeans at(polwing=1 party_media=3 inmedia==3 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 
margins, atmeans at(polwing=0 party_media=0 inmedia==3 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 

**Marginal Effects: Polwing Ties to Military**
quietly nbreg attack strong_ties weak_link strong_media weak_media inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
**Close Ties**
margins, atmeans at(strong_ties=1 weak_link=0 strong_media=1 weak_media=0 inmedia==1 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 
margins, atmeans at(strong_ties=1 weak_link=0 strong_media=2 weak_media=0 inmedia==2 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 
margins, atmeans at(strong_ties=1 weak_link=0 strong_media=3 weak_media=0 inmedia==3 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0 ethnicid=1) 

**Weak Links**
margins, atmeans at(strong_ties=0 weak_link=1 strong_media=0 weak_media=1 inmedia==1 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0) 
margins, atmeans at(strong_ties=0 weak_link=1 strong_media=0 weak_media=2 inmedia==2 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0) 
margins, atmeans at(strong_ties=0 weak_link=1 strong_media=0 weak_media=3 inmedia==3 demdum=1 intensity=1 post2000=1 territory1=1 highmob=0) 

**Figure 3**
quietly nbreg attack polwing legal party_media inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
margins, at(polwing=1 party_media=1 inmedia==1 rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(polwing=1 party_media=2 inmedia==2 rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(polwing=1 party_media=3 inmedia==3 rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) 
marginsplot, recast(bar)

margins, at(polwing=0 party_media=0 inmedia==1 rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(polwing=0 party_media=0 inmedia==2 rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(polwing=0 party_media=0 inmedia==3 rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) 
marginsplot, recast(bar)

quietly nbreg attack strong_ties weak_link strong_media weak_media inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
margins, at(strong_ties=1 weak_link=0 strong_media=1 weak_media=0 inmedia==1  rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(strong_ties=1 weak_link=0 strong_media=2 weak_media=0 inmedia==2  rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(strong_ties=1 weak_link=0 strong_media=3 weak_media=0 inmedia==3  rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) 
marginsplot, recast(bar)

margins, at(strong_ties=0 weak_link=1 strong_media=0 weak_media=1 inmedia==1  rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(strong_ties=0 weak_link=1 strong_media=0 weak_media=2 inmedia==2  rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) at(strong_ties=0 weak_link=1 strong_media=0 weak_media=3 inmedia==3  rebelstrength=2 demdum=0 intensity=1 post2000=0 territory1=0 highmob=0 ethnicid=1 legal=0) 
marginsplot, recast(bar)

**Note: Graphs edited to set similar X & Y Axes, labeled data points on X Axis**

graph combine "C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\Second Round Revision\New Revisions\Bar_NoPolwings.gph""C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\Second Round Revision\New Revisions\Bar_Polwings.gph""C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\Second Round Revision\New Revisions\Bar_StrongTies.gph""C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\Second Round Revision\New Revisions\Bar_LooseTies.gph", title(Media Freedom and Rebel Terrorist Attacks) 

**Robustness Checks**
**Table 1A**
probit highmed ciri_formov rgdppc_log log_pop polity troopratio_all
predict pp1, xb
generate phi2 = (1/sqrt(2*_pi))*exp(-(pp1^2/2))
generate capphi2 = normal(pp1)
generate invmills2 = phi2/capphi2

nbreg attack polwing legal party_media ciri_formov inmedia rebelstrength highmob territory1 intensity confl_actors rgdppc_log demdum fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
nbreg attack polwing legal party_media inmedia invmills2 rebelstrength highmob territory1 intensity confl_actors rgdppc_log demdum fh_pr fh_cl post2000 t t2 t3, vce(bootstrap)

**Table 2A**
sureg (attack polwing legal party_media rebelstrength inmedia territory1 intensity confl_actors rgdppc_log log_pop demdum t t2 t3)(polwing highmob inmedia regimechangenospecificideology marxistsocialist ethnoreligious nationalistseparatist rightwing rebsupp)(inmedia rgdppc_log log_pop polity troopratio_all)
outreg2 using myreg.doc, replace ctitle(Model 1) auto(2) label

**Table 3A**
nbreg attack polwing legal party_media propag inmedia rebelstrength highmob territory1 confl_actors rgdppc_log log_pop demdum fh_pr fh_cl t t2 t3 if year<=2006, robust cluster(dyadid)
outreg2 using myreg.doc, replace ctitle(Media Freedom) auto(2) label

**Table 4A**
xtnbreg attack polwing legal party_media rebelstrength highmob inmedia territory1 intensity confl_actors rgdppc_log demdum post2000 t t2 t3, fe
outreg2 using myreg.doc, replace ctitle(Model 1) auto(2) label

**Table 5A**
nbreg attack banned legal banned_media legal_media inmedia rebelstrength highmob territory1 intensity confl_actors rgdppc_log demdum fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
outreg2 using myreg.doc, replace ctitle(Model 1) auto(2) label

**Table 6A**
nbreg attack polwing legal party_media nationalistseparatist ethnoreligious regimechangenospecificideology marxistsocialist religious rightwing inmedia rebelstrength highmob territory1 intensity confl_actors rgdppc_log demdum fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
outreg2 using myreg.doc, replace ctitle(Model 1) auto(2) label

**Graphing First Differences for Variables of Interest**
clear
use "C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\PublishMaterials\terrorism_polwings.dta"

estsimp nbreg attack polwing legal party_media inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
 
plotfds, discrete(polwing) continuous(party_media inmedia) sortorder(polwing) changexcont(min max)

clear
use "C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\PublishMaterials\terrorism_polwings.dta"

estsimp nbreg attack strong_ties weak_link strong_media weak_media inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
plotfds, discrete(strong_ties weak_link) continuous(strong_media weak_media inmedia) sortorder(strong_ties weak_link) changexcont(min max)

clear

use "C:\Users\Eric Keels\Dropbox\Political Wings and Terrorism\International Interactions\PublishMaterials\terrorism_polwings.dta"

**Model Fit Tests**
quietly nbreg attack polwing legal inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
estimates store base
quietly nbreg attack polwing legal party_media inmedia rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
estimates store model
quietly nbreg attack strong_ties weak_link strong_media weak_media inmedia legal rebelstrength ethnicid highmob territory1 intensity confl_actors rgdppc_log demdum pts_average_lag fh_pr fh_cl post2000 t t2 t3, robust cluster(dyadid)
estimates store ties

estimates stats base model ties


