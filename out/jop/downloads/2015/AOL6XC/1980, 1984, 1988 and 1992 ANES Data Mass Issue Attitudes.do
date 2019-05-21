*1980, 1984, 1988 and 1992 American National Elections Studies Surveys*
*Factor Analysis of Mass Issue Attitudes*
*This project examines the dimensionality of mass public political attitudes*
*over a twenty-four year period, and, importantly, illustrates the differences*
*in the structure of political attitudes that exist within the mass public*

*Sun. 25 July 2010*
*Updated: Thurs. 13 January 2011*
*Updated: Sat. 14 January 2011*
*Updated: Mon. 17 January 2011*
*Updated: Wed. 19 January 2011*
*Updated: Mon. 24 January 2011*
*Updated: Thurs. 27 January 2011*
*Updated: Mon. 21 January 2011*
*Updated: Mon. 25 April 2011*
*Updated: Tues. 26 April 2011*
*Updated: Thurs. 5 May 2011*
*Updated: Mon. 16 May 2011*
*Updated: Tues. 17 May 2011*
*Updated: Thurs. 30 June 2011*
*Updated: Friday 1 July 2011*
*Updated: Mon. 4 July 2011*
*Updated: Tues. 6 September 2011*
*Updated: Wed. 7 September 2011*
*Updated: Thurs. 22 December 2011*
*Updated: Tues. 24 January 2012*
*Updated: Tues. 7 February 2012*
*Updated: Tues. 24 April 2012*
*Updated: Friday 28 September 2012*
*Updated: Tues. 23 October 2012*
*Updated: Thurs. 1 November 2012*
*Updated: Friday 2 November 2012*
*Updated: Thurs. 8 November 2012*
*Updated: Friday 16 November 2012*
*Updated: Saturday 17 November 2012*
*Updated: Mon. 19 November 2012*
*Updated: Wed. 21 November 2012*
*Updated: Friday 30 November 2012*
*Updated: Mon. 3 December 2012*
*Updated: Tues. 4 December 2012*
*Updated: Thurs. 6 December 2012*
*Updated: Sat. 8 December 2012*
*Updated: Tues. 11 December 2012*
*Updated: Wed. 12 December 2012*
*Updated: Thurs. 13 December 2012*
*Updated: Friday 14 December 2012*
*Updated: Mon. 17 December 2012*
*Updated: Tues. 18 December 2012*
*Updated: Wed. 19 December 2012*
*Updated: Mon. 7 January 2013*
*Updated: Thurs. 24 January 2013*
*Updated: Mon. 28 January 2013*
*Updated: Wed. 27 March 2013*
*Updated: Tues. 18 June 2013*
*Updated: Wed. 24 July 2013*
*Updated: Tues. 30 July 2013*
*Updated: Thurs. 7 May 2015*

****************
*1980 ANES Data*
****************

****************
*Recode symbolic predisposition variables*
****************

*Party identification*

*Note: Here, we recode the party identification variable by dividing "strong* 
*partisans" from "not strong partisans."  This step is done to demonstrate* 
*that the high level of constraint exhibited by sophisticated* 
*citizens Ñ particularly "hyper" sophisticates Ñ is not merely an artifact* 
*of partisanship*

gen Partyidm80 = V800266
replace Partyidm80 = . if V800266 == 9
replace Partyidm80 = 1 if V800266 == 2
replace Partyidm80 = 1 if V800266 == 3
replace Partyidm80 = 1 if V800266 == 4
replace Partyidm80 = 1 if V800266 == 5
replace Partyidm80 = 1 if V800266 == 7
replace Partyidm80 = 1 if V800266 == 8
replace Partyidm80 = 2 if V800266 == 0 
replace Partyidm80 = 2 if V800266 == 6
label var Partyidm80 "Partisan Strength"
label define Partisanstrengthm80 /// 
1 "1 Not strong identifiers" 2 "2 Strong party identifiers"
label values Partyidm80 Partisanstrengthm80

*Ideological self-identification*

gen Ideologym80 = V800267
drop if Ideologym80 == 0
drop if Ideologym80 == 8
drop if Ideologym80 == 9
label var Ideologym80 "Ideological Self-identification"
label define Ideologicalidentificationm80 /// 
1 "1 Extremely liberal" 2 "2 Liberal" 3 "3 Slightly liberal" /// 
4 "4 Moderate, middle of the road" 5 "5 Slightly conservative" /// 
6 "6 Conservative" 7 "7 Extremely conservative"
label values Ideologym80 Ideologicalidentificationm80

****************
*Record issue attitude variables*

*Note: The seven issues included in the analysis for 1980 are the following:* 
*assistance to blacks and other minority groups, environmental regulations,* 
*defense spending, relations with Russia, abortion, school prayer and the role* 
*of women in society*

*Note: The abortion and school prayer variables are reverse coded so higher* 
*values reflect more conservative attitudes*
****************

*Government assistance to blacks and other minority groups*

gen Assistblacksm80 = V801062
replace Assistblacksm80 = . if V801062 == 0
replace Assistblacksm80 = . if V801062 == 8
replace Assistblacksm80 = . if V801062 == 9
label var Assistblacksm80 /// 
"Attitudes Toward Government Assistance to Blacks and Other Minority Groups"
label define Assistanceblacksm80 /// 
1 "1 Government should help minority groups" ///
7 "7 Minority groups should help themselves"
label values Assistblacksm80 Assistanceblacksm80

*Environmental regulation*
*Note: This variable is coded so the order of responses is logical*

gen Environm80 = V801141
replace Environm80 = . if V801141 == 8  
replace Environm80 = . if V801141 == 9
replace Environm80 = 2 if V801141 == 6
replace Environm80 = 3 if V801141 == 5
label var Environm80 "Attitudes on Environmental Regulation"
label define Environmentm80 /// 
1 "1 Keep regulations unchanged" 2 "2 Relax regulations, with qualifications" ///
3 "3 Relax regulations"
label values Environm80 Environmentm80

*Defense spending*

gen Defensem80 = V800281 
replace Defensem80 = . if V800281 == 0
replace Defensem80 = . if V800281 == 8
replace Defensem80 = . if V800281 == 9
label var Defensem80 "Attitudes on Defense Spending"
label define Defensespendingm80 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defensem80 Defensespendingm80

*Relations with Russia*

gen Russiam80 = V801078
replace Russiam80 = . if V801078 == 0
replace Russiam80 = . if V801078 == 8
label var Russiam80 "Attitudes on Relations with Russia"
label define Russiarelationsm80 /// 
1 "1 Important to try very hard to get along with Russia" /// 
7 "7 Big mistake to try too hard to get along with Russia"
label values Russiam80 Russiarelationsm80

*Abortion*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Abortionm80 = V800311
replace Abortionm80 = . if V800311 == 7
replace Abortionm80 = . if V800311 == 8
replace Abortionm80 = . if V800311 == 9
replace Abortionm80 = 1 if V800311 == 4
replace Abortionm80 = 2 if V800311 == 3
replace Abortionm80 = 3 if V800311 == 2
replace Abortionm80 = 4 if V800311 == 1
label var Abortionm80 "Attitudes on Abortion"
label define Abortionattitudesm80 /// 
1 "1 By law, a woman should always be able to obtain an abortion as a matter of personal choice" ///
2 "2 The law should permit abortion in cases other than rape, incest or danger to the woman's life, but only after the need for the abortion has been clearly established" ///
3 "3 The law should permit abortion only in cases of rape, incest or when the woman's life is in danger" /// 
4 "4 By law, abortion should never be permitted"
label values Abortionm80 Abortionattitudesm80

*Women's role*

gen Womenm80 = V801094
replace Womenm80 = . if V801094 == 0
replace Womenm80 = . if V801094 == 8
replace Womenm80 = . if V801094 == 9
label var Womenm80 "Attitudes Toward the Role of Women in Society"
label define Womenrolem80 /// 
1 "1 Equal Role" 7 "7 Women's place in home"
label values Womenm80 Womenrolem80 

*School Prayer*
*Note: This variable is reverse coded so higher values reflect more* 
*conservative attitudes*

gen Prayerm80 = V801135
replace Prayerm80 = . if V801135 == 8
replace Prayerm80 = . if V801135 == 9
replace Prayerm80 = 1 if V801135 == 5
replace Prayerm80 = 2 if V801135 == 1
label var Prayerm80 "Attitudes Toward School Prayer"
label define Prayerschoolm80 /// 
1 "1 Religion does not belong in the schools" /// 
2 "2 Schools should be allowed to start each day with a prayer"
label values Prayerm80 Prayerschoolm80

****************
*Recode political sophistication variables*

*Note: Political sophistication is conceptualized in this analysis as a*
*combination of political knowledge, interest and involvement*

*Note: These variables are all reverse coded so that higher values reflect* 
*greater political sophistication*
****************

****************
*Recode political knowledge variable*

*Note: Political knowledge is conceptualized in this analysis as the* 
*interviewer's assessment of the respondent's level of general* 
*political information*
****************

*Political knowledge*
*Note: This variable is reverse coded so that higher values reflect greater* 
*political knowledge*

gen Knowledgem80 = V800726
replace Knowledgem80 = . if V800726 == 9
replace Knowledgem80 = 0 if V800726 == 5 
replace Knowledgem80 = 1 if V800726 == 4
replace Knowledgem80 = 2 if V800726 == 3
replace Knowledgem80 = 3 if V800726 == 2
replace Knowledgem80 = 4 if V800726 == 1
label var Knowledgem80 /// 
"Interviewer's Assessment of the Respondent's Level of Political Information"
label define Knowledgepoliticsm80 /// 
0 "0 Very low" 1 "1 Fairly Low" 2 "2 Average" 3 "3 Fairly High" 4 "4 Very High"
label values Knowledgem80 Knowledgepoliticsm80

****************
*Divide the political knowledge variable by the number of non-zero categories* 
*it contains (4) so that the variable ranges from zero to one*
****************

gen Knowledge2m80 = Knowledgem80/4

****************
*Recode interest in the political campaigns variable*
****************

*Interest in the campaigns*
*Note: This variable is reverse coded so that higher values reflect greater* 
*political interest*

gen Interestm80 = V800053
replace Interestm80 = . if V800053 == 8 
replace Interestm80 = . if V800053 == 9
replace Interestm80 = 0 if V800053 == 5
replace Interestm80 = 1 if V800053 == 3
replace Interestm80 = 2 if V800053 == 1
label var Interestm80 "Interest in the the Campaigns"
label define Interestcampaignm80 /// 
0 "0 Not much interested" 1 "1 Somewhat interested" 2 "2 Very much interested"
label values Interestm80 Interestcampaignm80 

****************
*Divide the interest in the campaigns variable by the number of non-zero* 
*categories it contains (2) so that the variable ranges from zero to one*
****************

gen Interest2m80 = Interestm80/2

****************
*Recode political involvement variables*

*Note: These variables are recoded so that higher values reflect greater* 
*political involvement*
****************

*Attendance at political events*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Attendm80 = V800795
replace Attendm80 = . if V800795 == 9
replace Attendm80 = 0 if V800795 == 5
label var Attendm80 "Attend a Political Event"
label define Attendancem80 /// 
0 "0 No" 1 "1 Yes"
label values Attendm80 Attendancem80

*Work for a political candidate*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Workm80 = V800796
replace Workm80 = . if V800796 == 9
replace Workm80 = 0 if V800796 == 5
label var Workm80 "Work for a Political Candidate"
label define Workedm80 /// 
0 "0 No" 1 "1 Yes"
label values Workm80 Workedm80

*Political expression in the form of a campaign button or sticker*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Displaym80 = V800797
replace Displaym80 = . if V800797 == 9
replace Displaym80 = 0 if V800797 == 5
label var Displaym80 "Display a Campaign Button or Sticker"
label define Displaypoliticsm80 /// 
0 "0 No" 1 "1 Yes"
label values Displaym80 Displaypoliticsm80

