

*设定区域码
encode Region, gen(Area)
encode  ccode, gen(countrycode)

*定义变量
gen lnGDPpcratio = log(gdppcratio)
gen lndistcap = log(distcap)

******table 1********
xi: reg IFDI BITsigned  i.year i.Area 
est store reg1 

xi: reg IFDI gdpratio tradegdpratio laborcostratio lndistcap comlang_off /// 
             rta enrsecondary highway BITsigned i.year i.Area 
est store reg2

    
 
xi: reg IFDI BITenforced  i.year i.Area 
est store reg3


xi: reg IFDI gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITenforced i.year i.Area
est store reg4

xi: reg IFDI  BITsigned BITenforced  i.year i.Area 
est store reg5


xi: reg IFDI gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITsigned BITenforced  i.year i.Area 
est store reg6


esttab reg1 reg2 reg3 reg4 reg5 reg6 ///
       using "Table1.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )
		
********table 2****** 
xi: reg IFDI  Absolute   i.year i.Area 
est store reg7
						
xi: reg IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Absolute   i.year i.Area
est store reg8


xi: reg IFDI  Relative   i.year i.Area 
						
est store reg9
						
xi: reg IFDI   gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Relative   i.year i.Area 
est store reg10						
					
xi: reg IFDI  DS   i.year i.Area 
est store reg11		

xi: reg IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway DS    i.year i.Area
est store reg12	
					
xi: reg IFDI Absolute Relative DS   i.year i.Area 
est store reg13	

xi: reg IFDI gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Absolute Relative DS    i.year i.Area
est store reg14

esttab reg7 reg8 reg9 reg10 reg11 reg12 reg13 reg14 ///
       using "Table2.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )
	   
***** Table 3 WTO ************* 
  


**yeardummy interacation
gen year2001dummy = 0
replace  year2001dummy = 1 if year >= 2001

capture drop bityear
gen bityear = BITsigned*year2001dummy
xi:reg IFDI bityear gdpratio tradegdp lndistcap  /// 
            laborcostratio comlang_off enrsecondary highway rta i.year i.Area
est store reg25	

capture drop enforcementyear
gen enforcementyear = BITenforced*year2001dummy
xi:reg IFDI enforcementyear gdpratio tradegdp lndistcap  /// 
            laborcostratio comlang_off enrsecondary highway rta i.year i.Area
est store reg26	

xi:reg IFDI bityear enforcementyear gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway  i.year i.Area
est store reg27

capture drop absoluteyear
gen absoluteyear = Absolute*year2001dummy
xi:reg IFDI absoluteyear  gdpratio tradegdp lndistcap  /// 
            laborcostratio comlang_off enrsecondary highway rta i.year i.Area
est store reg28

capture drop relativeyear
gen relativeyear = Relative*year2001dummy	
xi:reg IFDI relativeyear  gdpratio tradegdp lndistcap  /// 
            laborcostratio comlang_off enrsecondary highway rta i.year i.Area
est store reg29

capture drop dsyear			
gen dsyear = DS*year2001dummy			
xi:reg IFDI dsyear  gdpratio tradegdp lndistcap  /// 
            laborcostratio comlang_off enrsecondary highway rta i.year i.Area
est store reg30

xi:reg IFDI absoluteyear relativeyear dsyear  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway  i.year i.Area
			  
est store reg31

esttab reg25 reg26 reg27 reg28 reg29 reg30 reg31 ///
       using "Table3.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* ) scalars(r2 F N )
	   	   
**Table 4 GMM
xtset group year

ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(BITsigned = l.BITsigned l2.BITsigned), robust
est store GMM_1

ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(BITenforced = l.BITenforced l2.BITenforced), robust
est store GMM_2


ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(BITsigned BITenforced = l.BITsigned l2.BITsigned l.BITenforced l2.BITenforced), robust
est store GMM_3


  
ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(Absolute = l.Absolute l2.Absolute ), robust
est store GMM_4


ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(Relative = l.Relative l2.Relative), robust
est store GMM_5

ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(DS = l.DS l2.DS), robust
est store GMM_6

