insheet using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\oct1995cps.asc", double
drop if gtmsa==0

gen incomedolars=2500 if hufaminc==1
replace incomedolars=6250 if hufaminc==2
replace incomedolars=8750 if hufaminc==3
replace incomedolars=11250 if hufaminc==4
replace incomedolars=13750 if hufaminc==5
replace incomedolars=17500 if hufaminc==6
replace incomedolars=22500 if hufaminc==7
replace incomedolars=27500 if hufaminc==8
replace incomedolars=32500 if hufaminc==9
replace incomedolars=37500 if hufamin==10
replace incomedolars=45000 if hufaminc==11
replace incomedolars=55000 if hufaminc==12
replace incomedolars=67500 if hufaminc==13
replace incomedolars=100000 if hufaminc==14 
egen auxhh3=sum(pwsswgt), by(gtmsa)

gen incomew=incomedolars*pwsswgt
egen incomewmsa=sum(incomew), by(gtmsa)
gen income1995=incomewmsa/auxhh3
count if income1995~=.


egen numberofpeopleinhh=max(occurnum), by(hrhhid)
gen incomedolarspercap=incomedolars/numberofpeopleinhh


gen educw=preduca5*pwsswgt if preduca5~=0
egen educmsa=sum(educw), by(gtmsa)
gen educ1995=educmsa/auxhh3


gen weight35a=pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen aux33a=sum(weight35a), by(gtmsa)
gen weight35_54a=pwsswgt if prtage>=35 & prtage<55 & preduca5~=0
egen aux66a=sum(weight35_54a), by(gtmsa)
gen weight55plusa=pwsswgt if prtage>=55 & preduca5~=0
egen aux99a=sum(weight55plusa), by(gtmsa)

gen weight35aa=pwsswgt if prtage<35 & prtage>5 
egen aux33aaa=sum(weight35aa), by(gtmsa)
gen weight35_54aa=pwsswgt if prtage>=35 & prtage<55 
egen aux66aaa=sum(weight35_54aa), by(gtmsa)
gen weight55plusaa=pwsswgt if prtage>=55 
egen aux99aaa=sum(weight55plusaa), by(gtmsa)


gen educ6_34w=preduca5*pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen educ6_34msa=sum(educ6_34w), by(gtmsa)
gen educ6_34_1995=educ6_34msa/aux33a

gen educ35_54w=preduca5*pwsswgt if prtage<55 & prtage>34 & preduca5~=0
egen educ35_54msa=sum(educ35_54w), by(gtmsa)
gen educ35_54_1995=educ35_54msa/aux66a

gen educ55plusw=preduca5*pwsswgt if prtage>=55 & preduca5~=0
egen educ44plusmsa=sum(educ55plusw), by(gtmsa)
gen educ55plus1995=educ44plusmsa/aux99a

gen q=1
egen numberofobservations1995=sum(q), by(gtmsa) 

gen latino=0
replace latino=1 if prhspnon==1
gen latinoaux=latino*pwsswgt
egen latinomsa=sum(latinoaux), by(gtmsa)
gen latino1995=latinomsa/auxhh3

gen latino6_34w=latino*pwsswgt if prtage<35 & prtage>5 
egen latino6_34msa=sum(latino6_34w), by(gtmsa)
gen latino6_34_1995=latino6_34msa/aux33aaa

gen latino35_54w=latino*pwsswgt if prtage<55 & prtage>34
egen latino35_54msa=sum(latino35_54w), by(gtmsa)
gen latino35_54_1995=latino35_54msa/aux66aaa

gen latino55plusw=latino*pwsswgt if prtage>=55 
egen latino44plusmsa=sum(latino55plusw), by(gtmsa)
gen latino55plus1995=latino44plusmsa/aux99aaa

gen black=0
replace black=1 if perace==2

gen blackaux=black*pwsswgt
egen blackmsa=sum(blackaux), by(gtmsa)
gen black1995=blackmsa/auxhh3

gen black6_34w=black*pwsswgt if prtage<35 & prtage>5 
egen black6_34msa=sum(black6_34w), by(gtmsa)
gen black6_34_1995=black6_34msa/aux33aaa

gen black35_54w=black*pwsswgt if prtage<55 & prtage>34
egen black35_54msa=sum(black35_54w), by(gtmsa)
gen black35_54_1995=black35_54msa/aux66aaa

gen black55plusw=black*pwsswgt if prtage>=55 
egen black44plusmsa=sum(black55plusw), by(gtmsa)
gen black55plus1995=black44plusmsa/aux99aaa

preserve
keep incomedolarspercap gtmsa prtage
gen income6_34=incomedolarspercap if prtage<35 & prtage>5 
gen income35_54=incomedolarspercap if prtage<55 & prtage>=35 
gen income55plus=incomedolarspercap if prtage>=55 
rename incomedolarspercap incomedolarspercap1995
rename income6_34 incomedolarspercap634_1995
rename income35_54 incomedolarspercap3554_1995
rename income55plus incomedolarspercap55plus_1995
drop prtage
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\incomepercapitaresubmit1995.dta", replace
restore

collapse numberofobservations1995 black1995 black6_34_1995 black35_54_1995 black55plus1995 latino1995 latino6_34_1995 latino35_54_1995 latino55plus1995 educ55plus1995 educ35_54_1995 educ6_34_1995 income1995 educ1995, by(gtmsa)

save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\oct1995cpsfinal.dta", replace

