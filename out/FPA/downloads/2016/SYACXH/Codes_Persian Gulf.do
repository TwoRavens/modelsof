# delimit;

***Codes for religion
*** 1 = Mainline Protestant
*** 2 = Evangelical Protestant
*** 3 = Black Protestant
*** 4 = Catholic
*** 5 = Jewish
*** 9 = Other
*** 0 = None/ No response;

gen relig2=V900546;

replace relig2 = 1 if V900546 == 010 ;
replace relig2 = 1 if V900546 == 040 ;
replace relig2 = 1 if V900546 == 099 ;
replace relig2 = 1 if V900546 == 110 ; 
replace relig2 = 1 if V900546 == 121 & V900549!= 2 ; 
replace relig2 = 1 if V900546 == 150 ;
replace relig2 = 1 if V900546 == 151 ;
replace relig2 = 1 if V900546 == 155 ;
replace relig2 = 1 if V900546 == 163 ; 
replace relig2 = 1 if V900546 == 165 ; 
replace relig2 = 1 if V900546 == 220 ;
replace relig2 = 1 if V900546 == 229 ; 
replace relig2 = 1 if V900546 == 230 ;
replace relig2 = 1 if V900546 == 239 & V900549!= 2 ;
replace relig2 = 1 if V900546 == 249 & V900549!= 2 ;
replace relig2 = 1 if V900546 == 270 ;
replace relig2 = 1 if V900546 == 279 ; 
replace relig2 = 1 if V900546 == 281 ; 
replace relig2 = 1 if V900546 == 282 ;
replace relig2 = 1 if V900546 == 289 ; 
replace relig2 = 1 if V900546 == 290 ; 
replace relig2 = 1 if V900546 == 293 ;

replace relig2 = 2 if V900546 == 020 ; 
replace relig2 = 2 if V900546 == 030 ;
replace relig2 = 2 if V900546 == 100 ;
replace relig2 = 2 if V900546 == 102 ; 
replace relig2 = 2 if V900546 == 109 ;
replace relig2 = 2 if V900546 == 120 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 122 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 123 & V900549!= 2 ;
replace relig2 = 2 if V900546 == 124 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 125 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 126 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 127 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 128 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 130 & V900549!= 2 ;
replace relig2 = 2 if V900546 == 133 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 134 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 135 & V900549!= 2 ;
replace relig2 = 2 if V900546 == 147 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 148 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 149 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 160 ;
replace relig2 = 2 if V900546 == 161 ; 
replace relig2 = 2 if V900546 == 162 ; 
replace relig2 = 2 if V900546 == 164 ;
replace relig2 = 2 if V900546 == 166 ; 
replace relig2 = 2 if V900546 == 167 ; 
replace relig2 = 2 if V900546 == 168 ; 
replace relig2 = 2 if V900546 == 169 ;
replace relig2 = 2 if V900546 == 170 ;
replace relig2 = 2 if V900546 == 180 ; 
replace relig2 = 2 if V900546 == 181 ; 
replace relig2 = 2 if V900546 == 182 ; 
replace relig2 = 2 if V900546 == 183 ;
replace relig2 = 2 if V900546 == 184 ; 
replace relig2 = 2 if V900546 == 185 ;  
replace relig2 = 2 if V900546 == 199 ;
replace relig2 = 2 if V900546 == 200 ; 
replace relig2 = 2 if V900546 == 201 ; 
replace relig2 = 2 if V900546 == 219 ; 
replace relig2 = 2 if V900546 == 221 ;
replace relig2 = 2 if V900546 == 222 ; 
replace relig2 = 2 if V900546 == 223 ; 
replace relig2 = 2 if V900546 == 224 ;
replace relig2 = 2 if V900546 == 225 ;
replace relig2 = 2 if V900546 == 228 ;
replace relig2 = 2 if V900546 == 233 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 235 & V900549!= 2 ; 
replace relig2 = 2 if V900546 == 242 ;
replace relig2 = 2 if V900546 == 250 ; 
replace relig2 = 2 if V900546 == 251 ; 
replace relig2 = 2 if V900546 == 252 ;
replace relig2 = 2 if V900546 == 253 ; 
replace relig2 = 2 if V900546 == 254 ; 
replace relig2 = 2 if V900546 == 255 ; 
replace relig2 = 2 if V900546 == 256 ;
replace relig2 = 2 if V900546 == 260 ; 
replace relig2 = 2 if V900546 == 268 ; 
replace relig2 = 2 if V900546 == 269 ; 
replace relig2 = 2 if V900546 == 271 ; 
replace relig2 = 2 if V900546 == 272 ;
replace relig2 = 2 if V900546 == 275 ; 
replace relig2 = 2 if V900546 == 280 ; 
replace relig2 = 2 if V900546 == 291 ; 
replace relig2 = 2 if V900546 == 292 ; 
replace relig2 = 2 if V900546 == 156 ; 


