
*****************************************************
** Replication data and do-files
** Fjelde, Hultmant and Lindberg
** Offsetting losses: Bargaining power and rebel attacks on peacekeepers
** Forthcoming, International Studies Quarterly
*****************************************************

// Note to the reader: this do-file and data set replicates the results for the article "Offsetting losses: Bargaining power and rebel attacks on peacekeepers" 
// and is based on the Peacemakers at Risk data, version 1.0 Beta. Those interested in the most recent version of the Peacemakers at Risk dataset and all events 
// and event information contained in the original data should consult the datapage of the Uppsala Conflict Data Program at www.ucdp.uu.se.     


clear
use  ".../FjeldeHultmanLindberg_ISQ2015.dta" 


******************************************************
* TABLE 2
******************************************************

* Model 1: All PAR violence
poisson nr_allviolence_PK rebellosses lreblosses_PAR ldeaths_cw un force large rebelstrength_max noallvi_decay i.episode_id  

*  Model 2: Lethal PAR violence
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nolethal_decay i.episode_id  

* Model 3: Non-lethal PAR violence
poisson nr_nonlethal_PK rebellosses lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nononle_decay i.episode_id   
 
*  Model 4: Lethal PAR violence w. additional control variables
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nolethal_decay cwduration time_deployment  i.episode_id    
  
* Model 5: Lethal PAR violence w. 3-month rule
poisson nr_lethal_PK rebellosses_3month lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nolethal_decay i.episode_id if time_noactive<4
  
* Model 6: all lethal PAR events 
poisson nr_lethal_all rebellosses lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nolethal_all_decay i.episode_id  
    
  
  
******************************************************
* TABLE 3 
******************************************************

* Model 7: Lethal PAR violence, interaction rebel losses w. government and rebel losses w. peacekeepers 
generate rebloss_parloss=rebellosses*lreblosses_PAR
poisson nr_lethal_PK rebellosses lreblosses_PAR rebloss_parloss  rebelstrength_max ldeaths_cw un force large nolethal_decay i.episode_id if time_noactive<13 
  
* Model 8: Lethal PAR violence, interaction rebel losses w. government and rebel strength
generate rebloss_strength=rebellosses*rebelstrength_max
poisson nr_lethal_PK rebellosses lreblosses_PAR rebelstrength_max rebloss_strength ldeaths_cw un force large nolethal_decay i.episode_id if time_noactive<13 


* Model 9: Lethal PAR violence, interaction rebel losses w. government and weak central command
generate rebloss_comm=rebellosses*rebelcentcommand_min
poisson nr_lethal_PK rebellosses lreblosses_PAR rebelstrength_max rebelcentcommand_min rebloss_comm ldeaths_cw  un force large nolethal_decay i.episode_id if time_noactive<13 
  
 
 
******************************************************
* SUBSTANTIVE EFFECTS
******************************************************

** Substantive effects of Rebel losses, based on Table 2, Model 2 

capture drop b*
estsimp poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw un force large rebelstrength_max nolethal_decay ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 if time_noactive<13  

* Simulation scenario: large, non-UN missions with force mandate and other variables at mean)
setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.05
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.10
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.15
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.20
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.25
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.30
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.35
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.40
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.45
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.50
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.55
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.60
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.65
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.70
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.75
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.80
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.85
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.88
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.90
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 0.95
simqi, ev

