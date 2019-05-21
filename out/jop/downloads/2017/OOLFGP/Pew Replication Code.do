***Replication file for "Could global democracy satisfy diverse policy values? An empirical analysis" 

	**Uses Pew Data

***STEPS

**   1 Generate variables
**	 2 Produce excel sheets to calculate heterogeneity and polarization
**   3 Calculate Gamma (crosscuttingness) for each country and the world
**   4 Calculate divergence for each country and the world 
**   5 Calculate Inequality of divergence 

**Before begining merge population data by country

** 1 Generate variables 

gen relig=.
replace relig=1 if q24d=="Completely agree"
replace relig=2 if q24d=="Mostly agree"
replace relig=3 if q24d=="Mostly disagree"
replace relig=4 if q24d=="Completely disagree"
label variable relig "Q24c; relgion is personal 1=agree, 4=disagree"

gen nativism=.
replace nativism =1 if q24e =="Completely agree"
replace nativism =2 if q24e =="Mostly agree"
replace nativism =3 if q24e =="Mostly disagree"
replace nativism =4 if q24e =="Completely disagree"
label variable nativism "q24d; protect our way of life 1=agree, 4=disagree"

gen freemarket=.
replace freemarket =1 if q19b=="Completely agree"
replace freemarket =2 if q19b=="Mostly agree"
replace freemarket =3 if q19b=="Mostly disagree"
replace freemarket =4 if q19b=="Completely disagree"
label variable freemarket "Q19a; free market good 1=agree, 4=disagree"

gen responsibility=.
replace responsibility =1 if q24c =="Completely agree"
replace responsibility =2 if q24c =="Mostly agree"
replace responsibility =3 if q24c =="Mostly disagree"
replace responsibility =4 if q24c =="Completely disagree"
label variable responsibility "Q24b; state takes care of poor 1=agree, 4=disagree"

gen enviro=.
replace enviro =1 if q19d =="Completely agree"
replace enviro =2 if q19d =="Mostly agree"
replace enviro =3 if q19d =="Mostly disagree"
replace enviro =4 if q19d =="Completely disagree"
label variable enviro "Q19c; enviro>econ 1=agree, 4=disagree"

gen traditional1=(relig+(5-nativism))/2

gen econ1=(responsibility+(5-freemarket))/2

gen traditional=.
gen econ=.
gen odd = mod(obv,2) 

replace traditional=1 if traditional1==1
replace traditional=1 if traditional1==1.5 & odd==1
replace traditional=2 if traditional1==1.5 & odd==0

replace traditional=2 if traditional1==2
replace traditional=2 if traditional1==2.5 & odd==1
replace traditional=3 if traditional1==2.5 & odd==0

replace traditional=3 if traditional1==3
replace traditional=3 if traditional1==3.5 & odd==1
replace traditional=4 if traditional1==3.5 & odd==0

replace traditional=4 if traditional1==4

replace econ=1 if econ1==1
replace econ=1 if econ1==1.5 & odd==1
replace econ=2 if econ1==1.5 & odd==0

replace econ=2 if econ1==2
replace econ=2 if econ1==2.5 & odd==1
replace econ=3 if econ1==2.5 & odd==0

replace econ=3 if econ1==3
replace econ=3 if econ1==3.5 & odd==1
replace econ=4 if econ1==3.5 & odd==0

replace econ=4 if econ1==4

kountry(countryname), from(other) stuck
rename _ISO3N_ countrycode
replace countrycode=15 if countrycode==.
label variable countrycode "ISO3N ISO 3166 numeric code; palestine=15"

	**Different measure of econ taking into account transnational solidarity

gen transnational_solidarity=0
replace  transnational_solidarity=1 if q101a=="Not doing enough"
replace  transnational_solidarity=2 if q101a=="Doing enough"
replace  transnational_solidarity=. if q101a=="Don't know"
replace  transnational_solidarity=. if q101a=="NA"
label variable transnational_solidarity "Pew2007 q101a (Not = enough=1; = enough=2; other=.)"

