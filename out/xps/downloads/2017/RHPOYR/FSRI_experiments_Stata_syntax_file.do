/// This Dataverse file prensents a list of commands allowing users to replicate some of results to be published in 
/// Morin-Chassé, Alexandre. In Press. "How to survey about electoral turnout? Additional evidence." Journal of Experimental Political Science
/// The Dataverse replication file is divided in two parts. 
///   1) Replication for the Short Paragraph Experiment
///   2) Replication for the Face-Saving Response Items experiments.

/// The present syntax file is for the first item of this list: "2) Replication for the Face-Saving Response Items experiments."

/// The analyses below combine 5 new question wording experiments with those that were presented in Morin-Chassé,Alexandre, Damien Bol, Laura B. Stephenson and Simon Labbé St-Vincent 2017. 
/// "How to Survey About Electoral Turnout? The Efficacy of the Face-Saving Response Items in 19 Different Contexts" Political Science Research and Methods 5(3): 575-584
/// Data for the new experiments can be downloaded from http://dx.doi.org/10.7910/DVN/RR0NNQ where ELECID={19,24,25,26,27} ; data from Morin-Chassé et al. 2015 can 
/// be found at http://dx.doi.org/10.7910/DVN/B0NY7Y . 


///To save space, the datafile included in the present Dataverse already combines the relevant datasets together. 
///Open the datafile named "FSRI experiment - Stata data file".
///Once the datafile file is open, run the following commands.


 ///     db                 mm     db        `7MM          
 ///    ;MM:                MM                 MM          
 ///   ,V^MM.    `7Mb,od8 mmMMmm `7MM  ,p6"bo  MM  .gP"Ya  
 ///  ,M  `MM      MM' "'   MM     MM 6M'  OO  MM ,M'   Yb 
 ///  AbmmmqMA     MM       MM     MM 8M       MM 8M"""""" 
 /// A'     VML    MM       MM     MM YM.    , MM YM.    , 
///.AMA.   .AMMA..JMML.     `Mbmo.JMML.YMbmd'.JMML.`Mbmmd' 

* The commands below reproduce each of the effect sizes presented in Figure 1.
* Below these commands, readers can also find the syntax used to generate a raw version of Figure 1.
* This raw version was then marginaly modified using an image editor in other to produce the Figure that appears in the paper.  

*.######..######..######..######...####...######...........####...######..######..######...####..
*.##......##......##......##......##..##....##............##........##.......##...##......##.....
*.####....####....####....####....##........##.............####.....##......##....####.....####..
*.##......##......##......##......##..##....##................##....##.....##.....##..........##.
*.######..##......##......######...####.....##.............####...######..######..######...####..

svyset [pw=POST_WEIGHT1]

***Madrid regional***Madrid regional***Madrid regional  2015
svy: logit voted  i.FSRIs if ELECID==24
margins FSRIs, post
margins, coeflegend
gen obs= e(N) in 1
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
gen effectsize=100*(r(estimate)) in 1
gen p_value="<.001" in 1
gen Case_ID=1 in 1
gen Region="Madrid" in 1
gen Level="Regional" in 1
gen Year="2015" in 1
gen low_ci95= 100*((r(estimate))-(1.96*r(se))) in 1
gen high_ci95= 100*((r(estimate))+(1.96*r(se))) in 1

svy: tab voted_simple if  ELECID==24
svy: tab voted_complx2  if  ELECID==24

***Ontario national***Ontario national***Ontario national 2015
svy: logit voted  i.FSRIs if ELECID==25
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 2
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 2
replace p_value="<.001" in 2
replace Case_ID=2 in 2
replace Region="Ontario" in 2
replace Level="National" in 2
replace Year="2015" in 2
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 2
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 2

svy: tab voted_simple if  ELECID==25
svy: tab voted_complx2  if  ELECID==25

