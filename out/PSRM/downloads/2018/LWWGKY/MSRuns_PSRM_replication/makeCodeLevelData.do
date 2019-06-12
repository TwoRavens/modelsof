*! makeCodeLevelData.do
*! Constructs codelevel
*!    codelevel_work1 : one observation per coding decision

// -------------------------------------------------
//  Big reshape
//  --> one observation per single coding decision
// -------------------------------------------------
clear
use dataSets/hitlevel_work1.dta

local codevl $codevl			// get list of code variables from external do file for consistency

// capture original variable names 
label define vnlabel 1  "ecAppeal", add  
label define vnlabel 4  "etPositive", add  
label define vnlabel 5  "etNegative", add  
label define vnlabel 6  "flag", add  
label define vnlabel 7  "emEnthusiasm", add  
label define vnlabel 8  "emFear", add  
label define vnlabel 9  "emAnger", add  
label define vnlabel 10 "emDisgust", add  
label define vnlabel 15 "tFcComp", add  
label define vnlabel 16 "tFcLeader", add  
label define vnlabel 17 "tFcInteg", add  
label define vnlabel 18 "tFcEmpathy", add  
label define vnlabel 19 "tOcComp", add  
label define vnlabel 20 "tOcLeader", add  
label define vnlabel 21 "tOcInteg", add  
label define vnlabel 22 "tOcEmpathy", add  
label define vnlabel 27 "ideologyFc", add  
label define vnlabel 28 "ideologyOc", add  
label define vnlabel 29 "em1Enthusiasm", add  
label define vnlabel 30 "em1Fear", add  
label define vnlabel 31 "em1Anger", add  
label define vnlabel 32 "em1Disgust", add  
label define vnlabel 33 "mention1Fc", add  
label define vnlabel 34 "mention1Oc", add  

//rename variables as Code1 Code2 ...
rename ecAppeal      Code1  
rename etPositive    Code4  
rename etNegative    Code5  
rename flag          Code6  
rename emEnthusiasm  Code7  
rename emFear        Code8  
rename emAnger       Code9  
rename emDisgust     Code10  
rename tFcComp       Code15  
rename tFcLeader     Code16  
rename tFcInteg      Code17  
rename tFcEmpathy    Code18  
rename tOcComp       Code19  
rename tOcLeader     Code20  
rename tOcInteg      Code21  
rename tOcEmpathy    Code22  
rename ideologyFc    Code27  
rename ideologyOc    Code28  
rename em1Enthusiasm Code29  
rename em1Fear       Code30  
rename em1Anger      Code31  
rename em1Disgust    Code32  
rename mention1Fc    Code33  
rename mention1Oc    Code34  

//capture original variable labels
foreach var of varlist Code* {
	local num : subinstr local var "Code" ""
	label define vllabel `num' `"`: variable label `var''"', add
}
// used later
label define vllabel 201 "Average for Economic tone", add
label define vllabel 202 "Average for emotions", add
label define vllabel 203 "Average for dichotomized emotions$^{1}$", add
label define vllabel 204 "Average for candidate appears", add
label define vllabel 205 "Average for FC traits", add
label define vllabel 206 "Average for OC traits", add
label define vllabel 207 "Average for ideology", add

// save labels for Var
label save vnlabel using auxSyntax/vnlabel.do, replace
label save vllabel using auxSyntax/vllabel.do, replace

// reshape to one obs per coding decision; new variable 'Var' indexes the original coding variable
reshape long Code , i(adName worker) j(Var)
la values Code		// unlabeled for now


*************************************************
* Calculate errors for metacoders size 1 and 5:
*************************************************
foreach i in 1 5 {
	codermse mIt`i'_, metasize(`i')  cttruth
}
gen mIt1_AbsError = abs(mIt1_error)
la var mIt1_AbsError "Absolute decision-level “error”"

recode Var                                      ///
	(6     = 1 "Flag appears")                  ///
	(33	34 = 2 "Average for candidate appears") ///
	(1     = 3 "Economic appeal")               ///
	(4 5   = 4 "Average for economic tone")     ///
	(7/10  = 5 "Average for emotions")          ///
	(15/18 = 6 "Average for FC traits")         ///
	(19/22 = 7 "Average for OC traits")         ///
	(27 28 = 8 "Average for ideology" )         ///
	(*     = .)                                 ///
	, gen(VarGrp)

// Utility vars
// local vuse 1 4/10 13 14 15/22 24 26 27 28
// (all of above except dichotomized emotions)
local vuse 1 4/10 15/22 27 28 33 34
gen vToUse = 0
foreach vv of numlist `vuse' {
	replace vToUse = 1 if Var==`vv'
}
la var vToUse "Includes variables for MSE calculation (`vuse')"

do auxSyntax/Label_timeGnoQt

egen adTag = tag(adName)
egen wVarTag = tag(workerId Var)
egen adVarTag = tag(adName Var)

compress
save dataSets/codelevel_work1, replace
