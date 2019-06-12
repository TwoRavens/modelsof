use "GibsonNelsonData.dta", clear

**Model Presented in Body of Paper (Table 1)
reg scsupx IDEODIF2 SCJOB2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 [aw=weights],  beta
estimates store t1

**Table D.2
reg scsupx IDEODIF2 SCJOB2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 [aw=weights],  beta
estimates store t1
reg scsupx IDEODIF2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 if haveSCJOB2==1 [aw=weights],  beta
estimates store t1noPS
estout t1 t1noPS, stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f)) cells(b(star fmt(%8.2f))  se(par fmt(%8.2f)))  varlabels(IDEODIF2 "Ideological Disagreement" SCJOB2 "Job Performance Satisfaction" rlawx "Support for the Rule of Law" tolx "Political Tolerance" orderx "Support for Liberty over Order" SCKNOWX5 "Court Knowledge" partyid "Party Identification" age "Age" hispanic "Hispanic" black "African American" degree "Level of Education" gender "Gender" ownhomed "Social Class (Home Ownership)" attend "Church Attendance" BAGAIN2 "Whether Born Again" _cons "Intercept" aboutright "Subjective Ideological Agreement" knowXideology "Court Knowledge x Ideological Disagreement" polviews01 "Respondent Ideology" scideo01 "Supreme Court Ideology" ideoInteract "Respondent Ideology x Supreme Court Ideology" strongAgreement "Strong Agreement" tacitAgreement "Tacit Agreement" moderateDisagreement "Moderate Disagreement" strongDisagreement "Strong Disagreement") varwidth(50)


**Table E.1
replace SCLIB2=. if SCLIB2==8
replace SCLIB2=. if SCLIB2==9
gen aboutright=SCLIB2
replace aboutright=0 if aboutright==1
replace aboutright=0 if aboutright==3
replace aboutright=1 if aboutright==2
reg scsupx aboutright SCJOB2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 [aw=weights],  beta
estimates store te1

**Table E.1 (No performance satisfaction)
reg scsupx aboutright rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 if haveSCJOB2==1 [aw=weights],  beta
estimates store te1noPS

estout te1 te1noPS, stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f)) cells(b(star fmt(%8.2f))  se(par fmt(%8.2f)))  varlabels(IDEODIF2 "Ideological Disagreement" SCJOB2 "Job Performance Satisfaction" rlawx "Support for the Rule of Law" tolx "Political Tolerance" orderx "Support for Liberty over Order" SCKNOWX5 "Court Knowledge" partyid "Party Identification" age "Age" hispanic "Hispanic" black "African American" degree "Level of Education" gender "Gender" ownhomed "Social Class (Home Ownership)" attend "Church Attendance" BAGAIN2 "Whether Born Again" _cons "Intercept" aboutright "Subjective Ideological Agreement" knowXideology "Court Knowledge x Ideological Disagreement" polviews01 "Respondent Ideology" scideo01 "Supreme Court Ideology" ideoInteract "Respondent Ideology x Supreme Court Ideology" strongAgreement "Strong Agreement" tacitAgreement "Tacit Agreement" moderateDisagreement "Moderate Disagreement" strongDisagreement "Strong Disagreement") varwidth(50)


*Table E.2
su SCIDEO2, meanonly 
gen scideo01 = (SCIDEO2 - r(min)) / (r(max) - r(min)) 
su polviews, meanonly 
gen polviews01 = (polviews - r(min)) / (r(max) - r(min))
gen ideoInteract=scideo01*polviews01
reg scsupx scideo01 polviews01 ideoInteract SCJOB2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 [aw=weights],  beta
estimates store te2

*Table E.2 (No performance satisfaction)
reg scsupx scideo01 polviews01 ideoInteract rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 if haveSCJOB2==1 [aw=weights],  beta
estimates store te2noPS

estout te2 te2noPS, stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f)) cells(b(star fmt(%8.2f))  se(par fmt(%8.2f)))  varlabels(IDEODIF2 "Ideological Disagreement" SCJOB2 "Job Performance Satisfaction" rlawx "Support for the Rule of Law" tolx "Political Tolerance" orderx "Support for Liberty over Order" SCKNOWX5 "Court Knowledge" partyid "Party Identification" age "Age" hispanic "Hispanic" black "African American" degree "Level of Education" gender "Gender" ownhomed "Social Class (Home Ownership)" attend "Church Attendance" BAGAIN2 "Whether Born Again" _cons "Intercept" aboutright "Subjective Ideological Agreement" knowXideology "Court Knowledge x Ideological Disagreement" polviews01 "Respondent Ideology" scideo01 "Supreme Court Ideology" ideoInteract "Respondent Ideology x Supreme Court Ideology" strongAgreement "Strong Agreement" tacitAgreement "Tacit Agreement" moderateDisagreement "Moderate Disagreement" strongDisagreement "Strong Disagreement") varwidth(50)


