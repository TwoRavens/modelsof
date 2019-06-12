*****
*****

*STATA CODE FILE FOR JEPS ARTICLE "LOOKS AND SOUNDS LIKE A WINNER" (KLOFSTAD)

*****
*****

*BASIC RESULTS BY EXPERIMENTAL CONDITION
*get data
	*clear
clear
	*get data
import excel "/CASEY/UM_drive/data/pitch and faces/study 2 data/election_results_GC_only.xlsx", sheet("Sheet1") firstrow clear

*faces
ttest gc_voteshare, by (compface)

*voices
ttest gc_voteshare, by (lowvoice)

*****

*MULTIVARIATE MODELS (Table 1)
*get data
	*clear
clear
	*get data
import excel "/CASEY/UM_drive/data/pitch and faces/study 2 data/election_results_GC_only.xlsx", sheet("Sheet1") firstrow clear

*analysis: all
reg gc_voteshare compface##lowvoice, cluster (election)

*analysis: by candidate sex
reg gc_voteshare compface##lowvoice##female, cluster (election)

*****

*FIGURE 3 (calculate interaction effects by hand based on variable means and Table 1/Column 2 coefficients)
*get data
	*clear
clear
	*get data
import excel "/CASEY/UM_drive/data/pitch and faces/study 2 data/election_results_GC_only.xlsx", sheet("Sheet1") firstrow clear

*competent face
summarize compface

*competent voice
summarize low voice	

*competent faceXcompetent voice
generate face_voice=compface*lowvoice
summarize face_voice

*female
summarize female

*competent faceXfemale
generate face_female=compface*female
summarize face_female

*competent voiceXfemale
generate voice_female=lowvoice*female
summarize voice_female

*competent faceXcompetent voiceXfemale
generate face_voice_female=compface*lowvoice*female
summarize face_voice_female

*****

*DESCRIPTIVE STATS ON SUBJECTS (Table A1)
*refer to SPSS dataset named "subject demogs"

*****

*DESCRIPTIVE STATS (Table A2)
*get data
	*clear
clear
	*get data
import excel "/CASEY/UM_drive/data/pitch and faces/study 2 data/election_results_GC_only.xlsx", sheet("Sheet1") firstrow clear

*competent face
summarize compface

*competent voice
summarize low voice	

*competent faceXcompetent voice
generate face_voice=compface*lowvoice
summarize face_voice

*female
summarize female

*competent faceXfemale
generate face_female=compface*female
summarize face_female

*competent voiceXfemale
generate voice_female=lowvoice*female
summarize voice_female

*competent faceXcompetent voiceXfemale
generate face_voice_female=compface*lowvoice*female
summarize face_voice_female

*****

*BALANCE TABLE (Table A3)
*refer to SPSS dataset named "subject demogs"

*****

*REPLICATE ANALYSIS WITH OUTLIER FACES KICKED OUT
*get data
	*clear
clear
	*get data
import excel "/CASEY/UM_drive/data/pitch and faces/study 2 data/election_results_GC_only_outliers_dropped.xlsx", sheet("Sheet1") firstrow clear

*basic results by experimental condition
	*faces
ttest gc_voteshare, by (compface)
	*voices
ttest gc_voteshare, by (lowvoice)

*multivariate analyses (Table A4)
	*analysis: all
reg gc_voteshare compface##lowvoice, cluster (election)
	*analysis: by candidate sex
reg gc_voteshare compface##lowvoice##female, cluster (election)

*****

*MULTILEVEL MODEL

*get data
	*clear
clear
	*get data
import excel "/CASEY/UM_drive/data/pitch and faces/study 2 data/election_results_GC_only.xlsx", sheet("Sheet1") firstrow clear

*multilevel analysis (Table A5)
	*analysis: all
mixed gc_voteshare compface##lowvoice || election:
	*analysis: by candidate sex
mixed gc_voteshare compface##lowvoice##female || election:

