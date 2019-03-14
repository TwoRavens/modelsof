******************************************
*** Attacks Ads - Ken Miller *************
*** 1. 2010 Add Variables ****************
******************************************

clear
set more off
set scheme lean1

* The original 
use "/Volumes/External/Datasets/CMAG/CMAG 2010/wmp-federal-2010-v1.1S12.dta"

* Extracting Sponsor Name out of creative
split creative if sponsor==4

* Result is creative1 with race, creative2 with sponsor, creative3-8 with ad name
encode creative2, generate(adsponsor)
* Many of these will have to be manually inspected to determine true group name and type
* Group total = 135

* Create the general election variable
gen genelect=0
recode genelect 0=1 if state=="IL" & airdate>date("02feb2010", "DMY")
recode genelect 0=1 if state=="TX" & airdate>date("13apr2010", "DMY")
recode genelect 0=1 if state=="IN" & airdate>date("04may2010", "DMY") 
recode genelect 0=1 if state=="OH" & airdate>date("04may2010", "DMY")
recode genelect 0=1 if state=="NC" & airdate>date("22jun2010", "DMY")
recode genelect 0=1 if state=="NE" & airdate>date("11may2010", "DMY")
recode genelect 0=1 if state=="WV" & airdate>date("11may2010", "DMY")
recode genelect 0=1 if state=="KY" & airdate>date("18may2010", "DMY")
recode genelect 0=1 if state=="OR" & airdate>date("18may2010", "DMY")
recode genelect 0=1 if state=="PA" & airdate>date("18may2010", "DMY")
recode genelect 0=1 if state=="AR" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="ID" & airdate>date("25may2010", "DMY")
recode genelect 0=1 if state=="NM" & airdate>date("01jun2010", "DMY")
recode genelect 0=1 if state=="MS" & airdate>date("22jun2010", "DMY")
recode genelect 0=1 if state=="AL" & airdate>date("13jul2010", "DMY")
recode genelect 0=1 if state=="CA" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="IA" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="ME" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="MT" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="NV" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="NJ" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="ND" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="VA" & airdate>date("08jun2010", "DMY")
recode genelect 0=1 if state=="SC" & airdate>date("22jun2010", "DMY")
recode genelect 0=1 if state=="SD" & airdate>date("29jun2010", "DMY")
recode genelect 0=1 if state=="UT" & airdate>date("22jun2010", "DMY")
recode genelect 0=1 if state=="GA" & airdate>date("10aug2010", "DMY")
recode genelect 0=1 if state=="OK" & airdate>date("24aug2010", "DMY")
recode genelect 0=1 if state=="KS" & airdate>date("03aug2010", "DMY")
recode genelect 0=1 if state=="MI" & airdate>date("03aug2010", "DMY")
recode genelect 0=1 if state=="MO" & airdate>date("03aug2010", "DMY")
recode genelect 0=1 if state=="TN" & airdate>date("05aug2010", "DMY")
recode genelect 0=1 if state=="CO" & airdate>date("10aug2010", "DMY")
recode genelect 0=1 if state=="CT" & airdate>date("10aug2010", "DMY")
recode genelect 0=1 if state=="MN" & airdate>date("10aug2010", "DMY")
recode genelect 0=1 if state=="WA" & airdate>date("17aug2010", "DMY")
recode genelect 0=1 if state=="WY" & airdate>date("17aug2010", "DMY")
recode genelect 0=1 if state=="AK" & airdate>date("24aug2010", "DMY")
recode genelect 0=1 if state=="AZ" & airdate>date("24aug2010", "DMY")
recode genelect 0=1 if state=="FL" & airdate>date("24aug2010", "DMY")
recode genelect 0=1 if state=="VT" & airdate>date("24aug2010", "DMY")
*recode genelect 0=1 if state=="LA" & airdate>date("02oct2010", "DMY")
recode genelect 0=1 if state=="DE" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="DC" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="MD" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="MA" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="NH" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="NY" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="RI" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="WI" & airdate>date("14sep2010", "DMY")
recode genelect 0=1 if state=="HI" & airdate>date("14sep2010", "DMY")

* Create negativity ratio
gen negativity=.
recode negativity .=1 if ad_tone==3
recode negativity .=0 if ad_tone==2
recode negativity .=.25 if cnt_prp==1
recode negativity .=.5 if cnt_prp==2
recode negativity .=.75 if cnt_prp==3
recode negativity .=1 if cnt_prp==4

* Create grouptype
gen outsider=adsponsor
recode outsider 3 62 85 96 = 1 ///
                1 4 11 12 14 17 22 23 26 29 46 47 51 52 54 59 67 70 73 78 81 84 ///
                94 97 98 104 105 106 107 108 109 118 127 128 129 135 = 2 ///
                2 5 6 7 9 10 13 15 16 18 19 20 24 25 31 32 33 34 37 38 40 42 43 ///
                45 48 49 50 53 55 56 57 58 60 61 63 64 65 66 68 69 71 72 74 79 ///
                80 82 87 88 89 90 91 92 93 95 99 100 101 102 111 112 113 115 116 ///
                117 119 120 121 122 123 124 125 126 131 133 134 = 3 ///
                8 21 28 30 35 36 39 41 44 76 77 103 114 130 132 = 4 ///
                27 75 83 86 110 = 5

gen grouptype=.
recode grouptype .=1 if sponsor==1
recode grouptype .=2 if sponsor==2 | sponsor==3
recode grouptype .=2 if outsider==1
recode grouptype .=3 if outsider==2
recode grouptype .=4 if outsider==3
recode grouptype .=5 if outsider==4
recode grouptype .=1 if outsider==5

gen noncand=0
recode noncand 0=1 if grouptype==2 
recode noncand 0=1 if grouptype==3
recode noncand 0=1 if grouptype==4
recode noncand 0=1 if grouptype==5
                
 * Create disclosure
gen outdisc=adsponsor
recode outdisc 1 3 6 7 8 9 10 12 13 15 16 18 19 21 23 24 25 27 28 31 33 34 35 37 ///
               39 43 44 50 51 52 56 57 58 60 62 63 64 66 67 68 69 75 76 77 79 80 ///
               81 83 84 85 86 87 88 89 90 91 94 95 96 97 98 101 102 103 104 106 ///
               110 111 112 113 114 116 117 118 119 121 123 124 127 128 129 130 ///
               131 134 135 = 1 ///
               2 4 5 11 14 17 20 22 26 29 30 32 36 38 40 41 42 45 46 47 48 49 53 ///
               54 55 59 61 65 70 71 72 73 74 78 82 92 93 99 100 105 107 108 109 ///
               115 120 122 125 126 132 133 = 2

gen disclosure=.
recode disclosure .=1 if grouptype==1 | grouptype==2
recode disclosure .=1 if outdisc==1
recode disclosure .=2 if outdisc==2


label define grp 1 "1.Candidate" 2 "2.Party" 3 "3.Party-Adjacent" 4 "4.Issue-Based" 5 "5.Single Candidate"
label define disc 1 "1.Tranparent" 2 "2.Opaque"
label values grouptype grp
label values disclosure disc

gen campaign=.
recode campaign .=3 if senate==1 & state=="AK" & party=="Democrat"
recode campaign .=8 if senate==1 & state=="AR" & party=="Democrat"
recode campaign .=6 if senate==1 & state=="AZ" & party=="Democrat"
recode campaign .=10 if senate==1 & state=="CA" & party=="Democrat"
recode campaign .=12 if senate==1 & state=="CO" & party=="Democrat"
recode campaign .=14 if senate==1 & state=="CT" & party=="Democrat"
recode campaign .=16 if senate==1 & state=="DE" & party=="Democrat"
recode campaign .=18 if senate==1 & state=="FL" & party=="Democrat"
recode campaign .=21 if senate==1 & state=="GA" & party=="Democrat"
recode campaign .=23 if senate==1 & state=="HI" & party=="Democrat"
recode campaign .=31 if senate==1 & state=="IA" & party=="Democrat"
recode campaign .=27 if senate==1 & state=="IL" & party=="Democrat"
recode campaign .=29 if senate==1 & state=="IN" & party=="Democrat"
recode campaign .=33 if senate==1 & state=="KS" & party=="Democrat"
recode campaign .=35 if senate==1 & state=="KY" & party=="Democrat"
recode campaign .=37 if senate==1 & state=="LA" & party=="Democrat"
recode campaign .=39 if senate==1 & state=="MD" & party=="Democrat"
recode campaign .=41 if senate==1 & state=="MO" & party=="Democrat"
recode campaign .=51 if senate==1 & state=="NC" & party=="Democrat"
recode campaign .=53 if senate==1 & state=="ND" & party=="Democrat"
recode campaign .=45 if senate==1 & state=="NH" & party=="Democrat"
recode campaign .=43 if senate==1 & state=="NV" & party=="Democrat"
recode campaign .=55 if senate==1 & state=="OH" & party=="Democrat"
recode campaign .=58 if senate==1 & state=="OR" & party=="Democrat"
recode campaign .=60 if senate==1 & state=="PA" & party=="Democrat"
recode campaign .=64 if senate==1 & state=="UT" & party=="Democrat"
recode campaign .=66 if senate==1 & state=="VT" & party=="Democrat"
recode campaign .=68 if senate==1 & state=="WA" & party=="Democrat"
recode campaign .=72 if senate==1 & state=="WI" & party=="Democrat"
recode campaign .=70 if senate==1 & state=="WV" & party=="Democrat"
recode campaign .=4 if senate==1 & state=="AK" & party=="Republican"
recode campaign .=9 if senate==1 & state=="AR" & party=="Republican"
recode campaign .=7 if senate==1 & state=="AZ" & party=="Republican"
recode campaign .=11 if senate==1 & state=="CA" & party=="Republican"
recode campaign .=13 if senate==1 & state=="CO" & party=="Republican"
recode campaign .=15 if senate==1 & state=="CT" & party=="Republican"
recode campaign .=17 if senate==1 & state=="DE" & party=="Republican"
recode campaign .=19 if senate==1 & state=="FL" & party=="Republican"
recode campaign .=22 if senate==1 & state=="GA" & party=="Republican"
recode campaign .=24 if senate==1 & state=="HI" & party=="Republican"
recode campaign .=32 if senate==1 & state=="IA" & party=="Republican"
recode campaign .=26 if senate==1 & state=="ID" & party=="Republican"
recode campaign .=28 if senate==1 & state=="IL" & party=="Republican"
recode campaign .=30 if senate==1 & state=="IN" & party=="Republican"
recode campaign .=34 if senate==1 & state=="KS" & party=="Republican"
recode campaign .=36 if senate==1 & state=="KY" & party=="Republican"
recode campaign .=38 if senate==1 & state=="LA" & party=="Republican"
recode campaign .=40 if senate==1 & state=="MD" & party=="Republican"
recode campaign .=42 if senate==1 & state=="MO" & party=="Republican"
recode campaign .=52 if senate==1 & state=="NC" & party=="Republican"
recode campaign .=54 if senate==1 & state=="ND" & party=="Republican"
recode campaign .=46 if senate==1 & state=="NH" & party=="Republican"
recode campaign .=44 if senate==1 & state=="NV" & party=="Republican"
recode campaign .=56 if senate==1 & state=="OH" & party=="Republican"
recode campaign .=57 if senate==1 & state=="OK" & party=="Republican"
recode campaign .=59 if senate==1 & state=="OR" & party=="Republican"
recode campaign .=61 if senate==1 & state=="PA" & party=="Republican"
recode campaign .=65 if senate==1 & state=="UT" & party=="Republican"
recode campaign .=67 if senate==1 & state=="VT" & party=="Republican"
recode campaign .=69 if senate==1 & state=="WA" & party=="Republican"
recode campaign .=73 if senate==1 & state=="WI" & party=="Republican"
recode campaign .=71 if senate==1 & state=="WV" & party=="Republican"
recode campaign .=5 if senate==1 & state=="AK" & party=="Other"
recode campaign .=20 if senate==1 & state=="FL" & party=="Other"

