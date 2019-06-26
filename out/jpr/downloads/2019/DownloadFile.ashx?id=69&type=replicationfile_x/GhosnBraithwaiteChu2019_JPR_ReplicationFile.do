



****************************************************************
****************************************************************
*
* Replication file for "Violence, displacement, contact, and attitudes toward hosting refugees"
* by Faten Ghosn, Alex Braithwaite, and Tiffany S. Chu
* in Journal of Peace Research (2019)
*
****************************************************************
****************************************************************

use "GhosnBraithwaiteChu2019_JPR_ReplicationData.dta", clear


*Support hosting refugees: Figure 5 in Manuscript, Table 3 in Appendix
ologit supphostrefs i.exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

ologit supphostrefs i.moved age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

ologit supphostrefs i.syrianfriendsinleb age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

ologit supphostrefs i.syrrefknow age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

*Would hire a refugee: Figure 6 in Manuscript, Table 4 in Appendix
logit hireref i.exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

logit hireref i.moved age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

logit hireref i.syrianfriendsinleb age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

logit hireref i.syrrefknow age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

*Would allow child to marry a refugee: Figure 7 in Manuscript, Table 5 in Appendix
logit refkidmarry i.exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

logit refkidmarry i.moved age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

logit refkidmarry i.syrianfriendsinleb age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c

logit refkidmarry i.syrrefknow age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c


***Coefficient plots: Figures 5-7 in Manuscript
coefplot s1 s2 s3 s4, drop(_cons 1.district_c 2.district_c 3.district_c 4.district_c 5.district_c 6.district_c 7.district_c 8.district_c 9.district_c 10.district_c 11.district_c 12.district_c 13.district_c 14.district_c 15.district_c 16.district_c 17.district_c 18.district_c 19.district_c 20.district_c 21.district_c 22.district_c 23.district_c 24.district_c) xline(0) graphregion(fcolor(white)) ///
ysize(20) xsize(12) order(exp_viol moved syrianfriendsinleb syrrefknow) legend(off) ///
coeflabels(exp_viol="Experienced Violence" moved="Displaced" syrianfriendsinleb="Syrian friends in Lebanon" syrrefknow="Know displaced Syrians" age="Age" male="Male" married="Married" 2.relig="Shia" 3.relig="Maronite" 4.relig="Eastern Orthodox" 5.relig="Catholic" 6.relig="Druze" 7.relig="Other" edu_int="Some secondary school" edu_hs="High school" edu_high="College and above" income_1500="Monthly income $501-1500" income_2000="Monthly income exceeds $1501" 1.month_fe="July" 2.month_fe="August") /// 
headings(exp_viol="{bf: Lebanese CW Experience}" syrianfriendsinleb="{bf:Contact with Syrians}" age="{bf:Demographics}" 2.relig="{bf:Religion}" edu_int="{bf:Education}" income_1500="{bf:Income}" 1.month_fe="{bf:Time of Survey}")
*saved as coefplot_supphostrefs.gph

coefplot h1 h2 h3 h4, drop(_cons 1.district_c 2.district_c 3.district_c 4.district_c 5.district_c 6.district_c 7.district_c 8.district_c 9.district_c 10.district_c 11.district_c 12.district_c 13.district_c 14.district_c 15.district_c 16.district_c 17.district_c 18.district_c 19.district_c 20.district_c 21.district_c 22.district_c 23.district_c 24.district_c) xline(0) graphregion(fcolor(white)) ///
ysize(16) xsize(12) order(exp_viol moved syrianfriendsinleb syrrefknow) scheme(s2mono) legend(off)  ///
coeflabels(exp_viol="Experienced Violence" moved="Displaced" syrianfriendsinleb="Syrian friends in Lebanon" syrrefknow="Know displaced Syrians" age="Age" male="Male" married="Married" 2.relig="Shia" 3.relig="Maronite" 4.relig="Eastern Orthodox" 5.relig="Catholic" 6.relig="Druze" 7.relig="Other" edu_int="Some secondary school" edu_hs="High school" edu_high="College and above" income_1500="Monthly income $501-1500" income_2000="Monthly income exceeds $1501" 1.month_fe="July" 2.month_fe="August") /// 
headings(exp_viol="{bf: Lebanese CW Experience}" syrianfriendsinleb="{bf:Contact with Syrians}" age="{bf:Demographics}" 2.relig="{bf:Religion}" edu_int="{bf:Education}" income_1500="{bf:Income}" 1.month_fe="{bf:Time of Survey}")
*saved as coefplot_hireref.gph

