global T="A"
global table "TableWDI1"
global title "Quality-of-Life Indicators, National Accounts and Survey Means"
global key=0

if "$T"=="A" | "$T"=="C" {

macro drop b_* se_* seo_* R2_* Cl_* N_* a_*

use NASM_base2, clear
so isoc year
merge isoc year using lifex
ta _me
drop if _me==2
drop _me
so isoc year
merge isoc year using welfare
ta _me
drop if _me==2
drop _me

global col=1
global T1_${col}="Log Lights"
global T2_${col}="per capita"
global T3_${col}=""
global col=1+${col}

gen llifex=ln(SP_DYN_LE00_IN)
global T1_${col}="Log Life"
global T2_${col}="Expectancy"
global T3_${col}="Years"
global col=1+${col}

/*
gen lmeasles=ln(SH_IMM_MEAS)
global T1_${col}="Log Frac"
global T2_${col}="Measles"
global T3_${col}="Immune"
global col=1+${col}

gen ldpt=ln(SH_IMM_IDPT)
global T1_${col}="Log Frac"
global T2_${col}="DPT"
global T3_${col}="Immune"
global col=1+${col}
*/

gen lfert=-ln(SP_DYN_TFRT_IN)
global T1_${col}="Neg. Log"
global T2_${col}="Fertility"
global T3_${col}="per 100,000"
global col=1+${col}


gen ltnfert=-ln(SP_ADO_TFRT)
global T1_${col}="Neg. Log"
global T2_${col}="Adolesc. Fertil."
global T3_${col}="per 100,000"
global col=1+${col}

gen lfooddef=-ln(SN_ITK_DFCT)
global T1_${col}="Neg. Log"
global T2_${col}="Food Deficit"
global T3_${col}="per capita"
global col=1+${col}

/*
gen ltuber=-ln(SH_TBS_INCD)
global T1_${col}="Neg. Log"
global T2_${col}="Tuberculosis"
global T3_${col}="Rate"
global col=1+${col}
*/




gen lpanemia=-ln(SH_PRG_ANEM)
global T1_${col}="Log Frac"
global T2_${col}="Pregnant"
global T3_${col}="Anemic"
global col=1+${col}

gen lsanit=ln(SH_STA_ACSN)
global T1_${col}="Log Frac"
global T2_${col}="Access"
global T3_${col}="Sanitation"
global col=1+${col}


gen lsafewater = ln(SH_H2O_SAFE_ZS)
global T1_${col}="Log Frac"
global T2_${col}="Access"
global T3_${col}="Safe Water"
global col=1+${col}


gen lprimenrr=ln(SE_PRM_ENRR)
global T1_${col}="Log Frac"
global T2_${col}="Primary"
global T3_${col}="School"
global col=1+${col}

/*
gen lsecenrr=ln(SE_SEC_ENRR)
global T1_${col}="Log Frac"
global T2_${col}="Secondary"
global T3_${col}="School"
global col=1+${col}

gen ltertenrr=ln(SE_TER_ENRR)
global T1_${col}="Log Frac"
global T2_${col}="Tertiary"
global T3_${col}="School"
global col=1+${col}

gen lterttot=lprimenrr+lsecenrr+ltertenrr

gen lprimrat=ln(SE_ENR_PRIM_FM_ZS)
global T1_${col}="Log Sex"
global T2_${col}="Ratio Elem."
global T3_${col}="School"
global col=1+${col}
*/

gen llitr=ln(SE_ADT_LITR_FE_ZS)
global T1_${col}="Log Female"
global T2_${col}="Literacy"
global T3_${col}="Rate"
global col=1+${col}

/*
gen ltel=ln(IT_MLT_MAIN_P2)
global T1_${col}="Log "
global T2_${col}="Tel. Lines"
global T3_${col}="per capita"
global col=1+${col}


gen lrdfuel=ln(IS_ROD_SGAS_PC)
global T1_${col}="Log Road Fuel"
global T2_${col}="per capita"
global T3_${col}=""
global col=1+${col}

gen lrdlenpa=ln(IS_ROD_TOTL_KM)-lSararea
global T1_${col}="Log Road"
global T2_${col}="KM per area"
global T3_${col}=""
global col=1+${col}


gen lrdpave=ln(IS_ROD_PAVE_ZS)
global T1_${col}="Log Frac"
global T2_${col}="Roads"
global T3_${col}="Paved"
global col=1+${col}


global T1_${col}="Happiness"
global T2_${col}="WVS"
global T3_${col}=""
global col=1+${col}
*/





global col=1
global Lablrgdpchfit "Log GDP per Capita"
global Lablrgdpchsurveys "Log Survey Mean Income"

global LabP1 "QOL Measure on National Accounts and Survey Means: No Fixed Effects"
global LabP2 "QOL Measure on National Accounts and Survey Means: Country Fixed Effects"
global LabP3 "National Accounts-Survey Means Differential on QOL Measure: No Fixed Effects"
global LabP4 "National Accounts-Survey Means Differential on QOL Measure: Country Fixed Effects"

cap drop diff
gen diff=lrgdpchWB-lrgdpchsurveys




foreach v in lrgdpchlight llifex lfert ltnfert lfooddef lpanemia lsanit lsafewater lprimenrr llitr   {

global pan=1
cap drop covariate
global Labcovariate "Log QOL Measure"
clonevar covariate=`v'

reg `v' lrgdpchWB lrgdpchsurveys if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchWB lrgdpchsurveys"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global pan=1+${pan}; 
	#delimit cr
xtreg `v' lrgdpchWB lrgdpchsurveys if base_sample==1, fe i(iso_n) cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchWB lrgdpchsurveys"; global log=1; run auxilpanE; 
	global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);  
      global pan=1+${pan}; 
	#delimit cr
reg diff covariate if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "covariate"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global pan=1+${pan}; 
	#delimit cr
xtreg diff covariate if base_sample==1, fe i(iso_n) cluster(iso_n)
	#delimit ;
	est sto M; global varlist "covariate"; global log=1; run auxilpanE; 
	global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);  
      global pan=1+${pan}; 
	#delimit cr
	
global col=1+${col}
	
}
global col1=${col}
global col=${col}-1
global pan=${pan}-1
global V1 "lrgdpchWB lrgdpchsurveys"
global V2 "lrgdpchWB lrgdpchsurveys"
global V3 "covariate"
global V4 "covariate"
global varlist "lrgdpchWB lrgdpchsurveys covariate"


/* End of Computation */
}

if "$T"=="A" | "$T"=="T" {

*Here we begin writing the table
quietly {
cap log close
log using l${table}.txt, replace

noi di "\documentclass[10pt]{report}"
noi di "\pagestyle{plain}"
noi di "\setlength{\topmargin}{-.25in}"
noi di "\setlength{\textheight}{8.5in}"
noi di "\setlength{\oddsidemargin}{0in}"
noi di "\setlength{\evensidemargin}{0in}"
noi di "\setlength{\textwidth}{6.5in}"
noi di "\usepackage{geometry}"
noi di "\geometry{right=1in,left=0.5in,top=1in,bottom=1in}
noi di "\begin{document}"
noi di "\begin{center}"
noi di "\setlength{\baselineskip}{14pt}"

*Here we reformat all the statistics we have collected
foreach v in $varlist {
forvalues c=1/$col {
forvalues p=1/$pan {
foreach S in b se {
global v `v'
global c `c'
global p `p'
global S `S'
cap global macro "${S}_${v}_${c}_${p}"
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+3)
if "${S}"=="b" {
global ${macro}="{ ${${macro}}${a_${v}_${c}_${p}}}"
}
if "${S}"=="se" {
global ${macro}=cond("${${macro}}"!="","(${${macro}})","")
}
}
}
}
}

forvalues c=1/$col {
forvalues p=1/$pan {
foreach S in R2 {
global c `c'
global p `p'
global S `S'
global macro ${S}_${c}_${p}

cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+2)+substr("${${macro}}",strpos("${${macro}}","e"),.)
if "${S}"=="R2" {
global ${macro}=cond("${${macro}}"!="","${${macro}}","")
}


}
}
}

