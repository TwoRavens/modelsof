	#delimit;


clear;
set memory 500m;

/*
Data Request Summary

Data Request ID         041222027
Libraries/Data Sets     crsp/msf  /
Frequency/Date Range    mon / Jan 1925 - Dec 2008
Search Variable         TICKER
Input Codes
all item(s)

-all-

Conditional Statements  n/a
Output format/Compression       dta / zip
Variables Selected      CUSIP COMNAM PERMCO SICCD PRC ALTPRC RET SHROUT DLRET
Extra Variables and Parameters Selected

As part of the WRDS Capacity Expansion Plans, this data query is being processed on a new grid server. If you encounter any issues running this query, please contact wrds-support@wharton.upenn.edu.

Your output is complete. Click on the link below to open the output file.

      041222027_dta.zip (43.4 MB, 3656362 observations 11 variables)

      Download instructions
      Internet Explorer and Firefox users... Right-click and select "Save Target As..."

      Your data query results will be accessible for the next 48 hours in the My Wrds section of the website.

      Notice:
      Your use of WRDS and this data extract must comply with the WRDS Terms of Use. There may be additional usage restrictions that are governed by your institution’s licensing of specific databases. If you have any questions about data licensing and appropriate usage, please contact wrds-support@wharton.upenn.edu.
*/



use "$startdir/$inputdata/041222027.dta", clear;

