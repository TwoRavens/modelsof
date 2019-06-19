clear
use ${Output}/MainFile if status<3
save ${Output}/MainFile_PR , replace
/****************************************************************/
/* Variables for basic information about kids and the household */
/****************************************************************/

gen Age=lh12y
gen AgeSq=Age^2
replace AgeSq=0.1*AgeSq

generate AgeUnder25=(Age<25)
generate AgeUnder30=(Age<30)
generate AgeUnder35=(Age<35)
generate Age15to20=(Age>=15 & Age<20)
generate Age25to30=(Age>=25 & Age<30)
generate Age30to35=(Age>=30 & Age<35)
generate Age35to40=(Age>=35 & Age<40)
generate Age40to45=(Age>=40 & Age<45)
generate Age45to50=(Age>=45 & Age<50)
generate Age50to55=(Age>=50 & Age<55)
generate Age55to60=(Age>=55 & Age<60)
generate Age60to65=(Age>=60 & Age<65)
generate Age65Over=(Age>=65)
generate AgeOver50=(Age>=50)
generate AgeOver55=(Age>=55)
generate AgeOver60=(Age>=60)
generate AgeOver40=(Age>=40)

generate Age20to30=(Age>=20 & Age<30)
generate Age30to40=(Age>=30 & Age<40)
generate Age40to50=(Age>=40 & Age<50)
generate Age30to50=(Age>=30 & Age<50)

generate AgeUnder60=(Age<60)
generate AgeUnder20=(Age<20)
generate Muslim=(lh18a==1)

gen Female=1 if lh09==3
replace Female=0 if lh09==1

gen YearsEd=lh21 
replace YearsEd=ed07 if YearsEd==. 
replace YearsEd=ed08a if YearsEd==. 
replace YearsEd=. if YearsEd>30

generate EverAttd=1 if (lh20==4 | lh20==5)
replace EverAttd=0 if (lh20==1 | lh20==2 | lh20==3)
replace EverAttd=(lh26==1)
replace EverAttd=0 if lh26==3
replace EverAttd=1 if ed03==1
replace EverAttd=0 if ed03==3 

generate NoEd=(EverAttd==0)
replace NoEd=. if EverAttd==.

replace YearsEd=0 if EverAttd==0 

generate AttdReligSch=(lh20==2 | lh20==3) 
replace AttdReligSch=. if lh20==. 

generate MoEverAttd=1 if (Molh20==4 | Molh20==5)
replace MoEverAttd=0 if Molh20==1 | Molh20==2 | Molh20==3
replace MoEverAttd=1 if Molh26==1
replace MoEverAttd=0 if Molh26==3
replace MoEverAttd=1 if Moed03==1
replace MoEverAttd=0 if Moed03>1 

generate FaEverAttd=1 if (Falh20==4 | Falh20==5)
replace FaEverAttd=0 if Falh20==1 | Falh20==2 | Falh20==3
replace FaEverAttd=1 if Falh26==1
replace FaEverAttd=0 if Falh26==3
replace FaEverAttd=1 if Faed03==1
replace FaEverAttd=0 if Faed03>1 

generate SpAge=Splh12y 
generate SpAgeSq=SpAge^2

generate SpAgeMissing=(SpAge==.)

generate SpEverAttd=1 if (Splh20==4 | Splh20==5)
replace SpEverAttd=0 if Splh20==1 | Splh20==2 | Splh20==3
replace SpEverAttd=1 if Splh26==1
replace SpEverAttd=0 if Splh26==3
replace SpEverAttd=1 if Sped03==1
replace SpEverAttd=0 if Sped03>1 

generate SpYrsEd=Splh21
replace SpYrsEd=0 if SpEverAttd==0
replace SpYrsEd=. if SpYrsEd==98 | SpYrsEd==99

generate SpEdMissing=(SpYrsEd==.)

generate MusXAttd=EverAttd*Muslim
generate MusXFaAttd=FaEverAttd*Muslim
generate MusXMoAttd=MoEverAttd*Muslim
generate MusXYearsEd=Muslim*YearsEd

generate FaAge=par04_f
replace FaAge=100 if par04_f>100 & par04_f<120
replace FaAge=. if par04_f>120
replace FaAge=FaAgeR if FaAge==.