clear
insheet using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\oct1997cps.asc", double
merge using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\latino1997.dta"
count if  hrhhid~=hrhhid1
drop if gtmsa==0

*PESCU1=1 Computer in HH*
*PESCU12A Does person...use the internet at home?- universe is PESCU1=1 and age 15+*
*PESCHCU3 Does person...use the computer at home?-universe PESCU1=1 and age 3-14*
*PESCCU4H Does person ...use the internet at home?-universe PESCHCU3=1*



gen aux1=0
replace aux1=1 if pescu12a==1
replace aux1=1 if  pesccu4h==1
gen aux2=aux1*pwsswgt
egen aux3=sum(pwsswgt), by(gtmsa)
egen aux4=sum(aux2), by(gtmsa)
gen internetuse1997=aux4/aux3



gen a=1
egen aa=concat( hrhhid occurnum), format(%19.0g)
format hrhhid %19.0g
egen aaa=sum(a), by(aa)
tab aaa
egen auxhh1=max(aux1), by(hrhhid)
gen auxhh2=auxhh1*pwsswgt
egen auxhh3=sum(pwsswgt), by(gtmsa)
egen auxhh4=sum(auxhh2), by(gtmsa)
gen internetusehh1997=auxhh4/auxhh3


gen incomedolars=2500 if hufaminc==1
replace incomedolars=6250 if hufaminc==2
replace incomedolars=8750 if hufaminc==3
replace incomedolars=11250 if hufaminc==4
replace incomedolars=13750 if hufaminc==5
replace incomedolars=17500 if hufaminc==6
replace incomedolars=22500 if hufaminc==7
replace incomedolars=27500 if hufaminc==8
replace incomedolars=32500 if hufaminc==9
replace incomedolars=37500 if hufamin==10
replace incomedolars=45000 if hufaminc==11
replace incomedolars=55000 if hufaminc==12
replace incomedolars=67500 if hufaminc==13
replace incomedolars=100000 if hufaminc==14 

gen incomew=incomedolars*pwsswgt
egen incomewmsa=sum(incomew), by(gtmsa)
gen income1997=incomewmsa/auxhh3
count if income1997~=.


egen numberofpeopleinhh=max(occurnum), by(hrhhid)
gen incomedolarspercap=incomedolars/numberofpeopleinhh


gen educw=preduca5*pwsswgt if preduca5~=0
egen educmsa=sum(educw), by(gtmsa)
gen educ1997=educmsa/auxhh3


gen aux22=0 if prtage<35 & prtage>5
replace aux22=1 if prtage<35 & prtage>5 & pescu12a==1
replace aux22=1 if prtage<35 & prtage>5 & pesccu4h==1
gen aux222=aux22*pwsswgt
gen weight35=pwsswgt if prtage<35 & prtage>5
egen aux33=sum(weight35), by(gtmsa)
egen aux44=sum(aux222), by(gtmsa)
gen internetuse6_34person1997=aux44/aux33

gen aux55=0 if prtage>=35 & prtage<55
replace aux55=1 if prtage>=35 & prtage<55 & pescu12a==1
replace aux55=1 if prtage>=35 & prtage<55 & pesccu4h==1
gen aux555=aux55*pwsswgt
gen weight35_54=pwsswgt if prtage>=35 & prtage<55
egen aux66=sum(weight35_54), by(gtmsa)
egen aux77=sum(aux555), by(gtmsa)
gen internetuse35_54person1997=aux77/aux66

gen aux88=0 if  prtage>=55
replace aux88=1 if prtage>=55 & pescu12a==1
replace aux88=1 if prtage>=55 & pesccu4h==1
gen aux888=aux88*pwsswgt
gen weight55plus=pwsswgt if prtage>=55
egen aux99=sum(weight55plus), by(gtmsa)
egen aux999=sum(aux888), by(gtmsa)
gen internetuse55plusperson1997=aux999/aux99

gen weight35a=pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen aux33a=sum(weight35a), by(gtmsa)


gen weight35_54a=pwsswgt if prtage>=35 & prtage<55 & preduca5~=0
egen aux66a=sum(weight35_54a), by(gtmsa)
gen weight55plusa=pwsswgt if prtage>=55 & preduca5~=0
egen aux99a=sum(weight55plusa), by(gtmsa)


gen weight35aa=pwsswgt if prtage<35 & prtage>5 
egen aux33aaa=sum(weight35aa), by(gtmsa)
gen weight35_54aa=pwsswgt if prtage>=35 & prtage<55 
egen aux66aaa=sum(weight35_54aa), by(gtmsa)
gen weight55plusaa=pwsswgt if prtage>=55 
egen aux99aaa=sum(weight55plusaa), by(gtmsa)


gen educ6_34w=preduca5*pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen educ6_34msa=sum(educ6_34w), by(gtmsa)
gen educ6_34_1997=educ6_34msa/aux33a

gen educ35_54w=preduca5*pwsswgt if prtage<55 & prtage>34 & preduca5~=0
egen educ35_54msa=sum(educ35_54w), by(gtmsa)
gen educ35_54_1997=educ35_54msa/aux66a

gen educ55plusw=preduca5*pwsswgt if prtage>=55 & preduca5~=0
egen educ44plusmsa=sum(educ55plusw), by(gtmsa)
gen educ55plus1997=educ44plusmsa/aux99a


gen q=1
egen numberofobservations1997=sum(q), by(gtmsa) 

