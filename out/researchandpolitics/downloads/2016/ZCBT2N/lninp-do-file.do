/////The following do file runs on the lninp-dataset.dta dataset that includes EVS variables and all country-level variables merged from other datasets (see Tables B1 and B2 in Appendix B in Supplementary material) 

///Cleaning the data and definining variables

///destring WGI variables
destring politicalstability, replace
destring govteffectiveness, replace
destring ruleoflaw , replace
destring controlofcorruption , replace
destring voiceandaccountability , replace

///employed dummy = 1 if employed, = 0 otherwise 
codebook v89
generate employed = 0
replace employed = 1 if v89 ==1
replace employed = . if v89 ==.d
replace employed = . if v89 ==.e
replace employed = . if v89 ==.a

///unemployed dummy = 1 if unemployed, = 0 otherwise 
generate unemployed = .
replace unemployed = 1 if v89 ==2
replace unemployed = 0 if v89 ==1
replace unemployed = . if v89 ==.d
replace unemployed = . if v89 ==.e
replace unemployed = . if v89 ==.a

///dummy for experienced prolonged unemployment
generate unemployment_experience=.
replace unemployment_experience=1 if v349==1
replace unemployment_experience=0 if v349==2

///dummy for experienced dependence on social security
generate socialsec_dependence=.
replace socialsec_dependence=1 if v351==1
replace socialsec_dependence=0 if v351==2

///dummy for religiosity = 1 if person is religious, 0 if person is not religious or convinced atheist
codebook v114
generate religious = 0
replace religious = 1 if v114 ==1
replace religious = . if v114 ==.b
replace religious = . if v114 ==.d
replace religious = . if v114 ==.e
replace religious = . if v114 ==.a

///confidence in government variable where 1 = none at all, 4 = a great deal
codebook v222
generate confidenceGovt = 5 - v222

generate confGovt1=.
replace confGovt1=1 if confidenceGovt==1
replace confGovt1=0 if (confidenceGovt!=1)&(confidenceGovt!=.)

generate confGovt2=.
replace confGovt2=1 if confidenceGovt==2
replace confGovt2=0 if (confidenceGovt!=2)&(confidenceGovt!=.)

generate confGovt3=.
replace confGovt3=1 if confidenceGovt==3
replace confGovt3=0 if (confidenceGovt!=3)&(confidenceGovt!=.)

generate confGovt4=.
replace confGovt4=1 if confidenceGovt==4
replace confGovt4=0 if (confidenceGovt!=4)&(confidenceGovt!=.)

///dummy if person is citizen of the country
codebook v255
generate citizen = 0
replace citizen = 1 if v255 ==1
replace citizen = . if v255 ==.a
replace citizen = . if v255 ==.d
replace citizen = . if v255 ==.e

///national pride variable (cardinal)
codebook v256
generate nationalPride = 5 - v256

///gender dummy (male = 1 if male, 0 if female)
codebook v302
generate male = 0
replace male = 1 if v302 ==1
replace male = . if v302 ==.a
replace male = . if v302 ==.d

///age cohort dummies 
replace age = . if age ==.b
replace age = . if age ==.c
replace age = . if age ==.d
replace age = . if age ==.e

generate age_less19 = 0
replace age_less19 = 1 if age <20
replace age_less19 = . if age == .

generate age_20to29 = 0
replace age_20to29 =  1 if age > 19 & age <30
replace age_20to29 = . if age ==.

generate age_30to39 = 0
replace age_30to39 =  1 if age > 29 & age <40
replace age_30to39 = . if age ==.

generate age_40to49 = 0
replace age_40to49 =  1 if age > 39 & age <50
replace age_40to49 = . if age ==.

generate age_50to59 = 0
replace age_50to59 =  1 if age > 49 & age <60
replace age_50to59 = . if age ==.

generate age_60to69 = 0
replace age_60to69 =  1 if age > 59 & age <70
replace age_60to69 = . if age ==.

