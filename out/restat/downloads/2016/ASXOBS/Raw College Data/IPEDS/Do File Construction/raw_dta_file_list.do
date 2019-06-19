**** State of residence data ****

use "Raw Stata Files/dct_ef1986_c.dta", clear
keep unitid line efres01
gen newline = line
replace newline = 60 if line==58
replace newline = 66 if line==59
replace newline = 69 if line==60
replace newline = 72 if line==61
replace newline = 64 if line==62
replace newline = 78 if line==63
replace newline = 90 if line==64
replace newline = 99 if line==65
drop line
rename newline line
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 1986
save "Merge Stata Files/residence_1986.dta", replace

use "Raw Stata Files/dct_ef1988_c.dta", clear
keep unitid line efres01
gen newline = line
replace newline = 60 if line==58
replace newline = 66 if line==59
replace newline = 69 if line==60
replace newline = 72 if line==61
replace newline = 64 if line==62
replace newline = 78 if line==63
replace newline = 90 if line==64
replace newline = 99 if line==65
drop line
rename newline line
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 1988
save "Merge Stata Files/residence_1988.dta", replace

use "Raw Stata Files/dct_ef1992_c.dta", clear
keep unitid line efres01
gen newline = line
replace newline = 60 if line==58
replace newline = 66 if line==59
replace newline = 69 if line==60
replace newline = 72 if line==61
replace newline = 64 if line==62
replace newline = 78 if line==63
replace newline = 90 if line==64
replace newline = 99 if line==65
drop line
rename newline line
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 1992
save "Merge Stata Files/residence_1992.dta", replace

use "Raw Stata Files/dct_ef1994_c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 1994
save "Merge Stata Files/residence_1994.dta", replace

use "Raw Stata Files/dct_ef2000c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2000
save "Merge Stata Files/residence_2000.dta", replace

use "Raw Stata Files/dct_ef2001c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2001
save "Merge Stata Files/residence_2001.dta", replace

use "Raw Stata Files/dct_ef2002c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2002
save "Merge Stata Files/residence_2002.dta", replace

use "Raw Stata Files/dct_ef2003c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2003
save "Merge Stata Files/residence_2003.dta", replace

use "Raw Stata Files/dct_ef2004c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2004
save "Merge Stata Files/residence_2004.dta", replace

use "Raw Stata Files/dct_ef2005c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2005
save "Merge Stata Files/residence_2005.dta", replace

use "Raw Stata Files/dct_ef2006c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2006
save "Merge Stata Files/residence_2006.dta", replace

use "Raw Stata Files/dct_ef2007c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2007
save "Merge Stata Files/residence_2007.dta", replace

use "Raw Stata Files/dct_ef2008c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
collapse (sum) first_time_students, by(unitid state_of_residence)
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 2008
save "Merge Stata Files/residence_2008.dta", replace

use "Raw Stata Files/dct_ef96_c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 1996
save "Merge Stata Files/residence_1996.dta", replace

use "Raw Stata Files/dct_ef98_c.dta", clear
keep unitid line efres01
rename line state_of_residence
rename efres01 first_time_students
reshape wide first_time_students, i(unitid) j(state_of_residence)
gen int year = 1998
save "Merge Stata Files/residence_1998.dta", replace

**** Institution background data ****

use "Raw Stata Files/dct_fa2000hd.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 2000
save "Merge Stata Files/background_2000.dta", replace

use "Raw Stata Files/dct_fa2001hd.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 2001
save "Merge Stata Files/background_2001.dta", replace

use "Raw Stata Files/dct_hd2002.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 2002
save "Merge Stata Files/background_2002.dta", replace

use "Raw Stata Files/dct_hd2003.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 2003
save "Merge Stata Files/background_2003.dta", replace

use "Raw Stata Files/dct_hd2004.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 2004
save "Merge Stata Files/background_2004.dta", replace

use "Raw Stata Files/dct_hd2005.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 2005
save "Merge Stata Files/background_2005.dta", replace

use "Raw Stata Files/dct_hd2006.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 2006
save "Merge Stata Files/background_2006.dta", replace

use "Raw Stata Files/dct_hd2007.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 2007
save "Merge Stata Files/background_2007.dta", replace

use "Raw Stata Files/dct_hd2008.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 2008
save "Merge Stata Files/background_2008.dta", replace

use "Raw Stata Files/dct_ic1986_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1986
save "Merge Stata Files/background_1986.dta", replace

use "Raw Stata Files/dct_ic1987_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1987
save "Merge Stata Files/background_1987.dta", replace

use "Raw Stata Files/dct_ic1988_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1988
save "Merge Stata Files/background_1988.dta", replace

use "Raw Stata Files/dct_ic1989_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1989
save "Merge Stata Files/background_1989.dta", replace

use "Raw Stata Files/dct_ic1991_hdr.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1991
save "Merge Stata Files/background_1991.dta", replace

use "Raw Stata Files/dct_ic1992_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1992
save "Merge Stata Files/background_1992.dta", replace

use "Raw Stata Files/dct_ic1993_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1993
save "Merge Stata Files/background_1993.dta", replace

use "Raw Stata Files/dct_ic1994_a.dta", clear
keep unitid instnm city stabbr fips control iclevel
rename instnm name
rename stabbr state
gen int year = 1994
save "Merge Stata Files/background_1994.dta", replace

* year for this file is based on classification of data on IPEDS website
use "Raw Stata Files/dct_ic9596_a.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 1995
save "Merge Stata Files/background_1995.dta", replace

* year for this file is based on classification of data on IPEDS website
use "Raw Stata Files/dct_ic9697_a.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 1996
save "Merge Stata Files/background_1996.dta", replace

* year for this file is based on classification of data on IPEDS website
use "Raw Stata Files/dct_ic9798_hdr.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 1997
save "Merge Stata Files/background_1997.dta", replace

use "Raw Stata Files/dct_ic98hdac.dta", clear
keep unitid instnm city stabbr fips control pctmin1 pctmin3 pctmin4 iclevel
rename instnm name
rename stabbr state
rename pctmin1 black
rename pctmin3 asian
rename pctmin4 hispanic
gen int year = 1998
save "Merge Stata Files/background_1998.dta", replace


**** Applicant characteristics ****


use "Raw Stata Files/dct_ic2001.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2001
save "Merge Stata Files/applicants_2001.dta", replace

use "Raw Stata Files/dct_ic2002.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2002
save "Merge Stata Files/applicants_2002.dta", replace

use "Raw Stata Files/dct_ic2003.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2003
save "Merge Stata Files/applicants_2003.dta", replace

use "Raw Stata Files/dct_ic2004.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2004
save "Merge Stata Files/applicants_2004.dta", replace

use "Raw Stata Files/dct_ic2005.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2005
save "Merge Stata Files/applicants_2005.dta", replace

use "Raw Stata Files/dct_ic2006.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2006
save "Merge Stata Files/applicants_2006.dta", replace

use "Raw Stata Files/dct_ic2007.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2007
save "Merge Stata Files/applicants_2007.dta", replace

use "Raw Stata Files/dct_ic2008.dta", clear
keep unitid appdate applcnm applcnw admssnm admssnw enrlftm enrlftw satactdt satnum satpct actnum actpct satvr25 satvr75 satmt25 satmt75 actcm25 actcm75 acten25 acten75 actmt25 actmt75
rename satactdt satdate
rename applcnm applicants_male
rename applcnw applicants_female
rename admssnm admits_male
rename admssnw admits_female
rename enrlftm enrolled_male
rename enrlftw enrolled_female
gen int year = 2008
save "Merge Stata Files/applicants_2008.dta", replace