gen latino=0
replace latino=1 if prhspnon==1
gen latinoaux=latino*pwsswgt
egen latinomsa=sum(latinoaux), by(gtmsa)
gen latino1997=latinomsa/auxhh3

gen latino6_34w=latino*pwsswgt if prtage<35 & prtage>5 
egen latino6_34msa=sum(latino6_34w), by(gtmsa)
gen latino6_34_1997=latino6_34msa/aux33aaa

gen latino35_54w=latino*pwsswgt if prtage<55 & prtage>34
egen latino35_54msa=sum(latino35_54w), by(gtmsa)
gen latino35_54_1997=latino35_54msa/aux66aaa

gen latino55plusw=latino*pwsswgt if prtage>=55 
egen latino44plusmsa=sum(latino55plusw), by(gtmsa)
gen latino55plus1997=latino44plusmsa/aux99aaa

gen black=0
replace black=1 if perace==2

gen blackaux=black*pwsswgt
egen blackmsa=sum(blackaux), by(gtmsa)
gen black1997=blackmsa/auxhh3

gen black6_34w=black*pwsswgt if prtage<35 & prtage>5 
egen black6_34msa=sum(black6_34w), by(gtmsa)
gen black6_34_1997=black6_34msa/aux33aaa

gen black35_54w=black*pwsswgt if prtage<55 & prtage>34
egen black35_54msa=sum(black35_54w), by(gtmsa)
gen black35_54_1997=black35_54msa/aux66aaa

gen black55plusw=black*pwsswgt if prtage>=55 
egen black44plusmsa=sum(black55plusw), by(gtmsa)
gen black55plus1997=black44plusmsa/aux99aaa


preserve
keep incomedolarspercap gtmsa prtage
gen income6_34=incomedolarspercap if prtage<35 & prtage>5 
gen income35_54=incomedolarspercap if prtage<55 & prtage>=35 
gen income55plus=incomedolarspercap if prtage>=55 
rename incomedolarspercap incomedolarspercap1997
rename income6_34 incomedolarspercap634_1997
rename income35_54 incomedolarspercap3554_1997
rename income55plus incomedolarspercap55plus_1997
drop prtage
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\incomepercapitaresubmit1997.dta", replace
restore

collapse numberofobservations1997 black1997 black6_34_1997 black35_54_1997 black55plus1997 latino1997 latino6_34_1997 latino35_54_1997 latino55plus1997 educ55plus1997 educ35_54_1997 educ6_34_1997 internetuse55plusperson1997 internetuse35_54person1997 internetuse6_34person1997 income1997 internetuse1997 internetusehh1997 educ1997, by(gtmsa)

save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\october1997cpsfinal.dta", replace

clear
insheet using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\dec1998cps.asc", double
merge using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\latino1998.dta"
count if  hrhhid~=hrhhid1
drop if gtmsa==0


gen aux1=0
replace aux1=1 if hesiu3==1
gen aux2=aux1*pwsswgt
egen aux3=sum(pwsswgt), by(gtmsa)
egen aux4=sum(aux2), by(gtmsa)
gen internetuse1998=aux4/aux3

gen incomedolars=2500 if hufaminc==1
replace incomedolars=6250 if hufaminc==2
replace incomedolars=8750 if hufaminc==3
replace incomedolars=11250 if hufaminc==4
replace incomedolars=13750 if hufaminc==5
replace incomedolars=17500 if hufaminc==6
replace incomedolars=22500 if hufaminc==7
replace incomedolars=27500 if hufaminc==8
replace incomedolars=32500 if hufaminc==9
replace incomedolars=37500 if hufaminc==10
replace incomedolars=45000 if hufaminc==11
replace incomedolars=55000 if hufaminc==12
replace incomedolars=67500 if hufaminc==13
replace incomedolars=100000 if hufaminc==14 

gen incomew=incomedolars*pwsswgt
egen incomewmsa=sum(incomew), by(gtmsa)
gen income1998=incomewmsa/aux3
count if income1998~=.


egen numberofpeopleinhh=max(occurnum), by(hrhhid)
gen incomedolarspercap=incomedolars/numberofpeopleinhh


gen educw=preduca5*pwsswgt if preduca5~=0
egen educmsa=sum(educw), by(gtmsa)
gen educ1998=educmsa/aux3

gen aux22=0 if prtage<35 & prtage>5
replace aux22=1 if prtage<35 & prtage>5 & prs11==1
gen aux222=aux22*pwsswgt
gen weight35=pwsswgt if prtage<35 & prtage>5
egen aux33=sum(weight35), by(gtmsa)
egen aux44=sum(aux222), by(gtmsa)
gen internetuse6_34person1998=aux44/aux33

gen aux55=0 if prtage>=35 & prtage<55
replace aux55=1 if prtage>=35 & prtage<55 & prs11==1
gen aux555=aux55*pwsswgt
gen weight35_54=pwsswgt if prtage>=35 & prtage<55
egen aux66=sum(weight35_54), by(gtmsa)
egen aux77=sum(aux555), by(gtmsa)
gen internetuse35_54person1998=aux77/aux66

gen aux88=0 if  prtage>=55
replace aux88=1 if prtage>=55 & prs11==1
gen aux888=aux88*pwsswgt
gen weight55plus=pwsswgt if prtage>=55
egen aux99=sum(weight55plus), by(gtmsa)
egen aux999=sum(aux888), by(gtmsa)
gen internetuse55plusperson1998=aux999/aux99