generate FaYrsSch=par06_f
replace FaYrsSch=0 if par05_f==1  
replace FaYrsSch=. if FaYrsSch>90
replace FaYrsSch=0 if FaEverAttd==0 & FaYrsSch==.
replace FaYrsSch=. if FaYrsSch>18

generate FaYrsSchSq=FaYrsSch^2

replace FaEverAttd=1 if FaYrsSch>0

generate MoYrsSch=par06_m
replace MoYrsSch=0 if par05_m==1  
replace MoYrsSch=. if MoYrsSch>90
replace MoYrsSch=0 if MoEverAttd==0 & MoYrsSch==.

generate FaNoEd=(FaYrsSch==0)
replace FaNoEd=. if FaEverAttd==. 
generate FaPrimSch=(FaYrsSch>0&FaYrsSch<5)
replace FaPrimSch=. if FaYrsSch==. 
generate FaSecSch=(FaYrsSch>=5 & FaYrsSch<=10)
replace FaSecSch=. if FaYrsSch==. 
generate FaPostSecSch=(FaYrsSch>10)
replace FaPostSecSch=. if FaYrsSch==. 

generate MusXFaYrsSch=Muslim*FaYrsSch

generate SpFaYrsSch=Sppar06_f
replace SpFaYrsSch=0 if Sppar05_f==1  
generate SpMoYrsSch=Sppar06_m
replace SpMoYrsSch=0 if Sppar05_m==1  
replace SpFaYrsSch=. if SpFaYrsSch>90
replace SpMoYrsSch=. if SpMoYrsSch>90

generate SpFaEverAttdSch=(Sppar05_f==1)
replace  SpFaEverAttdSch=. if  Sppar05_f==.

replace SpFaYrsSch=SpFaEverAttd if SpFaYrsSch==. & SpFaEverAttd~=.

generate FaEdGap=FaYrsSch-SpFaYrsSch

generate FaOwnFL=(par15a_f==1)  
generate MoOwnFL=(par15a_m==1)  

generate FaOwnHSL=(par15b_f==1)  
generate MoOwnHSL=(par15b_m==1)  

generate SpFaOwnFL=(Sppar15a_f==1)  
generate SpMoOwnFL=(Sppar15a_m==1)  

generate SpFaOwnHSL=(Sppar15b_f==1)  
generate SpMoOwnHSL=(Sppar15b_m==1)  

gen FaFarmland=.  
replace FaFarmland=0 if FaOwnFL~=1  
replace FaFarmland=par16a_f if par16u_f=="D"  
replace FaFarmland=160*par16a_f if par16u_f=="A"  
replace FaFarmland=80*par16a_f if par16u_f=="B"  
replace FaFarmland=33*par16a_f if par16u_f=="C"  
replace FaFarmland=1.65*par16a_f if par16u_f=="E"  
replace FaFarmland=30*par16a_f if par16u_f=="F"  
generate LFaFarmland=log(FaFarmland)
replace LFaFarmland=log(0.01) if FaFarmland==0
generate LFaFarmlandSq=LFaFarmland^2

gen MoFarmland=.  
replace MoFarmland=0 if MoOwnFL~=1  
replace MoFarmland=par16a_m if par16u_m=="D"  
replace MoFarmland=160*par16a_m if par16u_m=="A"  
replace MoFarmland=80*par16a_m if par16u_m=="B"  
replace MoFarmland=33*par16a_m if par16u_m=="C"  
replace MoFarmland=1.65*par16a_m if par16u_m=="E"  
replace MoFarmland=30*par16a_m if par16u_m=="F"  

generate ParFarmland=FaFarmland+MoFarmland
replace ParFarmland=FaFarmland if MoFarmland==.
replace ParFarmland=MoFarmland if FaFarmland==.
replace ParFarmland=0 if FaOwnFL==0 & ParFarmland==. 

generate ParFarmlandMissing=(ParFarmland==.)
quietly summarize ParFarmland
replace ParFarmland=r(mean) if ParFarmlandMissing==1

generate LParFarmland=log(ParFarmland)
replace LParFarmland=log(0.01) if ParFarmland==0
generate LParFarmlandSq=LParFarmland^2

generate FaAlFstMarr=(FirstMarrmh18==1)
generate MoAlFstMarr=(FirstMarrmh19==1)

generate FaAttdSch=par05_f>1 
generate MoAttdSch=par05_m>1 
generate SpFaAttdSch=Sppar05_f>1 
generate SpMoAttdSch=Sppar05_m>1 
generate ParAttdSch=(par05_f>1 | par05_m>1)