gen responsibility_national=responsibility
replace responsibility_national=3 if responsibility==1 & transnational_solidarity==2
replace responsibility_national=4 if responsibility==2 & transnational_solidarity==2

gen econ_national= (responsibility_national+(5-freemarket))/2

replace econ_national=1 if econ_national==1.5 & odd==1
replace econ_national=2 if econ_national==1.5 & odd==0


replace econ_national=2 if econ_national==2.5 & odd==1
replace econ_national=3 if econ_national==2.5 & odd==0

replace econ_national=3 if econ_national==3.5 & odd==1
replace econ_national=4 if econ_national==3.5 & odd==0



**	 2 Produce excel sheets to calculate heterogeneity and polarization

	**This process yields excel charts that can be used ot calculate heterogeneity and polarization for each country and for the world
	
	**Traditional

xcontract traditional, saving(traditional.dta) by(countrycode) nomiss

tab traditional
svyset, poststrata(countrycode) postweight(pop2008)
svy:tab traditional

svyset, poststrata(countrycode) postweight(penrose2008)
svy:tab traditional

svyset, poststrata(countrycode) postweight(GDP2008)
svy:tab traditional

sum traditional [aw=pop2008]
sum traditional [aw=penrose2008]
sum traditional [aw=GDP2008]

clear

use "/Users/bsog0016/Desktop/Preferences crosscutting globalgov/Pew/traditional.dta"

drop _freq

reshape wide _percent, i(countrycode) j(traditional)

export excel using "traditional", firstrow(variables) nolabel replace



	**Econ

xcontract econ, saving(econ.dta) by(countrycode) nomiss

tab econ
svyset, poststrata(countrycode) postweight(pop2008)
svy:tab econ

svyset, poststrata(countrycode) postweight(penrose2008)
svy:tab econ

svyset, poststrata(countrycode) postweight(GDP2008)
svy:tab econ

sum econ [aw=pop2008]
sum econ [aw=penrose2008]
sum econ [aw=GDP2008]

clear

use "/Users/bsog0016/Desktop/Preferences crosscutting globalgov/Pew/econ.dta"

drop _freq

reshape wide _percent, i(countrycode) j(econ)

export excel using "econ", firstrow(variables) nolabel replace


	**Enviro

xcontract enviro, saving(enviro.dta) by(countrycode) nomiss

tab enviro
svyset, poststrata(countrycode) postweight(pop2008)
svy:tab enviro

svyset, poststrata(countrycode) postweight(penrose2008)
svy:tab enviro

svyset, poststrata(countrycode) postweight(GDP2008)
svy:tab enviro

sum enviro [aw=pop2008]
sum enviro [aw=penrose2008]
sum enviro [aw=GDP2008]

clear

use "/Users/bsog0016/Desktop/Preferences crosscutting globalgov/Pew/enviro.dta"

drop _freq

reshape wide _percent, i(countrycode) j(enviro)

export excel using "enviro", firstrow(variables) nolabel replace



**   3 Calculate Gamma (crosscuttingness) for each country and the world
	
	**Recall crosscuttingness = 1 - gamma

	**traditional X econ

tabout traditional econ using traditional_econ.xls if countrycode==15, stats(gamma)
tabout traditional econ using traditional_econ.xls if countrycode==32, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==50, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==68, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==76, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==100, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==124, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==152, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==156, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==203, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==231, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==250, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==276, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==288, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==356, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==360, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==376, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==380, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==384, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==392, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==400, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==404, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==410, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==414, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==422, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==458, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==466, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==484, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==504, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==566, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==586, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==604, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==616, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==686, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==703, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==710, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==724, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==752, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==792, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==800, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==804, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==810, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==818, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==826, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==834, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==840, stats(gamma) append
tabout traditional econ using traditional_econ.xls if countrycode==862, stats(gamma) append

	**traditional X enviro

