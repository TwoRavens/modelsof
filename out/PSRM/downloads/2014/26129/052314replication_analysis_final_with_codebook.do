
/////////////////////ANALYSIS (IN THE ORDER IT APPEARS IN THE PAPER)///////////////////////////

//////////////////////1. EXTERNAL MANIPULATION CHECKS///////////////////////////////

***1.1. FRAME ANALYSIS (text page 9)
use "C:\Users\xdudel\Downloads\031613videoframe_analysis_replication.dta", clear
drop faceGCY thumbdist
label var nonverbal "Candidate nonverbal attitude"
label def nonverbal 1 "Confident" 0 "Non-confident", add
label val nonverbal nonverbal
label var verbal "Verbal speech quality"
label def verbal 1 "High quality" 0 "Low quality", add
label val verbal verbal

**DV1: GRAVITY CENTER OF THE CANDIDATE'S FACE AS IT APPEARS ON THE FRAME
	**COMPUTED AS THE DISTANCE FROM THE TOP TO THE GRAVITY CENTER OF THE FACE (ON THE Y AXIS) OVER THE TOTAL HEIGHT OF THE FRAME, LOWER VALUES INDICATE HIGHER POSITIONNING
gen faceGCY= facegcy/ frameheight
label var faceGCY "Gravity center of the candidate's face as it appears on the screen (vertical axis)"
***nonverbal confidence effect cited in the paper on page 9, line 17
anova faceGCY nonverbal##verbal
margins nonverbal#verbal

**DV2: DISTANCE BETWEEN THE CANDIDATES' THUMBS AS IT APPEARS ON THE FRAME
	**COMPUTED AS THE DISTANCE BETWEEN THE LEFT X-COORDINATE OF THE RIGHT THUMB, AND THE RIGHT X-COORDINATE OF THE LEFT THUMB, OVER THE FRAME TOTAL WIDTH
	**POSITIVE VALUES INDICATE OPEN BODY, AND NEGATIVE VALUES INCATE HAND CROSSING. 
gen thumbdist= (rightthumbleft-leftthumbright)/ framewidth
***nonverbal confidence effect cited in the paper on page 9, line 18
label var thumbdist "Distance between the candidate thumbs on the screen"
anova thumbdist nonverbal##verbal
margins nonverbal#verbal

****Other variable labels:
label var	seconds	"	Screen capture order in the video"
label var	image	"	Screen capture name"
label var	framewidth	"	Screen frame: width in pixels"
label var	frameheight	"	Screen frame: height in pixels"
label var	framearea	"	Screen frame: area in pixels"
label var	frameleft	"	Screen frame: left coordinate in pixels"
label var	frametop	"	Screen frame: top coordinate in pixels"
label var	frameright	"	Screen frame: right coordinate in pixels"
label var	framebottom	"	Screen frame: bottom coordinate in pixels"
label var	framegcx	"	Screen frame: gravity center vertical coordinate in pixels"
label var	framegcy	"	Screen frame: gravity center horizontal coordinate in pixels"
label var	facewidth	"	Face: width in pixels"
label var	faceheight	"	Face: height in pixels"
label var	facearea	"	Face: area in pixels"
label var	faceleft	"	Face: left coordinate in pixels"
label var	facetop	"	Face: top coordinate in pixels"
label var	faceright	"	Face: right coordinate in pixels"
label var	facebottom	"	Face: bottom coordinate in pixels"
label var	facegcx	"	Face: gravity center vertical coordinate in pixels"
label var	facegcy	"	Face: gravity center horizontal coordinate in pixels"
label var	rightthumbwidth	"	Right thumb: width in pixels"
label var	rightthumbheight	"	Right thumb: height in pixels"
label var	rightthumbarea	"	Right thumb: area in pixels"
label var	rightthumbleft	"	Right thumb: left coordinate in pixels"
label var	rightthumbtop	"	Right thumb: top coordinate in pixels"
label var	rightthumbright	"	Right thumb: right coordinate in pixels"
label var	rightthumbbottom	"	Right thumb: bottom coordinate in pixels"
label var	rightthumbgcx	"	Right thumb: gravity center vertical coordinate in pixels"
label var	rightthumbgcy	"	Right thumb: gravity center horizontal coordinate in pixels"
label var	leftthumbwidth	"	Left thumb: width in pixels"
label var	leftthumbheight	"	Left thumb: height in pixels"
label var	leftthumbarea	"	Left thumb: area in pixels"
label var	leftthumbleft	"	Left thumb: left coordinate in pixels"
label var	leftthumbtop	"	Left thumb: top coordinate in pixels"
label var	leftthumbright	"	Left thumb: right coordinate in pixels"
label var	leftthumbbottom	"	Left thumb: bottom coordinate in pixels"
label var	leftthumbgcx	"	Left thumb: gravity center vertical coordinate in pixels"
label var	leftthumbgcy	"	Left thumb: gravity center horizontal coordinate in pixels"
label var	v1n0	"	Experimental condition: N-V+"
label var	videosecond	"	Second the frame appeared in the video"
label var	v1n1	"	Experimental condition: N+V+"
label var	v0n0	"	Experimental condition: N-V-"
label var	v0n1	"	Experimental condition: N+V-"
codebook, compact

