*! version 1.0 14/10/2008
*! version 1.1 26/05/2009

/*
////////////////////////////////////////////////////////////////////////
     Recodes ISCO88 Codes into ESeC scheme

     Daniel Stegmueller
     d.stegmueller@gmail.com
///////////////////////////////////////////////////////////////////////
    Arguments:
    isco   -> ISCO88 codes, 4-digits
    sv     -> Supervision of people: 1 yes 0 no
    sempl  -> 1 if self employed, else 0
    emplno -> number of employees, all NA DK etc must be -1
//////////////////////////////////////////////////////////////////////
   Class assignment matrix from:
   see: http://www.iser.essex.ac.uk/esec/consort/matrices/
*/


capture program drop isco2esec
program define isco2esec
version 10
syntax newvarname, isco(varname numeric) sv(varname numeric) sempl(varname numeric) emplno (varname numeric)

tempvar sv_tmp 
tempvar isco_tmp
tempvar sempl_tmp
tempvar emplno_tmp
tempvar empstat

qui gen `isco_tmp' = `isco'
qui gen `sv_tmp' = `sv'
qui gen `sempl_tmp' = `sempl'
qui gen `emplno_tmp' = `emplno'


//convert to three digits isco codes
#delimit ;
qui recode `isco_tmp'
(1110=111) (1140 / 1143=114) (1200=120) (1210=121) (1221 / 1229=122) (1231 / 1239=123)
(1300=130) (1311 / 1319 =131) (2110 / 2114=211) (2121 / 2122 =212) (2130 / 2139=213) (2140 / 2149=214) (2211 / 2213=221) (2221 / 2229=222) (2310=231) (2320=232) (2330 / 2332=233) (2340 =234) (2351 / 2359=235) (2411 / 2419=241) (2420 / 2429=242) (2430 / 2432=243) (2440 / 2446=244) (2451 / 2455=245) (2460=246) (2470=247)
(3110 / 3119=311) (3120 / 3123=312) (3131 / 3139=313) (3141 / 3145=314) (3151 / 3152=315) (3210 / 3213=321)
(3220 / 3229=322) (3231 / 3232=323) (3310=331) (3320=332) (3330=333) (3340=334) (3411 / 3419=341) (3421 / 3429=342) (3431 / 3439=343) (3441 / 3449=344) (3450=345) (3460=346) (3470 / 3475=347) (3480=348) (4000=400) 
(4110 / 4115=411) (4120 / 4122=412) (4131 / 4133=413) (4141 / 4144=414) (4190=419) (4210 / 4215=421) (4220 / 4223=422) (5110 / 5113=511) (5121 / 5123=512) (5131 / 5139=513) (5141 / 5149=514) (5161 / 5169=516) (5210=521) (5220=522) (6100=610) (6111 / 6112=611) (6121 / 6129=612) (6130=613) (6141 / 6142=614) (6150 / 6154=615)
(7000=700) (7100=710) (7111 / 7113=711) (7121 / 7129=712) (7131 / 7139=713) (7141 / 7143=714) (7200=720)(7211 / 7216=721) (7221 / 7224=722) (7230 / 7233=723) (7241 / 7245=724) (7300=730) (7311 / 7313=731) (7320 / 7324=732) (7330 / 7332=733) (7341 / 7346=734) (7400=740) (7411 / 7416=741) (7421 / 7424=742) (7430 / 7437=743) (7441 / 7442=744) (8100=810) (8111 / 8113=811) (8120 / 8124=812) (8130 / 8139=813) (8140 / 8143=814) (8150 / 8159=815) (8160 / 8163=816) (8170=817) (8211 / 8212=821) (8221 / 8229=822)  (8231 / 8232=823) (8240=824) (8251 / 8253=825) (8260 / 8269=826) (8270 / 8279=827) (8280 / 8287=828) (8290=829) (8311 / 8312=831) (8321 / 8324=832) (8330 / 8334=833) (8340=834) (9000=900) (9111 / 9113=911) (9120=912) (9130 / 9133=913)(9141 / 9142=914) (9150 / 9153=915) (9161 / 9162=916) (9210 / 9213=921) (9311 / 9313=931) (9320=932) (9330=933) (100=100) (110=110)
(else=.);
#delimit cr


// number of employees 
// 0 none 1 <10 2 >=10 
qui recode `emplno_tmp' (0=0) (1/9=1) (10/6000=2) (-1=9) (else=.)

