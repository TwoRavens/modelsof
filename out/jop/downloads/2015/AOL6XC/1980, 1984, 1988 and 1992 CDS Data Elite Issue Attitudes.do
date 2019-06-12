*1980, 1984, 1988 and 1992 Convention Delegate Survey Studies*
*Factor Analysis of Elite Issue Attitudes*
*Wed. 14 July 2010*
*Updated: Wed. 20 October 2010*
*Updated: Thurs. 13 January 2011*
*Updated: Sat. 15 January 2011*
*Updated: Mon 17 January 2011*
*Updated: Mon. 25 April 2011*
*Updated: Tues. 23 October 2012*
*Updated: Thurs. 8 November 2012*
*Updated: Friday 9 November 2012*
*Updated: Mon. 12 November 2012*
*Updated: Tues. 13 November 2012*
*Updated: Wed. 14 November 2012*
*Updated: Friday 16 November 2012*
*Updated: Mon. 19 November 2012*
*Updated: Wed. 21 November 2012*
*Updated: Tues. 27 November 2012*
*Updated: Tues. 4 December 2012*
*Updated: Thurs. 6 December 2012*
*Updated: Friday 7 December 2012*
*Updated: Sat. 8 December 2012*
*Updated: Wed. 12 December 2012*
*Updated: Thurs. 13 December 2012*
*Updated: Friday 14 December 2012*
*Updated: Friday 19 April 2013*

****************
*1980 CDS Data*
****************

****************
*Recode symbolic predisposition variable*
****************

*Ideological self-identification*

gen Ideology80 = V305
label var Ideology80 "Ideological Self-identification*
label define Ideologicalidentification80 /// 
1 "1 Extremely liberal" 7 "7 Extremely conservative"
label values Ideology80 Ideologicalidentification80

****************
*Recode issue attitude variables*

*Note: The six issues included in the analysis for 1980 are the following:* 
*school busing, environmental regulations, defense spending,* 
*relations with Russia, abortion and the ERA* 

*Note: All issue attitudes variables except the attitudes toward Russia (USSR)* 
*and ERA variables are reverse coded so higher values reflect more* 
*conservative attitudes*
****************

*Environmental regulation*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Environ80 = V316
replace Environ80 = 1 if V316 == 3
replace Environ80 = 3 if V316 == 1
label var Environ80 /// 
"Attitudes on Strengthening versus Relaxing Environmental Regulations*
label define Environment80 /// 
1 "1 Keep regulations unchanged" 2 "2 Relax regulations, with qualifications" /// 
3 "3 Relax regulations" 
label values Environ80 Environment80

*School busing*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Busing80 = V319
replace Busing80 = 1 if V319 == 7
replace Busing80 = 2 if V319 == 6
replace Busing80 = 3 if V319 == 5
replace Busing80 = 5 if V319 == 3
replace Busing80 = 6 if V319 == 2
replace Busing80 = 7 if V319 == 1
label var Busing80 "Attitudes on School Busing"
label define Busingschools80 /// 
1 "1 Busing to achieve integration" /// 
7 "7 Keeping children in neighborhood schools"
label values Busing80 Busingschools80

*Defense spending*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Defense80 = V317
replace Defense80 = 1 if V317 == 7
replace Defense80 = 2 if V317 == 6
replace Defense80 = 3 if V317 == 5
replace Defense80 = 5 if V317 == 3
replace Defense80 = 6 if V317 == 2
replace Defense80 = 7 if V317 == 1
label var Defense80 "Attitudes on Defense Spending"
label define Defensespending80 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defense80 Defensespending80

*Relations with Russia*

gen Russia80 = V318
label var Russia80 "Attitudes on Relations with Russia"
label define Russiarelations80 /// 
1 "1 Important to try very hard to get along with Russia" /// 
7 "7 Big mistake to try too hard to get along with Russia"
label values Russia80 Russiarelations80

*Abortion*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Abortion80 = V321
replace Abortion80 = 1 if V321 == 4
replace Abortion80 = 2 if V321 == 3
replace Abortion80 = 3 if V321 == 2
replace Abortion80 = 4 if V321 == 1
label var Abortion80 "Attitudes on Abortion"
label define Abortionattitudes80 /// 
1 "1 Abortion Should never be forbidden" ///
2 "Abortion should be permitted if, due to personal reasons, the woman would have difficulty in caring for the child" /// 
3 "Abortion should be permitted only if the life and health of the woman is in danger" ///
4 "Abortion should never be permitted" 
label values Abortion80 Abortionattitudes80

