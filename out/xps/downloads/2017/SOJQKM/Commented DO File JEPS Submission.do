/*
STATA Commands used for results presented in Manuscript
*/

egen subject_id = concat(IndNum game_id)
table subject_id

egen group_id = concat(Treatment Session Group)
destring group_id, replace
table group_id

egen period_id = concat(group_id Period)
table period_id
bysort period_id: egen mean_cont_period_group = mean(Contribute)
bysort period_id: egen mean_earn_period_group = mean(Profit)
bysort period_id: egen mean_vote_period_group = mean(MembersToMonitor)
* These values are unique for each period group combo
* Added previous round average contribution for Regs.
sort Treatment Session Group Period Subject
gen mean_cont_period_group_prev = mean_cont_period_group[_n-1] if group_id == group_id[_n-1]
replace mean_cont_period_group_prev = mean_cont_period_group_prev[_n-1] if period_id == period_id[_n-1]

*Phase 2 contributions and profit across treatments, with aggregated mean contributions across all 12 phase2 Periods.
egen group_phase_id = concat(phase game_id )
table group_phase_id
bysort group_phase_id: egen mean_cont_group_phase = mean(Contribute)
bysort group_phase_id: egen mean_earn_group_phase = mean(Profit)

*Phase 2 contributions and earnings across treatments, with 2 aggregated mean contributions across phase2, 2 Periods each, (each monitoring level).
egen group_phase_choice_id = concat(phase game_id Choice)
table group_phase_choice_id
bysort group_phase_choice_id: egen mean_cont_group_phase_choice = mean(Contribute)
bysort group_phase_choice_id: egen mean_earn_group_phase_choice = mean(Profit)

gen EndoComm = (Treatment == 3)
*Identifier for exo comm treatment - treatment 1 and 3 = 0
gen ExoComm = (Treatment == 2)


***************************************************************************
************      Results for JEPS Submission      ************************
***************************************************************************

***** Table 1 ******
table Treatment if phase == 1, c(mean Contribute mean Profit)
table Treatment if phase == 2, c(mean Contribute mean Profit)
table Treatment if phase == 3, c(mean Contribute mean Profit mean Choice)

***** Footnote 11 result - equivalence of Phase 1 Contributoins and Earnings *****
*Phase 1 contribution across all treatments 							   
kwallis  mean_cont_group_phase if IndNum == 1 & phase == 1 & Period == 1, by(Treatment)
*Phase 1 Earnings across all treatments 							   
kwallis  mean_earn_group_phase if IndNum == 1 & phase == 1 & Period == 1, by(Treatment)

***** Result 1 *****
ttest     mean_cont_group_phase if IndNum == 1 & phase == 2 & Period == 4 | ///
	                               IndNum == 1 & phase == 2 & Period == 4, by(ExoComm)
ranksum   mean_cont_group_phase if IndNum == 1 & phase == 2 & Period == 4 | ///
	                               IndNum == 1 & phase == 2 & Period == 4, by(ExoComm)	
ttest     mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 0 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 0 & Period < 10, by(ExoComm)	
ranksum   mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 0 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 0 & Period < 10, by(ExoComm)											
ttest     mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 1 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 1 & Period < 10, by(ExoComm)	
ranksum   mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 1 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 1 & Period < 10, by(ExoComm)
ttest     mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 2 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 2 & Period < 10, by(ExoComm)	
ranksum   mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 2 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 2 & Period < 10, by(ExoComm)											  
ttest     mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 3 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 3 & Period < 10, by(ExoComm)	
ranksum   mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 3 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 3 & Period < 10, by(ExoComm)	
ttest     mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 4 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 4 & Period < 10, by(ExoComm)	
ranksum   mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 4 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 4 & Period < 10, by(ExoComm)
ttest     mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 5 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 5 & Period < 10, by(ExoComm)	
ranksum   mean_cont_group_phase_choice if IndNum == 1 & phase == 2 & Choice == 5 & Period < 10| ///
	                                      IndNum == 1 & phase == 2 & Choice == 5 & Period < 10, by(ExoComm)										   							  
/*
Using the above results I used the following Latex to create Figure 1

\begin{figure}[htbp]
\begin{tikzpicture}
    \begin{axis}[    
        width  = \textwidth,
        height = 6.25cm,
        major x tick style = transparent,
        ybar=1*\pgflinewidth,
        bar width=11pt,
        title={\normalsize{Average Contributions during Phase 2}},
        ymajorgrids = true,
        ylabel = {\normalsize{Average Contribution (EDs)}},
        symbolic x coords={,z = 0, z = 1,z = 2, z = 3, z = 4, z = 5},
        xtick = data,
        scaled y ticks = false,
        enlarge x limits=0.1,
        ymin=0,
        ymax = 24,
        legend cell align=left,
        legend style={at={(0.5,-0.15)},
		anchor=north,legend columns=-1},
    ]
 
		\addplot[style={charcoal,fill=gray,mark=none}]
            coordinates {
                         (z = 0,  16.08)
                         (z = 1,  17.85)
                         (z = 2,  18.77 )
                         (z = 3,  19.58)
                         (z = 4,  19.58 )
                         (z = 5,  20.00)};
                         
         \addplot[style={dark,fill=black,mark=none}]
            coordinates {
                         (z = 0,  8.21 )
                         (z = 1,   10.69)
                         (z = 2,  13.91 )
                         (z = 3,  16.64)
                         (z = 4,  17.87)
                         (z = 5,  17.49)}; 
            
        \legend{\textit{Phase2Comm}, Pooled (\textit{NoComm} and \textit{Phase3Comm})}

\end{axis}
\end{tikzpicture}
\caption{Average contributions at each level of monitoring in phase 2 across \textit{Phase2Comm} and the Pooled, \textit{NoComm} and \textit{Phase3Comm} treatments.}
\end{figure}
*/						
				  
