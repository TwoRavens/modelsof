clear
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\10298252\ICPSR_04426\DS0001\pkg04426-0001\Part1"
set mem 500m

use 02finindfinal




global vars1 v_a01 	v_a03 	v_a09 	v_a10 	v_a12 	v_a16 	v_a18 	v_a21 	v_a36 	v_a44 	v_a45 	v_a50 	v_a54 	v_a56 	v_a59 	v_a60 	v_a61 	v_a80 	v_a81 	v_a87 	v_a89 v_t01
global vars2 v_t09 	v_t10 	v_t11 	v_t12 	v_t13 	v_t14 	v_t15 	v_t16 	v_t19 	v_t20 	v_t21 	v_t22 	v_t23 	v_t24 	v_t25 	v_t27 	v_t28 	v_t29 	v_t40 	v_t41 	v_t50 v_t51
global vars3 v_t53 	v_t99 	v_u01 	v_u10 	v_u11 	v_u20 	v_u30 	v_u40 	v_u41 	v_u50 	v_u95 	v_u99 	v_b01 	v_b21 	v_b22 	v_b27 	v_b30 	v_b42 	v_b46 	v_b47 	v_b50 v_b54 
global vars4 v_b59 	v_b79 	v_b80 	v_b89 	v_b91 	v_b92 	v_b93 	v_b94 	v_c21 	v_c28 	v_c30 	v_c42 	v_c46 	v_c47 	v_c50 	v_c67 	v_c79 	v_c80 	v_c89 	v_c91 	v_c92 v_c93
global vars5 v_c94 	v_d11 	v_d21 	v_d30 	v_d42 	v_d46 	v_d47 	v_d50 	v_d79 	v_d80 	v_d89 	v_d91 	v_d92 	v_d93 	v_d94 	v_a06 	v_a14 	 v_e01 	 v_f01 	 v_g01  v_i01 v_l01
global vars6 v_m01 	 v_n01 	 v_o01 	 v_p01 	 v_r01 	 v_e02 	 v_f02 	 v_g02 	 v_i02 	 v_l02 	 v_m02 	 v_e03 	 v_f03 	 v_g03 	 v_e04 	 v_f04 	 v_g04 	 v_i04 	 v_l04 	 v_m04 	v_e05 v_f05
global vars7 v_g05 	 v_l05 	 v_m05 	 v_n05 	 v_o05 	 v_p05 	 v_s05 	 v_e06 	 v_f06 	 v_g06 	 v_i06 	 v_l06 	 v_m06 	 v_e12 	 v_f12 	 v_g12 	 v_l12 	 v_m12 	 v_n12 	 v_o12 	v_p12 v_q12
global vars8 v_r12 	 v_e14 	 v_f14 	 v_g14 	 v_i14 	 v_e16 	 v_f16 	 v_g16 	 v_e18 	 v_f18 	 v_g18 	 v_l18 	 v_m18 	 v_n18 	 v_o18 	 v_p18 	 v_q18 	 v_r18 	 v_e19 	 v_e20  v_f20 v_g20
global vars9 v_i20 	 v_l20 	 v_m20 	 v_e21 	 v_f21 	 v_g21 	 v_i21 	 v_l21 	 v_m21 	 v_n21 	 v_o21 	 v_p21 	 v_q21 	 v_s21 	 v_e22 	 v_f22 	 v_g22 	 v_i22 	 v_l22 	 v_m22 	v_e23 v_f23
global vars10 v_g23 	 v_i23 	 v_l23 	 v_m23 	 v_n23 	 v_o23 	 v_p23 	 v_e24 	 v_f24 	 v_g24 	 v_l24 	 v_m24 	 v_n24 	 v_o24 	 v_p24 	 v_r24 	 v_e25 	 v_f25 	 v_f26 	 v_g29 	v_p30 v_m32
global vars11 v_g37 	 v_n38 	 v_e44 	 v_e45 	 v_r47 	 v_r50 	 v_m52 	 v_m53 	 v_r54 	 v_f56 	 v_f57 	 v_m58 	 v_r59 	 v_p60 	 v_p61 	 v_p62 	 v_p66 	 v_e68 	 v_g77 	 v_r79 	v_r80 v_r81 
global vars12 v_l87 	 v_j89 	 v_n91 	 v_l94 	 v_g25 	 v_g26 	 v_i29 	 v_r30 	 v_n32 	 v_i37 	 v_o38 	 v_f44 	 v_f45 	 v_e50 	 v_e51 	 v_n52 	 v_e54 	 v_e55 	 v_g56 	 v_g57 	v_e59 v_s59 
global vars13 v_r60 	 v_r61 	 v_r62 	 v_r66 	 v_i68 	 v_e79 	 v_e80 	 v_e81 	 v_e84 	 v_m87 	 v_l89 	 v_r91 	 v_m94 	 v_i25	 v_e28	 v_l29	 v_e31	 v_o32	 v_l37	 v_p38	 v_g44	 v_g45	
global vars14 v_f50	 v_i51	 v_o52	 v_f54	 v_f55	 v_i56	 v_i57	 v_f59	 v_e60	 v_e61	 v_e62	 v_e66	 v_e67	 v_m68	 v_f79	 v_f80	 v_f81	 v_e85	 v_n87	 v_m89	 v_l92	 v_n94	 
global vars15 v_l25 	 v_f28 	 v_m29 	 v_f31 	 v_p32 	 v_m37 	 v_r38 	 v_i44 	 v_e47 	 v_g50 	 v_l51 	 v_p52 	 v_g54 	 v_g55 	 v_l56 	 v_l57 	 v_g59 	 v_f60 	 v_f61 	 v_f62 	 v_f66 	 v_i67 	
global vars16 v_n68 	 v_g79 	 v_g80 	 v_g81 	 v_f85 	 v_o87 	 v_n89 	 v_m92 	 v_r94 	 v_m25 	 v_g28 	 v_n29 	 v_g31 	 v_r32 	 v_e38 	 v_e39 	 v_l44 	 v_i47 	 v_i50 	 v_m51 	 v_r52 	 v_i54 	 
global vars17 v_m55 	 v_m56 	 v_m57 	 v_i59 	 v_g60 	 v_g61 	 v_g62 	 v_g66 	 v_l67 	 v_o68 	 v_i79 	 v_i80 	 v_i81 	 v_g85 	 v_p87 	 v_o89 	 v_n92 	 v_n25 	 v_i28 	 v_o29 	 v_e32 	 v_e36 	
global vars18 v_f38 	 v_f39 	 v_m44 	 v_l47 	 v_l50 	 v_e52 	 v_e53 	 v_l54 	 v_n55 	 v_n56 	 v_e58 	 v_l59 	 v_i60 	 v_i61 	 v_i62 	 v_i66 	 v_m67 	 v_p68 	 v_l79 	 v_l80 	 v_l81 	 v_i85 	
global vars19 v_r87 	 v_p89 	 v_r92 	 v_o25 	 v_l28 	 v_p29 	 v_f32 	 v_f36 	 v_g38 	 v_g39 	 v_n44 	 v_m47 	 v_m50 	 v_f52 	 v_f53 	 v_m54 	 v_o55 	 v_o56 	 v_f58 	 v_m59 	 v_l60 	 v_l61 	 
global vars20 v_l62 	 v_l66 	 v_n67 	 v_e74 	 v_m79 	 v_m80 	 v_m81 	 v_e87 	 v_e89 	 v_r89 	 v_l93 	 v_p25 	 v_m28 	 v_m30 	 v_g32 	 v_g36 	 v_i38 	 v_i39 	 v_o44 	 v_n47 	 v_n50 	 v_g52 	 
global vars21 v_g53 	 v_n54 	 v_p55 	 v_p56 	 v_g58 	 v_n59 	 v_m60 	 v_m61 	 v_m62 	 v_m66 	 v_o67 	 v_e75 	 v_n79 	 v_n80 	 v_n81 	 v_f87 	 v_f89 	 v_s89 	 v_m93 	 v_s25 	 v_e29 	 v_n30 	
global vars22 v_i32 	 v_e37 	 v_l38 	 v_l39 	 v_p44 	 v_o47 	 v_o50 	 v_i52 	 v_i53 	 v_o54 	 v_r55 	 v_r56 	 v_i58 	 v_o59 	 v_n60 	 v_n61 	 v_n62 	 v_n66 	 v_p67 	 v_e77 	 v_o79 	 v_o80 	 
global vars23 v_o81 	 v_g87 	 v_g89 	 v_l91 	 v_n93 	 v_e26 	 v_f29 	 v_o30 	 v_l32 	 v_f37 	 v_m38 	 v_m39 	 v_r44 	 v_p47 	 v_p50 	 v_l52 	 v_l53 	 v_p54 	 v_e56 	 v_e57 	 v_l58 	 v_p59 	 
global vars24 v_o60 	 v_o61 	 v_o62 	 v_o66 	 v_s67 	 v_f77 	 v_p79 	 v_p80 	 v_p81 	 v_i87 	 v_i89 	 v_m91 	 v_r93 


