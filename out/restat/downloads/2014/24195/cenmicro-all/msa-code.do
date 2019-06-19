/**
msa-code.do
This program takes a data set including statefips and
cntyfips and codes up extra variables msa and cmsa.

This program comes in 3 parts
1. Relabel all counties to the new coding system that
makes county geography consistent over time.  This code
is from county-change-code.do.
NOTE that NE county equivalents are taken care of
2. create codes msacmsa and pmsa.  This code is based on
msa-county.txt, which comes from Mable geocorr.
3. create final msa and cmsa codes

This is generic code meant to be run on any data set.
**/

set more off

****** DON'T FIX b/c BEFORE 1950 ***************
** Los Alamos, NM => Sandoval -- split from Sandoval & Santa Fe in 1949
*replace cntyfips = 43 if cntyfips==28 & statefips==35
***********************************************

******************** Part 1 ***************************

** La Paz County AZ Split off from Yuma County in 1983 => recombine
replace cntyfips = 27 if cntyfips==12 & statefips==4
** Miami-Dade County changed its fips code in 1997, use new one
replace cntyfips = 86 if cntyfips==25 & statefips==12
** Columbus City, GA merged into Muscogee County in 1971
replace cntyfips = 215 if cntyfips==510 & statefips==13 
** Old county consolidated into Fremont County Idaho
replace cntyfips = 43 if cntyfips==89 & statefips==16
** Ste Genevieve Co, MO changed codes in 1980
replace cntyfips = 193 if cntyfips==186 & statefips==29
** Carson City, NV created from (now defunct) Omsby County in 1969
replace cntyfips = 510 if cntyfips==25 & statefips==32
** Cibola county broke off from Valencia County in 1981
replace cntyfips = 61 if cntyfips==6 & statefips==35
** Two old Indian territories combined into counties in SD
replace cntyfips = 55 if cntyfips==1 & statefips==46
replace cntyfips = 71 if cntyfips==131 & statefips==46
** Washington County, SD absorbed into Shannon County in 1941
replace cntyfips = 113 if cntyfips==133 & statefips==46
** Old Consolidation in WI
replace cntyfips = 29 if cntyfips==47 & statefips==56

** Combine Independent Cities With Surrounding Counties in VA
replace cntyfips = 3  if cntyfips==540 & statefips==51
replace cntyfips = 5  if cntyfips==580 & statefips==51
replace cntyfips = 15 if cntyfips==790 & statefips==51
replace cntyfips = 15 if cntyfips==820 & statefips==51
replace cntyfips = 19 if cntyfips==515 & statefips==51
replace cntyfips = 41 if cntyfips==570 & statefips==51
replace cntyfips = 59 if cntyfips==600 & statefips==51
replace cntyfips = 59 if cntyfips==610 & statefips==51
replace cntyfips = 69 if cntyfips==840 & statefips==51
replace cntyfips = 77 if cntyfips==640 & statefips==51
replace cntyfips = 81 if cntyfips==595 & statefips==51
replace cntyfips = 83 if cntyfips==780 & statefips==51
replace cntyfips = 95 if cntyfips==830 & statefips==51
replace cntyfips = 121 if cntyfips==750 & statefips==51

**These are all consolidated into Norfolk and assigned
*code 129 (NOTE 129 ADDED TO MSA-COUNTY CODE BELOW)
replace cntyfips = 129 if cntyfips==550 & statefips==51
replace cntyfips = 129 if cntyfips==710 & statefips==51
replace cntyfips = 129 if cntyfips==740 & statefips==51
replace cntyfips = 129 if cntyfips==800 & statefips==51
replace cntyfips = 129 if cntyfips==810 & statefips==51

**
replace cntyfips = 143 if cntyfips==590 & statefips==51
**730 took part from 53 too but the 149 part is bigger
replace cntyfips = 149 if cntyfips==730 & statefips==51
replace cntyfips = 153 if cntyfips==683 & statefips==51
replace cntyfips = 153 if cntyfips==685 & statefips==51
replace cntyfips = 161 if cntyfips==770 & statefips==51
replace cntyfips = 161 if cntyfips==775 & statefips==51
replace cntyfips = 163 if cntyfips==530 & statefips==51
replace cntyfips = 163 if cntyfips==678 & statefips==51
replace cntyfips = 165 if cntyfips==660 & statefips==51
replace cntyfips = 175 if cntyfips==620 & statefips==51
replace cntyfips = 177 if cntyfips==630 & statefips==51
replace cntyfips = 191 if cntyfips==520 & statefips==51
replace cntyfips = 195 if cntyfips==720 & statefips==51
replace cntyfips = 199 if cntyfips==735 & statefips==51
**These counties existed in 1940 but don't exist today
*129 is a code resurrected for convenience
replace cntyfips = 129 if cntyfips==123 & statefips==51
replace cntyfips = 129 if cntyfips==154 & statefips==51
replace cntyfips = 129 if cntyfips==785 & statefips==51
replace cntyfips = 650 if cntyfips==55 & statefips==51
replace cntyfips = 700 if cntyfips==189 & statefips==51
replace cntyfips = 700 if cntyfips==815 & statefips==51

**Assign Menominee WI to Shawano - Menominee had been an indian reservation
replace cntyfips = 115 if cntyfips==78 & statefips==55


*************** Part 2 **************************

*** These are the msa/cmsa codes
gen msacmsa = -9
*** 129 is a county coded above
replace msacmsa = 5720 if statefips== 51 & cntyfips==129

