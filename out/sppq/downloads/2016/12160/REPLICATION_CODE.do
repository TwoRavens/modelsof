

/*
Hicks, William D. (hickswd@appstate.edu), Seth C. McKee (sc.mckee@ttu.edu), 
   and Daniel A. Smith (dasmith@ufl.edu). 2016. "The Determinants of State 
   Legislator Support for Restrictive Voter ID Laws."   
*/

/*
Master .DO file created by William D. Hicks 
Last update: 01/09/2016 
This file directs the following tasks:
   (1) label/define variables
   (2) reproduce quantities for TABLE 1 in 3 .CSV files
      -TABLE1_FULL.CSV
      -TABLE1_DEMS.CSV
      -TABLE1_REPS.CSV
   (3) reproduce FIGURE 1 in a .GPH file
      -FIGURE1.GPH
   (4) reproduce TABLE 2 (minus predicted probabilities) in a .CSV file
      -TABLE2.CSV
   (5) reproduce FIGURE 2 in a .GPH file
      -FIGURE2.GPH
   (6) reproduce predicted probabilities in TABLE 2 in a .CSV file
      -TABLE2_PROBABILITIES.CSV 
*/
/*
                 YOU NEED TO FIRST IMPORT THE .DTA DATASET
                 THIS REQUIRES THAT YOU WRITE YOUR OWN PATH
*/

use ~[FILE PATH]/REPLICATION_DATA.dta, clear 

/*
            OUTPUT (ALL TABLES & GRAPHS) SAVED TO ~DIRECTORY
    -you also need to set the appropriate location for a directory file - 
*/

cd [MAKE YOUR DIRECTORY HERE]


/*                           
                    VARIABLE DEFINITIONS AND LABELS
*/

label var year "Year"
label var time "Time (Year-2005)" 
label var state "State Abbreviation"
label var state_name "State Name"
label var statecode "Unique State Code"
label var senate "Senate Indicator (0,1)"
label var district "District Coding I"
label var district_id "District Coding II"
label var unique_district_id "Unique District ID concat(statecode,senate,district)"
label var mmd "Multimember District Indicator (0,1)"
label var dist_magnitude "Number of Representatives in District"
label var term_length "Length of Term for Chamber"
label var lawmaker_name "Lawmaker's Name"
label var republican "Republican Indicator for Lawmaker (0,1)"
label var democrat "Democratic Indicator for Lawmaker (0,1)" 
label var female "Female Indicator for Lawmaker (0,1)"
label var black_legislator "Black Indicator for Lawmaker (0,1)"
label var latino_legislator "Latino Indicator for Lawmaker (0,1)"
label var election_year "Lawmaker's Election Year"
label var c_votes "Number of Votes Lawmaker Earned in Last Election"
label var dist_votes "Number of Votes for all Candidates in Last Election"
label var d_votes_floser "Number of Votes Earned by Losing Candidate with Most Votes"
label var margin_of_victory "(c_votes-d_votes_floser)/(dist_votes/dist_magnitude)"
label var bill_prefix "Voter ID Bill Prefix"
label var bill_number "Voter ID Bill Number"
label var vote_yes "Lawmaker Voted Yes on Bill (0,1)"
label var vote_no "Lawmaker Voted No on Bill (0,1)"
label var acs_year "Years of Data Collection for ACS-Census Data"
label var under25 "Percentage of Population Under 25 Years of Age"
label var age25_64 "Percentage of Population between 25 and 64 Years of Age"
label var pctover65 "Percentage of Population over 65 Years of Age"
label var pctnonhispblack "Percentage of Population (non-Hispanic) Black"
label var pcthispanicpop "Percentage of Population Hispanic" 
label var pctmarried "Percentage of Population Married"
label var pctbachelorsormore "Percentage of Population with (at least) Bachelor's Degree"
label var pctusnative "Percentage of Population Born in US"
label var nonnative "Percentage of Population Foreign Born"
label var pct_dem "Percentage of Democratic Votes across all of State's Districts in Last Election"
label var pct_rep "Percentage of Republican Votes across all of State's Districts in Last Election" 
label var partisan_election_margin "abs(pct_dem-pct_rep)" 
label var strict_photo_id "Strict Photo ID State Indicator (0,1)"
label var south "Southern State Indicator (0,1)" 
label var southxblack "South times Black Lawmaker" 
label var southxlatino "South times Latino Lawmaker"/*
********************************************************************************           
             QUANTITIES FOR TABLE 1
********************************************************************************           
*/