recode campaign .=1001 if house==1 & state=="AK" & district==1 & party=="Democrat" 
recode campaign .=1002 if house==1 & state=="AK" & district==1 & party=="Republican"
recode campaign .=1003 if house==1 & state=="AL" & district==1 & party=="Democrat" 
recode campaign .=1004 if house==1 & state=="AL" & district==1 & party=="Republican"
recode campaign .=1005 if house==1 & state=="AL" & district==2 & party=="Democrat" 
recode campaign .=1006 if house==1 & state=="AL" & district==2 & party=="Republican"
recode campaign .=1007 if house==1 & state=="AL" & district==3 & party=="Democrat" 
recode campaign .=1008 if house==1 & state=="AL" & district==3 & party=="Republican"
recode campaign .=1009 if house==1 & state=="AL" & district==4 & party=="Democrat" 
recode campaign .=1010 if house==1 & state=="AL" & district==4 & party=="Republican"
recode campaign .=1011 if house==1 & state=="AL" & district==5 & party=="Democrat" 
recode campaign .=1012 if house==1 & state=="AL" & district==5 & party=="Republican"
recode campaign .=1013 if house==1 & state=="AL" & district==6 & party=="Democrat" 
recode campaign .=1014 if house==1 & state=="AL" & district==6 & party=="Republican"
recode campaign .=1015 if house==1 & state=="AL" & district==7 & party=="Democrat" 
recode campaign .=1016 if house==1 & state=="AL" & district==7 & party=="Republican"
recode campaign .=1017 if house==1 & state=="AR" & district==1 & party=="Democrat" 
recode campaign .=1018 if house==1 & state=="AR" & district==1 & party=="Republican"
recode campaign .=1019 if house==1 & state=="AR" & district==2 & party=="Democrat" 
recode campaign .=1020 if house==1 & state=="AR" & district==2 & party=="Republican"
recode campaign .=1021 if house==1 & state=="AR" & district==3 & party=="Democrat" 
recode campaign .=1022 if house==1 & state=="AR" & district==3 & party=="Republican"
recode campaign .=1023 if house==1 & state=="AR" & district==4 & party=="Democrat" 
recode campaign .=1024 if house==1 & state=="AR" & district==4 & party=="Republican"
recode campaign .=1025 if house==1 & state=="AZ" & district==1 & party=="Democrat" 
recode campaign .=1026 if house==1 & state=="AZ" & district==1 & party=="Republican"
recode campaign .=1027 if house==1 & state=="AZ" & district==2 & party=="Democrat" 
recode campaign .=1028 if house==1 & state=="AZ" & district==2 & party=="Republican"
recode campaign .=1029 if house==1 & state=="AZ" & district==3 & party=="Democrat" 
recode campaign .=1030 if house==1 & state=="AZ" & district==3 & party=="Republican"
recode campaign .=1031 if house==1 & state=="AZ" & district==5 & party=="Democrat" 
recode campaign .=1032 if house==1 & state=="AZ" & district==5 & party=="Republican"
recode campaign .=1033 if house==1 & state=="AZ" & district==7 & party=="Democrat" 
recode campaign .=1034 if house==1 & state=="AZ" & district==7 & party=="Republican"
recode campaign .=1035 if house==1 & state=="AZ" & district==8 & party=="Democrat" 
recode campaign .=1036 if house==1 & state=="AZ" & district==8 & party=="Republican"
recode campaign .=1037 if house==1 & state=="CA" & district==3 & party=="Democrat" 
recode campaign .=1038 if house==1 & state=="CA" & district==3 & party=="Republican"
recode campaign .=1039 if house==1 & state=="CA" & district==5 & party=="Democrat" 
recode campaign .=1040 if house==1 & state=="CA" & district==5 & party=="Republican"
recode campaign .=1041 if house==1 & state=="CA" & district==11 & party=="Democrat" 
recode campaign .=1042 if house==1 & state=="CA" & district==11 & party=="Republican"
recode campaign .=1043 if house==1 & state=="CA" & district==17 & party=="Democrat" 
recode campaign .=1044 if house==1 & state=="CA" & district==17 & party=="Republican"
recode campaign .=1045 if house==1 & state=="CA" & district==18 & party=="Democrat" 
recode campaign .=1046 if house==1 & state=="CA" & district==18 & party=="Republican"
recode campaign .=1047 if house==1 & state=="CA" & district==19 & party=="Democrat" 
recode campaign .=1048 if house==1 & state=="CA" & district==19 & party=="Republican"
recode campaign .=1049 if house==1 & state=="CA" & district==20 & party=="Democrat" 
recode campaign .=1050 if house==1 & state=="CA" & district==20 & party=="Republican"
recode campaign .=1051 if house==1 & state=="CA" & district==21 & party=="Democrat" 
recode campaign .=1052 if house==1 & state=="CA" & district==21 & party=="Republican"
recode campaign .=1053 if house==1 & state=="CA" & district==23 & party=="Democrat" 
recode campaign .=1054 if house==1 & state=="CA" & district==23 & party=="Republican"
recode campaign .=1055 if house==1 & state=="CA" & district==42 & party=="Democrat" 
recode campaign .=1056 if house==1 & state=="CA" & district==42 & party=="Republican"
recode campaign .=1057 if house==1 & state=="CA" & district==45 & party=="Democrat" 
recode campaign .=1058 if house==1 & state=="CA" & district==45 & party=="Republican"
recode campaign .=1059 if house==1 & state=="CA" & district==47 & party=="Democrat" 
recode campaign .=1060 if house==1 & state=="CA" & district==47 & party=="Republican"
recode campaign .=1061 if house==1 & state=="CA" & district==51 & party=="Democrat" 
recode campaign .=1062 if house==1 & state=="CA" & district==51 & party=="Republican"
recode campaign .=1063 if house==1 & state=="CO" & district==1 & party=="Democrat" 
recode campaign .=1064 if house==1 & state=="CO" & district==1 & party=="Republican"
recode campaign .=1065 if house==1 & state=="CO" & district==2 & party=="Democrat" 
recode campaign .=1066 if house==1 & state=="CO" & district==2 & party=="Republican"
recode campaign .=1067 if house==1 & state=="CO" & district==3 & party=="Democrat" 
recode campaign .=1068 if house==1 & state=="CO" & district==3 & party=="Republican"
recode campaign .=1069 if house==1 & state=="CO" & district==4 & party=="Democrat" 
recode campaign .=1070 if house==1 & state=="CO" & district==4 & party=="Republican"
recode campaign .=1071 if house==1 & state=="CO" & district==6 & party=="Democrat" 
recode campaign .=1072 if house==1 & state=="CO" & district==6 & party=="Republican"
recode campaign .=1073 if house==1 & state=="CO" & district==7 & party=="Democrat" 
recode campaign .=1074 if house==1 & state=="CO" & district==7 & party=="Republican"
recode campaign .=1075 if house==1 & state=="CT" & district==1 & party=="Democrat" 
recode campaign .=1076 if house==1 & state=="CT" & district==1 & party=="Republican"
recode campaign .=1077 if house==1 & state=="CT" & district==2 & party=="Democrat" 
recode campaign .=1078 if house==1 & state=="CT" & district==2 & party=="Republican"
recode campaign .=1079 if house==1 & state=="CT" & district==3 & party=="Democrat" 
recode campaign .=1080 if house==1 & state=="CT" & district==3 & party=="Republican"
recode campaign .=1081 if house==1 & state=="CT" & district==4 & party=="Democrat" 
recode campaign .=1082 if house==1 & state=="CT" & district==4 & party=="Republican"
recode campaign .=1083 if house==1 & state=="CT" & district==5 & party=="Democrat" 
recode campaign .=1084 if house==1 & state=="CT" & district==5 & party=="Republican"
recode campaign .=1085 if house==1 & state=="DC" & district==1 & party=="Democrat" 
recode campaign .=1086 if house==1 & state=="DC" & district==1 & party=="Republican"
recode campaign .=1087 if house==1 & state=="DE" & district==1 & party=="Democrat" 
recode campaign .=1088 if house==1 & state=="DE" & district==1 & party=="Republican"
recode campaign .=1089 if house==1 & state=="FL" & district==2 & party=="Democrat" 
recode campaign .=1090 if house==1 & state=="FL" & district==2 & party=="Republican"
recode campaign .=1091 if house==1 & state=="FL" & district==7 & party=="Democrat" 
recode campaign .=1092 if house==1 & state=="FL" & district==7 & party=="Republican"
recode campaign .=1093 if house==1 & state=="FL" & district==8 & party=="Democrat" 
recode campaign .=1094 if house==1 & state=="FL" & district==8 & party=="Republican"
recode campaign .=1095 if house==1 & state=="FL" & district==10 & party=="Democrat" 
recode campaign .=1096 if house==1 & state=="FL" & district==10 & party=="Republican"
recode campaign .=1097 if house==1 & state=="FL" & district==12 & party=="Democrat" 
recode campaign .=1098 if house==1 & state=="FL" & district==12 & party=="Republican"
recode campaign .=1099 if house==1 & state=="FL" & district==14 & party=="Democrat" 
recode campaign .=1100 if house==1 & state=="FL" & district==14 & party=="Republican"
recode campaign .=1101 if house==1 & state=="FL" & district==16 & party=="Democrat" 
recode campaign .=1102 if house==1 & state=="FL" & district==16 & party=="Republican"
recode campaign .=1103 if house==1 & state=="FL" & district==17 & party=="Democrat" 
recode campaign .=1104 if house==1 & state=="FL" & district==17 & party=="Republican"
recode campaign .=1105 if house==1 & state=="FL" & district==18 & party=="Democrat" 
recode campaign .=1106 if house==1 & state=="FL" & district==18 & party=="Republican"
recode campaign .=1107 if house==1 & state=="FL" & district==19 & party=="Democrat" 
recode campaign .=1108 if house==1 & state=="FL" & district==19 & party=="Republican"
recode campaign .=1109 if house==1 & state=="FL" & district==22 & party=="Democrat" 
recode campaign .=1110 if house==1 & state=="FL" & district==22 & party=="Republican"
recode campaign .=1111 if house==1 & state=="FL" & district==24 & party=="Democrat" 
recode campaign .=1112 if house==1 & state=="FL" & district==24 & party=="Republican"
recode campaign .=1113 if house==1 & state=="FL" & district==25 & party=="Democrat" 
recode campaign .=1114 if house==1 & state=="FL" & district==25 & party=="Republican"
recode campaign .=1115 if house==1 & state=="GA" & district==2 & party=="Democrat" 
recode campaign .=1116 if house==1 & state=="GA" & district==2 & party=="Republican"
recode campaign .=1117 if house==1 & state=="GA" & district==8 & party=="Democrat" 
recode campaign .=1118 if house==1 & state=="GA" & district==8 & party=="Republican"
recode campaign .=1119 if house==1 & state=="GA" & district==9 & party=="Democrat" 
recode campaign .=1120 if house==1 & state=="GA" & district==9 & party=="Republican"
recode campaign .=1121 if house==1 & state=="GA" & district==10 & party=="Democrat" 
recode campaign .=1122 if house==1 & state=="GA" & district==10 & party=="Republican"
recode campaign .=1123 if house==1 & state=="GA" & district==12 & party=="Democrat" 
recode campaign .=1124 if house==1 & state=="GA" & district==12 & party=="Republican"
recode campaign .=1125 if house==1 & state=="HI" & district==1 & party=="Democrat" 
recode campaign .=1126 if house==1 & state=="HI" & district==1 & party=="Republican"
recode campaign .=1127 if house==1 & state=="HI" & district==2 & party=="Democrat" 
recode campaign .=1128 if house==1 & state=="HI" & district==2 & party=="Republican"
recode campaign .=1129 if house==1 & state=="IA" & district==1 & party=="Democrat" 
recode campaign .=1130 if house==1 & state=="IA" & district==1 & party=="Republican"
recode campaign .=1131 if house==1 & state=="IA" & district==2 & party=="Democrat" 
recode campaign .=1132 if house==1 & state=="IA" & district==2 & party=="Republican"
recode campaign .=1133 if house==1 & state=="IA" & district==3 & party=="Democrat" 
recode campaign .=1134 if house==1 & state=="IA" & district==3 & party=="Republican"
recode campaign .=1135 if house==1 & state=="IA" & district==4 & party=="Democrat" 
recode campaign .=1136 if house==1 & state=="IA" & district==4 & party=="Republican"
recode campaign .=1137 if house==1 & state=="IA" & district==5 & party=="Democrat" 
recode campaign .=1138 if house==1 & state=="IA" & district==5 & party=="Republican"
recode campaign .=1139 if house==1 & state=="ID" & district==1 & party=="Democrat" 
recode campaign .=1140 if house==1 & state=="ID" & district==1 & party=="Republican"
recode campaign .=1141 if house==1 & state=="IL" & district==2 & party=="Democrat" 
recode campaign .=1142 if house==1 & state=="IL" & district==2 & party=="Republican"
recode campaign .=1143 if house==1 & state=="IL" & district==7 & party=="Democrat" 
recode campaign .=1144 if house==1 & state=="IL" & district==7 & party=="Republican"
recode campaign .=1145 if house==1 & state=="IL" & district==8 & party=="Democrat" 
recode campaign .=1146 if house==1 & state=="IL" & district==8 & party=="Republican"
recode campaign .=1147 if house==1 & state=="IL" & district==9 & party=="Democrat" 
recode campaign .=1148 if house==1 & state=="IL" & district==9 & party=="Republican"
recode campaign .=1149 if house==1 & state=="IL" & district==10 & party=="Democrat" 
recode campaign .=1150 if house==1 & state=="IL" & district==10 & party=="Republican"
recode campaign .=1151 if house==1 & state=="IL" & district==11 & party=="Democrat" 
recode campaign .=1152 if house==1 & state=="IL" & district==11 & party=="Republican"
recode campaign .=1153 if house==1 & state=="IL" & district==14 & party=="Democrat" 
recode campaign .=1154 if house==1 & state=="IL" & district==14 & party=="Republican"
recode campaign .=1155 if house==1 & state=="IL" & district==15 & party=="Democrat" 
recode campaign .=1156 if house==1 & state=="IL" & district==15 & party=="Republican"
recode campaign .=1157 if house==1 & state=="IL" & district==17 & party=="Democrat" 
recode campaign .=1158 if house==1 & state=="IL" & district==17 & party=="Republican"
recode campaign .=1159 if house==1 & state=="IN" & district==2 & party=="Democrat" 
recode campaign .=1160 if house==1 & state=="IN" & district==2 & party=="Republican"
recode campaign .=1161 if house==1 & state=="IN" & district==3 & party=="Democrat" 
recode campaign .=1162 if house==1 & state=="IN" & district==3 & party=="Republican"
recode campaign .=1163 if house==1 & state=="IN" & district==4 & party=="Democrat" 
recode campaign .=1164 if house==1 & state=="IN" & district==4 & party=="Republican"
recode campaign .=1165 if house==1 & state=="IN" & district==5 & party=="Democrat" 
recode campaign .=1166 if house==1 & state=="IN" & district==5 & party=="Republican"
recode campaign .=1167 if house==1 & state=="IN" & district==6 & party=="Democrat" 
recode campaign .=1168 if house==1 & state=="IN" & district==6 & party=="Republican"
recode campaign .=1169 if house==1 & state=="IN" & district==7 & party=="Democrat" 
recode campaign .=1170 if house==1 & state=="IN" & district==7 & party=="Republican"
recode campaign .=1171 if house==1 & state=="IN" & district==8 & party=="Democrat" 
recode campaign .=1172 if house==1 & state=="IN" & district==8 & party=="Republican"
recode campaign .=1173 if house==1 & state=="IN" & district==9 & party=="Democrat" 
recode campaign .=1174 if house==1 & state=="IN" & district==9 & party=="Republican"
recode campaign .=1175 if house==1 & state=="KS" & district==1 & party=="Democrat" 
recode campaign .=1176 if house==1 & state=="KS" & district==1 & party=="Republican"
recode campaign .=1177 if house==1 & state=="KS" & district==2 & party=="Democrat" 
recode campaign .=1178 if house==1 & state=="KS" & district==2 & party=="Republican"
recode campaign .=1179 if house==1 & state=="KS" & district==3 & party=="Democrat" 
recode campaign .=1180 if house==1 & state=="KS" & district==3 & party=="Republican"
recode campaign .=1181 if house==1 & state=="KS" & district==4 & party=="Democrat" 
recode campaign .=1182 if house==1 & state=="KS" & district==4 & party=="Republican"
recode campaign .=1183 if house==1 & state=="KY" & district==2 & party=="Democrat" 
recode campaign .=1184 if house==1 & state=="KY" & district==2 & party=="Republican"
recode campaign .=1185 if house==1 & state=="KY" & district==3 & party=="Democrat" 
recode campaign .=1186 if house==1 & state=="KY" & district==3 & party=="Republican"
recode campaign .=1187 if house==1 & state=="KY" & district==6 & party=="Democrat" 
recode campaign .=1188 if house==1 & state=="KY" & district==6 & party=="Republican"
recode campaign .=1189 if house==1 & state=="LA" & district==1 & party=="Democrat" 
recode campaign .=1190 if house==1 & state=="LA" & district==1 & party=="Republican"
recode campaign .=1191 if house==1 & state=="LA" & district==2 & party=="Democrat" 
recode campaign .=1192 if house==1 & state=="LA" & district==2 & party=="Republican"
recode campaign .=1193 if house==1 & state=="LA" & district==3 & party=="Democrat" 
recode campaign .=1194 if house==1 & state=="LA" & district==3 & party=="Republican"
recode campaign .=1195 if house==1 & state=="LA" & district==4 & party=="Democrat" 
recode campaign .=1196 if house==1 & state=="LA" & district==4 & party=="Republican"
recode campaign .=1197 if house==1 & state=="MA" & district==1 & party=="Democrat" 
recode campaign .=1198 if house==1 & state=="MA" & district==1 & party=="Republican"
recode campaign .=1199 if house==1 & state=="MA" & district==2 & party=="Democrat" 
recode campaign .=1200 if house==1 & state=="MA" & district==2 & party=="Republican"
recode campaign .=1201 if house==1 & state=="MA" & district==3 & party=="Democrat" 
recode campaign .=1202 if house==1 & state=="MA" & district==3 & party=="Republican"
recode campaign .=1203 if house==1 & state=="MA" & district==4 & party=="Democrat" 
recode campaign .=1204 if house==1 & state=="MA" & district==4 & party=="Republican"
recode campaign .=1205 if house==1 & state=="MA" & district==5 & party=="Democrat" 
recode campaign .=1206 if house==1 & state=="MA" & district==5 & party=="Republican"
recode campaign .=1207 if house==1 & state=="MA" & district==6 & party=="Democrat" 
recode campaign .=1208 if house==1 & state=="MA" & district==6 & party=="Republican"
recode campaign .=1209 if house==1 & state=="MA" & district==9 & party=="Democrat" 
recode campaign .=1210 if house==1 & state=="MA" & district==9 & party=="Republican"
recode campaign .=1211 if house==1 & state=="MA" & district==10 & party=="Democrat" 
recode campaign .=1212 if house==1 & state=="MA" & district==10 & party=="Republican"
recode campaign .=1213 if house==1 & state=="MD" & district==1 & party=="Democrat" 
recode campaign .=1214 if house==1 & state=="MD" & district==1 & party=="Republican"
recode campaign .=1215 if house==1 & state=="MD" & district==2 & party=="Democrat" 
recode campaign .=1216 if house==1 & state=="MD" & district==2 & party=="Republican"
recode campaign .=1217 if house==1 & state=="MD" & district==5 & party=="Democrat" 
recode campaign .=1218 if house==1 & state=="MD" & district==5 & party=="Republican"
recode campaign .=1219 if house==1 & state=="ME" & district==1 & party=="Democrat" 
recode campaign .=1220 if house==1 & state=="ME" & district==1 & party=="Republican"
recode campaign .=1221 if house==1 & state=="ME" & district==2 & party=="Democrat" 
recode campaign .=1222 if house==1 & state=="ME" & district==2 & party=="Republican"
recode campaign .=1223 if house==1 & state=="MI" & district==1 & party=="Democrat" 
recode campaign .=1224 if house==1 & state=="MI" & district==1 & party=="Republican"
recode campaign .=1225 if house==1 & state=="MI" & district==2 & party=="Democrat" 
recode campaign .=1226 if house==1 & state=="MI" & district==2 & party=="Republican"
recode campaign .=1227 if house==1 & state=="MI" & district==3 & party=="Democrat" 
recode campaign .=1228 if house==1 & state=="MI" & district==3 & party=="Republican"
recode campaign .=1229 if house==1 & state=="MI" & district==4 & party=="Democrat" 
recode campaign .=1230 if house==1 & state=="MI" & district==4 & party=="Republican"
recode campaign .=1231 if house==1 & state=="MI" & district==5 & party=="Democrat" 
recode campaign .=1232 if house==1 & state=="MI" & district==5 & party=="Republican"
recode campaign .=1233 if house==1 & state=="MI" & district==6 & party=="Democrat" 
recode campaign .=1234 if house==1 & state=="MI" & district==6 & party=="Republican"
recode campaign .=1235 if house==1 & state=="MI" & district==7 & party=="Democrat" 
recode campaign .=1236 if house==1 & state=="MI" & district==7 & party=="Republican"
recode campaign .=1237 if house==1 & state=="MI" & district==9 & party=="Democrat" 
recode campaign .=1238 if house==1 & state=="MI" & district==9 & party=="Republican"
recode campaign .=1239 if house==1 & state=="MI" & district==13 & party=="Democrat" 
recode campaign .=1240 if house==1 & state=="MI" & district==13 & party=="Republican"
recode campaign .=1241 if house==1 & state=="MI" & district==15 & party=="Democrat" 
recode campaign .=1242 if house==1 & state=="MI" & district==15 & party=="Republican"
recode campaign .=1243 if house==1 & state=="MN" & district==1 & party=="Democrat" 
recode campaign .=1244 if house==1 & state=="MN" & district==1 & party=="Republican"
recode campaign .=1245 if house==1 & state=="MN" & district==3 & party=="Democrat" 
recode campaign .=1246 if house==1 & state=="MN" & district==3 & party=="Republican"
recode campaign .=1247 if house==1 & state=="MN" & district==6 & party=="Democrat" 
recode campaign .=1248 if house==1 & state=="MN" & district==6 & party=="Republican"
recode campaign .=1249 if house==1 & state=="MN" & district==7 & party=="Democrat" 
recode campaign .=1250 if house==1 & state=="MN" & district==7 & party=="Republican"
recode campaign .=1251 if house==1 & state=="MN" & district==8 & party=="Democrat" 
recode campaign .=1252 if house==1 & state=="MN" & district==8 & party=="Republican"
recode campaign .=1253 if house==1 & state=="MO" & district==1 & party=="Democrat" 
recode campaign .=1254 if house==1 & state=="MO" & district==1 & party=="Republican"
recode campaign .=1255 if house==1 & state=="MO" & district==3 & party=="Democrat" 
recode campaign .=1256 if house==1 & state=="MO" & district==3 & party=="Republican"
recode campaign .=1257 if house==1 & state=="MO" & district==4 & party=="Democrat" 
recode campaign .=1258 if house==1 & state=="MO" & district==4 & party=="Republican"
recode campaign .=1259 if house==1 & state=="MO" & district==6 & party=="Democrat" 
recode campaign .=1260 if house==1 & state=="MO" & district==6 & party=="Republican"
recode campaign .=1261 if house==1 & state=="MO" & district==7 & party=="Democrat" 
recode campaign .=1262 if house==1 & state=="MO" & district==7 & party=="Republican"
recode campaign .=1263 if house==1 & state=="MO" & district==8 & party=="Democrat" 
recode campaign .=1264 if house==1 & state=="MO" & district==8 & party=="Republican"
recode campaign .=1265 if house==1 & state=="MS" & district==1 & party=="Democrat" 
recode campaign .=1266 if house==1 & state=="MS" & district==1 & party=="Republican"
recode campaign .=1267 if house==1 & state=="MS" & district==2 & party=="Democrat" 
recode campaign .=1268 if house==1 & state=="MS" & district==2 & party=="Republican"
recode campaign .=1269 if house==1 & state=="MS" & district==3 & party=="Democrat" 
recode campaign .=1270 if house==1 & state=="MS" & district==3 & party=="Republican"
recode campaign .=1271 if house==1 & state=="MT" & district==1 & party=="Democrat" 
recode campaign .=1272 if house==1 & state=="MT" & district==1 & party=="Republican"
recode campaign .=1273 if house==1 & state=="NC" & district==2 & party=="Democrat" 
recode campaign .=1274 if house==1 & state=="NC" & district==2 & party=="Republican"
recode campaign .=1275 if house==1 & state=="NC" & district==3 & party=="Democrat" 
recode campaign .=1276 if house==1 & state=="NC" & district==3 & party=="Republican"
recode campaign .=1277 if house==1 & state=="NC" & district==4 & party=="Democrat" 
recode campaign .=1278 if house==1 & state=="NC" & district==4 & party=="Republican"
recode campaign .=1279 if house==1 & state=="NC" & district==5 & party=="Democrat" 
recode campaign .=1280 if house==1 & state=="NC" & district==5 & party=="Republican"
recode campaign .=1281 if house==1 & state=="NC" & district==6 & party=="Democrat" 
recode campaign .=1282 if house==1 & state=="NC" & district==6 & party=="Republican"
recode campaign .=1283 if house==1 & state=="NC" & district==7 & party=="Democrat" 
recode campaign .=1284 if house==1 & state=="NC" & district==7 & party=="Republican"
recode campaign .=1285 if house==1 & state=="NC" & district==8 & party=="Democrat" 
recode campaign .=1286 if house==1 & state=="NC" & district==8 & party=="Republican"
recode campaign .=1287 if house==1 & state=="NC" & district==9 & party=="Democrat" 
recode campaign .=1288 if house==1 & state=="NC" & district==9 & party=="Republican"
recode campaign .=1289 if house==1 & state=="NC" & district==10 & party=="Democrat" 
recode campaign .=1290 if house==1 & state=="NC" & district==10 & party=="Republican"
recode campaign .=1291 if house==1 & state=="NC" & district==11 & party=="Democrat" 
recode campaign .=1292 if house==1 & state=="NC" & district==11 & party=="Republican"
recode campaign .=1293 if house==1 & state=="NC" & district==13 & party=="Democrat" 
recode campaign .=1294 if house==1 & state=="NC" & district==13 & party=="Republican"
recode campaign .=1295 if house==1 & state=="ND" & district==1 & party=="Democrat" 
recode campaign .=1296 if house==1 & state=="ND" & district==1 & party=="Republican"
recode campaign .=1297 if house==1 & state=="NE" & district==2 & party=="Democrat" 
recode campaign .=1298 if house==1 & state=="NE" & district==2 & party=="Republican"
recode campaign .=1299 if house==1 & state=="NH" & district==1 & party=="Democrat" 
recode campaign .=1300 if house==1 & state=="NH" & district==1 & party=="Republican"
recode campaign .=1301 if house==1 & state=="NH" & district==2 & party=="Democrat" 
recode campaign .=1302 if house==1 & state=="NH" & district==2 & party=="Republican"
recode campaign .=1303 if house==1 & state=="NJ" & district==2 & party=="Democrat" 
recode campaign .=1304 if house==1 & state=="NJ" & district==2 & party=="Republican"
recode campaign .=1305 if house==1 & state=="NJ" & district==3 & party=="Democrat" 
recode campaign .=1306 if house==1 & state=="NJ" & district==3 & party=="Republican"
recode campaign .=1307 if house==1 & state=="NM" & district==1 & party=="Democrat" 
recode campaign .=1308 if house==1 & state=="NM" & district==1 & party=="Republican"
recode campaign .=1309 if house==1 & state=="NM" & district==2 & party=="Democrat" 
recode campaign .=1310 if house==1 & state=="NM" & district==2 & party=="Republican"
recode campaign .=1311 if house==1 & state=="NM" & district==3 & party=="Democrat" 
recode campaign .=1312 if house==1 & state=="NM" & district==3 & party=="Republican"
recode campaign .=1313 if house==1 & state=="NV" & district==3 & party=="Democrat" 
recode campaign .=1314 if house==1 & state=="NV" & district==3 & party=="Republican"
recode campaign .=1315 if house==1 & state=="NY" & district==1 & party=="Democrat" 
recode campaign .=1316 if house==1 & state=="NY" & district==1 & party=="Republican"
recode campaign .=1317 if house==1 & state=="NY" & district==13 & party=="Democrat" 
recode campaign .=1318 if house==1 & state=="NY" & district==13 & party=="Republican"
recode campaign .=1319 if house==1 & state=="NY" & district==14 & party=="Democrat" 
recode campaign .=1320 if house==1 & state=="NY" & district==14 & party=="Republican"
recode campaign .=1321 if house==1 & state=="NY" & district==19 & party=="Democrat" 
recode campaign .=1322 if house==1 & state=="NY" & district==19 & party=="Republican"
recode campaign .=1323 if house==1 & state=="NY" & district==20 & party=="Democrat" 
recode campaign .=1324 if house==1 & state=="NY" & district==20 & party=="Republican"
recode campaign .=1325 if house==1 & state=="NY" & district==21 & party=="Democrat" 
recode campaign .=1326 if house==1 & state=="NY" & district==21 & party=="Republican"
recode campaign .=1327 if house==1 & state=="NY" & district==23 & party=="Democrat" 
recode campaign .=1328 if house==1 & state=="NY" & district==23 & party=="Republican"
recode campaign .=1329 if house==1 & state=="NY" & district==24 & party=="Democrat"
recode campaign .=1330 if house==1 & state=="NY" & district==24 & party=="Republican"
recode campaign .=1331 if house==1 & state=="NY" & district==25 & party=="Democrat"
recode campaign .=1332 if house==1 & state=="NY" & district==25 & party=="Republican"
recode campaign .=1333 if house==1 & state=="NY" & district==27 & party=="Democrat" 
recode campaign .=1334 if house==1 & state=="NY" & district==27 & party=="Republican"
recode campaign .=1335 if house==1 & state=="NY" & district==29 & party=="Democrat" 
recode campaign .=1336 if house==1 & state=="NY" & district==29 & party=="Republican"
recode campaign .=1337 if house==1 & state=="OH" & district==1 & party=="Democrat" 
recode campaign .=1338 if house==1 & state=="OH" & district==1 & party=="Republican"
recode campaign .=1339 if house==1 & state=="OH" & district==2 & party=="Democrat" 
recode campaign .=1340 if house==1 & state=="OH" & district==2 & party=="Republican"
recode campaign .=1341 if house==1 & state=="OH" & district==6 & party=="Democrat" 
recode campaign .=1342 if house==1 & state=="OH" & district==6 & party=="Republican"
recode campaign .=1343 if house==1 & state=="OH" & district==7 & party=="Democrat" 
recode campaign .=1344 if house==1 & state=="OH" & district==7 & party=="Republican"
recode campaign .=1345 if house==1 & state=="OH" & district==8 & party=="Democrat" 
recode campaign .=1346 if house==1 & state=="OH" & district==8 & party=="Republican"
recode campaign .=1347 if house==1 & state=="OH" & district==9 & party=="Democrat" 
recode campaign .=1348 if house==1 & state=="OH" & district==9 & party=="Republican"
recode campaign .=1349 if house==1 & state=="OH" & district==10 & party=="Democrat" 
recode campaign .=1350 if house==1 & state=="OH" & district==10 & party=="Republican"
recode campaign .=1351 if house==1 & state=="OH" & district==12 & party=="Democrat" 
recode campaign .=1352 if house==1 & state=="OH" & district==12 & party=="Republican"
recode campaign .=1353 if house==1 & state=="OH" & district==13 & party=="Democrat" 
recode campaign .=1354 if house==1 & state=="OH" & district==13 & party=="Republican"
recode campaign .=1355 if house==1 & state=="OH" & district==15 & party=="Democrat" 
recode campaign .=1356 if house==1 & state=="OH" & district==15 & party=="Republican"
recode campaign .=1357 if house==1 & state=="OH" & district==16 & party=="Democrat" 
recode campaign .=1358 if house==1 & state=="OH" & district==16 & party=="Republican"
recode campaign .=1359 if house==1 & state=="OH" & district==18 & party=="Democrat" 
recode campaign .=1360 if house==1 & state=="OH" & district==18 & party=="Republican"
recode campaign .=1361 if house==1 & state=="OK" & district==1 & party=="Democrat" 
recode campaign .=1362 if house==1 & state=="OK" & district==1 & party=="Republican"
recode campaign .=1363 if house==1 & state=="OK" & district==2 & party=="Democrat" 
recode campaign .=1364 if house==1 & state=="OK" & district==2 & party=="Republican"
recode campaign .=1365 if house==1 & state=="OK" & district==5 & party=="Democrat" 
recode campaign .=1366 if house==1 & state=="OK" & district==5 & party=="Republican"
recode campaign .=1367 if house==1 & state=="OR" & district==1 & party=="Democrat" 
recode campaign .=1368 if house==1 & state=="OR" & district==1 & party=="Republican"
recode campaign .=1369 if house==1 & state=="OR" & district==2 & party=="Democrat" 
recode campaign .=1370 if house==1 & state=="OR" & district==2 & party=="Republican"
recode campaign .=1371 if house==1 & state=="OR" & district==3 & party=="Democrat" 
recode campaign .=1372 if house==1 & state=="OR" & district==3 & party=="Republican"
recode campaign .=1373 if house==1 & state=="OR" & district==5 & party=="Democrat" 
recode campaign .=1374 if house==1 & state=="OR" & district==5 & party=="Republican"
recode campaign .=1375 if house==1 & state=="PA" & district==3 & party=="Democrat" 
recode campaign .=1376 if house==1 & state=="PA" & district==3 & party=="Republican"
recode campaign .=1377 if house==1 & state=="PA" & district==4 & party=="Democrat" 
recode campaign .=1378 if house==1 & state=="PA" & district==4 & party=="Republican"
recode campaign .=1379 if house==1 & state=="PA" & district==6 & party=="Democrat" 
recode campaign .=1380 if house==1 & state=="PA" & district==6 & party=="Republican"
recode campaign .=1381 if house==1 & state=="PA" & district==7 & party=="Democrat" 
recode campaign .=1382 if house==1 & state=="PA" & district==7 & party=="Republican"
recode campaign .=1383 if house==1 & state=="PA" & district==8 & party=="Democrat" 
recode campaign .=1384 if house==1 & state=="PA" & district==8 & party=="Republican"
recode campaign .=1385 if house==1 & state=="PA" & district==9 & party=="Democrat" 
recode campaign .=1386 if house==1 & state=="PA" & district==9 & party=="Republican"
recode campaign .=1387 if house==1 & state=="PA" & district==10 & party=="Democrat" 
recode campaign .=1388 if house==1 & state=="PA" & district==10 & party=="Republican"
recode campaign .=1389 if house==1 & state=="PA" & district==11 & party=="Democrat" 
recode campaign .=1390 if house==1 & state=="PA" & district==11 & party=="Republican"
recode campaign .=1391 if house==1 & state=="PA" & district==12 & party=="Democrat" 
recode campaign .=1392 if house==1 & state=="PA" & district==12 & party=="Republican"
recode campaign .=1393 if house==1 & state=="PA" & district==13 & party=="Democrat" 
recode campaign .=1394 if house==1 & state=="PA" & district==13 & party=="Republican"
recode campaign .=1395 if house==1 & state=="PA" & district==15 & party=="Democrat" 
recode campaign .=1396 if house==1 & state=="PA" & district==15 & party=="Republican"
recode campaign .=1397 if house==1 & state=="PA" & district==16 & party=="Democrat" 
recode campaign .=1398 if house==1 & state=="PA" & district==16 & party=="Republican"
recode campaign .=1399 if house==1 & state=="PA" & district==17 & party=="Democrat" 
recode campaign .=1400 if house==1 & state=="PA" & district==17 & party=="Republican"
recode campaign .=1401 if house==1 & state=="PA" & district==18 & party=="Democrat" 
recode campaign .=1402 if house==1 & state=="PA" & district==18 & party=="Republican"
recode campaign .=1403 if house==1 & state=="RI" & district==1 & party=="Democrat" 
recode campaign .=1404 if house==1 & state=="RI" & district==1 & party=="Republican"
recode campaign .=1405 if house==1 & state=="SC" & district==1 & party=="Democrat" 
recode campaign .=1406 if house==1 & state=="SC" & district==1 & party=="Republican"
recode campaign .=1407 if house==1 & state=="SC" & district==2 & party=="Democrat" 
recode campaign .=1408 if house==1 & state=="SC" & district==2 & party=="Republican"
recode campaign .=1409 if house==1 & state=="SC" & district==3 & party=="Democrat" 
recode campaign .=1410 if house==1 & state=="SC" & district==3 & party=="Republican"
recode campaign .=1411 if house==1 & state=="SC" & district==4 & party=="Democrat" 
recode campaign .=1412 if house==1 & state=="SC" & district==4 & party=="Republican"
recode campaign .=1413 if house==1 & state=="SC" & district==5 & party=="Democrat" 
recode campaign .=1414 if house==1 & state=="SC" & district==5 & party=="Republican"
recode campaign .=1415 if house==1 & state=="SC" & district==6 & party=="Democrat" 
recode campaign .=1416 if house==1 & state=="SC" & district==6 & party=="Republican"
recode campaign .=1417 if house==1 & state=="SD" & district==1 & party=="Democrat" 
recode campaign .=1418 if house==1 & state=="SD" & district==1 & party=="Republican"
recode campaign .=1419 if house==1 & state=="TN" & district==2 & party=="Democrat" 
recode campaign .=1420 if house==1 & state=="TN" & district==2 & party=="Republican"
recode campaign .=1421 if house==1 & state=="TN" & district==3 & party=="Democrat" 
recode campaign .=1422 if house==1 & state=="TN" & district==3 & party=="Republican"
recode campaign .=1423 if house==1 & state=="TN" & district==4 & party=="Democrat" 
recode campaign .=1424 if house==1 & state=="TN" & district==4 & party=="Republican"
recode campaign .=1425 if house==1 & state=="TN" & district==5 & party=="Democrat" 
recode campaign .=1426 if house==1 & state=="TN" & district==5 & party=="Republican"
recode campaign .=1427 if house==1 & state=="TN" & district==6 & party=="Democrat" 
recode campaign .=1428 if house==1 & state=="TN" & district==6 & party=="Republican"
recode campaign .=1429 if house==1 & state=="TN" & district==8 & party=="Democrat" 
recode campaign .=1430 if house==1 & state=="TN" & district==8 & party=="Republican"
recode campaign .=1431 if house==1 & state=="TN" & district==9 & party=="Democrat" 
recode campaign .=1432 if house==1 & state=="TN" & district==9 & party=="Republican"
recode campaign .=1433 if house==1 & state=="TX" & district==4 & party=="Democrat" 
recode campaign .=1434 if house==1 & state=="TX" & district==4 & party=="Republican"
recode campaign .=1435 if house==1 & state=="TX" & district==15 & party=="Democrat" 
recode campaign .=1436 if house==1 & state=="TX" & district==15 & party=="Republican"
recode campaign .=1437 if house==1 & state=="TX" & district==16 & party=="Democrat" 
recode campaign .=1438 if house==1 & state=="TX" & district==16 & party=="Republican"
recode campaign .=1439 if house==1 & state=="TX" & district==17 & party=="Democrat" 
recode campaign .=1440 if house==1 & state=="TX" & district==17 & party=="Republican"
recode campaign .=1441 if house==1 & state=="TX" & district==18 & party=="Democrat" 
recode campaign .=1442 if house==1 & state=="TX" & district==18 & party=="Republican"
recode campaign .=1443 if house==1 & state=="TX" & district==20 & party=="Democrat" 
recode campaign .=1444 if house==1 & state=="TX" & district==20 & party=="Republican"
recode campaign .=1445 if house==1 & state=="TX" & district==23 & party=="Democrat" 
recode campaign .=1446 if house==1 & state=="TX" & district==23 & party=="Republican"
recode campaign .=1447 if house==1 & state=="TX" & district==25 & party=="Democrat" 
recode campaign .=1448 if house==1 & state=="TX" & district==25 & party=="Republican"
recode campaign .=1449 if house==1 & state=="TX" & district==26 & party=="Democrat" 
recode campaign .=1450 if house==1 & state=="TX" & district==26 & party=="Republican"
recode campaign .=1451 if house==1 & state=="TX" & district==27 & party=="Democrat" 
recode campaign .=1452 if house==1 & state=="TX" & district==27 & party=="Republican"
recode campaign .=1453 if house==1 & state=="TX" & district==28 & party=="Democrat" 
recode campaign .=1454 if house==1 & state=="TX" & district==28 & party=="Republican"
recode campaign .=1455 if house==1 & state=="TX" & district==30 & party=="Democrat" 
recode campaign .=1456 if house==1 & state=="TX" & district==30 & party=="Republican"
recode campaign .=1457 if house==1 & state=="UT" & district==2 & party=="Democrat" 
recode campaign .=1458 if house==1 & state=="UT" & district==2 & party=="Republican"
recode campaign .=1459 if house==1 & state=="VA" & district==2 & party=="Democrat" 
recode campaign .=1460 if house==1 & state=="VA" & district==2 & party=="Republican"
recode campaign .=1461 if house==1 & state=="VA" & district==5 & party=="Democrat" 
recode campaign .=1462 if house==1 & state=="VA" & district==5 & party=="Republican"
recode campaign .=1463 if house==1 & state=="VA" & district==7 & party=="Democrat" 
recode campaign .=1464 if house==1 & state=="VA" & district==7 & party=="Republican"
recode campaign .=1465 if house==1 & state=="VA" & district==9 & party=="Democrat" 
recode campaign .=1466 if house==1 & state=="VA" & district==9 & party=="Republican"
recode campaign .=1467 if house==1 & state=="VA" & district==11 & party=="Democrat" 
recode campaign .=1468 if house==1 & state=="VA" & district==11 & party=="Republican"
recode campaign .=1469 if house==1 & state=="WA" & district==2 & party=="Democrat" 
recode campaign .=1470 if house==1 & state=="WA" & district==2 & party=="Republican"
recode campaign .=1471 if house==1 & state=="WA" & district==3 & party=="Democrat" 
recode campaign .=1472 if house==1 & state=="WA" & district==3 & party=="Republican"
recode campaign .=1473 if house==1 & state=="WA" & district==5 & party=="Democrat" 
recode campaign .=1474 if house==1 & state=="WA" & district==5 & party=="Republican"
recode campaign .=1475 if house==1 & state=="WA" & district==8 & party=="Democrat" 
recode campaign .=1476 if house==1 & state=="WA" & district==8 & party=="Republican"
recode campaign .=1477 if house==1 & state=="WA" & district==9 & party=="Democrat" 
recode campaign .=1478 if house==1 & state=="WA" & district==9 & party=="Republican"
recode campaign .=1479 if house==1 & state=="WI" & district==2 & party=="Democrat" 
recode campaign .=1480 if house==1 & state=="WI" & district==2 & party=="Republican"
recode campaign .=1481 if house==1 & state=="WI" & district==3 & party=="Democrat" 
recode campaign .=1482 if house==1 & state=="WI" & district==3 & party=="Republican"
recode campaign .=1483 if house==1 & state=="WI" & district==4 & party=="Democrat" 
recode campaign .=1484 if house==1 & state=="WI" & district==4 & party=="Republican"
recode campaign .=1485 if house==1 & state=="WI" & district==7 & party=="Democrat" 
recode campaign .=1486 if house==1 & state=="WI" & district==7 & party=="Republican"
recode campaign .=1487 if house==1 & state=="WI" & district==8 & party=="Democrat" 
recode campaign .=1488 if house==1 & state=="WI" & district==8 & party=="Republican"
recode campaign .=1489 if house==1 & state=="WV" & district==3 & party=="Democrat" 
recode campaign .=1490 if house==1 & state=="WV" & district==3 & party=="Republican"

