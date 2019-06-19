* writes the "bare bones" contents of the TeX table (i.e. just the numbers)
#delimit;

tempname hh;
file open `hh' using "$docPath\tables\tAllCountriesFin.tex", write append; 

file write `hh' (countryCaption[$rowCounter]) "  & ";

sca ptest = 2*(1-normal(abs(t1pointAllTemp[$rowCounter,2])/t1seAllTemp[$rowCounter,2]));
do MakeTestStringJ;
file write `hh' %5.2f (t1pointAllTemp[$rowCounter,2]) (teststr) "  & ";
if t1pvalAllTemp[$rowCounter,1] == . {;
    file write `hh' " \multicolumn{1}{c}{--} & ";
    };
else {;
    file write `hh' %5.4f (t1pvalAllTemp[$rowCounter,1]) "  & ";
};


sca ptest = 2*(1-normal(abs(t1pointAllTemp[$rowCounter,3])/t1seAllTemp[$rowCounter,3]));
do MakeTestStringJ;
file write `hh' %5.2f (t1pointAllTemp[$rowCounter,3]) (teststr) " & ";
if t1pvalAllTemp[$rowCounter,2] == . {;
    file write `hh' " \multicolumn{1}{c}{--} & ";
    };
else {;
    file write `hh' %5.4f (t1pvalAllTemp[$rowCounter,2]) "  & ";
};

sca ptest = 2*(1-normal(abs(t1pointAllTemp[$rowCounter,4])/t1seAllTemp[$rowCounter,4]));
do MakeTestStringJ;
file write `hh' %5.2f (t1pointAllTemp[$rowCounter,4]) (teststr) "  & ";
if t1pvalAllTemp[$rowCounter,3] == . {;
    file write `hh' " \multicolumn{1}{c}{--} & ";
    };
else {;
    file write `hh' %5.4f (t1pvalAllTemp[$rowCounter,3]) "  & ";
};

if t1pointAllTemp[$rowCounter,9] == . {;
    file write `hh' " \multicolumn{1}{c}{--} & "_n;
    };
else {;
    file write `hh' %5.2f (t1pointAllTemp[$rowCounter,9]) " & ";
};


sca ptest = 2*(1-normal(abs(t1pointAllTemp[$rowCounter,5])/t1seAllTemp[$rowCounter,5]));
do MakeTestStringJ;
file write `hh' %5.2f (t1pointAllTemp[$rowCounter,5]) (teststr) " & ";
sca ptest = 2*(1-normal(abs(t1pointAllTemp[$rowCounter,6])/t1seAllTemp[$rowCounter,6]));
do MakeTestStringJ;
file write `hh' %5.2f (t1pointAllTemp[$rowCounter,6]) (teststr) " & ";
sca ptest = 2*(1-normal(abs(t1pointAllTemp[$rowCounter,7])/t1seAllTemp[$rowCounter,7]));
do MakeTestStringJ;
file write `hh' %5.2f (t1pointAllTemp[$rowCounter,7]) (teststr) " & ";

if t1pointAllTemp[$rowCounter,8] == . {;
    file write `hh' " \multicolumn{1}{c}{--}" $eolString _n;
    };
else {;
    file write `hh' %5.2f (t1pointAllTemp[$rowCounter,8]) $eolString _n;
};

file close `hh';