***1.2. INDEPENDENT RATINGS DATA (text page 10)
use "C:\Users\xdudel\Downloads\031613nonverbal_indep_manipcheck_replication.dta", clear
label var strong_speech "Group exposed to the high quality speech"
label var strong_args "Evaluation of the strength of arguments in the speech"
label var structure "Evaluation of the structure of the speech" 
label var clear "Evaluation of the clarity of the speech"
label var persuasive "Evaluation of the persuasiveness of the speech" 

///1.2.1. VERBAL MANIPULATION CHECK (paper page 10, lines 7 and 8)
	***SBS READ ONE OF THE TWO SPEECHES AND RATED THEM ON THE STRENGTH OF ARGUMENTS, STRUCTURE, CLARITY & PERSUASIVENESS
	***HIGHER RATINGS INDICATE BETTER SCORES ON THESE VARIABLES
	***BETWEEN-SBS ANALYSIS 
	***strong_speech= variable identifying the group that saw the high quality message, assignment to this group was random
***t-statistic cited in the paper page 10, line 7:
ttest  strong_args, by(strong_speech)
***t-statistic cited in the paper page 10, line 8:
ttest  structure , by(strong_speech) 
***t-statistic cited in the paper page 10, line 8:
ttest  clear, by(strong_speech) 
***t-statistic cited in the paper page 10, line 8:
ttest  persuasive, by(strong_speech) 

///1.2.2. NONVERBAL MANIPULATION CHECK (paper page 10, line 6)
	***SBS SAW TWO 30s EXCEPTS FROM DIFFERENT CONDITIONS AND RATED THE LEVEL OF CONFIDENCE IN EACH OF THEM
	***TESTS ARE WITHING-SBS, COMPARING THE CONFIDENCE RATINGS FOR EACH PAIR OF VIDEOS
	***SBS WERE RANDOMLY ASSIGNED TO SEE DIFFERENT PAIRS OF VIDEOS, INDICATED BY THE VARIABLE branch
label var confident1 "Level of candidate confidence in the first video"
label var confident2 "Level of candidate confidence in the second video"
label var branch "Order of videos exposed to"
label def branch 1 "Order of videos: 1=N-V-, 2=N-V+" 2 "Order of videos: 1=N-V-, 2=N-V+" 3 "Order of videos: 1=N+V+, 2=N-V-" 4 "Order of videos: 1=N+V+, 2=N-V-" 5 "Order of videos: 1=N+V+, 2=N-V+" 6 "Order of videos: 1=N+V+, 2=N-V+" 7 "Order of videos: 1=N-V+, 2=N+V-" 8 "Order of videos: 1=N-V+, 2=N+V-" 9 "Order of videos: 1=N+V-, 2=N-V-" 10 "Order of videos: 1=N+V-, 2=N-V-" 11 "Order of videos: 1=N+V+, 2=N+V-" 12 "Order of videos: 1=N+V+, 2=N+V-", add
label values branch branch 