*Donation to a political candidate*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatecm80 = V800802
replace Donatecm80 = . if V800802 == 8
replace Donatecm80 = . if V800802 == 9
replace Donatecm80 = 0 if V800802 == 5
label var Donatecm80 "Donate money to a political candidate"
label define Donatecandidatem80 /// 
0 "0 No" 1 "1 Yes"
label values Donatecm80 Donatemoneycm80

*Donation to a political party*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatepm80 = V800811
replace Donatepm80 = . if V800811 == 8
replace Donatepm80 = . if V800811 == 9
replace Donatepm80 = 0 if V800811 == 5
label var Donatepm80 "Donate money to a political party"
label define Donatepartym80 /// 
0 "0 No" 1 "1 Yes"
label values Donatepm80 Donatepartym80

****************
*Create a five-point political involvement index that will be used to display* 
*summary statistics of political involvement*
****************

gen Involvementindexm80 = Attendm80 + Workm80 + Displaym80 + Donatecm80 /// 
+ Donatepm80

summarize Involvementindexm80

****************
*Create an eleven-point political sophistication index that combines measures* 
*of political knowledge, interest and involvement*

*Note: This index will be used to display summary statistics of the* 
*sophistication measure*
****************

gen Sophisticationindexm80 = Knowledgem80 + Interestm80 + Involvementindexm80

summarize Sophisticationindexm80

****************
*Plot a histogram of the sophistication index*
****************

histogram Sophisticationindexm80, aspect(1) fcolor(gs14) lcolor(black) /// 
discrete scheme(s1mono) ///
plotregion(lcolor(black))graphregion(margin(medsmall)) ///
title("1980", size(huge)) ///
xlabel(0 (5) 10,labsize(huge)) ///
xtitle("Sophistication", size(huge)) ///
ylabel(0.0 (0.1) 0.2, format(%02.1f) labsize(huge))  ///
ytitle("Density", size(huge))

****************
*Graph a kernel density plot of the sophistication index*
****************

kdensity Sophisticationindexm80, aspect(1) scheme(s1mono) 

****************
*Create a political sophistication scale ranging from zero to one that* 
*combines measures of political knowledge, interest and involvement*

*Note: This scale will become the basis of analysis for this paper*
****************

alpha Knowledge2m80 Interest2m80 Attendm80 Workm80 Displaym80 Donatecm80 /// 
Donatepm80, detail item generate(Sophisticationscalem80) casewise

summarize Sophisticationscalem80

****************
*Create a new variable by stratifying the sophistication scale into thirds,* 
*corresponding to the "least," "moderately" and "most" politically* 
*sophisticated respondents in the sample*
****************

display 883/3

table Sophisticationscalem80

gen Sophisticationm80 = .
replace Sophisticationm80 = 1 if Sophisticationscalem80 < .15
replace Sophisticationm80 = 2 if Sophisticationscalem80 > .15 & /// 
Sophisticationscalem80 <= .25
replace Sophisticationm80 = 3 if Sophisticationscalem80 > .25 & /// 
Sophisticationscalem80 < .

summarize Sophisticationm80

table Sophisticationm80

****************
*Obtain summary statistics (mean and standard deviation) for the components* 
*of the sophistication index, as well as the sophistication index itself,* 
*for each of the three segments of the mass public we have identified*
*for this analysis*

*Note: The summary statistics for the entire sample for the political* 
*knowledge and interest in the campaigns variables are calculated here, too*
****************

*Political Knowledge*

summarize Knowledgem80

summarize Knowledgem80 if Sophisticationm80 == 1

summarize Knowledgem80 if Sophisticationm80 == 2

summarize Knowledgem80 if Sophisticationm80 == 3

*Interest in the campaigns*

summarize Interestm80

summarize Interestm80 if Sophisticationm80 == 1

summarize Interestm80 if Sophisticationm80 == 2

summarize Interestm80 if Sophisticationm80 == 3

*Involvement Index*

summarize Involvementindexm80 if Sophisticationm80 == 1

summarize Involvementindexm80 if Sophisticationm80 == 2

summarize Involvementindexm80 if Sophisticationm80 == 3

*Sophistication Index*

summarize Sophisticationindexm80 if Sophisticationm80 == 1

summarize Sophisticationindexm80 if Sophisticationm80 == 2

summarize Sophisticationindexm80 if Sophisticationm80 == 3

****************
*Exploratory factor analysis of the 1980 mass issue attitudes*

*Note: This procedure is conducted to determine appropriate "indicator*
*variables" for factors 1 and 2 (social welfare and cultural) in the* 
*confirmatory factor analysis*
****************

factor Assistblacksm80 Environm80 Defensem80 Russiam80 Abortionm80 Womenm80 ///
Prayerm80, ipf

*Note: The analysis indicates that attitudes toward defense spending and* 
*the role of women in society are appropriate indicator variables*
*for factor 1 and factor 2 (social welfare and cultural), respectively*

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
*Confirmatory factor analysis of the 1980 mass issue attitudes*

*Note: Attitudes toward defense spending and the role of women are used as*
*"indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*

*Note: This step is done to assess the factor correlation between factors one*
*and two for the full ANES sample*
****************

sem (L1 -> Defensem80) (L1 -> Assistblacksm80) (L1 -> Environm80) /// 
(L1 -> Russiam80) (L2 -> Womenm80) (L2 -> Abortionm80) (L2 -> Prayerm80), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2)

estat gof, stats (all)

****************
*Confirmatory multiple groups factor analysis of the 1980 mass issue attitudes*

*Note: Attitudes toward defense spending and the role of women are used as*
*"indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*

*Note: This step is done to obtain the correlation between ideological*
*self-identifications and factor one for the entire mass public sample*
*in 1980*

*Note: This step also is done to assess equality of means and variances* 
*across groups*
****************

sem (L1 -> Defensem80) (L1 -> Assistblacksm80) (L1 -> Environm80) /// 
(L1 -> Russiam80) (L2 -> Womenm80) (L2 -> Abortionm80) (L2 -> Prayerm80), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2) group (Sophisticationm80)

estat gof, stats (all)

estat ginvariant

predict Factor1m80, latent (L1)

net search corrci

corrci Ideologym80 Factor1m80

*Here, we observe that the assistance to blacks item does not exhibit* 
*residual invariance*

****************
*Stratify the mass public according to sophistication, which is a scale* 
*combining measures of political knowledge, interest and involvement*

*Note: The stratification procedure divides the mass public into three groups*
*according to their level of political sophistication*

*Note: The ideological self-identifications variable is used in this procedure*
*because ideological self-identifications of individuals who fall into*
*each sophistication group later will be correlated with the first retained* 
*factor in the analysis*
****************
  
gen Ideologym802 = Ideologym80 if Sophisticationm80 == 1

gen Ideologym803 = Ideologym80 if Sophisticationm80 == 2

gen Ideologym804 = Ideologym80 if Sophisticationm80 == 3

****************
*Confirmatory factor analysis of the 1980 mass issue attitudes for the* 
*stratified sample*

*This step investigates more fully our hypothesis that a lack* 
*of sophistication drives the apparently multidimensional structure* 
*of mass political attitudes*

*Note: For each segment of the stratified sample, model fit is assessed* 
*and the correlation between the ideological self-identifications of citizens* 
*who fall in the group being examined and the first retained* 
*factor (hypothesized to be ideology) is estimated*

*Note: The reported estimates thus reflect differences in the correlation*
*between ideological self-identifications and the first retained factor*
*across sophistication groups*

*Note: The procedure reports a ninety-five percent confidence interval* 
*for the estimated correlation*

*Note: Ultimately, the key difference between this analysis and the prior*
*exploratory factor analysis is that the first retained factor here, although*
*representing ideology in each case, is estimated separately for each segment* 
*of the stratified sample*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

sem (L1 -> Defensem80) (L1 -> Assistblacksm80) (L1 -> Environm80) /// 
(L1 -> Russiam80) (L2 -> Abortionm80) (L2 -> Womenm80) (L2 -> Prayerm80), ///
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2), if Sophisticationm80 == 1

estat gof, stats (all)

predict Factor1m80low, latent (L1)

corrci Ideologym802 Factor1m80low

****************
*Moderately politically sophisticated third of the stratified sample*
****************

sem (L1 -> Defensem80) (L1 -> Assistblacksm80) (L1 -> Environm80) /// 
(L1 -> Russiam80) (L2 -> Abortionm80) (L2 -> Womenm80) (L2 -> Prayerm80), ///
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2), if Sophisticationm80 == 2

estat gof, stats (all)

predict Factor1m80middle, latent (L1)

corrci Ideologym803 Factor1m80middle

****************
*Most politically sophisticated third of the stratified sample*
****************

sem (L1 -> Defensem80) (L1 -> Assistblacksm80) (L1 -> Environm80) /// 
(L1 -> Russiam80) (L2 -> Abortionm80) (L2 -> Womenm80) (L2 -> Prayerm80), ///
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2), if Sophisticationm80 == 3

estat gof, stats (all)

predict Factor1m80high, latent (L1)

corrci Ideologym804 Factor1m80high

****************
*Stratify the mass public according to sophistication once more, but this time*
*the variable is measured for a small fraction of the mass public representing* 
*the absolutely most politically knowledgeable, interested and involved* 
*citizens in other words, these citizens represent the members of the* 
*electorate who we most expect to resemble political elites in their* 
*organization of political attitudes*

*Specifically, these "hyper" sophisticates are operationalized as possessing* 
*a "very high" level of general political information, being* 
*"very much interested" in the campaign and having participated in at least* 
*one political activity during the course of the campaign*
****************

gen Ideologym805 = Ideologym80 if Knowledgem80 == 4 & Interestm80 == 2 & /// 
Involvementindexm80 > 0 

****************
*Correlate ideological self-identifications of the stratified sample* 
*(by sophistication) with the first retained factor*

*This procedure obtains correlations between the first retained factor and* 
*ideological identifications for the absolutely most politically* 
*knowledgeable, interested and involved citizens - our "hyper" sophisticates*

*Note: Considering the limited sample of "hyper sophisticates" in several*
*years in included in the analysis," no separate factor model is specified* 
*for these individuals*

*Rather, their ideological self-identifications are correlated with the first*
*retained factor obtained for the most sophisticated third of the sample using*
*the alternate method*

*Note: This procedure reports a ninety-five percent confidence interval* 
*for the estimated correlations*
****************

gen Hypersophisticatesm80 = .
replace Hypersophisticatesm80 = 1 if Ideologym805 == 1
replace Hypersophisticatesm80 = 1 if Ideologym805 == 2
replace Hypersophisticatesm80 = 1 if Ideologym805 == 3
replace Hypersophisticatesm80 = 1 if Ideologym805 == 4
replace Hypersophisticatesm80 = 1 if Ideologym805 == 5
replace Hypersophisticatesm80 = 1 if Ideologym805 == 6
replace Hypersophisticatesm80 = 1 if Ideologym805 == 7

corrci Ideologym805 Factor1m80high

****************
*Conduct a series of robustness checks to demonstrate that the sophistication* 
*effects are not a simple reflection of partisanship*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

corrci Ideologym802 Factor1m80low if Partyidm80 == 1

corrci Ideologym802 Factor1m80low if Partyidm80 == 2

****************
*Moderately politically sophisticated third of the stratified sample*
****************

corrci Ideologym803 Factor1m80middle if Partyidm80 == 1

corrci Ideologym803 Factor1m80middle if Partyidm80 == 2

****************
*Most politically sophisticated third of the stratified sample*
****************

corrci Ideologym804 Factor1m80high if Partyidm80 == 1

corrci Ideologym804 Factor1m80high if Partyidm80 == 2

****************
*"Hyper" sophisticates*
****************

corrci Ideologym805 Factor1m80high if Partyidm80 == 1

corrci Ideologym805 Factor1m80high if Partyidm80 == 2

