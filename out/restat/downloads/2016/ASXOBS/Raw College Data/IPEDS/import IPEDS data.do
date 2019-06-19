*** IPEDS timing: year==2008 = FY 2008 / Academic Year 2007-2008 / Fall 2008
*** "Fall 2001" for admissions/SATs appears to pertain to students who *enroll* in Fall 2001 (i.e. apply around Dec 2000)

** WARNING: Program deletes existing files from "/Raw Stata Files" first!!!

set more off

**** Convert Raw Data to Stata ****

cd "Raw Stata Files"
!rm *.dta

do "../Raw Do Files/ef1986_c.do"
clear
do "../Raw Do Files/ef1988_c.do"
clear
do "../Raw Do Files/ef1992_c.do"
clear
do "../Raw Do Files/ef1994_c.do"
clear
do "../Raw Do Files/ef2000c.do"
clear
do "../Raw Do Files/ef2001c.do"
clear
do "../Raw Do Files/ef2002c.do"
clear
do "../Raw Do Files/ef2003c.do"
clear
do "../Raw Do Files/ef2004c.do"
clear
do "../Raw Do Files/ef2005c.do"
clear
do "../Raw Do Files/ef2006c.do"
clear
do "../Raw Do Files/ef2007c.do"
clear
do "../Raw Do Files/ef2008c.do"
clear
do "../Raw Do Files/ef96_c.do"
clear
do "../Raw Do Files/ef98_c.do"
clear
do "../Raw Do Files/f0001_f1.do"
clear
do "../Raw Do Files/f0001_f2.do"
clear
do "../Raw Do Files/f0102_f1.do"
clear
do "../Raw Do Files/f0102_f2.do"
clear
do "../Raw Do Files/f0203_f1a.do"
clear
do "../Raw Do Files/f0203_f2.do"
clear
do "../Raw Do Files/f0304_f1a.do"
clear
do "../Raw Do Files/f0304_f2.do"
clear
do "../Raw Do Files/f0405_f1a.do"
clear
do "../Raw Do Files/f0405_f2.do"
clear
do "../Raw Do Files/f0506_f1a.do"
clear
do "../Raw Do Files/f0506_f2.do"
clear
do "../Raw Do Files/f0607_f1a.do"
clear
do "../Raw Do Files/f0607_f2.do"
clear
do "../Raw Do Files/f0708_f1a.do"
clear
do "../Raw Do Files/f0708_f2.do"
clear
do "../Raw Do Files/f9900_f1.do"
clear
do "../Raw Do Files/f9900f2.do"
clear
do "../Raw Do Files/fa2000hd.do"
clear
do "../Raw Do Files/fa2001hd.do"
clear
do "../Raw Do Files/hd2002.do"
clear
do "../Raw Do Files/hd2003.do"
clear
do "../Raw Do Files/hd2004.do"
clear
do "../Raw Do Files/hd2005.do"
clear
do "../Raw Do Files/hd2006.do"
clear
do "../Raw Do Files/hd2007.do"
clear
do "../Raw Do Files/hd2008.do"
clear
do "../Raw Do Files/ic1986_a.do"
clear
do "../Raw Do Files/ic1987_a.do"
clear
do "../Raw Do Files/ic1987_b.do"
clear
do "../Raw Do Files/ic1988_a.do"
clear
do "../Raw Do Files/ic1988_b.do"
clear
do "../Raw Do Files/ic1989_a.do"
clear
do "../Raw Do Files/ic1989_b.do"
clear
do "../Raw Do Files/ic1991_d.do"
clear
do "../Raw Do Files/ic1991_hdr.do"
clear
do "../Raw Do Files/ic1992_a.do"
clear
do "../Raw Do Files/ic1992_b.do"
clear
do "../Raw Do Files/ic1993_a.do"
clear
do "../Raw Do Files/ic1993_b.do"
clear
do "../Raw Do Files/ic1994_a.do"
clear
do "../Raw Do Files/ic1994_b.do"
clear
do "../Raw Do Files/ic2000.do"
clear
do "../Raw Do Files/ic2000_ay.do"
clear
do "../Raw Do Files/ic2001.do"
clear
do "../Raw Do Files/ic2001_ay.do"
clear
do "../Raw Do Files/ic2002.do"
clear
do "../Raw Do Files/ic2002_ay.do"
clear
do "../Raw Do Files/ic2003.do"
clear
do "../Raw Do Files/ic2003_ay.do"
clear
do "../Raw Do Files/ic2004.do"
clear
do "../Raw Do Files/ic2004_ay.do"
clear
do "../Raw Do Files/ic2005.do"
clear
do "../Raw Do Files/ic2005_ay.do"
clear
do "../Raw Do Files/ic2006.do"
clear
do "../Raw Do Files/ic2006_ay.do"
clear
do "../Raw Do Files/ic2007.do"
clear
do "../Raw Do Files/ic2007_ay.do"
clear
do "../Raw Do Files/ic2008.do"
clear
do "../Raw Do Files/ic2008_ay.do"
clear
do "../Raw Do Files/ic90d.do"
clear
do "../Raw Do Files/ic9596_a.do"
clear
do "../Raw Do Files/ic9596_b.do"
clear
do "../Raw Do Files/ic9697_a.do"
clear
do "../Raw Do Files/ic9697_c.do"
clear
do "../Raw Do Files/ic9798_c.do"
clear
do "../Raw Do Files/ic9798_d.do"
clear
do "../Raw Do Files/ic9798_hdr.do"
clear
do "../Raw Do Files/ic98_c.do"
clear
do "../Raw Do Files/ic98_d.do"
clear
do "../Raw Do Files/ic98hdac.do"
clear
cd ..

**** Keep Relevant Variables in Stata ****

do "Do File Construction/raw_dta_file_list.do"
cd "Raw Stata Files"
!rm *.dta
cd ..

**** Merge Trimmed Stata Files ****

cd "Merge Stata Files"

use applicants_2001.dta
forvalues yearcount = 2002(1)2008 {
	append using applicants_`yearcount'
}
sort unitid year
save applicants.dta, replace

use background_1986.dta
foreach yearcount of numlist 1987(1)1989 1991(1)1998 2000(1)2008 {
	append using background_`yearcount'
}
sort unitid year
save background.dta, replace

use residence_1986.dta
foreach yearcount of numlist 1988 1992(2)2000 2001(1)2008 {
	append using residence_`yearcount'
}
sort unitid year
save residence.dta, replace

use applicants.dta
sort unitid year
merge unitid year using background.dta
tab _merge
drop _merge
sort unitid year
merge unitid year using residence.dta
tab _merge
drop _merge

sort unitid year
gen byte fouryear = iclevel==1
by unitid: egen maxfouryear = max(fouryear)
keep if maxfouryear==1
keep if control==1 | control==2
!rm *.dta

cd ..
save "ipeds data.dta", replace
