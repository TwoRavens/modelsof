
************************************************************************
*  Creates oblast-level sex ratios for Russia by five-year age group
************************************************************************

# delimit ;
set more 1;
use pop_age_sex_1yr;  /*  Contains population counts by oblast, sex, urban/rural, married, by 1-year age group */


* Broad definition of sex ratios = up to 15-year age gap;
gen popmu1359=popmu1459;
gen popmr1359=popmr1459;
capture program drop numerator;
program define numerator;
        local i = 15     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        local q = `i'+6  ;
        local r = `i'+7  ;
        local s = `i'+8  ;
        local t = `i'+9  ;
        local u = `i'+10 ;
        local v = `i'+11 ;
        local w = `i'+12 ;
        local x = `i'+13 ;
        local y = `i'+14 ;
        local z = `i'+15 ;
        local a = `i'+16 ;
        local b = `i'+17 ;
        local c = `i'+18 ;
        local d = `i'+19;
        while `i' <= 45 {  ;
        gen numu`i'=popmu`i'59+popmu`j'59+popmu`k'59+popmu`l'59+popmu`m'59+popmu`n'59+popmu`o'59+popmu`p'59+popmu`q'59+popmu`r'59+popmu`s'59+popmu`t'59+popmu`u'59+popmu`v'59+popmu`w'59+popmu`x'59+popmu`y'59+popmu`z'59+popmu`a'59+popmu`b'59+popmu`c'59+popmu`d'59;
        gen numr`i'=popmr`i'59+popmr`j'59+popmr`k'59+popmr`l'59+popmr`m'59+popmr`n'59+popmr`o'59+popmr`p'59+popmr`q'59+popmr`r'59+popmr`s'59+popmr`t'59+popmr`u'59+popmr`v'59+popmr`w'59+popmr`x'59+popmr`y'59+popmr`z'59+popmr`a'59+popmr`b'59+popmr`c'59+popmr`d'59;
        gen num`i'=numu`i'+numr`i';
        local i = `i' + 5;
        local j = `j' + 5;
        local k = `k' + 5;
        local l = `l' + 5;
        local m = `m' + 5;
        local n = `n' + 5;
        local o = `o' + 5;
        local p = `p' + 5;
        local q = `q' + 5;
        local r = `r' + 5;
        local s = `s' + 5;
        local t = `t' + 5;
        local u = `u' + 5;
        local v = `v' + 5;
        local w = `w' + 5;
        local x = `x' + 5;
        local y = `y' + 5;
        local z = `z' + 5;
        local a = `a' + 5;
        local b = `b' + 5;
        local c = `c' + 5;
        local d = `d' + 5;
        }  ;
end;


capture program drop denominator;
program define denominator;
        local i = 15     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        local q = `i'+6  ;
        local r = `i'+7  ;
        local s = `i'+8  ;
        local t = `i'+9  ;
        local u = `i'+10 ;
        local v = `i'+11 ;
        local w = `i'+12 ;
        local x = `i'+13 ;
        local y = `i'+14 ;
        local z = `i'+15 ;
        local a = `i'+16 ;
        local b = `i'+17 ;
        local c = `i'+18 ;
        local d = `i'+19 ;
        while `i' <= 49 {  ;
        gen denu`i'=popfu`i'59+popfu`j'59+popfu`k'59+popfu`l'59+popfu`m'59+popfu`n'59+popfu`o'59+popfu`p'59+popfu`q'59+popfu`r'59+popfu`s'59+popfu`t'59+popfu`u'59+popfu`v'59+popfu`w'59+popfu`x'59+popfu`y'59+popfu`z'59+popfu`a'59+popfu`b'59+popfu`c'59+popfu`d'59;
        gen denr`i'=popfr`i'59+popfr`j'59+popfr`k'59+popfr`l'59+popfr`m'59+popfr`n'59+popfr`o'59+popfr`p'59+popfr`q'59+popfr`r'59+popfr`s'59+popfr`t'59+popfr`u'59+popfr`v'59+popfr`w'59+popfr`x'59+popfr`y'59+popfr`z'59+popfr`a'59+popfr`b'59+popfr`c'59+popfr`d'59;
        gen den`i'=denu`i'+denr`i';
        local i = `i' + 5;
        local j = `j' + 5;
        local k = `k' + 5;
        local l = `l' + 5;
        local m = `m' + 5;
        local n = `n' + 5;
        local o = `o' + 5;
        local p = `p' + 5;
        local q = `q' + 5;
        local r = `r' + 5;
        local s = `s' + 5;
        local t = `t' + 5;
        local u = `u' + 5;
        local v = `v' + 5;
        local w = `w' + 5;
        local x = `x' + 5;
        local y = `y' + 5;
        local z = `z' + 5;
        local a = `a' + 5;
        local b = `b' + 5;
        local c = `c' + 5;
        local d = `d' + 5;
        }  ;
