* When Can Multiple Imputation Improve Regression Estimates? *
* Vincent Arel-Bundock (vincent.arel-bundock@umontreal.ca) and Krzysztof J. Pelc (kj.pelc@mcgill.ca) *
* 2017-06-30 *

clear

* Set directory
cd  "~/Dropbox/research/multiple_imputation/replication"

* Use Lall's (2016) imputed dataset
use "P2011 WP Imp Data.dta", clear

* Model 1: Pelc's original results (imp == 0 identifies the pre-imputation data)
reg overhang1 mfn logGDPcap logGDPconst  xpolity  logimportsprod ldc agri recententrant xchangedum944 ADuserconsist95 if imp==0, cluster(reporter)
est store m1

* Set imputation data
mi import flong, m(imp) id(reporter case) imp(mfn-xchangeXAD)

* Model 2: Lall's replication
mi estimate, esampvaryok post: reg overhang1 mfn logGDPcap logGDPconst  xpolity  logimportsprod ldc agri recententrant xchangedum944 ADuserconsist95, cluster(reporter)
est store m2

* Tag theoretically irrelevant observations
gen miss_overhang1_=1 if imp==0 & overhang1==.
replace miss_overhang1_=0 if imp==0 & overhang1!=.
bysort case: egen miss_overhang1=max( miss_overhang1_ )

* Fill-in the "fully floating exchange rate" variable where missing from Reinhart & Rogoff and true value is known
/* EU */ replace xchangedum944=1 if reporter==918
/* Taiwan, China */ replace xchangedum944=0 if reporter==158
/* Angola */ replace xchangedum944=0 if reporter==24
/* Namibia */ replace xchangedum944=0 if reporter==516
/* Fiji */ replace xchangedum944=0 if reporter==242
/* Oman */ replace xchangedum944=0 if reporter==512
/* Cuba */ replace xchangedum944=0 if reporter==192
/* Macao */ replace xchangedum944=0 if reporter==446
/* Macedonia */ replace xchangedum944=0 if reporter==807
/* St-Kitts and Nevis */ replace xchangedum944=0 if reporter==659
/* Rwanda */ replace xchangedum944=0 if reporter==646
/* Djibouti */ replace xchangedum944=0 if reporter==262

* Fill-in two missing countries for AD actions: St-Kitts and Trinidad and Tobago, both non-users in 1995. 
replace  ADuserconsist95=0 if reporter==659 | reporter==780

* Model 3: Excluding irrelevant observations + filling-in true values
mi estimate, esampvaryok post: reg overhang1 mfn logGDPcap logGDPconst  xpolity  logimportsprod ldc agri recententrant xchangedum944 ADuserconsist95 if miss_overhang1==0, cluster(reporter)
est store m3

* Model 4: Excluding irrelevant observations + filling-in true values + excluding 5 island nations
mi estimate, esampvaryok post: reg overhang1 mfn logGDPcap logGDPconst  xpolity  logimportsprod ldc agri recententrant xchangedum944 ADuserconsist95 if miss_overhang1==0 & reporter!=659 & reporter!=212 & reporter!=28 & reporter!=662 & reporter!=308, cluster(reporter)
est store m4

* Print regression table
label var mfn "Applied Rate"
label var logGDPcap "Logged GDP per capita"
label var logGDPconst "Logged GDP"
label var xpolity "Regime"
label var logimportsprod "Logged Products Imports"
label var agri "Agricultural Product"
label var ldc "LDC dummy"
label var recententrant "Recent Entrant"
label var xchangedum944 "Fully Floating Currency"
label var ADuserconsist95 "Remedies User"

esttab m1 m2 m3 m4, replace cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) title(The Effect of Policy Substitutes on Tariff Flexibility: Replicated vs. Imputed Data  \label{repl}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) 
