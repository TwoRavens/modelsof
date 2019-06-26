**Article
*Nuclear Proliferation
*Table 1
Use Kroenig_US Nuclear Weapons and Nonproliferation.dta
*Explore
stset risk1 if risk1~=. & explore2~=., id (cowcc) failure (explore2==1)
stcox usarsenal guarantee gdpcap industry1 rivalry polity openness chopen5 year, cluster (cowcc) nohr
*Pursue
stset risk1 if risk1~=. & pursue~=., id (cowcc) failure (pursue==1)
stcox usarsenal guarantee gdpcap industry1 rivalry polity openness chopen5 year, cluster (cowcc) nohr
*Acquire
stset risk1 if risk1~=. & acquire~=., id (cowcc) failure (acquire==1)
stcox usarsenal nucass_full industry1 rivalry year, cluster (cowcc) nohr

clear

Use Kroenig_Sensitive Nuclear Assistance.dta
**Nonproliferation Policy
*Sensitive nuclear assistance
*Table 2
logit  nucass usarsenal rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3, cluster(dyad)
logit  nucass usarsenal rel_pow enemy sup_pact1 trade nsg1 ldist ldist2 openness_2 count _spline1 _spline2 _spline3, cluster(dyad)

clear

use Kroenig_UNSC Voting.dta
*UNSC Voting
*Table 3
probit unsc_vote  usarsenal cap_1 gdp_un  polity npt2 explore, cluster (cowcc)
probit unsc_vote  usarsenal cap_1 npt2, cluster (cowcc)


**Suplementary material
Use Kroenig_US Nuclear Weapons and Nonproliferation.dta
*Table 2A
*Proliferation with U.S. Security Guarantee Interaction
*Explore
stset risk1 if risk1~=. & explore2~=., id (cowcc) failure (explore2==1)
stcox usarsenal usguarantee interact gdpcap industry1 rivalry polity openness chopen5 year, cluster (cowcc) nohr
*Pursue
stset risk1 if risk1~=. & pursue~=., id (cowcc) failure (pursue==1)
stcox usarsenal usguarantee interact gdpcap industry1 rivalry polity openness chopen5 year, cluster (cowcc) nohr
*Acquire
stset risk1 if risk1~=. & acquire~=., id (cowcc) failure (acquire==1)
stcox usarsenal  usguarantee interact nucass_full industry2 rivalry year, cluster (cowcc) nohr
*Table 3A
*Proliferation U.S. Allies and Nonallies
*Explore U.S. Allies
stset risk1 if risk1~=. & explore2~=., id (cowcc) failure (explore2==1)
stcox usarsenal gdpcap industry1 rivalry polity openness chopen5 year if usguarantee==1, cluster (cowcc) nohr
*Explore U.S. Non-Allies
stcox usarsenal gdpcap  industry1 guarantee rivalry polity openness chopen5 year if usguarantee==0, cluster (cowcc) nohr
*Pursue U.S. Non-Allies
stset risk1 if risk1~=. & pursue~=., id (cowcc) failure (pursue==1)
stcox usarsenal gdpcap industry1 rivalry polity openness chopen5 year if usguarantee==0, cluster (cowcc) nohr

clear

*Table 4A
*System-Level Proliferation Outcomes
use Kroenig_Systel Level
*NPT Signature
regress joinpct_nop5 usarsenal
regress joinpct_nop5 usarsenal coldwar year
*UNSC Resolution
regress unsc_resolution usarsenal 
regress unsc_resolution usarsenal coldwar year

*Table 5A
*Explore
stset risk1 if risk1~=. & explore2~=., id (cowcc) failure (explore2==1)
stcox log_usarsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox  us_ordinal industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox usarsenal_change industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox us_cut industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox p5arsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox usarsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year if year > 1968, cluster (cowcc) nohr
stcox usarsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year if year < 1991, cluster (cowcc) nohr
stcox usarsenal no_riopact rio_interact industry1 gdpcap rivalry polity openness chopen5 year, cluster (cowcc) nohr