generate age_70to79 = 0
replace age_70to79 =  1 if age > 69 & age <80
replace age_70to79 = . if age ==.

generate age_79above = 0
replace age_79above =  1 if age > 79
replace age_79above = . if age ==.

///marital status dummy = 1 if married or in registered partnership
generate marital_status = 0
replace marital_status = 1 if v313 ==1
replace marital_status = 1 if v313 ==2
replace marital_status = . if v313 ==.a
replace marital_status = . if v313 ==.d
replace marital_status = . if v313 ==.e

///children dummy 
generate children_dummy = 0
replace children_dummy = 1 if v321 >0
replace children_dummy= . if v321 ==.a
replace children_dummy= . if v321 ==.b
replace children_dummy= . if v321 ==.c
replace children_dummy= . if v321 ==.d
replace children_dummy= . if v321 ==.e

///educational attainment
rename v336 education
replace education = . if education ==.a
replace education = . if education ==.d
replace education = . if education ==.e

generate educ0=.
replace educ0=1 if education==0
replace educ0=0 if (education!=0)&(education!=.)

generate educ1=.
replace educ1=1 if education==1
replace educ1=0 if (education!=1)&(education!=.)

generate educ2=.
replace educ2=1 if education==2
replace educ2=0 if (education!=2)&(education!=.)

generate educ3=.
replace educ3=1 if education==3
replace educ3=0 if (education!=3)&(education!=.)

generate educ4=.
replace educ4=1 if education==4
replace educ4=0 if (education!=4)&(education!=.)

generate educ5=.
replace educ5=1 if education==5
replace educ5=0 if (education!=5)&(education!=.)

generate educ6=.
replace educ6=1 if education==6
replace educ6=0 if (education!=6)&(education!=.)

///annual household income; 1 = less than 1800 euros, 2 = 1800 to 3600 euros, ..., 12 = 120000 euros or more (income after taxes and deductions) 
rename v353YR annual_hhincome
replace annual_hhincome = . if annual_hhincome ==.a
replace annual_hhincome = . if annual_hhincome ==.b
replace annual_hhincome = . if annual_hhincome ==.c
replace annual_hhincome = . if annual_hhincome ==.d
replace annual_hhincome = . if annual_hhincome ==.e

generate ahhinc1=.
replace ahhinc1=1 if annual_hhincome==1
replace ahhinc1=0 if (annual_hhincome!=1)&(annual_hhincome!=.)

generate ahhinc2=.
replace ahhinc2=1 if annual_hhincome==2
replace ahhinc2=0 if (annual_hhincome!=2)&(annual_hhincome!=.)

generate ahhinc3=.
replace ahhinc3=1 if annual_hhincome==3
replace ahhinc3=0 if (annual_hhincome!=3)&(annual_hhincome!=.)

generate ahhinc4=.
replace ahhinc4=1 if annual_hhincome==4
replace ahhinc4=0 if (annual_hhincome!=4)&(annual_hhincome!=.)

generate ahhinc5=.
replace ahhinc5=1 if annual_hhincome==5
replace ahhinc5=0 if (annual_hhincome!=5)&(annual_hhincome!=.)

generate ahhinc6=.
replace ahhinc6=1 if annual_hhincome==6
replace ahhinc6=0 if (annual_hhincome!=6)&(annual_hhincome!=.)

generate ahhinc7=.
replace ahhinc7=1 if annual_hhincome==7
replace ahhinc7=0 if (annual_hhincome!=7)&(annual_hhincome!=.)

generate ahhinc8=.
replace ahhinc8=1 if annual_hhincome==8
replace ahhinc8=0 if (annual_hhincome!=8)&(annual_hhincome!=.)

generate ahhinc9=.
replace ahhinc9=1 if annual_hhincome==9
replace ahhinc9=0 if (annual_hhincome!=9)&(annual_hhincome!=.)