****************
*1984 ANES Data*
****************

****************
*Recode symbolic predisposition variables*
****************

*Party identification*

*Note: Here, we recode the party identification variable by dividing "strong* 
*partisans" from "not strong partisans."  This step is done to demonstrate* 
*that the high level of constraint exhibited by sophisticated* 
*citizens particularly "hyper" sophisticates is not merely an artifact*
*of partisanship*

gen Partyidm84 = V840318
replace Partyidm84 = . if V840318 == 9
replace Partyidm84 = 1 if V840318 == 2
replace Partyidm84 = 1 if V840318 == 3
replace Partyidm84 = 1 if V840318 == 4
replace Partyidm84 = 1 if V840318 == 5
replace Partyidm84 = 1 if V840318 == 7
replace Partyidm84 = 1 if V840318 == 8
replace Partyidm84 = 2 if V840318 == 0 
replace Partyidm84 = 2 if V840318 == 6
label var Partyidm84 "Partisan Strength"
label define Partisanstrengthm84 /// 
1 "1 Not strong identifiers" 2 "2 Strong party identifiers"
label values Partyidm84 Partisanstrengthm84

*Ideological self-identification*

gen Ideologym84 = V840122
replace Ideologym84 = . if V840122 == 00
replace Ideologym84 = . if V840122 == 8
replace Ideologym84 = . if V840122 == 99
label var Ideologym84 "Ideological Self-identification"
label define Ideologicalidentificationm84 /// 
1 "1 Extremely liberal" 2 "2 Liberal" 3 "3 Slightly liberal" /// 
4 "4 Moderate, middle of the road" 5 "5 Slightly conservative" /// 
6 "6 Conservative" 7 "7 Extremely conservative"
label values Ideologym84 Ideologicalidentificationm84

****************
*Recode issue attitude variables*

*Note: The eight issues included in the analysis for 1984 are the following:* 
*public school spending, assistance to blacks and other minority groups,* 
*environmental regulations, defense spending, relations with Russia, abortion,* 
*school prayer and the role of women in society*

*Note: The abortion and school prayer variables are reverse coded so higher* 
*values reflect more conservative attitudes*
****************

*Public school spending*

gen Schoolsm84 = V840998
replace Schoolsm84 = . if V840998 == 8
replace Schoolsm84 = . if V840998 == 9
label var Schoolsm84 "Attitudes Toward Public School Spending"
label define Publicschoolsm84 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Decreased"
label values Schoolsm84 Publicschoolsm84

*Government assistance to blacks and other minority groups*

gen Assistblacksm84 = V840382
replace Assistblacksm84 = . if V840382 == 0
replace Assistblacksm84 = . if V840382 == 8
replace Assistblacksm84 = . if V840382 == 9
label var Assistblacksm84 /// 
"Attitudes Toward Government Assistance to Blacks and Other Minority Groups"
label define Assistansblacksm84 /// 
1 "1 Government should help minority groups" /// 
7 "7 Minority groups should help themselves"
label values Assistblacksm84 Assistanceblacksm84

*Spending on the environment*

gen Environm84 = V840996
replace Environm84 = . if V840996 == 8
replace Environm84 = . if V840996 == 9
label var Environm84 "Attitudes on Environmental Spending"
label define Environmentm84 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Decreased"
label values Environm84 Environmentm84

*Defense spending*

gen Defensem84 = V840395
replace Defensem84 = . if V840395 == 0
replace Defensem84 = . if V840395 == 8
replace Defensem84 = . if V840395 == 9
label var Defensem84 "Attitudes on Defense Spending"
label define Defensespendingm84 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defensem84 Defensespendingm84

*Relations with Russia*

gen Russiam84 = V840408
replace Russiam84 = . if V840408 == 0
replace Russiam84 = . if V840408 == 8
replace Russiam84 = . if V840408 == 9
label var Russiam84 "Attitudes on Relations with Russia"
label define Russiarelationsm84 /// 
1 "1 Try to cooperate more with Russia" 7 "7 Get much tougher with Russia"
label values Russiam84 Russiarelationsm84

*Abortion*
*Note: This variable is recoded so higher values reflect more* 
*conservative attitudes*

gen Abortionm84 = V840423 
replace Abortionm84 = . if V840423 == 7
replace Abortionm84 = . if V840423 == 8
replace Abortionm84 = . if V840423 == 9
replace Abortionm84 = 1 if V840423 == 4
replace Abortionm84 = 2 if V840423 == 3
replace Abortionm84 = 3 if V840423 == 2
replace Abortionm84 = 4 if V840423 == 1
label var Abortionm84 "Attitudes on Abortion"
label define Abortionattitudesm84 /// 
1 "By law, a woman should always be able to obtain an abortion as a matter of personal choice" /// 
2 "The law should permit abortion in cases other than rape, incest or danger to the woman's life, but only after the need for the abortion has been clearly established" ///
3 "The law should permit abortion only in cases of rape, incest or when the woman's life is in danger" ///
4 "By law, abortion should never be permitted"
label values Abortionm84 Abortionattitudesm84

*Women's role*

gen Womenm84 = V840250
replace Womenm84 = . if V840250 == 0
replace Womenm84 = . if V840250 == 8
replace Womenm84 = . if V840250 == 9
label var Womenm84 "Attitudes on the Role of Women in Society"
label define Womenrolem88 ///
1 "1 Women have equal role" 7 "7 Women's place is in the home"
label values Womenm84 Womenrolem84 

*School Prayer*
*Note: This variable is recoded so higher values reflect more* 
*conservative attitudes*

gen Prayerm84 = V841038
replace Prayerm84 = . if V841038 == 0
replace Prayerm84 = . if V841038 == 7
replace Prayerm84 = . if V841038 == 8
replace Prayerm84 = . if V841038 == 9
replace Prayerm84 = 1 if V841038 == 5
replace Prayerm84 = 2 if V841038 == 1
label var Prayerm84 "Attitudes Toward School Prayer"
label define Prayerschoolm84 /// 
1 "1 Religion does not belong in the schools" /// 
2 "2 Schools should be allowed to start each day with a prayer"
label values Prayerm84 Prayerschoolm84

****************
*Recode political sophistication variables*

*Note: Political sophistication is conceptualized in this analysis as a*
*combination of political knowledge, interest and involvement*

*Note: These variables are all reverse coded so that higher values reflect* 
*greater political sophistication*
****************

****************
*Recode political knowledge variable*

*Note: Political knowledge is conceptualized in this analysis as the* 
*interviewer's assessment of the respondent's level of general* 
*political information*
****************

*Political knowledge*
*Note: This variable is reverse coded so that higher values reflect greater* 
*political knowledge*

gen Knowledgem84 = V840713
replace Knowledgem84 = . if V840713 == 9
replace Knowledgem84 = . if V840713 == 5
replace Knowledgem84 = 1 if V840713 == 4
replace Knowledgem84 = 2 if V840713 == 3
replace Knowledgem84 = 3 if V840713 == 2
replace Knowledgem84 = 4 if V840713 == 1
label var Knowledgem84 /// 
"Interviewer's Assessment of the Respondent's Level of Political Information"
label define Knowledgepoliticsm84 /// 
0 "0 Very low" 1 "1 Fairly Low" 2 "2 Average" 3 "3 Fairly High" 4 "4 Very High"
label values Knowledgem84 Knowledgepoliticsm84

****************
*Divide the political knowledge variable by the number of non-zero categories* 
*it contains (4) so that the variable ranges from zero to one*
****************

gen Knowledge2m84 = Knowledgem84/4

****************
*Recode interest in the political campaigns variable*
*Note: This variable is recoded so that higher values reflect greater* 
*political interest*
****************

*Interest in the campaigns*

gen Interestm84 = V840075
replace Interestm84 = . if V840075 == 8 
replace Interestm84 = . if V840075 == 9
replace Interestm84 = 0 if V840075 == 5
replace Interestm84 = 1 if V840075 == 3
replace Interestm84 = 2 if V840075 == 1
label var Interestm84 "Interest in the Campaigns"
label define Interestcampaignm84 /// 
0 "0 Not much interested" 1 "1 Somewhat interested" 2 "2 Very much interested"
label values Interestm84 Interestcampaignm84 

****************
*Divide the interest in the campaigns variable by the number of non-zero*
*categories it contains (2) so that the variable ranges from zero to one*
****************

gen Interest2m84 = Interestm84/2

****************
*Recode political involvement variables*
*Note: These variables are recoded so that higher values reflect greater*
*political involvement*
****************

*Attendance at political events*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Attendm84 = V840821
replace Attendm84 = . if V840821 == 9
replace Attendm84 = 0 if V840821 == 5
label var Attendm84 "Attend a Political Event"
label define Attendancem84 /// 
0 "0 No" 1 "1 Yes"
label values Attendm84 Attendancem84

*Work for a political candidate or party*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Workm84 = V840823
replace Workm84 = . if V840823 == 9
replace Workm84 = 0 if V840823 == 5
label var Workm84 "Work for a Political Candidate or Party"
label define Workedm84 /// 
0 "0 No" 1 "1 Yes"
label values Workm84 Workedm84

*Political expression in the form of a campaign button, sticker or flag*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Displaym84 = V840819
replace Displaym84 = . if V840819 == 9
replace Displaym84 = 0 if V840819 == 5
label var Displaym84 "Display a Campaign Button, Sticker or Flag"
label define Displaypoliticsm84 /// 
0 "0 No" 1 "1 Yes"
label values Displaym84 Displaypoliticsm84

*Donation to a political candidate or party*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatecpm84 = V840825
replace Donatecpm84 = . if V840825 == 8
replace Donatecpm84 = . if V840825 == 9
replace Donatecpm84 = 0 if V840825 == 5
label var Donatecpm84 "Donate money to a political candidate"
label define Donatemoneym84 /// 
0 "0 No" 1 "1 Yes"
label values Donatecpm84 Donatemoneycm84

****************
*Create a five-point political involvement index that will be used to display* 
*summary statistics of political involvement*
****************

gen Involvementindexm84 = Attendm84 + Workm84 + Displaym84 + Donatecpm84 

summarize Involvementindexm84

****************
*Create an eleven-point political sophistication index that combines measures* 
*of political knowledge, interest and involvement*
*Note: This index will be used to display summary statistics of the* 
*sophistication measure*
****************

gen Sophisticationindexm84 = Knowledgem84 + Interestm84 + Involvementindexm84

summarize Sophisticationindexm84

****************
*Plot a histogram of the sophistication index*
****************

histogram Sophisticationindexm84, aspect(1) fcolor(gs14) lcolor(black) /// 
discrete scheme(s1mono) ///
plotregion(lcolor(black))graphregion(margin(medsmall)) ///
title("1984", size(huge)) ///
xlabel(0 (5) 10,labsize(huge)) ///
xtitle("Sophistication", size(huge)) ///
ylabel(0.0 (0.1) 0.2, format(%02.1f) labsize(huge))  ///
ytitle("Density", size(huge))

****************
*Graph a kernel density plot of the sophistication index*
****************

kdensity Sophisticationindexm84, aspect(1) scheme(s1mono) 

****************
*Create a political sophistication scale ranging from zero to one that* 
*combines measures of political knowledge, interest and involvement*
*Note: This scale will become the basis of analysis for this paper*
****************

alpha Knowledge2m84 Interest2m84 Attendm84 Workm84 Displaym84 Donatecpm84, /// 
detail item generate(Sophisticationscalem84) casewise

summarize Sophisticationscalem84

****************
*Create a new variable by stratifying the sophistication scale into thirds,* 
*corresponding to the "least," "moderately" and "most" politically* 
*sophisticated respondents in the sample*
****************

display 1787/3

table Sophisticationscalem84

gen Sophisticationm84 = .
replace Sophisticationm84 = 1 if Sophisticationscalem84 < .25
replace Sophisticationm84 = 2 if Sophisticationscalem84 >= .25 & /// 
Sophisticationscalem84 < .34
replace Sophisticationm84 = 3 if Sophisticationscalem84 > .34 & ///
Sophisticationscalem84 < .

