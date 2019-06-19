* This program installs user-generated Stata programs needed to run estimation commands
* for Flores and Mitnik (2013)

* Install center
ssc install center, replace
* Install estout
ssc install estout, replace
* Install kdens
ssc install kdens, replace
* Install locpoly
net install st0053_3.pkg, from(http://www.stata-journal.com/software/sj6-4/) replace
* Install mat2txt
ssc install mat2txt, replace
* Install moremata
ssc install moremata, replace
* Install svmat2
net install dm79.pkg, from(http://www.stata.com/stb/stb56/) replace
* Install svmatf
ssc install svmatf, replace
