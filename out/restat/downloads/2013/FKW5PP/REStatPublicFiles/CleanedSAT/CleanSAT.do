cd C:\DataFiles\Research-Papers\Immigration\Kato\REStatPublicFiles\CleanedSAT
*Rename directory according to own folder name.
*Make sure all College Board SAT Data files are in the same folder.
clear
set more off
capture log close
log using CleanSAT.log, text replace

set mem 500m
set matsize 3000






/*************************************************************************
Takao Kato & Chad Sparber
"Quotas and Quality: The Effect of H-1B Visa Restrictions 
   on the Pool of Prospective Undergraduate Students from Abroad"

Stata do-file for main dataset.
Data Source: College Board





This file keeps necessary SAT Data and appends year files.

The unique identifier for each student is the SATMAP variable; there should be 
multiple records per student with the records corresponding to those studentss 
score recipient choices. The file was created with a random sample of international 
students. Then their score report recipients were matched to Kato_Sparber_SchoolInfo.xlsx
to create information on colleges receiving score reports. All of the data is exactly the 
same for students with the same SATMAP, except for the college information that came from 
Kato_Sparber_SchoolInfo.xlsx, based on the various institutions that scores were sent to. 

The files provided are based on the cohort of international test-takers
who took the exam in their senior year of a given academic year.
They contain only the students' most recent test scores.
The variable latstsat tells you exactly when the scores provided were earned.

The SAT_TAKER variable indicates students that took a SAT test, 
a value of 0 indicates the student only took subject tests. 
If the student appears in the file they had those exam scores sent to an institution. 
If a value of 1 appears they took the SAT reasoning test. 
(i.e., this explains why some SAT M & V scores are missing or 0).

There is a coding error in the database for 2003; 
in 2003 the sat_taker is null for students that have only taken the subject tests.
Failure to record any sat_taker=0 2006 and beyond is a sample size issue:
In the prior years there were approximately 100K students that took only subject tests; 
in the more current years there have been less than 20K. 
The random sample is not catching any of the students that were taking only subject tests in the more current years.

A coding error in 2002 records non-sat takers as having "missing" sat scores. 
(All other years record those scores as 0).


The sample is not a traditional % sample of the population.
It is an unweighted sample of international senior test-takers within 
a year, the sample proportion varies across years.

The number of total international senior test-takers per academic year is:
2008: 23,236
2007: 22,541
2006: 22,849
2005: 28,882
2004: 36,219
2003: 38,699
2002: 37,808
2001: 9,956
2000: 9,635
use this information to infer year-specific sample weights.
*******************************************************************************/




/******************************************
1)Input raw data from the College Board.
  The data is in CSV format.
******************************************/
capture erase CleanSAT.dta

forvalues i=2000(1)2008 {
use `i'SAT.dta, clear
# delimit ;
keep ethdist satvrecn satmrecn sexsat frgnadd latstsat gradsat numsat2 sat_taker satmap 
     rcgapsdq income motheduc fatheduc citzsdq ethnsdq finaid varsca deggoal 
     wcundec wcoutus wcothst wcnrsta wchmstat wchome clasrank sdqyear sdqmonth
     type tier funding optional policy intlreq bea;
# delimit cr
gen year=`i'
capture append using CleanSAT.dta
tab year
sort year 
save CleanSAT.dta, replace
}





/******************************************
2)Calculate the number of senior test-takers
  per year in the sample. Use to infer
  weights.
******************************************/
gen samp=1
collapse (mean) samp, by(year satmap)
collapse (sum) samp, by(year)
sort year
list
save tempsamp.dta, replace

*Merge year-specific sample size with data, use population size to infer weights
use CleanSAT.dta, clear
sort year
merge year using tempsamp.dta
tab _merge
drop _merge
tab samp
gen weight=9635/samp if year==2000
replace weight=9956/samp if year==2001
replace weight=37808/samp if year==2002
replace weight=38699/samp if year==2003
replace weight=36219/samp if year==2004
replace weight=28882/samp if year==2005
replace weight=22849/samp if year==2006
replace weight=22541/samp if year==2007
replace weight=23236/samp if year==2008
count if weight==.
drop samp
tab year weight
sort year
save CleanSAT.dta, replace
erase tempsamp.dta





/******************************************
3)Fix errors in user-defined variables
  from Kato_Sparber_SchoolInfo.xlsx.
  Tabulate user-defined variables.
******************************************/
replace funding=	"Private"	 if funding=="NA"	 & type=="AltSource"		   
replace funding=	"Private"	 if funding=="NA"	 & type=="CommunityCollege"	 & bea==1	   
replace funding=	"Public"	 if funding=="NA"	 & type=="CommunityCollege"	 & bea!=1	   
replace funding=	"Private"	 if funding=="NA"	 & type=="InCB_NotUSN"		   
replace funding=	"International"	 if funding=="NA"	 & type=="International"		   
replace funding=	"Intl Public"	 if funding=="NA"	 & type=="IntlCC"		   
replace funding=	"Private"	 if funding=="NA"	 & type=="Medical"		   
replace funding=	"Private"	 if funding=="NA"	 & type=="Other"		   
replace funding=	"Proprietary"	 if funding=="NA"	 & type=="Proprietary"		   
replace funding=	"Public"	 if funding=="NA"	 & type=="Research"	 & tier=="Tier_3"	   
replace funding=	"Private"	 if funding=="NA"	 & type=="Research"	 & tier=="Top_50"	   
replace funding=	"Public"	 if funding=="Pubic"			   
replace funding=	"Private"	 if funding=="Privatea"			   
replace funding=	"Public"	 if funding=="Public "			 