*Equal Rights Amendment*
*Note: This variable is a proxy for attitudes on the role of women in society*

gen ERA80 = V322
label var ERA80 "Attitudes on the Equal Rights Amendment"
label define ERAattitudes80 /// 
1 "1 Approve Strongly" 2 "2 Approve somewhat" 3 "3 Disapprove somewhat" /// 
4 "4 Disapprove strongly"
label values ERA80 ERAattitudes80 

****************
*Exploratory factor analysis of the 1980 elite issue attitudes*
*Note: This procedure is conducted to determine the appropriate "indicator*
*variable" for factors 1 and 2 (social welfare and cultural) in the* 
*confirmatory factor analysis*
****************

factor Environ80 Busing80 Defense80 Russia80 Abortion80 ERA80, ipf

*Note: The analysis indicates that attitudes toward defense spending and* 
*the role of women in society are appropriate "indicator variables"*
*for factor 1 and factor 2, respectively*

****************
*Create a scree plot of the factor analysis results*
*Note: This step is taken almost entirely in the interest of nostalgia!*
****************

screeplot, msymbol(Oh) mcolor(black) ylab(,angle(0)) aspect(1)

****************
*Obtain squared multiple correlation coefficients of each variable with all* 
*other variables*
****************

estat smc

****************
*Confirmatory factor analysis of the 1980 elite issue attitudes*
*Note: Attitudes toward defense spending and the role of women in society*
*are used as "indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*
****************

sem (L1 -> Defense80) (L1 -> Environ80) (L1 -> Busing80) (L1 -> Russia80) /// 
(L2 -> ERA80) (L2 -> Abortion80), ///
covstruct(_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2) 

****************
*Examine fit statistics for the confirmatory factor analysis*
****************

estat gof, stats(all)

****************
*Correlate ideological self-identifications with factor one, which is* 
*hypothesized to represent ideology*
*Note: This procedure also reports a ninety-five percent confidence interval* 
*for the estimated correlation*
****************

predict Factor180, latent(L1)

net search corrci

corrci Ideology80 Factor180

****************
*Conduct an analysis to examine the demographic profile of the*
*delegates, including race, age, gender, education and income*


*Note: These statistics are calculated for the purpose of examining basic*
*demographic and socioeconomic differences between the delegates and*
*the mass public*

*Note: The race variable on the 1980 CDS is not comparable to the other years,* 
*and thus the item is excluded from the analyis in this year*
****************

*Gender*

gen Gender80 = V368
replace Gender80 = 0 if V368 == 1
replace Gender80 = 1 if V368 == 2
labe var Gender80 "Respondent Gender"
label define Gendertype80 0 "0 Male" 1 "1 Female"
label values Gender80 Gendertype80

****************
*Obtain the percentage of male and female delgates in the sample*
****************

tabulate Gender80

*Age*

gen Age80 = V468
label var Age80 "Respondent Age"

****************
*Obtain the median sample value for the age variable*
****************

summarize Age80, detail

*Education*

gen Education80 = V402
replace Education80 = 1 if V402 == 2
replace Education80 = 2 if V402 == 3
replace Education80 = 3 if V402 == 4
replace Education80 = 4 if V402 == 5
replace Education80 = 4 if V402 == 6
replace Education80 = 4 if V402 == 6
replace Education80 = 4 if V402 == 7
replace Education80 = 4 if V402 == 8
replace Education80 = 4 if V402 == 9
replace Education80 = 4 if V402 == 10
label var Education80 "Respondent's Level of Education"
label define Educationlevel80 ///
1 "1 High school diplom or less " 2 "2 Some college" ///
3 "3 College graduate" 4 "4 Some graduate school or advanced degree"
label values Education80 Educationlevel80

****************
*Obtain the percentage of delegates who fall into each education category*
****************

tabulate Education80

*Income*

gen Income80 = V431
label var Income80 "Respondent Income"

****************
*Obtain the median sample value for the income variable*
****************

summarize Income80, detail

****************
*1984 CDS Data*
****************

****************
*Recode symbolic predisposition variable*
****************

*Ideological self-identification*

gen Ideology84 = V142
label var Ideology84 "Ideological Self-identification"
label define Ideologicalidentification84 /// 
1 "1 Extremely liberal" 7 "7 Extremely conservative"
label values Ideology84 Ideologicalidentification84

****************
*Recode issue attitude variables*

*Note: The eight issues included in the analysis for 1984 are the following:* 
*public school spending, school busing, environmental regulations,* 
*defense spending, relations with Russia, abortion, ERA and school prayer*