***WITHIN-SBS TEST OF CONFIDENCE RATINGS FOR THOSE WHO SAW EXCERPTS FROM N+V+ FIRST, AND N-V- SECOND
*branch 3 & 4 = N+V+ vs. N-V-
*t-test cited in the paper, page 10, line 6
ttest  confident1= confident2 if branch >2 & branch<5

***WITHIN-SBS TEST OF CONFIDENCE RATINGS FOR THOSE WHO SAW EXCERPTS FROM N+V+ FIRST, AND N-V+ SECOND
*branch 5 & 6 = N+V+ vs. N-V+
*higher absolute value than the t-test cited in the paper page 10, line 6
ttest  confident1= confident2 if branch >4 & branch <7

***WITHIN-SBS TEST OF CONFIDENCE RATINGS FOR THOSE WHO SAW EXCERPTS FROM N-V+ FIRST, AND N+V- SECOND
*branch 7 & 8 = N-V+ vs. N+V-
*higher absolute value than the t-test cited in the paper page 10, line 6
ttest  confident1= confident2 if branch >6 & branch<9

***WITHIN-SBS TEST OF CONFIDENCE RATINGS FOR THOSE WHO SAW EXCERPTS FROM N+V- FIRST, AND N-V-  SECOND
*branch 9 & 10 = N+V- vs. N-V-
*higher absolute value than the t-test cited in the paper page 10, line 6
ttest  confident1= confident2 if branch >8 & branch<11

****Other variable labels:
label var	nonverbal1	"Confidence condition in the first video"
label var	verbal1	"Verbal quality condition in the first video"
label var	nonverbal2	"Confidence condition in the second video"
label var	verbal2	"Verbal quality condition in the second video"
label var	timevideopage	"Time spent on the video evaluation page"
label var	yearborn	"Year born"
label var	female	"Female"
label var	timespeechtextpage	"Time spent on the verbal speech evaluation page"
codebook, compact

