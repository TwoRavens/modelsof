/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 int     year                                 1-4 ///
 byte    datanum                              5-6 ///
 double  serial                               7-14 ///
 int     hhwt                                15-18 ///
 byte    stateicp                            19-20 ///
 byte    statefip                            21-22 ///
 byte    urban                               23 ///
 byte    metro                               24 ///
 int     metarea                             25-27 ///
 int     metaread                            28-31 ///
 long    citypop                             32-36 ///
 byte    gq                                  37 ///
 long    ftotinc                             38-43 ///
 long    hhincome                            44-49 ///
 byte    nfams                               50-51 ///
 byte    ncouples                            52 ///
 byte    nmothers                            53 ///
 byte    nfathers                            54 ///
 int     perwt                               55-58 ///
 byte    momloc                              59-60 ///
 byte    stepmom                             61 ///
 byte    momrule                             62 ///
 byte    poploc                              63-64 ///
 byte    steppop                             65 ///
 byte    poprule                             66 ///
 byte    sploc                               67-68 ///
 byte    sprule                              69 ///
 byte    famsize                             70-71 ///
 byte    nchild                              72 ///
 byte    nchlt5                              73 ///
 byte    famunit                             74-75 ///
 byte    eldch                               76-77 ///
 byte    yngch                               78-79 ///
 byte    nsibs                               80 ///
 int     relate                              81-82 ///
 int     related                             83-86 ///
 int     age                                 87-89 ///
 byte    sex                                 90 ///
 byte    marst                               91 ///
 byte    agemonth                            92-93 ///
 byte    birthmo                             94-95 ///
 byte    birthqtr                            96 ///
 byte    agemarr                             97-98 ///
 byte    durmarr                             99-100 ///
 byte    marrno                             101 ///
 byte    marrqtr                            102 ///
 byte    widow                              103 ///
 byte    chborn                             104-105 ///
 int     race                               106 ///
 int     raced                              107-109 ///
 long    bpl                                110-112 ///
 long    bpld                               113-117 ///
 byte    nativity                           118 ///
 byte    citizen                            119 ///
 int     yrimmig                            120-122 ///
 byte    yrsusa1                            123-124 ///
 int     higrade                            125-126 ///
 int     higraded                           127-129 ///
 byte    educ99                             130-131 ///
 byte    empstat                            132 ///
 byte    empstatd                           133-134 ///
 byte    labforce                           135 ///
 int     occ                                136-138 ///
 int     occ1950                            139-141 ///
 int     occ1990                            142-144 ///
 int     ind                                145-147 ///
 int     ind1950                            148-150 ///
 int     ind1990                            151-153 ///
 byte    classwkr                           154 ///
 byte    classwkrd                          155-156 ///
 str    occsoc                             157-162 ///
 str    indnaics                           163-170 ///
 byte    wkswork1                           171-172 ///
 byte    wkswork2                           173 ///
 byte    hrswork1                           174-175 ///
 byte    hrswork2                           176 ///
 byte    uhrswork                           177-178 ///
 byte    qtrunemp                           179 ///
 byte    wksunemp                           180-181 ///
 int     durunemp                           182-184 ///
 byte    yrlastwk                           185-186 ///
 byte    activity                           187 ///
 byte    absent                             188 ///
 byte    looking                            189 ///
 byte    availble                           190 ///
 byte    wrkrecal                           191 ///
 byte    workedyr                           192 ///
 int     uocc                               193-195 ///
 int     uocc95                             196-198 ///
 int     uind                               199-201 ///
 byte    uclasswk                           202 ///
 int     rocc                               203-205 ///
 int     rind                               206-208 ///
 byte    rclasswk                           209 ///
 byte    hadnajob                           210 ///
 long    inctot                             211-216 ///
 long    incwage                            217-222 ///
 long    incbusfm                           223-227 ///
 long    incbus                             228-233 ///
 long    incbus00                           234-239 ///
 long    incfarm                            240-245 ///
 byte    incnonwg                           246 ///
 long    incss                              247-251 ///
 long    incwelfr                           252-256 ///
 long    incinvst                           257-262 ///
 long    incretir                           263-268 ///
 long    incsupp                            269-273 ///
 long    incother                           274-278 ///
 long    incearn                            279-284 ///
 byte    deducts                            285 ///
 int     poverty                            286-288 ///
  using "$startdir/$inputdata\ipums\1930\usa_1930.dat"

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
label var ftotinc `"Total family income"'
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
label var agemonth `"Age in months"'
label var birthmo `"Month of birth"'
label var birthqtr `"Quarter of birth"'
label var agemarr `"Age at first marriage"'
label var durmarr `"Duration of current marital status"'
label var marrno `"Times married"'
label var marrqtr `"Quarter of first marriage"'
label var widow `"Marriage ended by death"'
label var chborn `"Children ever born"'
label var race `"Race [general version]"'
label var raced `"Race [detailed version]"'
label var bpl `"Birthplace [general version]"'
label var bpld `"Birthplace [detailed version]"'
label var nativity `"Foreign birthplace or parentage"'
label var citizen `"Citizenship status"'
label var yrimmig `"Year of immigration"'
label var yrsusa1 `"Years in the United States"'
label var higrade `"Highest grade of schooling [general version]"'
label var higraded `"Highest grade of schooling [detailed version]"'
label var educ99 `"Educational attainment, 1990"'
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
label var hrswork1 `"Hours worked last week"'
label var hrswork2 `"Hours worked last week, intervalled"'
label var uhrswork `"Usual hours worked per week"'
label var qtrunemp `"Quarters unemployed last year"'
label var wksunemp `"Weeks unemployed last year"'
label var durunemp `"Continuous weeks unemployed"'
label var yrlastwk `"Year last worked"'
label var activity `"Main activity last week"'
label var absent `"Absent from work last week"'
label var looking `"Looking for work"'
label var availble `"Available for work"'
label var wrkrecal `"Informed of work recall"'
label var workedyr `"Worked last year"'
label var uocc `"Usual occupation"'
label var uocc95 `"Usual occupation, 1950 classification"'
label var uind `"Usual industry"'
label var uclasswk `"Usual class of worker"'
label var rocc `"Occupation, labor reserve"'
label var rind `"Industry, labor reserve"'
label var rclasswk `"Class of worker, labor reserve"'
label var hadnajob `"Had a non-active job last week"'
label var inctot `"Total personal income"'
label var incwage `"Wage and salary income"'
label var incbusfm `"Business and farm income"'
label var incbus `"Non-farm business income"'
label var incbus00 `"Business and farm income, 2000"'
label var incfarm `"Farm income"'
label var incnonwg `"Had non-wage/salary income over $50"'
label var incss `"Social Security income"'
label var incwelfr `"Welfare (public assistance) income"'
label var incinvst `"Interest, dividend, and rental income"'
label var incretir `"Retirement income"'
label var incsupp `"Supplementary Security Income"'
label var incother `"Other income"'
label var incearn `"Total personal earned income"'
label var deducts `"Deductions for retirement"'
label var poverty `"Poverty status"'

save "$startdir/$outputdata\usa_1930.dta", replace


#delimit;

keep year hhwt statefip relate;
rename statefip fips;
sort fips year;
collapse (sum) N=hhwt, by(fips year);
save "$startdir/$outputdata\population_1930.dta", replace;


use "$startdir/$outputdata\usa_1930.dta";

gen cohort=year-age;
drop momloc stepmom momrule poploc steppop poprule sploc sprule nsibs related;
drop if age<25;
drop if age>59;
drop if cohort<1881;
drop if cohort>1975;

keep if relate==1;
keep if sex==1;

save "$startdir/$outputdata\usa_1930_sample.dta", replace;
