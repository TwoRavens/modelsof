# delimit;

***Codes for religion
*** 1 = Mainline Protestant
*** 2 = Evangelical Protestant
*** 3 = Black Protestant
*** 4 = Catholic
*** 5 = Jewish
*** 9 = Other
*** 0 = None/ No response;

gen relig2=V043248;

replace relig2 = 1 if V043248 == 010 ;
replace relig2 = 1 if V043248 == 040 ;
replace relig2 = 1 if V043248 == 099 ;
replace relig2 = 1 if V043248 == 110 ; 
replace relig2 = 1 if V043248 == 111 ; 
replace relig2 = 1 if V043248 == 121 & V043299a != 10 ; 
replace relig2 = 1 if V043248 == 150 ;
replace relig2 = 1 if V043248 == 155 ;
replace relig2 = 1 if V043248 == 163 ; 
replace relig2 = 1 if V043248 == 165 ; 
replace relig2 = 1 if V043248 == 220 ;
replace relig2 = 1 if V043248 == 229 ; 
replace relig2 = 1 if V043248 == 230 ;
replace relig2 = 1 if V043248 == 239 & V043299a != 10 ;
replace relig2 = 1 if V043248 == 249 & V043299a != 10 ;
replace relig2 = 1 if V043248 == 270 ;
replace relig2 = 1 if V043248 == 279 ; 
replace relig2 = 1 if V043248 == 281 ; 
replace relig2 = 1 if V043248 == 282 ;
replace relig2 = 1 if V043248 == 289 ; 
replace relig2 = 1 if V043248 == 290 ; 
replace relig2 = 1 if V043248 == 293 ;

replace relig2 = 2 if V043248 == 020 ; 
replace relig2 = 2 if V043248 == 030 ;
replace relig2 = 2 if V043248 == 100 ; 
replace relig2 = 2 if V043248 == 109 ;
replace relig2 = 2 if V043248 == 120 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 122 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 123 & V043299a != 10 ;
replace relig2 = 2 if V043248 == 124 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 125 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 126 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 127 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 128 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 130 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 134 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 135 & V043299a != 10 ;
replace relig2 = 2 if V043248 == 147 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 148 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 149 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 160 ;
replace relig2 = 2 if V043248 == 161 ; 
replace relig2 = 2 if V043248 == 162 ; 
replace relig2 = 2 if V043248 == 164 ;
replace relig2 = 2 if V043248 == 166 ; 
replace relig2 = 2 if V043248 == 167 ; 
replace relig2 = 2 if V043248 == 168 ; 
replace relig2 = 2 if V043248 == 169 ;
replace relig2 = 2 if V043248 == 170 ;
replace relig2 = 2 if V043248 == 180 ; 
replace relig2 = 2 if V043248 == 181 ; 
replace relig2 = 2 if V043248 == 182 ; 
replace relig2 = 2 if V043248 == 183 ;
replace relig2 = 2 if V043248 == 184 ; 
replace relig2 = 2 if V043248 == 185 ; 
replace relig2 = 2 if V043248 == 186 ; 
replace relig2 = 2 if V043248 == 199 ;
replace relig2 = 2 if V043248 == 200 ; 
replace relig2 = 2 if V043248 == 201 ; 
replace relig2 = 2 if V043248 == 219 ; 
replace relig2 = 2 if V043248 == 221 ;
replace relig2 = 2 if V043248 == 222 ; 
replace relig2 = 2 if V043248 == 223 ; 
replace relig2 = 2 if V043248 == 224 ;
replace relig2 = 2 if V043248 == 225 ;
replace relig2 = 2 if V043248 == 228 ;
replace relig2 = 2 if V043248 == 233 & V043299a != 10 ;
replace relig2 = 2 if V043248 == 234 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 235 & V043299a != 10 ; 
replace relig2 = 2 if V043248 == 240 & V043299a != 10 ;
replace relig2 = 2 if V043248 == 242 ;
replace relig2 = 2 if V043248 == 250 ; 
replace relig2 = 2 if V043248 == 251 ; 
replace relig2 = 2 if V043248 == 252 ;
replace relig2 = 2 if V043248 == 253 ; 
replace relig2 = 2 if V043248 == 254 ; 
replace relig2 = 2 if V043248 == 255 ; 
replace relig2 = 2 if V043248 == 256 ;
replace relig2 = 2 if V043248 == 260 ; 
replace relig2 = 2 if V043248 == 261 ; 
replace relig2 = 2 if V043248 == 262 ;
replace relig2 = 2 if V043248 == 263 ; 
replace relig2 = 2 if V043248 == 264 ; 
replace relig2 = 2 if V043248 == 267 & V043299a!= 10  ; 
replace relig2 = 2 if V043248 == 268 ; 
replace relig2 = 2 if V043248 == 269 ; 
replace relig2 = 2 if V043248 == 271 ; 
replace relig2 = 2 if V043248 == 272 ;
replace relig2 = 2 if V043248 == 276 ;
replace relig2 = 2 if V043248 == 275 ; 
replace relig2 = 2 if V043248 == 280 ; 
replace relig2 = 2 if V043248 == 291 ; 
replace relig2 = 2 if V043248 == 292 ; 
replace relig2 = 2 if V043248 == 156 ; 


