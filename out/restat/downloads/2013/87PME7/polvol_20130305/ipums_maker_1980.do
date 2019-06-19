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
 byte    metro                               25 ///
 int     metarea                             26-28 ///
 int     metaread                            29-32 ///
 long    citypop                             33-37 ///
 byte    gq                                  38 ///
 long    hhincome                            39-45 ///
 byte    nfams                               46-47 ///
 byte    ncouples                            48 ///
 byte    nmothers                            49 ///
 byte    nfathers                            50 ///
 float  perwt                               51-56 ///
 byte    momloc                              57-58 ///
 byte    stepmom                             59 ///
 byte    momrule                             60 ///
 byte    poploc                              61-62 ///
 byte    steppop                             63 ///
 byte    poprule                             64 ///
 byte    sploc                               65-66 ///
 byte    sprule                              67 ///
 byte    famsize                             68-69 ///
 byte    nchild                              70 ///
 byte    nchlt5                              71 ///
 byte    famunit                             72-73 ///
 byte    eldch                               74-75 ///
 byte    yngch                               76-77 ///
 byte    nsibs                               78 ///
 int     relate                              79-80 ///
 int     related                             81-84 ///
 int     age                                 85-87 ///
 byte    sex                                 88 ///
 byte    marst                               89 ///
 byte    birthqtr                            90 ///
 byte    agemarr                             91-92 ///
 byte    marrno                              93 ///
 byte    marrqtr                             94 ///
 byte    widow                               95 ///
 byte    chborn                              96-97 ///
 int     race                                98 ///
 int     raced                               99-101 ///
 long    bpl                                102-104 ///
 long    bpld                               105-109 ///
 byte    citizen                            110 ///
 int     yrimmig                            111-114 ///
 int     higrade                            115-116 ///
 int     higraded                           117-119 ///
 int     educ                               120-121 ///
 int     educd                              122-124 ///
 byte    empstat                            125 ///
 byte    empstatd                           126-127 ///
 byte    labforce                           128 ///
 int     occ                                129-131 ///
 int     occ1950                            132-134 ///
 int     occ1990                            135-137 ///
 int     ind                                138-141 ///
 int     ind1950                            142-144 ///
 int     ind1990                            145-147 ///
 byte    classwkr                           148 ///
 byte    classwkrd                          149-150 ///
 byte    wkswork1                           151-152 ///
 byte    wkswork2                           153 ///
 byte    hrswork1                           154-155 ///
 byte    hrswork2                           156 ///
 byte    uhrswork                           157-158 ///
 byte    qtrunemp                           159 ///
 byte    wksunemp                           160-161 ///
 byte    yrlastwk                           162-163 ///
 byte    absent                             164 ///
 byte    looking                            165 ///
 byte    availble                           166 ///
 byte    workedyr                           167 ///
 long    inctot                             168-174 ///
 long    ftotinc                            175-181 ///
 long    incwage                            182-187 ///
 long    incbus                             188-193 ///
 long    incfarm                            194-199 ///
 long    incss                              200-204 ///
 long    incwelfr                           205-209 ///
 long    incinvst                           210-215 ///
 long    incother                           216-220 ///
 int     poverty                            221-223 ///
 int     migplac5                           224-226 ///
using "$startdir/$inputdata\ipums\1980\usa_1980.dat"

replace hhwt=hhwt/100
replace perwt=perwt/100

label var year `"Census year"'
label var datanum `"Data set number"'
label var serial `"Household serial number"'
label var hhwt `"Household weight"'
label var stateicp `"State (ICPSR code)"'
label var statefip `"State (FIPS code)"'
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
label var wkswork1 `"Weeks worked last year"'
label var wkswork2 `"Weeks worked last year, intervalled"'
label var hrswork1 `"Hours worked last week"'
label var hrswork2 `"Hours worked last week, intervalled"'
label var uhrswork `"Usual hours worked per week"'
label var qtrunemp `"Quarters unemployed last year"'
label var wksunemp `"Weeks unemployed last year"'
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
label var incother `"Other income"'
label var poverty `"Poverty status"'
label var migplac5 `"State or country of residence 5 years ago"'




save "$startdir/$outputdata\usa_1980.dta", replace

#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1980.dta", replace;


use "$startdir/$outputdata\usa_1980.dta";
gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1980_sample.dta", replace;
