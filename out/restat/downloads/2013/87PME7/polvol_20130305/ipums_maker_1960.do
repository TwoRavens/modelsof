

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
 byte    chborn                              77-78 ///
 int     race                                79 ///
 int     raced                               80-82 ///
 long    bpl                                 83-85 ///
 long    bpld                                86-90 ///
 byte    nativity                            91 ///
 int     higrade                             92-93 ///
 int     higraded                            94-96 ///
 int     educ                                97-98 ///
 int     educd                               99-101 ///
 byte    empstat                            102 ///
 byte    empstatd                           103-104 ///
 byte    labforce                           105 ///
 int     occ                                106-108 ///
 int     occ1950                            109-111 ///
 int     occ1990                            112-114 ///
 int     ind                                115-118 ///
 int     ind1950                            119-121 ///
 int     ind1990                            122-124 ///
 byte    classwkr                           125 ///
 byte    classwkrd                          126-127 ///
 byte    wkswork2                           128 ///
 byte    hrswork2                           129 ///
 byte    yrlastwk                           130-131 ///
 byte    workedyr                           132 ///
 long    inctot                             133-139 ///
 long    ftotinc                            140-146 ///
 long    incwage                            147-152 ///
 long    incbusfm                           153-157 ///
 long    incother                           158-162 ///
 int     poverty                            163-165 ///
 using "$startdir/$inputdata\ipums\1960\usa_1960.dat"

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
label var chborn `"Children ever born"'
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var bpl `"Birthplace [general version]"'
label var bpld `"Birthplace [detailed version]"'
label var nativity `"Foreign birthplace or parentage"'
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
label var incbusfm `"Business and farm income"'
label var incother `"Other income"'
label var poverty `"Poverty status"'
save "$startdir/$outputdata\usa_1960.dta", replace

#delimit;


keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1960.dta", replace;


use "$startdir/$outputdata\usa_1960.dta";
gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1960_sample.dta", replace;
