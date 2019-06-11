**** Econ Voting project (Tilley, Hobolt, Neundorf)
** Mergin BHPS data

clear all
set more off
*cd "/Users/aneundorf/Dropbox/Data/BHPS"
cd "/Users/ldzan/Dropbox/Data/BHPS"

* ========================================
* = extract variables from raw bhps data =
* ========================================


local waves = "a b c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp", clear
	keep `i'vote1 `i'vote2 `i'vote4 `i'vote5 `i'sex `i'qfachi `i'casmin `i'isced `i'jbgold `i'tenure `i'region ///
	`i'race  `i'qfedhi `i'fimn `i'fiyr `i'fiyrl `i'fiyeari `i'jbonus `i'jbrise `i'age `i'hid `i'pno  `i'jbsemp ///
	`i'jbmngr `i'jbisco `i'jssize  `i'jbhrs `i'jbot `i'jshrs `i'jbsoc `i'jbsect ///
	`i'paygu `i'paynu `i'paygui `i'paynui `i'mastat  ///
	`i'fimnb `i'fimnbi `i'fimnp `i'fimnpi   ///
	`i'fiyrb `i'fiyrbi `i'fiyrp `i'fiyrpi   `i'fiyrt `i'fiyrti  ///
	`i'hlsv `i'jbsat4 `i'plbornc  `i'jbft `i'jbstat  `i'jbub `i'jbuby `i'fisit `i'fisitc `i'fisitx  ///
	`i'jbstatl `i'jbstat `i'spjbyr `i'cjsbgy4 `i'jlend4 `i'njbnew `i'njbwks `i'sppid `i'jboff `i'jboffy pid ///
	
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _a
append using _b _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main.dta", replace

* ========================================
* = extract variables vote3 =
* ========================================


local waves = "a c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'vote3  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _a
append using   _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main_vote3.dta", replace


* ========================================
* = extract variables Job History =
* ========================================


local waves = "a b c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'jobhist", clear
	keep `i'jhstpy  pid
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _a
append using _b _c _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

tab jhstpy, 
tab jhstpy, nolabel 
recode jhstpy (-9/-1=.)
drop if jhstpy==. 
 
*drop jhstpy_new
bys pid waven: egen jhstpy_new = mode(jhstpy)

drop if jhstpy_new==.
drop count
bys pid waven: egen count = count(waven)
tab count

sort count  pid waven
// IMPORTANT! AT THIS POINT, I CODED ALL DOUBLE WAVES AS 1 IN EXCELL 
drop if count_new!=1

corr jhstpy jhstpy_new
drop jhstpy

lab def reasolbl 1"Promoted"	2"Left for better job"	3"Made redundant"	4"Dismissed or sacked"	///
5 "Temporary job ended"	6"Took retirement"	7"Stopped health reas"	8"Left to have baby"	///
9" Children/home care"	10"Care of other person" 11	"Moved away" 12 "Started college or university" ///
13"Other reason"

lab val jhstpy_new reasolbl
lab var jhstpy_new "Reason for stopping previous job"

recode jhstpy_new (11=13) if waven>5
rename jhstpy_new jhstpy
tab jhstpy

drop count count_new 
sort  pid wave
save "temp/__main_Jobhist.dta", replace

* ========================================
* = extract variables Fin sit change =
* ========================================


local waves = "c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'fisitc `i'fisity pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'", replace
}
* ip -- pid
use "_p"
ren id pid
save "_p", replace

use _c
append using _d _e _f _g _h _i _j _k _l _m _n _o _p _q _r
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main_fisit.dta", replace

* ========================================
* = extract vote variables =
* ========================================