gen weight35a=pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen aux33a=sum(weight35a), by(gtmsa)
gen weight35_54a=pwsswgt if prtage>=35 & prtage<55 & preduca5~=0
egen aux66a=sum(weight35_54a), by(gtmsa)
gen weight55plusa=pwsswgt if prtage>=55 & preduca5~=0
egen aux99a=sum(weight55plusa), by(gtmsa)

gen educ6_34w=preduca5*pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen educ6_34msa=sum(educ6_34w), by(gtmsa)
gen educ6_34_1998=educ6_34msa/aux33a

gen educ35_54w=preduca5*pwsswgt if prtage<55 & prtage>34 & preduca5~=0
egen educ35_54msa=sum(educ35_54w), by(gtmsa)
gen educ35_54_1998=educ35_54msa/aux66a

gen educ55plusw=preduca5*pwsswgt if prtage>=55 & preduca5~=0
egen educ44plusmsa=sum(educ55plusw), by(gtmsa)
gen educ55plus1998=educ44plusmsa/aux99a

gen a=1
egen numberofobservations1998=sum(a), by(gtmsa) 

gen weight35aa=pwsswgt if prtage<35 & prtage>5 
egen aux33aaa=sum(weight35aa), by(gtmsa)
gen weight35_54aa=pwsswgt if prtage>=35 & prtage<55 
egen aux66aaa=sum(weight35_54aa), by(gtmsa)
gen weight55plusaa=pwsswgt if prtage>=55 
egen aux99aaa=sum(weight55plusaa), by(gtmsa)


gen latino=0
replace latino=1 if prhspnon==1
gen latinoaux=latino*pwsswgt
egen latinomsa=sum(latinoaux), by(gtmsa)
gen latino1998=latinomsa/aux3

gen latino6_34w=latino*pwsswgt if prtage<35 & prtage>5 
egen latino6_34msa=sum(latino6_34w), by(gtmsa)
gen latino6_34_1998=latino6_34msa/aux33aaa

gen latino35_54w=latino*pwsswgt if prtage<55 & prtage>34
egen latino35_54msa=sum(latino35_54w), by(gtmsa)
gen latino35_54_1998=latino35_54msa/aux66aaa

gen latino55plusw=latino*pwsswgt if prtage>=55 
egen latino44plusmsa=sum(latino55plusw), by(gtmsa)
gen latino55plus1998=latino44plusmsa/aux99aaa

gen black=0
replace black=1 if perace==2

gen blackaux=black*pwsswgt
egen blackmsa=sum(blackaux), by(gtmsa)
gen black1998=blackmsa/aux3

gen black6_34w=black*pwsswgt if prtage<35 & prtage>5 
egen black6_34msa=sum(black6_34w), by(gtmsa)
gen black6_34_1998=black6_34msa/aux33aaa

gen black35_54w=black*pwsswgt if prtage<55 & prtage>34
egen black35_54msa=sum(black35_54w), by(gtmsa)
gen black35_54_1998=black35_54msa/aux66aaa

gen black55plusw=black*pwsswgt if prtage>=55 
egen black44plusmsa=sum(black55plusw), by(gtmsa)
gen black55plus1998=black44plusmsa/aux99aaa

preserve
keep incomedolarspercap gtmsa prtage
gen income6_34=incomedolarspercap if prtage<35 & prtage>5 
gen income35_54=incomedolarspercap if prtage<55 & prtage>=35 
gen income55plus=incomedolarspercap if prtage>=55 
rename incomedolarspercap incomedolarspercap1998
rename income6_34 incomedolarspercap634_1998
rename income35_54 incomedolarspercap3554_1998
rename income55plus incomedolarspercap55plus_1998
drop prtage
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\incomepercapitaresubmit1998.dta", replace
restore

collapse numberofobservations1998 black1998 black6_34_1998 black35_54_1998 black55plus1998 latino1998 latino6_34_1998 latino35_54_1998 latino55plus1998 educ55plus1998 educ35_54_1998 educ6_34_1998 internetuse55plusperson1998 internetuse35_54person1998 internetuse6_34person1998 income1998 internetuse1998 educ1998, by(gtmsa)
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\december1998cpsfinal.dta", replace

clear
insheet using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\aug2000cps.asc", double
merge using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\latino2000.dta"
count if  hrhhid~=hrhhid1
drop in 1
drop if gtmsa==0
*a few hhid more than once*
*to do it by person we need to use PES11A to PES11J*
gen aux1=0
replace aux1=1 if hesiu3==1
gen aux2=aux1*pwsswgt
egen aux3=sum(pwsswgt), by(gtmsa)
egen aux4=sum(aux2), by(gtmsa)
gen internetuse2000=aux4/aux3

gen incomedolars=2500 if hufaminc==1
replace incomedolars=6250 if hufaminc==2
replace incomedolars=8750 if hufaminc==3
replace incomedolars=11250 if hufaminc==4
replace incomedolars=13750 if hufaminc==5
replace incomedolars=17500 if hufaminc==6
replace incomedolars=22500 if hufaminc==7
replace incomedolars=27500 if hufaminc==8
replace incomedolars=32500 if hufaminc==9
replace incomedolars=37500 if hufaminc==10
replace incomedolars=45000 if hufaminc==11
replace incomedolars=55000 if hufaminc==12
replace incomedolars=67500 if hufaminc==13
replace incomedolars=100000 if hufaminc==14 

gen incomew=incomedolars*pwsswgt
egen incomewmsa=sum(incomew), by(gtmsa)
gen income2000=incomewmsa/aux3