preserve 
collapse (min) blackpop_min=pctnonhispblack (median) blackpop_median=pctnonhispblack (max) blackpop_max=pctnonhispblack ///
   (min) hisppop_min=pcthispanicpop (median) hisppop_median=pcthispanicpop (max) hisppop_max=pcthispanicpop ///
   (min) nonnative_min=nonnative (median) nonnative_median=nonnative (max) nonnative_max=nonnative ///   (min) bachpop_min=pctbachelorsormore (median) bachpop_median=pctbachelorsormore (max) bachpop_max=pctbachelorsormore ///
   (min) marriedpop_min=pctmarried (median) marriedpop_median=pctmarried (max) marriedpop_max=pctmarried ///
   (min) over65pop_min=pctover65 (median) over65pop_median=pctover65 (max) over65pop_max=pctover65 ///    (min) latino_min=latino_legislator (median) latino_median=latino_legislator (max) latino_max=latino_legislator ///
   (min) black_min=black_legislator (median) black_median=black_legislator (max) black_max=black_legislator ///
   (min) female_min=female (median) female_median=female (max) female_max=female ///   (min) senate_min=senate (median) senate_median=senate (max) senate_max=senate ///
   (min) photo_ID_min=strict_photo_id (median) photo_ID_median=strict_photo_id (max) photo_ID_max=strict_photo_id ///
   (min) MOV_min=margin_of_victory (median) MOV_median=margin_of_victory (max) MOV_max=margin_of_victory ///
   (min) South_min=south (median) South_median=south (max) South_max=south ///
   (min) PEM_min=partisan_election_margin (median) PEM_median=partisan_election_margin (max) PEM_max=partisan_election_margin ///
   (min) time_min=time (median) time_median=time (max) time_max=time
xpose, clear varname
outsheet using TABLE1_FULL.csv, replace comma
restore

preserve 
collapse (min) blackpop_min=pctnonhispblack (median) blackpop_median=pctnonhispblack (max) blackpop_max=pctnonhispblack ///
   (min) hisppop_min=pcthispanicpop (median) hisppop_median=pcthispanicpop (max) hisppop_max=pcthispanicpop ///
   (min) nonnative_min=nonnative (median) nonnative_median=nonnative (max) nonnative_max=nonnative ///   (min) bachpop_min=pctbachelorsormore (median) bachpop_median=pctbachelorsormore (max) bachpop_max=pctbachelorsormore ///
   (min) marriedpop_min=pctmarried (median) marriedpop_median=pctmarried (max) marriedpop_max=pctmarried ///
   (min) over65pop_min=pctover65 (median) over65pop_median=pctover65 (max) over65pop_max=pctover65 ///    (min) latino_min=latino_legislator (median) latino_median=latino_legislator (max) latino_max=latino_legislator ///
   (min) black_min=black_legislator (median) black_median=black_legislator (max) black_max=black_legislator ///
   (min) female_min=female (median) female_median=female (max) female_max=female ///   (min) senate_min=senate (median) senate_median=senate (max) senate_max=senate ///
   (min) photo_ID_min=strict_photo_id (median) photo_ID_median=strict_photo_id (max) photo_ID_max=strict_photo_id ///
   (min) MOV_min=margin_of_victory (median) MOV_median=margin_of_victory (max) MOV_max=margin_of_victory ///
   (min) South_min=south (median) South_median=south (max) South_max=south ///
   (min) PEM_min=partisan_election_margin (median) PEM_median=partisan_election_margin (max) PEM_max=partisan_election_margin ///
   (min) time_min=time (median) time_median=time (max) time_max=time ///
   if democrat==1
xpose, clear varname
outsheet using TABLE1_DEMOCRATS.csv, replace comma
restore

preserve 
collapse (min) blackpop_min=pctnonhispblack (median) blackpop_median=pctnonhispblack (max) blackpop_max=pctnonhispblack ///
   (min) hisppop_min=pcthispanicpop (median) hisppop_median=pcthispanicpop (max) hisppop_max=pcthispanicpop ///
   (min) nonnative_min=nonnative (median) nonnative_median=nonnative (max) nonnative_max=nonnative ///   (min) bachpop_min=pctbachelorsormore (median) bachpop_median=pctbachelorsormore (max) bachpop_max=pctbachelorsormore ///
   (min) marriedpop_min=pctmarried (median) marriedpop_median=pctmarried (max) marriedpop_max=pctmarried ///
   (min) over65pop_min=pctover65 (median) over65pop_median=pctover65 (max) over65pop_max=pctover65 ///    (min) latino_min=latino_legislator (median) latino_median=latino_legislator (max) latino_max=latino_legislator ///
   (min) black_min=black_legislator (median) black_median=black_legislator (max) black_max=black_legislator ///
   (min) female_min=female (median) female_median=female (max) female_max=female ///   (min) senate_min=senate (median) senate_median=senate (max) senate_max=senate ///
   (min) photo_ID_min=strict_photo_id (median) photo_ID_median=strict_photo_id (max) photo_ID_max=strict_photo_id ///
   (min) MOV_min=margin_of_victory (median) MOV_median=margin_of_victory (max) MOV_max=margin_of_victory ///
   (min) South_min=south (median) South_median=south (max) South_max=south ///
   (min) PEM_min=partisan_election_margin (median) PEM_median=partisan_election_margin (max) PEM_max=partisan_election_margin ///
   (min) time_min=time (median) time_median=time (max) time_max=time ///
   if republican==1