replace optional=99 if optional==98 | (optional==. & type=="CommunityCollege")

sort year
save CleanSAT.dta, replace

count
tab type
tab tier
tab funding
tab optional
tab policy
tab intlreq
tab bea





/******************************************************************************************************
4a)Fix errors College Board's SAT data.
First, undefined (.) in 2003 should be 0 (these people have undefined SAT scores too)
        sat_taker=0 should mean that a student only took the SAT II at his/her most recent testing.
        nonexistence of sat_taker=0 in 2006 and beyond is due to population size (see above).
Second, Rescale SAT
        Note that satv=0 (or .) only when satm=0 (or .) and vice-versa.
        These are people who SHOULD have sat_taker=0.
Third, replace satv and satm 0 values with missing. 
        Note that in 2002 only, non-takers already have missing score values.
        This was a coding error, but we are making it the convention.
*****************************************************************************************************/
tab year if sat_taker==.
replace sat_taker=0 if sat_taker==. & year==2003 & satv==.
label var sat_taker "Took SAT = 1"

sum sat* if sat_taker==0
replace satvrecn=10*satvrecn
replace satmrecn=10*satmrecn
tab year if satvr==.
tab year if satvr==0
replace satvr=. if satvr==0 
replace satmr=. if satmr==0
gen satt = satvr+satmr
label var satt "Total SAT"





/******************************************************************************************************
4b)Clean College Board's SAT Dates information.
year: Represents a cohort of students taking the exam within an academic year.
          Year is the spring of Academic Year. 
          Expl: 2000 is for Fall 1999 - Spring 2000
latstsat: the date of a student's most recent SAT exam, the only score reported.
          The last two digits are for year. The first one or two are for month.
          latstsat=0 for sat_taker=0; redefine as undefined.
          latstsat=. for sat_taker=0 in 2004 & 2005. Keep as undefined.
sdqyear:  the year in which the student most recently completed the questionairre.
          Some values are 0 and should not be.
sdqmonth: the month in which the student most recently completed the questionairre.
          Some values are 0 and should not be.
          Note: questionairres may be completed far before or after the test date.
gradsat:  High School Graduation Date.
          Undefineds are 0 2000-2003; are . afterward. Convert all to .
UNKNOWN:  the date in which a student requests a score report to be sent.

Let sample begin with first test date (Nov 2000) that H1B did not bind anyone.

*****************************************************************************************************/
label var year "Spring of Acadmic Year"

tab latstsat sat_taker
tab year sat_taker if latstsat==.
replace latstsat=. if latstsat==0
gen latstm=floor(latstsat/100)
gen latsty=latstsat-100*latstm
replace latsty=1900+latsty if latsty>20
replace latsty=2000+latsty if latsty<=20
label var latstm "Month of Latest Exam"
label var latsty "Year of Latest Exam"
gen satdate=100*latsty + latstm
label var satdate "Date of Latest Exam, YYYYMM"
drop latstsat

tab year if sdqyear==0
replace sdqyear=. if sdqyear==0
replace sdqmonth=. if sdqmonth==0
label var sdqyear "Year Student Completed Survey"
label var sdqmonth "Month Student Completed Survey"

replace gradsat=. if gradsat==0
gen gradm=floor(gradsat/100)
gen grady=gradsat-100*gradm
replace grady=1900+grady if grady>20
replace grady=2000+grady if grady<=20
replace gradm=. if grady<1980
replace grady=. if grady<1980
label var gradm "Month of HS Graduation"
label var grady "Year of HS Graduation"
gen graddate=100*grady + gradm
label var graddate "Date of HS Graduation, YYYYMM"
drop gradsat

*Drop those with latest SAT occuring before Nov 2000
tab year if latsty==1999 | (latsty==2000 & latstm<11)
drop if latsty==1999 | (latsty==2000 & latstm<11)
drop if latsty==.





/******************************************************************************************************
4c)Clean College Board's SAT Ethnic & Gender information.
ethnsdq has missing values, all coded as ethdist==0
ethdist has no missing values.
convert sex into female.
*****************************************************************************************************/
tab ethdist ethnsdq if ethdist!=ethnsdq
tab ethdist if ethnsdq==.
tab ethnsdq if ethdist==.
drop ethnsdq

gen race=.
replace race=1 if ethdist==2
replace race=2 if ethdist==3
replace race=3 if ethdist>=4 & ethdist<=6
replace race=4 if ethdist==1|ethdist==8
replace race=5 if ethdist==7
drop ethdist

label define racelbl 1 "Asian"
label define racelbl 2 "Black", add
label define racelbl 3 "Hispanic", add
label define racelbl 4 "Other", add
label define racelbl 5 "White", add
label values race racelbl

gen female=0 if sex=="M"
replace female=1 if sex=="F"
drop sex





/******************************************************************************************************
4d)Clean College Board's Foreign Address information.
Drop Missing/Undefined codes, Label remaining
999 means country not listed
aggregates countries not consistent through sample
Identify Key 5 Control countries
*****************************************************************************************************/
tab year if frgnadd==0
drop if frgnadd==0