end;

numerator;
denominator;

forval i = 15(5)49 { ;
        gen sr15u`i'=numu`i'/denu`i';
        gen sr15r`i'=numr`i'/denr`i';
        gen sr15a`i'=num`i'/den`i';
        } ;


gen numu1619=popmu1459+popmu1559+popmu1659+popmu1759+popmu1859+popmu1959+popmu2059+popmu2159+popmu2259+popmu2359
            +popmu2459+popmu2559+popmu2659+popmu2759+popmu2859+popmu2959+popmu3059+popmu3159+popmu3259+popmu3359+popmu3459;
gen denu1619=popfu1459+popfu1559+popfu1659+popfu1759+popfu1859+popfu1959+popfu2059+popfu2159+popfu2259+popfu2359
            +popfu2459+popfu2559+popfu2659+popfu2759+popfu2859+popfu2959+popfu3059+popfu3159+popfu3259+popfu3359+popfu3459;

gen numr1619=popmr1459+popmr1559+popmr1659+popmr1759+popmr1859+popmr1959+popmr2059+popmr2159+popmr2259+popmr2359
            +popmr2459+popmr2559+popmr2659+popmr2759+popmr2859+popmr2959+popmr3059+popmr3159+popmr3259+popmr3359+popmr3459;
gen denr1619=popfr1459+popfr1559+popfr1659+popfr1759+popfr1859+popfr1959+popfr2059+popfr2159+popfr2259+popfr2359
            +popfr2459+popfr2559+popfr2659+popfr2759+popfr2859+popfr2959+popfr3059+popfr3159+popfr3259+popfr3359+popfr3459;

gen numu1819=popmu1659+popmu1759+popmu1859+popmu1959+popmu2059+popmu2159+popmu2259+popmu2359
            +popmu2459+popmu2559+popmu2659+popmu2759+popmu2859+popmu2959+popmu3059+popmu3159+popmu3259+popmu3359+popmu3459;
gen denu1819=popfu1659+popfu1759+popfu1859+popfu1959+popfu2059+popfu2159+popfu2259+popfu2359
            +popfu2459+popfu2559+popfu2659+popfu2759+popfu2859+popfu2959+popfu3059+popfu3159+popfu3259+popfu3359+popfu3459;

gen numr1819=popmr1659+popmr1759+popmr1859+popmr1959+popmr2059+popmr2159+popmr2259+popmr2359
            +popmr2459+popmr2559+popmr2659+popmr2759+popmr2859+popmr2959+popmr3059+popmr3159+popmr3259+popmr3359+popmr3459;
gen denr1819=popfr1659+popfr1759+popfr1859+popfr1959+popfr2059+popfr2159+popfr2259+popfr2359
            +popfr2459+popfr2559+popfr2659+popfr2759+popfr2859+popfr2959+popfr3059+popfr3159+popfr3259+popfr3359+popfr3459;

gen numu3039=popmu2859+popmu2959+popmu3059+popmu3159+popmu3259+popmu3359+popmu3459+popmu3559+popmu3659+popmu3759
            +popmu3859+popmu3959+popmu4059+popmu4159+popmu4259+popmu4359+popmu4459+popmu4559+popmu4659+popmu4759
            +popmu4859+popmu4959+popmu5059+popmu5159+popmu5259+popmu5359+popmu5459;