generate ahhinc10=.
replace ahhinc10=1 if annual_hhincome==10
replace ahhinc10=0 if (annual_hhincome!=10)&(annual_hhincome!=.)

generate ahhinc11=.
replace ahhinc11=1 if annual_hhincome==11
replace ahhinc11=0 if (annual_hhincome!=11)&(annual_hhincome!=.)

generate ahhinc12=.
replace ahhinc12=1 if annual_hhincome==12
replace ahhinc12=0 if (annual_hhincome!=12)&(annual_hhincome!=.)

///interest in politics
generate interest_politics = 5 - v186
replace interest_politics = . if interest_politics ==.a
replace interest_politics = . if interest_politics ==.d
replace interest_politics = . if interest_politics ==.e

generate interest_politics1 = .
replace interest_politics1=1 if interest_politics==1
replace interest_politics1=0 if (interest_politics!=1)&(interest_politics!=.)

generate interest_politics2 = .
replace interest_politics2=1 if interest_politics==2
replace interest_politics2=0 if (interest_politics!=2)&(interest_politics!=.)

generate interest_politics3 = .
replace interest_politics3=1 if interest_politics==3
replace interest_politics3=0 if (interest_politics!=3)&(interest_politics!=.)

generate interest_politics4 = .
replace interest_politics4=1 if interest_politics==4
replace interest_politics4=0 if (interest_politics!=4)&(interest_politics!=.)

///political scale dummies, original variable 1 = left, 10 = right
rename v193 politicalScale
replace politicalScale = . if politicalScale ==.a
replace politicalScale = . if politicalScale ==.d
replace politicalScale = . if politicalScale ==.e

generate left_polscale = 0
replace left_polscale = 1 if politicalScale ==1
replace left_polscale = 1 if politicalScale ==2
replace left_polscale = 1 if politicalScale ==3
replace left_polscale = . if politicalScale ==.

generate center_polscale = 0
replace center_polscale = 1 if politicalScale ==4
replace center_polscale = 1 if politicalScale ==5
replace center_polscale = 1 if politicalScale ==6
replace center_polscale = 1 if politicalScale ==7
replace center_polscale = . if politicalScale ==.

generate right_polscale = 0
replace right_polscale = 1 if politicalScale ==8
replace right_polscale = 1 if politicalScale ==9
replace right_polscale = 1 if politicalScale ==10
replace right_polscale = . if politicalScale ==.

///voting 
generate voting = 0
replace voting = 1 if v263 ==1
replace voting = . if v263 ==.a
replace voting = . if v263 ==.b
replace voting = . if v263 ==.c
replace voting = . if v263 ==.d
replace voting = . if v263 ==.e

///create a dummy = 1 if father is an immigrant
generate fatherImmigrant = 0
replace fatherImmigrant = 1 if v309 ==2
replace fatherImmigrant =. if v309 ==.a
replace fatherImmigrant =. if v309 ==.b
replace fatherImmigrant =. if v309 ==.c
replace fatherImmigrant =. if v309 ==.d
replace fatherImmigrant =. if v309 ==.e

///create a dummy = 1 if mother is an immigrant 
generate motherImmigrant = 0
replace motherImmigrant = 1 if v311 ==2
replace motherImmigrant = . if v311 ==.a
replace motherImmigrant = . if v311 ==.b
replace motherImmigrant = . if v311 ==.c
replace motherImmigrant = . if v311 ==.d
replace motherImmigrant = . if v311 ==.e