egen numberofpeopleinhh=max(occurnum), by(hrhhid)
gen incomedolarspercap=incomedolars/numberofpeopleinhh


gen educw=preduca5*pwsswgt if preduca5~=0
egen educmsa=sum(educw), by(gtmsa)
gen educ2000=educmsa/aux3


gen aux22=0 if prtage<35 & prtage>5
replace aux22=1 if prtage<35 & prtage>5 & prs11==1
gen aux222=aux22*pwsswgt
gen weight35=pwsswgt if prtage<35 & prtage>5
egen aux33=sum(weight35), by(gtmsa)
egen aux44=sum(aux222), by(gtmsa)
gen internetuse6_34person2000=aux44/aux33

gen aux55=0 if prtage>=35 & prtage<55
replace aux55=1 if prtage>=35 & prtage<55 & prs11==1
gen aux555=aux55*pwsswgt
gen weight35_54=pwsswgt if prtage>=35 & prtage<55
egen aux66=sum(weight35_54), by(gtmsa)
egen aux77=sum(aux555), by(gtmsa)
gen internetuse35_54person2000=aux77/aux66

gen aux88=0 if  prtage>=55
replace aux88=1 if prtage>=55 & prs11==1
gen aux888=aux88*pwsswgt
gen weight55plus=pwsswgt if prtage>=55
egen aux99=sum(weight55plus), by(gtmsa)
egen aux999=sum(aux888), by(gtmsa)
gen internetuse55plusperson2000=aux999/aux99

gen weight35a=pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen aux33a=sum(weight35a), by(gtmsa)
gen weight35_54a=pwsswgt if prtage>=35 & prtage<55 & preduca5~=0
egen aux66a=sum(weight35_54a), by(gtmsa)
gen weight55plusa=pwsswgt if prtage>=55 & preduca5~=0
egen aux99a=sum(weight55plusa), by(gtmsa)


gen educ6_34w=preduca5*pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen educ6_34msa=sum(educ6_34w), by(gtmsa)
gen educ6_34_2000=educ6_34msa/aux33a

gen educ35_54w=preduca5*pwsswgt if prtage<55 & prtage>34 & preduca5~=0
egen educ35_54msa=sum(educ35_54w), by(gtmsa)
gen educ35_54_2000=educ35_54msa/aux66a

gen educ55plusw=preduca5*pwsswgt if prtage>=55 & preduca5~=0
egen educ44plusmsa=sum(educ55plusw), by(gtmsa)
gen educ55plus2000=educ44plusmsa/aux99a


gen a=1
egen numberofobservations2000=sum(a), by(gtmsa) 

gen weight35aa=pwsswgt if prtage<35 & prtage>5 
egen aux33aaa=sum(weight35aa), by(gtmsa)
gen weight35_54aa=pwsswgt if prtage>=35 & prtage<55 
egen aux66aaa=sum(weight35_54aa), by(gtmsa)
gen weight55plusaa=pwsswgt if prtage>=55 
egen aux99aaa=sum(weight55plusaa), by(gtmsa)

gen latino=0
replace latino=1 if prhspnon==1
gen latinoaux=latino*pwsswgt
egen latinomsa=sum(latinoaux), by(gtmsa)
gen latino2000=latinomsa/aux3

gen latino6_34w=latino*pwsswgt if prtage<35 & prtage>5 
egen latino6_34msa=sum(latino6_34w), by(gtmsa)
gen latino6_34_2000=latino6_34msa/aux33aaa

gen latino35_54w=latino*pwsswgt if prtage<55 & prtage>34
egen latino35_54msa=sum(latino35_54w), by(gtmsa)
gen latino35_54_2000=latino35_54msa/aux66aaa

gen latino55plusw=latino*pwsswgt if prtage>=55 
egen latino44plusmsa=sum(latino55plusw), by(gtmsa)
gen latino55plus2000=latino44plusmsa/aux99aaa

gen black=0
replace black=1 if perace==2

gen blackaux=black*pwsswgt
egen blackmsa=sum(blackaux), by(gtmsa)
gen black2000=blackmsa/aux3

gen black6_34w=black*pwsswgt if prtage<35 & prtage>5 
egen black6_34msa=sum(black6_34w), by(gtmsa)
gen black6_34_2000=black6_34msa/aux33aaa

gen black35_54w=black*pwsswgt if prtage<55 & prtage>34
egen black35_54msa=sum(black35_54w), by(gtmsa)
gen black35_54_2000=black35_54msa/aux66aaa

gen black55plusw=black*pwsswgt if prtage>=55 
egen black44plusmsa=sum(black55plusw), by(gtmsa)
gen black55plus2000=black44plusmsa/aux99aaa

preserve
keep incomedolarspercap gtmsa prtage
gen income6_34=incomedolarspercap if prtage<35 & prtage>5 
gen income35_54=incomedolarspercap if prtage<55 & prtage>=35 
gen income55plus=incomedolarspercap if prtage>=55 
rename incomedolarspercap incomedolarspercap2000
rename income6_34 incomedolarspercap634_2000
rename income35_54 incomedolarspercap3554_2000
rename income55plus incomedolarspercap55plus_2000
drop prtage
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\incomepercapitaresubmit2000.dta", replace
restore

collapse black2000 black6_34_2000 black35_54_2000 black55plus2000 latino2000 latino6_34_2000 latino35_54_2000 latino55plus2000 numberofobservations2000 educ55plus2000 educ35_54_2000 educ6_34_2000 internetuse55plusperson2000 internetuse35_54person2000 internetuse6_34person2000 income2000 internetuse2000 educ2000, by(gtmsa)
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\august2000cpsfinal.dta", replace


