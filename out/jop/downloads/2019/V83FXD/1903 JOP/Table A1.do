* Date: February 5, 2019
* Description: Compile blame rankings for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Treatments

drop if treat_info==.

gen pattern = 0
replace pattern = 1 if treat_info==2

gen reform = 0
replace reform = 1 if treat_info==3


* Interactions

gen saccounty = 0
replace saccounty = 1 if county=="sacramento"
replace saccounty = . if county==""


gen black = 0
replace black = 1 if race==2
replace black = . if race==.


* Compile blame distribution tables
* Copy and paste frequences into Excel spreadsheets
* See Table A1 sacrament.xlsx, Table A1 nonsacramento.xslx, Table A1 black.xslx

* Sacramento respondents

tab blame_clark if treat_info==1 & county=="sacramento"
tab blame_officers if treat_info==1 & county=="sacramento"
tab blame_hahn if treat_info==1 & county=="sacramento"
tab blame_steinberg if treat_info==1 & county=="sacramento"
tab blame_schubert if treat_info==1 & county=="sacramento"
tab blame_brown if treat_info==1 & county=="sacramento"
tab blame_senators if treat_info==1 & county=="sacramento"


tab blame_clark if treat_info==2 & county=="sacramento"
tab blame_officers if treat_info==2 & county=="sacramento"
tab blame_hahn if treat_info==2 & county=="sacramento"
tab blame_steinberg if treat_info==2 & county=="sacramento"
tab blame_schubert if treat_info==2 & county=="sacramento"
tab blame_brown if treat_info==2 & county=="sacramento"
tab blame_senators if treat_info==2 & county=="sacramento"


tab blame_clark if treat_info==3 & county=="sacramento"
tab blame_officers if treat_info==3 & county=="sacramento"
tab blame_hahn if treat_info==3 & county=="sacramento"
tab blame_steinberg if treat_info==3 & county=="sacramento"
tab blame_schubert if treat_info==3 & county=="sacramento"
tab blame_brown if treat_info==3 & county=="sacramento"
tab blame_senators if treat_info==3 & county=="sacramento"


* Non-Sacramento respondents

tab blame_clark if treat_info==1 & county!="sacramento"
tab blame_officers if treat_info==1 & county!="sacramento"
tab blame_hahn if treat_info==1 & county!="sacramento"
tab blame_steinberg if treat_info==1 & county!="sacramento"
tab blame_schubert if treat_info==1 & county!="sacramento"
tab blame_brown if treat_info==1 & county!="sacramento"
tab blame_senators if treat_info==1 & county!="sacramento"


tab blame_clark if treat_info==2 & county!="sacramento"
tab blame_officers if treat_info==2 & county!="sacramento"
tab blame_hahn if treat_info==2 & county!="sacramento"
tab blame_steinberg if treat_info==2 & county!="sacramento"
tab blame_schubert if treat_info==2 & county!="sacramento"
tab blame_brown if treat_info==2 & county!="sacramento"
tab blame_senators if treat_info==2 & county!="sacramento"


tab blame_clark if treat_info==3 & county!="sacramento"
tab blame_officers if treat_info==3 & county!="sacramento"
tab blame_hahn if treat_info==3 & county!="sacramento"
tab blame_steinberg if treat_info==3 & county!="sacramento"
tab blame_schubert if treat_info==3 & county!="sacramento"
tab blame_brown if treat_info==3 & county!="sacramento"
tab blame_senators if treat_info==3 & county!="sacramento"


* Black respondents

tab blame_clark if treat_info==1 & black==1
tab blame_officers if treat_info==1 & black==1
tab blame_hahn if treat_info==1 & black==1
tab blame_steinberg if treat_info==1 & black==1
tab blame_schubert if treat_info==1 & black==1
tab blame_brown if treat_info==1 & black==1
tab blame_senators if treat_info==1 & black==1


tab blame_clark if treat_info==2 & black==1
tab blame_officers if treat_info==2 & black==1
tab blame_hahn if treat_info==2 & black==1
tab blame_steinberg if treat_info==2 & black==1
tab blame_schubert if treat_info==2 & black==1
tab blame_brown if treat_info==2 & black==1
tab blame_senators if treat_info==2 & black==1


tab blame_clark if treat_info==3 & black==1
tab blame_officers if treat_info==3 & black==1
tab blame_hahn if treat_info==3 & black==1
tab blame_steinberg if treat_info==3 & black==1
tab blame_schubert if treat_info==3 & black==1
tab blame_brown if treat_info==3 & black==1
tab blame_senators if treat_info==3 & black==1


