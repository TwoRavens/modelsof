* Date: April 25, 2011
* Apply to: hst3879.dat
* Description: This set of commands imports data on committee membership
* compiled by Charles Stewart for the 38th to 79th congresses, extracts 
* measures of committee membership and chairs and collapses to member-
* congress observations.

clear

set more off


* Import, format Stewart text file

infix V1 1-2 V2 3 V3 4-6 ///
     V4 7-11 str V5 12-36 V6 37 ///
     V7 38-39 V8 40-41 V9 42-43 ///
     V10 44-47 V11 48-49 V12 50-51 ///
     V13 52-55 V14 56-59 ///
     using "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Committees\hst3879.dat"

rename V1 cong
rename V2 session
rename V3 comm
rename V4 id
rename V5 name
rename V6 ptystat
rename V7 rank
rename V8 moa
rename V9 daa
rename V10 yea
rename V11 mot
rename V12 dat
rename V13 yet
rename V14 party


* Counter for assignments

gen com_no = 1

gen com_any = 1

gen chr_no = 0
replace chr_no = 1 if rank==1

gen chr_any = 0
replace chr_any = 1 if rank==1


* Committee dummies

* Private
* Pensions (46-79)

gen com_pens = 0
replace com_pens = 1 if comm==163

gen chr_pens = 0
replace chr_pens = 1 if comm==163 & rank==1


* Invalid Pensions (38-79)

gen com_pinv = 0
replace com_pinv = 1 if comm==111

gen chr_pinv = 0
replace chr_pinv = 1 if comm==111 & rank==1


* Pensions (Combined)

gen com_pcom = 0
replace com_pcom = 1 if com_pens==1
replace com_pcom = 1 if com_pinv==1

gen chr_pcom = 0
replace chr_pcom = 1 if com_pens==1 & rank==1
replace chr_pcom = 1 if com_pinv==1 & rank==1


* War Claims (43-79)

gen com_clms = 0
replace com_clms = 1 if comm==241

gen chr_clms = 0
replace chr_clms = 1 if comm==241 & rank==1


* Military Affairs (38-79)

gen com_maff = 0
replace com_maff = 1 if comm==145

gen chr_maff = 0
replace chr_maff = 1 if comm==145 & rank==1


* Naval Affairs (38-79)

gen com_naff = 0
replace com_naff = 1 if comm==151

gen chr_naff = 0
replace chr_naff = 1 if comm==151 & rank==1


* Military Records (Combined)

gen com_baff = 0
replace com_baff = 1 if com_maff==1
replace com_baff = 1 if com_naff==1

gen chr_baff = 0
replace chr_baff = 1 if com_maff==1 & rank==1
replace chr_baff = 1 if com_naff==1 & rank==1


* Local
* Commerce (38-51) / Interstate and Foreign Commerce (52-79)

gen com_cmrc = 0
replace com_cmrc = 1 if comm==25
replace com_cmrc = 1 if comm==109

gen chr_cmrc = 0
replace chr_cmrc = 1 if comm==25 & rank==1
replace chr_cmrc = 1 if comm==109 & rank==1
 

* Indian Affairs (38-79)

gen com_iaff = 0
replace com_iaff = 1 if comm==102

gen chr_iaff = 0
replace chr_iaff = 1 if comm==102 & rank==1


* Judiciary (38-79)

gen com_judi = 0
replace com_judi = 1 if comm==121

gen chr_judi = 0
replace chr_judi = 1 if comm==121 & rank==1


* Merchant Marine and Fisheries (50-79)

gen com_fish = 0
replace com_fish = 1 if comm==143

gen chr_fish = 0
replace chr_fish = 1 if comm==143 & rank==1


* Public Buildings and Grounds (38-79)

gen com_bild = 0
replace com_bild = 1 if comm==169

gen chr_bild = 0
replace chr_bild = 1 if comm==169 & rank==1


* Public Lands (38-79)

gen com_land = 0
replace com_land = 1 if comm==171

gen chr_land = 0
replace chr_land = 1 if comm==171 & rank==1


* Rivers and Harbors (48-79)

gen com_rhar = 0
replace com_rhar = 1 if comm==187

gen chr_rhar = 0
replace chr_rhar = 1 if comm==187 & rank==1


* Internal Improvements (Combined)

gen com_iimp = 0
replace com_iimp = 1 if com_cmrc==1
replace com_iimp = 1 if com_rhar==1

gen chr_iimp = 0
replace chr_iimp = 1 if com_cmrc==1 & rank==1
replace chr_iimp = 1 if com_rhar==1 & rank==1


* Policy
* Agriculture (39-79)

gen com_agri = 0
replace com_agri = 1 if comm==2

gen chr_agri = 0
replace chr_agri = 1 if comm==2 & rank==1


* Banking and Currency (39-79)

gen com_bank = 0
replace com_bank = 1 if comm==11

gen chr_bank = 0
replace chr_bank = 1 if comm==11 & rank==1


* Education and Labor (40-47) / Education (48-79)

gen com_educ = 0
replace com_educ = 1 if comm==41
replace com_educ = 1 if comm==42

gen chr_educ = 0
replace chr_educ = 1 if comm==41 & rank==1
replace chr_educ = 1 if comm==42 & rank==1


* Foreign Affairs (38-79)

gen com_faff = 0
replace com_faff = 1 if comm==72

gen chr_faff = 0
replace chr_faff = 1 if comm==72 & rank==1


* Immigration and Naturalization (51-79)

gen com_imig = 0
replace com_imig = 1 if comm==101

gen chr_imig = 0
replace chr_imig = 1 if comm==101 & rank==1


* Education and Labor (40-47) / Labor (48-79)

gen com_labo = 0
replace com_labo = 1 if comm==131
replace com_labo = 1 if comm==42

gen chr_labo = 0
replace chr_labo = 1 if comm==131 & rank==1
replace chr_labo = 1 if comm==42 & rank==1


* Ways and Means (38-79)

gen com_ways = 0
replace com_ways = 1 if comm==242

gen chr_ways = 0
replace chr_ways = 1 if comm==242 & rank==1


* Education and Labor (Combined)

gen com_edla = 0
replace com_edla = 1 if com_educ==1
replace com_edla = 1 if com_labo==1

gen chr_edla = 0
replace chr_edla = 1 if com_educ==1 & rank==1
replace chr_edla = 1 if com_labo==1 & rank==1


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Committees\com_38_79_assigns.dta", replace


* Collapse to member-congress observations

collapse (max) com_any chr_any (sum) com_no chr_no ///
     com_pens com_pinv com_pcom com_clms com_maff com_naff com_baff ///
	 com_cmrc com_iaff com_bild com_land com_judi com_fish com_rhar com_iimp ///
	 com_agri com_bank com_educ com_faff com_imig com_labo com_ways com_edla ///
     chr_pens chr_pinv chr_pcom chr_clms chr_maff chr_naff chr_baff ///
	 chr_cmrc chr_iaff chr_bild chr_land chr_judi chr_fish chr_rhar chr_iimp ///
	 chr_agri chr_bank chr_educ chr_faff chr_imig chr_labo chr_ways chr_edla ///
	 , by(id cong)

drop if id==0

gen long icpsr_cong = (id * 1000) + cong

drop id cong

sort icpsr_cong


save "C:\Users\samacken\Documents\MWW_Combined\1605 AJPS\Committees\com_38_79.dta", replace

* End