*Table E.4
table ideo SCLIB2
gen strongAgreement=0
replace strongAgreement=1 if ideo==1&SCLIB2==2
replace strongAgreement=1 if ideo==2&SCLIB2==2
replace strongAgreement=1 if ideo==3&SCLIB2==2
gen tacitAgreement=0
replace tacitAgreement=1 if ideo==1&SCLIB2==1
replace tacitAgreement=1 if ideo==3&SCLIB2==3
gen moderateDisagreement=0
replace moderateDisagreement=1 if ideo==2&SCLIB2==1
replace moderateDisagreement=1 if ideo==2&SCLIB2==3
gen strongDisagreement=0
replace strongDisagreement=1 if ideo==1&SCLIB2==3
replace strongDisagreement=1 if ideo==3&SCLIB2==1
gen sumBJNominal=strongAgreement+tacitAgreement+moderateDisagreement+strongDisagreement
replace strongAgreement=. if sumBJNominal==0
replace tacitAgreement=. if sumBJNominal==0
replace moderateDisagreement=. if sumBJNominal==0
replace strongDisagreement=. if sumBJNominal==0
reg scsupx tacitAgreement moderateDisagreement strongDisagreement SCJOB2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 [aw=weights],  beta
estimates store te4

*Table E.4 (No performance satisfaction)
reg scsupx tacitAgreement moderateDisagreement strongDisagreement rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 if haveSCJOB2==1 [aw=weights],  beta
estimates store te4noPS

estout te4 te4noPS, stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f)) cells(b(star fmt(%8.2f))  se(par fmt(%8.2f)))  varlabels(IDEODIF2 "Ideological Disagreement" SCJOB2 "Job Performance Satisfaction" rlawx "Support for the Rule of Law" tolx "Political Tolerance" orderx "Support for Liberty over Order" SCKNOWX5 "Court Knowledge" partyid "Party Identification" age "Age" hispanic "Hispanic" black "African American" degree "Level of Education" gender "Gender" ownhomed "Social Class (Home Ownership)" attend "Church Attendance" BAGAIN2 "Whether Born Again" _cons "Intercept" aboutright "Subjective Ideological Agreement" knowXideology "Court Knowledge x Ideological Disagreement" polviews01 "Respondent Ideology" scideo01 "Supreme Court Ideology" ideoInteract "Respondent Ideology x Supreme Court Ideology" strongAgreement "Strong Agreement" tacitAgreement "Tacit Agreement" moderateDisagreement "Moderate Disagreement" strongDisagreement "Strong Disagreement") varwidth(50)


**Table E.5
gen knowXideology=SCKNOWX5*IDEODIF2
reg scsupx IDEODIF2 knowXideology SCJOB2 rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 [aw=weights],  beta
estimates store te5

**Table E.5 (No performance satisfaction)
reg scsupx IDEODIF2 knowXideology rlawx tolx orderx SCKNOWX5 partyid age hispanic black degree gender ownhomed attend BAGAIN2 if haveSCJOB2==1 [aw=weights],  beta
estimates store te5noPS

estout te5 te5noPS, stats(N r2 r2_a, fmt(%9.0f %9.3f %9.3f)) cells(b(star fmt(%8.2f))  se(par fmt(%8.2f)))  varlabels(IDEODIF2 "Ideological Disagreement" SCJOB2 "Job Performance Satisfaction" rlawx "Support for the Rule of Law" tolx "Political Tolerance" orderx "Support for Liberty over Order" SCKNOWX5 "Court Knowledge" partyid "Party Identification" age "Age" hispanic "Hispanic" black "African American" degree "Level of Education" gender "Gender" ownhomed "Social Class (Home Ownership)" attend "Church Attendance" BAGAIN2 "Whether Born Again" _cons "Intercept" aboutright "Subjective Ideological Agreement" knowXideology "Court Knowledge x Ideological Disagreement" polviews01 "Respondent Ideology" scideo01 "Supreme Court Ideology" ideoInteract "Respondent Ideology x Supreme Court Ideology" strongAgreement "Strong Agreement" tacitAgreement "Tacit Agreement" moderateDisagreement "Moderate Disagreement" strongDisagreement "Strong Disagreement") varwidth(50)