summarize Sophisticationm84

table Sophisticationm84

****************
*Obtain summary statistics (mean and standard deviation) for the components* 
*of the sophistication index, as well as the sophistication index itself,* 
*for each of the three segments of the mass public we have identified*
*for this analysis*

*Note: The summary statistics for the entire sample for the political* 
*knowledge and interest in the campaigns variables are calculated here, too*
****************

*Political Knowledge*

summarize Knowledgem84

summarize Knowledgem84 if Sophisticationm84 == 1

summarize Knowledgem84 if Sophisticationm84 == 2

summarize Knowledgem84 if Sophisticationm84 == 3

*Interest in the campaigns*

summarize Interestm84

summarize Interestm84 if Sophisticationm84 == 1

summarize Interestm84 if Sophisticationm84 == 2

summarize Interestm84 if Sophisticationm84 == 3

*Involvement Index*

summarize Involvementindexm84 if Sophisticationm84 == 1

summarize Involvementindexm84 if Sophisticationm84 == 2

summarize Involvementindexm84 if Sophisticationm84 == 3

*Sophistication Index*

summarize Sophisticationindexm84 if Sophisticationm84 == 1

summarize Sophisticationindexm84 if Sophisticationm84 == 2

summarize Sophisticationindexm84 if Sophisticationm84 == 3

****************
*Exploratory factor analysis of the 1984 mass issue attitudes*

*Note: This procedure is conducted to determine appropriate "indicator*
*variables" for factors 1 and 2 (social welfare and cultural) in the /// 
*confirmatory factor analysis*
****************

factor Schoolsm84 Assistblacksm84 Environm84 Defensem84 Russiam84 Abortionm84 /// 
Womenm84 Prayerm84, ipf

*Note: The analysis indicates that attitudes toward defense spending and* 
*school prayer are appropriate indicator variables*
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
*Confirmatory factor analysis of the 1984 mass issue attitudes*

*Note: Attitudes toward defense spending and school prayer are used as*
*"indicator variables" for factors 1 and 2 (social welfare and cultural),* 
*respectively*

*Note: This step is done to assess the factor correlation between factors one*
*and two for the full ANES sample*
****************

sem (L1 -> Defensem84) (L1 -> Schoolsm84) (L1 -> Assistblacksm84) /// 
(L1 -> Environm84) (L1 -> Russiam84) (L2 -> Womenm84) (L2 -> Abortionm84) /// 
(L2 -> Prayerm84), covstruct (_lexogenous, diagonal) standard latent (L1 L2) /// 
nocapslatent cov (L1*L2) 

estat gof, stats (all)

****************
*Confirmatory multiple groups factor analysis of the 1984 mass issue attitudes*

*Note: Attitudes toward defense spending and school prayer are used as*
*"indicator variables" for factors 1 and 2 (social welfare and cultural),* 
*respectively*

*Note: This step is done to obtain the correlation between ideological*
*self-identifications and factor one for the entire mass public sample*
*in 1984*

*Note: This step also is done to assess equality of means and variances* 
*across groups*
****************

sem (L1 -> Defensem84) (L1 -> Schoolsm84) (L1 -> Assistblacksm84) /// 
(L1 -> Environm84) (L1 -> Russiam84) (L2 -> Womenm84) (L2 -> Abortionm84) /// 
(L2 -> Prayerm84), covstruct (_lexogenous, diagonal) standard latent (L1 L2) /// 
nocapslatent cov (L1*L2) group (Sophisticationm84) 

estat gof, stats (all)

estat ginvariant

predict Factor1m84, latent (L1)

corrci Ideologym84 Factor1m84

*Here, we observe that the Russia item does not exhibit mean invariance, and*
*the defense and abortion items do not exhibit residual invariance*

****************
*Stratify the mass public according to sophistication, which is a scale* 
*combining political knowledge, interest and involvement*

*Note: The stratification procedure divides the mass public into three groups* 
*according to their level of political sophistication*

*Note: The ideological self-identifications variable is used in this procedure*
*because ideological self-identifications of individuals who fall into*
*each sophistication group later will be correlated with the first retained* 
*factor in the analysis*
****************

gen Ideologym842 = Ideologym84 if Sophisticationm84 == 1

gen Ideologym843 = Ideologym84 if Sophisticationm84 == 2

gen Ideologym844 = Ideologym84 if Sophisticationm84 == 3

****************
*Confirmatory factor analysis of the 1984 mass issue attitudes for the* 
*stratified sample*

*This step investigates more fully our hypothesis that a lack* 
*of sophistication drives the apparently multidimensional structure* 
*of mass political attitudes*

*Note: For each segment of the stratified sample, model fit is assessed* 
*and the correlation between the ideological self-identifications of citizens* 
*who fall in the group being examined and the first retained* 
*factor (hypothesized to be ideology) is estimated*

*Note: The procedure reports a ninety-five percent confidence interval* 
*for the estimated correlation*

*Note: The reported estimates thus reflect differences in the correlation*
*between ideological self-identifications and the first retained factor*
*across sophistication groups*

*Note: Ultimately, the key difference between this analysis and the prior*
*exploratory factor analysis is that the first retained factor here, although*
*representing ideology in each case, is estimated separately for each segment* 
*of the stratified sample*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

sem (L1 -> Defensem84) (L1 -> Schoolsm84) (L1 -> Environm84) /// 
(L1 -> Russiam84) (L1 -> Assistblacksm84) (L2 -> Abortionm84) /// 
(L2 -> Womenm84) (L2 -> Prayerm84), covstruct(_lexogenous, diagonal) ///
standard latent (L1 L2) nocapslatent cov (L1*L2), if Sophisticationm84 == 1

estat gof, stats (all)

predict Factor1m84low, latent (L1)

corrci Ideologym842 Factor1m84low

****************
*Moderately politically sophisticated third of the stratified sample*
****************

sem (L1 -> Defensem84) (L1 -> Schoolsm84) (L1 -> Assistblacksm84) /// 
(L1 -> Environm84) (L1 -> Russiam84) (L2 -> Abortionm84) (L2 -> Womenm84) /// 
(L2 -> Prayerm84), covstruct (_lexogenous, diagonal) standard /// 
latent (L1 L2) nocapslatent cov (L1*L2), if Sophisticationm84 == 2

estat gof, stats(all)

predict Factor1m84middle, latent(L1)

corrci Ideologym843 Factor1m84middle

****************
*Most politically sophisticated third of the stratified sample*
****************

sem (L1 -> Defensem84) (L1 -> Schoolsm84) (L1 -> Assistblacksm84) /// 
(L1 -> Environm84) (L1 -> Russiam84) (L2 -> Abortionm84) (L2 -> Womenm84) /// 
(L2 -> Prayer), covstruct (_lexogenous, diagonal) standard /// 
latent (L1 L2) nocapslatent cov (L1*L2), if Sophisticationm84 == 3

estat gof, stats(all)

predict Factor1m84high, latent(L1)

corrci Ideologym844 Factor1m84high

****************
*Stratify the mass public according to sophistication once more, but this time*
*the variable is measured for a small fraction of the mass public representing* 
*the absolutely most politically knowledgeable, interested and involved* 
*citizens Ñ in other words, these citizens represent the members of the* 
*electorate who we expect to most resemble political elites in their* 
*organization of political attitudes*

*Specifically, these "hyper" sophisticates are operationalized as possessing* 
*a "very high" level of general political information, being*
*"very much interested" in the campaign and having participated in at least* 
*one political activity during the course of the campaign*
****************

gen Ideologym845 = Ideologym84 if Knowledgem84 == 4 & Interestm84 == 2 & /// 
Involvementindexm84 > 0 

****************
*Correlate ideological self-identifications of the stratified sample* 
*(by sophistication) with the first retained factor*

*This procedure obtains correlations between the first retained factor and* 
*ideological identifications for the absolutely most politically* 
*knowledgeable, interested and involved citizens Ñ our "hyper" sophisticates*

*Note: Considering the limited sample of "hyper sophisticates" in several*
*years in included in the analysis," no separate factor model is specified* 
*for these individuals*

*Rather, their ideological self-identifications are correlated with the first*
*retained factor obtained for the most sophisticated third of the sample using*
*the alternate method*

*Note: This procedure reports a ninety-five percent confidence interval* 
*for the estimated correlations*
****************

gen Hypersophisticatesm84 = .
replace Hypersophisticatesm84 = 1 if Ideologym845 == 1
replace Hypersophisticatesm84 = 1 if Ideologym845 == 2
replace Hypersophisticatesm84 = 1 if Ideologym845 == 3
replace Hypersophisticatesm84 = 1 if Ideologym845 == 4
replace Hypersophisticatesm84 = 1 if Ideologym845 == 5
replace Hypersophisticatesm84 = 1 if Ideologym845 == 6
replace Hypersophisticatesm84 = 1 if Ideologym845 == 7

sem (L1 -> Defensem84) (L1 -> Schoolsm84) (L1 -> Assistblacksm84) /// 
(L1 -> Environm84) (L1 -> Russiam84) (L2 -> Abortionm84) (L2 -> Womenm84) /// 
(L2 -> Prayer), covstruct (_lexogenous, diagonal) standard /// 
latent (L1 L2) nocapslatent cov (L1*L2), if Hypersophisticatesm84 == 1

predict Factor184mhighest, latent(L1)

corrci Ideologym845 Factor1m84high

****************
*Conduct a series of robustness checks to demonstrate that the sophistication* 
*effects are not a simple 1984reflection of partisanship*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

corrci Ideologym842 Factor1m84low if Partyidm84 == 1

corrci Ideologym842 Factor1m84low if Partyidm84 == 2

****************
*Moderately politically sophisticated third of the stratified sample*
****************

corrci Ideologym843 Factor1m84middle if Partyidm84 == 1

corrci Ideologym843 Factor1m84middle if Partyidm84 == 2

****************
*Most politically sophisticated third of the stratified sample*
****************

corrci Ideologym844 Factor1m84high if Partyidm84 == 1

corrci Ideologym844 Factor1m84high if Partyidm84 == 2

****************
*"Hyper" sophisticates*
****************

corrci Ideologym845 Factor1m84high if Partyidm84 == 1

corrci Ideologym845 Factor1m84high if Partyidm84 == 2

****************
*1988 ANES Data*
****************

****************
*Recode symbolic predisposition variables*
****************

*Party identification*

*Note: Here, we recode the party identification variable by dividing "strong* 
*partisans" from "not strong partisans."  This step is done to demonstrate* 
*that the high level of constraint exhibited by sophisticated* 
*citizens Ñ particularly "hyper" sophisticates  Ñ is not merely an artifact* 
*of partisanship*

gen Partyidm88 = V880274
replace Partyidm88 = . if V880274 == 9
replace Partyidm88 = 1 if V880274 == 2
replace Partyidm88 = 1 if V880274 == 3
replace Partyidm88 = 1 if V880274 == 4
replace Partyidm88 = 1 if V880274 == 5
replace Partyidm88 = 1 if V880274 == 7
replace Partyidm88 = 1 if V880274 == 8
replace Partyidm88 = 2 if V880274 == 0 
replace Partyidm88 = 2 if V880274 == 6
label var Partyidm88 "Partisan Strength"
label define Partisanstrengthm88 /// 
1 "1 Not strong identifiers" 2 "2 Strong party identifiers"
label values Partyidm88 Partisanstrengthm88

****************
*Ideological self-identification*
****************

gen Ideologym88 = V880228
replace Ideologym88 = . if V880228 == 0
replace Ideologym88 = . if V880228 == 8
replace Ideologym88 = . if V880228 == 9
label var Ideologym88 "Ideological Self-identification"
label define Ideologicalidentificationm88 /// 
1 "1 Extremely liberal" 2 "2 Liberal" 3 "3 Slightly liberal" ///
4 "4 Moderate, middle of the road" 5 "5 Slightly conservative" /// 
6 "6 Conservative" 7 "7 Extremely conservative"
label values Ideologym88 Ideologicalidentificationm88

