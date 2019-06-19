set more 1


capture program drop fixnumeric
program define fixnumeric
syntax, var(varname string) gen(string) replace(string)  

quietly {
local typevar : type `var'
gen `typevar' `gen' = ""
count
local N = r(N)
forvalues i = 1/`N' {
local ii = `var'[`i']
local lii = strlen("`ii'") 
  forvalues j = 1/`lii'{
  local js = substr("`ii'",`j',1)
    local c0 = "`js'" == "0"
    local c1 = "`js'" == "1"
    local c2 = "`js'" == "2"
    local c3 = "`js'" == "3"
    local c4 = "`js'" == "4"
    local c5 = "`js'" == "5"
    local c6 = "`js'" == "6"
    local c7 = "`js'" == "7"
    local c8 = "`js'" == "8"
    local c9 = "`js'" == "9"

    
  local sumc = `c0'+`c1'+`c2'+`c3'+`c4'+`c5'+`c6'+`c7'+`c8'+`c9'
  if `sumc' != 1 {
    local ii2 = subinstr("`ii'","`js'","`replace'",1)
    local ii = "`ii2'"
                 } 
  if `sumc' == 1 {
    local ii2 = "`ii'"
                 } 
}
replace `gen' = "`ii2'" if _n == `i'
}
}
end


fixnumeric, var(frdm) gen(firm_idn) replace(0)

destring firm_idn, generate(firm_id_tn)

list firm_id* in 1/1000

