/*=========================================
Title:  encyregs.do
Author: Mitchell Hoffman
Purpose: Compare occupations of rescuers (from Encyclopedia of
the Righteous Among the Nations to the general population)
=========================================*/

clear
clear matrix
set mem 1g

cd "C:\Users\Mitch"
capture log close
log using "Ency.log", replace

******************************************************* Belgium

clear
/*
. tab ocstatus if person=="Man"

      Occupational |
            status |      Freq.     Percent        Cum.
-------------------+-----------------------------------
     agrforestfish |         33       16.10       16.10
minmancommtrandmst |         91       44.39       60.49
    proflibpubserv |         81       39.51      100.00
-------------------+-----------------------------------
             Total |        205      100.00
*/



/*		
Farming, fishing, and forestry	18.3	497072
Mining, manufacturing, commerce, and service	74.4	2023501
Liberal Professions and Public Service	7.3	199715
		2720288
*/


capture drop r1 r2 r3
scalar r1 = 33
scalar r2 = 91
scalar r3 = 81
scalar p1 = 497072
scalar p2 = 2023501
scalar p3 = 199715


input rescuer class
1 1
1 2
1 3
0 1
0 2
0 3
end

expand r1 if rescuer==1 & class==1
expand r2 if rescuer==1 & class==2
expand r3 if rescuer==1 & class==3
expand p1-r1 if rescuer==0 & class==1
expand p2-r2 if rescuer==0 & class==2
expand p3-r3 if rescuer==0 & class==3

sum class
tab class if rescuer==1
tab class if rescuer==0
dlogit2 rescuer class, robust 


******************************************************* France

clear
/*
. tab ocstatus if person=="Man"

      Occupational |
            status |      Freq.     Percent        Cum.
-------------------+-----------------------------------
     agrforestfish |        120       27.46       27.46
minmancommtrandmst |        162       37.07       64.53
    proflibpubserv |        155       35.47      100.00
-------------------+-----------------------------------
             Total |        437      100.00
*/


/*
Farming, fishing, and forestry	34.1	4510447
Mining, manufacturing, commerce, and service	59.0	7803987
Liberal Professions and Public Service	7.0	923272
		13237706
*/



capture drop r1 r2 r3
scalar r1 = 120
scalar r2 = 162
scalar r3 = 155
scalar p1 = 4510447
scalar p2 = 7803987
scalar p3 = 923272


input rescuer class
1 1
1 2
1 3
0 1
0 2
0 3
end

expand r1 if rescuer==1 & class==1
expand r2 if rescuer==1 & class==2
expand r3 if rescuer==1 & class==3
expand p1-r1 if rescuer==0 & class==1
expand p2-r2 if rescuer==0 & class==2
expand p3-r3 if rescuer==0 & class==3

sum class
tab class if rescuer==1
tab class if rescuer==0
dlogit2 rescuer class, robust 


******************************************************* Netherlands

clear

/*
. tab ocstatus if person=="Man"

      Occupational |
            status |      Freq.     Percent        Cum.
-------------------+-----------------------------------
     agrforestfish |        194       26.04       26.04
minmancommtrandmst |        330       44.30       70.34
    proflibpubserv |        221       29.66      100.00
-------------------+-----------------------------------
             Total |        745      100.00
*/


/*	
Farming, fishing, and forestry	23.3	545524
Mining, Manufacturing, commerce, and service	71.4	1672283
Liberal Professions and Public Service	5.3	123622
		2341429
*/

capture drop r1 r2 r3
scalar r1 = 194
scalar r2 = 330
scalar r3 = 221
scalar p1 = 545524
scalar p2 = 1672283
scalar p3 = 123622


input rescuer class
1 1
1 2
1 3
0 1
0 2
0 3
end

expand r1 if rescuer==1 & class==1
expand r2 if rescuer==1 & class==2
expand r3 if rescuer==1 & class==3
expand p1-r1 if rescuer==0 & class==1
expand p2-r2 if rescuer==0 & class==2
expand p3-r3 if rescuer==0 & class==3

sum class
tab class if rescuer==1
tab class if rescuer==0
dlogit2 rescuer class, robust

******************************************************* Poland

clear
/*
. tab ocstatus if person=="Man" | person=="Woman"

      Occupational |
            status |      Freq.     Percent        Cum.
-------------------+-----------------------------------
     agrforestfish |      1,034       57.10       57.10
minmancommtrandmst |        489       27.00       84.10
    proflibpubserv |        288       15.90      100.00
-------------------+-----------------------------------
             Total |      1,811      100.00
*/




/*
Farming, fishing, and forestry	73.5	10002.402	10002402
Mining, manufacturing, commerce, transportation, and service	22.3	3027.700	3027700
Liberal Professions and Public Service	4.2	570.688	570688
		13600.79028	
*/


capture drop r1 r2 r3
scalar r1 = 1034
scalar r2 = 489
scalar r3 = 288
scalar p1 = 10002402
scalar p2 = 3027700
scalar p3 = 570688


input rescuer class
1 1
1 2
1 3
0 1
0 2
0 3
end

expand r1 if rescuer==1 & class==1
expand r2 if rescuer==1 & class==2
expand r3 if rescuer==1 & class==3
expand p1-r1 if rescuer==0 & class==1
expand p2-r2 if rescuer==0 & class==2
expand p3-r3 if rescuer==0 & class==3

sum class
tab class if rescuer==1
tab class if rescuer==0
dlogit2 rescuer class, robust


******************************************************* Slovakia

clear

/*
. tab ocstatus if person=="Man" | person=="Woman"

      Occupational |
            status |      Freq.     Percent        Cum.
-------------------+-----------------------------------
     agrforestfish |         76       52.78       52.78
minmancommtrandmst |         38       26.39       79.17
    proflibpubserv |         30       20.83      100.00
-------------------+-----------------------------------
             Total |        144      100.00
*/


/*		
Farming, fishing, and forestry	62.6	1892042
Mining, manufacturing, commerce, transportation, and service	32.2	973709
Liberal Professions and Public Service	5.2	155983
		3021734
*/




capture drop r1 r2 r3
scalar r1 = 76
scalar r2 = 38
scalar r3 = 30
scalar p1 = 1892042
scalar p2 = 973709
scalar p3 = 155983


input rescuer class
1 1
1 2
1 3
0 1
0 2
0 3
end

expand r1 if rescuer==1 & class==1
expand r2 if rescuer==1 & class==2
expand r3 if rescuer==1 & class==3
expand p1-r1 if rescuer==0 & class==1
expand p2-r2 if rescuer==0 & class==2
expand p3-r3 if rescuer==0 & class==3

sum class
tab class if rescuer==1
tab class if rescuer==0
dlogit2 rescuer class, robust