clear

insheet using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\set2001cps.asc", double
merge using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\latino2001.dta"
count if  hrhhid~=hrhhid1
drop if gtmsa==0

*to do it by person we need to use pes11a to pes11j*
gen aux1=0
replace aux1=1 if hesint1==1
gen aux2=aux1*pwsswgt
egen aux3=sum(pwsswgt), by(gtmsa)
egen aux4=sum(aux2), by(gtmsa)
gen internetuse2001=aux4/aux3

gen incomedolars=2500 if hufaminc==1
replace incomedolars=6250 if hufaminc==2
replace incomedolars=8750 if hufaminc==3
replace incomedolars=11250 if hufaminc==4
replace incomedolars=13750 if hufaminc==5
replace incomedolars=17500 if hufaminc==6
replace incomedolars=22500 if hufaminc==7
replace incomedolars=27500 if hufaminc==8
replace incomedolars=32500 if hufaminc==9
replace incomedolars=37500 if hufaminc==10
replace incomedolars=45000 if hufaminc==11
replace incomedolars=55000 if hufaminc==12
replace incomedolars=67500 if hufaminc==13
replace incomedolars=100000 if hufaminc==14 


gen incomew=incomedolars*pwsswgt
egen incomewmsa=sum(incomew), by(gtmsa)
gen income2001=incomewmsa/aux3



egen numberofpeopleinhh=max(occurnum), by(hrhhid)
gen incomedolarspercap=incomedolars/numberofpeopleinhh

gen educw=preduca5*pwsswgt if preduca5~=0
egen educmsa=sum(educw), by(gtmsa)
gen educ2001=educmsa/aux3


gen aux22=0 if prtage<35 & prtage>5
replace aux22=1 if prtage<35 & prtage>5 & prnet2==1
gen aux222=aux22*pwsswgt
gen weight35=pwsswgt if prtage<35 & prtage>5
egen aux33=sum(weight35), by(gtmsa)
egen aux44=sum(aux222), by(gtmsa)
gen internetuse6_34person2001=aux44/aux33

gen aux55=0 if prtage>=35 & prtage<55
replace aux55=1 if prtage>=35 & prtage<55 & prnet2==1
gen aux555=aux55*pwsswgt
gen weight35_54=pwsswgt if prtage>=35 & prtage<55
egen aux66=sum(weight35_54), by(gtmsa)
egen aux77=sum(aux555), by(gtmsa)
gen internetuse35_54person2001=aux77/aux66

gen aux88=0 if  prtage>=55
replace aux88=1 if prtage>=55 & prnet2==1
gen aux888=aux88*pwsswgt
gen weight55plus=pwsswgt if prtage>=55
egen aux99=sum(weight55plus), by(gtmsa)
egen aux999=sum(aux888), by(gtmsa)
gen internetuse55plusperson2001=aux999/aux99

gen weight35a=pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen aux33a=sum(weight35a), by(gtmsa)
gen weight35_54a=pwsswgt if prtage>=35 & prtage<55 & preduca5~=0
egen aux66a=sum(weight35_54a), by(gtmsa)
gen weight55plusa=pwsswgt if prtage>=55 & preduca5~=0
egen aux99a=sum(weight55plusa), by(gtmsa)

gen educ6_34w=preduca5*pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen educ6_34msa=sum(educ6_34w), by(gtmsa)
gen educ6_34_2001=educ6_34msa/aux33a

gen educ35_54w=preduca5*pwsswgt if prtage<55 & prtage>34 & preduca5~=0
egen educ35_54msa=sum(educ35_54w), by(gtmsa)
gen educ35_54_2001=educ35_54msa/aux66a

gen educ55plusw=preduca5*pwsswgt if prtage>=55 & preduca5~=0
egen educ44plusmsa=sum(educ55plusw), by(gtmsa)
gen educ55plus2001=educ44plusmsa/aux99a



gen a=1
egen numberofobservations2001=sum(a), by(gtmsa)  
gen weight35aa=pwsswgt if prtage<35 & prtage>5 
egen aux33aaa=sum(weight35aa), by(gtmsa)
gen weight35_54aa=pwsswgt if prtage>=35 & prtage<55 
egen aux66aaa=sum(weight35_54aa), by(gtmsa)
gen weight55plusaa=pwsswgt if prtage>=55 
egen aux99aaa=sum(weight55plusaa), by(gtmsa)

gen latino=0
replace latino=1 if prhspnon==1
gen latinoaux=latino*pwsswgt
egen latinomsa=sum(latinoaux), by(gtmsa)
gen latino2001=latinomsa/aux3

gen latino6_34w=latino*pwsswgt if prtage<35 & prtage>5 
egen latino6_34msa=sum(latino6_34w), by(gtmsa)
gen latino6_34_2001=latino6_34msa/aux33aaa

gen latino35_54w=latino*pwsswgt if prtage<55 & prtage>34
egen latino35_54msa=sum(latino35_54w), by(gtmsa)
gen latino35_54_2001=latino35_54msa/aux66aaa

gen latino55plusw=latino*pwsswgt if prtage>=55 
egen latino44plusmsa=sum(latino55plusw), by(gtmsa)
gen latino55plus2001=latino44plusmsa/aux99aaa

gen black=0
replace black=1 if perace==2

