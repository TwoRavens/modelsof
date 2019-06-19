global path "u:\user3\klp27\Blau and Kahn\Immigration"
set mem 4g
set more off

foreach type in Immigrant Native {
  use "$path\Census 1980 `type' data", clear

  *Allocate average wage among topcoded values to all topcoded wage values
  gen wsinc=incwage
  replace wsinc=1.45*75000 if wsinc>=75000 & wsinc<.

  gen spwsinc=spincwage
  replace spwsinc=1.45*75000 if spwsinc>=75000 & spwsinc<.

  *Adjust non-wage inc to take account of top- and bottom-coding (and use 1990 top code)
  replace incinvst=1.45*40000 if incinvst>=40000 & incinvst<.
  replace spincinvst=1.45*40000 if spincinvst>=40000 & spincinvst<.
  replace incinvst=1.45*(-9990) if incinvst==-9995
  replace spincinvst=1.45*(-9990) if spincinvst==-9995

  *Juhn and Murphy's dependent variable
  gen emprate=wkswork1/52
  gen spemprate=spwkswork1/52

  *Annual hours dependent variable
  gen annhours=wkswork1*uhrswork
  gen spannhours=spwkswork1*spuhrswork

  *Indicator for worked last year
  gen worked=.
  replace worked=0 if uhrswork==0
  replace worked=1 if uhrswork>0
  gen spworked=0
  replace spworked=0 if spuhrswork==0
  replace spworked=1 if spuhrswork>0

  *Transform nominal values in real (2000) values
  for var wsinc incwage inctot incinvst spwsinc spincwage spinctot spincinvst: replace X=X/0.47059

  gen wage=wsinc/(wkswork1*uhrswork)
  gen lnw=ln(wsinc/(wkswork1*uhrswork))
  gen spwage=spwsinc/(spwkswork1*spuhrswork)
  gen splnw=ln(spwsinc/(spwkswork1*spuhrswork))
  *gen nonwageinc=(fintval+fdivval+frntval)/1000
  gen ownnonwageinc=incinvst/1000
  gen spownnonwageinc=spincinvst/1000

  *drop if age>54 | spage>54
  *drop if age<25 | spage<25

  gen str5 agegrp="Other"
  replace agegrp="18-24" if age>=18 & age<=24
  replace agegrp="25-34" if age>=25 & age<=34
  replace agegrp="35-44" if age>=35 & age<=44
  replace agegrp="45-54" if age>=45 & age<=54
  replace agegrp="55-65" if age>=55 & age<=65

  gen str5 spagegrp="Other"
  replace spagegrp="18-24" if spage>=18 & spage<=24
  replace spagegrp="25-34" if spage>=25 & spage<=34
  replace spagegrp="35-44" if spage>=35 & spage<=44
  replace spagegrp="45-54" if spage>=45 & spage<=54
  replace spagegrp="55-65" if spage>=55 & spage<=65

  egen majregion=group(region)
/*
rename metro metrod
gen metro=0
replace metro=1 if metrod>=2 & metrod<=4
*/
  gen gradecomp=.
  replace gradecomp=0 if higraded<40
  replace gradecomp=1 if higraded>=40&higraded<=42
  replace gradecomp=2 if higraded>=50&higraded<=52
  replace gradecomp=3 if higraded>=60&higraded<=62
  replace gradecomp=4 if higraded>=70&higraded<=72
  replace gradecomp=5 if higraded>=80&higraded<=82
  replace gradecomp=6 if higraded>=90&higraded<=92
  replace gradecomp=7 if higraded>=100&higraded<=102
  replace gradecomp=8 if higraded>=110&higraded<=112
  replace gradecomp=9 if higraded>=120&higraded<=122
  replace gradecomp=10 if higraded>=130&higraded<=132
  replace gradecomp=11 if higraded>=140&higraded<=142
  replace gradecomp=12 if higraded>=150&higraded<=152
  replace gradecomp=13 if higraded>=160&higraded<=162
  replace gradecomp=14 if higraded>=170&higraded<=172
  replace gradecomp=15 if higraded>=180&higraded<=182
  replace gradecomp=16 if higraded>=190&higraded<=192
  replace gradecomp=17 if higraded>=200&higraded<=202
  replace gradecomp=18 if higraded>=210&higraded<=212
  replace gradecomp=19 if higraded>=220&higraded<=222
  replace gradecomp=20 if higraded==230

  gen educgrp=.
  replace educgrp=1 if gradecomp>=0  & gradecomp<=11
  replace educgrp=2 if gradecomp==12
  replace educgrp=3 if gradecomp>=13 & gradecomp<=15
  replace educgrp=4 if gradecomp>=16 & gradecomp<=20
  label define educgrp 1 "Grade 11 or less" 2 "Grade 12" 3 "Some college" 4 "College graduate"
  label values educgrp educgrp

  gen spgradecomp=.
  replace spgradecomp=0 if sphigraded<40
  replace spgradecomp=1 if sphigraded>=40&sphigraded<=42
  replace spgradecomp=2 if sphigraded>=50&sphigraded<=52
  replace spgradecomp=3 if sphigraded>=60&sphigraded<=62
  replace spgradecomp=4 if sphigraded>=70&sphigraded<=72
  replace spgradecomp=5 if sphigraded>=80&sphigraded<=82
  replace spgradecomp=6 if sphigraded>=90&sphigraded<=92
  replace spgradecomp=7 if sphigraded>=100&sphigraded<=102
  replace spgradecomp=8 if sphigraded>=110&sphigraded<=112
  replace spgradecomp=9 if sphigraded>=120&sphigraded<=122
  replace spgradecomp=10 if sphigraded>=130&sphigraded<=132
  replace spgradecomp=11 if sphigraded>=140&sphigraded<=142
  replace spgradecomp=12 if sphigraded>=150&sphigraded<=152
  replace spgradecomp=13 if sphigraded>=160&sphigraded<=162
  replace spgradecomp=14 if sphigraded>=170&sphigraded<=172
  replace spgradecomp=15 if sphigraded>=180&sphigraded<=182
  replace spgradecomp=16 if sphigraded>=190&sphigraded<=192
  replace spgradecomp=17 if sphigraded>=200&sphigraded<=202
  replace spgradecomp=18 if sphigraded>=210&sphigraded<=212
  replace spgradecomp=19 if sphigraded>=220&sphigraded<=222
  replace spgradecomp=20 if sphigraded==230

  gen speducgrp=.
  replace speducgrp=1 if spgradecomp>=0  & spgradecomp<=11
  replace speducgrp=2 if spgradecomp==12
  replace speducgrp=3 if spgradecomp>=13 & spgradecomp<=15
  replace speducgrp=4 if spgradecomp>=16 & spgradecomp<=20
  label define speducgrp 0 "Other" 1 "Grade 11 or less" 2 "Grade 12" 3 "Some college" 4 "College graduate"
  label values speducgrp speducgrp

  gen spanish=.
  replace spanish=0 if hispan==0
  replace spanish=1 if hispan>0 & hispan~=.
  label define spanish 0 "Not Spanish origin" 1 "Spanish origin"
  label values spanish spanish

  gen spspanish=.
  replace spspanish=0 if sphispan==0
  replace spspanish=1 if sphispan>0 & sphispan~=.
  label define spspanish 0 "Not Spanish origin" 1 "Spanish origin"
  label values spspanish spspanish

  gen racegrp=.
  *One major race group
  replace racegrp=1 if raced>=100 & raced<200
  replace racegrp=2 if raced>=200 & raced<300
  replace racegrp=3 if raced>=400 & raced<700
  replace racegrp=4 if (raced>=300 & raced<400) | raced==700
  *Two major race groups
  replace racegrp=2 if raced==801 | (raced>=830 & raced<=845)
  replace racegrp=3 if (raced>=810 & raced<=825) | (raced>=850 & raced<=855) | (raced>=860 & raced<=892)
  replace racegrp=4 if raced==802 | raced==826 | raced==856
  *Three major race groups
  replace racegrp=2 if (raced>=901 & raced<=904) | (raced>=930 & raced<=935)
  replace racegrp=3 if (raced>=905 & raced<=906) | (raced>=910 & raced<=925) | (raced>=940 & raced<=943)
  replace racegrp=4 if raced==907
  *Four major race groups
  replace racegrp=2 if (raced>=950 & raced<=955) | (raced>=970 & raced<=973)
  replace racegrp=3 if (raced>=960 & raced<=963) | raced==974
  *Five major race groups
  replace racegrp=2 if (raced>=980 & raced<=983) | raced==985
  replace racegrp=3 if raced==984
  *Six major race groups
  replace racegrp=2 if raced==990
  label define racegrp 1 "White" 2 "Black" 3 "Asian" 4 "Other race"
  label values racegrp racegrp

  gen mixedrace=.
  replace mixedrace=0 if raced<801
  replace mixedrace=1 if raced>=801 & raced~=.

  gen spracegrp=.
  *One major race group
  replace spracegrp=1 if spraced>=100 & spraced<200
  replace spracegrp=2 if spraced>=200 & spraced<300
  replace spracegrp=3 if spraced>=400 & spraced<700
  replace spracegrp=4 if (spraced>=300 & spraced<400) | spraced==700
  *Two major race groups
  replace spracegrp=2 if spraced==801 | (spraced>=830 & spraced<=845)
  replace spracegrp=3 if (spraced>=810 & spraced<=825) | (spraced>=850 & spraced<=855) | (spraced>=860 & spraced<=892)
  replace spracegrp=4 if spraced==802 | spraced==826 | spraced==856
  *Three major race groups
  replace spracegrp=2 if (spraced>=901 & spraced<=904) | (spraced>=930 & spraced<=935)
  replace spracegrp=3 if (spraced>=905 & spraced<=906) | (spraced>=910 & spraced<=925) | (spraced>=940 & spraced<=943)
  replace spracegrp=4 if spraced==907
  *Four major race groups
  replace spracegrp=2 if (spraced>=950 & spraced<=955) | (spraced>=970 & spraced<=973)
  replace spracegrp=3 if (spraced>=960 & spraced<=963) | spraced==974
  *Five major race groups
  replace spracegrp=2 if (spraced>=980 & spraced<=983) | spraced==985
  replace spracegrp=3 if spraced==984
  *Six major race groups
  replace spracegrp=2 if spraced==990
  label define spracegrp 1 "White" 2 "Black" 3 "Asian" 4 "Other race"
  label values spracegrp spracegrp

  gen spmixedrace=.
  replace spmixedrace=0 if spraced<801
  replace spmixedrace=1 if spraced>=801 & spraced~=.

  gen black=.
  replace black=0 if racegrp~=.
  replace black=1 if racegrp==2
  gen asian=.
  replace asian=0 if racegrp~=.
  replace asian=1 if racegrp==3
  gen othrace=.
  replace othrace=0 if racegrp~=.
  replace othrace=1 if racegrp==4
  gen spblack=.
  replace spblack=0 if spracegrp~=.
  replace spblack=1 if spracegrp==2
  gen spasian=.
  replace spasian=0 if spracegrp~=.
  replace spasian=1 if spracegrp==3
  gen spothrace=.
  replace spothrace=0 if spracegrp~=.
  replace spothrace=1 if spracegrp==4

  gen racehisp=.
  replace racehisp=1 if racegrp==1 & spanish==0
  replace racehisp=2 if racegrp==2 & spanish==0
  replace racehisp=3 if spanish==1
  replace racehisp=4 if racegrp==3 & spanish==0
  replace racehisp=5 if racegrp==4 & spanish==0
  label define racehisp 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Hispanic (any race)" 4 "Asian non-Hispanic" 5 "Other non-Hispanic"
  label values racehisp racehisp

  gen spracehisp=.
  replace spracehisp=1 if spracegrp==1 & spspanish==0
  replace spracehisp=2 if spracegrp==2 & spspanish==0
  replace spracehisp=3 if spspanish==1
  replace spracehisp=4 if spracegrp==3 & spspanish==0
  replace spracehisp=5 if spracegrp==4 & spspanish==0
  label define spracehisp 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Hispanic (any race)" 4 "Asian non-Hispanic" 5 "Other non-Hispanic"
  label values spracehisp spracehisp

  gen nchildu18= nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchm6+ nchm7+ nchm8+ nchm9+ nchm10+ nchm11+ nchm12+ nchm13+ nchm14+ nchm15+ nchm16+ nchm17+ nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5+ nchf6+ nchf7+ nchf8+ nchf9+ nchf10 +nchf11+ nchf12+ nchf13+ nchf14+ nchf15+ nchf16+ nchf17
  gen nchildu6=nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5
  gen nchild617=nchildu18-nchildu6
  gen str23 childstatus="No children under 18"
  replace childstatus="Child under 6 only" if nchildu6>0 & nchildu6~=. & nchild617==0
  replace childstatus="Child btwn 6 and 17 only" if nchild617>0 & nchild617~=. & nchildu6==0
  replace childstatus="Child under 6 and btwn 6 and 17" if nchildu6>0 & nchildu6~=. & nchild617>0 & nchild617~=.

  tab educgrp, gen(educ)
  tab agegrp, gen(age)
  tab racehisp, gen(rhisp)

  tab speducgrp, gen(speduc)
  tab spagegrp, gen(spage)
  tab spracehisp, gen(sprhisp)
  tab majregion, gen(reg)

  gen child=.
  replace child=1 if childstatus=="No children under 18"
  replace child=2 if childstatus=="Child under 6 and btwn 6 and 17" | childstatus=="Child under 6 only"
  replace child=3 if childstatus=="Child btwn 6 and 17 only"
  label define child 1 "No children under 18" 2 "Child under 6" 3 "Child btwn 6 and 17 only"
  label values child child

  gen nochu18=.
  replace nochu18=0 if child~=.
  replace nochu18=1 if child==1
  gen chu6=.
  replace chu6=0 if child~=.
  replace chu6=1 if child==2
  gen ch617=.
  replace ch617=0 if child~=.
  replace ch617=1 if child==3

  save "$path\Census 1980 `type' Analysis data", replace
}