coefplot r1 r2 r3 r4, drop(_cons 1.district_c 2.district_c 3.district_c 4.district_c 5.district_c 6.district_c 7.district_c 8.district_c 9.district_c 10.district_c 11.district_c 12.district_c 13.district_c 14.district_c 15.district_c 16.district_c 17.district_c 18.district_c 19.district_c 20.district_c 21.district_c 22.district_c 23.district_c 24.district_c) xline(0) graphregion(fcolor(white)) ///
ysize(16) xsize(12) order(exp_viol moved syrianfriendsinleb syrrefknow) scheme(s2mono) legend(off)  ///
coeflabels(exp_viol="Experienced Violence" moved="Displaced" syrianfriendsinleb="Syrian friends in Lebanon" syrrefknow="Know displaced Syrians" age="Age" male="Male" married="Married" 2.relig="Shia" 3.relig="Maronite" 4.relig="Eastern Orthodox" 5.relig="Catholic" 6.relig="Druze" 7.relig="Other" edu_int="Some secondary school" edu_hs="High school" edu_high="College and above" income_1500="Monthly income $501-1500" income_2000="Monthly income exceeds $1501" 1.month_fe="July" 2.month_fe="August") /// 
headings(exp_viol="{bf: Lebanese CW Experience}" syrianfriendsinleb="{bf:Contact with Syrians}" age="{bf:Demographics}" 2.relig="{bf:Religion}" edu_int="{bf:Education}" income_1500="{bf:Income}" 1.month_fe="{bf:Time of Survey}")
*saved as coefplot_childmarryref.gph




*Histograms of DVs

ologit supphostrefs exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c
histogram supphostrefs if e(sample)==1, discrete frequency by(exp_viol) scheme(s2mono) ytitle("Number of Respondents") ylab(0(200)600)
histogram supphostrefs if e(sample)==1, discrete frequency by(moved) scheme(s2mono) ytitle("Number of Respondents") ylab(0(200)600)
histogram supphostrefs if e(sample)==1, discrete frequency by(syrianfriendsinleb) scheme(s2mono) ytitle("Number of Respondents") ylab(0(200)600)
histogram supphostrefs if e(sample)==1, discrete frequency by(syrrefknow) scheme(s2mono) ytitle("Number of Respondents") ylab(0(200)600)


ologit hireref exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c
histogram hireref if e(sample)==1, discrete frequency by(exp_viol) scheme(s2mono) ytitle("Number of Respondents")
histogram hireref if e(sample)==1, discrete frequency by(moved) scheme(s2mono) ytitle("Number of Respondents") 
histogram hireref if e(sample)==1, discrete frequency by(syrianfriendsinleb) scheme(s2mono) ytitle("Number of Respondents") 
histogram hireref if e(sample)==1, discrete frequency by(syrrefknow) scheme(s2mono) ytitle("Number of Respondents") 


ologit refkidmarry exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c
histogram refkidmarry if e(sample)==1, discrete frequency by(exp_viol) scheme(s2mono) ytitle("Number of Respondents") 
histogram refkidmarry if e(sample)==1, discrete frequency by(moved) scheme(s2mono) ytitle("Number of Respondents") 
histogram refkidmarry if e(sample)==1, discrete frequency by(syrianfriendsinleb) scheme(s2mono) ytitle("Number of Respondents") 
histogram refkidmarry if e(sample)==1, discrete frequency by(syrrefknow) scheme(s2mono) ytitle("Number of Respondents") 

*Figure 2 in Manuscript
graph combine "Graphs/hist_supphost_expviol.gph" ///
"Graphs/hist_supphost_displaced.gph" ///
"Graphs/hist_supphost_syrfriendsleb.gph" ///
"Graphs/hist_supphost_knowsyr.gph", ///
graphregion(fcolor(white)) commonscheme scheme(s2mono) 

*Figure 3 in Manuscript
graph combine "Graphs/hist_hireref_expviol.gph" ///
"Graphs/hist_hireref_displaced.gph" ///
"Graphs/hist_hireref_syrfriendsleb.gph" ///
"Graphs/hist_hire_knowsyr.gph", ///
graphregion(fcolor(white)) commonscheme scheme(s2mono) 

*Figure 4 in Manuscript
graph combine "Graphs/hist_childmarry_expviol.gph" ///
"Graphs/hist_childmarry_displaced.gph" ///
"Graphs/hist_childmarry_syrfriendsleb.gph" ///
"Graphs/hist_childmarry_knowsyr.gph", ///
graphregion(fcolor(white)) commonscheme scheme(s2mono) 


*IPW regressions
*Support hosting refugees: Table 7 in Appendix
ologit supphostrefs i.exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

ologit supphostrefs i.moved age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

ologit supphostrefs i.syrianfriendsinleb age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

ologit supphostrefs i.syrrefknow age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]


*Would hire a refugee: Table 8 in Appendix
logit hireref i.exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

logit hireref i.moved age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

logit hireref i.syrianfriendsinleb age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

logit hireref i.syrrefknow age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

*Would allow child to marry a refugee: Table 9 in Appendix
logit refkidmarry i.exp_viol age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

logit refkidmarry i.moved age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

logit refkidmarry i.syrianfriendsinleb age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

logit refkidmarry i.syrrefknow age male married i.relig  edu_int edu_hs edu_high income_1500 income_2000 i.month_fe i.district_c [pweight=weight_lvl]

