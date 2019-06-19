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
 byte    birthmo                             83-84 ///
 byte    birthqtr                            85 ///
 byte    durmarr                             86-87 ///
 byte    marrno                              88 ///
 byte    chborn                              89-90 ///
 int     race                                91 ///
 int     raced                               92-94 ///
 long    bpl                                 95-97 ///
 long    bpld                                98-102 ///
 byte    nativity                           103 ///
 byte    citizen                            104 ///
 int     higrade                            105-106 ///
 int     higraded                           107-109 ///
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
 int     durunemp                           147-149 ///
 byte    activity                           150 ///
 int     rocc                               151-153 ///
 int     rind                               154-156 ///
 byte    rclasswk                           157 ///
 byte    hadnajob                           158 ///
 long    inctot                             159-165 ///
 long    ftotinc                            166-172 ///
 long    incwage                            173-178 ///
 long    incbusfm                           179-183 ///
 long    incother                           184-188 ///
 int     poverty                            189-191 ///
 using "$startdir/$inputdata\ipums\1950\usa_1950.dat"

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
label var birthmo `"Month of birth"'
label var birthqtr `"Quarter of birth"'
label var durmarr `"Duration of current marital status"'
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
label var durunemp `"Continuous weeks unemployed"'
label var activity `"Main activity last week"'
label var rocc `"Occupation, labor reserve"'
label var rind `"Industry, labor reserve"'
label var rclasswk `"Class of worker, labor reserve"'
label var hadnajob `"Had a non-active job last week"'
label var inctot `"Total personal income"'
label var ftotinc `"Total family income"'
label var incwage `"Wage and salary income"'
label var incbusfm `"Business and farm income"'
label var incother `"Other income"'
label var poverty `"Poverty status"'

save "$startdir/$outputdata\usa_1950.dta", replace

#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1950.dta", replace;


use "$startdir/$outputdata\usa_1950.dta";

gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1950_sample.dta", replace;
