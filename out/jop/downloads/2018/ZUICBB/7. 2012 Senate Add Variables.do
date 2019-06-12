******************************************
*** Attacks Ads - Ken Miller *************
*** 7. 2012 Senate Add Variables **********
******************************************

clear
set more off
set scheme lean1

use "/Volumes/External/Datasets/CMAG/CMAG 2012/2012senads.dta"

* Create the general election variable
encode election, generate(genelect)

* Create negativity ratio
gen negativity=.
recode negativity .=1 if ad_tone==3
recode negativity .=0 if ad_tone==2
recode negativity .=.25 if cnt_prp==1
recode negativity .=.5 if cnt_prp==2
recode negativity .=.75 if cnt_prp==3
recode negativity .=1 if cnt_prp==4

* Create grouptype
encode sponsor_name if sponsor==4, generate(groupname)
label list groupname
gen outsider=groupname
recode outsider 1 2 3 4 5 6 7 8 11 13 14 21 23 24 25 26 27 28 29 31 33 34 36 37 43 49 50 53 ///
                54 55 56 57 58 60 66 67 68 69 70 71 72 74 76 77 80 81 86 87 88 89 90 92 94 ///
                95 96 97 98 99 100 = 3 ///
                9 10 12 15 16 17 18 22 32 39 41 44 45 46 48 61 62 63 64 78 79 83 85 93 = 2 ///
                19 20 30 35 38 40 42 47 51 52 59 65 73 75 82 84 91 = 4

gen grouptype=.
recode grouptype .=1 if sponsor==1
recode grouptype .=2 if sponsor==2 | sponsor==3
recode grouptype .=3 if outsider==2
recode grouptype .=4 if outsider==3
recode grouptype .=5 if outsider==4

gen noncand=0
recode noncand 0=1 if grouptype==2 
recode noncand 0=1 if grouptype==3
recode noncand 0=1 if grouptype==4
recode noncand 0=1 if grouptype==5

label define grp 1 "1.Candidate" 2 "2.Party" 3 "3.Party-Adjacent" 4 "4.Issue-Based" 5 "5.Single Candidate"
label values grouptype grp

* Create disclosure
gen outdisc=groupname
recode outdisc 2 3 4 5 6 8 10 13 14 18 20 26 30 31 33 34 35 36 37 38 39 40 41 43 46 47 48 ///
               49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 66 67 69 70 71 73 74 75 76 ///
               79 80 81 82 83 84 85 86 87 88 90 91 94 95 96 97 99 100 = 1  1 7 9 11 12 15 ///
               16 17 19 21 22 23 24 25 27 28 29 32 42 44 45 65 66 72 77 78 89 92 93 98 = 2

gen disclosure=.
recode disclosure .=1 if grouptype==1 | grouptype==2
recode disclosure .=1 if outdisc==1
recode disclosure .=2 if outdisc==2

label define disc 1 "1.Tranparent" 2 "2.Opaque"
label values disclosure disc