*Pursue
stset risk1 if risk1~=. & pursue~=., id (cowcc) failure (pursue==1)
stcox log_usarsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox  us_ordinal industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox usarsenal_change industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox us_cut industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox p5arsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year, cluster (cowcc) nohr
stcox usarsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year if year > 1968, cluster (cowcc) nohr
stcox usarsenal industry1 gdpcap guarantee rivalry polity openness chopen5 year if year < 1991, cluster (cowcc) nohr
stcox usarsenal no_riopact rio_interact industry1 gdpcap rivalry polity openness chopen5 year, cluster (cowcc) nohr

*Acquire
stset risk1 if risk1~=. & acquire~=., id (cowcc) failure (acquire==1)
stcox usarsenal nucass_full industry1 rivalry chopen5 year, cluster (cowcc) nohr
stcox log_usarsenal nucass_full industry1 rivalry chopen5 year, cluster (cowcc) nohr
stcox us_ordinal nucass_full industry1 rivalry chopen5 year, cluster (cowcc) nohr
stcox usarsenal_change nucass_full industry1 rivalry chopen5 year, cluster (cowcc) nohr
stcox us_cut nucass_full industry1 rivalry chopen5 year, cluster (cowcc) nohr
stcox p5arsenal nucass_full industry1 rivalry chopen5 year, cluster (cowcc) nohr
stcox usarsenal nucass_full industry1 rivalry chopen5 year if year > 1968, cluster (cowcc) nohr
stcox usarsenal nucass_full industry1 rivalry chopen5 year if year < 1991, cluster (cowcc) nohr
stcox usarsenal nucass_full no_riopact rio_interact industry1 rivalry chopen5 year, cluster (cowcc) nohr

*Sensitive Nuclear Assistance
logit  nucass log_usarsenal rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if npt_nws==0, cluster(dyad)
logit  nucass us_ordinal rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if npt_nws==0, cluster(dyad)
logit  nucass  usarsenal_change rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if npt_nws==0, cluster(dyad)
logit  nucass  cuts rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if  npt_nws==0, cluster(dyad)
logit  nucass  p5arsenal rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if  npt_nws==0, cluster(dyad)
logit  nucass usarsenal rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if year > 1968, cluster(dyad)
logit  nucass usarsenal rel_pow enemy sup_pact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 sup_pact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if year < 1991, cluster(dyad)
logit  nucass usarsenal rel_pow enemy rio_suppact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 rio_suppact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if year, cluster(dyad)
logit  onset usarsenal rel_pow enemy rio_suppact1 rgdp96p1 gdp_grow  openness_1 trade polity21 npt1 nsg1 ldist ldist2 disputes_2 rio_suppact2 rgdp96p2 chopen5_2 openness_2 npt2 count _spline1 _spline2 _spline3 if year, cluster(dyad)


*UNSC Voting
probit unsc_vote  log_usarsenal cap_1 npt2 gdp_un  polity, cluster (cowcc)
probit unsc_vote  us_ordinal cap_1 npt2 gdp_un  polity, cluster (cowcc)
probit unsc_vote  usarsenal_change cap_1 npt2 gdp_un  polity, cluster (cowcc)
probit unsc_vote  us_cut cap_1 npt2 gdp_un  polity, cluster (cowcc)
probit unsc_vote  p5arsenal cap_1 npt2 gdp_un  polity, cluster (cowcc)
probit unsc_vote  usarsenal cap_1 npt2 gdp_un  polity if year > 1968, cluster (cowcc)
probit unsc_vote  usarsenal cap_1 npt2 gdp_un  polity if year < 1991, cluster (cowcc)


*Jo and Gartzke (2007) Test
probit nuke_dfl USarsenal nuk7set1 new_econ l_year_t ln_ri_t r_nukep nuke_a_d d_isol ln_xst1 democ npt_eff majpow regpowt count2, robust cluster(ccode1)
probit nuk_apl USarsenal nuk7set1 new_econ l_year_t ln_ri_t r_nukep nuke_a_d d_isol ln_xst1 democ npt_rati npt_eff majpow regpowt count1, robust cluster(ccode1)

