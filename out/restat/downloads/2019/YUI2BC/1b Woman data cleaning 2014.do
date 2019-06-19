***Last Updated: 12/14/2018 Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Data cleaning of the Turkish National Survey on Domestic Violence against Women (TNSDVW) 2014

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

To run the do file all you need to do is to change the path of the working directory in line 34.

The dataset used in this do file is provided by the Turkish Statistical Institute (TSI). Their data availability policy 
prohibits the distribution of data to non-registered users. Researchers have to complete a form 
(http://www.turkstat.gov.tr/UstMenu/body/bilgitalep/MVKullaniciTalepFormu_ENG.pdf), and send it 
to bilgi@tuik.gov.tr by e-mail. Upon receipt of this form, the TSI sends 
the datasets through an ftp server electronically. 

Please convert this data in spss to Stata format, and save it as "Domestic Violence/originals/women_2014_destring.dta" before you run this
do file.

*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";

use "originals/women_2014_destring.dta", clear;

*Create unique household ID;
gen HHID = wcluster*1000+wnumber;
sort HHID;
order HHID;
label variable HHID "Unique household ID";

label variable womenweight "Sampling weights for women";

*SCHOOLING VARIABLES;

gen schooling = w111t;
replace schooling=0 if w111t==.&w107==2;

gen jhighschool = 0;
replace jhighschool = 1 if w108==2 & w110==1;
replace jhighschool = 1 if w108==3 | w108==4 | w108==5 | w108==6 ;
replace jhighschool =. if w107==9;

gen highschool = 0;
replace highschool = 1 if w108==3 & w110==1;
replace highschool = 1 if w108==4 | w108==5 | w108==6;
replace highschool =. if w107==9;

gen primaryschool = 0;
replace primaryschool = 1 if w108==1 & w110==1;
replace primaryschool = 1 if w108==2 | w108==3 | w108==4 | w108==5 | w108==6;
replace primaryschool =. if w107==9;
replace primaryschool = 1 if w111a==5;

label variable schooling "Years of schooling";
label variable jhighschool "Dummy:1 if last degree is junior high";
label variable highschool "Dummy:1 if last degree is high school";
label variable primaryschool "Dummy:1 if last degree is primary school";

gen schooling_partner=wm406t;
replace schooling_partner=0 if wm402==2;

label variable schooling_partner "Partner's years of schooling"; 

*AGE VARIABLES AND DIFFERENCES;

drop if w101m==98| w101m==99;
rename w101m month;
drop if w101y==9998|w101y==9999;
rename w101y year;

gen age=2014-year;
gen age_sq=age^2;

label var age "Age";
label var age_sq "Age squarred";
label variable month "Month of birth";
label variable year "Year of birth";

gen dif=.;
replace dif = (-1)*[(12*(1987-year-1))+(12-month)+1] if year<1987;
replace dif = [(12*(year-1987-1))+month+11] if year>1987;
replace dif = (-1)*[1-month] if year==1987&month<1;
replace dif = month - 1 if year==1987&month>=1;

gen di1=dif;
gen di1_i=dif;
replace di1_i=0 if dif<0;
gen di2=dif^2;
gen di2_i=dif^2;
replace di2_i=0 if dif<0;

label var dif "Difference between birth month and January 1987 (in months)";
label var di1 "Difference between birth month and January 1987 (in months)";
label var di1_i "Difference between birth month and January 1987 interacted with treatment (in months)";
label var di2 "Difference squarred between birth month and January 1987 (in months)";
label var di2_i "Difference squarred between birth month and January 1987 interacted with treatment (in months)";

gen after1986=0;
replace after1986=1 if dif>=0;

label variable after1986 "Dummy:1 if born after January 1987";

gen modate = ym(year, month);
format modate %tm;

label variable modate "Birth month and year variables";

*GENERATE OTHER IMPORTANT CONTROL VARIABLES;
*Regions;
tab month, gen(month_);

foreach num of numlist 1(1)12{;
label variable month_`num' "Birth month dummies";
};

*Relationship (ever married or ever engaged/have boyfriend);
gen rel=.;
replace rel=1 if w201==1 | w204==1;
replace rel=0 if w207 == 11;
label variable rel "Dummy:1 if ever married or in a relationship";

*Ever married;
gen married=.;
replace married=1 if w201==1;
replace married=0 if w201==2;
label variable married "Dummy:1 if ever married";

*Language;
gen noturkish2=.;
replace noturkish2=1 if w105==2 | w105==3 | w105== 7;
replace noturkish2=0 if w105==1;
label variable noturkish2 "Dummy:1 if the respondent's mother tongue is not Turkish";

gen noturkish=.;
replace noturkish=1 if w1008==2 | w1008==3 | w1008== 7;
replace noturkish=0 if w1008==1;
label variable noturkish "Dummy:1 if the interview language is not Turkish";

*Urban vs. Rural;
gen rural=0;
replace rural=1 if wtyper==2;
label variable rural "Dummy:1 if living in a rural area now";

gen province_pre12=w104;
replace province_pre12=wprovin if w104==.;
label variable province_pre12 "Province they lived in before age 12";
tab province_pre12, gen(province_pre12_);

foreach num of numlist 1(1)82{;
label variable province_pre12_`num' "Province dummies for their childhood locations";
};

gen rural_pre12=.;
replace rural_pre12=1 if w103==0&rural==1;
replace rural_pre12=0 if w103==0&rural==0;
replace rural_pre12=1 if w103==3 | w103==2;
replace rural_pre12=0 if w103==1;
label variable rural_pre12 "Dummy:1 if childhood region is rural";

gen region_pre12=.;
replace region_pre12=1 if province_pre12==34;
replace region_pre12=2 if province_pre12==10 |province_pre12==17 |province_pre12==22 |province_pre12==39 |province_pre12==59;
replace region_pre12=3 if province_pre12==20 |province_pre12==35 |province_pre12==43 |province_pre12==45 |province_pre12==48| province_pre12==3 |province_pre12==9 |province_pre12==64;
replace region_pre12=4 if province_pre12==14 |province_pre12==16 |province_pre12==26 |province_pre12==41 |province_pre12==81| province_pre12==81 |province_pre12==11|province_pre12==54|province_pre12==77;
replace region_pre12=5 if province_pre12==6 |province_pre12==42 |province_pre12==70 ;
replace region_pre12=6 if province_pre12==1 |province_pre12==7 |province_pre12==15|province_pre12==31 |province_pre12==32|province_pre12==33 |province_pre12==46|province_pre12==80;
replace region_pre12=7 if province_pre12==38 |province_pre12==40 |province_pre12==51 |province_pre12==66 |province_pre12==71|province_pre12==68 |province_pre12==50|province_pre12==58;
replace region_pre12=8 if province_pre12==19 |province_pre12==37 |province_pre12==55 |province_pre12==60 |province_pre12==67|province_pre12==78|province_pre12==74|province_pre12==18|province_pre12==57|province_pre12==5;
replace region_pre12=9 if province_pre12==61 |province_pre12==52 |province_pre12==28 |province_pre12==53|province_pre12==8|province_pre12==29;
replace region_pre12=10 if province_pre12==4 |province_pre12==24 |province_pre12==25 |province_pre12==36 |province_pre12==76|province_pre12==69|province_pre12==75;
replace region_pre12=11 if province_pre12==12 |province_pre12==23 |province_pre12==44 |province_pre12==65|province_pre12==62|province_pre12==30|province_pre12==49|province_pre12==13;
replace region_pre12=12 if province_pre12==21 |province_pre12==27 |province_pre12==47 |province_pre12==63 |province_pre12==73|province_pre12==2|province_pre12==79|province_pre12==72|province_pre12==56;
label variable region_pre12 "12 Regions they lived in before age 12";

tab region_pre12, gen(region_pre12_);
foreach num of numlist 1(1)12{;
label variable region_pre12_`num' "12 Region dummies for their childhood locations";
};

gen region5_pre12=.;
replace region5_pre12=1 if region_pre12==1|region_pre12==2|region_pre12==3|region_pre12==4;
replace region5_pre12=2 if region_pre12==6;
replace region5_pre12=3 if region_pre12==5| region_pre12==7;
replace region5_pre12=4 if region_pre12==8| region_pre12==9;
replace region5_pre12=5 if region_pre12==10| region_pre12==11| region_pre12==12;
tab region5_pre12, gen(region5_pre12_);
label var region5_pre12 "5 Regions they lived in before age 12";

foreach num of numlist 1(1)5{;
label variable region5_pre12_`num' "5 Region dummies for their childhood locations";
};

gen region_pre12i1=region_pre12_1*rural_pre12;
gen region_pre12i2=region_pre12_2*rural_pre12;
gen region_pre12i3=region_pre12_3*rural_pre12;
gen region_pre12i4=region_pre12_4*rural_pre12;
gen region_pre12i5=region_pre12_5*rural_pre12;
gen region_pre12i6=region_pre12_6*rural_pre12;
gen region_pre12i7=region_pre12_7*rural_pre12;
gen region_pre12i8=region_pre12_8*rural_pre12;
gen region_pre12i9=region_pre12_9*rural_pre12;
gen region_pre12i10=region_pre12_10*rural_pre12;
gen region_pre12i11=region_pre12_11*rural_pre12;
gen region_pre12i12=region_pre12_12*rural_pre12;

foreach num of numlist 1(1)12{;
label variable region_pre12i`num' "12 childhood region dummies interacted with rural childhood region dummy";
};

*Current region at NUTS2 level;
gen region26=.;
replace region26=1 if wprovin==34;
replace region26=2 if wprovin==22 | wprovin==39 | wprovin==59;
replace region26=3 if wprovin==10 |wprovin==17;
replace region26=4 if wprovin==35;
replace region26=5 if wprovin==9| wprovin==20|wprovin==48;
replace region26=6 if wprovin==45 |wprovin==3 |wprovin==43 |wprovin==64;
replace region26=7 if wprovin==16 |wprovin==26 |wprovin==11;
replace region26=8 if wprovin==41 |wprovin==54 |wprovin==81 |wprovin==14|wprovin==77;
replace region26=9 if wprovin==6 ;
replace region26=10 if wprovin==42 |wprovin==70 ;
replace region26=11 if wprovin==7 |wprovin==32 |wprovin==15;
replace region26=12 if wprovin==1 |wprovin==33;
replace region26=13 if wprovin==31 |wprovin==46 |wprovin==80;
replace region26=14 if wprovin==71 |wprovin==68 |wprovin==51|wprovin==50|wprovin==40;
replace region26=15 if wprovin==38 |wprovin==58 |wprovin==66;
replace region26=16 if wprovin==67 |wprovin==78 |wprovin==74;
replace region26=17 if wprovin==37 |wprovin==18 |wprovin==57;
replace region26=18 if wprovin==55 |wprovin==60 |wprovin==19 |wprovin==5;
replace region26=19 if wprovin==61 |wprovin==52 |wprovin==28 |wprovin==53|wprovin==8|wprovin==29;
replace region26=20 if wprovin==25 |wprovin==24 |wprovin==69;
replace region26=21 if wprovin==4 |wprovin==36 |wprovin==76 |wprovin==75;
replace region26=22 if wprovin==44 |wprovin==23 |wprovin==12 |wprovin==62;
replace region26=23 if wprovin==65 |wprovin==49 |wprovin==13 |wprovin==30;
replace region26=24 if wprovin==27 |wprovin==2 |wprovin==79;
replace region26=25 if wprovin==63 |wprovin==21;
replace region26=26 if wprovin==47 |wprovin==72 |wprovin==73|wprovin==56;
label variable region26 "Current region at NUTS2 level";

**LABOR MARKET VARIABLES;
gen work_lastweek =.;
replace work_lastweek = 1 if w112==1;
replace work_lastweek = 0 if w112==2;
label variable work_lastweek "Dummy:1 if woman had a job last week";

gen social_security=.;
replace social_security =0 if w118==0;
replace social_security =1 if w118>0;
replace social_security =. if w118==.;
replace social_security = 0 if work_lastweek==0;
label variable social_security "Dummy:1 if woman had social security";

gen service = 0;
replace service = 1 if w115==3;
replace service = 0 if work_lastweek==0;
label variable service "Dummy:1 if woman works in service";

gen income_land=0;
replace income_land=1 if w122a==1| w122a==2;
gen income_house=0;
replace income_house=1 if w122b==1| w122b==2;
gen income_company=0;
replace income_company=1 if w122c==1| w122c==2;
gen income_vehicle=0;
replace income_vehicle=1 if w122d==1| w122d==2;
gen income_bank=0;
replace income_bank=1 if w122e==1| w122e==2;
gen income_other=0;
replace income_other=1 if w122f==1| w122f==2;
foreach var in 
income_land income_house income_company income_vehicle income_bank income_other{;
egen z_`var'=std(`var');
};
egen z_income=rowmean(z_income_land z_income_house z_income_company z_income_vehicle z_income_bank z_income_other);
drop z_income_land z_income_house z_income_company z_income_vehicle z_income_bank z_income_other income_land income_house income_company income_vehicle income_bank income_other;
label variable z_income "z-score: all income variables";