gen ShoreInd=.;
replace ShoreInd=       1       if floor(siccd/100)==   1       & siccd!=. ;
replace ShoreInd=       2       if floor(siccd/100)==   2       & siccd!=. ;
replace ShoreInd=       2       if siccd==      .       & siccd!=. ;
replace ShoreInd=       3       if floor(siccd/100)==   7       & siccd!=. ;
replace ShoreInd=       3       if siccd==      .       & siccd!=. ;
replace ShoreInd=       4       if floor(siccd/100)==   8       & siccd!=. ;
replace ShoreInd=       5       if floor(siccd/100)==   9       & siccd!=. ;
replace ShoreInd=       11      if floor(siccd/100)==   10      & siccd!=. ;
replace ShoreInd=       12      if floor(siccd/100)==   12      & siccd!=. ;
replace ShoreInd=       13      if floor(siccd/100)==   13      & siccd!=. ;
replace ShoreInd=       14      if floor(siccd/100)==   14      & siccd!=. ;
replace ShoreInd=       21      if floor(siccd/100)==   15      & siccd!=. ;
replace ShoreInd=       21      if floor(siccd/100)==   16      & siccd!=. ;
replace ShoreInd=       21      if floor(siccd/100)==   17      & siccd!=. ;
replace ShoreInd=       21      if siccd==      .       & siccd!=. ;
replace ShoreInd=       21      if siccd==      .       & siccd!=. ;
replace ShoreInd=       31      if floor(siccd/100)==   24      & siccd!=. ;
replace ShoreInd=       31      if floor(siccd/100)==   25      & siccd!=. ;
replace ShoreInd=       31      if siccd==      .       & siccd!=. ;
replace ShoreInd=       31      if siccd==      .       & siccd!=. ;
replace ShoreInd=       32      if floor(siccd/100)==   32      & siccd!=. ;
replace ShoreInd=       32      if siccd==      .       & siccd!=. ;
replace ShoreInd=       32      if siccd==      .       & siccd!=. ;
replace ShoreInd=       32      if siccd==      .       & siccd!=. ;
replace ShoreInd=       32      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if floor(siccd/100)==   33      & siccd!=. ;
replace ShoreInd=       33      if floor(siccd/100)==   34      & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       33      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if floor(siccd/100)==   35      & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       34      if siccd==      .       & siccd!=. ;
replace ShoreInd=       35      if floor(siccd/100)==   36      & siccd!=. ;
replace ShoreInd=       35      if siccd==      .       & siccd!=. ;
replace ShoreInd=       35      if siccd==      .       & siccd!=. ;
replace ShoreInd=       35      if siccd==      .       & siccd!=. ;
replace ShoreInd=       36      if floor(siccd/100)==   37      & siccd!=. ;
replace ShoreInd=       36      if siccd==      .       & siccd!=. ;
replace ShoreInd=       36      if siccd==      .       & siccd!=. ;
replace ShoreInd=       36      if siccd==      .       & siccd!=. ;
replace ShoreInd=       36      if siccd==      .       & siccd!=. ;
replace ShoreInd=       36      if siccd==      .       & siccd!=. ;
replace ShoreInd=       37      if floor(siccd/100)==   38      & siccd!=. ;
replace ShoreInd=       37      if siccd==      .       & siccd!=. ;
replace ShoreInd=       37      if siccd==      .       & siccd!=. ;
replace ShoreInd=       37      if siccd==      .       & siccd!=. ;
replace ShoreInd=       37      if siccd==      .       & siccd!=. ;
replace ShoreInd=       41      if floor(siccd/10)/10== 20.1    & siccd!=. ;
replace ShoreInd=       42      if floor(siccd/10)/10== 20.2    & siccd!=. ;
replace ShoreInd=       43      if floor(siccd/10)/10== 20.3    & siccd!=. ;
replace ShoreInd=       44      if floor(siccd/10)/10== 20.4    & siccd!=. ;
replace ShoreInd=       45      if floor(siccd/10)/10== 20.5    & siccd!=. ;
replace ShoreInd=       46      if floor(siccd/10)/10== 20.6    & siccd!=. ;
replace ShoreInd=       47      if floor(siccd/10)/10== 20.8    & siccd!=. ;
replace ShoreInd=       48      if floor(siccd/100)==   21      & siccd!=. ;
replace ShoreInd=       49      if floor(siccd/10)/10== 20.7    & siccd!=. ;
replace ShoreInd=       49      if floor(siccd/10)/10== 20.9    & siccd!=. ;
replace ShoreInd=       50      if floor(siccd/100)==   22      & siccd!=. ;
replace ShoreInd=       50      if siccd==      .       & siccd!=. ;
replace ShoreInd=       50      if siccd==      .       & siccd!=. ;
replace ShoreInd=       50      if siccd==      .       & siccd!=. ;
replace ShoreInd=       50      if siccd==      .       & siccd!=. ;
replace ShoreInd=       50      if siccd==      .       & siccd!=. ;
replace ShoreInd=       50      if siccd==      .       & siccd!=. ;
replace ShoreInd=       51      if floor(siccd/100)==   23      & siccd!=. ;
replace ShoreInd=       51      if siccd==      .       & siccd!=. ;
replace ShoreInd=       52      if floor(siccd/100)==   26      & siccd!=. ;
replace ShoreInd=       52      if siccd==      .       & siccd!=. ;
replace ShoreInd=       52      if siccd==      .       & siccd!=. ;
replace ShoreInd=       53      if floor(siccd/100)==   27      & siccd!=. ;
replace ShoreInd=       53      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if floor(siccd/100)==   28      & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       54      if siccd==      .       & siccd!=. ;
replace ShoreInd=       55      if floor(siccd/100)==   29      & siccd!=. ;
replace ShoreInd=       55      if siccd==      .       & siccd!=. ;
replace ShoreInd=       56      if floor(siccd/100)==   30      & siccd!=. ;
replace ShoreInd=       56      if siccd==      .       & siccd!=. ;
replace ShoreInd=       57      if floor(siccd/100)==   31      & siccd!=. ;
replace ShoreInd=       57      if siccd==      .       & siccd!=. ;
replace ShoreInd=       57      if siccd==      .       & siccd!=. ;
replace ShoreInd=       58      if floor(siccd/100)==   39      & siccd!=. ;
replace ShoreInd=       58      if siccd==      .       & siccd!=. ;
replace ShoreInd=       58      if siccd==      .       & siccd!=. ;
replace ShoreInd=       58      if siccd==      .       & siccd!=. ;
replace ShoreInd=       61      if siccd==      .       & siccd!=. ;
replace ShoreInd=       61      if floor(siccd/100)==   40      & siccd!=. ;
replace ShoreInd=       62      if floor(siccd/100)==   42      & siccd!=. ;
replace ShoreInd=       62      if siccd==      .       & siccd!=. ;
replace ShoreInd=       63      if floor(siccd/100)==   45      & siccd!=. ;
replace ShoreInd=       64      if floor(siccd/100)==   44      & siccd!=. ;
replace ShoreInd=       65      if floor(siccd/100)==   41      & siccd!=. ;
replace ShoreInd=       65      if siccd==      .       & siccd!=. ;
replace ShoreInd=       66      if floor(siccd/100)==   46      & siccd!=. ;
replace ShoreInd=       67      if floor(siccd/100)==   47      & siccd!=. ;
replace ShoreInd=       68      if floor(siccd/100)==   48      & siccd!=. ;
replace ShoreInd=       68      if siccd==      .       & siccd!=. ;
replace ShoreInd=       68      if siccd==      .       & siccd!=. ;
replace ShoreInd=       69      if floor(siccd/100)==   49      & siccd!=. ;
replace ShoreInd=       69      if siccd==      .       & siccd!=. ;
replace ShoreInd=       69      if siccd==      .       & siccd!=. ;
replace ShoreInd=       69      if siccd==      .       & siccd!=. ;
replace ShoreInd=       69      if siccd==      .       & siccd!=. ;
replace ShoreInd=       69      if siccd==      .       & siccd!=. ;
replace ShoreInd=       69      if siccd==      .       & siccd!=. ;
replace ShoreInd=       71      if floor(siccd/10)/10== 50.1    & siccd!=. ;
replace ShoreInd=       72      if floor(siccd/10)/10== 51.2    & siccd!=. ;
replace ShoreInd=       72      if floor(siccd/10)/10== 51.6    & siccd!=. ;
replace ShoreInd=       73      if floor(siccd/10)/10== 51.3    & siccd!=. ;
replace ShoreInd=       73      if floor(siccd/10)/10== 50.2    & siccd!=. ;
replace ShoreInd=       74      if floor(siccd/10)/10== 51.4    & siccd!=. ;
replace ShoreInd=       75      if floor(siccd/10)/10== 51.5    & siccd!=. ;
replace ShoreInd=       75      if siccd==      .       & siccd!=. ;
replace ShoreInd=       76      if floor(siccd/10)/10== 50.6    & siccd!=. ;
replace ShoreInd=       77      if floor(siccd/10)/10== 50.7    & siccd!=. ;
replace ShoreInd=       78      if floor(siccd/10)/10== 50.6    & siccd!=. ;
replace ShoreInd=       79      if floor(siccd/10)/10== 50.8    & siccd!=. ;
replace ShoreInd=       79      if siccd==      .       & siccd!=. ;
replace ShoreInd=       80      if floor(siccd/10)/10== 50.5    & siccd!=. ;
replace ShoreInd=       81      if floor(siccd/10)/10== 51.7    & siccd!=. ;
replace ShoreInd=       82      if floor(siccd)/100==   50.93   & siccd!=. ;
replace ShoreInd=       83      if floor(siccd/10)/10== 51.8    & siccd!=. ;
replace ShoreInd=       84      if floor(siccd/10)/10== 51.1    & siccd!=. ;
replace ShoreInd=       85      if floor(siccd/10)/10== 50.3    & siccd!=. ;
replace ShoreInd=       86      if floor(siccd/10)/10== 51.9    & siccd!=. ;
replace ShoreInd=       86      if floor(siccd)/100==   50.91   & siccd!=. ;
replace ShoreInd=       86      if floor(siccd)/100==   50.92   & siccd!=. ;
replace ShoreInd=       86      if floor(siccd)/100==   50.94   & siccd!=. ;
replace ShoreInd=       86      if floor(siccd)/100==   50.99   & siccd!=. ;
replace ShoreInd=       86      if floor(siccd/10)/10== 50.4    & siccd!=. ;
replace ShoreInd=       91      if floor(siccd/100)==   52      & siccd!=. ;
replace ShoreInd=       91      if siccd==      .       & siccd!=. ;
replace ShoreInd=       91      if siccd==      .       & siccd!=. ;
replace ShoreInd=       92      if floor(siccd/10)/10== 53.1    & siccd!=. ;
replace ShoreInd=       92      if floor(siccd/10)/10== 53.3    & siccd!=. ;
replace ShoreInd=       92      if floor(siccd/10)/10== 53.9    & siccd!=. ;
replace ShoreInd=       93      if floor(siccd/100)==   54      & siccd!=. ;
replace ShoreInd=       93      if siccd==      .       & siccd!=. ;
replace ShoreInd=       93      if siccd==      .       & siccd!=. ;
replace ShoreInd=       93      if siccd==      .       & siccd!=. ;
replace ShoreInd=       94      if floor(siccd/10)/10== 59.1    & siccd!=. ;
replace ShoreInd=       95      if siccd==      .       & siccd!=. ;
replace ShoreInd=       95      if floor(siccd/100)==   55      & siccd!=. ;
replace ShoreInd=       95      if siccd==      .       & siccd!=. ;
replace ShoreInd=       95      if siccd==      .       & siccd!=. ;
replace ShoreInd=       95      if siccd==      .       & siccd!=. ;
replace ShoreInd=       96      if floor(siccd/100)==   56      & siccd!=. ;
replace ShoreInd=       96      if siccd==      .       & siccd!=. ;
replace ShoreInd=       97      if floor(siccd/100)==   57      & siccd!=. ;
replace ShoreInd=       97      if siccd==      .       & siccd!=. ;
replace ShoreInd=       97      if siccd==      .       & siccd!=. ;
replace ShoreInd=       98      if floor(siccd/100)==   58      & siccd!=. ;
replace ShoreInd=       99      if floor(siccd/10)/10== 59.2    & siccd!=. ;
replace ShoreInd=       100     if floor(siccd/10)/10== 59.6    & siccd!=. ;
replace ShoreInd=       100     if siccd==      .       & siccd!=. ;
replace ShoreInd=       100     if siccd==      .       & siccd!=. ;
replace ShoreInd=       101     if floor(siccd/10)/10== 59.3    & siccd!=. ;
replace ShoreInd=       101     if floor(siccd/10)/10== 59.4    & siccd!=. ;
replace ShoreInd=       101     if floor(siccd/10)/10== 59.8    & siccd!=. ;
replace ShoreInd=       101     if floor(siccd/10)/10== 59.9    & siccd!=. ;
replace ShoreInd=       101     if siccd==      .       & siccd!=. ;
replace ShoreInd=       101     if siccd==      .       & siccd!=. ;
replace ShoreInd=       101     if siccd==      .       & siccd!=. ;
replace ShoreInd=       101     if siccd==      .       & siccd!=. ;
replace ShoreInd=       101     if siccd==      .       & siccd!=. ;
replace ShoreInd=       101     if siccd==      .       & siccd!=. ;
replace ShoreInd=       102     if floor(siccd/100)==   60      & siccd!=. ;
replace ShoreInd=       102     if siccd==      .       & siccd!=. ;
replace ShoreInd=       103     if floor(siccd/100)==   61      & siccd!=. ;
replace ShoreInd=       104     if floor(siccd/100)==   62      & siccd!=. ;
replace ShoreInd=       105     if floor(siccd/100)==   63      & siccd!=. ;
replace ShoreInd=       106     if floor(siccd/100)==   65      & siccd!=. ;
replace ShoreInd=       107     if floor(siccd/100)==   67      & siccd!=. ;
replace ShoreInd=       111     if floor(siccd/100)==   73      & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       111     if siccd==      .       & siccd!=. ;
replace ShoreInd=       112     if floor(siccd/100)==   75      & siccd!=. ;
replace ShoreInd=       112     if siccd==      .       & siccd!=. ;
replace ShoreInd=       112     if siccd==      .       & siccd!=. ;
replace ShoreInd=       113     if floor(siccd/100)==   76      & siccd!=. ;
replace ShoreInd=       113     if siccd==      .       & siccd!=. ;
replace ShoreInd=       113     if siccd==      .       & siccd!=. ;
replace ShoreInd=       114     if floor(siccd/100)==   88      & siccd!=. ;
replace ShoreInd=       115     if floor(siccd/100)==   70      & siccd!=. ;
replace ShoreInd=       115     if siccd==      .       & siccd!=. ;
replace ShoreInd=       116     if floor(siccd/100)==   72      & siccd!=. ;
replace ShoreInd=       116     if siccd==      .       & siccd!=. ;
replace ShoreInd=       116     if siccd==      .       & siccd!=. ;
replace ShoreInd=       116     if siccd==      .       & siccd!=. ;
replace ShoreInd=       116     if siccd==      .       & siccd!=. ;
replace ShoreInd=       116     if siccd==      .       & siccd!=. ;
replace ShoreInd=       116     if siccd==      .       & siccd!=. ;
replace ShoreInd=       117     if floor(siccd/100)==   78      & siccd!=. ;
replace ShoreInd=       117     if siccd==      .       & siccd!=. ;
replace ShoreInd=       118     if floor(siccd/100)==   79      & siccd!=. ;
replace ShoreInd=       118     if siccd==      .       & siccd!=. ;
replace ShoreInd=       118     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if floor(siccd/100)==   80      & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       119     if siccd==      .       & siccd!=. ;
replace ShoreInd=       120     if floor(siccd/100)==   81      & siccd!=. ;
replace ShoreInd=       121     if floor(siccd/100)==   82      & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       121     if siccd==      .       & siccd!=. ;
replace ShoreInd=       122     if floor(siccd/100)==   84      & siccd!=. ;
replace ShoreInd=       123     if floor(siccd/100)==   83      & siccd!=. ;
replace ShoreInd=       123     if siccd==      .       & siccd!=. ;
replace ShoreInd=       123     if siccd==      .       & siccd!=. ;
replace ShoreInd=       124     if floor(siccd/100)==   86      & siccd!=. ;
replace ShoreInd=       124     if siccd==      .       & siccd!=. ;
replace ShoreInd=       125     if floor(siccd/100)==   87      & siccd!=. ;
replace ShoreInd=       125     if siccd==      .       & siccd!=. ;
replace ShoreInd=       125     if siccd==      .       & siccd!=. ;
replace ShoreInd=       126     if floor(siccd/100)==   89      & siccd!=. ;
replace ShoreInd=       126     if siccd==      .       & siccd!=. ;
replace ShoreInd=       126     if siccd==      .       & siccd!=. ;
replace ShoreInd=       127     if floor(siccd/100)==   43      & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   91      & siccd!=. ;
replace ShoreInd=       128     if siccd==      .       & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   92      & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   93      & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   94      & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   95      & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   96      & siccd!=. ;
replace ShoreInd=       128     if floor(siccd/100)==   97      & siccd!=. ;
replace ShoreInd=       128     if siccd==      .       & siccd!=. ;
replace ShoreInd=       128     if siccd==      .       & siccd!=. ;
replace ShoreInd=       129     if floor(siccd/100)==   99      & siccd!=. ;
replace ShoreInd=       129     if siccd==      .       & siccd!=. ;
replace ShoreInd=       129     if siccd==      .       & siccd!=. ;
replace ShoreInd=       129     if siccd==      .       & siccd!=. ;
replace ShoreInd=       129     if siccd==      .       & siccd!=. ;
replace ShoreInd=       129     if siccd==      .       & siccd!=. ;
replace ShoreInd=       129     if siccd==      .       & siccd!=. ;