gen denu3039=popfu2859+popfu2959+popfu3059+popfu3159+popfu3259+popfu3359+popfu3459+popfu3559+popfu3659+popfu3759
            +popfu3859+popfu3959+popfu4059+popfu4159+popfu4259+popfu4359+popfu4459+popfu4559+popfu4659+popfu4759
            +popfu4859+popfu4959+popfu5059+popfu5159+popfu5259+popfu5359+popfu5459;

gen numr3039=popmr2859+popmr2959+popmr3059+popmr3159+popmr3259+popmr3359+popmr3459+popmr3559+popmr3659+popmr3759
            +popmr3859+popmr3959+popmr4059+popmr4159+popmr4259+popmr4359+popmr4459+popmr4559+popmr4659+popmr4759
            +popmr4859+popmr4959+popmr5059+popmr5159+popmr5259+popmr5359+popmr5459;
gen denr3039=popfr2859+popfr2959+popfr3059+popfr3159+popfr3259+popfr3359+popfr3459+popfr3559+popfr3659+popfr3759
            +popfr3859+popfr3959+popfr4059+popfr4159+popfr4259+popfr4359+popfr4459+popfr4559+popfr4659+popfr4759
            +popfr4859+popfr4959+popfr5059+popfr5159+popfr5259+popfr5359+popfr5459;

gen numu4049=popmu3859+popmu3959+popmu4059+popmu4159+popmu4259+popmu4359+popmu4459+popmu4559+popmu4659+popmu4759
            +popmu4859+popmu4959+popmu5059+popmu5159+popmu5259+popmu5359+popmu5459+popmu5559+popmu5659+popmu5759
            +popmu5859+popmu5959+popmu6059+popmu6159+popmu6259+popmu6359+popmu6459;
gen denu4049=popfu3859+popfu3959+popfu4059+popfu4159+popfu4259+popfu4359+popfu4459+popfu4559+popfu4659+popfu4759
            +popfu4859+popfu4959+popfu5059+popfu5159+popfu5259+popfu5359+popfu5459+popfu5559+popfu5659+popfu5759
            +popfu5859+popfu5959+popfu6059+popfu6159+popfu6259+popfu6359+popfu6459;

gen numr4049=popmr3859+popmr3959+popmr4059+popmr4159+popmr4259+popmr4359+popmr4459+popmr4559+popmr4659+popmr4759
            +popmr4859+popmr4959+popmr5059+popmr5159+popmr5259+popmr5359+popmr5459+popmr5559+popmr5659+popmr5759
            +popmr5859+popmr5959+popmr6059+popmr6159+popmr6259+popmr6359+popmr6459;
gen denr4049=popfr3859+popfr3959+popfr4059+popfr4159+popfr4259+popfr4359+popfr4459+popfr4559+popfr4659+popfr4759
            +popfr4859+popfr4959+popfr5059+popfr5159+popfr5259+popfr5359+popfr5459+popfr5559+popfr5659+popfr5759
            +popfr5859+popfr5959+popfr6059+popfr6159+popfr6259+popfr6359+popfr6459;

gen sr15u16=numu1619/denu1619;
gen sr15r16=numr1619/denr1619;
gen sr15a16=(numu1619+numr1619)/(denu1619+denr1619);

gen sr15u18=numu1819/denu1819;
gen sr15r18=numr1819/denr1819;
gen sr15a18=(numu1819+numr1819)/(denu1819+denr1819);

gen sr15u3039=numu3039/denu3039;
gen sr15r3039=numr3039/denu3039;
gen sr15a3039=(numu3039+numr3039)/(denu3039+denr3039);

gen sr15u4049=numu4049/denu4049;
gen sr15r4049=numr4049/denu4049;
gen sr15a4049=(numu4049+numr4049)/(denu4049+denr4049);


