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
drop if market=="NATIONAL CABLE"
gen households=.
recode households .=114.08 if market=="ABILENE-SWEETWAT"
recode households .=540.05 if market=="ALBANY, NY"

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


