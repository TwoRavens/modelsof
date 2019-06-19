capture log close
clear all
set mem 450m
set matsize 400

global dir C:/Dropbox/AResearch/GGreen
cd /
cd $dir

log using Logs/estimates.txt, text replace

** ESTIMATION GLOBALS
global controlsA "logft centralair shingled i.baths i.beds i.stories zipD* monthyearD*"
global controlsB "logft centralair shingled i.baths i.beds i.stories ZMY1X1-ZMY5X15 ZMY5X17-ZMY9X36"
global weatherA "CodeHDD CodeCDD"
global weatherB "CodeHDD CodeCDD HDD CDD"
global treatmentyears "EffectiveYear1999 EffectiveYear2000 EffectiveYear2001 EffectiveYear2003 EffectiveYear2004 EffectiveYear2005"

** ESTIMATES: Table 3: Pre- and Post-Code Comparisons
use Data/gg, clear
xi: reg elec x2001code $controlsA, cluster(home_id)
estsave, gen(elecA)
xi: reg elec x2001code $controlsB, cluster(home_id)
estsave, gen(elecB)
xi: reg gas x2001code $controlsA, cluster(home_id)
estsave, gen(gasA)
xi: reg gas x2001code $controlsB, cluster(home_id)
estsave, gen(gasB)

** ESTIMATES: Table 4: Diff-in-Diff Weather
xi: xtreg elec $weatherA monthyearD*, fe cluster(home_id)
estsave, gen(elecddA)
xi: xtreg elec $weatherB monthD* yearD*, fe cluster(home_id)
estsave, gen(elecddB)
xi: xtreg gas $weatherA monthyearD*, fe cluster(home_id)
estsave, gen(gasddA)
xi: xtreg gas $weatherB monthD* yearD*, fe cluster(home_id)
estsave, gen(gasddB)

** ESTIMATES: Figure 1 & 2: Effect by month
xi: reg elec CodexMonth1-CodexMonth12 $controlsA, cluster(home_id)
estsave, gen(eleccal)
xi: reg gas CodexMonth1-CodexMonth12 $controlsA, cluster(home_id)
estsave, gen(gascal)

** SAVE ESTIMATION RESULTS
save Data/est1, replace

** ELEC AND GAS AMOUNTS PER MONTH (FOR CALCULATING PERCENTAGES FOR FIGURE 1 and 2)
use Data/gg, clear
collapse elec gas, by(month)
outsheet using PaperGG/Tab/monthavg.csv, replace

** ESTIMATES: Figure 3 & 4: Effect by Year
use Data/gg2002, clear
xi: reg elec $treatmentyears $controlsA, cluster(home_id)
estsave, gen(elecyears)
xi: reg gas $treatmentyears $controlsA, cluster(home_id)
estsave, gen(gasyears)

** SAVE ESTIMATION RESULTS
save Data/est2, replace

** THE REST OF THIS IS MAKING LATEX TABLES

** SOME TABLE GLOBALS
global tablekeep "x2001code logft centralair shingled"
global tablekeepfe "CodeCDD CodeHDD CDD HDD"
global labels "cells(b(star fmt(3)) se(par fmt(3))) style(GG) mlabels(, none) collabels(, none) label"
global prehead "prehead(\begin{tabular}{l*{@M}{cc}} \hline\hline)"
global postfoot "postfoot(\hline \end{tabular})"

** MORE TABLE GLOBALS
# delimit ;

global posthead
"posthead(
\textbf{Dependent Variable:} 
& \multicolumn{2}{c}{\textbf{Electricity}}
& \multicolumn{2}{c}{\textbf{Natural Gas}} \\
& \multicolumn{1}{c}{(1)}
& \multicolumn{1}{c}{(2)}
& \multicolumn{1}{c}{(3)}
& \multicolumn{1}{c}{(4)}
\\ \hline
)"
;

global postheadcal 
"posthead(
\textbf{Dependent Variable:} 
& \multicolumn{1}{c}{\textbf{Electricity}}
& \multicolumn{1}{c}{\textbf{Natural Gas}} \\
& \multicolumn{1}{c}{(1)}
& \multicolumn{1}{c}{(2)}
\\ \hline
)"
;

global prefoot 
"prefoot(
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ }
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ } \\
Bathroom Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes}
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Bedroom Dummiess: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes}
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Story Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes}
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\\\
Zip Code Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes}
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Month-year Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes}
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Zip Code X Month-Year Dummies: 
& \multicolumn{1}{c}{No} & \multicolumn{1}{c}{Yes}
& \multicolumn{1}{c}{No} & \multicolumn{1}{c}{Yes} \\
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ }
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ } \\
)"
;

global prefootdd 
"prefoot(
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ } 
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ } \\
Month Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{No} 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{No} \\
Year Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{No} 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{No} \\
Month-year Dummies: 
& \multicolumn{1}{c}{No} & \multicolumn{1}{c}{Yes} 
& \multicolumn{1}{c}{No} & \multicolumn{1}{c}{Yes} \\
Residence fixed-effects: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
)"
;

global prefootcal 
"prefoot(
& \multicolumn{1}{c}{ } & \multicolumn{1}{c}{ } \\
Bathroom Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Bedroom Dummiess: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Story Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\\\
Zip Code Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
Month-year Dummies: 
& \multicolumn{1}{c}{Yes} & \multicolumn{1}{c}{Yes} \\
)"
;

# delimit cr

** LOAD ESTIMATES
use Data/est1, clear
estsave, from(elecA)
est sto elecA
estsave, from(elecB)
est sto elecB
estsave, from(gasA)
est sto gasA
estsave, from(gasB)
est sto gasB
estsave, from(elecddA)
est sto elecddA
estsave, from(elecddB)
est sto elecddB
estsave, from(gasddA)
est sto gasddA
estsave, from(gasddB)
est sto gasddB
estsave, from(gasddB)
est sto gasddB
estsave, from(eleccal)
est sto eleccal
estsave, from(gascal)
est sto gascal

** TABLE 3 
estout elecA elecB gasA gasB ///
using PaperGG/Tab/table3.tex, ///
keep($tablekeep) ///
order($tablekeep) ///
$labels $prehead $posthead $prefoot $postfoot replace stats(r2 N)

** TABLE 4
estout elecddB elecddA gasddB gasddA ///
using PaperGG/Tab/table4.tex, ///
keep($tablekeepfe) ///
order($tablekeepfe) ///
$labels $prehead $posthead $prefootdd $postfoot replace stats(r2 N)

** FIGS 1 AND 2: THESE ESTIMATES CAN BE COMBINED WITH THE AVERAGES GENERATED ABOVE (monthavg.csv) 
** TO CREATE FIGURES 1 AND 2.
estout eleccal gascal ///
using PaperGG/Tab/cal.tex, ///
keep(CodexMonth* logft centralair shingled) ///
order(CodexMonth* logft centralair shingled) ///
$labels $prehead $postheadcal $prefootcal $postfoot replace stats(r2 N)

** FIGS 3 AND 4: THESE ESTIMATES CAN BE USED TO CREATE FIGURES 3 and 4
use Data/est2, replace
estsave, from(elecyears)
est sto elecyears
estsave, from(gasyears)
est sto gasyears
estout elecyears gasyears ///
using PaperGG/Tab/years.tex, ///
keep($treatmentyears logft centralair shingled) ///
order($treatmentyears logft centralair shingled) ///
$labels $prehead $postheadcal $prefootcal $postfoot replace stats(r2 N)

log close