* T-tests blame
* Copy and paste N, Mean, Std. Dev. from Excel spreadsheets
* See Table A1 sacrament.xlsx, Table A1 nonsacramento.xslx, Table A1 black.xslx

* Sacramento respondents

* Mean
* Control vs. Pattern

ttesti 402 5.05 2.07 378 5.19 2.00
ttesti 402 5.75 1.70 378 5.63 1.69
ttesti 402 4.60 1.32 378 4.58 1.31
ttesti 402 3.47 1.09 378 3.60 1.03
ttesti 402 3.61 1.17 378 3.46 1.24
ttesti 402 2.93 1.40 378 2.87 1.43
ttesti 402 2.59 1.43 378 2.67 1.50

* Control vs. Reform

ttesti 402 5.05 2.07 363 5.34 1.93
ttesti 402 5.75 1.70 363 5.78 1.54
ttesti 402 4.60 1.32 363 4.58 1.19
ttesti 402 3.47 1.09 363 3.58 1.08
ttesti 402 3.61 1.17 363 3.43 1.26
ttesti 402 2.93 1.40 363 2.82 1.31
ttesti 402 2.59 1.43 363 2.45 1.38

* Pattern vs. Reform

ttesti 378 5.19 2.00 363 5.34 1.93
ttesti 378 5.63 1.69 363 5.78 1.54
ttesti 378 4.58 1.31 363 4.58 1.19
ttesti 378 3.60 1.03 363 3.58 1.08
ttesti 378 3.46 1.24 363 3.43 1.26
ttesti 378 2.87 1.43 363 2.82 1.31
ttesti 378 2.67 1.50 363 2.45 1.38


* Non-Sacramento respondents

* Mean
* Control vs. Pattern

ttesti 460 4.22 2.28 418 3.75 2.25
ttesti 460 6.09 1.56 418 6.23 1.39
ttesti 460 4.85 1.43 418 5.03 1.32
ttesti 460 3.52 1.23 418 3.67 1.19
ttesti 460 3.72 1.30 418 3.79 1.27
ttesti 460 2.92 1.50 418 3.03 1.45
ttesti 460 2.68 1.52 418 2.49 1.36

* Control vs. Reform

ttesti 460 4.22 2.28 444 4.30 2.37
ttesti 460 6.09 1.56 444 5.83 1.79
ttesti 460 4.85 1.43 444 4.70 1.48
ttesti 460 3.52 1.23 444 3.58 1.32
ttesti 460 3.72 1.30 444 3.56 1.36
ttesti 460 2.92 1.50 444 3.19 1.67
ttesti 460 2.68 1.52 444 2.84 1.63

* Pattern vs. Reform

ttesti 418 3.75 2.25 444 4.30 2.37
ttesti 418 6.23 1.39 444 5.83 1.79
ttesti 418 5.03 1.32 444 4.70 1.48
ttesti 418 3.67 1.19 444 3.58 1.32
ttesti 418 3.79 1.27 444 3.56 1.36
ttesti 418 3.03 1.45 444 3.19 1.67
ttesti 418 2.49 1.36 444 2.84 1.63


* Black respondents

* Mean
* Control vs. Pattern

ttesti 75 3.19 0.87 63 2.40 0.68
ttesti 75 6.29 0.67 63 6.21 0.55
ttesti 75 5.11 0.53 63 5.32 0.49
ttesti 75 3.93 0.46 63 3.68 0.40
ttesti 75 3.95 0.49 63 4.00 0.53
ttesti 75 2.88 0.51 63 3.37 0.59
ttesti 75 2.65 0.60 63 3.03 0.66

* Control vs. Reform

ttesti 75 3.19 0.87 70 2.86 0.86
ttesti 75 6.29 0.67 70 6.47 0.45
ttesti 75 5.11 0.53 70 5.26 0.55
ttesti 75 3.93 0.46 70 3.71 0.48
ttesti 75 3.95 0.49 70 3.86 0.57
ttesti 75 2.88 0.51 70 3.21 0.54
ttesti 75 2.65 0.60 70 2.63 0.55

* Pattern vs. Reform

ttesti 63 2.40 0.68 70 2.86 0.86
ttesti 63 6.21 0.55 70 6.47 0.45
ttesti 63 5.32 0.49 70 5.26 0.55
ttesti 63 3.68 0.40 70 3.71 0.48
ttesti 63 4.00 0.53 70 3.86 0.57
ttesti 63 3.37 0.59 70 3.21 0.54
ttesti 63 3.03 0.66 70 2.63 0.55

* End