***** Table 2 Regression ******
xtset subject_id
xtreg Contribute i.Choice#i.ExoComm Period mean_cont_period_group_prev if phase == 2, vce(cluster group_id)
margins, dydx(ExoComm) at(Choice = (0, 1, 2, 3, 4, 5))

***** Result 2 *****
ttest     mean_choice_group_phase if IndNum == 1 & phase == 3 & Period == 16 & Treatment == 1| ///
	                               IndNum == 1 & phase == 3 & Period == 16 & Treatment == 3, by(Treatment)
ranksum   mean_choice_group_phase if IndNum == 1 & phase == 3 & Period == 16 & Treatment == 1| ///
	                               IndNum == 1 & phase == 3 & Period == 16 & Treatment == 3, by(Treatment)

***** Count for the Group Voting outcomes *****
table Treatment if Choice == 0 & phase == 3, c(n Choice)
table Treatment if Choice == 1 & phase == 3, c(n Choice)
table Treatment if Choice == 2 & phase == 3, c(n Choice)
table Treatment if Choice == 3 & phase == 3, c(n Choice)
table Treatment if Choice == 4 & phase == 3, c(n Choice)
table Treatment if Choice == 5 & phase == 3, c(n Choice)

/* Using the above information we created the following Latex for Figure 2
NOTE: The above includes all observations, to re-create the table divide each by 
5 so that individual votes are aggregated into group voets. Analysis ignores 
Treatment 2 (Phase2Comm).

\begin{figure}[t]
\begin{tikzpicture}
    \begin{axis}[    
        width  = \textwidth,
        height = 6.25cm,
        major x tick style = transparent,
        ybar=1*\pgflinewidth,
        bar width=11pt,
        title={\normalsize{Group Level Voting Pattern across Treatments}},
        ymajorgrids = true,
        ylabel = {\normalsize{\% of Voting Outcomes}},
        symbolic x coords={,z = 0, z = 1,z = 2, z = 3, z = 4, z = 5},
        xtick = data,
        scaled y ticks = false,
        enlarge x limits=0.1,
        ymin=0,
        ymax = 100,
        legend cell align=left,
        legend style={at={(0.5,-0.15)},
		anchor=north,legend columns=-1},
    ]
% 
		\addplot[style={black,fill=dark,mark=none}]
            coordinates {
                         (z = 0,  80 )
                         (z = 1,  6)
                         (z = 2,  1 )
                         (z = 3,  7)
                         (z = 4,  1)
                         (z = 5,  4)}; 
            
		\addplot[style={black,fill=gray,mark=none}]
            coordinates {
                         (z = 0,  10)
                         (z = 1,  3)
                         (z = 2,  4 )
                         (z = 3,  21)
                         (z = 4,  21 )
                         (z = 5,  41)};
                         
         
        \legend{\textit{Phase3Comm} \hspace{0.5cm}, \textit{NoComm}}        
 
 \end{axis}
\end{tikzpicture}
\caption{Percent of group level votes at each level of monitoring across \textit{Phase3Comm} and \textit{NoComm}. The total number of group level votes in \textit{Phase3Comm} and \textit{NoComm} is 70 and 80 respectively.}
\end{figure}
*/

***** Table 3 Regression *****
xtreg MembersToMonitor EndoComm Period mean_cont_period_group_prev if phase == 3 & ExoComm != 1, vce(cluster group_id)

***** Table 4 *****
total(Leader Comm ProSoc MoralCongrats AngerThreats ExpIncor ExpCor IndOpt GroupOpt GoBig Future EndGame NoChat) ///
	if Period >3 & Period < 16 & grouplevel ==1 & Treatment == 2
total(Leader Comm ProSoc MoralCongrats AngerThreats ExpIncor ExpCor IndOpt GroupOpt GoBig Future EndGame NoChat) ///
	if Period >15 & grouplevel ==1 & Treatment == 3
/*
The above count the number of group-period chats that were coded as a given category.
To get the percent take the count for treatment == 2 (phase2comm) and divide by 72 
and for treatment == 3 (phase3comm) divide the count by 70.
To translate the STATA variables to the presentation in the paper use the following:
Leader = Leadership
Comm = Committment
ProSoc = Pro-Social
MoralCongrats = Morale
AngerThreats = Threat
ExpIncor = Explain Incorrect
ExpCor = Explain Correct
IndOpt = Individual Optimal
GroupOpt = Group Optimal
GoBig = Go Big
Future = Future
EndGame = End Game
NoChat = No Chat
*/

xtset group_id

***** Table 5 *****	
xtreg mean_cont_period_group Leader Comm ProSoc MoralCongrats AngerThreats ExpCor ///
	Choice Period mean_cont_period_group_prev if grouplevel == 1 & Treatment == 2 & phase == 2
	
xtreg MedianChoice Leader Comm ProSoc MoralCongrats AngerThreats ExpCor ///
	Period mean_cont_period_group_prev if grouplevel == 1 & Treatment == 3 & phase == 3
	





