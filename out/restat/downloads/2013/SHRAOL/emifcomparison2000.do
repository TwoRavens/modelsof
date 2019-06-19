clear
capture log close
set matsize 800
set memory 500m
log using emifcomparison2000.log, replace
use "C:\DATA\EMIF\9803sur.dta", clear

/*Survey commands*/
svyset, clear(all)
svyset [pweight=ponfin3]

/*Non-specified age is a missing value*/
replace edad = . if edad==99

/*Who can be considered a migrant?*/
gen mig = 0
/*Personas que no comprometieron fecha de regreso*/
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 0)
/*Personas que declaran ir a trabajar o a buscar trabajo*/
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_2 == 1)
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_2 == 2)
/*Personas que permanecer·n en USA m·s de un aÒo*/
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 1 & p13_4t > 365)
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 2 & p13_4t > 52)
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 3 & p13_4t > 12)
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 4)
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 5)
replace mig = 1 if (a—ocuest==2000 & trim~=3 & p13_4c == 6)
replace mig = 0 if edad < 18
replace mig = 0 if edad > 67

/*Counting available observations (three last quarters of 2000)*/
svymean edad, by(mig sexo) ci obs

/*Sex*/
gen male = sexo
replace male = 0 if sexo == 2

svymean male, by(mig) ci obs

/*Age groups*/
gen age1827 = 0
replace age1827 = 1 if (edad>17 & edad<28)
replace age1827 = . if mig == 0
gen age2837 = 0
replace age2837 = 1 if (edad>27 & edad<38)
replace age2837 = . if mig == 0
gen age3847 = 0
replace age3847 = 1 if (edad>37 & edad<48)
replace age3847 = . if mig == 0
gen age4857 = 0
replace age4857 = 1 if (edad>47 & edad<58)
replace age4857 = . if mig == 0
gen age5867 = 0
replace age5867 = 1 if (edad>57 & edad<68)
replace age5867 = . if mig == 0

svymean age1827, by(mig sexo)
svymean age2837, by(mig sexo)
svymean age3847, by(mig sexo)
svymean age4857, by(mig sexo)
svymean age5867, by(mig sexo)

replace mig = 0 if edad > 47
svymean edad, by(mig sexo) ci obs

/*Creating schooling years*/
gen schoolyears=0
replace schoolyears=. if p2_2gra==99
replace schoolyears=p2_2gra if p2_2niv==2
replace schoolyears=p2_2gra+6 if p2_2niv==3
replace schoolyears=p2_2gra+9 if p2_2niv==4
replace schoolyears=p2_2gra+6 if p2_2niv==5
replace schoolyears=p2_2gra+9 if p2_2niv==6
replace schoolyears=p2_2gra+12 if p2_2niv==7
replace schoolyears=p2_2gra+12 if p2_2niv==8

/*Grouping the schooling variable*/
gen school0 = 0
replace school0 = 1 if schoolyears == 0
replace school0 = . if mig == 0
gen school1to4 = 0
replace school1to4 = 1 if (schoolyears > 0 & schoolyears < 5)
replace school1to4 = . if mig == 0
gen school5to8 = 0
replace school5to8 = 1 if (schoolyears >= 5 & schoolyears < 9)
replace school5to8 = . if mig == 0
gen school9to11 = 0
replace school9to11 = 1 if (schoolyears >= 9 & schoolyears < 12)
replace school9to11 = . if mig == 0
gen school12to15 = 0
replace school12to15 = 1 if (schoolyears >= 12 & schoolyears < 16)
replace school12to15 = . if mig == 0
gen school16plus = 0
replace school16plus = 1 if schoolyears >= 16
replace school16plus = . if mig == 0

svymean school0, by(mig sexo)
svymean school1to4, by(mig sexo)
svymean school5to8, by(mig sexo)
svymean school9to11, by(mig sexo)
svymean school12to15, by(mig sexo)
svymean school16plus, by(mig sexo)

svymean schoolyears, by(mig sexo)

/*Rural/urban*/
gen rural = .
replace rural = 0 if p6_loc == 2
replace rural = 1 if p6_loc == 1

svymean rural, by(mig sexo)

/*Labor force participation*/
gen laborforce = 0
/*People who work*/
replace laborforce = 1 if p8_1 == 1
replace laborforce = 1 if p8_1_1 == 1
/*People who looked for work in the last month or in the last two months and are ready to join a firm*/
replace laborforce = 1 if (p8_1_2t == 1 & p8_1_2c <61)
replace laborforce = 1 if (p8_1_2t == 2 & p8_1_2c <9)
replace laborforce = 1 if (p8_1_2t == 3 & p8_1_2c <3)

svymean laborforce, by(mig sexo)

/*Work in agriculture*/
gen agriculture = 0
replace agriculture = 1 if match(substr(string(p8_5),1,2),"41") == 1

svymean agriculture, by(mig sexo)
