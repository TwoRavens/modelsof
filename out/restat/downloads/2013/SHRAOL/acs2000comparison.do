clear
capture log close
set matsize 800
set memory 900m
log using acs2000comparison.log, replace

/*Opening the data*/
do "C:\DATA\ACSUScensus\jfxxx003.do"

/*Survey commands*/
svyset, clear(all)
svyset [pweight=perwt]

/*Reduce the dataset to those aged 18-67*/
gen edad = age
replace edad = . if age < 18
replace edad = . if age > 67

/*Counting observations*/
/*Migrants*/
sum edad if (sex == 1 & migplac1 == 200 & year == 0)
sum edad if (sex == 2 & migplac1 == 200 & year == 0)
/*Young Migrants*/
sum edad if (sex == 1 & migplac1 == 200 & year == 0 & edad<48)
sum edad if (sex == 2 & migplac1 == 200 & year == 0 & edad<48)

/*Sex percentages*/
gen male = 1
replace male = 0 if sex == 2
svymean male if (edad ~= . & migplac1 == 200 & year == 0)

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
svymean age1827 if (migplac1 == 200 & year == 0 & male == 1)
svymean age1827 if (migplac1 == 200 & year == 0 & male == 0)
svymean age2837 if (migplac1 == 200 & year == 0 & male == 1)
svymean age2837 if (migplac1 == 200 & year == 0 & male == 0)
svymean age3847 if (migplac1 == 200 & year == 0 & male == 1)
svymean age3847 if (migplac1 == 200 & year == 0 & male == 0)
svymean age4857 if (migplac1 == 200 & year == 0 & male == 1)
svymean age4857 if (migplac1 == 200 & year == 0 & male == 0)
svymean age5867 if (migplac1 == 200 & year == 0 & male == 1)
svymean age5867 if (migplac1 == 200 & year == 0 & male == 0)

/*Creating schooling years*/
gen schoolyears = 0
replace schoolyears = . if educrec == 0
replace schoolyears = 2.5 if educrec == 2
replace schoolyears = 6.5 if educrec == 3
replace schoolyears = 9 if educrec == 4
replace schoolyears = 10 if educrec == 5
replace schoolyears = 11 if educrec == 6
replace schoolyears = 12 if educrec == 7
replace schoolyears = 14 if educrec == 8
replace schoolyears = 17 if educrec == 9

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

svymean school0 if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean school0 if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)
svymean school1to4 if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean school1to4 if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)
svymean school5to8 if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean school5to8 if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)
svymean school9to11 if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean school9to11 if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)
svymean school12to15 if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean school12to15 if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)
svymean school16plus if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean school16plus if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)

svymean schoolyears if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean schoolyears if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)

/*Labor force participation*/
gen laborforce = 0
replace laborforce = 1 if labforce == 2
replace laborforce = . if labforce == 0

svymean laborforce if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean laborforce if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)

/*Work in agriculture*/
gen agriculture = 0
replace agriculture = 1 if ind < 30
replace agriculture = . if ind == 0

svymean agriculture if (migplac1 == 200 & year == 0 & male == 1 & edad < 48)
svymean agriculture if (migplac1 == 200 & year == 0 & male == 0 & edad < 48)