foreach type in Immigrant Native {
  use "$path\Census 1990 `type' data", clear

  *Allocate average wage among topcoded values to all topcoded wage values
  gen wsinc=incwage
  replace wsinc=1.45*140000 if wsinc>=140000 & wsinc<.

  gen spwsinc=spincwage
  replace spwsinc=1.45*140000 if spwsinc>=140000 & spwsinc<.

  *Adjust non-wage inc to take account of top- and bottom-coding
  replace incinvst=1.45*40000 if incinvst>=40000 & incinvst<.
  replace spincinvst=1.45*40000 if spincinvst>=40000 & spincinvst<.
  replace incinvst=1.45*(-9999) if incinvst==-9999
  replace spincinvst=1.45*(-9999) if spincinvst==-9999

  *Juhn and Murphy's dependent variable
  gen emprate=wkswork1/52
  gen spemprate=spwkswork1/52

  *Annual hours dependent variable
  gen annhours=wkswork1*uhrswork
  gen spannhours=spwkswork1*spuhrswork

  *Indicator for worked last year
  gen worked=.
  replace worked=0 if uhrswork==0
  replace worked=1 if uhrswork>0
  gen spworked=.
  replace spworked=0 if spuhrswork==0
  replace spworked=1 if spuhrswork>0

  *Transform nominal values in real (2000) values
  for var wsinc incwage inctot incinvst spwsinc spincwage spinctot spincinvst: replace X=X/0.76972

  gen wage=wsinc/(wkswork1*uhrswork)
  gen lnw=ln(wsinc/(wkswork1*uhrswork))
  gen spwage=spwsinc/(spwkswork1*spuhrswork)
  gen splnw=ln(spwsinc/(spwkswork1*spuhrswork))
  *gen nonwageinc=(fintval+fdivval+frntval)/1000
  gen ownnonwageinc=incinvst/1000
  gen spownnonwageinc=spincinvst/1000

  *drop if age>54 | spage>54
  *drop if age<25 | spage<25

  gen str5 agegrp="Other"
  replace agegrp="18-24" if age>=18 & age<=24
  replace agegrp="25-34" if age>=25 & age<=34
  replace agegrp="35-44" if age>=35 & age<=44
  replace agegrp="45-54" if age>=45 & age<=54
  replace agegrp="55-65" if age>=55 & age<=65

  gen str5 spagegrp="Other"
  replace spagegrp="18-24" if spage>=18 & spage<=24
  replace spagegrp="25-34" if spage>=25 & spage<=34
  replace spagegrp="35-44" if spage>=35 & spage<=44
  replace spagegrp="45-54" if spage>=45 & spage<=54
  replace spagegrp="55-65" if spage>=55 & spage<=65

  egen majregion=group(region)
/*
rename metro metrod
gen metro=0
replace metro=1 if metrod>=2 & metrod<=4
*/
  gen gradecomp=.
  replace gradecomp=0 if educ99==0|educ99==1|educ99==2|educ99==3
  replace gradecomp=2.5 if educ99==4
  replace gradecomp=6.5 if educ99==5
  replace gradecomp=9 if educ99==6
  replace gradecomp=10 if educ99==7
  replace gradecomp=11 if educ99==8
  replace gradecomp=12 if educ99==9|educ99==10
  replace gradecomp=13 if educ99==11
  replace gradecomp=14 if educ99==12|educ99==13
  replace gradecomp=16 if educ99==14
  replace gradecomp=18 if educ99==15|educ99==16|educ99==17

  gen educgrp=.
  replace educgrp=1 if gradecomp>=0  & gradecomp<=11
  replace educgrp=2 if gradecomp==12
  replace educgrp=3 if gradecomp>=13 & gradecomp<=15
  replace educgrp=4 if gradecomp>=16 & gradecomp<19
  label define educgrp 1 "Grade 11 or less" 2 "Grade 12" 3 "Some college" 4 "College graduate"
  label values educgrp educgrp

  gen spgradecomp=.
  replace spgradecomp=0 if speduc99==0|speduc99==1|speduc99==2|speduc99==3
  replace spgradecomp=2.5 if speduc99==4
  replace spgradecomp=6.5 if speduc99==5
  replace spgradecomp=9 if speduc99==6
  replace spgradecomp=10 if speduc99==7
  replace spgradecomp=11 if speduc99==8
  replace spgradecomp=12 if speduc99==9|speduc99==10
  replace spgradecomp=13 if speduc99==11
  replace spgradecomp=14 if speduc99==12|speduc99==13
  replace spgradecomp=16 if speduc99==14
  replace spgradecomp=18 if speduc99==15|speduc99==16|speduc99==17

  gen speducgrp=.
  replace speducgrp=1 if spgradecomp>=0  & spgradecomp<=11
  replace speducgrp=2 if spgradecomp==12
  replace speducgrp=3 if spgradecomp>=13 & spgradecomp<=15
  replace speducgrp=4 if spgradecomp>=16 & spgradecomp<19
  label define speducgrp 1 "Grade 11 or less" 2 "Grade 12" 3 "Some college" 4 "College graduate"
  label values speducgrp speducgrp

  gen spanish=.
  replace spanish=0 if hispan==0
  replace spanish=1 if hispan>0 & hispan~=.
  label define spanish 0 "Not Spanish origin" 1 "Spanish origin"
  label values spanish spanish

  gen spspanish=.
  replace spspanish=0 if sphispan==0
  replace spspanish=1 if sphispan>0 & sphispan~=.
  label define spspanish 0 "Not Spanish origin" 1 "Spanish origin"
  label values spspanish spspanish

  gen racegrp=.
  *One major race group
  replace racegrp=1 if raced>=100 & raced<200
  replace racegrp=2 if raced>=200 & raced<300
  replace racegrp=3 if raced>=400 & raced<700
  replace racegrp=4 if (raced>=300 & raced<400) | raced==700
  *Two major race groups
  replace racegrp=2 if raced==801 | (raced>=830 & raced<=845)
  replace racegrp=3 if (raced>=810 & raced<=825) | (raced>=850 & raced<=855) | (raced>=860 & raced<=892)
  replace racegrp=4 if raced==802 | raced==826 | raced==856
  *Three major race groups
  replace racegrp=2 if (raced>=901 & raced<=904) | (raced>=930 & raced<=935)
  replace racegrp=3 if (raced>=905 & raced<=906) | (raced>=910 & raced<=925) | (raced>=940 & raced<=943)
  replace racegrp=4 if raced==907
  *Four major race groups
  replace racegrp=2 if (raced>=950 & raced<=955) | (raced>=970 & raced<=973)
  replace racegrp=3 if (raced>=960 & raced<=963) | raced==974
  *Five major race groups
  replace racegrp=2 if (raced>=980 & raced<=983) | raced==985
  replace racegrp=3 if raced==984
  *Six major race groups
  replace racegrp=2 if raced==990
  label define racegrp 1 "White" 2 "Black" 3 "Asian" 4 "Other race"
  label values racegrp racegrp

  gen mixedrace=.
  replace mixedrace=0 if raced<801
  replace mixedrace=1 if raced>=801 & raced~=.

  gen spracegrp=.
  *One major race group
  replace spracegrp=1 if spraced>=100 & spraced<200
  replace spracegrp=2 if spraced>=200 & spraced<300
  replace spracegrp=3 if spraced>=400 & spraced<700
  replace spracegrp=4 if (spraced>=300 & spraced<400) | spraced==700
  *Two major race groups
  replace spracegrp=2 if spraced==801 | (spraced>=830 & spraced<=845)
  replace spracegrp=3 if (spraced>=810 & spraced<=825) | (spraced>=850 & spraced<=855) | (spraced>=860 & spraced<=892)
  replace spracegrp=4 if spraced==802 | spraced==826 | spraced==856
  *Three major race groups
  replace spracegrp=2 if (spraced>=901 & spraced<=904) | (spraced>=930 & spraced<=935)
  replace spracegrp=3 if (spraced>=905 & spraced<=906) | (spraced>=910 & spraced<=925) | (spraced>=940 & spraced<=943)
  replace spracegrp=4 if spraced==907
  *Four major race groups
  replace spracegrp=2 if (spraced>=950 & spraced<=955) | (spraced>=970 & spraced<=973)
  replace spracegrp=3 if (spraced>=960 & spraced<=963) | spraced==974
  *Five major race groups
  replace spracegrp=2 if (spraced>=980 & spraced<=983) | spraced==985
  replace spracegrp=3 if spraced==984
  *Six major race groups
  replace spracegrp=2 if spraced==990
  label define spracegrp 1 "White" 2 "Black" 3 "Asian" 4 "Other race"
  label values spracegrp spracegrp

  gen spmixedrace=.
  replace spmixedrace=0 if spraced<801
  replace spmixedrace=1 if spraced>=801 & spraced~=.

  gen black=.
  replace black=0 if racegrp~=.
  replace black=1 if racegrp==2
  gen asian=.
  replace asian=0 if racegrp~=.
  replace asian=1 if racegrp==3
  gen othrace=.
  replace othrace=0 if racegrp~=.
  replace othrace=1 if racegrp==4
  gen spblack=.
  replace spblack=0 if spracegrp~=.
  replace spblack=1 if spracegrp==2
  gen spasian=.
  replace spasian=0 if spracegrp~=.
  replace spasian=1 if spracegrp==3
  gen spothrace=.
  replace spothrace=0 if spracegrp~=.
  replace spothrace=1 if spracegrp==4

  gen racehisp=.
  replace racehisp=1 if racegrp==1 & spanish==0
  replace racehisp=2 if racegrp==2 & spanish==0
  replace racehisp=3 if spanish==1
  replace racehisp=4 if racegrp==3 & spanish==0
  replace racehisp=5 if racegrp==4 & spanish==0
  label define racehisp 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Hispanic (any race)" 4 "Asian non-Hispanic" 5 "Other non-Hispanic"
  label values racehisp racehisp

  gen spracehisp=.
  replace spracehisp=1 if spracegrp==1 & spspanish==0
  replace spracehisp=2 if spracegrp==2 & spspanish==0
  replace spracehisp=3 if spspanish==1
  replace spracehisp=4 if spracegrp==3 & spspanish==0
  replace spracehisp=5 if spracegrp==4 & spspanish==0
  label define spracehisp 0 "NA" 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Hispanic (any race)" 4 "Asian non-Hispanic" 5 "Other non-Hispanic"
  label values spracehisp spracehisp

  gen nchildu18= nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchm6+ nchm7+ nchm8+ nchm9+ nchm10+ nchm11+ nchm12+ nchm13+ nchm14+ nchm15+ nchm16+ nchm17+ nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5+ nchf6+ nchf7+ nchf8+ nchf9+ nchf10 +nchf11+ nchf12+ nchf13+ nchf14+ nchf15+ nchf16+ nchf17
  gen nchildu6=nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5
  gen nchild617=nchildu18-nchildu6
  gen str23 childstatus="No children under 18"
  replace childstatus="Child under 6 only" if nchildu6>0 & nchildu6~=. & nchild617==0
  replace childstatus="Child btwn 6 and 17 only" if nchild617>0 & nchild617~=. & nchildu6==0
  replace childstatus="Child under 6 and btwn 6 and 17" if nchildu6>0 & nchildu6~=. & nchild617>0 & nchild617~=.

  tab educgrp, gen(educ)
  tab agegrp, gen(age)
  tab racehisp, gen(rhisp)

  tab speducgrp, gen(speduc)
  tab spagegrp, gen(spage)
  tab spracehisp, gen(sprhisp)
  tab majregion, gen(reg)

  gen child=.
  replace child=1 if childstatus=="No children under 18"
  replace child=2 if childstatus=="Child under 6 and btwn 6 and 17" | childstatus=="Child under 6 only"
  replace child=3 if childstatus=="Child btwn 6 and 17 only"
  label define child 1 "No children under 18" 2 "Child under 6" 3 "Child btwn 6 and 17 only"
  label values child child

  gen nochu18=.
  replace nochu18=0 if child~=.
  replace nochu18=1 if child==1
  gen chu6=.
  replace chu6=0 if child~=.
  replace chu6=1 if child==2
  gen ch617=.
  replace ch617=0 if child~=.
  replace ch617=1 if child==3

  save "$path\Census 1990 `type' Analysis data", replace
}

