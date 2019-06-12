clearset mem 80mset matsize 800set more off
# delimit;use "C:\Research\isqminor.dta";
hetprob init gov d_un d_inf d_gro du_gov di_gov dg_gov cap_1 ipeace, het(gov d_inf di_gov d_un du_gov d_gro dg_gov cap_1) robust cluster(dyad);

***generate figure with CI intervals***;preserve;drawnorm MG_b1-MG_b18, n(10000) means(e(b)) cov(e(V)) clear;postutil clear;postfile mypost prob_hatlo lo0 hi0 prob_hathi lo1 hi1 prob_hatz loz hiz using "C:\Research\isqCI.dta", replace;noisily display "start";local a=-50;while `a' <=50{;{;scalar h_gov=(`a');scalar h_d_un=0;scalar h_d_inf=-0.015;scalar h_d_gro=0;scalar h_du_gov=0; scalar h_di_gov=-0.015;
scalar h_dg_gov=0;
scalar h_cap_1=.0068737;scalar h_ipeace=69.0212;scalar h_constant=1;
scalar g_gov=(`a');
scalar g_d_inf=-0.015;
scalar g_di_gov=-0.015;
scalar g_d_un=0;
scalar g_du_gov=0;
scalar g_d_gro=0;
scalar g_dg_gov=0;
scalar g_cap_1=.0068737;generate x_betahatlo = MG_b1*(`a')					+ MG_b2*h_d_un					+ MG_b3*h_d_inf					+ MG_b4*h_d_gro 					+ MG_b5*h_du_gov 					+ MG_b6*h_di_gov*(`a')					+ MG_b7*h_dg_gov 					+ MG_b8*h_cap_1 					+ MG_b9*h_ipeace					+ MG_b10*h_constant;					generate x_betahathi = MG_b1*(`a')					+ MG_b2*h_d_un					+ MG_b3*(h_d_inf+0.03)					+ MG_b4*h_d_gro 					+ MG_b5*h_du_gov 					+ MG_b6*(h_di_gov+0.03)*(`a')					+ MG_b7*h_dg_gov 					+ MG_b8*h_cap_1 					+ MG_b9*h_ipeace					+ MG_b10*h_constant;

generate x_betahatz = MG_b1*(`a')					+ MG_b2*h_d_un					+ MG_b3*(h_d_inf*0)					+ MG_b4*h_d_gro 					+ MG_b5*h_du_gov 					+ MG_b6*(h_di_gov*0)*(`a')					+ MG_b7*h_dg_gov 					+ MG_b8*h_cap_1 					+ MG_b9*h_ipeace					+ MG_b10*h_constant;

generate z_gammalo = MG_b11*(`a')
					+ MG_b12*g_d_inf
					+ MG_b13*g_di_gov*(`a')
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

generate z_gammahi = MG_b11*(`a')
					+ MG_b12*(g_d_inf+0.03)
					+ MG_b13*(g_di_gov+0.03)*(`a')
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

generate z_gammaz = MG_b11*(`a')
					+ MG_b12*(g_d_inf*0)
					+ MG_b13*(g_di_gov*0)*(`a')
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

gen prob0=normprob(x_betahatlo/(exp(z_gammalo)));gen prob1=normprob(x_betahathi/(exp(z_gammahi)));
gen probz=normprob(x_betahatz/(exp(z_gammaz)));egen probhat0=mean(prob0);egen probhat1=mean(prob1);egen probhatz=mean(probz);tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hatz loz hiz;_pctile prob0, p(2.5, 97.5);scalar `lo0' = r(r1);scalar `hi0' = r(r2);_pctile prob1, p(2.5, 97.5);scalar `lo1' = r(r1);scalar `hi1' = r(r2);_pctile probz, p(2.5, 97.5);scalar `loz' = r(r1);scalar `hiz' = r(r2);scalar `prob_hat0'=probhat0;scalar `prob_hat1'=probhat1;scalar `prob_hatz'=probhatz;post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 			(`prob_hatz') (`loz') (`hiz');};drop x_betahatlo x_betahathi x_betahatz z_gammalo z_gammahi z_gammaz prob0 prob1 probz probhat0 probhat1 probhatz;local a=`a'+1;display "." _c;};display "";postclose mypost;
