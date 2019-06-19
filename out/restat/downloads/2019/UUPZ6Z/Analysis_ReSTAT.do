set matsize 11000
set maxvar 30000
global directory Path_To_Directory
cd $directory


**-> Globals
************************************
global cov912  totfelb totmisb  wrstrefb_* refindex                          c.chscr#i.labelfac91 c.rskscr#i.labelfac91  i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov913  totfelb totmisb  wrstrefb_* refindex                                                                       i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov914  totfelb totmisb  wrstrefb_* refindex                         											  i.labelfac912 			female black hisp agerel i.quarter  recpoolf
global cov612  totfelb totmisb  wrstrefb_* refindex  c.rec_out#i.labelfac61  c.chscr#i.labelfac61 c.rskscr#i.labelfac61   i.labelfac613  rskscr chscr female black hisp agerel i.quarter recpoolf
global out tarrest tarrfel tconvict tconvfel anypris
global out1 tarrest1 tarrfel1 tconvict1 tconvfel1 anypris
global supin if quarter>7 & quarter<18
global noncog skills_p skills_r agg_p agg_r att_p att_r noncog_r noncog_p
global shortlist age female black chscr rskscr los prevcom totfelb totmisb
global sample if quarter>7 & quarter<18 & freqlabelFE>50 & labelfac91!=102 & labelfac91!=5 & labelfac91!=14 & labelfac91!=24 & recpoolf==1
global noncog2 agg attitude implsv noncog_r socskill future noncog_p
global covnorsk totfelb totmisb  wrstrefb_1 wrstrefb_2 wrstrefb_3 wrstrefb_4 refindex   chscr female black hisp agerel recpoolf
global covnoch totfelb totmisb  wrstrefb_1 wrstrefb_2 wrstrefb_3 wrstrefb_4 refindex   rskscr female black hisp agerel recpoolf


use Master_ReSTAT.dta


	
* Summary stats for full sample
**************************************************

*** summary statistics - basics
eststo clear
estpost tabstat age female black hisp violfel3 propfel3 prevcom rskscr chscr $out1 $sample ,listwise s(mean) columns(statistics)
	
	
* summary statistics - criminal history
eststo clear
estpost tabstat fr14und fr12und prevcom totfelb totmisb assault burglary robbery drug_off auto_theft larceny murderp $sample,   listwise s(mean) columns(statistics)

	
* summary statistics - risk
eststo clear
estpost tabstat dropout alc drug gangz pardrug parpris pris DCF2 run_kickout2  abused abuse_sex  $sample,   listwise s(mean) columns(statistics)
	
* summary statistics - noncogs
eststo clear
estpost tabstat optN impN empathN resp_propN tolfrustN hostintN verb_aggN phys_agg2N goal_setN sit_percN soc_skillN diff_emotN $sample,   listwise s(mean) columns(statistics)

	
* Summary stats for sample with post-release noncogs
**************************************************

*** summary statistics - basics
eststo clear
estpost tabstat age female black hisp violfel3 propfel3 prevcom rskscr chscr $out1 $sample & agg!=. & agg_final2!=. ,listwise s(mean) columns(statistics)
	
	
* summary statistics  - criminal history
eststo clear
estpost tabstat fr14und fr12und prevcom totfelb totmisb assault burglary robbery drug_off auto_theft larceny murderp $sample & agg!=. & agg_final2!=.,   listwise s(mean) columns(statistics)


	
* summary statistics - risk
eststo clear
estpost tabstat dropout alc drug gangz pardrug parpris pris DCF2 run_kickout2  abused abuse_sex $sample & agg!=. & agg_final2!=.,   listwise s(mean) columns(statistics)

	
* summary statistics - noncogs
eststo clear
estpost tabstat optN impN empathN resp_propN tolfrustN hostintN verb_aggN phys_agg2N goal_setN sit_percN soc_skillN diff_emotN $sample & agg!=. & agg_final2!=.,   listwise s(mean) columns(statistics)


