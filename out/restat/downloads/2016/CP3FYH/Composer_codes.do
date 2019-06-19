

****** Choose a local folder here *****
cd "C:\Users\Knock knock\Whos there\My data"
***************************************

***************************************
*** Main Results:
***************************************

***************************************
*** Table 3. The determinants of well-being
***************************************
use composer_data
xtset composer_name
global city vie lon mil flo rom ber ven bol col pra bud wei bon man sal str 

xtreg negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual  relationship?  , fe
outreg2 using "emotions.xls", tex(frag) ctitle(negemo, OLS) drop(o.* decade* composer? relationship*) nocons addtext(Composer FE, \checkmark, Addressee FE, \checkmark, Decade FE )  replace
xtreg negemo posemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual  relationship*  , fe
outreg2 using "emotions.xls", tex(frag) ctitle(negemo, OLS) drop(o.* decade* composer? relationship*) nocons addtext(Composer FE, \checkmark, Addressee FE, \checkmark, Decade FE )  append
xtreg negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual  relationship* decade* $city, fe
outreg2 using "emotions.xls", tex(frag) ctitle(negemo, OLS) drop(o.* decade* composer? relationship* $city) nocons addtext(Composer FE, \checkmark, Decade FE, \checkmark, Addressee FE, \checkmark, City FE, \checkmark)  append

xtreg posemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual  relationship*  ,fe
outreg2 using "emotions.xls", tex(frag) ctitle(posemo, OLS) drop(o.* decade* composer? relationship*) nocons addtext(Composer FE, \checkmark, Addressee FE, \checkmark, Decade FE )  append
xtreg posemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual  relationship* decade* $city, fe
outreg2 using "emotions.xls", tex(frag) ctitle(posemo, OLS) drop(o.*  decade* composer? relationship* $city) nocons addtext(Composer FE, \checkmark, Decade FE, \checkmark, Addressee FE, \checkmark, City FE, \checkmark)  append
***************************************


***************************************
*** Table 4. Creativity and negative emotions
***************************************
use composer_data
xtset composer_name