///////////////////////////////////2. EXPERIMENTAL DATA AND ANALYSIS////////////////////////////////////////////
use "C:\Users\xdudel\Downloads\031613nonverbal_experiment_data_replication.dta", clear
drop select libstrength age nfc_scale envscale affect qualif elect
label var nonverbal "Candidate nonverbal attitude"
label def nonverbal 1 "Confident" 0 "Non-confident", add
label values nonverbal nonverbal
label var verbal "Verbal speech quality"
label def verbal 1 "High quality" 0 "Low quality", add
label values verbal verbal
label var confid_delivery "Evaluation: Candidate gave a confident delivery"
label var ctrl_read_text "Were you able to read the candidate's environmental text on the website in the time allotted?"
label def ctrl_read_text 1 "None of it" 2 "Some of it" 3 "Most of it" 4 "All of it"	, add
label values  ctrl_read_text ctrl_read_text
label var ctrl_physio "During the study did you feel at all uncomfortable because of the physiological measures?"
label def ctrl_physio 1 "Not at all" 5 "Very", add
label values ctrl_physio ctrl_physio 
label var female " Respondent is female"
label var yearborn " What year were you born"
label var partyvoted4 "What party did you vote for in the past federal election"
label var partyifvoted "If you didnt vote: What party came closest to your preference"
label var envir_importance "Importance of the environment as an issue"
label var env1_disposable "How often do you: avoid using disposable items (e.g. plastic forks, paper plates, etc.)"
label def env1_disposable 1 "never" 2 "Rarely" 3 "Now and then"	4 "Often" 5 "Very often", add
label var env1_same_price "How often do you: choose environmentally-friendly products regardless of price"
label values env1_same_price env1_disposable
label var env1_higher_price "How often do you: choose environmentally-friendly products regardless of price"
label values env1_higher_price env1_disposable
label var env1_boycott "How often do you: boycott products of companies that are not environmentally responsible"
label values env1_boycott env1_disposable
label var env2_pesticides_ad "Agree/Disagree: People worry too much about pesticides on food products"
label def env2_pesticides_ad 1 "Strongly agree" 2 "Agree" 3 "Neither agree nor disagree" 4 "Disagree" 5 "Strongly disagree" , add
label values env2_pesticides_ad env2_pesticides_ad
label var env2_ec_growth "Agree/Disagree: Our government should focus more on promoting economic growth even if this means placing lower priority on environmental issues"
label values env2_ec_growth env2_pesticides_ad
label var env2_exagerated "Agree/Disagree: The importance of the environment is frequently exaggerated"
label values env2_exagerated env2_pesticides_ad
label var env2_firms_profit "Agree/Disagree: Firms should always put profitability before environmental protection"
label values env2_firms_profit env2_pesticides_ad
label var env2_unsustainable "Agree/Disagree: Life on this planet will become unsustainable if we don't take care of the environment"
label values env2_unsustainable env2_pesticides_ad
label var env2_imp_issue "Agree/Disagree: The environment is one of the most important issues facing society today"
label values env2_imp_issue env2_pesticides_ad
label var env2_intl_agree "Agree/Disagree: Canada should sign international environmental agreements that help to reduce the emission of carbon dioxide"
label values env2_intl_agree env2_pesticides_ad
label var env2_protect "Agree/Disagree: Our government should focus on promoting a more environmentally friendly society even if this means a lower material standard of living"
label values env2_protect env2_pesticides_ad
label var nfc_complex_pbs "NFC, Agree/Disagree: I would prefer complex to simple problems"
label def nfc_complex_pbs 1 "Strongly agree" 2 "Agree" 3 "Disagree" 4 "Strongly disagree" , add
label values nfc_complex_pbs nfc_complex_pbs 
label var nfc_gets_job_done "NFC, Agree/Disagree: It's enough for me that something gets the job done; I don't care how or why it works"
label values nfc_gets_job_done nfc_complex_pbs 
label var nfc_small_pbs "NFC, Agree/Disagree: I prefer to think about small, daily projects to long-term ones"
label values nfc_small_pbs nfc_complex_pbs 
label var nfc_thinking_not_fun "NFC, Agree/Disagree: Thinking is not my idea of fun"
label values nfc_thinking_not_fun nfc_complex_pbs 
label var nfc_new_sols "NFC, Agree/Disagree: I really enjoy a task that involves coming up with new solutions to problems"
label values nfc_new_sols nfc_complex_pbs 
label var nfc_deliberating "NFC, Agree/Disagree: I find satisfaction in deliberating hard and for long hours"
label values nfc_deliberating nfc_complex_pbs 
label var nfc_not_think_hard "NFC, Agree/Disagree: I only think as hard as I have to"
label values nfc_not_think_hard nfc_complex_pbs 
label var nfc_no_thought "NFC, Agree/Disagree: I like tasks that require little thought once I've learned them"
label values nfc_no_thought nfc_complex_pbs 
label var nfc_deliberate_other "NFC, Agree/Disagree: I usually end up deliberating about issues even when they do not affect me personally"
label values nfc_deliberate_other nfc_complex_pbs 
label var honest "Honest: how well does this describe the candidate"
label def honest 1 "Not well at all" 2 "Not very well" 3 "Fairly well"	4 "Very well" 5	"Extremely well", add
label values honest honest
label var likable "Likable: how well does this describe the candidate "
label values likable honest
label var warm "Warm: how well does this describe the candidate"
label values warm honest
label var trustworthy "Trustworthy: how well does this describe the candidate"
label values trustworthy honest
label var competent "Competent: how well does this describe the candidate"
label values competent honest
label var knowledgeable "Knowledgeable: how well does this describe the candidate"
label values knowledgeable honest
label var intelligent "Intelligent: how well does this describe the candidate"
label values intelligent honest
label var strong_leader "Strong leader: how well does this describe the candidate"
label values strong_leader honest
label var winning_chance "Candidate's chance to win his district, compared to other Liberal candidates"
label def winning_chance 1 "Much worse" 2 "Worse" 3 "Neither better nor worse"	4 "Better" 5	"Much better", add
label values winning_chance  winning_chance 
label var persuade_voters "Candidate's chance to persuade, compared to other Liberal candidates"
label values persuade_voters winning_chance 
label var condition  "Experimental condition"
label def condition 1 "N+V+" 2 "N+V-" 3 "N-V+" 4 "N-V-", add
label values condition condition
label var belong_in_pols "Does the candidate belong in politics?"
label var belong_yes "Yes, he belongs: Why?"
label var belong_no "No, he doesnt belong: Why?"
label var interest_federal "How interested in federal politics?"
label var interest_pols_gen "How interested in politics in general"
label var student_yn "Are you a student: yes/no"
label var faculty "What department are you a student of"

