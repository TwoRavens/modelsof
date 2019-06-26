*JPR Replication Models
*Shellman, Hatfield, and Mills
*Case: Indonesia 
*Data Files: Run on both the months and weeks data files to produce all output reported in the Appendix
******************************************************************************************************************************************************************************************************************
*Indonesia Descriptives
************************************************************************
sum gmalldisssoc  alldisssocgm gmaallsep  aallsepgm gmaji  ajigm gmaac  aacgm gmaopm  aopmgm gmaet  aetgm hosscalegmalldisssoc hosscalealldisssocgm coopscalegmalldisssoc  coopscalealldisssocgm hosscalegmaallsep  hosscaleaallsepgm coopscalegmaallsep  coopscaleaallsepgm hosscalegmaji  hosscaleajigm coopscalegmaji  coopscaleajigm hosscalegmaet  hosscaleaetgm coopscalegmaet  coopscaleaetgm hosscalegmaac  hosscaleaacgm coopscalegmaac  coopscaleaacgm hosscalegmaopm  hosscaleaopmgm coopscalegmaopm  coopscaleaopmgm hosgmalldisssoc hosalldisssocgm coopgmalldisssoc  coopalldisssocgm hosgmaallsep  hosaallsepgm coopgmaallsep  coopaallsepgm hosgmaji  hosajigm coopgmaji  coopajigm hosgmaet  hosaetgm coopgmaet  coopaetgm hosgmaac  hosaacgm coopgmaac  coopaacgm hosgmaopm  hosaopmgm coopgmaopm  coopaopmgm   chcpi habibie wahid sukarnoputri
************************************************************************

*VAR Models
*************************************************************************

*Note how we display the results in the paper and appendix. We do not display results with both the government and dissident equations in the SAME table. 
*For comparison purposes, the results for both VAR equations are displayed in separate tables. 
                             
*Scaled Values
set more off
var gmalldisssoc  alldisssocgm ,  lags(1) exog(chcpi habibie wahid sukarnoputri)
var gmaallsep  aallsepgm ,  lags(1) exog(chcpi habibie wahid sukarnoputri)
var gmaji  ajigm ,  lags(1) exog(chcpi habibie wahid sukarnoputri)
var gmaet  aetgm ,  lags(1) exog(chcpi habibie wahid sukarnoputri)
var gmaac  aacgm ,  lags(1) exog(chcpi habibie wahid sukarnoputri)
var gmaopm  aopmgm ,  lags(1) exog(chcpi habibie wahid sukarnoputri)

****************************************************************************************

*Separated Scales of conflict and cooperation
set more off
var hosscalegmalldisssoc hosscalealldisssocgm coopscalegmalldisssoc  coopscalealldisssocgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosscalegmaallsep  hosscaleaallsepgm coopscalegmaallsep  coopscaleaallsepgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosscalegmaji  hosscaleajigm coopscalegmaji  coopscaleajigm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosscalegmaet  hosscaleaetgm coopscalegmaet  coopscaleaetgm ,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosscalegmaac  hosscaleaacgm coopscalegmaac  coopscaleaacgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosscalegmaopm  hosscaleaopmgm coopscalegmaopm  coopscaleaopmgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)

****************************************************************************************

*Frequncies of conflict and cooperation
set more off
var hosgmalldisssoc hosalldisssocgm coopgmalldisssoc  coopalldisssocgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosgmaallsep  hosaallsepgm coopgmaallsep  coopaallsepgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosgmaji  hosajigm coopgmaji  coopajigm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosgmaet  hosaetgm coopgmaet  coopaetgm ,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosgmaac  hosaacgm coopgmaac  coopaacgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)
var hosgmaopm  hosaopmgm coopgmaopm  coopaopmgm,  lags(1) exog(  chcpi habibie wahid sukarnoputri)

****************************************************************************************
*End .do file
***********************************
*NOTE: If first run on Cambodia Weeks data, repeat on Cambodia Months data or vice versa. 

********************


        
                                                      