foreach type in Immigrant Native {
  use "$path\Census 2000 `type' data", clear

  *Allocate average wage among topcoded values to all topcoded wage values
  gen wsinc=incwage
  replace wsinc=1.45*175000 if wsinc>=175000 & wsinc<.

  gen spwsinc=spincwage
  replace spwsinc=1.45*175000 if spwsinc>=175000 & spwsinc<.

  *Adjust non-wage inc to take account of top- and bottom-coding
  replace incinvst=1.45*50000 if incinvst>=50000 & incinvst<.
  replace spincinvst=1.45*50000 if spincinvst>=50000 & spincinvst<.
  replace incinvst=1.45*(-10000) if incinvst==-10000
  replace spincinvst=1.45*(-10000) if spincinvst==-10000

  *Juhn and Murphy's dependent variable
  gen emprate=wkswork1/52
  gen spemprate=spwkswork1/52

  *Annual hours dependent variable
  gen annhours=wkswork1*uhrswork
  gen spannhours=spwkswork1*spuhrswork

  *Indicator for worked last year
  gen worked=.
  replace worked=0 if uhrswork==0
  replace worked=1 if uhrswork>0
  gen spworked=.
  replace spworked=0 if spuhrswork==0
  replace spworked=1 if spuhrswork>0

  *Transform nominal values in real (2000) values
  for var wsinc incwage inctot incinvst spwsinc spincwage spinctot spincinvst: replace X=X/0.97575

  gen wage=wsinc/(wkswork1*uhrswork)
  gen lnw=ln(wsinc/(wkswork1*uhrswork))
  gen spwage=spwsinc/(spwkswork1*spuhrswork)
  gen splnw=ln(spwsinc/(spwkswork1*spuhrswork))
  *gen nonwageinc=(fintval+fdivval+frntval)/1000
  gen ownnonwageinc=incinvst/1000
  gen spownnonwageinc=spincinvst/1000

  *drop if age>54 | spage>54
  *drop if age<25 | spage<25

  gen str5 agegrp="Other"
  replace agegrp="18-24" if age>=18 & age<=24
  replace agegrp="25-34" if age>=25 & age<=34
  replace agegrp="35-44" if age>=35 & age<=44
  replace agegrp="45-54" if age>=45 & age<=54
  replace agegrp="55-65" if age>=55 & age<=65

  gen str5 spagegrp="Other"
  replace spagegrp="18-24" if spage>=18 & spage<=24
  replace spagegrp="25-34" if spage>=25 & spage<=34
  replace spagegrp="35-44" if spage>=35 & spage<=44
  replace spagegrp="45-54" if spage>=45 & spage<=54
  replace spagegrp="55-65" if spage>=55 & spage<=65

  egen majregion=group(region)

  rename metro metrod
  gen metro=.
  replace metro=0 if metrod~=.
  replace metro=1 if metrod>=2 & metrod<=4

  gen gradecomp=.
  replace gradecomp=0 if educ99==0|educ99==1|educ99==2|educ99==3
  replace gradecomp=2.5 if educ99==4
  replace gradecomp=6.5 if educ99==5
  replace gradecomp=9 if educ99==6
  replace gradecomp=10 if educ99==7
  replace gradecomp=11 if educ99==8
  replace gradecomp=12 if educ99==9|educ99==10
  replace gradecomp=13 if educ99==11
  replace gradecomp=14 if educ99==12|educ99==13
  replace gradecomp=16 if educ99==14
  replace gradecomp=18 if educ99==15|educ99==16|educ99==17

  gen educgrp=.
  replace educgrp=1 if gradecomp>=0  & gradecomp<=11
  replace educgrp=2 if gradecomp==12
  replace educgrp=3 if gradecomp>=13 & gradecomp<=15
  replace educgrp=4 if gradecomp>=16 & gradecomp<19
  label define educgrp 1 "Grade 11 or less" 2 "Grade 12" 3 "Some college" 4 "College graduate"
  label values educgrp educgrp

  gen spgradecomp=.
  replace spgradecomp=0 if speduc99==0|speduc99==1|speduc99==2|speduc99==3
  replace spgradecomp=2.5 if speduc99==4
  replace spgradecomp=6.5 if speduc99==5
  replace spgradecomp=9 if speduc99==6
  replace spgradecomp=10 if speduc99==7
  replace spgradecomp=11 if speduc99==8
  replace spgradecomp=12 if speduc99==9|speduc99==10
  replace spgradecomp=13 if speduc99==11
  replace spgradecomp=14 if speduc99==12|speduc99==13
  replace spgradecomp=16 if speduc99==14
  replace spgradecomp=18 if speduc99==15|speduc99==16|speduc99==17

  gen speducgrp=.
  replace speducgrp=1 if spgradecomp>=0  & spgradecomp<=11
  replace speducgrp=2 if spgradecomp==12
  replace speducgrp=3 if spgradecomp>=13 & spgradecomp<=15
  replace speducgrp=4 if spgradecomp>=16 & spgradecomp<19
  label define speducgrp 1 "Grade 11 or less" 2 "Grade 12" 3 "Some college" 4 "College graduate"
  label values speducgrp speducgrp

  gen spanish=.
  replace spanish=0 if hispan==0
  replace spanish=1 if hispan>0 & hispan~=.
  label define spanish 0 "Not Spanish origin" 1 "Spanish origin"
  label values spanish spanish

  gen spspanish=.
  replace spspanish=0 if sphispan==0
  replace spspanish=1 if sphispan>0 & sphispan~=.
  label define spspanish 0 "Not Spanish origin" 1 "Spanish origin"
  label values spspanish spspanish

  gen racegrp=.
  *One major race group
  replace racegrp=1 if raced>=100 & raced<200
  replace racegrp=2 if raced>=200 & raced<300
  replace racegrp=3 if raced>=400 & raced<700
  replace racegrp=4 if (raced>=300 & raced<400) | raced==700
  *Two major race groups
  replace racegrp=2 if raced==801 | (raced>=830 & raced<=845)
  replace racegrp=3 if (raced>=810 & raced<=825) | (raced>=850 & raced<=855) | (raced>=860 & raced<=892)
  replace racegrp=4 if raced==802 | raced==826 | raced==856
  *Three major race groups
  replace racegrp=2 if (raced>=901 & raced<=904) | (raced>=930 & raced<=935)
  replace racegrp=3 if (raced>=905 & raced<=906) | (raced>=910 & raced<=925) | (raced>=940 & raced<=943)
  replace racegrp=4 if raced==907
  *Four major race groups
  replace racegrp=2 if (raced>=950 & raced<=955) | (raced>=970 & raced<=973)
  replace racegrp=3 if (raced>=960 & raced<=963) | raced==974
  *Five major race groups
  replace racegrp=2 if (raced>=980 & raced<=983) | raced==985
  replace racegrp=3 if raced==984
  *Six major race groups
  replace racegrp=2 if raced==990
  label define racegrp 1 "White" 2 "Black" 3 "Asian" 4 "Other race"
  label values racegrp racegrp

  gen mixedrace=.
  replace mixedrace=0 if raced<801
  replace mixedrace=1 if raced>=801 & raced~=.

  gen spracegrp=.
  *One major race group
  replace spracegrp=1 if spraced>=100 & spraced<200
  replace spracegrp=2 if spraced>=200 & spraced<300
  replace spracegrp=3 if spraced>=400 & spraced<700
  replace spracegrp=4 if (spraced>=300 & spraced<400) | spraced==700
  *Two major race groups
  replace spracegrp=2 if spraced==801 | (spraced>=830 & spraced<=845)
  replace spracegrp=3 if (spraced>=810 & spraced<=825) | (spraced>=850 & spraced<=855) | (spraced>=860 & spraced<=892)
  replace spracegrp=4 if spraced==802 | spraced==826 | spraced==856
  *Three major race groups
  replace spracegrp=2 if (spraced>=901 & spraced<=904) | (spraced>=930 & spraced<=935)
  replace spracegrp=3 if (spraced>=905 & spraced<=906) | (spraced>=910 & spraced<=925) | (spraced>=940 & spraced<=943)
  replace spracegrp=4 if spraced==907
  *Four major race groups
  replace spracegrp=2 if (spraced>=950 & spraced<=955) | (spraced>=970 & spraced<=973)
  replace spracegrp=3 if (spraced>=960 & spraced<=963) | spraced==974
  *Five major race groups
  replace spracegrp=2 if (spraced>=980 & spraced<=983) | spraced==985
  replace spracegrp=3 if spraced==984
  *Six major race groups
  replace spracegrp=2 if spraced==990
  label define spracegrp 1 "White" 2 "Black" 3 "Asian" 4 "Other race"
  label values spracegrp spracegrp

  gen spmixedrace=.
  replace spmixedrace=0 if spraced<801
  replace spmixedrace=1 if spraced>=801 & spraced~=.

  gen black=.
  replace black=0 if racegrp~=.
  replace black=1 if racegrp==2
  gen asian=.
  replace asian=0 if racegrp~=.
  replace asian=1 if racegrp==3
  gen othrace=.
  replace othrace=0 if racegrp~=.
  replace othrace=1 if racegrp==4
  gen spblack=.
  replace spblack=0 if spracegrp~=.
  replace spblack=1 if spracegrp==2
  gen spasian=.
  replace spasian=0 if spracegrp~=.
  replace spasian=1 if spracegrp==3
  gen spothrace=.
  replace spothrace=0 if spracegrp~=.
  replace spothrace=1 if spracegrp==4

  gen racehisp=.
  replace racehisp=1 if racegrp==1 & spanish==0
  replace racehisp=2 if racegrp==2 & spanish==0
  replace racehisp=3 if spanish==1
  replace racehisp=4 if racegrp==3 & spanish==0
  replace racehisp=5 if racegrp==4 & spanish==0
  label define racehisp 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Hispanic (any race)" 4 "Asian non-Hispanic" 5 "Other non-Hispanic"
  label values racehisp racehisp

  gen spracehisp=.
  replace spracehisp=1 if spracegrp==1 & spspanish==0
  replace spracehisp=2 if spracegrp==2 & spspanish==0
  replace spracehisp=3 if spspanish==1
  replace spracehisp=4 if spracegrp==3 & spspanish==0
  replace spracehisp=5 if spracegrp==4 & spspanish==0
  label define spracehisp 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Hispanic (any race)" 4 "Asian non-Hispanic" 5 "Other non-Hispanic"
  label values spracehisp spracehisp

  gen nchildu18= nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchm6+ nchm7+ nchm8+ nchm9+ nchm10+ nchm11+ nchm12+ nchm13+ nchm14+ nchm15+ nchm16+ nchm17+ nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5+ nchf6+ nchf7+ nchf8+ nchf9+ nchf10 +nchf11+ nchf12+ nchf13+ nchf14+ nchf15+ nchf16+ nchf17
  gen nchildu6=nchm0+ nchm1+ nchm2+ nchm3+ nchm4+ nchm5+ nchf0+ nchf1+ nchf2+ nchf3+ nchf4+ nchf5
  gen nchild617=nchildu18-nchildu6
  gen str23 childstatus="No children under 18"
  replace childstatus="Child under 6 only" if nchildu6>0 & nchildu6~=. & nchild617==0
  replace childstatus="Child btwn 6 and 17 only" if nchild617>0 & nchild617~=. & nchildu6==0
  replace childstatus="Child under 6 and btwn 6 and 17" if nchildu6>0 & nchildu6~=. & nchild617>0 & nchild617~=.

  tab educgrp, gen(educ)
  tab agegrp, gen(age)
  tab racehisp, gen(rhisp)

  tab speducgrp, gen(speduc)
  tab spagegrp, gen(spage)
  tab spracehisp, gen(sprhisp)
  tab majregion, gen(reg)

  gen child=.
  replace child=1 if childstatus=="No children under 18"
  replace child=2 if childstatus=="Child under 6 and btwn 6 and 17" | childstatus=="Child under 6 only"
  replace child=3 if childstatus=="Child btwn 6 and 17 only"
  label define child 1 "No children under 18" 2 "Child under 6" 3 "Child btwn 6 and 17 only"
  label values child child

  gen nochu18=.
  replace nochu18=0 if child~=.
  replace nochu18=1 if child==1
  gen chu6=.
  replace chu6=0 if child~=.
  replace chu6=1 if child==2
  gen ch617=.
  replace ch617=0 if child~=.
  replace ch617=1 if child==3

  save "$path\Census 2000 `type' Analysis data", replace
}

