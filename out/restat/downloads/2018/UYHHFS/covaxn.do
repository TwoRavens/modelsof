
global co=$i

capture program drop matt
program define matt  /*merges residuals*/
	local j=$from
	use  err_${b}_`j'
	local k=`j'+1
	while `k'<=$to {
		merge pnr using  err_${b}_`k'
		drop _merge 
		sort pnr
		local k=`k'+1
	}
	save  matres,replace
end






set mat 800
set more off
capture program drop cprod
capture program drop cdum
capture program drop covax
matt
use  matres
capture quietly mvencode res*, mv(0)
capture quietly mvencode ageA*, mv(0)
capture quietly mvencode ageC*, mv(0)


sort pnr
quietly compress

program define cprod /*creates cross-products of residuals*/
	local i=$from 
	while `i'<=$to {
		local j=`i'
		while `j'<=$to {
			gen res`i'`j'=res`i'*res`j'
			gen ageA`i'`j'=(ageA`i')*(ageA`j')
			gen ageC`i'`j'=(ageC`i')*(ageC`j')
			local j=`j'+1
		}
		gen d`i'=res`i'~=0
		drop res`i' 
		quietly compress
		local i=`i'+1
	}
end
cprod



program define cdum /*cross-products of dummies*/
	local i=$from
	while `i'<=$to {
		local j=`i'
		while `j'<=$to {
			gen d`i'`j'=d`i'*d`j'
			local j=`j'+1
		}
		local i=`i'+1
	}
end
cdum

program define covax /*calculates covariances*/
	local i=$from
	while `i'<=$to {
		egen etaA`i'=sum(ageA`i')
		egen etaC`i'=sum(ageC`i')
		egen do`i'=sum(d`i')
		drop ageA`i'  ageC`i'  d`i' 
		local i=`i'+1
	}
	local i=$from
	while `i'<=$to {
		local j=`i'
		while `j'<=$to {
			egen s`i'`j'=sum(res`i'`j')
			egen t`i'`j'=sum(d`i'`j')
			egen xaA`i'`j'=sum(ageA`i'`j')
			egen xaC`i'`j'=sum(ageC`i'`j')
			gen m`i'`j'=s`i'`j'/t`i'`j'
			gen agexA`i'`j' = xaA`i'`j'/t`i'`j'
			gen agexC`i'`j' = xaC`i'`j'/t`i'`j'
			quietly gen dev_${b}${b}_${co}${co}_`i'`j'=(m`i'`j'-res`i'`j')/(t`i'`j') if res`i'`j'~=0
			quietly recode dev_${b}${b}_${co}${co}_`i'`j' .=0
			drop res`i'`j'  s`i'`j' d`i'`j'  xaA`i'`j'  xaC`i'`j'  
			gen yt`i'`j'=`i'
			gen ys`i'`j'=`j'
			gen agetA`i'`j'=etaA`i'/do`i'
			gen agesA`i'`j'=etaA`j'/do`j'
			gen agetC`i'`j'=etaC`i'/do`i'
			gen agesC`i'`j'=etaC`j'/do`j'
			local j=`j'+1
		}
		drop etaA`i'  etaC`i'  do`i'
		local i=`i'+1
	}
	sort pnr
end
covax

save  tempo,replace
use  tempo
matrix accum fm=dev*  ,noc
mat varia=vecdiag(fm)            
mat varia=varia'
mat coln varia=varia
svmat varia, n(col)
keep varia
keep if varia~=.
gen stdev=sqrt(varia)
save  varia,replace
drop _all
svmat fm,n(col)
save  fm_${b}_${b}_${co} ,replace	//dta file with the columns of the fourth moments matrix
use  tempo



mkmat m* in 1/1, matrix (m)
matrix m=m'
mat coln m=m



mkmat t* in 1/1, matrix (t)
matrix t=t'
mat coln t=cell
mkmat yt* in 1/1, matrix (yt)
matrix yt=yt'
mat coln yt=yt
mkmat ys* in 1/1, matrix (ys)
matrix ys=ys'
mat coln ys=ys

mkmat agetA* in 1/1, matrix (agetA)
matrix agetA=agetA'
mat coln agetA=agetA
mkmat agesA* in 1/1, matrix (agesA)
matrix agesA=agesA'
mat coln agesA=agesA
mkmat agexA* in 1/1, matrix (agexA)
matrix agexA=agexA'
mat coln agexA=agexA

mkmat agetC* in 1/1, matrix (agetC)
matrix agetC=agetC'
mat coln agetC=agetC
mkmat agesC* in 1/1, matrix (agesC)
matrix agesC=agesC'
mat coln agesC=agesC
mkmat agexC* in 1/1, matrix (agexC)
matrix agexC=agexC'
mat coln agexC=agexC



mat A=m,yt,ys,agetA,agesA,agexA,agetC,agesC,agexC,t
 

drop _all
svmat A,n(col)


ge bobt=$b
ge bobs=$b
ge cohot=$co
ge cohos=$co

save  mm_${b}_${b}_${co} ,replace		// dta file with second moments plus year, cohort, age and member type indicators
merge using  varia
capture drop _merge

save,replace 

erase  tempo.dta
erase varia.dta
erase matres.dta


