# delimit ;

/********************************************************
CheckVin.do
Nathan Wozny 8/17/09
Drop invalid VINs.  Invalid means it is the wrong length,
contains invalid characters, or the check digit is
incorrect.  Called from AuctionPrices.do.
********************************************************/

gen byte ValidVin = 1;
/* Drop records with invalid VINs. */
replace ValidVin = 0 if length(trim(vin))~=17;

local weight1 = 8;
local weight2 = 7;
local weight3 = 6;
local weight4 = 5;
local weight5 = 4;
local weight6 = 3;
local weight7 = 2;
local weight8 = 10;
local weight9 = 0;
local weight10 = 9;
local weight11 = 8;
local weight12 = 7;
local weight13 = 6;
local weight14 = 5;
local weight15 = 4;
local weight16 = 3;
local weight17 = 2;

* Check the check digit;
gen int check = 0;
forvalues i = 1/17 {;
    gen digit = substr(vin,`i',1);
    gen byte num = 0 if digit=="0";
    replace num = 1 if digit=="1" | digit=="A" | digit=="J";
    replace num = 2 if digit=="2" | digit=="B" | digit=="K" | digit=="S";
    replace num = 3 if digit=="3" | digit=="C" | digit=="L" | digit=="T";
    replace num = 4 if digit=="4" | digit=="D" | digit=="M" | digit=="U";
    replace num = 5 if digit=="5" | digit=="E" | digit=="N" | digit=="V";
    replace num = 6 if digit=="6" | digit=="F" | digit=="W";
    replace num = 7 if digit=="7" | digit=="G" | digit=="P" | digit=="X";
    replace num = 8 if digit=="8" | digit=="H" | digit=="Y";
    replace num = 9 if digit=="9" | digit=="R" | digit=="Z";
    tab digit if num==., m;
    replace check = check + num * `weight`i'';
    drop digit num;
};
* Drop if VIN contains an invalid character;
replace ValidVin = 0 if check==.;
replace check = mod(check,11);
* Drop if check digit is wrong;
replace ValidVin = 0 if (check<10 & string(check)~=substr(vin,9,1) | (check==10 & substr(vin,9,1)~="X"));
tab ValidVin;
drop if ValidVin==0;
drop check ValidVin;