tabout traditional enviro using traditional_enviro.xls if countrycode==15, stats(gamma)
tabout traditional enviro using traditional_enviro.xls if countrycode==32, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==50, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==68, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==76, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==100, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==124, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==152, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==156, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==203, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==231, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==250, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==276, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==288, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==356, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==360, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==376, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==380, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==384, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==392, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==400, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==404, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==410, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==414, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==422, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==458, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==466, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==484, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==504, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==566, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==586, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==604, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==616, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==686, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==703, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==710, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==724, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==752, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==792, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==800, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==804, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==810, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==818, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==826, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==834, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==840, stats(gamma) append
tabout traditional enviro using traditional_enviro.xls if countrycode==862, stats(gamma) append

	**econ X enviro

tabout econ enviro using econ_enviro.xls if countrycode==15, stats(gamma)
tabout econ enviro using econ_enviro.xls if countrycode==32, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==50, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==68, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==76, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==100, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==124, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==152, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==156, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==203, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==231, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==250, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==276, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==288, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==356, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==360, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==376, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==380, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==384, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==392, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==400, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==404, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==410, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==414, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==422, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==458, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==466, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==484, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==504, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==566, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==586, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==604, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==616, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==686, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==703, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==710, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==724, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==752, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==792, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==800, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==804, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==810, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==818, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==826, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==834, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==840, stats(gamma) append
tabout econ enviro using econ_enviro.xls if countrycode==862, stats(gamma) append


**   4 Calculate divergence for each country and the world 

	**First calculate mean scores for each country and the world for each dimension

egen enviro_countrymean=mean(enviro), by(countrycode)
egen enviro_worldmean=mean(enviro)
sum enviro [aw=pop2008]
gen enviro_worldmeanpop=1.859318

egen enviro_countrymedian=median(enviro), by(countrycode)
egen enviro_worldmedian=median(enviro)
univar enviro [aw=pop2008]
gen enviro_worldmedianpop=2


egen econ_countrymean=mean(econ), by(countrycode)
egen econ_worldmean=mean(econ)
sum econ [aw=pop2008]
gen econ_worldmeanpop=2.269574 

egen econ_countrymedian=median(econ), by(countrycode)
egen econ_worldmedian=median(econ)
univar econ [aw=pop2008]
gen econ_worldmedianpop=2

egen traditional_countrymean=mean(traditional), by(countrycode)
egen traditional_worldmean=mean(traditional)
sum traditional [aw=pop2008]
gen traditional_worldmeanpop=2.477781 

egen traditional_countrymedian=median(traditional), by(countrycode)
egen traditional_worldmedian=median(traditional)
univar traditional [aw=pop2008]
gen traditional_worldmedianpop=2


	**Then generate individual divergence scores (take the absolute value)

gen enviro_countrydiv1=abs(enviro-enviro_countrymean)
gen enviro_worlddiv1=abs(enviro-enviro_worldmean)
gen enviro_worlddivpop1=abs(enviro-enviro_worldmeanpop)

gen enviro_countrydiv2=abs(enviro-enviro_countrymedian)
gen enviro_worlddiv2=abs(enviro-enviro_worldmedian)
gen enviro_worlddivpop2=abs(enviro-enviro_worldmedianpop)

gen econ_countrydiv1=abs(econ-econ_countrymean)
gen econ_worlddiv1=abs(econ-econ_worldmean)
gen econ_worlddivpop1=abs(econ-econ_worldmeanpop)

gen econ_countrydiv2=abs(econ-econ_countrymedian)
gen econ_worlddiv2=abs(econ-econ_worldmedian)
gen econ_worlddivpop2=abs(econ-econ_worldmedianpop)

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


	**calculate total divergence in different polities

xcollapse (mean) div_country1, by(countrycode) list(,) 
xcollapse (sd) div_country1, by(countrycode) list(,) 
sum div_world1 div_worldpop1 [aw=2008]