replace ShoreInd=. if siccd==0 | siccd==.;



save "$startdir/$outputdata/stockinddatatemp.dta", replace;

use "$startdir/$outputdata/stockinddatatemp.dta", clear;



label variable ShoreInd "Shore's standardized industry codes";
label define ShoreIndlblb       1       "       Agricultural Production Crops   ", add;
label define ShoreIndlblb       2       "       Agriculture production livestock and animal specialties ", add;
label define ShoreIndlblb       3       "       Agricultural Services   ", add;
label define ShoreIndlblb       4       "       Forestry        ", add;
label define ShoreIndlblb       5       "       Fishing, hunting, and trapping  ", add;
label define ShoreIndlblb       11      "       Metal mining    ", add;
label define ShoreIndlblb       12      "       Coal mining     ", add;
label define ShoreIndlblb       13      "       Crude petroleum and natural gas extractions     ", add;
label define ShoreIndlblb       14      "       Nonmetallic mining and quarrying, except fuel   ", add;
label define ShoreIndlblb       21      "       Construction    ", add;
label define ShoreIndlblb       31      "       Manufacturing, durable, Lumber and wood products        ", add;
label define ShoreIndlblb       33      "       Manufacturing, durable, metal   ", add;
label define ShoreIndlblb       34      "       Manufacturing, durable, machinery       ", add;
label define ShoreIndlblb       35      "       Manufacturing, durable, electrical      ", add;
label define ShoreIndlblb       36      "       Manufacturing, durable, transportation equipment        ", add;
label define ShoreIndlblb       37      "       Manufacturing, durable, measurement equipment   ", add;
label define ShoreIndlblb       41      "       Manufacturing, nondurable, meat ", add;
label define ShoreIndlblb       42      "       Manufacturing, nondurable, dairy        ", add;
label define ShoreIndlblb       43      "       Manufacturing, nondurable, canned       ", add;
label define ShoreIndlblb       44      "       Manufacturing, nondurable, Grain-mill products                  ", add;
label define ShoreIndlblb       45      "       Manufacturing, nondurable, Bakery products                      ", add;
label define ShoreIndlblb       46      "       Manufacturing, nondurable, Confectionery and related products   ", add;
label define ShoreIndlblb       47      "       Manufacturing, nondurable, Beverage industries  ", add;
label define ShoreIndlblb       48      "       Manufacturing, nondurable, tobacco      ", add;
label define ShoreIndlblb       49      "       Manufacturing, nondurable, other food   ", add;
label define ShoreIndlblb       50      "       Manufacturing, textiles ", add;
label define ShoreIndlblb       51      "       Manufacturing, apparel  ", add;
label define ShoreIndlblb       52      "       Manufacturing, paper    ", add;
label define ShoreIndlblb       53      "       Manufacturing, printing ", add;
label define ShoreIndlblb       54      "       Manufacturing, chemicals        ", add;
label define ShoreIndlblb       55      "       Manufacturing, petroleum        ", add;
label define ShoreIndlblb       56      "       Manufacturing, rubber   ", add;
label define ShoreIndlblb       57      "       Manufacturing, leather  ", add;
label define ShoreIndlblb       58      "       Manufacturing, other    ", add;
label define ShoreIndlblb       61      "       Transportation, rail    ", add;
label define ShoreIndlblb       62      "       Transportation, trucking and storage    ", add;
label define ShoreIndlblb       63      "       Transportation, air     ", add;
label define ShoreIndlblb       64      "       Transportation, water   ", add;
label define ShoreIndlblb       65      "       Transportation, bus, taxi, public transit       ", add;
label define ShoreIndlblb       66      "       Transportation, pipelines       ", add;
label define ShoreIndlblb       67      "       Transportation, services        ", add;
label define ShoreIndlblb       68      "       Communications  ", add;
label define ShoreIndlblb       69      "       Utilities       ", add;
label define ShoreIndlblb       71      "       Wholesale, motor vehicles       ", add;
label define ShoreIndlblb       72      "       Wholesale, drugs and chemicals  ", add;
label define ShoreIndlblb       73      "       Wholesale, Dry goods and apparel                                                ", add;
label define ShoreIndlblb       74      "       Wholesale, Food and related products                                            ", add;
label define ShoreIndlblb       75      "       Wholesale, Farm products--raw materials                                         ", add;
label define ShoreIndlblb       76      "       Wholesale, Electrical goods                                                     ", add;
label define ShoreIndlblb       77      "       Wholesale, Hardware, plumbing, and heating supplies                             ", add;
label define ShoreIndlblb       78      "       Wholesale, Electrical and hardware products, n.s.                               ", add;
label define ShoreIndlblb       79      "       Wholesale, Machinery equipment and supplies                                     ", add;
label define ShoreIndlblb       80      "       Wholesale, Metals and minerals, n.e.c.                                          ", add;
label define ShoreIndlblb       81      "       Wholesale, Petroleum products                                                   ", add;
label define ShoreIndlblb       82      "       Wholesale, Scrap and waste materials                                            ", add;
label define ShoreIndlblb       83      "       Wholesale, Alcoholic beverages                                                  ", add;
label define ShoreIndlblb       84      "       Wholesale, Paper and its products                                               ", add;
label define ShoreIndlblb       85      "       Wholesale, Lumber and construction materials                                    ", add;
label define ShoreIndlblb       86      "       Wholesale, misc ", add;
label define ShoreIndlblb       91      "       Retail, hardware, lumber, and building  ", add;
label define ShoreIndlblb       92      "       Retail, department and general stores   ", add;
label define ShoreIndlblb       93      "       Retail, food    ", add;
label define ShoreIndlblb       94      "       Retail, liquor  ", add;
label define ShoreIndlblb       95      "       Retail, auto    ", add;
label define ShoreIndlblb       96      "       Retail, apparel ", add;
label define ShoreIndlblb       97      "       Retail, home furnishings        ", add;
label define ShoreIndlblb       98      "       Retail, restaurants and bars    ", add;
label define ShoreIndlblb       99      "       Retail, drug stores     ", add;
label define ShoreIndlblb       100     "       Retail, Nonstore Retailers      ", add;
label define ShoreIndlblb       101     "       Retail, other   ", add;
label define ShoreIndlblb       102     "       Finance, banks  ", add;
label define ShoreIndlblb       103     "       Finance, credit ", add;
label define ShoreIndlblb       104     "       Finance, securities, brokers, and dealers       ", add;
label define ShoreIndlblb       105     "       Finance, insurance      ", add;
label define ShoreIndlblb       106     "       Fiannce, real estate    ", add;
label define ShoreIndlblb       107     "       Finance, other  ", add;
label define ShoreIndlblb       111     "       Services, business      ", add;
label define ShoreIndlblb       112     "       Services, auto  ", add;
label define ShoreIndlblb       113     "       Services, repair        ", add;
label define ShoreIndlblb       114     "       Services, private household     ", add;
label define ShoreIndlblb       115     "       Services, lodging       ", add;
label define ShoreIndlblb       116     "       Services, personal      ", add;
label define ShoreIndlblb       117     "       Services, movies        ", add;
label define ShoreIndlblb       118     "       Services, non-movie entertainment       ", add;
label define ShoreIndlblb       119     "       Services, health        ", add;
label define ShoreIndlblb       120     "       Services, legal ", add;
label define ShoreIndlblb       121     "       Services, education     ", add;
label define ShoreIndlblb       122     "       Services, Museums, art galleries, and zoos              ", add;
label define ShoreIndlblb       123     "       Services, religious and social service  ", add;
label define ShoreIndlblb       124     "       Services, Membership Organizations      ", add;
label define ShoreIndlblb       125     "       Services, Engineering, Accounting, Research, Management, And Related Services           ", add;
label define ShoreIndlblb       126     "       Services, other ", add;
label define ShoreIndlblb       127     "       Services, postal        ", add;
label define ShoreIndlblb       128     "       Government      ", add;
label define ShoreIndlblb       129     "       unclassified workers or firms   ", add;

