*Appendix I
use "`data'", replace

cd "`base'"


local dvars1 "burglary larceny mv_theft stolen_prop_buy_rec_poss vandalism"
local dvars2 "cocaine_opio_sale_manuf mj_sale_manuf dang_non_narc_sale_manuf cocaine_opio_posses mj_posses dang_non_narc_posses"

local status "replace"
forvalues i = 2(1)4 {
   foreach dvar of local dvars`i' {
      reg `dvar'_r post linear square linear_post square_post birthday_19  birthday_19_1 birthday_20  birthday_20_1 birthday_21  birthday_21_1 birthday_22 birthday_22_1 birthday_23 birthday_23_1 if days_to_21 >= -2*365 & days_to_21 <= 2*365 -1, robust 
      outreg2 using Appendix_I.xls, bdec(3) se paren noaster ctitle(`dvar' band = 1) `status'
      local status "append"
   }
}
