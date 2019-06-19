set more off


******************************************************************
* Compare locations where convenience should matter with locations 
* where convenience is irrelevant using relative inconvenience
******************************************************************

* REStat regression (1) using n(p), Table 2, column (a)
* Note: location10 (superstores) is the excluded variable (constant)
regress n price location14 location15 location13 location17 location12 location9 location7 location16 location6 location3 location5 location4 location1 location18 location11 location2 product2 product3 product4 product7 product8 product9 product15 product19, r
test product2 product3 product4 product7 product8 product9 product15 product19
* For adjusted-R-squared
display(e(r2_a))

* REStat regression (1) using n+(p), Table 2, column (b)
* Note: location10 (superstores) is the excluded variable (constant)
regress nplus price location14 location15 location13 location17 location12 location9 location7 location16 location6 location3 location5 location4 location1 location18 location11 location2 product2 product3 product4 product7 product8 product9 product15 product19, r
test product2 product3 product4 product7 product8 product9 product15 product19
* For adjusted-R-squared
display(e(r2_a))


**********************************************************
* Convenience regressions, level of relative inconvenience
**********************************************************

* REStat regression (2) using n(p), Table 3, column (a)
regress n price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21, r
test product1 product2 product3 product4 product5 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21 
* For adjusted-R-squared
display(e(r2_a))

* REStat regression (2) using n+(p), Table 3, column (b)
regress nplus price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21, r
test product1 product2 product3 product4 product5 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21 
* For adjusted-R-squared
display(e(r2_a))

* * For computing average savings from interacting CONV with product dummies:
* * For n(p) measure:
* regress n price product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21 convp1 convp2 convp3 convp4 convp5 convp6 convp7 convp8 convp9 convp10 convp12 convp13 convp14 convp15 convp16 convp17 convp18 convp19 convp21, r
* * For n+(p) measure:
* regress nplus price product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21 convp1 convp2 convp3 convp4 convp5 convp6 convp7 convp8 convp9 convp10 convp12 convp13 convp14 convp15 convp16 convp17 convp18 convp19 convp21, r

* * For count data regressions:
* * Poisson regression for [n(p)-1]:
* * Note: product16 excluded (constant)
* poisson nminus1 price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product17 product18 product19 product21, r
* estat gof
* * Negative binomial regression for [n+(p)-1]:
* * Note: product16 excluded (constant)
* nbreg nplusminus1 price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product17 product18 product19 product21, r

* Considering TAXEXTRA:

* REStat regression (2) plus TAXEXTRA using n(p), Table 3, column (c)
regress n price conv taxextra product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21, r 
test product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21
* For adjusted-R-squared
display(e(r2_a))

* REStat regression (2) plus TAXEXTRA using n+(p), Table 3, column (d)
regress nplus price conv taxextra product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21, r 
test product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product16 product17 product18 product19 product21
* For adjusted-R-squared
display(e(r2_a))

****************************************************
* For computing marginal effects later
****************************************************
egen m1=mean(product1)
egen m2=mean(product2)
egen m3=mean(product3)
egen m4=mean(product4)
egen m5=mean(product5)
egen m6=mean(product6)
egen m7=mean(product7)
egen m8=mean(product8)
egen m9=mean(product9)
egen m10=mean(product10)
egen m12=mean(product12)
egen m13=mean(product13)
egen m14=mean(product14)
egen m15=mean(product15)
egen m16=mean(product16)
egen m17=mean(product17)
egen m18=mean(product18)
egen m19=mean(product19)
egen m21=mean(product21)

egen pp1=mean(price) if product1
egen pp2=mean(price) if product2
egen pp3=mean(price) if product3
egen pp4=mean(price) if product4
egen pp5=mean(price) if product5
egen pp6=mean(price) if product6
egen pp7=mean(price) if product7
egen pp8=mean(price) if product8
egen pp9=mean(price) if product9
egen pp10=mean(price) if product10
egen pp12=mean(price) if product12
egen pp13=mean(price) if product13
egen pp14=mean(price) if product14
egen pp15=mean(price) if product15
egen pp16=mean(price) if product16
egen pp17=mean(price) if product17
egen pp18=mean(price) if product18
egen pp19=mean(price) if product19
egen pp21=mean(price) if product21

