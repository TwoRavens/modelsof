**This code with associated data files will replicate results from Institutional Control of Redistricting and the Geography of Representation. 
**There are two data files, "redistricting_and_geography_cong_dataverse.dta" contains data for congressional districts and "redistricting_and_geography_state_dataverse.dta"
**contains data for state legislative districts

****Figure 2******

*********Figure 2 Congressional Districts*************
use redistricting_and_geography_cong_dataverse.dta
set more off

quietly glm prop_prior_retained   irc non_irc court sec5 abs_seat_change  num_cd year_dum7-year_dum12  ,  link(logit) family(binomial) robust
margins, dydx(*) post
estimates store a

quietly reg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties year_dum7-year_dum12, robust
estimates store c

quietly reg cities_split  irc non_irc court sec5 abs_seat_change per_pop_unincorp  num_cities num_cd year_dum7-year_dum12, robust
estimates store g

quietly glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12   , link(logit) family(binomial) robust
margins, dydx(*) post
estimates store d 

quietly  glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd year_dum1-year_dum12  , link(logit) family(binomial) robust
margins, dydx(*) post
estimates store e

quietly glm reock irc non_irc court sec5   abs_seat_change num_cd  year_dum1-year_dum12 , link(logit) family(binomial) robust
estimates store f 

#delimit ;
coefplot a, bylabel("Continutity" "Pro. Retained (GLM)")  
	|| c , bylabel("Respect for Subdivisions" "Split Counties (OLS)") 
	|| g, bylabel("Respect for Subdivisions" "Split Cities (OLS)")
	|| d , bylabel("Compactness" "Polsby/Popper (GLM)") 
	|| e , bylabel("Compactness" "Convex Hull (GLM)")
	|| f , bylabel("Compactness" "Reock (GLM)")
	

 xline(0)  drop(_cons sec5 abs_seat_change num_cd num_counties per_pop_unincorp num_cities year_dum1 year_dum4 year_dum7 year_dum12)

 msymbol(circle)
 byopts(title("Congressional Districts") note("OLS: Coefficients GLM: dy/dx. both with 95% CIs two-tailed" "Continuity and Respect for Subdivisions 1992-2012" "Compactness 1972-2012") xrescale)
scheme(tufte)
saving(cong, replace)

; 

****Figure 2 State Districts****
use redistricting_and_geography_state_dataverse.dta
set more off
quietly glm prop_retained  irc other_comm court sec5  num_dist chamber_dum ,  link(logit) family(binomial) robust
margins, dydx(*) post
estimates store h

quietly  reg num_counties_split irc other_comm court sec5 num_dist chamber_dum num_counties , robust
estimates store i

quietly  reg num_cities_split irc other_comm court sec5 num_dist chamber_dum per_pop_unincorp  num_cities,   robust
estimates store j

quietly  glm polsby_popper irc other_comm court sec5   num_dist chamber_dum , link(logit) family(binomial) robust
margins, dydx(*) post
estimates store k

quietly  glm ch_ratio  irc other_comm court  sec5   num_dist chamber_dum  , link(logit) family(binomial) robust
margins, dydx(*) post
estimates store l

quietly  glm reock irc other_comm court sec5 num_dist chamber_dum  , link(logit) family(binomial) robust
margins, dydx(*) post
estimates store m


#delimit ;
coefplot h, bylabel("Continutity" "Core Retained (GLM)")   
	|| i , bylabel("Respect for Subdivisions" "Split Counties (OLS)") 
	|| j, bylabel("Respect for Subdivisions" "Split Cities (OLS)")	
	|| k , bylabel("Compactness" "Polsby/Popper (GLM)")
	|| l , bylabel("Compactness" "Convex Hull (GLM)")
	|| m , bylabel("Compactness" "Reock (GLM)")
	
 xline(0)  drop(_cons sec5 abs_seat_change num_cd num_counties per_pop_unincorp  num_cities num_dist year_dum1 year_dum4 year_dum7 year_dum12 chamber_dum)
 msymbol(circle) 
 byopts(title("State Legislative Districts") note("OLS: Coefficients GLM: dy/dx. Both with 95% CIs two-tailed" "All measures 2012 only") xrescale)
scheme(tufte)
saving(leg, replace)

; 

