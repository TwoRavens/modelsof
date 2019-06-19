
*************************************/
* educ95.do
* Empirical Analsysis for: * Crossley, T.F., and H. Low, “Job Loss, Credit Constraints and Consumption Growth.” Review of Economics and Statistics, 96(5):876-884 (December, 2014.) 
* Contact: tfcrossley@gmail.com or tcross@esex.ac.uk
* this program is called by cl_data.do
* this program generates education variables
* last revised 2014
**************************************

set more 1
#delimit;

**********************************;;
* FIRST SET - 4 categories;

*less than high school;

g byte elem=0;
replace elem=1 if youredn1==1|youredn1==2|youredn1==3|youredn1==4;
replace elem=. if youredn1==.;

*High school;

g byte hgh=0;
replace hgh=1 if youredn1==5|youredn1==6|youredn1==8;
replace hgh=. if youredn1==.;

*Post secondary;

g byte unicol=0;
replace unicol=1 if youredn1==7|youredn1==9;
replace unicol=. if youredn1==.;

*Trade school;

g byte trade=0;
replace trade=1 if youredn1==10;
replace trade=. if youredn1==.;

sum elem trade hgh unicol;
*drop elem trade hgh unicol;
exit;
*************************************/ ;
* Second expanded set to match 93 based on Arthurs owned93.do;

**NOTE there are new categories and some of the categories
disappeared - have to decide how to match!;


* 1993 dummies;
* elem, s_hs (some hs), hs_grad, trade, scollege, college;
* s_univ (some univ), undr_grd, profcert, post_grd;

* 1995 dummies;
* no_ed, selem (some elem),elem, s_hs (some hs), hs_grad, trade, scollege, college;
* s_univ (some univ), undr_grd;


* creating blank to set all vars equal to initially;
g b=0                                              ;
replace b=. if youredn1 >90 | youredn1==.          ;

g no_ed=b                                          ;
replace no_ed =1  if youredn1==1                         ;

g selem= b                                          ;

replace selem=1 if youredn1 ==2                 ;
g elem= b                                       ;
replace elem=1 if youredn1 ==3                  ;
g hs_grad =b                                    ;
replace hs_grad = 1 if youredn1==5              ;
g s_hs =b                                       ;
replace s_hs=1 if youredn1==4                   ;
g trade=b                                       ;
replace trade=1 if youredn1==10                 ;
g scollege =b                                   ;
replace scollege=1 if youredn1==6               ;
g college=b                                     ;
replace college=1 if youredn1==7                ;
g s_univ=b                                      ;
replace s_univ= 1 if youredn1==8                ;
g undr_grd=b                                    ;
replace undr_grd=1 if youredn1==9               ;
*;
drop b youredn1;

*log close;
*;
