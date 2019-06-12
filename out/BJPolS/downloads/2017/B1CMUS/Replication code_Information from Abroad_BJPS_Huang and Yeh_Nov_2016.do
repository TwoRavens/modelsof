*Replication code for "Information from Abroad: Foreign Media, Selective Exposure, and Political Support in China" by Haifeng Huang and Yao-Yuan Yeh, BJPS.
*Prepared Nov., 2016

*Marcro setting
set more off

/*Variable name (for question wordings, please check Appendix.1):
houseinterest = reading interest in NY housing
healthinterest = reading interest in Indian health care system
eduainterest = reading interest in American education
educinterest = reading interest in Chinese education
chinabad = aggregate reading interest (houseinterest+healthinterest+eduainterest+educinterest)

governance = evaluations of China's performance of the government
future = evaluations of China's future prospects
polity = evaluations of China's political system
govcompetence = evaluations of China's the competence of the government
post = aggregate post-treatment regime evaluation index (china + responsive + govtrust)

pinterest = political interest
news = news consumption:
pride = national pride
indiv = individualism
eefficacy = external efficacy
iefficacy = internal efficacy 
pwest = pro-Western orientation
life = life satisfaction
female = gender (female=1)
age = respondent's age
education = education level
income = domestic economic evaluation
ccpmember = CCP membership
region = three different regions in China (West, Cental, and East Coast)

china2 = China's current overall situation
responsive2 = responsiveness of the Chinese government
govtrust2 = trust on the Chinese government
pre = aggregate pre-treatment regime evaluation index (governance + future + polity + govcompetence)

rgroup = a dummy variable coded 1 for the treated respondents, 0 otherwise

house1time = time respondent spent on reading "Good housing in NY"
house2time = time respondent spent on reading "High rent in Manhattan"
health1time = time respondent spent on reading "India Needs to Learn from China's Public Health Care System"
health2time = time respondent spent on reading "Why Are India's Private Hospitals Worthy of Emulation for China?"

fmtrust = "In general, compared to American and European media outlet, how trustworthy is our domestic media outlet?" (5 point-scale)

houser1 = a dummy variable coded 1 for respondents who expressed interests in reading "Good housing in NY," 0 otherwise
houser2 = a dummy variable coded 1 for respondents who expressed interests in reading "High rent in Manhattan," 0 otherwise
healthr1 = a dummy variable coded 1 for respondents who expressed interests in reading "India Needs to Learn from China's Public Health Care System," 0 otherwise
healthr2= a dummy variable coded 1 for respondents who expressed interests in reading "Why Are India's Private Hospitals Worthy of Emulation for China," 0 otherwise
*/


*Aggregate and rescale variables
gen china2 = (china-1)/6
gen responsive2 = (responsive-1)/6
gen govtrust2 = (govtrust-1)/6

sum china2 responsive2 govtrust2

gen pre = (china+responsive + govtrust-3)/18
alpha china responsive govtrust, item
gen post = (governance+ future+ polity+ govcompetence-4)/24
alpha governance future polity govcompetence

gen chinabad = houseinterest+healthinterest+eduainterest+educinterest

recode pinterest (1=0) (2=.33) (3=.67) (4=1)
recode news (1=0) (2=.25) (3=.5) (4=.75) (5=1)
recode pride (1=0) (2=.33) (3=.67) (4=1)
recode indiv (1=0) (2=.33) (3=.67) (4=1)
recode eefficacy (1=0) (2=.33) (3=.67) (4=1)
recode iefficacy (1=0) (2=.33) (3=.67) (4=1)
recode pwest (1=0) (2=.33) (3=.67) (4=1)
gen life2 = (life-1)/6
drop life
rename life2 life
gen age2 = (age-1)/9
drop age
rename age2 age
gen education2 = (education-1)/5
drop education
rename education2 education
gen income2 = (income-1)/6
drop income
rename income2 income

gen governance2 = (governance-1)/6
gen future2 = (future-1)/6
gen polity2 = (polity-1)/6
gen govcompetence2 = (govcompetence-1)/6

drop governance future polity govcompetence
rename governance2 governance
rename future2 future
rename polity2 polity 
rename govcompetence2 govcompetence

*Summary statistics
sum governance future polity govcompetence post pinterest news pride indiv eefficacy iefficacy  pwest pre life female age education income ccpmember 
sum houseinterest healthinterest eduainterest educinterest chinabad 
tab region

*Figure 3 and Table S8
logit houseinterest pwest pre pride pinterest news indiv eefficacy iefficacy life female age education income ccpmember i.region, 
margins, dydx(*) level(90)
marginsplot, ytitle(Housing) ylabel(#10, labcolor(black)) xscale(lcolor(black)) xlabel(1 "Pro-west" 2 "Regime evaluation" 3 "National pride" 4 "Political interest" 5 "Following news" 6 "Individulism" 7 "External efficacy" 8 "Internal efficacy" 9 "Life satisfaction" 10 "Female" 11 "Age group" 12 "Education" 13 "Income" 14 "CCP member" 15 "Western China" 16 "Central China" 17 "Eastern China", labcolor(black) angle(vertical)) title(, color(black)) graphregion(fcolor(none))

logit healthinterest pwest pre pride pinterest news indiv eefficacy iefficacy life female age education income ccpmember i.region
margins, dydx(*) level(90)
marginsplot, ytitle(Health Care) ylabel(#10, labcolor(black)) xscale(lcolor(black)) xlabel(1 "Pro-west" 2 "Regime evaluation" 3 "National pride" 4 "Political interest" 5 "Following news" 6 "Individulism" 7 "External efficacy" 8 "Internal efficacy" 9 "Life satisfaction" 10 "Female" 11 "Age group" 12 "Education" 13 "Income" 14 "CCP member" 15 "Western China" 16 "Central China" 17 "Eastern China", labcolor(black) angle(vertical)) title(, color(black)) graphregion(fcolor(none))
 
logit eduainterest pwest pre pride pinterest news indiv eefficacy iefficacy life female age education income ccpmember i.region 
margins, dydx(*) level(90)
marginsplot, ytitle(American Education) ylabel(#10, labcolor(black)) xscale(lcolor(black)) xlabel(1 "Pro-west" 2 "Regime evaluation" 3 "National pride" 4 "Political interest" 5 "Following news" 6 "Individulism" 7 "External efficacy" 8 "Internal efficacy" 9 "Life satisfaction" 10 "Female" 11 "Age group" 12 "Education" 13 "Income" 14 "CCP member" 15 "Western China" 16 "Central China" 17 "Eastern China", labcolor(black) angle(vertical)) title(, color(black)) graphregion(fcolor(none))

logit educinterest pwest pre pride pinterest news indiv eefficacy iefficacy life female age education income ccpmember i.region
margins, dydx(*) level(90)
marginsplot, ytitle(Chinese Education) ylabel(#10, labcolor(black)) xscale(lcolor(black)) xlabel(1 "Pro-west" 2 "Regime evaluation" 3 "National pride" 4 "Political interest" 5 "Following news" 6 "Individulism" 7 "External efficacy" 8 "Internal efficacy" 9 "Life satisfaction" 10 "Female" 11 "Age group" 12 "Education" 13 "Income" 14 "CCP member" 15 "Western China" 16 "Central China" 17 "Eastern China", labcolor(black) angle(vertical)) title(, color(black)) graphregion(fcolor(none))

ologit chinabad pinterest news pride indiv eefficacy iefficacy  pwest pre life female age education income ccpmember i.region,

*Table S9
logit houseinterest pinterest news pride indiv eefficacy iefficacy  pwest china2 life female age education income ccpmember i.region, 
logit healthinterest pinterest news pride indiv eefficacy iefficacy  pwest china2 life female age education income ccpmember i.region, 
logit eduainterest pinterest news pride indiv eefficacy iefficacy  pwest china2 life female age education income ccpmember i.region, 
logit educinterest pinterest news pride indiv eefficacy iefficacy  pwest china2 life female age education income ccpmember i.region,
ologit chinabad pinterest news pride indiv eefficacy iefficacy  pwest china2 life female age education income ccpmember i.region,  

logit houseinterest pinterest news pride indiv eefficacy iefficacy  pwest responsive2 life female age education income ccpmember i.region, 
logit healthinterest pinterest news pride indiv eefficacy iefficacy  pwest responsive2 life female age education income ccpmember i.region, 
logit eduainterest pinterest news pride indiv eefficacy iefficacy  pwest responsive2 life female age education income ccpmember i.region, 
logit educinterest pinterest news pride indiv eefficacy iefficacy  pwest responsive2 life female age education income ccpmember i.region, 
ologit chinabad pinterest news pride indiv eefficacy iefficacy  pwest responsive2 life female age education income ccpmember i.region,  

logit houseinterest pinterest news pride indiv eefficacy iefficacy  pwest govtrust2 life female age education income ccpmember i.region, 
logit healthinterest pinterest news pride indiv eefficacy iefficacy  pwest govtrust2 life female age education income ccpmember i.region, 
logit eduainterest pinterest news pride indiv eefficacy iefficacy  pwest govtrust2 life female age education income ccpmember i.region, 
logit educinterest pinterest news pride indiv eefficacy iefficacy  pwest govtrust2 life female age education income ccpmember i.region, 
ologit chinabad pinterest news pride indiv eefficacy iefficacy  pwest govtrust2 life female age education income ccpmember i.region,  


*Table 1, S10, S11, S12, S13
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser1!=. & house1time>59, 
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser2!=. & house2time>59, 
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr1!=. & health1time>59, 
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr2!=. & health2time>59, 

ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser1!=. & house1time>59, 
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser2!=. & house2time>59, 
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr1!=. & health1time>59, 
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr2!=. & health2time>59, 

ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser1!=. & house1time>59, 
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser2!=. & house2time>59, 
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr1!=. & health1time>59, 
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr2!=. & health2time>59, 

ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if houser1!=. & house1time>59, 
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if houser2!=. & house2time>59, 
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if healthr1!=. & health1time>59, 
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if healthr2!=. & health2time>59, 

reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>59, r
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>59, r
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>59, r
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>59, r

*Table 2
*generate reading time variables
gen house1time_nomiss = house1time
recode house1time_nomiss (.=0) if houser1!=.
replace house1time_nomiss = 1 if house1time < 30 & house1time > 0
replace house1time_nomiss = 2 if house1time < 60 & house1time > 29
replace house1time_nomiss = 3 if house1time < 90 & house1time > 59
replace house1time_nomiss = 4 if house1time < 120 & house1time > 89
replace house1time_nomiss = 5 if house1time < 460 & house1time > 119 

gen house2time_nomiss = house2time
recode house2time_nomiss (.=0) if houser2!=.
replace house2time_nomiss = 1 if house2time < 30 & house2time > 0
replace house2time_nomiss = 2 if house2time < 60 & house2time > 29
replace house2time_nomiss = 3 if house2time < 90 & house2time > 59
replace house2time_nomiss = 4 if house2time < 120 & house2time > 89
replace house2time_nomiss = 5 if house2time < 5700 & house2time > 119 

gen health1time_nomiss = health1time
recode health1time_nomiss (.=0) if healthr1!=.
replace health1time_nomiss = 1 if health1time < 30 & health1time > 0
replace health1time_nomiss = 2 if health1time < 60 & health1time > 29
replace health1time_nomiss = 3 if health1time < 90 & health1time > 59
replace health1time_nomiss = 4 if health1time < 120 & health1time > 89
replace health1time_nomiss = 5 if health1time < 6700 & health1time > 119 

gen health2time_nomiss = health2time
recode health2time_nomiss (.=0) if healthr2!=.
replace health2time_nomiss = 1 if health2time < 30 & health2time > 0
replace health2time_nomiss = 2 if health2time < 60 & health2time > 29
replace health2time_nomiss = 3 if health2time < 90 & health2time > 59
replace health2time_nomiss = 4 if health2time < 120 & health2time > 89
replace health2time_nomiss = 5 if health2time < 1780 & health2time > 119 


ologit governance house1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser1!=., 
ologit governance house2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser2!=., 
ologit governance health1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr1!=., 
ologit governance health2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr2!=., 

ologit future house1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser1!=., 
ologit future house2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser2!=., 
ologit future health1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr1!=., 
ologit future health2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr2!=., 

ologit polity house1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser1!=., 
ologit polity house2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if houser2!=., 
ologit polity health1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr1!=., 
ologit polity health2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region if healthr2!=., 

ologit govcompetence house1time_nomiss pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if houser1!=., 
ologit govcompetence house2time_nomiss pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if houser2!=., 
ologit govcompetence health1time_nomiss pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if healthr1!=., 
ologit govcompetence health2time_nomiss pinterest news pride indiv eefficacy iefficacy pwest life female age education income ccpmember i.region if healthr2!=., 

reg post house1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=., r
reg post house2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=., r
reg post health1time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=., r
reg post health2time_nomiss pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=., r

*Table S1
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=.
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. 
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. 
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=.

ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. 
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. 
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. 
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. 

ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=.
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. 
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. 
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. 

ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. 
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=.
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=.
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=.

reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. 
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. 
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=.
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=.

*Table S2
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>29
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>29
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>29
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>29

ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>29
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>29
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>29
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>29

ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>29
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>29
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>29
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>29

ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>29
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>29
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>29
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>29

reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>29
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>29
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>29
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>29 

*Table S3
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>89
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>89
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>89
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>89

ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>89
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>89
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>89
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>89

ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>89
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>89
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>89
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>89

ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>89
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>89
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>89
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>89

reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>89
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>89
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>89
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>89

*Table S4
*120s
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>119
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>119
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>119
ologit governance rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>119

ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>119
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>119
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>119
ologit future rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>119

ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>119
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>119
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>119
ologit polity rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>119

ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>119
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>119
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>119
ologit govcompetence rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>119

reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser1!=. & house1time>119, r
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if houser2!=. & house2time>119, r
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr1!=. & health1time>119, r
reg post rgroup pinterest news pride indiv eefficacy iefficacy  pwest life female age education income ccpmember i.region if healthr2!=. & health2time>119, r

*Table S5
teffects ipw (governance) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser1!=. & house1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (governance) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser2!=. & house2time>59,
tebalance overid
tebalance summarize, 
teffects ipw (governance) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr1!=. & health1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (governance) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr2!=. & health2time>59, 
tebalance overid
tebalance summarize, 

teffects ipw (future) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser1!=. & house1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (future) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser2!=. & house2time>59,
tebalance overid
tebalance summarize, 
teffects ipw (future) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr1!=. & health1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (future) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr2!=. & health2time>59, 
tebalance overid
tebalance summarize, 

teffects ipw (polity) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser1!=. & house1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (polity) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser2!=. & house2time>59,
tebalance overid
tebalance summarize, 
teffects ipw (polity) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr1!=. & health1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (polity) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr2!=. & health2time>59, 
tebalance overid
tebalance summarize, 

teffects ipw (govcompetence) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser1!=. & house1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (govcompetence) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser2!=. & house2time>59,
tebalance overid
tebalance summarize, 
teffects ipw (govcompetence) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr1!=. & health1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (govcompetence) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr2!=. & health2time>59, 
tebalance overid
tebalance summarize, 

teffects ipw (post) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser1!=. & house1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (post) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if houser2!=. & house2time>59,
tebalance overid
tebalance summarize, 
teffects ipw (post) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr1!=. & health1time>59,
tebalance overid
tebalance summarize, 
teffects ipw (post) (rgroup pinterest news pride indiv eefficacy iefficacy  pwest  life female age education income ccpmember i.region) if healthr2!=. & health2time>59, 
tebalance overid
tebalance summarize, 