gen blackaux=black*pwsswgt
egen blackmsa=sum(blackaux), by(gtmsa)
gen black2001=blackmsa/aux3

gen black6_34w=black*pwsswgt if prtage<35 & prtage>5 
egen black6_34msa=sum(black6_34w), by(gtmsa)
gen black6_34_2001=black6_34msa/aux33aaa

gen black35_54w=black*pwsswgt if prtage<55 & prtage>34
egen black35_54msa=sum(black35_54w), by(gtmsa)
gen black35_54_2001=black35_54msa/aux66aaa

gen black55plusw=black*pwsswgt if prtage>=55 
egen black44plusmsa=sum(black55plusw), by(gtmsa)
gen black55plus2001=black44plusmsa/aux99aaa

preserve
keep incomedolarspercap gtmsa prtage
gen income6_34=incomedolarspercap if prtage<35 & prtage>5 
gen income35_54=incomedolarspercap if prtage<55 & prtage>=35 
gen income55plus=incomedolarspercap if prtage>=55 
rename incomedolarspercap incomedolarspercap2001
rename income6_34 incomedolarspercap634_2001
rename income35_54 incomedolarspercap3554_2001
rename income55plus incomedolarspercap55plus_2001
drop prtage
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\incomepercapitaresubmit2001.dta", replace
restore

collapse numberofobservations2001 black2001 black6_34_2001 black35_54_2001 black55plus2001 latino2001 latino6_34_2001 latino35_54_2001 latino55plus2001 educ55plus2001 educ35_54_2001 educ6_34_2001 internetuse55plusperson2001 internetuse35_54person2001 internetuse6_34person2001 income2001 internetuse2001 educ2001, by(gtmsa)
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\september2001cpsfinal.dta", replace

clear

insheet using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\oct2003cps.asc", double
merge using "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\latino2003.dta"
*dropped if hrhhid1==. in latino2003.asc" 
count if  hrhhid~=hrhhid1

*algunos pocos repetidos*

drop if gtmsa==0

*to do it by person we need to use pes11a to pes11j*
gen aux1=0
replace aux1=1 if hesint1==1
gen aux2=aux1*pwsswgt
egen aux3=sum(pwsswgt), by(gtmsa)
egen aux4=sum(aux2), by(gtmsa)
gen internetuse2003=aux4/aux3

gen incomedolars=2500 if hufaminc==1
replace incomedolars=6250 if hufaminc==2
replace incomedolars=8750 if hufaminc==3
replace incomedolars=11250 if hufaminc==4
replace incomedolars=13750 if hufaminc==5
replace incomedolars=17500 if hufaminc==6
replace incomedolars=22500 if hufaminc==7
replace incomedolars=27500 if hufaminc==8
replace incomedolars=32500 if hufaminc==9
replace incomedolars=37500 if hufaminc==10
replace incomedolars=45000 if hufaminc==11
replace incomedolars=55000 if hufaminc==12
replace incomedolars=67500 if hufaminc==13
replace incomedolars=87500 if hufaminc==14 
replace incomedolars=125000 if hufaminc==15
replace incomedolars=175000 if hufaminc==16 



gen incomew=incomedolars*pwsswgt
egen incomewmsa=sum(incomew), by(gtmsa)
gen income2003=incomewmsa/aux3

egen numberofpeopleinhh=max(occurnum), by(hrhhid)
gen incomedolarspercap=incomedolars/numberofpeopleinhh


gen educw=preduca5*pwsswgt if preduca5~=0
egen educmsa=sum(educw), by(gtmsa)
gen educ2003=educmsa/aux3

*pew*
gen aux1pewg1=0 if prtage<30 & prtage>17
replace aux1pewg1=1 if prtage<30 & prtage>17 & prnet2==1
gen aux2pewg1=aux1pewg1*pwsswgt
egen aux3pewg1=sum(aux2pewg1)if prtage<30 & prtage>17
egen aux4pewg1=sum(pwsswgt) if prtage<30 & prtage>17
gen pewg1= aux3pewg1/aux4pewg1
sum pewg1

gen aux1pewg2=0 if prtage<50 & prtage>29
replace aux1pewg2=1 if prtage<50 & prtage>29 & prnet2==1
gen aux2pewg2=aux1pewg2*pwsswgt
egen aux3pewg2=sum(aux2pewg2)if prtage<50 & prtage>29
egen aux4pewg2=sum(pwsswgt) if prtage<50 & prtage>29
gen pewg2= aux3pewg2/aux4pewg2
sum pewg2

gen aux1pewg3=0 if prtage<65 & prtage>49
replace aux1pewg3=1 if prtage<65 & prtage>49 & prnet2==1
gen aux2pewg3=aux1pewg3*pwsswgt
egen aux3pewg3=sum(aux2pewg3)if prtage<65 & prtage>49
egen aux4pewg3=sum(pwsswgt) if prtage<65 & prtage>49
gen pewg3= aux3pewg3/aux4pewg3
sum pewg3

gen aux1pewg4=0 if prtage>64
replace aux1pewg4=1 if prtage>64 & prnet2==1
gen aux2pewg4=aux1pewg4*pwsswgt
egen aux3pewg4=sum(aux2pewg4)if prtage>64
egen aux4pewg4=sum(pwsswgt) if prtage>64
gen pewg4= aux3pewg4/aux4pewg4
sum pewg4
*pew fin*