** All But New England States
replace msacmsa = 960 if statefips== 36 & cntyfips==7
replace msacmsa = 960 if statefips== 36 & cntyfips==107
replace msacmsa = 9360 if statefips== 4 & cntyfips==27
replace msacmsa = 9340 if statefips== 6 & cntyfips==115
replace msacmsa = 9340 if statefips== 6 & cntyfips==101
replace msacmsa = 9320 if statefips== 39 & cntyfips==99
replace msacmsa = 9320 if statefips== 39 & cntyfips==29
replace msacmsa = 9320 if statefips== 39 & cntyfips==155
replace msacmsa = 9280 if statefips== 42 & cntyfips==133
replace msacmsa = 9260 if statefips== 53 & cntyfips==77
replace msacmsa = 9200 if statefips== 37 & cntyfips==19
replace msacmsa = 9200 if statefips== 37 & cntyfips==129
replace msacmsa = 920 if statefips== 28 & cntyfips==59
replace msacmsa = 920 if statefips== 28 & cntyfips==47
replace msacmsa = 920 if statefips== 28 & cntyfips==45
replace msacmsa = 9140 if statefips== 42 & cntyfips==81
replace msacmsa = 9080 if statefips== 48 & cntyfips==9
replace msacmsa = 9080 if statefips== 48 & cntyfips==485
replace msacmsa = 9040 if statefips== 20 & cntyfips==79
replace msacmsa = 9040 if statefips== 20 & cntyfips==173
replace msacmsa = 9040 if statefips== 20 & cntyfips==15
replace msacmsa = 9000 if statefips== 54 & cntyfips==69
replace msacmsa = 9000 if statefips== 54 & cntyfips==51
replace msacmsa = 9000 if statefips== 39 & cntyfips==13
replace msacmsa = 8960 if statefips== 12 & cntyfips==99
replace msacmsa = 8940 if statefips== 55 & cntyfips==73
replace msacmsa = 8920 if statefips== 19 & cntyfips==13
replace msacmsa = 8872 if statefips== 54 & cntyfips==37
replace msacmsa = 8872 if statefips== 54 & cntyfips==3
replace msacmsa = 8872 if statefips== 51 & cntyfips==99
replace msacmsa = 8872 if statefips== 51 & cntyfips==685
replace msacmsa = 8872 if statefips== 51 & cntyfips==683
replace msacmsa = 8872 if statefips== 51 & cntyfips==630
replace msacmsa = 8872 if statefips== 51 & cntyfips==610
replace msacmsa = 8872 if statefips== 51 & cntyfips==61
replace msacmsa = 8872 if statefips== 51 & cntyfips==600
replace msacmsa = 8872 if statefips== 51 & cntyfips==59
replace msacmsa = 8872 if statefips== 51 & cntyfips==510
replace msacmsa = 8872 if statefips== 51 & cntyfips==47
replace msacmsa = 8872 if statefips== 51 & cntyfips==43
replace msacmsa = 8872 if statefips== 51 & cntyfips==187
replace msacmsa = 8872 if statefips== 51 & cntyfips==179
replace msacmsa = 8872 if statefips== 51 & cntyfips==177
replace msacmsa = 8872 if statefips== 51 & cntyfips==153
replace msacmsa = 8872 if statefips== 51 & cntyfips==13
replace msacmsa = 8872 if statefips== 51 & cntyfips==107
replace msacmsa = 8872 if statefips== 24 & cntyfips==9
replace msacmsa = 8872 if statefips== 24 & cntyfips==510
replace msacmsa = 8872 if statefips== 24 & cntyfips==5
replace msacmsa = 8872 if statefips== 24 & cntyfips==43
replace msacmsa = 8872 if statefips== 24 & cntyfips==35
replace msacmsa = 8872 if statefips== 24 & cntyfips==33
replace msacmsa = 8872 if statefips== 24 & cntyfips==31
replace msacmsa = 8872 if statefips== 24 & cntyfips==3
replace msacmsa = 8872 if statefips== 24 & cntyfips==27
replace msacmsa = 8872 if statefips== 24 & cntyfips==25
replace msacmsa = 8872 if statefips== 24 & cntyfips==21
replace msacmsa = 8872 if statefips== 24 & cntyfips==17
replace msacmsa = 8872 if statefips== 24 & cntyfips==13
replace msacmsa = 8872 if statefips== 11 & cntyfips==1
replace msacmsa = 8800 if statefips== 48 & cntyfips==309
replace msacmsa = 880 if statefips== 30 & cntyfips==111
replace msacmsa = 8780 if statefips== 6 & cntyfips==107
replace msacmsa = 8750 if statefips== 48 & cntyfips==469
replace msacmsa = 870 if statefips== 26 & cntyfips==21
replace msacmsa = 8680 if statefips== 36 & cntyfips==65
replace msacmsa = 8680 if statefips== 36 & cntyfips==43
replace msacmsa = 8640 if statefips== 48 & cntyfips==423
replace msacmsa = 8600 if statefips== 1 & cntyfips==125
replace msacmsa = 860 if statefips== 53 & cntyfips==73
replace msacmsa = 8560 if statefips== 40 & cntyfips==37
replace msacmsa = 8560 if statefips== 40 & cntyfips==145
replace msacmsa = 8560 if statefips== 40 & cntyfips==143
replace msacmsa = 8560 if statefips== 40 & cntyfips==131
replace msacmsa = 8560 if statefips== 40 & cntyfips==113
replace msacmsa = 8520 if statefips== 4 & cntyfips==19
replace msacmsa = 8440 if statefips== 20 & cntyfips==177
replace msacmsa = 8400 if statefips== 39 & cntyfips==95
replace msacmsa = 8400 if statefips== 39 & cntyfips==51
replace msacmsa = 8400 if statefips== 39 & cntyfips==173
replace msacmsa = 840 if statefips== 48 & cntyfips==361
replace msacmsa = 840 if statefips== 48 & cntyfips==245
replace msacmsa = 840 if statefips== 48 & cntyfips==199
replace msacmsa = 8360 if statefips== 5 & cntyfips==91
replace msacmsa = 8360 if statefips== 48 & cntyfips==37
replace msacmsa = 8320 if statefips== 18 & cntyfips==21
replace msacmsa = 8320 if statefips== 18 & cntyfips==167
replace msacmsa = 8320 if statefips== 18 & cntyfips==165
replace msacmsa = 8280 if statefips== 12 & cntyfips==57
replace msacmsa = 8280 if statefips== 12 & cntyfips==53
replace msacmsa = 8280 if statefips== 12 & cntyfips==103
replace msacmsa = 8280 if statefips== 12 & cntyfips==101
replace msacmsa = 8240 if statefips== 12 & cntyfips==73
replace msacmsa = 8240 if statefips== 12 & cntyfips==39
replace msacmsa = 8160 if statefips== 36 & cntyfips==75
replace msacmsa = 8160 if statefips== 36 & cntyfips==67
replace msacmsa = 8160 if statefips== 36 & cntyfips==53
replace msacmsa = 8160 if statefips== 36 & cntyfips==11
replace msacmsa = 8140 if statefips== 45 & cntyfips==85
replace msacmsa = 8120 if statefips== 6 & cntyfips==77
replace msacmsa = 8080 if statefips== 54 & cntyfips==9
replace msacmsa = 8080 if statefips== 54 & cntyfips==29
replace msacmsa = 8080 if statefips== 39 & cntyfips==81
replace msacmsa = 8050 if statefips== 42 & cntyfips==27
replace msacmsa = 7920 if statefips== 29 & cntyfips==77
replace msacmsa = 7920 if statefips== 29 & cntyfips==43
replace msacmsa = 7920 if statefips== 29 & cntyfips==225
replace msacmsa = 7880 if statefips== 17 & cntyfips==167
replace msacmsa = 7880 if statefips== 17 & cntyfips==129
replace msacmsa = 7840 if statefips== 53 & cntyfips==63
replace msacmsa = 7800 if statefips== 18 & cntyfips==141
replace msacmsa = 7760 if statefips== 46 & cntyfips==99
replace msacmsa = 7760 if statefips== 46 & cntyfips==83
replace msacmsa = 7720 if statefips== 31 & cntyfips==43
replace msacmsa = 7720 if statefips== 19 & cntyfips==193
replace msacmsa = 7680 if statefips== 22 & cntyfips==17
replace msacmsa = 7680 if statefips== 22 & cntyfips==15
replace msacmsa = 7680 if statefips== 22 & cntyfips==119
replace msacmsa = 7640 if statefips== 48 & cntyfips==181
replace msacmsa = 7620 if statefips== 55 & cntyfips==117
replace msacmsa = 7610 if statefips== 42 & cntyfips==85
replace msacmsa = 7602 if statefips== 53 & cntyfips==67
replace msacmsa = 7602 if statefips== 53 & cntyfips==61
replace msacmsa = 7602 if statefips== 53 & cntyfips==53
replace msacmsa = 7602 if statefips== 53 & cntyfips==35
replace msacmsa = 7602 if statefips== 53 & cntyfips==33
replace msacmsa = 7602 if statefips== 53 & cntyfips==29
replace msacmsa = 760 if statefips== 22 & cntyfips==63
replace msacmsa = 760 if statefips== 22 & cntyfips==5
replace msacmsa = 760 if statefips== 22 & cntyfips==33
replace msacmsa = 760 if statefips== 22 & cntyfips==121
replace msacmsa = 7560 if statefips== 42 & cntyfips==79
replace msacmsa = 7560 if statefips== 42 & cntyfips==69
replace msacmsa = 7560 if statefips== 42 & cntyfips==37
replace msacmsa = 7560 if statefips== 42 & cntyfips==131
replace msacmsa = 7520 if statefips== 13 & cntyfips==51
replace msacmsa = 7520 if statefips== 13 & cntyfips==29
replace msacmsa = 7520 if statefips== 13 & cntyfips==103
replace msacmsa = 7510 if statefips== 12 & cntyfips==81
replace msacmsa = 7510 if statefips== 12 & cntyfips==115
replace msacmsa = 7490 if statefips== 35 & cntyfips==49
replace msacmsa = 7490 if statefips== 35 & cntyfips==28
replace msacmsa = 7480 if statefips== 6 & cntyfips==83
replace msacmsa = 7460 if statefips== 6 & cntyfips==79
replace msacmsa = 7362 if statefips== 6 & cntyfips==97
replace msacmsa = 7362 if statefips== 6 & cntyfips==95
replace msacmsa = 7362 if statefips== 6 & cntyfips==87
replace msacmsa = 7362 if statefips== 6 & cntyfips==85
replace msacmsa = 7362 if statefips== 6 & cntyfips==81
replace msacmsa = 7362 if statefips== 6 & cntyfips==75
replace msacmsa = 7362 if statefips== 6 & cntyfips==55
replace msacmsa = 7362 if statefips== 6 & cntyfips==41
replace msacmsa = 7362 if statefips== 6 & cntyfips==13
replace msacmsa = 7362 if statefips== 6 & cntyfips==1
replace msacmsa = 7320 if statefips== 6 & cntyfips==73
replace msacmsa = 7240 if statefips== 48 & cntyfips==91
replace msacmsa = 7240 if statefips== 48 & cntyfips==493
replace msacmsa = 7240 if statefips== 48 & cntyfips==29
replace msacmsa = 7240 if statefips== 48 & cntyfips==187
replace msacmsa = 7200 if statefips== 48 & cntyfips==451
replace msacmsa = 7160 if statefips== 49 & cntyfips==57
replace msacmsa = 7160 if statefips== 49 & cntyfips==35
replace msacmsa = 7160 if statefips== 49 & cntyfips==11
replace msacmsa = 7120 if statefips== 6 & cntyfips==53
replace msacmsa = 7040 if statefips== 29 & cntyfips==99
replace msacmsa = 7040 if statefips== 29 & cntyfips==71
replace msacmsa = 7040 if statefips== 29 & cntyfips==510
replace msacmsa = 7040 if statefips== 29 & cntyfips==219
replace msacmsa = 7040 if statefips== 29 & cntyfips==189
replace msacmsa = 7040 if statefips== 29 & cntyfips==183
replace msacmsa = 7040 if statefips== 29 & cntyfips==113
replace msacmsa = 7040 if statefips== 17 & cntyfips==83
replace msacmsa = 7040 if statefips== 17 & cntyfips==27
replace msacmsa = 7040 if statefips== 17 & cntyfips==163
replace msacmsa = 7040 if statefips== 17 & cntyfips==133
replace msacmsa = 7040 if statefips== 17 & cntyfips==119
replace msacmsa = 7000 if statefips== 29 & cntyfips==3
replace msacmsa = 7000 if statefips== 29 & cntyfips==21
replace msacmsa = 6980 if statefips== 27 & cntyfips==9
replace msacmsa = 6980 if statefips== 27 & cntyfips==145
replace msacmsa = 6960 if statefips== 26 & cntyfips==17
replace msacmsa = 6960 if statefips== 26 & cntyfips==145
replace msacmsa = 6960 if statefips== 26 & cntyfips==111
replace msacmsa = 6922 if statefips== 6 & cntyfips==67
replace msacmsa = 6922 if statefips== 6 & cntyfips==61
replace msacmsa = 6922 if statefips== 6 & cntyfips==17
replace msacmsa = 6922 if statefips== 6 & cntyfips==113
replace msacmsa = 6895 if statefips== 37 & cntyfips==65
replace msacmsa = 6895 if statefips== 37 & cntyfips==127
replace msacmsa = 6880 if statefips== 17 & cntyfips==7
replace msacmsa = 6880 if statefips== 17 & cntyfips==201
replace msacmsa = 6880 if statefips== 17 & cntyfips==141
replace msacmsa = 6840 if statefips== 36 & cntyfips==73
replace msacmsa = 6840 if statefips== 36 & cntyfips==69
replace msacmsa = 6840 if statefips== 36 & cntyfips==55
replace msacmsa = 6840 if statefips== 36 & cntyfips==51
replace msacmsa = 6840 if statefips== 36 & cntyfips==37
replace msacmsa = 6840 if statefips== 36 & cntyfips==117
replace msacmsa = 6820 if statefips== 27 & cntyfips==109
replace msacmsa = 6800 if statefips== 51 & cntyfips==775
replace msacmsa = 6800 if statefips== 51 & cntyfips==770
replace msacmsa = 6800 if statefips== 51 & cntyfips==23
replace msacmsa = 6800 if statefips== 51 & cntyfips==161
replace msacmsa = 680 if statefips== 6 & cntyfips==29
replace msacmsa = 6760 if statefips== 51 & cntyfips==87
replace msacmsa = 6760 if statefips== 51 & cntyfips==85
replace msacmsa = 6760 if statefips== 51 & cntyfips==760
replace msacmsa = 6760 if statefips== 51 & cntyfips==75
replace msacmsa = 6760 if statefips== 51 & cntyfips==730
replace msacmsa = 6760 if statefips== 51 & cntyfips==670
replace msacmsa = 6760 if statefips== 51 & cntyfips==570
replace msacmsa = 6760 if statefips== 51 & cntyfips==53
replace msacmsa = 6760 if statefips== 51 & cntyfips==41
replace msacmsa = 6760 if statefips== 51 & cntyfips==36
replace msacmsa = 6760 if statefips== 51 & cntyfips==149
replace msacmsa = 6760 if statefips== 51 & cntyfips==145
replace msacmsa = 6760 if statefips== 51 & cntyfips==127
replace msacmsa = 6740 if statefips== 53 & cntyfips==5
replace msacmsa = 6740 if statefips== 53 & cntyfips==21
replace msacmsa = 6720 if statefips== 32 & cntyfips==31
replace msacmsa = 6690 if statefips== 6 & cntyfips==89
replace msacmsa = 6680 if statefips== 42 & cntyfips==11
replace msacmsa = 6660 if statefips== 46 & cntyfips==103
replace msacmsa = 6640 if statefips== 37 & cntyfips==69
replace msacmsa = 6640 if statefips== 37 & cntyfips==63
replace msacmsa = 6640 if statefips== 37 & cntyfips==37
replace msacmsa = 6640 if statefips== 37 & cntyfips==183
replace msacmsa = 6640 if statefips== 37 & cntyfips==135
replace msacmsa = 6640 if statefips== 37 & cntyfips==101
replace msacmsa = 6580 if statefips== 12 & cntyfips==15
replace msacmsa = 6560 if statefips== 8 & cntyfips==101
replace msacmsa = 6520 if statefips== 49 & cntyfips==49
replace msacmsa = 6442 if statefips== 53 & cntyfips==11
replace msacmsa = 6442 if statefips== 41 & cntyfips==9
replace msacmsa = 6442 if statefips== 41 & cntyfips==71
replace msacmsa = 6442 if statefips== 41 & cntyfips==67
replace msacmsa = 6442 if statefips== 41 & cntyfips==53
replace msacmsa = 6442 if statefips== 41 & cntyfips==51
replace msacmsa = 6442 if statefips== 41 & cntyfips==5
replace msacmsa = 6442 if statefips== 41 & cntyfips==47
replace msacmsa = 640 if statefips== 48 & cntyfips==55
replace msacmsa = 640 if statefips== 48 & cntyfips==491
replace msacmsa = 640 if statefips== 48 & cntyfips==453
replace msacmsa = 640 if statefips== 48 & cntyfips==21
replace msacmsa = 640 if statefips== 48 & cntyfips==209
replace msacmsa = 6340 if statefips== 16 & cntyfips==5
replace msacmsa = 6280 if statefips== 42 & cntyfips==7
replace msacmsa = 6280 if statefips== 42 & cntyfips==51
replace msacmsa = 6280 if statefips== 42 & cntyfips==3
replace msacmsa = 6280 if statefips== 42 & cntyfips==19
replace msacmsa = 6280 if statefips== 42 & cntyfips==129
replace msacmsa = 6280 if statefips== 42 & cntyfips==125
replace msacmsa = 6240 if statefips== 5 & cntyfips==69
replace msacmsa = 6200 if statefips== 4 & cntyfips==21
replace msacmsa = 6200 if statefips== 4 & cntyfips==13
replace msacmsa = 6162 if statefips== 42 & cntyfips==91
replace msacmsa = 6162 if statefips== 42 & cntyfips==45
replace msacmsa = 6162 if statefips== 42 & cntyfips==29
replace msacmsa = 6162 if statefips== 42 & cntyfips==17
replace msacmsa = 6162 if statefips== 42 & cntyfips==101
replace msacmsa = 6162 if statefips== 34 & cntyfips==9
replace msacmsa = 6162 if statefips== 34 & cntyfips==7
replace msacmsa = 6162 if statefips== 34 & cntyfips==5
replace msacmsa = 6162 if statefips== 34 & cntyfips==33
replace msacmsa = 6162 if statefips== 34 & cntyfips==15
replace msacmsa = 6162 if statefips== 34 & cntyfips==11
replace msacmsa = 6162 if statefips== 34 & cntyfips==1
replace msacmsa = 6162 if statefips== 24 & cntyfips==15
replace msacmsa = 6162 if statefips== 10 & cntyfips==3
replace msacmsa = 6120 if statefips== 17 & cntyfips==203
replace msacmsa = 6120 if statefips== 17 & cntyfips==179
replace msacmsa = 6120 if statefips== 17 & cntyfips==143
replace msacmsa = 6080 if statefips== 12 & cntyfips==33
replace msacmsa = 6080 if statefips== 12 & cntyfips==113
replace msacmsa = 6020 if statefips== 54 & cntyfips==107
replace msacmsa = 6020 if statefips== 39 & cntyfips==167
replace msacmsa = 6015 if statefips== 12 & cntyfips==5
replace msacmsa = 600 if statefips== 45 & cntyfips==37
replace msacmsa = 600 if statefips== 45 & cntyfips==3
replace msacmsa = 600 if statefips== 13 & cntyfips==73
replace msacmsa = 600 if statefips== 13 & cntyfips==245
replace msacmsa = 600 if statefips== 13 & cntyfips==189
replace msacmsa = 5990 if statefips== 21 & cntyfips==59
replace msacmsa = 5960 if statefips== 12 & cntyfips==97
replace msacmsa = 5960 if statefips== 12 & cntyfips==95
replace msacmsa = 5960 if statefips== 12 & cntyfips==69
replace msacmsa = 5960 if statefips== 12 & cntyfips==117
replace msacmsa = 5920 if statefips== 31 & cntyfips==55
replace msacmsa = 5920 if statefips== 31 & cntyfips==25
replace msacmsa = 5920 if statefips== 31 & cntyfips==177
replace msacmsa = 5920 if statefips== 31 & cntyfips==153
replace msacmsa = 5920 if statefips== 19 & cntyfips==155
replace msacmsa = 5880 if statefips== 40 & cntyfips==87
replace msacmsa = 5880 if statefips== 40 & cntyfips==83
replace msacmsa = 5880 if statefips== 40 & cntyfips==27
replace msacmsa = 5880 if statefips== 40 & cntyfips==17
replace msacmsa = 5880 if statefips== 40 & cntyfips==125
replace msacmsa = 5880 if statefips== 40 & cntyfips==109
replace msacmsa = 5800 if statefips== 48 & cntyfips==329
replace msacmsa = 5800 if statefips== 48 & cntyfips==135
replace msacmsa = 580 if statefips== 1 & cntyfips==81
replace msacmsa = 5790 if statefips== 12 & cntyfips==83
replace msacmsa = 5720 if statefips== 51 & cntyfips==95
replace msacmsa = 5720 if statefips== 51 & cntyfips==93
replace msacmsa = 5720 if statefips== 51 & cntyfips==830
replace msacmsa = 5720 if statefips== 51 & cntyfips==810
replace msacmsa = 5720 if statefips== 51 & cntyfips==800
replace msacmsa = 5720 if statefips== 51 & cntyfips==740
replace msacmsa = 5720 if statefips== 51 & cntyfips==735
replace msacmsa = 5720 if statefips== 51 & cntyfips==73
replace msacmsa = 5720 if statefips== 51 & cntyfips==710
replace msacmsa = 5720 if statefips== 51 & cntyfips==700
replace msacmsa = 5720 if statefips== 51 & cntyfips==650
replace msacmsa = 5720 if statefips== 51 & cntyfips==550
replace msacmsa = 5720 if statefips== 51 & cntyfips==199
replace msacmsa = 5720 if statefips== 51 & cntyfips==115
replace msacmsa = 5720 if statefips== 37 & cntyfips==53
replace msacmsa = 5602 if statefips== 42 & cntyfips==103
replace msacmsa = 5602 if statefips== 36 & cntyfips==87
replace msacmsa = 5602 if statefips== 36 & cntyfips==85
replace msacmsa = 5602 if statefips== 36 & cntyfips==81
replace msacmsa = 5602 if statefips== 36 & cntyfips==79
replace msacmsa = 5602 if statefips== 36 & cntyfips==71
replace msacmsa = 5602 if statefips== 36 & cntyfips==61
replace msacmsa = 5602 if statefips== 36 & cntyfips==59
replace msacmsa = 5602 if statefips== 36 & cntyfips==5
replace msacmsa = 5602 if statefips== 36 & cntyfips==47
replace msacmsa = 5602 if statefips== 36 & cntyfips==27
replace msacmsa = 5602 if statefips== 36 & cntyfips==119
replace msacmsa = 5602 if statefips== 36 & cntyfips==103
replace msacmsa = 5602 if statefips== 34 & cntyfips==41
replace msacmsa = 5602 if statefips== 34 & cntyfips==39
replace msacmsa = 5602 if statefips== 34 & cntyfips==37
replace msacmsa = 5602 if statefips== 34 & cntyfips==35
replace msacmsa = 5602 if statefips== 34 & cntyfips==31
replace msacmsa = 5602 if statefips== 34 & cntyfips==3
replace msacmsa = 5602 if statefips== 34 & cntyfips==29
replace msacmsa = 5602 if statefips== 34 & cntyfips==27
replace msacmsa = 5602 if statefips== 34 & cntyfips==25
replace msacmsa = 5602 if statefips== 34 & cntyfips==23
replace msacmsa = 5602 if statefips== 34 & cntyfips==21
replace msacmsa = 5602 if statefips== 34 & cntyfips==19
replace msacmsa = 5602 if statefips== 34 & cntyfips==17
replace msacmsa = 5602 if statefips== 34 & cntyfips==13
replace msacmsa = 5560 if statefips== 22 & cntyfips==95
replace msacmsa = 5560 if statefips== 22 & cntyfips==93
replace msacmsa = 5560 if statefips== 22 & cntyfips==89
replace msacmsa = 5560 if statefips== 22 & cntyfips==87
replace msacmsa = 5560 if statefips== 22 & cntyfips==75
replace msacmsa = 5560 if statefips== 22 & cntyfips==71
replace msacmsa = 5560 if statefips== 22 & cntyfips==51
replace msacmsa = 5560 if statefips== 22 & cntyfips==103
replace msacmsa = 5360 if statefips== 47 & cntyfips==43
replace msacmsa = 5360 if statefips== 47 & cntyfips==37
replace msacmsa = 5360 if statefips== 47 & cntyfips==21
replace msacmsa = 5360 if statefips== 47 & cntyfips==189
replace msacmsa = 5360 if statefips== 47 & cntyfips==187
replace msacmsa = 5360 if statefips== 47 & cntyfips==165
replace msacmsa = 5360 if statefips== 47 & cntyfips==149
replace msacmsa = 5360 if statefips== 47 & cntyfips==147
replace msacmsa = 5345 if statefips== 12 & cntyfips==21
replace msacmsa = 5330 if statefips== 45 & cntyfips==51
replace msacmsa = 5280 if statefips== 18 & cntyfips==35
replace msacmsa = 5240 if statefips== 1 & cntyfips==51
replace msacmsa = 5240 if statefips== 1 & cntyfips==101
replace msacmsa = 5240 if statefips== 1 & cntyfips==1
replace msacmsa = 5200 if statefips== 22 & cntyfips==73
replace msacmsa = 520 if statefips== 13 & cntyfips==97
replace msacmsa = 520 if statefips== 13 & cntyfips==89
replace msacmsa = 520 if statefips== 13 & cntyfips==77
replace msacmsa = 520 if statefips== 13 & cntyfips==67
replace msacmsa = 520 if statefips== 13 & cntyfips==63
replace msacmsa = 520 if statefips== 13 & cntyfips==57
replace msacmsa = 520 if statefips== 13 & cntyfips==45
replace msacmsa = 520 if statefips== 13 & cntyfips==297
replace msacmsa = 520 if statefips== 13 & cntyfips==255
replace msacmsa = 520 if statefips== 13 & cntyfips==247
replace msacmsa = 520 if statefips== 13 & cntyfips==227
replace msacmsa = 520 if statefips== 13 & cntyfips==223
replace msacmsa = 520 if statefips== 13 & cntyfips==217
replace msacmsa = 520 if statefips== 13 & cntyfips==151
replace msacmsa = 520 if statefips== 13 & cntyfips==15
replace msacmsa = 520 if statefips== 13 & cntyfips==135
replace msacmsa = 520 if statefips== 13 & cntyfips==13
replace msacmsa = 520 if statefips== 13 & cntyfips==121
replace msacmsa = 520 if statefips== 13 & cntyfips==117
replace msacmsa = 520 if statefips== 13 & cntyfips==113
replace msacmsa = 5170 if statefips== 6 & cntyfips==99
replace msacmsa = 5160 if statefips== 1 & cntyfips==97
replace msacmsa = 5160 if statefips== 1 & cntyfips==3
replace msacmsa = 5140 if statefips== 30 & cntyfips==63
replace msacmsa = 5120 if statefips== 55 & cntyfips==93
replace msacmsa = 5120 if statefips== 55 & cntyfips==109
replace msacmsa = 5120 if statefips== 27 & cntyfips==59
replace msacmsa = 5120 if statefips== 27 & cntyfips==53
replace msacmsa = 5120 if statefips== 27 & cntyfips==37
replace msacmsa = 5120 if statefips== 27 & cntyfips==3
replace msacmsa = 5120 if statefips== 27 & cntyfips==25
replace msacmsa = 5120 if statefips== 27 & cntyfips==19
replace msacmsa = 5120 if statefips== 27 & cntyfips==171
replace msacmsa = 5120 if statefips== 27 & cntyfips==163
replace msacmsa = 5120 if statefips== 27 & cntyfips==141
replace msacmsa = 5120 if statefips== 27 & cntyfips==139
replace msacmsa = 5120 if statefips== 27 & cntyfips==123
replace msacmsa = 5082 if statefips== 55 & cntyfips==89
replace msacmsa = 5082 if statefips== 55 & cntyfips==79
replace msacmsa = 5082 if statefips== 55 & cntyfips==133
replace msacmsa = 5082 if statefips== 55 & cntyfips==131
replace msacmsa = 5082 if statefips== 55 & cntyfips==101
replace msacmsa = 500 if statefips== 13 & cntyfips==59
replace msacmsa = 500 if statefips== 13 & cntyfips==219
replace msacmsa = 500 if statefips== 13 & cntyfips==195
replace msacmsa = 4992 if statefips== 12 & cntyfips==86
replace msacmsa = 4992 if statefips== 12 & cntyfips==11
replace msacmsa = 4940 if statefips== 6 & cntyfips==47
replace msacmsa = 4920 if statefips== 5 & cntyfips==35
replace msacmsa = 4920 if statefips== 47 & cntyfips==47
replace msacmsa = 4920 if statefips== 47 & cntyfips==167
replace msacmsa = 4920 if statefips== 47 & cntyfips==157
replace msacmsa = 4920 if statefips== 28 & cntyfips==33
replace msacmsa = 4900 if statefips== 12 & cntyfips==9
replace msacmsa = 4890 if statefips== 41 & cntyfips==29
replace msacmsa = 4880 if statefips== 48 & cntyfips==215
replace msacmsa = 4800 if statefips== 39 & cntyfips==33
replace msacmsa = 4800 if statefips== 39 & cntyfips==139
replace msacmsa = 480 if statefips== 37 & cntyfips==21
replace msacmsa = 480 if statefips== 37 & cntyfips==115
replace msacmsa = 4720 if statefips== 55 & cntyfips==25
replace msacmsa = 4680 if statefips== 13 & cntyfips==289
replace msacmsa = 4680 if statefips== 13 & cntyfips==225
replace msacmsa = 4680 if statefips== 13 & cntyfips==21
replace msacmsa = 4680 if statefips== 13 & cntyfips==169
replace msacmsa = 4680 if statefips== 13 & cntyfips==153
replace msacmsa = 4640 if statefips== 51 & cntyfips==9
replace msacmsa = 4640 if statefips== 51 & cntyfips==680
replace msacmsa = 4640 if statefips== 51 & cntyfips==515
replace msacmsa = 4640 if statefips== 51 & cntyfips==31
replace msacmsa = 4640 if statefips== 51 & cntyfips==19
replace msacmsa = 4600 if statefips== 48 & cntyfips==303
replace msacmsa = 460 if statefips== 55 & cntyfips==87
replace msacmsa = 460 if statefips== 55 & cntyfips==15
replace msacmsa = 460 if statefips== 55 & cntyfips==139
replace msacmsa = 4520 if statefips== 21 & cntyfips==29
replace msacmsa = 4520 if statefips== 21 & cntyfips==185
replace msacmsa = 4520 if statefips== 21 & cntyfips==111
replace msacmsa = 4520 if statefips== 18 & cntyfips==61
replace msacmsa = 4520 if statefips== 18 & cntyfips==43
replace msacmsa = 4520 if statefips== 18 & cntyfips==19
replace msacmsa = 4520 if statefips== 18 & cntyfips==143
replace msacmsa = 450 if statefips== 1 & cntyfips==15
replace msacmsa = 4472 if statefips== 6 & cntyfips==71
replace msacmsa = 4472 if statefips== 6 & cntyfips==65
replace msacmsa = 4472 if statefips== 6 & cntyfips==59
replace msacmsa = 4472 if statefips== 6 & cntyfips==37
replace msacmsa = 4472 if statefips== 6 & cntyfips==111
replace msacmsa = 4420 if statefips== 48 & cntyfips==459
replace msacmsa = 4420 if statefips== 48 & cntyfips==203
replace msacmsa = 4420 if statefips== 48 & cntyfips==183
replace msacmsa = 4400 if statefips== 5 & cntyfips==85
replace msacmsa = 4400 if statefips== 5 & cntyfips==45
replace msacmsa = 4400 if statefips== 5 & cntyfips==125
replace msacmsa = 4400 if statefips== 5 & cntyfips==119
replace msacmsa = 4360 if statefips== 31 & cntyfips==109
replace msacmsa = 4320 if statefips== 39 & cntyfips==3
replace msacmsa = 4320 if statefips== 39 & cntyfips==11
replace msacmsa = 4280 if statefips== 21 & cntyfips==67
replace msacmsa = 4280 if statefips== 21 & cntyfips==49
replace msacmsa = 4280 if statefips== 21 & cntyfips==239
replace msacmsa = 4280 if statefips== 21 & cntyfips==209
replace msacmsa = 4280 if statefips== 21 & cntyfips==17
replace msacmsa = 4280 if statefips== 21 & cntyfips==151
replace msacmsa = 4280 if statefips== 21 & cntyfips==113
replace msacmsa = 4200 if statefips== 40 & cntyfips==31
replace msacmsa = 4150 if statefips== 20 & cntyfips==45
replace msacmsa = 4120 if statefips== 4 & cntyfips==15
replace msacmsa = 4120 if statefips== 32 & cntyfips==3
replace msacmsa = 4120 if statefips== 32 & cntyfips==23
replace msacmsa = 4100 if statefips== 35 & cntyfips==13
replace msacmsa = 4080 if statefips== 48 & cntyfips==479
replace msacmsa = 4040 if statefips== 26 & cntyfips==65
replace msacmsa = 4040 if statefips== 26 & cntyfips==45
replace msacmsa = 4040 if statefips== 26 & cntyfips==37
replace msacmsa = 4000 if statefips== 42 & cntyfips==71
replace msacmsa = 40 if statefips== 48 & cntyfips==441
replace msacmsa = 3980 if statefips== 12 & cntyfips==105
replace msacmsa = 3960 if statefips== 22 & cntyfips==19
replace msacmsa = 3920 if statefips== 18 & cntyfips==23
replace msacmsa = 3920 if statefips== 18 & cntyfips==157
replace msacmsa = 3880 if statefips== 22 & cntyfips==99
replace msacmsa = 3880 if statefips== 22 & cntyfips==97
replace msacmsa = 3880 if statefips== 22 & cntyfips==55
replace msacmsa = 3880 if statefips== 22 & cntyfips==1
replace msacmsa = 3870 if statefips== 55 & cntyfips==63
replace msacmsa = 3870 if statefips== 27 & cntyfips==55
replace msacmsa = 3850 if statefips== 18 & cntyfips==67
replace msacmsa = 3850 if statefips== 18 & cntyfips==159
replace msacmsa = 3840 if statefips== 47 & cntyfips==93
replace msacmsa = 3840 if statefips== 47 & cntyfips==9
replace msacmsa = 3840 if statefips== 47 & cntyfips==173
replace msacmsa = 3840 if statefips== 47 & cntyfips==155
replace msacmsa = 3840 if statefips== 47 & cntyfips==105
replace msacmsa = 3840 if statefips== 47 & cntyfips==1
replace msacmsa = 3810 if statefips== 48 & cntyfips==99
replace msacmsa = 3810 if statefips== 48 & cntyfips==27
replace msacmsa = 380 if statefips== 2 & cntyfips==20
replace msacmsa = 3760 if statefips== 29 & cntyfips==95
replace msacmsa = 3760 if statefips== 29 & cntyfips==49
replace msacmsa = 3760 if statefips== 29 & cntyfips==47
replace msacmsa = 3760 if statefips== 29 & cntyfips==37
replace msacmsa = 3760 if statefips== 29 & cntyfips==177
replace msacmsa = 3760 if statefips== 29 & cntyfips==165
replace msacmsa = 3760 if statefips== 29 & cntyfips==107
replace msacmsa = 3760 if statefips== 20 & cntyfips==91
replace msacmsa = 3760 if statefips== 20 & cntyfips==209
replace msacmsa = 3760 if statefips== 20 & cntyfips==121
replace msacmsa = 3760 if statefips== 20 & cntyfips==103
replace msacmsa = 3720 if statefips== 26 & cntyfips==77
replace msacmsa = 3720 if statefips== 26 & cntyfips==25
replace msacmsa = 3720 if statefips== 26 & cntyfips==159
replace msacmsa = 3710 if statefips== 29 & cntyfips==97
replace msacmsa = 3710 if statefips== 29 & cntyfips==145
replace msacmsa = 3700 if statefips== 5 & cntyfips==31
replace msacmsa = 3680 if statefips== 42 & cntyfips==21
replace msacmsa = 3680 if statefips== 42 & cntyfips==111
replace msacmsa = 3660 if statefips== 51 & cntyfips==520
replace msacmsa = 3660 if statefips== 51 & cntyfips==191
replace msacmsa = 3660 if statefips== 51 & cntyfips==169
replace msacmsa = 3660 if statefips== 47 & cntyfips==73
replace msacmsa = 3660 if statefips== 47 & cntyfips==19
replace msacmsa = 3660 if statefips== 47 & cntyfips==179
replace msacmsa = 3660 if statefips== 47 & cntyfips==171
replace msacmsa = 3660 if statefips== 47 & cntyfips==163
replace msacmsa = 3620 if statefips== 55 & cntyfips==105
replace msacmsa = 3610 if statefips== 36 & cntyfips==13
replace msacmsa = 3605 if statefips== 37 & cntyfips==133
replace msacmsa = 3600 if statefips== 12 & cntyfips==89
replace msacmsa = 3600 if statefips== 12 & cntyfips==31
replace msacmsa = 3600 if statefips== 12 & cntyfips==19
replace msacmsa = 3600 if statefips== 12 & cntyfips==109
replace msacmsa = 3580 if statefips== 47 & cntyfips==23
replace msacmsa = 3580 if statefips== 47 & cntyfips==113
replace msacmsa = 3560 if statefips== 28 & cntyfips==89
replace msacmsa = 3560 if statefips== 28 & cntyfips==49
replace msacmsa = 3560 if statefips== 28 & cntyfips==121
replace msacmsa = 3520 if statefips== 26 & cntyfips==75
replace msacmsa = 3500 if statefips== 19 & cntyfips==103
replace msacmsa = 3480 if statefips== 18 & cntyfips==97
replace msacmsa = 3480 if statefips== 18 & cntyfips==95
replace msacmsa = 3480 if statefips== 18 & cntyfips==81
replace msacmsa = 3480 if statefips== 18 & cntyfips==63
replace msacmsa = 3480 if statefips== 18 & cntyfips==59
replace msacmsa = 3480 if statefips== 18 & cntyfips==57
replace msacmsa = 3480 if statefips== 18 & cntyfips==145
replace msacmsa = 3480 if statefips== 18 & cntyfips==11
replace msacmsa = 3480 if statefips== 18 & cntyfips==109
replace msacmsa = 3440 if statefips== 1 & cntyfips==89
replace msacmsa = 3440 if statefips== 1 & cntyfips==83
replace msacmsa = 3400 if statefips== 54 & cntyfips==99
replace msacmsa = 3400 if statefips== 54 & cntyfips==11
replace msacmsa = 3400 if statefips== 39 & cntyfips==87
replace msacmsa = 3400 if statefips== 21 & cntyfips==89
replace msacmsa = 3400 if statefips== 21 & cntyfips==43
replace msacmsa = 3400 if statefips== 21 & cntyfips==19
replace msacmsa = 3362 if statefips== 48 & cntyfips==71
replace msacmsa = 3362 if statefips== 48 & cntyfips==473
replace msacmsa = 3362 if statefips== 48 & cntyfips==39
replace msacmsa = 3362 if statefips== 48 & cntyfips==339
replace msacmsa = 3362 if statefips== 48 & cntyfips==291
replace msacmsa = 3362 if statefips== 48 & cntyfips==201
replace msacmsa = 3362 if statefips== 48 & cntyfips==167
replace msacmsa = 3362 if statefips== 48 & cntyfips==157
replace msacmsa = 3350 if statefips== 22 & cntyfips==57
replace msacmsa = 3350 if statefips== 22 & cntyfips==109
replace msacmsa = 3320 if statefips== 15 & cntyfips==3
replace msacmsa = 3290 if statefips== 37 & cntyfips==35
replace msacmsa = 3290 if statefips== 37 & cntyfips==3
replace msacmsa = 3290 if statefips== 37 & cntyfips==27
replace msacmsa = 3290 if statefips== 37 & cntyfips==23
replace msacmsa = 3285 if statefips== 28 & cntyfips==73
replace msacmsa = 3285 if statefips== 28 & cntyfips==35
replace msacmsa = 3240 if statefips== 42 & cntyfips==99
replace msacmsa = 3240 if statefips== 42 & cntyfips==75
replace msacmsa = 3240 if statefips== 42 & cntyfips==43
replace msacmsa = 3240 if statefips== 42 & cntyfips==41
replace msacmsa = 320 if statefips== 48 & cntyfips==381
replace msacmsa = 320 if statefips== 48 & cntyfips==375
replace msacmsa = 3160 if statefips== 45 & cntyfips==83
replace msacmsa = 3160 if statefips== 45 & cntyfips==77
replace msacmsa = 3160 if statefips== 45 & cntyfips==7
replace msacmsa = 3160 if statefips== 45 & cntyfips==45
replace msacmsa = 3160 if statefips== 45 & cntyfips==21
replace msacmsa = 3150 if statefips== 37 & cntyfips==147
replace msacmsa = 3120 if statefips== 37 & cntyfips==81
replace msacmsa = 3120 if statefips== 37 & cntyfips==67
replace msacmsa = 3120 if statefips== 37 & cntyfips==59
replace msacmsa = 3120 if statefips== 37 & cntyfips==57
replace msacmsa = 3120 if statefips== 37 & cntyfips==197
replace msacmsa = 3120 if statefips== 37 & cntyfips==169
replace msacmsa = 3120 if statefips== 37 & cntyfips==151
replace msacmsa = 3120 if statefips== 37 & cntyfips==1
replace msacmsa = 3080 if statefips== 55 & cntyfips==9
replace msacmsa = 3040 if statefips== 30 & cntyfips==13
replace msacmsa = 3000 if statefips== 26 & cntyfips==81
replace msacmsa = 3000 if statefips== 26 & cntyfips==5
replace msacmsa = 3000 if statefips== 26 & cntyfips==139
replace msacmsa = 3000 if statefips== 26 & cntyfips==121
replace msacmsa = 2995 if statefips== 8 & cntyfips==77
replace msacmsa = 2985 if statefips== 38 & cntyfips==35
replace msacmsa = 2985 if statefips== 27 & cntyfips==119
replace msacmsa = 2980 if statefips== 37 & cntyfips==191
replace msacmsa = 2975 if statefips== 36 & cntyfips==115
replace msacmsa = 2975 if statefips== 36 & cntyfips==113
replace msacmsa = 2900 if statefips== 12 & cntyfips==1
replace msacmsa = 2880 if statefips== 1 & cntyfips==55
replace msacmsa = 2840 if statefips== 6 & cntyfips==39
replace msacmsa = 2840 if statefips== 6 & cntyfips==19
replace msacmsa = 280 if statefips== 42 & cntyfips==13
replace msacmsa = 2760 if statefips== 18 & cntyfips==69
replace msacmsa = 2760 if statefips== 18 & cntyfips==33
replace msacmsa = 2760 if statefips== 18 & cntyfips==3
replace msacmsa = 2760 if statefips== 18 & cntyfips==183
replace msacmsa = 2760 if statefips== 18 & cntyfips==179
replace msacmsa = 2760 if statefips== 18 & cntyfips==1
replace msacmsa = 2750 if statefips== 12 & cntyfips==91
replace msacmsa = 2720 if statefips== 5 & cntyfips==33
replace msacmsa = 2720 if statefips== 5 & cntyfips==131
replace msacmsa = 2720 if statefips== 40 & cntyfips==135
replace msacmsa = 2710 if statefips== 12 & cntyfips==85
replace msacmsa = 2710 if statefips== 12 & cntyfips==111
replace msacmsa = 2700 if statefips== 12 & cntyfips==71
replace msacmsa = 2670 if statefips== 8 & cntyfips==69
replace msacmsa = 2655 if statefips== 45 & cntyfips==41
replace msacmsa = 2650 if statefips== 1 & cntyfips==77
replace msacmsa = 2650 if statefips== 1 & cntyfips==33
replace msacmsa = 2620 if statefips== 49 & cntyfips==25
replace msacmsa = 2620 if statefips== 4 & cntyfips==5
replace msacmsa = 2580 if statefips== 5 & cntyfips==7
replace msacmsa = 2580 if statefips== 5 & cntyfips==143
replace msacmsa = 2560 if statefips== 37 & cntyfips==51
replace msacmsa = 2520 if statefips== 38 & cntyfips==17
replace msacmsa = 2520 if statefips== 27 & cntyfips==27
replace msacmsa = 2440 if statefips== 21 & cntyfips==101
replace msacmsa = 2440 if statefips== 18 & cntyfips==173
replace msacmsa = 2440 if statefips== 18 & cntyfips==163
replace msacmsa = 2440 if statefips== 18 & cntyfips==129
replace msacmsa = 2400 if statefips== 41 & cntyfips==39
replace msacmsa = 240 if statefips== 42 & cntyfips==95
replace msacmsa = 240 if statefips== 42 & cntyfips==77
replace msacmsa = 240 if statefips== 42 & cntyfips==25
replace msacmsa = 2360 if statefips== 42 & cntyfips==49
replace msacmsa = 2340 if statefips== 40 & cntyfips==47
replace msacmsa = 2335 if statefips== 36 & cntyfips==15
replace msacmsa = 2330 if statefips== 18 & cntyfips==39
replace msacmsa = 2320 if statefips== 48 & cntyfips==141
replace msacmsa = 2290 if statefips== 55 & cntyfips==35
replace msacmsa = 2290 if statefips== 55 & cntyfips==17
replace msacmsa = 2240 if statefips== 55 & cntyfips==31
replace msacmsa = 2240 if statefips== 27 & cntyfips==137
replace msacmsa = 2200 if statefips== 19 & cntyfips==61
replace msacmsa = 220 if statefips== 22 & cntyfips==79
replace msacmsa = 2190 if statefips== 10 & cntyfips==1
replace msacmsa = 2180 if statefips== 1 & cntyfips==69
replace msacmsa = 2180 if statefips== 1 & cntyfips==45
replace msacmsa = 2162 if statefips== 26 & cntyfips==99
replace msacmsa = 2162 if statefips== 26 & cntyfips==93
replace msacmsa = 2162 if statefips== 26 & cntyfips==91
replace msacmsa = 2162 if statefips== 26 & cntyfips==87
replace msacmsa = 2162 if statefips== 26 & cntyfips==49
replace msacmsa = 2162 if statefips== 26 & cntyfips==163
replace msacmsa = 2162 if statefips== 26 & cntyfips==161
replace msacmsa = 2162 if statefips== 26 & cntyfips==147
replace msacmsa = 2162 if statefips== 26 & cntyfips==125
replace msacmsa = 2162 if statefips== 26 & cntyfips==115
replace msacmsa = 2120 if statefips== 19 & cntyfips==49
replace msacmsa = 2120 if statefips== 19 & cntyfips==181
replace msacmsa = 2120 if statefips== 19 & cntyfips==153
replace msacmsa = 2082 if statefips== 8 & cntyfips==59
replace msacmsa = 2082 if statefips== 8 & cntyfips==5
replace msacmsa = 2082 if statefips== 8 & cntyfips==35
replace msacmsa = 2082 if statefips== 8 & cntyfips==31
replace msacmsa = 2082 if statefips== 8 & cntyfips==13
replace msacmsa = 2082 if statefips== 8 & cntyfips==123
replace msacmsa = 2082 if statefips== 8 & cntyfips==1
replace msacmsa = 2040 if statefips== 17 & cntyfips==115
replace msacmsa = 2030 if statefips== 1 & cntyfips==79
replace msacmsa = 2030 if statefips== 1 & cntyfips==103
replace msacmsa = 2020 if statefips== 12 & cntyfips==35
replace msacmsa = 2020 if statefips== 12 & cntyfips==127
replace msacmsa = 2000 if statefips== 39 & cntyfips==57
replace msacmsa = 2000 if statefips== 39 & cntyfips==23
replace msacmsa = 2000 if statefips== 39 & cntyfips==113
replace msacmsa = 2000 if statefips== 39 & cntyfips==109
replace msacmsa = 200 if statefips== 35 & cntyfips==61
replace msacmsa = 200 if statefips== 35 & cntyfips==43
replace msacmsa = 200 if statefips== 35 & cntyfips==1
replace msacmsa = 1960 if statefips== 19 & cntyfips==163
replace msacmsa = 1960 if statefips== 17 & cntyfips==73
replace msacmsa = 1960 if statefips== 17 & cntyfips==161
replace msacmsa = 1950 if statefips== 51 & cntyfips==590
replace msacmsa = 1950 if statefips== 51 & cntyfips==143
replace msacmsa = 1922 if statefips== 48 & cntyfips==85
replace msacmsa = 1922 if statefips== 48 & cntyfips==439
replace msacmsa = 1922 if statefips== 48 & cntyfips==397
replace msacmsa = 1922 if statefips== 48 & cntyfips==367
replace msacmsa = 1922 if statefips== 48 & cntyfips==257
replace msacmsa = 1922 if statefips== 48 & cntyfips==251
replace msacmsa = 1922 if statefips== 48 & cntyfips==231
replace msacmsa = 1922 if statefips== 48 & cntyfips==221
replace msacmsa = 1922 if statefips== 48 & cntyfips==213
replace msacmsa = 1922 if statefips== 48 & cntyfips==139
replace msacmsa = 1922 if statefips== 48 & cntyfips==121
replace msacmsa = 1922 if statefips== 48 & cntyfips==113
replace msacmsa = 1900 if statefips== 54 & cntyfips==57
replace msacmsa = 1900 if statefips== 24 & cntyfips==1
replace msacmsa = 1890 if statefips== 41 & cntyfips==3
replace msacmsa = 1880 if statefips== 48 & cntyfips==409
replace msacmsa = 1880 if statefips== 48 & cntyfips==355
replace msacmsa = 1840 if statefips== 39 & cntyfips==97
replace msacmsa = 1840 if statefips== 39 & cntyfips==89
replace msacmsa = 1840 if statefips== 39 & cntyfips==49
replace msacmsa = 1840 if statefips== 39 & cntyfips==45
replace msacmsa = 1840 if statefips== 39 & cntyfips==41
replace msacmsa = 1840 if statefips== 39 & cntyfips==129
replace msacmsa = 1800 if statefips== 13 & cntyfips==53
replace msacmsa = 1800 if statefips== 13 & cntyfips==215
replace msacmsa = 1800 if statefips== 13 & cntyfips==145
replace msacmsa = 1800 if statefips== 1 & cntyfips==113
replace msacmsa = 1760 if statefips== 45 & cntyfips==79
replace msacmsa = 1760 if statefips== 45 & cntyfips==63
replace msacmsa = 1740 if statefips== 29 & cntyfips==19
replace msacmsa = 1720 if statefips== 8 & cntyfips==41
replace msacmsa = 1692 if statefips== 39 & cntyfips==93
replace msacmsa = 1692 if statefips== 39 & cntyfips==85
replace msacmsa = 1692 if statefips== 39 & cntyfips==7
replace msacmsa = 1692 if statefips== 39 & cntyfips==55
replace msacmsa = 1692 if statefips== 39 & cntyfips==35
replace msacmsa = 1692 if statefips== 39 & cntyfips==153
replace msacmsa = 1692 if statefips== 39 & cntyfips==133
replace msacmsa = 1692 if statefips== 39 & cntyfips==103
replace msacmsa = 1660 if statefips== 47 & cntyfips==125
replace msacmsa = 1660 if statefips== 21 & cntyfips==47
replace msacmsa = 1642 if statefips== 39 & cntyfips==61
replace msacmsa = 1642 if statefips== 39 & cntyfips==25
replace msacmsa = 1642 if statefips== 39 & cntyfips==17
replace msacmsa = 1642 if statefips== 39 & cntyfips==165
replace msacmsa = 1642 if statefips== 39 & cntyfips==15
replace msacmsa = 1642 if statefips== 21 & cntyfips==81
replace msacmsa = 1642 if statefips== 21 & cntyfips==77
replace msacmsa = 1642 if statefips== 21 & cntyfips==37
replace msacmsa = 1642 if statefips== 21 & cntyfips==191
replace msacmsa = 1642 if statefips== 21 & cntyfips==15
replace msacmsa = 1642 if statefips== 21 & cntyfips==117
replace msacmsa = 1642 if statefips== 18 & cntyfips==29
replace msacmsa = 1642 if statefips== 18 & cntyfips==115
replace msacmsa = 1620 if statefips== 6 & cntyfips==7
replace msacmsa = 1602 if statefips== 55 & cntyfips==59
replace msacmsa = 1602 if statefips== 18 & cntyfips==89
replace msacmsa = 1602 if statefips== 18 & cntyfips==127
replace msacmsa = 1602 if statefips== 17 & cntyfips==97
replace msacmsa = 1602 if statefips== 17 & cntyfips==93
replace msacmsa = 1602 if statefips== 17 & cntyfips==91
replace msacmsa = 1602 if statefips== 17 & cntyfips==89
replace msacmsa = 1602 if statefips== 17 & cntyfips==63
replace msacmsa = 1602 if statefips== 17 & cntyfips==43
replace msacmsa = 1602 if statefips== 17 & cntyfips==37
replace msacmsa = 1602 if statefips== 17 & cntyfips==31
replace msacmsa = 1602 if statefips== 17 & cntyfips==197
replace msacmsa = 1602 if statefips== 17 & cntyfips==111
replace msacmsa = 160 if statefips== 36 & cntyfips==95
replace msacmsa = 160 if statefips== 36 & cntyfips==93
replace msacmsa = 160 if statefips== 36 & cntyfips==91
replace msacmsa = 160 if statefips== 36 & cntyfips==83
replace msacmsa = 160 if statefips== 36 & cntyfips==57
replace msacmsa = 160 if statefips== 36 & cntyfips==1
replace msacmsa = 1580 if statefips== 56 & cntyfips==21
replace msacmsa = 1560 if statefips== 47 & cntyfips==65
replace msacmsa = 1560 if statefips== 47 & cntyfips==115
replace msacmsa = 1560 if statefips== 13 & cntyfips==83
replace msacmsa = 1560 if statefips== 13 & cntyfips==47
replace msacmsa = 1560 if statefips== 13 & cntyfips==295
replace msacmsa = 1540 if statefips== 51 & cntyfips==79
replace msacmsa = 1540 if statefips== 51 & cntyfips==65
replace msacmsa = 1540 if statefips== 51 & cntyfips==540
replace msacmsa = 1540 if statefips== 51 & cntyfips==3
replace msacmsa = 1520 if statefips== 45 & cntyfips==91
replace msacmsa = 1520 if statefips== 37 & cntyfips==71
replace msacmsa = 1520 if statefips== 37 & cntyfips==25
replace msacmsa = 1520 if statefips== 37 & cntyfips==179
replace msacmsa = 1520 if statefips== 37 & cntyfips==159
replace msacmsa = 1520 if statefips== 37 & cntyfips==119
replace msacmsa = 1520 if statefips== 37 & cntyfips==109
replace msacmsa = 1480 if statefips== 54 & cntyfips==79
replace msacmsa = 1480 if statefips== 54 & cntyfips==39
replace msacmsa = 1440 if statefips== 45 & cntyfips==35
replace msacmsa = 1440 if statefips== 45 & cntyfips==19
replace msacmsa = 1440 if statefips== 45 & cntyfips==15
replace msacmsa = 1400 if statefips== 17 & cntyfips==19
replace msacmsa = 1360 if statefips== 19 & cntyfips==113
replace msacmsa = 1350 if statefips== 56 & cntyfips==25
replace msacmsa = 1320 if statefips== 39 & cntyfips==19
replace msacmsa = 1320 if statefips== 39 & cntyfips==151
replace msacmsa = 1280 if statefips== 36 & cntyfips==63
replace msacmsa = 1280 if statefips== 36 & cntyfips==29
replace msacmsa = 1260 if statefips== 48 & cntyfips==41
replace msacmsa = 1240 if statefips== 48 & cntyfips==61
replace msacmsa = 120 if statefips== 13 & cntyfips==95
replace msacmsa = 120 if statefips== 13 & cntyfips==177
replace msacmsa = 1080 if statefips== 16 & cntyfips==27
replace msacmsa = 1080 if statefips== 16 & cntyfips==1
replace msacmsa = 1040 if statefips== 17 & cntyfips==113
replace msacmsa = 1020 if statefips== 18 & cntyfips==105
replace msacmsa = 1010 if statefips== 38 & cntyfips==59
replace msacmsa = 1010 if statefips== 38 & cntyfips==15
replace msacmsa = 1000 if statefips== 1 & cntyfips==9
replace msacmsa = 1000 if statefips== 1 & cntyfips==73
replace msacmsa = 1000 if statefips== 1 & cntyfips==117
replace msacmsa = 1000 if statefips== 1 & cntyfips==115

