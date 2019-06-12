/* This code imports data from the Dataquick files, using the
   specified layout.

   The data is in fixed text format. It can be read by Stata "infix" command, e.g.
     infix str x 1-4 int y 2-8 using file.txt
   reads a 2-column file, with character variable x in columns 1-4
   and integer variable y in columns 2-8.

   Here the layout is provided in the vendor-supplied Excel file, and this program
   creates the Stata infix specification from that.

   We also add Stata variable labels.
*/

/* ===== 1. Read the layout file */

import excel using $dqfmtfile, cellrange($cellrange) firstrow case(lower) clear
    
/* Clean up dictionary data */
keep field* ansi sql prec scale length empty def    
qui ds, has(type string)
local strvars = r(varlist)
foreach v in `strvars' {
    replace `v' = ltrim(rtrim(`v'))
}
compress
keep if fieldnumber ~= .
replace fieldname = lower(fieldname)

/* See what variable types are there */
tab sql

/* This assumes that datestring vars (if any) are all in format YYYYMMDD */
/*   This is true for the assessor file */   

replace sql = "str" if sql == "varchar"
replace sql = "byte" if sql == "tinyint" || sql == "bit"
replace sql = "long" if sql == "int"
replace sql = "int" if sql == "smallint"
replace sql = "double" if sql == "numeric"

/* Remove double quotes in the definition, if any */
replace definition = subinstr(definition, char(34), "",.)

gen start = 1
replace start = start[_n-1]+length[_n-1] if _n>1

gen end = start + length -1

/* ===== 2. Create a format string from the layout file */
qui d
local NVARS = r(N)
local fstring = ""
local allvars = ""
local datestring = ""
forvalues i = 1(1)`NVARS' {
    local field = fieldname[`i']
    local start = start[`i']
    local end = end[`i']
    if(sql[`i']=="datetime") {
        local datestring = "`datestring'" + " `field'"
        local type = "str"
    }
    else {
        local type = sql[`i']
    }
    local fstring = "`fstring'" + " `type' `field' `start'-`end'"
    local varname`i' = fieldname[`i']
    local varlabel`i' = definition[`i']
    local allvars = "`allvars'" + " `field'"
}


/* ===== 3. Read the actual data set using the format string */
infix `fstring' using $dqfname $dqrows, clear

/* === Convert date variables into Stata date format */
foreach v in `datestring' {
    gen `v'_tmp = mdy(real(substr(`v',5,2)),real(substr(`v',7,2)),real(substr(`v',1,4)))
    format `v'_tmp %td
    drop `v'
    rename `v'_tmp `v'
}
order `allvars'


/* Add variable labels */
forvalues i = 1(1)`NVARS' {
    label variable `varname`i'' "`varlabel`i''"
}