* Drop national ads
drop if market=="NATIONAL CABLE"drop if market=="NATIONAL NETWORK"

* Market Size
* Note, Manchester, NH is not a recognized separate DMA for Nielson, so combined w/ Boston
gen households=.
recode households .=156.91 if market=="ALBANY, GA"recode households .=557.86 if market=="ALBANY, NY"recode households .=703.72 if market=="ALBUQUERQUE"recode households .=90.64 if market=="ALEXANDRIA"recode households .=17.04 if market=="ALPENA"recode households .=154.82 if market=="ANCHORAGE"recode households .=2407.08 if market=="ATLANTA"recode households .=257.03 if market=="AUGUSTA"recode households .=707.43 if market=="AUSTIN"recode households .=225.67 if market=="BAKERSFIELD"recode households .=1108.36 if market=="BALTIMORE"recode households .=144.13 if market=="BANGOR"recode households .=334.73 if market=="BATON ROUGE"recode households .=170.01 if market=="BEAUMONT"recode households .=66.68 if market=="BEND"recode households .=109.09 if market=="BILLINGS"recode households .=136.74 if market=="BINGHAMTON"recode households .=747.19 if market=="BIRMINGHAM"recode households .=138.73 if market=="BISMARCK-MINOT"recode households .=143.28 if market=="BLUEFIELD-BECKLEY"recode households .=262.92 if market=="BOISE"recode households .=2460.29 if market=="BOSTON"
recode households .=2460.29 if market=="MANCHESTER, NH"recode households .=81.75 if market=="BOWLING GREEN"recode households .=636.32 if market=="BUFFALO"recode households .=330.73 if market=="BURLINGTON"recode households .=65.78 if market=="BUTTE"recode households .=346.01 if market=="CEDAR RAPIDS"recode households .=384.99 if market=="CHAMPAIGN"recode households .=312.77 if market=="CHARLESTON, SC"recode households .=505.20 if market=="CHARLESTON, WV"recode households .=1166.18 if market=="CHARLOTTE"recode households .=76.70 if market=="CHARLOTTESVILLE"recode households .=376.91 if market=="CHATTANOOGA"recode households .=3502.61 if market=="CHICAGO"recode households .=198.37 if market=="CHICO-REDDING"recode households .=923.83 if market=="CINCINNATI"recode households .=110.44 if market=="CLARKSBURG"recode households .=1526.20 if market=="CLEVELAND"recode households .=336.88 if market=="COLORADO SPRINGS"recode households .=178.61 if market=="COLUMBIA, MO"recode households .=405.67 if market=="COLUMBIA, SC"recode households .=219.45 if market=="COLUMBUS, GA"recode households .=915.95 if market=="COLUMBUS, OH"recode households .=190.27 if market=="COLUMBUS/TUPELO"recode households .=199.37 if market=="CORPUS CHRISTI"recode households .=2594.63 if market=="DALLAS"recode households .=309.80 if market=="DAVENPORT"recode households .=527.03 if market=="DAYTON"recode households .=1572.74 if market=="DENVER"recode households .=432.82 if market=="DES MOINES"recode households .=1883.84 if market=="DETROIT"recode households .=110.08 if market=="DOTHAN"recode households .=174.57 if market=="DULUTH"recode households .=315.13 if market=="EL PASO"recode households .=96.39 if market=="ELMIRA"recode households .=158.00 if market=="ERIE"recode households .=243.87 if market=="EUGENE"recode households .=61.57 if market=="EUREKA"recode households .=292.44 if market=="EVANSVILLE"recode households .=36.45 if market=="FAIRBANKS"recode households .=241.99 if market=="FARGO"recode households .=455.84 if market=="FLINT"recode households .=304.06 if market=="FORT SMITH"recode households .=581.34 if market=="FRESNO"recode households .=499.41 if market=="FT. MYERS"recode households .=277.05 if market=="FT. WAYNE"recode households .=130.46 if market=="GAINESVILLE"recode households .=4.04 if market=="GLENDIVE"recode households .=76.32 if market=="GRAND JUNCTION"recode households .=740.23 if market=="GRAND RAPIDS"recode households .=65.90 if market=="GREAT FALLS"recode households .=445.51 if market=="GREEN BAY"recode households .=699.04 if market=="GREENSBORO"recode households .=294.55 if market=="GREENVILLE, NC"recode households .=878.55 if market=="GREENVILLE, SC"recode households .=69.45 if market=="GREENWOOD"recode households .=356.01 if market=="HARLINGEN"recode households .=749.02 if market=="HARRISBURG"recode households .=1018.77 if market=="HARTFORD"recode households .=112.12 if market=="HATTIESBURG-LAUREL"recode households .=28.03 if market=="HELENA"recode households .=433.53 if market=="HONOLULU"recode households .=2177.22 if market=="HOUSTON"recode households .=399.44 if market=="HUNTSVILLE"recode households .=128.86 if market=="IDAHO FALLS-POCATELLO"recode households .=1106.42 if market=="INDIANAPOLIS"recode households .=338.03 if market=="JACKSON, MS"recode households .=77.70 if market=="JACKSON, TN"recode households .=678.43 if market=="JACKSONVILLE"recode households .=293.94 if market=="JOHNSTOWN"recode households .=83.00 if market=="JONESBORO"recode households .=156.36 if market=="JOPLIN"recode households .=25.25 if market=="JUNEAU"recode households .=974.82 if market=="KANSAS CITY"recode households .=557.04 if market=="KNOXVILLE"recode households .=216.51 if market=="LA CROSSE"recode households .=67.56 if market=="LAFAYETTE, IN"recode households .=231.56 if market=="LAFAYETTE, LA"recode households .=96.21 if market=="LAKE CHARLES"recode households .=253.38 if market=="LANSING"recode households .=70.09 if market=="LAREDO"recode households .=718.03 if market=="LAS VEGAS"recode households .=515.32 if market=="LEXINGTON"recode households .=40.02 if market=="LIMA"recode households .=279.82 if market=="LINCOLN"recode households .=573.67 if market=="LITTLE ROCK"recode households .=5666.90 if market=="LOS ANGELES"recode households .=674.94 if market=="LOUISVILLE"recode households .=241.12 if market=="MACON"recode households .=382.70 if market=="MADISON"recode households .=52.64 if market=="MANKATO"recode households .=87.67 if market=="MARQUETTE"recode households .=172.23 if market=="MEDFORD-KLAMATH FALLS"recode households .=693.86 if market=="MEMPHIS"recode households .=72.28 if market=="MERIDIAN"recode households .=1580.58 if market=="MIAMI"recode households .=901.10 if market=="MILWAUKEE"recode households .=1753.78 if market=="MINNEAPOLIS"recode households .=113.38 if market=="MISSOULA"recode households .=539.19 if market=="MOBILE"recode households .=177.90 if market=="MONROE"recode households .=229.15 if market=="MONTEREY"recode households .=244.47 if market=="MONTGOMERY"recode households .=289.57 if market=="MYRTLE BEACH"recode households .=1039.43 if market=="NASHVILLE"recode households .=635.86 if market=="NEW ORLEANS"recode households .=7515.33 if market=="NEW YORK"recode households .=716.05 if market=="NORFOLK"recode households .=146.31 if market=="ODESSA/MIDLAND"recode households .=704.67 if market=="OKLAHOMA CITY"recode households .=418.29 if market=="OMAHA"recode households .=1453.12 if market=="ORLANDO"recode households .=51.37 if market=="OTTUMWA"recode households .=398.82 if market=="PADUCAH"recode households .=157.18 if market=="PALM SPRINGS"recode households .=139.70 if market=="PANAMA CITY"recode households .=64.37 if market=="PARKERSBURG"recode households .=251.88 if market=="PEORIA"recode households .=3015.82 if market=="PHILADELPHIA"recode households .=1881.31 if market=="PHOENIX"recode households .=1160.82 if market=="PITTSBURGH"recode households .=410.30 if market=="PORTLAND, ME"recode households .=1197.78 if market=="PORTLAND, OR"recode households .=30.38 if market=="PRESQUE ISLE"recode households .=620.60 if market=="PROVIDENCE"recode households .=102.01 if market=="QUINCY"recode households .=1131.31 if market=="RALEIGH"recode households .=97.93 if market=="RAPID CITY"recode households .=271.38 if market=="RENO"recode households .=558.50 if market=="RICHMOND"recode households .=464.48 if market=="ROANOKE"recode households .=144.59 if market=="ROCHESTER, MN"recode households .=392.09 if market=="ROCHESTER, NY"recode households .=187.97 if market=="ROCKFORD"recode households .=1409.40 if market=="SACRAMENTO"recode households .=159.63 if market=="SALISBURY"recode households .=953.95 if market=="SALT LAKE CITY"recode households .=55.28 if market=="SAN ANGELO"recode households .=844.91 if market=="SAN ANTONIO"recode households .=1089.01 if market=="SAN DIEGO"recode households .=2523.52 if market=="SAN FRANCISCO"recode households .=239.25 if market=="SANTA BARBARA"recode households .=329.46 if market=="SAVANNAH"recode households .=1874.75 if market=="SEATTLE"recode households .=129.48 if market=="SHERMAN"recode households .=387.06 if market=="SHREVEPORT"recode households .=155.49 if market=="SIOUX CITY"recode households .=263.79 if market=="SIOUX FALLS"recode households .=336.22 if market=="SOUTH BEND"recode households .=424.22 if market=="SPOKANE"recode households .=269.50 if market=="SPRINGFIELD, MA"recode households .=424.27 if market=="SPRINGFIELD, MO"recode households .=1258.58 if market=="ST LOUIS"recode households .=48.04 if market=="ST. JOSEPH"recode households .=389.97 if market=="SYRACUSE"recode households .=282.11 if market=="TALLAHASSEE"recode households .=1795.20 if market=="TAMPA"recode households .=144.95 if market=="TERRE HAUTE"recode households .=445.60 if market=="TOLEDO"recode households .=179.51 if market=="TOPEKA"recode households .=242.70 if market=="TRAVERSE CITY"recode households .=337.61 if market=="TRI-CITIES"recode households .=461.45 if market=="TUCSON"recode households .=535.82 if market=="TULSA"recode households .=65.31 if market=="TWIN FALLS"recode households .=104.99 if market=="UTICA"recode households .=344.02 if market=="WACO"recode households .=2389.71 if market=="WASHINGTON DC"recode households .=95.75 if market=="WATERTOWN"recode households .=186.01 if market=="WAUSAU"recode households .=773.89 if market=="WEST PALM BEACH"recode households .=132.91 if market=="WHEELING-STEUBENVILLE"recode households .=457.88 if market=="WICHITA"recode households .=595.48 if market=="WILKES BARRE"recode households .=191.63 if market=="WILMINGTON"recode households .=225.32 if market=="YAKIMA"recode households .=268.15 if market=="YOUNGSTOWN"recode households .=118.70 if market=="YUMA-EL CENTRO"recode households .=32.55 if market=="ZANESVILLE"


