***Last Updated: 12/14/2018 Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Produce the graphs for the paper

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

Before you run this do file, please change the path of the working directory in line 24 and run all of the data cleaning do files.
*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";

global grfont "Georgia"

********FIGURE 1: BALANCED COVARIATES GRAPH
use "created/women_data_for_analysis_2014.dta", clear
set more off

cap prog drop _all

do "do files\rdprog_cols1_se2_mod2.do"

global gbw "54"
global bin "1"
global lim "dif<=54 & dif>=-54"
global xlabel "-60(12)60,"

global ylabel "0(0.2)1,"

rdintgraphtlim rural_pre12 dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" /// 
	"" "(a) Childhood Region: Rural , size(3.5) color(black)" "" "$gbw"
graph save "graphs/Rural.gph", replace

rdintgraphtlim region5_pre12_1 dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" /// 
	"" "(b) Childhood Region: West, size(3.5) color(black)" "" "$gbw"
graph save "graphs/West.gph", replace

rdintgraphtlim region5_pre12_2 dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" ///
	"" "(c) Childhood Region: South, size(3.5) color(black)" "" "$gbw"
graph save "graphs/South.gph", replace

rdintgraphtlim region5_pre12_3 dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" ///
	"" "(d) Childhood Region: Central, size(3.5) color(black)" "" "$gbw"
graph save "graphs/Central.gph", replace

rdintgraphtlim region5_pre12_4 dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" ///
	"" "(e) Childhood Region: North, size(3.5) color(black)" "" "$gbw"
graph save "graphs/North.gph", replace

rdintgraphtlim region5_pre12_5 dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" ///
	"" "(f) Childhood Region: East, size(3.5) color(black)" "" "$gbw"
graph save "graphs/East.gph", replace

global ylabel "0(0.1)0.4,"

rdintgraphtlim noturkish dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" ///
	"" "(g) Non-Turkish Speaker, size(3.5) color(black)" "" "$gbw"
graph save "graphs/Noturkish.gph", replace

global ylabel "0(0.2)1,"

rdintgraphtlim has_children dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" /// 
	"" "(h) Has Children , size(3.5) color(black)" "" "$gbw"
graph save "graphs/Haschildren.gph", replace

global ylabel "0(0.5)2.5,"

rdintgraphtlim num_children dif $bin "$lim" "" "Born after January 1987 (in months), size(3) color(black)" "$ylabel" "$xlabel" /// 
	"" "(i) Number of Children , size(3.5) color(black)" "" "$gbw"
graph save "graphs/Numchildren.gph", replace


graph combine "graphs/Rural.gph" "graphs/West.gph" "graphs/South.gph" "graphs/Central.gph" "graphs/North.gph" "graphs/East.gph" "graphs/Noturkish.gph"  ///
 "graphs/Haschildren.gph" "graphs/Numchildren.gph", col(3) imargin(small) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	ysize(4) xsize(5.5) saving("graphs/Figure1.gph", replace)

graph export "graphs/Figure1.eps", replace font($grfont)

********FIGURE 2: 
***PANEL A: RD TREATMENT EFFECTS ON JUNIOR HIGH SCHOOL COMPLETION
use "created/hlfs2014_for_graphs.dta", clear

keep if male==0
do "do files/rdprog_cols1_se2_mod.do"
global lim "dif<=60 & dif>=-60"
global xlabel "-60(30)60,"
global ylabel "0.3(0.1)1,"
global bin "1"
global gbw "60"

rdintgraphtlim jhighschool dif $bin "$lim" "" "Born after January 1987 (in months), size(4) color(black)" "$ylabel" "$xlabel" "" "Women with Completed Junior High School, size(4) color(black)" "" "$gbw"
graph save "graphs/Women_jhigh_14.gph", replace

use "created/hlfs2014_for_graphs.dta", clear