di "Country not on SAT registry"
tab year if frgnadd==999
drop if frgnadd==999

tab year if frgnadd==.
drop if frgnadd==.

*Aggregate West Indies and Associated States
replace frgnadd=615 if frgnadd==012
replace frgnadd=615 if frgnadd==154
replace frgnadd=615 if frgnadd==227
replace frgnadd=615 if frgnadd==486
replace frgnadd=615 if frgnadd==011
replace frgnadd=615 if frgnadd==521
replace frgnadd=615 if frgnadd==522

*Aggregate Serbia & Montenegro
replace frgnadd=625 if frgnadd==499
replace frgnadd=625 if frgnadd==383

*Aggregate UK
replace frgnadd=588 if frgnadd==180
replace frgnadd=588 if frgnadd==434
replace frgnadd=588 if frgnadd==495
replace frgnadd=588 if frgnadd==610
replace frgnadd=588 if frgnadd==277

*Aggregate Japan & Okinawa
replace frgnadd=300 if frgnadd==440

*Drop countries with missing codes in some years
drop if frgnadd==090
drop if frgnadd==030
drop if frgnadd==105
drop if frgnadd==353
drop if frgnadd==002
drop if frgnadd==187

*Drop country codes with missing labels
drop if frgnadd==229
drop if frgnadd==367

*Aggregate Canadian Provinces
replace frgnadd=100 if (frgnadd>=643 & frgnadd<=654) | frgnadd==626


