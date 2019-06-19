clear
cd "C:\Users\HW462587\Documents\Leah\Data\census_gov\1992\10298251\ICPSR_04420\DS0001\pkg04420-0001\Part1"
set mem 500m

use 92censusindunitfinal

keep govcode govname coname fipstate fipsco fipspla v_a01 	v_a03 	v_a07 	v_a08 	v_a09 	v_a10 	v_a11 	v_a12 	v_a13 	v_a15 	v_a16 	v_a18 	v_a20 	v_a21 	v_a36 	v_a44 	v_a45 	v_a50 	v_a54 	v_a56 	v_a59 	v_a60 	v_a61 	v_a80 	v_a81 	v_a87 	v_a89 v_a90 	v_a91 	v_a92 	v_a93 	v_a94 	v_b01 	v_b10 	v_b11 	v_b12 	v_b13 	v_b22 	v_b30 	v_b42 	v_b46 	v_b50 	v_b54 	v_b59 	v_b79 	v_b80 	v_b89 	v_b91 	v_b92  	v_b94 	v_c01 	v_c04 	v_c05 	v_c06 	v_c24 	v_c30 	v_c35 	v_c36 	v_c38 	v_c39 	v_c42 	v_c46 	v_c50 	v_c79 	v_c80 	v_c89 	v_c91 	v_c92 	v_c93 	v_c94 	v_d30 	v_d42 	v_d46 	v_d50 	v_d79 	v_d80 	v_d89 	v_d91 	v_d92 	v_d93 	v_d94 	v_e01 	v_e03 	v_e04 	v_e05 	v_e07 	v_e08 	v_e22 	v_e23 	v_e24 	v_e25 	v_e26 	v_e29 	v_e31 	v_e32 	v_e36 	v_e38 	v_e44 	v_e45 	v_e47 	v_e50 	v_e52 	v_e54 	v_e55 	v_e56 	v_e59 	v_e60 	v_e61 	v_e62 	v_e66 	v_e67 	v_e68 	v_e74 	v_e75 	v_e77 	v_e79 	v_e80 	v_e81 	v_e84 	v_e85 	v_e87 	v_e89 	v_e90 	v_e91 	v_e92 	v_e93 	v_e94 	v_f01 	v_f03 	v_f04 	v_f05 	v_f12 	v_f16 	v_f18 	v_f21 	v_f22 	v_f23 	v_f24 	v_f25 	v_f26 	v_f29 	v_f31 	v_f32 	v_f36 	v_f38 	v_f44 	v_f45 	v_f50 	v_f52 	v_f54 	v_f55 	v_f56 	v_f59 	v_f60 	v_f61 	v_f62 	v_f66 	v_f77 	v_f79 	v_f80 	v_f81 	v_f85 	v_f87 	v_f89 	v_f90 	v_f91 	v_f92 	v_f93 	v_f94 	v_g01 	v_g03 	v_g04 	v_g05 	v_g22 	v_g23 	v_g24 	v_g25 	v_g26 	v_g29 	v_g31 	v_g32 	v_g36 	v_g38 	v_g44 	v_g45 	v_g50 	v_g52 	v_g54 	v_g55 	v_g56 	v_g59 	v_g60 	v_g61 	v_g62 	v_g66 	v_g77 	v_g79 	v_g80 	v_g81 	v_g85 	v_g87 	v_g89 	v_g90 	v_g91 	v_g92 	v_g93 	v_g94 	v_i91 	v_i92 	v_i93 	v_i94 	v_k01 	v_k03 	v_k04 	v_k05 	v_k09 	v_k10 	v_k11 	v_k12 	v_k22 	v_k23 	v_k24 	v_k25 	v_k26 	v_k29 	v_k31 	v_k32 	v_k36 	v_k38 	v_k44 	v_k45 	v_k50 	v_k52 	v_k54 	v_k55 	v_k56 	v_k59 	v_k60 	v_k61 	v_k62 	v_k66 	v_k77 	v_k79 	v_k80 	v_k81 	v_k85 	v_k87 	v_k89 	v_k90 	v_k91 	v_k92 	v_k93 	v_k94 	v_l01 	v_l05 	v_l12 	v_l18 	v_l23 	v_l24 	v_l25 	v_l29 	v_l32 	v_l38 	v_l44 	v_l50 	v_l52 	v_l59  	v_l61 	v_l62 	v_l66 	v_l67 	v_l79 	v_l80 	v_l81 	v_l87 	v_l89 	v_l91 	v_l92 	v_l93 	v_l94 	v_m01 	v_m05 	v_m23 	v_m24 	v_m25 	v_m29 	v_m30 	v_m32 	v_m38 	v_m44 	v_m50 	v_m52 	v_m54 	v_m55 	v_m56 	v_m59 	v_m60 	v_m61 	v_m62 	v_m66 	v_m67  	v_m79 	v_m80 	v_m81 	v_m87 	v_m89 	v_m91 	v_m92 	v_m93 	v_m94 	v_n01 	v_n05 	v_n23 	v_n25 	v_n29 	v_n30 	v_n32 	v_n38 	v_n44 	v_n50 	v_n52 	v_n54 	v_n55 	v_n56 	v_n59 	v_n61 	v_n62 	v_n66 	v_n67 	v_n68 	v_n79 	v_n80 	v_n81 	v_n87 	v_n89 	v_n92  	v_n94 	v_r01 	v_r30 	v_r32 	v_r38 	v_r44 	v_r50 	v_r52 	v_r54 	v_r55  	v_r59 	v_r61 	v_r62 	v_r66 	v_r79 	v_r80 	v_r81 	v_r87 	v_r89 	v_r92 	v_r94 	v_s67 	v_s89 	v_t01 	v_t02 	v_t04 	v_t05 	v_t06 	v_t09 	v_t10 	v_t11 	v_t12 	v_t13 	v_t14 	v_t15 	v_t16 	v_t19 	v_t20 	v_t21 	v_t22 	v_t23 	v_t24 	v_t25 	v_t27 	v_t28 	v_t29 	v_t40 	v_t41 	v_t50 	v_t51 	v_t53 	v_t99 	v_u01 	v_u10 	v_u11 	v_u20 	v_u30 	v_u40 	v_u41 	v_u50 	v_u95 	v_u99 	v_v10 	v_v11 	v_v12 	v_v13 	v_v14 	v_v15 	v_v16 	v_v17 	v_v18 	v_v19 	v_v20 	v_v21 	v_v22 	v_v23 	v_v24 	v_v25 	v_v26 	v_v27 	v_v28 	v_v29 	v_v30 	v_v32 	v_z32 	v_z33 	v_z34 	v_z41 	v_z42 	v_z43 	v_z44 	v_z46 



