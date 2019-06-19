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
 byte    gq                                  27 ///
 byte    nfams                               28-29 ///
 byte    ncouples                            30 ///
 byte    nmothers                            31 ///
 byte    nfathers                            32 ///
 float  perwt                               33-38 ///
 byte    momloc                              39-40 ///
 byte    stepmom                             41 ///
 byte    momrule                             42 ///
 byte    poploc                              43-44 ///
 byte    steppop                             45 ///
 byte    poprule                             46 ///
 byte    sploc                               47-48 ///
 byte    sprule                              49 ///
 byte    famsize                             50-51 ///
 byte    nchild                              52 ///
 byte    nchlt5                              53 ///
 byte    famunit                             54-55 ///
 byte    eldch                               56-57 ///
 byte    yngch                               58-59 ///
 byte    nsibs                               60 ///
 int     relate                              61-62 ///
 int     related                             63-66 ///
 int     age                                 67-69 ///
 byte    sex                                 70 ///
 byte    marst                               71 ///
 byte    birthqtr                            72 ///
 byte    agemarr                             73-74 ///
 byte    marrno                              75 ///
 byte    marrqtr                             76 ///
 byte    widow                               77 ///
 byte    chborn                              78-79 ///
 int     race                                80 ///
 int     raced                               81-83 ///
 long    bpl                                 84-86 ///
 long    bpld                                87-91 ///
 byte    citizen                             92 ///
 int     yrimmig                             93-96 ///
 int     higrade                             97-98 ///
 int     higraded                            99-101 ///
 int     educ                               102-103 ///
 int     educd                              104-106 ///
 byte    empstat                            107 ///
 byte    empstatd                           108-109 ///
 byte    labforce                           110 ///
 int     occ                                111-113 ///
 int     occ1950                            114-116 ///
 int     occ1990                            117-119 ///
 int     ind                                120-123 ///
 int     ind1950                            124-126 ///
 int     ind1990                            127-129 ///
 byte    classwkr                           130 ///
 byte    classwkrd                          131-132 ///
 byte    wkswork2                           133 ///
 byte    hrswork2                           134 ///
 byte    yrlastwk                           135-136 ///
 byte    workedyr                           137 ///
 long    inctot                             138-144 ///
 long    ftotinc                            145-151 ///
 long    incwage                            152-157 ///
 long    incbus                             158-163 ///
 long    incfarm                            164-169 ///
 long    incss                              170-174 ///
 long    incwelfr                           175-179 ///
 long    incother                           180-184 ///
 int     poverty                            185-187 ///
 int     migplac5                           188-190 ///
 using "$startdir/$inputdata\ipums\1970\usa_1970.dat"

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
label var gq `"Group quarters status"'
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
label var birthqtr `"Quarter of birth"'
label var agemarr `"Age at first marriage"'
label var marrno `"Times married"'
label var marrqtr `"Quarter of first marriage"'
label var widow `"Marriage ended by death"'
label var chborn `"Children ever born"'
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var bpl `"Birthplace [general version]"'
label var bpld `"Birthplace [detailed version]"'
label var citizen `"Citizenship status"'
label var yrimmig `"Year of immigration"'
label var higrade `"Highest grade of schooling [general version]"'
label var higraded `"Highest grade of schooling [detailed version]"'
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
label var wkswork2 `"Weeks worked last year, intervalled"'
label var hrswork2 `"Hours worked last week, intervalled"'
label var yrlastwk `"Year last worked"'
label var workedyr `"Worked last year"'
label var inctot `"Total personal income"'
label var ftotinc `"Total family income"'
label var incwage `"Wage and salary income"'
label var incbus `"Non-farm business income"'
label var incfarm `"Farm income"'
label var incss `"Social Security income"'
label var incwelfr `"Welfare (public assistance) income"'
label var incother `"Other income"'
label var poverty `"Poverty status"'
label var migplac5 `"State or country of residence 5 years ago"'


save "$startdir/$outputdata\usa_1970.dta", replace

#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1970.dta", replace;


use "$startdir/$outputdata\usa_1970.dta";


gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1970_sample.dta", replace;