keep if male==1
do "do files/rdprog_cols1_se2_mod.do"
global lim "dif<=60 & dif>=-60"
global xlabel "-60(30)60,"
global ylabel "0.3(0.1)1,"
global bin "1"
global gbw "60"

rdintgraphtlim jhighschool dif $bin "$lim" "" "Born after January 1987 (in months), size(4) color(black)" "$ylabel" "$xlabel" "" "Men with Completed Junior High School, size(4) color(black)" "" "$gbw"
graph save "graphs/Men_jhigh_14.gph", replace

graph combine "graphs/Women_jhigh_14.gph" "graphs/Men_jhigh_14.gph", col(2) imargin(small) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	ysize(2.5) xsize(5) title("Panel A: RD Treatment Effects on Junior High Completion", size(3.5) color(black)) saving("graphs/Figure2A.gph", replace)

*** PANEL B: TREATMENT AND PLACEBO GRAPH
use "created/women_data_for_analysis_2014.dta", clear
set more off

cap prog drop _all

do "do files/rdprog_cols1_se2.do"

global ylabel "0(0.1)1,"

global gbw "60"
global bin "1"
global lim "dif<=60 & dif>=-60"
global xlabel "-60(30)60,"

rdintgraphtlim jhighschool dif $bin "$lim" "" "Born after January 1987 (in months), size(4) color(black)" "$ylabel" "$xlabel" /// 
	"" "2014 TNSDVW Survey, size(4) color(black)" "" "$gbw"

graph save "graphs/jhighschool_14.gph", replace

use "created/women_data_for_analysis.dta", clear
set more off

cap prog drop _all

do "do files/rdprog_cols1_se2.do"

global ylabel "0(0.1)1,"

global gbw "60"
global bin "1"
global lim "dif2<=60 & dif2>=-60"
global xlabel "-60(30)60,"

gen dif2=dif+72

rdintgraphtlim jhighschool dif2 $bin "$lim" "" "Born after January 1981 (in months), size(4) color(black)" "$ylabel" "$xlabel" /// 
	"" "2008 TNSDVW Survey, size(4) color(black)" "" "$gbw"
graph save "graphs/jhighschool_08.gph", replace
graph combine "graphs/jhighschool_14.gph" "graphs/jhighschool_08.gph", col(2) imargin(small) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	ysize(2.5) xsize(5) title("Panel B: Treatment and Placebo", size(3.5) color(black)) saving("graphs/Figure2B.gph", replace)

graph combine "graphs/Figure2A.gph" "graphs/Figure2B.gph", col(1) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	ysize(5) xsize(5) title("", size(3.5) color(black)) saving("graphs/Figure2_new.gph", replace)

graph export "graphs/Figure2_new.eps", replace font($grfont)

********FIGURE A3: RD TREATMENT EFFECTS ON CHILDHOOD VIOLENCE
use "created/women_data_for_analysis_2014.dta", clear
set more off

cap prog drop _all

do "do files\rdprog_cols1_se2.do"

global gbw "96"
global bin "1"
global lim "dif<=96 & dif>=-96"
global xlabel "-90(45)90,"

global ylabel "0(0.2)0.4,"

rdintgraphtlim violence_family dif $bin "$lim" "" "Born after January 1987 (in months), size(3.5) color(black)" "$ylabel" "$xlabel" /// 
	"" "(a) Childhood Violence , size(4) color(black)" "" "$gbw"
graph save "graphs/violence.gph", replace

rdintgraphtlim violence_family_often dif $bin "$lim" "" "Born after January 1987 (in months), size(3.5) color(black)" "$ylabel" "$xlabel" /// 
	"" "(b) Childhood Violence Intensity, size(4) color(black)" "" "$gbw"
graph save "graphs/violenceint.gph", replace

graph combine "graphs/violence.gph" "graphs/violenceint.gph"   ///
, col(3) imargin(small) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	ysize(2) xsize(5) saving("graphs/FigureA3.gph", replace)

graph export "graphs/FigureA3.eps", replace font($grfont)
