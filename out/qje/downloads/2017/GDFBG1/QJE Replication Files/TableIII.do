global T="A"
global table "TableSubsamples"
global title "Weights in the Optimal Proxy: Subsamples"
global key=0

if "$T"=="A" | "$T"=="C" {

macro drop b_* se_* seo_* R2_* Cl_* N_* a_*

use NASM_base2, clear
cap gen lSelectp=lSelect-lSpoptotal
xi i.year, pref(Y)
so isoc
merge isoc using CNgrades
ta _me
drop if _me==2
drop _me

gen sigma=sqrt(2)*invnormal((1+gini/100)/2)
gen povct=popWB*normal((ln(1.25*365)-lrgdpchsurveys)/sigma)
by isoc, so: egen mean_povct=mean(povct)

preserve
keep if base_sample==1
keep isoc mean_povct
duplicates drop isoc, force
su mean_povct, det
restore

gen povsample=0
replace povsample=1 if base_sample==1 & mean_povct<r(p50)
replace povsample=2 if base_sample==1 & mean_povct>=r(p50) 

global col=1
global LabNA "Log GDP per Capita"
global LabSurveys "Log Survey Mean"

global B=200

global LabP1 "No Fixed Effects"
global LabP2 "Year Fixed Effects"
global LabP3 "Country Fixed Effects"
global LabP4 "Country and Year Fixed Effects"

global controls1 "lSpoptotal lSpoprural lSpopurban Slat Slon lSrichshare lSpoorshare"
global controls21 "lSpoptotal lSgdpnrg lSarea lSararea Slat Slon lSoil lSelect lSpoprural lSpopurban lSservices lSagr lSexports lSimports lSmanuf lShcfa lSgovexp lSgrosscapform lSrichshare lSpoorshare"
global controls22 "lSpoptotal2 lSgdpnrg2 lSarea2 lSararea2 Slat2 Slon2 lSpoprural2 lSoil2 lSelect2 lSpopurban2 lSservices2 lSagr2 lSexports2 lSimports2 lSmanuf2 lShcfa2 lSgovexp2 lSgrosscapform2 lSrichshare2 lSpoorshare2"


global pan=1

foreach set in "" "YFE" "CFE" "CYFE"  {
if strpos("`set'","C")>0 {
global cmd "xtreg"
global suffix "fe i(iso_n)"
}
if strpos("`set'","C")==0 {
global cmd "reg"
global suffix ""
}
if strpos("`set'","Y")>0 {
global controlset "Y*"
}
if strpos("`set'","Y")==0 {
global controlset ""
}


global col=1

noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1, ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} ""; global TL2_${col} "";
    global col=1+${col}; 
	#delimit cr
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & region=="ssa", ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Africa"; global TL2_${col} "";
    global col=1+${col}; 
	#delimit cr
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & (region=="ea" | region=="sa" | region=="mena"), ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Asia"; global TL2_${col} "";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & region=="la", ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Latin"; global TL2_${col} "America";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & (region=="eeu" | region=="exsoviet"), ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Post"; global TL2_${col} "Comm.";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & povsample==1, ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Less"; global TL2_${col} "Poor";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & povsample==2, ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "More"; global TL2_${col} "Poor";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & (grade=="B" | grade=="C") , ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Good"; global TL2_${col} "Data";
    global col=1+${col}; 
	#delimit cr
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & (grade=="D" | grade=="E") , ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "Bad"; global TL2_${col} "Data";
    global col=1+${col}; 
	#delimit cr
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & year>=1992 & year<=1997, ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "1992"; global TL2_${col} "-1997";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & year>=1998 & year<=2003, ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "1998"; global TL2_${col} "-2003";
    global col=1+${col}; 
	#delimit cr	
noi bootstrap NA=(_b[lrgdpchWB]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) Surveys=(_b[lrgdpchsurveys]/(_b[lrgdpchWB]+_b[lrgdpchsurveys])) ///
	, level(95) seed(777) reps(${B}) cluster(iso_n): ///
	${cmd} lrgdpchlight lrgdpchWB lrgdpchsurveys ${controlset} if base_sample==1 & year>=2004 & year<=2010, ${suffix} cluster(iso_n)
	#delimit;  
	global varlist "NA Surveys"; global log=1; do auxilpanE; 
	`=subinstr("`e(command)'",","," if e(sample),",1)'; 
    global R2_${col}_${pan}=e(r2); global Cl_${col}_${pan}=e(N_clust); global N_${col}_${pan}=e(N);
	global TL1_${col} "2004"; global TL2_${col} "-2010";
    global col=1+${col}; 
	#delimit cr

		
		
global pan=1+${pan}
	
}
global col1=${col}
global col=${col}-1
global pan=${pan}-1
global varlist "NA Surveys"


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
foreach S in b se ub lb {
global v `v'
global c `c'
global p `p'
global S `S'
cap global macro "${S}_${v}_${c}_${p}"
if "${S}"=="b" {
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+2) 
global ${macro}="{ ${${macro}}${a_${v}_${c}_${p}}}"
}
if "${S}"=="se" {
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+3)
global ${macro}=cond("${${macro}}"!="","(${${macro}})","")
}
if "${S}"=="ub" || "${S}"=="lb"  {
if abs(${${macro}})>1.1 {
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+1)
}
else {
cap global ${macro}=substr("${${macro}}",1,strpos("${${macro}}",".")+2)
}
}
}

global ci_${v}_${c}_${p}="(${lb_${v}_${c}_${p}},${ub_${v}_${c}_${p}})"
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

	
	foreach S in  TL1 TL2 {
	global S `S'
	global string${S}=""
	forvalues c=1/$col {
	global c=`c'
	global string${S}="${string${S}}"+"& ${${S}_${c}} "
	}
	}

noi di "\begin{tabular}{|l|c|cccc|cc|cc|ccc}"
noi di "\hline\hline"
noi di "\multicolumn{$col1}{|c|}{} \\ [-.15in]"
noi di "\multicolumn{$col1}{|c|}{\bf ${title}} \\ [.04in]"
noi di "\multicolumn{$col1}{|c|}{\it Dependent Variable is Log Light Intensity per Capita} \\ [.04in]"
noi di "\hline"
noi di "$stringnum \\ [.04in]"
noi di "\hline\hline"
noi di "& \multicolumn{1}{|c|}{Baseline} & \multicolumn{4}{|c|}{Regions} & \multicolumn{2}{|c|}{Poverty} & \multicolumn{2}{|c|}{Grades} & \multicolumn{3}{c|}{Years} \\"
noi di "\hline\hline"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "$stringsp \\ [-.15in]"
noi di "${stringTL1} \\"
noi di "${stringTL2} \\"


forvalues p=1/$pan {
global p=`p'
foreach v in $varlist {
global v `v'
foreach S in b se ci {
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
noi di "            ${stringci_${v}_${p}} \\"


}

	foreach S in R2  {
	global S `S'
	global string${S}_${p}=""
	forvalues c=1/$col {
	global c=`c'
	global string${S}_${p}="${string${S}_${p}}"+"& ${${S}_${c}_${p}} "
	}

}
*noi di "$stringsp \\ [-.15in]"
*noi di "$stringsp \\ [-.15in]"
*noi di "$stringsp \\ [-.15in]"
*noi di "$stringsp \\ [-.15in]"
*noi di "R2  ${stringR2_${p}} \\"
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