replace relig2 = 3 if V043248 == 231 ;
replace relig2 = 3 if V043248 == 232 ;
replace relig2 = 3 if V043248 == 129 ;
replace relig2 = 3 if V043248 == 130 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 131 ;
replace relig2 = 3 if V043248 == 132 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 243 ;
replace relig2 = 3 if V043248 == 244 ;
replace relig2 = 3 if V043248 == 257 ;
replace relig2 = 3 if V043248 == 258 ;
replace relig2 = 3 if V043248 == 266 ;
replace relig2 = 3 if V043248 == 120 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 121 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 122 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 123 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 124 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 125 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 126 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 127 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 128 ; 
replace relig2 = 3 if V043248 == 133 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 134 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 135 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 147 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 148 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 149 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 233 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 234 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 239 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 240 & V043299a == 10 ; 
replace relig2 = 3 if V043248 == 249 & V043299a == 10 ;
replace relig2 = 3 if V043248 == 267 & V043299a == 10 ;

replace relig2 = 4 if V043248 == 400;
replace relig2 = 4 if V043248 == 600;
replace relig2 = 4 if V043248 == 700; 
replace relig2 = 4 if V043248 == 701;
replace relig2 = 4 if V043248 == 702;
replace relig2 = 4 if V043248 == 703; 
replace relig2 = 4 if V043248 == 704; 
replace relig2 = 4 if V043248 == 705; 
replace relig2 = 4 if V043248 == 706;
replace relig2 = 4 if V043248 == 707; 
replace relig2 = 4 if V043248 == 708; 
replace relig2 = 4 if V043248 == 719;

replace relig2 = 5 if V043248 == 500;
replace relig2 = 5 if V043248 == 501; 
replace relig2 = 5 if V043248 == 502; 
replace relig2 = 5 if V043248 == 503; 
replace relig2 = 5 if V043248 == 524;
replace relig2 = 5 if V043248 == 650;

replace relig2 = 9  if V043248 == 720;  
replace relig2 = 9  if V043248 == 721;  
replace relig2 = 9  if V043248 == 722; 
replace relig2 = 9  if V043248 == 723;  
replace relig2 = 9  if V043248 == 724;  
replace relig2 = 9  if V043248 == 725;  
replace relig2 = 9  if V043248 == 726; 
replace relig2 = 9  if V043248 == 727; 
replace relig2 = 9  if V043248 == 729;
replace relig2 = 9  if V043248 == 730;
replace relig2 = 9  if V043248 == 732;
replace relig2 = 9  if V043248 == 740;
replace relig2 = 9  if V043248 == 750;  
replace relig2 = 9  if V043248 == 790; 
replace relig2 = 9  if V043248 == 795; 
replace relig2 = 9  if V043248 == 997;  
replace relig2 = 9  if V043248 == 300;  
replace relig2 = 9  if V043248 == 301; 
replace relig2 = 9  if V043248 == 302;  
replace relig2 = 9  if V043248 == 303;  
replace relig2 = 9  if V043248 == 304; 
replace relig2 = 9  if V043248 == 305;
replace relig2 = 9  if V043248 == 306; 
replace relig2 = 9  if V043248 == 308;
replace relig2 = 9  if V043248 == 309; 
replace relig2 = 9  if V043248 == 870;
replace relig2 = 9  if V043248 == 879;

replace relig2 = 0 if V043248 == 880;
replace relig2 = 0 if V043248 == 881;
replace relig2 = 0 if V043248 == 882;

replace relig2 =99 if V043248 == 888;
replace relig2 =99 if V043248 == 889;

gen religFinal = V043248;

replace religFinal = 1 if relig2 == 1;
replace religFinal = 2 if relig2 == 2;
replace religFinal = 3 if relig2 == 3;
replace religFinal = 4 if relig2 == 4;
replace religFinal = 5 if relig2 == 5;
replace religFinal = 9 if relig2 == 9;
replace religFinal = 0 if relig2 == 0;
replace religFinal = 666 if relig2 ==99;
recode religFinal 666=4;