// Employment Status
qui gen `empstat' = .
qui replace `empstat' = 1 if `sempl_tmp' == 1 & `emplno_tmp' == 2
qui replace `empstat' = 2 if `sempl_tmp' == 1 & `emplno_tmp' == 1
qui replace `empstat' = 3 if `sempl_tmp' == 1 & `emplno_tmp' == 0
qui replace `empstat' = 3 if `sempl_tmp' == 1 & `emplno_tmp' == 9
qui replace `empstat' = 4 if `sempl_tmp' == 0 & `sv_tmp' == 1
qui replace `empstat' = 5 if `sempl_tmp' == 0 & `sv_tmp' == 0


//Assigning esec values by isco codes
#delimit ;
qui gen `varlist'=.;

// Employers with 10+ empl;
qui replace `varlist' = 1 if `empstat' == 1;
qui replace `varlist' = 2 if (`isco_tmp' == 344 | `isco_tmp' == 345) & `empstat' == 1;
qui replace `varlist' = 3 if (`isco_tmp' == 011 | `isco_tmp' == 516) & `empstat' == 1;
qui replace `varlist' = 5 if `isco_tmp' == 621  & `empstat' == 1;


// employers with <10 empl;
qui replace `varlist' = 4 if `empstat' == 2;

qui replace `varlist' = 1 if (`isco_tmp'==010|`isco_tmp'== 110|`isco_tmp'== 111|`isco_tmp'== 114|`isco_tmp'== 200|`isco_tmp'== 210|`isco_tmp'== 211|`isco_tmp'== 212|`isco_tmp'== 213|`isco_tmp'== 214|`isco_tmp'== 220|`isco_tmp'== 221|`isco_tmp'== 222|`isco_tmp'== 231|`isco_tmp'== 235|`isco_tmp'== 240|`isco_tmp'== 241|`isco_tmp'== 242) & `empstat'==2;

qui replace `varlist' = 2 if (`isco_tmp'==223|`isco_tmp'== 230|`isco_tmp'== 232|`isco_tmp'== 233|`isco_tmp'== 234|`isco_tmp'== 243|`isco_tmp'== 244|`isco_tmp'== 245|`isco_tmp'== 246|`isco_tmp'== 247|`isco_tmp'== 310|`isco_tmp'== 311|`isco_tmp'== 312|`isco_tmp'== 314|`isco_tmp'== 320|`isco_tmp'== 321|`isco_tmp'== 322|`isco_tmp'== 323|`isco_tmp'== 334|`isco_tmp'== 342|`isco_tmp'== 344|`isco_tmp'== 345|`isco_tmp'== 348) & `empstat' == 2;

qui replace `varlist' = 3 if (`isco_tmp'==011|`isco_tmp'== 516) & `empstat' == 2;

qui replace `varlist' = 5 if (`isco_tmp'==600|`isco_tmp'== 610|`isco_tmp'== 611|`isco_tmp'== 612|`isco_tmp'== 613|`isco_tmp'== 614|`isco_tmp'== 615|`isco_tmp'== 621|`isco_tmp'== 920|`isco_tmp'== 921) & `empstat' == 2;

dis as res "Don't panic ...." ;

//employers no empl.;
qui replace `varlist' = 4 if `empstat' == 3;

qui replace `varlist' = 1 if (`isco_tmp'==010|`isco_tmp'==110|`isco_tmp'==111|`isco_tmp'==114|`isco_tmp'==200|`isco_tmp'==210|`isco_tmp'==211|`isco_tmp'==212|`isco_tmp'==213|`isco_tmp'==214|`isco_tmp'==220|`isco_tmp'==221|`isco_tmp'==222|`isco_tmp'==231|`isco_tmp'==235|`isco_tmp'==240|`isco_tmp'==241|`isco_tmp'==242) & `empstat' == 3;

qui replace `varlist' = 2 if (`isco_tmp'==223|`isco_tmp'==230|`isco_tmp'==232|`isco_tmp'==233|`isco_tmp'==234|`isco_tmp'==243|`isco_tmp'==244|`isco_tmp'==245|`isco_tmp'==246|`isco_tmp'==247|`isco_tmp'==310|`isco_tmp'==311|`isco_tmp'==312|`isco_tmp'==314|`isco_tmp'==320|`isco_tmp'==321|`isco_tmp'==322|`isco_tmp'==323|`isco_tmp'==334|`isco_tmp'==342|`isco_tmp'==344|`isco_tmp'==345|`isco_tmp'==348) & `empstat' == 3;

qui replace `varlist' = 3 if (`isco_tmp'==011|`isco_tmp'==516) & `empstat' == 3;

