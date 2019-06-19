* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

foreach regime in 0 1 {
foreach digit in 1 2 {
capture file close myfile
file open myfile using "$table/bunching_regime`regime'_digit`digit'.tex", write replace
foreach kei in 0 1 {

global regime = `regime'
global kei = `kei'

* Define global variables 
run Do/do_globalvariables.do 

if `kei'==0 file write myfile "\\ \multicolumn{8}{c}{Panel A: Regular passenger cars}   \\ \\ " _n
if `kei'==1 file write myfile "\\ \multicolumn{8}{c}{Panel B: Kei cars (smaller passenger cars)}   \\ \\ " _n

foreach notch in $notchlist {
foreach se in 0 1 {
if `se'==0 file write myfile "`notch' kg & "  %4.1f (${e`se'_notch`notch'}) " "        
if `se'==1 file write myfile "  & "  %4.1f (${e`se'_notch`notch'}) " "        
foreach uniform in 0 1 {

if `se'==0 insheet using TableText/bunching_uniform`uniform'_regime`regime'_kei`kei'.txt,clear
if `se'==1 use TableText/se_bunching_uniform`uniform'_regime`regime'_kei`kei',clear
keep if notch==`notch'
foreach x in bunch_num bunch dw {
if `se'==0 file write myfile  " & "  %4.`digit'f (`x'[1]) " "
if `se'==1 & `uniform'==1 & "`x'"=="dw" file write myfile  " & " "---"
if `se'==1 & `uniform'==1 & "`x'"~="dw" file write myfile  " & " "("  %3.`digit'f (abs(`x'[1])) ") "
if `se'==1 & `uniform'==0 file write myfile  " & " "("  %3.`digit'f (abs(`x'[1])) ") "
}
}
if `se'==0 file write myfile "\\ " _n
if `se'==1 file write myfile "\\ \addlinespace" _n
}
}
}
file close myfile 
}
}

*** END
