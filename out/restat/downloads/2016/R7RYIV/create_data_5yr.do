
******************************************************
* Ceates data by 5-year age group
******************************************************

clear
# delimit ;
capture log close;
set more 1;

log using create_data_5yr.log, replace;
use data_5yr_raw;

*  Creating population by 5-year age groups;
egen popmu151959=rsum(popmu1559 popmu1659 popmu1759 popmu1859 popmu1959);
egen popmu161959=rsum(popmu1659 popmu1759 popmu1859 popmu1959);
egen popmu181959=rsum(popmu1859 popmu1959);
egen popfu151959=rsum(popfu1559 popfu1659 popfu1759 popfu1859 popfu1959);
egen popfu161959=rsum(popfu1659 popfu1759 popfu1859 popfu1959);
egen popfu181959=rsum(popfu1859 popfu1959);
egen popmr151959=rsum(popmr1559 popmr1659 popmr1759 popmr1859 popmr1959);
egen popmr161959=rsum(popmr1659 popmr1759 popmr1859 popmr1959);
egen popmr181959=rsum(popmr1859 popmr1959);
egen popfr151959=rsum(popfr1559 popfr1659 popfr1759 popfr1859 popfr1959);
egen popfr161959=rsum(popfr1659 popfr1759 popfr1859 popfr1959);
egen popfr181959=rsum(popfr1859 popfr1959);

egen popmu202459=rsum(popmu2059 popmu2159 popmu2259 popmu2359 popmu2459);
egen popfu202459=rsum(popfu2059 popfu2159 popfu2259 popfu2359 popfu2459);
egen popmr202459=rsum(popmr2059 popmr2159 popmr2259 popmr2359 popmr2459);
egen popfr202459=rsum(popfr2059 popfr2159 popfr2259 popfr2359 popfr2459);

egen popmu252959=rsum(popmu2559 popmu2659 popmu2759 popmu2859 popmu2959);
egen popfu252959=rsum(popfu2559 popfu2659 popfu2759 popfu2859 popfu2959);
egen popmr252959=rsum(popmr2559 popmr2659 popmr2759 popmr2859 popmr2959);
egen popfr252959=rsum(popfr2559 popfr2659 popfr2759 popfr2859 popfr2959);

egen popmu303459=rsum(popmu3059 popmu3159 popmu3259 popmu3359 popmu3459);
egen popfu303459=rsum(popfu3059 popfu3159 popfu3259 popfu3359 popfu3459);
egen popmr303459=rsum(popmr3059 popmr3159 popmr3259 popmr3359 popmr3459);
egen popfr303459=rsum(popfr3059 popfr3159 popfr3259 popfr3359 popfr3459);

egen popmu353959=rsum(popmu3559 popmu3659 popmu3759 popmu3859 popmu3959);
egen popfu353959=rsum(popfu3559 popfu3659 popfu3759 popfu3859 popfu3959);
egen popmr353959=rsum(popmr3559 popmr3659 popmr3759 popmr3859 popmr3959);
egen popfr353959=rsum(popfr3559 popfr3659 popfr3759 popfr3859 popfr3959);

egen popmu404459=rsum(popmu4059 popmu4159 popmu4259 popmu4359 popmu4459);
egen popfu404459=rsum(popfu4059 popfu4159 popfu4259 popfu4359 popfu4459);
egen popmr404459=rsum(popmr4059 popmr4159 popmr4259 popmr4359 popmr4459);
egen popfr404459=rsum(popfr4059 popfr4159 popfr4259 popfr4359 popfr4459);

egen popmu454959=rsum(popmu4559 popmu4659 popmu4759 popmu4859 popmu4959);
egen popfu454959=rsum(popfu4559 popfu4659 popfu4759 popfu4859 popfu4959);
egen popmr454959=rsum(popmr4559 popmr4659 popmr4759 popmr4859 popmr4959);
egen popfr454959=rsum(popfr4559 popfr4659 popfr4759 popfr4859 popfr4959);

egen popmu505459=rsum(popmu5059 popmu5159 popmu5259 popmu5359 popmu5459);
egen popfu505459=rsum(popfu5059 popfu5159 popfu5259 popfu5359 popfu5459);
egen popmr505459=rsum(popmr5059 popmr5159 popmr5259 popmr5359 popmr5459);
egen popfr505459=rsum(popfr5059 popfr5159 popfr5259 popfr5359 popfr5459);

egen popmu555959=rsum(popmu5559 popmu5659 popmu5759 popmu5859 popmu5959);
egen popfu555959=rsum(popfu5559 popfu5659 popfu5759 popfu5859 popfu5959);
egen popmr555959=rsum(popmr5559 popmr5659 popmr5759 popmr5859 popmr5959);
egen popfr555959=rsum(popfr5559 popfr5659 popfr5759 popfr5859 popfr5959);

gen popm151959=popmu151959+popmr151959;
gen popm161959=popmu161959+popmr161959;
gen popm181959=popmu181959+popmr181959;
gen popf151959=popfu151959+popfr151959;
gen popf161959=popfu161959+popfr161959;
gen popf181959=popfu181959+popfr181959;
gen popm202459=popmu202459+popmr202459;
gen popf202459=popfu202459+popfr202459;
gen popm252959=popmu252959+popmr252959;
gen popf252959=popfu252959+popfr252959;
gen popm303459=popmu303459+popmr303459;
gen popf303459=popfu303459+popfr303459;
gen popm353959=popmu353959+popmr353959;
gen popf353959=popfu353959+popfr353959;
gen popm404459=popmu404459+popmr404459;
gen popf404459=popfu404459+popfr404459;
gen popm454959=popmu454959+popmr454959;
gen popf454959=popfu454959+popfr454959;
gen popm505459=popmu505459+popmr505459;
gen popf505459=popfu505459+popfr505459;
gen popm555959=popmu555959+popmr555959;
gen popf555959=popfu555959+popfr555959;

gen popm303959=popm303459+popm353959;
gen popmu303959=popmu303459+popmu353959;
gen popmr303959=popmr303459+popmr353959;
gen popf303959=popf303459+popf353959;
gen popfu303959=popfu303459+popfu353959;
gen popfr303959=popfr303459+popfr353959;

gen popm404959=popm404459+popm454959;
gen popmu404959=popmu404459+popmu454959;
gen popmr404959=popmr404459+popmr454959;
gen popf404959=popf404459+popf454959;
gen popfu404959=popfu404459+popfu454959;
gen popfr404959=popfr404459+popfr454959;

label var popmu151959 "Male pop. age 15-19, urban";
label var popmu161959 "Male pop. age 16-19, urban";
label var popmu181959 "Male pop. age 18-19, urban";
label var popmu202459 "Male pop. age 20-24, urban";
label var popmu252959 "Male pop. age 25-29, urban";
label var popmu303459 "Male pop. age 30-34, urban";
label var popmu353959 "Male pop. age 35-39, urban";
label var popmu404459 "Male pop. age 40-44, urban";
label var popmu454959 "Male pop. age 45-49, urban";
label var popmu505459 "Male pop. age 50-54, urban";
label var popmu555959 "Male pop. age 55-59, urban";

label var popfu151959 "Female pop. age 15-19, urban";
label var popfu161959 "Female pop. age 16-19, urban";
label var popfu181959 "Female pop. age 18-19, urban";
label var popfu202459 "Female pop. age 20-24, urban";
label var popfu252959 "Female pop. age 25-29, urban";
label var popfu303459 "Female pop. age 30-34, urban";
label var popfu353959 "Female pop. age 35-39, urban";
label var popfu404459 "Female pop. age 40-44, urban";
label var popfu454959 "Female pop. age 45-49, urban";
label var popfu505459 "Female pop. age 50-54, urban";
label var popfu555959 "Female pop. age 55-59, urban";

label var popmr151959 "Male pop. age 15-19, rural";
label var popmr161959 "Male pop. age 16-19, rural";
label var popmr181959 "Male pop. age 18-19, rural";
label var popmr202459 "Male pop. age 20-24, rural";
label var popmr252959 "Male pop. age 25-29, rural";
label var popmr303459 "Male pop. age 30-34, rural";
label var popmr353959 "Male pop. age 35-39, rural";
label var popmr404459 "Male pop. age 40-44, rural";
label var popmr454959 "Male pop. age 45-49, rural";
label var popmr505459 "Male pop. age 50-54, rural";
label var popmr555959 "Male pop. age 55-59, rural";

label var popfr151959 "Female pop. age 15-19, rural";
label var popfr161959 "Female pop. age 16-19, rural";
label var popfr181959 "Female pop. age 18-19, rural";
label var popfr202459 "Female pop. age 20-24, rural";
label var popfr252959 "Female pop. age 25-29, rural";
label var popfr303459 "Female pop. age 30-34, rural";
label var popfr353959 "Female pop. age 35-39, rural";
label var popfr404459 "Female pop. age 40-44, rural";
label var popfr454959 "Female pop. age 45-49, rural";
label var popfr505459 "Female pop. age 50-54, rural";
label var popfr555959 "Female pop. age 55-59, rural";

*  Married population by 5-year age group;
egen mpmu1519=rsum(mpopmu1559 mpopmu1659 mpopmu1759 mpopmu1859 mpopmu1959);
egen mpmu1619=rsum(mpopmu1659 mpopmu1759 mpopmu1859 mpopmu1959);
egen mpmu1819=rsum(mpopmu1859 mpopmu1959);
egen mpfu1519=rsum(mpopfu1559 mpopfu1659 mpopfu1759 mpopfu1859 mpopfu1959);
egen mpfu1619=rsum(mpopfu1659 mpopfu1759 mpopfu1859 mpopfu1959);
egen mpfu1819=rsum(mpopfu1859 mpopfu1959);
egen mpmr1519=rsum(mpopmr1559 mpopmr1659 mpopmr1759 mpopmr1859 mpopmr1959);
egen mpmr1619=rsum(mpopmr1659 mpopmr1759 mpopmr1859 mpopmr1959);
egen mpmr1819=rsum(mpopmr1859 mpopmr1959);
egen mpfr1519=rsum(mpopfr1559 mpopfr1659 mpopfr1759 mpopfr1859 mpopfr1959);
egen mpfr1619=rsum(mpopfr1659 mpopfr1759 mpopfr1859 mpopfr1959);
egen mpfr1819=rsum(mpopfr1859 mpopfr1959);
gen mpm1519=mpmu1519+mpmr1519;
gen mpf1519=mpfu1519+mpfr1519;
gen mpm1619=mpmu1619+mpmr1619;
gen mpf1619=mpfu1619+mpfr1619;
gen mpm1819=mpmu1819+mpmr1819;
gen mpf1819=mpfu1819+mpfr1819;

egen mpmu2024=rsum(mpopmu2059 mpopmu2159 mpopmu2259 mpopmu2359 mpopmu2459);
egen mpfu2024=rsum(mpopfu2059 mpopfu2159 mpopfu2259 mpopfu2359 mpopfu2459);
egen mpmr2024=rsum(mpopmr2059 mpopmr2159 mpopmr2259 mpopmr2359 mpopmr2459);
egen mpfr2024=rsum(mpopfr2059 mpopfr2159 mpopfr2259 mpopfr2359 mpopfr2459);
gen mpm2024=mpmu2024+mpmr2024;
gen mpf2024=mpfu2024+mpfr2024;

egen mpmu2529=rsum(mpopmu2559 mpopmu2659 mpopmu2759 mpopmu2859 mpopmu2959);
egen mpfu2529=rsum(mpopfu2559 mpopfu2659 mpopfu2759 mpopfu2859 mpopfu2959);
egen mpmr2529=rsum(mpopmr2559 mpopmr2659 mpopmr2759 mpopmr2859 mpopmr2959);
egen mpfr2529=rsum(mpopfr2559 mpopfr2659 mpopfr2759 mpopfr2859 mpopfr2959);
gen mpm2529=mpmu2529+mpmr2529;
gen mpf2529=mpfu2529+mpfr2529;

egen mpmu3034=rsum(mpopmu3059 mpopmu3159 mpopmu3259 mpopmu3359 mpopmu3459);
egen mpfu3034=rsum(mpopfu3059 mpopfu3159 mpopfu3259 mpopfu3359 mpopfu3459);
egen mpmr3034=rsum(mpopmr3059 mpopmr3159 mpopmr3259 mpopmr3359 mpopmr3459);
egen mpfr3034=rsum(mpopfr3059 mpopfr3159 mpopfr3259 mpopfr3359 mpopfr3459);
gen mpm3034=mpmu3034+mpmr3034;
gen mpf3034=mpfu3034+mpfr3034;

egen mpmu3539=rsum(mpopmu3559 mpopmu3659 mpopmu3759 mpopmu3859 mpopmu3959);
egen mpfu3539=rsum(mpopfu3559 mpopfu3659 mpopfu3759 mpopfu3859 mpopfu3959);
egen mpmr3539=rsum(mpopmr3559 mpopmr3659 mpopmr3759 mpopmr3859 mpopmr3959);
egen mpfr3539=rsum(mpopfr3559 mpopfr3659 mpopfr3759 mpopfr3859 mpopfr3959);
gen mpm3539=mpmu3539+mpmr3539;
gen mpf3539=mpfu3539+mpfr3539;

