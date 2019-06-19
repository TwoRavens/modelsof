# delimit ;

/*************************************************************************
* WardsMatchSmart.do
* Generate a .csv with an attempt to match Wards names to Prefix names.
* This .csv can be manually edited to make corrections, then WardsAttributes.do
* will read the corrected .csv to complete the merge.
* Disclaimer: "Smart" may not be that smart!  It would be wise to double-check...
*************************************************************************/

capture log close;
log using WardsMatchSmart.log, replace;

set more off;
clear all;
set mem 500m;
insheet using wardsbody.txt, names;
rename bodystyle BodyStyle;
sort BodyStyle;
tempfile wardsbody;
save `wardsbody';
insheet using prefixbody.txt, names clear;
rename bodystyle BodyStyle;
sort BodyStyle;
tempfile prefixbody;
save `prefixbody';

use WardsAttributes, clear;
gen Prefix=0;
local numwards=_N;
drop if BodyStyle=="—" | BodyStyle=="-" | BodyStyle=="--" | BodyStyle=="----";
sort BodyStyle;
merge BodyStyle using `wardsbody', uniqusing;
assert _merge==3 | BodyStyle=="";
drop _merge;
replace Drive = "AWD" if Drive=="4WD" | Drive=="4WD, AWD";
replace Drive = "2WD" if Drive=="FWD" | Drive=="RWD";
replace Make="HUMMER" if Make=="AM GENERAL";
replace Make="ROLLS-ROYCE" if Make=="ROLLS";
replace Make="GMC" if Make=="CHEVROLET";

/*
gen SpecialChar=0;
gen str244 AltModelJoin = "";
forvalues i=1/244 {;
    qui replace SpecialChar=((substr(Trim,`i',1)~=" " & substr(Trim,`i',1)<".") | substr(Trim,`i',1)=="/" | (substr(Trim,`i',1)>"9" & substr(Trim,`i',1)<"A") | (substr(Trim,`i',1)>"Z" & substr(Trim,`i',1)<"a")  | substr(Trim,`i',1)>"Z");
    qui replace AltModelJoin=AltModelJoin +substr(Model,`i',1) if SpecialChar==0;
};
gen str244 AltTrimJoin = "";
forvalues i=1/244 {;
    qui replace SpecialChar=((substr(Trim,`i',1)~=" " & substr(Trim,`i',1)<".") | substr(Trim,`i',1)=="/" | (substr(Trim,`i',1)>"9" & substr(Trim,`i',1)<"A") | (substr(Trim,`i',1)>"Z" & substr(Trim,`i',1)<"a")  | substr(Trim,`i',1)>"Z");
    qui replace AltTrimJoin=AltTrimJoin +substr(Trim,`i',1) if SpecialChar==0;
};
*/
gen str244 AltTrim = "";
gen str244 AltTrimJoin = "";
gen SpecialChar=0;
forvalues i=1/244 {;
    qui replace SpecialChar=((substr(Trim,`i',1)~=" " & substr(Trim,`i',1)<".") | substr(Trim,`i',1)=="/" | (substr(Trim,`i',1)>"9" & substr(Trim,`i',1)<"A") | (substr(Trim,`i',1)>"Z" & substr(Trim,`i',1)<"a")  | substr(Trim,`i',1)>"z");
    qui replace AltTrim=AltTrim +substr(Trim,`i',1) if SpecialChar==0;
    qui replace AltTrim=AltTrim +" " if SpecialChar==1;
    qui replace AltTrimJoin=AltTrimJoin +substr(Trim,`i',1) if SpecialChar==0;
    local nexti = `i'+1;
    qui replace AltTrim = AltTrim + " " if (substr(Trim,`i',1)>"0" & substr(Trim,`i',1)<"9" & substr(Trim,`nexti',1)>"A" & substr(Trim,`nexti',1)<"Z") | (substr(Trim,`nexti',1)>"0" & substr(Trim,`nexti',1)<"9" & substr(Trim,`i',1)>"A" & substr(Trim,`i',1)<"Z");
};
forvalues i=1/10 {;
    gen Trim`i'=word(AltTrim,`i');
    replace Trim`i'="XXXXX" if Trim`i'=="" | length(Trim`i')==1;
    gen TrimJoin`i'=word(AltTrimJoin,`i');
    replace TrimJoin`i'="XXXXX" if TrimJoin`i'=="";
};
gen str244 AltModel = "";
gen str244 AltModelJoin = "";
forvalues i=1/244 {;
    qui replace SpecialChar=((substr(Trim,`i',1)~=" " & substr(Trim,`i',1)<".") | (substr(Model,`i',1)>"9" & substr(Model,`i',1)<"A") | (substr(Model,`i',1)>"Z" & substr(Model,`i',1)<"a")  | substr(Model,`i',1)>"z");
    qui replace AltModel=AltModel +substr(Model,`i',1) if SpecialChar==0;
    qui replace AltModel=AltModel +" " if SpecialChar==1;
    qui replace AltModelJoin=AltModelJoin +substr(Model,`i',1) if SpecialChar==0;
    local nexti=`i'-1;
    qui replace AltModel = AltModel + " " if (substr(Model,`i',1)>"0" & substr(Model,`i',1)<"9" & substr(Model,`nexti',1)>"A" & substr(Model,`nexti',1)<"Z") | (substr(Model,`nexti',1)>"0" & substr(Model,`nexti',1)<"9" & substr(Model,`i',1)>"A" & substr(Model,`i',1)<"Z");
};
forvalues i=1/10 {;
    gen Model`i'=word(AltModel,`i');
    replace Model`i'="XXXXX" if Model`i'=="" | length(Model`i')==1;
    gen ModelJoin`i'=word(AltModelJoin,`i');
    replace ModelJoin`i'="XXXXX" if ModelJoin`i'=="";
};
forvalues i=1/10 {;
    forvalues j=1/10 {;
        if `i'~=`j' {;
            replace Trim`i'="XXXXX" if Trim`i'==Trim`j';
            replace TrimJoin`i'="XXXXX" if TrimJoin`i'==TrimJoin`j';
            replace Model`i'="XXXXX" if Model`i'==Model`j';
            replace ModelJoin`i'="XXXXX" if ModelJoin`i'==ModelJoin`j';
        };
        replace Trim`i'="XXXXX" if Trim`i'==TrimJoin`j';
        replace Trim`i'="XXXXX" if Trim`i'==Model`j';
        replace Trim`i'="XXXXX" if Trim`i'==ModelJoin`j';

        replace TrimJoin`i'="XXXXX" if TrimJoin`i'==Trim`j';
        replace TrimJoin`i'="XXXXX" if TrimJoin`i'==Model`j';
        replace TrimJoin`i'="XXXXX" if TrimJoin`i'==ModelJoin`j';

        replace Model`i'="XXXXX" if Model`i'==TrimJoin`j';
        replace Model`i'="XXXXX" if Model`i'==Trim`j';
        replace Model`i'="XXXXX" if Model`i'==ModelJoin`j';

        replace ModelJoin`i'="XXXXX" if ModelJoin`i'==TrimJoin`j';
        replace ModelJoin`i'="XXXXX" if ModelJoin`i'==Model`j';
        replace ModelJoin`i'="XXXXX" if ModelJoin`i'==Trim`j';
    };
};
gen XPenalty = 0;
forvalues i=1/10 {;
    replace XPenalty = XPenalty + 1 if Model`i'=="XXXXX";
    replace XPenalty = XPenalty + 1 if Trim`i'=="XXXXX";
    replace XPenalty = XPenalty + 1 if ModelJoin`i'=="XXXXX";
    replace XPenalty = XPenalty + 1 if TrimJoin`i'=="XXXXX";
};

tempfile wards_mod;
save `wards_mod';

use ../../Matchups/Prefix810, clear;
drop if ModelYear<1999;
replace Make=upper(Make);
replace Model=upper(Model);
replace Trim=upper(Trim);
replace Liters = Liters*10;
sort BodyStyle;
merge BodyStyle using `prefixbody', uniqusing nokeep;
assert _merge==3;
drop _merge;
replace DriveWheels = "AWD" if DriveWheels=="4" | DriveWheels=="A";
replace DriveWheels = "2WD" if DriveWheels=="F" | DriveWheels=="R";
replace Make="GMC" if Make=="CHEVROLET";
replace Make="MERCEDES" if Make=="MERCEDES-BENZ";
replace Make="TOYOTA" if Make=="SCION";

gen str244 AltTrim = "";
gen str244 AltTrimJoin = "";
gen SpecialChar=0;
forvalues i=1/244 {;
    qui replace SpecialChar=((substr(Trim,`i',1)~=" " & substr(Trim,`i',1)<".") | substr(Trim,`i',1)=="/" | (substr(Trim,`i',1)>"9" & substr(Trim,`i',1)<"A") | (substr(Trim,`i',1)>"Z" & substr(Trim,`i',1)<"a")  | substr(Trim,`i',1)>"z");
    qui replace AltTrim=AltTrim +substr(Trim,`i',1) if SpecialChar==0;
    qui replace AltTrim=AltTrim +" " if SpecialChar==1;
    qui replace AltTrimJoin=AltTrimJoin +substr(Trim,`i',1) if SpecialChar==0;
    qui replace AltTrim = AltTrim + " " if (substr(Trim,`i',1)>"0" & substr(Trim,`i',1)<"9" & substr(Trim,`nexti',1)>"A" & substr(Trim,`nexti',1)<"Z") | (substr(Trim,`nexti',1)>"0" & substr(Trim,`nexti',1)<"9" & substr(Trim,`i',1)>"A" & substr(Trim,`i',1)<"Z");
};
forvalues i=1/10 {;
    gen Trim`i'=word(AltTrim,`i');
    replace Trim`i'="XXXXX" if Trim`i'=="" | length(Trim`i')==1;
    gen TrimJoin`i'=word(AltTrimJoin,`i');
    replace TrimJoin`i'="XXXXX" if TrimJoin`i'=="";
};
gen str244 AltModel = "";
gen str244 AltModelJoin = "";
forvalues i=1/244 {;
    qui replace SpecialChar=((substr(Trim,`i',1)~=" " & substr(Trim,`i',1)<".") | (substr(Model,`i',1)>"9" & substr(Model,`i',1)<"A") | (substr(Model,`i',1)>"Z" & substr(Model,`i',1)<"a")  | substr(Model,`i',1)>"z");
    qui replace AltModel=AltModel +substr(Model,`i',1) if SpecialChar==0;
    qui replace AltModel=AltModel +" " if SpecialChar==1;
    qui replace AltModelJoin=AltModelJoin +substr(Model,`i',1) if SpecialChar==0;
    local nexti=`i'-1;
    qui replace AltModel = AltModel + " " if (substr(Model,`i',1)>"0" & substr(Model,`i',1)<"9" & substr(Model,`nexti',1)>"A" & substr(Model,`nexti',1)<"Z") | (substr(Model,`nexti',1)>"0" & substr(Model,`nexti',1)<"9" & substr(Model,`i',1)>"A" & substr(Model,`i',1)<"Z");
};
forvalues i=1/10 {;
    gen Model`i'=word(AltModel,`i');
    replace Model`i'="XXXXX" if Model`i'=="" | length(Model`i')==1;
    gen ModelJoin`i'=word(AltModelJoin,`i');
    replace ModelJoin`i'="XXXXX" if ModelJoin`i'=="";
};
forvalues i=1/10 {;
    forvalues j=1/10 {;
        if `i'~=`j' {;
            replace Trim`i'="XXXXX" if Trim`i'==Trim`j';
            replace TrimJoin`i'="XXXXX" if TrimJoin`i'==TrimJoin`j';
            replace Model`i'="XXXXX" if Model`i'==Model`j';
            replace ModelJoin`i'="XXXXX" if ModelJoin`i'==ModelJoin`j';
        };
        replace Trim`i'="XXXXX" if Trim`i'==TrimJoin`j';
        replace Trim`i'="XXXXX" if Trim`i'==Model`j';
        replace Trim`i'="XXXXX" if Trim`i'==ModelJoin`j';

        replace TrimJoin`i'="XXXXX" if TrimJoin`i'==Trim`j';
        replace TrimJoin`i'="XXXXX" if TrimJoin`i'==Model`j';
        replace TrimJoin`i'="XXXXX" if TrimJoin`i'==ModelJoin`j';

        replace Model`i'="XXXXX" if Model`i'==TrimJoin`j';
        replace Model`i'="XXXXX" if Model`i'==Trim`j';
        replace Model`i'="XXXXX" if Model`i'==ModelJoin`j';

        replace ModelJoin`i'="XXXXX" if ModelJoin`i'==TrimJoin`j';
        replace ModelJoin`i'="XXXXX" if ModelJoin`i'==Model`j';
        replace ModelJoin`i'="XXXXX" if ModelJoin`i'==Trim`j';
        /*
        if `i'~=`j' {;
            replace Trim`i'="XXXXX" if strpos(Trim`i',Trim`j')>0;
            replace TrimJoin`i'="XXXXX" if strpos(TrimJoin`i',TrimJoin`j')>0;
            replace Model`i'="XXXXX" if strpos(Model`i',Model`j')>0;
            replace ModelJoin`i'="XXXXX" if strpos(ModelJoin`i',ModelJoin`j')>0;
        };
        replace Trim`i'="XXXXX" if strpos(Trim`i',TrimJoin`j')>0;
        replace Trim`i'="XXXXX" if strpos(Trim`i',Model`j')>0;
        replace Trim`i'="XXXXX" if strpos(Trim`i',ModelJoin`j')>0;

        replace TrimJoin`i'="XXXXX" if strpos(TrimJoin`i',Trim`j')>0;
        replace TrimJoin`i'="XXXXX" if strpos(TrimJoin`i',Model`j')>0;
        replace TrimJoin`i'="XXXXX" if strpos(TrimJoin`i',ModelJoin`j')>0;

        replace Model`i'="XXXXX" if strpos(Model`i',TrimJoin`j')>0;
        replace Model`i'="XXXXX" if strpos(Model`i',Trim`j')>0;
        replace Model`i'="XXXXX" if strpos(Model`i',ModelJoin`j')>0;

        replace ModelJoin`i'="XXXXX" if strpos(ModelJoin`i',TrimJoin`j')>0;
        replace ModelJoin`i'="XXXXX" if strpos(ModelJoin`i',Model`j')>0;
        replace ModelJoin`i'="XXXXX" if strpos(ModelJoin`i',Trim`j')>0;
        */
    };
};

sort Make ModelYear Trim BodyStyle Cylinder Liters Drive;
gen Prefix=1;
gen PrefixID=_n;
local numprefix=_N;

append using `wards_mod';
assert PrefixID==. if Prefix==0;
gsort - Prefix + PrefixID WardsID;
qui gen long Score = 0;
gen long MatchScore=.;
gen WinnerID = 0;
local starttime=clock("$S_TIME","hms");
/* Calculate a match score, and choose the highest */
forvalues i=1/`numprefix' {;
    qui replace Score = 0 - 3 * XPenalty;
    qui replace Score = . if Prefix | ModelYear~=ModelYear[`i'];
    qui replace WinnerID = 0;
    forvalues j=1/10 {;
        qui replace Score=Score+5 if strpos(AltTrimJoin,Trim`j'[`i'])>0 | strpos(AltModelJoin,Trim`j'[`i'])>0;
        qui replace Score=Score+5 if strpos(AltTrimJoin,TrimJoin`j'[`i'])>0 | strpos(AltModelJoin,TrimJoin`j'[`i'])>0;
        qui replace Score=Score+5 if strpos(AltTrimJoin,Model`j'[`i'])>0 | strpos(AltModelJoin,Model`j'[`i'])>0;
        qui replace Score=Score+5 if strpos(AltTrimJoin,ModelJoin`j'[`i'])>0 | strpos(AltModelJoin,ModelJoin`j'[`i'])>0;
    };
    forvalues j=1/10 {;
        qui replace Score=Score+5 if strpos(AltTrimJoin[`i'],Trim`j')>0 | strpos(AltModelJoin[`i'],Trim`j')>0;
        qui replace Score=Score+5 if strpos(AltTrimJoin[`i'],TrimJoin`j')>0 | strpos(AltModelJoin[`i'],TrimJoin`j')>0;
        qui replace Score=Score+5 if strpos(AltTrimJoin[`i'],Model`j')>0 | strpos(AltModelJoin[`i'],Model`j')>0;
        qui replace Score=Score+5 if strpos(AltTrimJoin[`i'],ModelJoin`j')>0 | strpos(AltModelJoin[`i'],ModelJoin`j')>0;
    };
    qui replace Score = Score + 40 if AltTrim==AltTrim[`i'] | AltTrimJoin==AltTrimJoin[`i'] | AltModel==AltModel[`i'] | AltModelJoin==AltModelJoin[`i'];
    qui replace Score = Score + 20 if AltTrim==AltModel[`i'] | AltTrimJoin==AltModelJoin[`i'] | AltModel==AltTrim[`i'] | AltModelJoin==AltTrimJoin[`i'];
    qui replace Score = Score - (Liters-Liters[`i'])^2 if Liters<. & Liters[`i']<.;
    qui replace Score = Score - abs(Cylinder - Cylinder[`i'])*15 if Cylinder<. & Cylinder[`i']<.;
    qui replace Score = Score + 20 if (type==type[`i'] | type2==type[`i']) & type[`i']~="";
    qui replace Score = Score + 15 if (type==type2[`i'] | type2==type2[`i']) & type2[`i']~="";
    qui replace Score = Score + 15 if doors==doors[`i'] & doors~=.;
    qui replace Score = Score + 15 if Drive==DriveWheels[`i'];
    qui replace Score = Score - 1000 if Make~=Make[`i'];
    * Avoid a slow sort;
    qui sum Score;
    local highscore = r(max);
    qui replace WinnerID = WardsID if Score==`highscore';
    qui replace WinnerID = WinnerID[_n-1] if WinnerID[_n-1]>0 & _n>1;
    * Assign the ID of the winner to the prefix record;
    * Use -200 as a minimum score to be a match (note this means the Make must match);
    qui replace WardsID = WinnerID[_N] if _n==`i' & `highscore'>-200;
    qui replace MatchScore = `highscore' if _n==`i';
    local now=clock("$S_TIME","hms");
    local timeest = ceil((`now'-`starttime')*(`numprefix'-`i')/`i'/60000);
    local hrs=floor(`timeest'/60);
    local min=`timeest'-60*`hrs';
    di "Matching `i' / `numprefix' . . . `hrs' hours, `min' minutes remaining";
};

* If multiple matches, keep the best ones if some are substantially better than others;
sort WardsID;
by WardsID: egen NumMatch=total(PrefixID<.);
by WardsID: egen MaxScore=max(MatchScore);
replace WardsID=. if MatchScore<MaxScore-50 & PrefixID<. & NumMatch>12;
sort WardsID MatchScore;
by WardsID: replace WardsID=. if _N-_n>21 & PrefixID<. & MatchScore<-80;

gen WardsNoMatch = (WardsID==.);

sort WardsID PrefixID Make ModelYear Trim BodyStyle Cylinder Liters Drive;
order MatchScore WardsID PrefixID Make ModelYear Model Trim BodyStyle Cylinder Liters Drive;

outsheet using WardsPrefixSmart.csv, comma replace;

set more on;
log close;
