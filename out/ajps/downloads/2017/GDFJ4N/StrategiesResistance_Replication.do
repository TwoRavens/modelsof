*Strategies of Resistance: Diversification and Diffusion
*Cunningham, Dahl, and Frugé
*AJPS Replication Do File

*Open main data
*use "StrategiesResistance_Replication_AJPS.dta"
tsset facid year

*Article Table 2: SUR Model on Tactics of Resistance  
sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

outreg2 using AJPS_Table2.xls, coefastr dec(3) symbol(**, *) replace 

*Figures
*Figure 1: Direct strategy difussion
use "Strategies graph data figure 1_AJPS.dta"
twoway (bar effect xpos, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability) xtitle(Direct Diffussion) yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xlabel(.5 "Economic" 1 "Protest" 1.5 "Social" 2 "NV intervention" 2.5 "Institutional" 3 "Violence", labsize(small) angle(forty_five)) legend(off) graphregion(fcolor(white) ifcolor(white)) 

*Figure 2: Diffusion through tactical diversification
use "Strategies graph data figure 2_AJPS.dta"
capture cd "/Users/kathleencunningham/Dropbox//Organizaional Behavior project/KC_AF_MD/regression files/AJPS_R&R"

twoway (bar violence xpos1, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Violence) ///
 xlabel(.5 "Protest" 1 "Institutional" 1.5 "Violence" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "violence", replace

twoway (bar economic xpos2, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Economic) ///
 xlabel(.5 "Economic" 1 "Protest" 1.5 "Social" 2 "Political" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "economic", replace

twoway (bar protest xpos3, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Protest) ///
 xlabel(.5 "Protest" 1 "Social" 1.5 "NV intervention" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "protest", replace


twoway (bar social xpos4, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Social) ///
 xlabel(.5 "Economic" 1 "Protest" 1.5 "Social" 2 "NV intervention" 2.5 "Political" 3 "Institutional" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "social", replace

twoway (bar nonviolentintervention xpos5, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of NV Intervention) ///
 xlabel(0 " " .5 "NV Intervention" 1 " ", labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "nv", replace

twoway (bar political xpos6, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Political) ///
 xlabel(.5 "Social" 1 "NV intervention" 1.5 "Political" 2 "Violence" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "political", replace


twoway (bar institutional xpos7, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Institutional) ///
 xlabel(.5 "Social" 1 "Political" 1.5 "Institutional" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "institutional", replace

gr combine "economic" "protest" "social" "nv" "political" "institutional"



 *summary statistics: Appendix Table 1
 *use "StrategiesResistance_Replication_AJPS.dta"
 preserve
tsset facid year
keep anyNV economic_noncoop protest_demonstration nvintervention social_noncoop ///
institutional political_nocoop violence_state numotherorg numotherprotestnew ///
numothereconomicnew numotherviolence_statenew numothernvinew numothersocialnew ///
numothersintitutionalnew averageimportgdp log_grouppop polity2 anyelectionNELDA

order  anyNV economic_noncoop protest_demonstration nvintervention social_noncoop ///
institutional political_nocoop violence_state numotherorg numotherprotestnew ///
numothereconomicnew numotherviolence_statenew numothernvinew numothersocialnew ///
numothersintitutionalnew averageimportgdp log_grouppop polity2 anyelectionNELDA
estpost summ
restore

*use "StrategiesResistance_Replication_AJPS.dta"
*Appendix Table 3: SUR Model on Tactics of Resistance with 2-year Lag 
tsset facid year
sureg (economic_noncoop L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew ///
L2.numothernvinew L2.numotherpoliticalnew L2.numothersintitutionalnew averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew ///
L2.numothernvinew L2.numotherpoliticalnew  L2.numothersintitutionalnew  log_grouppop  polity2 yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew L2.numothernvinew ///
L2.numotherpoliticalnew  L2.numothersintitutionalnew  yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew ///
L2.numothernvinew L2.numotherpoliticalnew L2.numothersintitutionalnew   yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew L2.numothernvinew ///
 L2.numotherpoliticalnew  L2.numothersintitutionalnew anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew ///
L2.numothernvinew L2.numotherpoliticalnew L2.numothersintitutionalnew anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L2.numotherviolence_statenew L2.numothereconomicnew L2.numotherprotestnew L2.numothersocialnew L2.numothernvinew ///
 L2.numotherpoliticalnew L2.numothersintitutionalnew yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

 outreg2 using AJPS_AppendixTable3.xls, coefastr dec(3) symbol(**, *, +) replace 
 
 *Appendix Table 4: SUR Model on Tactics of Resistance with 3-year Lag 
 sureg (economic_noncoop L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew ///
L3.numothernvinew L3.numotherpoliticalnew L3.numothersintitutionalnew averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew ///
L3.numothernvinew L3.numotherpoliticalnew  L3.numothersintitutionalnew  log_grouppop  polity2 yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew L3.numothernvinew ///
L3.numotherpoliticalnew  L3.numothersintitutionalnew  yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew ///
L3.numothernvinew L3.numotherpoliticalnew L3.numothersintitutionalnew   yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew L3.numothernvinew ///
 L3.numotherpoliticalnew  L3.numothersintitutionalnew anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew ///
L3.numothernvinew L3.numotherpoliticalnew L3.numothersintitutionalnew anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L3.numotherviolence_statenew L3.numothereconomicnew L3.numotherprotestnew L3.numothersocialnew L3.numothernvinew ///
 L3.numotherpoliticalnew L3.numothersintitutionalnew yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

 outreg2 using AJPS_AppendixTable4.xls, coefastr dec(3) symbol(**, *) replace 
 

 *Appendix Table 5:SUR Model on Tactics of Resistance with Control for Armed Conflict (Decay Term) 
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  armedc_d2 yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 armedc_d2 yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  armedc_d2 yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   armedc_d2 yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 armedc_d2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop armedc_d2 yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew armedc_d2 yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small
 
 outreg2 using AJPS_AppendixTable5.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 6:SUR Model on Tactics of Resistance with Imports as % GDP in All Equations  
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew log_grouppop  averageimportgdp yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 averageimportgdp yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  averageimportgdp yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   averageimportgdp yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 averageimportgdp yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop averageimportgdp yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small


 
 outreg2 using AJPS_AppendixTable6.xls, coefastr dec(3) symbol(**, *) replace 

 *Appendix Table 7: SUR Model on Tactics of Resistance with Controls for Concessions and Repression
   sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L.concession L.anyPTSrepression_GROUP yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L.concession L.anyPTSrepression_GROUP yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L.concession L.anyPTSrepression_GROUP yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L.concession L.anyPTSrepression_GROUP yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L.concession L.anyPTSrepression_GROUP yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L.concession L.anyPTSrepression_GROUP yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L.concession L.anyPTSrepression_GROUP yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small


 outreg2 using AJPS_AppendixTable7.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 8:SUR Model on Tactics of Resistance with Control for Wing Ties Between Organizations  
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  wing yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 wing yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  wing yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   wing yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 wing yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop wing yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew wing yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small
 
 outreg2 using AJPS_AppendixTable8.xls, coefastr dec(3) symbol(**, *) replace 
 *Appendix Table 9: SUR Model on Tactics of Resistance with Control for Repression 1-year Lag  
sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L.anyPTSrepression_GROUP yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L.anyPTSrepression_GROUP yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L.anyPTSrepression_GROUP yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L.anyPTSrepression_GROUP yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L.anyPTSrepression_GROUP yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L.anyPTSrepression_GROUP yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L.anyPTSrepression_GROUP yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small


 outreg2 using AJPS_AppendixTable9.xls, coefastr dec(3) symbol(**, *) replace 
 *Appendix Table 10: SUR Model on Tactics of Resistance with Control for Repression 2-year Lag  
sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L2.anyPTSrepression_GROUP yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L2.anyPTSrepression_GROUP yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L2.anyPTSrepression_GROUP yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L2.anyPTSrepression_GROUP yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L2.anyPTSrepression_GROUP yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L2.anyPTSrepression_GROUP yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L2.anyPTSrepression_GROUP yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small
 
 outreg2 using AJPS_AppendixTable10.xls, coefastr dec(3) symbol(**, *) replace 
 *Appendix Table 11:SUR Model on Tactics of Resistance with Control for Repression 3-year Lag  
  sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L3.anyPTSrepression_GROUP yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L3.anyPTSrepression_GROUP yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L3.anyPTSrepression_GROUP yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L3.anyPTSrepression_GROUP yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L3.anyPTSrepression_GROUP yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L3.anyPTSrepression_GROUP yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L3.anyPTSrepression_GROUP yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small
 
 outreg2 using AJPS_AppendixTable11.xls, coefastr dec(3) symbol(**, *) replace 
 *Appendix Table 12: SUR Model on Tactics of Resistance with Control for Concessions (1-year Lag)
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L.concession yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L.concession yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L.concession yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L.concession yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L.concession yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L.concession yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L.concession yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

 outreg2 using AJPS_AppendixTable12.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 13: SUR Model on Tactics of Resistance with Control for Concessions (2-year Lag)
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L2.concession yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L2.concession yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L2.concession yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L2.concession yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L2.concession yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L2.concession yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L2.concession yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

 outreg2 using AJPS_AppendixTable13.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 14: SUR Model on Tactics of Resistance with Control for Concessions (3-year Lag)
sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  L3.concession yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 L3.concession yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  L3.concession yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   L3.concession yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 L3.concession yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop L3.concession yrsnoinstitutional yrsnoinstitutional3 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew L3.concession yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small
 
 outreg2 using AJPS_AppendixTable14.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 15:SUR Model on Tactics of Resistance with Controls for Geographic Concentration of SD Movement, Country-level Political Instability and Relative SD Group Size
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp  groupcon instab1  log_groupsizepercent yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew   polity2 groupcon instab1  log_groupsizepercent yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  groupcon instab1  log_groupsizepercent yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   groupcon instab1  log_groupsizepercent yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 groupcon instab1  log_groupsizepercent yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA groupcon instab1  log_groupsizepercent yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew groupcon instab1  log_groupsizepercent yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small


 outreg2 using AJPS_AppendixTable15.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 16: SUR Model on Tactics of Resistance including Country Dummies (Not Shown in Table)
 set matsize 800
*cty*
sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  cty* yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 cty* yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  cty* yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   cty* yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 cty* yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop cty* yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew cty* yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small


 outreg2 using AJPS_AppendixTable16.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 17:SUR Model on Tactics of Resistance with Control for the Number of Organizations
 sureg (economic_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew averageimportgdp log_grouppop  numotherorg yrseconomic_noncoop yrseconomic_noncoop2 ///
yrseconomic_noncoop3) ///
(protest_demonstration L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew  L.numothersintitutionalnew  log_grouppop  polity2 numotherorg yrsprotest_demonstration ///
yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
L.numotherpoliticalnew  L.numothersintitutionalnew  numotherorg yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew   numotherorg yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew  L.numothersintitutionalnew anyelectionNELDA polity2 numotherorg yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew ///
L.numothernvinew L.numotherpoliticalnew L.numothersintitutionalnew anyelectionNELDA log_grouppop numotherorg yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numothereconomicnew L.numotherprotestnew L.numothersocialnew L.numothernvinew ///
 L.numotherpoliticalnew L.numothersintitutionalnew numotherorg yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

 outreg2 using AJPS_AppendixTable17.xls, coefastr dec(3) symbol(**, *) replace 
 
 *Appendix Table 18: SUR Model on Tactics of Resistance using Within Country Diffusion (1-year Lags)
sureg (economic_noncoop L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint ///
L.country_numotherpolitical L.country_numotherinstit averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 yrseconomic_noncoop3) ///
(protest_demonstration L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint ///
L.country_numotherpolitical L.country_numotherinstit  log_grouppop  polity2 yrsprotest_demonstration yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint L.country_numotherpolitical ///
L.country_numotherinstit yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint L.country_numotherpolitical ///
L.country_numotherinstit   yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint L.country_numotherpolitical ///
L.country_numotherinstit anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint L.country_numotherpolitical ///
L.country_numotherinstit anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.country_numotherviolence L.country_numothereconomic L.country_numotherprotest  L.country_numothersocial L.country_numothernvint L.country_numotherpolitical ///
L.country_numotherinstit yrsviolencestate yrsviolencestate2 yrsviolencestate3)if singlemvmtincountry==0, corr small

 outreg2 using AJPS_AppendixTable18.xls, coefastr dec(3) symbol(**, *) replace 

 *Appendix Table 19: SUR Model on Tactics of Resistance using Within Country Diffusion (2-year Lags)
 sureg (economic_noncoop L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint ///
L2.country_numotherpolitical L2.country_numotherinstit averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 yrseconomic_noncoop3) ///
(protest_demonstration L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint ///
L2.country_numotherpolitical L2.country_numotherinstit  log_grouppop  polity2 yrsprotest_demonstration yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint L2.country_numotherpolitical ///
L2.country_numotherinstit yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint L2.country_numotherpolitical ///
L2.country_numotherinstit   yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint L2.country_numotherpolitical ///
L2.country_numotherinstit anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint L2.country_numotherpolitical ///
L2.country_numotherinstit anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L2.country_numotherviolence L2.country_numothereconomic L2.country_numotherprotest  L2.country_numothersocial L2.country_numothernvint L2.country_numotherpolitical ///
L2.country_numotherinstit yrsviolencestate yrsviolencestate2 yrsviolencestate3) if singlemvmtincountry==0, corr small


 outreg2 using AJPS_AppendixTable19.xls, coefastr dec(3) symbol(**, *) replace 

 *Appendix Table 20: SUR Model on Tactics of Resistance using Within Country Diffusion (3-year Lags)
 sureg (economic_noncoop L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint ///
L3.country_numotherpolitical L3.country_numotherinstit averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 yrseconomic_noncoop3) ///
(protest_demonstration L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint ///
L3.country_numotherpolitical L3.country_numotherinstit  log_grouppop  polity2 yrsprotest_demonstration yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint L3.country_numotherpolitical ///
L3.country_numotherinstit yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint L3.country_numotherpolitical ///
L3.country_numotherinstit   yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint L3.country_numotherpolitical ///
L3.country_numotherinstit anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint L3.country_numotherpolitical ///
L3.country_numotherinstit anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L3.country_numotherviolence L3.country_numothereconomic L3.country_numotherprotest  L3.country_numothersocial L3.country_numothernvint L3.country_numotherpolitical ///
L3.country_numotherinstit yrsviolencestate yrsviolencestate2 yrsviolencestate3) if singlemvmtincountry==0, corr small

 outreg2 using AJPS_AppendixTable20.xls, coefastr dec(3) symbol(**, *) replace 

 *Appendix Table 21: SUR Model on Tactics of Resistance with High and Low Resource Aggregation
  sureg (high L.numotherhigh L.numotherlow2 averageimportgdp log_grouppop  polity2 anyelectionNELDA yrshigh yrshigh2 yrshigh3) ///
(low L.numotherhigh L.numotherlow2 polity2 anyelectionNELDA yrslow yrslow2 yrslow3) ///
(institutional L.numotherviolence_statenew L.numotherhigh L.numotherlow2 L.numothersintitutionalnew ///
anyelectionNELDA log_grouppop  yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state L.numotherviolence_statenew L.numotherhigh L.numotherlow2  ///
 L.numothersintitutionalnew  yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small
 outreg2 using AJPS_R&R_SUR_highlow2.xls, coefastr dec(3) symbol(**, *, +) replace 
 
 outreg2 using AJPS_AppendixTable21.xls, coefastr dec(3) symbol(**, *) replace  
 
 *Appendix Table 22: SUR Model on Tactics of Resistance with Percent of Organizations using Tactics 
 sureg (economic_noncoop  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
 L.percent_otherpolitical_nocoop L.percent_otherinstitutional averageimportgdp log_grouppop  yrseconomic_noncoop yrseconomic_noncoop2 yrseconomic_noncoop3) ///
(protest_demonstration  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
L.percent_otherpolitical_nocoop L.percent_otherinstitutional log_grouppop  polity2 yrsprotest_demonstration yrsprotest_demonstration2 yrsprotest_demonstration3) /// 
(social_noncoop  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
L.percent_otherpolitical_nocoop L.percent_otherinstitutional yrssocial_noncoop yrssocial_noncoop2 yrssocial_noncoop3) ///
(nvintervention  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
L.percent_otherpolitical_nocoop L.percent_otherinstitutional yrsnvintervention yrsnvintervention2 yrsnvintervention3) ///
(political_nocoop  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
L.percent_otherpolitical_nocoop L.percent_otherinstitutional anyelectionNELDA polity2 yrsnpolitical_nocoop yrsnpolitical_nocoop2 yrsnpolitical_nocoop3) ///
(institutional  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
L.percent_otherpolitical_nocoop L.percent_otherinstitutional anyelectionNELDA log_grouppop yrsnoinstitutional yrsnoinstitutional2 yrsnoinstitutional3)  ///
(violence_state  L.percent_otherviolence_state L.percent_otherecon L.percent_otherprotest L.percent_othersocial L.percent_othernvintervention ///
L.percent_otherpolitical_nocoop L.percent_otherinstitutional yrsviolencestate yrsviolencestate2 yrsviolencestate3), corr small

 outreg2 using AJPS_AppendixTable22.xls, coefastr dec(3) symbol(**, *) replace 

 *Appendix Table 23: Logistic Regression of Repression of the SD Movement
 logit anyPTSrepression_GROUP L.violence_state L.economic_noncoop L.protest_demonstration L.social_noncoop L.nvintervention L.political_nocoop L.institutional L.anyPTSrepression_GROUP, cluster(kgcid)

 outreg2 using AJPS_AppendixTable23.xls, coefastr dec(3) symbol(**, *) replace 
 *Appendix Table 24 is correlation matrix from Article Table 2 SUR
 
 *Appendix Table 25: Logistic Regression of Organizational tsset facid year of Any Nonviolent Tactics
 logit anyNV L.numotherNV yearsince_anyNV yearsince_anyNV2 yearsince_anyNV3, cluster(facid)
 outreg2 using AJPS_AppendixTable25.xls, coefastr dec(3) symbol(**, *) replace 
 
 

 
 
 