egen mpmu4044=rsum(mpopmu4059 mpopmu4159 mpopmu4259 mpopmu4359 mpopmu4459);
egen mpfu4044=rsum(mpopfu4059 mpopfu4159 mpopfu4259 mpopfu4359 mpopfu4459);
egen mpmr4044=rsum(mpopmr4059 mpopmr4159 mpopmr4259 mpopmr4359 mpopmr4459);
egen mpfr4044=rsum(mpopfr4059 mpopfr4159 mpopfr4259 mpopfr4359 mpopfr4459);
gen mpm4044=mpmu4044+mpmr4044;
gen mpf4044=mpfu4044+mpfr4044;

egen mpmu4549=rsum(mpopmu4559 mpopmu4659 mpopmu4759 mpopmu4859 mpopmu4959);
egen mpfu4549=rsum(mpopfu4559 mpopfu4659 mpopfu4759 mpopfu4859 mpopfu4959);
egen mpmr4549=rsum(mpopmr4559 mpopmr4659 mpopmr4759 mpopmr4859 mpopmr4959);
egen mpfr4549=rsum(mpopfr4559 mpopfr4659 mpopfr4759 mpopfr4859 mpopfr4959);
gen mpm4549=mpmu4549+mpmr4549;
gen mpf4549=mpfu4549+mpfr4549;

egen mpmu5054=rsum(mpopmu5059 mpopmu5159 mpopmu5259 mpopmu5359 mpopmu5459);
egen mpfu5054=rsum(mpopfu5059 mpopfu5159 mpopfu5259 mpopfu5359 mpopfu5459);
egen mpmr5054=rsum(mpopmr5059 mpopmr5159 mpopmr5259 mpopmr5359 mpopmr5459);
egen mpfr5054=rsum(mpopfr5059 mpopfr5159 mpopfr5259 mpopfr5359 mpopfr5459);
gen mpm5054=mpmu5054+mpmr5054;
gen mpf5054=mpfu5054+mpfr5054;

label var mpmu1519 "Married pop., male, 15-19, urban";
label var mpmu1619 "Married pop., male, 16-19, urban";
label var mpmu1819 "Married pop., male, 18-19, urban";
label var mpmu2024 "Married pop., male, 20-24, urban";
label var mpmu2529 "Married pop., male, 25-29, urban";
label var mpmu3034 "Married pop., male, 30-34, urban";
label var mpmu3539 "Married pop., male, 35-39, urban";
label var mpmu4044 "Married pop., male, 40-44, urban";
label var mpmu4549 "Married pop., male, 45-49, urban";

label var mpfu1519 "Married pop., female, 15-19, urban";
label var mpfu1619 "Married pop., female, 16-19, urban";
label var mpfu1819 "Married pop., female, 18-19, urban";
label var mpfu2024 "Married pop., female, 20-24, urban";
label var mpfu2529 "Married pop., female, 25-29, urban";
label var mpfu3034 "Married pop., female, 30-34, urban";
label var mpfu3539 "Married pop., female, 35-39, urban";
label var mpfu4044 "Married pop., female, 40-44, urban";
label var mpfu4549 "Married pop., female, 45-49, urban";

label var mpmr1519 "Married pop., male, 15-19, rural";
label var mpmr1619 "Married pop., male, 16-19, rural";
label var mpmr1819 "Married pop., male, 18-19, rural";
label var mpmr2024 "Married pop., male, 20-24, rural";
label var mpmr2529 "Married pop., male, 25-29, rural";
label var mpmr3034 "Married pop., male, 30-34, rural";
label var mpmr3539 "Married pop., male, 35-39, rural";
label var mpmr4044 "Married pop., male, 40-44, rural";
label var mpmr4549 "Married pop., male, 45-49, rural";

label var mpfr1519 "Married pop., female, 15-19, rural";
label var mpfr1619 "Married pop., female, 16-19, rural";
label var mpfr1819 "Married pop., female, 18-19, rural";
label var mpfr2024 "Married pop., female, 20-24, rural";
label var mpfr2529 "Married pop., female, 25-29, rural";
label var mpfr3034 "Married pop., female, 30-34, rural";
label var mpfr3539 "Married pop., female, 35-39, rural";
label var mpfr4044 "Married pop., female, 40-44, rural";
label var mpfr4549 "Married pop., female, 45-49, rural";


* Proportion married by 5-year age group;
gen marrm151959=(mpmu1519+mpmr1519)/popm151959;
gen marrm161959=(mpmu1619+mpmr1619)/popm161959;
gen marrm181959=(mpmu1819+mpmr1819)/popm181959;
gen marrf151959=(mpfu1519+mpfr1519)/popf151959;
gen marrf161959=(mpfu1619+mpfr1619)/popf161959;
gen marrf181959=(mpfu1819+mpfr1819)/popf181959;
gen marrmu151959=mpmu1519/popmu151959;
gen marrmu161959=mpmu1619/popmu161959;
gen marrmu181959=mpmu1819/popmu181959;
gen marrfu151959=mpfu1519/popfu151959;
gen marrfu161959=mpfu1619/popfu161959;
gen marrfu181959=mpfu1819/popfu181959;
gen marrmr151959=mpmr1519/popmr151959;
gen marrmr161959=mpmr1619/popmr161959;
gen marrmr181959=mpmr1819/popmr181959;
gen marrfr151959=mpfr1519/popfr151959;
gen marrfr161959=mpfr1619/popfr161959;
gen marrfr181959=mpfr1819/popfr181959;

gen marrm202459=(mpmu2024+mpmr2024)/popm202459;
gen marrf202459=(mpfu2024+mpfr2024)/popf202459;
gen marrmu202459=mpmu2024/popmu202459;
gen marrfu202459=mpfu2024/popfu202459;
gen marrmr202459=mpmr2024/popmr202459;
gen marrfr202459=mpfr2024/popfr202459;

gen marrm252959=(mpmu2529+mpmr2529)/popm252959;
gen marrf252959=(mpfu2529+mpfr2529)/popf252959;
gen marrmu252959=mpmu2529/popmu252959;
gen marrfu252959=mpfu2529/popfu252959;
gen marrmr252959=mpmr2529/popmr252959;
gen marrfr252959=mpfr2529/popfr252959;

gen marrm303459=(mpmu3034+mpmr3034)/popm303459;
gen marrf303459=(mpfu3034+mpfr3034)/popf303459;
gen marrmu303459=mpmu3034/popmu303459;
gen marrfu303459=mpfu3034/popfu303459;
gen marrmr303459=mpmr3034/popmr303459;
gen marrfr303459=mpfr3034/popfr303459;

gen marrm353959=(mpmu3539+mpmr3539)/popm353959;
gen marrf353959=(mpfu3539+mpfr3539)/popf353959;
gen marrmu353959=mpmu3539/popmu353959;
gen marrfu353959=mpfu3539/popfu353959;
gen marrmr353959=mpmr3539/popmr353959;
gen marrfr353959=mpfr3539/popfr353959;

gen marrm404459=(mpmu4044+mpmr4044)/popm404459;
gen marrf404459=(mpfu4044+mpfr4044)/popf404459;
gen marrmu404459=mpmu4044/popmu404459;
gen marrfu404459=mpfu4044/popfu404459;
gen marrmr404459=mpmr4044/popmr404459;
gen marrfr404459=mpfr4044/popfr404459;

gen marrm454959=(mpmu4549+mpmr4549)/popm454959;
gen marrf454959=(mpfu4549+mpfr4549)/popf454959;
gen marrmu454959=mpmu4549/popmu454959;
gen marrfu454959=mpfu4549/popfu454959;
gen marrmr454959=mpmr4549/popmr454959;
gen marrfr454959=mpfr4549/popfr454959;

gen marrm505459=(mpmu5054+mpmr5054)/popm505459;
gen marrf505459=(mpfu5054+mpfr5054)/popf505459;
gen marrmu505459=mpmu5054/popmu505459;
gen marrfu505459=mpfu5054/popfu505459;
gen marrmr505459=mpmr5054/popmr505459;
gen marrfr505459=mpfr5054/popfr505459;

gen marrf303959=(mpfu3034+mpfr3034+mpfu3539+mpfr3539)/(popf303459+popf353959);
gen marrfu303959=(mpfu3034+mpfu3539)/(popfu303459+popfu353959);
gen marrfr303959=(mpfr3034+mpfr3539)/(popfr303459+popfr353959);
gen marrf404959=(mpfu4044+mpfr4044+mpfu4549+mpfr4549)/(popf404459+popf454959);
gen marrfu404959=(mpfu4044+mpfu4549)/(popfu404459+popfu454959);
gen marrfr404959=(mpfr4044+mpfr4549)/(popfr404459+popfr454959);

gen marrm303959=(mpmu3034+mpmr3034+mpmu3539+mpmr3539)/(popm303459+popm353959);
gen marrmu303959=(mpmu3034+mpmu3539)/(popmu303459+popmu353959);
gen marrmr303959=(mpmr3034+mpmr3539)/(popmr303459+popmr353959);
gen marrm404959=(mpmu4044+mpmr4044+mpmu4549+mpmr4549)/(popm404459+popm454959);
gen marrmu404959=(mpmu4044+mpmu4549)/(popmu404459+popmu454959);
gen marrmr404959=(mpmr4044+mpmr4549)/(popmr404459+popmr454959);

label var marrmu151959 "Proportion married, men 15-19, urban";
label var marrmu202459 "Proportion married, men 20-24, urban";
label var marrmu252959 "Proportion married, men 25-29, urban";
label var marrmu303459 "Proportion married, men 30-34, urban";
label var marrmu353959 "Proportion married, men 35-39, urban";
label var marrmu404459 "Proportion married, men 40-44, urban";
label var marrmu454959 "Proportion married, men 45-49, urban";

label var marrfu151959 "Proportion married, women 15-19, urban";
label var marrfu202459 "Proportion married, women 20-24, urban";
label var marrfu252959 "Proportion married, women 25-29, urban";
label var marrfu303459 "Proportion married, women 30-34, urban";
label var marrfu353959 "Proportion married, women 35-39, urban";
label var marrfu404459 "Proportion married, women 40-44, urban";
label var marrfu454959 "Proportion married, women 45-49, urban";

label var marrmr151959 "Proportion married, men 15-19, rural";
label var marrmr202459 "Proportion married, men 20-24, rural";
label var marrmr252959 "Proportion married, men 25-29, rural";
label var marrmr303459 "Proportion married, men 30-34, rural";
label var marrmr353959 "Proportion married, men 35-39, rural";
label var marrmr404459 "Proportion married, men 40-44, rural";
label var marrmr454959 "Proportion married, men 45-49, rural";

label var marrfr151959 "Proportion married, women 15-19, rural";
label var marrfr202459 "Proportion married, women 20-24, rural";
label var marrfr252959 "Proportion married, women 25-29, rural";
label var marrfr303459 "Proportion married, women 30-34, rural";
label var marrfr353959 "Proportion married, women 35-39, rural";
label var marrfr404459 "Proportion married, women 40-44, rural";
label var marrfr454959 "Proportion married, women 45-49, rural";


*  Employment to population ratios;
gen epopf151959=(empfu151959+empfr151959)/(popfu151959+popfr151959);
gen epopf161959=(empfu161959+empfr161959)/(popfu161959+popfr161959);
gen epopf181959=(empfu181959+empfr181959)/(popfu181959+popfr181959);
gen epopf202459=(empfu202459+empfr202459)/(popfu202459+popfr202459);
gen epopf252959=(empfu252959+empfr252959)/(popfu252959+popfr252959);
gen epopf303459=(empfu303459+empfr303459)/(popfu303459+popfr303459);
gen epopf353959=(empfu353959+empfr353959)/(popfu353959+popfr353959);
gen epopf404459=(empfu404459+empfr404459)/(popfu404459+popfr404459);
gen epopf454959=(empfu454959+empfr454959)/(popfu454959+popfr454959);
gen epopf505459=(empfu505459+empfr505459)/(popfu505459+popfr505459);
gen epopf555959=(empfu555959+empfr555959)/(popfu555959+popfr555959);

gen epopfu151959=empfu151959/popfu151959;
gen epopfu161959=empfu161959/popfu161959;
gen epopfu181959=empfu181959/popfu181959;
gen epopfu202459=empfu202459/popfu202459;
gen epopfu252959=empfu252959/popfu252959;
gen epopfu303459=empfu303459/popfu303459;
gen epopfu353959=empfu353959/popfu353959;
gen epopfu404459=empfu404459/popfu404459;
gen epopfu454959=empfu454959/popfu454959;
gen epopfu505459=empfu505459/popfu505459;
gen epopfu555959=empfu555959/popfu555959;

gen epopfr151959=empfr151959/popfr151959;
gen epopfr161959=empfr161959/popfr161959;
gen epopfr181959=empfr181959/popfr181959;
gen epopfr202459=empfr202459/popfr202459;
gen epopfr252959=empfr252959/popfr252959;
gen epopfr303459=empfr303459/popfr303459;
gen epopfr353959=empfr353959/popfr353959;
gen epopfr404459=empfr404459/popfr404459;
gen epopfr454959=empfr454959/popfr454959;
gen epopfr505459=empfr505459/popfr505459;
gen epopfr555959=empfr555959/popfr555959;

