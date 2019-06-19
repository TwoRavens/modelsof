clear
use "C:\Users\HW462587\Documents\Leah\Data\gov_codes_fips_eqs"
keep  govcode fipstate fipspla
gen year=1999
tempfile aux_eqs
keep if fipspla!=""
sort govcode year
save `aux_eqs', replace

clear
use "C:\Users\HW462587\Documents\Leah\Data\census_gov\2002\10298252\ICPSR_04426\DS0001\pkg04426-0001\Part1\02finindfinal"
drop year
gen year=1999
sort govcode year

merge govcode year using `aux_eqs'
tab _merge
keep if _merge==3 | _merge==2
drop _merge

sort govcode year
save `aux_eqs', replace


gen categories_name=""
gen categories=.




global variables1   v_e01	v_e02	v_f04	v_n05	v_e12	v_e14	v_l18	v_g20	v_n21
global variables2   v_m52	v_m53	v_r54	v_f56	v_f57	v_m58	v_r59	v_p60	v_p61
global variables3   v_y34	v_f01	v_f02	v_g04	v_o05	v_f12	v_f14	v_m18	v_i20
global variables4   v_e51	v_n52	v_e54	v_e55	v_g56	v_g57	v_e59	v_s59	v_r60
global variables5   v_r93	v_y45	v_g01	v_g02	v_i04	v_p05	v_g12	v_g14	v_n18
global variables6   v_f50	v_i51	v_o52	v_f54	v_f55	v_i56	v_i57	v_f59	v_e60
global variables7   v_m92	v_r94	v_i01	v_i02	v_l04	v_s05	v_l12	v_i14	v_o18
global variables8   v_g50	v_l51	v_p52	v_g54	v_g55	v_l56	v_l57	v_g59	v_f60
global variables9   v_m93	v_x11	v_l01	v_l02	v_m04	v_e06	v_m12	v_e16	v_p18
global variables10  v_i50	v_m51	v_r52	v_i54	v_m55	v_m56	v_m57	v_i59	v_g60
global variables11  v_m94	v_x12	v_m01	v_m02	v_e05	v_f06	v_n12	v_f16	v_q18
global variables12  v_l50	v_e52	v_e53	v_l54	v_n55	v_n56	v_e58	v_l59	v_i60
global variables13  v_n91	v_y05	v_n01	v_e03	v_f05	v_g06	v_o12	v_g16	v_r18
global variables14  v_m50	v_f52	v_f53	v_m54	v_o55	v_o56	v_f58	v_m59	v_l60
global variables15  v_n92	v_y06	v_o01	v_f03	v_g05	v_i06	v_p12	v_e18	v_e19
global variables16  v_n50	v_g52	v_g53	v_n54	v_p55	v_p56	v_g58	v_n59	v_m60
global variables17  v_n93	v_y14	v_p01	v_g03	v_l05	v_l06	v_q12	v_f18	v_e20
global variables18  v_o50	v_i52	v_i53	v_o54	v_r55	v_r56	v_i58	v_o59	v_n60
global variables19  v_n94	v_y53	v_r01	v_e04	v_m05	v_m06	v_r12	v_g18	v_f20
global variables20  v_p50	v_l52	v_l53	v_p54	v_e56	v_e57	v_l58	v_p59	v_o60
global variables21  v_r91	v_y25							
global variables22  v_m22	v_e24	v_f25	v_f26	v_g29	v_p30	v_m32	v_g37	
global variables23  v_p62	v_p66	v_e68	v_g77	v_r79	v_r80	v_r81	v_l87	
global variables24  v_o21	v_e23	v_f24	v_g25	v_g26	v_i29	v_r30	v_n32	
global variables25  v_r61	v_r62	v_r66	v_i68	v_e79	v_e80	v_e81	v_e84	
global variables26  v_l20	v_p21	v_f23	v_g24	v_i25	v_e28	v_l29	v_e31	
global variables27  v_e61	v_e62	v_e66	v_e67	v_m68	v_g79	v_f80	v_f81	
global variables28  v_m20	v_q21	v_g23	v_l24	v_l25	v_f28	v_m29	v_f31	
global variables29  v_f61	v_f62	v_f66	v_i67	v_n68	v_f79	v_g80	v_g81	
global variables30  v_e21	v_s21	v_i23	v_m24	v_m25	v_g28	v_n29	v_g31	
global variables31  v_g61	v_g62	v_g66	v_l67	v_o68	v_i79	v_i80	v_i81	
global variables32  v_f21	v_e22	v_l23	v_n24	v_n25	v_i28	v_o29	v_e32	
global variables33  v_i61	v_i62	v_i66	v_m67	v_p68	v_l79	v_l80	v_l81	
global variables34  v_g21	v_f22	v_m23	v_o24	v_o25	v_l28	v_p29	v_f32	
global variables35  v_l61	v_l62	v_l66	v_n67	v_e74	v_m79	v_m80	v_m81	
global variables36  v_i21	v_g22	v_n23	v_p24	v_p25	v_m28	v_m30	v_g32	
global variables37  v_m61	v_m62	v_m66	v_o67	v_e75	v_n79	v_n80	v_n81	
global variables38  v_l21	v_i22	v_o23	v_r24	v_s25	v_e29	v_n30	v_i32	
global variables39  v_n61	v_n62	v_n66	v_p67	v_e77	v_o79	v_o80	v_o81	
global variables40  v_m21	v_l22	v_p23	v_e25	v_e26	v_f29	v_o30	v_l32	
global variables41  v_o61	v_o62	v_o66	v_s67	v_f77	v_p79	v_p80	v_p81	
global variables42  v_n38	v_e44	v_e45	v_r47	v_r50				
global variables43  v_j89	v_g90	v_f93	v_l94	v_r92				
global variables44  v_i37	v_o38	v_f44	v_f45	v_e50				
global variables45  v_m87	v_l89	v_e91	v_g93	v_m91				
global variables46  v_o32	v_l37	v_p38	v_g44	v_g45				
global variables47  v_e85	v_n87	v_m89	v_f91	v_i93				
global variables48  v_p32	v_m37	v_r38	v_i44	v_e47				
global variables49  v_f85	v_o87	v_n89	v_g91	v_e94				
global variables50  v_r32	v_e38	v_e39	v_l44	v_i47				
global variables51  v_g85	v_p87	v_o89	v_i91	v_f94				
global variables52  v_e36	v_f38	v_f39	v_m44	v_l47				
global variables53  v_i85	v_r87	v_p89	v_e92	v_g94				
global variables54  v_f36	v_g38	v_g39	v_n44	v_m47				
global variables55  v_e87	v_e89	v_r89	v_f92	v_i94				
global variables56  v_g36	v_i38	v_i39	v_o44	v_n47				
global variables57  v_f87	v_f89	v_s89	v_g92	v_l91				
global variables58  v_e37	v_l38	v_l39	v_p44	v_o47				
global variables59  v_g87	v_g89	v_e90	v_i92	v_l92				
global variables60  v_f37	v_m38	v_m39	v_r44	v_p47				
global variables61  v_f37	v_i87	v_i89	v_f90	v_e93	v_l93				




foreach var in  $variables1   	$variables2   	$variables3   	$variables4   	$variables5   	$variables6   	$variables7   	$variables8   	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables9   	$variables10  	$variables11  	$variables12  	$variables13  	$variables14  	$variables15  	$variables16  	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables17  	$variables18  	$variables19  	$variables20  	$variables21  	$variables22  	$variables23  	$variables24  	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables25  	$variables26  	$variables27  	$variables28  	$variables29  	$variables30  	$variables31  	$variables32  	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables33  	$variables34  	$variables35  	$variables36  	$variables37  	$variables38  	$variables39  	$variables40  	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables41  	$variables42  	$variables43  	$variables44  	$variables45  	$variables46  	$variables47  	$variables48  	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables49  	$variables50  	$variables51  	$variables52  	$variables53  	$variables54  	$variables55  	$variables56  	   {

cap gen exp_`var'=`var'
cap drop `var'


}
foreach var in  $variables57  	$variables58  	$variables59  	$variables60  	$variables61     {

cap gen exp_`var'=`var'
cap drop `var'


}






keep exp_* 
collapse (sum) exp_* 

save "C:\Users\HW462587\Documents\Leah\Data\census_go\expenditures2000", replace


