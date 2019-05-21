***Replication file for "Could global democracy satisfy diverse policy values? An empirical analysis" 

	**Uses WVS Data

***STEPS

**   1 Generate variables
**	 2 Produce excel sheets to calculate heterogeneity and polarization
**   3 Calculate Gamma (crosscuttingness) for each country and the world
**   4 Calculate divergence for each country and the world 
**   5 Calculate Inequality of divergence 

**Before begining merge population data by country

** 1 Generate variables 

	**Gen F121

gen f121=.

	**populate f121 with F121

replace f121 =1 if F121==1 | F121==2
replace f121 =2 if F121==3 | F121==4
replace f121 =3 if F121==5 | F121==6
replace f121 =4 if F121==7 | F121==8
replace f121 =5 if F121==9 | F121==10

label variable f121 "F121. Divorce ok? 1=never; 10=always"

replace f121=. if S002!=5

	**Gen F118

gen f118=.

	**populate f118 with F118

replace f118 =1 if F118==1 | F118==2
replace f118 =2 if F118==3 | F118==4
replace f118 =3 if F118==5 | F118==6
replace f118 =4 if F118==7 | F118==8
replace f118 =5 if F118==9 | F118==10

label variable f118 "F118. Homosexuality ok? 1=never; 10=always"

replace f118=. if S002!=5

	**Gen F105

gen f105=.

	**populate f105 with F105

replace f105 =1 if F105==5
replace f105 =2 if F105==4
replace f105 =3 if F105==3
replace f105 =4 if F105==2
replace f105 =5 if F105==1

label variable f105 "F105 INV. 1=disagree; 5=agree religious leaders not influence gov"

replace f105=. if S002!=5

	**Gen F102

gen f102=.

	**populate f102 with F102

replace f102 =1 if F102==1
replace f102 =2 if F102==2
replace f102 =3 if F102==3
replace f102 =4 if F102==4
replace f102 =5 if F102==5

label variable f102 "F102. 1=agree; 5=disagree aethist politicians unfit"

replace f102=. if S002!=5

	**Gen average traditionalism score

gen traditional=(f102+f105+f118+f121)/4
gen traditional1 = round(traditional)

	**Gen e037

gen e037=.

	**populate e037 with E037

replace e037 =1 if E037==10
replace e037 =2 if E037==9
replace e037 =3 if E037==8
replace e037 =4 if E037==7
replace e037 =5 if E037==6
replace e037 =6 if E037==5
replace e037 =7 if E037==4
replace e037 =8 if E037==3
replace e037 =9 if E037==2
replace e037 =10 if E037==1

label variable e037 "E037 INV. 1=gov resp; 10=people resp"

replace e037=. if S002!=5

	**Gen e036

gen e036=.

	**populate e036 with E036

replace e036 =1 if E036==10
replace e036 =2 if E036==9
replace e036 =3 if E036==8
replace e036 =4 if E036==7
replace e036 =5 if E036==6
replace e036 =6 if E036==5
replace e036 =7 if E036==4
replace e036 =8 if E036==3
replace e036 =9 if E036==2
replace e036 =10 if E036==1

label variable e036 "E036. INV 1=gov own 10=priv own"

replace e036=. if S002!=5

	**Gen e035

gen e035=.

	**populate e035 with E035

replace e035 =1 if E035==1
replace e035 =2 if E035==2
replace e035 =3 if E035==3
replace e035 =4 if E035==4
replace e035 =5 if E035==5
replace e035 =6 if E035==6
replace e035 =7 if E035==7
replace e035 =8 if E035==8
replace e035 =9 if E035==9
replace e035 =10 if E035==10

label variable e035 "E035. 1=income equal; 10=income inequal"

replace e035=. if S002!=5

	**Gen average economic score

gen economic=(e035+e036+e037)/3

gen economic1 = round(economic)

	**Gen b003

gen b003=.

	**populate b003 with B003

replace b003 =1 if B003==4
replace b003 =2 if B003==3
replace b003 =3 if B003==2
replace b003 =4 if B003==1

label variable b003 "B003. INV Gov reduce pollution, not cost me 1=no; 4=agree"

replace b003=. if S002!=5

	**Gen b002

gen b002=.

	**populate b002 with B002