xpose, clear varname
outsheet using TABLE1_REPUBLICANS.csv, replace comma
restore


/*
********************************************************************************
                               FIGURE 1
********************************************************************************
*/

preserve 

drop if democrat<1collapse (sum) vote_nay_Dems=vote_no (sum) vote_yea_Dems=vote_yes, by(year state)save democrats_vote_totals.dta, replace

/*import the data matrix again */

use ~[FILE PATH]/REPLICATION_DATA.csv, clear 

drop if republican<1collapse (sum) vote_nay_Reps=vote_no (sum) vote_yea_Reps=vote_yes, by(year state)save republicans_vote_totals.dta, replacemerge year state using democrats_vote_totals.dta, unique sortdrop _mergegen pct_yea_Reps=100*(vote_yea_Reps/(vote_yea_Reps+vote_nay_Reps))gen pct_nay_Dems=100*(vote_nay_Dems/(vote_yea_Dems+vote_nay_Dems))gen polar = 100-abs((pct_yea_Reps)-(pct_nay_Dems))gen pos=3replace pos=3 if state=="IN" & year==2005 replace pos=5 if state=="GA" & year==2005 replace pos=9 if state=="WI" & year==2006 replace pos=10 if state=="TX" & year==2011 replace pos=8 if state=="NC" & year==2011 replace pos=1 if state=="MT" & year==2011 replace pos=9 if state=="TN" & year==2011 replace pos=1 if state=="SC" & year==2011 replace pos=3 if state=="KS" & year==2011 replace pos=2 if state=="AL" & year==2011 replace pos=3 if state=="WI" & year==2011 replace pos=5 if state=="MN" & year==2011 replace pos=9 if state=="PA" & year==2012 replace pos=10 if state=="VA" & year==2012 replace pos=2 if state=="MN" & year==2012 replace pos=9 if state=="TN" & year==2013 replace pos=10 if state=="VA" & year==2013 replace pos=2 if state=="NC" & year==2013 twoway (scatter polar year, mlabel(state) mlabv(pos) msize(small) ///
mlabc(gs8) mcolor(black)), ///ytitle("Partisan Polarization on Voter ID Bills") ///
ylabel(, nogrid) ///xtitle("Year") ///yscale(range(0,100)) ///
scheme (s2mono) graphregion(fcolor(white) icolor(white) lcolor(white)) ///xscale(range(2005, 2013)) saving(FIGURE1, replace)


restore/*
********************************************************************************
   QUANTITIES FOR TABLE 2 (PREDICTED PROBABILITIES ARE AT THE BOTTOM OF FILE)********************************************************************************           */quietly gllamm vote_yes republican  ///
pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator black_legislator south southxblack female ///senate strict_photo_id margin_of_victory ///
partisan_election_margin time, i(statecode) link(logit) family(binomial) adapt
estimates store FULL


quietly gllamm vote_yes ///
pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator black_legislator south southxblack female ///senate strict_photo_id margin_of_victory ///
partisan_election_margin time if democrat==1, i(statecode) link(logit) family(binomial) adapt
estimates store DEMOCRAT

quietly gllamm vote_yes  ///
pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// south latino_legislator female ///senate strict_photo_id margin_of_victory ///
partisan_election_margin time if republican==1, i(statecode) link(logit) family(binomial) adapt
estimates store REPUBLICANesttab FULL DEMOCRAT REPUBLICAN using TABLE2.csv, replace ar2 ///
 nonumbers mtitles("FULL" "DEMS" "REPS") cells(b(star fmt(%9.4f)) /// se) starlevels(+ 0.10 * 0.05 ** 0.01) stats(N aic bic, /// fmt(%9.0g %9.3f)) varwidth(30) modelwidth(10) /// title("Multilevel Logit: Voting for Voter ID Laws") /// note("Note: DV = 1 for yea vote on Voter ID Law") /// varlabels(_cons constant republican "Republican" pctnonhispblack "% Black" ///
 pcthispanicpop "% Hispanic" nonnative "% non-US Native" ///
 pctbachelorsormore "% Bachelors" pctmarried "% Married" ///
 pctover65 "% Over 65" latino_legislator "Latino Leg." black_legislator "Black Leg." ///
 south "South" southXblack "South X Black Leg." female "Female" senate "Senator" ///
 strict_photo_id "Strict Photo ID" time "Time" ///
 margin_of_victory "M.O.V." partisan_election_margin "P.E.M.") /// label legend style(tab) 
 