*"HACER LO MISMO EN OTROS ANIOS!!!!!!!!!!!!!!!!!!!!!"
gen aux=substr(govcode,3,1)
destring aux, replace
keep if aux==2 | aux==3
drop aux

replace govcode=govcode+"00000"


label var v_a01 "Charges - Air Transportation                                  "
label var v_a03 "Charges - Miscellaneous Commercial Activities		       "
label var v_a07 "Charges - A10 Subcode-Tuition Fees			       "
label var v_a08 "Charges - A10 Subcode-Transportation Fees		       "
label var v_a09 "Charges - Elementary & Secondary Education School Lunch       "
label var v_a10 "Charges - Elementary & Secondary Education School Tuition     "
label var v_a11 "Charges - A12 Subcode-Textbook Sales/Returns		       "
label var v_a12 "Charges - Elementary & Secondary Education - Other	       "
label var v_a13 "Charges - A12 Subcode-Student Activity			       "
label var v_a15 "Charges - A10 Subcode-Undistributed-Student Fees	       "
label var v_a16 "Charges - Higher Education Auxiliary Enterprises	       "
label var v_a18 "Charges - Higher Education - Other			       "
label var v_a20 "Charges - A12 Subcode-Other Sales/Services		       "
label var v_a21 "Charges - Education - Other, NEC			       "
label var v_a36 "Charges - Hospital Public				       "
label var v_a44 "Charges - Regular Highways				       "
label var v_a45 "Charges - Toll Highways				       "
label var v_a50 "Charges - Housing & Community Development		       "
label var v_a54 "Charges - Natural Resources, Agriculture		       "
label var v_a56 "Charges - Natural Resources, Forestry			       "
label var v_a59 "Charges - Natural Resources - Other			       "
label var v_a60 "Charges - Parking Facilities				       "
label var v_a61 "Charges - Parks & Recreation				       "
label var v_a80 "Charges - Sewerage					       "
label var v_a81 "Charges - Solid Waste Management			       "
label var v_a87 "Charges - Water Transport & Terminals			       "
label var v_a89 "Charges - All Other					       "