///socialistDEE dummy
generate socialistDEE = .
replace socialistDEE = 1 if ( c_abrv1=="AL")|( c_abrv1=="AM")|( c_abrv1=="AZ")|( c_abrv1=="BA")|( c_abrv1=="BG")|( c_abrv1=="BY")|( c_abrv1=="CZ")|( c_abrv1=="DE-E")|( c_abrv1=="EE")|( c_abrv1=="GE")|( c_abrv1=="HR")|( c_abrv1=="HU")|( c_abrv1=="LT")|( c_abrv1=="LV")|( c_abrv1=="MD")|( c_abrv1=="ME")|( c_abrv1=="MK")|( c_abrv1=="PL")|( c_abrv1=="RO")|( c_abrv1=="RS-KM")|( c_abrv1=="RS")|( c_abrv1=="RU")|( c_abrv1=="SI")|( c_abrv1=="SK")|( c_abrv1=="UA")
replace socialistDEE = 0 if ( c_abrv1!="AL")&( c_abrv1!="AM")&( c_abrv1!="AZ")&( c_abrv1!="BA")&( c_abrv1!="BG")&( c_abrv1!="BY")&( c_abrv1!="CZ")&( c_abrv1!="DE-E")&( c_abrv1!="EE")&( c_abrv1!="GE")&( c_abrv1!="HR")&( c_abrv1!="HU")&( c_abrv1!="LT")&( c_abrv1!="LV")&( c_abrv1!="MD")&( c_abrv1!="ME")&( c_abrv1!="MK")&( c_abrv1!="PL")&( c_abrv1!="RO")&( c_abrv1!="RS-KM")&( c_abrv1!="RS")&( c_abrv1!="RU")&( c_abrv1!="SI")&( c_abrv1!="SK")&( c_abrv1!="UA")
**Note: DE is split into DE-E and DE-W; DE-E coded as socialist

///normalized discounted identity index based on max. value in our sample (Portugal)
generate indexn=index/13.73
generate indexn001=index001/12.9
generate indexn01=index01/12.11
generate indexn05=index05/9.41
generate indexn10=index10/7.27

///normalized state history index based on max. value in our sample (France)
generate statehistpgn05v3=statehist05v3/749.9112
summarize statehistpgn05v3

//income variable expressed in 1000s
generate var433_1000= var433/1000

///keeping only citizens and sample that allows for maximum number of controls
keep  if citizen ==1
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
keep if e(sample)

/////generate indexlatest05
generate indexlatest05 = .
///Albania
replace indexlatest05 = 2.85941 if country ==8
///Austria
replace indexlatest05 = 1.95238 if country ==40
///Azerbaijan
replace indexlatest05 = 2.85941 if country ==31
///Belarus
replace indexlatest05 = 0 if country ==112
///Belgium
replace indexlatest05 = 0 if country ==56
///Bosnia
replace indexlatest05 = 0 if country ==70
///Bulgaria
replace indexlatest05 = 4.54595 if country ==100
///Croatia
replace indexlatest05 = 3.72325 if country ==191
///Czech Republic
replace indexlatest05 = 2.85941 if country ==203
///Denmark
replace indexlatest05 = 3.72325 if country ==208
///Estonia
replace indexlatest05 = 2.85941 if country ==233
///Finland
replace indexlatest05 = 2.85941 if country ==246
///France
replace indexlatest05 = 1.95238 if country ==250
///Georgia
replace indexlatest05 = 3.72325 if country ==268
///Germany
replace indexlatest05 = 4.54595 if country ==276
///Greece
replace indexlatest05 = 4.54595 if country ==300
///Hungary
replace indexlatest05 = 3.72325 if country ==348
///Iceland
replace indexlatest05 = 1.95238 if country ==352
///Italy
replace indexlatest05 = 2.85941 if country ==380
///Latvia
replace indexlatest05 = 2.85941 if country ==428
///Lithuania
replace indexlatest05 = 2.85941 if country ==440
///Moldova
replace indexlatest05 = 1.95238 if country ==498
///Netherlands
replace indexlatest05 = 1.95238 if country ==528
///Norway
replace indexlatest05 = 6.07569 if country ==578
///Poland
replace indexlatest05 = 2.85941 if country ==616
///Portugal
replace indexlatest05 = 4.54595 if country ==620
///Romania
replace indexlatest05 = 4.54595 if country ==642
///Russia
replace indexlatest05 = 1.95238 if country ==643
///Slovakia
replace indexlatest05 = 2.85941 if country ==703
///Slovenia
replace indexlatest05 = 6.07569 if country ==705
///Spain
replace indexlatest05 = 4.54595 if country ==724
///Sweden
replace indexlatest05 = 3.72325 if country ==752
///Switzerland
replace indexlatest05 = 3.72325 if country ==756
///UK
replace indexlatest05 = 7.46321 if country ==826
///Ukraine
replace indexlatest05 = 1.95238 if country ==804
///Macedonia
replace indexlatest05 = 2.85941 if country ==807
/////generate indexlatest05n
generate indexlatest05n = indexlatest05/7.46321