gen epopfu303959=(empfu303459+empfu353959)/popfu303959;
gen epopfr303959=(empfr303459+empfr353959)/popfr303959;
gen epopf303959=(empfu303459+empfr303459+empfu353959+empfr353959)/popf303959;

gen epopfu404959=(empfu404459+empfu454959)/popfu404959;
gen epopfr404959=(empfr404459+empfr454959)/popfr404959;
gen epopf404959=(empfu404459+empfr404459+empfu454959+empfr454959)/popf404959;

label var epopfu151959 "Employment to pop. ratio, women 15-19, urban";
label var epopfu202459 "Employment to pop. ratio, women 20-24, urban";
label var epopfu252959 "Employment to pop. ratio, women 25-29, urban";
label var epopfu303459 "Employment to pop. ratio, women 30-34, urban";
label var epopfu353959 "Employment to pop. ratio, women 35-39, urban";
label var epopfu404459 "Employment to pop. ratio, women 40-44, urban";


*  Creating 1959-1960 average population by age group to use as denominator for vital statistics data;
egen spopfu1519=rsum(popfu1459 popfu1559 popfu1559 popfu1659 popfu1659 popfu1759 popfu1759 popfu1859 popfu1859 popfu1959);
egen spopfr1519=rsum(popfr1459 popfr1559 popfr1559 popfr1659 popfr1659 popfr1759 popfr1759 popfr1859 popfr1859 popfr1959);
replace spopfu1519=spopfu1519/2;
replace spopfr1519=spopfr1519/2;
gen spopf1519=spopfu1519+spopfr1519;

egen spopfu1619=rsum(popfu1559 popfu1659 popfu1659 popfu1759 popfu1759 popfu1859 popfu1859 popfu1959);
egen spopfr1619=rsum(popfr1559 popfr1659 popfr1659 popfr1759 popfr1759 popfr1859 popfr1859 popfr1959);
replace spopfu1619=spopfu1619/2;
replace spopfr1619=spopfr1619/2;
gen spopf1619=spopfu1619+spopfr1619;

egen spopfu1819=rsum(popfu1759 popfu1859 popfu1859 popfu1959);
egen spopfr1819=rsum(popfr1759 popfr1859 popfr1859 popfr1959);
replace spopfu1819=spopfu1819/2;
replace spopfr1819=spopfr1819/2;
gen spopf1819=spopfu1819+spopfr1819;

egen spopfu2024=rsum(popfu1959 popfu2059 popfu2059 popfu2159 popfu2159 popfu2259 popfu2259 popfu2359 popfu2359 popfu2459);
egen spopfr2024=rsum(popfr1959 popfr2059 popfr2059 popfr2159 popfr2159 popfr2259 popfr2259 popfr2359 popfr2359 popfr2459);
replace spopfu2024=spopfu2024/2;
replace spopfr2024=spopfr2024/2;
gen spopf2024=spopfu2024+spopfr2024;

egen spopfu2529=rsum(popfu2459 popfu2559 popfu2559 popfu2659 popfu2659 popfu2759 popfu2759 popfu2859 popfu2859 popfu2959);
egen spopfr2529=rsum(popfr2459 popfr2559 popfr2559 popfr2659 popfr2659 popfr2759 popfr2759 popfr2859 popfr2859 popfr2959);
replace spopfu2529=spopfu2529/2;
replace spopfr2529=spopfr2529/2;
gen spopf2529=spopfu2529+spopfr2529;

egen spopfu3034=rsum(popfu2959 popfu3059 popfu3059 popfu3159 popfu3159 popfu3259 popfu3259 popfu3359 popfu3359 popfu3459);
egen spopfr3034=rsum(popfr2959 popfr3059 popfr3059 popfr3159 popfr3159 popfr3259 popfr3259 popfr3359 popfr3359 popfr3459);
replace spopfu3034=spopfu3034/2;
replace spopfr3034=spopfr3034/2;
gen spopf3034=spopfu3034+spopfr3034;

egen spopfu3539=rsum(popfu3459 popfu3559 popfu3559 popfu3659 popfu3659 popfu3759 popfu3759 popfu3859 popfu3859 popfu3959);
egen spopfr3539=rsum(popfr3459 popfr3559 popfr3559 popfr3659 popfr3659 popfr3759 popfr3759 popfr3859 popfr3859 popfr3959);
replace spopfu3539=spopfu3539/2;
replace spopfr3539=spopfr3539/2;
gen spopf3539=spopfu3539+spopfr3539;

egen spopfu3039=rsum(popfu2959 popfu3059 popfu3059 popfu3159 popfu3159 popfu3259 popfu3259 popfu3359 popfu3359 popfu3459
        popfu3459 popfu3559 popfu3559 popfu3659 popfu3659 popfu3759 popfu3759 popfu3859 popfu3859 popfu3959);
egen spopfr3039=rsum(popfr2959 popfr3059 popfr3059 popfr3159 popfr3159 popfr3259 popfr3259 popfr3359 popfr3359 popfr3459
        popfr3459 popfr3559 popfr3559 popfr3659 popfr3659 popfr3759 popfr3759 popfr3859 popfr3859 popfr3959);
replace spopfu3039=spopfu3039/2;
replace spopfr3039=spopfr3039/2;
gen spopf3039=spopfu3039+spopfr3039;

egen spopfu4044=rsum(popfu3959 popfu4059 popfu4059 popfu4159 popfu4159 popfu4259 popfu4259 popfu4359 popfu4359 popfu4459);
egen spopfr4044=rsum(popfr3959 popfr4059 popfr4059 popfr4159 popfr4159 popfr4259 popfr4259 popfr4359 popfr4359 popfr4459);
replace spopfu4044=spopfu4044/2;
replace spopfr4044=spopfr4044/2;
gen spopf4044=spopfu4044+spopfr4044;

egen spopfu4549=rsum(popfu4459 popfu4559 popfu4559 popfu4659 popfu4659 popfu4759 popfu4759 popfu4859 popfu4859 popfu4959);
egen spopfr4549=rsum(popfr4459 popfr4559 popfr4559 popfr4659 popfr4659 popfr4759 popfr4759 popfr4859 popfr4859 popfr4959);
replace spopfu4549=spopfu4549/2;
replace spopfr4549=spopfr4549/2;
gen spopf4549=spopfu4549+spopfr4549;

egen spopfu4049=rsum(popfu3959 popfu4059 popfu4059 popfu4159 popfu4159 popfu4259 popfu4259 popfu4359 popfu4359 popfu4459
        popfu4459 popfu4559 popfu4559 popfu4659 popfu4659 popfu4759 popfu4759 popfu4859 popfu4859 popfu4959);
egen spopfr4049=rsum(popfr3959 popfr4059 popfr4059 popfr4159 popfr4159 popfr4259 popfr4259 popfr4359 popfr4359 popfr4459
        popfr4459 popfr4559 popfr4559 popfr4659 popfr4659 popfr4759 popfr4759 popfr4859 popfr4859 popfr4959);
replace spopfu4049=spopfu4049/2;
replace spopfr4049=spopfr4049/2;
gen spopf4049=spopfu4049+spopfr4049;


egen spopmu1519=rsum(popmu1559 popmu1559 popmu1559 popmu1659 popmu1659 popmu1759 popmu1759 popmu1859 popmu1859 popmu1959);
egen spopmr1519=rsum(popmr1559 popmr1559 popmr1559 popmr1659 popmr1659 popmr1759 popmr1759 popmr1859 popmr1859 popmr1959);
replace spopmu1519=spopmu1519/2;
replace spopmr1519=spopmr1519/2;
gen spopm1519=spopmu1519+spopmr1519;

egen spopmu1619=rsum(popmu1559 popmu1659 popmu1659 popmu1759 popmu1759 popmu1859 popmu1859 popmu1959);
egen spopmr1619=rsum(popmr1559 popmr1659 popmr1659 popmr1759 popmr1759 popmr1859 popmr1859 popmr1959);
replace spopmu1619=spopmu1619/2;
replace spopmr1619=spopmr1619/2;
gen spopm1619=spopmu1619+spopmr1619;

egen spopmu1819=rsum(popmu1759 popmu1859 popmu1859 popmu1959);
egen spopmr1819=rsum(popmr1759 popmr1859 popmr1859 popmr1959);
replace spopmu1819=spopmu1819/2;
replace spopmr1819=spopmr1819/2;
gen spopm1819=spopmu1819+spopmr1819;

egen spopmu2024=rsum(popmu1959 popmu2059 popmu2059 popmu2159 popmu2159 popmu2259 popmu2259 popmu2359 popmu2359 popmu2459);
egen spopmr2024=rsum(popmr1959 popmr2059 popmr2059 popmr2159 popmr2159 popmr2259 popmr2259 popmr2359 popmr2359 popmr2459);
replace spopmu2024=spopmu2024/2;
replace spopmr2024=spopmr2024/2;
gen spopm2024=spopmu2024+spopmr2024;

egen spopmu2529=rsum(popmu2459 popmu2559 popmu2559 popmu2659 popmu2659 popmu2759 popmu2759 popmu2859 popmu2859 popmu2959);
egen spopmr2529=rsum(popmr2459 popmr2559 popmr2559 popmr2659 popmr2659 popmr2759 popmr2759 popmr2859 popmr2859 popmr2959);
replace spopmu2529=spopmu2529/2;
replace spopmr2529=spopmr2529/2;
gen spopm2529=spopmu2529+spopmr2529;

egen spopmu3034=rsum(popmu2959 popmu3059 popmu3059 popmu3159 popmu3159 popmu3259 popmu3259 popmu3359 popmu3359 popmu3459);
egen spopmr3034=rsum(popmr2959 popmr3059 popmr3059 popmr3159 popmr3159 popmr3259 popmr3259 popmr3359 popmr3359 popmr3459);
replace spopmu3034=spopmu3034/2;
replace spopmr3034=spopmr3034/2;
gen spopm3034=spopmu3034+spopmr3034;

egen spopmu3539=rsum(popmu3459 popmu3559 popmu3559 popmu3659 popmu3659 popmu3759 popmu3759 popmu3859 popmu3859 popmu3959);
egen spopmr3539=rsum(popmr3459 popmr3559 popmr3559 popmr3659 popmr3659 popmr3759 popmr3759 popmr3859 popmr3859 popmr3959);
replace spopmu3539=spopmu3539/2;
replace spopmr3539=spopmr3539/2;
gen spopm3539=spopmu3539+spopmr3539;

egen spopmu3039=rsum(popmu2959 popmu3059 popmu3059 popmu3159 popmu3159 popmu3259 popmu3259 popmu3359 popmu3359 popmu3459
        popmu3459 popmu3559 popmu3559 popmu3659 popmu3659 popmu3759 popmu3759 popmu3859 popmu3859 popmu3959);
egen spopmr3039=rsum(popmr2959 popmr3059 popmr3059 popmr3159 popmr3159 popmr3259 popmr3259 popmr3359 popmr3359 popmr3459
        popmr3459 popmr3559 popmr3559 popmr3659 popmr3659 popmr3759 popmr3759 popmr3859 popmr3859 popmr3959);
replace spopmu3039=spopmu3039/2;
replace spopmr3039=spopmr3039/2;
gen spopm3039=spopmu3039+spopmr3039;

egen spopmu4044=rsum(popmu3959 popmu4059 popmu4059 popmu4159 popmu4159 popmu4259 popmu4259 popmu4359 popmu4359 popmu4459);
egen spopmr4044=rsum(popmr3959 popmr4059 popmr4059 popmr4159 popmr4159 popmr4259 popmr4259 popmr4359 popmr4359 popmr4459);
replace spopmu4044=spopmu4044/2;
replace spopmr4044=spopmr4044/2;
gen spopm4044=spopmu4044+spopmr4044;

egen spopmu4549=rsum(popmu4459 popmu4559 popmu4559 popmu4659 popmu4659 popmu4759 popmu4759 popmu4859 popmu4859 popmu4959);
egen spopmr4549=rsum(popmr4459 popmr4559 popmr4559 popmr4659 popmr4659 popmr4759 popmr4759 popmr4859 popmr4859 popmr4959);
replace spopmu4549=spopmu4549/2;
replace spopmr4549=spopmr4549/2;
gen spopm4549=spopmu4549+spopmr4549;

egen spopmu4049=rsum(popmu3959 popmu4059 popmu4059 popmu4159 popmu4159 popmu4259 popmu4259 popmu4359 popmu4359 popmu4459
        popmu4459 popmu4559 popmu4559 popmu4659 popmu4659 popmu4759 popmu4759 popmu4859 popmu4859 popmu4959);
egen spopmr4049=rsum(popmr3959 popmr4059 popmr4059 popmr4159 popmr4159 popmr4259 popmr4259 popmr4359 popmr4359 popmr4459
        popmr4459 popmr4559 popmr4559 popmr4659 popmr4659 popmr4759 popmr4759 popmr4859 popmr4859 popmr4959);
replace spopmu4049=spopmu4049/2;
replace spopmr4049=spopmr4049/2;
gen spopm4049=spopmu4049+spopmr4049;


