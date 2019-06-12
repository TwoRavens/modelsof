use "anes_timeseries_cdf_stata12.dta", clear

gen lcself=VCF0803 if VCF0803>0 & VCF0803<8

gen lcdem=VCF0503 if VCF0503>0 & VCF0503<8
gen lcrep=VCF0504 if VCF0504>0 & VCF0504<8

gen lcselfcen=lcself-4
gen lcdemcen=lcdem-4
gen lcrepcen=lcrep-4

gen lcproxdem=abs(lcdemcen-lcselfcen)
gen lcproxrep=abs(lcrepcen-lcselfcen)

gen lcdemdir=lcselfcen*lcdemcen
gen lcrepdir=lcselfcen*lcrepcen

gen lcsamedem=0 
replace lcsamedem=1 if lcdemdir>0
replace lcsamedem=. if lcdemdir==.

gen lcoppdem=0
replace lcoppdem=1 if lcdemdir<0
replace lcoppdem=. if lcdemdir==.

gen lcsamerep=0
replace lcsamerep=1 if lcrepdir>0
replace lcsamerep=. if lcrepdir==.

gen lcopprep=0
replace lcopprep=1 if lcrepdir<0
replace lcopprep=. if lcrepdir==.

gen pid=VCF0301 if VCF0301>0 & VCF0301<8

gen repvote=0
replace repvote=1 if VCF0704==2
replace repvote=. if VCF0704==. |  VCF0704==3

gen year=VCF0004

gen lcsameprox = lcproxrep * lcsamerep
gen lcoppprox = lcproxrep * lcopprep

*** Models:
reg repvote lcrepdir lcproxrep lcsamerep lcopprep i.year,robust
estimates store mod1a
reg repvote lcproxrep lcsamerep lcopprep i.year,robust
estimates store mod2a
reg repvote lcsamerep lcopprep i.lcproxrep i.year if lcproxrep < 4 & lcproxrep > 0,robust
estimates store mod3a
reg repvote lcproxrep lcsamerep lcopprep lcsameprox lcoppprox  i.year,robust
estimates store mod4a
*
reg repvote lcrepdir lcproxrep lcsamerep lcopprep i.year i.pid,robust
estimates store mod1b
reg repvote lcproxrep lcsamerep lcopprep i.year i.pid,robust
estimates store mod2b
reg repvote lcsamerep lcopprep i.lcproxrep i.year i.pid if lcproxrep < 4 & lcproxrep > 0,robust
estimates store mod3b
reg repvote lcproxrep lcsamerep lcopprep lcsameprox lcoppprox i.year i.pid,robust
estimates store mod4b

*** Summary:
esttab mod1a mod2a mod3a mod4a mod1b mod2b mod3b mod4b, compress nogaps ///
	indicate("Year-Fixed Eff." = *year) drop(*pid 1b.lcproxrep 2.lcproxrep 3.lcproxrep) ///
	rename (lcrepdir "Directional~Term" lcproxrep "Proximity~Term" lcsamerep "Same~Side" lcopprep "Opposite~Side" ) ///
	replace label  title("Replication of Table 1 using the ANES: 1972-2012") se b(3) scalars(r2_a N) sfmt(%9.3f %9.0f) 