* Create Weekend Dayparts
gen sunday=0
recode sunday 0=1 if airdate==date("03jan2010", "DMY")
recode sunday 0=1 if airdate==date("10jan2010", "DMY")
recode sunday 0=1 if airdate==date("17jan2010", "DMY")recode sunday 0=1 if airdate==date("24jan2010", "DMY")recode sunday 0=1 if airdate==date("31jan2010", "DMY")recode sunday 0=1 if airdate==date("07feb2010", "DMY")recode sunday 0=1 if airdate==date("14feb2010", "DMY")recode sunday 0=1 if airdate==date("21feb2010", "DMY")recode sunday 0=1 if airdate==date("28feb2010", "DMY")recode sunday 0=1 if airdate==date("07mar2010", "DMY")recode sunday 0=1 if airdate==date("14mar2010", "DMY")recode sunday 0=1 if airdate==date("21mar2010", "DMY")recode sunday 0=1 if airdate==date("28mar2010", "DMY")recode sunday 0=1 if airdate==date("04apr2010", "DMY")recode sunday 0=1 if airdate==date("11apr2010", "DMY")recode sunday 0=1 if airdate==date("18apr2010", "DMY")recode sunday 0=1 if airdate==date("25apr2010", "DMY")recode sunday 0=1 if airdate==date("02may2010", "DMY")recode sunday 0=1 if airdate==date("09may2010", "DMY")recode sunday 0=1 if airdate==date("16may2010", "DMY")recode sunday 0=1 if airdate==date("23may2010", "DMY")recode sunday 0=1 if airdate==date("30may2010", "DMY")recode sunday 0=1 if airdate==date("06jun2010", "DMY")recode sunday 0=1 if airdate==date("13jun2010", "DMY")recode sunday 0=1 if airdate==date("20jun2010", "DMY")recode sunday 0=1 if airdate==date("27jun2010", "DMY")recode sunday 0=1 if airdate==date("04jul2010", "DMY")recode sunday 0=1 if airdate==date("11jul2010", "DMY")recode sunday 0=1 if airdate==date("18jul2010", "DMY")recode sunday 0=1 if airdate==date("25jul2010", "DMY")recode sunday 0=1 if airdate==date("01aug2010", "DMY")recode sunday 0=1 if airdate==date("08aug2010", "DMY")recode sunday 0=1 if airdate==date("15aug2010", "DMY")recode sunday 0=1 if airdate==date("22aug2010", "DMY")recode sunday 0=1 if airdate==date("29aug2010", "DMY")recode sunday 0=1 if airdate==date("05sep2010", "DMY")recode sunday 0=1 if airdate==date("12sep2010", "DMY")recode sunday 0=1 if airdate==date("19sep2010", "DMY")recode sunday 0=1 if airdate==date("26sep2010", "DMY")recode sunday 0=1 if airdate==date("03oct2010", "DMY")recode sunday 0=1 if airdate==date("10oct2010", "DMY")recode sunday 0=1 if airdate==date("17oct2010", "DMY")recode sunday 0=1 if airdate==date("24oct2010", "DMY")recode sunday 0=1 if airdate==date("31oct2010", "DMY")recode sunday 0=1 if airdate==date("07nov2010", "DMY")recode sunday 0=1 if airdate==date("14nov2010", "DMY")recode sunday 0=1 if airdate==date("21nov2010", "DMY")recode sunday 0=1 if airdate==date("28nov2010", "DMY")recode sunday 0=1 if airdate==date("05dec2010", "DMY")recode sunday 0=1 if airdate==date("12dec2010", "DMY")recode sunday 0=1 if airdate==date("19dec2010", "DMY")recode sunday 0=1 if airdate==date("26dec2010", "DMY")

