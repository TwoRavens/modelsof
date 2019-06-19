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
 byte    nfams                               39-40 ///
 byte    ncouples                            41 ///
 byte    nmothers                            42 ///
 byte    nfathers                            43 ///
 float  perwt                               44-49 ///
 byte    momloc                              50-51 ///
 byte    stepmom                             52 ///
 byte    momrule                             53 ///
 byte    poploc                              54-55 ///
 byte    steppop                             56 ///
 byte    poprule                             57 ///
 byte    sploc                               58-59 ///
 byte    sprule                              60 ///
 byte    famsize                             61-62 ///
 byte    nchild                              63 ///
 byte    nchlt5                              64 ///
 byte    famunit                             65-66 ///
 byte    eldch                               67-68 ///
 byte    yngch                               69-70 ///
 byte    nsibs                               71 ///
 int     relate                              72-73 ///
 int     related                             74-77 ///
 int     age                                 78-80 ///
 byte    sex                                 81 ///
 byte    marst                               82 ///
 byte    agemonth                            83-84 ///
 byte    agemarr                             85-86 ///
 byte    marrno                              87 ///
 byte    chborn                              88-89 ///
 int     race                                90 ///
 int     raced                               91-93 ///
 long    bpl                                 94-96 ///
 long    bpld                                97-101 ///
 byte    nativity                           102 ///
 byte    citizen                            103 ///
 int     higrade                            104-105 ///
 int     higraded                           106-108 ///
 int     educ                               109-110 ///
 int     educd                              111-113 ///
 byte    empstat                            114 ///
 byte    empstatd                           115-116 ///
 byte    labforce                           117 ///
 int     occ                                118-120 ///
 int     occ1950                            121-123 ///
 int     ind                                124-127 ///
 int     ind1950                            128-130 ///
 byte    classwkr                           131 ///
 byte    classwkrd                          132-133 ///
 byte    wkswork1                           134-135 ///
 byte    wkswork2                           136 ///
 byte    hrswork1                           137-138 ///
 byte    hrswork2                           139 ///
 int     durunemp                           140-142 ///
 int     uocc                               143-145 ///
 int     uocc95                             146-148 ///
 int     uind                               149-151 ///
 byte    uclasswk                           152 ///
 long    incwage                            153-158 ///
 byte    incnonwg                           159 ///
 byte    deducts                            160 ///
 int     migplac5                           161-163 ///
 using "$startdir/$inputdata\ipums\1940\usa_1940.dat"

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
label var agemonth `"Age in months"'
label var agemarr `"Age at first marriage"'
label var marrno `"Times married"'
label var chborn `"Children ever born"'
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var bpl `"Birthplace [general version]"'
label var bpld `"Birthplace [detailed version]"'
label var nativity `"Foreign birthplace or parentage"'
label var citizen `"Citizenship status"'
label var higrade `"Highest grade of schooling [general version]"'
label var higraded `"Highest grade of schooling [detailed version]"'
label var educ `"Educational attainment [general version]"'
label var educd `"Educational attainment [detailed version]"'
label var empstat `"Employment status [general version]"'
label var empstatd `"Employment status [detailed version]"'
label var labforce `"Labor force status"'
label var occ `"Occupation"'
label var occ1950 `"Occupation, 1950 basis"'
label var ind `"Industry"'
label var ind1950 `"Industry, 1950 basis"'
label var classwkr `"Class of worker [general version]"'
label var classwkrd `"Class of worker [detailed version]"'
label var wkswork1 `"Weeks worked last year"'
label var wkswork2 `"Weeks worked last year, intervalled"'
label var hrswork1 `"Hours worked last week"'
label var hrswork2 `"Hours worked last week, intervalled"'
label var durunemp `"Continuous weeks unemployed"'
label var uocc `"Usual occupation"'
label var uocc95 `"Usual occupation, 1950 classification"'
label var uind `"Usual industry"'
label var uclasswk `"Usual class of worker"'
label var incwage `"Wage and salary income"'
label var incnonwg `"Had non-wage/salary income over $50"'
label var deducts `"Deductions for retirement"'
label var migplac5 `"State or country of residence 5 years ago"'

save "$startdir/$outputdata\usa_1940.dta", replace

#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1940.dta", replace;

use "$startdir/$outputdata\usa_1940.dta", clear;

gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1940_sample.dta", replace;