setx (lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx rebellosses 1.00
simqi, ev


*** Change dataset for this 

clear
use ".../sim_output_mainmodel.dta"
twoway (line y rebellosses, sort lcolor(gs8) lpattern(solid)) (line ylow rebellosses, sort lcolor(gs8) lpattern(dash)) (line yhigh rebellosses, sort lcolor(gs8) lpattern(dash)), ytitle(Predicted number of lethal attacks) ytitle(, size(small)) ylabel(, labsize(small)) ymtick(, labsize(small)) xtitle( Rebel losses, size(small)) xlabel(#8, labsize(small)) xmtick(, labsize(small)) legend(order(1  2 C.I. low 3 C.I high) size(small)) graphregion(margin(large))


*********************************


clear
use  ".../FjeldeHultmanLindberg_ISQ2015.dta" 


*** Substantive effects PKO sidetaking based on Table 2, Model 2
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nolethal_decay ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 if time_noactive<13  
 
capture drop b* 
estsimp poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw  un force large rebelstrength_max nolethal_decay ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 if time_noactive<13  

setx (rebellosses ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx lreblosses_PAR 0
simqi, ev

setx (rebellosses ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx lreblosses_PAR .1
simqi, ev

setx (rebellosses ldeaths_cw nolethal_decay rebelstrength_max) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx lreblosses_PAR 6.7
simqi, ev
 
 
 *** Substantive effects PKO force based on Table 2, Model 2
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw un force large rebelstrength_max nolethal_decay ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 if time_noactive<13  
 
capture drop b* 
estsimp poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw un force large rebelstrength_max nolethal_decay ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 if time_noactive<13  

setx (rebellosses lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx force 0
simqi, ev

setx (rebellosses lreblosses_PAR ldeaths_cw nolethal_decay rebelstrength_max) mean (large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep19 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18) 0
setx force 1
simqi, ev
 
 
 
** Substantive effects, interaction rebel losses and rebel strength based on Table 3, Model 7
generate rebloss_strength=rebellosses*rebelstrength_max

drop b*  
estsimp poisson nr_lethal_PK rebellosses lreblosses_PAR rebelstrength_max rebloss_strength ldeaths_cw un force large nolethal_decay ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19 if time_noactive<13  

* Scenario 1  
setx  rebellosses 0 rebelstrength_max 0 rebloss_strength 0 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev  genev(ev00) 

* Scenario 2
setx rebellosses 1 rebelstrength_max 0 rebloss_strength 0  (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev genev(ev10) 

* Scenario 3  
setx rebellosses 0 rebelstrength_max 1 rebloss_strength 0 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev  genev(ev01) 

* Scenario 4
setx rebellosses 1 rebelstrength_max 1 rebloss_strength 1 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev genev(ev11) 

* Scenario 5  
setx rebellosses 0 rebelstrength_max 2 rebloss_strength 0 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev  genev(ev02) 

* Scenario 6
setx rebellosses 1 rebelstrength_max 2 rebloss_strength 2 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev genev(ev12) 

* Scenario 7
setx rebellosses 0 rebelstrength_max 3 rebloss_strength 0 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9  ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev genev(ev03) 

* Scenario 8
setx rebellosses 1 rebelstrength_max 3 rebloss_strength 3 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9  ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev  genev(ev13)

* Scenario 9
setx rebellosses 0 rebelstrength_max 4 rebloss_strength 0 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9  ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev genev(ev04) 

* Scenario 10
setx rebellosses 1 rebelstrength_max 4 rebloss_strength 4 (lreblosses_PAR ldeaths_cw nolethal_decay) mean (force large) 1 (un) 0 (ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9  ep11 ep12 ep13 ep14 ep15 ep16 ep17 ep18 ep19) 0 
simqi, ev  genev(ev14)

gen slblurred2e0 = ev10 - ev00
gen slblurred2e1 = ev11 - ev01
gen slblurred2e2 = ev12 - ev02
gen slblurred2e3 = ev13 - ev03
gen slblurred2e4 = ev14 - ev04

sumqi slblurred2e0 slblurred2e1 slblurred2e2 slblurred2e3 slblurred2e4  



******************************************************
* ADDITIONAL ROBUSTNESS TESTS, NOT REPORTED
******************************************************

* Robustness w. negative binomial estimator 
nbreg nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw cwduration un force large rebelstrength_max nononle_decay i.episode_id  
 
* Adding robust standard errors
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw cwduration un force large rebelstrength_max nolethal_decay i.episode_id , vce(robust)

* Replacing the decay function with cubic polynomials
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw cwduration un force large rebelstrength_max no_lethal_PK_li no_lethal_PK_sq no_lethal_PK_cu i.episode_id if time_noactive<13, vce(robust)

* Only active months
poisson nr_lethal_PK rebellosses lreblosses_PAR ldeaths_cw cwduration un force large rebelstrength_max nolethal_decay i.episode_id if activemonth==1, vce(robust) 