set more off
***2.1. MANIPULATION CHECKS page 9 (paper page 9, line 22):
anova confid_delivery verbal##nonverbal

***2.2. FILTER VARIABLE (paper page 10, line 24 and paper page 11, line 1): excluding those who were uncomfortable with the physiological measurements and who did not read the description
	***were you able to read the text and were you comfortable with the physiological devices
	***12 people did not read or where very unconfortable:
tab ctrl_read_text
tab ctrl_physio
tab ctrl_read_text ctrl_physio
gen select =1 if ctrl_read_text >2 & ctrl_physio <4
label var select "Final sample"
tab select

***2.3. RANDOMIZATION CHECKS (paper page 11, line 4):
***RANDOM DISTRIBUTION OF GENDER (paper page 11, line 4):
anova female verbal##nonverbal if select==1

***RANDOM DISTRIBUTION OF LIBERAL STRENGTH (paper page 11, line 4):
***generating the liberal vote variable:
gen libstrength=1 if partyvoted4==1
recode libstrength .=1 if partyifvoted==1
tab libstrength
recode libstrength .=0
label var libstrength "Liberal party voter"
****Randomization check (paper page 11, line 4)
anova libstrength verbal##nonverbal if select==1

***RANDOM DISTRIBUTION OF AGE (paper page 11, line 4)
gen age= 2011-yearborn
label var age "Age"
anova age verbal##nonverbal if select==1

***RANDOM DISTRIBUTION OF ENVIRONMENTAL POSITIONS (paper page 11, line 4)
***Generating the environmental attitudes variable
alpha envir_importance- env2_firms_profit
gen envscale= (24-env2_pesticides_ad -env2_ec_growth -env2_exagerated -env2_firms_profit+ envir_importance +env1_disposable +env1_same_price + env1_higher_price + env1_boycott + env2_unsustainable + env2_imp_issue + env2_intl_agree + env2_protect )/13
sum envscale
label var envscale "Environmental scale (higher values indicate stronger pro-environmental stances)"
****Randomization check (paper page 11, line 4)
anova envscale verbal##nonverbal if select==1

***RANDOM DISTRIBUTION OF PERSONALITY (NEED FOR COGNITION) (paper page 11, line 4)
***Generating the need for cognition scale:
alpha  nfc_complex_pbs nfc_gets_job_done nfc_small_pbs nfc_thinking_not_fun nfc_new_sols nfc_deliberating nfc_not_think_hard nfc_no_thought nfc_deliberate_other
sum  nfc_complex_pbs nfc_gets_job_done nfc_small_pbs nfc_thinking_not_fun nfc_new_sols nfc_deliberating nfc_not_think_hard nfc_no_thought nfc_deliberate_other
gen nfc_scale= (5-  nfc_complex_pbs+ nfc_gets_job_done +nfc_small_pbs +nfc_thinking_not_fun + 5-nfc_new_sols +5-nfc_deliberating +nfc_not_think_hard +nfc_no_thought +5-nfc_deliberate_other)/9
****Randomization check (paper page 11, line 4)
label var nfc_scale "NFC scale"
anova nfc_scale verbal##nonverbal if select==1

***2.4. FULL RESULTS (Paper and Appendix)
***Appendix Table 1, page 1 (rows 1,2,3; 5,6,7; 9, 10, 11)
sum honest likable warm competent knowledgeable intelligent strong_leader persuade_voters winning_chance if select==1

***Appendix Table 2, page 2
pca honest likable warm competent intelligent knowledgeable  strong_leader winning_chance persuade_voters, comp(3), if select==1
****Rotated results (Table 2, page 2):
rotate