**MARRIAGE VARIABLES;

gen marriage_age=w210y1-year+1;
replace marriage_age=. if w210y1==9997 | w210y1==9998;
tab marriage_age;
replace marriage_age=. if marriage_age<=7;
label variable marriage_age "Age at first marriage";

gen pregnancy_age=w307;
replace pregnancy_age=. if w307==98|w307==99;
label variable pregnancy_age "Age at first pregnancy";

gen husband_age=.;
replace husband_age=w2121;
replace husband_age=. if w2121==98| w2121==.a| w2121==97;
label variable husband_age "Husband's age";

gen marriage_decision=.;
replace marriage_decision=1 if w2161==2 | w2161==3;
replace marriage_decision=0 if w2161==1 | w2161==4 | w2161==5 | w2161==7;
label variable marriage_decision "Dummy:1 if woman made the marriage decision";

gen divorced=0;
replace divorced=1 if w2241==2|w2241==3;
replace divorced=1 if w2242==2|w2242==3;
replace divorced=1 if w2243==2|w2243==3;
replace divorced=1 if w2244==2|w2244==3;
replace divorced=1 if w2245==2|w2245==3;
replace divorced=1 if w2246==2|w2246==3;
label variable divorced "Dummy:1 if ever divorced or separated";

gen notdrinking=.;
replace notdrinking=1 if wm417==0;
replace notdrinking=0 if wm417==1|wm417==2|wm417==3|wm417==4;
replace notdrinking=. if wm417==9;
label variable notdrinking "Dummy:1 if husband does not consume alcoholic beverages";
gen notgambling=.;
replace notgambling=1 if wm419==0;
replace notgambling=0 if wm419==1|wm419==2|wm419==3|wm419==4;
replace notgambling=. if wm419==9;
label variable notgambling "Dummy:1 if husband does not gamble";
gen nodrugs=.;
replace nodrugs=1 if wm420==0;
replace nodrugs=0 if wm420==1|wm420==2|wm420==3|wm420==4;
replace nodrugs=. if wm420==9;
label variable nodrugs "Dummy:1 if husband does not use any narcotic drugs";
gen affair=.;
replace affair=1 if wm423==1 | wm423==3 ;
replace affair=0 if wm423==2;
replace affair=. if wm423==9;
gen noaffair=.;
replace noaffair=1 if affair==0;
replace noaffair=0 if affair==1;
label variable noaffair "Dummy:1 if husband did not have an affair";