gen saturday=0
recode saturday 0=1 if airdate==date("02jan2010", "DMY")
recode saturday 0=1 if airdate==date("09jan2010", "DMY")recode saturday 0=1 if airdate==date("16jan2010", "DMY")recode saturday 0=1 if airdate==date("23jan2010", "DMY")recode saturday 0=1 if airdate==date("30jan2010", "DMY")recode saturday 0=1 if airdate==date("06feb2010", "DMY")recode saturday 0=1 if airdate==date("13feb2010", "DMY")recode saturday 0=1 if airdate==date("20feb2010", "DMY")recode saturday 0=1 if airdate==date("27feb2010", "DMY")recode saturday 0=1 if airdate==date("06mar2010", "DMY")recode saturday 0=1 if airdate==date("13mar2010", "DMY")recode saturday 0=1 if airdate==date("20mar2010", "DMY")recode saturday 0=1 if airdate==date("27mar2010", "DMY")recode saturday 0=1 if airdate==date("03apr2010", "DMY")recode saturday 0=1 if airdate==date("10apr2010", "DMY")recode saturday 0=1 if airdate==date("17apr2010", "DMY")recode saturday 0=1 if airdate==date("24apr2010", "DMY")recode saturday 0=1 if airdate==date("01may2010", "DMY")recode saturday 0=1 if airdate==date("08may2010", "DMY")recode saturday 0=1 if airdate==date("15may2010", "DMY")recode saturday 0=1 if airdate==date("22may2010", "DMY")recode saturday 0=1 if airdate==date("29may2010", "DMY")recode saturday 0=1 if airdate==date("05jun2010", "DMY")recode saturday 0=1 if airdate==date("12jun2010", "DMY")recode saturday 0=1 if airdate==date("19jun2010", "DMY")recode saturday 0=1 if airdate==date("26jun2010", "DMY")recode saturday 0=1 if airdate==date("03jul2010", "DMY")recode saturday 0=1 if airdate==date("10jul2010", "DMY")recode saturday 0=1 if airdate==date("17jul2010", "DMY")recode saturday 0=1 if airdate==date("24jul2010", "DMY")recode saturday 0=1 if airdate==date("31jul2010", "DMY")recode saturday 0=1 if airdate==date("07aug2010", "DMY")recode saturday 0=1 if airdate==date("14aug2010", "DMY")recode saturday 0=1 if airdate==date("21aug2010", "DMY")recode saturday 0=1 if airdate==date("28aug2010", "DMY")recode saturday 0=1 if airdate==date("04sep2010", "DMY")recode saturday 0=1 if airdate==date("11sep2010", "DMY")recode saturday 0=1 if airdate==date("18sep2010", "DMY")recode saturday 0=1 if airdate==date("25sep2010", "DMY")recode saturday 0=1 if airdate==date("02oct2010", "DMY")recode saturday 0=1 if airdate==date("09oct2010", "DMY")recode saturday 0=1 if airdate==date("16oct2010", "DMY")recode saturday 0=1 if airdate==date("23oct2010", "DMY")recode saturday 0=1 if airdate==date("30oct2010", "DMY")recode saturday 0=1 if airdate==date("06nov2010", "DMY")recode saturday 0=1 if airdate==date("13nov2010", "DMY")recode saturday 0=1 if airdate==date("20nov2010", "DMY")recode saturday 0=1 if airdate==date("27nov2010", "DMY")recode saturday 0=1 if airdate==date("04dec2010", "DMY")recode saturday 0=1 if airdate==date("11dec2010", "DMY")recode saturday 0=1 if airdate==date("18dec2010", "DMY")recode saturday 0=1 if airdate==date("25dec2010", "DMY")