*Note: All issue attitude variables except the attitudes toward Russia (USSR)* 
*and ERA variables are reverse coded so higher values reflect more* 
*conservative attitudes*
****************

*Public school spending*

gen Schools84 = V186
replace Schools84 = 1 if V186 == 3
replace Schools84 = 2 if V186 == 1
label var Schools84 "Attitudes Toward Public School Spending"
label define Schoolspending84 1 "Increased" 2 "Kept the same" 3 "Reduced"
label values Schools84 Schoolspending84

*School busing*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Busing84 = V184
replace Busing84 = 1 if V184 == 7
replace Busing84 = 2 if V184 == 6
replace Busing84 = 3 if V184 == 5
replace Busing84 = 5 if V184 == 3
replace Busing84 = 6 if V184 == 2
replace Busing84 = 7 if V184 == 1
label var Busing84 "Attitudes on School Busing"
label define Busingschools84 /// 
1 "1 Busing to achieve integration" 7 "7 Keeping children in neighborhood schools"
label values Busing84 Busingschools84

*Environmental regulation*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Environ84 = V177
replace Environ84 = 1 if V177 == 5
replace Environ84 = 2 if V177 == 4
replace Environ84 = 4 if V177 == 2
replace Environ84 = 5 if V177 == 1
label var Environ84 "Attitudes on Strengthening versus Relaxing Environmental Regulations*
label define Environment84 /// 
1 "1 Tighten regulations" 2 "2 Tighten regulations, with qualifications" /// 
3 "3 Keep regulations unchanged" 4 "4 Relax regulations, with qualifications" /// 
5 "5 Relax regulations" 
label values Environ84 Environment84

*Defense spending*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Defense84 = V182
replace Defense84 = 1 if V182 == 7
replace Defense84 = 2 if V182 == 6
replace Defense84 = 3 if V182 == 5
replace Defense84 = 5 if V182 == 3
replace Defense84 = 6 if V182 == 2
replace Defense84 = 7 if V182 == 1
label var Defense84 "Attitudes on Defense Spending"
label define Defensespending84 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defense84 Defensespending84

*Relations with Russia*

gen Russia84 = V183
label var Russia84 "Attitudes on Relations with Russia"
label define Russiarelations84 /// 
1 "1 Important to try very hard to get along with Russia" /// 
7 "7 Big mistake to try too hard to get along with Russia"
label values Russia84 Russiarelations84

*Abortion*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Abortion84 = V178
replace Abortion84 = 1 if V178 == 4
replace Abortion84 = 2 if V178 == 3
replace Abortion84 = 3 if V178 == 2
replace Abortion84 = 4 if V178 == 1
label var Abortion84 "Attitudes on Abortion"
label define Abortionattitudes84 /// 
1 "1 Abortion should never be forbidden" ///
2 "2 Abortion should be permitted if, due to personal reasons, the woman would have difficulty in caring for the child" /// 
3 "3 Abortion should be permitted only if the life and health of the woman is in danger" ///
4 "4 Abortion should never be permitted" 
label values Abortion84 Abortionattitudes84

*Equal Rights Amendment*
*Note: This variable is a proxy for attitudes on the role of women in society*

gen ERA84 = V179
label var ERA84 "Attitudes on the Equal Rights Amendment"
label define ERAattitudes84 /// 
1 "1 Approve strongly" 2 "2 Approve somewhat" 3 "3 Disapprove somewhat" /// 
4 "4 Disapprove strongly"
label values ERA84 ERAattitudes84 

*School prayer*

gen Prayer84 = V180
replace Prayer84 = 1 if V180 == 3
replace Prayer84 = 3 if V180 == 1
label var Prayer84 "Attitudes Toward School Prayer"
label define Prayerschools84 /// 
1 "1 Religion does not belong in the schools" ///
2 "2 Schools should be allowed to start each day with a prayer, provided the prayer is silent" /// 
3 "3 Schools should be allowed to start each day with a prayer"
label values Prayer84 Prayerschools84

****************
*Exploratory factor analysis of the 1984 elite issue attitudes*
*Note: This procedure is conducted to determine the appropriate "indicator*
*variable" for factors 1 and 2 (social welfare and cultural) in the* 
*confirmatory factor analysis*
****************

factor Schools84 Busing84 Environ84 Defense84 Russia84 Abortion84 ERA84 /// 
Prayer84, ipf