***BC national***BC national***BC national 2015
svy: logit voted  i.FSRIs if ELECID==26
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 3
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 3
replace p_value="0.739" in 3
replace Case_ID=3 in 3
replace Region="British Columbia" in 3
replace Level="National" in 3
replace Year="2015" in 3
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 3
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 3

svy: tab voted_simple if  ELECID==26
svy: tab voted_complx2  if  ELECID==26

***Quebec national***Quebec national***Quebec national 2015
svy: logit voted  i.FSRIs if ELECID==27
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 4
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 4
replace p_value="<.001" in 4
replace Case_ID=4 in 4
replace Region="Quebec" in 4
replace Level="National" in 4
replace Year="2015" in 4
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 4
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 4

svy: tab voted_simple if  ELECID==27
svy: tab voted_complx2  if  ELECID==27

***Bavaria Europe***Bavaria Europe***Bavaria Europe 2014
svy: logit voted  i.FSRIs if ELECID==19
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 5
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace Case_ID=5 in 5
replace effectsize=100*(r(estimate)) in 5
replace p_value=".014" in 5
replace Region="Bavaria" in 5
replace Level="Europe" in 5
replace Year="2014" in 5
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 5
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 5
	
svy: tab voted_simple if  ELECID==19
svy: tab voted_complx2  if  ELECID==19
	
***Provence europe***Provence europe***Provence europe 2014
svy: logit voted  i.FSRIs if ELECID==16
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 6
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 6
replace p_value="<.001" in 6
replace Case_ID=6 in 6
replace Region="Provence" in 6
replace Level="Europe" in 6
replace Year="2014" in 6
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 6
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 6

***IDF europe***IDF europe***IDF europe 2014
svy: logit voted  i.FSRIs if ELECID==17
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 7
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 7
replace p_value="<.001" in 7
replace Case_ID=7 in 7
replace Region="Îles-de-France" in 7
replace Level="Europe" in 7
replace Year="2014" in 7
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 7
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 7

***Catalonia europe***Catalonia europe***Catalonia europe 2014
svy: logit voted  i.FSRIs if ELECID==20
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 8
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 8
replace p_value=".002" in 8
replace Case_ID=8 in 8
replace Region="Catalonia" in 8
replace Level="Europe" in 8
replace Year="2014" in 8
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 8
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 8

***Madrid europe***Madrid europe***Madrid europe 2014
svy: logit voted  i.FSRIs if ELECID==21
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 9
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 9
replace p_value=".001" in 9
replace Case_ID=9 in 9
replace Region="Madrid" in 9
replace Level="Europe" in 9
replace Year="2014" in 9
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 9
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 9

***Lower Saxony europe***Lower Saxony europe***Lower Saxony europe 2014
svy: logit voted  i.FSRIs if ELECID==18
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 10
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 10
replace p_value=".211" in 10
replace Case_ID=10 in 10
replace Region="Lower Saxony" in 10
replace Level="Europe" in 10
replace Year="2014" in 10
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 10
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 10

***Marseille municipal***Marseille municipal***Marseille municipal 2014
svy: logit voted  i.FSRIs if ELECID==23
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 11
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 11
replace Case_ID=11 in 11
replace p_value=".232" in 11
replace Region="Marseille" in 11
replace Level="Municipal" in 11
replace Year="2014" in 11
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 11
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 11

***Paris municipal***Paris municipal***Paris municipal 2014
svy: logit voted  i.FSRIs if ELECID==22
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 12
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 12
replace p_value=".020" in 12
replace Case_ID=12 in 12
replace Region="Paris" in 12
replace Level="Municipal" in 12
replace Year="2014" in 12
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 12
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 12

*** Lower Saxony regional*** Lower Saxony regional*** 2013
svy: logit voted  i.FSRIs if ELECID==11
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 13
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 13
replace p_value=".152" in 13
replace Case_ID=13 in 13
replace Region="Lower Saxony" in 13
replace Level="Regional" in 13
replace Year="2013" in 13
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 13
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 13
			