/*
       MARGINAL EFFECTS FOR THE INTERACTION TERM IN FULL AND DEM MODELS
*/estimates restore FULL
estimates replay FULL
estat vce, cov

gen B_south= -1.448715 gen B_black= .6508103   gen B_southXblack=-4.195239 

gen V_south=.41906661     gen V_black=.2602885  gen V_southXblack=.78609945  gen COV_south_southXblack=-.04203255   
gen COV_black_southXblack=-.18343876 

gen ME_black_south=B_black+B_southXblack*1
gen ME_black_nonsouth=B_black+B_southXblack*0
 
gen ME_VAR_black_south=sqrt(V_black+((1^2)*V_southXblack)+ ///
    (2*1*COV_black_southXblack))   
gen ME_VAR_black_nonsouth=sqrt(V_black+((1^2)*V_southXblack)+ ///
    (2*0*COV_black_southXblack))
    
gen upper_black_south=ME_black_south+(1.645*ME_VAR_black_south)
gen lower_black_south=ME_black_south-(1.645*ME_VAR_black_south)
gen upper_black_nonsouth=ME_black_nonsouth+(1.645*ME_VAR_black_nonsouth)
gen lower_black_nonsouth=ME_black_nonsouth-(1.645*ME_VAR_black_nonsouth)
 
sum ME_black_south ME_black_nonsouth upper_black_south ///
   lower_black_south upper_black_nonsouth lower_black_nonsouth
   
di exp(-2.188416) /*Upper limit, ME(Black|South)*/
di exp(-3.544429) /*ME(Black|South)*/
di exp(-4.900442) /*Lower limit, ME(Black|South)*/

di exp(2.333532) /*Upper limit, ME(Black|Non-South)*/
di exp(.6508103) /*ME(Black|Non-South)*/
di exp(-1.031911) /*Lower limit, ME(Black|Non-South)*/

drop B_south-lower_black_nonsouth

/*Democratic only model */

estimates restore DEMOCRAT
estimates replay DEMOCRAT
estat vce, cov

gen B_south= -1.510928  gen B_black=.7953023   gen B_southXblack=-4.539846  

gen V_south=.67274628      gen V_black=.32418572   gen V_southXblack=1.347402  gen COV_south_southXblack=-.05126121    
gen COV_black_southXblack=-.20183584  

gen ME_black_south=B_black+B_southXblack*1
gen ME_black_nonsouth=B_black+B_southXblack*0
 
gen ME_VAR_black_south=sqrt(V_black+((1^2)*V_southXblack)+ ///
    (2*1*COV_black_southXblack))   
gen ME_VAR_black_nonsouth=sqrt(V_black+((1^2)*V_southXblack)+ ///
    (2*0*COV_black_southXblack))
    
gen upper_black_south=ME_black_south+(1.645*ME_VAR_black_south)
gen lower_black_south=ME_black_south-(1.645*ME_VAR_black_south)
gen upper_black_nonsouth=ME_black_nonsouth+(1.645*ME_VAR_black_nonsouth)
gen lower_black_nonsouth=ME_black_nonsouth-(1.645*ME_VAR_black_nonsouth)
 
sum ME_black_south ME_black_nonsouth upper_black_south ///
   lower_black_south upper_black_nonsouth lower_black_nonsouth
   
di exp(-1.892244) /*Upper limit, ME(Black|South)*/
di exp(-3.744544) /*ME(Black|South)*/
di exp(-5.596843) /*Lower limit, ME(Black|South)*/

di exp(2.922121) /*Upper limit, ME(Black|Non-South)*/
di exp(.7953023) /*ME(Black|Non-South)*/
di exp(-1.331517) /*Lower limit, ME(Black|Non-South)*/
 
/*
********************************************************************************
                              FIGURE 2                                         
********************************************************************************OTHER VARIABLES HELD TO MEDIAN OF FULL SAMPLE 
*/preserve 
estimates restore DEMOCRAT

replace pctnonhispblack = (_n/2)
replace pctnonhispblack=. if pctnonhispblack>97
replace pcthispanicpop =  3.5
replace nonnative=4 
replace pctbachelorsormore=22.7 
replace pctmarried=53.7 
replace pctover65=13
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=37.0852
replace partisan_election_margin=16.54175  
replace time=6 

