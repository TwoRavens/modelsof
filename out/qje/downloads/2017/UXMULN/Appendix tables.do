

clear *

cap cd "~/Dropbox/Projects/The Demand for Status/Final_data_QJE"
set more off



/************************

Table A.1

************************/



*******************************

prog define Store, rclass
args row col y
 {
 
 	cap reg `y' , robust
 	
	cap mat TABLE_A1[`row',`col']=_b[_cons]
	cap mat TABLE_A1[`row'+1,`col']=_se[_cons]
			
}
end
*******************************

use Datasets/Experiment1.dta, clear


keep if exclude==0

replace credit_limit=credit_limit/1000000
replace income=income/1000000

gen plat=0

mat TABLE_A1=J(30,8,.)

qreg income
mat TABLE_A1[1,1]=_b[_cons]
mat TABLE_A1[2,1]=_se[_cons]



local row=4
foreach x in credit_limit  age  female muslim jakarta  plat  {

Store `row' 1 `x'


local ++row
local ++row
local ++row
 
}


/* Note: the NDA with the partner bank does not allow us to post the transaction data. Therefore, it is not possible to replicate column 2 of Table A.1.

use Datasets/Transactions.dta, clear

replace income=income/1000000
replace credit_limit=credit_limit/1000000


qreg income
mat TABLE_A1[1,2]=_b[_cons]
mat TABLE_A1[2,2]=_se[_cons]

local row=4
foreach x in credit_limit  age  female muslim jakarta  plat  {

Store `row' 2 `x'


local ++row
local ++row
local ++row
 
}


*/


use Datasets/Experiment2.dta, clear

keep if exclude==0

replace income=income/1000000
replace credit_limit=credit_limit/1000000
gen plat=1



qreg income
mat TABLE_A1[1,3]=_b[_cons]
mat TABLE_A1[2,3]=_se[_cons]

local row=4
foreach x in credit_limit  age  female muslim jakarta  plat  {

Store `row' 3 `x'


local ++row
local ++row
local ++row
 
}


use Datasets/Experiment3.dta, clear

keep if exclude==0



qreg income
mat TABLE_A1[1,4]=_b[_cons]
mat TABLE_A1[2,4]=_se[_cons]



local row=4
foreach x in credit_limit  age  female muslim jakarta  platinum  {

Store `row' 4 `x'


local ++row
local ++row
local ++row
 
}



mat li TABLE_A1




/************************

Table A.2

************************/

use Datasets/Experiment1.dta, clear

clear programs
*******************************