local waves = " b e g h i j k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'vote1 `i'vote7 `i'vote8  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "temp/_`i'vot", replace
}
* ip -- pid
use temp/_pvot
ren id pid
save "temp/_pvot", replace

use temp/_bvot
append using temp/_evot temp/_gvot temp/_hvot temp/_ivot temp/_jvot temp/_kvot temp/_lvot temp/_mvot temp/_nvot ///
 temp/_ovot temp/_pvot temp/_qvot temp/_rvot
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__mainvote", replace



* ========================================
* = extract political interest  =
* ========================================

local waves = "a b c d e f  k l m n o p q r"

foreach i of local waves {
	use "Data_BHPS/`i'indresp"
	keep `i'vote6  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save "_`i'pol", replace
}
* ip -- pid
use _ppol
ren id pid
save "_ppol", replace

use _apol
append using _bpol _cpol _dpol _epol _fpol _kpol _lpol _mpol _npol _opol _ppol _qpol _rpol
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save temp/__main_polint, replace

* ========================================
* = extract nat. economic evaluation variables  =
* ========================================


local waves = "b d f "

foreach i of local waves {
	use "Data_BHPS/`i'indresp", clear
	keep `i'opiss1 `i'opiss3  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i'econ, replace
}


use _becon
append using  _decon _fecon 
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__mainecon", replace


* ========================================
* = extract pol. ideology variables  =
* ========================================


local waves = "a c e g j n q"

foreach i of local waves {
	use "Data/`i'indresp"
	keep `i'opsoca `i'opsocb `i'opsocc `i'opsocd `i'opsoce `i'opsocf  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i'ido, replace
}


use _aido
append using  _cido _eido _gido _jido _nido _qido 
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__mainido", replace

* ========================================
* = extract political activity  =
* ========================================

*cd "/Users/dstegmue/Sync/Research/Papers/PIDBHPS/Data"

local waves = "a b c d e  g  i  k  m  o  q "

foreach i of local waves {
	use "Data/`i'indresp"
	keep `i'orgaa `i'orgma `i'orgmb `i'orgab  pid 
	gen wave = "`i'"
	sort pid
	renpfix `i'
	save _`i'act, replace
}


use _aact
append using _bact _cact _dact _eact _gact _iact _kact _mact _oact _qact 
sort pid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__mainact", replace


* ========================================
* = extract Consituency code   =
* ========================================

local waves = "a b c d e f g h i j k l m n o p q r"

foreach i of local waves {
	use "Const_data/stata11/`i'pcon_protect"
	keep `i'hid `i'pcon
	gen wave = "`i'"
	sort `i'hid
	renpfix `i'
	save _`i'const, replace
}

use _aconst
append using _bconst _cconst _dconst _econst _fconst _gconst _hconst _iconst _jconst _kconst _lconst _mconst ///
_nconst _oconst _pconst _qconst _rconst 
sort hid wave

*gen numeric wave indicator
egen waven = group(wave)

save "temp/__main_const", replace


* ============================
* = merge in additional info =
* ============================

use "Data_BHPS/xwlsten"
sort pid
save __tmp2, replace

use "temp/__main", clear
*merge m:1 pid using __tmp1, gen(_merge1)
merge m:1 pid using __tmp2, gen(_merge2)
sort pid wave

merge pid wave using "temp/__main_polint"
sort pid wave
drop _merge

merge pid wave using "temp/__mainvote"
sort pid wave
drop _merge

merge pid wave using "temp/__main_vote3"
sort pid wave
drop _merge

merge pid wave  using "temp/__main_Jobhist"
sort pid wave
drop _merge

merge pid wave  using "temp/__main_fisit"
sort pid wave
drop _merge

merge pid wave  using "temp/__mainecon"
sort pid wave
drop _merge

merge pid wave  using "temp/__mainact"
sort pid wave
drop _merge

merge pid wave  using "temp/__mainido"
sort pid wave
drop _merge

drop _merge2

sort pid wave
browse pid waven
save BHPS_main, replace


* ===========================
* = ----- CHECK ------ =
* ===========================
rename waven time
sort hid pid time

browse hid pid time vote8

***** SAFE
compress
saveold "/Users/aneundorf/Dropbox/Project_EconVote_BHPS/Analysis/BHPS_working", replace

*log close

