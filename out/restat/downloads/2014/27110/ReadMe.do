
// ReadMe Stata Routines for Replicating Results of Fernandes, A. and C. Paunov, The Risks of Innovation: Are Innovating Firms Less Likely to Die? 

// Data 

// The paper has been exempted from the data requirement. The Chilean plant-level manufacturing census and the products datasets used in our paper 
// are proprietary, they were purchased by the World Bank Research Department from the Chilean statistical institute INE with the agreement that 
// they would not freely disseminated. 
// The contact person at INE from whom another individual researcher or another institution can obtain the data is:
//    Bartolomé Payeras 
//    Tel: (562) 366-7502
//    Email: bartolome.payeras@ine.cl

// A fake dataset is provided to allow running the codes that obtain variables needed for the regressions. Note that it will not allow reproducing
// fake regression results for which the original dataset will be needed. The fake dataset does not work for obtaining fake proximity measures either
// as the full number of observations required is insufficient.  

// In the paper we also use COMTRADE data for 1996-2003 to compute the product proximity indicator used in Column 3 of Table 5. The computed proximity indicator pairs 
// are provided jointly with the do-files. They are obtained following the Program File ProximityIndicators_Step1.do. 

// Software Used

// The results reported were obtained using Stata Version 11

// Explanation of Files Provided

// ProximityIndicators_Step1.do and ProximityIndicatorsStep2: Produces the proximity data needed for Column 3 of Table 5. 
// ProductData.do: Produces the following variables at the product level: 
		//d_inno_mul_7 d_inno_mul_6 d_add_any_7 d_add_any_6 multi_prod multi_prod_at_1 n_herf_6d d_sales_ind6 inno_ind6 n2_herf_6d 
		//d_add_X_7 d_add_nX_7 inno7_sin10 inno7_nsin10 add_sh50 entry_rate6 K_intense6 ad_sales6 av_wage6
// BaselineData.do: Produces the following variables for analysis (as well as adding in product variables for the regressions): 
        //firm_exit d_add_any_7 d_FDI d_exp av_wage6 ad_sales6 K_intense6 entry_rate6 d_add_any_6 d_inno_mul_7 d_inno_mul_6 av_sales1 
		// firm_size tot_workers2 K_intensity multi_plant firm_age79 firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age 
		// multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 region year industry2_4 surv6 add_sh50 crisis_year d_add_X_7  
		// d_add_nX_7 d_add_any_7_invm2 d_add_any_7_ninvm2 d_add7_forM d_add7_nforM d_add_any_7_sin d_add_any_7_mul d_add_prox d_add_nprox
		// inno7_nsin10 inno7_sin10 inno7_std5_small inno7_std5_big lprod_wind1 profit1_rate_w1 multi_prod lprod
// ResultsTables.do: Produces Tables 2-7 and Appendix Tables 1-2. 