*Relabel Countries
capture label drop addlbl
label define addlbl	1	 "Afghanistan"   
label define addlbl	3	 "Albania", add	   
label define addlbl	5	 "Algeria", add	   
label define addlbl	8	 "Andorra", add	   
label define addlbl	10	 "Angola", add	    
label define addlbl	15	 "Argentina", add	   
label define addlbl	16	 "Armenia", add	   
label define addlbl	17	 "Aruba", add	   
label define addlbl	20	 "Australia", add	   
label define addlbl	25	 "Austria", add	   
label define addlbl	29	 "Azerbaijan", add	   
label define addlbl	35	 "Bahamas, The", add	   
label define addlbl	40	 "Bahrain", add	   
label define addlbl	45	 "Bangladesh", add	   
label define addlbl	50	 "Barbados", add	   
label define addlbl	55	 "Belgium", add	   
label define addlbl	56	 "Belize", add	   
label define addlbl	58	 "Benin", add	   
label define addlbl	60	 "Bermuda", add	   
label define addlbl	63	 "Bhutan", add	   
label define addlbl	65	 "Bolivia", add	   
label define addlbl	69	 "Bosnia and Herzegovina", add	   
label define addlbl	70	 "Botswana", add	   
label define addlbl	75	 "Brazil", add	   
label define addlbl	77	 "British Virgin Islands", add	   
label define addlbl	81	 "Brunei", add	   
label define addlbl	85	 "Bulgaria", add	   
label define addlbl	92	 "Burundi", add	   
label define addlbl	94	 "Belarus", add	   
label define addlbl	95	 "Cameroon", add	   
label define addlbl	100	 "Canada", add	   
label define addlbl	106	 "Cape Verde", add	   
label define addlbl	107	 "Micronesia, Federated States of", add	   
label define addlbl	110	 "Cayman Islands", add	   
label define addlbl	113	 "Central African Republic", add	   
label define addlbl	114	 "Chad", add	   
label define addlbl	115	 "Chile", add	   
label define addlbl	120	 "Colombia", add	   
label define addlbl	122	 "Comoros", add	   
label define addlbl	125	 "Congo, Republic of the (Brazzaville)", add	   
label define addlbl	126	 "Cook Islands", add	   
label define addlbl	130	 "Costa Rica", add	   
label define addlbl	133	 "Croatia", add	   
label define addlbl	135	 "Cuba", add	   
label define addlbl	140	 "Cyprus", add	   
label define addlbl	142	 "Czech Republic", add	   
label define addlbl	150	 "Denmark", add	   
label define addlbl	153	 "Djibouti", add	   
label define addlbl	155	 "Dominican Republic", add	   
label define addlbl	165	 "Ecuador", add	   
label define addlbl	170	 "Egypt", add	   
label define addlbl	175	 "El Salvador", add	   
label define addlbl	182	 "Eritrea", add	   
label define addlbl	183	 "Equatorial Guinea", add	   
label define addlbl	184	 "Estonia", add	   
label define addlbl	185	 "Ethiopia", add	   
label define addlbl	190	 "Fiji", add	   
label define addlbl	195	 "Finland", add	   
label define addlbl	200	 "France", add	   
label define addlbl	202	 "French Polynesia", add	   
label define addlbl	203	 "French Guiana", add	   
label define addlbl	204	 "Gabon", add	   
label define addlbl	205	 "Gambia, The", add	   
label define addlbl	208	 "Georgia", add	   
label define addlbl	210	 "Germany", add	   
label define addlbl	215	 "Ghana", add	   
label define addlbl	217	 "Gibraltar", add	   
label define addlbl	220	 "Greece", add	   
label define addlbl	225	 "Greenland", add	   
label define addlbl	228	 "Guadeloupe", add	   
label define addlbl	230	 "Guatemala", add	   
label define addlbl	233	 "Guinea", add	   
label define addlbl	234	 "Guinea-Bissau", add	   
label define addlbl	235	 "Guyana", add	   
label define addlbl	240	 "Haiti", add	   
label define addlbl	245	 "Honduras", add	   
label define addlbl	250	 "Hong Kong", add	   
label define addlbl	251	 "Hungary", add	   
label define addlbl	255	 "Iceland", add	   
label define addlbl	260	 "India", add	   
label define addlbl	265	 "Indonesia", add	   
label define addlbl	270	 "Iran", add	   
label define addlbl	273	 "Iraq", add	   
label define addlbl	275	 "Ireland", add	   
label define addlbl	280	 "Israel", add	   
label define addlbl	285	 "Italy", add	   
label define addlbl	290	 "Cote D’Ivoire", add	   
label define addlbl	295	 "Jamaica", add	   
label define addlbl	300	 "Japan", add	   
label define addlbl	305	 "Jordan", add	   
label define addlbl	307	 "Cambodia", add	   
label define addlbl	308	 "Kazakhstan", add	   
label define addlbl	310	 "Kenya", add	   
label define addlbl	312	 "Kiribati", add	   
label define addlbl	314	 "Korea (DPR)", add	   
label define addlbl	315	 "Korea (ROK)", add	   
label define addlbl	320	 "Kuwait", add	   
label define addlbl	323	 "Kyrgyzstan", add	   
label define addlbl	325	 "Laos", add	   
label define addlbl	328	 "Latvia", add	   
label define addlbl	330	 "Lebanon", add	   
label define addlbl	333	 "Lesotho", add	   
label define addlbl	335	 "Liberia", add	   
label define addlbl	340	 "Libya", add	   
label define addlbl	343	 "Liechtenstein", add	   
label define addlbl	344	 "Lithuania", add	   
label define addlbl	345	 "Luxembourg", add	   
label define addlbl	347	 "Macau", add	   
label define addlbl	348	 "Macedonia, The Former Yugoslav Republic of", add	   
label define addlbl	350	 "Madagascar", add	   
label define addlbl	355	 "Malawi", add	   
label define addlbl	360	 "Malaysia", add	   
label define addlbl	361	 "Maldives", add	   
label define addlbl	363	 "Mali", add	   
label define addlbl	365	 "Malta", add	   
label define addlbl	366	 "Martinique", add	   
label define addlbl	368	 "Marshall Islands", add	   
label define addlbl	369	 "Mauritania", add	   
label define addlbl	370	 "Mauritius", add	   
label define addlbl	375	 "Mexico", add	   
label define addlbl	376	 "Moldova", add	   
label define addlbl	378	 "Monaco", add	   
label define addlbl	379	 "Mongolia", add	   
label define addlbl	380	 "Morocco", add	   
label define addlbl	381	 "Montserrat", add	   
label define addlbl	383	 "Montenegro", add	   
label define addlbl	385	 "Mozambique", add	   
label define addlbl	386	 "Nauru", add	   
label define addlbl	387	 "Nepal", add	   
label define addlbl	388	 "Namibia", add	   
label define addlbl	390	 "Netherlands", add	   
label define addlbl	395	 "Netherlands Antilles", add	   
label define addlbl	396	 "New Caledonia", add	   
label define addlbl	400	 "Papua New Guinea", add	   
label define addlbl	405	 "New Zealand", add	   
label define addlbl	420	 "Nicaragua", add	   
label define addlbl	425	 "Niger", add	   
label define addlbl	430	 "Nigeria", add	   
label define addlbl	433	 "Niue", add	   
label define addlbl	435	 "Norway", add	   
label define addlbl	443	 "Oman", add	   
label define addlbl	445	 "Pakistan", add	   
label define addlbl	447	 "Palau", add	   
label define addlbl	450	 "Panama", add	   
label define addlbl	455	 "Paraguay", add	   
label define addlbl	457	 "China, People’s Republic of", add	   
label define addlbl	460	 "Peru", add	   
label define addlbl	465	 "Philippines", add	   
label define addlbl	470	 "Poland", add	   
label define addlbl	475	 "Portugal", add	   
label define addlbl	477	 "Qatar", add	   
label define addlbl	480	 "Zimbabwe", add	   
label define addlbl	482	 "Reunion", add	   
label define addlbl	483	 "Romania", add	   
label define addlbl	484	 "Russia", add	   
label define addlbl	487	 "Rwanda", add	   
label define addlbl	488	 "San Marino", add	   
label define addlbl	489	 "Sao Tome and Principe", add	   
label define addlbl	490	 "Saudi Arabia", add	   
label define addlbl	497	 "Senegal", add	   
label define addlbl	498	 "Seychelles", add	   
label define addlbl	499	 "Serbia", add	   
label define addlbl	500	 "Sierra Leone", add	   
label define addlbl	503	 "Slovakia", add	   
label define addlbl	504	 "Slovenia", add	   
label define addlbl	505	 "Singapore", add	   
label define addlbl	506	 "Solomon Islands", add	   
label define addlbl	507	 "Somalia", add	   
label define addlbl	510	 "South Africa", add	   
label define addlbl	515	 "Spain", add	   
label define addlbl	520	 "Sri Lanka", add	   
label define addlbl	525	 "Sudan", add	   
label define addlbl	527	 "Suriname", add	   
label define addlbl	530	 "Swaziland", add	   
label define addlbl	535	 "Sweden", add	   
label define addlbl	540	 "Switzerland", add	   
label define addlbl	545	 "Syria", add	   
label define addlbl	550	 "Tahiti", add	   
label define addlbl	555	 "Taiwan", add	   
label define addlbl	556	 "Tajikistan", add	   
label define addlbl	560	 "Tanzania", add	   
label define addlbl	565	 "Thailand", add	   
label define addlbl	567	 "Togo", add	   
label define addlbl	570	 "Tonga", add	   
label define addlbl	575	 "Trinidad and Tobago", add	   
label define addlbl	580	 "Tunisia", add	   
label define addlbl	584	 "Turkmenistan", add	   
label define addlbl	585	 "Turkey", add	   
label define addlbl	586	 "Turks and Caicos Islands", add	   
label define addlbl	587	 "Tuvalu", add	   
label define addlbl	588	 "United Kingdom", add	   
label define addlbl	589	 "Ukraine", add	   
label define addlbl	590	 "Uganda", add	   
label define addlbl	591	 "United Arab Emirates", add	   
label define addlbl	593	 "Burkina Faso", add	   
label define addlbl	594	 "Uzbekistan", add	   
label define addlbl	595	 "Uruguay", add	   
label define addlbl	596	 "Vanuatu", add	   
label define addlbl	597	 "Holy See (Vatican City)", add	   
label define addlbl	600	 "Venezuela", add	   
label define addlbl	605	 "Vietnam", add	   
label define addlbl	611	 "West Bank & Palestinian Territories", add	   
label define addlbl	615	 "West Indies and Associated States", add	   
label define addlbl	620	 "Samoa (former Western Samoa)", add	   
label define addlbl	623	 "Yemen", add	   
label define addlbl	625	 "Yugoslav, Late Era (Serbia & Montenegro)", add	   
label define addlbl	630	 "Congo, Democratic Republic of the (former Kinshasa)", add	   
label define addlbl	635	 "Zambia", add	   
label values frgnadd addlbl					 

