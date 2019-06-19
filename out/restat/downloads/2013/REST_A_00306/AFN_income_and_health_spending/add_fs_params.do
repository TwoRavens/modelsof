
capture program drop add_fstat
program add_fstat, eclass
  ereturn scalar fstat = `1'
end

capture program drop add_parm
program add_parm, eclass
  ereturn scalar `1' = `2'
end

 **
 ** do add_fs_params `instrument'
 **

 local instrument = "`1'"
 if ("`instrument'" == "") {
  local instrument = "sizeXlogoil"
 }
 add_fstat r(F)

 capture drop myn
 bys stateEconArea: gen myn = _n
 if ("`instrument'" == "minXdummyXlogoil") { 
   capture drop minXsize_temp
   gen minXsize_temp = miningShare1970_orig * (tot_size_orig > 0)
   summ minXsize_temp if myn == 1, det
 }
 else {
  if ("`instrument'" == "size95Xlogoil") {
   summ size95 if myn == 1, det
  }
  else {
   summ tot_size if myn == 1, det
  }
 } 
 if ("`instrument'" == "minXlogoil") {
   summ miningShare1970_orig if myn == 1, det
 }
 if ("`instrument'" == "oil_dummyXlogoil") {
  summ oil_dummy if myn == 1, det
 }

 add_parm "p5" r(p5)
 add_parm "p95" r(p95)
 local diff_95_5 = (r(p95) - r(p5))

 add_parm "p10" r(p10)
 add_parm "p90" r(p90)
 local diff_90_10 = (r(p90) - r(p10))

 local diff_1sd_size = r(sd)
 local diff_2sd_size = 2 * r(sd)

 add_parm "onesd_size" `diff_1sd_size'
 add_parm "twosd_size" `diff_2sd_size'

 if ("`instrument'" == "sizeXoil") { 
  summ oilprice_level if year >= 1970 & year <= 1990
  di "adding two_sd_oil ..."
  **local two_sd_oil = 2 * r(sd)
  **add_parm "two_sd_oil" `two_sd_oil'
  local two_sd_oil = r(max) - r(min)
  add_parm "two_sd_oil" `two_sd_oil'
 }
 else {
  summ oilprice if year >= 1970 & year <= 1990
  di "adding two_sd_oil ..."
  **local two_sd_oil = 2 * r(sd)
  **add_parm "two_sd_oil" `two_sd_oil'
  local two_sd_oil = r(max) - r(min)
  add_parm "two_sd_oil" `two_sd_oil'
 }


 di "adding effect_95_5 ..."

 local effect_95_5 = _b[`instrument'] * `diff_95_5' * `two_sd_oil'
 add_parm "effect_95_5" `effect_95_5'

 local effect_90_10 = _b[`instrument'] * `diff_90_10' * `two_sd_oil'
 add_parm "effect_90_10" `effect_90_10'

 local effect_1sd_size = _b[`instrument'] * `diff_1sd_size' * `two_sd_oil'
 add_parm "effect_1sd_size" `effect_1sd_size'

 local effect_2sd_size = _b[`instrument'] * `diff_2sd_size' * `two_sd_oil'
 add_parm "effect_2sd_size" `effect_2sd_size'

 di `effect_1sd_size'
 di `effect_2sd_size'

 di "storing first stage ..."
