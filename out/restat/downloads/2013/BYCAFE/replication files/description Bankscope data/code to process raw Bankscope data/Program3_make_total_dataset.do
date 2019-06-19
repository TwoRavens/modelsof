** Make overall dataset

clear
set memory 200M

use DatabestandAD3.dta, clear
local vars "AE AM AR AT AU AZ BD BE BH BM BO BR BS BW CA CH CI CL CN CO CR CY CZ DE DK DO DZ EC EE ES FI FR GB GH GR HK HR HU ID IE IL IN IS IT JO JP KE KR KW KY KZ LB LI LK LT LU LV MA MC MD MK MO MT MU MX MY MZ NG NL NO NP NZ OM PA PE PH PK PL PT PY RO RU SA SE SG SI SK SN SV TH TR TT TW UA US UY VE VN ZA ZM"
foreach var of local vars {
       append using Databestand`var'3.dta
	}

save Allelanden3.dta, replace

clear
use Allelanden3.dta