replace relig2 = 3 if V900546 == 231 ;
replace relig2 = 3 if V900546 == 232 ;
replace relig2 = 3 if V900546 == 129 ;
replace relig2 = 3 if V900546 == 130 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 131 ;
replace relig2 = 3 if V900546 == 132 & V900549== 2 ;
replace relig2 = 3 if V900546 == 243 ;
replace relig2 = 3 if V900546 == 244 ;
replace relig2 = 3 if V900546 == 257 ;
replace relig2 = 3 if V900546 == 258 ;
replace relig2 = 3 if V900546 == 266 ;
replace relig2 = 3 if V900546 == 120 & V900549== 2 ;
replace relig2 = 3 if V900546 == 121 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 122 & V900549== 2 ;
replace relig2 = 3 if V900546 == 123 & V900549== 2 ;
replace relig2 = 3 if V900546 == 124 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 125 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 126 & V900549== 2 ;
replace relig2 = 3 if V900546 == 127 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 128 ; 
replace relig2 = 3 if V900546 == 133 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 134 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 135 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 147 & V900549== 2 ;
replace relig2 = 3 if V900546 == 148 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 149 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 233 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 234 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 239 & V900549== 2 ;
replace relig2 = 3 if V900546 == 240 & V900549== 2 ; 
replace relig2 = 3 if V900546 == 249 & V900549== 2 ;
replace relig2 = 3 if V900546 == 267 & V900549== 2 ;

replace relig2 = 4 if V900546 == 400;
replace relig2 = 4 if V900546 == 600;
replace relig2 = 4 if V900546 == 700; 
replace relig2 = 4 if V900546 == 701;
replace relig2 = 4 if V900546 == 702;
replace relig2 = 4 if V900546 == 703; 
replace relig2 = 4 if V900546 == 704; 
replace relig2 = 4 if V900546 == 705; 
replace relig2 = 4 if V900546 == 706;
replace relig2 = 4 if V900546 == 707; 
replace relig2 = 4 if V900546 == 708; 
replace relig2 = 4 if V900546 == 719;

replace relig2 = 5 if V900546 == 500;
replace relig2 = 5 if V900546 == 501; 
replace relig2 = 5 if V900546 == 502; 
replace relig2 = 5 if V900546 == 503; 
replace relig2 = 5 if V900546 == 650;

replace relig2 = 9  if V900546 == 720;  
replace relig2 = 9  if V900546 == 721;  
replace relig2 = 9  if V900546 == 722; 
replace relig2 = 9  if V900546 == 723;  
replace relig2 = 9  if V900546 == 724;   
replace relig2 = 9  if V900546 == 729;
replace relig2 = 9  if V900546 == 730;
replace relig2 = 9  if V900546 == 732;
replace relig2 = 9  if V900546 == 740;  
replace relig2 = 9  if V900546 == 790; 
replace relig2 = 9  if V900546 == 795; 
replace relig2 = 9  if V900546 == 997;  
replace relig2 = 9  if V900546 == 300;  
replace relig2 = 9  if V900546 == 301; 
replace relig2 = 9  if V900546 == 302;  
replace relig2 = 9  if V900546 == 303;  
replace relig2 = 9  if V900546 == 304; 
replace relig2 = 9  if V900546 == 305;
replace relig2 = 9  if V900546 == 308;
replace relig2 = 9  if V900546 == 309; 
 

