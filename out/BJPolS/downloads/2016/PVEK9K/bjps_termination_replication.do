/* Bertelli-Sinclair                               */
/* Termination Paper Replication File, BJPS        */
/* Prepared 20 January 2016                        */



/* Preamble */
set more off

/* Note: You will need to change this to your own directory. */
cd "~/Dropbox/Quango Grant/Output/Termination Paper/Second to BJPS/BJPS RR/submit2/accepted ms/"


/* Open Data, Set Log. */
capture log close
log using "terminationpaper_replication_log.log", replace
use "originaldata.dta", clear




/*Table 1*/

tab outcome4
bys outcome4: summarize missionconflict
bys outcome4: summarize policyareaconflict
tab govtoperations outcome4, row
bys outcome4: summarize qage
tab pmbrown outcome4, row
tab pmblair outcome4, row
tab newlabourera outcome4, row
tab advisory outcome4, row
tab public outcome4, row
tab newdep outcome4, row
bys outcome4: summarize ftelog
tab nofte outcome4, row


/*Table 2*/
  tab standardterm
  logit standardterm missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte
  estat classification, all
 
 
 
/*Table 3*/ 
  ** NOTE: Must have "seqlogit" package installed **
   seqlogit  outcome4 missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte, tree(1 2 : 3 4, 1:2, 3:4) 
   estat ic


/* Note: Each figure has been edited in the graph editor to make it presentation ready.  

/* Figure 2 */

  ** NOTE: Must have "plotfds" package installed. Due to the simulation procedure, there may be SLIGHT differences in 
  **       the appearance of the graphs produced each time the following code is run.  Also, we made our adjustments in 
  **       the graph editor directly for each individual graph and THEN combined them.  This code is included for procedural 
  **       illustration only.


estsimp logit binaryterm missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte
  plotfds, continuous(missionconflict policyareaconflict qage ftelog) ///
           discrete(govtoperations pmbrown pmblair advisory public newdep nofte) ///
           sortorder(missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte) ///
           label scheme(lean1) xline(0)
  graph save "independent_not.gph", replace
  drop b1-b12  
  
  
estsimp logit reform missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte if binaryterm==0
  plotfds, continuous(missionconflict policyareaconflict qage ftelog) ///
           discrete(govtoperations pmbrown pmblair advisory public newdep nofte) ///
           sortorder(missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte) ///
           label scheme(lean1) xline(0) 
  graph save "reform_retain.gph", replace
  drop b1-b12


estsimp logit abolish missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte if binaryterm==1
  plotfds, continuous(missionconflict policyareaconflict qage ftelog) ///
           discrete(govtoperations pmbrown pmblair advisory public newdep nofte) ///
           sortorder(missionconflict policyareaconflict govtoperations pmbrown pmblair qage advisory public newdep ftelog nofte) ///
           label scheme(lean1) xline(0)
  graph save "abolish_integrate.gph", replace
  drop b1-b12
  

graph combine "independent_not.gph" ///
              "reform_retain.gph" ///
			  "abolish_integrate.gph", rows(3)


log close
exit













