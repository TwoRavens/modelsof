
* writes the "bare bones" contents of the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tables\tAllCgroups.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Consumption Dynamics---Groups of Countries (Simple Averages) } \label{tAllCG}" _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{4}d{4}d{5}d{4}d{4}d{5}@{}}" _n;
file write `hh' "\multicolumn{7}{c}{ \$\Delta\log\mathbf{C}_{t}=\varsigma+\chi\mathbb{E}_{t-2}[\Delta\log\mathbf{C}_{t-1}]+\eta\mathbb{E}_{t-2}[\Delta\log\mathbf{Y}_{t}]+\alpha \mathbb{E}_{t-2}[a_{t-1}]\$ } " $eolString  _n "\toprule" _n;
file write `hh' "   &   \multicolumn{3}{c}{Estimation with } & \multicolumn{3}{c}{Estimation with }" $eolString _n;
file write `hh' "   &   \multicolumn{3}{c}{one regressor only} & \multicolumn{3}{c}{all three regressors}" $eolString _n;
file write `hh' " \cmidrule(r){2-4} \cmidrule(l){5-7} " _n;
file write `hh' " Country & \multicolumn{1}{c}{\$\chi\$}  & \multicolumn{1}{c}{\$\eta\$}  &  \multicolumn{1}{c}{\$\alpha\$} & \multicolumn{1}{c}{\$\chi\$}  & \multicolumn{1}{c}{\$\eta\$}  &  \multicolumn{1}{c}{\$\alpha\$}" $eolString _n "\midrule " _n;

* All Countries;
file write `hh' "All Countries  & ";
sca ptest = 2*(1-normal(abs(tPointSumAll[1,2])/tSeSumAll[1,2]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAll[1,2]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAll[1,3])/tSeSumAll[1,3]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAll[1,3]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAll[1,4])/tSeSumAll[1,4]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAll[1,4]) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(tPointSumAll[1,5])/tSeSumAll[1,5]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAll[1,5]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAll[1,6])/tSeSumAll[1,6]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAll[1,6]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAll[1,7])/tSeSumAll[1,7]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAll[1,7]) (teststr)  $eolString _n;

file write `hh' " & (" %4.2f (tSeSumAll[1,2]) ")  &  (" %4.2f (tSeSumAll[1,3]) ")  &  (" %4.2f (tSeSumAll[1,4]) ")  &  (" %4.2f (tSeSumAll[1,5]) ")  &  ("%4.2f (tSeSumAll[1,6]) ")  &  (" %4.2f (tSeSumAll[1,7]) ")"  $eolString _n;


* G7 Countries;
file write `hh' "G7 Countries  & ";
sca ptest = 2*(1-normal(abs(tPointSumG7[1,2])/tSeSumG7[1,2]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumG7[1,2]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumG7[1,3])/tSeSumG7[1,3]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumG7[1,3]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumG7[1,4])/tSeSumG7[1,4]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumG7[1,4]) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(tPointSumG7[1,5])/tSeSumG7[1,5]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumG7[1,5]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumG7[1,6])/tSeSumG7[1,6]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumG7[1,6]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumG7[1,7])/tSeSumG7[1,7]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumG7[1,7]) (teststr) $eolString _n;

file write `hh' " & (" %4.2f (tSeSumG7[1,2]) ")  &  (" %4.2f (tSeSumG7[1,3]) ")  &  (" %4.2f (tSeSumG7[1,4]) ")  &  (" %4.2f (tSeSumG7[1,5]) ")  &  ("%4.2f (tSeSumG7[1,6]) ")  &  (" %4.2f (tSeSumG7[1,7]) ") " $eolString _n;

* Anglo-Saxon Countries;
file write `hh' "Anglo--Saxon  & ";
sca ptest = 2*(1-normal(abs(tPointSumAngloSaxon[1,2])/tSeSumAngloSaxon[1,2]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAngloSaxon[1,2]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAngloSaxon[1,3])/tSeSumAngloSaxon[1,3]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAngloSaxon[1,3]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAngloSaxon[1,4])/tSeSumAngloSaxon[1,4]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAngloSaxon[1,4]) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(tPointSumAngloSaxon[1,5])/tSeSumAngloSaxon[1,5]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAngloSaxon[1,5]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAngloSaxon[1,6])/tSeSumAngloSaxon[1,6]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAngloSaxon[1,6]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumAngloSaxon[1,7])/tSeSumAngloSaxon[1,7]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumAngloSaxon[1,7]) (teststr) $eolString _n;