*Note: The analysis indicates that attitudes toward defense spending and the* 
*ERA are appropriate "indicator variables" for factor 1 and factor 2,* 
*respectively*

*Note: The analysis also indicates that Social Security is a problematic item,*
*perhaps suggesting that Social Security spending is a valence issue*

****************
*Create a scree plot of the factor analysis results*
*Note: This step is taken almost entirely in the interest of nostalgia!*
****************

screeplot, msymbol(Oh) mcolor(black) ylab(,angle(0)) aspect(1)

****************
*Obtain squared multiple correlation coefficients of each variable with all* 
*other variables*
****************

estat smc

****************
*Confirmatory factor analysis of the 1984 elite issue attitudes*
*Note: Attitudes toward defense spending and ERS are used as* 
*"indicator variables" for factors 1 and 2 (social welfare and cultural),* 
*respectively*
****************

sem (L1 -> Defense84) (L1 -> Schools84) (L1 -> Busing84) (L1 -> Environ84) /// 
(L1 -> Russia84) (L2 -> ERA84) (L2-> Abortion84) (L2 -> Prayer84), ///
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2)

*Note: Omitting the Social Security item improves model fit considerably,* 
*which, again, was also demonstrated by examining the results of the* 
*exploratory factor analysis omitting the item*

****************
*Examine fit statistics for the confirmatory factor analysis*
****************

estat gof, stats(all)

****************
*Correlate ideological self-identifications with factor one, which is* 
*hypothesized to represent ideology*
*Note: This procedure also reports a ninety-five percent confidence interval* 
*for the estimated correlation*
****************

predict Factor184, latent(L1)

corrci Ideology84 Factor184

****************
*Conduct an analysis to examine the demographic profile of the*
*delegates, including race, age, gender, education and income*

*Note: These statistics are calculated for the purpose of examining basic*
*demographic and socioeconomic differences between the delegates and*
*the mass public*

*Note: Inexplicably, age and income are not included on the 1984 CDS*
****************

*Race*

gen Race84 = V457
replace Race84 = 0 if V457 == 1
replace Race84 = 1 if V457 == 2
label var Race84 "Respondent Race"
label define Racecategory84 0 "0 White" 1 "1 Non-white"
label values Race84 Racecategory84

****************
*Obtain the percentage of whites and non-whites in the sample*
****************

tabulate Race84

*Gender*

gen Gender84 = V236
replace Gender84 = 0 if V236 == 1
replace Gender84 = 1 if V236 == 2
labe var Gender84 "Respondent Gender"
label define Gendertype84 0 "0 Male" 1 "1 Female"
label values Gender84 Gendertype84

****************
*Obtain the percentage of male and female delgates in the sample*
****************

tabulate Gender84

*Education*

gen Education84 = V458
replace Education84 = 4 if V458 == 5
label var Education84 "Respondent's Level of Education"
label define Educationlevel84 ///
1 "1 High school diploma or less" 2 "3 Some college" ///
3 "3 College graduate" 4 "4 Some graduate school or advanced degree"
label values Education84 Educationlevel84

****************
*Obtain the percentage of delegates who fall into each education category*
****************

tabulate Education84

*Income*

gen Income84 = V431
label var Income84 "Respondent Income"

****************
*1988 CDS Data*
****************

****************
*Recode symbolic predisposition variable*
****************

*Ideological self-identification*

gen Ideology88 = V115
replace Ideology88 = . if V115 == 9 
label var Ideology88 "Ideological Self-identification"
label define Ideologicalidentification88 /// 
1 "1 Extremely Liberal" 7 "7 Extremely Conservative"
label values Ideology88 Ideologicalidentification88

****************
*Recode issue attitude variables*

*Note: The nine issues included in the analysis for 1988 are the following:* 
*child care spending, public school spending, school busing, spending on the* 
*environment, defense spending, relations with Russia, abortion, the role* 
*of women in society and school prayer*

*Note: The school busing, defense, abortion and school prayer issue attitude*
*variables are reverse coded so higher values reflect* 
*more conservative attitudes*
****************

*Child care spending*

gen Childcare88 = V188
replace Childcare88 = . if V188 == 9
label var Childcare88 "Attitudes Toward Child Care Spending"
label define Childcarespending88 /// 
1 "1 Increased" 2 "2 Kept the same" 3 "3 Reduced"
label values Childcare88 Childcarespending88

*Education spending*
*Note: This variable is a proxy for spending on public schools*

