/*									Autocracies and the International Sources of Cooperation
												   Soumyajit Mazumder
										          (Harvard University)
						
											   	     November 2016
										             Main Results
*/
cd "/Users/ShomMazumder/Google Drive/Research/PTA Centrality and Conflict/Datasets/" /*change this to your working directory*/
log using mainresults, text
use "IOConflictWorking.dta", clear
*******************************************************************************************************************
/*Descriptive Stats*/
//sum mzinit logEconomic_1 PTASameGT0_lag PTAPropInt_lag PTAClusSame_lag PTACent1_lag PTAClusSize1_lag machinejlw_1 juntajlw_1 bossjlw_1 strongmanjlw_1 allotherauts_1 newregime_1 democracy_2 cap_1 cap_2 initshare dependlow majmaj minmaj majmin contigdum logdist s_wt_glo s_lead_1 s_lead_2 pcyrsmzinit pcyrsmzinits* democracy_1 dirdyadid, d
*******************************************************************************************************************

label variable jointDemocracy "Joint Democracy"
label variable comlang_off "Common Language"
label variable logdist "Log(Distance b/w capitals)"
label variable oil_1_lag "Challenger Oil Exporter"
label variable PTAClusSize1_lag "Challenger PTA Cluster Size"
label variable PTASameGT0_lag "Overlapping PTA Membership"
label variable sanctOn_lag "Challenger Sanctioned Target"

sort dirdyadid year
local controls "jointDemocracy comlang_off logdist rgdp1_lag rgdp2_lag oil_1_lag cap_1 cap_2 initshare dependlow majmaj minmaj majmin"
local splines "pcyrsmzinit pcyrsmzinits*"
local explanatory "Economic_1_lag PTACent1_lag"

*********************************************************
* Main Results: PTA Centrality and Democracy Interaction*
*********************************************************
eststo clear

/*Baseline Model*/
quietly eststo base: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Kantian Model*/
quietly eststo kant: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*SNA Model*/
quietly eststo sna: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag requivlag5 PTASameGT0_lag PTAClusSame_lag PTAClusSize1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Full Specification*/
quietly eststo full: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

esttab base kant sna full using "main.tex", replace tex se label title(Directed-Dyad Analysis of MID Initiation, 1965-1999) ///
mtitles("Model 1: Baseline" "Model 2: Kantian Tripod" "Model 3: Network" "Model 4: Full Specification") ///
drop(pcyrsmzinit pcyrsmzinits*) ///
addnotes("Models estimated using logit with heteroskedastic robust standard errors and errors clustered by directed dyad.")

************************************************
* Substantive Effects                          *
************************************************
set seed 4563
quietly estsimp logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)
/*Simulating the effect of a change from 1 std. dev below the mean level of PTA centrality to 1 std. above the mean
conditional on the challenger's regime type and holding all other covariates at their median value*/

setx (PTACent1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 s_wt_glo rgdp1_lag rgdp2_lag ///
initshare pcyrsmzinit pcyrsmzinits*) mean ///
contigdum 1 logdist 0 minmaj 1 majmaj 0 majmin 0 democracy_1_lag 0 PTACent1_lag 0

simqi, fd(prval(1)) changex(PTACent1_lag 0 0.14)

setx democracy_1_lag 1
simqi, fd(prval(1)) changex(PTACent1_lag 0 0.14 PTACentDemoc_1_lag 0 0.14)

************************************************
* Graph of Interaction Effect             	   *
************************************************

cd "/Users/ShomMazumder/Desktop/MURF/PTA Size and MIDs/Drafts/"

set more off
	* Marginal effect of PTACent using 2.1