* Narrower definition of sex ratios = up to 10-year age gap;
drop num* den*;
capture program drop numerator;
program define numerator;
        local i = 15     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        local q = `i'+6  ;
        local r = `i'+7  ;
        local s = `i'+8  ;
        local t = `i'+9  ;
        local u = `i'+10 ;
        local v = `i'+11 ;
        local w = `i'+12 ;
        local x = `i'+13 ;
        local y = `i'+14 ;
        while `i' <= 45 {  ;
        gen numu`i'=popmu`i'59+popmu`j'59+popmu`k'59+popmu`l'59+popmu`m'59+popmu`n'59+popmu`o'59+popmu`p'59+popmu`q'59+popmu`r'59+popmu`s'59+popmu`t'59+popmu`u'59+popmu`v'59+popmu`w'59+popmu`x'59+popmu`y'59;
        gen numr`i'=popmr`i'59+popmr`j'59+popmr`k'59+popmr`l'59+popmr`m'59+popmr`n'59+popmr`o'59+popmr`p'59+popmr`q'59+popmr`r'59+popmr`s'59+popmr`t'59+popmr`u'59+popmr`v'59+popmr`w'59+popmr`x'59+popmr`y'59;
        gen num`i'=numu`i'+numr`i';
        local i = `i' + 5;
        local j = `j' + 5;
        local k = `k' + 5;
        local l = `l' + 5;
        local m = `m' + 5;
        local n = `n' + 5;
        local o = `o' + 5;
        local p = `p' + 5;
        local q = `q' + 5;
        local r = `r' + 5;
        local s = `s' + 5;
        local t = `t' + 5;
        local u = `u' + 5;
        local v = `v' + 5;
        local w = `w' + 5;
        local x = `x' + 5;
        local y = `y' + 5;
        }  ;
end;

capture program drop denominator;
program define denominator;
        local i = 15     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        local q = `i'+6  ;
        local r = `i'+7  ;
        local s = `i'+8  ;
        local t = `i'+9  ;
        local u = `i'+10 ;
        local v = `i'+11 ;
        local w = `i'+12 ;
        local x = `i'+13 ;
        local y = `i'+14 ;
        while `i' <= 49 {  ;
        gen denu`i'=popfu`i'59+popfu`j'59+popfu`k'59+popfu`l'59+popfu`m'59+popfu`n'59+popfu`o'59+popfu`p'59+popfu`q'59+popfu`r'59+popfu`s'59+popfu`t'59+popfu`u'59+popfu`v'59+popfu`w'59+popfu`x'59+popfu`y'59;
        gen denr`i'=popfr`i'59+popfr`j'59+popfr`k'59+popfr`l'59+popfr`m'59+popfr`n'59+popfr`o'59+popfr`p'59+popfr`q'59+popfr`r'59+popfr`s'59+popfr`t'59+popfr`u'59+popfr`v'59+popfr`w'59+popfr`x'59+popfr`y'59;
        gen den`i'=denu`i'+denr`i';
        local i = `i' + 5;
        local j = `j' + 5;
        local k = `k' + 5;
        local l = `l' + 5;
        local m = `m' + 5;
        local n = `n' + 5;
        local o = `o' + 5;
        local p = `p' + 5;
        local q = `q' + 5;
        local r = `r' + 5;
        local s = `s' + 5;
        local t = `t' + 5;
        local u = `u' + 5;
        local v = `v' + 5;
        local w = `w' + 5;
        local x = `x' + 5;
        local y = `y' + 5;
        }  ;
end;

numerator;
denominator;

forval i = 15(5)49 { ;
        gen sr10u`i'=numu`i'/denu`i';
        gen sr10r`i'=numr`i'/denr`i';
        gen sr10a`i'=num`i'/den`i';
        } ;

drop num* den*;
gen numu1619=popmu1459+popmu1559+popmu1659+popmu1759+popmu1859+popmu1959+popmu2059+popmu2159+popmu2259+popmu2359
            +popmu2459+popmu2559+popmu2659+popmu2759+popmu2859+popmu2959;
gen denu1619=popfu1459+popfu1559+popfu1659+popfu1759+popfu1859+popfu1959+popfu2059+popfu2159+popfu2259+popfu2359
            +popfu2459+popfu2559+popfu2659+popfu2759+popfu2859+popfu2959;