foreach var in 
notdrinking notgambling nodrugs noaffair{;
egen z_`var'=std(`var');
};
egen z_malereligious=rowmean(z_notdrinking z_notgambling z_nodrugs z_noaffair);
label variable z_malereligious "Z-score proxy for the religiosity of male partner";
drop z_notdrinking z_notgambling z_nodrugs z_noaffair affair notdrinking notgambling nodrugs noaffair;

gen has_female_children = .;
replace has_female_children = 1 if w310a > 0;
replace has_female_children = 0 if w310a == . | w310a == 0;
replace has_female_children = . if w310a == 99;
label variable has_female_children "Dummy:1 if woman has female children";
gen num_children_female = w310a;
replace num_children_female = 0 if w310a == .;
replace num_children_female = . if w310a == 99;
label variable num_children_female "Number of female children";
gen has_male_children = .;
replace has_male_children = 1 if w310b > 0;
replace has_male_children = 0 if w310b == . | w310b == 0;
replace has_male_children = . if w310b == 99;
label variable has_male_children "Dummy:1 if woman has male children";
gen num_children_male = w310b;
replace num_children_male = 0 if w310b == .;
replace num_children_male = . if w310b == 99;
label variable num_children_male "Number of male children";
gen has_children=0;
replace has_children=1 if has_female_children==1|has_male_children==1;
label variable has_children "Dummy:1 if woman has children";
gen num_children=num_children_female+num_children_male;
label variable num_children "Number of children";

