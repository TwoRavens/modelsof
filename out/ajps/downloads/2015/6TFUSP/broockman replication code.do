use "~/Documents/Docs/research/In Progress/MD Poll Exp/FINAL DATASET/broockman_maryland.dta", clearset more off/*Guide to variables

*Subject attributes
black
dem
female
*Treatment
treat_blackleg
treat_samerace
*Outcome
agreed_to_survey
*Census Block Group Attributes
totalpop
urbanpop
whitepop
blackpop
hispanicpop
whites_medianhhincom
blacks_medianhhincom
blackpercent
urbanpercent
*District Attributes
districtno
yearelected
*Legislator Name
legname
*Subject Vote History
voted2008p
voted2008g
voted2010p
voted2010g
voterbase_age
voterbase_gender
voterbase_race
vf_g2010
vf_p2010
vf_g2008
vf_p2008
vf_g2006
vf_p2006
vf_g2004
vf_p2004
vf_g2002
vf_p2002
vf_g2000
vf_p2000
vf_pp2000
vf_pp2004
vf_pp2008
*Census Tract Info
Census_Tracts__geoid
Census_Tracts__sumlevel
Census_Tracts__geoname
Census_Tracts__totalpop
Census_Tracts__urbanpop
Census_Tracts__whitepop
Census_Tracts__blackpop
Census_Tracts__hispanicpop
Census_Tracts__whites_medianhhin
Census_Tracts__blacks_medianhhin
Census_Tracts__blackpercent
Census_Tracts__urbanpercent

*/tab black agreed_to_survey, ro**Table 1 - Main Findingsreg agreed_to_survey treat_samerace, robustreg agreed_to_survey treat_samerace if black, robustreg agreed_to_survey treat_samerace dem voted2010p voted2010g urbanpercent blackpercent blacks_medianhhincom if black, robustxi: reg agreed_to_survey treat_samerace dem voted2010p voted2010g urbanpercent blackpercent blacks_medianhhincom i.districtno if black, robustreg agreed_to_survey treat_samerace if black == 0, robustreg agreed_to_survey treat_samerace dem voted2010p voted2010g urbanpercent blackpercent whites_medianhhincom if black == 0, robustxi: reg agreed_to_survey treat_samerace dem voted2010p voted2010g urbanpercent blackpercent whites_medianhhincom i.districtno if black == 0, robust*As discussed in text; overall differences and that results consistent when clusteringreg agreed_to_survey treat_samerace, cl(legname)reg agreed_to_survey treat_samerace if black == 0, cl(legname)reg agreed_to_survey treat_samerace if black == 1, cl(legname)encode legname, gen(legname_encoded)xtset legname_encodedxtreg agreed_to_survey treat_samerace, robustxtreg agreed_to_survey treat_samerace if black == 0, robustxtreg agreed_to_survey treat_samerace if black == 1, robust**Table 2 - Predictors of Communication To White and Descriptive Representativesgen medianhhinc = blacks_medianhhincom if black == 1replace medianhhinc = whites_medianhhincom if black == 0reg agreed_to_survey black if treat_blackleg == 0, robustreg agreed_to_survey black if treat_samerace, robustreg agreed_to_survey black dem voted2010p voted2010g urbanpercent blackpercent medianhhinc if treat_samerace, robustxi: reg agreed_to_survey black dem voted2010p voted2010g urbanpercent blackpercent medianhhinc i.districtno if treat_samerace, robust**Table 3 - Heterogenous Effectsgen treatsameraceXblackpercent = treat_samerace * blackpercentreg agreed_to_survey treat_samerace treatsameraceXblackpercent blackpercent, robustgen treatXvoted2010p = treat_samerace * voted2010pgen treat_sameraceXblackhh = treat_samerace * blacks_medianhhincomxi: reg agreed_to_survey treat_samerace treatsameraceXblackpercent treatXvoted2010p treat_sameraceXblackhh blackpercent voted2010g voted2010p dem blacks_medianhhincom urbanpercent i.districtno, robustreg agreed_to_survey treat_samerace treatsameraceXblackpercent blackpercent if black == 1, robustxi: reg agreed_to_survey treat_samerace treatsameraceXblackpercent treatXvoted2010p treat_sameraceXblackhh blackpercent voted2010g voted2010p dem blacks_medianhhincom urbanpercent i.districtno if black == 1, robustreg agreed_to_survey treat_samerace blackpercent treatsameraceXblackpercent if black == 0, robustxi: reg agreed_to_survey treat_samerace treatsameraceXblackpercent treatXvoted2010p treat_sameraceXblackhh blackpercent voted2010g voted2010p dem blacks_medianhhincom urbanpercent i.districtno if black == 0, robust