* This file calculated AMP reliability for Study 3 of Ryan,
* "How Do Indifferent Voters Decide" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

use "anes2008_2009panel_dataset.dta", clear

/* The approach here is to construct random pairs of individual AMP responses.
Each Obama item is paired with a randomly selected McCain item. (Randomization 
was done externally.) There are 24 pairs for each wave. Each pair is coded as
exhibiting a preference for McCain (McCain rated pleasant and Obama rated unpleasant, item=1)
a preference for Obama (Obama rated pleasant and McCain rated unpleasant, item=-1), or an
inconsistent preference (both candidates rated pleasant or both rated unpleasant, item=0).
Then, you calculate an alpha coefficient across all pairs. (End of this file.)
*/

gen w9item1 = .
replace w9item1 = 1 if (w9amp_q2_face42_choice==1 & w9amp_q2_face1_choice==2)
replace w9item1 = 0 if (w9amp_q2_face42_choice==1 & w9amp_q2_face1_choice==1)
replace w9item1 = 0 if (w9amp_q2_face42_choice==2 & w9amp_q2_face1_choice==2)
replace w9item1 = -1 if (w9amp_q2_face42_choice==2 & w9amp_q2_face1_choice==1)

gen w9item2 = .
replace w9item2 = 1 if (w9amp_q2_face45_choice==1 & w9amp_q2_face2_choice==2)
replace w9item2 = 0 if (w9amp_q2_face45_choice==1 & w9amp_q2_face2_choice==1)
replace w9item2 = 0 if (w9amp_q2_face45_choice==2 & w9amp_q2_face2_choice==2)
replace w9item2 = -1 if (w9amp_q2_face45_choice==2 & w9amp_q2_face2_choice==1)

gen w9item3 = .
replace w9item3 = 1 if (w9amp_q2_face29_choice==1 & w9amp_q2_face3_choice==2)
replace w9item3 = 0 if (w9amp_q2_face29_choice==1 & w9amp_q2_face3_choice==1)
replace w9item3 = 0 if (w9amp_q2_face29_choice==2 & w9amp_q2_face3_choice==2)
replace w9item3 = -1 if (w9amp_q2_face29_choice==2 & w9amp_q2_face3_choice==1)

gen w9item4 = .
replace w9item4 = 1 if (w9amp_q2_face48_choice==1 & w9amp_q2_face4_choice==2)
replace w9item4 = 0 if (w9amp_q2_face48_choice==1 & w9amp_q2_face4_choice==1)
replace w9item4 = 0 if (w9amp_q2_face48_choice==2 & w9amp_q2_face4_choice==2)
replace w9item4 = -1 if (w9amp_q2_face48_choice==2 & w9amp_q2_face4_choice==1)

gen w9item5 = .
replace w9item5 = 1 if (w9amp_q2_face26_choice==1 & w9amp_q2_face5_choice==2)
replace w9item5 = 0 if (w9amp_q2_face26_choice==1 & w9amp_q2_face5_choice==1)
replace w9item5 = 0 if (w9amp_q2_face26_choice==2 & w9amp_q2_face5_choice==2)
replace w9item5 = -1 if (w9amp_q2_face26_choice==2 & w9amp_q2_face5_choice==1)

gen w9item6 = .
replace w9item6 = 1 if (w9amp_q2_face27_choice==1 & w9amp_q2_face6_choice==2)
replace w9item6 = 0 if (w9amp_q2_face27_choice==1 & w9amp_q2_face6_choice==1)
replace w9item6 = 0 if (w9amp_q2_face27_choice==2 & w9amp_q2_face6_choice==2)
replace w9item6 = -1 if (w9amp_q2_face27_choice==2 & w9amp_q2_face6_choice==1)

gen w9item7 = .
replace w9item7 = 1 if (w9amp_q2_face35_choice==1 & w9amp_q2_face7_choice==2)
replace w9item7 = 0 if (w9amp_q2_face35_choice==1 & w9amp_q2_face7_choice==1)
replace w9item7 = 0 if (w9amp_q2_face35_choice==2 & w9amp_q2_face7_choice==2)
replace w9item7 = -1 if (w9amp_q2_face35_choice==2 & w9amp_q2_face7_choice==1)

