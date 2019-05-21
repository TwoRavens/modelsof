

**** EXPLAINING PROJECT (DATA SETUP FILE)
use qualtrics_data

**Paradata

rename v1 responseid
drop v2
drop v3
drop v4
drop v5
rename v6 ipaddress
drop v7
rename v8 start
rename v9 end
rename v10 left

label var responseid responseid
label var ipaddress ipaddress
label var start "time started survey"
label var end "time ended survey"
label var left "left survey before officially finishing"

**Treatment Conditions

gen senparty = .
recode senparty (.=1) if a1==1
recode senparty (.=2) if b1==1
label var senparty "Treatment: Party of Senator"
label define senparty 1 "Republican" 2 "Democrat"
label values senparty senparty

gen firstletter = .
recode firstletter (.=1) if dobrfl_41=="Q1A"|dobrfl_73=="Q2A"
recode firstletter (.=2) if dobrfl_41=="Q1B"|dobrfl_73=="Q2B"
recode firstletter (.=3) if dobrfl_41=="Q1C"|dobrfl_73=="Q2C"
recode firstletter (.=4) if dobrfl_41=="Q1D"|dobrfl_73=="Q2D"
recode firstletter (.=5) if dobrfl_41=="Q1E"|dobrfl_73=="Q2E"
recode firstletter (.=6) if dobrfl_41=="Q1F"|dobrfl_73=="Q2F"
label var firstletter "Treatment: First Letter"
label define firstletter 1 "Letter A" 2 "Letter B" 3 "Letter C" 4 "Letter D" 5 "Letter E" 6 "Letter F"
label values firstletter firstletter

gen secondletter = .
recode secondletter (.=2) if q605==1|q725==1
recode secondletter (.=1) if q585==1|q705==1
recode secondletter (.=4) if q645==1|q745==1
recode secondletter (.=3) if q625==1|q765==1
recode secondletter (.=6) if q685==1|q805==1
recode secondletter (.=5) if q665==1|q785==1
label var secondletter "Treatment: Second Letter"
label define secondletter 1 "Letter A" 2 "Letter B" 3 "Letter C" 4 "Letter D" 5 "Letter E" 6 "Letter F"
label values secondletter secondletter


**Timing Screens

egen firstletter_firstread = rowtotal(q825_3 q827_3 q829_3 q831_3 q833_3 q835_3 q837_3 q839_3 q841_3 q843_3 q845_3 q847_3), missing
label var firstletter_firstread "Seconds it Took to Read First Letter (Read 1)"

egen firstletter_secondread = rowtotal(q826_3 q828_3 q830_3 q832_3 q834_3 q836_3 q838_3 q840_3 q842_3 q844_3 q846_3 q848_3), missing
label var firstletter_secondread "Seconds it Took to Read First Letter (Read 2)"

egen secondletter_firstread = rowtotal(q849_3 q851_3 q853_3 q855_3 q857_3 q859_3 q861_3 q863_3 q865_3 q867_3 q869_3 q871_3), missing
label var secondletter_firstread "Seconds it Took to Read Second Letter (Read 1)"

egen secondletter_secondread = rowtotal(q850_3 q852_3 q854_3 q856_3 q858_3 q860_3 q862_3 q864_3 q866_3 q868_3 q870_3 q872_3), missing
label var secondletter_secondread "Seconds it Took to Read Second Letter (Read 2)"


**Consent
rename q354 consent
label var consent "Do you agree to participate?"
label define yes 1 "Yes"
label values consent yes

**Demographic Questions

//Gender
rename q1 gender
label var gender "What is your gender?"
label define gender 1 "Male" 2 "Female"
label values gender gender

//Age and Year of Birth
gen age = (85-q2+18) //Age is a much more intuitive measure. 
label var age "How old are you?"
order age, after(gender)

rename q2 YoB //I have included this variable but it is harder to use. Use 'age' instead. 
label var YoB "In what year were you born?"
label define YoB 85 "1994" 1 "1910" 5 "1914"
label values YoB YoB

//Race
rename q3 race
label var race "What is your race?"
label define race 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian/Pacific" 5 "Native American" 6 "Other"
label values race race