/////generate indexearliest05
generate indexearliest05 = .
///Albania
replace indexearliest05 = 2.85941 if country ==8
///Austria
replace indexearliest05 = 6.78637 if country ==40
///Azerbaijan
replace indexearliest05 = 2.85941 if country ==31
///Belarus
replace indexearliest05 = 2.85941 if country ==112
///Belgium
replace indexearliest05 = 5.32948 if country ==56
///Bosnia
replace indexearliest05 = 1.95238 if country ==70
///Bulgaria
replace indexearliest05 = 5.32948 if country ==100
///Croatia
replace indexearliest05 = 5.32948 if country ==191
///Czech Republic
replace indexearliest05 = 4.54595 if country ==203
///Denmark
replace indexearliest05 = 6.07569 if country ==208
///Estonia
replace indexearliest05 = 4.54595 if country ==233
///Finland
replace indexearliest05 = 5.32948 if country ==246
///France
replace indexearliest05 = 6.78637 if country ==250
///Georgia
replace indexearliest05 = 3.72325 if country ==268
///Germany
replace indexearliest05 = 6.78637 if country ==276
///Greece
replace indexearliest05 = 6.78637 if country ==300
///Hungary
replace indexearliest05 = 5.32948 if country ==348
///Iceland
replace indexearliest05 = 1.95238 if country ==352
///Italy
replace indexearliest05 = 6.07569 if country ==380
///Latvia
replace indexearliest05 = 4.54595 if country ==428
///Lithuania
replace indexearliest05 = 3.72325 if country ==440
///Moldova
replace indexearliest05 = 3.72325 if country ==498
///Netherlands
replace indexearliest05 = 9.30641 if country ==528
///Norway
replace indexearliest05 = 6.07569 if country ==578
///Poland
replace indexearliest05 = 5.32948 if country ==616
///Portugal
replace indexearliest05 = 11.8378 if country ==620
///Romania
replace indexearliest05 = 4.54595 if country ==642
///Russia
replace indexearliest05 = 3.72325 if country ==643
///Slovakia
replace indexearliest05 = 4.54595 if country ==703
///Slovenia
replace indexearliest05 = 6.07569 if country ==705
///Spain
replace indexearliest05 = 6.07569 if country ==724
///Sweden
replace indexearliest05 = 4.54595 if country ==752
///Switzerland
replace indexearliest05 = 5.32948 if country ==756
///UK
replace indexearliest05 = 8.10782 if country ==826
///Ukraine
replace indexearliest05 = 3.72325 if country ==804
///Macedonia
replace indexearliest05 = 3.72325 if country ==807
/////generate indexearliest05n
generate indexearliest05n = indexearliest05/11.8378