generate SpParAttdSch=(Sppar05_f>1 | Sppar05_m>1)

generate InheritFrFa=(par19a_m==1)
generate ExpInhFrFa=(par23_m==1)

generate InheritFrMo=(par19a_f==1)
generate ExpInhFrMo=(par23_f==1)

generate SpInheritFrFa=(Sppar19a_m==1)
generate SpExpInhFrFa=(Sppar23_m==1)

generate SpInheritFrMo=(Sppar19a_f==1)
generate SpExpInhFrMo=(Sppar23_f==1)

generate ParInherit=(InheritFrFa==1 | InheritFrMo==1)

generate FaInherit=(InheritFrFa==1 | ExpInhFrFa==1) 

generate FaInhVal=par21_f
generate MoInhVal=par21_m
replace FaInhVal=. if par21_f>=999997
replace MoInhVal=. if par21_m>=999997

generate ParInhVal=FaInhVal+MoInhVal
replace ParInhVal=0 if InheritFrFa==0 & InheritFrMo==0

generate str1 junk1=substr(par20_f,1,1)
generate str1 junk2=substr(par20_f,2,1)
generate str1 junk3=substr(par20_f,3,1)
generate str1 junk4=substr(par20_f,4,1)
generate str1 junk5=substr(par20_f,5,1)
generate str1 junk6=substr(par20_f,6,1)

generate str1 junk7=substr(par20_m,1,1)
generate str1 junk8=substr(par20_m,2,1)
generate str1 junk9=substr(par20_m,3,1)
generate str1 junk10=substr(par20_m,4,1)
generate str1 junk11=substr(par20_m,5,1)
generate str1 junk12=substr(par20_m,6,1)

generate InhHomestdLand=(junk1=="A" | junk2=="A" |  junk3=="A" |  junk4=="A" |  junk5=="A" |  junk6=="A" | junk7=="A" | junk8=="A" |  junk9=="A" |  junk10=="A" |  junk11=="A" |  junk12=="A")   
generate InhFarmLand=(junk1=="B" | junk2=="B" |  junk3=="B" |  junk4=="B" |  junk5=="B" |  junk6=="B" | junk7=="B" | junk8=="B" |  junk9=="B" |  junk10=="B" |  junk11=="B" |  junk12=="B")   
generate InhLivestock=(junk1=="C" | junk2=="C" |  junk3=="C" |  junk4=="C" |  junk5=="C" |  junk6=="C" | junk7=="C" | junk8=="C" |  junk9=="C" |  junk10=="C" |  junk11=="C" |  junk12=="C")    
generate InhJewelry=(junk1=="D" | junk2=="D" |  junk3=="D" |  junk4=="D" |  junk5=="D" |  junk6=="D" | junk7=="D" | junk8=="D" |  junk9=="D" |  junk10=="D" |  junk11=="D" |  junk12=="D")     
generate InhMoney=(junk1=="E" | junk2=="E" |  junk3=="E" |  junk4=="E" |  junk5=="E" |  junk6=="E" | junk7=="E" | junk8=="E" |  junk9=="E" |  junk10=="E" |  junk11=="E" |  junk12=="E")     
generate InhOther=(junk1=="F" | junk2=="F" |  junk3=="F" |  junk4=="F" |  junk5=="F" |  junk6=="F" | junk7=="F" | junk8=="F" |  junk9=="F" |  junk10=="F" |  junk11=="F" |  junk12=="F")      

generate InhLand=(InhHomestdLand==1 | InhFarmLand==1)

generate ParTransfer=(NParTransRec>0)
generate InhOrTrans=( InheritFrFa==1 | InheritFrMo==1 | NParTransRec>=1 | NSibTransRec>=1) 
drop junk*


/***********************************/
/* marriage variables */
/***********************************/

generate ParentsChose=(Basicmh03==1)

generate YearMarried=FirstMarrmh06y
replace YearMarried=. if FirstMarrmh06y>96
generate AgeMarried=FirstMarrmh07
replace AgeMarried=. if FirstMarrmh07>96
replace YearMarried=96-Age+AgeMarried if YearMarried==.
replace AgeMarried=. if Age<AgeMarried

