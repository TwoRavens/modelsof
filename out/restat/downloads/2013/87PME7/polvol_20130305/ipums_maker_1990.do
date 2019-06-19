/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 int     year                                 1-4 ///
 byte    datanum                              5-6 ///
 double  serial                               7-14 ///
 float  hhwt                                15-20 ///
 byte    stateicp                            21-22 ///
 byte    statefip                            23-24 ///
 byte    urban                               25 ///
 byte    metro                               26 ///
 int     metarea                             27-29 ///
 int     metaread                            30-33 ///
 long    citypop                             34-38 ///
 byte    gq                                  39 ///
 long    hhincome                            40-46 ///
 byte    nfams                               47-48 ///
 byte    ncouples                            49 ///
 byte    nmothers                            50 ///
 byte    nfathers                            51 ///
 float  perwt                               52-57 ///
 byte    momloc                              58-59 ///
 byte    stepmom                             60 ///
 byte    momrule                             61 ///
 byte    poploc                              62-63 ///
 byte    steppop                             64 ///
 byte    poprule                             65 ///
 byte    sploc                               66-67 ///
 byte    sprule                              68 ///
 byte    famsize                             69-70 ///
 byte    nchild                              71 ///
 byte    nchlt5                              72 ///
 byte    famunit                             73-74 ///
 byte    eldch                               75-76 ///
 byte    yngch                               77-78 ///
 byte    nsibs                               79 ///
 int     relate                              80-81 ///
 int     related                             82-85 ///
 int     age                                 86-88 ///
 byte    sex                                 89 ///
 byte    marst                               90 ///
 byte    chborn                              91-92 ///
 int     race                                93 ///
 int     raced                               94-96 ///
 long    bpl                                 97-99 ///
 long    bpld                               100-104 ///
 byte    citizen                            105 ///
 int     yrimmig                            106-109 ///
 int     educ                               110-111 ///
 int     educd                              112-114 ///
 byte    empstat                            115 ///
 byte    empstatd                           116-117 ///
 byte    labforce                           118 ///
 int     occ                                119-121 ///
 int     occ1950                            122-124 ///
 int     occ1990                            125-127 ///
 int     ind                                128-131 ///
 int     ind1950                            132-134 ///
 int     ind1990                            135-137 ///
 byte    classwkr                           138 ///
 byte    classwkrd                          139-140 ///
 byte    wkswork1                           141-142 ///
 byte    wkswork2                           143 ///
 byte    hrswork1                           144-145 ///
 byte    hrswork2                           146 ///
 byte    uhrswork                           147-148 ///
 byte    yrlastwk                           149-150 ///
 byte    absent                             151 ///
 byte    looking                            152 ///
 byte    availble                           153 ///
 byte    workedyr                           154 ///
 long    inctot                             155-161 ///
 long    ftotinc                            162-168 ///
 long    incwage                            169-174 ///
 long    incbus                             175-180 ///
 long    incfarm                            181-186 ///
 long    incss                              187-191 ///
 long    incwelfr                           192-196 ///
 long    incinvst                           197-202 ///
 long    incretir                           203-208 ///
 long    incother                           209-213 ///
 long    incearn                            214-220 ///
 int     poverty                            221-223 ///
 int     migplac5                           224-226 ///
using "$startdir/$inputdata\ipums\1990\usa_1990.dat"

replace hhwt=hhwt/100
replace perwt=perwt/100

label var year `"Census year"'
label var datanum `"Data set number"'
label var serial `"Household serial number"'
label var hhwt `"Household weight"'
label var stateicp `"State (ICPSR code)"'
label var statefip `"State (FIPS code)"'
label var urban `"Urban/rural status"'
label var metro `"Metropolitan status"'
label var metarea `"Metropolitan area [general version]"'
label var metaread `"Metropolitan area [detailed version]"'
label var citypop `"City population"'
label var gq `"Group quarters status"'
label var hhincome `"Total household income"'
label var nfams `"Number of families in household"'
label var ncouples `"Number of married couples in household"'
label var nmothers `"Number of mothers in household"'
label var nfathers `"Number of fathers in household"'
label var perwt `"Person weight"'
label var momloc `"Mother's location in the household"'
label var stepmom `"Probable step/adopted mother"'
label var momrule `"Rule for linking mother"'
label var poploc `"Father's location in the household"'
label var steppop `"Probable step/adopted father"'
label var poprule `"Rule for linking father"'
label var sploc `"Spouse's location in household"'
label var sprule `"Rule for linking spouse"'
label var famsize `"Number of own family members in household"'
label var nchild `"Number of own children in the household"'
label var nchlt5 `"Number of own children under age 5 in household"'
label var famunit `"Family unit membership"'
label var eldch `"Age of eldest own child in household"'
label var yngch `"Age of youngest own child in household"'
label var nsibs `"Number of own siblings in household"'
label var relate `"Relationship to household head [general version]"'
label var related `"Relationship to household head [detailed version]"'
label var age `"Age"'
label var sex `"Sex"'
label var marst `"Marital status"'
label var chborn `"Children ever born"'
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var bpl `"Birthplace [general version]"'
label var bpld `"Birthplace [detailed version]"'
label var citizen `"Citizenship status"'
label var yrimmig `"Year of immigration"'
label var educ `"Educational attainment [general version]"'
label var educd `"Educational attainment [detailed version]"'
label var empstat `"Employment status [general version]"'
label var empstatd `"Employment status [detailed version]"'
label var labforce `"Labor force status"'
label var occ `"Occupation"'
label var occ1950 `"Occupation, 1950 basis"'
label var occ1990 `"Occupation, 1990 basis"'
label var ind `"Industry"'
label var ind1950 `"Industry, 1950 basis"'
label var ind1990 `"Industry, 1990 basis"'
label var classwkr `"Class of worker [general version]"'
label var classwkrd `"Class of worker [detailed version]"'
label var wkswork1 `"Weeks worked last year"'
label var wkswork2 `"Weeks worked last year, intervalled"'
label var hrswork1 `"Hours worked last week"'
label var hrswork2 `"Hours worked last week, intervalled"'
label var uhrswork `"Usual hours worked per week"'
label var yrlastwk `"Year last worked"'
label var absent `"Absent from work last week"'
label var looking `"Looking for work"'
label var availble `"Available for work"'
label var workedyr `"Worked last year"'
label var inctot `"Total personal income"'
label var ftotinc `"Total family income"'
label var incwage `"Wage and salary income"'
label var incbus `"Non-farm business income"'
label var incfarm `"Farm income"'
label var incss `"Social Security income"'
label var incwelfr `"Welfare (public assistance) income"'
label var incinvst `"Interest, dividend, and rental income"'
label var incretir `"Retirement income"'
label var incother `"Other income"'
label var incearn `"Total personal earned income"'
label var poverty `"Poverty status"'
label var migplac5 `"State or country of residence 5 years ago"'


save "$startdir/$outputdata\usa_1990.dta", replace

#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1990.dta", replace;


use "$startdir/$outputdata\usa_1990.dta";

gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1990_sample.dta", replace;
