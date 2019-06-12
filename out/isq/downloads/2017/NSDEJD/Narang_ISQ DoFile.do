use "/Users/narangn/Dropbox/Work/Working Papers/Can Humanitarian Aid Prolong Conflict/ISQ/AidDuration ISQ R&R/Data/HAWarDur from Cunningham.dta"

*****STSET DATA SURVIVAL
stset t1, id(warnumber) failure(warend) enter(t0)


**************
*Hypothesis 1*
**************
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if pcw==1
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if pcw<1
**************
*Hypothesis 2*
**************
***Generate INTERACTION.
generate aidlogperihperal = aidlog*perihperal
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0 & pcw==1
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0 & pcw==0
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if  pcw==1
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if  pcw==0

***************************************************************************************************************************************************
*Appendix Table A3: "interact covriates with time diagnostic" of Poportional Hazard Assumption for Hypothesis 1 and Hypothesis 2 *
***************************************************************************************************************************************************

********************************
*Hypothesis 1 Time Varying Test*
********************************
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests, tvc(aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests) texp(_t)
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests, tvc(aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests) texp(_t), if pcw==1
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests, tvc(aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests) texp(_t), if pcw<1
********************************
*Hypothesis 2 Time Varying Test*
********************************
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal, tvc(aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal) texp(_t), if aidlog>0
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal, tvc(aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal) texp(_t), if aidlog>0 & pcw==1
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal, tvc(aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal) texp(_t), if aidlog>0 & pcw==0




***************************************************************************************************************************************************
*Appendix Table A4: "unit-level heterogenity diagnostic" using shared frailty models for Hypothesis 1 and Hypothesis 2 *
***************************************************************************************************************************************************

****************
*Hypothesis 1 *
****************
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests, vce(cluster cow_location) 
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if pcw==1, vce(cluster cow_location)
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if pcw<1, vce(cluster cow_location)
***************
*Hypothesis 2*
***************
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0, vce(cluster cow_location)
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0 & pcw==1, vce(cluster cow_location)
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0 & pcw==0, vce(cluster cow_location)




***************************************************************************************************************************************************
*Appendix Table A5: Dealing with Ties using exactm option Cleves 2010 pg 148
***************************************************************************************************************************************************

**************
*Hypothesis 1*
**************
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests, exactm
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if pcw==1, exactm
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if pcw<1, exactm
**************
*Hypothesis 2*
**************
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0, exactm
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0 & pcw==1, exactm
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal if aidlog>0 & pcw==0, exactm


***************************************************************************************************************************************************
*Appendix Table A6: Instrumental Variable using Natural Disasters
***************************************************************************************************************************************************

heckprobit warend aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if perihperal==1, select(aidlog = bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests logORDdef2k) vce(cluster warnumber) 
heckprobit warend aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee if perihperal==1, select(aidlog = bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee logORDdef2k) vce(cluster warnumber) 
heckprobit warend aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs if perihperal==1, select(aidlog = bdeadbestlag logpop gdppc polity2 diamonds drugs logORDdef2k) vce(cluster warnumber) 
heckprobit warend aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests if perihperal==0, select(aidlog = bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests logORDdef2k) vce(cluster warnumber) 
heckprobit warend aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee if perihperal==0, select(aidlog = bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee logORDdef2k) vce(cluster warnumber) 
heckprobit warend aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs if perihperal==0, select(aidlog = bdeadbestlag logpop gdppc polity2 diamonds drugs logORDdef2k) vce(cluster warnumber) 



***************************************************************************************************************************************************
*Appendix Table A7: Including (1)number of veto players (Strictvetos or Lenientvetos), (2)conflict type (Ethnic Coup Anticolonial), and (3)ethnic homogeneity (EF or elf)
***************************************************************************************************************************************************

**************
*Hypothesis 1*
**************
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests strictvetos elf coup anticolonial ethnicconflict
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests strictvetos elf coup anticolonial ethnicconflict if pcw==1
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests strictvetos elf coup anticolonial ethnicconflict if pcw<1
**************
*Hypothesis 2*
**************
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal strictvetos elf coup anticolonial ethnicconflict if aidlog>0
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal strictvetos elf coup anticolonial ethnicconflict if aidlog>0 & pcw==1
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal strictvetos elf coup anticolonial ethnicconflict if aidlog>0 & pcw==0


***************************************************************************************************************************************************
*Appendix Table A8: Other External Support R2 T1
***************************************************************************************************************************************************

**************
*Hypothesis 1*
**************
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests transconstsupp_binary rebextpart_binary rebelsupport_binary govsupport_binary govextpart_binary
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests transconstsupp_binary rebextpart_binary rebelsupport_binary govsupport_binary govextpart_binary if pcw==1
stcox aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests transconstsupp_binary rebextpart_binary rebelsupport_binary govsupport_binary govextpart_binary if pcw<1
**************
*Hypothesis 2*
**************
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal transconstsupp_binary rebextpart_binary rebelsupport_binary govsupport_binary govextpart_binary if aidlog>0
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal transconstsupp_binary rebextpart_binary rebelsupport_binary govsupport_binary govextpart_binary if aidlog>0 & pcw==1
stcox aidlogperihperal aidlog bdeadbestlag logpop gdppc polity2 diamonds drugs resources guarantee mountains forests perihperal transconstsupp_binary rebextpart_binary rebelsupport_binary govsupport_binary govextpart_binary if aidlog>0 & pcw==0