generate SpAgeMarried=SpFirstMarrmh07 
generate SpYearMarried=96-SpAge+SpAgeMarried 

replace YearMarried=SpYearMarried if YearMarried==.

generate YrsMarried=96-YearMarried
replace YrsMarried=96-SpYearMarried if YearMarried==.

replace AgeMarried=Age-YrsMarried if AgeMarried==. 

generate YearMarrD=.
replace YearMarrD=1910 if (YearMarried>=10 & YearMarried<20)
replace YearMarrD=1920 if (YearMarried>=20 & YearMarried<30)
replace YearMarrD=1930 if (YearMarried>=30 & YearMarried<40)
replace YearMarrD=1940 if (YearMarried>=40 & YearMarried<50)
replace YearMarrD=1950 if (YearMarried>=50 & YearMarried<60)
replace YearMarrD=1960 if (YearMarried>=60 & YearMarried<70)
replace YearMarrD=1970 if (YearMarried>=70 & YearMarried<80)
replace YearMarrD=1980 if (YearMarried>=80 & YearMarried<90)
replace YearMarrD=1990 if (YearMarried>=90 & YearMarried<95)

generate YearMarrD5=.
replace YearMarrD5=1910 if (YearMarried>=10 & YearMarried<15)
replace YearMarrD5=1915 if (YearMarried>=15 & YearMarried<20)
replace YearMarrD5=1920 if (YearMarried>=20 & YearMarried<25)
replace YearMarrD5=1925 if (YearMarried>=25 & YearMarried<30)
replace YearMarrD5=1930 if (YearMarried>=30 & YearMarried<35)
replace YearMarrD5=1935 if (YearMarried>=35 & YearMarried<40)
replace YearMarrD5=1940 if (YearMarried>=40 & YearMarried<45)
replace YearMarrD5=1945 if (YearMarried>=45 & YearMarried<50)
replace YearMarrD5=1950 if (YearMarried>=50 & YearMarried<55)
replace YearMarrD5=1955 if (YearMarried>=55 & YearMarried<60)
replace YearMarrD5=1960 if (YearMarried>=60 & YearMarried<65)
replace YearMarrD5=1965 if (YearMarried>=65 & YearMarried<70)
replace YearMarrD5=1970 if (YearMarried>=70 & YearMarried<75)
replace YearMarrD5=1975 if (YearMarried>=75 & YearMarried<80)
replace YearMarrD5=1980 if (YearMarried>=80 & YearMarried<85)
replace YearMarrD5=1985 if (YearMarried>=85 & YearMarried<90)
replace YearMarrD5=1990 if (YearMarried>=90 & YearMarried<95)
replace YearMarrD5=1995 if (YearMarried>=95) 

