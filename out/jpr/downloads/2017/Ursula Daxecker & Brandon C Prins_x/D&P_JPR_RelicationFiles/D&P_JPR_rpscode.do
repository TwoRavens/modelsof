*RPS Code*
*RPS Values for Tables II-IV*
*Using D&P_JPR_Data.do*


**in sample models**

*Table 2:Model 2 Pooled* 
 
 *Main model pooled *
quietly nbreg gedconfeventnew   l.allincidents   onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if year<2011, cluster(ucdpid)
 prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
 **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 

 *Table 2: Model 2 Pooled without piracy*
 *Pooled model without piracy incidents as right hand side variable*
 quietly nbreg gedconfeventnew     onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if year<2011, cluster(ucdpid)
 prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))

  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 
 *Main model with FE*
 nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
  prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 
 *Main model with FE and withoutu piracy as right hand side variable*
 nbreg gedconfeventnew  i.ccode    onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year<2011
  prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 
 
 
 
 **out of sample models -- same as models above but just using >2011**
 
 *Table 3: Model 2 Pooled*
 *Main model pooled *
quietly nbreg gedconfeventnew   l.allincidents   onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if year>2010, cluster(ucdpid)
 prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))

  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 3: Model 2 Pooled without piracy*
 *Pooled model without piracy incidents as right hand side variable*
 quietly nbreg gedconfeventnew     onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if year>2010, cluster(ucdpid)
 prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 3: Model 1*
 *Main model with FE*
 nbreg gedconfeventnew  i.ccode  l.allincidents   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year>2010
  prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 3: Model 1 without Piracy*
  *Main model with FE and withoutu piracy as right hand side variable*
 nbreg gedconfeventnew  i.ccode    onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year>2010
  prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 4: Model 4 Pooled*
  **run pooled model with and without 6 month MA piracy**
quietly nbreg gedconfeventnew   allincidents6movavg   onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if year>2010, cluster(ucdpid)
 prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 4: Model 4 Pooled without Piracy*
 **run pooled model without 6 month MA piracy**
quietly nbreg gedconfeventnew    onshoreoil diamond    l12.rpe_gdpimp l12.lnpopWB l.gedconfeventnew   i.year if year>2010, cluster(ucdpid)
 prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 4: Model 3*
   **run FE model with and without 6 month MA piracy**

 nbreg gedconfeventnew  i.ccode  allincidents6movavg   onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year>2010
  prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
 
 *Table 4: Model 3 FE without Piracy*
  nbreg gedconfeventnew  i.ccode    onshoreoil diamond   l12.rpe_gdp l12.lnpopWB l.gedconfeventnew   i.year       if year>2010
  prcounts psn if e(sample), plot  max(14)
 list psnval psnobeq psnpreq psnoble psnprle in 1/14
 graph twoway connected psnoble psnprle psnval, legend(row(1) position(6))
 
  **recode Y into dummy categories for Brier Score (0)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 1) (1/max=0)
 **use Brier ado**
 brier dummy psnpr0
 gen brier0 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (1)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0 = 0) (1 =1) (2/max=0)
 brier dummy psnpr1
 gen brier1 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (2)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/1 = 0) (2=1) (3/max=0)
 brier dummy psnpr2
 gen brier2 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (3)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/2 = 0) (3=1) (4/max=0)
 brier dummy psnpr3
 gen brier3 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (4)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/3 = 0) (4=1) (5/max=0)
 brier dummy psnpr4
 gen brier4 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (5)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/4 = 0) (5=1) (6/max=0)
 brier dummy psnpr5
 gen brier5 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (6)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/5 = 0) (6=1) (7/max=0)
 brier dummy psnpr6
 gen brier6 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (7)**
 gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/6 = 0) (7=1) (8/max=0)
 brier dummy psnpr7
 gen brier7 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (8)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/7 = 0) (8=1) (9/max=0)
 brier dummy psnpr8
 gen brier8 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (9)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/8 = 0) (9=1) (10/max=0)
 brier dummy psnpr9
 gen brier9 =r(brier)
 drop dummy
 **recode Y into dummy categories for Brier Score (10)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/9 = 0) (10=1) (11/max=0)
 brier dummy psnpr10
 gen brier10 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (11)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/10 = 0) (11=1) (12/max=0)
 brier dummy psnpr11
 gen brier11 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (12)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/11 = 0) (12=1) (13/max=0)
 brier dummy psnpr12
 gen brier12 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (13)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/12 = 0) (13=1) (14/max=0)
 brier dummy psnpr13
 gen brier13 =r(brier)
 drop dummy
**recode Y into dummy categories for Brier Score (14)**
gen dummy = gedconfeventnew if e(sample)
 recode dummy (0/13 = 0) (14=1) (15/max=0)
 brier dummy psnpr14
 gen brier14 =r(brier)
 drop dummy
 
 
 gen rps = (brier0+brier1+brier2+brier3+brier4+brier5+brier6+brier7+brier8+brier9+brier10+brier11+brier12+brier13+brier14)/14
 display rps
 
 drop psnrate psnrate psnpr0 psnpr1 psnpr2 psnpr3 psnpr4 psnpr5 psnpr6
 drop psnpr7 psnpr8 psnpr9 psnpr10 psnpr11 psnpr12 psnpr13 psnpr14  
 drop  psncu0
 drop psncu1 psncu2 psncu3 psncu4 psncu5 psncu6 psncu7 psncu8 psncu9 psncu10 psncu11
 drop psncu12 psncu13 psncu14 
 drop psnprgt psnval psnobeq psnpreq psnoble psnprle
 drop brier0 brier1 brier2 brier3 brier4 brier5 brier6 brier7 brier8 brier9 brier10 
 drop brier11 brier12 brier13 brier14 rps