replace b002 =1 if B002==1
replace b002 =2 if B002==2
replace b002 =3 if B002==3
replace b002 =4 if B002==4

label variable b002 "B002. Agree to higher taxes for env 1=agree; 4=no"

replace b002=. if S002!=5

	**Gen average enviro score

gen enviro=(b002+b003)/2

gen enviro1 = round(enviro)

drop traditional economic enviro

rename traditional1 traditional
rename economic1 economic
rename enviro1 enviro



**	 2 Produce excel sheets to calculate heterogeneity and polarization

	**Traditional

xcontract traditional, saving(traditional.dta) by(S003) nomiss

clear

use "/Users/bsog0016/Desktop/Preferences crosscutting globalgov/WVS/traditional.dta"

drop _freq

reshape wide _percent, i(S003) j(traditional)

export excel using "traditional", firstrow(variables) nolabel replace

	**Economic

xcontract economic, saving(economic.dta) by(S003) nomiss

clear

use "/Users/bsog0016/Desktop/Preferences crosscutting globalgov/WVS/economic.dta"

drop _freq

reshape wide _percent, i(S003) j(economic)


export excel using "economic", firstrow(variables) nolabel replace

	**Enviro
	
xcontract enviro, saving(enviro.dta) by(S003) nomiss

clear

use "/Users/bsog0016/Desktop/Preferences crosscutting globalgov/WVS/enviro.dta"

drop _freq

reshape wide _percent, i(S003) j(enviro)

export excel using "enviro", firstrow(variables) nolabel replace


**   3 Calculate Gamma (crosscuttingness) for each country and the world

	**economic X traditional

tabout traditional economic using traditional_economic.xls if S003==8, stats(gamma) 
tabout traditional economic using traditional_economic.xls if S003==12, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==20, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==31, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==32, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==36, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==50, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==51, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==70, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==76, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==100, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==112, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==124, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==152, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==156, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==158, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==170, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==191, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==196, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==203, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==214, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==222, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==231, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==233, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==246, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==250, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==268, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==276, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==288, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==320, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==344, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==348, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==356, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==360, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==364, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==368, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==376, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==380, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==392, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==400, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==410, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==417, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==428, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==440, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==458, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==466, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==484, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==498, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==504, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==528, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==554, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==566, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==578, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==586, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==604, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==608, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==616, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==630, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==642, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==643, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==646, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==682, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==702, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==703, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==704, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==705, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==710, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==716, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==724, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==752, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==756, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==764, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==780, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==792, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==800, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==804, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==807, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==818, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==826, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==834, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==840, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==854, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==858, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==862, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==891, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==894, stats(gamma) append
tabout traditional economic using traditional_economic.xls if S003==911, stats(gamma) append
tabout traditional economic using traditional_economic.xls, stats(gamma) append 


	**enviro X traditional



tabout traditional enviro using traditional_enviro.xls if S003==8, stats(gamma) 
tabout traditional enviro using traditional_enviro.xls if S003==12, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==20, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==31, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==32, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==36, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==50, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==51, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==70, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==76, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==100, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==112, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==124, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==152, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==156, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==158, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==170, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==191, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==196, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==203, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==214, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==222, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==231, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==233, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==246, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==250, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==268, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==276, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==288, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==320, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==344, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==348, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==356, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==360, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==364, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==368, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==376, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==380, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==392, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==400, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==410, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==417, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==428, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==440, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==458, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==466, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==484, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==498, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==504, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==528, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==554, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==566, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==578, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==586, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==604, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==608, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==616, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==630, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==642, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==643, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==646, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==682, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==702, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==703, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==704, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==705, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==710, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==716, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==724, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==752, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==756, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==764, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==780, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==792, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==800, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==804, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==807, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==818, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==826, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==834, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==840, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==854, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==858, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==862, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==891, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==894, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if S003==911, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls, stats(gamma) append 


	**economic X enviro