*Combine immigrant and native files and add some extra labels
use "$path\Census 1980 Immigrant Analysis data", clear
append using "$path\Census 1980 Native Analysis data"
drop sample

forvalues i=0/18 {
  label var nchm`i' "Number of own male children in household aged `i'"
  label var nchf`i' "Number of own female children in household aged `i'"
}
label var nchm19plus "Number of own male children in household aged 19 or older"
label var nchf19plus "Number of own female children in household aged 19 or older"

label var occmo "Occupation code (Meyer and Osborne)"
label var immigrant "Immigrant dummy"
label var ysm "Years since migration (using Census-specific intervals)"
label var ysm1 "Years since migration (using consistent intervals)"
label var yrimmig1 "Year of immigration (4-digit years)"
label var impre50 "Immigrant arrived prior to 1950"
label var im5059 "Immigrant arrived between 1950 and 1959"
label var im6064 "Immigrant arrived between 1960 and 1964"
label var im6569 "Immigrant arrived between 1965 and 1969"
label var im7074 "Immigrant arrived between 1970 and 1974"
label var im7579 "Immigrant arrived between 1975 and 1979"
label var im8084 "Immigrant arrived between 1980 and 1984"
label var im8590 "Immigrant arrived between 1985 and 1990"
label var im9194 "Immigrant arrived between 1991 and 1994"
label var im9500 "Immigrant arrived between 1995 and 2000"
label var yrimmig2 "Year used to match arrival country characteristics"
label var censusratecurr "Census/(Illegal+legal immigrants)"
label var illegalratecurr "Illegal immigrant/Census rate"
foreach suf in arr curr {
  label var proprefug`suf' "Refugee/immigrant ratio"
  label var emigratetot`suf' "Total emigration rate"
  label var emigratem`suf' "Male emigration rate"
  label var emigratef`suf' "Female emigration rate"
}