****************
*Recode issue attitude variables*

*Note: The nine issues included in the analysis for 1988 are the following:* 
*child care spending, public school spending, assistance to blacks and other* 
*minority groups, spending on the environment, defense spending, relations* 
*with Russia, abortion, school prayer and the role of women in society*

*Note: The abortion variable is reverse coded so higher values reflect more* 
*conservative attitudes*
****************

*Child care spending*

gen Childcarem88 = V880382
replace Childcarem88 = . if V880382 == 8
replace Childcarem88 = . if V880382 == 9
replace Childcarem88 = 4 if V880382 == 7
label var Childcarem88 "Attitudes Toward Child Care Spending"
label define Childcarespendingm88 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Reduced" 4 "4 Cut out entirely"
label values Childcarem88 Childcarespendingm88

*Public school spending*

gen Schoolsm88 = V880383
replace Schoolsm88 = . if V880383 == 8
replace Schoolsm88 = . if V880383 == 9
replace Schoolsm88 = 4 if V880383 == 7
label var Schoolsm88 "Attitudes Toward Public School Spending"
label define Schoolspendingm88 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Reduced" 4 "4 Cut out entirely"
label values Schoolsm88 Schoolspendingm88

*Government assistance to blacks*

gen Assistblacksm88 = V880332
replace Assistblacksm88 = . if V880332 == 0
replace Assistblacksm88 = . if V880332 == 8
replace Assistblacksm88 = . if V880332 == 9
label var Assistblacksm88 "Attitudes Toward Government Assistance to Blacks"
label define Assistanceblacksm88 /// 
1 "1 Government should help blacks" 7 "7 Blacks should help themselves"
label values Assistblacksm88 Assistanceblacksm88

*Spending on the environment*

gen Environm88 = V880377
replace Environm88 = . if V880377 == 8
replace Environm88 = . if V880377 == 9
replace Environm88 = 4 if V880377 == 7
label var Environm88 "Attitudes on Environmental Spending"
label define Environmentm88 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Decreased" 4 "4 Cut out entirely"
label values Environm88 Environmentm88

*Defense spending*

gen Defensem88 = V880310
replace Defensem88 = . if V880310 == 0
replace Defensem88 = . if V880310 == 8
replace Defensem88 = . if V880310 == 9
label var Defensem88 "Attitudes on Defense Spending"
label define Defensespendingm88 /// 
1 "1 Greatly decrease defense spending" 7 "7 Greatly increase defense spending"
label values Defensem88 Defensespendingm88

*Relations with Russia*

gen Russiam88 = V880368
replace Russiam88 = . if V880368 == 0
replace Russiam88 = . if V880368 == 8
replace Russiam88 = . if V880368 == 9
label var Russiam88 "Attitudes on Relations with Russia"
label define Russiarelationsm88 /// 
1 "1 Try to cooperate more with Russia" 7 "7 Get much tougher with Russia"
label values Russiam88 Russiarelationsm88

*Abortion*
*Note: This variable is recoded so higher values reflect more* 
*conservative attitudes*

gen Abortionm88 = V880395
replace Abortionm88 = . if V880395 == 7
replace Abortionm88 = . if V880395 == 8
replace Abortionm88 = . if V880395 == 9
replace Abortionm88 = 1 if V880395 == 4
replace Abortionm88 = 2 if V880395 == 3
replace Abortionm88 = 3 if V880395 == 2
replace Abortionm88 = 4 if V880395 == 1
label var Abortionm88 "Attitudes on Abortion"
label define Abortionattitudesm88 /// 
1 "1 By law, a woman should always be able to obtain an abortion as a matter of personal choice" /// 
2 "2 The law should permit abortion in cases other than rape, incest or danger to the woman's life, but only after the need for the abortion has been clearly established" /// 
3 "3 The law should permit abortion only in cases of rape, incest or when the woman's life is in danger" /// 
4 "4 By law, abortion should never be permitted" 
label values Abortionm88 Abortionattitudesm88

*Women's role*

gen Womenm88 = V880387
replace Womenm88 = . if V880387 == 0
replace Womenm88 = . if V880387 == 8
replace Womenm88 = . if V880387 == 9
label var Womenm88 "Attitudes on the Role of Women in Society"
label define Womenrolem88 /// 
1 "1 Women and men should have an equal role" 7 "7 Women's place is in the home"
label values Womenm88 Womenrolem88 

*School prayer*

gen Prayerm88 = V880866
replace Prayerm88 = . if V880866 == 0
replace Prayerm88 = . if V880866 == 7
replace Prayerm88 = . if V880866 == 8
replace Prayerm88 = . if V880866 == 9
label var Prayerm88 "Attitudes Toward School Prayer"
label define Prayerschoolm88 /// 
1 "1 By law, prayers should not be allowed in public schools" ///
2 "2 The law should allow public schools to schedule time when children can pray silently if they want to" ///
3 "3 The law should allow public schools to schedule time when children, as a group, can say a general prayer not tied to a particular religious faith" ///
4 "4 By law, public schools should schedule a time when all children would say a chosen Christ" 
label values Prayerm88 Prayerschool88

****************
*Recode political sophistication variables*

*Note: Political sophistication is conceptualized in this analysis as a*
*combination of political knowledge, interest and involvement*

*Note: These variables are all reverse coded so that higher values reflect* 
*greater political sophistication*
****************

****************
*Recode political knowledge variable*

*Note: Political knowledge is conceptualized in this analysis as the* 
*interviewer's assessment of the respondent's level of general* 
*political information*
****************

*Political knowledge*
*Note: This variable is reverse coded so that higher values reflect greater* 
*political knowledge*

gen Knowledgem88 = V880555
replace Knowledgem88 = . if V880555 == 9
replace Knowledgem88 = 0 if V880555 == 5 
replace Knowledgem88 = 1 if V880555 == 4
replace Knowledgem88 = 2 if V880555 == 3
replace Knowledgem88 = 3 if V880555 == 2
replace Knowledgem88 = 4 if V880555 == 1
label var Knowledgem88 /// 
"Interviewer's Assessment of the Respondent's Level of Political Information"
label define Knowledgepoliticsm88 /// 
0 "0 Very low" 1 "1 Fairly Low" 2 "2 Average" 3 "3 Fairly High" 4 "4 Very High"
label values Knowledgem88 Knowledgepoliticsm88

****************
*Divide the political knowledge variable by the number of non-zero categories* 
*it contains (4) so that the variable ranges from zero to one*
****************

gen Knowledge2m88 = Knowledgem88/4

****************
*Recode interest in the political campaigns variable*
****************

*Interest in the campaigns*
*Note: This variables is recoded so that higher values reflect greater* 
*political interest*

gen Interestm88 = V880097
replace Interestm88 = . if V880097 == 9
replace Interestm88 = 0 if V880097 == 5
replace Interestm88 = 1 if V880097 == 3
replace Interestm88 = 2 if V880097 == 1
label var Interestm88 "Interest in the Campaigns"
label define Interestcampaignm88 /// 
0 "0 Not much interested" 1 "1 Somewhat interested" 2 "2 Very much interested"
label values Interestm88 Interestcampaignm88 

****************
*Divide the interest in the campaigns variable by the number of non-zero*
*categories it contains (2) so that the variable ranges from zero to one*
****************

gen Interest2m88 = Interestm88/2

****************
*Recode political involvement variables*
*Note: These variables are recoded so that higher values reflect greater* 
*political involvement*
****************

*Attendance at political events*
*Note: This value is recoded so that higher values reflect greater* 
*political involvement*

gen Attendm88 = V880827
replace Attendm88 = . if V880827 == 0
replace Attendm88 = . if V880827 == 9
replace Attendm88 = 0 if V880827 == 5
label var Attendm88 "Attend a Political Event"
label define Attendancem88 /// 
0 "0 No" 1 "1 Yes"
label values Attendm88 Attendancem88

*Working for a political candidate*
*Note: This value is recoded so that higher values reflect greater* 
*political involvement*

gen Workm88 = V880828
replace Workm88 = . if V880828 == 0
replace Workm88 = . if V880828 == 9
replace Workm88 = 0 if V880828 == 5
label var Workm88 "Work for a Political Candidate"
label define Workedm88 /// 
0 "0 No" 1 "1 Yes"
label values Workm88 Workedm88

*Political expression in the form of a campaign button, sticker or flag*
*Note: This value is recoded so that higher values reflect greater* 
*political involvement*

gen Displaym88 = V880826
replace Displaym88 = . if V880826 == 0
replace Displaym88 = 0 if V880826 == 5
label var Displaym88 "Display a Campaign Button, Sticker or Flag"
label define Displaypoliticsm88 /// 
0 "0 No" 1 "1 Yes"
label values Displaym88 Displaypoliticsm88

*Donation to a political candidate*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatecm88 = V880830
replace Donatecm88 = . if V880830 == 0
replace Donatecm88 = . if V880830 == 8
replace Donatecm88 = 0 if V880830 == 5
label var Donatecm88 "Donate money to a political candidate"
label define Donatecandidatem88 /// 
0 "0 No" 1 "1 Yes"
label values Donatecm88 Donatecandidatem88

*Donation to a political party*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatepm88 = V880832
replace Donatepm88 = . if V880832 == 0
replace Donatepm88 = . if V880832 == 8
replace Donatepm88 = 0 if V880832 == 5
label var Donatepm88 "Donate money to a political candidate"
label define Donatepartym88 /// 
0 "0 No" 1 "1 Yes"
label values Donatepm88 Donatepartym88

****************
*Create a five-point political involvement index that will be used to display* 
*summary statistics of political involvement*
****************

gen Involvementindexm88 = Attendm88 + Workm88 + Displaym88 + Donatecm88 /// 
+ Donatepm88 

summarize Involvementindexm88

****************
*Create an eleven-point political sophistication index that combines measures* 
*of political knowledge, interest and involvement*

*Note: This index will be used to display summary statistics of the* 
*sophistication measure*
****************

gen Sophisticationindexm88 = Knowledgem88 + Interestm88 + Involvementindexm88

summarize Sophisticationindexm88

****************
*Plot a histogram of the sophistication index*
****************

histogram Sophisticationindexm88, aspect(1) fcolor(gs14) lcolor(black) /// 
discrete scheme(s1mono) ///
plotregion(lcolor(black))graphregion(margin(medsmall)) ///
title("1988", size(huge)) ///
xlabel(0 (5) 10,labsize(huge)) ///
xtitle("Sophistication", size(huge)) ///
ylabel(0.0 (0.1) 0.2, format(%02.1f) labsize(huge)) ///
ytitle("Density", size(huge))

****************
*Graph a kernel density plot of the sophistication index*
****************

kdensity Sophisticationindexm88, aspect(1) scheme(s1mono) 

****************
*Create a political sophistication scale ranging from zero to one that* 
*combines measures political knowledge, interest and involvement*
*Note: This scale will become the basis of analysis for this paper*
****************

alpha Knowledge2m88 Interest2m88 Attendm88 Workm88 Displaym88 Donatecm88 /// 
Donatepm88, detail item generate(Sophisticationscalem88) casewise

summarize Sophisticationscalem88

****************
*Create a new variable by stratifying the sophistication scale into thirds,* 
*corresponding to the "least," "moderately" and "most" politically* 
*sophisticated respondents in the sample*
****************

display 1751/3

table Sophisticationscalem88

gen Sophisticationm88 = .
replace Sophisticationm88 = 1 if Sophisticationscalem88 < .11
replace Sophisticationm88 = 2 if Sophisticationscalem88 > .15 & /// 
Sophisticationscalem88 < .25
replace Sophisticationm88 = 3 if Sophisticationscalem88 >= .25 & ///
Sophisticationscalem88 < .

