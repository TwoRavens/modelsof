**Replication files for Shifting Standards: How Voters Evaluate the Qualifications of Female and Male Candidates"
**Nichole Bauer 

**Replication Analyses for the Productivity Exp. (study 1)
**use productivity data file

**Figure 1 Comparisons, full means in Web Appendix 7, Table A6
ttest leg_tasks, by(female_condition)

**Figure 2 Comparisons, full means in Web Appendix 7, TAble A6
**Figure 2 Comparisons, full means in Web Appendix 7, TAble A6
ttest vote, by(female_condition)
ttest viability, by(female_condition)

**Web Appendix 5, Table A2
ttest hardworker, by(female_condition)
ttest consensus, by(female_condition)
ttest organized, by(female_condition)
ttest determined, by(female_condition)
ttest pubspeak, by(female_condition)
ttest workwell, by(female_condition)
ttest bipart, by(female_condition)
ttest priorities, by(female_condition)
ttest principled, by(female_condition)
ttest standground, by(female_condition)
ttest sharecredit, by(female_condition)

**Web Appendix 5, Table A3
ttest leg_tasks if female==1, by(female_condition)
ttest leg_tasks if female==0, by(female_condition)
ttest leg_tasks if female_condition==1, by(female)
ttest leg_tasks if female_condition==0, by(female)

ttest leg_tasks if dem_voter==1, by(female_condition)
ttest leg_tasks if dem_voter==0, by(female_condition)
ttest leg_tasks if female_condition==1, by(dem_voter)
ttest leg_tasks if female_condition==0, by(dem_voter)

**Web Appendix 5, Table A4
ttest vote if female==1, by(female_condition)
ttest vote if female==0, by(female_condition)
ttest vote if female_condition==1, by(female)
ttest vote if female_condition==0, by(female)

ttest viability if female==1, by(female_condition)
ttest viability if female==0, by(female_condition)
ttest viability if female_condition==1, by(female)
ttest viability if female_condition==0, by(female)

ttest vote if dem_voter==1, by(female_condition)
ttest vote if dem_voter==0, by(female_condition)
ttest vote if female_condition==1, by(dem_voter)
ttest vote if female_condition==0, by(dem_voter)

ttest viability if dem_voter==1, by(female_condition)
ttest viability if dem_voter==0, by(female_condition)
ttest viability if female_condition==1, by(dem_voter)
ttest viability if female_condition==0, by(dem_voter)

**Web Appendix 5, pg. 7
ttest fem_leg_tasks, by(female_condition)
ttest male_leg_tasks, by(female_condition)
ttest fem_leg_tasks=male_leg_tasks if female_condition==1
ttest fem_leg_tasks=male_leg_tasks if female_condition==0


**Replication Analyses for the Productivity Extension Study
**use productivity_extension data file
**Web Appendix 6, Table A5
ttest leg_tasks, by(female_condition)
ttest vote, by(female_condition)
ttest viability, by(female_condition)

**Competitive Context Experiment, study 2 in main paper
**use compete data file
**Comparisons for Figure 3
ttest tasknumber_hartley=tasknumber_larson if female_condition==1
ttest tasknumber_hartley=tasknumber_larson if female_condition==0
ttest tasknumber_hartley, by(female_condition)

**Vote Choice Comparisons
ttest vote_choice, by(female_condition)

**Figure 4 Comparisons
ttest primary_hartley==primary_larson if female_condition==1
ttest primary_hartley==primary_larson if female_condition==0

ttest general_hartley==general_larson if female_condition==1
ttest general_hartley==general_larson if female_condition==0

**Web Appendix 6, Table A7
ttest tasknumber_hartley if female_condition==1, by(female)
ttest tasknumber_hartley if female_condition==0, by(female)
ttest tasknumber_hartley if female==1, by(female_condition)
ttest tasknumber_hartley if female==0, by(female_condition)

ttest tasknumber_larson if female_condition==1, by(female)
ttest tasknumber_larson if female_condition==0, by(female)
ttest tasknumber_larson  if female==1, by(female_condition)
ttest tasknumber_larson  if female==0, by(female_condition)

**Web Appendix 6, Table A8
ttest vote_hartley if female_condition==1, by(female)
ttest vote_hartley if female_condition==0, by(female)
ttest vote_hartley if female==1, by(female_condition)
ttest vote_hartley if female==0, by(female_condition)

ttest primary_viability if female_condition==1, by(female)
ttest primary_viability if female_condition==0, by(female)
ttest primary_viability if female==1, by(female_condition)
ttest primary_viability if female==0, by(female_condition)

ttest general_viability if female_condition==1, by(female)
ttest general_viability if female_condition==0, by(female)
ttest general_viability if female==1, by(female_condition)
ttest general_viability if female==0, by(female_condition)

**Web Appendix 6, Table A9
ttest tasknumber_hartley if democrat_condition==1, by(female_condition)
ttest tasknumber_hartley if democrat_condition==0, by(female_condition)
ttest tasknumber_hartley if female_condition==1, by(democrat_condition)
ttest tasknumber_hartley if female_condition==0, by(democrat_condition)

ttest tasknumber_larson if democrat_condition==1, by(female_condition)
ttest tasknumber_larson if democrat_condition==0, by(female_condition)
ttest tasknumber_larson if female_condition==1, by(democrat_condition)
ttest tasknumber_larson if female_condition==0, by(democrat_condition)

**Web Appendix 6, Table A10

ttest vote_hartley if  democrat_condition==1, by(female_condition)
ttest vote_hartley if  democrat_condition==0, by(female_condition)
ttest vote_hartley if  female_condition==0, by(democrat_condition)
ttest vote_hartley if  female_condition==1, by(democrat_condition)

ttest primary_viability if democrat_condition==1, by(female_condition)
ttest primary_viability if democrat_condition==0, by(female_condition)
ttest primary_viability if female_condition==1, by(democrat_condition)
ttest primary_viability if female_condition==0, by(democrat_condition)

ttest general_viability if democrat_condition==1, by(female_condition)
ttest general_viability if democrat_condition==0, by(female_condition)
ttest general_viability if female_condition==1, by(democrat_condition)
ttest general_viability if female_condition==0, by(democrat_condition)

**Partisan Extension
**use compete_ext data file 
**conditions:  1=Dems,FvM 2=Dems,MvM 3=Reps,FvM 4=Reps,MvM

*Web Appendix 8
**Figure A1
ttest experience if conditions==1|conditions==2, by(conditions)
ttest experience if conditions==3|conditions==4, by(conditions)
ttest knowledge if conditions==1|conditions==2, by(conditions)
ttest knowledge if conditions==3|conditions==4, by(conditions)

**Figure A2
ttest primary_hartley=primary_larson if conditions==1
ttest primary_hartley=primary_larson if conditions==2
ttest primary_hartley=primary_larson if conditions==3
ttest primary_hartley=primary_larson if conditions==4

ttest general_hartley=general_larson if conditions==1
ttest general_hartley=general_larson if conditions==2
ttest general_hartley=general_larson if conditions==3
ttest general_hartley=general_larson if conditions==4

