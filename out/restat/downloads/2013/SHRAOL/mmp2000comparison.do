clear
capture log close
set matsize 800
set memory 900m
log using mmp2000.log, replace

/*Opening the data*/
use "c:\DATA\MMP\pers107.dta", clear

/*Survey commands*/
svyset, clear(all)
svyset [pweight=weight]

/*Reduce the dataset to those aged 18-67*/
gen edad = 2000 - yrborn
replace edad = . if yrborn == 9999
replace edad = . if edad < 18
replace edad = . if edad > 67

/*Creating variable for those who migrated in 2000*/
gen mig = 0
replace mig = 1 if usyr1 == 2000
replace mig = 1 if usyrl == 2000

/*Counting observations*/
/*Migrants*/
sum edad if (sex == 1 & mig == 1)
sum edad if (sex == 2 & mig == 1)
/*Young Migrants*/
sum edad if (sex == 1 & mig == 1 & edad<48)
sum edad if (sex == 2 & mig == 1 & edad<48)

/*Sex percentages*/
gen male = 1
replace male = 0 if sex == 2
svymean male if (edad ~= . & mig == 1)

/*Legal status*/
gen legal = 0
replace legal = . if mig == 0
replace legal = . if usdoc1 == 9999
replace legal = . if usdocl == 9999
replace legal = . if edad == .
replace legal = 1 if (mig == 1 & usyr1 == 2000 & usdoc1 ~= 8)
replace legal = 1 if (mig == 1 & usyrl == 2000 & usdocl ~= 8)

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
svymean age1827 if (mig == 1 & male == 1)
svymean age1827 if (mig == 1 & male == 0)
svymean age2837 if (mig == 1 & male == 1)
svymean age2837 if (mig == 1 & male == 0)
svymean age3847 if (mig == 1 & male == 1)
svymean age3847 if (mig == 1 & male == 0)
svymean age4857 if (mig == 1 & male == 1)
svymean age4857 if (mig == 1 & male == 0)
svymean age5867 if (mig == 1 & male == 1)
svymean age5867 if (mig == 1 & male == 0)

/*Creating schooling years*/
gen schoolyears = edyrs
replace schoolyears = . if (surveyyr - yrborn) < 18
replace schoolyears = . if edyrs == 8888
replace schoolyears = . if edyrs == 9999

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

svymean school0 if (mig == 1 & male == 1 & edad < 48)
svymean school0 if (mig == 1 & male == 0 & edad < 48)
svymean school1to4 if (mig == 1 & male == 1 & edad < 48)
svymean school1to4 if (mig == 1 & male == 0 & edad < 48)
svymean school5to8 if (mig == 1 & male == 1 & edad < 48)
svymean school5to8 if (mig == 1 & male == 0 & edad < 48)
svymean school9to11 if (mig == 1 & male == 1 & edad < 48)
svymean school9to11 if (mig == 1 & male == 0 & edad < 48)
svymean school12to15 if (mig == 1 & male == 1 & edad < 48)
svymean school12to15 if (mig == 1 & male == 0 & edad < 48)
svymean school16plus if (mig == 1 & male == 1 & edad < 48)
svymean school16plus if (mig == 1 & male == 0 & edad < 48)

svymean schoolyears if (mig == 1 & male == 1 & edad < 48)
svymean schoolyears if (mig == 1 & male == 0 & edad < 48)

/*Labor force participation*/
gen laborforce = 0
replace laborforce = 1 if (occ > 99 & surveyyr == 2000)
replace laborforce = 1 if (occ == 10 & surveyyr == 2000)
replace laborforce = . if occ == 9999
replace laborforce = . if surveyyr ~= 2000

svymean laborforce if (mig == 1 & male == 1 & edad < 48)
svymean laborforce if (mig == 1 & male == 0 & edad < 48)

/*Work in agriculture*/
gen agriculture = 0
replace agriculture = 1 if (occ > 409 & occ <420 & surveyyr == 2000)
replace agriculture = . if occ == 9999
replace agriculture = . if surveyyr ~= 2000

svymean agriculture if (mig == 1 & male == 1 & edad < 48)
svymean agriculture if (mig == 1 & male == 0 & edad < 48)