encode daypart, generate(fulldaypart)
* 1=Daytime; 2=Early Fringe; 3=Early Morning; 4=Early News; 5=Late Fringe; 6=Late News; 
* 7=Prime Access; 8=Prime; 9=Wknd Late News; 10=Overnight; 11=Sat Morning; 12=Sat Afternoon
* 13=Sat Early Fringe; 14=Sat Prime Access; 15=Sun Morning; 16=Sun Afternoon; 17=Sun Early Fringe
recode fulldaypart 5 = 10 if airtime<"05:00:00"
recode fulldaypart 6 = 9 if saturday==1 | sunday==1
recode fulldaypart 3 = 11 if saturday==1
recode fulldaypart 1 = 11 if saturday==1 & airtime<"13:00:00"
recode fulldaypart 1 = 12 if saturday==1 & airtime>="13:00:00"
recode fulldaypart 2 = 12 if saturday==1 & airtime<"16:30:00"
recode fulldaypart 2 = 13 if saturday==1 & airtime>="16:30:00"
recode fulldaypart 4 = 13 if saturday==1
recode fulldaypart 7 = 13 if saturday==1 & airtime<"19:30:00"
recode fulldaypart 7 = 14 if saturday==1 & airtime>="19:30:00"
recode fulldaypart 3 = 15 if sunday==1
recode fulldaypart 1 = 15 if sunday==1 & airtime<"13:00:00"
recode fulldaypart 1 = 16 if sunday==1 & airtime>="13:00:00"
recode fulldaypart 2 = 16 if sunday==1 & airtime<"16:30:00"
recode fulldaypart 2 = 17 if sunday==1 & airtime>="16:30:00"
recode fulldaypart 4 = 17 if sunday==1