**MENTAL HEALTH VARIABLES;

gen headache = .;
replace headache = 1 if w303a == 1;
replace headache = 0 if w303a == 2;
gen appetite_loss = .;
replace appetite_loss = 1 if w303b == 1;
replace appetite_loss = 0 if w303b == 2;
gen sleeping = .;
replace sleeping = 1 if w303c == 1;
replace sleeping = 0 if w303c == 2;
gen fear = .;
replace fear = 1 if w303d == 1;
replace fear = 0 if w303d == 2;
gen shaking_hands = .;
replace shaking_hands = 1 if w303e == 1;
replace shaking_hands = 0 if w303e == 2;
gen anxiety = .;
replace anxiety = 1 if w303f == 1;
replace anxiety = 0 if w303f == 2;
gen digestion = .;
replace digestion = 1 if w303g == 1;
replace digestion = 0 if w303g == 2;
gen stomach = .;
replace stomach = 1 if w303s == 1;
replace stomach = 0 if w303s == 2;
foreach var in headache appetite_loss sleeping fear shaking_hands anxiety digestion stomach{;
label variable `var' "Dummy:1 if woman had `var' problem last week";
};
gen clear_think = .;
replace clear_think = 1 if w303h == 1;
replace clear_think = 0 if w303h == 2;
label variable clear_think "Dummy:1 if woman had clear thinking issues last week";
gen unhappy = .;
replace unhappy = 1 if w303i == 1;
replace unhappy = 0 if w303i == 2;
label variable unhappy "Dummy:1 if woman felt unhappy last week";
gen crying = .;
replace crying = 1 if w303j == 1;
replace crying = 0 if w303j == 2;
label variable crying "Dummy:1 if woman cried last week";
gen not_enjoy_daily = .;
replace not_enjoy_daily = 1 if w303k == 1;
replace not_enjoy_daily = 0 if w303k == 2;
label variable not_enjoy_daily "Dummy:1 if woman didn't enjoy life last week";
gen difficulty_decisions = .;
replace difficulty_decisions = 1 if w303l == 1;
replace difficulty_decisions = 0 if w303l == 2;
label variable difficulty_decisions "Dummy:1 if woman had diff to make decisions last week";
gen difficulty_daily = .;
replace difficulty_daily = 1 if w303m == 1;
replace difficulty_daily = 0 if w303m == 2;
label variable difficulty_daily "Dummy:1 if woman had diff in daily tasks last week";
gen feel_useless = .;
replace feel_useless = 1 if w303n == 1;
replace feel_useless = 0 if w303n == 2;
label variable feel_useless "Dummy:1 if woman feel useless last week";
gen lose_interest = .;
replace lose_interest = 1 if w303o == 1;
replace lose_interest = 0 if w303o == 2;
label variable lose_interest "Dummy:1 if woman lost interest last week";
gen feel_worthless = .;
replace feel_worthless = 1 if w303p == 1;
replace feel_worthless = 0 if w303p == 2;
label variable feel_worthless "Dummy:1 if woman feel worthless last week";
gen think_suicide = .;
replace think_suicide = 1 if w303q == 1;
replace think_suicide = 0 if w303q == 2;
label variable think_suicide "Dummy:1 if woman thought suicide last week";
gen feel_tired = .;
replace feel_tired = 1 if w303r == 1;
replace feel_tired = 0 if w303r == 2;
label variable feel_tired "Dummy:1 if woman feel tired last week";
gen tired_easily = .;
replace tired_easily = 1 if w303t == 1;
replace tired_easily = 0 if w303t == 2;
label variable tired_easily "Dummy:1 if woman feel tired easily last week";