gen australia=0
replace australia=1 if frgnadd==20

gen canada=0
replace canada=1 if frgnadd>=643 & frgnadd<=654
replace canada=1 if frgnadd==626
replace canada=1 if frgnadd==100

gen chile=0
replace chile=1 if frgnadd==115

gen mexico=0
replace mexico=1 if frgnadd==375

gen singapore=0
replace singapore=1 if frgnadd==505

gen key5=0
replace key5=1 if aus==1|can==1|chile==1|mex==1|sing==1





/******************************************************************************************************
4e)Clean remaining College Board data.
*****************************************************************************************************/
*SATMAP
label var satmap "Unique Student Identifier"


*Cumulative GPA
rename rcgapsdq hsgpa
replace hsgpa=1.3 if hsgpa>1.3 & hsgpa<1.35
replace hsgpa=1.7 if hsgpa>1.6 & hsgpa<1.7
replace hsgpa=2.3 if hsgpa>2.3 & hsgpa<2.35
replace hsgpa=2.7 if hsgpa>2.6 & hsgpa<2.7
replace hsgpa=3.3 if hsgpa>3.3 & hsgpa<3.35
replace hsgpa=3.7 if hsgpa>3.6 & hsgpa<3.7
replace hsgpa=4.3 if hsgpa>4.3 & hsgpa<4.35


*INCOME
gen nomincome=income08
replace nomincome=0 if income==0 
replace nomincome=1 if income==1 
replace nomincome=2 if income==2 | income==3
replace nomincome=3 if income==4 | income==5
replace nomincome=4 if income==6 | income==7
replace nomincome=5 if income==8 
replace nomincome=6 if income==9 
replace nomincome=7 if income==10 
replace nomincome=8 if income==11 
replace nomincome=9 if income==12 
replace nomincome=10 if (income08>=10 & income08!=.) | income==13
replace nomincome=0 if income08==. & income==.
tab nomincome income
tab nomincome income08
drop income income08
replace nomincome=. if nomincome==0

label var nomincome "Nominal Income Range"
label define nomlbl  0  "No Response"   
label define nomlbl  1  "<10,000", add    
label define nomlbl  2  "10,000-20,000", add    
label define nomlbl  3  "20,000-30,000", add    
label define nomlbl  4  "30,000-40,000", add    
label define nomlbl  5  "40,000-50,000", add    
label define nomlbl  6  "50,000-60,000", add    
label define nomlbl  7  "60,000-70,000", add    
label define nomlbl  8  "70,000-80,000", add    
label define nomlbl  9  "80,000-100,000", add    
label define nomlbl  10  ">100,000", add    
label values nomincome nomlbl      


*Parental Education; Aggregate
replace motheduc=. if motheduc==0
replace motheduc=1 if mothed==2
replace motheduc=5 if mothed==6
replace motheduc=7 if mothed==8

replace fatheduc=. if fatheduc==0
replace fatheduc=1 if fathed==2
replace fatheduc=5 if fathed==6
replace fatheduc=7 if fathed==8
 