gen Education88 = V181
replace Education88 = . if V181 == 9
label var Education88 "Attitudes Toward Education Spending"
label define Educationspending88 ///
1 "1 Increased" 2 "2 Kept the same" 3 "3 Reduced"
label values Education88 Educationspending88

*School busing*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Busing88 = V155
replace Busing88 = . if V155 == 9
replace Busing88 = 1 if V155 == 7
replace Busing88 = 2 if V155 == 6
replace Busing88 = 3 if V155 == 5
replace Busing88 = 5 if V155 == 3
replace Busing88 = 6 if V155 == 2
replace Busing88 = 7 if V155 == 1
label var Busing88 "Attitudes on School Busing"
label define Busingschools88 /// 
1 "1 Busing to achieve integration" /// 
7 "7 Keeping children in neighborhood schools"
label values Busing88 Busingschools88

*Environmental regulation*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Environ88 = V153
replace Environ88 = . if V153 == 9
replace Environ88 = 1 if V153 == 5
replace Environ88 = 2 if V153 == 4
replace Environ88 = 4 if V153 == 2
replace Environ88 = 5 if V153 == 1
label var Environ88 "Attitudes on Strengthening versus Relaxing Environmental Regulations*
label define Environment84 /// 
1 "1 Tighten regulations" 2 "2 Tighten regulations, with qualifications" /// 
3 "3 Keep regulations unchanged" 4 "4 Relax regulations, with qualifications" /// 
5 "5 Relax regulations" 
label values Environ88 Environment88

*Defense spending*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Defense88 = V156
replace Defense88 = . if V156 == 9
replace Defense88 = 1 if V156 == 7
replace Defense88 = 2 if V156 == 6
replace Defense88 = 3 if V156 == 5
replace Defense88 = 5 if V156 == 3
replace Defense88 = 6 if V156 == 2
replace Defense88 = 7 if V156 == 1
label var Defense88 "Attitudes on Defense Spending"
label define Defensespending88 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defense88 Defensespending88

*Relations with Russia*

gen Russia88 = V161
replace Russia88 = . if V161 == 9
label var Russia88 "Attitudes on Relations with Russia"
label define Russiarelations88 /// 
1 "1 Important to try very hard to get along with Russia" ///
7 "7 Big mistake to try too hard to get along with Russia"
label values Russia88 Russiarelations88

*Abortion*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Abortion88 = V150
replace Abortion88 = . if V150 == 9
replace Abortion88 = 1 if V150 == 4
replace Abortion88 = 2 if V150 == 3
replace Abortion88 = 3 if V150 == 2
replace Abortion88 = 4 if V150 == 1
label var Abortion88 "Attitudes on Abortion"
label define Abortionattitudes88 /// 
1 "1 Abortion should never be forbidden" /// 
2 "2 Abortion should be permitted if, due to personal reasons, the woman would have difficulty in caring for the child" /// 
3 "3 Abortion should be permitted only if the life and health of the woman is in danger" /// 
4 "4 Abortion should never be permitted" 
label values Abortion88 Abortionattitudes88

*School prayer*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Prayer88 = V152
replace Prayer88 = . if V152 == 9
replace Prayer88 = 1 if V152 == 3
replace Prayer88 = 3 if V152 == 1
label var Prayer88 "Attitudes Toward School Prayer"
label define Prayerschools88 /// 
1 "1 Religion does not belong in the schools" /// 
2 "2 Schools should be allowed to start each day with a prayer, provided the prayer is silent" ///
3 "3 Schools should be allowed to start each day with a prayer"
label values Prayer88 Prayerschools88

*Women's role in society*

gen Women88 = V171
replace Women88 = . if V171 == 9
label var Women88 "Attitudes Toward the Role of Women in Society"
label define Womenrole88 /// 
1 "1 Women and men should have an equal role" ///
7 "7 Women's place is in the home"
label values Women88 Womenrole88

****************
*Exploratory factor analysis of the 1988 elite issue attitudes*
*Note: This procedure is conducted to determine the appropriate "indicator*
*variable" for factors 1 and 2 (social welfare and cultural) in the* 
*confirmatory factor analysis*
****************

factor Childcare88 Education88 Busing88 Environ88 Defense88 Russia88 /// 
Abortion88 Women88 Prayer88, ipf

*Note: The analysis indicates that defense spending and school prayer* 
*are appropriate "indicator variables" for factor 1 and factor 2,* 
*respectively*

****************
*Create a scree plot of the factor analysis results*
*Note: This step is taken almost entirely in the interest of nostalgia!*
****************

screeplot, msymbol(Oh) mcolor(black) ylab(,angle(0)) aspect(1)

