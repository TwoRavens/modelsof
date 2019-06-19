**Step 1: Merge household files (BHPS Waves 1-14)**

use "f:\BHPS\stata6\ahhresp.dta", clear
renpfix a
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 1
save "f:\BHPS\daughters\hhouse_wave1.dta", replace

use "f:\BHPS\stata6\bhhresp.dta", clear
renpfix b
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 2
save "f:\BHPS\daughters\hhouse_wave2.dta", replace

use "f:\BHPS\stata6\chhresp.dta", clear
renpfix c
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 3
save "f:\BHPS\daughters\hhouse_wave3.dta", replace

use "f:\BHPS\stata6\dhhresp.dta", clear
renpfix d
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 4
save "f:\BHPS\daughters\hhouse_wave4.dta", replace

use "f:\BHPS\stata6\ehhresp.dta", clear
renpfix e
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 5
save "f:\BHPS\daughters\hhouse_wave5.dta", replace

use "f:\BHPS\stata6\fhhresp.dta", clear
renpfix f
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 6
save "f:\BHPS\daughters\hhouse_wave6.dta", replace

use "f:\BHPS\stata6\ghhresp.dta", clear
renpfix g
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 7
save "f:\BHPS\daughters\hhouse_wave7.dta", replace

use "f:\BHPS\stata6\hhhresp.dta", clear
renpfix h
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 8
save "f:\BHPS\daughters\hhouse_wave8.dta", replace

use "f:\BHPS\stata6\ihhresp.dta", clear
renpfix i
gen round = 9
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
save "f:\BHPS\daughters\hhouse_wave9.dta", replace

use "f:\BHPS\stata6\jhhresp.dta", clear
renpfix j
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 10
save "f:\BHPS\daughters\hhouse_wave10.dta", replace

use "f:\BHPS\stata6\khhresp.dta", clear
renpfix k
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 11
save "f:\BHPS\daughters\hhouse_wave11.dta", replace

use "f:\BHPS\stata6\lhhresp.dta", clear
renpfix l
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 12
save "f:\BHPS\daughters\hhouse_wave12.dta", replace

use "f:\BHPS\stata6\mhhresp.dta", clear
renpfix m
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 13
save "f:\BHPS\daughters\hhouse_wave13.dta", replace

use "f:\BHPS\stata6\nhhresp.dta", clear
renpfix n
keep hid mghave hhsize region  nch* nkids nwed npens fihhyr
gen round = 14
save "f:\BHPS\daughters\hhouse_wave14.dta", replace


use "f:\BHPS\daughters\hhouse_wave1.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave1.dta", replace
use "f:\BHPS\daughters\hhouse_wave2.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave1.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave3.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave3.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave3.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave4.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave4.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave4.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave5.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave5.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave5.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave6.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave6.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave6.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave7.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave7.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave7.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave8.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave8.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave8.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave9.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave9.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave9.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave10.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave10.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave10.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave11.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave11.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave11.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave12.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave12.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave12.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave13.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave13.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave13.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace
use "f:\BHPS\daughters\hhouse_wave14.dta", clear
sort hid
save "f:\BHPS\daughters\hhouse_wave14.dta", replace
use "f:\BHPS\daughters\hhouse_allwaves.dta", clear
sort hid
merge hid using "f:\BHPS\daughters\hhouse_wave14.dta"
drop _m
save "f:\BHPS\daughters\hhouse_allwaves.dta", replace

**Step 2: Merge individual files**

use "f:\BHPS\stata6\aindresp.dta", clear
renpfix a
keep hid pid doi* sex sppid  aoprlg* mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 1
save "f:\BHPS\daughters\indresp_wave1.dta", replace

use "f:\BHPS\stata6\bindresp.dta", clear
renpfix b
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 2
save "f:\BHPS\daughters\indresp_wave2.dta", replace

use "f:\BHPS\stata6\cindresp.dta", clear
renpfix c
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 3
save "f:\BHPS\daughters\indresp_wave3.dta", replace

use "f:\BHPS\stata6\dindresp.dta", clear
renpfix d
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 4
save "f:\BHPS\daughters\indresp_wave4.dta", replace

use "f:\BHPS\stata6\eindresp.dta", clear
renpfix e
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 5
save "f:\BHPS\daughters\indresp_wave5.dta", replace

use "f:\BHPS\stata6\findresp.dta", clear
renpfix f
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race  ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 6
save "f:\BHPS\daughters\indresp_wave6.dta", replace

use "f:\BHPS\stata6\gindresp.dta", clear
renpfix g
keep hid pid doi* sex sppid aoprlg* mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 7
save "f:\BHPS\daughters\indresp_wave7.dta", replace

use "f:\BHPS\stata6\hindresp.dta", clear
renpfix h
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race  ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 8
save "f:\BHPS\daughters\indresp_wave8.dta", replace

use "f:\BHPS\stata6\iindresp.dta", clear
renpfix i
ren  hlsf1 hlstat
keep hid pid doi* sex sppid  mlstat aoprlg* hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 9
save "f:\BHPS\daughters\indresp_wave9.dta", replace

use "f:\BHPS\stata6\jindresp.dta", clear
renpfix j
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race  ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 10
save "f:\BHPS\daughters\indresp_wave10.dta", replace

use "f:\BHPS\stata6\kindresp.dta", clear
renpfix k
keep hid pid doi* sex sppid  mlstat aoprlg* hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 11
save "f:\BHPS\daughters\indresp_wave11.dta", replace

use "f:\BHPS\stata6\lindresp.dta", clear
renpfix l
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race  ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 12
save "f:\BHPS\daughters\indresp_wave12.dta", replace

use "f:\BHPS\stata6\mindresp.dta", clear
renpfix m
keep hid pid doi* sex sppid  mlstat hgr2r hlstat pno vote* op* race org* ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 13
save "f:\BHPS\daughters\indresp_wave13.dta", replace


use "f:\BHPS\stata6\nindresp.dta", clear
renpfix n
keep hid pid doi* sex sppid  mlstat aoprlg* hgr2r hlstat pno vote* op* race  ghq* region mastat age qfachi nchild fiyr jbstat
gen round = 14
save "f:\BHPS\daughters\indresp_wave14.dta", replace

use "f:\BHPS\daughters\indresp_wave1.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave1.dta", replace
use "f:\BHPS\daughters\indresp_wave2.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave1.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave3.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave3.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave3.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave4.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave4.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave4.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave5.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave5.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave5.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave6.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave6.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave6.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave7.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave7.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave7.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave8.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave8.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave8.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave9.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave9.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave9.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave10.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave10.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave10.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave11.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave11.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave11.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave12.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave12.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave12.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave13.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave13.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave13.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace
use "f:\BHPS\daughters\indresp_wave14.dta", clear
sort pid round
save "f:\BHPS\daughters\indresp_wave14.dta", replace
use "f:\BHPS\daughters\indresp_allwaves.dta", clear
sort pid round
merge pid round using "f:\BHPS\daughters\indresp_wave14.dta"
drop _m
save "f:\BHPS\daughters\indresp_allwaves.dta", replace

