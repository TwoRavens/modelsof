***JOP Wronski, Bankert, Amira,  Johnson, and Levitan****
***Appendix Figures and Tables***

***Table A1 sample characteristics
sum RWA_combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum RWA_combined if Primary_ClintonvsSanderscombined!=. & school!=. & PID01 < 0.5, d
sum RWA_combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5, d

sum Dem_PID_combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum Dem_PID_combined if Primary_ClintonvsSanderscombined!=. & school!=. & PID01 < 0.5, d
sum Dem_PID_combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5, d

sum Ideology_combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum Ideology_combined if Primary_ClintonvsSanderscombined!=. & school!=. & PID01 < 0.5, d
sum Ideology_combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5, d

sum ReligiousAttend_combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum ReligiousAttend_combined if Primary_ClintonvsSanderscombined!=. & school!=. & PID01 < 0.5, d
sum ReligiousAttend_combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5, d

tab Gender_combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5
tab Gender_combined if Primary_ClintonvsSanderscombined!=. & school!=. & PID01 < 0.5
tab Gender_combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5

tab White_combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5
tab White_combined if Primary_ClintonvsSanderscombined!=. & school!=. & PID01 < 0.5
tab White_combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5

sum Education_Combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum Education_Combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party<0.5, d

sum Income if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum Income if Primary_ClintonvsSanderscombined!=. & caseid!=. & party<0.5, d

tab Union_Combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5
tab Union_Combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5

tab Married_Combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5
tab Married_Combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5

sum Age_Combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d
sum Age_Combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party<0.5, d

tab South_Combined if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5
tab South_Combined if Primary_ClintonvsSanderscombined!=. & caseid!=. & party < 0.5

sum NEED_close if Primary_ClintonvsSanderscombined!=. & caseid!=. & party<0.5, d
sum SDO if Primary_ClintonvsSanderscombined!=. & caseid!=. & party<0.5, d
sum Racial if Primary_ClintonvsSanderscombined!=. & caseid!=. & party<0.5, d
sum SymbolRac if Primary_ClintonvsSanderscombined!=. & V101!=. & PID < 0.5, d

tab Primary_ClintonvsSanderscombined if V101!=. & PID < 0.5
tab Primary_ClintonvsSanderscombined if school!=. & PID01 < 0.5
tab Primary_ClintonvsSanderscombined if caseid!=. & party < 0.5

************************************Mean Differences Authoritarianism between Reps and Dems YOUGOV***********************
***Appendix Figures A1a and A1b******

sum auth if pid3 == 1 & caseid != .
sum auth if pid3 == 2 & caseid != .

gen RWA_Dems_YouGov = auth if pid3 == 1 & caseid != .
gen RWA_Reps_YouGov = auth if pid3 == 2 & caseid != .

ttest RWA_Dems_YouGov = RWA_Reps_YouGov, unpaired unequal

***statistically significant difference***

gen PID_Dich_YouGov = 0 if pid3 == 1 
**Dems**
replace PID_Dich_YouGov = 1 if pid3 == 2
**Reps**

univar RWA_Reps_YouGov
univar RWA_Dems_YouGov

************Standard Deviation Test Authoritarianism between Reps and Dems in YouGov**********

sdtest RWA_Reps_YouGov = RWA_Dems_YouGov


***********Mean Differences Authoritarianism between Clinton and Sanders Supporters in YouGov****

sum auth if primary_CvS == 1 & caseid ! = .  & pid3 == 1
sum auth if primary_CvS == 0 & caseid ! = .  & pid3 == 1

gen RWA_Clinton_YouGov = auth if primary_CvS == 1 & caseid ! = .  & pid3 == 1
gen RWA_Sanders_YouGov = auth if primary_CvS == 0 & caseid ! = .  & pid3 == 1

ttest RWA_Clinton_YouGov =   RWA_Sanders_YouGov, unpaired unequal

***statistically sig difference of 0.24***

*****Mean Differences Authoritarianism between Cruz and Trump Supporters in YouGov*******


sum auth if caseid ! = . & PrimYouGovCruzvTrump == 0 &  pid3 == 2
**Trump**
sum auth if caseid ! = . & PrimYouGovCruzvTrump == 1 &  pid3 == 2
**Cruz**

gen RWA_Cruz_YouGov = auth if caseid ! = . & PrimYouGovCruzvTrump == 1 &  pid3 == 2
gen RWA_Trump_YouGov = auth if caseid ! = . & PrimYouGovCruzvTrump == 0 &  pid3 == 2