tabout economic enviro using economic_enviro.xls if S003==8, stats(gamma) 
tabout economic enviro using economic_enviro.xls if S003==12, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==20, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==31, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==32, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==36, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==50, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==51, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==70, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==76, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==100, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==112, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==124, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==152, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==156, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==158, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==170, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==191, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==196, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==203, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==214, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==222, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==231, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==233, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==246, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==250, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==268, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==276, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==288, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==320, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==344, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==348, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==356, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==360, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==364, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==368, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==376, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==380, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==392, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==400, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==410, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==417, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==428, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==440, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==458, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==466, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==484, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==498, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==504, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==528, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==554, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==566, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==578, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==586, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==604, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==608, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==616, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==630, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==642, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==643, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==646, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==682, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==702, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==703, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==704, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==705, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==710, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==716, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==724, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==752, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==756, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==764, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==780, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==792, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==800, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==804, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==807, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==818, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==826, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==834, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==840, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==854, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==858, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==862, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==891, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==894, stats(gamma) append
tabout economic enviro using economic_enviro.xls if S003==911, stats(gamma) append
tabout economic enviro using economic_enviro.xls, stats(gamma) append 


**   4 Calculate divergence for each country and the world 

	***Look at how far each individual is from median on each issue

	**First generate mean scores for each country and the world 

egen enviro_countrymean=mean(enviro), by(countrycode)
egen enviro_worldmean=mean(enviro)
sum enviro [aw=pop2008]
gen enviro_worldmeanpop=2.80593

egen enviro_countrymedian=median(enviro), by(countrycode)
egen enviro_worldmedian=median(enviro)
univar enviro [aw=pop2008]
gen enviro_worldmedianpop=3


egen econ_countrymean=mean(economic), by(countrycode)
egen econ_worldmean=mean(economic)
sum economic [aw=pop2008]
gen econ_worldmeanpop=5.307831 

egen econ_countrymedian=median(economic), by(countrycode)
egen econ_worldmedian=median(economic)
univar economic [aw=pop2008]
gen econ_worldmedianpop=5

egen traditional_countrymean=mean(traditional), by(countrycode)
egen traditional_worldmean=mean(traditional)
sum traditional [aw=pop2008]
gen traditional_worldmeanpop= 2.837913

egen traditional_countrymedian=median(traditional), by(countrycode)
egen traditional_worldmedian=median(traditional)
univar traditional [aw=pop2008]
gen traditional_worldmedianpop=3

	**Generate individual divergence scores (take the absolute value)

gen enviro_countrydiv1=abs(enviro-enviro_countrymean)
gen enviro_worlddiv1=abs(enviro-enviro_worldmean)
gen enviro_worlddivpop1=abs(enviro-enviro_worldmeanpop)

gen enviro_countrydiv2=abs(enviro-enviro_countrymedian)
gen enviro_worlddiv2=abs(enviro-enviro_worldmedian)
gen enviro_worlddivpop2=abs(enviro-enviro_worldmedianpop)

gen econ_countrydiv1=abs(economic-econ_countrymean)
gen econ_worlddiv1=abs(economic-econ_worldmean)
gen econ_worlddivpop1=abs(economic-econ_worldmeanpop)

gen econ_countrydiv2=abs(economic-econ_countrymedian)
gen econ_worlddiv2=abs(economic-econ_worldmedian)
gen econ_worlddivpop2=abs(economic-econ_worldmedianpop)

gen traditional_countrydiv1=abs(traditional-traditional_countrymean)
gen traditional_worlddiv1=abs(traditional-traditional_worldmean)
gen traditional_worlddivpop1=abs(traditional-traditional_worldmeanpop)

gen traditional_countrydiv2=abs(traditional-traditional_countrymedian)
gen traditional_worlddiv2=abs(traditional-traditional_worldmedian)
gen traditional_worlddivpop2=abs(traditional-traditional_worldmedianpop)

	**Standardize individual divergence scores (rescale so that mean=0; SD=1)

egen Zenviro_countrydiv1=std(enviro_countrydiv1)
egen Zecon_countrydiv1=std(econ_countrydiv1)
egen Ztraditional_countrydiv1 =std(traditional_countrydiv1)

egen Zenviro_countrydiv2=std(enviro_countrydiv2)
egen Zecon_countrydiv2=std(econ_countrydiv2)
egen Ztraditional_countrydiv2 =std(traditional_countrydiv2)


egen Zenviro_worlddiv1=std(enviro_worlddiv1)
egen Zenviro_worlddivpop1=std(enviro_worlddivpop1)
egen Zenviro_worlddiv2=std(enviro_worlddiv2)
egen Zenviro_worlddivpop2=std(enviro_worlddivpop2)