label define motheduclbl  1  "< HS Degree", add    
label define motheduclbl  3  "HS DIPLOMA", add    
label define motheduclbl  4  "BUSINESS SCHOOL", add    
label define motheduclbl  5  "SOME COLLEGE or ASSOC", add    
label define motheduclbl  7  "BACHELORS DEGREE or SOME GRAD", add    
label define motheduclbl  9  "GRAD DEGREE", add    
label values motheduc motheduclbl        
        
label define fatheduclbl  1  "< HS Degree", add    
label define fatheduclbl  3  "HS DIPLOMA", add    
label define fatheduclbl  4  "BUSINESS SCHOOL", add    
label define fatheduclbl  5  "SOME COLLEGE or ASSOC", add    
label define fatheduclbl  7  "BACHELORS DEGREE or SOME GRAD", add    
label define fatheduclbl  9  "GRAD DEGREE", add    
label values fatheduc fatheduclbl     


*Citizenship: Want to keep just foreign citizens, but codes are:
*0 No Response    
*1 US Citizen or National    
*2 US Permanent Resident or Refugee    
*3 Citizen of another country    
*4 Other or Unknown  
tab citzsdq
keep if citzsdq==3
drop citzsdq


*Financial Aid
gen aid=.
replace aid=0 if finaid==2|finaid==3
replace aid=1 if finaid==1
label var aid "Sure to apply for fin aid = 1"
drop finaid


*Varsity Sports
rename varsca athlete
label var athlete "Intent to Play College Varsity Sports = 1"


*Ultimate Degree Goal: Create Variable for KNOWN goal of Advanced Degree
replace deggoal=. if deggoal==0
label define goallbl 0  "NO RESPONSE"    
label define goallbl 1  "CERTIFICATE", add    
label define goallbl 2  "ASSOCIATE", add    
label define goallbl 3  "BACHELOR'S", add    
label define goallbl 4  "MASTER'S", add    
label define goallbl 5  "DOCTORAL", add    
label define goallbl 6  "OTHER", add    
label define goallbl 7  "UNDECIDED", add	   
label values deggoal goallbl					 

gen advanced=0
replace advanced=. if deggoal==.
replace advanced=1 if deggoal==4|deggoal==5
label var advanced "Known goal: Adv Degree (excl professional)"

gen phd=0
replace phd=. if deggoal==.
replace phd=1 if deggoal==5


/*School Location Preference. Survey Asked, 
"Where would you like to go to college?
"You may mark more than one answer."
The options, several of which make no sense to an intl student, were:
a) Undecided
b) Outside US
c) Beyond States Bordering Mine
d) In states bordering mine
e) In My Home State
f) Close to Home
Keep the first two. */
drop wcoth wcn wch*
label var wcundec "Undecided about desired college location = 1"
label var wcoutus "Interested in college outside US = 1"


*Class Rank
replace clasrank=. if clasrank==0 
label define ranklbl 0  "NO RESPONSE"    
label define ranklbl 1  "HIGHEST TENTH", add    
label define ranklbl 2  "2ND TENTH", add    
label define ranklbl 3  "2ND FIFTH", add    
label define ranklbl 4  "MID FIFTH", add    
label define ranklbl 5  "4TH FIFTH", add    
label define ranklbl 6  "LOWEST FIFTH", add	   
label values clasrank ranklbl					 


*BEA LABELS 
label define bealbl 1 "New England"   
label define bealbl 2 "Mid East Coast", add   
label define bealbl 3 "Great Lakes", add   
label define bealbl 4 "Plains", add   
label define bealbl 5 "Southeast", add   
label define bealbl 6 "Southwest", add   
label define bealbl 7 "Rocky Mountain", add   
label define bealbl 8 "Far West", add   
label define bealbl 9 "International", add	   
label values bea bealbl					 


*Save
# delimit ;
order year satmap weight latsty latstm satdate satvrecn satmrecn satt sat_taker hsgpa clasrank numsat2 deggoal 
      motheduc fatheduc race female athlete nomincome aid advanced phd
      frgnadd aust can chil mex sing key5
      wcundec wcoutus 
      sdqyear sdqmonth grady gradm graddate
      type tier funding optional policy intlreq bea;
# delimit cr

sort year satmap
save CleanSAT.dta, replace





/******************************************************************************************************
5a)Create Additional Variables: Did student send any reports internationally?
*****************************************************************************************************/
gen anyintl=0
replace anyintl=1 if type=="International"
replace anyintl=1 if type=="IntlCC"
replace anyintl=1 if type=="IntlProprietary"
replace anyintl=1 if type=="USAbroad"
collapse (sum) anyintl, by(year satmap)
replace anyintl=1 if anyintl>0
label var anyintl "Did Student send any reports to Intl schools?"
sort year satmap
save temp.dta, replace
use CleanSAT.dta, clear
merge year satmap using temp.dta
tab _merge
drop _merge
sort year satmap
save CleanSAT.dta, replace
erase temp.dta