*  1959-1960 average married population by 5-year age group;
egen smpfu1519=rsum(mpopfu15 mpopfu15 mpopfu15 mpopfu16 mpopfu16 mpopfu17 mpopfu17 mpopfu18 mpopfu18 mpopfu19);
replace smpfu1519=smpfu1519/2;
egen smpfr1519=rsum(mpopfr15 mpopfr15 mpopfr15 mpopfr16 mpopfr16 mpopfr17 mpopfr17 mpopfr18 mpopfr18 mpopfr19);
replace smpfr1519=smpfr1519/2;
gen smpf1519=smpfu1519+smpfr1519;

egen smpfu1619=rsum(mpopfu15 mpopfu16 mpopfu16 mpopfu17 mpopfu17 mpopfu18 mpopfu18 mpopfu19);
replace smpfu1619=smpfu1619/2;
egen smpfr1619=rsum(mpopfr15 mpopfr16 mpopfr16 mpopfr17 mpopfr17 mpopfr18 mpopfr18 mpopfr19);
replace smpfr1619=smpfr1619/2;
gen smpf1619=smpfu1619+smpfr1619;

egen smpfu1819=rsum(mpopfu17 mpopfu18 mpopfu18 mpopfu19);
replace smpfu1819=smpfu1619/2;
egen smpfr1819=rsum(mpopfr17 mpopfr18 mpopfr18 mpopfr19);
replace smpfr1819=smpfr1619/2;
gen smpf1819=smpfu1819+smpfr1819;

egen smpfu2024=rsum(mpopfu19 mpopfu20 mpopfu20 mpopfu21 mpopfu21 mpopfu22 mpopfu22 mpopfu23 mpopfu23 mpopfu24);
replace smpfu2024=smpfu2024/2;
egen smpfr2024=rsum(mpopfr19 mpopfr20 mpopfr20 mpopfr21 mpopfr21 mpopfr22 mpopfr22 mpopfr23 mpopfr23 mpopfr24);
replace smpfr2024=smpfr2024/2;
gen smpf2024=smpfu2024+smpfr2024;

egen smpfu2529=rsum(mpopfu24 mpopfu25 mpopfu25 mpopfu26 mpopfu26 mpopfu27 mpopfu27 mpopfu28 mpopfu28 mpopfu29);
replace smpfu2529=smpfu2529/2;
egen smpfr2529=rsum(mpopfr24 mpopfr25 mpopfr25 mpopfr26 mpopfr26 mpopfr27 mpopfr27 mpopfr28 mpopfr28 mpopfr29);
replace smpfr2529=smpfr2529/2;
gen smpf2529=smpfu2529+smpfr2529;

egen smpfu3034=rsum(mpopfu29 mpopfu30 mpopfu30 mpopfu31 mpopfu31 mpopfu32 mpopfu32 mpopfu33 mpopfu33 mpopfu34);
replace smpfu3034=smpfu3034/2;
egen smpfr3034=rsum(mpopfr29 mpopfr30 mpopfr30 mpopfr31 mpopfr31 mpopfr32 mpopfr32 mpopfr33 mpopfr33 mpopfr34);
replace smpfr3034=smpfr3034/2;
gen smpf3034=smpfu3034+smpfr3034;

egen smpfu3539=rsum(mpopfu34 mpopfu35 mpopfu35 mpopfu36 mpopfu36 mpopfu37 mpopfu37 mpopfu38 mpopfu38 mpopfu39);
replace smpfu3539=smpfu3539/2;
egen smpfr3539=rsum(mpopfr34 mpopfr35 mpopfr35 mpopfr36 mpopfr36 mpopfr37 mpopfr37 mpopfr38 mpopfr38 mpopfr39);
replace smpfr3539=smpfr3539/2;
gen smpf3539=smpfu3539+smpfr3539;

egen smpfu3039=rsum(mpopfu29 mpopfu30 mpopfu30 mpopfu31 mpopfu31 mpopfu32 mpopfu32 mpopfu33 mpopfu33 mpopfu34
        mpopfu34 mpopfu35 mpopfu35 mpopfu36 mpopfu36 mpopfu37 mpopfu37 mpopfu38 mpopfu38 mpopfu39);
replace smpfu3039=smpfu3039/2;
egen smpfr3039=rsum(mpopfr29 mpopfr30 mpopfr30 mpopfr31 mpopfr31 mpopfr32 mpopfr32 mpopfr33 mpopfr33 mpopfr34
        mpopfr34 mpopfr35 mpopfr35 mpopfr36 mpopfr36 mpopfr37 mpopfr37 mpopfr38 mpopfr38 mpopfr39);
replace smpfr3039=smpfr3039/2;
gen smpf3039=smpfu3039+smpfr3039;

egen smpfu4044=rsum(mpopfu39 mpopfu40 mpopfu40 mpopfu41 mpopfu41 mpopfu42 mpopfu42 mpopfu43 mpopfu43 mpopfu44);
replace smpfu4044=smpfu4044/2;
egen smpfr4044=rsum(mpopfr39 mpopfr40 mpopfr40 mpopfr41 mpopfr41 mpopfr42 mpopfr42 mpopfr43 mpopfr43 mpopfr44);
replace smpfr4044=smpfr4044/2;
gen smpf4044=smpfu4044+smpfr4044;

egen smpfu4549=rsum(mpopfu44 mpopfu45 mpopfu45 mpopfu46 mpopfu46 mpopfu47 mpopfu47 mpopfu48 mpopfu48 mpopfu49);
replace smpfu4549=smpfu4549/2;
egen smpfr4549=rsum(mpopfr44 mpopfr45 mpopfr45 mpopfr46 mpopfr46 mpopfr47 mpopfr47 mpopfr48 mpopfr48 mpopfr49);
replace smpfr4549=smpfr4549/2;
gen smpf4549=smpfu4549+smpfr4549;

egen smpfu4049=rsum(mpopfu39 mpopfu40 mpopfu40 mpopfu41 mpopfu41 mpopfu42 mpopfu42 mpopfu43 mpopfu43 mpopfu44
        mpopfu44 mpopfu45 mpopfu45 mpopfu46 mpopfu46 mpopfu47 mpopfu47 mpopfu48 mpopfu48 mpopfu49);
replace smpfu4049=smpfu4049/2;
egen smpfr4049=rsum(mpopfr39 mpopfr40 mpopfr40 mpopfr41 mpopfr41 mpopfr42 mpopfr42 mpopfr43 mpopfr43 mpopfr44
        mpopfr44 mpopfr45 mpopfr45 mpopfr46 mpopfr46 mpopfr47 mpopfr47 mpopfr48 mpopfr48 mpopfr49);
replace smpfr4049=smpfr4049/2;
gen smpf4049=smpfu4049+smpfr4049;


egen smpmu1519=rsum(mpopmu15 mpopmu15 mpopmu15 mpopmu16 mpopmu16 mpopmu17 mpopmu17 mpopmu18 mpopmu18 mpopmu19);
replace smpmu1519=smpmu1519/2;
egen smpmr1519=rsum(mpopmr15 mpopmr15 mpopmr15 mpopmr16 mpopmr16 mpopmr17 mpopmr17 mpopmr18 mpopmr18 mpopmr19);
replace smpmr1519=smpmr1519/2;
gen smpm1519=smpmu1519+smpmr1519;

egen smpmu1619=rsum(mpopmu15 mpopmu16 mpopmu16 mpopmu17 mpopmu17 mpopmu18 mpopmu18 mpopmu19);
replace smpmu1619=smpmu1619/2;
egen smpmr1619=rsum(mpopmr15 mpopmr16 mpopmr16 mpopmr17 mpopmr17 mpopmr18 mpopmr18 mpopmr19);
replace smpmr1619=smpmr1619/2;
gen smpm1619=smpmu1619+smpmr1619;

egen smpmu1819=rsum(mpopmu17 mpopmu18 mpopmu18 mpopmu19);
replace smpmu1619=smpmu1619/2;
egen smpmr1819=rsum(mpopmr17 mpopmr18 mpopmr18 mpopmr19);
replace smpmr1619=smpmr1619/2;
gen smpm1819=smpmu1819+smpmr1819;

egen smpmu2024=rsum(mpopmu19 mpopmu20 mpopmu20 mpopmu21 mpopmu21 mpopmu22 mpopmu22 mpopmu23 mpopmu23 mpopmu24);
replace smpmu2024=smpmu2024/2;
egen smpmr2024=rsum(mpopmr19 mpopmr20 mpopmr20 mpopmr21 mpopmr21 mpopmr22 mpopmr22 mpopmr23 mpopmr23 mpopmr24);
replace smpmr2024=smpmr2024/2;
gen smpm2024=smpmu2024+smpmr2024;

egen smpmu2529=rsum(mpopmu24 mpopmu25 mpopmu25 mpopmu26 mpopmu26 mpopmu27 mpopmu27 mpopmu28 mpopmu28 mpopmu29);
replace smpmu2529=smpmu2529/2;
egen smpmr2529=rsum(mpopmr24 mpopmr25 mpopmr25 mpopmr26 mpopmr26 mpopmr27 mpopmr27 mpopmr28 mpopmr28 mpopmr29);
replace smpmr2529=smpmr2529/2;
gen smpm2529=smpmu2529+smpmr2529;

egen smpmu3034=rsum(mpopmu29 mpopmu30 mpopmu30 mpopmu31 mpopmu31 mpopmu32 mpopmu32 mpopmu33 mpopmu33 mpopmu34);
replace smpmu3034=smpmu3034/2;
egen smpmr3034=rsum(mpopmr29 mpopmr30 mpopmr30 mpopmr31 mpopmr31 mpopmr32 mpopmr32 mpopmr33 mpopmr33 mpopmr34);
replace smpmr3034=smpmr3034/2;
gen smpm3034=smpmu3034+smpmr3034;

egen smpmu3539=rsum(mpopmu34 mpopmu35 mpopmu35 mpopmu36 mpopmu36 mpopmu37 mpopmu37 mpopmu38 mpopmu38 mpopmu39);
replace smpmu3539=smpmu3539/2;
egen smpmr3539=rsum(mpopmr34 mpopmr35 mpopmr35 mpopmr36 mpopmr36 mpopmr37 mpopmr37 mpopmr38 mpopmr38 mpopmr39);
replace smpmr3539=smpmr3539/2;
gen smpm3539=smpmu3539+smpmr3539;

egen smpmu3039=rsum(mpopmu29 mpopmu30 mpopmu30 mpopmu31 mpopmu31 mpopmu32 mpopmu32 mpopmu33 mpopmu33 mpopmu34
        mpopmu34 mpopmu35 mpopmu35 mpopmu36 mpopmu36 mpopmu37 mpopmu37 mpopmu38 mpopmu38 mpopmu39);
replace smpmu3039=smpmu3039/2;
egen smpmr3039=rsum(mpopmr29 mpopmr30 mpopmr30 mpopmr31 mpopmr31 mpopmr32 mpopmr32 mpopmr33 mpopmr33 mpopmr34
        mpopmr34 mpopmr35 mpopmr35 mpopmr36 mpopmr36 mpopmr37 mpopmr37 mpopmr38 mpopmr38 mpopmr39);
replace smpmr3039=smpmr3039/2;
gen smpm3039=smpmu3039+smpmr3039;

egen smpmu4044=rsum(mpopmu39 mpopmu40 mpopmu40 mpopmu41 mpopmu41 mpopmu42 mpopmu42 mpopmu43 mpopmu43 mpopmu44);
replace smpmu4044=smpmu4044/2;
egen smpmr4044=rsum(mpopmr39 mpopmr40 mpopmr40 mpopmr41 mpopmr41 mpopmr42 mpopmr42 mpopmr43 mpopmr43 mpopmr44);
replace smpmr4044=smpmr4044/2;
gen smpm4044=smpmu4044+smpmr4044;

egen smpmu4549=rsum(mpopmu44 mpopmu45 mpopmu45 mpopmu46 mpopmu46 mpopmu47 mpopmu47 mpopmu48 mpopmu48 mpopmu49);
replace smpmu4549=smpmu4549/2;
egen smpmr4549=rsum(mpopmr44 mpopmr45 mpopmr45 mpopmr46 mpopmr46 mpopmr47 mpopmr47 mpopmr48 mpopmr48 mpopmr49);
replace smpmr4549=smpmr4549/2;
gen smpm4549=smpmu4549+smpmr4549;

egen smpmu4049=rsum(mpopmu39 mpopmu40 mpopmu40 mpopmu41 mpopmu41 mpopmu42 mpopmu42 mpopmu43 mpopmu43 mpopmu44
        mpopmu44 mpopmu45 mpopmu45 mpopmu46 mpopmu46 mpopmu47 mpopmu47 mpopmu48 mpopmu48 mpopmu49);
replace smpmu4049=smpmu4049/2;
egen smpmr4049=rsum(mpopmr39 mpopmr40 mpopmr40 mpopmr41 mpopmr41 mpopmr42 mpopmr42 mpopmr43 mpopmr43 mpopmr44
        mpopmr44 mpopmr45 mpopmr45 mpopmr46 mpopmr46 mpopmr47 mpopmr47 mpopmr48 mpopmr48 mpopmr49);
replace smpmr4049=smpmr4049/2;
gen smpm4049=smpmu4049+smpmr4049;