* Summary stats for sample with post-release noncogs, 8 months post
**************************************************

*** summary statistics
eststo clear
estpost tabstat age female black hisp violfel3 propfel3 prevcom rskscr chscr $out1 $sample & agg!=. & agg_82!=.& pact8gap>90 ,listwise s(mean) columns(statistics)

	
	
* summary statistics by gender - criminal history
eststo clear
estpost tabstat fr14und fr12und prevcom totfelb totmisb assault burglary robbery drug_off auto_theft larceny murderp $sample & agg!=. & agg_82!=.& pact8gap>90,   listwise s(mean) columns(statistics)

	
	
* summary statistics - risk
eststo clear
estpost tabstat dropout alc drug gangz pardrug parpris pris DCF2 run_kickout2  abused abuse_sex $sample & agg!=. & agg_82!=.& pact8gap>90,   listwise s(mean) columns(statistics)

	
	
* summary statistics - noncogs
eststo clear
estpost tabstat optN impN empathN resp_propN tolfrustN hostintN verb_aggN phys_agg2N goal_setN sit_percN soc_skillN diff_emotN $sample & agg!=. & agg_82!=.& pact8gap>90,   listwise s(mean) columns(statistics)



**************-> how various traits predict crime
**************************************************


* do the risk score, CH score and gang affiliation  predict recidivism? - altogether
foreach x in $out1{
qui reg `x' rskscr2 chscr2 gangz   female i.race agerel i.quarter  recpoolf  $sample, cl(labelfac91)
esttab, keep(rskscr2 chscr2 gangz)
est sto `x'
}