//Education
rename q4 education
label var education "Highest level of education?"
label define education 1 "Did not complete high-school" 2 "High School Diploma" 3 "Some College" 4 "Associate's" 5 "Bachelor's" 6 "Graduate"
label values education education

**Political Affiliation

//Affiliation A or B
rename q7 affiliationA
label var affiliationA "Political affiliation, Form A"
label define affilA 1 "Democrat" 2 "Republican" 3 "Independent" 4 "Other" 
label values affiliationA affilA

rename q8 affiliationB
label var affiliationB "Political affiliation, Form B"
label define affilB 2 "Democrat" 1 "Republican" 3 "Independent" 4 "Other" 
label values affiliationB affilB

//Strong Democrat or Republican
rename q9 strongDem
label var strongDem "Are you a strong Democrat?"
label define strongDem 1 "Strong Democrat" 2 "Not a very strong Democrat" 
label values strongDem strongDem

rename var20 strongRep
label var strongRep "Are you a strong Republican?"
label define strongRep 1 "Strong Republican" 2 "Not a very strong Republican" 
label values strongRep strongRep

//Closer to Democratic Party or Republican Party?
rename bb closerB
label var closerB "Are you closer to the Republican Party or the Democratic Party?"
label define closerB 1 "Republican" 2 "Democrat" 
label values closerB closerB

rename ba closerA
label var closerA "Are you closer to the Democratic Party or the Republican Party?"
label define closerA 2 "Republican" 1 "Democrat" 
label values closerA closerA

//Summarize Party ID

gen pid = .
recode pid (.=1) if strongDem==1
recode pid (.=2) if strongDem==2
recode pid (.=3) if closerB==2|closerA==1
recode pid (.=4) if closerB==1|closerA==2
recode pid (.=5) if strongRep==2
recode pid (.=6) if strongRep==1

label var pid "Party Identification"
label define pid 1 "Strong Democrat" 2 "Not Strong Democrat" 3 "Lean Democrat" 4 "Lean Republican" 5 "Not Strong Republican" 6 "Strong Republican"
label values pid pid


**Pre-Treatment Questions

//Initial Support for Immigration Reform
rename q11 preLetterSupport
label var preLetterSupport "Do you support the new Immigration Reform policy?"
label define support 1 "Strongly support" 2 "Somewhat support" 3 "Somewhat oppose" 4 "Strongly oppose"
label values preLetterSupport support

//Importance of Immigration Reform personally
rename q12 immigrationImportance
label var immigrationImportance "How important is immigration reform?"
label define important 1 "Extremely important" 2 "Very important" 3 "Moderately important" 4 "Slightly important" 5 "Not important at all"
label values immigrationImportance important

//Immigration Status
rename q13 isImmigrant
label var isImmigrant "Immigration status"
label define isImmigrant 1 "Born in the USA" 2 "Immigrated, but US citizen" 3 "Resident, but not US citizen" 4 "None of the above" 
label values isImmigrant isImmigrant

//Color Test 
rename q14_1 choseWhite
label var choseWhite "Chose White: Incorrect"
label values choseWhite yes

rename q14_2 chosePink
label var chosePink "Chose Pink: Incorrect"
label values chosePink yes

rename q14_3 choseBlack
label var choseBlack "Chose Black: Incorrect"
label values choseBlack yes

rename q14_4 choseGreen
label var choseGreen "Chose Green: Correct"
label values choseGreen yes

rename q14_5 choseRed
label var choseRed "Chose Red: Correct"
label values choseRed yes

rename q14_6 choseBlue
label var choseBlue "Chose Blue: Incorrect"
label values choseBlue yes

gen pass_attention = choseGreen==1&choseRed==1

***Letter Questions
 
//Lax or Restrictive Immigration Policy
label define senPosition 1 "Open and lax" 2 "Closed and restrictive"
//A
local a = 1
local b = 1
local x = 1
foreach var of varlist var45 q368 q388 q408 q428 q448 q468 q488 q508 q528 q548 q568 {
	rename `var' senPosition`a'`b'
	label var senPosition`a'`b' "Is the Senator's position open and lax or closed and restrictive?"
	label values senPosition`a'`b' senPosition
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}
//B
local a = 1
local b = 1
local x = 1
foreach var of varlist  q588 q608  q628 q648 q668 q688 q708 q728 q768 q748 q788 q808 {
	rename `var' senPositionB`a'`b'
	label var senPositionB`a'`b' "Is the Senator's position open and lax or closed and restrictive?"
	label values senPositionB`a'`b' senPosition
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}


