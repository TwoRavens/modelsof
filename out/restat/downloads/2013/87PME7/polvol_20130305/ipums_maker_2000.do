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
 int     race                                90 ///
 int     raced                               91-93 ///
 long    bpl                                 94-96 ///
 long    bpld                                97-101 ///
 byte    citizen                            102 ///
 int     yrimmig                            103-106 ///
 byte    yrsusa1                            107-108 ///
 int     educ                               109-110 ///
 int     educd                              111-113 ///
 byte    empstat                            114 ///
 byte    empstatd                           115-116 ///
 byte    labforce                           117 ///
 int     occ                                118-120 ///
 int     occ1950                            121-123 ///
 int     occ1990                            124-126 ///
 int     ind                                127-130 ///
 int     ind1950                            131-133 ///
 int     ind1990                            134-136 ///
 byte    classwkr                           137 ///
 byte    classwkrd                          138-139 ///
 str    occsoc                             140-145 ///
 str    indnaics                           146-153 ///
 byte    wkswork1                           154-155 ///
 byte    wkswork2                           156 ///
 byte    uhrswork                           157-158 ///
 byte    absent                             159 ///
 byte    looking                            160 ///
 byte    availble                           161 ///
 byte    wrkrecal                           162 ///
 byte    workedyr                           163 ///
 long    inctot                             164-170 ///
 long    ftotinc                            171-177 ///
 long    incwage                            178-183 ///
 long    incbus00                           184-189 ///
 long    incss                              190-194 ///
 long    incwelfr                           195-199 ///
 long    incinvst                           200-205 ///
 long    incretir                           206-211 ///
 long    incsupp                            212-216 ///
 long    incother                           217-221 ///
 long    incearn                            222-228 ///
 int     poverty                            229-231 ///
 int     migplac5                           232-234 ///
using "$startdir/$inputdata\ipums\2000\usa_2000.dat"

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
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var bpl `"Birthplace [general version]"'
label var bpld `"Birthplace [detailed version]"'
label var citizen `"Citizenship status"'
label var yrimmig `"Year of immigration"'
label var yrsusa1 `"Years in the United States"'
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
label var occsoc `"Occupation, SOC classification"'
label var indnaics `"Industry, NAICS classification"'
label var wkswork1 `"Weeks worked last year"'
label var wkswork2 `"Weeks worked last year, intervalled"'
label var uhrswork `"Usual hours worked per week"'
label var absent `"Absent from work last week"'
label var looking `"Looking for work"'
label var availble `"Available for work"'
label var wrkrecal `"Informed of work recall"'
label var workedyr `"Worked last year"'
label var inctot `"Total personal income"'
label var ftotinc `"Total family income"'
label var incwage `"Wage and salary income"'
label var incbus00 `"Business and farm income, 2000"'
label var incss `"Social Security income"'
label var incwelfr `"Welfare (public assistance) income"'
label var incinvst `"Interest, dividend, and rental income"'
label var incretir `"Retirement income"'
label var incsupp `"Supplementary Security Income"'
label var incother `"Other income"'
label var incearn `"Total personal earned income"'
label var poverty `"Poverty status"'
label var migplac5 `"State or country of residence 5 years ago"'

save "$startdir/$outputdata\usa_2000.dta", replace

#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_2000.dta", replace;


use "$startdir/$outputdata\usa_2000.dta";

gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_2000_sample.dta", replace;
