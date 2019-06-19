clear
set more off
set matsize 800
infile coll hope male black asian year state using reg.raw

xi:reg coll hope male black asian i.year i.state,r cluster(state)
gen styr=1000*state+year
xi:reg coll hope male black asian i.year i.state,r cluster(styr)

/* create indicator for the state where policy changed (Georgia==1)*/
g byte ga=state==58
matrix b=e(b) 
matrix b=b[1,1]

quietly {
/* predict residuals from regression */
predict eta, res 
replace eta=eta+_b[hope]*hope

/* create d tilde variable*/
bysort year: egen djtga=mean(hope) if ga==1
bysort year: egen sdjt=sum(djtga) 
bysort year: egen ndjt=count(djtga) 
gen djt=sdjt/ndjt
bysort state: egen meandjt=mean(djt) 
g dtil=djt-meandjt

/* obtain difference in differences coefficient*/
reg eta dtil if ga==1,noc
matrix alpha=e(b)
	
/* simulations*/
sum state 
g k=r(min)
g stmax=r(max)
while k<=stmax {
		capture {
		reg eta dtil if state==k&ga!=1, noc
		matrix alpha=alpha\e(b)
	}
		replace k=k+1
	} 
matrix asim=alpha[2...,1]
matrix alpha=alpha[1,1]

/* Confidence intervals */
svmat alpha 
svmat asim

g byte ind=1
bysort ind: egen alpha=sum(alpha1)
drop alpha1 ind eta djtga sdjt ndjt djt meandjt dtil k stmax
g ci=alpha-asim
}

/* form confidence intervals */
local numst=42
local i025=floor(0.025*(`numst'-1))
local i975=ceil(0.975*(`numst'-1))
local i05=floor(0.050*(`numst'-1))
local i95=ceil(0.950*(`numst'-1))

quietly sum alpha
display as text "Difference in Differences coefficient=" as result _newline(2) r(mean)

sort asim
quietly sum ci if _n==`i025'|_n==`i975'
display as text "95% Confidence interval=" as result _newline(2) r(min) _col(15) r(max)
quietly sum ci if _n==`i05'|_n==`i95' 
display as text "90% Confidence interval=" as result _newline(2) r(min) _col(15) r(max)

r(0.025*(`numst'-1))
local i975=ceil(0.975*(`numst'-1))
local i05=floor(0.050*(`numst'-1))
local i95=ceil(0.950*(`numst'-1))

quietly sum alpha
display as text "Difference in Differences coefficient=" as result _newline(