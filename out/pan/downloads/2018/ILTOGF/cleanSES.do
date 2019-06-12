timer clear
timer on 1
cd "/Users/coadywing/Dropbox/Censored LATE/dataset_600"
*cd "C:\Users\cwing\Dropbox\Censored LATE\dataset_600\"
use 600.dta, clear 

********************************************************************************
*Make a simple "any participation" variable
*Completed = 0 Incomplete, Completed = 1 Complete, Completed = 2 Not Started

tab complete
gen anyresponse = complete < 2
********************************************************************************
*Clean Sampling Frame Covariates
gen male = sex == 1

*Put the 17 year olds in the 18 to 24 bin.
replace agegroup = 1 if agegroup==. & age==17

tab agegroups, gen(a)
rename (a1 a2 a3 a4 a5 a6 a7) ///
(age1824 age2534 age3544 age4554 age5564 age6574 age75p)

tab lang, gen(l)
rename (l1 l2 l3)(german french italian)

*Not born in Switzerland. (Note I assume that the 4 people coded as -9 are Swiss Born)
gen foreignBorn = 0
replace foreignBorn = 1 if birthcntry~=8100
replace foreignBorn = 0 if birthcntry==-9

tab Canton, gen(c)
rename ///
(c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26) ///
(zurich bern luzern uri schwyz obwalden nidwalden glarus zug fribourg solothurn basel_stadt ///
basel_landschaft schaffhausen app_ausserrhoden app_innerrhoden stgallen graubunden aargau ///
thrugau ticino vaud valais neuchutel geneve jura)

tab UrbRur, gen(u)
rename (u1 u2 u3 u4)(centCityAgg othMunicAgg isolatedTown ruralMunic)

tab GrossReg, gen(g)
rename (g1 g2 g3 g4 g5 g6 g7) ///
(gr_reg_lemanique gr_espace_mittelland gr_northwest gr_zurich gr_ostschweiz gr_zentralschweiz gr_ticino)

tab ogr, gen(s)
rename (s1 s2 s3 s4 s5 s6 s7 s8) ///
(popGT100k pop50_lt100 pop20_lt50 pop10_lt20 pop5_lt10 pop2_lt5 pop1_lt2 poplt1k)

********************************************************************************
*Clean Outcomes

*Rather Interested or Very Interested in Politics
gen interestPolitics = 0 if f10100 <=4
replace interestPolitics = 1 if f10100 <=2

*Certainly participated in 2007 election.
gen certVote07 = 0 if f10200 >=2 & f10200 <=5
replace certVote07 = 1 if f10200 == 1

*Voted in 2011 election
gen certVote11 = f11100_d

*Fairly Satisfied or Very Satisfied with democratic process
gen satisfiedDemo = 1 if f13700<=2
replace satisfiedDemo = 0 if f13700 ==3 | f13700 ==4

*State of the Economy is Very Good or Good
gen goodEconomy = 0 if f14600<=5
replace goodEconomy = 1 if f14600<=2

*Rather Agree or Totally Agree that Migrants Exacerbate Job Market Situation.
gen immigStealJobs = 0 if f14806<=5
replace immigStealJobs = 1 if f14806<=2

*Rather Agree or Totally Agree that Swiss Culture is Vanising Due to Immigration
gen immigDestroyCulture = 0 if f14807<=5
replace immigDestroyCulture = 1 if f14807<=2

*Rather Agree or Totally Agree that Violence and Vandalism Due To Young Immigrants
gen immigCrime = 0 if f14808<=5
replace immigCrime = 1 if f14808<=2

*Left-Right Placement--Self. 0 = Left Most and 10 = Right Most.
gen selfLeftRight = f15200

*Opinion on taxes on high incomes: Rather for the Increase or Strongly For the Increase
gen favorHighIncomeTax = 0 if f15480 <=5
replace favorHighIncomeTax = 1 if f15480<=2

*Most Important Political Aim: Maintain Order in the Country, Give People More Influence in Government, Fight Rising Prices, Guarantee Freedom of Speech.
tab f15700, gen(p)
rename (p1 p2 p3 p4) ///
(priority_maintOrder priority_influence priority_costLive priority_freespeech)

********************************************************************************
save clean_sesExperiment.dta, replace
timer off 1
timer list 1