/******************************************************************************************************
5b)Create Additional Variables: Did citizens know they would be part of EU?

Use last test date as the student signal of interest.
Use month after treaty of accession signed to indicate change of EU status,
    which would affect students taking exam on or after that date.
Note that a delay does occur between accession treaty signing and actual membership.

Policy Dates:
Start - Apr 2003:    EU 15

May 2003 - Apr 2005: EU 15 + New 10

May 2005 - End:      EU 15 + New 10 + Bulgaria & Romania



Do the same for actually being in the EU.
That is, determine whether an SAT taker will have access to cheap EU
 education in the Fall of their freshman year.
Assume juniors take SAT in Spring, seniors take in Fall.

Students taking SAT on or after who will have a cheap freshman year in EU:
Whole Sample: EU 15

Spring 2003:  EU 15 + New 10                       (in EU 1 May 2004)

Spring 2006:  EU 15 + New 10 + Bulgaria & Romania  (in EU 1 Jan 2007)
*****************************************************************************************************/
gen eu_t=0
replace eu_t=1 if frgnadd==055
replace eu_t=1 if frgnadd==200
replace eu_t=1 if frgnadd==210
replace eu_t=1 if frgnadd==285
replace eu_t=1 if frgnadd==345
replace eu_t=1 if frgnadd==390
replace eu_t=1 if frgnadd==150
replace eu_t=1 if frgnadd==275
replace eu_t=1 if frgnadd==588|frgnadd==180|frgnadd==434|frgnadd==495|frgnadd==610|frgnadd==277
replace eu_t=1 if frgnadd==220
replace eu_t=1 if frgnadd==475
replace eu_t=1 if frgnadd==515
replace eu_t=1 if frgnadd==025
replace eu_t=1 if frgnadd==195
replace eu_t=1 if frgnadd==535

replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==140
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==142
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==184
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==251
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==328
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==344
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==365
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==470
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==503
replace eu_t=1 if (latsty>2003 |(latsty==2003 & latstm>5)) & frgnadd==504

replace eu_t=1 if (latsty>2005 |(latsty==2005 & latstm>5)) & frgnadd==085
replace eu_t=1 if (latsty>2005 |(latsty==2005 & latstm>5)) & frgnadd==483

replace eu_t=. if latsty==.
label var eu_t "Signed EU Accession Treaty"
tab frgnadd latsty if eu_t==1


gen eu_in=0
replace eu_in=1 if frgnadd==055
replace eu_in=1 if frgnadd==200
replace eu_in=1 if frgnadd==210
replace eu_in=1 if frgnadd==285
replace eu_in=1 if frgnadd==345
replace eu_in=1 if frgnadd==390
replace eu_in=1 if frgnadd==150
replace eu_in=1 if frgnadd==275
replace eu_in=1 if frgnadd==588|frgnadd==180|frgnadd==434|frgnadd==495|frgnadd==610|frgnadd==277
replace eu_in=1 if frgnadd==220
replace eu_in=1 if frgnadd==475
replace eu_in=1 if frgnadd==515
replace eu_in=1 if frgnadd==025
replace eu_in=1 if frgnadd==195
replace eu_in=1 if frgnadd==535

replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==140
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==142
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==184
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==251
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==328
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==344
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==365
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==470
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==503
replace eu_in=1 if (latsty>2003 |(latsty==2003 & latstm>3)) & frgnadd==504

replace eu_in=1 if (latsty>2006 |(latsty==2006 & latstm>3)) & frgnadd==085
replace eu_in=1 if (latsty>2006 |(latsty==2006 & latstm>3)) & frgnadd==483

replace eu_in=. if latsty==.
label var eu_in "Have cheap EU education"
tab frgnadd latsty if eu_in==1





/******************************************************************************************************
5c)Create Additional Variables: Was H1B visa policy binding?

Use last test date as the student signal of interest.
Use month after policy change signed to indicate change of bind,
    which would affect students taking exam on or after that date.

Policy Dates:
Start - Oct 2000:    Binding for all except Mex, Can
                             [AC21 signed Oct 2000]
Nov 2000 - Oct 2003: Binding for None
                             [AC21 ends Oct 2003; Chi & Sing FT signed in Sept 2003]
Nov 2003 - May 2005: Binding for all except Mex, Can, Chi, Sing
                             [Australia FT signed in May 2005]
June 2005 - End:     Binding for all except Mex, Can, Chi, Sing, Aus
******************************************************************************************************/
gen bind=1
replace bind=0 if can==1 
replace bind=0 if mex==1 

replace bind=0 if (latstm==11 | latstm==12) & latsty==2000
replace bind=0 if latsty==2001 | latsty==2002
replace bind=0 if latstm<=10 & latsty==2003

replace bind=0 if sing==1 & latsty>=2003 
replace bind=0 if chi==1 & latsty>=2003 

replace bind=0 if aus==1 & latstm>=6 & latsty==2005
replace bind=0 if aus==1 & latsty>=2006

replace bind=. if latsty==.
label var bind "Bound by H-1B Visa Cap?"

tab latsty bind if aus==1
tab latsty bind if can==1
tab latsty bind if chi==1
tab latsty bind if mex==1
tab latsty bind if sing==1
tab latsty bind if key5==0





/******************************************************************************************************
5d)Rename Variables
*******************************************************************************************************/
rename year acyear
rename satmr math
rename satvr verbal
rename satt sat
rename hsgpa gpa





