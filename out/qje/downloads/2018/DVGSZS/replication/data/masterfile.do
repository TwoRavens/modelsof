/*************************************************************************************************************
This .do file makes tables and figures in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"

IMPORTANT: the vacancy data (variable "v") come from a proprietary source (Conference Board) and have been replaced with noise in the data set.
IMPORTANT: the auto data in table 7 come from a proprietary source (R.L. Polk) and have been replaced with noise in the data set.
IMPORTANT: the state identifiers and state-level data in table 8 come from a proprietary source (Michigan Survey of Consumers) and have been replaced with missing values in the data set.
*************************************************************************************************************/
cap mkdir output
global monthlydataset crck_ui_macro_dataset_monthly_publicversion
global spendingdataset crck_ui_macro_spending_dataset_publicversion
global xsize_full = 4
global xsize_split = 3.25

do fig1
do fig2
do fig3 
do fig4
do fig5
do fig6
do tab2
do tab3 
do tab4 
do tab5
do tab6 
do tab7
*do tab8
do tab9 