gen campaign=.
recode campaign .=74 if categorystate=="AZ" & party=="DEMOCRAT"
recode campaign .=75 if categorystate=="AZ" & party=="REPUBLICAN"
recode campaign .=76 if categorystate=="CA" & party=="DEMOCRAT"
recode campaign .=77 if categorystate=="CA" & party=="REPUBLICAN"
recode campaign .=78 if categorystate=="CT" & party=="DEMOCRAT"
recode campaign .=79 if categorystate=="CT" & party=="REPUBLICAN"
recode campaign .=80 if categorystate=="DE" & party=="DEMOCRAT"
recode campaign .=81 if categorystate=="DE" & party=="REPUBLICAN"
recode campaign .=82 if categorystate=="FL" & party=="DEMOCRAT"
recode campaign .=83 if categorystate=="FL" & party=="REPUBLICAN"
recode campaign .=84 if categorystate=="HI" & party=="DEMOCRAT"
recode campaign .=85 if categorystate=="HI" & party=="REPUBLICAN"
recode campaign .=86 if categorystate=="IN" & party=="DEMOCRAT"
recode campaign .=87 if categorystate=="IN" & party=="REPUBLICAN"
recode campaign .=88 if categorystate=="ME" & party=="DEMOCRAT"
recode campaign .=89 if categorystate=="ME" & party=="REPUBLICAN"
recode campaign .=90 if categorystate=="ME" & party=="OTHER"
recode campaign .=91 if categorystate=="MD" & party=="DEMOCRAT"
recode campaign .=92 if categorystate=="MD" & party=="REPUBLICAN"
recode campaign .=93 if categorystate=="MD" & party=="OTHER"
recode campaign .=94 if categorystate=="MA" & party=="DEMOCRAT"
recode campaign .=95 if categorystate=="MA" & party=="REPUBLICAN"
recode campaign .=96 if categorystate=="MI" & party=="DEMOCRAT"
recode campaign .=97 if categorystate=="MI" & party=="REPUBLICAN"
recode campaign .=98 if categorystate=="MN" & party=="DEMOCRAT"
recode campaign .=99 if categorystate=="MN" & party=="REPUBLICAN"
recode campaign .=100 if categorystate=="MS" & party=="REPUBLICAN"
recode campaign .=101 if categorystate=="MO" & party=="DEMOCRAT"
recode campaign .=102 if categorystate=="MO" & party=="REPUBLICAN"
recode campaign .=103 if categorystate=="MT" & party=="DEMOCRAT"
recode campaign .=104 if categorystate=="MT" & party=="REPUBLICAN"
recode campaign .=105 if categorystate=="NE" & party=="DEMOCRAT"
recode campaign .=106 if categorystate=="NE" & party=="REPUBLICAN"
recode campaign .=107 if categorystate=="NV" & party=="DEMOCRAT"
recode campaign .=108 if categorystate=="NV" & party=="REPUBLICAN"
recode campaign .=109 if categorystate=="NJ" & party=="DEMOCRAT"
recode campaign .=110 if categorystate=="NJ" & party=="REPUBLICAN"
recode campaign .=111 if categorystate=="NM" & party=="DEMOCRAT"
recode campaign .=112 if categorystate=="NM" & party=="REPUBLICAN"
recode campaign .=113 if categorystate=="NY" & party=="DEMOCRAT"
recode campaign .=114 if categorystate=="NY" & party=="REPUBLICAN"
recode campaign .=115 if categorystate=="ND" & party=="DEMOCRAT"
recode campaign .=116 if categorystate=="ND" & party=="REPUBLICAN"
recode campaign .=117 if categorystate=="OH" & party=="DEMOCRAT"
recode campaign .=118 if categorystate=="OH" & party=="REPUBLICAN"
recode campaign .=119 if categorystate=="PA" & party=="DEMOCRAT"
recode campaign .=120 if categorystate=="PA" & party=="REPUBLICAN"
recode campaign .=121 if categorystate=="RI" & party=="DEMOCRAT"
recode campaign .=122 if categorystate=="RI" & party=="REPUBLICAN"
recode campaign .=123 if categorystate=="TN" & party=="REPUBLICAN"
recode campaign .=124 if categorystate=="TX" & party=="DEMOCRAT"
recode campaign .=125 if categorystate=="TX" & party=="REPUBLICAN"
recode campaign .=126 if categorystate=="UT" & party=="DEMOCRAT"
recode campaign .=127 if categorystate=="UT" & party=="REPUBLICAN"
recode campaign .=128 if categorystate=="VT" & party=="DEMOCRAT"
recode campaign .=129 if categorystate=="VT" & party=="REPUBLICAN"
recode campaign .=130 if categorystate=="VA" & party=="DEMOCRAT"
recode campaign .=131 if categorystate=="VA" & party=="REPUBLICAN"
recode campaign .=132 if categorystate=="WA" & party=="DEMOCRAT"
recode campaign .=133 if categorystate=="WA" & party=="REPUBLICAN"
recode campaign .=134 if categorystate=="WV" & party=="DEMOCRAT"
recode campaign .=135 if categorystate=="WV" & party=="REPUBLICAN"
recode campaign .=136 if categorystate=="WI" & party=="DEMOCRAT"
recode campaign .=137 if categorystate=="WI" & party=="REPUBLICAN"
*recode campaign .=138 if categorystate=="WY" & party=="REPUBLICAN"