*** Catalonia regional*** Catalonia regional*** Catalonia regional 2012
svy: logit voted  i.FSRIs if ELECID==8
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 14
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 14
replace p_value=".001" in 14
replace Case_ID=14 in 14
replace Region="Catalonia" in 14
replace Level="Regional" in 14
replace Year="2012" in 14
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 14
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 14

*** Quebec regional*** Quebec regional*** Quebec regional 2012
svy: logit voted  i.FSRIs if ELECID==15
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 15
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 15
replace p_value="<.001" in 15
replace Case_ID=15 in 15
replace Region="Quebec" in 15
replace Level="Regional" in 15
replace Year="2012" in 15
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 15
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 15

*** Provence national*** Provence national*** Provence national 2012
svy: logit voted  i.FSRIs if ELECID==6
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 16
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 16
replace p_value=".820" in 16
replace Case_ID=16 in 16
replace Region="Provence" in 16
replace Level="National" in 16
replace Year="2012" in 16
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 16
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 16

***IDF national***IDF national***IDF national 2012
svy: logit voted  i.FSRIs if ELECID==5
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 17
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 17
replace p_value=".873" in 17
replace Case_ID=17 in 17
replace Region="Île-de-France" in 17
replace Level="National" in 17
replace Year="2012" in 17
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 17
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 17

*** Ontario regional*** Ontario regional*** Ontario regional 2011
svy: logit voted  i.FSRIs if ELECID==14
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 18
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 18
replace p_value=".950" in 18
replace Case_ID=18 in 18
replace Region="Ontario" in 18
replace Level="Regional" in 18
replace Year="2011" in 18
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 18
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 18

*** Catalonia national*** Catalonia national*** Catalonia national 2011
svy: logit voted  i.FSRIs if ELECID==7
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 19
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 19
replace p_value=".284" in 19
replace Case_ID=19 in 19
replace Region="Catalonia" in 19
replace Level="National" in 19
replace Year="2011" in 19
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 19
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 19

*** Madrid national*** Madrid national*** Madrid national 2011
svy: logit voted  i.FSRIs if ELECID==9
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 20
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 20
replace p_value=".003" in 20
replace Case_ID=20 in 20
replace Region="Madrid" in 20
replace Level="National" in 20
replace Year="2011" in 20
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 20
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 20

***lucerne national***lucerne national***lucerne national 2011
svy: logit voted  i.FSRIs if ELECID==1
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 21
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 21
replace p_value=".003" in 21
replace Case_ID=21 in 21
replace Region="Lucerne" in 21
replace Level="National" in 21
replace Year="2011" in 21
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 21
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 21


***Lucerne regional***Lucerne regional***Lucerne regional 2011
svy: logit voted  i.FSRIs if ELECID==2
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 22
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 22
replace p_value="<.001" in 22
replace Case_ID=22 in 22
replace Region="Lucerne" in 22
replace Level="Regional" in 22
replace Year="2011" in 22
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 22
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 22

***Zurich national***Zurich national***Zurich national  2011
svy: logit voted  i.FSRIs if ELECID==3
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 23
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 23
replace p_value=".127" in 23
replace Case_ID=23 in 23
replace Region="Zurich" in 23
replace Level="National" in 23
replace Year="2011" in 23
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 23
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 23

***Zurich regional***Zurich regrional***Zurich regrional 2011
svy: logit voted  i.FSRIs if ELECID==4
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 24
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 24
replace p_value=".005" in 24
replace Case_ID=24 in 24
replace Region="Zurich" in 24
replace Level="Regional" in 24
replace Year="2011" in 24
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 24
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 24

**** Average effect size
ttest effectsize == 0
replace obs= 24 in 25
replace effectsize=-7.285532 in 25
replace p_value="<.001" in 25
replace Case_ID=25 in 25
replace Region="" in 25
replace Level="" in 25
replace Year="" in 25
replace low_ci95= -9.2456 in 25
replace high_ci95= -5.325465 in 25