gen numr1619=popmr1459+popmr1559+popmr1659+popmr1759+popmr1859+popmr1959+popmr2059+popmr2159+popmr2259+popmr2359
            +popmr2459+popmr2559+popmr2659+popmr2759+popmr2859+popmr2959;
gen denr1619=popfr1459+popfr1559+popfr1659+popfr1759+popfr1859+popfr1959+popfr2059+popfr2159+popfr2259+popfr2359
            +popfr2459+popfr2559+popfr2659+popfr2759+popfr2859+popfr2959;

gen numu1819=popmu1659+popmu1759+popmu1859+popmu1959+popmu2059+popmu2159+popmu2259+popmu2359
            +popmu2459+popmu2559+popmu2659+popmu2759+popmu2859+popmu2959;
gen denu1819=popfu1659+popfu1759+popfu1859+popfu1959+popfu2059+popfu2159+popfu2259+popfu2359
            +popfu2459+popfu2559+popfu2659+popfu2759+popfu2859+popfu2959;

gen numr1819=popmr1659+popmr1759+popmr1859+popmr1959+popmr2059+popmr2159+popmr2259+popmr2359
            +popmr2459+popmr2559+popmr2659+popmr2759+popmr2859+popmr2959;
gen denr1819=popfr1659+popfr1759+popfr1859+popfr1959+popfr2059+popfr2159+popfr2259+popfr2359
            +popfr2459+popfr2559+popfr2659+popfr2759+popfr2859+popfr2959;

gen numu3039=popmu2859+popmu2959+popmu3059+popmu3159+popmu3259+popmu3359+popmu3459+popmu3559+popmu3659+popmu3759
            +popmu3859+popmu3959+popmu4059+popmu4159+popmu4259+popmu4359+popmu4459+popmu4559+popmu4659+popmu4759
            +popmu4859+popmu4959;
gen denu3039=popfu2859+popfu2959+popfu3059+popfu3159+popfu3259+popfu3359+popfu3459+popfu3559+popfu3659+popfu3759
            +popfu3859+popfu3959+popfu4059+popfu4159+popfu4259+popfu4359+popfu4459+popfu4559+popfu4659+popfu4759
            +popfu4859+popfu4959;

gen numr3039=popmr2859+popmr2959+popmr3059+popmr3159+popmr3259+popmr3359+popmr3459+popmr3559+popmr3659+popmr3759
            +popmr3859+popmr3959+popmr4059+popmr4159+popmr4259+popmr4359+popmr4459+popmr4559+popmr4659+popmr4759
            +popmr4859+popmr4959;
gen denr3039=popfr2859+popfr2959+popfr3059+popfr3159+popfr3259+popfr3359+popfr3459+popfr3559+popfr3659+popfr3759
            +popfr3859+popfr3959+popfr4059+popfr4159+popfr4259+popfr4359+popfr4459+popfr4559+popfr4659+popfr4759
            +popfr4859+popfr4959;

gen numu4049=popmu3859+popmu3959+popmu4059+popmu4159+popmu4259+popmu4359+popmu4459+popmu4559+popmu4659+popmu4759
            +popmu4859+popmu4959+popmu5059+popmu5159+popmu5259+popmu5359+popmu5459+popmu5559+popmu5659+popmu5759
            +popmu5859+popmu5959;
gen denu4049=popfu3859+popfu3959+popfu4059+popfu4159+popfu4259+popfu4359+popfu4459+popfu4559+popfu4659+popfu4759
            +popfu4859+popfu4959+popfu5059+popfu5159+popfu5259+popfu5359+popfu5459+popfu5559+popfu5659+popfu5759
            +popfu5859+popfu5959;

gen numr4049=popmr3859+popmr3959+popmr4059+popmr4159+popmr4259+popmr4359+popmr4459+popmr4559+popmr4659+popmr4759
            +popmr4859+popmr4959+popmr5059+popmr5159+popmr5259+popmr5359+popmr5459+popmr5559+popmr5659+popmr5759
            +popmr5859+popmr5959;
