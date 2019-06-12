clear
set matsize 800



local from = `2'		/*first cohort*/
local to = `3'		/*last cohort*/



local co=`2'
while `co'<=`3' {
	use   mm_${b}_${b}_`co',clear
	merge using   fm_${b}_${b}_`co'
	drop _merge
	mkmat dev* ,mat(fm_${b}_${b}_`co')
	mat fminv`co'=syminv(fm_${b}_${b}_`co')
	gen cohort=`co'
	gen bob=$b
	gen dco`co'=1
	save   mmfm_${b}_${b}_`co',replace
	erase  fm_${b}_${b}_`co'.dta
	erase  mm_${b}_${b}_`co'.dta
local co=`co'+3
}

use   mmfm_${b}_${b}_`2'
local co=`2'+3
while `co'<=`3' {
append using   mmfm_${b}_${b}_`co'
erase   mmfm_${b}_${b}_`co'.dta
local co=`co'+3
}

save  moments_${b}_${b}, replace
erase  mmfm_${b}_${b}_`2'.dta
mvencode dco*,mv(0)


quietly summ cohort
global min=_result(5)
global max=_result(6)




ge t=yt-1980
ge s =ys-1980

local yt=1980
while `yt'<=2014 {
	local t=`yt'-1980
	ge byte dr`t'=yt==`yt'
	local yt=`yt'+1
}

local ys=1980
while `ys'<=2014 {
	local s=`ys'-1980
	ge byte dc`s'=ys==`ys'
	local ys=`ys'+1
}

ge dd=yt==ys
ge tds=abs(yt-ys)





compress
save,replace