gen w9item8 = .
replace w9item8 = 1 if (w9amp_q2_face36_choice==1 & w9amp_q2_face8_choice==2)
replace w9item8 = 0 if (w9amp_q2_face36_choice==1 & w9amp_q2_face8_choice==1)
replace w9item8 = 0 if (w9amp_q2_face36_choice==2 & w9amp_q2_face8_choice==2)
replace w9item8 = -1 if (w9amp_q2_face36_choice==2 & w9amp_q2_face8_choice==1)

gen w9item9 = .
replace w9item9 = 1 if (w9amp_q2_face38_choice==1 & w9amp_q2_face9_choice==2)
replace w9item9 = 0 if (w9amp_q2_face38_choice==1 & w9amp_q2_face9_choice==1)
replace w9item9 = 0 if (w9amp_q2_face38_choice==2 & w9amp_q2_face9_choice==2)
replace w9item9 = -1 if (w9amp_q2_face38_choice==2 & w9amp_q2_face9_choice==1)

gen w9item10 = .
replace w9item10 = 1 if (w9amp_q2_face44_choice==1 & w9amp_q2_face10_choice==2)
replace w9item10 = 0 if (w9amp_q2_face44_choice==1 & w9amp_q2_face10_choice==1)
replace w9item10 = 0 if (w9amp_q2_face44_choice==2 & w9amp_q2_face10_choice==2)
replace w9item10 = -1 if (w9amp_q2_face44_choice==2 & w9amp_q2_face10_choice==1)

gen w9item11 = .
replace w9item11 = 1 if (w9amp_q2_face41_choice==1 & w9amp_q2_face11_choice==2)
replace w9item11 = 0 if (w9amp_q2_face41_choice==1 & w9amp_q2_face11_choice==1)
replace w9item11 = 0 if (w9amp_q2_face41_choice==2 & w9amp_q2_face11_choice==2)
replace w9item11 = -1 if (w9amp_q2_face41_choice==2 & w9amp_q2_face11_choice==1)

gen w9item12 = .
replace w9item12 = 1 if (w9amp_q2_face43_choice==1 & w9amp_q2_face12_choice==2)
replace w9item12 = 0 if (w9amp_q2_face43_choice==1 & w9amp_q2_face12_choice==1)
replace w9item12 = 0 if (w9amp_q2_face43_choice==2 & w9amp_q2_face12_choice==2)
replace w9item12 = -1 if (w9amp_q2_face43_choice==2 & w9amp_q2_face12_choice==1)

gen w9item13 = .
replace w9item13 = 1 if (w9amp_q2_face47_choice==1 & w9amp_q2_face13_choice==2)
replace w9item13 = 0 if (w9amp_q2_face47_choice==1 & w9amp_q2_face13_choice==1)
replace w9item13 = 0 if (w9amp_q2_face47_choice==2 & w9amp_q2_face13_choice==2)
replace w9item13 = -1 if (w9amp_q2_face47_choice==2 & w9amp_q2_face13_choice==1)

gen w9item14 = .
replace w9item14 = 1 if (w9amp_q2_face32_choice==1 & w9amp_q2_face14_choice==2)
replace w9item14 = 0 if (w9amp_q2_face32_choice==1 & w9amp_q2_face14_choice==1)
replace w9item14 = 0 if (w9amp_q2_face32_choice==2 & w9amp_q2_face14_choice==2)
replace w9item14 = -1 if (w9amp_q2_face32_choice==2 & w9amp_q2_face14_choice==1)

gen w9item15 = .
replace w9item15 = 1 if (w9amp_q2_face28_choice==1 & w9amp_q2_face15_choice==2)
replace w9item15 = 0 if (w9amp_q2_face28_choice==1 & w9amp_q2_face15_choice==1)
replace w9item15 = 0 if (w9amp_q2_face28_choice==2 & w9amp_q2_face15_choice==2)
replace w9item15 = -1 if (w9amp_q2_face28_choice==2 & w9amp_q2_face15_choice==1)

gen w9item16 = .
replace w9item16 = 1 if (w9amp_q2_face40_choice==1 & w9amp_q2_face16_choice==2)
replace w9item16 = 0 if (w9amp_q2_face40_choice==1 & w9amp_q2_face16_choice==1)
replace w9item16 = 0 if (w9amp_q2_face40_choice==2 & w9amp_q2_face16_choice==2)
replace w9item16 = -1 if (w9amp_q2_face40_choice==2 & w9amp_q2_face16_choice==1)

