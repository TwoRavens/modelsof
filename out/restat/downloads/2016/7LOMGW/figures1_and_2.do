

******************Figures 1 and 2
global data="\\usi\dfs\utenti\F\funkp\My Documents\Projekt_Lying\Final_Files_Restat\Replication\data"

use "$data\VOX_prepared"

preserve
 

keep votenr survey_bias survey_bias_weighted

duplicates drop votenr, force

*kdensity  survey_bias, xtitle("") note("") caption("") title("") scheme(s1color) 

twoway kdensity survey_bias || kdensity survey_bias_weighted,  legend(off) xtitle("")  scheme(s1color) 

restore




 
 