*Here we construct the table itself

#delimit ;
global stringc=""; forvalues i=1/$col {; global stringc="$stringc"+"c"; };
#delimit cr

#delimit;
global stringnum=""; forvalues i=1/$col {; global stringnum="$stringnum"+"& (`i') "; };
#delimit cr

#delimit;
global stringsp=""; forvalues i=1/$col {; global stringsp="$stringsp"+"& "; };
#delimit cr

	
	foreach S in  T1 T2 T3 {
	global S `S'
	global string${S}=""
	forvalues c=1/$col {
	global c=`c'
	global string${S}="${string${S}}"+"& ${${S}_${c}} "
	}
	}

noi di "\begin{tabular}{|l|$stringc|}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf ${title}} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "${stringT1} \\"
noi di "${stringT2} \\"
noi di "${stringT3} \\"

forvalues p=1/$pan {
global p=`p'
global varlistn ${V`p'}
foreach v in $varlistn {
global v `v'
foreach S in b se {
global S `S'
global string${S}_${v}_${p}=""
forvalues c=1/$col {
global c=`c'
global string${S}_${v}_${p}="${string${S}_${v}_${p}}"+"& ${${S}_${v}_${c}_${p}} "
}
}
}
}

forvalues p=1/$pan {
global p=`p'
global varlistn ${V`p'}

noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it ${LabP${p}}} \\ [.04in]"
noi di "\hline\hline"

foreach v in $varlistn {
global v `v'

noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"

noi di " ${Lab${v}}  ${stringb_${v}_${p}} \\"
noi di "            ${stringse_${v}_${p}} \\"


}

	foreach S in R2  {
	global S `S'
	global string${S}_${p}=""
	forvalues c=1/$col {
	global c=`c'
	global string${S}_${p}="${string${S}_${p}}"+"& ${${S}_${c}_${p}} "
	}

}
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "R2  ${stringR2_${p}} \\"
}
noi di "\hline"

	foreach S in N Cl  {
	global S `S'
	global string${S}_2=""
	forvalues c=1/$col {
	global c=`c'
	global string${S}_2="${string${S}_2}"+"& ${${S}_${c}_2} "
	}
	}


noi di "Number of Obs.  ${stringN_2} \\"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "Number of Clusters  ${stringCl_2} \\"
noi di "\hline"

noi di "\hline"
noi di "\end{tabular}"
noi di "\end{center}"

noi di "\end{document}"
log close
}

shell perl -s tablemod.pl -tablenew="${table}" -table="l${table}"
shellout using "${table}.tex"
!texify -p -c -b --run-viewer ${table}.tex
/*End of Table Construction*/
}