egen firstsen_position = rowtotal (senPosition11 senPosition12 senPosition13 senPosition14 senPosition15 senPosition16 senPosition21 senPosition22 senPosition23 senPosition24 senPosition25 senPosition26), missing 
label values firstsen_position senPosition

egen secondsen_position = rowtotal (senPositionB11 senPositionB12 senPositionB13 senPositionB14 senPositionB15 senPositionB16 senPositionB21 senPositionB22 senPositionB23 senPositionB24 senPositionB25 senPositionB26), missing 
label values secondsen_position senPositionB

	
//Certainty of Senator's Position
label define certainty 1 "Extremely certain" 2 "Very certain" 3 "Moderately certain" 4 "Slightly certain" 5 "Not certain at all"

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q364 q369 q389 q409 q429 q449 q469 q489 q509 q529 q549 q569 {
	rename `var' certainty`a'`b'
	label var certainty`a'`b' "How certain are you on the the Senator's position concerning immigration?"
	label values certainty`a'`b' certainty
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q589 q609 q629 q649 q669 q689 q709 q729 q769 q749 q789 q809 {
	rename `var' certaintyB`a'`b'
	label var certaintyB`a'`b' "How certain are you on the the Senator's position concerning immigration?"
	label values certaintyB`a'`b' certainty
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_certainty = rowtotal (certainty1* certainty2*), missing 
label values firstsen_certainty certainty

egen secondsen_certainty = rowtotal (certaintyB*), missing 
label values secondsen_certainty certainty


//How Much Do You Agree With the Senator?
label define agree 1 "Strongly agree" 2 "Somewhat agree" 3 "Somewhat disagree" 4 "Strongly disagree"

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist  var48 q371 q391 q411 q431 q451 q471 q491 q511 q531 q551 q571 {
	rename `var' agree`a'`b'
	label var agree`a'`b' "How much do you agree with the Senator?"
	label values agree`a'`b' agree
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q591 q611 q631 q651 q671 q691 q711 q731 q751 q771 q791 q811 {
	rename `var' agreeB`a'`b'
	label var agreeB`a'`b' "How much do you agree with the Senator?"
	label values agreeB`a'`b' agree
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}


egen firstsen_agree = rowtotal (agree1* agree2*), missing 
label values firstsen_agree agree

egen secondsen_agree = rowtotal (agreeB*), missing 
label values secondsen_agree agree



//Did Senator Vote in Favor or Against Immigration Reform?
label define voted 1 "Voted in favor" 2 "Voted against"

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist   q4a q375 q395 q415 q435 q455 q475 q495 q515 q535 q555 q575 {
	rename `var' voted`a'`b'
	label var voted`a'`b' "Do you think the Senator voted for or against immigration reform?"
	label values voted`a'`b' voted
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q595 q615 q635 q655 q675 q695 q715 q735 q755 q775 q795 q815 {
	rename `var' votedB`a'`b'
	label var votedB`a'`b' "Do you think the Senator voted for or against immigration reform?"
	label values votedB`a'`b' voted
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_voted = rowtotal (voted1* voted2*), missing 
label values firstsen_voted voted

egen secondsen_voted = rowtotal (votedB*), missing 
label values secondsen_voted voted


//Opinions of Senator's Character
label define howWell 1 "Extremely well" 2 "Very well" 3 "Moderately well" 4 "Slightly well" 5 "Not well at all"

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q4b q377 q397 q417 q437 q457 q477 q497 q517 q537 q557 q577 {
	rename `var' isHonest`a'`b'
	label var isHonest`a'`b' "How well does the phrase 'he is honest ' describe the Senator?"
	label values isHonest`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q597 q617 q637 q657 q677 q697 q717 q737 q757 q777 q797 q817 {
	rename `var' isHonestB`a'`b'
	label var isHonestB`a'`b' "How well does the phrase 'he is honest ' describe the Senator?"
	label values isHonestB`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}


egen firstsen_honest = rowtotal (isHonest1* isHonest2*), missing 
label values firstsen_honest howWell

egen secondsen_honest = rowtotal (isHonestB*), missing 
label values secondsen_honest howWell

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q4c q378 q398 q418 q438 q458 q478 q498 q518 q538 q558 q578 {
	rename `var' isLeader`a'`b'
	label var isLeader`a'`b' "How well does the phrase 'he is strong leader ' describe the Senator?"
	label values isLeader`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q598 q618 q638 q658 q678 q698 q718 q738 q758 q778 q798 q818 {
	rename `var' isLeaderB`a'`b'
	label var isLeaderB`a'`b' "How well does the phrase 'he is a strong leader ' describe the Senator?"
	label values isLeaderB`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_leader = rowtotal (isLeader1* isLeader2*), missing 
label values firstsen_leader howWell

egen secondsen_leader = rowtotal (isLeaderB*), missing 
label values secondsen_leader howWell

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q4d q379 q399 q419 q439 q459 q479 q499 q519 q539 q559 q579 {
	rename `var' isKnowledgeable`a'`b'
	label var isKnowledgeable`a'`b' "How well does the phrase 'he is knowledgeable' describe the Sanator?"
	label values isKnowledgeable`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q599 q619 q639 q659 q679 q699 q719 q739 q759 q779 q799 q819 {
	rename `var' isKnowledgeableB`a'`b'
	label var isKnowledgeableB`a'`b' "How well does the phrase 'he is knowledgeable' describe the Sanator?"
	label values isKnowledgeableB`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_knowledge = rowtotal (isKnowledgeable1* isKnowledgeable2*), missing 
label values firstsen_knowledge howWell

egen secondsen_knowledge = rowtotal (isKnowledgeableB*), missing 
label values secondsen_knowledge howWell


//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q4e q380 q400 q420 q440 q460 q480 q500 q520 q540 q560 q580 {
	rename `var' isOpenMinded`a'`b'
	label var isOpenMinded`a'`b' "How well does the phrase 'he is Open-Minded' describe the Sanator?"
	label values isOpenMinded`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q600 q620 q640 q660 q680 q700 q720 q740 q760 q780 q800 q820 {
	rename `var' isOpenMindedB`a'`b'
	label var isOpenMindedB`a'`b' "How well does the phrase 'he is Open-Minded' describe the Sanator?"
	label values isOpenMindedB`a'`b' howWell
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}


egen firstsen_openminded = rowtotal (isOpenMinded1* isOpenMinded2*), missing 
label values firstsen_openminded howWell

egen secondsen_openminded = rowtotal (isOpenMindedB*), missing 
label values secondsen_openminded howWell


//How hard is Senator working?
label define howHard 1 "Extremely hard" 2 "Very hard" 3 "Moderately hard" 4 "Slightly hard" 5 "Not hard at all"


//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q5 q382 q402 q422 q442 q462 q482 q502 q522 q542 q562 q582 {
	rename `var' howHard`a'`b'
	label var howHard`a'`b' "How hard is the senator working on the issue of immigration?"
	label values howHard`a'`b' howHard
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q602 q622 q642 q662 q682 q702 q722 q742 q762 q782 q802 q822 {
	rename `var' howHardB`a'`b'
	label var howHardB`a'`b' "How hard is the senator working on the issue of immigration?"
	label values howHardB`a'`b' howHard
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_hardworking = rowtotal (howHard1* howHard2*), missing 
label values firstsen_hardworking howHard

egen secondsen_hardworking = rowtotal (howHardB*), missing 
label values secondsen_hardworking howHard


//Considered Support for Immigration Reform

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q70 q384 q404 q424 q444 q464 q484 q504 q524 q544 q564 q584 {
	rename `var' postLetterSupport`a'`b'
	label var postLetterSupport`a'`b' "Do you (now) support the new Immigration Reform policy?"
	label values postLetterSupport`a'`b' support
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q604 q624 q644 q664 q684 q704 q724 q744 q764 q784 q804 q824 {
	rename `var' postLetterSupportB`a'`b'
	label var postLetterSupportB`a'`b' "Do you (now) support the new Immigration Reform policy?"
	label values postLetterSupportB`a'`b' support
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_postlettersupport = rowtotal (postLetterSupport1* postLetterSupport2*), missing 
label values firstsen_postlettersupport support

egen secondsen_postlettersupport = rowtotal (postLetterSupportB*), missing 
label values secondsen_postlettersupport support


//Senator Liberal or Conservative?
label define howLiberal 1 "Extremely liberal" 2 "Moderately liberal" 3 "Slightly liberal" 4 "Moderate" 5 "Slightly conservative" 6 "Moderately conservative" 7 "Extremely conservative"

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q876 q889 q892 q895 q898 q901 q882 q919 q934 q922 q925 q928 {
	rename `var' howLiberal`a'`b'
	label var howLiberal`a'`b' "Where would you place the senator on a scale from liberal to conservative?"
	label values howLiberal`a'`b' howLiberal
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist  q904 q879  q910 q907  q916 q913  q940 q885 q946 q943 q949 q952 {
	rename `var' howLiberalB`a'`b'
	label var howLiberalB`a'`b' "Where would you place the senator on a scale from liberal to conservative?"
	label values howLiberalB`a'`b' howLiberal
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}


egen firstsen_ideology = rowtotal (howLiberal1* howLiberal2*), missing 
label values firstsen_ideology howLiberal

egen secondsen_ideology = rowtotal (howLiberalB*), missing 
label values secondsen_ideology howLiberal


//Senator feeling thermometer
label define thermometer 1 "Hate" 100 "Love" 50 "Neither hate nor love" 75 "Like" 25 "Dislike" 

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q877_1 q890_1 q893_1 q896_1 q899_1 q902_1 q883_1 q920_1 q935_1 q923_1 q926_1 q929_1   {
	rename `var' howMuchLikeSen`a'`b'
	label var howMuchLikeSen`a'`b' "On a scale from 1-100 how much do you like the senator?"
	label values howMuchLikeSen`a'`b' thermometer
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist q905_1 q880_1  q911_1 q908_1  q917_1 q914_1 q941_1 q886_1 q947_1 q944_1 q950_1 q953_1  {
	rename `var' howMuchLikeSenB`a'`b'
	label var howMuchLikeSenB`a'`b' "On a scale from 1-100 how much do you like the senator?"
	label values howMuchLikeSenB`a'`b' thermometer
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_therm = rowtotal (howMuchLikeSen1* howMuchLikeSen2*), missing 

egen secondsen_therm = rowtotal (howMuchLikeSenB*), missing 


//Vote for Senator?
label define likely 1 "Extremely likely" 2 "Very likely" 3 "Somewhat likely" 4 "Not too likely" 5 "Not likely at all"

//A
local a = 1
local b = 1
local x = 1
foreach var of varlist q878 q891 q894 q897 q900 q903 q884 q921 q936 q924 q927 q930 {
	rename `var' howVoteSen`a'`b'
	label var howVoteSen`a'`b' "How likely are you to vote for the Senator?"
	label values howVoteSen`a'`b' likely
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

//B
local a = 1
local b = 1
local x = 1
foreach var of varlist  q906 q881 q912 q909 q918 q915 q942 q887 q948 q945 q951 q954  {
	rename `var' howVoteSenB`a'`b'
	label var howVoteSenB`a'`b' "How likely are you to vote for the Senator?"
	label values howVoteSenB`a'`b' likely
	if (`b'<6) {
		local ++b
	}
	else {
		local b = 1
	}
	if (`x'>5) {
		local a = 2
	}
	local ++x
	
}

egen firstsen_votefor = rowtotal (howVoteSen1* howVoteSen2*), missing 
label values firstsen_votefor likely

egen secondsen_votefor = rowtotal (howVoteSenB*), missing 
label values secondsen_votefor likely



**Final question - who would you vote for?
rename q349 AorB
label var AorB "Would you vote for Senator A or B?"
label define AorB 1 "A" 2 "B"
label values AorB AorB

save study2replication.dta, replace



