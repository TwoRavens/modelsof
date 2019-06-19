clear all
set mem 2g
set more off

use "C:\D\Research\Charter\Houston\HISDdata\DataFiles\SecondGrades\secondary_classes.dta",


*IDENTIFY COURSE TYPE
sort course
merge course using "C:\teacher free riding\aspire_course_list_2009.dta", keep(subject)
replace subject = "" if year <= 2005
replace course_type = "" if year >= 2006
replace course_type = "eng" if subject == "Language Arts" & year >= 2006
replace course_type = "read" if subject == "Reading" & year >= 2006
replace course_type = "math" if subject == "Math" & year >= 2006
replace course_type = "sci" if subject == "Science" & year >= 2006
replace course_type = "soc" if subject == "Social Studies" & year >= 2006


*LIMIT TO HS ASPIRE GRADES
keep if grade >= 9 & grade <= 11


*IDENTIFY ASPIRE COURESES
gen  aspire_course = 1 if course_type != ""
# delimit ;
foreach course in 
"ADV JOURNAL 1A"
"ADV JOURNAL 1B"
"ADV JOURNAL 3A"
"ADV JOURNAL 3B"
"BRDCST JOURN 1A"
"BRDCST JOURN 1B"
"BRDCST JOURN 2A"
"BRDCST JOURN 2B"
"BRDCST JOURN 3A"
"BRDCST JOURN 3B"
"JOURNALISM 1A"
"JOURNALISM 1B"
"COMM APPLICATN"
"COMM APPS - HCC"
"COMMAPPL - BIL"
"ESL COMM APPL"
"ESL SPE COM 1A"
"ESL SPE COM 1B"
"CREAT WRIT A VG"
"CREAT WRIT B VG"
"CREATIVE WRIT A"
"CREATIVE WRIT B"
"CREATIVE WRITNG"
"ESL CREAT WRI A"
"ESL CREAT WRI B"
"TRAN CREA WRI A"
"TRAN CREA WRI B"
"DEBATE 1A"
"DEBATE 1A HON"
"DEBATE 1B"
"DEBATE 1B HON"
"DEBATE 2A"
"DEBATE 2A HON"
"DEBATE 2B"
"DEBATE 2B HON"
"DEBATE 3A"
"DEBATE 3A HON"
"DEBATE 3B"
"DEBATE 3B HON"
"HUMANITIES 1A"
"IND STDY SPE  A"
"IND STDY SPE  B"
"LIT GENRES 1A"
"LIT GENRES 1B"
"LIT GENRES VG"
"LITERARY GENRES"
"MEDIA LIT-SPE A"
"MEDIA LIT-SPE B"
"NEWSPAPER 1A"
"NEWSPAPER 1B"
"NEWSPAPER 2A"
"NEWSPAPER 2AHON"
"NEWSPAPER 2B"
"NEWSPAPER 2BHON"
"NEWSPAPER 3A"
"NEWSPAPER 3B"
"ORAL INTERPR 1A"
"ORAL INTERPR 1B"
"ORAL INTERPR 2A"
"ORAL INTERPR 2B"
"ORAL INTR 1AESL"
"ORAL INTR 1BESL"
"PHOTOJOURN 1A"
"PHOTOJOURN 1B"
"PRAC WRT SKLS A"
"PRAC WRT SKLS B"
"PRACT WRIT SK"
"ESL PRAC WRIT A"
"ESL PRAC WRIT B"
"TRAN PRAC WRI A"
"PUBLIC SPEAK 1A"
"PUBLIC SPEAK 1B"
"SPEECH COM 1A"
"SPEECH COM 1B"
"ESL TECH WRIT A"
"ESL TECH WRIT B"
"TECH WR A GT"
"TECH WR B GT"
"TECHNICAL WR"
"TECHNICAL WR A"
"TECHNICAL WR B"
"TRAN CREA WRI A"
"TRAN CREA WRI B"
"TRAN PRAC WRI A"
"YEARBOOK 1A"
"YEARBOOK 1B"
"YEARBOOK 2A"
"YEARBOOK 2A H"
"YEARBOOK 2B"
"YEARBOOK 2B H"
"YEARBOOK 3A"
"YEARBOOK 3B"
"NAT LAN RD I 1A"
"NAT LAN RD I 1B"
"AEROSP AVIA 3A"
"AEROSP AVIA 3B"
"AQUATIC SCI  A"
"AQUATIC SCI  B"
"ASTRONOMY  A"
"ASTRONOMY  B"
"ASTRONOMY A-HCC"
"ASTRONOMY B-HCC"
"MUSEUM STUDY VG"
"SOCIOLOGY"
"SOCIOLOGY-HCC"
"PSYCHOLOGY"
"PSYCHOLOGY AP"
"PSYCHOLOGY-HCC"
"SPTSS 1 - HCC"
"SPTSS TOPIC 1"
"SPTSS TOPIC 2"
"SPTSS: 1968 VG"
"SPTSS: ETHICS"
"SPTSS:AFRO STDY"
"SPTSS:COMP CULT"
"SPTSS:CON IS II"
"SPTSS:CON ISS I"
"SPTSS:ETH&LEAD"
"SPTSS:HOLOCAUST"
"SPTSS:PHIL I VG"
"SPTSS:PHIL IIVG"
"SS RES METH"
"SS RES METH VG"
"SS RES METHODS"
"SSAS:A CUL STYA"
"SSAS:A CUL STYB"
"SSAS:G/T MENT A"
"SSAS:G/T MENT B"
"SSAS:RESEARCH A"
"SSAS:RESEARCH B"
"SSAS:WORLD WARS"
{;
replace aspire_course = 0 if crs_title == "`course'";
};

# delimit cr
*GENERATE PREP NUMBER
keep if course_type != ""
gen unit = 1
collapse (mean) aspire_course unit, by(tch_number campus year crs_title)
egen teacher_preps = sum(unit), by(tch_number campus year)

*COLLAPSE BY TEACHER-COURSE


sort tch_number campus year crs_title
save "C:\teacher free riding\teacher_preps.dta", replace