file write `hh' " & (" %4.2f (tSeSumAngloSaxon[1,2]) ")  &  (" %4.2f (tSeSumAngloSaxon[1,3]) ")  &  (" %4.2f (tSeSumAngloSaxon[1,4]) ")  &  (" %4.2f (tSeSumAngloSaxon[1,5]) ")  &  ("%4.2f (tSeSumAngloSaxon[1,6]) ")  &  (" %4.2f (tSeSumAngloSaxon[1,7]) ")"  $eolString _n;

* Euro Area Countries;
file write `hh' "Euro Area  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroArea[1,2])/tSeSumEuroArea[1,2]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroArea[1,2]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroArea[1,3])/tSeSumEuroArea[1,3]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroArea[1,3]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroArea[1,4])/tSeSumEuroArea[1,4]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroArea[1,4]) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(tPointSumEuroArea[1,5])/tSeSumEuroArea[1,5]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroArea[1,5]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroArea[1,6])/tSeSumEuroArea[1,6]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroArea[1,6]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroArea[1,7])/tSeSumEuroArea[1,7]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroArea[1,7]) (teststr)  $eolString _n;

file write `hh' " & (" %4.2f (tSeSumEuroArea[1,2]) ")  &  (" %4.2f (tSeSumEuroArea[1,3]) ")  &  (" %4.2f (tSeSumEuroArea[1,4]) ")  &  (" %4.2f (tSeSumEuroArea[1,5]) ")  &  ("%4.2f (tSeSumEuroArea[1,6]) ")  &  (" %4.2f (tSeSumEuroArea[1,7]) ") " $eolString _n;

* EU;
file write `hh' "European Union  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroUnion[1,2])/tSeSumEuroUnion[1,2]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroUnion[1,2]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroUnion[1,3])/tSeSumEuroUnion[1,3]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroUnion[1,3]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroUnion[1,4])/tSeSumEuroUnion[1,4]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroUnion[1,4]) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(tPointSumEuroUnion[1,5])/tSeSumEuroUnion[1,5]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroUnion[1,5]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroUnion[1,6])/tSeSumEuroUnion[1,6]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroUnion[1,6]) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(tPointSumEuroUnion[1,7])/tSeSumEuroUnion[1,7]));
do MakeTestStringJ;
file write `hh' %4.2f (tPointSumEuroUnion[1,7]) (teststr)  $eolString _n;

file write `hh' " & (" %4.2f (tSeSumEuroUnion[1,2]) ")  &  (" %4.2f (tSeSumEuroUnion[1,3]) ")  &  (" %4.2f (tSeSumEuroUnion[1,4]) ")  &  (" %4.2f (tSeSumEuroUnion[1,5]) ")  &  ("%4.2f (tSeSumEuroUnion[1,6]) ")  &  (" %4.2f (tSeSumEuroUnion[1,7]) ") " $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' " Instruments: \footnotesize\texttt{";
foreach c of global ivset2all {;
	file write `hh' "`c' ";
	};
file write `hh' "}";
file write `hh' $eolString "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\footnotesize Notes: Left Panel: Regressions were estimated with one regressor only. Right Panel: Regressions were estimated with all three regressors. Robust standard errors, calculated as means of standard errors of individual countries, are in parentheses. \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent." $eolString " All countries: Canada, France, Germany, Italy, the United Kingdom, the United States, Australia, Belgium, Denmark, Finland, the Netherlands, Spain, Sweden. G7 countries: Canada, France, Germany, Italy, the United Kingdom, the United States. Anglo--Saxon Countries: Australia, Canada,  the United Kingdom,  the United States. Euro Area Countries: France, Germany, Italy, Belgium, Finland, the Netherlands, Spain. European Union: France, Germany, Italy, the United Kingdom, Belgium, Denmark, Finland, the Netherlands, Spain, Sweden.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