gllapred dem11, mu marginal

estimates restore REPUBLICAN

replace pctnonhispblack = (_n/2)
replace pctnonhispblack=. if pctnonhispblack>57     
replace pcthispanicpop =  3.5
replace nonnative=4 
replace pctbachelorsormore=22.7 
replace pctmarried=53.7 
replace pctover65=13
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=37.0852
replace partisan_election_margin=16.54175  
replace time=6 
gllapred rep11, mu marginal

gen blackpop_reps = (_n/2)
replace blackpop_reps=. if blackpop_reps>57

gen blackpop_dems = (_n/2)
replace blackpop_dems=. if blackpop_dems>97.4
twoway (line dem11 blackpop_dems, clpattern(longdash) clwidth(medium) clcolor(black)) ///
  (line rep11 blackpop_reps, clpattern(shortdash) clwidth(medium) clcolor(black)), ///
  yline(0.5, lwidth(thin) lpattern(solid) lcolor(gs8)) ///  xtitle("% Non-Hispanic Black Population", size(2.5)) ///  ytitle("Probability Legislator Votes Yea", size(2.5)) ///
  ylabel(, nogrid) ///  xsca(titlegap(2)) ///  ysca(titlegap(2)) ///  scheme (tufte) graphregion(fcolor(white) icolor(white) lcolor(white)) ///
  legend(rows(1) label(1 "Democrats") label(2 "Republicans") size(2.5)) /// 
  saving(FIGURE2, replace)restore/*
        PRESERVE DATA MATRIX, RUN ALL THE WAY THROUGH NEXT RESTORE
*/

preserve /*          MARGINAL/POPULATION AVERAGE PROBABILITIES                       
*/

/*
  SUMMARY STATISTICS BY PARTY FOR SET QUANTITIES (i.e., mean/median by sample)
Note: lines 451 through 464 generate values from Table 1. These values are then 
used to produce the probabilities reported in Table 2.   
*/summarize pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator black_legislator female ///senate strict_photo_id margin_of_victory south partisan_election_marginsummarize pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator black_legislator female ///senate strict_photo_id margin_of_victory south partisan_election_margin if democrat==1 summarize pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator black_legislator female ///senate strict_photo_id margin_of_victory south partisan_election_margin if republican==1
       

/*  
********************************************************************************           
                 PREDICTED PROBABILITIES FOR FULL MODEL
********************************************************************************           
*/
estimates restore FULL

/*1. REPUBLICANS V. DEMOCRATS */
replace republican = 1
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.40
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred republican_pr, mu marginal

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.40
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred democrat_pr, mu marginal

gen REPUBLICAN_PR_FULL=100*(republican_pr-democrat_pr)
tab REPUBLICAN_PR
drop democrat_pr republican_pr


/*1. % BLACK POP */

replace republican = 0
replace pctnonhispblack = 97.4
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.40
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred blackpop1_max, mu marginal

replace republican = 0
replace pctnonhispblack = 0
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.40
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred blackpop1_min, mu marginal

gen BLACKPOP_PR_FULL=100*(blackpop1_max-blackpop1_min)
tab BLACKPOP_PR_FULL
drop blackpop1_max blackpop1_min

/*1. % BACHELORS */

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=81.8
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred bachpop1_max, mu marginal

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=3.3
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred bachpop1_min, mu marginal

gen BACHPOP_PR_FULL=100*(bachpop1_max-bachpop1_min)
tab BACHPOP_PR_FULL
drop bachpop1_max bachpop1_min

/*1. SENATE */

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=1
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred senate1_max, mu marginal

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred senate1_min, mu marginal

gen SENATOR_PR_FULL=100*(senate1_max-senate1_min)
tab SENATOR_PR_FULL
drop senate1_max senate1_min

/*1. PARTISAN ElECTION MARGIN (PEM) */

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=51.16
replace time=6 

gllapred pem1_max, mu marginal


replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=0.24
replace time=6 

gllapred pem1_min, mu marginal

gen PEM_PR_FULL=100*(pem1_max-pem1_min)
tab PEM_PR_FULL
drop pem1_max pem1_min

/*1. STRICT PHOTO ID */

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred photo1_max, mu marginal

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=0
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred photo1_min, mu marginal

gen PHOTOID_PR_FULL=100*(photo1_max-photo1_min)
tab PHOTOID_PR_FULL
drop photo1_max photo1_min

/*1. TIME */

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=6 

gllapred time1_max, mu marginal