summarize Sophisticationm88

table Sophisticationm88

****************
*Obtain summary statistics (mean and standard deviation) for the components* 
*of the sophistication index, as well as the sophistication index itself,* 
*for each of the three segments of the mass public we have identified* 
*for this analysis*

*Note: The summary statistics for the entire sample for the political* 
*knowledge and interest in the campaigns variables are calculated here, too*
****************

*Political Knowledge*

summarize Knowledgem88

summarize Knowledgem88 if Sophisticationm88 == 1

summarize Knowledgem88 if Sophisticationm88 == 2

summarize Knowledgem88 if Sophisticationm88 == 3

*Interest in the campaigns*

summarize Interestm88

summarize Interestm88 if Sophisticationm88 == 1

summarize Interestm88 if Sophisticationm88 == 2

summarize Interestm88 if Sophisticationm88 == 3

*Involvement Index*

summarize Involvementindexm88 if Sophisticationm88 == 1

summarize Involvementindexm88 if Sophisticationm88 == 2

summarize Involvementindexm88 if Sophisticationm88 == 3

*Sophistication Index*

summarize Sophisticationindexm88 if Sophisticationm88 == 1

summarize Sophisticationindexm88 if Sophisticationm88 == 2

summarize Sophisticationindexm88 if Sophisticationm88 == 3

***************
*Exploratory factor analysis of the 1988 mass issue attitudes*

*Note: This procedure is conducted to determine appropriate "indicator*
*variables" for factors 1 and 2 (social welfare and cultural) in the* 
*confirmatory factor analysis*
****************

factor Childcarem88 Schoolsm88 Assistblacksm88 Environm88 Defensem88 Russiam88 /// 
Abortionm88 Womenm88 Prayerm88, ipf

*Note: The analysis indicates that attitudes toward defense spending and* 
*the role of women are appropriate indicator variables*
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
*Confirmatory factor analysis of the 1988 mass issue attitudes*

*Note: Attitudes toward defense spending and the school prayer are used as*
*"indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*

*Note: This step is done to assess the factor correlation between factors one*
*and two for the full ANES sample*
****************

sem (L1 -> Defensem88) (L1 -> Childcarem88) (L1 -> Schoolsm88) ///
(L1 -> Assistblacksm88) (L1 -> Environm88) (L1 -> Russiam88) ///
(L2 -> Womenm88) (L2 -> Abortionm88) (L2 -> Prayerm88), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2) 

estat gof, stats (all)

****************
*Confirmatory multiple groups factor analysis of the 1988 mass issue attitudes*

*Note: Attitudes toward defense spending and the school prayer are used as*
*"indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*

*Note: This step is done to obtain the correlation between ideological*
*self-identifications and factor one for the entire mass public sample*
*in 1988*

*Note: This step also is done to assess equality of means and variances* 
*across groups*
****************

sem (L1 -> Defensem88) (L1 -> Childcarem88) (L1 -> Schoolsm88) ///
(L1 -> Assistblacksm88) (L1 -> Environm88) (L1 -> Russiam88) ///
(L2 -> Womenm88) (L2 -> Abortionm88) (L2 -> Prayerm88), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2) group (Sophisticationm88)

estat gof, stats (all)

estat ginvariant

predict Factor1m88, latent (L1)

corrci Ideologym88 Factor1m88

*Here, we see the aid to blacks and role of women in society indicators do not* 
*exhibit mean* invariance, and the defense item does not exhibit* 
*residual invariance*

****************
*Stratify the mass public according to sophistication, which is a scale* 
*combining political knowledge, interest and involvement*

*Note: The stratification procedure divides the mass public into three groups* 
*according to their level of political sophistication*

*Note: The ideological self-identifications variable is used in this procedure*
*because ideological self-identifications of individuals who fall into*
*each sophistication group later will be correlated with the first retained* 
*factor in the analysis*
****************

gen Ideologym882 = Ideologym88 if Sophisticationm88 == 1

gen Ideologym883 = Ideologym88 if Sophisticationm88 == 2

gen Ideologym884 = Ideologym88 if Sophisticationm88 == 3

****************
*Confirmatory factor analysis of the 1988 mass issue attitudes for the* 
*stratified sample*

*This step investigates more fully our hypothesis that a lack* 
*of sophistication drives the apparently multidimensional structure* 
*of mass political attitudes*

*Note: For each segment of the stratified sample, model fit is assessed* 
*and the correlation between the ideological self-identifications of citizens* 
*who fall in the group being examined and the first retained factor* 
*(hypothesized to be ideology) is estimated*

*Note: The procedure reports a ninety-five percent confidence interval* 
*for the estimated correlation*

*Note: The reported estimates thus reflect differences in the correlation*
*between ideological self-identifications and the first retained factor*
*across sophistication groups*

*Note: Ultimately, the key difference between this analysis and the prior*
*exploratory factor analysis is that the first retained factor here, although*
*representing ideology in each case, is estimated separately for each segment* 
*of the stratified sample*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

sem (L1 -> Childcarem88) (L1 -> Schoolsm88) (L1 -> Assistblacksm88) /// 
(L1 -> Environm88) (L1 -> Defensem88) (L1 -> Russiam88) (L2 -> Womenm88) ///
(L2 -> Abortionm88) (L2 -> Prayerm88), covstruct (_lexogenous, diagonal) /// 
standard latent (L1 L2) nocapslatent cov (L1*L2), if Sophisticationm88 == 1

estat gof, stats (all)

predict Factor1m88low, latent(L1)

corrci Ideologym882 Factor1m88low

****************
*Moderately politically sophisticated third of the stratified sample*
****************

sem  (L1 -> Childcarem88) (L1 -> Schoolsm88) (L1 -> Assistblacksm88) ///
(L1 -> Environm88) (L1 -> Defensem88) (L1 -> Russiam88) (L2 -> Womenm88) ///
(L2 -> Abortionm88) (L2 -> Prayerm88), covstruct (_lexogenous, diagonal) ///
standard latent (L1 L2) nocapslatent cov (L1*L2), if Sophisticationm88 == 2

estat gof, stats (all)

predict Factor1m88middle, latent(L1)

corrci Ideologym883 Factor1m88middle

****************
*Most politically sophisticated third of the stratified sample*
****************

sem (L1 -> Childcarem88) (L1 -> Defensem88) (L1 -> Schoolsm88) ///
(L1 -> Assistblacksm88) (L1 -> Environm88) (L1 -> Russiam88) ///
(L2 -> Womenm88) (L2 -> Abortionm88) (L2 -> Prayerm88), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent ///
cov (L1*L2), if Sophisticationm88 == 3

estat gof, stats (all)

predict Factor1m88high, latent(L1)

corrci Ideologym884 Factor1m88high

****************
*Stratify the mass public according to sophistication once more, but this time*
*the variable is measured for a small fraction of the mass public representing* 
*the absolutely most politically knowledgeable, interested and involved* 
*citizens Ñ in other words, these citizens represent the members of the* 
*electorate who we expect to most resemble political elites in their* 
*organization of political attitudes*

*Specifically, these "hyper" sophisticates are operationalized as possessing* 
*a "very high" level of general political information, being* 
*"very much interested" in the campaign and having participated in at least* 
*one political activity during the course of the campaign*
****************

gen Ideologym885 = Ideologym88 if Knowledgem88 == 4 & Interestm88 == 2 /// 
& Involvementindexm88 > 0 

****************
*Correlate ideological self-identifications of the stratified sample* 
*(by sophistication) with the first retained factor*

*This procedure obtains correlations between the first retained factor and* 
*ideological identifications for the absolutely most politically* 
*knowledgeable, interested and involved citizens - our "hyper" sophisticates*

*Note: Considering the limited sample of "hyper sophisticates" in several*
*years in included in the analysis," no separate factor model is specified* 
*for these individuals*

*Rather, their ideological self-identifications are correlated with the first*
*retained factor obtained for the most sophisticated third of the sample using*
*the alternate method*

*Note: This procedure reports a ninety-five percent confidence interval* 
*for the estimated correlations*
****************

gen Hypersophisticatesm88 = .
replace Hypersophisticatesm88 = 1 if Ideologym885 == 1
replace Hypersophisticatesm88 = 1 if Ideologym885 == 2
replace Hypersophisticatesm88 = 1 if Ideologym885 == 3
replace Hypersophisticatesm88 = 1 if Ideologym885 == 4
replace Hypersophisticatesm88 = 1 if Ideologym885 == 5
replace Hypersophisticatesm88 = 1 if Ideologym885 == 6
replace Hypersophisticatesm88 = 1 if Ideologym885 == 7

corrci Ideologym885 Factor1m88high

****************
*Conduct a series of robustness checks to demonstrate that the sophistication* 
*effects are not a simple 1988reflection of partisanship*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

corrci Ideologym882 Factor1m88low if Partyidm88 == 1

corrci Ideologym882 Factor1m88low if Partyidm88 == 2

****************
*Moderately politically sophisticated third of the stratified sample*
****************

corrci Ideologym883 Factor1m88middle if Partyidm88 == 1

corrci Ideologym883 Factor1m88middle if Partyidm88 == 2

****************
*Most politically sophisticated third of the stratified sample*
****************

corrci Ideologym884 Factor1m88high if Partyidm88 == 1

corrci Ideologym884 Factor1m88high if Partyidm88 == 2

****************
*"Hyper" sophisticates*
****************

corrci Ideologym885 Factor1m88high if Partyidm88 == 1

corrci Ideologym885 Factor1m88high if Partyidm88 == 2

****************
*1992 ANES Data*
****************

****************
*Recode symbolic predisposition variables*
****************

*Party identification*

*Note: Here, we recode the party identification variable by dividing "strong* 
*partisans" from "not strong partisans."  This step is done to demonstrate* 
*that the high level of constraint exhibited by sophisticated* 
*citizens Ñ particularly "hyper" sophisticates Ð is not merely an artifact* 
*of partisanship*

gen Partyidm92 = V923634
replace Partyidm92 = . if V923634 == 9
replace Partyidm92 = 1 if V923634 == 2
replace Partyidm92 = 1 if V923634 == 3
replace Partyidm92 = 1 if V923634 == 4
replace Partyidm92 = 1 if V923634 == 5
replace Partyidm92 = 1 if V923634 == 7
replace Partyidm92 = 1 if V923634 == 9
replace Partyidm92 = 2 if V923634 == 0 
replace Partyidm92 = 2 if V923634 == 6
label var Partyidm92 "Partisan Strength"
label define Partisanstrengthm92 /// 
1 "1 Not strong identifiers" 2 "2 Strong party identifiers"
label values Partyidm92 Partisanstrengthm92

*Ideological self-identification*

gen Ideologym92 = V923509
replace Ideologym92 = . if V923509 == 0
replace Ideologym92 = . if V923509 == 8
replace Ideologym92 = . if V923509 == 9
label var Ideologym92 "Ideological Self-identification"
label define Ideologicalidentificationm92 ///
1 "1 Extremely liberal" 2 "2 Liberal" 3 "3 Slightly liberal" /// 
4 "4 Moderate, middle of the road" 5 "5 Slightly conservative" /// 
6 "6 Conservative" 7 "7 Extremely conservative"
label values Ideologym92 Ideologicalidentificationm92

****************
*Recode issue attitude variables*

*Note: The twelve issues included in the analysis for 1992 are the following:* 
*services spending, welfare spending, spending on programs to assist the* 
*unemployed, government versus private health insurance, child care spending,* 
*public school spending, assistance to blacks, spending on the environment,*
*the importance of the U.S. maintaining global military preeminence, abortion,* 
*school prayer and the role of women in society*

*Note: The services, defense and abortion variables are reverse coded* 
*so higher values reflect more conservative attitudes*
****************

*Services spending*