***Following the PCA results, generating affective, competence, and electability scales:
***The reliability coefficients are cited in the paper page 10, lines 20-22:
***Affective ratings scale (reliability coefficient cited in the paper, page 10, line 20)
alpha honest likable warm, gen(affect), if select==1
***Qualifications ratings scale (reliability coefficient cited in the paper page 10, line 21)
alpha competent intelligent knowledgeable, gen (qualif), if select==1
***Electability ratings scale (reliability coefficient cited in the paper page 10, line 22)
alpha strong_leader winning_chance persuade_voters, gen (elect), if select==1

***Appendix Table 1, page 1 (rows 4, 8, 12):
***Summary statistics of the Affective, Qualifications and Electability scales: 
label var affect "Affective rating"
label var qualif "Qualifications rating"
label var elect "Electability rating"

sum affect qualif elect if select==1

	***Appendix Table 3, pages 3-4
	***Affective ratings results, anova output, appendix page 3
anova affect nonverbal##verbal if select==1
	***Affective ratings results, marginal effects, appendix page 3
margins nonverbal##verbal if select==1, post
	***Affective ratings results, post-hoc group comparison of means, appendix page 4
lincom 1.nonverbal#1.verbal-0.nonverbal#0.verbal
lincom 1.nonverbal#1.verbal-0.nonverbal#1.verbal
lincom 1.nonverbal#1.verbal-1.nonverbal#0.verbal
lincom 1.nonverbal#0.verbal-0.nonverbal#0.verbal
lincom 0.nonverbal#1.verbal-0.nonverbal#0.verbal
lincom 1.nonverbal#0.verbal-0.nonverbal#1.verbal
		***nonverbal confidence effect: not significant
lincom 1.nonverbal-0.nonverbal
		***verbal quality effect: not significant
lincom 1.verbal-0.verbal
	
	***Appendix Table 3, pages 3-4
	***Qualifications ratings results, anova output, appendix page 3
anova qualif nonverbal##verbal  if select==1
	***Qualifications ratings results, marginal effects, appendix page 3
margins nonverbal##verbal  if select==1, post
	***Qualifications ratings results, post-hoc group comparison of means, appendix page 4
lincom 1.nonverbal#1.verbal-0.nonverbal#0.verbal
lincom 1.nonverbal#1.verbal-0.nonverbal#1.verbal
lincom 1.nonverbal#1.verbal-1.nonverbal#0.verbal
lincom 1.nonverbal#0.verbal-0.nonverbal#0.verbal
lincom 0.nonverbal#1.verbal-0.nonverbal#0.verbal
lincom 1.nonverbal#0.verbal-0.nonverbal#1.verbal
		***nonverbal confidence effect on qualifications ratings: cited in the paper (page 11, line 10)
lincom 1.nonverbal-0.nonverbal
		***verbal quality effect on qualifications ratings: cited in the paper (page 11, line 12)
lincom 1.verbal-0.verbal

	***Appendix Table 3, pages 3-4
	***Electability ratings results, anova output, appendix page 3
anova elect nonverbal##verbal  if select==1
	***Electability ratings results, marginal effects, appendix page 3
margins nonverbal##verbal if select==1, post
	***Electability ratings results, post-hoc group comparison of means, appendix page 4
lincom 1.nonverbal#1.verbal-0.nonverbal#0.verbal
lincom 1.nonverbal#1.verbal-0.nonverbal#1.verbal
lincom 1.nonverbal#1.verbal-1.nonverbal#0.verbal
lincom 1.nonverbal#0.verbal-0.nonverbal#0.verbal
lincom 0.nonverbal#1.verbal-0.nonverbal#0.verbal
lincom 1.nonverbal#0.verbal-0.nonverbal#1.verbal
		***nonverbal confidence effect on electability ratings: cited in the paper (page 11, line 11)
lincom 1.nonverbal-0.nonverbal
		***verbal quality effect on electability ratings: cited in the paper (page 11, line 12)
lincom 1.verbal-0.verbal

***FIGURE 1 (paper page 13):
***use the variable condition
***Figure 1, page 13, top graph: Affective ratings
anova affect i.condition if select==1
margins i.condition
marginsplot
***Figure 1, page 13, middle graph: Qualifications ratings
anova qualif i.condition if select==1
margins i.condition
marginsplot
***Figure 1, page 13, bottom graph: Electability ratings
anova elect i.condition  if select==1
margins i.condition
marginsplot

codebook, compact