gen denr4049=popfr3859+popfr3959+popfr4059+popfr4159+popfr4259+popfr4359+popfr4459+popfr4559+popfr4659+popfr4759
            +popfr4859+popfr4959+popfr5059+popfr5159+popfr5259+popfr5359+popfr5459+popfr5559+popfr5659+popfr5759
            +popfr5859+popfr5959;

gen sr10u16=numu1619/denu1619;
gen sr10r16=numr1619/denr1619;
gen sr10a16=(numu1619+numr1619)/(denu1619+denr1619);

gen sr10u18=numu1819/denu1819;
gen sr10r18=numr1819/denr1819;
gen sr10a18=(numu1819+numr1819)/(denu1819+denr1819);

gen sr10u3039=numu3039/denu3039;
gen sr10r3039=numr3039/denu3039;
gen sr10a3039=(numu3039+numr3039)/(denu3039+denr3039);

gen sr10u4049=numu4049/denu4049;
gen sr10r4049=numr4049/denu4049;
gen sr10a4049=(numu4049+numr4049)/(denu4049+denr4049);


* Narrowest definition of sex ratios = up to 5-year age gap;
drop num* den*;
capture program drop numerator;
program define numerator;
        local i = 15     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        local q = `i'+6  ;
        local r = `i'+7  ;
        local s = `i'+8  ;
        local t = `i'+9  ;
        while `i' <= 45 {  ;
        gen numu`i'=popmu`i'59+popmu`j'59+popmu`k'59+popmu`l'59+popmu`m'59+popmu`n'59+popmu`o'59+popmu`p'59+popmu`q'59+popmu`r'59+popmu`s'59+popmu`t'59;
        gen numr`i'=popmr`i'59+popmr`j'59+popmr`k'59+popmr`l'59+popmr`m'59+popmr`n'59+popmr`o'59+popmr`p'59+popmr`q'59+popmr`r'59+popmr`s'59+popmr`t'59;
        gen num`i'=numu`i'+numr`i';
        local i = `i' + 5;
        local j = `j' + 5;
        local k = `k' + 5;
        local l = `l' + 5;
        local m = `m' + 5;
        local n = `n' + 5;
        local o = `o' + 5;
        local p = `p' + 5;
        local q = `q' + 5;
        local r = `r' + 5;
        local s = `s' + 5;
        local t = `t' + 5;
        }  ;
end;


capture program drop denominator;
program define denominator;
        local i = 15     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        local q = `i'+6  ;
        local r = `i'+7  ;
        local s = `i'+8  ;
        local t = `i'+9  ;
        while `i' <= 49 {  ;
        gen denu`i'=popfu`i'59+popfu`j'59+popfu`k'59+popfu`l'59+popfu`m'59+popfu`n'59+popfu`o'59+popfu`p'59+popfu`q'59+popfu`r'59+popfu`s'59+popfu`t'59;
        gen denr`i'=popfr`i'59+popfr`j'59+popfr`k'59+popfr`l'59+popfr`m'59+popfr`n'59+popfr`o'59+popfr`p'59+popfr`q'59+popfr`r'59+popfr`s'59+popfr`t'59;
        gen den`i'=denu`i'+denr`i';
        local i = `i' + 5;
        local j = `j' + 5;
        local k = `k' + 5;
        local l = `l' + 5;
        local m = `m' + 5;
        local n = `n' + 5;
        local o = `o' + 5;
        local p = `p' + 5;
        local q = `q' + 5;
        local r = `r' + 5;
        local s = `s' + 5;
        local t = `t' + 5;
        }  ;
end;

numerator;
denominator;

forval i = 15(5)49 { ;
        gen sr5u`i'=numu`i'/denu`i';
        gen sr5r`i'=numr`i'/denr`i';
        gen sr5a`i'=num`i'/den`i';
        } ;

drop num* den*;
gen numu1619=popmu1459+popmu1559+popmu1659+popmu1759+popmu1859+popmu1959+popmu2059+popmu2159+popmu2259+popmu2359
            +popmu2459;
gen denu1619=popfu1459+popfu1559+popfu1659+popfu1759+popfu1859+popfu1959+popfu2059+popfu2159+popfu2259+popfu2359
            +popfu2459;

