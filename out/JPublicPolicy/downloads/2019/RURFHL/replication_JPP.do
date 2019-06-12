
****Table 2: Descriptive statistics 

summarize age if Rep==1 & groupIDfull!=., detail
summarize age if groupIDfull == 1 & Rep==1, detail
summarize age if groupIDfull == 2 & Rep==1, detail
summarize age if groupIDfull == 3 & Rep==1, detail
summarize age if groupIDfull == 4 & Rep==1, detail
summarize age if groupIDfull == 5 & Rep==1, detail
summarize age if groupIDfull == 6 & Rep==1, detail
summarize age if groupIDfull == 7 & Rep==1, detail
summarize age if groupIDfull == 8 & Rep==1, detail

summarize Black Hispanic female college if Rep==1 & groupIDfull!=.
summarize Black Hispanic female college if groupIDfull == 1 & Rep==1
summarize Black Hispanic female college if groupIDfull == 2 & Rep==1
summarize Black Hispanic female college if groupIDfull == 3 & Rep==1
summarize Black Hispanic female college if groupIDfull == 4 & Rep==1
summarize Black Hispanic female college if groupIDfull == 5 & Rep==1
summarize Black Hispanic female college if groupIDfull == 6 & Rep==1
summarize Black Hispanic female college if groupIDfull == 7 & Rep==1
summarize Black Hispanic female college if groupIDfull == 8 & Rep==1

****Table 3: Descriptive statistics

summarize age if Dem==1 & groupIDfull!=., detail
summarize age if groupIDfull == 1 & Dem==1, detail
summarize age if groupIDfull == 2 & Dem==1, detail
summarize age if groupIDfull == 3 & Dem==1, detail
summarize age if groupIDfull == 4 & Dem==1, detail
summarize age if groupIDfull == 5 & Dem==1, detail
summarize age if groupIDfull == 6 & Dem==1, detail
summarize age if groupIDfull == 7 & Dem==1, detail
summarize age if groupIDfull == 8 & Dem==1, detail

summarize Black Hispanic female college if Dem==1 & groupIDfull!=.
summarize Black Hispanic female college if groupIDfull == 1 & Dem==1
summarize Black Hispanic female college if groupIDfull == 2 & Dem==1
summarize Black Hispanic female college if groupIDfull == 3 & Dem==1
summarize Black Hispanic female college if groupIDfull == 4 & Dem==1
summarize Black Hispanic female college if groupIDfull == 5 & Dem==1
summarize Black Hispanic female college if groupIDfull == 6 & Dem==1
summarize Black Hispanic female college if groupIDfull == 7 & Dem==1
summarize Black Hispanic female college if groupIDfull == 8 & Dem==1


****Appendix Table 2

ologit samepartyCOMMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if dod==1 
ologit samepartyCOMMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if hhs==1 
ologit samepartyMEMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if dod==1 
ologit samepartyMEMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if hhs==1

****Figures 3 and 4

