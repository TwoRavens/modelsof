**Article RISP/IPSR Di Mauro-Fiket**

**Regression models for Table. 5** 


**selecting cases and recoding demographic variables**


generate partonly=TYPE
recode partonly (1=1) (2/10=0) 
tab partonly

drop if partonly<1


**gender:male**

recode SEX1 (2=0), gen (Male)
ta Male

**Age**
generate float Age = 2009-AGE1

ta Age


**Education**

generate float Education = EDUC1
replace Education = Age if (EDUC1<1)
ta Education


**class**

generate class=CLASS1
recode class (1=4) (2=3) (3=2) (4=1) (5=.)
ta class





** --------------------TIME 1 --------------**


recode V1Q34 (5=.), gen (identityw1)
label values identityw1 V1Q34
tab identityw1



** ologit TIME 1**

ologit identityw1 Male Age Education class LEFTRIGH V1Q33B, or vce(robust)

fitstat


***---------------------TIME 2 -----------------**


recode V2Q34 (5=.), gen (identityw2)
tab identityw2



** ologit TIME 2**

ologit identityw2 Male Age Education class LEFTRIGH V1Q33B, or vce(robust)


fitstat


***---------------------TIME 3 -----------------**


recode V3Q34 (5=.), gen (identityw3)
tab identityw3



** ologit TIME 3**

ologit identityw3 Male Age Education class LEFTRIGH V1Q33B, or vce(robust)

fitstat


***---------------------TIME 4 -----------------**


recode V4Q34 (5=.), gen (identityw4)
tab identityw4



** ologit TIME 4**

ologit identityw4 Male Age Education class LEFTRIGH V1Q33B, or vce(robust)


fitstat