** New England
replace msacmsa = 3280 if statefips==9 & cntyfips==3
replace msacmsa = 3280 if statefips==9 & cntyfips==7
replace msacmsa = 3280 if statefips==9 & cntyfips==13
replace msacmsa = 5480 if statefips==9 & cntyfips==1
replace msacmsa = 5480 if statefips==9 & cntyfips==9
replace msacmsa = 5520 if statefips==9 & cntyfips==11
replace msacmsa = 4243 if statefips==23 & cntyfips==1
replace msacmsa = 6403 if statefips==23 & cntyfips==5
replace msacmsa = 733 if statefips==23 & cntyfips==19
** Springfield, MA
replace msacmsa = 8000 if statefips==25 & cntyfips==13
replace msacmsa = 8000 if statefips==25 & cntyfips==15
** Barnstable, MA --> Too small to be useful
*replace msacmsa = 743 if statefips==25 & cntyfips==1
** Boston
replace msacmsa = 1120 if statefips==25 & cntyfips==5
replace msacmsa = 1120 if statefips==25 & cntyfips==9
replace msacmsa = 1120 if statefips==25 & cntyfips==17
replace msacmsa = 1120 if statefips==25 & cntyfips==21
replace msacmsa = 1120 if statefips==25 & cntyfips==23
replace msacmsa = 1120 if statefips==25 & cntyfips==25
** Worcester
replace msacmsa = 9240 if statefips==25 & cntyfips==27
** Pittsfield
replace msacmsa = 6323 if statefips==25 & cntyfips==3
**  Manchester, NH 
replace msacmsa = 4760 if statefips==33 & cntyfips==11
replace msacmsa = 4760 if statefips==33 & cntyfips==13
replace msacmsa = 4760 if statefips==33 & cntyfips==15
** Portsmouth, NH
replace msacmsa = 6450 if statefips== 33 & cntyfips==17
replace msacmsa = 6450 if statefips== 23 & cntyfips==31
** Providence, RI
replace msacmsa = 6483 if statefips==44 & cntyfips==1
replace msacmsa = 6483 if statefips==44 & cntyfips==3
replace msacmsa = 6483 if statefips==44 & cntyfips==7
replace msacmsa = 6483 if statefips==44 & cntyfips==9
** Burlington, VT
replace msacmsa = 1305 if statefips==50 & cntyfips==7
replace msacmsa = 1305 if statefips==50 & cntyfips==11
replace msacmsa = 1305 if statefips==50 & cntyfips==13

