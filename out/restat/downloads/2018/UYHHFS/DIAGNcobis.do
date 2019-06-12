

capture program drop gino
program define gino
	local j=1
	while `j'<=gino{
		matrix a`j'=vppi[`j'..`j',1..1]
		scalar a`j'=trace(a`j')
		scalar b`j'=a`j'^.5
		matrix a`j'=uno*b`j'
		local j=`j'+1
	}
	matrix vppi=a1\a2
	local j=3
	while `j'<=gino {
		matrix vppi=vppi\a`j'
	local j=`j'+1
	}
end




forv bt=0(1)2 {
	forv bs=`bt'(1)2 {
		forv ct = 1936(3)1984 {
			forv cs = 1936(3)1984 {
				capture mkmat resi if bobt==`bt' & bobs==`bs' & cohot==`ct' & cohos==`cs', mat(resi_`bt'`bs'_`ct'`cs')
				capture mkmat ${listpar}  if bobt==`bt' & bobs==`bs' & cohot==`ct' & cohos==`cs', mat(g_`bt'`bs'_`ct'`cs')
			}  
		}
	}
}


mat accum GG=$listpar , noc  
mat invGG= syminv(GG)



forv bt=0(1)2 {
	forv bs=`bt'(1)2 {
		forv ct = 1936(3)1984 {
			forv cs = 1936(3)1984 {
				if 	(`ct'==1936 & `cs'==1936 & `bt' == 0 & `bs'==0 ) {
					mat gfmg= g_`bt'`bs'_`ct'`cs''*fm_`bt'`bs'_`ct'`cs'* g_`bt'`bs'_`ct'`cs'
					matrix chi=resi_`bt'`bs'_`ct'`cs''*fminv_`bt'`bs'_`ct'`cs'*resi_`bt'`bs'_`ct'`cs'
					matrix unchi=resi_`bt'`bs'_`ct'`cs''*resi_`bt'`bs'_`ct'`cs'			
				}
				else {
					capture mat gfmg=gfmg+g_`bt'`bs'_`ct'`cs''*fm_`bt'`bs'_`ct'`cs'* g_`bt'`bs'_`ct'`cs'
					capture matrix chi= chi+resi_`bt'`bs'_`ct'`cs''*fminv_`bt'`bs'_`ct'`cs'*resi_`bt'`bs'_`ct'`cs'
					capture matrix unchi= unchi+resi_`bt'`bs'_`ct'`cs''*resi_`bt'`bs'_`ct'`cs'
				}
			}  
		}
	}
}



matrix vp=invGG*gfmg*invGG
matrix vpp=vecdiag(vp)
matrix vppi=vpp'

scalar gino=rowsof(vppi)
matrix uno=(1)
gino


forv bt=0(1)2 {
	forv bs=`bt'(1)2 {
		forv ct = 1936(3)1984 {
			forv cs = 1936(3)1984 {
				qui count if cohot == `ct' & cohos == `cs' & bobt==`bt' & bobs==`bs'
				capture mat Id=I(r(N))
				capture mat W_`bt'`bs'_`ct'`cs'=(Id-g_`bt'`bs'_`ct'`cs'*invGG*g_`bt'`bs'_`ct'`cs'')
				capture mat R_`bt'`bs'_`ct'`cs'=W_`bt'`bs'_`ct'`cs'*fm_`bt'`bs'_`ct'`cs'*W_`bt'`bs'_`ct'`cs''
				capture mat invR_`bt'`bs'_`ct'`cs'=syminv(R_`bt'`bs'_`ct'`cs')
				capture mat chi_`bt'`bs'_`ct'`cs'=resi_`bt'`bs'_`ct'`cs''*invR_`bt'`bs'_`ct'`cs'*resi_`bt'`bs'_`ct'`cs'
			}  
		}
	}
}









mat chinew=(0)


forv bt=0(1)2 {
	forv bs=`bt'(1)2 {
		forv ct = 1936(3)1984 {
			forv cs = 1936(3)1984 {
				capture mat chinew=chinew+chi_`bt'`bs'_`ct'`cs'
			}  
		}
	}
}
				
				
				
				

matrix diagn=unchi,chinew
matrix bi=get(_b)
matrix bi=bi'
matrix result=bi,vppi
matrix result=result\diagn