gen Servicesm92 = V923701
replace Servicesm92 = . if V923701 == 0
replace Servicesm92 = . if V923701 == 8
replace Servicesm92 = . if V923701 == 9
replace Servicesm92 = 1 if V923701 == 7
replace Servicesm92 = 2 if V923701 == 6
replace Servicesm92 = 3 if V923701 == 5
replace Servicesm92 = 5 if V923701 == 3
replace Servicesm92 = 6 if V923701 == 2
replace Servicesm92 = 7 if V923701 == 1
label var Servicesm92 "Government Provision of Services versus Lower Spending"
label define Servicesgovm92 /// 
1 "1 Government provide many more services, increase spending a lot" /// 
7 "7 Government provide many fewer services, reduce spending a lot"
label value Servicesm92 Servicesgovm92

*Welfare spending*

gen Welfarem92 = V923726
replace Welfarem92 = . if V923726 == 8 
replace Welfarem92 = . if V923726 == 9 
replace Welfarem92 = 4 if V923726 == 7
label var Welfarem92 "Attitudes Toward Welfare Spending"
label define Welfarespendingm92 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Reduced" 4 "4 Cut out entirely"
label values Welfarem92 Welfarespendingm92

*Spending on programs to assist the unemployed*

gen Unemployedm92 = V923816
replace Unemployedm92 = . if V923816 == 8 
replace Unemployedm92 = . if V923816 == 9 
replace Unemployedm92 = 4 if V923816 == 7
label var Unemployedm92 "Attitudes Toward Spending on Programs to Assist the Unemployed"
label define Unemployedspendingm92 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Reduced" 4 "4 Cut out entirely"
label values Unemployedm92 Unemployedspendingm92

*Government versus health insurance*

gen Insurancem92 = V923716
replace Insurancem92 = . if V923716 == 0
replace Insurancem92 = . if V923716 == 8
replace Insurancem92 = . if V923716 == 9
label var Insurancem92 /// 
"Attitudes Toward Government versus Private Insurance Plans"
label define Insuranceplanm92 /// 
1 "1 Government insurance plan" 7 "7 Private insurance plan"
label values Insurancem92 Insuranceplanm92

*Child care spending*

gen Childcarem92 = V923813
replace Childcarem92 = . if V923813 == 8
replace Childcarem92 = . if V923813 == 9
replace Childcarem92 = 4 if V923813 == 7
label var Childcarem92 "Attitudes Toward Spending on Child Care"
label define Childcarespendingm92 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Reduced" 4 "4 Cut out entirely"
label values Childcarem92 Childcarespendingm92

*Public school spending*

gen Schoolsm92 = V923818
replace Schoolsm92 = . if V923818 == 8
replace Schoolsm92 = . if V923818 == 9
replace Schoolsm92 = 4 if V923818 == 7
label var Schoolsm92 "Attitudes Toward Public School Spending"
label define Schoolspendingm92 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Reduced" 4 "4 Cut out entirely"
label values Schoolsm92 Schoolspendingm92

*Government assistance to blacks*

gen Assistblacksm92 = V923724
replace Assistblacksm92 = . if V923724 == 0
replace Assistblacksm92 = . if V923724 == 8
replace Assistblacksm92 = . if V923724 == 9
label var Assistblacksm92 "Attitudes Toward Government Assistance to Blacks"
label define Assistanceblacksm92 /// 
1 "1 Government should help blacks" 7 "7 Blacks should help themselves"
label values Assistblacksm92 Assistanceblacksm92

*Spending on the environment*

gen Environm92 = V923815
replace Environm92 = . if V923815 == 8
replace Environm92 = . if V923815 == 9
replace Environm92 = 4 if V923815 == 7
label var Environm92 "Attitudes on Environmental Spending'
label define Environmentm92 /// 
1 "1 Increased" 2 "2 Same" 3 "3 Decreased" 4 "Cut out entirely"
label values Environm92 Environmentm92

*Attitudes toward the U.S. maintainting global military preeminence*
*Note: This variable is a proxy for defense spending attitudes

gen Defensem92 = V923603
replace Defensem92 = . if V923603 == 8
replace Defensem92 = . if V923603 == 9
replace Defensem92 = 1 if V923603 == 5
replace Defensem92 = 2 if V923603 == 4
replace Defensem92 = 4 if V923603 == 2
replace Defensem92 = 5 if V923603 == 1
label var Defensem92 /// 
"Attitudes on the Importance of the U.S. Maintaining the World's Strongest Military Power"
label define Defensespendingm92 /// 
1 "1 Disagree strongly" 2 "2 Disagree somewhat" 3 "Neither agree nor disagree" /// 
4 "4 Agree somewhat" 5 "5 Agree strongly" 
label values Defensem92 Defensespendingm92

*Abortion*
*Note: This variable is recoded so higher values reflect more* 
*conservative attitudes*

gen Abortionm92 = V923732
replace Abortionm92 = . if V923732 == 6
replace Abortionm92 = . if V923732 == 7
replace Abortionm92 = . if V923732 == 8
replace Abortionm92 = . if V923732 == 9
replace Abortionm92 = 1 if V923732 == 4
replace Abortionm92 = 2 if V923732 == 3
replace Abortionm92 = 3 if V923732 == 2
replace Abortionm92 = 4 if V923732 == 1
label var Abortionm92 "Attitudes on Abortion"
label define Abortionattitudesm92 /// 
1 "1 By law, a woman should always be able to obtain an abortion as a matter of personal choice" /// 
2 "2 The law should permit abortion in cases other than rape, incest or danger to the woman's life, but only after the need for the abortion has been clearly established" /// 
3 "3 The law should permit abortion only in cases of rape, incest or when the woman's life is in danger" ///
4 "4 By law, abortion should never be permitted"
label values Abortionm92 Abortionattitudesm92

*Shool Prayer*

gen Prayerm92 = V925945
replace Prayerm92 = . if V925945 == 0
replace Prayerm92 = . if V925945 == 7
replace Prayerm92 = . if V925945 == 8
replace Prayerm92 = . if V925945 == 9
label var Prayerm92 "School Prayer"
label define Prayerschoolm92 /// 
1 "1 By law, prayer should not be allowed in public schools" ///
2 "2 The law should allow public schools to schedule time when childten can pray silently if they want to" ///
3 "3 The law should allow public schools to schedule time when children, as a group, can say a general prayer not tied to a particular religious faith" ///
4 "4 By law, public schools should schedule a time when all children would say a chosen Christian prayer"
label values Prayerm92 Prayerschoolm92

*Women's role*

gen Womenm92 = V923801
replace Womenm92 = . if V923801 == 0
replace Womenm92 = . if V923801 == 8
replace Womenm92 = . if V923801 == 9
label var Womenm92 "Attitudes on the Role of Women in Society"
label define Womenrolem92 /// 
1 "1 Women and men should have an equal role" 7 "7 Women's place is in the home"
label values Womenm92 Womenrolem92 

****************
*Recode political sophistication variables*

*Note: Political sophistication is conceptualized in this analysis as a*
*combination of political knowledge, interest and involvement*

*Note: These variables are all reverse coded so that higher values reflect* 
*greater political sophistication*
****************

****************
*Recode political knowledge variable*

*Note: Political knowledge is conceptualized in this analysis as the* 
*interviewer's assessment of the respondent's level of general* 
*political information*
****************

*Political knowledge*
*Note: This variable is reverse coded so that higher values reflect greater* 
*political knowledge*

gen Knowledgem92 = V924205
replace Knowledgem92 = . if V924205 == 9
replace Knowledgem92 = 0 if V924205 == 5 
replace Knowledgem92 = 1 if V924205 == 4
replace Knowledgem92 = 2 if V924205 == 3
replace Knowledgem92 = 3 if V924205 == 2
replace Knowledgem92 = 4 if V924205 == 1
label var Knowledgem92 /// 
"Interviewer's Assessment of the Respondent's Level of Political Information"
label define Knowledgepoliticsm92 /// 
0 "0 Very low" 1 "1 Fairly Low" 2 "2 Average" 3 "3 Fairly High" 4 "4 Very High"
label values Knowledgem92 Knowledgepoliticsm92

****************
*Divide the political knowledge variable by the number of non-zero*
*categories it contains (4) so that the variable ranges from zero to one*
****************

gen Knowledge2m92 = Knowledgem92/4

****************
*Recode interest in the political campaigns variable*
****************

*Interest in the campaigns*
*Note: This variables is recoded so that higher values reflect greater* 
*political interest*

gen Interestm92 = V923101
replace Interestm92 = . if V923101 == 9
replace Interestm92 = 0 if V923101 == 5
replace Interestm92 = 1 if V923101 == 3
replace Interestm92 = 2 if V923101 == 1
label var Interestm92 "Interest in the Campaigns"
label define Interestcampaignm92 /// 
0 "0 Not much interested" 1 "1 Somewhat interested" 2 "2 Very much interested"
label values Interestm92 Interestcampaignm92 

****************
*Divide the interest in the campaigns variable by the number of non-zero*
*categories it contains (2) so that the variable ranges from zero to one*
****************

gen Interest2m92 = Interestm92/2

****************
*Recode political involvement variables*

*Note: These variables are recoded so that higher values reflect greater* 
*political involvement*
****************

*Recode attendance at political events variable*
*Note: This value is recoded so that higher values reflect greater* 
*political involvement*

gen Attendm92 = V925810
replace Attendm92 = . if V925810 == 0
replace Attendm92 = . if V925810 == 9
replace Attendm92 = 0 if V925810 == 5
label var Attendm92 "Attend a Political Event"
label define Attendancem92 /// 
0 "0 No" 1 "1 Yes"
label values Attendm92 Attendancem92

*Recode working for a political candidate variable*
*Note: This value is recoded so that higher values reflect greater* 
*political involvement*

gen Workm92 = V925812
replace Workm92 = . if V925812 == 0
replace Workm92 = . if V925812 == 9
replace Workm92 = 0 if V925812 == 5
label var Workm92 "Work for a Political Candidate"
label define Workedm92 0 "No" 1 "Yes"
label values Workm92 Workedm92

*Recode political expression in the form of a campaign button, sticker or* 
*flag variable*
*Note: This value is recoded so that higher values reflect greater* 
*political involvement*

gen Displaym92 = V925809
replace Displaym92 = . if V925809 == 0
replace Displaym92 = . if V925809 == 9
replace Displaym92 = 0 if V925809 == 5
label var Displaym92 "Display a Campaign Button, Sticker or Flag"
label define Displaypoliticsm92 /// 
0 "0 No" 1 "1 Yes"
label values Displaym92 Displaypoliticsm92

*Donation to a political candidate*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatecm92 = V925815
replace Donatecm92 = . if V925815 == 0
replace Donatecm92 = . if V925815 == 9
replace Donatecm92 = 0 if V925815 == 5
label var Donatecm92 "Donate money to a political candidate"
label define Donatecandidatem92 /// 
0 "0 No" 1 "1 Yes"
label values Donatecm92 Donatecandidatem92

*Donation to a political party*
*Note: This variable is recoded so that higher values reflect greater* 
*political involvement*

gen Donatepm92 = V925817
replace Donatepm92 = . if V925817 == 0
replace Donatepm92 = . if V925817 == 8
replace Donatepm92 = 0 if V925817 == 5
label var Donatepm92 "Donate money to a political candidate"
label define Donatepartym92 /// 
0 "0 No" 1 "1 Yes"
label values Donatepm92 Donatepartym92

****************
*Create a five-point index of political involvement that will be used* 
*to display summary statistics of political involvement*
****************

gen Involvementindexm92 = Attendm92 + Workm92 + Displaym92 + Donatecm92 /// 
+ Donatepm92 

summarize Involvementindexm92

****************
*Create an eleven-point political sophistication index that combines measures* 
*of political knowledge, interest and involvement* 

*Note: This index will be used to display summary statistics of the* 
*sophistication measure*
****************

gen Sophisticationindexm92 = Knowledgem92 + Interestm92 + Involvementindexm92

summarize Sophisticationindexm92