foreach var in $vars1 $vars2  $vars3  $vars4  $vars5  $vars6  $vars7  $vars8  $vars9  $vars10  $vars11  $vars12  $vars13  $vars14  $vars15  $vars16  $vars17  $vars18  $vars19  $vars20  $vars21 $vars22  $vars23 $vars24 {

capture rename `var' variables_`var'

}





keep govcode govname coname fipstate fipsco fipspla variables_*

foreach var in $vars1 $vars2  $vars3  $vars4  $vars5  $vars6  $vars7  $vars8  $vars9  $vars10  $vars11  $vars12  $vars13  $vars14  $vars15  $vars16  $vars17  $vars18  $vars19  $vars20  $vars21 $vars22  $vars23 $vars24 {

capture rename variables_`var' `var' 

}



*"HACER LO MISMO EN OTROS ANIOS!!!!!!!!!!!!!!!!!!!!!"
gen aux=substr(govcode,3,1)
destring aux, replace
keep if aux==2 | aux==3
drop aux

* Total general revenue categories


 global vars_1 v_t01 	v_t09 	v_t10 	v_t11 	v_t12 	v_t13 	v_t14 	v_t15 	v_t16 	v_t19 	v_t20 	v_t21 	v_t22 	v_t23 	v_t24 	v_t25 	v_t27 	v_t28 	v_t29 	v_t40 	v_t41 	v_t50 	
 global vars_2 v_t51 	v_t53 	v_t99 	v_u01 	v_u10 	v_u11 	v_u20 	v_u30 	v_u40 	v_u41 	v_u50 	v_u95 	v_u99 	v_b01 	v_b21 	v_b22 	v_b27 	v_b30 	v_b42 	v_b46 	v_b47 	v_b50 	v_b54 	v_b59 	
 global vars_3 v_b79 	v_b80 	v_b89 	v_b91 	v_b92 	v_b93 	v_b94 	v_c21 	v_c28 	v_c30 	v_c42 	v_c46 	v_c47 	v_c50 	v_c67 	v_c79 	v_c80 	v_c89 	v_c91 	v_c92 	v_c93 	v_c94 	v_d11 	v_d21 	
 global vars_4  v_d30 	v_d42 	v_d46 	v_d47 	v_d50 	v_d79 	v_d80 	v_d89 	v_d91 	v_d92 	v_d93 	v_d94 	v_a06 	v_a14 	      	v_a01 	v_a03 	v_a09 	v_a10 	v_a12 	v_a16 	v_a18 	v_a21 	v_a36 	
 global vars_5  v_a44 	v_a45 	v_a50 	v_a54 	v_a56 	v_a59 	v_a60 	v_a61 	v_a80 	v_a81 	v_a87 	v_a89 