gen None=religFinal;
recode None 0=11 1/9=0;
recode None 11=1;
gen Mainline=religFinal;
recode Mainline 2/9=0;
gen Evangelical=religFinal;
recode Evangelical 1=0 2=11 3/9=0;
recode Evangelical 11=1;
gen Blackprotestant=religFinal;
recode Blackprotestant 1/2=0 4/9=0 3=11;
recode Blackprotestant 11=1;
gen Catholic=religFinal;
recode Catholic 1/3=0 4=11 5/9=0;
recode Catholic 11=1;
gen Jew=religFinal;
recode Jew 1/4=0 9=0 5=11;
recode Jew 11=1;
gen Others=religFinal;
recode Others 1/5=0 9=11;
recode Others 11=1;

gen WA=V043224;
recode WA 8/9=5 .=5;
** 8/9=5 because they constitute non-attendees in previous question and missing responses added to modal category**;
recode WA 1=500 2=400 3=300 4=200 5=100;
recode WA 100=1 200=2 300=3 400=4 500=5;
label define WA1 1"Never" 2"A few times a year" 3"Once or twice a month" 4"Almost every week" 5"Everyweek";
label values WA WA1;

 gen Prayer=V043221;
 recode Prayer 7/9=.;
 recode Prayer .=1;
 **.02% missing data added to modal category**;
 recode Prayer 1=500 2=400 3=300 4=200 5=100;
 recode Prayer 100=1 200=2 300=3 400=4 500=5;
 label define Prayer 1"1. Never" 2"2.Once a week or less" 3"3. A few times a week" 4"4. Once a day" 5" 5. Several times a day";
 label values Prayer Prayer;
  
 gen Bible=V043222;
 recode Bible 7/9=.;
 recode Bible 3=10 1=30;
 recode Bible 10=1 30=3;
 label define Bible 1"1.  The Bible is a book written by men" 2" 2. The Bible is the word of God but not everything it says is true " 3"3. The Bible is the actual word of God";
 label values Bible Bible;
 
 gen Ideology=V043085;
 recode Ideology 80/89=.;
 label define Ideology 1"01. Extremely liberal" 2"02. Liberal" 3".03 Slightly liberal" 4".04 Moderate" 5".05 Slightly conservative" 6".06 Conservative" 7".07. Extremely conservative";
 label values Ideology Ideology;

 gen Party=V043116;
 recode Party 7/9=.;
 recode Party 0=100 1=200 2=300 3=400 4=500 5=600 6=700;
 recode Party 100=1 200=2 300=3 400=4 500=5 600=6 700=7;
 label define Party 1"1. Strong Democrat" 2" 2. Weak Democrat" 3" 3. Independent Democrat" 4" 4. Independent-Independent" 5" 5. Independent Republican" 6" 6. Weak Republican" 7"7. Strong Repubilcan";
 label values Party Party;

gen Female=V043411;
recode Female 0=.;
recode Female 1=0 2=1;
label define Female 0" 0. Male" 1"1. Female";
label values Female Female;

gen Age=V043250;

gen Race=V043299a;
recode Race 88/89=.;
recode Race 50=1 10=2 70=3 20/40=3;
recode Race .=1;
gen White=Race;
recode White 2/3=0;
gen Black=Race;
recode Black 1=0 3=0 2=1;
gen OtherRaces=Race;
recode OtherRaces 1/2=0 3=1;

gen INCOME=V043294;
recode INCOME 88/89=.;
label define INCOME 1" 1. None or less that $2,999" 23"23. $120,000 and over";
label values INCOME INCOME;

gen Education=V043254;
recode Education 0=3;
label define Education 1"1. 8 grade or less and no diploma" 7" 7. Advanced Degree including LLB";
label values Education Education;

gen South=V041205;
recode South 1/2=0 4=0;
recode South 3=1;


gen Iraq=V043134;
recode Iraq 8/9=.;
recode Iraq 5=0;

gen Afghanistan=V043131;
recode Afghanistan 8/9=. 5=0;

impute Bible Female Age White Black INCOME Edu, gen (iBible);
impute Ideology Female Age White Black INCOME Edu, gen (iIdeology);
impute Party Female Age White Black INCOME Edu, gen (iParty);
impute INCOME Female Age White Black  Edu, gen (iInc);g

gen Behavior=Prayer+WA;

khb logit Afgh Evangelical Blackprotestant Catholic Jew Others None Behavior iBible || Female Age iInc Edu South Black OtherRaces iIdeology iParty [pweight=V040101];
khb logit Iraq  Evangelical Blackprotestant Catholic Jew Others None Behavior iBible || Female Age iInc Edu South Black OtherRaces iIdeology iParty [pweight=V040101], verbose disentangle;




 
 
 