******* Descriptive Statistics, Table 1 in Appendix ****************************
use redistricting_and_geography_cong_dataverse.dta
* for congressional districts
sum prop_prior_retained 
sum num_counties_split 
sum cities_split
sum polsby_popper 
sum ch_ratio 
sum reock 
sum num_prior_dist
sum reock_adj
sum ch_ratio_adj
sum schwartzberg 

* for state legislative districts
use redistricting_and_geography_state_dataverse.dta
set more off

sum prop_retained 
sum num_counties_split 
sum num_cities_split 
sum polsby_popper 
sum ch_ratio 
sum reock 
sum num_dist_merged
sum reock_adj
sum ch_ratio_adj
sum schwartzberg

***Congressional Districts, main regression results, Table 2 in Appendix***
use redistricting_and_geography_cong_dataverse.dta

set more off

glm prop_prior_retained   irc non_irc court sec5 abs_seat_change  num_cd year_dum7-year_dum12,  link(logit) family(binomial) robust

reg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties year_dum7-year_dum12, robust

reg cities_split  irc non_irc court sec5 abs_seat_change per_pop_unincorp  num_cities num_cd year_dum7-year_dum12, robust
 
glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12 , link(logit) family(binomial) robust
 
glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd year_dum1-year_dum12 , link(logit) family(binomial) robust

glm reock irc non_irc court sec5   abs_seat_change num_cd  year_dum1-year_dum12 , link(logit) family(binomial) robust

****State Districts, main regression results, Table 2 in Appendix***

use redistricting_and_geography_state_dataverse.dta
set more off 

glm prop_retained  irc other_comm court sec5  num_dist chamber_dum ,  link(logit) family(binomial) robust

reg num_counties_split irc other_comm court sec5 num_dist chamber_dum num_counties  , robust

reg num_cities_split irc other_comm court sec5 num_dist chamber_dum per_pop_unincorp num_cities ,   robust

glm polsby_popper irc other_comm court sec5   num_dist chamber_dum , link(logit) family(binomial) robust

glm ch_ratio  irc other_comm court  sec5   num_dist chamber_dum , link(logit) family(binomial) robust

glm reock irc other_comm court sec5 num_dist chamber_dum  , link(logit) family(binomial) robust

**Congressional districts, State fixed effects model for appendix, Table 3**
use redistricting_and_geography_cong_dataverse.dta
set more off
glm prop_prior_retained   irc non_irc court sec5 abs_seat_change  num_cd year_dum7-year_dum12 state_dum1-state_dum51,  link(logit) family(binomial) robust

reg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties  year_dum7-year_dum12 state_dum1-state_dum51 , robust

reg cities_split  irc non_irc court sec5 abs_seat_change per_pop_unincorp  num_cities num_cd year_dum7-year_dum12 state_dum1-state_dum51 , robust

glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12 state_dum1-state_dum51 , link(logit) family(binomial) robust

glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd year_dum1-year_dum12 state_dum1-state_dum51 , link(logit) family(binomial) robust

glm reock irc non_irc court sec5   abs_seat_change num_cd  year_dum1-year_dum12 state_dum1-state_dum51, link(logit) family(binomial) robust

***state legislative districts, with state fixed effects for appendix, Table 3***
use redistricting_and_geography_state_dataverse.dta
set more off

glm prop_retained  irc other_comm court sec5  num_dist chamber_dum i.n_state ,  link(logit) family(binomial) robust

reg num_counties_split irc other_comm court sec5 num_dist num_counties chamber_dum i.n_state , robust

reg num_cities_split irc other_comm court sec5 num_dist num_cities per_pop_unincorp chamber_dum i.n_state,   robust

glm polsby_popper irc other_comm court sec5   num_dist chamber_dum i.n_state , link(logit) family(binomial) robust

glm ch_ratio  irc other_comm court  sec5   num_dist chamber_dum  i.n_state, link(logit) family(binomial) robust

glm reock irc other_comm court sec5 num_dist chamber_dum i.n_state  , link(logit) family(binomial) robust


**********Congressional irc states in 72 and 82, Table 4 in Appendix*********
use redistricting_and_geography_cong_dataverse.dta
set more off
glm polsby_popper before_irc non_irc court sec5   abs_seat_change num_cd year_dum1  , link(logit) family(binomial) robust
 

glm reock before_irc non_irc court sec5   abs_seat_change num_cd year_dum1, link(logit) family(binomial) robust
 

glm ch_ratio  before_irc non_irc court  sec5   abs_seat_change num_cd year_dum1  , link(logit) family(binomial) robust