****************
*Plot a histogram of the sophistication index*
****************

histogram Sophisticationindexm92, aspect(1) fcolor(gs14) lcolor(black) /// 
discrete scheme(s1mono) ///
plotregion(lcolor(black))graphregion(margin(medsmall)) ///
title("1992", size(huge)) ///
xlabel(0 (5) 10,labsize(huge)) ///
xtitle("Sophistication", size(huge)) ///
ylabel(0.0 (0.1) 0.2, format(%02.1f) labsize(huge))  ///
ytitle("Density", size(huge))

****************
*Graph a kernel density plot of the sophistication index*
****************

kdensity Sophisticationindexm92, aspect(1) scheme(s1mono) 

****************
*Create a political sophistication scale ranging from zero to one that* 
*combines measures political knowledge, interest and involvement*

*Note: This scale will become the basis of analysis for this paper*
****************

alpha Knowledge2m92 Interest2m92 Attendm92 Workm92 Displaym92 Donatecm92 /// 
Donatepm92, detail item generate(Sophisticationscalem92) casewise

summarize Sophisticationscalem92

****************
*Create a new variable by stratifying the sophistication scale into thirds,* 
*corresponding to the "least," "moderately" and "most" politically* 
*sophisticated respondents in the sample*
****************

display 2237/3

table Sophisticationscalem92

gen Sophisticationm92 = .
replace Sophisticationm92 = 1 if Sophisticationscalem92 < .17
replace Sophisticationm92 = 2 if Sophisticationscalem92 > .17 & /// 
Sophisticationscalem92 <= .25
replace Sophisticationm92 = 3 if Sophisticationscalem92 > .25 & ///
Sophisticationscalem92 < .

summarize Sophisticationm92

table Sophisticationm92

****************
*Obtain summary statistics (mean and standard deviation) for the components* 
*of the sophistication index, as well as the sophistication index itself,* 
*for each of the three segments of the mass public we have identified* 
*for this analysis*

*Note: The summary statistics for the entire sample for the political* 
*knowledge and interest in the campaigns variables are calculated here, too*
****************

*Political Knowledge*

summarize Knowledgem92

summarize Knowledgem92 if Sophisticationm92 == 1

summarize Knowledgem92 if Sophisticationm92 == 2

summarize Knowledgem92 if Sophisticationm92 == 3

*Interest in the campaigns*

summarize Interestm92

summarize Interestm92 if Sophisticationm92 == 1

summarize Interestm92 if Sophisticationm92 == 2

summarize Interestm92 if Sophisticationm92 == 3

*Involvement Index*

summarize Involvementindexm92 if Sophisticationm92 == 1

summarize Involvementindexm92 if Sophisticationm92 == 2

summarize Involvementindexm92 if Sophisticationm92 == 3

*Sophistication Index*

summarize Sophisticationindexm92 if Sophisticationm92 == 1

summarize Sophisticationindexm92 if Sophisticationm92 == 2

summarize Sophisticationindexm92 if Sophisticationm92 == 3

***************
*Exploratory factor analysis of the 1992 mass issue attitudes*

*Note: This procedure is conducted to determine appropriate "indicator*
*variables" for factors 1 and 2 (social welfare and cultural) in the* 
*confirmatory factor analysis*
****************

factor Servicesm92 Welfarem92 Unemployedm92 Insurancem92 Childcarem92 ///
Schoolsm92 Assistblacksm92 Environm92 Defensem92 Abortionm92 Womenm92 /// 
Prayerm92, ipf

*Note: The analysis indicates that attitudes toward defense spending and* 
*the role of women are appropriate indicator variables*
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
*Confirmatory factor analysis of the 1992 mass issue attitudes*

*Note: Attitudes toward defense spending and the school prayer are used as*
*"indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*

*Note: This step is done to assess the factor correlation between factors one*
*and two for the full ANES sample*
****************

sem (L1 ->Servicesm92) (L1 -> Welfarem92) (L1 -> Unemployedm92) /// 
(L1 -> Insurancem92) (L1 -> Childcarem92) (L1 -> Schoolsm92) ///
(L1 -> Assistblacksm92) (L1 -> Environm92) (L1 -> Defensem92) ///
(L2 -> Womenm92) (L2 -> Prayerm92) (L2 -> Abortionm92), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2) 

estat gof, stats (all)

****************
*Confirmatory multiple groups factor analysis of the 1992 mass issue attitudes*

*Note: Attitudes toward defense spending and the school prayer are used as*
*"indicator variables" for factors 1 and 2* 
*(social welfare and cultural), respectively*

*Note: This step is done to obtain the correlation between ideological*
*self-identifications and factor one for the entire mass public sample*
*in 1992*

*Note: This step also is done to assess equality of means and variances* 
*across groups*
****************

sem (L1 ->Servicesm92) (L1 -> Welfarem92) (L1 -> Unemployedm92) /// 
(L1 -> Insurancem92) (L1 -> Childcarem92) (L1 -> Schoolsm92) ///
(L1 -> Assistblacksm92) (L1 -> Environm92) (L1 -> Defensem92) ///
(L2 -> Womenm92) (L2 -> Prayerm92) (L2 -> Abortionm92), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent /// 
cov (L1*L2) group (Sophisticationm92)  

estat ginvariant

estat gof, stats (all)

predict Factor1m92, latent(L1)

corrci Ideologym92 Factor1m92

*Here, we see the unemployed and school paryer indicators do not* 
*exhibit mean invariance, and the services, assistance to blacks and role of*
*women in society items do not exhibit residual invariance*

****************
*Stratify the mass public according to sophistication, which is a scale* 
*combining political knowledge, interest and involvement*

*Note: The stratification procedure divides the mass public into three groups* 
*according to their level of political sophistication*

*Note: The ideological self-identifications variable is used in this procedure*
*because ideological self-identifications of individuals who fall into*
*each sophistication group later will be correlated with the first retained* 
*factor in the analysis*
****************

gen Ideologym922 = Ideologym92 if Sophisticationm92 == 1

gen Ideologym923 = Ideologym92 if Sophisticationm92 == 2

gen Ideologym924 = Ideologym92 if Sophisticationm92 == 3

****************
*Confirmatory factor analysis of the 1992 mass issue attitudes for the* 
*stratified sample*

*This step investigates more fully our hypothesis that a lack* 
*of sophistication drives the apparently multidimensional structure* 
*of mass political attitudes*

*Note: For each segment of the stratified sample, model fit is assessed* 
*and the correlation between the ideological self-identifications of citizens* 
*who fall in the group being examined and the first retained factor* 
*(hypothesized to be ideology) is estimated*

*Note: The procedure reports a ninety-five percent confidence interval* 
*for the estimated correlation*

*Note: The reported estimates thus reflect differences in the correlation*
*between ideological self-identifications and the first retained factor*
*across sophistication groups*

*Note: Ultimately, the key difference between this analysis and the prior*
*exploratory factor analysis is that the first retained factor here, although*
*representing ideology in each case, is estimated separately for each segment* 
*of the stratified sample*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

sem (L1 -> Servicesm92) (L1 -> Welfarem92) (L1 -> Unemployedm92) /// 
(L1 -> Insurancem92) (L1 -> Childcarem92) (L1 -> Schoolsm92) ///
(L1 -> Assistblacksm92) (L1 -> Environm92) (L1 -> Defensem92) ///
(L2 -> Abortionm92) (L2 -> Womenm92) (L2 -> Prayerm92), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent ///
cov (L1*L2), if Sophisticationm92 == 1

estat gof, stats (all)

predict Factor1m92low, latent (L1)

corrci Ideologym922 Factor1m92low

****************
*Moderately politically sophisticated third of the stratified sample*
****************

sem (L1 -> Servicesm92) (L1 -> Welfarem92) (L1 -> Unemployedm92) /// 
(L1 -> Insurancem92) (L1 -> Childcarem92) (L1 -> Schoolsm92) ///
(L1 -> Assistblacksm92) (L1 -> Environm92) (L1 -> Defensem92) ///
(L2 -> Abortionm92) (L2 -> Womenm92) (L2 -> Prayerm92), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent ///
cov (L1*L2), if Sophisticationm92 == 2

estat gof, stats (all)

predict Factor1m92middle, latent (L1)

corrci Ideologym923 Factor1m92middle

****************
*Most politically sophisticated third of the stratified sample*
****************

sem (L1 -> Servicesm92) (L1 -> Welfarem92) (L1 -> Unemployedm92) /// 
(L1 -> Insurancem92) (L1 -> Childcarem92) (L1 -> Schoolsm92) ///
(L1 -> Assistblacksm92) (L1 -> Environm92) (L1 -> Defensem92) ///
(L2 -> Abortionm92) (L2 -> Womenm92) (L2 -> Prayerm92), /// 
covstruct (_lexogenous, diagonal) standard latent (L1 L2) nocapslatent ///
cov (L1*L2), if Sophisticationm92 == 3

estat gof, stats (all)

predict Factor1m92high, latent (L1)

corrci Ideologym924 Factor1m92high

****************
*Stratify the mass public according to sophistication once more, but this time*
*the variable is measured for a small fraction of the mass public representing* 
*the absolutely most politically knowledgeable, interested and involved* 
*citizens Ñ in other words, these citizens represent the members of the* 
*electorate who we expect to most resemble political elites in their* 
*organization of political attitudes*

*Specifically, these "hyper" sophisticates are operationalized as possessing* 
*a "very high" level of general political information, being* 
*"very much interested" in the campaign and having participated in at least* 
*one political activity during the course of the campaign*
****************

gen Ideologym925 = Ideologym92 if Knowledgem92 == 4 & Interestm92 == 2 & /// 
Involvementindexm92 > 0 

****************
*Correlate ideological self-identifications of the stratified sample* 
*(by sophistication) with the first retained factor*

*This procedure obtains correlations between the first retained factor and* 
*ideological identifications for the absolutely most politically* 
*knowledgeable, interested and involved citizens - our "hyper" sophisticates*

*Note: Considering the limited sample size of "hyper sophisticates" in several*
*years in included in the analysis," no separate factor model is specified* 
*for these individuals*

*Rather, their ideological self-identifications are correlated with the first*
*retained factor obtained for the most sophisticated third of the sample using*
*the alternate method*

*Note: This procedure reports a ninety-five percent confidence interval* 
*for the estimated correlations*
****************

gen Hypersophisticatesm92 = .
replace Hypersophisticatesm92 = 1 if Ideologym925 == 1
replace Hypersophisticatesm92 = 1 if Ideologym925 == 2
replace Hypersophisticatesm92 = 1 if Ideologym925 == 3
replace Hypersophisticatesm92 = 1 if Ideologym925 == 4
replace Hypersophisticatesm92 = 1 if Ideologym925 == 5
replace Hypersophisticatesm92 = 1 if Ideologym925 == 6
replace Hypersophisticatesm92 = 1 if Ideologym925 == 7

corrci Ideologym925 Factor1m92high

****************
*Conduct a series of robustness checks to demonstrate that the sophistication* 
*effects are not a simple 1992reflection of partisanship*
****************

****************
*Least politically sophisticated third of the stratified sample*
****************

corrci Ideologym922 Factor1m92low if Partyidm92 == 1

corrci Ideologym922 Factor1m92low if Partyidm92 == 2

****************
*Moderately politically sophisticated third of the stratified sample*
****************

corrci Ideologym923 Factor1m92middle if Partyidm92 == 1

corrci Ideologym923 Factor1m92middle if Partyidm92 == 2

****************
*Most politically sophisticated third of the stratified sample*
****************

corrci Ideologym924 Factor1m92high if Partyidm92 == 1

corrci Ideologym924 Factor1m92high if Partyidm92 == 2

****************
*"Hyper" sophisticates*
****************

corrci Ideologym925 Factor1m92high if Partyidm92 == 1

corrci Ideologym925 Factor1m92high if Partyidm92 == 2
