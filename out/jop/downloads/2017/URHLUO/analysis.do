clear all
cd ""

use final-data.dta, replace

/*Variable Coding
id - Unique ID of official
email_cluster - ID of Gmail account used for treatment
treat - 0 = mail sender; 1 = female sender
latino_email - 0 = non-Latinx sender; 1 = Latinx sender
latino_gender - 0 = non-Latinx male sender; 1 = non-Latinx female sender; 2 = Latino male sender; 3 = Latina female sender
female - 0 = official is male; 1 = official is female
local  - 0 = official is not a local official; 1 = official is a local official
democrat - 0 = official is not a Democratic official; 1 = official is a Democratic official
republican - 0 = official is not a Republican official; 1 = official is a Republican official
white - 0 = official is not a white official; 1 = official is a white official
strata - gender/state of legislator strata ID
male_coder - 0 = coder was female; 1 = coder was male; missing if no coder because no reply received
bounce - 1 if bounceback received; 0 otherwise
real_content - 1 if qualitative assessment by coder that the email contains real content; 0 otherwise
offers_help - 1 if coded as willing to meet, to talk on the phone, to email further, or a general offer to follow-up; 0 otherwise
praises - 1 if coded as either “Praises student for an interest in a political career” or a vague praises (e.g., “Good luck with everything”, “hope this helps”); 0 otherwise
warnings - 1 if coded as containing an explicit statement not to run, an encouragement to consider other career paths, or a warning of time commitment, work-life balance challenges, the difficultly of finding time for family, the challenges of fundraising, or the loss of privacy; 0 otherwise
email_received - 1 if any non-bounceback received; 0 otherwise
character - character count of email received; 0 if no email received
log_count - log of word count of email received; log(1) = 0 if no email received
any_advice - 1 if coded as containing either practical advice (e.g., motivational advice, get a business job, go to law school, get a different type of job, become involved in local community groups, attend local party or political meetings, volunteer, get a mentor, fundraising advice, run for student government, learn about the issues, get a good education, always put your values first, stay loyal to your political party) or personality/image advice (e.g., always have a professional appearance, have thick skin, learn to be extroverted, learn to deal with conflict); 0 otherwise
*/
 

//Table 1:Treatment Effects by Dependent Variable
//Row 1: Emails sent by condition
tab treat
//Results
//_subpop_1: treat = Male Pers
//_subpop_2: treat = Female Pers
//p-value calculated from the regression.
foreach var of varlist email_received real_content praises offers_help warnings any_advice log_count character {
	mean `var', over(treat)
	areg `var' i.treat, a(strata) cluster(email_cluster)	
}

//Table OA1: Experimental Balance
tabstat female democrat republican local white bounce, by(treat) format(%5.0g)
tab treat

//Table OA3: Details of Coding Classifications, by Gender of Coder
foreach var of varlist real_content praises offers_help warnings any_advice {
	mean `var', over(male_coder)
	reg `var' i.(male_coder), cluster(email_cluster)
}
tab male_coder

//Table OA4: Experimental Results by Gender of Legislator and Gender of Sender
foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	bysort female: tab `var' treat, col chi2
	bysort female: areg `var' i.treat, a(strata) cluster(email_cluster)
}
foreach var of varlist log_count character {
	mean `var', over(treat female)
	bysort female: areg `var' i.treat, a(strata) cluster(email_cluster)
}
tab treat female

//Table OA5: Experimental Results by Party of Legislator and Gender of Sender.
foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	tab `var' treat if democrat == 1, col chi2
	areg `var' i.treat if democrat == 1, a(strata) cluster(email_cluster)
}
foreach var of varlist log_count character {
	mean `var' if democrat == 1, over(treat)
	areg `var' i.treat if democrat == 1, a(strata) cluster(email_cluster)
}
tab treat if democrat == 1

foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	tab `var' treat if republican == 1, col chi2
	areg `var' i.treat if republican == 1, a(strata) cluster(email_cluster)
}
foreach var of varlist log_count character {
	mean `var' if republican == 1, over(treat)
	areg `var' i.treat if republican == 1, a(strata) cluster(email_cluster)
}
tab treat if republican == 1

//Table OA6: Experimental Results by Office Level of Legislator and Gender of Sender.
foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	tab `var' treat if local == 1, col chi2
	areg `var' i.treat if local == 1, a(strata) cluster(email_cluster)
}
foreach var of varlist log_count character {
	mean `var' if local == 1, over(treat)
	areg `var' i.treat if local == 1, a(strata) cluster(email_cluster)
}
tab treat if local == 1

foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	tab `var' treat if local == 0, col chi2
	areg `var' i.treat if local == 0, a(strata) cluster(email_cluster)
}
foreach var of varlist log_count character {
	mean `var' if local == 0, over(treat)
	areg `var' i.treat if local == 0, a(strata) cluster(email_cluster)
}
tab treat if local == 0

//Table OA7: Experimental Results by Latinx Sender.
foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	tab `var' latino_email, col chi2
	areg `var' i.latino_email, a(strata) cluster(email_cluster)
}
foreach var of varlist log_count character {
	mean `var', over(latino_email)
	areg `var' i.latino_email, a(strata) cluster(email_cluster)
}
tab latino_email

//Table OA8: Experimental Results by Latinx and Gender of Sender.
foreach var of varlist email_received real_content praises offers_help warnings any_advice {
	tab `var' latino_gender, col chi2
	areg `var' i.latino_gender, a(strata) cluster(email_cluster)
	test 0.latino_gender = 2.latino_gender
	test 1.latino_gender = 3.latino_gender
}
foreach var of varlist log_count character {
	mean `var', over(latino_gender)
	areg `var' i.latino_gender, a(strata) cluster(email_cluster)
	test 0.latino_gender = 2.latino_gender
	test 1.latino_gender = 3.latino_gender
}
count if latino_gender == 0 //Male Non-Latino Sender
count if latino_gender == 2 //Male Latino Sender
count if latino_gender == 1 //Female Non-Latina Sender
count if latino_gender == 3 //Female Latina Sender