**** This is the whole USA (by state)
replace msacmsa = 0 if cntyfips==0

*** These are the PMSAs within CMSAs
gen pmsa = -9

** All But New England
replace pmsa = 9270 if statefips== 6 & cntyfips==113
replace pmsa = 9160 if statefips== 24 & cntyfips==15
replace pmsa = 9160 if statefips== 10 & cntyfips==3
replace pmsa = 8840 if statefips== 54 & cntyfips==37
replace pmsa = 8840 if statefips== 54 & cntyfips==3
replace pmsa = 8840 if statefips== 51 & cntyfips==99
replace pmsa = 8840 if statefips== 51 & cntyfips==685
replace pmsa = 8840 if statefips== 51 & cntyfips==683
replace pmsa = 8840 if statefips== 51 & cntyfips==630
replace pmsa = 8840 if statefips== 51 & cntyfips==610
replace pmsa = 8840 if statefips== 51 & cntyfips==61
replace pmsa = 8840 if statefips== 51 & cntyfips==600
replace pmsa = 8840 if statefips== 51 & cntyfips==59
replace pmsa = 8840 if statefips== 51 & cntyfips==510
replace pmsa = 8840 if statefips== 51 & cntyfips==47
replace pmsa = 8840 if statefips== 51 & cntyfips==43
replace pmsa = 8840 if statefips== 51 & cntyfips==187
replace pmsa = 8840 if statefips== 51 & cntyfips==179
replace pmsa = 8840 if statefips== 51 & cntyfips==177
replace pmsa = 8840 if statefips== 51 & cntyfips==153
replace pmsa = 8840 if statefips== 51 & cntyfips==13
replace pmsa = 8840 if statefips== 51 & cntyfips==107
replace pmsa = 8840 if statefips== 24 & cntyfips==9
replace pmsa = 8840 if statefips== 24 & cntyfips==33
replace pmsa = 8840 if statefips== 24 & cntyfips==31
replace pmsa = 8840 if statefips== 24 & cntyfips==21
replace pmsa = 8840 if statefips== 24 & cntyfips==17
replace pmsa = 8840 if statefips== 11 & cntyfips==1
replace pmsa = 8760 if statefips== 34 & cntyfips==11
replace pmsa = 875 if statefips== 34 & cntyfips==31
replace pmsa = 875 if statefips== 34 & cntyfips==3
replace pmsa = 8735 if statefips== 6 & cntyfips==111
replace pmsa = 8720 if statefips== 6 & cntyfips==95
replace pmsa = 8720 if statefips== 6 & cntyfips==55
replace pmsa = 8480 if statefips== 34 & cntyfips==21
replace pmsa = 8200 if statefips== 53 & cntyfips==53
replace pmsa = 80 if statefips== 39 & cntyfips==153
replace pmsa = 80 if statefips== 39 & cntyfips==133
replace pmsa = 7600 if statefips== 53 & cntyfips==61
replace pmsa = 7600 if statefips== 53 & cntyfips==33
replace pmsa = 7600 if statefips== 53 & cntyfips==29
replace pmsa = 7500 if statefips== 6 & cntyfips==97
replace pmsa = 7485 if statefips== 6 & cntyfips==87
replace pmsa = 7400 if statefips== 6 & cntyfips==85
replace pmsa = 7360 if statefips== 6 & cntyfips==81
replace pmsa = 7360 if statefips== 6 & cntyfips==75
replace pmsa = 7360 if statefips== 6 & cntyfips==41
replace pmsa = 720 if statefips== 24 & cntyfips==510
replace pmsa = 720 if statefips== 24 & cntyfips==5
replace pmsa = 720 if statefips== 24 & cntyfips==35
replace pmsa = 720 if statefips== 24 & cntyfips==3
replace pmsa = 720 if statefips== 24 & cntyfips==27
replace pmsa = 720 if statefips== 24 & cntyfips==25
replace pmsa = 720 if statefips== 24 & cntyfips==13
replace pmsa = 7080 if statefips== 41 & cntyfips==53
replace pmsa = 7080 if statefips== 41 & cntyfips==47
replace pmsa = 6920 if statefips== 6 & cntyfips==67
replace pmsa = 6920 if statefips== 6 & cntyfips==61
replace pmsa = 6920 if statefips== 6 & cntyfips==17
replace pmsa = 6780 if statefips== 6 & cntyfips==71
replace pmsa = 6780 if statefips== 6 & cntyfips==65
replace pmsa = 6600 if statefips== 55 & cntyfips==101
replace pmsa = 6440 if statefips== 53 & cntyfips==11
replace pmsa = 6440 if statefips== 41 & cntyfips==9
replace pmsa = 6440 if statefips== 41 & cntyfips==71
replace pmsa = 6440 if statefips== 41 & cntyfips==67
replace pmsa = 6440 if statefips== 41 & cntyfips==51
replace pmsa = 6440 if statefips== 41 & cntyfips==5
replace pmsa = 6160 if statefips== 42 & cntyfips==91
replace pmsa = 6160 if statefips== 42 & cntyfips==45
replace pmsa = 6160 if statefips== 42 & cntyfips==29
replace pmsa = 6160 if statefips== 42 & cntyfips==17
replace pmsa = 6160 if statefips== 42 & cntyfips==101
replace pmsa = 6160 if statefips== 34 & cntyfips==7
replace pmsa = 6160 if statefips== 34 & cntyfips==5
replace pmsa = 6160 if statefips== 34 & cntyfips==33
replace pmsa = 6160 if statefips== 34 & cntyfips==15
replace pmsa = 5945 if statefips== 6 & cntyfips==59
replace pmsa = 5910 if statefips== 53 & cntyfips==67
replace pmsa = 5775 if statefips== 6 & cntyfips==13
replace pmsa = 5775 if statefips== 6 & cntyfips==1
replace pmsa = 5660 if statefips== 42 & cntyfips==103
replace pmsa = 5660 if statefips== 36 & cntyfips==71
replace pmsa = 5640 if statefips== 34 & cntyfips==41
replace pmsa = 5640 if statefips== 34 & cntyfips==39
replace pmsa = 5640 if statefips== 34 & cntyfips==37
replace pmsa = 5640 if statefips== 34 & cntyfips==27
replace pmsa = 5640 if statefips== 34 & cntyfips==13
replace pmsa = 5600 if statefips== 36 & cntyfips==87
replace pmsa = 5600 if statefips== 36 & cntyfips==85
replace pmsa = 5600 if statefips== 36 & cntyfips==81
replace pmsa = 5600 if statefips== 36 & cntyfips==79
replace pmsa = 5600 if statefips== 36 & cntyfips==61
replace pmsa = 5600 if statefips== 36 & cntyfips==5
replace pmsa = 5600 if statefips== 36 & cntyfips==47
replace pmsa = 5600 if statefips== 36 & cntyfips==119
replace pmsa = 560 if statefips== 34 & cntyfips==9
replace pmsa = 560 if statefips== 34 & cntyfips==1
replace pmsa = 5380 if statefips== 36 & cntyfips==59
replace pmsa = 5380 if statefips== 36 & cntyfips==103
replace pmsa = 5190 if statefips== 34 & cntyfips==29
replace pmsa = 5190 if statefips== 34 & cntyfips==25
replace pmsa = 5080 if statefips== 55 & cntyfips==89
replace pmsa = 5080 if statefips== 55 & cntyfips==79
replace pmsa = 5080 if statefips== 55 & cntyfips==133
replace pmsa = 5080 if statefips== 55 & cntyfips==131
replace pmsa = 5015 if statefips== 34 & cntyfips==35
replace pmsa = 5015 if statefips== 34 & cntyfips==23
replace pmsa = 5015 if statefips== 34 & cntyfips==19
replace pmsa = 5000 if statefips== 12 & cntyfips==86
replace pmsa = 4480 if statefips== 6 & cntyfips==37
replace pmsa = 440 if statefips== 26 & cntyfips==93
replace pmsa = 440 if statefips== 26 & cntyfips==91
replace pmsa = 440 if statefips== 26 & cntyfips==161
replace pmsa = 3800 if statefips== 55 & cntyfips==59
replace pmsa = 3740 if statefips== 17 & cntyfips==91
replace pmsa = 3640 if statefips== 34 & cntyfips==17
replace pmsa = 3360 if statefips== 48 & cntyfips==71
replace pmsa = 3360 if statefips== 48 & cntyfips==473
replace pmsa = 3360 if statefips== 48 & cntyfips==339
replace pmsa = 3360 if statefips== 48 & cntyfips==291
replace pmsa = 3360 if statefips== 48 & cntyfips==201
replace pmsa = 3360 if statefips== 48 & cntyfips==157
replace pmsa = 3200 if statefips== 39 & cntyfips==17
replace pmsa = 3180 if statefips== 24 & cntyfips==43
replace pmsa = 3060 if statefips== 8 & cntyfips==123
replace pmsa = 2960 if statefips== 18 & cntyfips==89
replace pmsa = 2960 if statefips== 18 & cntyfips==127
replace pmsa = 2920 if statefips== 48 & cntyfips==167
replace pmsa = 2800 if statefips== 48 & cntyfips==439
replace pmsa = 2800 if statefips== 48 & cntyfips==367
replace pmsa = 2800 if statefips== 48 & cntyfips==251
replace pmsa = 2800 if statefips== 48 & cntyfips==221
replace pmsa = 2680 if statefips== 12 & cntyfips==11
replace pmsa = 2640 if statefips== 26 & cntyfips==49
replace pmsa = 2281 if statefips== 36 & cntyfips==27
replace pmsa = 2160 if statefips== 26 & cntyfips==99
replace pmsa = 2160 if statefips== 26 & cntyfips==87
replace pmsa = 2160 if statefips== 26 & cntyfips==163
replace pmsa = 2160 if statefips== 26 & cntyfips==147
replace pmsa = 2160 if statefips== 26 & cntyfips==125
replace pmsa = 2160 if statefips== 26 & cntyfips==115
replace pmsa = 2080 if statefips== 8 & cntyfips==59
replace pmsa = 2080 if statefips== 8 & cntyfips==5
replace pmsa = 2080 if statefips== 8 & cntyfips==35
replace pmsa = 2080 if statefips== 8 & cntyfips==31
replace pmsa = 2080 if statefips== 8 & cntyfips==1
replace pmsa = 1920 if statefips== 48 & cntyfips==85
replace pmsa = 1920 if statefips== 48 & cntyfips==397
replace pmsa = 1920 if statefips== 48 & cntyfips==257
replace pmsa = 1920 if statefips== 48 & cntyfips==231
replace pmsa = 1920 if statefips== 48 & cntyfips==213
replace pmsa = 1920 if statefips== 48 & cntyfips==139
replace pmsa = 1920 if statefips== 48 & cntyfips==121
replace pmsa = 1920 if statefips== 48 & cntyfips==113
replace pmsa = 1680 if statefips== 39 & cntyfips==93
replace pmsa = 1680 if statefips== 39 & cntyfips==85
replace pmsa = 1680 if statefips== 39 & cntyfips==7
replace pmsa = 1680 if statefips== 39 & cntyfips==55
replace pmsa = 1680 if statefips== 39 & cntyfips==35
replace pmsa = 1680 if statefips== 39 & cntyfips==103
replace pmsa = 1640 if statefips== 39 & cntyfips==61
replace pmsa = 1640 if statefips== 39 & cntyfips==25
replace pmsa = 1640 if statefips== 39 & cntyfips==165
replace pmsa = 1640 if statefips== 39 & cntyfips==15
replace pmsa = 1640 if statefips== 21 & cntyfips==81
replace pmsa = 1640 if statefips== 21 & cntyfips==77
replace pmsa = 1640 if statefips== 21 & cntyfips==37
replace pmsa = 1640 if statefips== 21 & cntyfips==191
replace pmsa = 1640 if statefips== 21 & cntyfips==15
replace pmsa = 1640 if statefips== 21 & cntyfips==117
replace pmsa = 1640 if statefips== 18 & cntyfips==29
replace pmsa = 1640 if statefips== 18 & cntyfips==115
replace pmsa = 1600 if statefips== 17 & cntyfips==97
replace pmsa = 1600 if statefips== 17 & cntyfips==93
replace pmsa = 1600 if statefips== 17 & cntyfips==89
replace pmsa = 1600 if statefips== 17 & cntyfips==63
replace pmsa = 1600 if statefips== 17 & cntyfips==43
replace pmsa = 1600 if statefips== 17 & cntyfips==37
replace pmsa = 1600 if statefips== 17 & cntyfips==31
replace pmsa = 1600 if statefips== 17 & cntyfips==197
replace pmsa = 1600 if statefips== 17 & cntyfips==111
replace pmsa = 1150 if statefips== 53 & cntyfips==35
replace pmsa = 1145 if statefips== 48 & cntyfips==39
replace pmsa = 1125 if statefips== 8 & cntyfips==13

** No New England CMSAs (Boston is broken up above)

******************** Part 3 ***********************

/*cmsa is the variable that assigns msa codes to counties in msas and cmsa codes to counties in cmsas which consists of pmsas*/

gen cmsa = -9 
replace cmsa = msacmsa

/*msa is the variable that assigns msa codes to counties in msas and pmsa codes to counties in pmsas*/
gen msa=msacmsa 
replace msa=pmsa if pmsa~=-9

drop pmsa msacmsa 