label var spoccmo "Occupation code (Meyer and Osborne)"
label var spimmigrant "Immigrant dummy"
label var spysm "Years since migration (using Census-specific intervals)"
label var spysm1 "Years since migration (using consistent intervals)"
label var spyrimmig1 "Year of immigration (4-digit years)"
label var spimpre50 "Immigrant arrived prior to 1950"
label var spim5059 "Immigrant arrived between 1950 and 1959"
label var spim6064 "Immigrant arrived between 1960 and 1964"
label var spim6569 "Immigrant arrived between 1965 and 1969"
label var spim7074 "Immigrant arrived between 1970 and 1974"
label var spim7579 "Immigrant arrived between 1975 and 1979"
label var spim8084 "Immigrant arrived between 1980 and 1984"
label var spim8590 "Immigrant arrived between 1985 and 1990"
label var spim9194 "Immigrant arrived between 1991 and 1994"
label var spim9500 "Immigrant arrived between 1995 and 2000"
label var spyrimmig2 "Year used to match arrival country characteristics"
label var spcensusratecurr "Census/(Illegal+legal immigrants)"
label var spillegalratecurr "Illegal immigrant/Census rate"
foreach suf in arr curr {
  label var spproprefug`suf' "Refugee/immigrant ratio"
  label var spemigratetot`suf' "Total emigration rate"
  label var spemigratem`suf' "Male emigration rate"
  label var spemigratef`suf' "Female emigration rate"
}

save "$path\Census 1980 Analysis data", replace

use "$path\Census 1990 Immigrant Analysis data", clear
append using "$path\Census 1990 Native Analysis data"
drop sample

forvalues i=0/18 {
  label var nchm`i' "Number of own male children in household aged `i'"
  label var nchf`i' "Number of own female children in household aged `i'"
}
label var nchm19plus "Number of own male children in household aged 19 or older"
label var nchf19plus "Number of own female children in household aged 19 or older"

label var occmo "Occupation code (Meyer and Osborne)"
label var immigrant "Immigrant dummy"
label var ysm "Years since migration (using Census-specific intervals)"
label var ysm1 "Years since migration (using consistent intervals)"
label var yrimmig1 "Year of immigration (4-digit years)"
label var impre50 "Immigrant arrived prior to 1950"
label var im5059 "Immigrant arrived between 1950 and 1959"
label var im6064 "Immigrant arrived between 1960 and 1964"
label var im6569 "Immigrant arrived between 1965 and 1969"
label var im7074 "Immigrant arrived between 1970 and 1974"
label var im7579 "Immigrant arrived between 1975 and 1979"
label var im8084 "Immigrant arrived between 1980 and 1984"
label var im8590 "Immigrant arrived between 1985 and 1990"
label var im9194 "Immigrant arrived between 1991 and 1994"
label var im9500 "Immigrant arrived between 1995 and 2000"
label var yrimmig2 "Year used to match arrival country characteristics"
label var censusratecurr "Census/(Illegal+legal immigrants)"
label var illegalratecurr "Illegal immigrant/Census rate"
foreach suf in arr curr {
  label var proprefug`suf' "Refugee/immigrant ratio"
  label var emigratetot`suf' "Total emigration rate"
  label var emigratem`suf' "Male emigration rate"
  label var emigratef`suf' "Female emigration rate"
}