label values ShoreInd ShoreIndlbl;


save "$startdir/$outputdata/stockinddatatemp.dta", replace;


use "$startdir/$outputdata/stockinddatatemp.dta", replace;



generate datestring = date(date, "MDY");
gen year=year(datestring);
gen month=month(datestring);
drop date datestring;
recast int year;
recast int month;
recast int permno;

gen mktcap=shrout*abs(prc);
replace mktcap=shrout*abs(altprc) if prc==.;
drop prc altprc;
sort permno year month;
by permno: gen lagmktcap=mktcap[_n-1]
        if (year==year[_n-1] & month-1==month[_n-1]) | (year-1==year[_n-1] & month==1 & month[_n-1]==12) ;

gen R=1+ret if ret!=.;
replace R=(1+dlret) if ret==. & dlret!=.;
replace R=(1-.99) if R>=-1 & R<=-.99 & R!=.;
replace R=. if R<-1;
replace R=(1-.99) if dlret>=-1 & dlret<=-.99 & dlret!=.;
replace R=. if dlret<-1  & dlret!=.;

replace R=. if ShoreInd>=120 & ShoreInd<=130;
gen lnR=ln(R);
gen lnR2=ln(R)*ln(R);
drop ret dlret ;



gen insample=0;
replace insample=1 if  lnR!=. & lagmktcap!=. & ShoreInd!=0 & ShoreInd!=.;