foreach var in $vars_1 $vars_2  $vars_3  $vars_4  $vars_5  {

cap sum `var'
if _rc==0 {

di in red "`var'"

}

if _rc!=0 {

gen `var'=.

}


}

egen tot_gen_rev_new=rsum( $vars_1 $vars_2  $vars_3  $vars_4  $vars_5)

egen  aux=rsum(v_b21 v_c21 v_d11 v_d21)

replace tot_gen_rev_new=tot_gen_rev_new-aux

drop aux


* Total general expenditure categories


global vars1 v_e01	v_f01	v_g01	v_i01	v_l01	v_m01	v_n01	v_o01	v_p01	v_r01	v_e02	v_f02	v_g02	v_i02	v_l02	v_m02	v_e03	v_f03	v_g03	v_e04	v_f04	v_g04	v_i04	v_l04	
global vars2 v_m04	v_e05	v_f05	v_g05	v_l05	v_m05	v_n05	v_o05	v_p05	v_s05	v_e06	v_f06	v_g06	v_i06	v_l06	v_m06	v_e12	v_f12	v_g12	v_l12	v_m12	v_n12	v_o12	v_p12	
global vars3 v_q12	v_r12	v_e14	v_f14	v_g14	v_i14	v_e16	v_f16	v_g16	v_e18	v_f18	v_g18	v_l18	v_m18	v_n18	v_o18	v_p18	v_q18	v_r18	v_e19	v_e20	v_f20	v_g20	v_i20	
global vars4 v_l20	v_m20	v_e21	v_f21	v_g21	v_i21	v_l21	v_m21	v_n21	v_o21	v_p21	v_q21	v_s21	v_e22	v_f22	v_g22	v_i22	v_l22	v_m22	v_e23	v_f23	v_g23	v_i23	v_l23	
global vars5 v_m23	v_n23	v_o23	v_p23	v_e24	v_f24	v_g24	v_l24	v_m24	v_n24	v_o24	v_p24	v_r24	v_e25	v_f25	v_f26	v_g29	v_p30	v_m32	v_g37	v_n38	v_e44	v_e45	v_r47	
global vars6 v_r50	v_m52	v_m53	v_r54	v_f56	v_f57	v_m58	v_r59	v_p60	v_p61	v_p62	v_p66	v_e68	v_g77	v_r79	v_r80	v_r81	v_l87	v_j89	v_n91	v_l94	v_g25	v_g26	v_i29	
global vars7 v_r30	v_n32	v_i37	v_o38	v_f44	v_f45	v_e50	v_e51	v_n52	v_e54	v_e55	v_g56	v_g57	v_e59	v_s59	v_r60	v_r61	v_r62	v_r66	v_i68	v_e79	v_e80	v_e81	v_e84	
global vars8 v_m87	v_l89	v_r91	v_m94	v_i25	v_e28	v_l29	v_e31	v_o32	v_l37	v_p38	v_g44	v_g45	v_f50	v_i51	v_o52	v_f54	v_f55	v_i56	v_i57	v_f59	v_e60	v_e61	v_e62	
global vars9 v_e66	v_e67	v_m68	v_f79	v_f80	v_f81	v_e85	v_n87	v_m89	v_l92	v_n94	v_l25	v_f28	v_m29	v_f31	v_p32	v_m37	v_r38	v_i44	v_e47	v_g50	v_l51	v_p52	v_g54	
global vars10 v_g55	v_l56	v_l57	v_g59	v_f60	v_f61	v_f62	v_f66	v_i67	v_n68	v_g79	v_g80	v_g81	v_f85	v_o87	v_n89	v_m92	v_r94	v_m25	v_g28	v_n29	v_g31	v_r32	v_e38	
global vars11 v_e39	v_l44	v_i47	v_i50	v_m51	v_r52	v_i54	v_m55	v_m56	v_m57	v_i59	v_g60	v_g61	v_g62	v_g66	v_l67	v_o68	v_i79	v_i80	v_i81	v_g85	v_p87	v_o89	v_n92	
global vars12 v_n25	v_i28	v_o29	v_e32	v_e36	v_f38	v_f39	v_m44	v_l47	v_l50	v_e52	v_e53	v_l54	v_n55	v_n56	v_e58	v_l59	v_i60	v_i61	v_i62	v_i66	v_m67	v_p68	v_l79	
global vars13 v_l80	v_l81	v_i85	v_r87	v_p89	v_r92	v_o25	v_l28	v_p29	v_f32	v_f36	v_g38	v_g39	v_n44	v_m47	v_m50	v_f52	v_f53	v_m54	v_o55	v_o56	v_f58	v_m59	v_l60	
global vars14 v_l61	v_l62	v_l66	v_n67	v_e74	v_m79	v_m80	v_m81	v_e87	v_e89	v_r89	v_l93	v_p25	v_m28	v_m30	v_g32	v_g36	v_i38	v_i39	v_o44	v_n47	v_n50	v_g52	v_g53	
global vars15 v_n54	v_p55	v_p56	v_g58	v_n59	v_m60	v_m61	v_m62	v_m66	v_o67	v_e75	v_n79	v_n80	v_n81	v_f87	v_f89	v_s89	v_m93	v_s25	v_e29	v_n30	v_i32	v_e37	v_l38	
global vars16 v_l39	v_p44	v_o47	v_o50	v_i52	v_i53	v_o54	v_r55	v_r56	v_i58	v_o59	v_n60	v_n61	v_n62	v_n66	v_p67	v_e77	v_o79	v_o80	v_o81	v_g87	v_g89	v_l91	v_n93	
global vars17 v_e26	v_f29	v_o30	v_l32	v_f37	v_m38	v_m39	v_r44	v_p47	v_p50	v_l52	v_l53	v_p54	v_e56	v_e57	v_l58	v_p59	v_o60	v_o61	v_o62	v_o66	v_s67	v_f77	v_p79	
global vars18 v_p80	v_p81	v_i87	v_i89	v_m91	v_r93
		 
		 

foreach var in $vars1 $vars2  $vars3  $vars4  $vars5  $vars6  $vars7  $vars8  $vars9  $vars10  $vars11  $vars12  $vars13  $vars14  $vars15  $vars16  $vars17  $vars18  {

cap sum `var'
if _rc==0 {

di in red "`var'"

}

if _rc!=0 {

gen `var'=.

}

}

egen tot_gen_exp_new=rsum($vars1 $vars2  $vars3  $vars4  $vars5  $vars6  $vars7  $vars8  $vars9  $vars10  $vars11  $vars12  $vars13  $vars14  $vars15  $vars16  $vars17  $vars18 )
egen aux=rsum(v_e12 v_e16 v_e18 v_e19 v_e21 v_f12 v_f16 v_f18 v_f21 v_g12 v_g16 v_g18 v_g21  v_m12 v_m18 v_m21 v_n18 v_n21 v_q12 v_q18)

replace tot_gen_exp_new=tot_gen_exp_new-aux
drop aux
		 

* Intergovernmental revenue

global vars1 v_b01	v_b21 	v_b22 	v_b27 	v_b30 	v_b42 	v_b46 	v_b47	v_b50 	v_b54	v_b59	v_b79	v_b80 	v_b89 	v_b91	v_b92 	v_b93	v_b94 	v_c21 	v_c28	v_c30	v_c42	v_c46	v_c47 	
global vars2 v_c50 	v_c67 	v_c79 	v_c80	v_c89 	v_c91	v_c92	v_c93 	v_c94	v_d11 	v_d21	v_d30 	v_d42	v_d46 	v_d47 	v_d50	v_d79	v_d80	v_d89 	v_d91 	v_d92	v_d93 	v_d94


foreach var in $vars1 $vars2  {

cap sum `var'
if _rc==0 {

di in red "`var'"

}

if _rc!=0 {

gen `var'=.

}

}


egen tot_int_gov_new=rsum( $vars1 $vars2)
egen aux=rsum(v_b21 v_c21 v_d11 v_d21)

egen aux1=rsum(v_e12 v_e16 v_e18 v_e19 v_e21 v_f12 v_f16 v_f18 v_f21 v_g12 v_g16 v_g18 v_g21  v_m12 v_m18 v_m21 v_n18 v_n21 v_q12 v_q18)



replace tot_int_gov_new=tot_int_gov_new-aux

drop aux


egen prop_tax_new=rsum(v_t01)


egen other_tax=rsum(v_t*)

egen aux_9=rsum(v_t09)
replace other_tax=other_tax-prop_tax_new-aux_9

drop aux*

		 
dropmiss
		 
compress	 
save "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\city_finances02", replace
                                        
		 
		 