label var spoccmo "Occupation code (Meyer and Osborne)"
label var spimmigrant "Immigrant dummy"
label var spysm "Years since migration (using Census-specific intervals)"
label var spysm1 "Years since migration (using consistent intervals)"
label var spyrimmig1 "Year of immigration (4-digit years)"
label var spimpre50 "Immigrant arrived prior to 1950"
label var spim5059 "Immigrant arrived between 1950 and 1959"
label var spim6064 "Immigrant arrived between 1960 and 1964"
label var spim6569 "Immigrant arrived between 1965 and 1969"
label var spim7074 "Immigrant arrived between 1970 and 1974"
label var spim7579 "Immigrant arrived between 1975 and 1979"
label var spim8084 "Immigrant arrived between 1980 and 1984"
label var spim8590 "Immigrant arrived between 1985 and 1990"
label var spim9194 "Immigrant arrived between 1991 and 1994"
label var spim9500 "Immigrant arrived between 1995 and 2000"
label var spyrimmig2 "Year used to match arrival country characteristics"
label var spcensusratecurr "Census/(Illegal+legal immigrants)"
label var spillegalratecurr "Illegal immigrant/Census rate"
foreach suf in arr curr {
  label var spproprefug`suf' "Refugee/immigrant ratio"
  label var spemigratetot`suf' "Total emigration rate"
  label var spemigratem`suf' "Male emigration rate"
  label var spemigratef`suf' "Female emigration rate"
}

save "$path\Census 1990 Analysis data", replace

use "$path\Census 2000 Immigrant Analysis data", clear
append using "$path\Census 2000 Native Analysis data"
drop sample

forvalues i=0/18 {
  label var nchm`i' "Number of own male children in household aged `i'"
  label var nchf`i' "Number of own female children in household aged `i'"
}
label var nchm19plus "Number of own male children in household aged 19 or older"
label var nchf19plus "Number of own female children in household aged 19 or older"

label var occmo "Occupation code (Meyer and Osborne)"
label var immigrant "Immigrant dummy"
label var ysm "Years since migration (using Census-specific intervals)"
label var ysm1 "Years since migration (using consistent intervals)"
label var yrimmig1 "Year of immigration (4-digit years)"
label var impre50 "Immigrant arrived prior to 1950"
label var im5059 "Immigrant arrived between 1950 and 1959"
label var im6064 "Immigrant arrived between 1960 and 1964"
label var im6569 "Immigrant arrived between 1965 and 1969"
label var im7074 "Immigrant arrived between 1970 and 1974"
label var im7579 "Immigrant arrived between 1975 and 1979"
label var im8084 "Immigrant arrived between 1980 and 1984"
label var im8590 "Immigrant arrived between 1985 and 1990"
label var im9194 "Immigrant arrived between 1991 and 1994"
label var im9500 "Immigrant arrived between 1995 and 2000"
label var yrimmig2 "Year used to match arrival country characteristics"
label var censusratecurr "Census/(Illegal+legal immigrants)"
label var illegalratecurr "Illegal immigrant/Census rate"
foreach suf in arr curr {
  label var proprefug`suf' "Refugee/immigrant ratio"
  label var emigratetot`suf' "Total emigration rate"
  label var emigratem`suf' "Male emigration rate"
  label var emigratef`suf' "Female emigration rate"
}

label var spoccmo "Occupation code (Meyer and Osborne)"
label var spimmigrant "Immigrant dummy"
label var spysm "Years since migration (using Census-specific intervals)"
label var spysm1 "Years since migration (using consistent intervals)"
label var spyrimmig1 "Year of immigration (4-digit years)"
label var spimpre50 "Immigrant arrived prior to 1950"
label var spim5059 "Immigrant arrived between 1950 and 1959"
label var spim6064 "Immigrant arrived between 1960 and 1964"
label var spim6569 "Immigrant arrived between 1965 and 1969"
label var spim7074 "Immigrant arrived between 1970 and 1974"
label var spim7579 "Immigrant arrived between 1975 and 1979"
label var spim8084 "Immigrant arrived between 1980 and 1984"
label var spim8590 "Immigrant arrived between 1985 and 1990"
label var spim9194 "Immigrant arrived between 1991 and 1994"
label var spim9500 "Immigrant arrived between 1995 and 2000"
label var spyrimmig2 "Year used to match arrival country characteristics"
label var spcensusratecurr "Census/(Illegal+legal immigrants)"
label var spillegalratecurr "Illegal immigrant/Census rate"
foreach suf in arr curr {
  label var spproprefug`suf' "Refugee/immigrant ratio"
  label var spemigratetot`suf' "Total emigration rate"
  label var spemigratem`suf' "Male emigration rate"
  label var spemigratef`suf' "Female emigration rate"
}

save "$path\Census 2000 Analysis data", replace