replace republican = 0
replace pctnonhispblack = 12.89
replace pcthispanicpop = 6.64
replace nonnative=6.029641     
replace pctbachelorsormore=26.4
replace pctmarried=51.47
replace pctover65=13.00
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03
replace partisan_election_margin=16.46
replace time=0 

gllapred time1_min, mu marginal

gen TIME_PR_FULL=100*(time1_max-time1_min)
tab TIME_PR_FULL
drop time1_max time1_min

/*
           INTERACTION EFFECT IN FULL MODEL (SEE TABLE NOTES)
*/
 
/*WHITE SOUTH*/
replace republican = 0
replace pctnonhispblack=12.88503     
replace pcthispanicpop=6.644803     
replace nonnative=6.029641     
replace pctbachelorsormore=26.40205     
replace pctmarried=51.47119      
replace pctover65=13.00276    
replace latino_legislator=0
replace black_legislator=0
replace south=1
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03146     
replace partisan_election_margin=16.4639     
replace time=6 

gllapred white_south_full, mu marginal

/*WHITE NON-SOUTH*/
replace republican = 0
replace pctnonhispblack=12.88503     
replace pcthispanicpop=6.644803     
replace nonnative=6.029641     
replace pctbachelorsormore=26.40205     
replace pctmarried=51.47119      
replace pctover65=13.00276    
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03146     
replace partisan_election_margin=16.4639     
replace time=6 

gllapred white_nonsouth_full, mu marginal


/*BLACK SOUTH*/
replace republican = 0
replace pctnonhispblack=12.88503     
replace pcthispanicpop=6.644803     
replace nonnative=6.029641     
replace pctbachelorsormore=26.40205     
replace pctmarried=51.47119      
replace pctover65=13.00276    
replace latino_legislator=0
replace black_legislator=1
replace south=1
replace southxblack=1
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03146     
replace partisan_election_margin=16.4639     
replace time=6 

gllapred black_south_full, mu marginal

/*BLACK NON-SOUTH*/
replace republican = 0
replace pctnonhispblack=12.88503     
replace pcthispanicpop=6.644803     
replace nonnative=6.029641     
replace pctbachelorsormore=26.40205     
replace pctmarried=51.47119      
replace pctover65=13.00276    
replace latino_legislator=0
replace black_legislator=1
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=50.03146     
replace partisan_election_margin=16.4639     
replace time=6 

gllapred black_nonsouth_full, mu marginal

/*
              SOUTH PREDICTED PROBABILITY
*/
gen SOUTH_PR_FULL = 100*(white_south_full-white_nonsouth_full)
tab SOUTH_PR_FULL
drop white_south_full white_nonsouth_full

/*     
             INTERACTION EFFECT PROBABILITY
*/

gen INTERACTION_PR_FULL = 100*(black_south_full-black_nonsouth_full)
tab INTERACTION_PR_FULL
drop black_south_full black_nonsouth_full/*********************************************************************************           
             PREDICTED PROBABILITIES FOR DEMOCRATIC MODEL
******************************************************************************** */estimates restore DEMOCRAT 


/*2. % BLACK POP */

replace pctnonhispblack = 97.4
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002 
replace time=6 

gllapred blackpop2_max, mu marginal

replace pctnonhispblack = 0
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred blackpop2_min, mu marginal

gen BLACKPOP_PR_DEM=100*(blackpop2_max-blackpop2_min)
tab BLACKPOP_PR_DEM
drop blackpop2_max blackpop2_min

/*2. % BACHELORS */

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=81.8 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred bach2_max, mu marginal

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=3.3 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred bach2_min, mu marginal

gen BACHPOP_PR_DEM=100*(bach2_max-bach2_min)
tab BACHPOP_PR_DEM
drop bach2_max bach2_min


/*2. SENATE */

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=1
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred senate2_max, mu marginal

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred senate2_min, mu marginal

gen SENATE_PR_DEM=100*(senate2_max-senate2_min)
tab SENATE_PR_DEM
drop senate2_max senate2_min

/*2. PHOTO ID */

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred photo2_max, mu marginal

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=0
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002
replace time=6 

gllapred photo2_min, mu marginal

gen PHOTO_PR_DEM=100*(photo2_max-photo2_min)
tab PHOTO_PR_DEM
drop photo2_max photo2_min

/*2. PEM */

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=51.16374
replace time=6 

gllapred pem2_max, mu marginal

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=.244545   
replace time=6 

gllapred pem2_min, mu marginal

gen PEM_PR_DEM=100*(pem2_max-pem2_min)
tab PEM_PR_DEM
drop pem2_max pem2_min

/*2. TIME */

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176 
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002 
replace time=6 

gllapred time2_max, mu marginal