*  Death rate from abortions adjusted for age-specific births;
*  Abortion death data are for <=15, 16-17, 18-19, 20-24, 25-29, 30-39 and 40-49;
*  abo16_59 is abortion deaths for age 16+age17, etc.;
gen dabobth1559=((abo15_59+abo16_59+abo18_59)/bth15_59)*100;
gen dabobthu1559=((abourb15_59+abourb16_59+abourb18_59)/bthu15_59)*100;
gen dabobthr1559=((aborur15_59+aborur16_59+aborur18_59)/bthr15_59)*100;
gen dabobth1659=((abo16_59+abo18_59)/bth16_59)*100;
gen dabobthu1659=((abourb16_59+abourb18_59)/bthu16_59)*100;
gen dabobthr1659=((aborur16_59+aborur18_59)/bthr16_59)*100;
gen dabobth1859=(abo18_59/bth18_59)*100;
gen dabobthu1859=(abourb18_59/bthu18_59)*100;
gen dabobthr1859=(aborur18_59/bthr18_59)*100;
gen dabobth2059=(abo20_59/bth20_59)*100;
gen dabobthu2059=(abourb20_59/bthu20_59)*100;
gen dabobthr2059=(aborur20_59/bthr20_59)*100;
gen dabobth2559=(abo25_59/bth25_59)*100;
gen dabobthu2559=(abourb25_59/bthu25_59)*100;
gen dabobthr2559=(aborur25_59/bthr25_59)*100;
gen dabobth3059=(abo30_59/(bth30_59+bth35_59))*100;
gen dabobthu3059=(abourb30_59/(bthu30_59+bthu35_59))*100;
gen dabobthr3059=(aborur30_59/(bthr30_59+bthr35_59))*100;
gen dabobth4059=(abo40_59/(bth40_59+bth45_59))*100;
gen dabobthu4059=(abourb40_59/(bthu40_59+bthu45_59))*100;
gen dabobthr4059=(aborur40_59/(bthr40_59+bthr45_59))*100;

label var dabobthu1659 "Deaths due to abortion age 16-19/births 16-19, urban";
label var dabobthu2059 "Deaths due to abortion age 20-24/births 20-24, urban";
label var dabobthu2559 "Deaths due to abortion age 25-29/births 25-29, urban";
label var dabobthu3059 "Deaths due to abortion age 30-39/births 30-39, urban";
label var dabobthu4059 "Deaths due to abortion age 40-49/births 40-49, urban";

label var dabobthr1659 "Deaths due to abortion age 16-19/births 16-19, rural";
label var dabobthr2059 "Deaths due to abortion age 20-24/births 20-24, rural";
label var dabobthr2559 "Deaths due to abortion age 25-29/births 25-29, rural";
label var dabobthr3059 "Deaths due to abortion age 30-39/births 30-39, rural";
label var dabobthr4059 "Deaths due to abortion age 40-49/births 40-49, rural";

*  Death rate from homicides;
*  Homicide death data are for <=15, 16-17, 18-19, 20-24, 25-29, 30-39 and 40-49;
*  homf16_59 is homide deaths for age 16+age17, etc.;
gen dhomf1559=((homf15_59+homf16_59+homf18_59)/spopf1519)*100000;
gen dhomf1659=((homf16_59+homf18_59)/spopf1619)*100000;
gen dhomf1859=(homf18_59/spopf1819)*100000;
gen dhomfu1559=((homfu15_59+homfu16_59+homfu18_59)/spopfu1519)*100000;
gen dhomfu1659=((homfu16_59+homfu18_59)/spopfu1619)*100000;
gen dhomfu1859=(homfu18_59/spopfu1819)*100000;
gen dhomfr1559=((homfr15_59+homfr16_59+homfr18_59)/spopfr1519)*100000;
gen dhomfr1659=((homfr16_59+homfr18_59)/spopfr1619)*100000;
gen dhomfr1859=(homfr18_59/spopfr1819)*100000;
gen dhomf2059=(homf20_59/spopf2024)*100000;
gen dhomfu2059=(homfu20_59/spopfu2024)*100000;
gen dhomfr2059=(homfr20_59/spopfr2024)*100000;
gen dhomf2559=(homf25_59/spopf2529)*100000;
gen dhomfu2559=(homfu25_59/spopfu2529)*100000;
gen dhomfr2559=(homfr25_59/spopfr2529)*100000;
gen dhomf3059=(homf30_59/spopf3039)*100000;
gen dhomfu3059=(homfu30_59/spopfu3039)*100000;
gen dhomfr3059=(homfr30_59/spopfr3039)*100000;
gen dhomf4059=(homf40_59/spopf4049)*100000;
gen dhomfu4059=(homfu40_59/spopfu4049)*100000;
gen dhomfr4059=(homfr40_59/spopfr4049)*100000;

* Death rates by 5-year age group;
gen asdrf1519=df19/spopf1519;
gen asdrf2024=df24/spopf2024;
gen asdrf2529=df29/spopf2529;
gen asdrf3034=df34/spopf3034;
gen asdrf3539=df39/spopf3539;
gen asdrf3039=(df34+df39)/(spopf3034+spopf3539);
gen asdrf4044=df44/spopf4044;
gen asdrf4549=df49/spopf4549;
gen asdrf4049=(df44+df49)/(spopf4044+spopf4549);

gen asdrfu1519=dfu19/spopfu1519;
gen asdrfu2024=dfu24/spopfu2024;
gen asdrfu2529=dfu29/spopfu2529;
gen asdrfu3034=dfu34/spopfu3034;
gen asdrfu3539=dfu39/spopfu3539;
gen asdrfu3039=(dfu34+dfu39)/(spopfu3034+spopfu3539);
gen asdrfu4044=dfu44/spopfu4044;
gen asdrfu4549=dfu49/spopfu4549;
gen asdrfu4049=(dfu44+dfu49)/(spopfu4044+spopfu4549);

gen asdrfr1519=dfr19/spopfr1519;
gen asdrfr2024=dfr24/spopfr2024;
gen asdrfr2529=dfr29/spopfr2529;
gen asdrfr3034=dfr34/spopfr3034;
gen asdrfr3539=dfr39/spopfr3539;
gen asdrfr3039=(dfr34+dfr39)/(spopfr3034+spopfr3539);
gen asdrfr4044=dfr44/spopfr4044;
gen asdrfr4549=dfr49/spopfr4549;
gen asdrfr4049=(dfr44+dfr49)/(spopfr4044+spopfr4549);

label var asdrfu1519 "Death rate, women age 15-19, urban";
label var asdrfu2024 "Death rate, women age 20-24, urban";
label var asdrfu2529 "Death rate, women age 25-29, urban";
label var asdrfu3034 "Death rate, women age 30-34, urban";
label var asdrfu3539 "Death rate, women age 35-39, urban";
label var asdrfu4044 "Death rate, women age 40-44, urban";

label var asdrfr1519 "Death rate, women age 15-19, rural";
label var asdrfr2024 "Death rate, women age 20-24, rural";
label var asdrfr2529 "Death rate, women age 25-29, rural";
label var asdrfr3034 "Death rate, women age 30-34, rural";
label var asdrfr3539 "Death rate, women age 35-39, rural";
label var asdrfr4044 "Death rate, women age 40-44, rural";

*  Proportion of out-of-wedlock births;
*  High proportion for Perm 40-44 rural appears correct;
gen nodad151959=bthnd15_59/bth15_59;
gen nodad161959=bthnd16_59/bth16_59;
gen nodadu151959=bthndu15_59/bthu15_59;
gen nodadu161959=bthndu16_59/bthu16_59;
gen nodadr151959=bthndr15_59/bthr15_59;
gen nodadr161959=bthndr16_59/bthr16_59;
gen nodad202459=bthnd20_59/bth20_59;
gen nodadu202459=bthndu20_59/bthu20_59;
gen nodadr202459=bthndr20_59/bthr20_59;
gen nodad252959=bthnd25_59/bth25_59;
gen nodadu252959=bthndu25_59/bthu25_59;
gen nodadr252959=bthndr25_59/bthr25_59;
gen nodad303459=bthnd30_59/bth30_59;
gen nodadu303459=bthndu30_59/bthu30_59;
gen nodadr303459=bthndr30_59/bthr30_59;
gen nodad353959=bthnd35_59/bth35_59;
gen nodadu353959=bthndu35_59/bthu35_59;
gen nodadr353959=bthndr35_59/bthr35_59;
gen nodad404459=bthnd40_59/bth40_59;
gen nodadu404459=bthndu40_59/bthu40_59;
gen nodadr404459=bthndr40_59/bthr40_59;
gen nodad303959=(bthnd30_59+bthnd35_59)/(bth30_59+bth35_59);
gen nodadu303959=(bthndu30_59+bthndu35_59)/(bthu30_59+bthu35_59);
gen nodadr303959=(bthndr30_59+bthndr35_59)/(bthr30_59+bthr35_59);
gen nodad404959=(bthnd40_59+bthnd45_59)/(bth40_59+bth45_59);
gen nodadu404959=(bthndu40_59+bthndu45_59)/(bthu40_59+bthu45_59);
gen nodadr404959=(bthndr40_59+bthndr45_59)/(bthr40_59+bthr45_59);

gen nodad454959=.;
gen nodadu454959=.;
gen nodadr454959=.;

label var nodadu161959 "Share of out of wedlock births age 16-19, urban";
label var nodadu202459 "Share of out of wedlock births age 20-24, urban";
label var nodadu252959 "Share of out of wedlock births age 25-29, urban";
label var nodadu303459 "Share of out of wedlock births age 30-34, urban";
label var nodadu353959 "Share of out of wedlock births age 35-39, urban";
label var nodadu404459 "Share of out of wedlock births age 40-44, urban";

label var nodadr161959 "Share of out of wedlock births age 16-19, rural";
label var nodadr202459 "Share of out of wedlock births age 20-24, rural";
label var nodadr252959 "Share of out of wedlock births age 25-29, rural";
label var nodadr303459 "Share of out of wedlock births age 30-34, rural";
label var nodadr353959 "Share of out of wedlock births age 35-39, rural";
label var nodadr404459 "Share of out of wedlock births age 40-44, rural";


*  Marital birth rate;
*  Kamchatka marital birth rate = 0 for 15-19 rural (100% out of wedlock);
gen brthm1559=bth15_59-bthnd15_59;
gen brthmu1559=bthu15_59-bthndu15_59;
gen brthmr1559=bthr15_59-bthndr15_59;
gen brthm1659=bth16_59-bthnd16_59;
gen brthmu1659=bthu16_59-bthndu16_59;
gen brthmr1659=bthr16_59-bthndr16_59;
gen brthm2059=bth20_59-bthnd20_59;
gen brthmu2059=bthu20_59-bthndu20_59;
gen brthmr2059=bthr20_59-bthndr20_59;
gen brthm2559=bth25_59-bthnd25_59;
gen brthmu2559=bthu25_59-bthndu25_59;
gen brthmr2559=bthr25_59-bthndr25_59;
gen brthm3059=bth30_59-bthnd30_59;
gen brthmu3059=bthu30_59-bthndu30_59;
gen brthmr3059=bthr30_59-bthndr30_59;
gen brthm3559=bth35_59-bthnd35_59;
gen brthmu3559=bthu35_59-bthndu35_59;
gen brthmr3559=bthr35_59-bthndr35_59;
gen brthm303959=brthm3059+brthm3559;
gen brthmu303959=brthmu3059+brthmu3559;
gen brthmr303959=brthmr3059+brthmr3559;
gen brthm4059=bth40_59-bthnd40_59;
gen brthmu4059=bthu40_59-bthndu40_59;
gen brthmr4059=bthr40_59-bthndr40_59;

gen asbrm1559=((brthmu1559+brthmr1559)/smpf1519)*1000;
gen asbrmu1559=(brthmu1559/smpfu1519)*1000;
gen asbrmr1559=(brthmr1559/smpfr1519)*1000;
replace asbrm1559=asbrmu1559 if regno==7 | regno==16;

gen asbrm1659=((brthmu1659+brthmr1659)/smpf1619)*1000;
gen asbrmu1659=(brthmu1659/smpfu1619)*1000;
gen asbrmr1659=(brthmr1659/smpfr1619)*1000;
replace asbrm1659=asbrmu1659 if regno==7 | regno==16;

gen asbrm2059=((brthmu2059+brthmr2059)/smpf2024)*1000;
gen asbrmu2059=(brthmu2059/smpfu2024)*1000;
gen asbrmr2059=(brthmr2059/smpfr2024)*1000;
replace asbrm2059=asbrmu2059 if regno==7 | regno==16;

gen asbrm2559=((brthmu2559+brthmr2559)/smpf2529)*1000;
gen asbrmu2559=(brthmu2559/smpfu2529)*1000;
gen asbrmr2559=(brthmr2559/smpfr2529)*1000;
replace asbrm2559=asbrmu2559 if regno==7 | regno==16;

gen asbrm3059=((brthmu3059+brthmr3059)/smpf3034)*1000;
gen asbrmu3059=(brthmu3059/smpfu3034)*1000;
gen asbrmr3059=(brthmr3059/smpfr3034)*1000;
replace asbrm3059=asbrmu3059 if regno==7 | regno==16;

