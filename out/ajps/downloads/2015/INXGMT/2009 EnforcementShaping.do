*Set working directory-needs to be changed
cd "DIRECTORY"

import delimited "SDWIS_enfs.txt", clear

keep if enffiscyear==2009

rename enfactiontype EnfActionType

gen formal=0

replace formal=1 if EnfActionType=="EF-"| EnfActionType=="EF/"| EnfActionType=="EF/"| EnfActionType=="EF<"| EnfActionType=="EFG"| EnfActionType=="EFH"| EnfActionType=="EFJ" | EnfActionType=="EFK" | EnfActionType=="EFL"| EnfActionType=="EFQ" | EnfActionType=="EFR"


replace formal=1 if EnfActionType=="SF%"| EnfActionType=="SF3"| EnfActionType=="SF4"| EnfActionType=="SFG"| EnfActionType=="SFH"| EnfActionType=="SFJ"| EnfActionType=="SFK"| EnfActionType=="SFL"| EnfActionType=="SFM"| EnfActionType=="SFN"| EnfActionType=="SFO"| EnfActionType=="SFQ"| EnfActionType=="SFR"| EnfActionType=="SFS"| EnfActionType=="SFT"| EnfActionType=="SFU"| EnfActionType=="SFV"| EnfActionType=="SFW"

export delimited using "enforcement2009clean.csv", replace