gen w9item17 = .
replace w9item17 = 1 if (w9amp_q2_face46_choice==1 & w9amp_q2_face17_choice==2)
replace w9item17 = 0 if (w9amp_q2_face46_choice==1 & w9amp_q2_face17_choice==1)
replace w9item17 = 0 if (w9amp_q2_face46_choice==2 & w9amp_q2_face17_choice==2)
replace w9item17 = -1 if (w9amp_q2_face46_choice==2 & w9amp_q2_face17_choice==1)

gen w9item18 = .
replace w9item18 = 1 if (w9amp_q2_face39_choice==1 & w9amp_q2_face18_choice==2)
replace w9item18 = 0 if (w9amp_q2_face39_choice==1 & w9amp_q2_face18_choice==1)
replace w9item18 = 0 if (w9amp_q2_face39_choice==2 & w9amp_q2_face18_choice==2)
replace w9item18 = -1 if (w9amp_q2_face39_choice==2 & w9amp_q2_face18_choice==1)

gen w9item19 = .
replace w9item19 = 1 if (w9amp_q2_face31_choice==1 & w9amp_q2_face19_choice==2)
replace w9item19 = 0 if (w9amp_q2_face31_choice==1 & w9amp_q2_face19_choice==1)
replace w9item19 = 0 if (w9amp_q2_face31_choice==2 & w9amp_q2_face19_choice==2)
replace w9item19 = -1 if (w9amp_q2_face31_choice==2 & w9amp_q2_face19_choice==1)

gen w9item20 = .
replace w9item20 = 1 if (w9amp_q2_face34_choice==1 & w9amp_q2_face20_choice==2)
replace w9item20 = 0 if (w9amp_q2_face34_choice==1 & w9amp_q2_face20_choice==1)
replace w9item20 = 0 if (w9amp_q2_face34_choice==2 & w9amp_q2_face20_choice==2)
replace w9item20 = -1 if (w9amp_q2_face34_choice==2 & w9amp_q2_face20_choice==1)

gen w9item21 = .
replace w9item21 = 1 if (w9amp_q2_face37_choice==1 & w9amp_q2_face21_choice==2)
replace w9item21 = 0 if (w9amp_q2_face37_choice==1 & w9amp_q2_face21_choice==1)
replace w9item21 = 0 if (w9amp_q2_face37_choice==2 & w9amp_q2_face21_choice==2)
replace w9item21 = -1 if (w9amp_q2_face37_choice==2 & w9amp_q2_face21_choice==1)

gen w9item22 = .
replace w9item22 = 1 if (w9amp_q2_face33_choice==1 & w9amp_q2_face22_choice==2)
replace w9item22 = 0 if (w9amp_q2_face33_choice==1 & w9amp_q2_face22_choice==1)
replace w9item22 = 0 if (w9amp_q2_face33_choice==2 & w9amp_q2_face22_choice==2)
replace w9item22 = -1 if (w9amp_q2_face33_choice==2 & w9amp_q2_face22_choice==1)

gen w9item23 = .
replace w9item23 = 1 if (w9amp_q2_face25_choice==1 & w9amp_q2_face23_choice==2)
replace w9item23 = 0 if (w9amp_q2_face25_choice==1 & w9amp_q2_face23_choice==1)
replace w9item23 = 0 if (w9amp_q2_face25_choice==2 & w9amp_q2_face23_choice==2)
replace w9item23 = -1 if (w9amp_q2_face25_choice==2 & w9amp_q2_face23_choice==1)

gen w9item24 = .
replace w9item24 = 1 if (w9amp_q2_face30_choice==1 & w9amp_q2_face24_choice==2)
replace w9item24 = 0 if (w9amp_q2_face30_choice==1 & w9amp_q2_face24_choice==1)
replace w9item24 = 0 if (w9amp_q2_face30_choice==2 & w9amp_q2_face24_choice==2)
replace w9item24 = -1 if (w9amp_q2_face30_choice==2 & w9amp_q2_face24_choice==1)

