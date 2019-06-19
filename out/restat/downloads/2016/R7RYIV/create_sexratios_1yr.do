
************************************************************************
*  Creates oblast-level sex ratios for Russia by one-year age group
************************************************************************

# delimit ;
set more 1;
use pop_age_sex_1yr;  /*  Contains population counts by oblast, sex, urban/rural, married, by 1-year age group */


* Narrow definition of sex ratios = 7-year age gap;
capture program drop numerator;
program define numerator;
        local i = 16    ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        while `i' <= 49 {  ;
        gen numu`i'=popmu`i'59+popmu`j'59+popmu`k'59+popmu`l'59+popmu`m'59+popmu`n'59+popmu`o'59+popmu`p'59;
        gen numr`i'=popmr`i'59+popmr`j'59+popmr`k'59+popmr`l'59+popmr`m'59+popmr`n'59+popmr`o'59+popmr`p'59;
        gen num`i'=numu`i'+numr`i';
        local i = `i' + 1;
        local j = `j' + 1;
        local k = `k' + 1;
        local l = `l' + 1;
        local m = `m' + 1;
        local n = `n' + 1;
        local o = `o' + 1;
        local p = `p' + 1;
        }  ;
end;

capture program drop denominator;
program define denominator;
        local i = 16     ;
        local j = `i'-2  ;
        local k = `i'-1  ;
        local l = `i'+1  ;
        local m = `i'+2  ;
        local n = `i'+3  ;
        local o = `i'+4  ;
        local p = `i'+5  ;
        while `i' <= 49 {  ;
        gen denu`i'=popfu`i'59+popfu`j'59+popfu`k'59+popfu`l'59+popfu`m'59+popfu`n'59+popfu`o'59+popfu`p'59; ;
        gen denr`i'=popfr`i'59+popfr`j'59+popfr`k'59+popfr`l'59+popfr`m'59+popfr`n'59+popfr`o'59+popfr`p'59;;
        gen den`i'=denu`i'+denr`i';
        local i = `i' + 1;
        local j = `j' + 1;
        local k = `k' + 1;
        local l = `l' + 1;
        local m = `m' + 1;
        local n = `n' + 1;
        local o = `o' + 1;
        local p = `p' + 1;
        }  ;
end;

numerator;
denominator;

forval i = 16(1)49 { ;
        gen sr5u`i'=numu`i'/denu`i';
        gen sr5r`i'=numr`i'/denr`i';
        gen sr5a`i'=num`i'/den`i';
        } ;

drop num* den*;


* Base definition of sex ratios = 10-year age gap, staggered 2 years;
capture program drop numerator;
program define numerator;
        local i = 16     ;
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
        while `i' <= 49 {  ;
        gen numu`i'=popmu`i'59+popmu`j'59+popmu`k'59+popmu`l'59+popmu`m'59+popmu`n'59+popmu`o'59+popmu`p'59+popmu`q'59+popmu`r'59+popmu`s'59+popmu`t'59+popmu`u'59;
        gen numr`i'=popmr`i'59+popmr`j'59+popmr`k'59+popmr`l'59+popmr`m'59+popmr`n'59+popmr`o'59+popmr`p'59+popmr`q'59+popmr`r'59+popmr`s'59+popmr`t'59+popmr`u'59;
        gen num`i'=numu`i'+numr`i';
        local i = `i' + 1;
        local j = `j' + 1;
        local k = `k' + 1;
        local l = `l' + 1;
        local m = `m' + 1;
        local n = `n' + 1;
        local o = `o' + 1;
        local p = `p' + 1;
        local q = `q' + 1;
        local r = `r' + 1;
        local s = `s' + 1;
        local t = `t' + 1;
        local u = `u' + 1;
        }  ;
end;

capture program drop denominator;
program define denominator;
        local i = 16     ;
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
        while `i' <= 49 {  ;
        gen denu`i'=popfu`i'59+popfu`j'59+popfu`k'59+popfu`l'59+popfu`m'59+popfu`n'59+popfu`o'59+popfu`p'59+popfu`q'59+popfu`r'59+popfu`s'59+popfu`t'59+popfu`u'59;
        gen denr`i'=popfr`i'59+popfr`j'59+popfr`k'59+popfr`l'59+popfr`m'59+popfr`n'59+popfr`o'59+popfr`p'59+popfr`q'59+popfr`r'59+popfr`s'59+popfr`t'59+popfr`u'59;
        gen den`i'=denu`i'+denr`i';
        local i = `i' + 1;
        local j = `j' + 1;
        local k = `k' + 1;
        local l = `l' + 1;
        local m = `m' + 1;
        local n = `n' + 1;
        local o = `o' + 1;
        local p = `p' + 1;
        local q = `q' + 1;
        local r = `r' + 1;
        local s = `s' + 1;
        local t = `t' + 1;
        local u = `u' + 1;
        }  ;
end;

numerator;
denominator;

forval i = 16(1)49 { ;
        gen sr10u`i'=numu`i'/denu`i';
        gen sr10r`i'=numr`i'/denr`i';
        gen sr10a`i'=num`i'/den`i';
        } ;


* Broadest definition of sex ratios = 17-year age gap;
drop den* num*;
capture program drop numerator;
program define numerator;
        local i = 16     ;
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
        local u = `i'+10  ;
        local v = `i'+11  ;
        local w = `i'+12  ;
        local x = `i'+13  ;
        local y = `i'+14  ;
        local z = `i'+15  ;
        while `i' <= 49 {  ;
        gen numu`i'=popmu`i'59+popmu`j'59+popmu`k'59+popmu`l'59+popmu`m'59+popmu`n'59+popmu`o'59+popmu`p'59+popmu`q'59+popmu`r'59+popmu`s'59+popmu`t'59+popmu`u'59+popmu`v'59+popmu`w'59+popmu`x'59+popmu`y'59+popmu`z'59;
        gen numr`i'=popmr`i'59+popmr`j'59+popmr`k'59+popmr`l'59+popmr`m'59+popmr`n'59+popmr`o'59+popmr`p'59+popmr`q'59+popmr`r'59+popmr`s'59+popmr`t'59+popmr`u'59+popmr`v'59+popmr`w'59+popmr`x'59+popmr`y'59+popmr`z'59;
        gen num`i'=numu`i'+numr`i';
        local i = `i' + 1;
        local j = `j' + 1;
        local k = `k' + 1;
        local l = `l' + 1;
        local m = `m' + 1;
        local n = `n' + 1;
        local o = `o' + 1;
        local p = `p' + 1;
        local q = `q' + 1;
        local r = `r' + 1;
        local s = `s' + 1;
        local t = `t' + 1;
        local u = `u' + 1;
        local v = `v' + 1;
        local w = `w' + 1;
        local x = `x' + 1;
        local y = `y' + 1;
        local z = `z' + 1;
        }  ;