****************
*Obtain squared multiple correlation coefficients of each variable with all* 
*other variables*
****************

estat smc

****************
*Confirmatory factor analysis of the 1988 elite issue attitudes*
*Note: Attitudes toward defense spending and school prayer are appropriate* 
*"indicator variables" for factors 1 and 2 (social welfare and cultural),* 
*respectively*
****************

sem (L1 ->Defense88) (L1 -> Childcare88) (L1 -> Education88) (L1 -> Busing88) /// 
(L1 -> Environ88) (L1 -> Russia88) (L2 -> Prayer88) (L2 -> Abortion88) ///
(L2 -> Women88), covstruct (_lexogenous, diagonal) standard /// 
latent (L1 L2) nocapslatent cov (L1*L2) 

****************
*Examine fit statistics for the confirmatory factor analysis*
****************

estat gof, stats(all)

****************
*Correlate ideological self-identifications with factor one, which is* 
*hypothesized to represent ideology*
*Note: This procedure also reports a ninety-five percent confidence interval* 
*for the estimated correlation*
****************

predict Factor188, latent(L1)

corrci Ideology88 Factor188

****************
*Conduct an analysis to examine the demographic profile of the*
*delegates, including race, age, gender, education and income*

*Note: These statistics are calculated for the purpose of examining basic*
*demographic and socioeconomic differences between the delegates and*
*the mass public*
****************

*Race*

gen Race88 = V656
replace Race88 = . if V656 == 9
replace Race88 = 0 if V656 == 1
replace Race88 = 1 if V656 == 2
label var Race88 "Respondent Race"
label define Racecategory88 0 "0 White" 1 "1 Non-white"
label values Race88 Racecategory88

****************
*Obtain the percentage of whites and non-whites in the sample*
****************

tabulate Race88

*Gender*

gen Gender88 = V255
replace Gender88 = . if V255 == 9
replace Gender88 = 0 if V255 == 1
replace Gender88 = 1 if V255 == 2
labe var Gender88 "Respondent Gender"
label define Gendertype88 0 "0 Male" 1 "1 Female"
label values Gender88 Gendertype88

****************
*Obtain the percentage of male and female delgates in the sample*
****************

tabulate Gender88

*Age*

gen Age88 = V657
replace Age88 = . if V657 == 9

****************
*Obtain the median sample value for the age variable*
****************

table Age88
summarize Age88, detail

*Education*

gen Education88 = V685
replace Education88 = . if V685 == 9
replace Education88 = 4 if V685 == 5
label var Education88 "Respondent's Level of Education"
label define Educationlevel88 ///
1 "1 High school diploma or less" 2 "3 Some college" ///
3 "3 College graduate" 4 "4 Some graduate school or advanced degree"
label values Education88 Educationlevel88

****************
*Obtain the percentage of delegates who fall into each education category*
****************

tabulate Education88

*Income*

gen Income88 = V299
replace Income88 = . if V299 == 99
label var Income88 "Respondent Income"

****************
*Obtain the median sample value for the income variable*
****************

table Income88
summarize Income88, detail

****************
*1992 CDS Data*
****************

****************
*Recode symbolic predisposition variable*
****************

*Ideological self-identification*

gen Ideology92 = V0087
drop if Ideology92 == 9 
label var Ideology92 "Ideological Self-identification"
label define Ideologicalidentification92 /// 
1 "1 Extremely Liberal" 7 "7 Extremely Conservative"
label values Ideology92 Ideologicalidentification92

****************
*Recode issue attitude variables*

*Note: The twelve issues included in the analysis for 1992 are the following:* 
*services spending, welfare spending, spending on programs to assist the* 
*unemployed, government versus private health insurance, child care spending,* 
*public school spending, assistance to blacks, spending on the environment,*
*defense spending, abortion, the role of women in society and school prayer*

*Note: The services, defense spending and abortion and school prayer issue* 
*attitude variables are reverse coded so higher values reflect* 
*more conservative attitudes*
****************

*Services spending*

gen Services92 = V0143
replace Services92 = . if V0143 == 9
replace Services92 = 1 if V0143 == 7
replace Services92 = 2 if V0143 == 6
replace Services92 = 3 if V0143 == 5
replace Services92 = 5 if V0143 == 3
replace Services92 = 6 if V0143 == 2
replace Services92 = 7 if V0143 == 1
label var Services92 "Government Provision of Services versus Lower Spending"
label define Servicesgov92 /// 
1 "1 Government provide many more services" /// 
7 "7 Government provide many fewer services"
label value Services92 Servicesgov92

