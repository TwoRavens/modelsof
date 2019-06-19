#delimit;
clear;
set memory 300m;

use "C:\Documents and Settings\Krishna Patel\My Documents\New Immigrant Survey\k_adult.dta";

sort pu_id;
save "C:\Documents and Settings\Krishna Patel\My Documents\New Immigrant Survey\k_adult.dta", replace;
clear;


use "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS\nis_abck.dta", replace;

keep pu_id b75  c20a_1  state_usimmig;
sort pu_id;

merge pu_id using "C:\Documents and Settings\Krishna Patel\My Documents\New Immigrant Survey\k_adult.dta";

generate 	b78state	 = 	k8_1mo	 if 	k4_1	<=	b75	 & b75<10000000 & 	k4_1 	<10000	;
replace 	b78state	 = 	k8_2mo	 if 	k4_2	<=	b75	 & b75<10000000 & 	k4_2	<10000	;
replace 	b78state	 = 	k8_3mo	 if 	k4_3	<=	b75	 & b75<10000000 & 	k4_3	<10000	;
replace 	b78state	 = 	k8_4mo	 if 	k4_4	<=	b75	 & b75<10000000 & 	k4_4	<10000	;
replace 	b78state	 = 	k8_5mo	 if 	k4_5	<=	b75	 & b75<10000000 & 	k4_5	<10000	;
replace 	b78state	 = 	k8_6mo	 if 	k4_6	<=	b75	 & b75<10000000 & 	k4_6	<10000	;
replace 	b78state	 = 	k8_7mo	 if 	k4_7	<=	b75	 & b75<10000000 & 	k4_7	<10000	;
replace 	b78state	 = 	k8_8mo	 if 	k4_8	<=	b75	 & b75<10000000 & 	k4_8	<10000	;
replace 	b78state	 = 	k8_9mo	 if 	k4_9	<=	b75	 & b75<10000000 & 	k4_9	<10000	;
replace 	b78state	 = 	k8_10mo	 if 	k4_10	<=	b75	 & b75<10000000 & 	k4_10	<10000	;
replace 	b78state	 = 	k8_11mo	 if 	k4_11	<=	b75	 & b75<10000000 & 	k4_11	<10000	;
replace 	b78state	 = 	k8_12mo	 if 	k4_12	<=	b75	 & b75<10000000 & 	k4_12	<10000	;
replace 	b78state	 = 	k8_13mo	 if 	k4_13	<=	b75	 & b75<10000000 & 	k4_13	<10000	;
replace 	b78state	 = 	k8_14mo	 if 	k4_14	<=	b75	 & b75<10000000 & 	k4_14	<10000	;
replace 	b78state	 = 	k8_15mo	 if 	k4_15	<=	b75	 & b75<10000000 & 	k4_15	<10000	;
replace 	b78state	 = 	k8_16mo	 if 	k4_16	<=	b75	 & b75<10000000 & 	k4_16	<10000	;
replace 	b78state	 = 	k8_17mo	 if 	k4_17	<=	b75	 & b75<10000000 & 	k4_17	<10000	;
replace 	b78state	 = 	k8_18mo	 if 	k4_18	<=	b75	 & b75<10000000 & 	k4_18	<10000	;
replace 	b78state	 = 	k8_19mo	 if 	k4_19	<=	b75	 & b75<10000000 & 	k4_19	<10000	;
replace 	b78state	 = 	k8_20mo	 if 	k4_20	<=	b75	 & b75<10000000 & 	k4_20	<10000	;
replace 	b78state	 = 	k8_21mo	 if 	k4_21	<=	b75	 & b75<10000000 & 	k4_21	<10000	;
replace 	b78state	 = 	k8_22mo	 if 	k4_22	<=	b75	 & b75<10000000 & 	k4_22	<10000	;
replace 	b78state	 = 	k8_23mo	 if 	k4_23	<=	b75	 & b75<10000000 & 	k4_23	<10000	;
replace 	b78state	 = 	k8_24mo	 if 	k4_24	<=	b75	 & b75<10000000 & 	k4_24	<10000	;
replace 	b78state	 = 	k8_25mo	 if 	k4_25	<=	b75	 & b75<10000000 & 	k4_25	<10000	;
replace 	b78state	 = 	k8_26mo	 if 	k4_26	<=	b75	 & b75<10000000 & 	k4_26	<10000	;
replace 	b78state	 = 	k8_27mo	 if 	k4_27	<=	b75	 & b75<10000000 & 	k4_27	<10000	;
replace 	b78state	 = 	k8_28mo	 if 	k4_28	<=	b75	 & b75<10000000 & 	k4_28	<10000	;
replace 	b78state	 = 	k8_29mo	 if 	k4_29	<=	b75	 & b75<10000000 & 	k4_29	<10000	;


generate 	c18state	 = 	k8_1mo	 if 	k4_1	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_1 	<10000	;
replace 	c18state	 = 	k8_2mo	 if 	k4_2	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_2	<10000	;
replace 	c18state	 = 	k8_3mo	 if 	k4_3	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_3	<10000	;
replace 	c18state	 = 	k8_4mo	 if 	k4_4	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_4	<10000	;
replace 	c18state	 = 	k8_5mo	 if 	k4_5	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_5	<10000	;
replace 	c18state	 = 	k8_6mo	 if 	k4_6	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_6	<10000	;
replace 	c18state	 = 	k8_7mo	 if 	k4_7	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_7	<10000	;
replace 	c18state	 = 	k8_8mo	 if 	k4_8	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_8	<10000	;
replace 	c18state	 = 	k8_9mo	 if 	k4_9	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_9	<10000	;
replace 	c18state	 = 	k8_10mo	 if 	k4_10	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_10	<10000	;
replace 	c18state	 = 	k8_11mo	 if 	k4_11	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_11	<10000	;
replace 	c18state	 = 	k8_12mo	 if 	k4_12	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_12	<10000	;
replace 	c18state	 = 	k8_13mo	 if 	k4_13	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_13	<10000	;
replace 	c18state	 = 	k8_14mo	 if 	k4_14	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_14	<10000	;
replace 	c18state	 = 	k8_15mo	 if 	k4_15	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_15	<10000	;
replace 	c18state	 = 	k8_16mo	 if 	k4_16	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_16	<10000	;
replace 	c18state	 = 	k8_17mo	 if 	k4_17	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_17	<10000	;
replace 	c18state	 = 	k8_18mo	 if 	k4_18	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_18	<10000	;
replace 	c18state	 = 	k8_19mo	 if 	k4_19	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_19	<10000	;
replace 	c18state	 = 	k8_20mo	 if 	k4_20	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_20	<10000	;
replace 	c18state	 = 	k8_21mo	 if 	k4_21	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_21	<10000	;
replace 	c18state	 = 	k8_22mo	 if 	k4_22	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_22	<10000	;
replace 	c18state	 = 	k8_23mo	 if 	k4_23	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_23	<10000	;
replace 	c18state	 = 	k8_24mo	 if 	k4_24	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_24	<10000	;
replace 	c18state	 = 	k8_25mo	 if 	k4_25	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_25	<10000	;
replace 	c18state	 = 	k8_26mo	 if 	k4_26	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_26	<10000	;
replace 	c18state	 = 	k8_27mo	 if 	k4_27	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_27	<10000	;
replace 	c18state	 = 	k8_28mo	 if 	k4_28	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_28	<10000	;
replace 	c18state	 = 	k8_29mo	 if 	k4_29	<=	 c20a_1	 &  c20a_1<10000000 & 	k4_29	<10000	;


keep pu_id b78state c18state;
sort pu_id;

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS\nis_occstate.dta", replace;
