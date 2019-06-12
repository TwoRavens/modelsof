# delimit ;
clear all;
/*______________________________________________________________________________________________

All empirical results in "Beauty, Job Tasks, and Wages: A New Conclusion about
Employer Taste-Based Discrimination"

output written to sub-directory "tables"

see readme for additional information.

_______________________________________________________________________________________________*/
local tabledir "tables/";

use berea_beauty_data.dta;

local r_dums0  fem_r_quart2 fem_r_quart3 fem_r_quart4;


/* TABLE 1: Descriptive Statistics by Gender */

  local desvars logrw1 i_rating i_coll_gpa i_hs_gpa i_faminc spec_p_high_no_o spec_p_low_no_o spec_i_high_no_o spec_i_low_no_o;
  estpost su `desvars' if female==1;
  est store stats_women;
  estpost su `desvars' if female==0;
  est store stats_men;

  esttab stats_women stats_men using "`tabledir'des_stats_by_gender.tex", cells(mean(fmt(3)) sd(fmt(3)) ) collabels(none)
           nostar unstack noobs nonote mtitle( "(1) Women" "(2) Men") nonumber
         label title(Descriptive Statistics by Gender\label{table:des_stats}) replace;

/* TABLE 2: Regression of Log-Wage on Attractiveness for Women */

  /* col 1 */
  reg logrw1 std_rating age if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col1.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 2 */
  reg logrw1 std_rating std_coll_gpa age if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col2.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 3 */
  reg logrw1 std_coll_gpa age `r_dums0' if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col3.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 4 */
  reg logrw1 std_rating std_coll_gpa age hs_gpa faminc if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col4.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 5 */
  reg logrw1 std_rating std_coll_gpa age char_com_self_high char_per_self_high  char_rel_self_high if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col5.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 6 */
  reg logrw1 std_rating std_coll_gpa age if female==1 & e(sample),cluster(id);
  esttab using "`tabledir'first_regressions_col6.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 7 */
  reg logrw1 std_rating std_coll_gpa age spec_p_high_no_o spec_p_low_no_o spec_i_high_no_o if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col7.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* col 8 */
  reg logrw1 std_coll_gpa age `r_dums0' spec_p_high_no_o spec_p_low_no_o spec_i_high_no_o if female==1,cluster(id);
  esttab using "`tabledir'first_regressions_col8.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;

/* TABLE 3: Log-Wage Regressions by Primary Job Task and Skill Level for Women: Linear Attractiveness Specification  */
  /* high p  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & spec_p_high_no_o==1,cluster(id);
  esttab using "`tabledir'table_linear_p_high.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low p  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & spec_p_low_no_o==1,cluster(id);
  esttab using "`tabledir'table_linear_p_low.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* high i  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & spec_i_high_no_o==1,cluster(id);
  esttab using "`tabledir'table_linear_i_high.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low i  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & spec_i_low_no_o==1,cluster(id);
  esttab using "`tabledir'table_linear_i_low.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;

/* TABLE 4: Log-Wage Regressions by Primary Job Task and Skill Level for Women: Categorical Attractiveness Specification */
  /* high p  */
  reg logrw1 `r_dums0' std_coll_gpa age if female==1 & spec_p_high_no_o==1,cluster(id);
  esttab using "`tabledir'table_quart_p_high.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low p  */
  reg logrw1 `r_dums0' std_coll_gpa age if female==1 & spec_p_low_no_o==1,cluster(id);
  esttab using "`tabledir'table_quart_p_low.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* high i  */
  reg logrw1 `r_dums0' std_coll_gpa age if female==1 & spec_i_high_no_o==1,cluster(id);
  esttab using "`tabledir'table_quart_i_high.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low i  */
  reg logrw1 `r_dums0' std_coll_gpa age if female==1 & spec_i_low_no_o==1,cluster(id);
  esttab using "`tabledir'table_quart_i_low.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;

