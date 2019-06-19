*Tables 1 and 2
use "`data'", replace

cd "`base'"

*Table 1
local dvars1 "all violent property ill_drugs alcohol other"
local status "replace"
forvalues i = 1(1)4 {
   foreach dvar of local dvars1 {
      reg `dvar'_r post linear square linear_post square_post birthday_19  birthday_19_1 birthday_20  birthday_20_1 birthday_21  birthday_21_1 birthday_22 birthday_22_1 birthday_23 birthday_23_1 if days_to_21 >= -2*365 & days_to_21 <= 2*365 -1, robust 
      outreg2 using Tables_1.xls, bdec(3) se paren noaster ctitle(`dvar' band = 1) `status'
      local status "append"
   }
}

*Combine a couple of categories
generate combined_oth_r =  disorderly_cond_r + vagrancy_r
generate drunk_risk_r = drunk_at_risk_r + drunkeness_pc_r


*Table 2 Panels 1-3
local dvars2 "dui  drunk_risk liquor_laws combined_oth "
local dvars3 "murder manslaughter rape robbery aggravated_assault ot_assault"
local dvars4 "traffic_violations county_ordinance weapons   hit_run_reckl_driv"

local status "replace"
forvalues i = 2(1)4 {
   foreach dvar of local dvars`i' {
      reg `dvar'_r post linear square linear_post square_post birthday_19  birthday_19_1 birthday_20  birthday_20_1 birthday_21  birthday_21_1 birthday_22 birthday_22_1 birthday_23 birthday_23_1 if days_to_21 >= -2*365 & days_to_21 <= 2*365 -1, robust 
      outreg2 using Tables_2.xls, bdec(3) se paren noaster ctitle(`dvar') `status'
      local status "append"
   }
}