qui replace `varlist' = 5 if (`isco_tmp'==600|`isco_tmp'==610|`isco_tmp'==611|`isco_tmp'==612|`isco_tmp'==613|`isco_tmp'==614|`isco_tmp'==615|`isco_tmp'==621|`isco_tmp'==920|`isco_tmp'==921) & `empstat' == 3;


//supervisors;
qui replace `varlist' = 6 if `empstat' == 4;

qui replace `varlist' = 1 if (`isco_tmp'==010|`isco_tmp'== 100|`isco_tmp'== 110|`isco_tmp'== 111|`isco_tmp'== 114|`isco_tmp'== 120|`isco_tmp'== 121|`isco_tmp'== 123|`isco_tmp'== 200|`isco_tmp'== 210|`isco_tmp'== 211|`isco_tmp'== 212|`isco_tmp'== 213|`isco_tmp'== 214|`isco_tmp'== 220|`isco_tmp'== 221|`isco_tmp'== 222|`isco_tmp'== 231|`isco_tmp'== 235|`isco_tmp'== 240|`isco_tmp'== 241|`isco_tmp'== 242) & `empstat'==4;

qui replace `varlist' = 2 if (`isco_tmp'==011|`isco_tmp'== 122|`isco_tmp'== 130|`isco_tmp'==131|`isco_tmp'== 223|`isco_tmp'== 230|`isco_tmp'== 232|`isco_tmp'== 233|`isco_tmp'== 234|`isco_tmp'== 243|`isco_tmp'== 244|`isco_tmp'== 245|`isco_tmp'== 246|`isco_tmp'== 247|`isco_tmp'== 300|`isco_tmp'== 310|`isco_tmp'== 311|`isco_tmp'== 312|`isco_tmp'== 313|`isco_tmp'== 314|`isco_tmp'== 320|`isco_tmp'== 321|`isco_tmp'== 322|`isco_tmp'== 323|`isco_tmp'== 330|`isco_tmp'== 331|`isco_tmp'== 332|`isco_tmp'== 333|`isco_tmp'== 334|`isco_tmp'== 340|`isco_tmp'== 
341|`isco_tmp'== 342|`isco_tmp'== 343|`isco_tmp'== 344|`isco_tmp'== 345|`isco_tmp'== 346|`isco_tmp'== 347|`isco_tmp'== 348|`isco_tmp'== 400|`isco_tmp'== 410|`isco_tmp'== 411|`isco_tmp'== 412|`isco_tmp'== 419|`isco_tmp'== 420|`isco_tmp'== 521) & `empstat' == 4;


qui replace `varlist' = 5 if `isco_tmp'==621 & `empstat'==4;

//employees;

qui replace `varlist'=1 if (`isco_tmp'==010|`isco_tmp'== 100|`isco_tmp'==110|`isco_tmp'==111|`isco_tmp'==114|`isco_tmp'==120|`isco_tmp'== 121|`isco_tmp'== 123|`isco_tmp'== 200|`isco_tmp'== 210|`isco_tmp'== 211|`isco_tmp'== 212|`isco_tmp'== 213|`isco_tmp'== 214|`isco_tmp'== 220|`isco_tmp'== 221|`isco_tmp'== 222|`isco_tmp'== 231|`isco_tmp'== 235|`isco_tmp'== 240|`isco_tmp'== 241|`isco_tmp'== 242) & `empstat'==5;

qui replace `varlist'=2 if (`isco_tmp'==122|`isco_tmp'==130|`isco_tmp'==131|`isco_tmp'== 223|`isco_tmp'== 230|`isco_tmp'== 232|`isco_tmp'== 233|`isco_tmp'== 234|`isco_tmp'== 243|`isco_tmp'== 244|`isco_tmp'== 245|`isco_tmp'== 246|`isco_tmp'== 247|`isco_tmp'== 310|`isco_tmp'== 311|`isco_tmp'== 312|`isco_tmp'== 314|`isco_tmp'== 320|`isco_tmp'== 321|`isco_tmp'== 322|`isco_tmp'== 323|`isco_tmp'== 334|`isco_tmp'== 
342|`isco_tmp'== 344|`isco_tmp'== 345|`isco_tmp'== 348|`isco_tmp'== 521) & `empstat'==5;