**Depression indices;
foreach var in 
headache appetite_loss sleeping fear shaking_hands anxiety digestion stomach clear_think unhappy crying not_enjoy_daily difficulty_decisions difficulty_daily feel_useless lose_interest feel_worthless think_suicide feel_tired tired_easily{;
egen z_`var'=std(`var');
};
egen z_depression=rowmean(z_headache z_appetite_loss z_sleeping z_fear z_shaking_hands z_anxiety z_digestion z_stomach z_clear_think z_unhappy z_crying z_not_enjoy_daily z_difficulty_decisions z_difficulty_daily z_feel_useless z_lose_interest z_feel_worthless z_think_suicide z_feel_tired z_tired_easily);
egen z_somatic=rowmean(z_headache z_shaking_hands  z_digestion z_stomach);
egen z_nonsomatic=rowmean(z_appetite_loss z_sleeping z_fear z_anxiety z_clear_think z_unhappy z_crying z_not_enjoy_daily z_difficulty_decisions z_difficulty_daily z_feel_useless z_lose_interest z_feel_worthless z_think_suicide z_feel_tired z_tired_easily);
drop z_headache z_appetite_loss z_sleeping z_fear z_shaking_hands z_anxiety z_digestion z_stomach z_clear_think z_unhappy z_crying z_not_enjoy_daily z_difficulty_decisions z_difficulty_daily z_feel_useless z_lose_interest z_feel_worthless z_think_suicide z_feel_tired z_tired_easily;
drop headache appetite_loss sleeping fear shaking_hands anxiety digestion stomach clear_think unhappy crying not_enjoy_daily difficulty_decisions difficulty_daily feel_useless lose_interest feel_worthless think_suicide feel_tired tired_easily;
label variable z_depression "z-score: overall depression variables";
label variable z_somatic "z-score: somatic depression variables";
label variable z_nonsomatic "z-score: non-somatic depression variables";