***all experiments pooled***all experiments pooled***all experiments pooled
svy: logit voted  i.FSRIs
margins FSRIs, post
margins, coeflegend
replace obs= e(N) in 26
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(95)
lincom _b[1.FSRIs] -  _b[0bn.FSRIs], level(99)
replace effectsize=100*(r(estimate)) in 26
replace p_value="<.001" in 26
replace Case_ID=26 in 26
replace Region="" in 26
replace Level="" in 26
replace Year="Average Effect" in 26
replace low_ci95= 100*((r(estimate))-(1.96*r(se))) in 26
replace high_ci95= 100*((r(estimate))+(1.96*r(se))) in 26

svy: tab voted_simple
svy: tab voted_complx2


*.######..######...####...##..##..#####...######............##...
*.##........##....##......##..##..##..##..##...............###...
*.####......##....##.###..##..##..#####...####..............##...
*.##........##....##..##..##..##..##..##..##................##...
*.##......######...####....####...##..##..######..........######.

replace Case_ID=-(Case_ID)
gen Case_ID_2=2*(Case_ID)
gsort -Case_ID_2


****Figure A
 twoway(dot effectsize Case_ID_2,  xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54)  lc(white))  ///
ylabel(0 "{bf:Case ID}" -2	"1" -4	"2" -6	"3" -8	"4" -10	"5" ///
-12	"6" -14	"7" -16	"8" -18	"9" -20	"10"   ///
-22	"11" -24	"12" -26	"13" -28	"14" -30	"15" -32	"16"   ///
-34	"17" -36	"18" -38	"19" -40	"20"  -42	"21" -44	"22"   ///
-46	"23" -48	"24" -50 "Average" -52 "Combined", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
 || rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
 aspectratio(200)  legend(off) graphregion(margin(zero))  plotregion(margin(zero))      name(figurea,replace)

****Figure B
 twoway(dot effectsize Case_ID_2, xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54) alt lc(white))  ///
ylabel(0 "{bf:Year}" -2	"2015" -4	"2015" -6	"2015" -8	"2015" -10	"2014" -12	"2014" -14	"2014"  ///
-16	"2014" -18	"2014" -20	"2014" -22	"2014" -24	"2014" -26	"2013" -28	"2012"  ///
-30	"2012" -32	"2012" -34	"2012" -36	"2011" -38	"2011" -40	"2011" -42	"2011"  ///
-44	"2011" -46	"2011" -48	"2011", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
 || rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
 aspectratio(200)  legend(off)  graphregion(margin(zero))  plotregion(margin(zero))     name(figureb,replace)
 
****Figure C
 twoway(dot effectsize Case_ID_2, xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54) alt lc(white))  ///
ylabel(0 "{bf:Region}" -2	"Madrid" -4	"Ontario" -6	"British Columbia" -8	"Quebec" -10	"Bavaria" ///
-12	"Provence" -14	"Îles-de-France" -16	"Catalonia" -18	"Madrid" -20	"Lower Saxony"   ///
-22	"Marseille" -24	"Paris" -26	"Lower Saxony" -28	"Catalonia" -30	"Quebec" -32	"Provence"   ///
-34	"Île-de-France" -36	"Ontario" -38	"Catalonia" -40	"Madrid"  -42	"Lucerne" -44	"Lucerne"   ///
-46	"Zurich" -48	"Zurich", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
 || rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
 aspectratio(200)  legend(off)  graphregion(margin(zero))  plotregion(margin(zero))     name(figurec,replace)
 
****Figure D
twoway(dot effectsize Case_ID_2, xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54) alt lc(white))  ///
ylabel(0 "{bf:Level}" -2	"Regional" -4	"National" -6	"National" -8	"National" -10	"Europe" -12	"Europe"  ///
-14	"Europe" -16	"Europe" -18	"Europe" -20	"Europe" -22	"Municipal"  ///
-24	"Municipal" -26	"Regional" -28	"Regional" -30	"Regional" -32	"National" -34	"National"  ///
-36	"Regional" -38	"National" -40	"National" -42	"National" -44	"Regional"  ///
-46	"National" -48	"Regional", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
 || rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
 aspectratio(200)  legend(off)  graphregion(margin(zero))  plotregion(margin(zero))     name(figured,replace)

 ****Figure E
 twoway(dot effectsize Case_ID_2,xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54)  lc(white))  ///