label var v_a90  "Revenue - Liquor Stores                                                     "
label var v_a91  "Revenue - Water Utilities						      "
label var v_a92  "Revenue - Electric Utilities						      "
label var v_a93  "Revenue - Gas Utilities						      "
label var v_a94  "Revenue - Transit Utilities						      "
label var v_b01  "Federal Intergovernmental - Air Transportation			      "
label var v_b10  "Federal Intergovernmental - B21 Subcode-Direct Federal		      "
label var v_b11  "Federal Intergovernmental - B21 Subcode-Direct Federal		      "
label var v_b12  "Federal Intergovernmental - B21 Subcode-Direct Federal		      "
label var v_b13  "Federal Intergovernmental - B21 Subcode-Direct Federal		      "
label var v_b22  "Federal Intergovernmental - Employment Security			      "
label var v_b30  "Federal Intergovernmental - General Support				      "
label var v_b42  "Federal Intergovernmental - Health & Hospitals			      "
label var v_b46  "Federal Intergovernmental - Highways					      "
label var v_b50  "Federal Intergovernmental - Housing & Community Development		      "
label var v_b54  "Federal Intergovernmental - Natural Resources, Agriculture		      "
label var v_b59  "Federal Intergovernmental - Other Natural Resources			      "
label var v_b79  "Federal Intergovernmental - Public Welfare				      "
label var v_b80  "Federal Intergovernmental - Sewerage					      "
label var v_b89  "Federal Intergovernmental - All Other					      "
label var v_b91  "Federal Intergovernmental - Water Utilities				      "
label var v_b92  "Federal Intergovernmental - Electric Utilities			      "
label var v_b94  "Federal Intergovernmental - Transit Utilities				      "
label var v_c01  "State Intergovernmental - C21 Subcode-State IG-General		      "
label var v_c04  "State Intergovernmental - C21 Subcode-State IG-Staff			      "
label var v_c05  "State Intergovernmental - C21 Subcode-State IG-Staff Impr		      "
label var v_c06  "State Intergovernmental - C21 Subcode-State IG-Comp/Basic		      "
label var v_c24  "State Intergovernmental - Census State Revenue, NCES Local Revenue	      "
label var v_c30  "State Intergovernmental - General Local Support			      "
label var v_c35  "State Intergovernmental - C21 Subcode-Undistributed-State IG		      "
label var v_c36  "State Intergovernmental - C21 Subcode-Undistributed-Federal		      "
label var v_c38  "State Intergovernmental - State Revenue on Behalf--Emp		      "
label var v_c39  "State Intergovernmental - State Revenue on Behalf--Other		      "
label var v_c42  "State Intergovernmental - Health and Hospitals			      "
label var v_c46  "State Intergovernmental - Highways					      "
label var v_c50  "State Intergovernmental - Housing and Community Development		      "
label var v_c79  "State Intergovernmental - Public Welfare				      "
label var v_c80  "State Intergovernmental - Sewerage					      "
label var v_c89  "State Intergovernmental - All Other					      "
label var v_c91  "State Intergovernmental - Water Utilities				      "
label var v_c92  "State Intergovernmental - Electric Utilities				      "
label var v_c93  "State Intergovernmental - Gas Utilities				      "
label var v_c94  "State Intergovernmental - Transit Utilities				      "
label var v_d30  "Local Intergovernmental - General Support				      "
label var v_d42  "Local Intergovernmental - Health & Hospitals				      "
label var v_d46  "Local Intergovernmental - Highways					      "
label var v_d50  "Local Intergovernmental - Housing and Community Development		      "
label var v_d79  "Local Intergovernmental - Public Welfare				      "
label var v_d80  "Local Intergovernmental - Sewerage					      "
label var v_d89  "Local Intergovernmental - All Other					      "
label var v_d91  "Local Intergovernmental - Water Utilities				      "
label var v_d92  "Local Intergovernmental - Electric Utilities				      "
label var v_d93  "Local Intergovernmental - Gas Utilities				      "
label var v_d94  "Local Intergovernmental - Transit Utilities				      "
label var v_e01  "Current Operations - Air Transportation				      "
label var v_e03  "Current Operations - Miscellaneous Commercial Activities, NEC		      "
label var v_e04  "Current Operations - Correctional Institutions			      "
label var v_e05  "Current Operations - Corrections - Other				      "
label var v_e07  "Current Operations - Instructional Staff Services Exp			      "
label var v_e08  "Current Operations - General Administration Exp			      "
label var v_e22  "Current Operations - Social Insurance Administration			      "
label var v_e23  "Current Operations - Financial Administration				      "
label var v_e24  "Current Operations - Fire Protection					      "
label var v_e25  "Current Operations - Judicial and Legal Services			      "
label var v_e26  "Current Operations - Legislative Services				      "
label var v_e29  "Current Operations - Central Staff Services				      "
label var v_e31  "Current Operations - General Public Buildings				      "
label var v_e32  "Current Operations - Health Services - Other				      "
label var v_e36  "Current Operations - Own Hospitals					      "
label var v_e38  "Current Operations - Other Hospitals					      "
label var v_e44  "Current Operations - Regular Highways					      "
label var v_e45  "Current Operations - Toll Highways					      "
label var v_e47  "Current Operations - Private Transit Subsidies			      "
label var v_e50  "Current Operations - Housing & Community Development			      "
label var v_e52  "Current Operations - Libraries					      "
label var v_e54  "Current Operations - Natural Resources, Agriculture-Other		      "
label var v_e55  "Current Operations - Natural Resources, Fish & Game			      "
label var v_e56  "Current Operations - Natural Resources, Forestry			      "
label var v_e59  "Current Operations - Natural Resources - Other			      "
label var v_e60  "Current Operations - Parking Facilities				      "
label var v_e61  "Current Operations - Parks & Recreation				      "
label var v_e62  "Current Operations - Police Protection				      "
label var v_e66  "Current Operations - Protective Inspection and Regulation,		      "
label var v_e67  "Current Operations - Welfare, Federal Categorical Assistance		      "
label var v_e68  "Current Operations - Welfare, Cash Assistance - Other			      "
label var v_e74  "Current Operations - Welfare, Vendor Payments for Medical		      "
label var v_e75  "Current Operations - Welfare, Vendor Payments for Other		      "
label var v_e77  "Current Operations - Welfare Institutions				      "
label var v_e79  "Current Operations - Welfare - Other					      "
label var v_e80  "Current Operations - Sewerage						      "
label var v_e81  "Current Operations- Solid Waste Management				      "
label var v_e84  "Current Operations - Veterans' Bonuses				      "
label var v_e85  "Current Operations - Other Veterans Services				      "
label var v_e87  "Current Operations - Water Transport and Terminals			      "
label var v_e89  "Current Operations - General - Other					      "
label var v_e90  "Current Operations - Liquor Stores					      "
label var v_e91  "Current Operations - Water Utilities					      "
label var v_e92  "Current Operations - Electric Utilities				      "
label var v_e93  "Current Operations - Gas Utilities					      "
label var v_e94  "Current Operations - Transit Utilities				      "
label var v_f01  "Construction - Air Transportation					      "
label var v_f03  "Construction - Miscellaneous Commercial Activities, NEC		      "
label var v_f04  "Construction - Correctional Institutions				      "
label var v_f05  "Construction - Corrections - Other					      "
label var v_f12  "Construction - Elementary & Secondary Education			      "
label var v_f16  "Construction - Higher Education - Auxiliary Enterprises		      "
label var v_f18  "Construction - Higher Education - Other				      "
label var v_f21  "Construction - Education - Other					      "
label var v_f22  "Construction - Social Insurance Administration			      "
label var v_f23  "Construction - Financial Administration				      "
label var v_f24  "Construction - Fire Protection					      "
label var v_f25  "Construction - Judicial & Legal					      "
label var v_f26  "Construction - Legislative						      "
label var v_f29  "Construction - Central Staff Services					      "
label var v_f31  "Construction - General Public Buildings				      "
label var v_f32  "Construction - Health - Other						      "
label var v_f36  "Construction - Own Hospitals						      "
label var v_f38  "Construction - Hospitals - Other					      "
label var v_f44  "Construction - Regular Highways					      "
label var v_f45  "Construction - Toll Highways						      "
label var v_f50  "Construction - Housing & Community Development			      "
label var v_f52  "Construction - Libraries						      "
label var v_f54  "Construction - Agriculture - Other					      "
label var v_f55  "Construction - Fish & Game						      "
label var v_f56  "Construction - Forestry						      "
label var v_f59  "Construction - Natural Resources - Other				      "
label var v_f60  "Construction - Parking Facilities					      "
label var v_f61  "Construction - Parks & Recreation					      "
label var v_f62  "Construction - Police Protection					      "
label var v_f66  "Construction - Protective Inspection & Regulation, NEC		      "
label var v_f77  "Construction - Welfare Institutions					      "
label var v_f79  "Construction - Welfare - Other					      "
label var v_f80  "Construction - Sewerage						      "
label var v_f81  "Construction - Solid Waste Management					      "
label var v_f85  "Construction - Other Veterans Services				      "
label var v_f87  "Construction - Water Transport & Terminals				      "
label var v_f89  "Construction - General						      "
label var v_f90  "Construction - Liquor Stores						      "
label var v_f91  "Construction - Water Utilities					      "
label var v_f92  "Construction - Electric Utilities					      "
label var v_f93  "Construction - Gas Utilities						      "
label var v_f94  "Construction - Transit Utilities					      "
label var v_g01  "Other Capital Outlay - Air Transportation				      "
label var v_g03  "Other Capital Outlay - Miscellaneous Commercial Activities,		      "
label var v_g04  "Other Capital Outlay - Correctional Institutions			      "
label var v_g05  "Other Capital Outlay - Corrections - Other				      "
label var v_g22  "Other Capital Outlay - Social Insurance Administration		      "
label var v_g23  "Other Capital Outlay - Financial Administration			      "
label var v_g24  "Other Capital Outlay - Fire Protection				      "
label var v_g25  "Other Capital Outlay - Judicial					      "
label var v_g26  "Other Capital Outlay - Legislative					      "
label var v_g29  "Other Capital Outlay - Central Staff					      "
label var v_g31  "Other Capital Outlay - General Public Building			      "
label var v_g32  "Other Capital Outlay - Health - Other					      "
label var v_g36  "Other Capital Outlay - Own Hospitals					      "
label var v_g38  "Other Capital Outlay - Hospitals - Other				      "
label var v_g44  "Other Capital Outlay - Regular Highways				      "
label var v_g45  "Other Capital Outlay - Toll Highways					      "
label var v_g50  "Other Capital Outlay - Housing & Community Development		      "
label var v_g52  "Other Capital Outlay - Libraries					      "
label var v_g54  "Other Capital Outlay - Agriculture - Other				      "
label var v_g55  "Other Capital Outlay - Fish & Game					      "
label var v_g56  "Other Capital Outlay - Forestry					      "
label var v_g59  "Other Capital Outlay - Natural Resource - Other			      "
label var v_g60  "Other Capital Outlay - Parking Facilities				      "
label var v_g61  "Other Capital Outlay - Parks & Recreation				      "
label var v_g62  "Other Capital Outlay - Police Protection				      "
label var v_g66  "Other Capital Outlay - Protective Inspection & Regulation.		      "
label var v_g77  "Other Capital Outlay - Welfare Institutions				      "
label var v_g79  "Other Capital Outlay - Welfare - Other				      "
label var v_g80  "Other Capital Outlay - Sewerage					      "
label var v_g81  "Other Capital Outlay - Solid Waste Management				      "
label var v_g85  "Other Capital Outlay - Other Veterans Services			      "
label var v_g87  "Other Capital Outlay - Water Transport and Terminals			      "
label var v_g89  "Other Capital Outlay - General - Other				      "
label var v_g90  "Other Capital Outlay - Liquor Stores					      "
label var v_g91  "Other Capital Outlay - Water Utilities				      "
label var v_g92  "Other Capital Outlay - Electric Utilities				      "
label var v_g93  "Other Capital Outlay - Gas Utilities					      "
label var v_g94  "Other Capital Outlay - Transit Utilities				      "
label var v_i91  "Water Utilities - Interest on Debt					      "
label var v_i92  "Electric Utilities - Interest on Debt					      "
label var v_i93  "Gas Utilities - Interest on Debt					      "
label var v_i94  "Transit Utilities - Interest on Debt					      "
label var v_k01  "Equipment Only - Air Transportation					      "
label var v_k03  "Equipment Only - Miscellaneous Commercial Activities, NEC		      "
label var v_k04  "Equipment Only - Correctional Institutions				      "
label var v_k05  "Equipment Only - Correction - Other					      "
label var v_k09  "Equipment Only - G12 Subcode-Instructional				      "
label var v_k10  "Equipment Only - G12 Subcode-Other					      "
label var v_k11  "Equipment Only - G12 Subcode-Undistributed				      "
label var v_k12  "Equipment Only - G12 Subcode						      "
label var v_k22  "Equipment Only - Social Insurance Administration			      "
label var v_k23  "Equipment Only - Financial Administration				      "
label var v_k24  "Equipment Only - Fire Protection					      "
label var v_k25  "Equipment Only - Judicial and Legal					      "
label var v_k26  "Equipment Only - Legislative						      "
label var v_k29  "Equipment Only - Central Staff Services				      "
label var v_k31  "Equipment Only - General Public Building				      "
label var v_k32  "Equipment Only - Health - Other					      "
label var v_k36  "Equipment Only - Own Hospitals					      "
label var v_k38  "Equipment Only - Hospitals - Other					      "
label var v_k44  "Equipment Only - Regular Highways					      "
label var v_k45  "Equipment Only - Toll Highways					      "
label var v_k50  "Equipment Only - Housing & Community Development			      "
label var v_k52  "Equipment Only - Libraries						      "
label var v_k54  "Equipment Only - Agriculture - Other					      "
label var v_k55  "Equipment Only - Fish & Game						      "
label var v_k56  "Equipment Only - Forestry						      "
label var v_k59  "Equipment Only - Natural Resources - Other				      "
label var v_k60  "Equipment Only - Parking Facilities					      "
label var v_k61  "Equipment Only - Parks & Recreation					      "
label var v_k62  "Equipment Only - Police Protection					      "
label var v_k66  "Equipment Only - Protective Inspection and Regulation, NEC		      "
label var v_k77  "Equipment Only - Welfare Institutions					      "
label var v_k79  "Equipment Only - Welfare - Other					      "
label var v_k80  "Equipment Only - Sewerage						      "
label var v_k81  "Equipment Only - Solid Waste Management				      "
label var v_k85  "Equipment Only - Other Veterans Services				      "
label var v_k87  "Equipment Only - Water Transport & Terminals				      "
label var v_k89  "Equipment Only - General - Other					      "
label var v_k90  "Equipment Only - Liquor Stores					      "
label var v_k91  "Equipment Only - Water Utilities					      "
label var v_k92  "Equipment Only - Electric Utilities					      "
label var v_k93  "Equipment Only - Gas Utilities					      "
label var v_k94  "Equipment Only - Transit Utilities					      "
label var v_l01  "Intergovernmental to State - Air Transportation			      "
label var v_l05  "Intergovernmental to State - Other Corrections			      "
label var v_l12  "Intergovernmental to State - Elementary & Secondary Education		      "
label var v_l18  "Intergovernmental to State - Other Higher Education			      "
label var v_l23  "Intergovernmental to State - Financial Administration			      "
label var v_l24  "Intergovernmental to State - Fire Protection				      "
label var v_l25  "Intergovernmental to State - Judicial and Legal			      "
label var v_l29  "Intergovernmental to State - Central Staff Services			      "
label var v_l32  "Intergovernmental to State - Other Health				      "
label var v_l38  "Intergovernmental to State - Other Hospitals				      "
label var v_l44  "Intergovernmental to State - Regular Highways				      "
label var v_l50  "Intergovernmental to State - Housing & Community Development		      "
label var v_l52  "Intergovernmental to State - Libraries				      "
label var v_l59  "Intergovernmental to State - Other Natural Resources			      "
label var v_l61  "Intergovernmental to State - Parks and Recreation			      "
label var v_l62  "Intergovernmental to State - Police Protection			      "
label var v_l66  "Intergovernmental to State - Protective Inspection &			      "
label var v_l67  "Intergovernmental to State - Federal Categorical Assistance		      "
label var v_l79  "Intergovernmental to State - Public Welfare				      "
label var v_l80  "Intergovernmental to State - Sewerage					      "
label var v_l81  "Intergovernmental to State - Solid Waste Management			      "
label var v_l87  "Intergovernmental to State - Water Transport & Terminals		      "
label var v_l89  "Intergovernmental to State - Other and Unallocable			      "
label var v_l91  "Intergovernmental to State - Water Utilities				      "
label var v_l92  "Intergovernmental to State - Electrical Utilities			      "
label var v_l93  "Intergovernmental to State - Gas Utilities				      "
label var v_l94  "Intergovernmental to State - Transit Utilities			      "
label var v_m01  "Intergovernmental to Local NEC - Air Transportation			      "
label var v_m05  "Intergovernmental to Local NEC - Corrections				      "
label var v_m23  "Intergovernmental to Local NEC - Financial Administration		      "
label var v_m24  "Intergovernmental to Local NEC - Fire Protection			      "
label var v_m25  "Intergovernmental to Local NEC - Judicial and Legal			      "
label var v_m29  "Intergovernmental to Local NEC - Central Staff Services		      "
label var v_m30  "Intergovernmental to Local NEC - General Support			      "
label var v_m32  "Intergovernmental to Local NEC - Health				      "
label var v_m38  "Intergovernmental to Local NEC - Hospitals				      "
label var v_m44  "Intergovernmental to Local NEC - Regular Highways			      "
label var v_m50  "Intergovernmental to Local NEC - Housing & Community			      "
label var v_m52  "Intergovernmental to Local NEC - Libraries				      "
label var v_m54  "Intergovernmental to Local NEC - Agriculture				      "
label var v_m55  "Intergovernmental to Local NEC - Fish & Game				      "
label var v_m56  "Intergovernmental to Local NEC - Forestry				      "
label var v_m59  "Intergovernmental to Local NEC - Natural Resources			      "
label var v_m60  "Intergovernmental to Local NEC - Parking Facilities			      "
label var v_m61  "Intergovernmental to Local NEC - Parks & Recreation			      "
label var v_m62  "Intergovernmental to Local NEC - Police Protection			      "
label var v_m66  "Intergovernmental to Local NEC - Protective Inspection &		      "
label var v_m67  "Intergovernmental to Local NEC - Welfare - Categorical Assistance Programs  "
label var v_m79  "Intergovernmental to Local NEC - Welfare				      "
label var v_m80  "Intergovernmental to Local NEC - Sewerage				      "
label var v_m81  "Intergovernmental to Local NEC - Solid Waste Management		      "
label var v_m87  "Intergovernmental to Local NEC - Water Transport & Terminals		      "
label var v_m89  "Intergovernmental to Local NEC - General				      "
label var v_m91  "Intergovernmental to Local NEC - Water Utilities			      "
label var v_m92  "Intergovernmental to Local NEC - Electric Utilities			      "
label var v_m93  "Intergovernmental to Local NEC - Gas Utilities			      "
label var v_m94  "Intergovernmental to Local NEC - Transit Utilities			      "
label var v_n01  "Intergovernmental to General Purpose - Air Transportation		      "
label var v_n05  "Intergovernmental to General Purpose - Corrections			      "
label var v_n23  "Intergovernmental to General Purpose - Financial Administration	      "
label var v_n25  "Intergovernmental to General Purpose - Judicial and Legal		      "
label var v_n29  "Intergovernmental to General Purpose - Central Staff Services		      "
label var v_n30  "Intergovernmental to General Purpose - General Support		      "
label var v_n32  "Intergovernmental to General Purpose - Health - Other			      "
label var v_n38  "Intergovernmental to General Purpose - Hospitals - Other		      "
label var v_n44  "Intergovernmental to General Purpose - Regular Highways		      "
label var v_n50  "Intergovernmental to General Purpose - Housing & Community development      "
label var v_n52  "Intergovernmental to General Purpose - Libraries			      "
label var v_n54  "Intergovernmental to General Purpose - Agriculture - Other		      "
label var v_n55  "Intergovernmental to General Purpose - Fish & Game			      "
label var v_n56  "Intergovernmental to General Purpose - Forestry			      "
label var v_n59  "Intergovernmental to General Purpose - Natural Resources		      "
label var v_n61  "Intergovernmental to General Purpose - Parks & Recreation		      "
label var v_n62  "Intergovernmental to General Purpose - Police Protection		      "
label var v_n66  "Intergovernmental to General Purpose - Protective Inspection and Regulation "
label var v_n67  "Intergovernmental to General Purpose - Welfare - Categorical Assistance Pro "
label var v_n68  "Intergovernmental to General Purpose - Welfare - Cash Assistance Programs   "
label var v_n79  "Intergovernmental to General Purpose - Welfare - Other		      "
label var v_n80  "Intergovernmental to General Purpose - Sewerage			      "
label var v_n81  "Intergovernmental to General Purpose - Solid Waste Management		      "
label var v_n87  "Intergovernmental to General Purpose - Water Transport & Terminals	      "
label var v_n89  "Intergovernmental to General Purpose - General - Other		      "
label var v_n92  "Intergovernmental to General Purpose - Electric Utilities		      "
label var v_n94  "Intergovernmental to General Purpose - Transit Utilities		      "
label var v_r01  "Intergovernmental to Special District - Air Transportation		      "
label var v_r30  "Intergovernmental to Special District - General Support		      "
label var v_r32  "Intergovernmental to Special District - Health - Other		      "
label var v_r38  "Intergovernmental to Special District - Hospitals - Other		      "
label var v_r44  "Intergovernmental to Special District - Regular Highways		      "
label var v_r50  "Intergovernmental to Special District - Housing & Community		      "
label var v_r52  "Intergovernmental to Special District - Libraries			      "
label var v_r54  "Intergovernmental to Special District - Agriculture - Other		      "
label var v_r55  "Intergovernmental to Special District - Fish & Game			      "
label var v_r59  "Intergovernmental to Special District - Natural Resources		      "
label var v_r61  "Intergovernmental to Special District - Parks & Recreation		      "
label var v_r62  "Intergovernmental to Special District - Police Protection		      "
label var v_r66  "Intergovernmental to Special District - Protective Inspection and Regulatio "
label var v_r79  "Intergovernmental to Special District - Welfare - Other		      "
label var v_r80  "Intergovernmental to Special District - Sewerage			      "
label var v_r81  "Intergovernmental to Special District - Solid Waste			      "
label var v_r87  "Intergovernmental to Special District - Water Transport and Terminals	      "
label var v_r89  "Intergovernmental to Special District - General - Other		      "
label var v_r92  "Intergovernmental to Special District - Electric Utilities		      "
label var v_r94  "Intergovernmental to Special District - Transit Utilities		      "
label var v_s67  "Intergovernmental to Federal - Welfare - Categorical Assistance Programs    "
label var v_s89  "Intergovernmental to Federal - General - Other			      "
label var v_t01  "Tax - Property							      "
label var v_t02  "Taxes - Parent Government Contribution-Elementary Secondary		      "
label var v_t04  "Taxes - T01 Subcode-Property Tax-Higher Education			      "
label var v_t05  "Taxes - Parent Government Contribution-Higher Education		      "
label var v_t06  "Taxes - T01 Subcode-Property Tax-Elementary/Secondary			      "
label var v_t09  "Tax - Total General Sales						      "
label var v_t10  "Tax - Alcoholic Beverage Sales					      "
label var v_t11  "Tax - Amusement							      "
label var v_t12  "Tax - Insurance Premiums						      "
label var v_t13  "Tax - Motor Fuels Sales						      "
label var v_t14  "Tax - Pari-mutuels							      "
label var v_t15  "Tax - Public Utilities						      "
label var v_t16  "Tax - Tobacco Sales							      "
label var v_t19  "Tax - Other Selective Sales						      "
label var v_t20  "Tax - Alcoholic Beverage License					      "
label var v_t21  "Tax - Amusement License						      "
label var v_t22  "Tax - Corporation License						      "
label var v_t23  "Tax - Hunting & Fishing License					      "
label var v_t24  "Tax - Motor Vehicle License						      "
label var v_t25  "Tax - Motor Vehicle Operators License					      "
label var v_t27  "Tax - Public Utility License						      "
label var v_t28  "Tax - Occupation & Business License, NEC				      "
label var v_t29  "Tax - Other License							      "
label var v_t40  "Tax - Individual Income						      "
label var v_t41  "Tax - Corporation Net Income						      "
label var v_t50  "Tax - Death & Gift							      "
label var v_t51  "Tax - Documentary & Stock Transfer					      "
label var v_t53  "Tax - Severance							      "
label var v_t99  "Tax - NEC								      "
label var v_u01  "Miscellaneous - Special Assessments					      "
label var v_u10  "Miscellaneous - Housing and Community Development Sale		      "
label var v_u11  "Miscellaneous - Property Sale Other					      "
label var v_u20  "Miscellaneous - Interest Earnings					      "
label var v_u30  "Miscellaneous - Fines & Forfeits					      "
label var v_u40  "Miscellaneous - Rents							      "
label var v_u41  "Miscellaneous - Royalties						      "
label var v_u50  "Miscellaneous - Donations From Private Sources			      "
label var v_u95  "Miscellaneous - Net Lottery Revenue					      "
label var v_u99  "Miscellaneous - General Revenue, NEC					      "
label var v_v10  "Elementary/Secondary Inst-Employee Benefits				      "
label var v_v11  "Elementary/Secondary Support Service Pupil-Salaries			      "
label var v_v12  "Elementary/Secondary Support Service Pupil-Employee Benefits		      "
label var v_v13  "Elementary/Secondary Support Service Instructional Staff		      "
label var v_v14  "Elementary/Secondary Support Service Instructional Staff-Emp. Benefi	      "
label var v_v15  "Elementary/Secondary Support Service General Admin-Salaries		      "
label var v_v16  "Elementary/Secondary Support Service General Admin-Emp.		      "
label var v_v17  "Elementary/Secondary Support Service School Admin-Salaries		      "
label var v_v18  "Elementary/Secondary Support Service School Admin-Emp.		      "
label var v_v19  "Elementary/Secondary Support Service Business-Salaries		      "
label var v_v20  "Elementary/Secondary Support Service Business-Emp. Benefits		      "
label var v_v21  "Elementary/Secondary Support Service Plant Operations			      "
label var v_v22  "Elementary/Secondary Support Service Plant Operations			      "
label var v_v23  "Elementary/Secondary Support Service Student Trans-Salaries		      "
label var v_v24  "Elementary/Secondary Support Service Student Trans			      "
label var v_v25  "Elementary/Secondary Support Service Central-Salaries			      "
label var v_v26  "Elementary/Secondary Support Service Central-Emp Benefits		      "
label var v_v27  "Elementary/Secondary Support Service Other-Salaries			      "
label var v_v28  "Elementary/Secondary Support Service Central-Emp Benefits		      "
label var v_v29  "Elementary/Secondary Food Service-Salaries				      "
label var v_v30  "Elementary/Secondary Food Service-Emp Benefits			      "
label var v_v32  "Elementary/Secondary Enterprise Operations-Salaries			      "
label var v_z32  "Elementary/Secondary Salaries-Total Subcode Z00			      "
label var v_z33  "Elementary/Secondary Salaries-Instructional Subcode Z00		      "
label var v_z34  "Elementary/Secondary Total Employee Benefits				      "
label var v_z41  "Liquor Stores - Net Sales						      "
label var v_z42  "Liquor Stores - Cost of Goods						      "
label var v_z43  "Liquor Stores - Operating Expenditures				      "
label var v_z44  "Liquor Stores - Other Income						      "
label var v_z46  "Liquor Stores - Transfer to General Funds				      "




* Tot general revenue

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

egen aux_9=rsum(v_t09)

egen other_tax=rsum(v_t*)
replace other_tax=other_tax-prop_tax-aux_9



drop aux*




compress
save "C:\Users\HW462587\Documents\Leah\Data\census_gov\1992\city_finances92", replace