* Audience is a fraction of DMA households estimated to be viewing at that daypart
* Estimates for daypart obtained from Nielsen 
* Disclosure Restricted, so dayshare values for each daypart are redacted with "###"
* To obtain these values, contact Nielsen at http://www.nielsen.com/us/en/contact-us/research.html
* Author worked with Elizabeth Kamins at Nielsen

gen dayshare=.
recode dayshare .=.### if fulldaypart==1
recode dayshare .=.### if fulldaypart==2
recode dayshare .=.### if fulldaypart==3
recode dayshare .=.### if fulldaypart==4
recode dayshare .=.### if fulldaypart==5
recode dayshare .=.### if fulldaypart==6
recode dayshare .=.### if fulldaypart==7
recode dayshare .=.### if fulldaypart==8
recode dayshare .=.### if fulldaypart==9
recode dayshare .=.### if fulldaypart==10
recode dayshare .=.### if fulldaypart==11
recode dayshare .=.### if fulldaypart==12
recode dayshare .=.### if fulldaypart==13
recode dayshare .=.### if fulldaypart==14
recode dayshare .=.### if fulldaypart==15
recode dayshare .=.### if fulldaypart==16
recode dayshare .=.### if fulldaypart==17

gen audience = households*dayshare

* A Raw Weighted Negative
gen weighted_neg = negativity*audience

* save the file
save "/Volumes/External/Datasets/CMAG/CMAG 2010/2010HouseSen1.dta"