gen w10item1 = .
replace w10item1 = 1 if (w10amp_q2_face42_choice==1 & w10amp_q2_face1_choice==2)
replace w10item1 = 0 if (w10amp_q2_face42_choice==1 & w10amp_q2_face1_choice==1)
replace w10item1 = 0 if (w10amp_q2_face42_choice==2 & w10amp_q2_face1_choice==2)
replace w10item1 = -1 if (w10amp_q2_face42_choice==2 & w10amp_q2_face1_choice==1)

gen w10item2 = .
replace w10item2 = 1 if (w10amp_q2_face45_choice==1 & w10amp_q2_face2_choice==2)
replace w10item2 = 0 if (w10amp_q2_face45_choice==1 & w10amp_q2_face2_choice==1)
replace w10item2 = 0 if (w10amp_q2_face45_choice==2 & w10amp_q2_face2_choice==2)
replace w10item2 = -1 if (w10amp_q2_face45_choice==2 & w10amp_q2_face2_choice==1)

gen w10item3 = .
replace w10item3 = 1 if (w10amp_q2_face29_choice==1 & w10amp_q2_face3_choice==2)
replace w10item3 = 0 if (w10amp_q2_face29_choice==1 & w10amp_q2_face3_choice==1)
replace w10item3 = 0 if (w10amp_q2_face29_choice==2 & w10amp_q2_face3_choice==2)
replace w10item3 = -1 if (w10amp_q2_face29_choice==2 & w10amp_q2_face3_choice==1)

gen w10item4 = .
replace w10item4 = 1 if (w10amp_q2_face48_choice==1 & w10amp_q2_face4_choice==2)
replace w10item4 = 0 if (w10amp_q2_face48_choice==1 & w10amp_q2_face4_choice==1)
replace w10item4 = 0 if (w10amp_q2_face48_choice==2 & w10amp_q2_face4_choice==2)
replace w10item4 = -1 if (w10amp_q2_face48_choice==2 & w10amp_q2_face4_choice==1)

gen w10item5 = .
replace w10item5 = 1 if (w10amp_q2_face26_choice==1 & w10amp_q2_face5_choice==2)
replace w10item5 = 0 if (w10amp_q2_face26_choice==1 & w10amp_q2_face5_choice==1)
replace w10item5 = 0 if (w10amp_q2_face26_choice==2 & w10amp_q2_face5_choice==2)
replace w10item5 = -1 if (w10amp_q2_face26_choice==2 & w10amp_q2_face5_choice==1)

gen w10item6 = .
replace w10item6 = 1 if (w10amp_q2_face27_choice==1 & w10amp_q2_face6_choice==2)
replace w10item6 = 0 if (w10amp_q2_face27_choice==1 & w10amp_q2_face6_choice==1)
replace w10item6 = 0 if (w10amp_q2_face27_choice==2 & w10amp_q2_face6_choice==2)
replace w10item6 = -1 if (w10amp_q2_face27_choice==2 & w10amp_q2_face6_choice==1)

gen w10item7 = .
replace w10item7 = 1 if (w10amp_q2_face35_choice==1 & w10amp_q2_face7_choice==2)
replace w10item7 = 0 if (w10amp_q2_face35_choice==1 & w10amp_q2_face7_choice==1)
replace w10item7 = 0 if (w10amp_q2_face35_choice==2 & w10amp_q2_face7_choice==2)
replace w10item7 = -1 if (w10amp_q2_face35_choice==2 & w10amp_q2_face7_choice==1)

gen w10item8 = .
replace w10item8 = 1 if (w10amp_q2_face36_choice==1 & w10amp_q2_face8_choice==2)
replace w10item8 = 0 if (w10amp_q2_face36_choice==1 & w10amp_q2_face8_choice==1)
replace w10item8 = 0 if (w10amp_q2_face36_choice==2 & w10amp_q2_face8_choice==2)
replace w10item8 = -1 if (w10amp_q2_face36_choice==2 & w10amp_q2_face8_choice==1)

gen w10item9 = .
replace w10item9 = 1 if (w10amp_q2_face38_choice==1 & w10amp_q2_face9_choice==2)
replace w10item9 = 0 if (w10amp_q2_face38_choice==1 & w10amp_q2_face9_choice==1)
replace w10item9 = 0 if (w10amp_q2_face38_choice==2 & w10amp_q2_face9_choice==2)
replace w10item9 = -1 if (w10amp_q2_face38_choice==2 & w10amp_q2_face9_choice==1)