sort ShoreInd year month;
save "$startdir/$outputdata/stockinddatatempb.dta", replace;


use "$startdir/$outputdata/stockinddatatempb.dta", replace;
sort year month;
save "$startdir/$outputdata/stockinddatatempb.dta", replace;

use "$startdir/$inputdata/ir.dta", replace;
generate datestring = date(date, "MDY");
gen year=year(datestring);
gen month=month(datestring);
drop date datestring;
recast int year;
recast int month;
sort year month;
merge year month using "$startdir/$outputdata/stockinddatatempb.dta";

gen Rweight=R*lagmktcap;
sort year month;
egen Rmkt=sum(Rweight), by(year month);
egen mktsum=sum(lagmktcap) if R!=., by(year month);
gen lnRmkt=ln(Rmkt/mktsum);


*if you want to double-collapse by month and then average over months;
collapse lnR lnR2 lnRmkt ir=rmgbs_a_ (count) Nstocks=lnR (rawsum) mktcap=lagmktcap [aweight=lagmktcap] if insample==1, by(ShoreInd year month);
sort ShoreInd year;

save "$startdir/$outputdata/stockinddatatempc.dta", replace;

use "$startdir/$outputdata/stockinddatatempc.dta";


gen eR=exp(lnR)-ir/100;
gen eRmkt=exp(lnRmkt)-ir/100;
gen se=.;
gen beta=.;
local i=1;
while `i' <=130 {;
        display(`i');
        quietly count if ShoreInd==`i' & eR!=.;
        local itemp= r(N) ;
        quietly if `itemp'>12{;
        reg eR eRmkt if ShoreInd==`i';
         matrix b=get(_b);
         matrix VCE=get(VCE);
         svmat b , names(indbeta); drop indbeta2;

         svmat VCE , names(indVCE); drop indVCE2;
         egen indV=max(indVCE1) ;
         egen beta1=max(indbeta1);
         replace beta=beta1  if ShoreInd==`i';
         replace se=indV^.5  if ShoreInd==`i';
         drop indV indVCE1;
        drop indbeta1 beta1;
        };

        local i=`i'+1;
};
         tab ShoreInd, sum(beta);



drop if N==0 | lnR==.;
replace mktcap=0 if month!=1;
collapse (mean) beta se (sum) lnR (sum) lnR2 (sum) Nstocks (max) mktcap , by(ShoreInd year);


/* if you want to single-collapse;
sort ShoreInd year;
collapse lnR lnR2 (count) Nstocks=lnR (rawsum) mktcap=lagmktcap  [aweight=lagmktcap] if insample==1, by(ShoreInd year);
*/

replace Nstocks=Nstocks/12;
replace lnR2 =lnR2 /12;


fillin ShoreInd year;
drop _fillin;
sort ShoreInd year;


save "$startdir/$outputdata/stockinddata.dta", replace;

erase "$startdir/$outputdata/stockinddatatemp.dta";
erase "$startdir/$outputdata/stockinddatatempb.dta";
erase "$startdir/$outputdata/stockinddatatempc.dta";