/////generate indexearliest05high
generate indexearliest05high = .
///Belarus
replace indexearliest05high = 2.85941 if country ==112
///Bulgaria
replace indexearliest05high = 5.32948 if country ==100
///Croatia
replace indexearliest05high = 5.32948 if country ==191
///Czech Republic
replace indexearliest05high = 4.54595 if country ==203
///Denmark
replace indexearliest05high = 6.07569 if country ==208
///Estonia
replace indexearliest05high = 4.54595 if country ==233
///Finland
replace indexearliest05high = 5.32948 if country ==246
///Germany
replace indexearliest05high = 6.78637 if country ==276
///Greece
replace indexearliest05high = 6.78637 if country ==300
///Italy
replace indexearliest05high = 6.07569 if country ==380
///Latvia
replace indexearliest05high = 4.54595 if country ==428
///Lithuania
replace indexearliest05high = 3.72325 if country ==440
///Moldova
replace indexearliest05high = 3.72325 if country ==498
///Portugal
replace indexearliest05high = 11.8378 if country ==620
///Romania
replace indexearliest05high = 4.54595 if country ==642
///Ukraine
replace indexearliest05high = 3.72325 if country ==804
///Macedonia
replace indexearliest05high = 3.72325 if country ==807
/////generate indexearliest05highn
generate indexearliest05highn = indexearliest05high/11.8378 

/////generate ww2axispower
generate ww2axispower=0
replace ww2axispower=1 if (country==40)|(country==100)|(country==276)|(country==348)|(country==380)|(country==642)|(country==703)

/////generate polityIVavg10
generate polityIVavg10=.
///Albania
replace polityIVavg10 = 7 if country ==8
///Austria
replace polityIVavg10 = 10 if country ==40
///Belarus
replace polityIVavg10 = -7 if country ==112
///Belgium
replace polityIVavg10 = 9.64 if country ==56
///Bulgaria
replace polityIVavg10 = 8.73 if country ==100
///Croatia
replace polityIVavg10 = 6.55 if country ==191
///Czech Republic
replace polityIVavg10 = 9.73 if country ==203
///Denmark
replace polityIVavg10 = 10 if country ==208
///Estonia
replace polityIVavg10 = 8.55 if country ==233
///Finland
replace polityIVavg10 = 10 if country ==246
///France
replace polityIVavg10 = 9 if country ==250
///Germany
replace polityIVavg10 = 10 if country ==276
///Greece
replace polityIVavg10 = 10 if country ==300
///Hungary
replace polityIVavg10 = 10 if country ==348
///Italy
replace polityIVavg10 = 10 if country ==380
///Latvia
replace polityIVavg10 = 8 if country ==428
///Lithuania
replace polityIVavg10 = 10 if country ==440
///Moldova
replace polityIVavg10 = 8.09 if country ==498
///Netherlands
replace polityIVavg10 = 10 if country ==528
///Norway
replace polityIVavg10 = 10 if country ==578
///Poland
replace polityIVavg10 = 9.64 if country ==616
///Portugal
replace polityIVavg10 = 10 if country ==620
///Romania
replace polityIVavg10 = 8.45 if country ==642
///Russia
replace polityIVavg10 = 5.09 if country ==643
///Slovakia
replace polityIVavg10 = 9.27 if country ==703
///Slovenia
replace polityIVavg10 = 10 if country ==705
///Spain
replace polityIVavg10 = 10 if country ==724
///Sweden
replace polityIVavg10 = 10 if country ==752
///Switzerland
replace polityIVavg10 = 10 if country ==756
///UK
replace polityIVavg10 = 10 if country ==826
///Ukraine
replace polityIVavg10 = 6.45 if country ==804
///Macedonia
replace polityIVavg10 = 7.91 if country ==807