ivregress gmm IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(Absolute Relative DS =l.Absolute l2.Absolute l.Relative l2.Relative l.DS l2.DS), robust
est store GMM_7



esttab GMM_1 GMM_2 GMM_3 GMM_4 GMM_5 GMM_6 GMM_7 ///
       using "Table4.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )
	   	   	   
	   
*********Robustnesschecks*****


**Supplmental Material I 2SLS

xtset group year
ivregress 2sls IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(BITsigned = l.BITsigned ), small
est store IV_1

ivregress 2sls IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(BITenforced = l.BITenforced ), small
est store IV_2
  
ivregress 2sls IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(Absolute = l.Absolute ), small
est store IV_3


ivregress 2sls  IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(Relative = l.Relative ), small
est store IV_4


ivregress 2sls IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway i.year i.Area ///
						(DS = l.DS ), small
est store IV_5


esttab IV_1 IV_2 IV_3 IV_4 IV_5 ///
       using "Table5.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )



**Supplmental Material II
	   
**No outliers 
preserve
sum IFDI, detail 
local temp1 = r(p1)
local temp2 = r(p99)
keep if IFDI  > `temp1' & IFDI  < `temp2'
xi: reg IFDI gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITsigned i.year i.Area
est store drop_1
restore

preserve
sum IFDI, detail 
local temp1 = r(p1)
local temp2 = r(p99)
keep if IFDI  > `temp1' & IFDI  < `temp2'
xi: reg IFDI gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITenforced i.year i.Area
est store drop_2
restore
  
preserve
sum IFDI, detail 
local temp1 = r(p1)
local temp2 = r(p99)
keep if IFDI  > `temp1' & IFDI  < `temp2'
xi: reg IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Absolute  i.year i.Area
est store drop_3
restore


preserve
sum IFDI, detail 
local temp1 = r(p1)
local temp2 = r(p99)
keep if IFDI  > `temp1' & IFDI  < `temp2'
xi: reg IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Relative    i.year i.Area
est store drop_4
restore


preserve
sum IFDI, detail 
local temp1 = r(p1)
local temp2 = r(p99)
keep if IFDI  > `temp1' & IFDI  < `temp2'
xi: reg IFDI  gdpratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway DS  i.year i.Area
est store drop_5
restore

esttab drop_1 drop_2 drop_3 drop_4 drop_5 ///
       using "Table6.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )

**Supplemental Material III Growthratio 


xi: reg IFDI  growthratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITsigned i.year i.Area
est store replace_1

xi: reg IFDI growthratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITenforced i.year i.Area
est store replace_2
  
xi: reg IFDI  growthratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Absolute  i.year i.Area
est store replace_3


xi: reg IFDI  growthratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Relative  i.year i.Area
est store replace_4


xi: reg IFDI  growthratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway DS  i.year i.Area
est store replace_5


esttab replace_1 replace_2 replace_3 replace_4 replace_5 ///
       using "Table7.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )

	   
   
	   **Supplemntal Material IV GDP per capita rratio


xi: reg IFDI gdppcratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITsigned  i.year i.Area
est store replace_7

xi: reg IFDI gdppcratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway BITenforced i.year i.Area
est store replace_8
  
xi: reg IFDI  gdppcratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Absolute  i.year i.Area
est store replace_9


xi: reg IFDI  gdppcratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway Relative i.year i.Area
est store replace_10


xi: reg IFDI  gdppcratio tradegdpratio laborcostratio lndistcap comlang_off rta  /// 
              enrsecondary highway DS  i.year i.Area
est store replace_11


esttab replace_7 replace_8 replace_9 replace_10 replace_11 ///
       using "Table8.rtf", rtf replace nogaps star(* .1 ** 0.05 *** 0.01) ///
       drop(*Area* *year*) scalars(r2 F N )
