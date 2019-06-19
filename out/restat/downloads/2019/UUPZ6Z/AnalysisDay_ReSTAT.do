*clear
clear mata 
clear matrix
set matsize 11000
set maxvar 30000 

global directory Path_To_Directory
cd $directory

**-> Globals
************************************
global cov912  totfelb totmisb  wrstrefb_* refindex                          c.chscr#i.labelfac91 c.rskscr#i.labelfac91  i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov913  totfelb totmisb  wrstrefb_* refindex                                                                       i.labelfac912 rskscr chscr female black hisp agerel i.quarter  recpoolf
global cov612  totfelb totmisb  wrstrefb_* refindex  c.rec_out#i.labelfac61  c.chscr#i.labelfac61 c.rskscr#i.labelfac61   i.labelfac613  rskscr chscr female black hisp agerel i.quarter recpoolf
global out tarrest tarrfel tconvict tconvfel anypris
global out1 tarrest1 tarrfel1 tconvict1 tconvfel1 anypris
global supin if quarter>7 & quarter<18
global noncog skills_p skills_r agg_p agg_r att_p att_r noncog_r noncog_p
global shortlist age female black chscr rskscr los prevcom totfelb totmisb
global sample if quarter>7 & quarter<18 & freqlabelFE>50 & labelfac91!=102 & labelfac91!=5 & labelfac91!=14 & labelfac91!=24 & recpoolf==1
global noncog2 agg attitude implsv noncog_r socskill future 
global covnorsk totfelb totmisb  wrstrefb_1 wrstrefb_2 wrstrefb_3 wrstrefb_4 refindex   chscr female black hisp agerel recpoolf
global covnoch totfelb totmisb  wrstrefb_1 wrstrefb_2 wrstrefb_3 wrstrefb_4 refindex   rskscr female black hisp agerel recpoolf


 use Master_ReSTAT.dta

 
 ** Summary statistics
 **************************
eststo clear
estpost tabstat age female black hisp violfel3 propfel3 prevcom rskscr chscr $out1 $supin & freqlabel>50 ,listwise s(mean) columns(statistics)
	
* summary statistics  - criminal history
eststo clear
estpost tabstat fr14und fr12und prevcom totfelb totmisb assault burglary robbery drug_off auto_theft larceny murderp $supin & freqlabel>50,   listwise s(mean) columns(statistics)
 
* summary statistics - risk
eststo clear
estpost tabstat dropout alc drug gangz pardrug parpris pris DCF2 run_kickout2  abused abuse_sex $supin & freqlabel>50,   listwise s(mean) columns(statistics)
	
	
* summary statistics - noncogs
eststo clear
estpost tabstat optN impN empathN resp_propN tolfrustN hostintN verb_aggN phys_agg2N goal_setN sit_percN soc_skillN diff_emotN $supin & freqlabel>50& noncog_r!=. & noncog_r_82!=.,   listwise s(mean) columns(statistics)

 
 
* Analysis 
**************************

* how do peers with a high life risk score, high CH score, gang affiliation, affect recidivism? one by one
foreach zz in peerRSK2 peerCH2 ph_gangz2 {
foreach x in $out1{
qui reg `x' `zz' recpoolf $cov612 $supin & freqlabel>50, cl(labelfac61)
esttab, keep(`zz') p
est sto `x'cc
}
}
		
		
* how do peers with a high life risk score, high CH score, gang affiliation, affect recidivism? altogether
foreach x in $out1{
qui reg `x' peerRSK2 peerCH2 ph_gangz2 recpoolf $cov612 $supin & freqlabel>50, cl(labelfac61)
esttab, keep(peerRSK2 peerCH2 ph_gangz2) p
est sto `x'cc
}


		
		
* impact on non-cognitive outcomes, one by one
foreach zz in peerRSK2 peerCH2 ph_gangz2 {
foreach x in agg attitude implsv socskill future noncog_r {
qui reg `x'_82 `zz' recpoolf $noncog2 $cov612 $supin & freqlabel>50, cl(labelfac61)
esttab, keep(`zz')
est sto `x'
}
}

* impact on non-cognitive outcomes, altogether
foreach x in agg attitude implsv socskill future noncog_r  {
qui reg `x'_82 peerRSK2 peerCH2 ph_gangz2 recpoolf $noncog2 $cov612 $supin & freqlabel>50, cl(labelfac61)
esttab, keep( peerCH2 ph_gangz2 peerRSK2 )
est sto `x'
}



** effects on gang outcomes
****************************

** effects on gang outcomes, altogether, no facility time trends
qui reg gangz_8 peerCH2  peerRSK2 ph_gangz2 gangz  totfelb totmisb  wrstrefb_* refindex    ///
c.chscr#i.labelfac61 c.rskscr#i.labelfac61   i.labelfac613  rskscr chscr female black hisp agerel i.quarter recpoolf $supin  & freqlabel>50 & lastfirst!=1 , cl(labelfac61)
esttab, keep( peerCH2 ph_gangz2 peerRSK2 )


** effects on gang outcomes, one by one, no facility time trends
foreach x in peerCH2  peerRSK2 ph_gangz2 {
qui reg gangz_8 `x' gangz  totfelb totmisb  wrstrefb_* refindex    ///
c.chscr#i.labelfac61 c.rskscr#i.labelfac61   i.labelfac613  rskscr chscr female black hisp agerel i.quarter recpoolf $supin  & freqlabel>50 & lastfirst!=1 , cl(labelfac61)
esttab, keep( `x') p
}


** effects on gang outcomes, altogether, with facility time trends
foreach x in gangz_8{
qui reg `x' peerRSK2 peerCH2 ph_gangz2 gangz recpoolf $cov612 $supin & freqlabel>50 & lastfirst!=1, cl(labelfac61)
esttab, keep(peerRSK2 peerCH2 ph_gangz2) 
est sto `x'cc
}

** effects on gang outcomes, one by one, with facility time trends
foreach x in peerRSK2 peerCH2 ph_gangz2{
qui reg gangz_8 `x'  gangz recpoolf $cov612 $supin & freqlabel>50 & lastfirst!=1, cl(labelfac61)
esttab, keep(`x') 
est sto `x'cc
}


		



*********** criminal skill transfer

* full sample, heterogeneous effects
foreach x in agg_ass sex_off robbery drug_off burglary auto_theft gralarceny  {
qui reg r`x' p`x'Y p`x'N `x' robbery drug_off burglary auto_theft gralarceny `x'#i.labelfac61 recpoolf totfelb totmisb  wrstrefb_* refindex  c.rec_out#i.labelfac61  i.labelfac613  female black hisp agerel i.quarter recpoolf ///
	  $supin & freqlabel>50, cl(labelfac61)
esttab, keep(p`x'Y p`x'N )
est sto `x'
}