xtreg output negemo age age_2 age_3 age_4    , 
outreg2 using "results_IV.xls", tex(frag) ctitle(Output, OLS) replace drop( age age_2 age_3 age_4 ) nocons addtext(Age FE, \checkmark) 
xtreg output negemo age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual  relationship*   , fe 
outreg2 using "results_IV.xls", tex(frag) ctitle(Output, OLS) append drop(o.* decade* composer? relationship* age age_2 age_3 age_4 ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 

xtreg negemo death_of_relative age age_2 age_3 age_4      , 
outreg2 using "results_IV.xls", tex(frag) ctitle(Negemo, First-stage) append drop( age age_2 age_3 age_4 ) nocons addtext(Age FE, \checkmark) 
xtreg negemo death_of_relative age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual  relationship*    , fe 
outreg2 using "results_IV.xls", tex(frag) ctitle(Negemo, First-stage) append drop(o.* decade* composer? relationship* age age_2 age_3 age_4 ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 

xtivreg output age age_2 age_3 age_4    (negemo = death_of_relative )  , 
outreg2 using "results_IV.xls", tex(frag) ctitle(Output, IV) append drop( age age_2 age_3 age_4 ) nocons addtext(Age FE, \checkmark) 
xtivreg output age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual   relationship*   (negemo = death_of_relative )  , fe 
outreg2 using "results_IV.xls", tex(frag) ctitle(Output, IV) append drop(o.* decade* composer? relationship* age age_2 age_3 age_4 ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 
***************************************


***************************************
*** Table 5. Creativity gains by type of negative emotion
***************************************
use composer_data
xtset composer_name

xtreg anx death_of_relative age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship*, fe 
outreg2 using "results_channel.xls", tex(frag) ctitle(Anxiety, First-stage) replace drop(decade* composer? relationship* age age_2 age_3 age_4 o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 
xtivreg output age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* (anx = death_of_relative )  , fe 
outreg2 using "results_channel.xls", tex(frag) ctitle(Output, IV) append drop(decade* composer? relationship* age age_2 age_3 age_4 o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 

xtreg anger death_of_relative age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual relationship*, fe 
outreg2 using "results_channel.xls", tex(frag) ctitle(Anger, First-stage) append drop(decade* composer? relationship* age age_2 age_3 age_4 o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 
xtivreg output age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* (anger  = death_of_relative )  , fe 
outreg2 using "results_channel.xls", tex(frag) ctitle(Output, IV) append drop(decade* composer? relationship* age age_2 age_3 age_4 o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 

xtreg sad death_of_relative age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* , fe 
outreg2 using "results_channel.xls", tex(frag) ctitle(Sadness, First-stage) append drop(decade* composer? relationship* age age_2 age_3 age_4 o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 
xtivreg output age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* (sad = death_of_relative )  , fe 
outreg2 using "results_channel.xls", tex(frag) ctitle(Output, IV) append drop(decade* composer? relationship* age age_2 age_3 age_4 o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark) 
**************************************


***************************************
*** Figures 1-3. Positive and negative emotions of Mozart, Beethoven or Liszt
***************************************
twoway  (lpolyci posemo age, xaxis(1) yaxis(1) yscale(alt axis(1)) xtitle("", axis(1))  )    (lpoly posemo year, xaxis(3) yaxis(3) yscale(off) xtitle("", axis(3))  lstyle(none) xscale(alt axis(3)) yscale(alt axis(3)) ), legend(off) ytitle(Positive emotions) scheme(sj) graphregion(color(white)), if composer == "Mozart"
graph save m1, replace
twoway  (lpolyci negemo age, xaxis(1) yaxis(1) yscale(alt axis(1)) xtitle("", axis(1))  )    (lpoly negemo year, xaxis(3) yaxis(3) yscale(off) xtitle("", axis(3))  lstyle(none) xscale(alt axis(3)) yscale(alt axis(3)) ), legend(off) ytitle(Negative emotions) scheme(sj) graphregion(color(white)), if composer == "Mozart"
graph save m2, replace
gr combine m1.gph m2.gph, title(Wolfgang Amadeus Mozart (1756-1791)) scheme(sj) graphregion(color(white))

twoway  (lpolyci posemo age, xaxis(1) yaxis(1) yscale(alt axis(1)) xtitle("", axis(1))  )    (lpoly posemo year, xaxis(3) yaxis(3) yscale(off) xtitle("", axis(3))  lstyle(none) xscale(alt axis(3)) yscale(alt axis(3)) ), legend(off) ytitle(Positive emotions) scheme(sj) graphregion(color(white)), if composer == "Beethoven"
graph save b1, replace
twoway  (lpolyci negemo age, xaxis(1) yaxis(1) yscale(alt axis(1)) xtitle("", axis(1))  )    (lpoly negemo year, xaxis(3) yaxis(3) yscale(off) xtitle("", axis(3))  lstyle(none) xscale(alt axis(3)) yscale(alt axis(3)) ), legend(off) ytitle(Negative emotions) scheme(sj) graphregion(color(white)), if composer == "Beethoven"
graph save b2, replace
gr combine b1.gph b2.gph, title(Ludwig van Beethoven (1770-1827)) scheme(sj) graphregion(color(white))

twoway  (lpolyci posemo age,   )    , legend(off) ytitle(Positive emotions) scheme(sj) graphregion(color(white)), if composer == "Liszt"
graph save l1, replace
twoway  (lpolyci negemo age, )    , legend(off) ytitle(Negative emotions) scheme(sj) graphregion(color(white)), if composer == "Liszt"
graph save l2, replace
gr combine l1.gph l2.gph, title(Franz Liszt (1811-1886)) scheme(sj) graphregion(color(white))
***************************************


******************************************************************************
*** Additional and Robustness Results from Online Appendix
******************************************************************************

***************************************
*** Table 7. Financial situation and well-being
***************************************
use composer_data
xtset composer_name

xtreg posemo financial_concerns age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual relationship* , fe
outreg2 using "financial_concerns.xls", tex(frag) ctitle(posemo,, OLS) drop(age age_2 age_3 age_4 letters_annual tenure touring  marriage_cohabitation death_of_relative illness decade* composer? relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark)  replace
xtreg negemo financial_concerns age age_2 age_3 age_4 output tenure touring  marriage_cohabitation  death_of_relative illness letters_annual relationship*  , fe
outreg2 using "financial_concerns.xls", tex(frag) ctitle(negemo,, OLS) drop(age age_2 age_3 age_4 letters_annual tenure touring  marriage_cohabitation  death_of_relative illness 4 decade* composer? relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark )  append

keep if composer == "Mozart"
collapse posemo negemo financial_concerns anx sad anger letter income age* output*, by(year)
reg posemo income output age
outreg2 using "financial_concerns.xls", tex(frag) ctitle(posemo,only Mozart, OLS) drop(age ) nocons addtext(Age FE, \checkmark)  append
reg negemo income output age
outreg2 using "financial_concerns.xls", tex(frag) ctitle(negemo, only Mozart, OLS) drop(age ) nocons addtext(Age FE, \checkmark) append
***************************************


***************************************
*** Figure 6. Mozart's positive emotions and income, 1781-1791
***************************************
twoway  (line posemo age, yaxis(1) )    (line income age , yaxis(2) ), scheme(sj) graphregion(color(white)), if age > 25
***************************************


***************************************
*** Table 8. Testing the text analysis method
***************************************
use composer_data, clear
xtset composer_name

xtreg financial_concerns posemo negemo death_of_relative age age_2 age_3 age_4 output tenure touring  marriage_cohabitation  illness letters_annual  relationship*  , fe 
outreg2 using "liwc_validity.xls", tex(frag) ctitle(financial concerns, OLS) drop( age age_2 age_3 age_4 composer? o.* relationship*  ) nocons  addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark )  replace
xtreg death_concerns death_of_relative age age_2 age_3 age_4 relationship* , fe 
outreg2 using "liwc_validity.xls", tex(frag) ctitle(death concerns, OLS) drop( age age_2 age_3 age_4 composer? o.* relationship*  ) nocons  addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark ) append

foreach variable in death_concerns social sexual { 
xtreg `variable' posemo negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness letters_annual  relationship*  , fe
outreg2 using "liwc_validity.xls", tex(frag) ctitle(`variable', OLS) drop( age age_2 age_3 age_4 composer? o.* relationship*  ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark)  append
}
***************************************


***************************************
*** Table 9. Robustness of the identification
***************************************
use composer_data
xtset composer_name

* Columns 1-3
xtreg negemo death_without_father age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual relationship* , fe 
outreg2 using "robust_IV.xls", tex(frag) ctitle(Negemo, OLS, \multicolumn{4}{c}{Father deaths excluded}) replace drop(marriage_cohabitation o.* age age_2 age_3 age_4 tenure touring  marriage illness letters_annual relationship* ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 
xtivreg output age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual relationship* (negemo = death_without_father ), fe 
outreg2 using "robust_IV.xls", tex(frag) ctitle(Output, IV, ) append drop(marriage_cohabitation o.* age age_2 age_3 age_4 tenure touring  marriage illness letters_annual   relationship*   ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 
xtreg financial_concerns death_of_relative age age_2 age_3 age_4 output tenure touring  marriage_cohabitation  illness letters_annual  relationship* , fe
outreg2 using "robust_IV.xls", tex(frag) ctitle(Financial concerns, OLS, ) drop(marriage_cohabitation o.* age age_2 age_3 age_4 output tenure touring  marriage  illness letters_annual  relationship* composer? decade* ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark)  append

* Column 4
keep if composer == "Mozart"
replace income = 756 if composer == "Mozart" & year == 1786
collapse death_of_relative posemo negemo financial_concerns anx sad anger letter income age* output*, by(year)
reg income death_of_relative age
outreg2 using "robust_IV.xls", tex(frag) ctitle(Income, OLS, Only Mozart) drop(o.* age) nocons addtext(Age FE, \checkmark)  append

* Columns 5-8
use composer_data, clear
xtset composer_name
global city vie lon mil flo rom ber ven bol col pra bud wei bon man sal str 
xtreg negemo posemo death_of_relative age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual relationship* , fe 
outreg2 using "robust_IV.xls", tex(frag) ctitle(Negemo, OLS, ) drop(marriage_cohabitation o.* age age_2 age_3 age_4 output tenure touring  marriage  illness letters_annual relationship* composer? decade* ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark)  append
xtivreg output posemo age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual relationship* (negemo = death_of_relative ) , fe 
outreg2 using "robust_IV.xls", tex(frag) ctitle(Output, IV, ) drop(marriage_cohabitation o.* age age_2 age_3 age_4 output tenure touring  marriage illness letters_annual relationship* composer? decade* ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark)  append

xtreg negemo death_of_relative age age_2 age_3 age_4 tenure touring  marriage_cohabitation illness letters_annual relationship* decade* $city, fe 
outreg2 using "robust_IV.xls", tex(frag) ctitle(Negemo, OLS, ) drop(marriage_cohabitation o.* age age_2 age_3 age_4 output tenure touring  marriage  illness letters_annual  relationship* composer? decade* $city ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Decade FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark, City FE, \checkmark) append
xtivreg output age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* decade* $city (negemo = death_of_relative ) , fe 
outreg2 using "robust_IV.xls", tex(frag) ctitle(Output, IV, ) drop(marriage_cohabitation o.* age age_2 age_3 age_4 output tenure touring  marriage  illness letters_annual  relationship* composer? decade* $city ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Decade FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark, City FE, \checkmark)  append
***************************************


***************************************
*** Table 10. Length and number of letters and type of addressee
***************************************
use composer_data, clear
xtset composer_name

* column 1
reg wc posemo negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness composer?  relationship*   
outreg2 using "letters_writing.xls", addnote(Column 1 and 2 report OLS coefficients. Columns 3 and 4 report probit marginal effects.) tex(frag) ctitle(Word count per letter,, OLS) drop(o.* composer?  relationship*   age age_2 age_3 age_4 ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark)  replace

* column 2
collapse letters_annual posemo negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness composer? relationship*  decade* , by(year composer )
reg letters_annual posemo negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness composer?  relationship*   
outreg2 using "letters_writing.xls", addnote(Column 1 and 2 report OLS coefficients. Columns 3 and 4 report probit marginal effects.) tex(frag) ctitle(\#letters,, OLS) drop(o.* composer?  relationship*   age age_2 age_3 age_4 ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark)  append

* columns 3 and 4
use composer_data, clear
xtset composer_name
foreach type in family peer friend business stranger {
gen relationship_`type' = (category_relationship == "`type'")
}
gen personal = relationship_family + relationship_friend
gen professional =  relationship_business + relationship_peer + relationship_stranger 

dprobit personal posemo negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness composer? 
outreg2 using "letters_writing.xls", tex(frag) ctitle(personal, (family or friend), Probit) addstat(Pseudo R2, 0.113)  drop(age age_2 age_3 age_4 composer?) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Decade FE, \checkmark)  append
dprobit professional posemo negemo age age_2 age_3 age_4 output tenure touring  marriage_cohabitation death_of_relative illness composer?, 
outreg2 using "letters_writing.xls", addnote(Column 1 and 2 report OLS coefficients. Columns 3 and 4 report probit marginal effects.) tex(frag) ctitle(professional, (business or peer or stranger), Probit)  addstat(Pseudo R2, 0.095) drop(age age_2 age_3 age_4 composer?) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Decade FE, \checkmark)  append
***************************************


***************************************
*** Table 11. Creativity and negative emotions: The timing of the effect
***************************************
use composer_data, clear
xtset composer_name
replace output = output - theater 

xtreg output negemo age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* , fe 
outreg2 using "timing.xls", tex(frag) ctitle(\multicolumn{2}{c}{Output (theater works excluded)}, OLS) replace drop(age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 
xtivreg output age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* (negemo = death_of_relative ), fe 
outreg2 using "timing.xls", tex(frag) ctitle(, IV) append drop(age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* o.* ) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 

use composer_data, clear
xtset composer_name

xtreg t2_output negemo age age_2 age_3 age_4 tenure touring marriage_cohabitation letters_annual relationship* , fe 
outreg2 using "timing.xls", tex(frag) ctitle(\multicolumn{2}{c}{Output over 2 years}, OLS) append drop(age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 
xtivreg t2_output age age_2 age_3 age_4 tenure touring marriage_cohabitation letters_annual relationship* (negemo = death_of_relative ), fe 
outreg2 using "timing.xls", tex(frag) ctitle(, IV) append drop(age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 

xtreg t3_output negemo age age_2 age_3 age_4 tenure touring marriage_cohabitation letters_annual relationship* , fe 
outreg2 using "timing.xls", tex(frag) ctitle(\multicolumn{2}{c}{Output over 3 years}, OLS) append drop(age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 
xtivreg t3_output age age_2 age_3 age_4 tenure touring marriage_cohabitation letters_annual relationship* (negemo = death_of_relative ) , fe 
outreg2 using "timing.xls", tex(frag) ctitle(, IV) append drop(age age_2 age_3 age_4 tenure touring marriage_cohabitation illness letters_annual relationship* o.*) nocons addtext(Composer FE, \checkmark, Age FE, \checkmark, Addressee FE, \checkmark, Background controls, \checkmark) 
***************************************