replace pctnonhispblack = 22.9332 
replace pcthispanicpop =  8.437701 
replace nonnative=7.582732 
replace pctbachelorsormore=25.53176
replace pctmarried=44.56868 
replace pctover65=12.49689 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41343
replace partisan_election_margin=15.91002    
replace time=0

gllapred time2_min, mu marginal

gen TIME_PR_DEM=100*(time2_max-time2_min)
tab TIME_PR_DEM
drop time2_max time2_min


/*
           INTERACTION EFFECT IN DEMOCRAT MODEL (SEE TABLE NOTES)
*/


/*WHITE SOUTH*/
replace pctnonhispblack = 22.93
replace pcthispanicpop = 8.44
replace nonnative=7.582732  
replace pctbachelorsormore=25.53
replace pctmarried=44.57
replace pctover65=12.50
replace latino_legislator=0
replace black_legislator=0
replace south=1
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41
replace partisan_election_margin=15.91
replace time=6 

gllapred white_south_dem, mu marginal

/*for confidence intervals, you can install and use the command ci_marg_mu
  this command was written by one of the authors of the gllamm command */
  
/*ci_marg_mu white_south_lower white_south_upper, level(90) reps(200)*/

/*BLACK SOUTH*/
replace pctnonhispblack = 22.93
replace pcthispanicpop = 8.44
replace nonnative=7.582732 
replace pctbachelorsormore=25.53
replace pctmarried=44.57
replace pctover65=12.50
replace latino_legislator=0
replace black_legislator=1
replace south=1
replace southxblack=1
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41
replace partisan_election_margin=15.91
replace time=6 

gllapred black_south_dem, mu marginal

/*for confidence intervals, you can install and use the command ci_marg_mu
  this command was written by one of the authors of the gllamm command */
  
/*ci_marg_mu black_south_lower black_south_upper, level(90) reps(200)*/


/*BLACK NON-SOUTH*/
replace pctnonhispblack = 22.93
replace pcthispanicpop = 8.44
replace nonnative=7.582732 
replace pctbachelorsormore=25.53
replace pctmarried=44.57
replace pctover65=12.50
replace latino_legislator=0
replace black_legislator=1
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41
replace partisan_election_margin=15.91
replace time=6 

gllapred black_nonsouth_dem, mu marginal
/*for confidence intervals, you can install and use the command ci_marg_mu
  this command was written by one of the authors of the gllamm command */
  
/*ci_marg_mu black_nonsouth_lower black_nonsouth_upper, level(90) reps(200)*/

/*WHITE NON-SOUTH*/
replace pctnonhispblack = 22.93
replace pcthispanicpop = 8.44
replace nonnative=7.582732 
replace pctbachelorsormore=25.53
replace pctmarried=44.57
replace pctover65=12.50
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=51.41
replace partisan_election_margin=15.91
replace time=6 

gllapred white_nonsouth_dem, mu marginal
/*for confidence intervals, you can install and use the command ci_marg_mu
  this command was written by one of the authors of the gllamm command */
  
/*ci_marg_mu white_nonsouth_lower white_nonsouth_upper, level(90) reps(200)*/

/*
              SOUTH PREDICTED PROBABILITY
*/
gen SOUTH_PR_DEM = 100*(white_south_dem-white_nonsouth_dem)
tab SOUTH_PR_DEM
drop white_south_dem white_nonsouth_dem

/*     
             INTERACTION EFFECT PROBABILITY
*/

gen INTERACTION_PR_DEM = 100*(black_south_dem-black_nonsouth_dem)
tab INTERACTION_PR_DEM
drop black_south_dem black_nonsouth_dem
/*******************************************************************************
         PREDICTED PROBABILITIES FOR REPUBLICAN MODEL
*******************************************************************************/estimates restore REPUBLICAN

/*3. % BLACK POP */

replace pctnonhispblack = 56.9
replace pcthispanicpop = 5.532647  
replace nonnative=5.06009
replace pctbachelorsormore=26.96648  
replace pctmarried=55.79707 
replace pctover65=13.31624 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=49.21861
replace partisan_election_margin=16.81399  
replace time=6 

gllapred blackpop3_max, mu marginal

replace pctnonhispblack = 0
replace pcthispanicpop = 5.532647  
replace nonnative=5.06009
replace pctbachelorsormore=26.96648  
replace pctmarried=55.79707 
replace pctover65=13.31624 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=49.21861
replace partisan_election_margin=16.81399 
replace time=6 

gllapred blackpop3_min, mu marginal

gen BLACKPOP_PR_REP = 100*(blackpop3_max-blackpop3_min)
tab BLACKPOP_PR_REP
drop blackpop3_max blackpop3_min