erase "$path\Census 1980 Immigrant Analysis data.dta"
erase "$path\Census 1980 Native Analysis data.dta"
erase "$path\Census 1990 Immigrant Analysis data.dta"
erase "$path\Census 1990 Native Analysis data.dta"
erase "$path\Census 2000 Immigrant Analysis data.dta"
erase "$path\Census 2000 Native Analysis data.dta"

*Create weights for each country by year
foreach year of numlist 1980 1990 2000 {
  use "$path\Census `year' Analysis data", clear
  gen legalhrs=(quhrswor==0 & qwkswork==0)
  gen splegalhrs=(spquhrswor==0 & spqwkswork==0)
  gen legalimm=(qbpl==0 & qyrimm==0)
  gen splegalimm=(spqbpl==0 & spqyrimm==0)
  *The following two vars are created to exclude those countries with no male or no female immigrants in any year
  gen misctry=0
  gen spmisctry=0
  foreach i of numlist 52300 30035 40200 42300 43500 50020 50030 51000 52120 52300 53000 53800 53900 54300 {
    replace misctry=1 if final_code==`i'
    replace spmisctry=1 if spfinal_code==`i'
  }
  preserve
  collapse (sum) perwt if immigrant==1 & sex==2 & legalhrs==1 & legalimm==1 & misctry==0, by(final_code)
  rename perwt fctrywgt`year'
  sort final_code
  save "$path\Census `year' female country weights", replace
  restore
  preserve
  collapse (sum) spperwt if spimmigrant==1 & spsex==1 & splegalhrs==1 & splegalimm==1 & spmisctry==0, by(spfinal_code)
  rename spperwt mctrywgt`year'
  rename spfinal_code final_code
  sort final_code
  save "$path\Census `year' male country weights", replace
  restore
  preserve
  collapse (sum) perwt if immigrant==1 & sex==2 & legalhrs==1 & legalimm==1 & misctry==0 & ysm1==2.5, by(final_code)
  rename perwt frecctrywgt`year'
  sort final_code
  save "$path\Census `year' recent female country weights", replace
  restore
  collapse (sum) spperwt if spimmigrant==1 & spsex==1 & splegalhrs==1 & spmisctry==0 & splegalimm==1 & spysm1==2.5, by(spfinal_code)
  rename spperwt mrecctrywgt`year'
  rename spfinal_code final_code
  sort final_code
  save "$path\Census `year' recent male country weights", replace

  use "$path\Census `year' female country weights", clear
  merge final_code using "$path\Census `year' male country weights"
  drop _merge
  sort final_code
  merge final_code using "$path\Census `year' recent female country weights"
  drop _merge
  sort final_code
  merge final_code using "$path\Census `year' recent male country weights"
  drop _merge
  sort final_code
  foreach var of varlist fctrywgt`year' mctrywgt`year' frecctrywgt`year' mrecctrywgt`year' {
    replace `var'=0 if `var'==.
  }
  save "$path\Census `year' country weights", replace

  erase "$path\Census `year' female country weights.dta"
  erase "$path\Census `year' male country weights.dta"
  erase "$path\Census `year' recent female country weights.dta"
  erase "$path\Census `year' recent male country weights.dta"
}

foreach year of numlist 1980 1990 2000 {
  use "$path\Census `year' Analysis data", clear

  sort final_code
  merge final_code using "$path\Census 1980 country weights"
  tab _merge
  drop _merge
  sort final_code
  merge final_code using "$path\Census 1990 country weights"
  tab _merge
  drop _merge
  sort final_code
  merge final_code using "$path\Census 2000 country weights"
  tab _merge
  drop _merge

  foreach var of varlist fctrywgt`year' mctrywgt`year' frecctrywgt`year' mrecctrywgt`year' {
    replace `var'=. if immigrant==0
  }

  foreach num of numlist 10000 15000 16010 16020 16040 20000 21010 21020 21030 21040 21050 21060 21070 25000 26010 26020 26030 26043 26044 26060 30005 30010 30015 30020 30025 30030 30035 30040 30045 30050 30060 30065 40100 40200 40300 40500 41000 41400 42000 42100 42200 42300 42500 43000 43100 43300 43330 43400 43500 43600 45000 45100 45200 45300 45400 45500 45600 46000 50000 50010 50020 50030 50040 50100 50200 51000 51100 51200 51300 51400 51500 51600 51700 51800 52000 52100 52110 52120 52130 52140 52150 52200 52300 52400 53000 53100 53200 53400 53410 53600 53700 53800 53900 54000 54100 54200 54300 54400 60000 60011 60012 60014 60015 60023 60027 60031 60032 60033 60044 60045 60053 60054 60055 60057 60072 60094 70010 70020 71000 71021 {
    foreach var of varlist fctrywgt`year' mctrywgt`year' frecctrywgt`year' mrecctrywgt`year' {
      replace `var'=0 if immigrant==1 & final_code==`num' & `var'==.
    }
  }

  save "$path\Census `year' Analysis data", replace
}

foreach year of numlist 1980 1990 2000 {
  use "$path\Census `year' country weights", clear
  foreach var of varlist * {
    rename `var' sp`var'
    save "$path\Census `year' country weights (men)", replace
  }
}

foreach year of numlist 1980 1990 2000 {
  use "$path\Census `year' Analysis data", clear

  sort spfinal_code
  merge spfinal_code using "$path\Census 1980 country weights (men)"
  tab _merge
  drop _merge
  sort spfinal_code
  merge spfinal_code using "$path\Census 1990 country weights (men)"
  tab _merge
  drop _merge
  sort spfinal_code
  merge spfinal_code using "$path\Census 2000 country weights (men)"
  tab _merge
  drop _merge

  foreach var of varlist spfctrywgt`year' spmctrywgt`year' spfrecctrywgt`year' spmrecctrywgt`year' {
    replace `var'=. if spimmigrant==0
  }

  foreach num of numlist 10000 15000 16010 16020 16040 20000 21010 21020 21030 21040 21050 21060 21070 25000 26010 26020 26030 26043 26044 26060 30005 30010 30015 30020 30025 30030 30035 30040 30045 30050 30060 30065 40100 40200 40300 40500 41000 41400 42000 42100 42200 42300 42500 43000 43100 43300 43330 43400 43500 43600 45000 45100 45200 45300 45400 45500 45600 46000 50000 50010 50020 50030 50040 50100 50200 51000 51100 51200 51300 51400 51500 51600 51700 51800 52000 52100 52110 52120 52130 52140 52150 52200 52300 52400 53000 53100 53200 53400 53410 53600 53700 53800 53900 54000 54100 54200 54300 54400 60000 60011 60012 60014 60015 60023 60027 60031 60032 60033 60044 60045 60053 60054 60055 60057 60072 60094 70010 70020 71000 71021 {
    foreach var of varlist spfctrywgt`year' spmctrywgt`year' spfrecctrywgt`year' spmrecctrywgt`year' {
      replace `var'=0 if spimmigrant==1 & spfinal_code==`num' & `var'==.
    }
  }

  save "$path\Census `year' Analysis data", replace
}

foreach year of numlist 1980 1990 2000 {
  erase "$path\Census `year' country weights (men).dta"
}
