# delimit ;

/********************************************************
CalcSurvProb.do
Nathan Wozny 9/02/09
Estimate survival probabilities for each vehicle.
Called from PolkQuantities.do
********************************************************/
/* Setup*/;
local maxage=25;


/* Load up the temporary file stored from PolkQuantities.do */
use SurvivalProbabilityData.dta,clear;

/* Get MPG */
sort CarID ModelYear;
merge CarID ModelYear using ../EPAMPG/EPAByID, uniqusing keep(GPMA);
tab _merge;
drop _merge;
gen MPG = 1/GPMA;
gen MPG2 = MPG^2;
drop GPMA;



* get NHTS age-specific quantity adjustments;
gen Age = Year - ModelYear;
drop if Age==.;
sort Age;
merge Age using ../NHTS/NHTSQAgeAdj, uniqusing nokeep;
assert _merge==3;
*replace Quantity = round(Quantity * NHTSQAdj,1);
drop _merge NHTSQAdj;

gen MY = ModelYear-1966;
gen AgeMPG = Age*MPG;
sort CarID ModelYear Age;
by CarID ModelYear: gen NextQuantity=Quantity[_n+1] if Age>=0 & Age[_n+1]==Age+1;
/* diagnostic */
gen SurvProb = NextQuantity/Quantity;
sum SurvProb if Age==0;
sum SurvProb if Age==1;
sum SurvProb if Age==5;
sum SurvProb if Age==10;
sum SurvProb if Age==15;
sum SurvProb [aw=Quantity] if Age==0;
sum SurvProb [aw=Quantity] if Age==1;
sum SurvProb [aw=Quantity] if Age==5;
sum SurvProb [aw=Quantity] if Age==10;
sum SurvProb [aw=Quantity] if Age==15;
drop SurvProb;
char Age [omit] 0;
xi i.Age;
drop _IAge_1;

/* Start by computing annual survival probabilities:
   AnnSurvProb`s' = P(survive to t+s+1 | survive to t+s) */
*xi: bprobit NextQuantity Quantity MY i.Age i.FirmID*Age i.VClass if Age>=0 & Age<`maxage';
* Note: bprobit has a problem in Stata 11.;
*xi: bprobit NextQuantity Quantity MY i.FirmID*Age i.Age if Age>=0 & Age<`maxage';
bprobit NextQuantity Quantity MY MPG MPG2 AgeMPG _I* if Age>=1 & Age<`maxage';

gen OrigAge = Age;
forvalues s=0/`maxage' {;
    * Predict annual survival probability `i' years in the future, i.e. as if the age of the car were Age+`i';
    replace Age = OrigAge + `s';
    forvalues i=2/`maxage' {;
        replace _IAge_`i' = (OrigAge==`i'-`s');
    };
    replace AgeMPG = Age*MPG;
    predict AnnSurvProb`s' if Age<`maxage', pr;
    replace AnnSurvProb`s' = 0 if Age>=`maxage' | AnnSurvProb`s'<0;
    replace AnnSurvProb`s' = 1 if AnnSurvProb`s' > 1 & AnnSurvProb`s' < .;
};
/* diagnostic */
sum AnnSurvProb* if OrigAge==0 & ModelYear==2005;
replace AnnSurvProb0 = 1 if OrigAge==0;
sum AnnSurvProb* if OrigAge==0;
sum AnnSurvProb* if OrigAge==1;
sum AnnSurvProb* if OrigAge==5;
sum AnnSurvProb* if OrigAge==10;
sum AnnSurvProb* if OrigAge==15;
/* Now compute s-year survival probabilities:
   SurvProb`s' = P(survive to t+s | survive to t) */
gen SurvProb0 = 1;
forvalues s=1/`maxage' {;
    local s1 = `s'-1;
    gen SurvProb`s'=SurvProb`s1'*AnnSurvProb`s1';
};

/* As a diagnostic measure, calculate the life expectancy from this year for each vehicle. */
gen LifeExp = 0;
forvalues s=1/`maxage' {;
    replace LifeExp = LifeExp + SurvProb`s' if OrigAge<`maxage'-`s';
};

drop NextQuantity AnnSurvProb* Age OrigAge AgeMPG MY _I*;

sort CarID ModelYear Year;
preserve;
drop MPG MPG2;
save SurvProb, replace;
restore;

/* Get survival probabilities when the vehicle was new (for purposes of constructing the instrument) */
drop SurvProb* LifeExp;
gen MY = ModelYear-1966;
gen Age = Year - ModelYear;
gen AgeMPG = Age*MPG;
xi i.Age;
forvalues s=0/`maxage' {;
    replace Age = `s';
    forvalues i=1/`maxage' {;
        replace _IAge_`i' = (`i'==`s');
    };
    replace AgeMPG = Age*MPG;
    predict AnnSurvProb`s', pr;
    replace AnnSurvProb`s' = 0 if Age>=`maxage' | AnnSurvProb`s'<0;
    replace AnnSurvProb`s' = 1 if AnnSurvProb`s' > 1 & AnnSurvProb`s' < .;
};
/* Now compute s-year survival probabilities:
   SurvProb`s' = P(survive to t+s | survive to t) */
gen SurvProb0 = 1;
forvalues s=1/`maxage' {;
    local s1 = `s'-1;
    gen SurvProb`s'=SurvProb`s1'*AnnSurvProb`s1';
};

/* As a diagnostic measure, calculate the life expectancy from this year for each vehicle. */
gen LifeExp = 0;
forvalues s=1/`maxage' {;
    replace LifeExp = LifeExp + SurvProb`s' if `s'<`maxage';
};
reg LifeExp Age;

drop AnnSurvProb* Age MY MPG MPG2 AgeMPG _I*;

sort CarID ModelYear Year;
save SurvProbNew, replace;

* drop SurvProb* LifeExp;
