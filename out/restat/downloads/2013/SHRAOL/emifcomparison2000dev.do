clear
capture log close
set matsize 800
set memory 500m
log using emifcomparison2000dev.log, replace
use "C:\DATA\EMIF\07980703dev.dta", clear

/*Survey commands*/
svyset, clear(all)
svyset [pweight=ponfin3]

/*Cleaning the data*/
gen edad=p2
replace edad=. if p2==99
gen dialindig=p2_1
replace dialindig=. if p2_1==99
gen leeresc=p3
replace leeresc=. if p3==99
replace leeresc=0 if p3==2
gen schoolyears=0
replace schoolyears=. if p3_1gra==99
replace schoolyears=p3_1gra if p3_1niv==2
replace schoolyears=p3_1gra+6 if p3_1niv==3
replace schoolyears=p3_1gra+9 if p3_1niv==4
replace schoolyears=p3_1gra+6 if p3_1niv==5
replace schoolyears=p3_1gra+9 if p3_1niv==6
replace schoolyears=p3_1gra+12 if p3_1niv==7
replace schoolyears=p3_1gra+12 if p3_1niv==8
gen married=0
replace married=. if p4==99
replace married=1 if p4==2
replace married=1 if p4==3
gen jefe=0
replace jefe=. if p5==99
replace jefe=1 if p5==1
gen hhsize=p6
replace hhsize=. if p6==99
gen accomp=p7_3
replace accomp=. if p7_3==99
replace accomp=0 if p7_3==-1
gen fullhhtrav=0
replace fullhhtrav=1 if (accomp+1)/hhsize>=1
gen rural=p8_loc
replace rural=. if p8_loc==99
replace rural=0 if p8_loc==2
replace rural=. if p8_loc==-1

/*Counting available observations (three last quarters of 2000)*/
sum edad if (year==2000 & trim~=3 & p1==1 & edad>17 & edad<68)
sum edad if (year==2000 & trim~=3 & p1==2 & edad>17 & edad<68)
sum edad if (year==2000 & trim~=3 & p1==1 & edad>17 & edad<48)
sum edad if (year==2000 & trim~=3 & p1==2 & edad>17 & edad<48)

/*Sex*/
gen male = p1
replace male = 0 if p1 == 2

svymean male if (year==2000 & trim~=3 & edad>17 & edad<68)

/*Age groups*/
gen age1827 = 0
replace age1827 = 1 if (edad>17 & edad<28)
replace age1827 = . if edad == .
gen age2837 = 0
replace age2837 = 1 if (edad>27 & edad<38)
replace age2837 = . if edad == .
gen age3847 = 0
replace age3847 = 1 if (edad>37 & edad<48)
replace age3847 = . if edad == .
gen age4857 = 0
replace age4857 = 1 if (edad>47 & edad<58)
replace age4857 = . if edad == .
gen age5867 = 0
replace age5867 = 1 if (edad>57 & edad<68)
replace age5867 = . if edad == .
svymean age1827 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1)
svymean age1827 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0)
svymean age2837 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1)
svymean age2837 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0)
svymean age3847 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1)
svymean age3847 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0)
svymean age4857 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1)
svymean age4857 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0)
svymean age5867 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1)
svymean age5867 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0)

/*Grouping the schooling variable*/
gen school0 = 0
replace school0 = 1 if schoolyears == 0
replace school0 = . if schoolyears == .
gen school1to4 = 0
replace school1to4 = 1 if (schoolyears > 0 & schoolyears < 5)
replace school1to4 = . if schoolyears == .
gen school5to8 = 0
replace school5to8 = 1 if (schoolyears >= 5 & schoolyears < 9)
replace school5to8 = . if schoolyears == .
gen school9to11 = 0
replace school9to11 = 1 if (schoolyears >= 9 & schoolyears < 12)
replace school9to11 = . if schoolyears == .
gen school12to15 = 0

replace school12to15 = 1 if (schoolyears >= 12 & schoolyears < 16)
replace school12to15 = . if schoolyears == .
gen school16plus = 0
replace school16plus = 1 if schoolyears >= 16
replace school16plus = . if schoolyears == .

svymean school0 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean school0 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)
svymean school1to4 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean school1to4 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)
svymean school5to8 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean school5to8 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)
svymean school9to11 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean school9to11 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)
svymean school12to15 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean school12to15 if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)
svymean school16plus if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean school16plus if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)

svymean schoolyears if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 1 & edad < 48)
svymean schoolyears if (year==2000 & trim~=3 & edad>17 & edad<68 & male == 0 & edad < 48)

/*Rural/urban*/
svymean rural if (year==2000 & trim~=3 & edad>17 & male == 1 & edad < 48)
svymean rural if (year==2000 & trim~=3 & edad>17 & male == 0 & edad < 48)

/*Labor force participation*/
gen laborforce = 0
/*People who work*/
replace laborforce = 1 if p11 == 1
replace laborforce = 1 if p11_1 == 1
/*People who looked for work in the last month or in the last two months and are ready to join a firm*/
replace laborforce = 1 if (p11_1_1t == 1 & p11_1_1c <61)
replace laborforce = 1 if (p11_1_1t == 2 & p11_1_1c <9)
replace laborforce = 1 if (p11_1_1t == 3 & p11_1_1c <3)

svymean laborforce if (year==2000 & trim~=3 & edad>17 & male == 1 & edad < 48)
svymean laborforce if (year==2000 & trim~=3 & edad>17 & male == 0 & edad < 48)

/*Work in agriculture*/
gen agriculture = 0
replace agriculture = 1 if match(substr(string(p11_5),1,2),"41") == 1

svymean agriculture if (year==2000 & trim~=3 & edad>17 & male == 1 & edad < 48)
svymean agriculture if (year==2000 & trim~=3 & edad>17 & male == 0 & edad < 48)
