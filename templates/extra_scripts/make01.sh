#!/bin/bash
#Currently unused.
#You can move this to the main working directory if you want to use it instead of 00_initialize. 
module load python


#Define Directories to Use
NEW_PATIENT=$(<input/sample_names.txt)
NEW_FASTQ=$(<input/fastq_dir.txt)
NEW_OUT=$(<input/out_dir.txt)
NEW_B=$(<input/b_dir.txt)


#Making MIXCR Analyze Scripts
cp templates/01_TEMPLATE_mixcr_analyze_script_maker.py prep_scripts/01_mixcr_analyze_script_maker.py
sed -i "s|PATIENT_LIST|$NEW_PATIENT|g" prep_scripts/01_mixcr_analyze_script_maker.py
sed -i "s|FASTQ_LIST|$NEW_FASTQ|g" prep_scripts/01_mixcr_analyze_script_maker.py
sed -i "s|OUT_LIST|$NEW_OUT|g" prep_scripts/01_mixcr_analyze_script_maker.py
python prep_scripts/01_mixcr_analyze_script_maker.py > run_scripts/01_mixcr_run.swarm

#Making MIXCR Export Scripts
cp templates/02_TEMPLATE_mixcr_export_script_maker.py prep_scripts/02_mixcr_script_maker.py
sed -i "s|PATIENT_LIST|$NEW_PATIENT|g" prep_scripts/02_mixcr_script_maker.py
sed -i "s|B_LIST|$NEW_B|g" prep_scripts/02_mixcr_script_maker.py
sed -i "s|OUT_LIST|$NEW_OUT|g" prep_scripts/02_mixcr_script_maker.py
python prep_scripts/02_mixcr_script_maker.py > run_scripts/02_mixcr_export.sh