end;


capture program drop denominator;
program define denominator;
        local i = 16     ;
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
        local u = `i'+10  ;
        local v = `i'+11  ;
        local w = `i'+12  ;
        local x = `i'+13  ;
        local y = `i'+14  ;
        local z = `i'+15  ;
        while `i' <= 49 {  ;
        gen denu`i'=popfu`i'59+popfu`j'59+popfu`k'59+popfu`l'59+popfu`m'59+popfu`n'59+popfu`o'59+popfu`p'59+popfu`q'59+popfu`r'59+popfu`s'59+popfu`t'59+popfu`u'59+popfu`v'59+popfu`w'59+popfu`x'59+popfu`y'59+popfu`z'59;
        gen denr`i'=popfr`i'59+popfr`j'59+popfr`k'59+popfr`l'59+popfr`m'59+popfr`n'59+popfr`o'59+popfr`p'59+popfr`q'59+popfr`r'59+popfr`s'59+popfr`t'59+popfr`u'59+popfr`v'59+popfr`w'59+popfr`x'59+popfr`y'59+popfr`z'59;
        gen den`i'=denu`i'+denr`i';
        local i = `i' + 1;
        local j = `j' + 1;
        local k = `k' + 1;
        local l = `l' + 1;
        local m = `m' + 1;
        local n = `n' + 1;
        local o = `o' + 1;
        local p = `p' + 1;
        local q = `q' + 1;
        local r = `r' + 1;
        local s = `s' + 1;
        local t = `t' + 1;
        local u = `u' + 1;
        local v = `v' + 1;
        local w = `w' + 1;
        local x = `x' + 1;
        local y = `y' + 1;
        local z = `z' + 1;
        }  ;
end;

numerator;
denominator;

forval i = 16(1)49 { ;
        gen sr15u`i'=numu`i'/denu`i';
        gen sr15r`i'=numr`i'/denr`i';
        gen sr15a`i'=num`i'/den`i';
        } ;


keep regno sr*;
sort regno;
save sexratios_1yr, replace;