#delimit;
 margins, at(treatid=(0 1) Rep=(0 1) Black=0 Hispanic=0 female=1 age=35
 postgrad=0 somepostgrad=0 collegeonly=1 somecollege=0)
  post ;
  
  lincom  _b[2._at#1._predict] - _b[1._at#1._predict]
  lincom  _b[2._at#2._predict] - _b[1._at#2._predict]
  lincom  _b[2._at#3._predict] - _b[1._at#3._predict]
  lincom  _b[2._at#4._predict] - _b[1._at#4._predict]
  lincom  _b[2._at#5._predict] - _b[1._at#5._predict]

  lincom  _b[4._at#1._predict] - _b[3._at#1._predict]
  lincom  _b[4._at#2._predict] - _b[3._at#2._predict]
  lincom  _b[4._at#3._predict] - _b[3._at#3._predict]
  lincom  _b[4._at#4._predict] - _b[3._at#4._predict]
  lincom  _b[4._at#5._predict] - _b[3._at#5._predict]
  
  lincom (_b[2._at#1._predict] - _b[1._at#1._predict]) - (_b[4._at#1._predict] - _b[3._at#1._predict])
  lincom (_b[2._at#2._predict] - _b[1._at#2._predict]) - (_b[4._at#2._predict] - _b[3._at#2._predict])
  lincom (_b[2._at#3._predict] - _b[1._at#3._predict]) - (_b[4._at#3._predict] - _b[3._at#3._predict])
  lincom (_b[2._at#4._predict] - _b[1._at#4._predict]) - (_b[4._at#4._predict] - _b[3._at#4._predict])
  lincom (_b[2._at#5._predict] - _b[1._at#5._predict]) - (_b[4._at#5._predict] - _b[3._at#5._predict])
	 
	
****Appendix Table 4

ologit samepartyCOMMapp treatid##dod somecollege collegeonly somepostgrad postgrad age female Black Hispanic if Rep==1 
ologit samepartyMEMapp treatid##dod somecollege collegeonly somepostgrad postgrad age female Black Hispanic if Rep==1 
ologit samepartyCOMMapp treatid##dod somecollege collegeonly somepostgrad postgrad age female Black Hispanic if Dem==1
ologit samepartyMEMapp treatid##dod somecollege collegeonly somepostgrad postgrad age female Black Hispanic if Dem==1

#delimit;
 margins, at(treatid=(0 1) dod=(0 1) Black=0 Hispanic=0 female=1 age=35
 postgrad=0 somepostgrad=0 collegeonly=1 somecollege=0)
   post ;
 
  lincom (_b[3._at#1._predict] - _b[1._at#1._predict])
  lincom (_b[3._at#2._predict] - _b[1._at#2._predict])
  lincom (_b[3._at#3._predict] - _b[1._at#3._predict])
  lincom (_b[3._at#4._predict] - _b[1._at#4._predict])
  lincom (_b[3._at#5._predict] - _b[1._at#5._predict])
   
  lincom (_b[4._at#1._predict] - _b[2._at#1._predict])
  lincom (_b[4._at#2._predict] - _b[2._at#2._predict])
  lincom (_b[4._at#3._predict] - _b[2._at#3._predict])
  lincom (_b[4._at#4._predict] - _b[2._at#4._predict])
  lincom (_b[4._at#5._predict] - _b[2._at#5._predict])
   
  lincom (_b[3._at#1._predict] - _b[1._at#1._predict]) - (_b[4._at#1._predict] - _b[2._at#1._predict])
  lincom (_b[3._at#2._predict] - _b[1._at#2._predict]) - (_b[4._at#2._predict] - _b[2._at#2._predict])
  lincom (_b[3._at#3._predict] - _b[1._at#3._predict]) - (_b[4._at#3._predict] - _b[2._at#3._predict])
  lincom (_b[3._at#4._predict] - _b[1._at#4._predict]) - (_b[4._at#4._predict] - _b[2._at#4._predict])
  lincom (_b[3._at#5._predict] - _b[1._at#5._predict]) - (_b[4._at#5._predict] - _b[2._at#5._predict])
 
  
****Appendix Table 3

ologit diffpartyCOMMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if dod==1 
ologit diffpartyCOMMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if hhs==1 
ologit diffpartyMEMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if dod==1 
ologit diffpartyMEMapp Rep##i.treatid somecollege collegeonly somepostgrad postgrad age female Black Hispanic if hhs==1 

****Figures 5 and 6

#delimit;
 margins, at(treatid=(0 1) Rep=(0 1) Black=0 Hispanic=0 female=1 age=35
 postgrad=0 somepostgrad=0 collegeonly=1 somecollege=0)
   post;
      
  lincom  _b[2._at#1._predict] - _b[1._at#1._predict]
  lincom  _b[2._at#2._predict] - _b[1._at#2._predict]
  lincom  _b[2._at#3._predict] - _b[1._at#3._predict]
  lincom  _b[2._at#4._predict] - _b[1._at#4._predict]
  lincom  _b[2._at#5._predict] - _b[1._at#5._predict]

  lincom  _b[4._at#1._predict] - _b[3._at#1._predict]
  lincom  _b[4._at#2._predict] - _b[3._at#2._predict]
  lincom  _b[4._at#3._predict] - _b[3._at#3._predict]
  lincom  _b[4._at#4._predict] - _b[3._at#4._predict]
  lincom  _b[4._at#5._predict] - _b[3._at#5._predict]

  lincom (_b[2._at#1._predict] - _b[1._at#1._predict]) - (_b[4._at#1._predict] - _b[3._at#1._predict])
  lincom (_b[2._at#2._predict] - _b[1._at#2._predict]) - (_b[4._at#2._predict] - _b[3._at#2._predict])
  lincom (_b[2._at#3._predict] - _b[1._at#3._predict]) - (_b[4._at#3._predict] - _b[3._at#3._predict])
  lincom (_b[2._at#4._predict] - _b[1._at#4._predict]) - (_b[4._at#4._predict] - _b[3._at#4._predict])
  lincom (_b[2._at#5._predict] - _b[1._at#5._predict]) - (_b[4._at#5._predict] - _b[3._at#5._predict])
 

****Statistical tests Tables 2 and 3

anova age i.groupIDfull if Dem == 1 
anova age i.groupIDfull if Rep == 1 

tab Black groupIDfull if Dem == 1, chi2
tab Black groupIDfull if Rep == 1, chi2

regress Black i.groupIDfull if Dem == 1
regress Black i.groupIDfull if Rep == 1

tab Hispanic groupIDfull if Dem == 1, chi2
tab Hispanic groupIDfull if Rep == 1, chi2

regress Hispanic i.groupIDfull if Dem == 1
regress Hispanic i.groupIDfull if Rep == 1

tab female groupIDfull if Dem == 1, chi2
tab female groupIDfull if Rep == 1, chi2

regress female i.groupIDfull if Dem == 1
regress female i.groupIDfull if Rep == 1

tab college groupIDfull if Dem == 1, chi2
tab college groupIDfull if Rep == 1, chi2

regress college i.groupIDfull if Dem == 1
regress college i.groupIDfull if Rep == 1

prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==2, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest college if Dem==1 & groupIDfull==7 | Dem==1 & groupIDfull==8, by(groupIDfull)

prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==2, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest college if Rep==1 & groupIDfull==7 | Rep==1 & groupIDfull==8, by(groupIDfull)


prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==2, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Dem==1 & groupIDfull==7 | Dem==1 & groupIDfull==8, by(groupIDfull)


prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==2, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Black if Rep==1 & groupIDfull==7 | Rep==1 & groupIDfull==8, by(groupIDfull)


prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==2, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Dem==1 & groupIDfull==7 | Dem==1 & groupIDfull==8, by(groupIDfull)


prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==2, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest Hispanic if Rep==1 & groupIDfull==7 | Rep==1 & groupIDfull==8, by(groupIDfull)


prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==2, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==3, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==4, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==5, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==6, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==7, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==8, by(groupIDfull)
prtest female if Dem==1 & groupIDfull==7 | Dem==1 & groupIDfull==8, by(groupIDfull)


prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==2, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==3, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==4, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==5, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==6, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==7, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==8, by(groupIDfull)
prtest female if Rep==1 & groupIDfull==7 | Rep==1 & groupIDfull==8, by(groupIDfull)


ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==2, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==3, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==4, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==5, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==6, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==7, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==1 | Dem==1 & groupIDfull==8, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==3, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==4, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==5, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==6, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==7, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==2 | Dem==1 & groupIDfull==8, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==4, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==5, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==6, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==7, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==3 | Dem==1 & groupIDfull==8, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==5, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==6, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==7, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==4 | Dem==1 & groupIDfull==8, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==6, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==7, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==5 | Dem==1 & groupIDfull==8, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==7, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==6 | Dem==1 & groupIDfull==8, by(groupIDfull)
ttest age if Dem==1 & groupIDfull==7 | Dem==1 & groupIDfull==8, by(groupIDfull)


ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==2, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==3, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==4, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==5, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==6, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==7, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==1 | Rep==1 & groupIDfull==8, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==3, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==4, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==5, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==6, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==7, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==2 | Rep==1 & groupIDfull==8, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==4, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==5, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==6, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==7, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==3 | Rep==1 & groupIDfull==8, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==5, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==6, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==7, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==4 | Rep==1 & groupIDfull==8, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==6, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==7, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==5 | Rep==1 & groupIDfull==8, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==7, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==6 | Rep==1 & groupIDfull==8, by(groupIDfull)
ttest age if Rep==1 & groupIDfull==7 | Rep==1 & groupIDfull==8, by(groupIDfull)