egen p1=mean(pp1)
egen p2=mean(pp2)
egen p3=mean(pp3)
egen p4=mean(pp4)
egen p5=mean(pp5)
egen p6=mean(pp6)
egen p7=mean(pp7)
egen p8=mean(pp8)
egen p9=mean(pp9)
egen p10=mean(pp10)
egen p12=mean(pp12)
egen p13=mean(pp13)
egen p14=mean(pp14)
egen p15=mean(pp15)
egen p16=mean(pp16)
egen p17=mean(pp17)
egen p18=mean(pp18)
egen p19=mean(pp19)
egen p21=mean(pp21)


****************************************************
* Probit regressions for monetary convenience points
****************************************************

* REStat regression (3) using n(p), +/- 1%, Table 3, column (e)
* Note: product15 excluded (constant)
probit n1percent price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product16 product17 product18 product19 product21, r 
test product2 product3 product4 product6 product7 product8 product9 product10 product12 product18 product19 product21
* Compute average marginal effect
generate s1=m2+m3+m4+m6+m7+m8+m9+m10+m12+m15+m18+m19+m21
generate w2=m2/s1
generate w3=m3/s1
generate w4=m4/s1
generate w6=m6/s1
generate w7=m7/s1
generate w8=m8/s1
generate w9=m9/s1
generate w10=m10/s1
generate w12=m12/s1
generate w15=m15/s1
generate w18=m18/s1
generate w19=m19/s1
generate w21=m21/s1
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4])
generate d6=normal(_coef[_cons]+_coef[price]*p6+_coef[product6]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p6+_coef[product6])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[conv])-normal(_coef[_cons]+_coef[price]*p15)
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18])
generate d19=normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p19+_coef[product19])
generate d21=normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p21+_coef[product21])
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd6=w6*d6
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd15=w15*d15
generate wd18=w18*d18
generate wd19=w19*d19
generate wd21=w21*d21
generate avg_marg=wd2+wd3+wd4+wd6+wd7+wd8+wd9+wd10+wd12+wd15+wd18+wd19+wd21
* Average marginal effect from CONV:
di avg_marg
drop s1 w2 w3 w4 w6 w7 w8 w9 w10 w12 w15 w18 w19 w21 d2 d3 d4 d6 d7 d8 d9 d10 d12 d15 d18 d19 d21 wd2 wd3 wd4 wd6 wd7 wd8 wd9 wd10 wd12 wd15 wd18 wd19 wd21 avg_marg
 
* REStat regression (3) using n(p), +/- 5%, Table 3, column (f)
* Note: product16 excluded (constant)
probit n5percent price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product17 product18 product19 product21, r
test product1 product2 product3 product4 product7 product8 product9 product10 product12 product13 product15 product17 product18 product19 product21 
* Compute average marginal effect
generate s1=m1+m2+m3+m4+m7+m8+m9+m10+m12+m13+m15+m16+m17+m18+m19+m21
generate w1=m1/s1
generate w2=m2/s1
generate w3=m3/s1
generate w4=m4/s1
generate w7=m7/s1
generate w8=m8/s1
generate w9=m9/s1
generate w10=m10/s1
generate w12=m12/s1
generate w13=m13/s1
generate w15=m15/s1
generate w16=m16/s1
generate w17=m17/s1
generate w18=m18/s1
generate w19=m19/s1
generate w21=m21/s1
generate d1=normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p1+_coef[product1])
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12])
generate d13=normal(_coef[_cons]+_coef[price]*p13+_coef[product13]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p13+_coef[product13])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p15+_coef[product15])
generate d16=normal(_coef[_cons]+_coef[price]*p16+_coef[conv])-normal(_coef[_cons]+_coef[price]*p16)
generate d17=normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p17+_coef[product17])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18])
generate d19=normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p19+_coef[product19])
generate d21=normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p21+_coef[product21])
generate wd1=w1*d1
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd13=w13*d13
generate wd15=w15*d15
generate wd16=w16*d16
generate wd17=w17*d17
generate wd18=w18*d18
generate wd19=w19*d19
generate wd21=w21*d21
generate avg_marg=wd1+wd2+wd3+wd4+wd7+wd8+wd9+wd10+wd12+wd13+wd15+wd16+wd17+wd18+wd19+wd21
* Average marginal effect from CONV:
di avg_marg
drop s1 w1 w2 w3 w4 w7 w8 w9 w10 w12 w13 w15 w16 w17 w18 w19 w21 d1 d2 d3 d4 d7 d8 d9 d10 d12 d13 d15 d16 d17 d18 d19 d21 
drop wd1 wd2 wd3 wd4 wd7 wd8 wd9 wd10 wd12 wd13 wd15 wd16 wd17 wd18 wd19 wd21 avg_marg

* REStat regression (3) using n(p), +/- 10%, Table 3, column (g)
* Note: product16 excluded (constant)
probit n10percent price conv product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product17 product18 product19 product21, r
test product1 product2 product3 product4 product7 product8 product9 product10 product12 product14 product15 product17 product18 
* Compute average marginal effect
generate s1=m1+m2+m3+m4+m7+m8+m9+m10+m12+m13+m14+m15+m16+m17+m18
generate w1=m1/s1
generate w2=m2/s1
generate w3=m3/s1
generate w4=m4/s1
generate w7=m7/s1
generate w8=m8/s1
generate w9=m9/s1
generate w10=m10/s1
generate w12=m12/s1
generate w13=m13/s1
generate w14=m14/s1
generate w15=m15/s1
generate w16=m16/s1
generate w17=m17/s1
generate w18=m18/s1
generate d1=normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p1+_coef[product1])
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12])
generate d13=normal(_coef[_cons]+_coef[price]*p13+_coef[product13]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p13+_coef[product13])
generate d14=normal(_coef[_cons]+_coef[price]*p14+_coef[product14]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p14+_coef[product14])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p15+_coef[product15])
generate d16=normal(_coef[_cons]+_coef[price]*p16+_coef[conv])-normal(_coef[_cons]+_coef[price]*p16)
generate d17=normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p17+_coef[product17])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18])
generate wd1=w1*d1
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd13=w13*d13
generate wd14=w14*d14
generate wd15=w15*d15
generate wd16=w16*d16
generate wd17=w17*d17
generate wd18=w18*d18
generate avg_marg=wd1+wd2+wd3+wd4+wd7+wd8+wd9+wd10+wd12+wd13+wd14+wd15+wd16+wd17+wd18
* Average marginal effect from CONV:
di avg_marg
drop s1 w1 w2 w3 w4 w7 w8 w9 w10 w12 w13 w14 w15 w16 w17 w18 d1 d2 d3 d4 d7 d8 d9 d10 d12 d13 d14 d15 d16 d17 d18
drop wd1 wd2 wd3 wd4 wd7 wd8 wd9 wd10 wd12 wd13 wd14 wd15 wd16 wd17 wd18 avg_marg

* Considering TAXEXTRA:

* REStat regression (3) plus TAXEXTRA using n(p), +/- 1%, Table 3, column (h)
* Note: product15 excluded (constant)
probit n1percent price conv taxextra product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product16 product17 product18 product19 product21, r 
test product2 product3 product4 product6 product7 product8 product9 product10 product12 product18 product19 product21
* Compute average marginal effect
generate s1=m2+m3+m4+m6+m7+m8+m9+m10+m12+m15+m18+m19+m21
generate w2=m2/s1
generate w3=m3/s1
generate w4=m4/s1
generate w6=m6/s1
generate w7=m7/s1
generate w8=m8/s1
generate w9=m9/s1
generate w10=m10/s1
generate w12=m12/s1
generate w15=m15/s1
generate w18=m18/s1
generate w19=m19/s1
generate w21=m21/s1
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4])
generate d6=normal(_coef[_cons]+_coef[price]*p6+_coef[product6]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p6+_coef[product6])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p15)
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18])
generate d19=normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p19+_coef[product19])
generate d21=normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p21+_coef[product21])
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd6=w6*d6
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd15=w15*d15
generate wd18=w18*d18
generate wd19=w19*d19
generate wd21=w21*d21
generate avg_marg=wd2+wd3+wd4+wd6+wd7+wd8+wd9+wd10+wd12+wd15+wd18+wd19+wd21
* Average marginal effect from TAXEXTRA when CONV=0:
di avg_marg
drop d2 d3 d4 d6 d7 d8 d9 d10 d12 d15 d18 d19 d21 wd2 wd3 wd4 wd6 wd7 wd8 wd9 wd10 wd12 wd15 wd18 wd19 wd21 avg_marg
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv])
generate d6=normal(_coef[_cons]+_coef[price]*p6+_coef[product6]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p6+_coef[product6]+_coef[conv])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p15+_coef[conv])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv])
generate d19=normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[conv])
generate d21=normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[conv])
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd6=w6*d6
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd15=w15*d15
generate wd18=w18*d18
generate wd19=w19*d19
generate wd21=w21*d21
generate avg_marg=wd2+wd3+wd4+wd6+wd7+wd8+wd9+wd10+wd12+wd15+wd18+wd19+wd21
* Average marginal effect from TAXEXTRA when CONV=1:
di avg_marg
drop s1 w2 w3 w4 w6 w7 w8 w9 w10 w12 w15 w18 w19 w21 d2 d3 d4 d6 d7 d8 d9 d10 d12 d15 d18 d19 d21 wd2 wd3 wd4 wd6 wd7 wd8 wd9 wd10 wd12 wd15 wd18 wd19 wd21 avg_marg

* REStat regression (3) plus TAXEXTRA using n(p), +/- 5%, Table 3, column (i)
* Note: product13 excluded (constant)
probit n5percent price conv taxextra product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product14 product15 product16 product17 product18 product19 product21, r
test product1 product2 product3 product4 product7 product8 product9 product10 product12 product15 product16 product17 product18 product19 product21 
* Compute average marginal effect
generate s1=m1+m2+m3+m4+m7+m8+m9+m10+m12+m13+m15+m16+m17+m18+m19+m21
generate w1=m1/s1
generate w2=m2/s1
generate w3=m3/s1
generate w4=m4/s1
generate w7=m7/s1
generate w8=m8/s1
generate w9=m9/s1
generate w10=m10/s1
generate w12=m12/s1
generate w13=m13/s1
generate w15=m15/s1
generate w16=m16/s1
generate w17=m17/s1
generate w18=m18/s1
generate w19=m19/s1
generate w21=m21/s1
generate d1=normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p1+_coef[product1])
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12])
generate d13=normal(_coef[_cons]+_coef[price]*p13+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p13)
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p15+_coef[product15])
generate d16=normal(_coef[_cons]+_coef[price]*p16+_coef[product16]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p16+_coef[product16])
generate d17=normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p17+_coef[product17])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18])
generate d19=normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p19+_coef[product19])
generate d21=normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p21+_coef[product21])
generate wd1=w1*d1
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd13=w13*d13
generate wd15=w15*d15
generate wd16=w16*d16
generate wd17=w17*d17
generate wd18=w18*d18
generate wd19=w19*d19
generate wd21=w21*d21
generate avg_marg=wd1+wd2+wd3+wd4+wd7+wd8+wd9+wd10+wd12+wd13+wd15+wd16+wd17+wd18+wd19+wd21
* Average marginal effect from TAXEXTRA when CONV=0:
di avg_marg
drop d1 d2 d3 d4 d7 d8 d9 d10 d12 d13 d15 d16 d17 d18 d19 d21 
drop wd1 wd2 wd3 wd4 wd7 wd8 wd9 wd10 wd12 wd13 wd15 wd16 wd17 wd18 wd19 wd21 avg_marg
generate d1=normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[conv])
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv])
generate d13=normal(_coef[_cons]+_coef[price]*p13+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p13+_coef[conv])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[conv])
generate d16=normal(_coef[_cons]+_coef[price]*p16+_coef[product16]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p16+_coef[product16]+_coef[conv])
generate d17=normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[conv])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv])
generate d19=normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p19+_coef[product19]+_coef[conv])
generate d21=normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p21+_coef[product21]+_coef[conv])
generate wd1=w1*d1
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd13=w13*d13
generate wd15=w15*d15
generate wd16=w16*d16
generate wd17=w17*d17
generate wd18=w18*d18
generate wd19=w19*d19
generate wd21=w21*d21
generate avg_marg=wd1+wd2+wd3+wd4+wd7+wd8+wd9+wd10+wd12+wd13+wd15+wd16+wd17+wd18+wd19+wd21
* Average marginal effect from TAXEXTRA when CONV=1:
di avg_marg
drop s1 w1 w2 w3 w4 w7 w8 w9 w10 w12 w13 w15 w16 w17 w18 w19 w21 d1 d2 d3 d4 d7 d8 d9 d10 d12 d13 d15 d16 d17 d18 d19 d21 
drop wd1 wd2 wd3 wd4 wd7 wd8 wd9 wd10 wd12 wd13 wd15 wd16 wd17 wd18 wd19 wd21 avg_marg

