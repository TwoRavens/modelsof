yy1 is case id
x42001 is the weight


* consider people only who bought vehicles in the year of the survey.


/* LINES OF CREDIT USED FOR CARS */
lines of credit
x1106 x1117 and x1128 are lines of credit. check to see if they are for cars.
original: 
10 is for car, including repossessed cars.
24 is for truck/jeep/utility vehicle.
93 is vehicle repair/upkeep.
10/24 collapsed into 3 for the public use data.

x1111 x1122 and x1133 are the interest rates on the loan.


/* First line of credit */
* Amount owed
reg x7141 [aw=x42001] if x7141>0 & x1106 == 10
qreg x7141 [aw=x42001] if x7141>0 & x1106 == 10,q(50)

* Interest rate
reg x1111 [aw=x42001] if x7141>0 & x1106 == 10
qreg x1111 [aw=x42001] if x7141>0 & x1106 == 10, q(50)


/* Second line of credit */
* Amount owed
reg x7142 [aw=x42001] if x7142>0 & x1117 == 10


* Interest rate
reg x1122 [aw=x42001] if x7142>0 & x1117 == 10


/* Third line of credit */
* Amount owed
reg x7143 [aw=x42001] if x7143>0 & x1128 == 10

* Interest rate
reg x1133 [aw=x42001] if x7143>0 & x1128 == 10



/* VEHICLES LEASED */
* Do you lease?
tab x2101

* We can't do anything with the lease payment because we don't know the APRs and can't calculate them.



/* VEHICLES OWNED */

do you own vehicles
x2201
x2206: is more money owed?

* Do you own vehicles?
tab x2201 [aw=42001]

* Do you have a loan, for people who bought a used car in 2007 or bought a new car of model year 2007 or 2008
foreach q in 2206 2306 2406 7155 {
gen HaveLoan`q' = cond(x`q'==1,1,0)
replace HaveLoan`q' = 0 if x`q' == 0
}

reg HaveLoan2206 [aw=x42001] if (x7543==2&x7540==2007)|(x7543==1&(x2205==2007|x2205==2008))
reg HaveLoan2306 [aw=x42001] if x7539==2007
reg HaveLoan2406 [aw=x42001] if x7538==2007
reg HaveLoan7155 [aw=x42001] if x7154==2007

* New:
reg HaveLoan2206 [aw=x42001] if (x2205==2007|x2205==2008) & x7543==1
* Used
reg HaveLoan2206 [aw=x42001] if x7540==2007 & x7543==2


** How much was borrowed?



/* What is the interest rate? */
replace x2219 = . if x2219==0
replace x2219 = 0 if x2219==-1
reg x2219 [aw=x42001] if (x7543==2&x7540==2007)|(x7543==1&(x2205==2007|x2205==2008))
qreg x2219 [aw=x42001] if (x7543==2&x7540==2007)|(x7543==1&(x2205==2007|x2205==2008)), q(50)