qui replace `varlist'=3 if (`isco_tmp'==011|`isco_tmp'== 300|`isco_tmp'== 330|`isco_tmp'== 331|`isco_tmp'== 332|`isco_tmp'== 333|`isco_tmp'== 340|`isco_tmp'== 341|`isco_tmp'== 343|`isco_tmp'== 346|`isco_tmp'== 347|`isco_tmp'== 400|`isco_tmp'== 410|`isco_tmp'== 411|`isco_tmp'== 412|`isco_tmp'== 419|`isco_tmp'== 420) & `empstat'==5;

qui replace `varlist'=5 if `isco_tmp'==621 & `empstat'==5;

qui replace `varlist'=6 if (`isco_tmp'==313|`isco_tmp'== 315|`isco_tmp'== 730|`isco_tmp'==731) & `empstat'==5;

qui replace `varlist'=7 if (`isco_tmp'==413|`isco_tmp'== 421|`isco_tmp'== 422|`isco_tmp'== 500|`isco_tmp'== 510|`isco_tmp'== 511|`isco_tmp'== 513|`isco_tmp'== 514|`isco_tmp'== 516|`isco_tmp'== 520|`isco_tmp'== 522|`isco_tmp'== 911) & `empstat'==5;

qui replace `varlist'=8 if (`isco_tmp'==600|`isco_tmp'== 610|`isco_tmp'== 611|`isco_tmp'== 612|`isco_tmp'== 613|`isco_tmp'== 614|`isco_tmp'== 615|`isco_tmp'== 700|`isco_tmp'== 710|`isco_tmp'== 711|`isco_tmp'== 712|`isco_tmp'== 713|`isco_tmp'== 714|`isco_tmp'== 720|`isco_tmp'== 721|`isco_tmp'== 722|`isco_tmp'== 723|`isco_tmp'== 724|`isco_tmp'== 732|`isco_tmp'== 733|`isco_tmp'== 734|`isco_tmp'== 740|`isco_tmp'== 741|`isco_tmp'== 742|`isco_tmp'== 743|`isco_tmp'== 744|`isco_tmp'== 
825|`isco_tmp'== 831|`isco_tmp'== 834) & `empstat'==5;

qui replace `varlist'=9 if (`isco_tmp'==414|`isco_tmp'== 512|`isco_tmp'== 800|`isco_tmp'== 810|`isco_tmp'== 811|`isco_tmp'==  812|`isco_tmp'== 813|`isco_tmp'== 814|`isco_tmp'== 815|`isco_tmp'== 816|`isco_tmp'== 817|`isco_tmp'== 820|`isco_tmp'== 821|`isco_tmp'== 822|`isco_tmp'== 823|`isco_tmp'== 824|`isco_tmp'== 826|`isco_tmp'== 827|`isco_tmp'== 828|`isco_tmp'== 829|`isco_tmp'== 830|`isco_tmp'== 832|`isco_tmp'== 833|`isco_tmp'==
900|`isco_tmp'== 910|`isco_tmp'== 912|`isco_tmp'== 913|`isco_tmp'== 914|`isco_tmp'== 915|`isco_tmp'== 916|`isco_tmp'== 920|`isco_tmp'== 921|`isco_tmp'== 930|`isco_tmp'== 931|`isco_tmp'== 932|`isco_tmp'== 933) & `empstat' == 5;



// no employment status given

qui replace `varlist' = 1 if (`isco_tmp'==010|`isco_tmp'== 100|`isco_tmp'==110|`isco_tmp'==111|`isco_tmp'==114|`isco_tmp'== 120|`isco_tmp'==121|`isco_tmp'==123|`isco_tmp'== 200|`isco_tmp'== 210|`isco_tmp'== 211|`isco_tmp'== 212|`isco_tmp'== 213|`isco_tmp'== 214|`isco_tmp'== 220|`isco_tmp'== 221|`isco_tmp'== 222|`isco_tmp'== 231|`isco_tmp'== 235|`isco_tmp'== 240|`isco_tmp'== 241|`isco_tmp'== 242) & `empstat' == . ;

qui replace `varlist' = 2 if (`isco_tmp'==122|`isco_tmp'== 223|`isco_tmp'== 230|`isco_tmp'== 232|`isco_tmp'== 233|`isco_tmp'== 234|`isco_tmp'== 243|`isco_tmp'== 244|`isco_tmp'== 245|`isco_tmp'== 246|`isco_tmp'== 247|`isco_tmp'== 310|`isco_tmp'== 311|`isco_tmp'==312|`isco_tmp'== 314|`isco_tmp'== 320|`isco_tmp'== 321|`isco_tmp'== 322|`isco_tmp'== 323|`isco_tmp'== 334|`isco_tmp'== 342|`isco_tmp'== 344|`isco_tmp'== 345|`isco_tmp'== 348|`isco_tmp'== 521) & `empstat' == . ;

qui replace `varlist' = 3 if (`isco_tmp'==011|`isco_tmp'==300|`isco_tmp'== 330|`isco_tmp'== 331|`isco_tmp'== 332|`isco_tmp'== 333|`isco_tmp'== 340|`isco_tmp'== 341|`isco_tmp'== 343|`isco_tmp'== 346|`isco_tmp'== 347|`isco_tmp'== 400|`isco_tmp'== 410|`isco_tmp'== 411|`isco_tmp'== 412|`isco_tmp'== 419|`isco_tmp'== 420) & `empstat' == . ;