*********additional measures cong districts, adj. scores appendix Table 5***********
use redistricting_and_geography_cong_dataverse.dta

set more off

reg num_prior_dist irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12  , robust

glm reock_adj irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12  , link(logit) family(binomial) robust

glm ch_ratio_adj irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12  , link(logit) family(binomial) robust

reg schwartzberg irc non_irc court sec5   abs_seat_change num_cd year_dum1-year_dum12  , robust 

***state districts appendix Table 6, additional continuity and compactness measures***

use redistricting_and_geography_state_dataverse.dta
set more off

reg num_dist_merged  irc other_comm court sec5   num_dist chamber_dum , robust

glm reock_adj irc other_comm court sec5   num_dist chamber_dum , link(logit) family(binomial) robust

glm ch_ratio_adj irc other_comm court sec5   num_dist chamber_dum , link(logit) family(binomial) robust
 
reg schwartzberg  irc other_comm court sec5   num_dist chamber_dum , robust


****NBREG CONGRESS, for Appendix Table 7***
use redistricting_and_geography_cong_dataverse.dta

set more off
nbreg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties year_dum7-year_dum12 , robust
margins, dydx(*) atmeans

nbreg cities_split  irc non_irc court sec5 abs_seat_change per_pop_unincorp  num_cities num_cd year_dum7-year_dum12, robust
margins, dydx(*) atmeans

****NBREG state level, for Appendix Table 7***
use redistricting_and_geography_state_dataverse.dta
set more off

nbreg num_counties_split irc other_comm court sec5 num_dist chamber_dum num_counties  , robust
margins, dydx(*) atmeans

nbreg num_cities_split irc other_comm court sec5 num_dist chamber_dum per_pop_unincorp num_cities ,   robust
margins, dydx(*) atmeans

***** regression analysis of congressionl districts by cycle, Appendix Tables 8a-8f
use redistricting_and_geography_cong_dataverse.dta
set more off
* Table 8a
glm prop_prior_retained   irc non_irc court sec5 abs_seat_change  num_cd if  year==1992,  link(logit) family(binomial) robust
glm prop_prior_retained   irc non_irc court sec5 abs_seat_change  num_cd if  year==2002,  link(logit) family(binomial) robust
glm prop_prior_retained   irc non_irc court sec5 abs_seat_change  num_cd if  year==2012,  link(logit) family(binomial) robust

* Table 8b
reg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties if  year==1992, robust
reg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties if  year==2002, robust
reg num_counties_split  irc non_irc court sec5 abs_seat_change  num_cd num_counties if  year==2012, robust

* Table 8c
reg cities_split  irc non_irc court sec5 abs_seat_change num_cities num_cd per_pop_unincorp if  year==1992, robust
reg cities_split  irc non_irc court sec5 abs_seat_change num_cities num_cd per_pop_unincorp if  year==2002, robust
reg cities_split  irc non_irc court sec5 abs_seat_change num_cities num_cd per_pop_unincorp if  year==2012, robust 

* Table 8d
glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd  if  year==1972, link(logit) family(binomial) robust
glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd  if  year==1982, link(logit) family(binomial) robust
glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd  if  year==1992, link(logit) family(binomial) robust
glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd  if  year==2002, link(logit) family(binomial) robust
glm polsby_popper irc non_irc court sec5   abs_seat_change num_cd  if  year==2012, link(logit) family(binomial) robust

* Table 8e
glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd if  year==1972, link(logit) family(binomial) robust
glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd if year==1982, link(logit) family(binomial) robust
glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd if  year==1992, link(logit) family(binomial) robust
glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd if  year==2002, link(logit) family(binomial) robust
glm ch_ratio  irc non_irc court  sec5   abs_seat_change num_cd if year==2012, link(logit) family(binomial) robust

* Table 8f
glm reock irc non_irc court sec5   abs_seat_change num_cd if  year==1972, link(logit) family(binomial) robust
glm reock irc non_irc court sec5   abs_seat_change num_cd if  year==1982, link(logit) family(binomial) robust
glm reock irc non_irc court sec5   abs_seat_change num_cd if  year==1992, link(logit) family(binomial) robust
glm reock irc non_irc court sec5   abs_seat_change num_cd if  year==2002, link(logit) family(binomial) robust
glm reock irc non_irc court sec5   abs_seat_change num_cd if  year==2012, link(logit) family(binomial) robust