generate YearMarrD2=.
replace YearMarrD2=1910 if (YearMarried>=10 & YearMarried<12)
replace YearMarrD2=1912 if (YearMarried>=12 & YearMarried<14)
replace YearMarrD2=1914 if (YearMarried>=14 & YearMarried<16)
replace YearMarrD2=1916 if (YearMarried>=16 & YearMarried<18)
replace YearMarrD2=1918 if (YearMarried>=18 & YearMarried<20)
replace YearMarrD2=1920 if (YearMarried>=20 & YearMarried<22)
replace YearMarrD2=1922 if (YearMarried>=22 & YearMarried<24)
replace YearMarrD2=1924 if (YearMarried>=24 & YearMarried<26)
replace YearMarrD2=1926 if (YearMarried>=26 & YearMarried<28)
replace YearMarrD2=1928 if (YearMarried>=28 & YearMarried<30)
replace YearMarrD2=1930 if (YearMarried>=30 & YearMarried<32)
replace YearMarrD2=1932 if (YearMarried>=32 & YearMarried<34)
replace YearMarrD2=1934 if (YearMarried>=34 & YearMarried<36)
replace YearMarrD2=1936 if (YearMarried>=36 & YearMarried<38)
replace YearMarrD2=1938 if (YearMarried>=38 & YearMarried<40)
replace YearMarrD2=1940 if (YearMarried>=40 & YearMarried<42)
replace YearMarrD2=1942 if (YearMarried>=42 & YearMarried<44)
replace YearMarrD2=1944 if (YearMarried>=44 & YearMarried<46)
replace YearMarrD2=1946 if (YearMarried>=46 & YearMarried<48)
replace YearMarrD2=1948 if (YearMarried>=48 & YearMarried<50)
replace YearMarrD2=1950 if (YearMarried>=50 & YearMarried<52)
replace YearMarrD2=1952 if (YearMarried>=52 & YearMarried<54)
replace YearMarrD2=1954 if (YearMarried>=54 & YearMarried<56)
replace YearMarrD2=1956 if (YearMarried>=56 & YearMarried<58)
replace YearMarrD2=1958 if (YearMarried>=58 & YearMarried<60)
replace YearMarrD2=1960 if (YearMarried>=60 & YearMarried<62)
replace YearMarrD2=1962 if (YearMarried>=62 & YearMarried<64)
replace YearMarrD2=1964 if (YearMarried>=64 & YearMarried<66)
replace YearMarrD2=1966 if (YearMarried>=66 & YearMarried<68)
replace YearMarrD2=1968 if (YearMarried>=68 & YearMarried<70)
replace YearMarrD2=1970 if (YearMarried>=70 & YearMarried<72)
replace YearMarrD2=1972 if (YearMarried>=72 & YearMarried<74)
replace YearMarrD2=1974 if (YearMarried>=74 & YearMarried<76)
replace YearMarrD2=1976 if (YearMarried>=76 & YearMarried<78)
replace YearMarrD2=1978 if (YearMarried>=78 & YearMarried<80)
replace YearMarrD2=1980 if (YearMarried>=80 & YearMarried<82)
replace YearMarrD2=1982 if (YearMarried>=82 & YearMarried<84)
replace YearMarrD2=1984 if (YearMarried>=84 & YearMarried<86)
replace YearMarrD2=1986 if (YearMarried>=86 & YearMarried<88)
replace YearMarrD2=1988 if (YearMarried>=88 & YearMarried<90)
replace YearMarrD2=1990 if (YearMarried>=90 & YearMarried<92)
replace YearMarrD2=1992 if (YearMarried>=92 & YearMarried<94)
replace YearMarrD2=1994 if (YearMarried>=94 & YearMarried<96)
replace YearMarrD2=1996 if (YearMarried>=96) 

generate DowryVal=0 if FirstMarrmh10a=="A"
replace DowryVal=FirstMarrmh10b if FirstMarrmh10a~="A"
replace DowryVal=. if DowryVal==999999999 | DowryVal==9 | DowryVal==99
replace DowryVal=. if DowryVal==99999 | DowryVal==99998 
replace DowryVal=0.0001*DowryVal

generate Dowry=(DowryVal>0)
replace Dowry=. if DowryVal==.

generate str1 dowry1=substr(FirstMarrmh10a,1,1)
generate str1 dowry2=substr(FirstMarrmh10a,2,1)
generate str1 dowry3=substr(FirstMarrmh10a,3,1)
generate str1 dowry4=substr(FirstMarrmh10a,4,1)
generate str1 dowry5=substr(FirstMarrmh10a,5,1)
generate str1 dowry6=substr(FirstMarrmh10a,6,1)
generate str1 dowry7=substr(FirstMarrmh10a,7,1)
generate str1 dowry8=substr(FirstMarrmh10a,8,1)
generate str1 dowry9=substr(FirstMarrmh10a,9,1)
generate DowryBW=(dowry1=="F" |dowry2=="F" |dowry3=="F" |dowry4=="F" |dowry5=="F" |dowry6=="F" |dowry7=="F" |dowry8=="F" |dowry9=="F") 
replace DowryBW=1 if dowry1=="G" |dowry2=="G" |dowry3=="G" |dowry4=="G" |dowry5=="G" |dowry6=="G" |dowry7=="G" |dowry8=="G" |dowry9=="G" 
replace DowryBW=0 if DowryVal==0 

