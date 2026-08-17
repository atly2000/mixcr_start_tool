#!/bin/bash 
#MIXCR Start Tool
#Written by Ann Ly, 8/17/26


echo ""
echo ""
echo "-------------------------------------------------------------------------------------------"
echo ""
echo "                 MIXCR Start TOOL"
echo ""
echo "-------------------------------------------------------------------------------------------"
echo "Hi! This is Ann Ly. I'm a MD/PhD student in Adrian Wiestner's lab."
echo "I can help you prepare for your MIXCR run. When I ask you for some info, just paste it."
echo "If you don't have all this info, we can't run MIXCR." 
echo "Make sure you have you have all the information we need to make MIXCR work."
echo "-------------------------------------------------------------------------------------------"
echo " Menu Navigation Tips"
echo ""
echo " If you change your mind on adding info anytime, you can click Ctrl+C to exit. "
echo " Step 1 make_folders should be done first."
echo " Steps 2-6 can be done in any order."
echo " After you finish Steps 2-6, select Step 7, the ready_to_go option."
echo "-------------------------------------------------------------------------------------------"
echo ""



PS3="What information do you want to add?: "

select opt in make_folders sample_names fastq_dir out_dir b_dir fastq_format ready_to_go quit; do

  case $opt in
    make_folders)
      echo "Do you need me to set up the key folders? Only say yes if you are running a completely fresh analysis."
      while true; do
              # Prompt the user for input
              read -p "Do you want to continue? (y/n): " yn
              
              case $yn in
                  # Match y, Y, yes, YES, Yes
                  [Yy]* ) 
                      echo "Okay, I made the key folders."
                      mkdir input prep_scripts run_scripts
                      cd run_scripts
                      mkdir swarm_report
                      cd ..
                      break
                      ;;
                      
                  # Match n, N, no, NO, No
                  [Nn]* ) 
                      echo "Ok, I won't make the key folders."
                      exit 0
                      ;;
                      
                  # invalid input
                  * ) 
                      echo "Please answer yes (y) or no (n)."
                      ;;
              esac
          done
      ;;
    sample_names)
      read -p "What are your sample names?: " n1
      echo "Okay, I recorded these fastq sample names in input/sample_names.txt"
      echo "$n1" > input/sample_names.txt
      
      ;;
    fastq_dir)
      read -p "Where are your FASTQ files?: " n1
      echo "Okay, I recorded your FASTQ file locations in input/fastq_dir.txt"
      echo "$n1" > input/fastq_dir.txt
      ;;
    out_dir)
      read -p "Where do you want MIXCR's initial output to be placed? This is called out_dir. : " n1
      echo "Okay, I recorded your FASTQ file locations in input/out_dir.txt"
      echo "$n1" > input/out_dir.txt
      ;;
    b_dir)
      read -p "Where do you want MIXCR's IGHV results to be placed? This is called b_dir: " n1
      echo "Okay, I recorded your FASTQ file locations in input/b_dir.txt"
      echo "$n1" > input/b_dir.txt
      ;;
    
    fastq_format)
      read -p "What is the R1 fastq file suffix? (ex: _1.fastq.gz or _R1.fastq.gz or _1.fastq or _R1.fastq):  " n1
      echo "Okay, I recorded your R1 fastq suffix in input/style_R1.txt"
      echo "$n1" > input/style_R1.txt
      read -p "What is the R2 fastq file suffix? (ex: _2.fastq.gz or _R2.fastq.gz or _2.fastq or _R2.fastq):  " n2
      echo "Okay, I recorded your R2 fastq suffix in input/style_R1.txt"
      echo "$n2" > input/style_R2.txt
      ;;
    
    
    
    
    ready_to_go)
      echo "You finished all the other steps? I'm going to prepare all your data for MIXCR to read now."
        module load python


          #Define Directories to Use
          NEW_PATIENT=$(<input/sample_names.txt)
          NEW_FASTQ=$(<input/fastq_dir.txt)
          NEW_OUT=$(<input/out_dir.txt)
          NEW_B=$(<input/b_dir.txt)
          NEW_STYLE_R1=$(<input/style_R1.txt)
          NEW_STYLE_R2=$(<input/style_R2.txt)
          
          #Making MIXCR Analyze Scripts
          cp templates/01_TEMPLATE_mixcr_analyze_script_maker.py prep_scripts/01_mixcr_analyze_script_maker.py
          sed -i "s|PATIENT_LIST|$NEW_PATIENT|g" prep_scripts/01_mixcr_analyze_script_maker.py
          sed -i "s|FASTQ_LIST|$NEW_FASTQ|g" prep_scripts/01_mixcr_analyze_script_maker.py
          sed -i "s|OUT_LIST|$NEW_OUT|g" prep_scripts/01_mixcr_analyze_script_maker.py
          sed -i "s|STYLE_R1|$NEW_STYLE_R1|g" prep_scripts/01_mixcr_analyze_script_maker.py
          sed -i "s|STYLE_R2|$NEW_STYLE_R2|g" prep_scripts/01_mixcr_analyze_script_maker.py
          python prep_scripts/01_mixcr_analyze_script_maker.py > run_scripts/01_mixcr_run.swarm
          
          #Making MIXCR Export Scripts
          cp templates/02_TEMPLATE_mixcr_export_script_maker.py prep_scripts/02_mixcr_script_maker.py
          sed -i "s|PATIENT_LIST|$NEW_PATIENT|g" prep_scripts/02_mixcr_script_maker.py
          sed -i "s|B_LIST|$NEW_B|g" prep_scripts/02_mixcr_script_maker.py
          sed -i "s|OUT_LIST|$NEW_OUT|g" prep_scripts/02_mixcr_script_maker.py
          sed -i "s|STYLE_R1|$NEW_STYLE_R1|g" prep_scripts/02_mixcr_script_maker.py
          sed -i "s|STYLE_R2|$NEW_STYLE_R2|g" prep_scripts/02_mixcr_script_maker.py
          python prep_scripts/02_mixcr_script_maker.py > run_scripts/02_mixcr_export.sh
      echo "Okay, I just finished prepping your data. You are ready to submit the job to Biowulf as the next step!"
      ;;
    quit)
      echo "Thanks for letting me know about your analysis!"
      break
      ;;
    *)
      echo "Invalid option $REPLY"
      ;;
  esac
done