*Child Behavior Indicators;
gen child_nightmare = .;
replace child_nightmare = 1 if w321a == 1;
replace child_nightmare = 0 if w321a == 2;
gen child_peebed = .;
replace child_peebed = 1 if w321b == 1;
replace child_peebed = 0 if w321b == 2;
gen child_shy = .;
replace child_shy = 1 if w321c == 1;
replace child_shy = 0 if w321c == 2;
gen child_aggressive = .;
replace child_aggressive = 1 if w321d == 1;
replace child_aggressive = 0 if w321d == 2;
gen child_cry_aggressive = .;
replace child_cry_aggressive = 1 if w321e == 1;
replace child_cry_aggressive = 0 if w321e == 2;
label variable child_nightmare "Dummy:1 if any young child has nightmares";
label variable child_peebed "Dummy:1 if any young child pees in bed";
label variable child_shy "Dummy:1 if any young child is shy";
label variable child_aggressive "Dummy:1 if any young child is aggressive";
label variable child_cry_aggressive "Dummy:1 if any young child cries ill-temperedly";

*GENERATE ATTITUTES MEASURES;
gen agree_beat=.;
replace agree_beat=1 if w425a==1|w425b==1|w425c==1|w425d==1|w425e==1|w425f==1;
replace agree_beat=0 if w425a==2&w425b==2&w425c==2&w425d==2&w425e==2&w425f==2;
gen agree_childbeat=.;
replace agree_childbeat=1 if w424d==1;
replace agree_childbeat=0 if w424d==2;
label variable agree_beat "Dummy:1 if thinks a husband can beat his wife in some cases";
label variable agree_childbeat "Dummy:1 if thinks a child can be beaten for discipline";

*GENERATE DOMESTIC VIOLENCE MEASURES;

