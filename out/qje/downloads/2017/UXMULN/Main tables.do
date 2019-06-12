

clear *

cd "~/Dropbox/Projects/The Demand for Status/Final_data_QJE"


set more off

/************************

Table 1

************************/


clear*

use Datasets/Experiment1.dta, clear


*******************************

prog define Store, rclass
args column variables y
 {
	local row=1
	foreach x in `variables'  {
		cap mat TABLE1[`row',`column']=_b[`x'] 
		cap mat TABLE1[`row'+1,`column']=_se[`x']
			local ++row
			local ++row		
			local ++row				
	}
	
		mat TABLE1[10,`column']=e(N)
		mat TABLE1[11,`column']=e(r2)
						
		reg decision if platinum==0, robust

		mat TABLE1[5,`column']=_b[_cons]
		mat TABLE1[6,`column']=_se[_cons]		
	

}
end
*******************************

mat TABLE1=J(24,6,.)

keep if exclude==0

reg decision platinum, robust
Store 1 "platinum"


reg decision platinum i.strata caller_* credit_limit female muslim jakarta age, robust
Store 2 "platinum"

* For p-values based on permutation test, run permutation_pvalues.do
 

mat li TABLE1






/************************

Table 2

************************/


/* Note: the NDA with the partner bank does not allow us to post the transaction data. Therefore, it is not possible to replicate column 2 of Table A.1.

clear*

use Datasets/Transactions.dta, clear


*******************************

prog define Store, rclass
args Y column 
 {
	local row=1

	reg `Y' if C20000000==1, robust 	
	mat TABLE2[10,`column']=_b[_cons]
	mat TABLE2[11,`column']=_se[_cons]

	reg `Y' C20000000 C30000000 C40000000 C50000000 , robust	noc
	
	lincom C30000000-C20000000
	mat TABLE2[1,`column']=r(estimate)
	mat TABLE2[2,`column']=r(se)

	lincom C40000000-C30000000
	mat TABLE2[4,`column']=r(estimate)
	mat TABLE2[5,`column']=r(se)

	lincom C50000000-C40000000
	mat TABLE2[7,`column']=r(estimate)
	mat TABLE2[8,`column']=r(se)


	test (C40000000-C30000000)=(C30000000-C20000000)
		mat TABLE2[20,`column']=r(p)	


	test (C50000000-C40000000)=(C30000000-C20000000)
		mat TABLE2[22,`column']=r(p)

	test (C40000000-C30000000)=(C50000000-C40000000)
		mat TABLE2[24,`column']=r(p)


	
	
	
	reg `Y' if C20000000==1, robust 	
	mat TABLE2[14,`column']=e(N)

	reg `Y' if C30000000==1, robust 	
	mat TABLE2[15,`column']=e(N)	
	
	reg `Y' if C40000000==1, robust 	
	mat TABLE2[16,`column']=e(N)	

	reg `Y' if C50000000==1, robust 	
	mat TABLE2[17,`column']=e(N)	
	
	
	reg `Y' C20000000 C30000000 C40000000 C50000000 income female muslim jakarta age , robust	noc

	lincom C30000000-C20000000
	mat TABLE2[1,`column'+1]=r(estimate)
	mat TABLE2[2,`column'+1]=r(se)

	lincom C40000000-C30000000
	mat TABLE2[4,`column'+1]=r(estimate)
	mat TABLE2[5,`column'+1]=r(se)

	lincom C50000000-C40000000
	mat TABLE2[7,`column'+1]=r(estimate)
	mat TABLE2[8,`column'+1]=r(se)


	test (C40000000-C30000000)=(C30000000-C20000000)
		mat TABLE2[20,`column'+1]=r(p)	


	test (C50000000-C40000000)=(C30000000-C20000000)
		mat TABLE2[22,`column'+1]=r(p)

	test (C40000000-C30000000)=(C50000000-C40000000)
		mat TABLE2[24,`column'+1]=r(p)	
	
	
	reg `Y' if C20000000==1, robust 	
	mat TABLE2[14,`column'+1]=e(N)

	reg `Y' if C30000000==1, robust 	
	mat TABLE2[15,`column'+1]=e(N)	
	
	reg `Y' if C40000000==1, robust 	
	mat TABLE2[16,`column'+1]=e(N)	

	reg `Y' if C50000000==1, robust 	
	mat TABLE2[17,`column'+1]=e(N)	
	


}
end
*******************************


mat TABLE2=J(24,10,.)


Store visible 1

Store online 4

Store retail 7

mat li TABLE2


*/


/************************

Table 3

************************/


clear*

use Datasets/Experiment2.dta, clear

*******************************

prog define Store, rclass
args column variables 
 {
	local row=1
	foreach x in `variables'  {
		cap mat TABLE3[`row',`column']=_b[`x'] 
		cap mat TABLE3[`row'+1,`column']=_se[`x']
			local ++row
			local ++row		
			local ++row				
	}
	
		mat TABLE3[7,`column']=e(N)
		mat TABLE3[8,`column']=e(r2)
		
				
		reg Y if T==0, robust

		mat TABLE3[4,`column']=_b[_cons]
		mat TABLE3[5,`column']=_se[_cons]		
	

}
end
*******************************

mat TABLE3=J(24,3,.)
 
keep if exclude==0

reg Y T, robust
Store 1 T

reg Y T  credit_limit income age  female muslim jakarta, robust
Store 2 T

* For p-values based on permutation test, run permutation_pvalues.do


mat li TABLE3


/************************

Table 4

************************/

use Datasets/mTurk.dta, clear

mat TABLE4=J(17,10,.)


regress rose  self,  r
mat TABLE4[1,1]=_b[self]
mat TABLE4[2,1]=_se[self]

mat TABLE4[7,1]=e(N)


regress rose  self if self==0,  r
mat TABLE4[4,1]=_b[_cons]
mat TABLE4[5,1]=_se[_cons]

forvalues x=1(1)5 {


regress demand_armani_offer`x'  self ,  r
mat TABLE4[1,`x'+2]=_b[self]
mat TABLE4[2,`x'+2]=_se[self]

mat TABLE4[7,`x'+2]=e(N)


regress demand_armani_offer`x'  if self==0 ,  r
mat TABLE4[4,`x'+2]=_b[_cons]
mat TABLE4[5,`x'+2]=_se[_cons]


}


regress rose  self  race_* female age married i.education i.income ,  r
mat TABLE4[11,1]=_b[self]
mat TABLE4[12,1]=_se[self]

mat TABLE4[17,1]=e(N)


forvalues x=1(1)5 {

regress demand_armani_offer`x'  self race_* female age married i.education i.income ,  r
mat TABLE4[11,`x'+2]=_b[self]
mat TABLE4[12,`x'+2]=_se[self]

mat TABLE4[17,`x'+2]=e(N)


regress demand_armani_offer`x'  if self==0 ,  r
mat TABLE4[14,`x'+2]=_b[_cons]
mat TABLE4[15,`x'+2]=_se[_cons]


}

* For p-values based on permutation test, run permutation_pvalues.do


mat li TABLE4