generate DowryNBW=0 
replace DowryNBW=1 if dowry1=="B" |dowry2=="B" |dowry3=="B" |dowry4=="B" |dowry5=="B" |dowry6=="B" |dowry7=="B" |dowry8=="B" |dowry9=="B" 
replace DowryNBW=1 if dowry1=="C" |dowry2=="C" |dowry3=="C" |dowry4=="C" |dowry5=="C" |dowry6=="C" |dowry7=="C" |dowry8=="C" |dowry9=="C" 
replace DowryNBW=1 if dowry1=="D" |dowry2=="D" |dowry3=="D" |dowry4=="D" |dowry5=="D" |dowry6=="D" |dowry7=="D" |dowry8=="D" |dowry9=="D" 
replace DowryNBW=1 if dowry1=="E" |dowry2=="E" |dowry3=="E" |dowry4=="E" |dowry5=="E" |dowry6=="E" |dowry7=="E" |dowry8=="E" |dowry9=="E" 
replace DowryNBW=1 if dowry1=="H" |dowry2=="H" |dowry3=="H" |dowry4=="H" |dowry5=="H" |dowry6=="H" |dowry7=="H" |dowry8=="H" |dowry9=="H" 
replace DowryNBW=1 if dowry1=="I" |dowry2=="I" |dowry3=="I" |dowry4=="I" |dowry5=="I" |dowry6=="I" |dowry7=="I" |dowry8=="I" |dowry9=="I" 

generate LDowryVal=log(DowryVal)
replace LDowryVal=log(.1) if DowryVal==0

generate AgeUnd50=(Age<50)
generate DowryXAge50=Dowry*AgeUnd50
generate LDVXAge50=LDowryVal*AgeUnd50

generate DowryXAge=Dowry*Age
generate DowryXAgeSq=Dowry*AgeSq
generate LDVXAge=LDowryVal*Age
generate LDVXAgeSq=LDowryVal*AgeSq

generate FaAlive=(check_f=="Father(Alive)")
generate MoAlive=(check_m=="Mother(Alive)")

generate DowryXFaAlive=Dowry*FaAlive 
generate LDVXFaAlive=LDowryVal*FaAlive

gen MarrCousin=(FirstMarrmh08>=53 & FirstMarrmh08<=60)
replace MarrCousin=. if  FirstMarrmh08==99 | FirstMarrmh08==.

generate MarrRelative=(FirstMarrmh08~=78)
replace MarrRelative=. if FirstMarrmh08==99 | FirstMarrmh08==.
generate MarrRelative2=MarrRelative-MarrCousin
drop MarrRelative
rename MarrRelative2 MarrRelative

generate SameVillage=(FirstMarrmh09<=3)

generate MarrVillage=(SameVillage==1 & MarrRelative==0 & MarrCousin==0)

generate MarrCousXVill=SameVillage*MarrCousin

generate NumAdBroAtMarr=FirstMarrmh21
replace NumAdBroAtMarr=. if NumAdBroAtMarr>90

generate MusXNumAdBro=Muslim*NumAdBroAtMarr

rename mrh01 AgeMenarche
replace AgeMenarche=. if AgeMenarche>50

generate SibSR=MaleSibs/(FemaleSibs+1) if Female==1
replace SibSR=(MaleSibs+1)/FemaleSibs if Female==0

generate BirthOrder=OlderSibs+1

save ${Output}/MainFile_PR, replace

/* household information */
gen Farmland=.
replace Farmland=0 if lndfb01a~=1
replace Farmland=lndfb01t if lndfb01b=="D"
replace Farmland=160*lndfb01t if lndfb01b=="A"
replace Farmland=80*lndfb01t if lndfb01b=="B"
replace Farmland=33*lndfb01t if lndfb01b=="C"
replace Farmland=1.65*lndfb01t if lndfb01b=="E"
replace Farmland=30*lndfb01t if lndfb01b=="F"


generate LogFarmland=log(Farmland)
replace LogFarmland=log(.1) if Farmland==0

generate LogFarmlandSq=LogFarmland^2


replace Farmland=.01*Farmland
generate Farmlandsq=Farmland^2


generate YearWom10=(1996-Age)+10 if Female==1 
generate YearWom11=(1996-Age)+11 if Female==1 
generate YearWom12=(1996-Age)+12 if Female==1 
generate YearWom13=(1996-Age)+13 if Female==1 
generate YearWom14=(1996-Age)+14 if Female==1 
generate YearWom15=(1996-Age)+15 if Female==1 


generate YearMan16=(1996-Age)+16 if Female==0
generate YearMan17=(1996-Age)+17 if Female==0
generate YearMan18=(1996-Age)+18 if Female==0
generate YearMan19=(1996-Age)+19 if Female==0
generate YearMan20=(1996-Age)+20 if Female==0
generate YearMan21=(1996-Age)+21 if Female==0
generate YearMan22=(1996-Age)+22 if Female==0

save ${Output}\MainFile_PR, replace 