*Psychological Violence;
gen insult=.;
replace insult=1 if w506a == 1;
replace insult=0 if w506a == 2;
gen humiliate=.;
replace humiliate=1 if w506b == 1;
replace humiliate=0 if w506b == 2;
gen threaten=.;
replace threaten=1 if w506c == 1;
replace threaten=0 if w506c == 2;
gen intervene_friends=.;
replace intervene_friends=1 if w501a == 1;
replace intervene_friends=0 if w501a == 2;
gen intervene_family=.;
replace intervene_family=1 if w501b == 1;
replace intervene_family=0 if w501b == 2;
gen intervene_location=.;
replace intervene_location=1 if w501c == 1;
replace intervene_location=0 if w501c == 2;
gen intervene_ignore=.;
replace intervene_ignore=1 if w501d == 1;
replace intervene_ignore=0 if w501d == 2;
gen intervene_otherman=.;
replace intervene_otherman=1 if w501e == 1;
replace intervene_otherman=0 if w501e == 2;
gen intervene_suspicious=.;
replace intervene_suspicious=1 if w501f == 1;
replace intervene_suspicious=0 if w501f == 2;
gen intervene_healthcare=.;
replace intervene_healthcare=1 if w501g == 1;
replace intervene_healthcare=0 if w501g == 2;
gen intervene_clothes=.;
replace intervene_clothes=1 if w501h == 1;
replace intervene_clothes=0 if w501h == 2;
foreach var in 
insult humiliate threaten intervene_friends intervene_family intervene_location intervene_ignore intervene_otherman intervene_suspicious intervene_healthcare intervene_clothes{;
egen z_`var'=std(`var');
};
egen z_emotional=rowmean(z_insult z_humiliate z_threaten z_intervene_friends z_intervene_family z_intervene_location z_intervene_ignore z_intervene_otherman z_intervene_suspicious z_intervene_healthcare z_intervene_clothes);
drop z_insult z_humiliate z_threaten z_intervene_friends z_intervene_family z_intervene_location z_intervene_ignore z_intervene_otherman z_intervene_suspicious z_intervene_healthcare z_intervene_clothes;
drop insult humiliate threaten intervene_friends intervene_family intervene_location intervene_ignore intervene_otherman intervene_suspicious intervene_healthcare intervene_clothes;

*Financial Violence;
gen refuse_money=.;
replace refuse_money=1 if w502b == 1;
replace refuse_money=0 if w502b == 2;
gen took_money=.;
replace took_money=1 if w502c == 1;
replace took_money=0 if w502c == 2;
foreach var in 
took_money refuse_money{;
egen z_`var'=std(`var');
};
egen z_financial=rowmean(z_took_money z_refuse_money);
drop z_took_money z_refuse_money;
drop took_money refuse_money;

*Physical Violence;
gen slap=.;
replace slap=1 if w510a == 1;
replace slap=0 if w510a == 2;
gen push=.;
replace push=1 if w510b == 1;
replace push=0 if w510b == 2;
gen hit=.;
replace hit=1 if w510c == 1;
replace hit=0 if w510c == 2;
gen kick=.;
replace kick=1 if w510d == 1;
replace kick=0 if w510d == 2;
gen choked=.;
replace choked=1 if w510e == 1;
replace choked=0 if w510e == 2;
foreach var in 
slap push hit kick choked{;
egen z_`var'=std(`var');
};
egen z_physical=rowmean(z_slap z_push z_hit z_kick z_choked);
drop z_slap z_push z_hit z_kick z_choked;
drop slap push hit kick choked;

label variable z_physical "Z-score: all physical violence variables";
label variable z_financial "Z-score: all finacial violence variables";
label variable z_emotional "Z-score: all emotional violence variables (controlling + psycho)";

*GENERATE VIOLENCE AGAINST CHILDREN MEASURES;
gen hit_child=.;
replace hit_child=1 if w529==1|w529==2|w529==3|w529==4;
replace hit_child=0 if w529==0;
gen hit_child_often=.;
replace hit_child_often=1 if w529==3|w529==4;
replace hit_child_often=0 if w529==0|w529==1|w529==2;
label var hit_child "Dummy:1 if a woman has ever hit or physically abused her children";
label var hit_child_often "Dummy:1 if a woman has hit or physically abused her children frequently";

gen mother_violence=.;
replace mother_violence=1 if w911==1;
replace mother_violence=0 if w911==2|w911==3;
label variable mother_violence "Dummy:1 if mother ever faced violence by partner";