/////generate polityIVsum
generate polityIVsum=.
///Albania
replace polityIVsum = -425 if country ==8
///Austria
replace polityIVsum = -70 if country ==40
///Belarus
replace polityIVsum = -63 if country ==112
///Belgium
replace polityIVsum = 1138 if country ==56
///Bulgaria
replace polityIVsum = -553 if country ==100
///Croatia
replace polityIVsum = 45 if country ==191
///Czech Republic
replace polityIVsum = 157 if country ==203
///Denmark
replace polityIVsum = 401 if country ==208
///Estonia
replace polityIVsum = 260 if country ==233
///Finland
replace polityIVsum = 835 if country ==246
///France
replace polityIVsum = 710 if country ==250
///Germany
replace polityIVsum = 115 if country ==276
///Greece
replace polityIVsum = 783 if country ==300
///Hungary
replace polityIVsum = -334 if country ==348
///Italy
replace polityIVsum = 282 if country ==380
///Latvia
replace polityIVsum = 179 if country ==428
///Lithuania
replace polityIVsum = 98 if country ==440
///Moldova
replace polityIVsum = 134 if country ==498
///Netherlands
replace polityIVsum = 484 if country ==528
///Norway
replace polityIVsum = 575 if country ==578
///Poland
replace polityIVsum = -112 if country ==616
///Portugal
replace polityIVsum = -347 if country ==620
///Romania
replace polityIVsum = -640 if country ==642
///Russia
replace polityIVsum = -1054 if country ==643
///Slovakia
replace polityIVsum = 137 if country ==703
///Slovenia
replace polityIVsum = 180 if country ==705
///Spain
replace polityIVsum = -60 if country ==724
///Sweden
replace polityIVsum = 279 if country ==752
///Switzerland
replace polityIVsum = 1610 if country ==756
///UK
replace polityIVsum = 1240 if country ==826
///Ukraine
replace polityIVsum = 116 if country ==804
///Macedonia
replace polityIVsum = 129 if country ==807

/////generating ifinwarfrom1946v2
generate ifinwarfrom1946v2=0
replace ifinwarfrom1946v2=1 if (country==8)|(country==31)|(country==70)|(country==191)|(country==268)|(country==528)|(country==705)|(country==250)|(country==826)|(country==643)|(country==348)

/////Regression results reported in the paper

/////TABLE 2
//Column (1)
quietly oprobit nationalPride  indexn05  , vce(cluster country)
margins , dydx (indexn05) predict(outcome(4))
//Column (2)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05  , vce(cluster country)
margins , dydx (indexn05) predict(outcome(4))
//Column (3)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3  , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3) predict(outcome(4))
//Column (4)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 var433_1000) predict(outcome(4))
//Column (5)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 govteffectiveness  , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 govteffectiveness) predict(outcome(4))
//Column (6)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 gini  , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 gini) predict(outcome(4))
//Column (7)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 socialistDEE  , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 socialistDEE) predict(outcome(4))
//Column (8)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 ethnicfractionalization , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 ethnicfractionalization) predict(outcome(4))
//Column (9)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 languagefractionalization , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 languagefractionalization) predict(outcome(4))
//Column (10)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 religionfractionalization , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 religionfractionalization) predict(outcome(4))
//Column (11)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization) predict(outcome(4))
**Note: To obtain pseudo R^2 for each model, remove 'quietly' before oprobit

/////TABLE 3
//Column (1): 0% discount rate
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexn) predict(outcome(4))
//Column (2): 0.1% discount rate 
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn001 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexn001) predict(outcome(4))
//Column (3): 1% discount rate
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn01 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexn01) predict(outcome(4))
//Column (4): 10% discount rate 
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn10 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexn10) predict(outcome(4))
//Column (5): dropping Portugal
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country), if c_abrv!="PT"
margins , dydx (indexn05) predict(outcome(4))
//Column (6): dropping Albania, Georgia, Iceland, Norway, and Slovenia 
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country), if c_abrv!="SI"&c_abrv!="AL"&c_abrv!="NO"&c_abrv!="IS"&c_abrv!="GE"
margins , dydx (indexn05) predict(outcome(4))
//Column (7): dropping Albania, Georgia, and Norway; responses of two experts (for Iceland and Slovenia) who did not elaborate on their definition of national identity are included in the calculation of the value of the index
generate indexICESLO05=index05
replace indexICESLO05=3.98 if c_abrv=="IS"
replace indexICESLO05=4.93 if c_abrv=="SI"
generate indexICESLO05n=indexICESLO05/9.41
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexICESLO05n statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country), if c_abrv!="AL"&c_abrv!="NO"&c_abrv!="GE"
margins , dydx (indexICESLO05n) predict(outcome(4))
//Column (8): index based on smallest longevity responses
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexlatest05n statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexlatest05n) predict(outcome(4))
//Column (9): index based on greatest longevity responses, conditional on those responses entailing 'high confidence'
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexearliest05highn statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexearliest05highn) predict(outcome(4))
//Column (10): adding further controls: ww2axispower, polityIVavg10, polityIVsum, ifinwarfrom1946v2
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization ww2axispower polityIVavg10 polityIVsum ifinwarfrom1946v2 , vce(cluster country)
margins , dydx (indexn05) predict(outcome(4))