* Create Market Weights
* Drop national ads
drop if market=="NATIONAL CABLE"* Market Size
gen households=.
recode households .=114.08 if market=="ABILENE-SWEETWAT"
recode households .=540.05 if market=="ALBANY, NY"recode households .=691.45 if market=="ALBUQUERQUE"recode households .=16.91 if market=="ALPENA"recode households .=197.11 if market=="AMARILLO"recode households .=705.28 if market=="AUSTIN"recode households .=221.74 if market=="BAKERSFIELD"recode households .=1085.07 if market=="BALTIMORE"recode households .=138.04 if market=="BANGOR"recode households .=167.11 if market=="BEAUMONT"recode households .=109.73 if market=="BILLINGS"recode households .=128.3 if market=="BILOXI"recode households .=133.42 if market=="BINGHAMTON"recode households .=150 if market=="BISMARCK-MINOT"recode households .=134.41 if market=="BLUEFIELD-BECKLE"recode households .=2366.69 if market=="BOSTON"recode households .=632.15 if market=="BUFFALO"recode households .=316.91 if market=="BURLINGTON"recode households .=67.18 if market=="BUTTE"recode households .=455.49 if market=="CHARLESTON, WV"recode households .=74.34 if market=="CHARLOTTESVILLE"recode households .=353.71 if market=="CHATTANOOGA"recode households .=3484.8 if market=="CHICAGO"recode households .=191.5 if market=="CHICO-REDDING"recode households .=897.89 if market=="CINCINNATI"recode households .=106.48 if market=="CLARKSBURG"recode households .=1485.14 if market=="CLEVELAND"recode households .=173.64 if market=="COLUMBIA, MO"recode households .=930.46 if market=="COLUMBUS, OH"recode households .=184.99 if market=="COLUMBUS/TUPELO"recode households .=203.73 if market=="CORPUS CHRISTI"recode households .=2588.02 if market=="DALLAS"recode households .=498.27 if market=="DAYTON"recode households .=1845.92 if market=="DETROIT"recode households .=107.11 if market=="DOTHAN"recode households .=169.61 if market=="DULUTH"recode households .=339.13 if market=="EL PASO"recode households .=95.53 if market=="ELMIRA"recode households .=155.19 if market=="ERIE"recode households .=284.04 if market=="EVANSVILLE"recode households .=243.89 if market=="FARGO"recode households .=446.01 if market=="FLINT"recode households .=576.82 if market=="FRESNO"recode households .=502.05 if market=="FT. MYERS"recode households .=265.39 if market=="FT. WAYNE"recode households .=123.43 if market=="GAINESVILLE"recode households .=4.05 if market=="GLENDIVE"recode households .=720.15 if market=="GRAND RAPIDS"recode households .=65.93 if market=="GREAT FALLS"recode households .=441.8 if market=="GREEN BAY"recode households .=66.41 if market=="GREENWOOD"recode households .=364.16 if market=="HARLINGEN"recode households .=716.99 if market=="HARRISBURG"recode households .=90.26 if market=="HARRISONBURG"recode households .=996.55 if market=="HARTFORD"recode households .=109.95 if market=="HATTIESBURG-LAUR"recode households .=28.26 if market=="HELENA"recode households .=437.79 if market=="HONOLULU"recode households .=2215.65 if market=="HOUSTON"recode households .=1089.7 if market=="INDIANAPOLIS"recode households .=331.5 if market=="JACKSON, MS"recode households .=93.09 if market=="JACKSON, TN"recode households .=659.17 if market=="JACKSONVILLE"recode households .=288.1 if market=="JOHNSTOWN"recode households .=151.2 if market=="JOPLIN"recode households .=931.32 if market=="KANSAS CITY"recode households .=520.89 if market=="KNOXVILLE"recode households .=211.67 if market=="LA CROSSE"recode households .=66.24 if market=="LAFAYETTE, IN"recode households .=251.14 if market=="LANSING"recode households .=72.59 if market=="LAREDO"recode households .=718.99 if market=="LAS VEGAS"recode households .=51.24 if market=="LIMA"recode households .=276.79 if market=="LINCOLN"recode households .=5613.46 if market=="LOS ANGELES"recode households .=670.88 if market=="LOUISVILLE"recode households .=159.84 if market=="LUBBOCK"recode households .=376.67 if market=="MADISON"recode households .=52.53 if market=="MANKATO"recode households .=84.64 if market=="MARQUETTE"recode households .=662.83 if market=="MEMPHIS"recode households .=68.86 if market=="MERIDIAN"recode households .=1621.13 if market=="MIAMI"recode households .=902.19 if market=="MILWAUKEE"recode households .=1728.05 if market=="MINNEAPOLIS"recode households .=113.01 if market=="MISSOULA"recode households .=525.99 if market=="MOBILE"recode households .=1014.91 if market=="NASHVILLE"recode households .=7384.34 if market=="NEW YORK"recode households .=709.73 if market=="NORFOLK"recode households .=14.72 if market=="NORTH PLATTE"recode households .=147.73 if market=="ODESSA/MIDLAND"recode households .=414.06 if market=="OMAHA"recode households .=1453.17 if market=="ORLANDO"recode households .=46.73 if market=="OTTUMWA"recode households .=388.34 if market=="PADUCAH"recode households .=129.39 if market=="PANAMA CITY"recode households .=62.62 if market=="PARKERSBURG"recode households .=2949.31 if market=="PHILADELPHIA"recode households .=1812.04 if market=="PHOENIX"recode households .=1165.74 if market=="PITTSBURGH"recode households .=389.53 if market=="PORTLAND, ME"recode households .=1182.18 if market=="PORTLAND, OR"recode households .=29.25 if market=="PRESQUE ISLE"recode households .=606.4 if market=="PROVIDENCE"recode households .=103.52 if market=="QUINCY"recode households .=265.6 if market=="RENO"recode households .=553.39 if market=="RICHMOND"recode households .=445.47 if market=="ROANOKE"recode households .=143.33 if market=="ROCHESTER, MN"recode households .=395.68 if market=="ROCHESTER, NY"recode households .=1387.71 if market=="SACRAMENTO"recode households .=157.83 if market=="SALISBURY"recode households .=917.37 if market=="SALT LAKE CITY"recode households .=55.82 if market=="SAN ANGELO"recode households .=881.05 if market=="SAN ANTONIO"recode households .=1075.12 if market=="SAN DIEGO"recode households .=2502.03 if market=="SAN FRANCISCO"recode households .=231.95 if market=="SANTA BARBARA"recode households .=1818.9 if market=="SEATTLE"recode households .=384.41 if market=="SHREVEPORT"recode households .=154.83 if market=="SIOUX CITY"recode households .=258.46 if market=="SIOUX FALLS"recode households .=319.86 if market=="SOUTH BEND"recode households .=420.64 if market=="SPOKANE"recode households .=252.95 if market=="SPRINGFIELD, MA"recode households .=414.57 if market=="SPRINGFIELD, MO"recode households .=1243.49 if market=="ST LOUIS"recode households .=46.18 if market=="ST. JOSEPH"recode households .=377.55 if market=="SYRACUSE"recode households .=273.12 if market=="TALLAHASSEE"recode households .=1806.56 if market=="TAMPA"recode households .=139.6 if market=="TERRE HAUTE"recode households .=409.55 if market=="TOLEDO"recode households .=241.8 if market=="TRAVERSE CITY"recode households .=319.06 if market=="TRI-CITIES"recode households .=438.44 if market=="TUCSON"recode households .=268.15 if market=="TYLER"recode households .=102.89 if market=="UTICA"recode households .=31.56 if market=="VICTORIA"recode households .=349.54 if market=="WACO"recode households .=2359.16 if market=="WASHINGTON DC"recode households .=92.59 if market=="WATERTOWN"recode households .=179.45 if market=="WAUSAU"recode households .=794.31 if market=="WEST PALM BEACH"recode households .=130.11 if market=="WHEELING-STEUBEN"recode households .=581.02 if market=="WILKES BARRE"recode households .=231.95 if market=="YAKIMA"recode households .=260 if market=="YOUNGSTOWN"recode households .=113.23 if market=="YUMA-EL CENTRO"recode households .=32.94 if market=="ZANESVILLE"

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
save "/Volumes/External/Datasets/CMAG/CMAG 2012/2012senate2.dta"