egen Zecon_worlddiv1=std(econ_worlddiv1)
egen Zecon_worlddivpop1=std(econ_worlddivpop1)
egen Zecon_worlddiv2=std(econ_worlddiv2)
egen Zecon_worlddivpop2=std(econ_worlddivpop2)


egen Ztraditional_worlddiv1=std(traditional_worlddiv1)
egen Ztraditional_worlddivpop1=std(traditional_worlddivpop1)
egen Ztraditional_worlddiv2=std(traditional_worlddiv2)
egen Ztraditional_worlddivpop2=std(traditional_worlddivpop2)

	**Aggregate individual divergence scores by mean of absolute values 

gen div_country1=(abs(Zenviro_countrydiv1)+abs(Zecon_countrydiv1)+abs(Ztraditional_countrydiv1))/3
gen div_country2=(abs(Zenviro_countrydiv2)+abs(Zecon_countrydiv2)+abs(Ztraditional_countrydiv2))/3


gen div_world1=(abs(Zenviro_worlddiv1)+abs(Zecon_worlddiv1)+abs(Ztraditional_worlddiv1))/3
gen div_world2=(abs(Zenviro_worlddiv2)+abs(Zecon_worlddiv2)+abs(Ztraditional_worlddiv2))/3

gen div_worldpop1=(abs(Zenviro_worlddivpop1)+abs(Zecon_worlddivpop1)+abs(Ztraditional_worlddivpop1))/3
gen div_worldpop2=(abs(Zenviro_worlddivpop2)+abs(Zecon_worlddivpop2)+abs(Ztraditional_worlddivpop2))/3


	***calculate total divergence in different polities

xcollapse (mean) div_country1, by(S003) saving(WVSdivergence_mean1)
xcollapse (sd) div_country1, by(S003) saving(WVSdivergence_SD1)
sum div_world1 div_worldpop1 [aw=pop2008]

xcollapse (mean) div_country2, by(S003) saving(WVSdivergence_mean2)
xcollapse (sd) div_country2, by(S003) saving(WVSdivergence)
sum div_world2 div_worldpop2 [aw=pop2008]

	**See how much total disastisifaction there is in different polities. World of states v. globe

	**See how disatisfaction is distributed. Are there polities with a high concentration of very disatified groups?


**   5 Calculate Inequality of divergence 

fastgini div_country2 if S003==20
fastgini div_country2 if S003==32
fastgini div_country2 if S003==36
fastgini div_country2 if S003==76
fastgini div_country2 if S003==100
fastgini div_country2 if S003==854
fastgini div_country2 if S003==124
fastgini div_country2 if S003==152
fastgini div_country2 if S003==196
fastgini div_country2 if S003==231
fastgini div_country2 if S003==246
fastgini div_country2 if S003==268
fastgini div_country2 if S003==276
fastgini div_country2 if S003==288
fastgini div_country2 if S003==320
fastgini div_country2 if S003==356
fastgini div_country2 if S003==360
fastgini div_country2 if S003==364
fastgini div_country2 if S003==380
fastgini div_country2 if S003==392
fastgini div_country2 if S003==400
fastgini div_country2 if S003==458
fastgini div_country2 if S003==466
fastgini div_country2 if S003==484
fastgini div_country2 if S003==498
fastgini div_country2 if S003==554
fastgini div_country2 if S003==578
fastgini div_country2 if S003==616
fastgini div_country2 if S003==642
fastgini div_country2 if S003==646
fastgini div_country2 if S003==911
fastgini div_country2 if S003==705
fastgini div_country2 if S003==710
fastgini div_country2 if S003==410
fastgini div_country2 if S003==724
fastgini div_country2 if S003==752
fastgini div_country2 if S003==158
fastgini div_country2 if S003==764
fastgini div_country2 if S003==780
fastgini div_country2 if S003==792
fastgini div_country2 if S003==804
fastgini div_country2 if S003==840
fastgini div_country2 if S003==858
fastgini div_country2 if S003==704
fastgini div_country2 if S003==894


fastgini div_worldpop2 [w=pop2008]
fastgini div_world2
