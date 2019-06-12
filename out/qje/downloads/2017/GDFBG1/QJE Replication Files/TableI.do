global T="A"
global table "TableReg"
global title "Baseline Regressions"
global key=0

if "$T"=="A" | "$T"=="C" {

macro drop b_* se_* seo_* R2_* Cl_* N_* a_*

use NASM_base2, clear


global col=1
global LablrgdpchWB "Log GDP per Capita"
global Lablrgdpchsurveys "Log Survey Mean Income"
global LablSelectp "Log Electricity per Capita"

global LabP1 "No Fixed Effects"
global LabP2 "Year Fixed Effects"
global LabP3 "Country Fixed Effects"
global LabP4 "Country and Year Fixed Effects"



global pan=1

foreach controlset in "" "i.year" "i.iso_n" "i.iso_n i.year"  {
global controlset `controlset'

global col=1

xi: reg lrgdpchlight lrgdpchWB ${controlset} if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchWB"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global col=1+${col}; 
	#delimit cr
xi: reg lrgdpchlight lrgdpchsurveys ${controlset} if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchsurveys"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global col=1+${col}; 
	#delimit cr
xi: ivreg lrgdpchsurveys  (lrgdpchWB=lrgdpchlight)   ${controlset} if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchWB"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global col=1+${col}; 
	#delimit cr
xi: reg lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchWB lrgdpchsurveys"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global col=1+${col}; 
	#delimit cr
xi: reg lrgdpchlight lrgdpchWB lrgdpchsurveys lSelectp ${controlset} if base_sample==1, cluster(iso_n)
	#delimit ;
	est sto M; global varlist "lrgdpchWB lrgdpchsurveys lSelectp"; global log=1; run auxilpanE; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N); 
    global col=1+${col}; 
	#delimit cr

	
global pan=1+${pan}
	
}
global col1=${col}
global col=${col}-1
global pan=${pan}-1
global varlist "lrgdpchWB lrgdpchsurveys lSelectp"


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

noi di "\begin{tabular}{|l|cc|c|cc|}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf ${title}} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "& Log & Log & Log & Log & Log \\"
noi di "& Lights & Lights & Surveys & Lights & Lights \\"
noi di "& OLS & OLS & IV, Lights & OLS & OLS \\"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"


forvalues p=1/$pan {
global p=`p'
foreach v in $varlist {
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

noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{\it ${LabP${p}}} \\ [.04in]"
noi di "\hline\hline"

foreach v in $varlist {
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
