//Change directory to location of file
use "INSERT DIRECTORY PATH HERE", clear

//t-test for comment bias manipulation check
ttest bias_poster, by(plainlib)
ttest bias_poster, by(plaincon)

//TABLE 3 - Trustworthiness analyses (positive values indicate more trustworthiness)
reg trust_outlet plain lib con
reg trust_poster plain lib con
reg trust_poll plain lib con

reg trust_outlet plain lib con nfc nfa knowledge age male white educ income party 
reg trust_poster plain lib con nfc nfa knowledge age male white educ income party
reg trust_poll plain lib con nfc nfa knowledge age male white educ income party

//TABLE 4 - Perceived flaws of survey
tab more_rep treatment, col
tab more_dem treatment, col
tab inaccurate treatment, col
tab funded_libs treatment, col
tab dk treatment, col

//FIGURE 2 - Misinformation by treatment group
prtest dv36, by(plainlib)
prtest dv36, by(plaincon)

prtest dv23, by(plainlib)
prtest dv23, by(plaincon)

prtest dv49, by(plainlib)
prtest dv49, by(plaincon)

//Motivated reasoning analysis (H4)
//selectedMisinformation: 1 if selected poll number cited in misinformative commentary, 0 otherwise
//exposure: 1 if exposed to pro-attitudinal poll number, 0 if exposed to counter-attitudinal poll number
prtest selectedMisinformation,by(exposure)

//APPENDIX A1 - Descriptive stats
sum nfc
sum nfa
sum knowledge
sum age
sum male
sum white
sum democrat
tab education
tab income

//APPENDIX A2 - Balance tests
ttest nfc,by(fullplain)
ttest nfc,by(fulllib)
ttest nfc,by(fullcon)
ttest nfc,by(plainlib)
ttest nfc,by(plaincon)

ttest nfa,by(fullplain)
ttest nfa,by(fulllib)
ttest nfa,by(fullcon)
ttest nfa,by(plainlib)
ttest nfa,by(plaincon)

ttest knowledge,by(fullplain)
ttest knowledge,by(fulllib)
ttest knowledge,by(fullcon)
ttest knowledge,by(plainlib)
ttest knowledge,by(plaincon)

ttest age,by(fullplain)
ttest age,by(fulllib)
ttest age,by(fullcon)
ttest age,by(plainlib)
ttest age,by(plaincon)

ttest educ,by(fullplain)
ttest educ,by(fulllib)
ttest educ,by(fullcon)
ttest educ,by(plainlib)
ttest educ,by(plaincon)

prtest democrat,by(fullplain)
prtest democrat,by(fulllib)
prtest democrat,by(fullcon)
prtest democrat,by(plainlib)
prtest democrat,by(plaincon)

prtest male,by(fullplain)
prtest male,by(fulllib)
prtest male,by(fullcon)
prtest male,by(plainlib)
prtest male,by(plaincon)

ttest income,by(fullplain)
ttest income,by(fulllib)
ttest income,by(fullcon)
ttest income,by(plainlib)
ttest income,by(plaincon)

logit full nfc nfa knowledge age educ democrat male income
logit plain nfc nfa knowledge age educ democrat male income
logit lib nfc nfa knowledge age educ democrat male income
logit con nfc nfa knowledge age educ democrat male income

//APPENDIX A3 - Perceived flaws of survey
logit inaccurate lib con plain 
logit more_rep lib con plain  
logit more_dem lib con plain  
logit dk lib con plain  

logit inaccurate plain lib con nfc nfa knowledge age male white educ income party
logit more_rep plain lib con nfc nfa knowledge age male white educ income party
logit more_dem plain lib con nfc nfa knowledge age male white educ income party
logit dk plain lib con nfc nfa knowledge age male white educ income party

//APPENDIX A4 - Treatment Effects on Likelihood of Selecting Approval Ratings
//NOTE: because no control group, constant term = full article condition
logit dv23 plain lib con 
logit dv36 plain lib con 
logit dv49 plain lib con

logit dv23 plain lib con trust_poster trust_outlet trust_poll nfc nfa knowledge age male white educ income party
logit dv36 plain lib con trust_poster trust_outlet trust_poll nfc nfa knowledge age male white educ income party
logit dv49 plain lib con trust_poster trust_outlet trust_poll nfc nfa knowledge age male white educ income party