gen asbrm3559=((brthmu3559+brthmr3559)/smpf3539)*1000;
gen asbrmu3559=(brthmu3559/smpfu3539)*1000;
gen asbrmr3559=(brthmr3559/smpfr3539)*1000;
replace asbrm3559=asbrmu3559 if regno==7 | regno==16;

gen asbrm4059=((brthmu4059+brthmr4059)/smpf4044)*1000;
gen asbrmu4059=(brthmu4059/smpfu4044)*1000;
gen asbrmr4059=(brthmr4059/smpfr4044)*1000;
replace asbrm4059=asbrmu4059 if regno==7 | regno==16;

gen asbrm4559=.;
gen asbrmu4559=.;
gen asbrmr4559=.;

label var asbrmu1659 "Marital births per 1000 married women age 16-19, urban";
label var asbrmu2059 "Marital births per 1000 married women age 20-24, urban";
label var asbrmu2559 "Marital births per 1000 married women age 25-29, urban";
label var asbrmu3059 "Marital births per 1000 married women age 30-34, urban";
label var asbrmu3559 "Marital births per 1000 married women age 35-39, urban";
label var asbrmu4059 "Marital births per 1000 married women age 40-44, urban";

label var asbrmr1659 "Marital births per 1000 married women age 16-19, rural";
label var asbrmr2059 "Marital births per 1000 married women age 20-24, rural";
label var asbrmr2559 "Marital births per 1000 married women age 25-29, rural";
label var asbrmr3059 "Marital births per 1000 married women age 30-34, rural";
label var asbrmr3559 "Marital births per 1000 married women age 35-39, rural";
label var asbrmr4059 "Marital births per 1000 married women age 40-44, rural";

*  Unwed birth rate;
gen unmarfu151959=popfu151959-mpfu1519;
gen unmarfu161959=popfu161959-mpfu1619;
gen unmarfu181959=popfu181959-mpfu1819;
gen unmarfr151959=popfr151959-mpfr1519;
gen unmarfr161959=popfr161959-mpfr1619;
gen unmarfr181959=popfr181959-mpfr1819;
gen unmarf151959=unmarfu151959+unmarfr151959;
gen unmarf161959=unmarfu161959+unmarfr161959;
gen unmarf181959=unmarfu181959+unmarfr181959;
gen unmarfu202459=popfu202459-mpfu2024;
gen unmarfr202459=popfr202459-mpfr2024;
gen unmarf202459=unmarfu202459+unmarfr202459;
gen unmarfu252959=popfu252959-mpfu2529;
gen unmarfr252959=popfr252959-mpfr2529;
gen unmarf252959=unmarfu252959+unmarfr252959;
gen unmarfu303459=popfu303459-mpfu3034;
gen unmarfr303459=popfr303459-mpfr3034;
gen unmarf303459=unmarfu303459+unmarfr303459;
gen unmarfu353959=popfu353959-mpfu3539;
gen unmarfr353959=popfr353959-mpfr3539;
gen unmarf353959=unmarfu353959+unmarfr353959;
gen unmarfu404459=popfu404459-mpfu4044;
gen unmarfr404459=popfr404459-mpfr4044;
gen unmarf404459=unmarfu404459+unmarfr404459;
gen unmarfu454959=popfu454959-mpfu4549;
gen unmarfr454959=popfr454959-mpfr4549;
gen unmarf454959=unmarfu454959+unmarfr454959;
gen unmarf303959=unmarf303459+unmarf353959;
gen unmarfu303959=unmarfu303459+unmarfu353959;
gen unmarfr303959=unmarfr303459+unmarfr353959;
gen unmarf404959=unmarf404459+unmarf454959;
gen unmarfu404959=unmarfu404459+unmarfu454959;
gen unmarfr404959=unmarfr404459+unmarfr454959;

gen sunmarfu1519=spopfu1519-smpfu1519;
gen sunmarfr1519=spopfr1519-smpfr1519;
gen sunmarf1519=sunmarfu1519+sunmarfr1519;
gen sunmarfu1619=spopfu1619-smpfu1619;
gen sunmarfr1619=spopfr1619-smpfr1619;
gen sunmarf1619=sunmarfu1619+sunmarfr1619;
gen sunmarfu1819=spopfu1819-smpfu1819;
gen sunmarfr1819=spopfr1819-smpfr1819;
gen sunmarf1819=sunmarfu1819+sunmarfr1819;
gen sunmarfu2024=spopfu2024-smpfu2024;
gen sunmarfr2024=spopfr2024-smpfr2024;
gen sunmarf2024=sunmarfu2024+sunmarfr2024;
gen sunmarfu2529=spopfu2529-smpfu2529;
gen sunmarfr2529=spopfr2529-smpfr2529;
gen sunmarf2529=sunmarfu2529+sunmarfr2529;
gen sunmarfu3034=spopfu3034-smpfu3034;
gen sunmarfr3034=spopfr3034-smpfr3034;
gen sunmarf3034=sunmarfu3034+sunmarfr3034;
gen sunmarfu3539=spopfu3539-smpfu3539;
gen sunmarfr3539=spopfr3539-smpfr3539;
gen sunmarf3539=sunmarfu3539+sunmarfr3539;
gen sunmarfu3039=spopfu3039-smpfu3039;
gen sunmarfr3039=spopfr3039-smpfr3039;
gen sunmarf3039=sunmarfu3039+sunmarfr3039;
gen sunmarfu4044=spopfu4044-smpfu4044;
gen sunmarfr4044=spopfr4044-smpfr4044;
gen sunmarf4044=sunmarfu4044+sunmarfr4044;
gen sunmarfu4549=spopfu4549-smpfu4549;
gen sunmarfr4549=spopfr4549-smpfr4549;
gen sunmarf4549=sunmarfu4549+sunmarfr4549;
gen sunmarfu4049=spopfu4049-smpfu4049;
gen sunmarfr4049=spopfr4049-smpfr4049;
gen sunmarf4049=sunmarfu4049+sunmarfr4049;

gen sunmarmu1519=spopmu1519-smpmu1519;
gen sunmarmr1519=spopmr1519-smpmr1519;
gen sunmarm1519=sunmarmu1519+sunmarmr1519;
gen sunmarmu1619=spopmu1619-smpmu1619;
gen sunmarmr1619=spopmr1619-smpmr1619;
gen sunmarm1619=sunmarmu1619+sunmarmr1619;
gen sunmarmu1819=spopmu1819-smpmu1819;
gen sunmarmr1819=spopmr1819-smpmr1819;
gen sunmarm1819=sunmarmu1819+sunmarmr1819;
gen sunmarmu2024=spopmu2024-smpmu2024;
gen sunmarmr2024=spopmr2024-smpmr2024;
gen sunmarm2024=sunmarmu2024+sunmarmr2024;
gen sunmarmu2529=spopmu2529-smpmu2529;
gen sunmarmr2529=spopmr2529-smpmr2529;
gen sunmarm2529=sunmarmu2529+sunmarmr2529;
gen sunmarmu3034=spopmu3034-smpmu3034;
gen sunmarmr3034=spopmr3034-smpmr3034;
gen sunmarm3034=sunmarmu3034+sunmarmr3034;
gen sunmarmu3539=spopmu3539-smpmu3539;
gen sunmarmr3539=spopmr3539-smpmr3539;
gen sunmarm3539=sunmarmu3539+sunmarmr3539;
gen sunmarmu3039=spopmu3039-smpmu3039;
gen sunmarmr3039=spopmr3039-smpmr3039;
gen sunmarm3039=sunmarmu3039+sunmarmr3039;
gen sunmarmu4044=spopmu4044-smpmu4044;
gen sunmarmr4044=spopmr4044-smpmr4044;
gen sunmarm4044=sunmarmu4044+sunmarmr4044;
gen sunmarmu4549=spopmu4549-smpmu4549;
gen sunmarmr4549=spopmr4549-smpmr4549;
gen sunmarm4549=sunmarmu4549+sunmarmr4549;
gen sunmarmu4049=spopmu4049-smpmu4049;
gen sunmarmr4049=spopmr4049-smpmr4049;
gen sunmarm4049=sunmarmu4049+sunmarmr4049;


gen asbrnd1559=(bthnd15_59/sunmarf1519)*1000;
gen asbrnd1659=(bthnd16_59/sunmarf1619)*1000;
gen asbrndu1559=(bthndu15_59/sunmarfu1519)*1000;
gen asbrndu1659=(bthndu16_59/sunmarfu1619)*1000;
gen asbrndr1559=(bthndr15_59/sunmarfr1519)*1000;
gen asbrndr1659=(bthndr16_59/sunmarfr1619)*1000;
replace asbrnd1559=asbrndu1559 if regno==7 | regno==16;
replace asbrnd1659=asbrndu1659 if regno==7 | regno==16;

gen asbrnd2059=(bthnd20_59/sunmarf2024)*1000;
gen asbrndu2059=(bthndu20_59/sunmarfu2024)*1000;
gen asbrndr2059=(bthndr20_59/sunmarfr2024)*1000;
replace asbrnd2059=asbrndu2059 if regno==7 | regno==16;

gen asbrnd2559=(bthnd25_59/sunmarf2529)*1000;
gen asbrndu2559=(bthndu25_59/sunmarfu2529)*1000;
gen asbrndr2559=(bthndr25_59/sunmarfr2529)*1000;
replace asbrnd2559=asbrndu2559 if regno==7 | regno==16;

gen asbrnd3059=(bthnd30_59/sunmarf3034)*1000;
gen asbrndu3059=(bthndu30_59/sunmarfu3034)*1000;
gen asbrndr3059=(bthndr30_59/sunmarfr3034)*1000;
replace asbrnd3059=asbrndu3059 if regno==7 | regno==16;

gen asbrnd3559=(bthnd35_59/sunmarf3539)*1000;
gen asbrndu3559=(bthndu35_59/sunmarfu3539)*1000;
gen asbrndr3559=(bthndr35_59/sunmarfr3539)*1000;
replace asbrnd3559=asbrndu3559 if regno==7 | regno==16;

gen asbrnd303959=((bthnd30_59+bthnd35_59)/sunmarf3039)*1000;
gen asbrndu303959=((bthndu30_59+bthndu35_59)/sunmarfu3039)*1000;
gen asbrndr303959=((bthndr30_59+bthndr35_59)/sunmarfr3039)*1000;
replace asbrnd303959=asbrndu303959 if regno==7 | regno==16;

gen asbrnd4059=(bthnd40_59/sunmarf4044)*1000;
gen asbrndu4059=(bthndu40_59/sunmarfu4044)*1000;
gen asbrndr4059=(bthndr40_59/sunmarfr4044)*1000;
replace asbrnd4059=asbrndu4059 if regno==7 | regno==16;

gen asbrnd404959=((bthnd40_59+bthnd45_59)/sunmarf4049)*1000;
gen asbrndu404959=((bthndu40_59+bthndu45_59)/sunmarfu4049)*1000;
gen asbrndr404959=((bthndr40_59+bthndr45_59)/sunmarfr4049)*1000;
replace asbrnd404959=asbrndu404959 if regno==7 | regno==16;

gen asbrnd4559=.;
gen asbrndu4559=.;
gen asbrndr4559=.;

label var asbrndu1659 "Nonmarital births per 1000 unmarried women age 16-19, urban";
label var asbrndu2059 "Nonmarital births per 1000 unmarried women age 20-24, urban";
label var asbrndu2559 "Nonmarital births per 1000 unmarried women age 25-29, urban";
label var asbrndu3059 "Nonmarital births per 1000 unmarried women age 30-34, urban";
label var asbrndu3559 "Nonmarital births per 1000 unmarried women age 35-39, urban";
label var asbrndu4059 "Nonmarital births per 1000 unmarried women age 40-44, urban";

*  Dropping Kamchatka for age 16-19 because nonmarital births look wrong;
replace asbrm1659=. if regno==85;
replace asbrmu1659=. if regno==85;
replace asbrmr1659=. if regno==85;
replace asbrnd1659=. if regno==85;
replace asbrndu1659=. if regno==85;
replace asbrndr1659=. if regno==85;
replace nodad1619=. if regno==85;
replace nodadu1619=. if regno==85;
replace nodadr1619=. if regno==85;
replace bthnd16_59=. if regno==85;
replace bthndu16_59=. if regno==85;
replace bthndr16_59=. if regno==85;


*  % marriages with a very large (11+ year) gap in ages between men and women at marriage in 1959;
gen vlargegap1619u=(f1619m3034u+f1619m3539u+f1619m4044u+f1619m4549u+f1619m5054u+f1619m5559u+f1619m60u)/nmarruf16;
gen vlargegap2024u=(f2024m3539u+f2024m4044u+f2024m4549u+f2024m5054u+f2024m5559u+f2024m60u)/nmarruf20;
gen vlargegap2529u=(f2529m4044u+f2529m4549u+f2529m5054u+f2529m5559u+f2529m60u)/nmarruf25;
gen vlargegap3034u=(f3034m1619u+f3034m4549u+f3034m5054u+f3034m5559u+f3034m60u)/nmarruf30;
gen vlargegap3539u=(f3539m1619u+f3539m2024u+f3539m5054u+f3539m5559u+f3539m60u)/nmarruf35;
gen vlargegap4044u=(f4044m1619u+f4044m2024u+f4044m2529u+f4044m5559u+f4044m60u)/nmarruf40;
gen vlargegap4549u=(f4549m1619u+f4549m2024u+f4549m2529u+f4549m60u)/nmarruf45;