replace relig2 = 0 if V900546 == 800;
replace relig2 = 0 if V900546 == 801;
replace relig2 = 0 if V900546 == 995;

replace relig2 =99 if V900546 == 999;
replace relig2 =99 if V900546 == 998;

gen religFinal = V900546;

replace religFinal = 1 if relig2 == 1;
replace religFinal = 2 if relig2 == 2;
replace religFinal = 3 if relig2 == 3;
replace religFinal = 4 if relig2 == 4;
replace religFinal = 5 if relig2 == 5;
replace religFinal = 9 if relig2 == 9;
replace religFinal = 0 if relig2 == 0;
replace religFinal = 666 if relig2 ==99;
recode religFinal 666=4;

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
gen None=religFinal;
recode None 0=11 1/9=0;
recode None 11=1;

gen Gulf=V900357;
recode Gulf 7/9=.;
recode Gulf 5=1 3=2 1=3;

gen CA=V900526;
recode CA 5=1 4=2 3=3 2=4 1=5;
label define CA 1"1. Never" 2"2. A few times a yr" 3" 3. Once or twice a month" 4" 4. Almost every week" 5" 5. Every week";
label values CA CA;
 recode CA 0=1 9=1;

gen Pray=V900513;
recode Pray 5=1 4=2 3=3 2=4  1=5;
recode Pray 8/9=5;
label define Pray 1" 1. Never" 2" 2. Once a week or less" 3" 3. Few times a week" 4" 4. Once a day" 5"5. Several times a day";
label values Pray Pray;

gen BibleIn=V900516;
gen BibleLit=V900517;
gen BibleFinal=V900517;
recode BibleIn 1=11;
recode BibleIn 2=12 3=13 4=14 7=17 8=18 9=19;
replace BibleFinal=11 if BibleIn==11;
replace BibleFinal=12 if BibleIn==12;
replace BibleFinal=13 if BibleIn==13;
replace BibleFinal=14 if BibleIn==14;
replace BibleFinal=17 if BibleIn==17;
replace BibleFinal=18 if BibleIn==18;
replace BibleFinal=19 if BibleIn==19;
recode BibleFinal 11=1 12=2 13=2 14=3 17=7 18=9 19=9;
recode BibleFinal 7/9=.;
recode BibleFinal 1=3 3=1;
label define Biblefinal 1"1. Low" 3"3. High";
label values BibleFinal Biblefinal;

gen Ideology=V900406;
recode Ideology 0=. 8/9=.;
label define Ideology 1"1. Extremely Liberal" 7"7. Extremely Conservative";
label values Ideology Ideology;

gen Party=V900320;
recode Party 7/9=.;
replace Party=Party+1;
label define Party 1"1. Strong Democrat" 7"7. Strong Republican";
label values Party Party;


 gen Female=V900547;
 recode Female 2=1 1=0;
 
 gen Age=V900548;
 
 gen Race=V900549;
 recode Race 9=1;
 recode Race 4=3;
 gen White=Race;
 recode White 2/3=0;
 gen Black=Race;
 recode Black 1=0 2=1 3=0;
 gen OtherRace=Race;
 recode OtherRace 1=0 2=0 3=1;
 
 gen Income=V900664;
 recode Income 88/99=. 0=.;
 label define Income 1"1. >$2,999" 23"23.<90,000";
 label values Income Income;
 
 gen Education=V900557;
 recode Education 98/99=.;
 label define Education 1"01. 8th grade or less" 7"7. Advanced degree";
 label values Education Education;
 
 gen South=V900008;
 recode South 1/2=0 4=0 3=1;
 
 impute BibleFinal Female Age White Black Income Edu, gen (iBible);
 impute Ideology Female Age White Black Income Edu, gen (iIdeo);
 impute Income Female Age White Black  Edu, gen (iInc);
 impute Party Female Age White Black Income Edu, gen (iPID);