* REStat regression (3) plus TAXEXTRA using n(p), +/- 10%, Table 3, column (j)
* Note: product16 excluded (constant)
probit n10percent price conv taxextra product1 product2 product3 product4 product5 product6 product7 product8 product9 product10 product12 product13 product14 product15 product17 product18 product19 product21, r
test product1 product2 product3 product4 product7 product8 product9 product10 product12 product14 product15 product17 product18 
* Compute average marginal effect
generate s1=m1+m2+m3+m4+m7+m8+m9+m10+m12+m13+m14+m15+m16+m17+m18
generate w1=m1/s1
generate w2=m2/s1
generate w3=m3/s1
generate w4=m4/s1
generate w7=m7/s1
generate w8=m8/s1
generate w9=m9/s1
generate w10=m10/s1
generate w12=m12/s1
generate w13=m13/s1
generate w14=m14/s1
generate w15=m15/s1
generate w16=m16/s1
generate w17=m17/s1
generate w18=m18/s1
generate d1=normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p1+_coef[product1])
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12])
generate d13=normal(_coef[_cons]+_coef[price]*p13+_coef[product13]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p13+_coef[product13])
generate d14=normal(_coef[_cons]+_coef[price]*p14+_coef[product14]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p14+_coef[product14])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p15+_coef[product15])
generate d16=normal(_coef[_cons]+_coef[price]*p16+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p16)
generate d17=normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p17+_coef[product17])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18])
generate wd1=w1*d1
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd13=w13*d13
generate wd14=w14*d14
generate wd15=w15*d15
generate wd16=w16*d16
generate wd17=w17*d17
generate wd18=w18*d18
generate avg_marg=wd1+wd2+wd3+wd4+wd7+wd8+wd9+wd10+wd12+wd13+wd14+wd15+wd16+wd17+wd18
* Average marginal effect from TAXEXTRA when CONV=0: 
di avg_marg
drop d1 d2 d3 d4 d7 d8 d9 d10 d12 d13 d14 d15 d16 d17 d18
drop wd1 wd2 wd3 wd4 wd7 wd8 wd9 wd10 wd12 wd13 wd14 wd15 wd16 wd17 wd18 avg_marg
generate d1=normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p1+_coef[product1]+_coef[conv])
generate d2=normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p2+_coef[product2]+_coef[conv])
generate d3=normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p3+_coef[product3]+_coef[conv])
generate d4=normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p4+_coef[product4]+_coef[conv])
generate d7=normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p7+_coef[product7]+_coef[conv])
generate d8=normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p8+_coef[product8]+_coef[conv])
generate d9=normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p9+_coef[product9]+_coef[conv])
generate d10=normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p10+_coef[product10]+_coef[conv])
generate d12=normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p12+_coef[product12]+_coef[conv])
generate d13=normal(_coef[_cons]+_coef[price]*p13+_coef[product13]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p13+_coef[product13]+_coef[conv])
generate d14=normal(_coef[_cons]+_coef[price]*p14+_coef[product14]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p14+_coef[product14]+_coef[conv])
generate d15=normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p15+_coef[product15]+_coef[conv])
generate d16=normal(_coef[_cons]+_coef[price]*p16+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p16+_coef[conv])
generate d17=normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p17+_coef[product17]+_coef[conv])
generate d18=normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv]+_coef[taxextra])-normal(_coef[_cons]+_coef[price]*p18+_coef[product18]+_coef[conv])
generate wd1=w1*d1
generate wd2=w2*d2
generate wd3=w3*d3
generate wd4=w4*d4
generate wd7=w7*d7
generate wd8=w8*d8
generate wd9=w9*d9
generate wd10=w10*d10
generate wd12=w12*d12
generate wd13=w13*d13
generate wd14=w14*d14
generate wd15=w15*d15
generate wd16=w16*d16
generate wd17=w17*d17
generate wd18=w18*d18
generate avg_marg=wd1+wd2+wd3+wd4+wd7+wd8+wd9+wd10+wd12+wd13+wd14+wd15+wd16+wd17+wd18
* Average marginal effect from TAXEXTRA when CONV=1:
di avg_marg
drop s1 w1 w2 w3 w4 w7 w8 w9 w10 w12 w13 w14 w15 w16 w17 w18 d1 d2 d3 d4 d7 d8 d9 d10 d12 d13 d14 d15 d16 d17 d18
drop wd1 wd2 wd3 wd4 wd7 wd8 wd9 wd10 wd12 wd13 wd14 wd15 wd16 wd17 wd18 avg_marg