gen vlargegap1619r=(f1619m3034r+f1619m3539r+f1619m4044r+f1619m4549r+f1619m5054r+f1619m5559r+f1619m60r)/nmarrrf16;
gen vlargegap2024r=(f2024m3539r+f2024m4044r+f2024m4549r+f2024m5054r+f2024m5559r+f2024m60r)/nmarrrf20;
gen vlargegap2529r=(f2529m4044r+f2529m4549r+f2529m5054r+f2529m5559r+f2529m60r)/nmarrrf25;
gen vlargegap3034r=(f3034m1619r+f3034m4549r+f3034m5054r+f3034m5559r+f3034m60r)/nmarrrf30;
gen vlargegap3539r=(f3539m1619r+f3539m2024r+f3539m5054r+f3539m5559r+f3539m60r)/nmarrrf35;
gen vlargegap4044r=(f4044m1619r+f4044m2024r+f4044m2529r+f4044m5559r+f4044m60r)/nmarrrf40;
gen vlargegap4549r=(f4549m1619r+f4549m2024r+f4549m2529r+f4549m60r)/nmarrrf45;

gen vlargegap1619= (f1619m3034u+f1619m3539u+f1619m4044u+f1619m4549u+f1619m5054u+f1619m5559u+f1619m60u+
                   f1619m3034r+f1619m3539r+f1619m4044r+f1619m4549r+f1619m5054r+f1619m5559r+f1619m60r)/
                  (nmarruf16+nmarrrf16);
gen vlargegap2024= (f2024m3539u+f2024m4044u+f2024m4549u+f2024m5054u+f2024m5559u+f2024m60u+
                   f2024m3539r+f2024m4044r+f2024m4549r+f2024m5054r+f2024m5559r+f2024m60r)/
                  (nmarruf20+nmarrrf20);
gen vlargegap2529= (f2529m4044u+f2529m4549u+f2529m5054u+f2529m5559u+f2529m60u+
                   f2529m4044r+f2529m4549r+f2529m5054r+f2529m5559r+f2529m60r)/
                  (nmarruf25+nmarrrf25);
gen vlargegap3034= (f3034m1619u+f3034m4549u+f3034m5054u+f3034m5559u+f3034m60u+
                   f3034m1619r+f3034m4549r+f3034m5054r+f3034m5559r+f3034m60r)/
                  (nmarruf30+nmarrrf30);
gen vlargegap3539= (f3539m1619u+f3539m2024u+f3539m5054u+f3539m5559u+f3539m60u+
                   f3539m1619r+f3539m2024r+f3539m5054r+f3539m5559r+f3539m60r)/
                   (nmarruf35+nmarrrf35);
gen vlargegap4044= (f4044m1619u+f4044m2024u+f4044m2529u+f4044m5559u+f4044m60u+
                   f4044m1619r+f4044m2024r+f4044m2529r+f4044m5559r+f4044m60r)/
                  (nmarruf40+nmarrrf40);
gen vlargegap4549= (f4549m1619u+f4549m2024u+f4549m2529u+f4549m60u+
                   f4549m1619r+f4549m2024r+f4549m2529r+f4549m60r)/
                  (nmarruf45+nmarrrf45);

label var vlargegap1619u "Share of marriages with 11+ year age gap, women 16-19, urban";
label var vlargegap2024u "Share of marriages with 11+ year age gap, women 20-24, urban";
label var vlargegap2529u "Share of marriages with 11+ year age gap, women 25-29, urban";
label var vlargegap3034u "Share of marriages with 11+ year age gap, women 30-34, urban";
label var vlargegap3539u "Share of marriages with 11+ year age gap, women 35-39, urban";
label var vlargegap4044u "Share of marriages with 11+ year age gap, women 40-44, urban";

label var vlargegap1619r "Share of marriages with 11+ year age gap, women 16-19, rural";
label var vlargegap2024r "Share of marriages with 11+ year age gap, women 20-24, rural";
label var vlargegap2529r "Share of marriages with 11+ year age gap, women 25-29, rural";
label var vlargegap3034r "Share of marriages with 11+ year age gap, women 30-34, rural";
label var vlargegap3539r "Share of marriages with 11+ year age gap, women 35-39, rural";
label var vlargegap4044r "Share of marriages with 11+ year age gap, women 40-44, rural";


*  Divorce rate by 5-year age group;
*  Data is for 18-19, 20-24, 25-29, 30-39 and 40-49 age groups;
*  All divorces;
gen divr1859=((divm1859+divf1859)/(smpm1819+smpf1819))*1000;
gen divru1859=((divmu1859+divfu1859)/(smpmu1819+smpfu1819))*1000;
gen divrr1859=((divmr1859+divfr1859)/(smpmr1819+smpfr1819))*1000;
replace divr1859=divru1859 if regno==7 | regno==16;

gen divr2059=((divm2059+divf2059)/(smpm2024+smpf2024))*1000;
gen divru2059=((divmu2059+divfu2059)/(smpmu2024+smpfu2024))*1000;
gen divrr2059=((divmr2059+divfr2059)/(smpmr2024+smpfr2024))*1000;
replace divr2059=divru2059 if regno==7 | regno==16;

gen divr2559=((divm2559+divf2559)/(smpm2529+smpf2529))*1000;
gen divru2559=((divmu2559+divfu2559)/(smpmu2529+smpfu2529))*1000;
gen divrr2559=((divmr2559+divfr2559)/(smpmr2529+smpfr2529))*1000;
replace divr2559=divru2559 if regno==7 | regno==16;

gen divr3059=((divm3059+divf3059)/(smpm3039+smpf3039))*1000;
gen divru3059=((divmu3059+divfu3059)/(smpmu3039+smpfu3039))*1000;
gen divrr3059=((divmr3059+divfr3059)/(smpmr3039+smpfr3039))*1000;
replace divr3059=divru3059 if regno==7 | regno==16;

gen divr4059=((divm4059+divf4059)/(smpm4049+smpf4049))*1000;
gen divru4059=((divmu4059+divfu4059)/(smpmu4049+smpfu4049))*1000;
gen divrr4059=((divmr4059+divfr4059)/(smpmr4049+smpfr4049))*1000;
replace divr4059=divru4059 if regno==7 | regno==16;

label var divru1859 "Divorces per 1000 married pop. age 18-19, urban";
label var divru2059 "Divorces per 1000 married pop. age 20-24, urban";
label var divru2559 "Divorces per 1000 married pop. age 25-29, urban";
label var divru3059 "Divorces per 1000 married pop. age 30-39, urban";
label var divru4059 "Divorces per 1000 married pop. age 40-49, urban";

label var divrr1859 "Divorces per 1000 married pop. age 18-19, rural";
label var divrr2059 "Divorces per 1000 married pop. age 20-24, rural";
label var divrr2559 "Divorces per 1000 married pop. age 25-29, rural";
label var divrr3059 "Divorces per 1000 married pop. age 30-39, rural";
label var divrr4059 "Divorces per 1000 married pop. age 40-49, rural";

* % urban population;
gen urbshm151959=popmu151959/popm151959;
gen urbshm161959=popmu161959/popm161959;
gen urbshm181959=popmu181959/popm181959;
gen urbshm202459=popmu202459/popm202459;
gen urbshm252959=popmu252959/popm252959;
gen urbshm303459=popmu303459/popm303459;
gen urbshm353959=popmu353959/popm353959;
gen urbshm404459=popmu404459/popm404459;
gen urbshm454959=popmu454959/popm454959;
gen urbshm505459=popmu505459/popm505459;
gen urbshm303959=(popmu303459+popmu353959)/popm303959;
gen urbshm404959=(popmu404459+popmu454959)/popm404959;

gen urbshf151959=popfu151959/popf151959;
gen urbshf161959=popfu161959/popf161959;
gen urbshf181959=popfu181959/popf181959;
gen urbshf202459=popfu202459/popf202459;
gen urbshf252959=popfu252959/popf252959;
gen urbshf303459=popfu303459/popf303459;
gen urbshf353959=popfu353959/popf353959;
gen urbshf404459=popfu404459/popf404459;
gen urbshf454959=popfu454959/popf454959;
gen urbshf505459=popfu505459/popf505459;
gen urbshf303959=(popfu303459+popfu353959)/popf303959;
gen urbshf404959=(popfu404459+popfu454959)/popf404959;

label var urbshm161959 "% urban pop., men 16-19";
label var urbshm202459 "% urban pop., men 20-24";
label var urbshm252959 "% urban pop., men 25-29";
label var urbshm303459 "% urban pop., men 30-34";
label var urbshm353959 "% urban pop., men 35-39";
label var urbshm404459 "% urban pop., men 40-44";

save data_5yr, replace;

*************************************************************************************
* Stacking data by age group;
*************************************************************************************

*  Merging in sex ratios;
sort regno;
merge 1:1 regno using sexratios_5yr;
assert _merge==3;
drop _merge;

* Dropping small regions that are part of other regions;
drop if regno==4 | regno==45 | regno==48 | regno==57 | regno==60 | regno==67 | regno==68 |
        regno==73 | regno==74 | regno==76 | regno==78 | regno==80 |
        regno==81 | regno==86;

* using age 15-19 death rates since 16-19 not in archives;
gen asdrf1619=asdrf1519;
gen asdrfu1619=asdrfu1519;
gen asdrfr1619=asdrfr1519;

aorder;
sort regno;

*  Stacking data by age group for regressions in Tables 4, 5a, 5b;
stack   region regno nodad1619 nodadu1619 nodadr1619
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm1659 asbrmu1659 asbrmr1659 asbrnd1659 asbrndu1659 asbrndr1659
        popf161959 popfu161959 popfr161959 popm161959 popmu161959 popmr161959
        vlargegap1619 vlargegap1619u vlargegap1619r sr10a16 sr10u16 sr10r16 urbshf161959
        asdrf1619 asdrfu1619 asdrfr1619 epopf161959 epopfu161959 epopfr161959
        sr15a16 sr15u16 sr15r16 sr5a16 sr5u16 sr5r16

        region regno nodad2024 nodadu2024 nodadr2024
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm2059 asbrmu2059 asbrmr2059 asbrnd2059 asbrndu2059 asbrndr2059
        popf202459 popfu202459 popfr202459 popm202459 popmu202459 popmr202459
        vlargegap2024 vlargegap2024u vlargegap2024r sr10a20 sr10u20 sr10r20 urbshf202459
        asdrf2024 asdrfu2024 asdrfr2024 epopf202459 epopfu202459 epopfr202459
        sr15a20 sr15u20 sr15r20 sr5a20 sr5u20 sr5r20

        region regno nodad2529 nodadu2529 nodadr2529
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm2559 asbrmu2559 asbrmr2559 asbrnd2559 asbrndu2559 asbrndr2559
        popf252959 popfu252959 popfr252959 popm252959 popmu252959 popmr252959
        vlargegap2529 vlargegap2529u vlargegap2529r sr10a25 sr10u25 sr10r25 urbshf252959
        asdrf2529 asdrfu2529 asdrfr2529 epopf252959 epopfu252959 epopfr252959
        sr15a25 sr15u25 sr15r25 sr5a25 sr5u25 sr5r25

        region regno nodad3034 nodadu3034 nodadr3034
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm3059 asbrmu3059 asbrmr3059 asbrnd3059 asbrndu3059 asbrndr3059
        popf303459 popfu303459 popfr303459 popm303459 popmu303459 popmr303459
        vlargegap3034 vlargegap3034u vlargegap3034r sr10a30 sr10u30 sr10r30 urbshf303459
        asdrf3034 asdrfu3034 asdrfr3034 epopf303459 epopfu303459 epopfr303459
        sr15a30 sr15u30 sr15r30 sr5a30 sr5u30 sr5r30

        region regno nodad3539 nodadu3539 nodadr3539
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm3559 asbrmu3559 asbrmr3559 asbrnd3559 asbrndu3559 asbrndr3559
        popf353959 popfu353959 popfr353959 popm353959 popmu353959 popmr353959
        vlargegap3539 vlargegap3539u vlargegap3539r sr10a35 sr10u35 sr10r35 urbshf353959
        asdrf3539 asdrfu3539 asdrfr3539 epopf353959 epopfu353959 epopfr353959
        sr15a35 sr15u35 sr15r35 sr5a35 sr5u35 sr5r35

        region regno nodad4044 nodadu4044 nodadr4044
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm4059 asbrmu4059 asbrmr4059 asbrnd4059 asbrndu4059 asbrndr4059
        popf404459 popfu404459 popfr404459 popm404459 popmu404459 popmr404459
        vlargegap4044 vlargegap4044u vlargegap4044r sr10a40 sr10u40 sr10r40 urbshf404459
        asdrf4044 asdrfu4044 asdrfr4044 epopf404459 epopfu404459 epopfr404459
        sr15a40 sr15u40 sr15r40 sr5a40 sr5u40 sr5r40

        region regno nodad4549 nodadu4549 nodadr4549
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm4559 asbrmu4559 asbrmr4559 asbrnd4559 asbrndu4559 asbrndr4559
        popf454959 popfu454959 popfr454959 popm454959 popmu454959 popmr454959
        vlargegap4549 vlargegap4549u vlargegap4549r sr10a45 sr10u45 sr10r45 urbshf454959
        asdrf4549 asdrfu4549 asdrfr4549 epopf454959 epopfu454959 epopfr454959
        sr15a45 sr15u45 sr15r45 sr5a45 sr5u45 sr5r45,

        into(region regno nodad nodadu nodadr
        cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        asbrm asbrmu asbrmr asbrnd asbrndu asbrndr
        popf popfu popfr popm popmu popmr
        vlargegap vlargegapu vlargegapr sr10a sr10u sr10r urbshf
        asdrf asdrfu asdrfr epopf epopfu epopfr sr15a sr15u sr15r sr5a sr5u sr5r) clear;