ttest  RWA_Cruz_YouGov  =  RWA_Trump_YouGov , unpaired unequal

**statistically NO sig. difference***


*********************Mean Differences in Authoritarianism between Democrats and Republicans in STUDENT sample****

sum auth if PID01 < 0.5 & school ! = .
sum auth if PID01 > 0.5 & school ! = .

ttest RWA_Students_Reps  = RWA_Students_Dems, unpaired unequal

***statistically sig. difference***

******************Standard Deviation Test*******

sdtest RWA_Students_Reps = RWA_Students_Dems


*********Mean Difference between Clinton and Sanders Supporters*****

ttest RWA_Students_DemsSanders = RWA_Students_DemsClinton, unpaired unequal

***sig. difference***

*********Mean Difference between Trup and Cruz Supporters****

ttest RWA_Students_Trump = RWA_Students_Cruz, unpaired unequal


***Figure A1a***
graph box auth, over(PID_Dich_YouGov)

***Figure A1b***
graph box auth, over(primary_CvS)

***Figure A2a***
graph box auth, over(revPID_students)

***Figure A2b***
graph box auth if PID01 < 0.5, over(PrimaryHvsS)

***Figure A3a***
graph box RWA if PID > 0.5, over(Primary_TvC)

***Figure A3b***
graph box auth if pid3 ==2, over(PrimYouGovCruzvTrump)

***Figure A3c***
graph box auth if PID01 > 0.5 & school !=  ., over(Primary_CruzvTrump)

***Table A4***
heckprobit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined White_combined Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID < 0.5,  select(Dem_PID_combined Age_Combined Gender_combined White_combined)
heckprobit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined White_combined Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined NEED_close SDO Racial  if caseid !=. ,select(Dem_PID_combined Age_Combined Gender_combined White_combined)
heckprobit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined White_combined   if school !=. & PID01 < 0.5 ,select(Dem_PID_combined Gender_combined White_combined)

***Table A5***
logit Primary_ClintonvsSanderscombined RWA_combined  ReligiousAttend_combined Gender_combined White_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID < 0.5, robust
logit Primary_ClintonvsSanderscombined RWA_combined  ReligiousAttend_combined Gender_combined White_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined NEED_close SDO Racial  if caseid !=. , robust
logit Primary_ClintonvsSanderscombined RWA_combined  ReligiousAttend_combined Gender_combined White_combined   if school !=. & PID01 < 0.5, robust

***Table A6***
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined SymbolRac ReligiousAttend_combined Gender_combined White_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID < 0.5, robust
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined Gender_combined White_combined  if school !=. & PID01 < 0.5, robust

***Table A7a****
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID < 0.5 & White_combined == 1, robust
estimates store CCES_White
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined if school !=. & PID01 < 0.5 & White_combined   == 1, robust
estimates store Students_White
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined NEED_close SDO Racial  if caseid !=. & White_combined == 1 , robust
estimates store YouGov_White

***Table A7b****
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID < 0.5 & White_combined == 0, robust
estimates store CCES_NonWhite
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined if school !=. & PID01 < 0.5 & White_combined   == 0, robust
estimates store Students_NonWhite
logit Primary_ClintonvsSanderscombined RWA_combined Dem_PID_combined Ideology_combined ReligiousAttend_combined Gender_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined NEED_close SDO Racial  if caseid !=. & White_combined == 0 , robust
estimates store YouGov_NonWhite

***Table A8***
logit Primary_CruzvTrump RWA_combined Rep_PID_combined Ideology_combined ReligiousAttend_combined  White_combined Gender_combined Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined if V101 !=.  & PID > 0.5, robust
estimates store CCES_Rep
logit Primary_CruzvTrump RWA_combined Rep_PID_combined Ideology_combined ReligiousAttend_combined White_combined  Gender_combined if school !=. & PID01 > 0.5, robust
estimates store Students_Rep
logit Primary_CruzvTrump RWA_combined Rep_PID_combined Ideology_combined ReligiousAttend_combined  White_combined  Gender_combined  Education_Combined Income Union_Combined Married_Combined Age_Combined South_Combined NEED_close SDO Racial  if caseid !=. , robust
estimates store YouGov_Rep

***Figure A4***
coefplot CCES_White CCES_NonWhite || YouGov_White YouGov_NonWhite || Students_White Students_NonWhite ,drop(_cons) xline(0) byopts(row(1))

***Figure A5***
coefplot CCES_Rep || YouGov_Rep ||  Students_Rep || ,drop(_cons) xline(0) byopts(row(1))