*Welfare spending*

gen Welfare92 = V0168
replace Welfare92 = . if V0168 == 9 
label var Welfare92 "Attitudes Toward Welfare Spending"
label define Welfarespending92 ///
1 "1 Increased" 2 "2 Kept the same" 3 "3 Reduced" 4 "Cut out"
label values Welfare92 Welfarespending92

*Spending on programs to assist the unemployed*

gen Unemployed92 = V0171
replace Unemployed92 = . if V0171 == 9 
label var Unemployed92 /// 
"Attitudes Toward Spending on Programs to Assist the Unemployed"
label define Unemployedspending92 ///
1 "1 Increased" 2 "2 Kept the same" 3 "3 Reduced" 4 "Cut out"
label values Unemployed92 Unemployedspending92

*Government versus private health insurance*

gen Insurance92 = V0152
replace Insurance92 = . if V0152 == 9
label var Insurance92 "Attitudes Toward Government versus Private Insurance Plans"
label define Insuranceplan92 /// 
1 "1 Government insurance plan" 7 "7 Private insurance plan"
label values Insurance92 Insuranceplan92

*Child care spending*

gen Childcare92 = V0167
replace Childcare92 = . if V0167 == 9
label var Childcare92 "Attitudes Toward Spending on Child Care"
label define Childcarespending92 ///
1 "Increased" 2 "Kept the same" 3 "Reduced" 4 "Cut out"
label values Childcare92 Childcarespending92

*Public school spending*

gen Schools92 = V0160
replace Schools92 = . if V0160 == 9
label var Schools92 "Attitudes Toward Public School Spending"
label define Schoolspending92 ///
1 "Increased" 2 "Kept the same" 3 "Reduced" 4 "Cut out"
label values Schools92 Schoolspending92

*Government assistance to blacks*

gen Assistblacks92 = V0122
replace Assistblacks92 = . if V0122 == 9
label var Assistblacks92 "Attitudes Toward Government Assistance of Blacks"
label define Assistanceblacks92 /// 
1 "1 Government should help blacks" 7 "7 Blacks should help themselves" 
label values Assistblacks92 Assistanceblacks92

*Spending on the environment*

gen Environ92 = V0169
replace Environ92 = . if V0169 == 9
label var Environ92 "Attitudes on Spending to Protect the Environment"
label define Environmentspending92 ///
1 "Increased" 2 "Kept the same" 3 "Reduced" 4 "Cut out"
label values Environ92 Environmentspending92

*Defense spending*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Defense92 = V0121
replace Defense92 = . if V0121 == 9
replace Defense92 = 1 if V0121 == 7
replace Defense92 = 2 if V0121 == 6
replace Defense92 = 3 if V0121 == 5
replace Defense92 = 5 if V0121 == 3
replace Defense92 = 6 if V0121 == 2
replace Defense92 = 7 if V0121 == 1
label var Defense92 "Attitudes on Defense Spending"
label define Defensespending92 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defense92 Defensespending92

*Abortion*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Abortion92 = V0106
replace Abortion92 = . if V0106 == 9
replace Abortion92 = 1 if V0106 == 4
replace Abortion92 = 2 if V0106 == 3
replace Abortion92 = 3 if V0106 == 2
replace Abortion92 = 4 if V0106 == 1
label var Abortion92 "Attitudes on Abortion"
label define Abortionattitudes92 /// 
1 "1 By law, a woman should always be able to/by choice" ///
2 "2 The law should permit abortion for reasons/other clearly established" ///
3 "3 The law should permit abortion only in case of rape ..." ///
4 "4 By law, abortion should never be permitted"
label values Abortion92 Abortionattitudes92

*Women's role in society*

gen Women92 = V0128
replace Women92 = . if V0128 == 9
label var Women92 "Attitudes on the Role of Women in Society"
label define Womenrole92 /// 
1 "1 Women and men should have an equal role" 7 "7 Women's place is in the home"
label values Women92 Womenrole92 

*School prayer*

gen Prayer92 = V0112
replace Prayer92 = . if V0112 == 9
replace Prayer92 = 1 if V0112 == 3
replace Prayer92 = 3 if V0112 == 1
label var Prayer92 "Attitudes Toward School Prayer"
label define Prayerschools92 /// 
1 "1 Religion does not belong in the schools" /// 
2 "2 Schools should be allowed to start each day with a prayer, provided the prayer is silent" ///
3 "3 Schools should be allowed to start each day with a prayer" 
label values Prayer92 Prayerschools92