* do the risk score, CH score and gang affiliation  predict recidivism? - one by one
foreach zz in rskscr2 chscr2 gangz{
foreach y in $out1{
qui reg `y' `zz'  i.labelfac912  female i.race agerel i.quarter  recpoolf  $sample, cl(labelfac91)
esttab, keep(`zz')
est sto `y'
}
}


* do the risk score, CH score and gang affiliation  predict recidivism? - altogher, controlling for CH stuff
foreach x in $out1{
qui reg `x' chscr2 agg_final2 attitude_final2 implsv_final2  socskill_final2 future_final2  totfelb totmisb  i.wrstrefb refindex  female i.race agerel i.quarter  recpoolf  $sample  & agg!=., cl(labelfac91)
esttab, keep(  agg_final2 attitude_final2 implsv_final2 socskill_final2 future_final2 )
est sto `x'
}



* do the risk score, CH score and gang affiliation  predict recidivism? - one-by-one, controlling for CH stuff
foreach x in agg attitude implsv socskill future noncog_r {
foreach y in $out1{
qui reg `y'  `x'_final2   totfelb totmisb  i.wrstrefb refindex female i.race agerel i.quarter  recpoolf  $sample & agg!=., cl(labelfac91)
esttab, keep(`x'_final2 )
est sto `y'
}
}


**************-> main regressions
**********************************************


***** main results, altogether		
foreach x in $out1 {
qui reg `x' peerRSK2 peerCH2 ph_gangz2 $cov912 $sample, cl(labelfac91)
est sto `x'
esttab, keep(peerRSK2 peerCH2  ph_gangz2)
}


		

***** main results, one by one	
foreach zz in peerRSK2 peerCH2 ph_gangz2 {
foreach x in $out1 {
qui reg `x' `zz' $cov912 $sample, cl(labelfac91)
est sto `x'
esttab, keep(`zz')
}
}




***** outcome variable is noncogs immediately after release
foreach x in $noncog2 {
qui reg `x'_final2 i.`x'r i.county i.county#c.rec_out peerRSK2 peerCH2 ph_gangz2 pact1gap $cov912 $sample & pact1gap<90 , cl(labelfac91)
esttab, keep(peerRSK2 peerCH2 ph_gangz2)
est sto `x'
}



***** outcome variable is noncogs 8 months after release
foreach x in $noncog2{
qui  reg `x'_82 i.`x'r i.county i.county#c.rec_out  peerRSK2 peerRSK202  peerCH2 peerCH202 ph_gangz2 p_gangz302 pact8gap $cov912 $sample & pact8gap>90 , cl(labelfac91)
esttab, keep(peerRSK2 peerRSK202  peerCH2 peerCH202 ph_gangz2 p_gangz302)
est sto `x'
}

		
** influence of neighboring peers
foreach x in $out1{
qui reg `x' peerRSK2 peerRSK202  peerCH2 peerCH202 ph_gangz2 p_gangz302 $cov912 $sample, cl(labelfac91)
est sto `x'
esttab, keep(peerRSK2 peerRSK202  peerCH2 peerCH202 ph_gangz2 p_gangz302)
}



******* Adding covariates one at a time
qui reg tarrest1 peerRSK2 i.quarter i.labelfac912   recpoolf $sample & rskscr!=., cl(labelfac91)
est sto a
esttab, keep(peerRSK2)
qui reg tarrest1 peerRSK2 $cov912 $sample & rskscr!=., cl(labelfac91)
est sto b
esttab, keep(peerRSK2)
qui reg tarrest1 peerRSK2 page pblack phisp $cov912 $sample & rskscr!=., cl(labelfac91)
est sto c
esttab, keep(peerRSK2)
qui reg tarrest1 peerRSK2 page pblack phisp ph_gangz2 $cov912 $sample & rskscr!=., cl(labelfac91)
est sto d
esttab, keep(peerRSK2 ph_gangz2)
qui reg tarrest1 peerRSK2 page pblack phisp ph_gangz2 peerCH2 probbery pdrug_off pburglary pauto_theft plarceny $cov912 $sample & rskscr!=., cl(labelfac91)
est sto e
esttab, keep(peerRSK2)
qui reg tarrest1 peerRSK2 page pblack phisp ph_gangz2 peerCH2 probbery pdrug_off pburglary pauto_theft plarceny i.labelfac91#c.rec_out $cov912 $sample & rskscr!=., cl(labelfac91)
est sto f
esttab, keep(peerRSK2)


**** impact of peer noncogs one at a time
******************************
foreach zz in agg attitude implsv socskill future noncog_r {
foreach x in $out1 {
qui reg `x' p`zz'2   peerCH2 ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny $cov912 $sample, cl(labelfac91)
est sto `x'
esttab, keep(p`zz'2)
}
}


**** main regressions, controlling for peer criminal history in detailed manner
******************************

*peer RSK, gangz and CH, all 
foreach x in $out1 {
qui reg `x' peerRSK2 peerCH2 ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny  $cov912 $sample, cl(labelfac91)
est sto `x'
esttab, keep(peerRSK2 peerCH2  ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny)
}

		
** decomposing the life-risk score		
*****************************************
foreach x in $out1 {
qui reg `x' ph_drugsalc2 peerCH2 ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny $cov912 $sample , cl(labelfac91)
esttab, keep(ph_drugsalc2 )
est sto `x'
}

foreach x in $out1 {
qui reg `x' ph_schoolprob2 peerCH2 ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny $cov912 $sample , cl(labelfac91)
esttab, keep(ph_schoolprob2)
est sto `x'
}

foreach x in $out1 {
qui reg `x' ph_famprob2 peerCH2 ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny $cov912 $sample , cl(labelfac91)
esttab, keep(ph_famprob2)
est sto `x'
}

foreach x in $out1 {
qui reg `x' ph_trauma2 $cov912 $sample , cl(labelfac91)
esttab, keep(ph_trauma2 )
est sto `x'
}

foreach x in $out1 {
qui reg `x' ph_peers2 peerCH2 ph_gangz2 probbery pdrug_off pburglary pauto_theft pgralarceny $cov912 $sample , cl(labelfac91)
esttab, keep(ph_peers2)
est sto `x'
}




	
		


