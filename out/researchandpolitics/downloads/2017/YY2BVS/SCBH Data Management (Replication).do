*Title: SCBH Data Management
*Author: Jack Reilly
*Date: 4.28.17
*Purpose: Recode variables in CNES (CSES?) for analysis (ICPSR #6541)
*Requires: 1992 CNES Data File
*Output: Data set ready for analysis
*Stata 13.1 SE on macOS 10.12

clear all
cd "~/your/working/directory"
use "06541-0001-data.dta"

*******************************
***INDIVIDUAL DEMO VARIABLES***
*******************************

***OUTDEGREE***
recode v185 1=1 *=0, gen(d1)
recode v187 1=1 *=0, gen(d2)
recode v189 1=1 *=0, gen(d3)
recode v191 1=1 *=0, gen(d4)
recode v193 1=1 *=0, gen(d5)

gen outdegree = d1+d2+d3+d4+d5
gen netsize = outdegree
gen importantonlydisc=d1+d2+d3+d4

*dummy out outdegree
gen isolate = 0
gen onedisc = 0
gen twodisc = 0
gen threedisc = 0
gen fourdisc = 0
gen fivedisc = 0

replace isolate = 1 if outdegree==0
replace onedisc = 1 if outdegree==1
replace twodisc = 1 if outdegree==2
replace threedisc = 1 if outdegree==3
replace fourdisc = 1 if outdegree==4
replace fivedisc = 1 if outdegree==5

*dummy more than/less than categories
recode netsize 0/1=0 2/5=1, gen(twoormore)
recode netsize 0/2=0 3/5=1, gen(threeormore)
recode netsize 0/3=0 4/5=1, gen(fourormore)

*dummy more than/less than categories removing isolates
recode netsize 0=. 1=0 2/5=1, gen(twoormore_noiso)
recode netsize 0=. 1/2=0 3/5=1, gen(threeormore_noiso)
recode netsize 0=. 1/3=0 4/5=1, gen(fourormore_noiso)
recode netsize 0=. 1/4=0 5=1, gen(five_noiso)

***EDUCATION***
recode v173 0/11=0 12=1 20=1 13/15=2 16=3 17/18=4 19=5 *=., gen(educ)

***RACE & ETHNICITY***
recode v182 1=1 2/5=0 *=., gen(white)
recode v182 1=0 2/5=1 *=., gen(minority)
recode v182 1=0 2=1 3/5=0 *=., gen(black)
recode v182 1/2=0 3/5=1 *=., gen(other)
recode v183 1=1 5=0 *=., gen(hispanic)

***GENDER***
recode v87 1=0 5=1 *=., gen(female)

***AGE***

***INCOME***
*six categories: less than 15k, 15k-25k, 25k-35k, 35k-50k, 50k-75k, 75k+
gen income=.
replace income=1 if v261==1
replace income=2 if v261==5
replace income=3 if v262==5
replace income=4 if v263==5
replace income=5 if v264==5
replace income=6 if v264==1

********************
***PARTIES/VOTING***
********************

***TURNOUT***
recode v43 1=1 3=0 5=. 7=., gen(turnout)

***PID***
recode v54 8=. 9=., gen(pidstrength)

gen demdummy=.
replace demdummy=-1 if v52==1
recode pidstrength 1=-5 2=-4 3=-3 4=-2 5=-1, gen(dpids)
gen dempid=demdummy+dpids
recode dempid .=0, gen(dem)
recode demdummy -1=1 .=0, gen(demdummyfin)

gen repdummy=.
replace repdummy=1 if v52==2
recode pidstrength 1=5 2=4 3=3 4=2 5=1, gen(rpids)
gen reppid=repdummy+rpids
recode reppid .=0, gen(rep)
recode repdummy 1=1 .=0, gen(repdummyfin)

gen indpid=.
replace indpid=0 if v52==3
replace indpid=1 if v53==1
replace indpid=-1 if v53==5
recode indpid .=0, gen(ind)

*Final Coding: -6 Strong Dem, 0 True Independent, 6 Strong Rep
*13 category
gen pid=dem+rep+ind
gen pid13=pid

*Three category PID
*Dem=1, Ind=0, Rep=-1
recode v52 1=1 3=0 2=-1 5=0 *=., gen(pid3)
*Nine category PID
recode pid 0=0 1=1 -1=-1 -2=-2 -3=-2 -4=-2 -5=-3 -6=-4 2=2 3=2 4=2 5=3 6=4, gen(pid9)

*PID categories from 0-1
gen pid13tab = (pid-6)/12
gen pid3tab = (pid3-1)/2

***VOTE
*-1=bush 0=perot 1=clinton
recode v44 1=-1 3=1 5=0 *=., gen(vote)
recode vote 1=0 -1=1 0=0, gen(votebush)
recode vote 1=1 -1=0 0=0, gen(voteclinton)
recode vote 1=0 -1=0 0=1, gen(voteperot)

*********************
***IDEOLOGY/ISSUES***
*********************

***IDEOLOGY
recode v79 96=. 97=. 98=. 99=., gen(ideology_flip)
gen ideology=-ideology_flip

***ISSUE 1: AFFIRMATIVE ACTION***
recode v158 1=1 3=0 *=., gen(proaffaction)
replace proaffaction=1 if v159==1
replace proaffaction=0 if v159==3

***ISSUE 2: ENVIRONMENT
recode v164 1=0 3=1 *=., gen(proenvironment)
replace proenvironment=0 if v165==1
replace proenvironment=1 if v165==3

***ISSUE 3: GOV'T HEALTH CARE
recode v146 1=1 3=0 *=., gen(progovthealth)
replace progovthealth=1 if v147==1
replace progovthealth=0 if v147==3

***ISSUE 4: ABORTION
recode v152 1=0 3=1 *=., gen(prolife)
replace prolife=1 if v153==3
replace prolife=0 if v153==1

recode v152 1=1 3=0 *=., gen(prochoice)
replace prochoice=1 if v153==1
replace prochoice=0 if v153==3

***********************
***ACTIVITY/BEHAVIOR***
***********************

***TRY TO PERSUADE OTHERS?
*1=yes; 0=no
recode v132 1=1 5=0 *=., gen(convince)

***WORK FOR CAMPAIGN?
*yes - 1, no - 0
recode v133 1=1 5=0 *=., gen(campaignwork)

***ATTEND POLITICAL MEETING?
*yes - 1, no - 0
recode v134 1=1 5=0 *=., gen(attpolmeetings)

***HAVE YARDSIGN, BUMPER STICKER, CAMPAIGN BUTTON?
*yes - 1, no - 0
recode v135 1=1 5=0 *=., gen(yardsticker)

***DONATE MONEY?
*yes - 1, no - 0
recode v136 1=1 5=0 *=., gen(donatemoney)

***TOTAL POLITICAL ACTS (inc. turnout from above)
gen totalacts = convince+campaignwork+attpolmeetings+yardsticker+donatemoney+turnout

*************************
***COUNTY LEAN VARS***
*************************

***USING VOTE CHOICE***
*mean with ego
bys cnty: egen countyvote=mean(vote)

*mean without ego
egen total_vote = total(vote), by(cnty)
egen n_vote = count(vote), by(cnty)

gen totalMINUSi_vote = total_vote - cond(missing(vote), 0, vote)
gen countyvote_subego = totalMINUSi_vote / (n_vote - !missing(vote))

***USING PID***
***means including the ego:
bys cnty: egen countypid3=mean(pid3)

***means not including the ego
egen total_pid3 = total(pid3), by(cnty)
egen n_pid3 = count(pid3), by(cnty)

gen totalMINUSi_pid3 = total_pid3 - cond(missing(pid3), 0, pid3)
gen countypid3_subego = totalMINUSi_pid3 / (n_pid3 - !missing(pid3))

************************
***COUNTY HOMOGENEITY***
************************

egen county_homog = sd(vote), by(cnty)

**************************
***COUNTY CONNECTEDNESS***
**************************

egen county_connectedness = mean(outdegree), by(cnty)


save "connectedness_working.dta", replace