/////TABLE 4
//Column (1): ordered logit; odds ratio and average marginal effect
ologit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , or vce(cluster country)
margins , dydx (indexn05)  predict(outcome(4))
//Column (2): random intercept ordered logit; odds ratio
meologit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization || country:, or vce(cluster country)
//Column (3): OLS coefficient
regress nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
//Column (4): Hausman-Taylor coefficient
quietly xtset country
xthtaylor nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious confGovt1 confGovt2 confGovt3 confGovt4 interest_politics1 interest_politics2 interest_politics3 interest_politics4 educ0 educ1 educ2 educ3 educ4 educ5 educ6 ahhinc1 ahhinc2 ahhinc3 ahhinc4 ahhinc5 ahhinc6 ahhinc7 ahhinc8 ahhinc9 ahhinc10 ahhinc11 ahhinc12 indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , endog(indexn05)

/////Tables in Appendix B

/////TABLES B3-B5: summary statistics
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
summarize nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious confGovt1 confGovt2 confGovt3 confGovt4 interest_politics1 interest_politics2 interest_politics3 interest_politics4 educ0 educ1 educ2 educ3 educ4 educ5 educ6 ahhinc1 ahhinc2 ahhinc3 ahhinc4 ahhinc5 ahhinc6 ahhinc7 ahhinc8 ahhinc9 ahhinc10 ahhinc11 ahhinc12 indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization
correlate indexn05 statehistpgn05v3 var433_1000 govteffectiveness gini socialistDEE ethnicfractionalization languagefractionalization religionfractionalization
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization ww2axispower polityIVavg10 polityIVsum ifinwarfrom1946v2 , vce(cluster country)
summarize ww2axispower polityIVavg10 polityIVsum ifinwarfrom1946v2 if e(sample)

/////TABLE B6: average marginal effects for individual-level variables
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (*) predict(outcome(4))

/////Table B7: adding further controls: ww2axispower, polityIVavg10, polityIVsum, ifinwarfrom1946v2 (as in Column (10) in TABLE 4)
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexn05 statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization ww2axispower polityIVavg10 polityIVsum ifinwarfrom1946v2 , vce(cluster country)
margins , dydx (indexn05 ww2axispower polityIVavg10 polityIVsum ifinwarfrom1946v2) predict(outcome(4))

/////The following regression justifies endnote 7 in the manuscript
quietly oprobit nationalPride male voting age_less19 age_20to29 age_30to39 age_40to49 age_50to59 age_60to69 age_70to79 age_79above marital_status children_dummy left_polscale center_polscale right_polscale fatherImmigrant motherImmigrant   unemployed  unemployment_experience religious i.confidenceGovt i.interest_politics i.education i.annual_hhincome indexearliest05n statehistpgn05v3 var433_1000 govteffectiveness socialistDEE gini ethnicfractionalization languagefractionalization religionfractionalization , vce(cluster country)
margins , dydx (indexearliest05n) predict(outcome(4))

*** END ***