gen pop=popm+popf;
gen popu=popmu+popfu;
gen popr=popmr+popfr;
gen lnpopm=log(popm);
gen lnpopmu=log(popmu);
gen lnpopmr=log(popmr);
gen lnpopf=log(popf);
gen lnpopfu=log(popfu);
gen lnpopfr=log(popfr);

ren _stack agegroup;
sort agegroup;

replace pop=popu if regno==7 | regno==16;   */  Assigns urban variables to Moscow and St. Petersburg since these have only urban populations */
replace popm=popmu if regno==7 | regno==16;
replace popf=popfu if regno==7 | regno==16;
replace asbrm=asbrmu if regno==7 | regno==16;
replace asbrnd=asbrndu if regno==7 | regno==16;
replace nodad=nodadu if regno==7 | regno==16;
replace vlargegap=vlargegapu if regno==7 | regno==16;
replace asdrf=asdrfu if regno==7 | regno==16;
replace epopf=epopfu if regno==7 | regno==16;
replace sr10a=sr10u if regno==7 | regno==16;
replace sr15a=sr15u if regno==7 | regno==16;
replace sr5a=sr5u if regno==7 | regno==16;

label var sr10a "Sex ratio, all pop.";
label var sr10u "Sex ratio, urban pop.";
label var sr10r "Sex ratio, rural pop.";

label var sr5a "Sex ratio, all pop., narrow definition";
label var sr5u "Sex ratio, urban pop., narrow definition";
label var sr5r "Sex ratio, rural pop., narrow definition";

label var sr15a "Sex ratio, all pop., broad definition";
label var sr15u "Sex ratio, urban pop., broad definition";
label var sr15r "Sex ratio, rural pop., broad definition";

label var nodad "Share of out of wedlock births, all pop.";
label var nodadu "Share of out of wedlock births, urban pop.";
label var nodadr "Share of out of wedlock births, rural pop.";

label var asbrm "Marital births per 1000 married women, all pop.";
label var asbrmu "Marital births per 1000 married women, urban pop.";
label var asbrmr "Marital births per 1000 married women, rural pop.";

label var asbrnd "Nonmarital births per 1000 unmarried women, all pop.";
label var asbrndu "Nonmarital births per 1000 unmarried women, urban pop.";
label var asbrndr "Nonmarital births per 1000 unmarried women, rural pop.";

label var epopf "Employment to pop. ratio, women, all pop.";
label var epopfu "Employment to pop. ratio, women, urban pop.";
label var epopfr "Employment to pop. ratio, women, rural pop.";

label var asdrf "Age-specific death rate, women, all pop.";
label var asdrfu "Age-specific death rate, women, urban pop.";
label var asdrfr "Age-specific death rate, women, rural pop.";

label var urbshf "% urban pop., women";


aorder;
sort regno;
save data_5yr_stacked, replace;


clear;
* Creating stacked data for divorce regressions (diffeent age groups than other dependent variables);
use data_5yr;
sort regno;
merge 1:1 regno using sexratios_5yr;
assert _merge==3;
drop _merge;

* using age 15-19 death rates since 18-19 not in archives;
gen asdrf1819=asdrf1519;
gen asdrfu1819=asdrfu1519;
gen asdrfr1819=asdrfr1519;

*  Stacking data by age group;
stack   region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        divr1859 divru1859 divrr1859
        popf181959 popfu181959 popfr181959 popm181959 popmu181959 popmr181959
        sr10a18 sr10u18 sr10r18 urbshm181959 urbshf181959
        asdrf1819 asdrfu1819 asdrfr1819 epopf181959 epopfu181959 epopfr181959
        sr15a18 sr15u18 sr15r18 sr5a18 sr5u18 sr5r18

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        divr2059 divru2059 divrr2059
        popf202459 popfu202459 popfr202459 popm202459 popmu202459 popmr202459
        sr10a20 sr10u20 sr10r20 urbshm202459 urbshf202459
        asdrf2024 asdrfu2024 asdrfr2024 epopf202459 epopfu202459 epopfr202459
        sr15a20 sr15u20 sr15r20 sr5a20 sr5u20 sr5r20

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        divr2559 divru2559 divrr2559
        popf252959 popfu252959 popfr252959 popm252959 popmu252959 popmr252959
        sr10a25 sr10u25 sr10r25 urbshm252959 urbshf252959
        asdrf2529 asdrfu2529 asdrfr2529 epopf252959 epopfu252959 epopfr252959
        sr15a25 sr15u25 sr15r25 sr5a25 sr5u25 sr5r25

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        divr3059 divru3059 divrr3059
        popf303959 popfu303959 popfr303959 popm303959 popmu303959 popmr303959
        sr10a3039 sr10u3039 sr10r3039 urbshm303959 urbshf303959
        asdrf3039 asdrfu3039 asdrfr3039 epopf303959 epopfu303959 epopfr303959
        sr15a3039 sr15u3039 sr15r3039 sr5a3039 sr5u3039 sr5r3039

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        divr4059 divru4059 divrr4059
        popf404959 popfu404959 popfr404959 popm404959 popmu404959 popmr404959
        sr10a4049 sr10u4049 sr10r4049 urbshm404959 urbshf404959
        asdrf4049 asdrfu4049 asdrfr4049 epopf404959 epopfu404959 epopfr404959
        sr15a4049 sr15u4049 sr15r4049 sr5a4049 sr5u4049 sr5r4049,


        into(region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        divr divru divrr popf popfu popfr popm popmu popmr sr10a sr10u sr10r urbshm urbshf
        asdrf asdrfu asdrfr epopf epopfu epopfr sr15a sr15u sr15r sr5a sr5u sr5r) clear;

gen pop=popm+popf;
gen popu=popmu+popfu;
gen popr=popmr+popfr;
gen lnpopm=log(popm);
gen lnpopmu=log(popmu);
gen lnpopmr=log(popmr);
gen lnpopf=log(popf);
gen lnpopfu=log(popfu);
gen lnpopfr=log(popfr);

ren _stack agegroup;
sort agegroup;

replace pop=popu if regno==7 | regno==16;   */  Assigns urban variables to Moscow and St. Petersburg since these have only urban populations */
replace popm=popmu if regno==7 | regno==16;
replace popf=popfu if regno==7 | regno==16;
replace divr=divru if regno==7 | regno==16;
replace asdrf=asdrfu if regno==7 | regno==16;
replace epopf=epopfu if regno==7 | regno==16;
replace sr10a=sr10u if regno==7 | regno==16;
replace sr15a=sr15u if regno==7 | regno==16;
replace sr5a=sr5u if regno==7 | regno==16;

label var sr10a "Sex ratio, all pop.";
label var sr10u "Sex ratio, urban pop.";
label var sr10r "Sex ratio, rural pop.";

label var sr5a "Sex ratio, all pop., narrow definition";
label var sr5u "Sex ratio, urban pop., narrow definition";
label var sr5r "Sex ratio, rural pop., narrow definition";

label var sr15a "Sex ratio, all pop., broad definition";
label var sr15u "Sex ratio, urban pop., broad definition";
label var sr15r "Sex ratio, rural pop., broad definition";

label var epopf "Employment to pop. ratio, women, all pop.";
label var epopfu "Employment to pop. ratio, women, urban pop.";
label var epopfr "Employment to pop. ratio, women, rural pop.";

label var asdrf "Age-specific death rate, women, all pop.";
label var asdrfu "Age-specific death rate, women, urban pop.";
label var asdrfr "Age-specific death rate, women, rural pop.";

label var divr "Divorces per 1000 married pop., all pop.";
label var divru "Divorces per 1000 married pop., urban pop.";
label var divrr "Divorces per 1000 married pop., rural pop.";

label var urbshm "% urban pop., men";
label var urbshf "% urban pop., women";

aorder;
sort regno;
save data_5yr_stacked_div, replace;


clear;
* Creating stacked data for abortion regressions (diffeent age groups than other dependent variables);
use data_5yr;
sort regno;
merge 1:1 regno using sexratios_5yr;
assert _merge==3;
drop _merge;

* Dropping small regions that are part of other regions;
drop if regno==4 | regno==45 | regno==48 | regno==57 | regno==60 | regno==67 | regno==68 |
        regno==73 | regno==74 | regno==76 | regno==78 | regno==80 |
        regno==81 | regno==86;

* using age 15-19 death rates since 16-19 not in archives;
gen asdrf1619=asdrf1519;
gen asdrfu1619=asdrfu1519;
gen asdrfr1619=asdrfr1519;

*  Stacking data by age group;
stack   region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        dabobth1659 dabobthu1659 dabobthr1659
        popf161959 popfu161959 popfr161959 popm161959 popmu161959 popmr161959
        sr10a16 sr10u16 sr10r16 urbshm161959 urbshf161959
        asdrf1619 asdrfu1619 asdrfr1619 epopf161959 epopfu161959 epopfr161959

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        dabobth2059 dabobthu2059 dabobthr2059
        popf202459 popfu202459 popfr202459 popm202459 popmu202459 popmr202459
        sr10a20 sr10u20 sr10r20 urbshm202459 urbshf202459
        asdrf2024 asdrfu2024 asdrfr2024 epopf202459 epopfu202459 epopfr202459

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        dabobth2559 dabobthu2559 dabobthr2559
        popf252959 popfu252959 popfr252959 popm252959 popmu252959 popmr252959
        sr10a25 sr10u25 sr10r25 urbshm252959 urbshf252959
        asdrf2529 asdrfu2529 asdrfr2529 epopf252959 epopfu252959 epopfr252959

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        dabobth3059 dabobthu3059 dabobthr3059
        popf303959 popfu303959 popfr303959 popm303959 popmu303959 popmr303959
        sr10a3039 sr10u3039 sr10r3039 urbshm303959 urbshf303959
        asdrf3039 asdrfu3039 asdrfr3039 epopf303959 epopfu303959 epopfr303959

        region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        dabobth4059 dabobthu4059 dabobthr4059
        popf404959 popfu404959 popfr404959 popm404959 popmu404959 popmr404959
        sr10a4049 sr10u4049 sr10r4049 urbshm404959 urbshf404959
        asdrf4049 asdrfu4049 asdrfr4049 epopf404959 epopfu404959 epopfr404959,

        into(region regno cenchern central esib fareast ncauc north norwest povolzh urals volga wsib
        dabobth dabobthu dabobthr popf popfu popfr popm popmu popmr sr10a sr10u sr10r urbshm urbshf
        asdrf asdrfu asdrfr epopf epopfu epopfr) clear;

gen pop=popm+popf;
gen popu=popmu+popfu;
gen popr=popmr+popfr;
gen lnpopm=log(popm);
gen lnpopmu=log(popmu);
gen lnpopmr=log(popmr);
gen lnpopf=log(popf);
gen lnpopfu=log(popfu);
gen lnpopfr=log(popfr);

ren _stack agegroup;
sort agegroup;

replace pop=popu if regno==7 | regno==16;   */  Assigns urban variables to Moscow and St. Petersburg since these have only urban populations */
replace popm=popmu if regno==7 | regno==16;
replace popf=popfu if regno==7 | regno==16;
replace dabobth=dabobthu if regno==7 | regno==16;
replace asdrf=asdrfu if regno==7 | regno==16;
replace epopf=epopfu if regno==7 | regno==16;
replace sr10a=sr10u if regno==7 | regno==16;

label var sr10a "Sex ratio, all pop.";
label var sr10u "Sex ratio, urban pop.";
label var sr10r "Sex ratio, rural pop.";

label var epopf "Employment to pop. ratio, women, all pop.";
label var epopfu "Employment to pop. ratio, women, urban pop.";
label var epopfr "Employment to pop. ratio, women, rural pop.";

label var asdrf "Age-specific death rate, women, all pop.";
label var asdrfu "Age-specific death rate, women, urban pop.";
label var asdrfr "Age-specific death rate, women, rural pop.";

label var dabobth "Deaths due to abortion per 100 births, all pop.";
label var dabobthu "Deaths due to abortion per 100 births, urban pop.";
label var dabobthr "Deaths due to abortion per 100 births, rural pop.";

label var urbshm "% urban pop., men";
label var urbshf "% urban pop., women";

aorder;
sort regno;
save data_5yr_stacked_dabo, replace;