gen w10item10 = .
replace w10item10 = 1 if (w10amp_q2_face44_choice==1 & w10amp_q2_face10_choice==2)
replace w10item10 = 0 if (w10amp_q2_face44_choice==1 & w10amp_q2_face10_choice==1)
replace w10item10 = 0 if (w10amp_q2_face44_choice==2 & w10amp_q2_face10_choice==2)
replace w10item10 = -1 if (w10amp_q2_face44_choice==2 & w10amp_q2_face10_choice==1)

gen w10item11 = .
replace w10item11 = 1 if (w10amp_q2_face41_choice==1 & w10amp_q2_face11_choice==2)
replace w10item11 = 0 if (w10amp_q2_face41_choice==1 & w10amp_q2_face11_choice==1)
replace w10item11 = 0 if (w10amp_q2_face41_choice==2 & w10amp_q2_face11_choice==2)
replace w10item11 = -1 if (w10amp_q2_face41_choice==2 & w10amp_q2_face11_choice==1)

gen w10item12 = .
replace w10item12 = 1 if (w10amp_q2_face43_choice==1 & w10amp_q2_face12_choice==2)
replace w10item12 = 0 if (w10amp_q2_face43_choice==1 & w10amp_q2_face12_choice==1)
replace w10item12 = 0 if (w10amp_q2_face43_choice==2 & w10amp_q2_face12_choice==2)
replace w10item12 = -1 if (w10amp_q2_face43_choice==2 & w10amp_q2_face12_choice==1)

gen w10item13 = .
replace w10item13 = 1 if (w10amp_q2_face47_choice==1 & w10amp_q2_face13_choice==2)
replace w10item13 = 0 if (w10amp_q2_face47_choice==1 & w10amp_q2_face13_choice==1)
replace w10item13 = 0 if (w10amp_q2_face47_choice==2 & w10amp_q2_face13_choice==2)
replace w10item13 = -1 if (w10amp_q2_face47_choice==2 & w10amp_q2_face13_choice==1)

gen w10item14 = .
replace w10item14 = 1 if (w10amp_q2_face32_choice==1 & w10amp_q2_face14_choice==2)
replace w10item14 = 0 if (w10amp_q2_face32_choice==1 & w10amp_q2_face14_choice==1)
replace w10item14 = 0 if (w10amp_q2_face32_choice==2 & w10amp_q2_face14_choice==2)
replace w10item14 = -1 if (w10amp_q2_face32_choice==2 & w10amp_q2_face14_choice==1)

gen w10item15 = .
replace w10item15 = 1 if (w10amp_q2_face28_choice==1 & w10amp_q2_face15_choice==2)
replace w10item15 = 0 if (w10amp_q2_face28_choice==1 & w10amp_q2_face15_choice==1)
replace w10item15 = 0 if (w10amp_q2_face28_choice==2 & w10amp_q2_face15_choice==2)
replace w10item15 = -1 if (w10amp_q2_face28_choice==2 & w10amp_q2_face15_choice==1)

gen w10item16 = .
replace w10item16 = 1 if (w10amp_q2_face40_choice==1 & w10amp_q2_face16_choice==2)
replace w10item16 = 0 if (w10amp_q2_face40_choice==1 & w10amp_q2_face16_choice==1)
replace w10item16 = 0 if (w10amp_q2_face40_choice==2 & w10amp_q2_face16_choice==2)
replace w10item16 = -1 if (w10amp_q2_face40_choice==2 & w10amp_q2_face16_choice==1)

gen w10item17 = .
replace w10item17 = 1 if (w10amp_q2_face46_choice==1 & w10amp_q2_face17_choice==2)
replace w10item17 = 0 if (w10amp_q2_face46_choice==1 & w10amp_q2_face17_choice==1)
replace w10item17 = 0 if (w10amp_q2_face46_choice==2 & w10amp_q2_face17_choice==2)
replace w10item17 = -1 if (w10amp_q2_face46_choice==2 & w10amp_q2_face17_choice==1)