xcollapse (mean) div_country2, by(countrycode) list(,) 
xcollapse (sd) div_country2, by(countrycode) list(,) 
sum div_world2 div_worldpop2 [aw=2008]

	**See how much total disastisifaction there is in different polities. World of states v. globe

	**See how disatisfaction is distributed by looking at the SD of the scores you obtain. Are there polities with a high concentration of very disatified groups?

	**Taking into account solidarity 

egen econ_natl_countrymedian=median(econ_national), by(countrycode)
egen econ_natl_worldmedian=median(econ_national)
univar econ_national [aw=pop2008]
gen econ_natl_worldmedianpop=2

gen econ_natl_countrydiv2=abs(econ_national-econ_natl_countrymedian)
gen econ_natl_worlddiv2=abs(econ_national-econ_natl_worldmedian)
gen econ_natl_worlddivpop2=abs(econ_national-econ_natl_worldmedianpop)

egen Zecon_natl_countrydiv2=std(econ_natl_countrydiv2)

egen Zecon_natl_worlddiv2=std(econ_natl_worlddiv2)
egen Zecon_natl_worlddivpop2=std(econ_natl_worlddivpop2)

gen div_country2_natl=(abs(Zenviro_countrydiv2)+abs(Zecon_natl_countrydiv2)+abs(Ztraditional_countrydiv2))/3
gen div_world2_natl=(abs(Zenviro_worlddiv2)+abs(Zecon_natl_worlddiv2)+abs(Ztraditional_worlddiv2))/3
gen div_worldpop2_natl=(abs(Zenviro_worlddivpop2)+abs(Zecon_natl_worlddivpop2)+abs(Ztraditional_worlddivpop2))/3

sum div_world2_natl div_worldpop2_natl [aw=2008]


**   5 Calculate Inequality of divergence 

	**Calculate Ginis of dissatisfaction

fastgini div_country2 if countrycode==15
fastgini div_country2 if countrycode==32
fastgini div_country2 if countrycode==50
fastgini div_country2 if countrycode==68
fastgini div_country2 if countrycode==76
fastgini div_country2 if countrycode==100
fastgini div_country2 if countrycode==124
fastgini div_country2 if countrycode==152
fastgini div_country2 if countrycode==156
fastgini div_country2 if countrycode==203
fastgini div_country2 if countrycode==231
fastgini div_country2 if countrycode==250
fastgini div_country2 if countrycode==276
fastgini div_country2 if countrycode==288
fastgini div_country2 if countrycode==356
fastgini div_country2 if countrycode==360
fastgini div_country2 if countrycode==376
fastgini div_country2 if countrycode==380
fastgini div_country2 if countrycode==384
fastgini div_country2 if countrycode==392
fastgini div_country2 if countrycode==400
fastgini div_country2 if countrycode==404
fastgini div_country2 if countrycode==410
fastgini div_country2 if countrycode==414
fastgini div_country2 if countrycode==422
fastgini div_country2 if countrycode==458
fastgini div_country2 if countrycode==466
fastgini div_country2 if countrycode==484
fastgini div_country2 if countrycode==504
fastgini div_country2 if countrycode==566
fastgini div_country2 if countrycode==586
fastgini div_country2 if countrycode==604
fastgini div_country2 if countrycode==616
fastgini div_country2 if countrycode==686
fastgini div_country2 if countrycode==703
fastgini div_country2 if countrycode==710
fastgini div_country2 if countrycode==724
fastgini div_country2 if countrycode==752
fastgini div_country2 if countrycode==792
fastgini div_country2 if countrycode==800
fastgini div_country2 if countrycode==804
fastgini div_country2 if countrycode==810
fastgini div_country2 if countrycode==818
fastgini div_country2 if countrycode==826
fastgini div_country2 if countrycode==834
fastgini div_country2 if countrycode==840
fastgini div_country2 if countrycode==862

fastgini div_world2
fastgini div_worldpop2 [w=pop2008]
