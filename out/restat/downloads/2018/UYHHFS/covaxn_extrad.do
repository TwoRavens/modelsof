capture quietly mvencode res*, mv(0)
capture quietly mvencode ageA*, mv(0)
capture quietly mvencode ageB*, mv(0)
capture quietly mvencode ageC*, mv(0)
capture quietly mvencode ageD*, mv(0)

sort pnrf
quietly compress

cap program drop cprod
program define cprod /*creates cross-products of residuals*/
	forv i=${from_b${b1}_c${cob1}}(1)${to_b${b1}_c${cob1}} {
		forv j=${from_b${b2}_c${cob2}}(1)${to_b${b2}_c${cob2}} {
			gen res_${b1}_${b2}_`i'`j'=res_b${b1}_c${cob1}_`i'*res_b${b2}_c${cob2}_`j'
			gen ageA_${b1}_${b2}_`i'`j'=(ageA_b${b1}_c${cob1}_`i')*(ageA_b${b2}_c${cob2}_`j')
			gen ageC_${b1}_${b2}_`i'`j'=(ageC_b${b1}_c${cob1}_`i')*(ageC_b${b2}_c${cob2}_`j')
			gen d_${b1}_${b2}_`i'`j'=  res_b${b1}_c${cob1}_`i'~=0 &res_b${b2}_c${cob2}_`j'~=0
		}
		quietly compress
	}
end
cprod




cap program drop cdum
program define cdum 
	forv i=${from_b${b1}_c${cob1}}(1)${to_b${b1}_c${cob1}} {
		ge d_b${b1}_c${cob1}_`i' =  res_b${b1}_c${cob1}_`i'~=0
		egen do_b${b1}_c${cob1}_`i'= sum(d_b${b1}_c${cob1}_`i') 
		egen etaA_b${b1}_c${cob1}_`i'=sum(ageA_b${b1}_c${cob1}_`i')
		egen etaC_b${b1}_c${cob1}_`i'=sum(ageC_b${b1}_c${cob1}_`i')
		drop d_b${b1}_c${cob1}_`i' ageA_b${b1}_c${cob1}_`i' ageC_b${b1}_c${cob1}_`i' 
	}
	forv j=${from_b${b2}_c${cob2}}(1)${to_b${b2}_c${cob2}} {
		ge d_b${b2}_c${cob2}_`j' =  res_b${b2}_c${cob2}_`j'~=0
		egen do_b${b2}_c${cob2}_`j'= sum(d_b${b2}_c${cob2}_`j')
		egen etaA_b${b2}_c${cob2}_`j' =  sum(ageA_b${b2}_c${cob2}_`j')
		egen etaC_b${b2}_c${cob2}_`j' =  sum(ageC_b${b2}_c${cob2}_`j')
		drop d_b${b2}_c${cob2}_`j' ageA_b${b2}_c${cob2}_`j' ageC_b${b2}_c${cob2}_`j' 
	}	
end
cdum	
		

		


compress

global OK = 0

cap program drop covax
program define covax /*calculates covariances*/

	forv i=${from_b${b1}_c${cob1}}(1)${to_b${b1}_c${cob1}} {
		forv j=${from_b${b2}_c${cob2}}(1)${to_b${b2}_c${cob2}} {
			egen t_${b1}_${b2}_`i'`j'=sum(d_${b1}_${b2}_`i'`j')
			if t_${b1}_${b2}_`i'`j'[1]>99 {
			
			global OK = $OK + 1
				egen s_${b1}_${b2}_`i'`j'=sum(res_${b1}_${b2}_`i'`j')
				drop d_${b1}_${b2}_`i'`j'
				egen xaA_${b1}_${b2}_`i'`j'=sum(ageA_${b1}_${b2}_`i'`j')
				egen xaC_${b1}_${b2}_`i'`j'=sum(ageC_${b1}_${b2}_`i'`j')
				drop ageA_${b1}_${b2}_`i'`j'  ageC_${b1}_${b2}_`i'`j' 
				gen m_${b1}_${b2}_`i'`j'=s_${b1}_${b2}_`i'`j'/t_${b1}_${b2}_`i'`j'
				drop s_${b1}_${b2}_`i'`j'  
				gen agexA_${b1}_${b2}_`i'`j' = xaA_${b1}_${b2}_`i'`j'/t_${b1}_${b2}_`i'`j'
				gen agexC_${b1}_${b2}_`i'`j' = xaC_${b1}_${b2}_`i'`j'/t_${b1}_${b2}_`i'`j'
				drop xaA_${b1}_${b2}_`i'`j'  xaC_${b1}_${b2}_`i'`j' 
				quietly gen dev_${b1}${b2}_${cob1}${cob2}_`i'`j'=(m_${b1}_${b2}_`i'`j'-res_${b1}_${b2}_`i'`j')/(t_${b1}_${b2}_`i'`j') if res_${b1}_${b2}_`i'`j'~=0
				quietly recode dev_${b1}${b2}_${cob1}${cob2}_`i'`j' .=0
				drop   res_${b1}_${b2}_`i'`j'  
				gen yt_${b1}_${b2}_`i'`j'=`i'
				gen ys_${b1}_${b2}_`i'`j' = `j'
				gen agetA_${b1}_${b2}_`i'`j'=etaA_b${b1}_c${cob1}_`i'/do_b${b1}_c${cob1}_`i'
				gen agesA_${b1}_${b2}_`i'`j'=etaA_b${b2}_c${cob2}_`j'/do_b${b2}_c${cob2}_`j'
				gen agetC_${b1}_${b2}_`i'`j'=etaC_b${b1}_c${cob1}_`i'/do_b${b1}_c${cob1}_`i'
				gen agesC_${b1}_${b2}_`i'`j'=etaC_b${b2}_c${cob2}_`j'/do_b${b2}_c${cob2}_`j'

			}
			if t_${b1}_${b2}_`i'`j'[1]<=99 {
				drop t_${b1}_${b2}_`i'`j'
			}
		}
	}
	sort pnrf
end

*set trace on
covax


drop eta* do*

if $OK > 0 {

save  tempo_extra,replace
use  tempo_extra
matrix accum fm=dev*  ,noc
mat varia=vecdiag(fm)           
mat varia=varia'
mat coln varia=varia
svmat varia, n(col)
keep varia
keep if varia~=.
gen stdev=sqrt(varia)
save  varia_extra,replace
drop _all
svmat fm,n(col)
save  fm_b${b1}${b2}_co${cob1}${cob2} ,replace //dta file with the columns of the fourth moments matrix
use  tempo_extra



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
ge bobt=$b1
ge bobs=$b2
ge cohot=$cob1
ge cohos=$cob2
save  mm_b${b1}${b2}_co${cob1}${cob2} ,replace // dta file with second moments plus year, cohort, age and member type indicators
merge using  varia_extra
capture drop _merge

save,replace 

erase  tempo_extra.dta
erase varia_extra.dta




use  mm_b${b1}${b2}_co${cob1}${cob2},clear
merge using  fm_b${b1}${b2}_co${cob1}${cob2}
drop _merge
mkmat dev* ,mat(fm_b${b1}${b2}_co${cob1}${cob2})
mat fminv`co'=syminv(fm_b${b1}${b2}_co${cob1}${cob2})

save  mmfm_b${b1}${b2}_co${cob1}${cob2},replace
erase fm_b${b1}${b2}_co${cob1}${cob2}.dta
erase mm_b${b1}${b2}_co${cob1}${cob2}.dta


}