qui replace `varlist' = 4 if (`isco_tmp'==130|`isco_tmp'== 131|`isco_tmp'== 911) & `empstat' == . ;

qui replace `varlist' = 5 if (`isco_tmp'==600|`isco_tmp'== 610|`isco_tmp'== 611|`isco_tmp'== 612|`isco_tmp'== 613|`isco_tmp'== 621) & `empstat' == . ;

qui replace `varlist' = 6 if (`isco_tmp'==313|`isco_tmp'== 315|`isco_tmp'== 730|`isco_tmp'==731) & `empstat' == . ;

qui replace `varlist' = 7 if (`isco_tmp'==413|`isco_tmp'== 421|`isco_tmp'== 422|`isco_tmp'== 500|`isco_tmp'== 510|`isco_tmp'== 511|`isco_tmp'== 513|`isco_tmp'== 514|`isco_tmp'== 516|`isco_tmp'== 520|`isco_tmp'== 522) & `empstat' == . ;

qui replace `varlist' = 8 if (`isco_tmp'==614|`isco_tmp'== 615|`isco_tmp'== 700|`isco_tmp'== 710|`isco_tmp'== 711|`isco_tmp'== 712|`isco_tmp'== 713|`isco_tmp'== 714|`isco_tmp'== 720|`isco_tmp'== 721|`isco_tmp'== 722|`isco_tmp'== 723|`isco_tmp'== 724|`isco_tmp'== 732|`isco_tmp'== 733|`isco_tmp'== 734|`isco_tmp'== 740|`isco_tmp'== 741|`isco_tmp'== 742|`isco_tmp'== 743|`isco_tmp'== 744|`isco_tmp'== 825|`isco_tmp'== 831|`isco_tmp'== 834)  & `empstat' == . ;

qui replace `varlist' = 9 if (`isco_tmp'==414|`isco_tmp'== 512|`isco_tmp'== 800|`isco_tmp'== 810|`isco_tmp'== 811|`isco_tmp'== 811|`isco_tmp'== 812|`isco_tmp'== 813|`isco_tmp'== 814|`isco_tmp'== 815|`isco_tmp'== 816|`isco_tmp'== 817|`isco_tmp'== 820|`isco_tmp'== 821|`isco_tmp'== 822|`isco_tmp'== 823|`isco_tmp'== 824|`isco_tmp'== 826|`isco_tmp'== 827|`isco_tmp'== 828|`isco_tmp'== 829|`isco_tmp'== 830|`isco_tmp'== 832|`isco_tmp'== 833|`isco_tmp'==
900|`isco_tmp'== 910|`isco_tmp'== 912|`isco_tmp'== 913|`isco_tmp'== 914|`isco_tmp'== 915|`isco_tmp'== 916|`isco_tmp'== 920|`isco_tmp'== 921|`isco_tmp'== 930|`isco_tmp'== 931|`isco_tmp'== 932|`isco_tmp'== 933) & `empstat' == . ;

#delimit cr



capture lab drop esec

lab def esec 1 "Large employers, higher mgrs/professionals" 2 "Lower mgrs/professionals, higher supervisory/technicians" 3 "Intermediate occupations" 4 "Small employers and self-employed (non-agriculture)" 5 "Small employers and self-employed (agriculture)" 6 "Lower supervisors and technicians" 7 "Lower sales and service" 8 "Lower technical" 9 "Routine"

lab val `varlist' esec 

dis "OK"
end