****************
*Exploratory factor analysis of the 1992 elite issue attitudes*
*Note: This procedure is conducted to determine the appropriate "indicator*
*variable" for factors 1 and 2 (social welfare and cultural) in the confirmatory*
*factor analysis*
****************

factor Services92 Welfare92 Unemployed92 Insurance92 Childcare92 Schools92 /// 
Assistblacks92 Environ92 Defense92 Abortion92 Women92 Prayer92, ipf

*Note: The analysis indicates that attitudes toward government services and* 
*abortion are appropriate "indicator variables" for factor 1 and factor 2,* 
*respectively*

****************
*Create a scree plot of the factor analysis results*
*Note: This step is taken almost entirely in the interest of nostalgia!*
****************

screeplot, msymbol(Oh) mcolor(black) ylab(,angle(0)) aspect(1)

****************
*Obtain squared multiple correlation coefficients of each variable with all* 
*other variables*
****************

estat smc

****************
*Confirmatory factor analysis of the 1992 elite issue attitudes*
*Note: Attitudes toward government services and abortion are *appropriate* 
*"indicator variables" for factors 1 and 2 (social welfare and cultural),* 
*respectively*
****************

sem (L1 -> Services92) (L1 -> Welfare92) (L1 -> Unemployed92) /// 
(L1 -> Insurance92) (L1 -> Childcare92) (L1-> Schools92) /// 
(L1 -> Assistblacks92) (L1 -> Environ92) (L1 -> Defense92) /// 
(L2 -> Abortion92) (L2 -> Women92) (L2 -> Prayer92), ///
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent ///
cov (L1*L2) 

****************
*Examine fit statistics for the confirmatory factor analysis*
****************

estat gof, stats(all)

****************
*Correlate ideological self-identifications with factor one, which is* 
*hypothesized to represent ideology*
*Note: This procedure also reports a ninety-five percent confidence interval* 
*for the estimated correlation*
****************

predict Factor192, latent(L1)

corrci Ideology92 Factor192

****************
*Conduct an analysis to examine the demographic profile of the*
*delegates, including race, age, gender, education and income*

*Note: These statistics are calculated for the purpose of examining basic*
*demographic and socioeconomic differences between the delegates and*
*the mass public*
****************

*Race*

gen Race92 = V0404
replace Race92 = . if V0404 == 9
replace Race92 = 0 if V0404 == 1
replace Race92 = 1 if V0404 == 2
label var Race92 "Respondent Race"
label define Racecategory92 0 "0 White" 1 "1 Non-white"
label values Race92 Racecategory92

****************
*Obtain the percentage of whites and non-whites in the sample*
****************

tabulate Race92

****************
*Perform a chisquare test in order to assess the relationship between race*
*and partisanship*
****************

gen Partyid92 = PARTY
label var Partyid92 "Party Identification"
label define Partisanship92 1 "1 Democrat" 2 "2 Republican"
label values Partyid92 Partisanship92

table Partyid

tabulate Race92 Partyid92, chi2

*Gender*

gen Gender92 = V0246
replace Gender92 = . if V0246 == 9
replace Gender92 = 0 if V0246 == 1
replace Gender92 = 1 if V0246 == 2
labe var Gender92 "Respondent Gender"
label define Gendertype92 0 "0 Male" 1 "1 Female"
label values Gender92 Gendertype92

****************
*Obtain the percentage of male and female delgates in the sample*
****************

tabulate Gender92

****************
*Perform a chisquare test in order to assess the relationship between gender*
*and partisanship*
****************

tabulate Gender92 Partyid92, chi2

*Age*

gen Age92 = V0405
replace Age92 = . if V0405 == 9

****************
*Obtain the median sample value for the age variable*
****************

table Age92
summarize Age92, detail

*Education*

gen Education92 = V0407
replace Education92 = . if V0407 == 9
replace Education92 = 4 if V0407 == 5
label var Education92 "Respondent's Level of Education"
label define Educationlevel92 ///
1 "1 High school diploma or less" 2 "3 Some college" ///
3 "3 College graduate" 4 "4 Some graduate school or advanced degree"
label values Education92 Educationlevel92

****************
*Obtain the percentage of delegates who fall into each education category*
****************

tabulate Education92

*Income*

gen Income92 = V0291
replace Income92 = . if V0291 == 99
label var Income92 "Respondent Income"

****************
*Obtain the median sample value for the income variable*
****************

table Income92
summarize Income92, detail