gen numr1619=popmr1459+popmr1559+popmr1659+popmr1759+popmr1859+popmr1959+popmr2059+popmr2159+popmr2259+popmr2359
            +popmr2459;
gen denr1619=popfr1459+popfr1559+popfr1659+popfr1759+popfr1859+popfr1959+popfr2059+popfr2159+popfr2259+popfr2359
            +popfr2459;

gen numu1819=popmu1659+popmu1759+popmu1859+popmu1959+popmu2059+popmu2159+popmu2259+popmu2359
            +popmu2459;
gen denu1819=popfu1659+popfu1759+popfu1859+popfu1959+popfu2059+popfu2159+popfu2259+popfu2359
            +popfu2459;

gen numr1819=popmr1659+popmr1759+popmr1859+popmr1959+popmr2059+popmr2159+popmr2259+popmr2359
            +popmr2459;
gen denr1819=popfr1659+popfr1759+popfr1859+popfr1959+popfr2059+popfr2159+popfr2259+popfr2359
            +popfr2459;

gen numu3039=popmu2859+popmu2959+popmu3059+popmu3159+popmu3259+popmu3359+popmu3459+popmu3559+popmu3659+popmu3759
            +popmu3859+popmu3959+popmu4059+popmu4159+popmu4259+popmu4359+popmu4459;
gen denu3039=popfu2859+popfu2959+popfu3059+popfu3159+popfu3259+popfu3359+popfu3459+popfu3559+popfu3659+popfu3759
            +popfu3859+popfu3959+popfu4059+popfu4159+popfu4259+popfu4359+popfu4459;

gen numr3039=popmr2859+popmr2959+popmr3059+popmr3159+popmr3259+popmr3359+popmr3459+popmr3559+popmr3659+popmr3759
            +popmr3859+popmr3959+popmr4059+popmr4159+popmr4259+popmr4359+popmr4459;
gen denr3039=popfr2859+popfr2959+popfr3059+popfr3159+popfr3259+popfr3359+popfr3459+popfr3559+popfr3659+popfr3759
            +popfr3859+popfr3959+popfr4059+popfr4159+popfr4259+popfr4359+popfr4459;

gen numu4049=popmu3859+popmu3959+popmu4059+popmu4159+popmu4259+popmu4359+popmu4459+popmu4559+popmu4659+popmu4759
            +popmu4859+popmu4959+popmu5059+popmu5159+popmu5259+popmu5359+popmu5459;
gen denu4049=popfu3859+popfu3959+popfu4059+popfu4159+popfu4259+popfu4359+popfu4459+popfu4559+popfu4659+popfu4759
            +popfu4859+popfu4959+popfu5059+popfu5159+popfu5259+popfu5359+popfu5459;

gen numr4049=popmr3859+popmr3959+popmr4059+popmr4159+popmr4259+popmr4359+popmr4459+popmr4559+popmr4659+popmr4759
            +popmr4859+popmr4959+popmr5059+popmr5159+popmr5259+popmr5359+popmr5459;
gen denr4049=popfr3859+popfr3959+popfr4059+popfr4159+popfr4259+popfr4359+popfr4459+popfr4559+popfr4659+popfr4759
            +popfr4859+popfr4959+popfr5059+popfr5159+popfr5259+popfr5359+popfr5459;

gen sr5u16=numu1619/denu1619;
gen sr5r16=numr1619/denr1619;
gen sr5a16=(numu1619+numr1619)/(denu1619+denr1619);

gen sr5u18=numu1819/denu1819;
gen sr5r18=numr1819/denr1819;
gen sr5a18=(numu1819+numr1819)/(denu1819+denr1819);

gen sr5u3039=numu3039/denu3039;
gen sr5r3039=numr3039/denu3039;
gen sr5a3039=(numu3039+numr3039)/(denu3039+denr3039);

gen sr5u4049=numu4049/denu4049;
gen sr5r4049=numr4049/denu4049;
gen sr5a4049=(numu4049+numr4049)/(denu4049+denr4049);


sort regno;
save sexratios_5yr, replace;