gen w10item18 = .
replace w10item18 = 1 if (w10amp_q2_face39_choice==1 & w10amp_q2_face18_choice==2)
replace w10item18 = 0 if (w10amp_q2_face39_choice==1 & w10amp_q2_face18_choice==1)
replace w10item18 = 0 if (w10amp_q2_face39_choice==2 & w10amp_q2_face18_choice==2)
replace w10item18 = -1 if (w10amp_q2_face39_choice==2 & w10amp_q2_face18_choice==1)

gen w10item19 = .
replace w10item19 = 1 if (w10amp_q2_face31_choice==1 & w10amp_q2_face19_choice==2)
replace w10item19 = 0 if (w10amp_q2_face31_choice==1 & w10amp_q2_face19_choice==1)
replace w10item19 = 0 if (w10amp_q2_face31_choice==2 & w10amp_q2_face19_choice==2)
replace w10item19 = -1 if (w10amp_q2_face31_choice==2 & w10amp_q2_face19_choice==1)

gen w10item20 = .
replace w10item20 = 1 if (w10amp_q2_face34_choice==1 & w10amp_q2_face20_choice==2)
replace w10item20 = 0 if (w10amp_q2_face34_choice==1 & w10amp_q2_face20_choice==1)
replace w10item20 = 0 if (w10amp_q2_face34_choice==2 & w10amp_q2_face20_choice==2)
replace w10item20 = -1 if (w10amp_q2_face34_choice==2 & w10amp_q2_face20_choice==1)

gen w10item21 = .
replace w10item21 = 1 if (w10amp_q2_face37_choice==1 & w10amp_q2_face21_choice==2)
replace w10item21 = 0 if (w10amp_q2_face37_choice==1 & w10amp_q2_face21_choice==1)
replace w10item21 = 0 if (w10amp_q2_face37_choice==2 & w10amp_q2_face21_choice==2)
replace w10item21 = -1 if (w10amp_q2_face37_choice==2 & w10amp_q2_face21_choice==1)

gen w10item22 = .
replace w10item22 = 1 if (w10amp_q2_face33_choice==1 & w10amp_q2_face22_choice==2)
replace w10item22 = 0 if (w10amp_q2_face33_choice==1 & w10amp_q2_face22_choice==1)
replace w10item22 = 0 if (w10amp_q2_face33_choice==2 & w10amp_q2_face22_choice==2)
replace w10item22 = -1 if (w10amp_q2_face33_choice==2 & w10amp_q2_face22_choice==1)

gen w10item23 = .
replace w10item23 = 1 if (w10amp_q2_face25_choice==1 & w10amp_q2_face23_choice==2)
replace w10item23 = 0 if (w10amp_q2_face25_choice==1 & w10amp_q2_face23_choice==1)
replace w10item23 = 0 if (w10amp_q2_face25_choice==2 & w10amp_q2_face23_choice==2)
replace w10item23 = -1 if (w10amp_q2_face25_choice==2 & w10amp_q2_face23_choice==1)

gen w10item24 = .
replace w10item24 = 1 if (w10amp_q2_face30_choice==1 & w10amp_q2_face24_choice==2)
replace w10item24 = 0 if (w10amp_q2_face30_choice==1 & w10amp_q2_face24_choice==1)
replace w10item24 = 0 if (w10amp_q2_face30_choice==2 & w10amp_q2_face24_choice==2)
replace w10item24 = -1 if (w10amp_q2_face30_choice==2 & w10amp_q2_face24_choice==1)

* Reliability if Candidate AMP was administered in Wave 9:
alpha w9item1 w9item2 w9item3 w9item4 w9item5 w9item6 w9item7 w9item8 w9item9 w9item10 w9item11 w9item12 w9item13 w9item14 w9item15 w9item16 w9item17 w9item18 w9item19 w9item20 w9item21 w9item22 w9item23 w9item24 if w9amp_ver==1, asis

* Reliability if Candidate AMP was administered in Wave 10:
alpha w10item1 w10item2 w10item3 w10item4 w10item5 w10item6 w10item7 w10item8 w10item9 w10item10 w10item11 w10item12 w10item13 w10item14 w10item15 w10item16 w10item17 w10item18 w10item19 w10item20 w10item21 w10item22 w10item23 w10item24 if w9amp_ver==2, asis

* Both reliabilities are alpha=.95, which is what is reported in the footnote.