/*3. % MARRIED */

replace pctnonhispblack = 6.578177    
replace pcthispanicpop = 5.532647  
replace nonnative=5.06009
replace pctbachelorsormore=26.96648  
replace pctmarried=71.2 
replace pctover65=13.31624 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=49.21861
replace partisan_election_margin=16.81399 
replace time=6 

gllapred married3_max, mu marginal

replace pctnonhispblack = 6.578177    
replace pcthispanicpop = 5.532647  
replace nonnative=5.06009
replace pctbachelorsormore=26.96648  
replace pctmarried=10.1       
replace pctover65=13.31624 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=49.21861
replace partisan_election_margin=16.81399  
replace time=6 

gllapred married3_min, mu marginal


gen MARRIEDPOP_PR_REP = 100*(married3_max-married3_min)
tab MARRIEDPOP_PR_REP
drop married3_max married3_min

/*3. TIME */

replace pctnonhispblack = 6.578177    
replace pcthispanicpop = 5.532647  
replace nonnative=5.06009
replace pctbachelorsormore=26.96648  
replace pctmarried=55.79707    
replace pctover65=13.31624 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=49.21861
replace partisan_election_margin=16.81399  
replace time=6 

gllapred time3_max, mu marginal

replace pctnonhispblack = 6.578177    
replace pcthispanicpop = 5.532647  
replace nonnative=5.06009
replace pctbachelorsormore=26.96648  
replace pctmarried=55.79707           
replace pctover65=13.31624 
replace latino_legislator=0
replace black_legislator=0
replace south=0
replace southxblack=0
replace female=0
replace senate=0
replace strict_photo_id=1
replace margin_of_victory=49.21861
replace partisan_election_margin=16.81399  
replace time=0 

gllapred time3_min, mu marginal


gen TIME_PR_REP = 100*(time3_max-time3_min)
tab TIME_PR_REP
drop time3_max time3_min


/*
*******************************************************************************
                        OUTSHEET OF PROBABILITIES
*******************************************************************************
*/


collapse REPUBLICAN_PR_FULL BLACKPOP_PR_FULL BACHPOP_PR_FULL ///
   SENATOR_PR_FULL PEM_PR_FULL PHOTOID_PR_FULL TIME_PR_FULL SOUTH_PR_FULL ///
   INTERACTION_PR_FULL BLACKPOP_PR_DEM BACHPOP_PR_DEM SENATE_PR_DEM ///
   PHOTO_PR_DEM PEM_PR_DEM TIME_PR_DEM SOUTH_PR_DEM INTERACTION_PR_DEM ///
   BLACKPOP_PR_REP MARRIEDPOP_PR_REP TIME_PR_REP 
xpose, clear varname
outsheet using TABLE2_PROBABILITIES.csv, comma replace



/*
                         RESTORE DATA MATRIX
*/

restore 
/***********************************************
  WALD TEST ON INTERACTION MODEL
(see footnote 15)
***********************************************/
  

quietly xtmelogit vote_yes republican  ///
pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator female ///senate strict_photo_id margin_of_victory ///
south partisan_election_margin time ///
i.republican#(c.pctnonhispblack c.pcthispanicpop c.nonnative ///c.pctbachelorsormore c.pctmarried c.pctover65 /// i.latino_legislator i.female ///i.senate i.strict_photo_id c.margin_of_victory ///
i.south c.partisan_election_margin c.time) || statecode: ,mle

estimates store INTERACTION

testparm i.republican#(c.pctnonhispblack c.pcthispanicpop c.nonnative ///c.pctbachelorsormore c.pctmarried c.pctover65 /// i.latino_legislator i.female ///i.senate i.strict_photo_id c.margin_of_victory ///
i.south c.partisan_election_margin c.time)

/*THE JOINT HYPOTHESIS THAT ALL INTERACTIONS ARE JOINTLY ZERO IS REJECTED
CHI2(14)=47.86, P<0.001*/

contrast i.republican#(c.pctnonhispblack c.pcthispanicpop c.nonnative ///c.pctbachelorsormore c.pctmarried c.pctover65 /// i.latino_legislator i.female ///i.senate i.strict_photo_id c.margin_of_victory ///
i.south c.partisan_election_margin c.time), overall


quietly xtmelogit vote_yes republican  ///
pctnonhispblack pcthispanicpop nonnative ///pctbachelorsormore pctmarried pctover65 /// latino_legislator female ///senate strict_photo_id margin_of_victory ///
south partisan_election_margin time  || statecode: ,mle

estimates store NON_INTERACTION

lrtest INTERACTION NON_INTERACTION, stats