quietly logit mzinit c.PTACent1_lag##c.pol1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)
tab democracy_1_lag if e(sample)
margins, dydx(PTACent1_lag) at(pol1_lag=(-10(1)10)) vsquish post
matrix at=e(at)
matrix at=at[1...,"pol1_lag"]
matrix list at
parmest, norestore
svmat at
twoway (line min95 at1, lpattern(dash)) (line estimate at1) (line max95 at1, lpattern(dash)), legend(order (1 "Upper 95% c.i." 3 "Lower 95% c.i.")) yline(0) ///
       xtitle(Polity Score) ytitle(Marginal Effect of PTA Degree Centrality) scheme(s1mono) yscale(range(-.001 0.004)) ylabel(#5)
save margcent_1.dta, replace
exit

************************************************
* Does transparency reduce MID initiation?     *
************************************************

*********************************************************
* Effect of Transparency      							*
*********************************************************
eststo clear

/*Baseline Model*/
quietly eststo HRV_base: logit mzinit HRV_1 democracy_1_lag democracy_2_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Kantian Model*/
quietly eststo HRV_kant: logit mzinit HRV_1 democracy_1_lag democracy_2_lag igos dependlow_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*SNA Model*/
quietly eststo HRV_sna: logit mzinit HRV_1 democracy_1_lag democracy_2_lag requivlag5 PTASameGT0_lag PTAClusSame_lag PTAClusSize1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Full Specification*/
quietly eststo HRV_full: logit mzinit HRV_1 democracy_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

esttab HRV_base HRV_kant HRV_sna HRV_full using "HRV.tex", replace tex se label title(Directed-Dyad Analysis of MID Initiation, 1965-1999\label{table:HRV}) ///
mtitles("Model 1: Baseline" "Model 2: Kantian Tripod" "Model 3: Network" "Model 4: Full Specification") ///
drop(pcyrsmzinit pcyrsmzinits*) ///
addnotes("Models estimated using logit with heteroskedastic robust standard errors and errors clustered by directed dyad.")


************************************************
* Bootstrapped Models             			   *
************************************************
*warning: bootstrapping these models takes a very long time to run
*eststo clear

*eststo bootBase: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, vce(boot, rep(500))

*eststo bootKant: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, vce(boot, rep(500))

*eststo bootSna: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag requivlag5 PTASameGT0_lag PTAClusSame_lag PTAClusSize1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, vce(boot, rep(500))

*eststo bootFull: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, vce(boot, rep(500))

*esttab bootBase bootKant bootSna bootFull using "boot.tex", replace tex se label title(Bootstrapped Directed-Dyad Analysis of MID Initiation, 1965-1999) ///
*mtitles("Model 1: Baseline" "Model 2: Kantian Tripod" "Model 3: Network" "Model 4: Full Specification") ///
*drop(pcyrsmzinit pcyrsmzinits*) ///
*addnotes("Models estimated using bootstrapped logit with heteroskedastic robust standard errors and errors clustered by directed dyad. The bootstrap resampling uses 500 replications. Results do not substantively vary with changes in the number of replications.")


************************************************
* PTA Centrality Robustness Checks             *
************************************************
cd "/Users/ShomMazumder/Desktop/MURF/PTA Size and MIDs/Drafts/"

eststo clear

/*Results hold using rare events logit estimator*/
quietly eststo rare: relogit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, cluster(dirdyadid)

/*Results hold when using Polity continuous scale instead of dichotomous indicator*/
quietly eststo cont: logit mzinit PTACent1_lag pol1_lag PTACentPolity democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Results hold when restricting the sample to politically relevant dyads*/
quietly eststo polrel: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits* if polrel==1, robust cluster(dirdyadid)

/*Results hold when restricting the challengers to only minor powers*/
quietly eststo minor: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare minmaj pcyrsmzinit pcyrsmzinits* if majmin!=1 & majmaj!=1, robust cluster(dirdyadid)

/*Results hold with region fixed effects as well*/
quietly eststo region: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin region1d* pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

esttab rare cont polrel minor region using "robust1.tex", replace tex se label title(Directed-Dyad Analysis of MID Initiation, 1965-1999) ///
mtitles("Model 1: Rare Events Logit" "Model 2: Polity Scores" "Model 3: Only Politically Relevant" "Model 4: Only Minor Power Challengers" "Model 5: Region Fixed Effects") ///
drop(pcyrsmzinit pcyrsmzinits*) ///
addnotes("Models estimated using logit with heteroskedastic robust standard errors and errors clustered by directed dyad.")


/*Results hold with dyad fixed effects and dropping time invariant variables
(had to drop UN voting similarity because model is not concave)*/
//xtset dirdyadid year
//quietly eststo cfx1: xtlogit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, fe
//quietly eststo cfx2: xtlogit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, fe

eststo clear

/*Results hold when accounting for political engagement in the international system*/
quietly eststo polIO: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos Political_1 dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Results hold when controlling for revolutionary leaders and petrostates*/
quietly eststo rev: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos revolutionaryleader_1 oil_1 dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Results hold when accounting for system-level variables such as cold-war period and system size*/
quietly eststo syst: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos postColdWar systsize dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Results hold when dropping allied dyads from the sample*/
quietly eststo allied: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag s_wt_glo contigdum logdist rgdp1_lag rgdp2_lag initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits* if allied!=1, robust cluster(dirdyadid)

/*Results hold when controlling for democratizing leaders*/
quietly eststo dem: logit mzinit l.democratizing_1 PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

esttab polIO rev syst allied dem using "robust2.tex", replace tex se label title(Directed-Dyad Analysis of MID Initiation, 1965-1999) ///
mtitles("Model 1: Political Engagement" "Model 2: Revolutionary Leaders" "Model 3: Cold War and System Size" "Model 4: Dropped Allied Dyads" "Model 5: Drop Warsaw Pact") ///
drop(pcyrsmzinit pcyrsmzinits*) ///
addnotes("Models estimated using logit with heteroskedastic robust standard errors and errors clustered by directed dyad.")

eststo clear

/*Results hold when replacing splines of DV with time fixed effects*/
quietly eststo tfx: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin _yr*, robust cluster(dirdyadid)

/*Results hold when including the lagged DV*/
quietly eststo ldv: logit mzinit mzinit_lag PTACent1_lag democracy_1_lag PTACentDemoc_1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Results hold when dropping all control variables but technical and geographic ones*/
quietly eststo techGeo: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag contigdum logdist pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

/*Results hold when dropping all control variables but technical ones*/
quietly eststo tech: logit mzinit PTACent1_lag democracy_1_lag PTACentDemoc_1_lag pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)

esttab tfx ldv techGeo tech using "robust3.tex", replace tex se label title(Directed-Dyad Analysis of MID Initiation, 1965-1999) ///
mtitles("Model 1: Time Fixed Effects" "Model 2: Lagged DV" "Model 3: Only Technical/Geographic Controls" "Model 4: Only Technical Controls") ///
drop(pcyrsmzinit pcyrsmzinits*) ///
addnotes("Models estimated using logit with heteroskedastic robust standard errors and errors clustered by directed dyad.")

*******************************************************************************************************************
log close