prog define Store, rclass
args row y
 {
 
 	cap reg `y' platinum Gold , robust noc
 	
	cap mat TABLE_A2[`row',1]=_b[Gold]
	cap mat TABLE_A2[`row'+1,1]=_se[Gold]

	cap mat TABLE_A2[`row',2]=_b[platinum]
	cap mat TABLE_A2[`row'+1,2]=_se[platinum]

	test Gold=platinum
	
	cap mat TABLE_A2[`row',3]=r(p)
			
}
end
*******************************


gen Gold= 1-platinum

keep if exclude==0

replace credit_limit=credit_limit/1000000
replace income=income/1000000

mat TABLE_A2=J(30,8,.)

qreg income if Gold==1
	mat TABLE_A2[1,1]=_b[_cons]
	mat TABLE_A2[2,1]=_se[_cons]

	mat TABLE_A2[22,1]=e(N)



qreg income if platinum==1
	mat TABLE_A2[1,2]=_b[_cons]
	mat TABLE_A2[2,2]=_se[_cons]

median income, by(platinum)
	mat TABLE_A2[1,3]=r(p)

	mat TABLE_A2[22,2]=e(N)


local row=4
foreach x in  credit_limit  age  female muslim jakarta    {

Store `row' `x'


local ++row
local ++row
local ++row
 
}


mat li TABLE_A2




/************************

Table A.3

************************/


clear *
use Datasets/Experiment1.dta, clear

keep if exclude==0


*******************************

prog define Store, rclass
args col 
 {

gen platinum_X1=platinum*X1
gen platinum_X0=platinum*(1-X1)

reg decision platinum_X1 platinum_X0 X1    i.strata caller_* credit_limit female muslim jakarta age  , robust
mat TABLE_A3[1,`col']=_b[platinum_X1]
mat TABLE_A3[2,`col']=_se[platinum_X1]

mat TABLE_A3[4,`col']=_b[platinum_X0]
mat TABLE_A3[5,`col']=_se[platinum_X0]


summ X1
mat TABLE_A3[9,`col']=r(mean)

mat TABLE_A3[11,`col']=e(N)

mat TABLE_A3[13,`col']=e(r2)

drop *X*

}
end
*******************************

mat TABLE_A3=J(13,10,.)


* Income cutoff=300
gen X1=inlist(strata,3,4,5,6)
Store 1

* Income cutoff=500
gen X1=inlist(strata,5,6)
Store 2

* Female
gen X1=female==1
Store 3

* Age
xtile age2= age, nq(2)
gen X1=age2==2
Store 4

mat li TABLE_A3



/************************

Table A.4

************************/


/* Note: the NDA with the partner bank does not allow us to post the transaction data. Therefore, it is not possible to replicate Table A.4.

clear*

use Datasets/Transactions.dta, clear

clear programs
*******************************

prog define Store, rclass
args column
 {
		cap mat TABLE_A4[1,`column']=_b[platinum] 
		cap mat TABLE_A4[2,`column']=_se[platinum]
	
		cap mat TABLE_A4[4,`column']=_b[credit] 
		cap mat TABLE_A4[5,`column']=_se[credit]
	
}
end
*******************************

gen T=credit>= 40000000

replace credit=credit/1000000

mat TABLE_A4=J(5,10,.)

ivreg visible (platinum=T) credit  , robust first
Store 1

ivreg visible  (platinum=T) credit income female muslim jakarta age , robust first
Store 2

ivreg online  (platinum=T) credit  , robust
Store 4

ivreg online  (platinum=T) credit income female muslim jakarta age , robust
Store 5

ivreg retail  (platinum=T) credit  , robust
Store 7

ivreg retail  (platinum=T) credit income female muslim jakarta age , robust
Store 8


mat li TABLE_A4

*/


/************************

Table A.5

************************/

clear*

use Datasets/Experiment2.dta, clear

keep if exclude==0

replace credit_limit= credit/1000000
replace income=income/1000000
gen plat=1


gen T1=T

gen T0=1-T1

clear programs
*******************************

prog define Store, rclass
args row y
 {
 
 	cap reg `y' T0 T1 , robust noc
 	
	cap mat TABLE1[`row',1]=_b[T0]
	cap mat TABLE1[`row'+1,1]=_se[T0]

	cap mat TABLE1[`row',2]=_b[T1]
	cap mat TABLE1[`row'+1,2]=_se[T1]

	test T0=T1
	
	cap mat TABLE1[`row',3]=r(p)
			
}
end
*******************************

mat TABLE1=J(19,8,.)


qreg income if T0==1
	mat TABLE1[1,1]=_b[_cons]
	mat TABLE1[2,1]=_se[_cons]

	mat TABLE1[19,1]=e(N)



qreg income if T1==1
	mat TABLE1[1,2]=_b[_cons]
	mat TABLE1[2,2]=_se[_cons]

	mat TABLE1[19,2]=e(N)


median income, by(T0)
	mat TABLE1[1,3]=r(p)


local row=4
foreach x in credit_limit  age  female muslim jakarta    {

Store `row' `x'


local ++row
local ++row
local ++row
 
}


mat li TABLE1











/************************

Table A.6

************************/


use Datasets/Experiment3.dta, clear


keep if exclude==0

clear programs
*******************************

prog define Store, rclass
args row y
 {
 
 	cap reg `y' plat_ntrl plat_pstv upgr_ntrl upgr_pstv  , robust noc
 	
	cap mat TABLE_A6[`row',1]=_b[plat_ntrl]
	cap mat TABLE_A6[`row'+1,1]=_se[plat_ntrl]

	cap mat TABLE_A6[`row',2]=_b[plat_pstv]
	cap mat TABLE_A6[`row'+1,2]=_se[plat_pstv]

	cap mat TABLE_A6[`row',4]=_b[upgr_ntrl]
	cap mat TABLE_A6[`row'+1,4]=_se[upgr_ntrl]

	cap mat TABLE_A6[`row',5]=_b[upgr_pstv]
	cap mat TABLE_A6[`row'+1,5]=_se[upgr_pstv]

	test plat_ntrl=plat_pstv=upgr_ntrl=upgr_pstv 
	
	cap mat TABLE_A6[`row',7]=r(p)
			
}
end
*******************************

mat TABLE_A6=J(30,8,.)


gen group=1 if plat_ntrl==1
replace group=2 if plat_pstv ==1
replace group=3 if upgr_ntrl ==1
replace group=4 if upgr_pstv ==1


qreg income if group==1
	mat TABLE_A6[1,1]=_b[_cons]
	mat TABLE_A6[2,1]=_se[_cons]

	mat TABLE_A6[19,1]=e(N)



qreg income if group==2
	mat TABLE_A6[1,2]=_b[_cons]
	mat TABLE_A6[2,2]=_se[_cons]

	mat TABLE_A6[19,2]=e(N)




qreg income if group==3
	mat TABLE_A6[1,4]=_b[_cons]
	mat TABLE_A6[2,4]=_se[_cons]

	mat TABLE_A6[19,4]=e(N)



qreg income if group==4
	mat TABLE_A6[1,5]=_b[_cons]
	mat TABLE_A6[2,5]=_se[_cons]

	mat TABLE_A6[19,5]=e(N)


median income, by(group)
	mat TABLE_A6[1,7]=r(p)

replace age=age/12 if age>100

local row=4
foreach x in  credit_limit  age  female muslim jakarta    {

Store `row' `x'


local ++row
local ++row
local ++row
 
}

mat li TABLE_A6







/************************

Table A7

************************/


use Datasets/Experiment3.dta, clear


clear programs
*******************************

prog define Store, rclass
args column x 
 {
	local row=1

		cap mat TABLE_A7[1,`column']=_b[`x'] 
		cap mat TABLE_A7[2,`column']=_se[`x']


		cap mat TABLE_A7[4,`column']=_b[_cons] 
		cap mat TABLE_A7[5,`column']=_se[_cons]
	


		mat TABLE_A7[7,`column']=e(N)
		mat TABLE_A7[8,`column']=e(r2)
		
}
end
*******************************


mat TABLE_A7=J(11,5,.)


reg takeup plat_pstv if plat_ntrl+plat_pstv==1, robust
Store 1 plat_pstv

reg takeup plat_pstv income credit_limit  age  female muslim jakarta caller_* if plat_ntrl+plat_pstv==1, robust
Store 2 plat_pstv


reg takeup upgr_pstv if upgr_ntrl + upgr_pstv ==1, robust
Store 4 upgr_pstv


reg takeup upgr_pstv  income credit_limit  age  female muslim jakarta caller_* if upgr_ntrl + upgr_pstv ==1, robust
Store 5 upgr_pstv



mat li TABLE_A7