**WOMAN'S EXPERIENCE WITH VIOLENCE FROM FAMILY AND OTHERS SINCE ADOLESCENCE (AGE 15);
gen physical_family=.;
replace physical_family=1 if w901b==1|w901c==1|w901d==1|w901e==1|w901f==1|w901g==1|w901h==1|w901i==1;
replace physical_family=0 if w901a==1;
label variable physical_family "Dummy:1 if respondent ever experienced physical violence from her own family since age 15";
gen sexual_family=.;
replace sexual_family=1 if w903b==1|w903c==1|w903d==1|w903e==1;
replace sexual_family=0 if w903a==1;
label variable sexual_family "Dummy:1 if respondent ever experienced sexual violence from her own family since age 15";
gen violence_family=.;
replace violence_family=1 if sexual_family==1|physical_family==1;
replace violence_family=0 if sexual_family==0&physical_family==0;
label variable violence_family "Dummy:1 if respondent ever experienced violence from her own family since age 15";

gen physical_others=.;
replace physical_others=1 if w901a==0;
replace physical_others=0 if w901a==1;
label variable physical_others "Dummy:1 if respondent ever experienced physical violence from others since age 15";
gen sexual_others=.;
replace sexual_others=1 if w903a==0;
replace sexual_others=0 if w903a==1;
label variable sexual_others "Dummy:1 if respondent ever experienced sexual violence from others since age 15";
gen violence_others=.;
replace violence_others=1 if sexual_others==1|physical_others==1;
replace violence_others=0 if sexual_others==0&physical_others==0;
label variable violence_others "Dummy:1 if respondent ever experienced violence from others since age 15";

gen physical_family_often=.;
replace physical_family_often=1 if w902b==3|w902c==3|w902d==3|w902e==3|w902f==3|w902g==3|w902h==3|w902i==3|w902b==4|w902c==4|w902d==4|w902e==4|w902f==4|w902g==4|w902h==4|w902i==4;
replace physical_family_often=0 if w901a==1|w902b==1|w902c==1|w902d==1|w902e==1|w902f==1|w902g==1|w902h==1|w902i==1|w902b==2|w902c==2|w902d==2|w902e==2|w902f==2|w902g==2|w902h==2|w902i==2;
gen sexual_family_often=.;
replace sexual_family_often=1 if w904b==3|w904c==3|w904d==3|w904e==3|w904b==4|w904c==4|w904d==4|w904e==4;
replace sexual_family_often=0 if w903a==1|w904b==1|w904c==1|w904d==1|w904e==1|w904b==2|w904c==2|w904d==2|w904e==2;
gen violence_family_often=.;
replace violence_family_often=1 if sexual_family_often==1|physical_family_often==1;
replace violence_family_often=0 if sexual_family_often==0&physical_family_often==0;
label variable physical_family_often "Dummy:1 if respondent ever experienced physical violence often from her own family since age 15";
label variable sexual_family_often "Dummy:1 if respondent ever experienced sexual violence often from her own family since age 15";
label variable violence_family_often "Dummy:1 if respondent ever experienced violence often from her own family since age 15";

*Create interaction terms for violence variables; 
gen after1986_family=after1986*violence_family;
gen after1986_others=after1986*violence_others;
gen schooling_family=schooling*violence_family;
gen schooling_others=schooling*violence_others;
gen schooling_mother=schooling*mother_violence;
gen after1986_mother=after1986*mother_violence;
gen after1986_family_often=after1986*violence_family_often;
label variable after1986_family "Dummy:1 if respondent ever experienced violence from her own family since age 15 and is born after Jan 1987";
label variable after1986_others "Dummy:1 if respondent ever experienced violence from others since age 15 and is born after Jan 1987";
label var schooling_family "Interaction of years of schooling and childhood violence";
label var schooling_others "Interaction of years of schooling and childhood violence from others";
label var schooling_mother "Interaction of years of schooling and mother's experience of violence from father";
label var after1986_mother "Interaction of being born after Jan 1987 and mother's experience of violence from father";
label variable after1986_family_often "Dummy:1 if respondent ever experienced violence often from her own family since age 15 and is born after Jan 1987";

***Merge household variables;
merge m:1 HHID using "created/household_data_for_analysis_2014_final.dta";
drop if _merge==2;
drop _merge;
drop w1* w2* w3* w4* w5* w6* w7* w8* w9*;
drop wcluster-wweight;
drop wline2b1-wcard;

save "created/women_data_for_analysis_2014.dta", replace;
