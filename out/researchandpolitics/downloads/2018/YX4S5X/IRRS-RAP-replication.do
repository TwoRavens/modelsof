
clear
set more off

use irrs-rap-replication-data.dta


 /* EU Referendum */
 
*If there was a referendum on Britain's membership of the European Union, how would you vote?
*(Rotate choices 1 and 2)
*1. I would vote for Britain to remain a member of the European Union.
*2. I would vote for Britain to leave the European Union.
*3. I would not vote.
*4. Don't know

 gen brexit5=w5EUref1
 recode brexit5 (1=1) (2=3) (3=2) (4=2)	
 
 gen brexit6=w6EUref1
 recode brexit6 (1=1) (2=3) (3=2) (4=2)	

 gen brexit7=w7EUref1
 recode brexit7 (1=1) (2=3) (3=2) (4=2)	

 
 /* Variables are labeled "wave 10" (w10) when they are actually the eigth British wave. (This numbering is so surveys fielded concurrently in the larger cross-national study would have the same wave numbers. Between the 7th wave and the 8th (British wave), two additional waves (waves 8 and 9) were fielded in the US */
  gen brexit10=w10EUref1
 recode brexit10 (1=1) (2=3) (3=2) (4=2)	
 

 /* Nativism battery -- coded so that higher values indicate greater nativism
   
-[w2eupan1] Even in its milder forms, Islam is a serious danger to Western civilization.
-[w2eupan2] The United Kingdom  has benefitted from the arrival in recent decades of people from many different countries and cultures.
-[w2eupan3]  All further immigration to the UK should be halted.
-[w2eupan4] The United Kingdom should allow more highly skilled immigrants from other countries to come and live here.
-[w2eupan5] The United Kingdom should allow more low-skilled immigrants from other countries to come and live here.
-[w2eupan6] Most crimes in Britain are committed by immigrants.
-[w2eupan7] Immigration in recent years has helped Britain’s economy grow faster than it would have done.
-[w2eupan8] The Government should encourage immigrants and their families to leave the United Kingdom (including family members who were born in the UK).
-[w2eupan9] Local councils normally allow immigrant families to jump the queue in allocating council homes.
-[w2eupan10] Non-white British citizens who were born in this country are just as ‘British’ as white citizens born in this country.

   */
 
  *Wave 2
  foreach var of varlist w2eupan1 w2eupan3 w2eupan6 w2eupan8 w2eupan9 {
   gen new`var'=`var'
   recode new`var' (1=5) (2=4) (3=3) (4=2) (5=1) (6=3)
   }
   
  foreach var of varlist w2eupan2 w2eupan4 w2eupan5 w2eupan7 w2eupan10  {
   gen new`var'=`var'
   recode new`var' (6=3)
   }

alpha neww2eupan1-neww2eupan10, item gen(nativismscale)

gen agescaled=age
replace agescaled=agescaled-18
replace agescaled=agescaled/75 
 
 
 gen female=(gender==2)

 
/* Populism measures */
*-[w2efftrst14] Those we elect to public office usually try to keep the promises they made during the election.
*-[w2efftrst15] Most public officials can be trusted to do what is right without our having to constantly check on them.
*-[w2efftrst16] You can generally trust the people who run our government to do what is right.
*-[w2efftrst18]


foreach var of varlist w2efftrst18   {
gen new`var'=`var'
recode new`var' (1=5) (2=4) (3=3) (4=2) (5=1) (6=3)
}

foreach var of varlist w2efftrst14 w2efftrst15 w2efftrst16  {
gen new`var'=`var'
recode new`var' (6=3)
}


* Higher values indicate greater populism (anti-elite sentiment)
alpha neww2efftrst14 neww2efftrst15 neww2efftrst16 neww2efftrst18, item gen(antielite)

replace antielite=antielite/4 if antielite!=.
xtile antielite_median=antielite if antielite!=., nquantiles(2)
replace antielite_median=antielite_median-1
tab antielite_median, generate(antieliteM)

xtile antielite_tercile=antielite if antielite!=., nquantiles(3)
tab antielite_tercile, generate(antieliteT)


/* Internal efficacy */

* w2efftrst1 I feel that I could do as good of a job in public office as most other people. (PUBOFF)
* w2efftrst2 I think I am as well-informed about politics and government as most people. (INFORM)
* w2efftrst3 I don't often feel sure of myself when talking with other people about politics and government. (NOTSURE)
* w2efftrst4 I feel that I have a pretty good understanding of the important political issues facing our country. (UNDERSTAND)
* w2efftrst5 I consider myself well-qualified to participate in politics. (SELFQUAL)
* w2efftrst6 Sometimes politics and government seem so complicated that a person like me can't really understand what's going on. (COMPLEX)

foreach var of varlist w2efftrst1 w2efftrst2 w2efftrst4 w2efftrst5 {
gen new`var'=`var'
recode new`var' (1=5) (2=4) (3=3) (4=2) (5=1) (6=3)
}

foreach var of varlist w2efftrst3 w2efftrst6 {
gen new`var'=`var'
recode new`var' (6=3)
}


alpha neww2efftrst1 neww2efftrst2 neww2efftrst3 neww2efftrst4 neww2efftrst5 neww2efftrst6, item gen(internal) /* Higher values indicate higher internal efficacy */



/* Authoritarianism */

*Please say whether you agree or disagree with each of the following statements:
*-[w1rwa11] Obedience and respect for authority are the most important virtues children should learn.
*-[w1rwa21] Our customs and national heritage are the things that have made us great, and certain people should be made to show greater respect for them.
*-[w1rwa31] Parents and other authorities have forgotten that good old-fashioned physical punishment is still one of the best ways to make people behave properly.

foreach var of varlist w1rwa11 w1rwa21 w1rwa31 {
gen new`var'=`var'
recode new`var' (1=5) (2=4) (3=3) (4=2) (5=1) (6=3)
}

alpha neww1rwa11 neww1rwa21 neww1rwa31, item gen(authoritarianism)
xtile authmed=authoritarianism if authoritarianism!=., nquantiles(2)
replace authmed=authmed-1
replace authoritarianism=authoritarianism-1 if authoritarianism!=.
replace authoritarianism=authoritarianism/4 if authoritarianism!=.

/* Ideology */
gen ideology=w1wing1a
replace ideology=ideology/10


/* University graduate */
gen university=0
replace university=1 if education_level==16
replace university=1 if education_level==17
replace university=1 if education_level==18 


/* Economic sentiment */

*[wXecon1] How do you think the general economic situation in this country has changed over the last 12 months?  Has it: 
*<1>  Got a lot better 
*<2>  Got a little better 
*<3>  Stayed the same 
*<4>  Got a little worse 
*<5>  Got a lot worse 
*<6>  Don't Know 

*[wXecon2] How does the financial situation of your household now compare with what it was 12 months ago? Has it: 
*<1>  Got a lot better 
*<2>  Got a little better 
*<3>  Stayed the same 
*<4>  Got a little worse 
*<5>  Got a lot worse 
*<6>  Don't Know 

*[wXeconp1] How do you think the financial situation of your household will change over the next 12 months?  Will it: 
*<1>  Get a lot worse 
*<2>  Get a little worse 
*<3>  Stay the same 
*<4>  Get a little better 
*<5>  Get a lot better 
*<6>  Don't know 

*[wXeconp2] How do you think the general economic situation in this country will develop over the next 12 months?  Will it: 
*<1>  Get a lot worse 
*<2>  Get a little worse 
*<3>  Stay the same 
*<4>  Get a little better 
*<5>  Get a lot better 
*<6>  Don't know 


foreach var of varlist w5econ1 w6econ1 w10econ1 w5econ2 w6econ2 w10econ2 {
gen new`var'=`var'
recode new`var' (1=5) (2=4) (3=3) (4=2) (5=1) (6=3)
}
foreach var of varlist w5econp1 w5econp2 w6econp1 w6econp2 w10econp1 w10econp2 {
gen new`var'=`var'
recode new`var' (6=3)
}

alpha neww5econ1 neww5econ2 neww5econp1 neww5econp2, item gen(econsentimentw5)
alpha neww6econ1 neww6econ2 neww6econp1 neww6econp2, item gen(econsentimentw6)
alpha neww10econ1 neww10econ2 neww10econp1 neww10econp2, item gen(econsentimentw10)

replace econsentimentw5=econsentimentw5-1
replace econsentimentw5=econsentimentw5/4

replace econsentimentw6=econsentimentw6-1
replace econsentimentw6=econsentimentw6/4

replace econsentimentw10=econsentimentw10-1
replace econsentimentw10=econsentimentw10/4


/* Partisanship (wave2) */

*[w2UKparty1 if splitUK1 ==1] Generally speaking, do you think of yourself as Conservative, Labour, Liberal Democrat or what?
*<1>  Conservative 
*<2>  Labour 
*<3>  Liberal Democrat 
*<4>  Plaid Cymru 
*<5>  Scottish National Party (SNP)
*<6>  Green 
*<7>  United Kingdom Independence Party (UKIP) 
*<8>  British National Party (BNP)
*<9>  Other party 
*<10>  No-none  
*<11>  Don't know

*[w2UKparty2 if splitUK1 ==2] Generally speaking, do you think of yourself as Labour, Liberal Democrat, Conservative or what?
*<1>  Labour
*<2>  Liberal Democrat
*<3>  Conservative
*<4>  Plaid Cymru 
*<5>  Scottish National Party (SNP)
*<6>  Green
*<7>  United Kingdom Independence Party (UKIP) 
*<8>  British National Party (BNP) 
*<9>  Other party 
*<10>  No-none 
*<11>  Don't know

*[w2UKparty3 if splitUK1 ==3] Generally speaking, do you think of yourself as Liberal Democrat, Conservative, Labour or what?
*<1>  Liberal Democrat
*<2>  Conservative
*<3>  Labour
*<4>  Plaid Cymru 
*<5>  Scottish National Party (SNP)
*<6>  Green
*<7>  United Kingdom Independence Party (UKIP) 
*<8>  British National Party (BNP) 
*<9>  Other party 
*<10>  No-none 
*<11>  Don't know


*Conservative
gen w2tory=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2tory (0=1) if w2UKparty1==1 | w2UKparty2==3 | w2UKparty3==2

*Lib Dem
gen w2libdem=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2libdem (0=1) if w2UKparty1==3 | w2UKparty2==2 | w2UKparty3==1

*Labour
gen w2labour=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2labour (0=1) if w2UKparty1==2 | w2UKparty2==1 | w2UKparty3==3

*UKIP
gen w2ukip=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2ukip 0=1 if w2UKparty1==7 | w2UKparty2==7 | w2UKparty3==7

*BNP
gen w2bnp=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2bnp 0=1 if  w2UKparty1==8 | w2UKparty2==8 | w2UKparty3==8

*SNP
gen w2snp=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2snp (0=1) if w2UKparty1==4 | w2UKparty2==4 | w2UKparty3==4 

*Plaid Cymru
gen w2plaid=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2plaid (0=1) if w2UKparty1==5 | w2UKparty2==5 | w2UKparty3==5 

*Green
gen w2green=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2green (0=1) if w2UKparty1==6 | w2UKparty2==6 | w2UKparty3==6


*Other
gen w2other=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2other (0=1) if w2UKparty1==9 | w2UKparty2==9 | w2UKparty3==9

*None/DK
gen w2noneDK=0 if w2UKparty1!=. | w2UKparty2!=. | w2UKparty3!=.
recode w2noneDK (0=1) if w2UKparty1==10 | w2UKparty2==10 | w2UKparty3==10 
recode w2noneDK (0=1) if w2UKparty1==11 | w2UKparty2==11 | w2UKparty3==11

gen w2noneDKother=w2noneDK
replace w2noneDKother=1 if w2other==1


/* British identity */

*[w2natid1] How important is being British to you?
*<1> Not important at all
*<2> Very unimportant
*<3> Neither unimportant nor important
*<4> Very important
*<5> Extremely important
*<6> Don’t know

*[w2natid2] How well does the term British describe you?
*<1> Not at all
*<2> Not very well
*<3> Very well
*<4> Extremely well
*<5> Don’t know

*[w2natid3] When talking about Britons, how often do you say “we” instead of “they”?
*<1> Never
*<2> Rarely
*<3> Sometimes
*<4> Quite Often
*<5> Always
*<6> Don’t know

*[w2natid4] For me, to possess British citizenship is:
*<1> Not important at all
*<2> Very unimportant
*<3> Neither unimportant nor important
*<4> Very important
*<5> Extremely important
*<6> Don’t know

recode w2natid1 (6=3), gen(neww2natid1)
recode w2natid2 (3=4) (4=5) (5=3), gen(neww2natid2)
recode w2natid3 (6=.), gen(neww2natid3)
recode w2natid4 (6=3), gen(neww2natid4)

factor neww2natid1 neww2natid2 neww2natid3 neww2natid4
alpha neww2natid1 neww2natid2 neww2natid3 neww2natid4, item 
/*Drop natid3 -- requires dropping obsvervations [because of uncertainty how to recode DK responnses to underlying scale] without doing very much to improve model fit */
alpha neww2natid1 neww2natid2 neww2natid4, item gen(brit_identw2)
replace brit_identw2=brit_identw2-1
replace brit_identw2=brit_identw2/4

/* Support for redistributive/egalitarian policies */
gen redistribution=w1EQUAL-1
replace redistribution=redistribution/6



/* General globalization views */
*-[w2trdegl8] You and your immediate family
*-[w2trdegl9] The British economy
*-[w2trdegl5] British factory workers
*-[w2trdegl7] Multinational corporations based in the United Kingdom*/

	*<1> Negative effect
	*<2> No effect
	*<3> Positive effect
	*<4> Don’t know
 
foreach var of varlist w2trdegl5 w2trdegl7 w2trdegl8 w2trdegl9 {
  gen new`var'=`var'
  recode new`var' (1=2) (2=1) (3=0) (4=1)
  } 

factor neww2trdegl5 neww2trdegl7 neww2trdegl8 neww2trdegl9
alpha neww2trdegl5 neww2trdegl7 neww2trdegl8 neww2trdegl9, item gen(losers) /*Extremely important editorial note: This is not a prerjorative variable name -- rather, this reflects perceptions of who loses through globaization */
replace losers=losers/2
 
 /* Region */
gen london=(government_region==7)
gen wales=(government_region==10)
gen scotland=(government_region==11)


/* Rescale 0-1 (if not done above) */
gen nativism=nativism-1 if nativism!=.
replace nativism=nativism/4 if nativism!=.
xtile nativism_median=nativism if nativism!=., nquantiles(2)
replace nativism_median=nativism_median-1


/* Interactions */ 
gen nativismXantielite=nativism*antielite
gen nativism_medianXantielite_median=nativism_median*antielite_median
gen nativism_medianXantielite_tercil=nativism_median*antielite_tercile


gen lowNATIVISMlowANTIELITE=1 if nativism_median==0 & antielite_median==0 
replace lowNATIVISMlowANTIELITE=0 if nativism_median==1 | antielite_median==1
replace lowNATIVISMlowANTIELITE=. if nativism_median==. | antielite_median==.

gen highNATIVISMlowANTIELITE=1 if nativism_median==1 & antielite_median==0 
replace highNATIVISMlowANTIELITE=0 if nativism_median==0 | antielite_median==1
replace highNATIVISMlowANTIELITE=. if nativism_median==. | antielite_median==.

gen lowNATIVISMhighANTIELITE=1 if nativism_median==0 & antielite_median==1 
replace lowNATIVISMhighANTIELITE=0 if nativism_median==1 | antielite_median==0
replace lowNATIVISMhighANTIELITE=. if nativism_median==. | antielite_median==.

gen highNATIVISMhighANTIELITE=1 if nativism_median==1 & antielite_median==1 
replace highNATIVISMhighANTIELITE=0 if nativism_median==0 | antielite_median==0
replace highNATIVISMhighANTIELITE=. if nativism_median==. | antielite_median==.


label define nativist 0 "Low nativism" 1 "High nativism"
label values nativism_median nativist


label define antielite 0 "Low anti-elite" 1 "High anti-elite"
label values antielite_median antielite


label define auth 0 "Low authoritarianism" 1 "High authoritarianism"
label values authmed auth


/* Anti-capitalist atttiudes (Are anti-capitalist attitudes driving Brexit)? */
  *[w7cgreed]Corporate greed is a major problem in Britain
  *[w7banks]British banks are making excessive profits at the expense of ordinary people

foreach var of varlist w7cgreed w7banks{
gen new`var'=`var'
recode new`var' (1=5) (2=4) (3=3) (4=2) (5=1) (6=3)
}

* higher values indicate strong agreement= strong anti-capitalist attitudes


alpha neww7cgreed neww7banks, item gen(anticap)
*factor neww7cgreed neww7banks, pcf

gen anticapital=anticap-1 if anticap!=.
replace anticapital=anticapital/4 if anticapital!=.
xtile anticapitalmedian=anticapital if anticapital!=., nquantiles(2)
tab anticapitalmedian, generate(antiC)
replace anticapitalmedian=anticapitalmedian-1

gen lowANTICAPlowANTIELITE=1 if anticapitalmedian==0 & antielite_median==0 
replace lowANTICAPlowANTIELITE=0 if anticapitalmedian==1 | antielite_median==1
replace lowANTICAPlowANTIELITE=. if anticapitalmedian==. | antielite_median==.

gen highANTICAPlowANTIELITE=1 if anticapitalmedian==1 & antielite_median==0 
replace highANTICAPlowANTIELITE=0 if anticapitalmedian==0 | antielite_median==1
replace highANTICAPlowANTIELITE=. if anticapitalmedian==. | antielite_median==.

gen lowANTICAPhighANTIELITE=1 if anticapitalmedian==0 & antielite_median==1 
replace lowANTICAPhighANTIELITE=0 if anticapitalmedian==1 | antielite_median==0
replace lowANTICAPhighANTIELITE=. if anticapitalmedian==. | antielite_median==.

gen highANTICAPhighANTIELITE=1 if anticapitalmedian==1 & antielite_median==1 
replace highANTICAPhighANTIELITE=0 if anticapitalmedian==0 | antielite_median==0
replace highANTICAPhighANTIELITE=. if anticapitalmedian==. | antielite_median==.

label define anticc 0 "Low anti-capitalist" 1 "High anti-capitalist"
label values anticapitalmedian anticc


/* Final models*/

*Table 1
svyset [pweight=W8wave5]
svy: tab w5EUref1

svyset [pweight=W8wave6]
svy: tab w6EUref1

svyset [pweight=W8wave7]
svy: tab w7EUref1

svyset [pweight=Weight_wave10]
svy: tab w10EUref1

oprobit brexit5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE [pweight=W8wave5]
estimates store brexit5simple
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave5]
estimates store brexit5full
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE [pweight=W8wave6]
estimates store brexit6simple
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave6]
estimates store brexit6full
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE [pweight=W8wave7]
estimates store brexit7simple
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave7]
estimates store brexit7full
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE [pweight= Weight_wave10]
estimates store brexit10simple
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
estimates store brexit10full
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

svyset [pweight=Weight_wave10]
svy: oprobit brexit10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland 



/*Final models */
esttab brexit5simple brexit5full brexit6simple brexit6full brexit7simple brexit7full brexit10simple brexit10full using finalmodels.csv, se b(2) se(2) stats(N r2_p , fmt(0 2)) replace
esttab brexit5simple brexit5full brexit6simple brexit6full brexit7simple brexit7full brexit10simple brexit10full using finalmodels.tex, se b(2) se(2) stats(N r2_p , fmt(0 2)) replace


margins, at(lowNATIVISMhighANTIELITE=0 highNATIVISMlowANTIELITE=0 highNATIVISMhighANTIELITE=0) atmeans predict(outcome(3))
matrix LNLAE=r(b)

margins, at(lowNATIVISMhighANTIELITE=1 highNATIVISMlowANTIELITE=0 highNATIVISMhighANTIELITE=0) atmeans predict(outcome(3))
matrix LNHAE=r(b)

margins, at(lowNATIVISMhighANTIELITE=0 highNATIVISMlowANTIELITE=1 highNATIVISMhighANTIELITE=0) atmeans predict(outcome(3))
matrix HNLAE=r(b)

margins, at(lowNATIVISMhighANTIELITE=0 highNATIVISMlowANTIELITE=0 highNATIVISMhighANTIELITE=1) atmeans predict(outcome(3))
matrix HNHAE=r(b)

matrix predictedprobs = LNLAE \ LNHAE \ HNLAE \HNHAE
svmat predictedprobs

gen graph_nativist=0 if _n==1 | _n==2
replace graph_nativist=1 if _n==3 | _n==4

gen graph_antielite=0 if _n==1 | _n==3
replace graph_antielite=1 if _n==2 | _n==4

label values graph_nativist nativist
label values graph_antielite antielite


graph bar predictedprobs, over(graph_antielite) over(graph_nativist) blabel(bar, format(%9.2f)) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%",nogrid labsize(*.9) angle(0)) ymtick(.1(.2).5) ytitle("Predicted probability") title("Vote for UK to leave EU (Brexit)",size(*.8)) ytitle("") subtitle("Wave 8 (April 2015)",size(*.8))
graph export "Brexit(wave8).pdf", replace



* Nativism (Median) by anti-elite (tercile)
gen MedianNxTercileAE=0 if nativism_median==0 & antielite_tercile==1
replace MedianNxTercileAE=1 if nativism_median==0 & antielite_tercile==2
replace MedianNxTercileAE=2 if nativism_median==0 & antielite_tercile==3
replace MedianNxTercileAE=3 if nativism_median==1 & antielite_tercile==1
replace MedianNxTercileAE=4 if nativism_median==1 & antielite_tercile==2
replace MedianNxTercileAE=5 if nativism_median==1 & antielite_tercile==3

label define MedianNxTercileAE 0 "Low nativism/Low anti-elite" 1 "Low nativism/Mid anti-elite" 2 "Low nativism/High anti-elite" 3 "High nativism/Low anti-elite" 4 "High nativism/Mid anti-elite" 5 "Low nativism/Mid anti-elite"
label values MedianNxTercileAE MedianNxTercileAE

tab MedianNxTercileAE, generate(NativismMedianAntiEliteTercile)


oprobit brexit10 i.MedianNxTercileAE authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
est store effectAE1

margins MedianNxTercileAE, atmeans predict(outcome(3)) 
matrix NATmedianAEtercile=r(b)'
svmat NATmedianAEtercile

/* Nativism (Low group, median split) */
gen medianNtercileAE_nativism_graph=0 if _n==1 | _n==2 | _n==3
/* Nativism (high group, median split) */
replace medianNtercileAE_nativism_graph=1 if _n==4 | _n==5 | _n==6

*label define nativist2 0 "Low nativism" 1 "High nativism"
label values medianNtercileAE_nativism_graph nativist

gen medianNtercileAE_antielite_graph=0 if _n==1 | _n==4
replace medianNtercileAE_antielite_graph=1 if _n==2 | _n==5
replace medianNtercileAE_antielite_graph=2 if _n==3 | _n==6

label values medianNtercileAE_antielite_graph antielite_tercile

graph bar NATmedianAEtercile, over(medianNtercileAE_antielite_graph) over(medianNtercileAE_nativism_graph)  blabel(bar, format(%9.2f)) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%",nogrid labsize(*.9) angle(0)) ymtick(.1(.2).5) ytitle("Predicted probability") title("Vote for UK to leave EU (Brexit)",size(*.8)) ytitle("") subtitle("Wave 8 (April 2015)",size(*.8))
graph export "median-by-tercile2.pdf", replace

oprobit brexit10 nativism_median antielite_tercile nativism_medianXantielite_tercil authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
est store effectAE2

esttab effectAE1 effectAE2 using "AElinear.csv", se b(2) se(2) stats(N r2_p , fmt(0 2)) replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
esttab effectAE1 effectAE2 using "AElinear.tex", se b(2) se(2) stats(N r2_p , fmt(0 2)) replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

*This graph has been slightly edited (text size change) in Stata as is saved as "AppendixFig1.pdf"


*Explaining interactions

*In earlier waves, interaction is significant for full scale (or close);

oprobit brexit5 nativism antielite  authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave5]
est store w5nointeraction
oprobit brexit6 nativism antielite  authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave6]
est store w6nointeraction
oprobit brexit7 nativism antielite  authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave7]
est store w7nointeraction
oprobit brexit10 nativism antielite authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
est store w10nointeraction

oprobit brexit5 nativism antielite nativismXantielite authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave5]
est store w5fullscaleinteraction
oprobit brexit6 nativism antielite nativismXantielite authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave6]
est store w6fullscaleinteraction
oprobit brexit7 nativism antielite nativismXantielite authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave7]
est store w7fullscaleinteraction
oprobit brexit10 nativism antielite nativismXantielite authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
est store w10fullscaleinteraction
*esttab w5fullscaleinteraction w6fullscaleinteraction w7fullscaleinteraction w10fullscaleinteraction, se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

oprobit brexit5 nativism_median antielite_median nativism_medianXantielite_median authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave5]
est store w5medianXmedian
oprobit brexit6 nativism_median antielite_median nativism_medianXantielite_median authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave6]
est store w6medianXmedian
oprobit brexit7 nativism_median antielite_median nativism_medianXantielite_median authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave7]
est store w7medianXmedian
oprobit brexit10 nativism_median antielite_median nativism_medianXantielite_median authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
est store w10medianXmedian
*esttab w5medianXmedian w6medianXmedian w7medianXmedian w10medianXmedian, se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


oprobit brexit5 nativism_median antielite_tercile nativism_medianXantielite_tercil authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave5]
est store w5medianXtercile
oprobit brexit6 nativism_median antielite_tercile nativism_medianXantielite_tercil  authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave6]
est store w6medianXtercile
oprobit brexit7 nativism_median antielite_tercile nativism_medianXantielite_tercil  authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight=W8wave7]
est store w7medianXtercile
oprobit brexit10 nativism_median antielite_tercile nativism_medianXantielite_tercil  authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
est store w10medianXtercile
*esttab w5medianXtercile w6medianXtercile w7medianXtercile w10medianXtercile, se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001)



***Appendix D
esttab w5nointeraction w6nointeraction w7nointeraction w10nointeraction w5fullscaleinteraction w6fullscaleinteraction w7fullscaleinteraction w10fullscaleinteraction using "interactions1-appendix.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab w5nointeraction w6nointeraction w7nointeraction w10nointeraction w5fullscaleinteraction w6fullscaleinteraction w7fullscaleinteraction w10fullscaleinteraction using "interactions1-appendix.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab w5medianXmedian w6medianXmedian w7medianXmedian w10medianXmedian using "interactions2-appendix.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace /* This should be functionally equivalent to final models */
esttab w5medianXmedian w6medianXmedian w7medianXmedian w10medianXmedian using "interactions2-appendix.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace /* This should be functionally equivalent to final models */
esttab w5nointeraction w6nointeraction w7nointeraction w10nointeraction w5fullscaleinteraction w6fullscaleinteraction w7fullscaleinteraction w10fullscaleinteraction w5medianXmedian w6medianXmedian w7medianXmedian w10medianXmedian using "interactions3-appendix.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab w5nointeraction w6nointeraction w7nointeraction w10nointeraction w5fullscaleinteraction w6fullscaleinteraction w7fullscaleinteraction w10fullscaleinteraction w5medianXmedian w6medianXmedian w7medianXmedian w10medianXmedian using "interactions3-appendix.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace


*Appendix G: Anti-capitalism

oprobit brexit7 lowANTICAPhighANTIELITE highANTICAPlowANTIELITE highANTICAPhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland [pweight= W8wave7]
estimates store anticap7

oprobit brexit10 lowANTICAPhighANTIELITE highANTICAPlowANTIELITE highANTICAPhighANTIELITE authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland [pweight= Weight_wave10]
estimates store anticap10
esttab anticap7 anticap10 using "anticap.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab anticap7 anticap10 using "anticap.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace

margins, at(lowANTICAPhighANTIELITE=0 highANTICAPlowANTIELITE=0 highANTICAPhighANTIELITE=0) atmeans predict(outcome(3))
matrix LACLAE=r(b)

margins, at(lowANTICAPhighANTIELITE=1 highANTICAPlowANTIELITE=0 highANTICAPhighANTIELITE=0) atmeans predict(outcome(3))
matrix LACHAE=r(b)

margins, at(lowANTICAPhighANTIELITE=0 highANTICAPlowANTIELITE=1 highANTICAPhighANTIELITE=0) atmeans predict(outcome(3))
matrix HACLAE=r(b)

margins, at(lowANTICAPhighANTIELITE=0 highANTICAPlowANTIELITE=0 highANTICAPhighANTIELITE=1) atmeans predict(outcome(3))
matrix HACHAE=r(b)

matrix anticappredictedprobs = LACLAE \ LACHAE \ HACLAE \HACHAE
svmat anticappredictedprobs

gen graph_anticap=0 if _n==1 | _n==2
replace graph_anticap=1 if _n==3 | _n==4

label values graph_anticap anticc

graph bar anticappredictedprobs, over(graph_antielite) over(graph_anticap) blabel(bar, format(%9.2f)) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%" 1 "100%",nogrid labsize(*.9) angle(0)) ymtick(.1(.2).5) ytitle("Predicted probability") title("Vote for UK to leave EU (Brexit)",size(*.8)) ytitle("") subtitle("Wave 8 (April 2015)",size(*.8))
graph export "Anticap-Brexit(wave8).pdf", replace


***Mlogits and recoded DVs

mlogit brexit5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave5], base(3)
estimates store mbr5
mlogit brexit6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave6], base(3)
estimates store mbr6
mlogit brexit7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave7], base(3)
estimates store mbr7
mlogit brexit10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc female london scotland [pweight= Weight_wave10], base(3)
estimates store mbr10

esttab mbr5 mbr6 mbr7 mbr10, se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) 
esttab mbr5 mbr6 mbr7 mbr10 using "mlogit.csv" , se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab mbr5 mbr6 mbr7 mbr10 using "mlogit.tex" , se star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace




/* Eliminating/recoding don't knows */

gen altdv1w5=.
replace altdv1w5=0 if brexit5==1
replace altdv1w5=1 if brexit5==3

gen altdv1w6=.
replace altdv1w6=0 if brexit6==1
replace altdv1w6=1 if brexit6==3

gen altdv1w7=.
replace altdv1w7=0 if brexit7==1
replace altdv1w7=1 if brexit7==3

gen altdv1w10=.
replace altdv1w10=0 if brexit10==1
replace altdv1w10=1 if brexit10==3

probit altdv1w5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave5]
est store altdv1w5
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv1w6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave6]
est store altdv1w6
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE
probit altdv1w7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave7]
est store altdv1w7
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE
probit altdv1w10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc female london scotland [pweight=Weight_wave10]
est store altdv1w10
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

/* Assigning don't knows to remain */
gen altdv2w5=.
replace altdv2w5=0 if brexit5==1
replace altdv2w5=0 if brexit5==2
replace altdv2w5=1 if brexit5==3

gen altdv2w6=.
replace altdv2w6=0 if brexit6==1
replace altdv2w6=0 if brexit6==2
replace altdv2w6=1 if brexit6==3

gen altdv2w7=.
replace altdv2w7=0 if brexit7==1
replace altdv2w7=0 if brexit7==2
replace altdv2w7=1 if brexit7==3

gen altdv2w10=.
replace altdv2w10=0 if brexit10==1
replace altdv2w10=0 if brexit10==2
replace altdv2w10=1 if brexit10==3

probit altdv2w5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave5]
est store altdv2w5
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv2w6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave6]
est store altdv2w6
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv2w7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave7]
est store altdv2w7
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv2w10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= Weight_wave10]
est store altdv2w10
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

/* Assigning don't knows to leave */
gen altdv3w5=.
replace altdv3w5=0 if brexit5==1
replace altdv3w5=1 if brexit5==2
replace altdv3w5=1 if brexit5==3

gen altdv3w6=.
replace altdv3w6=0 if brexit6==1
replace altdv3w6=1 if brexit6==2
replace altdv3w6=1 if brexit6==3

gen altdv3w7=.
replace altdv3w7=0 if brexit7==1
replace altdv3w7=1 if brexit7==2
replace altdv3w7=1 if brexit7==3

gen altdv3w10=.
replace altdv3w10=0 if brexit10==1
replace altdv3w10=1 if brexit10==2
replace altdv3w10=1 if brexit10==3

probit altdv3w5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave5]
est store altdv3w5
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv3w6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave6]
est store altdv3w6
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv3w7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= W8wave7]
est store altdv3w7
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

probit altdv3w10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc female london scotland [pweight= Weight_wave10]
est store altdv3w10
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE



esttab altdv1w5 altdv1w6 altdv1w7 altdv1w10 using "DKs-excluded.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab altdv2w5 altdv2w6 altdv2w7 altdv2w10 using "DKs-assgined-to-remain.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab altdv3w5 altdv3w6 altdv3w7 altdv3w10 using "DKs-assgined-to-leave.csv", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace


esttab altdv1w5 altdv1w6 altdv1w7 altdv1w10 using "DKs-excluded.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab altdv2w5 altdv2w6 altdv2w7 altdv2w10 using "DKs-assgined-to-remain.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
esttab altdv3w5 altdv3w6 altdv3w7 altdv3w10 using "DKs-assgined-to-leave.tex", se  star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace



***Party identification to models
oprobit brexit5 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw5 losers brit_identw2 redistribution agesc  female london scotland w2bnp w2tory w2noneDKother w2labour w2libdem w2snp w2plaid w2green [pweight=W8wave5]
estimates store brexit5full_pid
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit6 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland w2bnp w2tory w2noneDKother w2labour w2libdem w2snp w2plaid w2green [pweight=W8wave6]
estimates store brexit6full_pid
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit7 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw6 losers brit_identw2 redistribution agesc  female london scotland w2bnp w2tory w2noneDKother w2labour w2libdem w2snp w2plaid w2green [pweight=W8wave7]
estimates store brexit7full_pid
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE

oprobit brexit10 lowNATIVISMhighANTIELITE highNATIVISMlowANTIELITE highNATIVISMhighANTIELITE authoritarianism ideology uni internal econsentimentw10 losers brit_identw2 redistribution agesc  female london scotland w2bnp w2tory w2noneDKother w2labour w2libdem w2snp w2plaid w2green [pweight= Weight_wave10]
estimates store brexit10full_pid
lincom highNATIVISMlowANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-lowNATIVISMhighANTIELITE
lincom highNATIVISMhighANTIELITE-highNATIVISMlowANTIELITE


