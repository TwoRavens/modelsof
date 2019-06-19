# delimit ;

clear all;
set mem 3000m;

use AutoPQXG;

* base G;
rename G1000000006025024100110 G;
* base instrument;
rename GInst1000000006025024100110 G0;
gen MPG = 1/GPM;
gen PctCar=(VClass<=6);
gen PctTruck=(VClass>=7);

/* identify observations that can be used in nested logit analysis */
gen int Time = (Year-1999)*12 + Month-1;

sort Make Model;
merge m:1 Make Model using ExoticList.dta, assert(match);
*drop if Exotic;
drop ForeignHighLuxury ForeignLuxury SportsCar DomesticLuxury LuxlnP85 _merge;

*drop if VClass==10;

replace Quantity = . if ModelYear==2008;

/* Reweight so that new vehicles match 1 year old vehicles. */
forvalues yr=1999/2008 {;
    sum NumObs if Age==0 & Year==`yr';
    local mean0 = r(mean);
    sum NumObs if Age==1 & Year==`yr';
    local mean1 = r(mean);
    replace NumObs = NumObs * `mean1'/`mean0' if Age<=0 & Year==`yr';
};

gen HavePrice = (Price < .);

outsum Year ModelYear Age Price Quantity MPG G HP Weight Wheelbase PctCar PctTruck [aw=NumObs] using Estimation/sumstats if HavePrice==1, replace noparen;
outsum Year ModelYear Age Price Quantity MPG G HP Weight Wheelbase PctCar PctTruck [aw=NumObs] using Estimation/sumstats if ModelYear==2007 & Year==2007 & HavePrice==1, append noparen;

gen IncludeInBase = (Year>=1999 & (Year<2008 | Month<=3) & Age>=1 & VClass~=10 & Exotic==0);

		gen OrigCarID = CarID;
    /* Use BLP rule t`o divide a CarID into generations based on characteristics.  An alternate CarID is created. */
    /* Presumably characteristics of the same CarID and ModelYear should not change over time.  In case they do,
       perform this test only for the month of January and the youngest age observed in the dataset.  */
    sort Month CarID Age ModelYear;
    /* Liters and GPM seem like the best characteristics to use that are avaialble outside of the Wards data. */
		by Month CarID Age: gen BigChange = (abs(Liters-Liters[_n-1])/Liters[_n-1]>=.1) & Liters!=. & Liters[_n-1]!=. if _n>1;
    by Month CarID Age: replace BigChange = 1 if abs(GPM-GPM[_n-1])/GPM[_n-1]>=.1 & GPM!=. & GPM[_n-1]!=. & _n>1;
    gen GenNum = 1;
    by Month CarID Age: replace GenNum = GenNum[_n-1] + BigChange if _n>1;
    sort CarID ModelYear Age Month;
    by CarID ModelYear: replace GenNum = GenNum[1];
    by CarID: egen NumGens = max(GenNum);
    by CarID: gen firstrec=(_n==1);
    tab NumGens if firstrec;
    drop NumGens firstrec;
    egen CarGenID = group(CarID GenNum);
    replace CarID = CarGenID;

egen FEGroup = group(CarID Age Month);

sort FEGroup Time;
capture gen HavePrice = (Price < .);
gen HavePosQ = (Quantity < . & Quantity>0);
gen HaveG = (G < .);
gen HaveClass = (VClass>0 & VClass<.);
gen HaveInst = (G0<.);
gen ObsValidNL = (HavePrice & HavePosQ & HaveG & HaveClass & HaveInst & IncludeInBase & NumObs>0);
by FEGroup: egen NumValidObsNL = total(ObsValidNL);
by FEGroup: egen RegWeight = total(NumObs);
gen BaseSample = (NumValidObsNL>=2 & ObsValidNL & RegWeight<. & RegWeight>0);

egen ObsInSample = total(NumObs*BaseSample);
egen ObsNotInSample = total(NumObs*(1-BaseSample));
sum BaseSample ObsInSample ObsNotInSample;

*keep Year ModelYear Age Price G Quantity MPG HP Weight Wheelbase PctCar PctTruck ObsValidNL;
outsum Year ModelYear Age Price Quantity MPG G HP Weight Wheelbase PctCar PctTruck [aw=NumObs] using Estimation/sumstats if BaseSample, append noparen;


/* Determine how the sample sizes get reduced */
# delimit ;
sum CarID;
sum CarID if HavePrice;
sum CarID if HavePrice&Exotic==0&VClass<10;
sum CarID if HavePrice&Exotic==0&VClass<10 & Age >= 1;
sum CarID if HavePrice&Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3);
sum CarID if HavePrice&Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & HavePosQ & HaveG & HaveClass & HaveInst;
sum CarID if Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & ObsValidNL;
sum CarID if Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & ObsValidNL & NumValidObsNL>=2;

/* Sum Quantities for the observations without prices */
sum Quantity if Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & HavePrice;
sum Quantity if Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & HavePrice == 0;

sum CarID Age if Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & ObsValidNL & NumValidObsNL>=2;
sum CarID Age if Exotic==0&VClass<10 & Age >= 1 & (Year<2008|Month<=3) & ObsValidNL & NumValidObsNL<2;
