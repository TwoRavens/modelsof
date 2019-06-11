

*** 26-29 December 2016 Cyber Experiment Data Analysis

use [file name here], clear 

***Replication Code for Sarah Kreps and Debak Das (2017), “Warring from the Virtual to the Real: Assessing the Public’s Threshold for War on Cyber Security,” Research and Politics.


**FIGURE 1. Effect of four main treatment categories on DVs

. reg airstrikesbi high kinetic certain bipart, vce(robust) 

. estimates store airstrikesDV

. reg cyberattackbi high kinetic certain bipart, vce(robust)

. estimates store cyberattackDV

. reg sanctionsbi high kinetic certain bipart, vce(robust)

. estimates store sanctionsDV

. reg infobi high kinetic certain bipart, vce(robust)

. estimates store infoDV

coefplot (airstrikesDV, label(Airstrikes)) (cyberattackDV, label(Cyberattack)) (sanctionsDV, label(Sanctions)) (infoDV, label(Information)), drop(_cons) xline(0)


*FIGURE 2. Attitudes about Russia by Partisan Identification 

mean rusenemy if party==1

estimates store Democrats

mean rusenemy if party==2

estimates store Independents

mean rusenemy if party==3

estimates store Republicans

coefplot (Democrats, label(Democrats)) (Independents, label(Independents)) (Republicans, label(Republicans))


*FIGURE 3. Support for Retaliatory Airstrikes against Russia by Partisan Identification 

mean airstrikesbi if party==1

estimates store Democrats

mean airstrikesbi if party==2

estimates store Independents

mean airstrikesbi if party==3

estimates store Republicans

coefplot (Democrats, label(Democrats)) (Independents, label(Independents)) (Republicans, label(Republicans))

Appendix

Table D1.  Regression table.

*** Analysis in a logit model

logit infobi high certain kinetic bipart party edu rusenemy hawk agegp male income shop bank cybvic, vce(robust)

logit cyberattackbi high certain kinetic bipart party edu rusenemy hawk agegp male income shop bank cybvic, vce(robust)

logit sanctionsbi high certain kinetic bipart party edu rusenemy hawk agegp male
income shop bank cybvic, vce(robust)

logit airstrikesbi high certain kinetic bipart party edu rusenemy hawk agegp male income shop bank cybvic, vce(robust)


***Graphs for Appendix D figures

**Average Treatment Effects

*Info
logit infobi high certain kinetic bipart party edu rusenemy hawk agegp male income shop bank cybvic, vce(robust)

margins,  dydx(*)post

estimate store AverageEffects

coefplot AverageEffects, yline(0) vertical drop(_cons) byopts(cols(1)) level(90) mlabel format(%8.0f) rescale(100)


*Cyberattack
logit cyberattackbi high certain kinetic bipart party edu rusenemy hawk agegp male income shop bank cybvic, vce(robust)

margins,  dydx(*)post

estimate store AverageEffects

coefplot AverageEffects, yline(0) vertical drop(_cons) byopts(cols(1)) level(90) mlabel format(%8.0f) rescale(100)


*Sanctions

logit sanctionsbi high certain kinetic bipart party edu rusenemy hawk agegp male
income shop bank cybvic, vce(robust)

margins,  dydx(*)post

estimate store AverageEffects

coefplot AverageEffects, yline(0) vertical drop(_cons) byopts(cols(1)) level(90) mlabel format(%8.0f) rescale(100)


*Airstrikes
logit airstrikesbi high certain kinetic bipart party edu rusenemy hawk agegp male income shop bank cybvic, vce(robust)

margins,  dydx(*)post

estimate store AverageEffects

coefplot AverageEffects, yline(0) vertical drop(_cons) byopts(cols(1)) level(90) mlabel format(%8.0f) rescale(100)