/******************************************************************************************************
6)Create Numerical (and Generalized Numerical) Codes for Type/Tier/Funding
*******************************************************************************************************/
gen typenum=.					   
replace typenum=	1	 if type=="Research"	   
replace typenum=	2	 if type=="LiberalArts"   
replace typenum=	3	 if type=="Masters"   
replace typenum=	4	 if type=="Baccalaureate"   
replace typenum=	5	 if type=="Branch"   
replace typenum=	6	 if type=="Specialty"   
replace typenum=	7	 if type=="Medical"   
replace typenum=	8	 if type=="CommunityCollege"   
replace typenum=	9	 if type=="TwoYrPrivate"   
replace typenum=	10	 if type=="Proprietary"   
replace typenum=	11	 if type=="InCB_NotUSN"   
replace typenum=	12	 if type=="AltSource"   
replace typenum=	13	 if type=="International"   
replace typenum=	14	 if type=="IntlCC"   
replace typenum=	15	 if type=="USAbroad"   
replace typenum=	16	 if type=="NonAcademic"   
replace typenum=	17	 if type=="Other" 
					   
gen tiernum=.					   
replace tiernum= 	1	 if tier=="Top_10"   
replace tiernum= 	2	 if tier=="Top_25"   
replace tiernum= 	3	 if tier=="Top_50"   
replace tiernum= 	4	 if tier=="Top_100"   
replace tiernum= 	5	 if tier=="Other_Tier_1"   
replace tiernum= 	6	 if tier=="Tier_3"   
replace tiernum= 	7	 if tier=="Tier_4"   
replace tiernum= 	8	 if tier=="International"   
replace tiernum= 	9	 if tier=="NotRanked"   
replace tiernum= 	10	 if tier=="Unranked"   
replace tiernum= 	11	 if tier=="NA" 
  
gen gentier=.					   
replace gentier=	1	if tiernum==	1	 & (typenum==3 | typenum==4)	   
replace gentier=	1	if tiernum==	2	 & (typenum==1 | typenum==2)	   
replace gentier=	1	if tiernum==	3	 & (typenum==1 | typenum==2)	   
replace gentier=	2	if tiernum==	2	 & (typenum==3 | typenum==4)	   
replace gentier=	2	if tiernum==	4	 & (typenum==1 | typenum==2)	   
replace gentier=	2	if tiernum==	5	 & (typenum>=1 & typenum<=4)	   
replace gentier=	3	if tiernum==	6	 & (typenum>=1 & typenum<=4)	   
replace gentier=	3	if tiernum==	7	 & (typenum>=1 & typenum<=4)	   
replace gentier=	4	if tiernum==	10	 & (typenum>=1 & typenum<=4)	   
replace gentier=	5	if tiernum>=	8	 & tiernum!=. & typenum>=5	   
					   
gen genfund=.					   
replace genfund=	1	 if funding=="Public"   
replace genfund=	2	 if funding=="Private"   
replace genfund=	3	 if funding=="Proprietary"   
replace genfund=	4	 if funding=="International"   
replace genfund=	4	 if funding=="Intl Public"   
replace genfund=	4	 if funding=="NA"   
replace genfund=	4	 if funding=="Unknown" 
  
label define typenumlbl 	1	 "Research"   
label define typenumlbl 	2	 "Liberal Arts", add	   
label define typenumlbl 	3	 "Masters", add	   
label define typenumlbl 	4	 "Baccalaureate", add	   
label define typenumlbl 	5	 "Branch", add	   
label define typenumlbl 	6	 "Specialty", add	   
label define typenumlbl 	7	 "Medical", add	   
label define typenumlbl 	8	 "Community Coll", add	   
label define typenumlbl 	9	 "2 Yr Private", add	   
label define typenumlbl 	10	 "Proprietary", add	   
label define typenumlbl 	11	 "In CB, Not USN", add	   
label define typenumlbl 	12	 "Alt Source", add	   
label define typenumlbl 	13	 "International", add	   
label define typenumlbl 	14	 "Intl CC", add	   
label define typenumlbl 	15	 "US Abroad", add	   
label define typenumlbl 	16	 "NCAA", add	   
label define typenumlbl 	17	 "Other", add	   
label values typenum typenumlbl					   
					   
label define tiernumlbl	1	 "Top 10"   
label define tiernumlbl	2	 "Top 25", add	   
label define tiernumlbl	3	 "Top 50", add	   
label define tiernumlbl	4	 "Top 100", add	   
label define tiernumlbl	5	 "Other Tier 1", add	   
label define tiernumlbl	6	 "Tier 3", add	   
label define tiernumlbl	7	 "Tier 4", add	   
label define tiernumlbl	8	 "International", add	   
label define tiernumlbl	9	 "Not Ranked", add	   
label define tiernumlbl	10	 "Unranked", add	   
label define tiernumlbl	11	 "NA", add	   
label values tiernum tiernumlbl					 
  
label define gentierlbl 	1	 "Top"   
label define gentierlbl 	2	 "Mid", add	   
label define gentierlbl 	3	 "Bottom", add	   
label define gentierlbl 	4	 "Unranked, Big 4 Type", add	   
label define gentierlbl 	5	 "Unranked Type", add	   
label values gentier gentierlbl					   
					   
label define genfundlbl 	1	 "Public"   
label define genfundlbl 	2	 "Private", add	   
label define genfundlbl 	3	 "Proprietary", add	   
label define genfundlbl 	4	 "Other/Unknown", add	   
label values genfund genfundlbl					 









sort latsty satmap
save CleanSAT.dta, replace











capture log close

exit