/* TABLE 5: Probit Models of Sorting into Interpersonal Job Tasks for Women */
  gen probit_spec = .;
  replace probit_spec = 1 if agg_spec_p == 1;
  replace probit_spec = 0 if agg_spec_i == 1;
  replace probit_spec = . if agg_spec_p == 1 & agg_spec_i == 1;
  /* col 1 */
  dprobit probit_spec std_rating std_coll_gpa age if female==1;
  /* col 2 */
  dprobit probit_spec std_coll_gpa age fem_r_quart2-fem_r_quart4 if female==1;

/* TABLE 6: Multinomial Probit Models of Jointly Sorting into Job Tasks and Skill Levels for Women */
  egen spec_rowsum_no_o = rowtotal(spec_p_high_no_o spec_p_low_no_o spec_i_high_no_o spec_i_low_no_o);

  /* specification A, cols 1-3 */
  mprobit spec_dum_no_o std_rating std_coll_gpa age if female==1 & spec_rowsum_no_o==1,base(4);
  esttab using "`tabledir'mnp_spec1.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;

  /* specification B, cols 4-6 */
  mprobit spec_dum_no_o std_coll_gpa age fem_r_quart2-fem_r_quart4  if female==1 & spec_rowsum_no_o==1,base(4);
  esttab using "`tabledir'mnp_spec2.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;


/* TABLE 7: Log-Wage Regressions by Primary Job Task for Men and Women*/
  /* MEN FIRST 4cols */
    /* col 1: all p */
    reg logrw1 std_rating std_coll_gpa age if female==0 & (spec_p_low_no_o==1 | spec_p_high_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col1.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
    /* all i */
    reg logrw1 std_rating std_coll_gpa age if female==0 & (spec_i_low_no_o==1 | spec_i_high_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col2.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
    /* spec in high */
    reg logrw1 std_rating std_coll_gpa age if female==0 & (spec_p_high_no_o==1 | spec_i_high_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col3.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
    /* spec in low */
    reg logrw1 std_rating std_coll_gpa age if female==0 &  (spec_p_low_no_o==1 | spec_i_low_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col4.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* WOMEN LAST 4 cols */
    /* all p */
    reg logrw1 std_rating std_coll_gpa age if female==1 & (spec_p_low_no_o==1 | spec_p_high_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col5.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
    /* all i */
    reg logrw1 std_rating std_coll_gpa age if female==1 & (spec_i_low_no_o==1 | spec_i_high_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_co6.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
    /* spec in high */
    reg logrw1 std_rating std_coll_gpa age if female==1 &  (spec_p_high_no_o==1 | spec_i_high_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col7.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
    /* spec in low */
    reg logrw1 std_rating std_coll_gpa age if female==1 &  (spec_p_low_no_o==1 | spec_i_low_no_o==1),cluster(id);
    esttab using "`tabledir'table_men_women_col8.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;

/* (APPENDIX) TABLE 8: Log-Wage Regressions for Women: Jobs Above Median Tasks Usage in Each Category */
/* above median classification */
  /* high p  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & p_high>=0.2142, cluster(id);
  esttab using "`tabledir'table_linear_p_high_median.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low p  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & p_low>=0.24, cluster(id);
  esttab using "`tabledir'table_linear_p_low_median.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* high i  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & i_high>=0.150, cluster(id);
  esttab using "`tabledir'table_linear_i_high_median.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low i  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & i_low>=0.150,cluster(id);
  esttab using "`tabledir'table_linear_i_low_median.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;

/* (APPENDIX) TABLE 9: Log-Wage Regressions for Women: Jobs Above 75th Percentile Usage in Each Category */
/* above 75th percentile classification */
  /* high p  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & p_high>=.375, cluster(id);
  esttab using "`tabledir'table_linear_p_high_75.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low p  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & p_low>=.36, cluster(id);
  esttab using "`tabledir'table_linear_p_low_75.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* high i  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & i_high>=.24, cluster(id);
  esttab using "`tabledir'table_linear_i_high_75.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
  /* low i  */
  reg logrw1 std_rating std_coll_gpa age if female==1 & i_low>=.231,cluster(id);
  esttab using "`tabledir'table_linear_i_low_75.tex", label cells(b( fmt(3)) se(par fmt(3))) nostar replace;