ylabel(0 "{bf:Observations}" -2	"770" -4	"1431" -6	"1330" -8	"1307" ///
-10	"2399" -12	"806" -14	"834" -16	"811" ///
-18	"805" -20	"791" -22	"517" -24	"856" ///
-26	"818" -28	"800" -30	"724" -32	"719" ///
-34	"748" -36	"884" -38	"818" -40	"823" ///
-42	"844" -44	"904" -46	"840" -48	"843" ///
-50	"24" -52	"22422", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
 || rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
 aspectratio(200)  legend(off)  graphregion(margin(zero))  plotregion(margin(zero))     name(figuree,replace)
 
****Figure F
twoway(dot effectsize Case_ID_2,xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54)  lc(white))  ///
ylabel(0 "{bf:Effect Size}" -2	"-9.57" -4	"-7.57" -6	"-.81" -8	"-7.84" -10	"-4.46" ///
-12	"-14.24" -14	"-17.98" -16	"-12.23" -18	"-13.68" ///
-20	"-5.93" -22	"-5.99" -24	"-7.52" -26	"-5.68" -28	"-6.75" ///
-30	"-10.00" -32	"-.99" -34	"-.70" -36	"-.19" -38	"-2.41" ///
-40	"-5.99" -42	"-9.09" -44	"-12.53" -46	"-4.48" -48	"-8.24" ///
-50	"-7.27" -52	"-6.82", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
|| rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
aspectratio(200)  legend(off)  graphregion(margin(zero))  plotregion(margin(zero))     name(figuref,replace)

****Figure G
twoway(dot effectsize Case_ID_2, xsize(1) ysize(6) dcolor(white) mcolor(white) horiz base(0) yscale(range(2 -54)  lc(white))  ///
ylabel(0 "{bf:P-Value}" -2	"<.001" -4	"<.001" -6	"0.739" -8	"<.001" -10	".014" -12	"<.001"  ///
-14	"<.001" -16	".002" -18	".001" -20	".211" -22	".232" -24	".019" -26	".152" -28	".001"  ///
-30	"<.001" -32	".820" -34	".873" -36	".950" -38	".284" -40	".003" -42	".003" -44	"<.001"  ///
-46	".126" -48	".005" -50	"<.001" -52	"<.001", tlstyle(none) labsize(medium) nogrid) ///
xscale(off fill) xlabel(-20(10)0, nogrid) ytitle("") xtitle(""))  ///
|| rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(white)  ///
aspectratio(200)  legend(off)  graphregion(margin(zero))  plotregion(margin(zero))     name(figureg,replace)
 
 
 replace effectsize=round(effectsize, 0.01)

****Figure H
twoway(dot effectsize Case_ID_2, xsize(2) mcolor(black) ysize(6) xline(0) horiz base(0) yscale(range(2 -54) alt lc(white))  ///
ylabel(none) ///
xscale(range(-27 6) lc(black) ex ) xlabel(-20(10)0, tlstyle(none) grid glp(solid) glc(gs15) labc(black)) ytitle("") xtitle(""))  ///
|| rcap  low_ci95 high_ci95 Case_ID_2, horizontal lw(medthick) lc(black)  ///
aspectratio(6)  legend(off) graphregion(margin(zero))  plotregion(margin(zero))  name(figureh,replace)

graph combine figurea figureb figurec figured figuree figuref figureg figureh, iscale(*.75) rows(1) name("firstset", replace)




///    ____              ___                                                                                 ___                
///   6MMMMb             `MM 68b                                                                             `MM 68b            
///  8P    Y8             MM Y89                                                                              MM Y89            
/// 6M      Mb ___  __    MM ___ ___  __     ____            ___   __ ____  __ ____     ____  ___  __     ____MM ___ ____   ___ 
/// MM      MM `MM 6MMb   MM `MM `MM 6MMb   6MMMMb         6MMMMb  `M6MMMMb `M6MMMMb   6MMMMb `MM 6MMb   6MMMMMM `MM `MM(   )P' 
/// MM      MM  MMM9 `Mb  MM  MM  MMM9 `Mb 6M'  `Mb       8M'  `Mb  MM'  `Mb MM'  `Mb 6M'  `Mb MMM9 `Mb 6M'  `MM  MM  `MM` ,P   
/// MM      MM  MM'   MM  MM  MM  MM'   MM MM    MM           ,oMM  MM    MM MM    MM MM    MM MM'   MM MM    MM  MM   `MM,P    
/// MM      MM  MM    MM  MM  MM  MM    MM MMMMMMMM       ,6MM9'MM  MM    MM MM    MM MMMMMMMM MM    MM MM    MM  MM    `MM.    
/// YM      M9  MM    MM  MM  MM  MM    MM MM             MM'   MM  MM    MM MM    MM MM       MM    MM MM    MM  MM    d`MM.   
///  8b    d8   MM    MM  MM  MM  MM    MM YM    d9       MM.  ,MM  MM.  ,M9 MM.  ,M9 YM    d9 MM    MM YM.  ,MM  MM   d' `MM.  
///   YMMMM9   _MM_  _MM__MM__MM__MM_  _MM_ YMMMM9        `YMMM9'Yb.MMYMMM9  MMYMMM9   YMMMM9 _MM_  _MM_ YMMMMMM__MM__d_  _)MM_ 
///                                                                 MM       MM                                                 
///                                                                 MM       MM                                                 
///                                                                _MM_     _MM_                                                




*.######...####...#####...##......######...........####....####..
*...##....##..##..##..##..##......##..............##..##..##..##.
*...##....######..#####...##......####............######...####..
*...##....##..##..##..##..##......##..............##..##..##..##.
*...##....##..##..#####...######..######..........##..##...####..

tab FSRIs if ELECID==24  // MADRID Number of respondents in each experimental groups
svy: tab voted_simple if ELECID==24  // MADRID weighted response distribution in the control group
svy: tab voted_complx2 if ELECID==24 // MADRID weighted response distribution in the treatment group

tab FSRIs if ELECID==25  // ONTARIO Number of respondents in each experimental groups
svy: tab voted_simple if ELECID==25  // ONTARIO weighted response distribution in the control group
svy: tab voted_complx2 if ELECID==25 // ONTARIO weighted response distribution in the treatment group

tab FSRIs if ELECID==26  // BRITISH COLUMBIA Number of respondents in each experimental groups
svy: tab voted_simple if ELECID==26  // BRITISH COLUMBIA weighted response distribution in the control group
svy: tab voted_complx2 if ELECID==26 // BRITISH COLUMBIA weighted response distribution in the treatment group

tab FSRIs if ELECID==27  // QUEBEC Number of respondents in each experimental groups
svy: tab voted_simple if ELECID==27  // QUEBEC weighted response distribution in the control group
svy: tab voted_complx2 if ELECID==27 // QUEBEC weighted response distribution in the treatment group

tab FSRIs if ELECID==19  // BAVARIA Number of respondents in each experimental groups
svy: tab voted_simple if ELECID==19  // BAVARIA weighted response distribution in the control group
svy: tab voted_complx2 if ELECID==19 // BAVARIA weighted response distribution in the treatment group


svy: tab voted FSRIs if ELECID==19