gen aux22=0 if prtage<35 & prtage>5
replace aux22=1 if prtage<35 & prtage>5 & prnet2==1
gen aux222=aux22*pwsswgt
gen weight35=pwsswgt if prtage<35 & prtage>5
egen aux33=sum(weight35), by(gtmsa)
egen aux44=sum(aux222), by(gtmsa)
gen internetuse6_34person2003=aux44/aux33

gen aux55=0 if prtage>=35 & prtage<55
replace aux55=1 if prtage>=35 & prtage<55 & prnet2==1
gen aux555=aux55*pwsswgt
gen weight35_54=pwsswgt if prtage>=35 & prtage<55
egen aux66=sum(weight35_54), by(gtmsa)
egen aux77=sum(aux555), by(gtmsa)
gen internetuse35_54person2003=aux77/aux66

gen aux88=0 if  prtage>=55
replace aux88=1 if prtage>=55 & prnet2==1
gen aux888=aux88*pwsswgt
gen weight55plus=pwsswgt if prtage>=55
egen aux99=sum(weight55plus), by(gtmsa)
egen aux999=sum(aux888), by(gtmsa)
gen internetuse55plusperson2003=aux999/aux99

gen weight35a=pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen aux33a=sum(weight35a), by(gtmsa)
gen weight35_54a=pwsswgt if prtage>=35 & prtage<55 & preduca5~=0
egen aux66a=sum(weight35_54a), by(gtmsa)
gen weight55plusa=pwsswgt if prtage>=55 & preduca5~=0
egen aux99a=sum(weight55plusa), by(gtmsa)


gen educ6_34w=preduca5*pwsswgt if prtage<35 & prtage>5 & preduca5~=0
egen educ6_34msa=sum(educ6_34w), by(gtmsa)
gen educ6_34_2003=educ6_34msa/aux33a

gen educ35_54w=preduca5*pwsswgt if prtage<55 & prtage>34 & preduca5~=0
egen educ35_54msa=sum(educ35_54w), by(gtmsa)
gen educ35_54_2003=educ35_54msa/aux66a

gen educ55plusw=preduca5*pwsswgt if prtage>=55 & preduca5~=0
egen educ44plusmsa=sum(educ55plusw), by(gtmsa)
gen educ55plus2003=educ44plusmsa/aux99a



gen a=1
egen numberofobservations2003=sum(a), by(gtmsa) 

gen weight35aa=pwsswgt if prtage<35 & prtage>5 
egen aux33aaa=sum(weight35aa), by(gtmsa)
gen weight35_54aa=pwsswgt if prtage>=35 & prtage<55 
egen aux66aaa=sum(weight35_54aa), by(gtmsa)
gen weight55plusaa=pwsswgt if prtage>=55 
egen aux99aaa=sum(weight55plusaa), by(gtmsa)


gen latino=0
replace latino=1 if pehspnon==1
gen latinoaux=latino*pwsswgt
egen latinomsa=sum(latinoaux), by(gtmsa)
gen latino2003=latinomsa/aux3

gen latino6_34w=latino*pwsswgt if prtage<35 & prtage>5 
egen latino6_34msa=sum(latino6_34w), by(gtmsa)
gen latino6_34_2003=latino6_34msa/aux33aaa

gen latino35_54w=latino*pwsswgt if prtage<55 & prtage>34
egen latino35_54msa=sum(latino35_54w), by(gtmsa)
gen latino35_54_2003=latino35_54msa/aux66aaa

gen latino55plusw=latino*pwsswgt if prtage>=55 
egen latino44plusmsa=sum(latino55plusw), by(gtmsa)
gen latino55plus2003=latino44plusmsa/aux99aaa

gen black=0
replace black=1 if ptdtrace==2

gen blackaux=black*pwsswgt
egen blackmsa=sum(blackaux), by(gtmsa)
gen black2003=blackmsa/aux3

gen black6_34w=black*pwsswgt if prtage<35 & prtage>5 
egen black6_34msa=sum(black6_34w), by(gtmsa)
gen black6_34_2003=black6_34msa/aux33aaa

gen black35_54w=black*pwsswgt if prtage<55 & prtage>34
egen black35_54msa=sum(black35_54w), by(gtmsa)
gen black35_54_2003=black35_54msa/aux66aaa

gen black55plusw=black*pwsswgt if prtage>=55 
egen black44plusmsa=sum(black55plusw), by(gtmsa)
gen black55plus2003=black44plusmsa/aux99aaa

preserve
keep incomedolarspercap gtmsa prtage
gen income6_34=incomedolarspercap if prtage<35 & prtage>5 
gen income35_54=incomedolarspercap if prtage<55 & prtage>=35 
gen income55plus=incomedolarspercap if prtage>=55 
rename incomedolarspercap incomedolarspercap2003
rename income6_34 incomedolarspercap634_2003
rename income35_54 incomedolarspercap3554_2003
rename income55plus incomedolarspercap55plus_2003
drop prtage
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\incomepercapitaresubmit2003.dta", replace
restore

collapse black2003 black6_34_2003 black35_54_2003 black55plus2003 latino2003 latino6_34_2003 latino35_54_2003 latino55plus2003 numberofobservations2003 educ55plus2003 educ35_54_2003 educ6_34_2003 internetuse55plusperson2003 internetuse35_54person2003 internetuse6_34person2003 income2003 internetuse2003 educ2003, by(gtmsa)
save "C:\Documents and Settings\axz051000\My Documents\guale2009\stan\cps\restatonline\october2003cpsfinal.dta", replace

clear
