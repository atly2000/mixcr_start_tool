MIXCR Start Tool allows you to input FASTQ file directories, FASTQ names, and output directories to prepare for a MIXCR run.
The MIXCR run then operates using SWARM on the Biowulf HPC.

Currently, this version of the tool is compatible with IGH, IGK, and IGL retrieval.

Please download the Manual DOCX file and read it for guidance and tips.


***Please cite Ann Ly, University of Oxford/National Institutes of Health if you use my tool.***

Ly, Ann. MIXCR Start Tool, 2026, https://github.com/atly2000/mixcr_start_tool/. 


***MIXCR Was developed by:***
Dmitriy A. Bolotin, Stanislav Poslavsky, Igor Mitrophanov, Mikhail Shugay, Ilgar Z. Mamedov, Ekaterina V. Putintseva, and Dmitriy M. Chudakov. "MiXCR: software for comprehensive adaptive immunity profiling." Nature methods 12, no. 5 (2015): 380-381.


# Ann Ly’s MIXCR Start Tool

**Version 2**

Ann Ly

Last updated 8/20/26
This contains some of the information in the **Manual, which is downloadable.**
Please view that document using “Web Layout” in Microsoft Word.

**Table of Contents**

Overview  
Background Biology  
Preparing for Analysis  
Get a MIXCR License  
Create Input Files and Specify your Directories  
Option 1: Minimal Coding Method  
▶️1. Run the MIXCR Start Tool  
	1. Make_Folders  
	2. Sample_Names  
	3. Fastq_dir  
	4. Out_dir  
	5. B_dir  
	6. Specify FASTQ Format  
	7. Experiment Info  
	8. Ready to Go  
▶️2. Verify that all files are there using “tree”  
▶️3. Run the Commands specific to MIXCR  
	1. Run MIXCR  
	2. Run MIXCR Export  
▶️4. MIXCR is Done! Your outputs will be at out_dir and b_dir that you specified.  
▶️5. Optional: Place the data in a readable way  
	1. Add helper files and folders  
	2. Merge IGH, IGK, and IGL into the same table  
⚠️Troubleshooting Missing Files  
Results Interpretation  
 




# Overview

MIXCR has proved very useful for our lab.

We can gauge IGHV status for patients and check for light chain usage.

It’s also a good control to prevent sample mix-ups.

## Background Biology

<div class="joplin-table-wrapper"><table><thead><tr><th><p>There Are 3 IGH, IGK, and IGL Loci that help build antibodies</p></th></tr><tr><th><p>These are heavy, kappa, lambda loci (H, K, L) in the genome</p><ul><li><strong>H: Encodes Heavy chain</strong><ul><li>Contains V, D, J, C locus</li></ul></li><li><strong>K and L: Encodes light chain → no D locus.</strong><ul><li>Kappa<ul><li>Contains V, J, C locus</li></ul></li><li>Lambda<ul><li>Contains V, J, C locus</li></ul></li></ul></li></ul><p></p></th></tr></thead></table></div>

<div class="joplin-table-wrapper"><table><thead><tr><th><p>The C locus in heavy chain is special because it helps define isotype.</p></th></tr><tr><th><p>Antibodies are made of heavy chains and light chains</p><ul><li><strong></strong>Heavy chains <strong>define the isotype → IgA, IgM, IgD, IgE, IgG</strong><ul><li>Made up of <strong>constant </strong>regions that define isotype</li><li>V, D, J</li></ul></li><li>Light chains<ul><li>Made up of <strong>Kappa OR Lambda</strong></li><li>V, J only</li></ul></li></ul><p></p></th></tr></thead></table></div>

# Preparing for Analysis

## Get a MIXCR License

**Guide from** https://hpc.nih.gov/apps/mixcr.html

1.  Get license code from https://platforma.bio/mixcr-access. You will need a “Free Academic License."
    1.  For example, mine looked like this
    2.  E-OMZQAHFCCTXNBKBTQFIVVPFXYAOCDHAGMCKCEVJAXJWQKRSU
2.  Put mi.license content to MI_LICENSE global variable by adding the following line in ~/.bashrc file:
    1.  export MI_LICENSE="CopyPasteLicenseKeyHere"
    2.  make sure to remove all old license info:
        1.  rm ~/.mi.license
        2.  rm ~/mi.license
        3.  unset MI_LICENSE_FILE

**~/.bashrc is like a universal settings file for your Biowulf**

Paste this line in your ~/.bashrc file.

You can do this by typing “nano ~/.bashrc” to edit your ~/.bashrc.

export MI_LICENSE="E-OMZQAHFCCTXNBKBTQFIVVPFXYAOCDHAGMCKCEVJAXJWQKRSU"

My BASHRC then contains the license!

\# .bashrc

\# Source global definitions

if \[ -f /etc/bashrc \]; then

. /etc/bashrc

fi

\# User specific environment

if ! \[\[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" \]\]

then

PATH="$HOME/.local/bin:$HOME/bin:$PATH"

fi

export PATH

export MI_LICENSE="E-OMZQAHFCCTXNBKBTQFIVVPFXYAOCDHAGMCKCEVJAXJWQKRSU"

\# Uncomment the following line if you don't like systemctl's auto-paging feature:

\# export SYSTEMD_PAGER=

\# User specific aliases and functions

#export R_LIBS_USER="/data/lyat/R/4.5" --> commented out 4/2/26 because I want R per version

\# --> commented out on 4/2/26 to prevent issues

\# >>> conda initialize >>>

\# !! Contents within this block are managed by 'conda init' !!

#\__conda_setup="$('/usr/local/Anaconda/envs/py3.10/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"

#if \[ $? -eq 0 \]; then

\# eval "$\__conda_setup"

#else

\# if \[ -f "/usr/local/Anaconda/envs/py3.10/etc/profile.d/conda.sh" \]; then

\# . "/usr/local/Anaconda/envs/py3.10/etc/profile.d/conda.sh"

\# else

\# export PATH="/usr/local/Anaconda/envs/py3.10/bin:$PATH"

\# fi

#fi

#unset \__conda_setup

\# <<< conda initialize <<<

**If you already have a license, activate it by typing this into biowulf:**

mixcr activate-license

## Create Input Files and Specify your Directories

**You will need this information in order to run MIXCR**

<div class="joplin-table-wrapper"><table><thead><tr><th rowspan="2"><p><strong>Make new locations to place the MIXCR results</strong></p><p>Make the directories you want, then use PWD to retrieve the locations of these directories.</p></th><th><p><strong>out_dir</strong></p></th><th><p>MIXCR Analyze Output directory.</p><ul><li>This is the first place MIXCR places its analysis output.</li><li><strong>Use PWD to report where this directory lives!</strong></li></ul></th></tr><tr><th><p><strong>b_dir:</strong></p></th><th><p>MIXCR Export directory.</p><ul><li>After running MIXCR analyze, we only want to retrieve IGHV. This is where the human readable MIXCR results will live</li><li><strong>Use PWD to report where this directory lives!</strong></li></ul></th></tr><tr><th rowspan="4"><p><strong>Information about your FASTQ files</strong></p></th><th><p><strong>fastq_dir:</strong></p></th><th><p>The location of all your FASTQ files.</p></th></tr><tr><th><p><strong>sample_names:</strong></p></th><th><p>the list of all your FASTQ file names.</p></th></tr><tr><th><p><strong>FASTQ R1 style</strong></p></th><th rowspan="2"><p>FASTQ files should be in NAME_R1.fastq.gz and NAME_R2.fastq.gz format.</p><ul><li>This means that each file ends with <strong>_R1.fastq.gz</strong> and <strong>_R2.fastq.gz.</strong></li><li>Other formats can exist too for the suffix. Make sure you record what the suffixes are!</li></ul></th></tr><tr><th><p><strong>FASTQ R2 style</strong></p></th></tr><tr><th rowspan="2"><p><strong>Experiment Info</strong></p></th><th><p><strong>Experiment Type or Preset</strong></p></th><th><p>“Preset” or Experiment Type.</p><p>Options include</p><ul><li>RNA-seq (rna-seq)</li><li>WES (exome-seq)</li></ul></th></tr><tr><th><p><strong>Species</strong></p></th><th><p>Species of your sample</p></th></tr></thead></table></div>

**In other words, you should write down something that looks like this for your own reference:**

**b_dir**

/data/lyat/projects/project001/mixcr/set01/special_project_name/02_b_chain

**fastq_dir**

/data/lyat/projects/project001/fastq/01_lymph_node/special_project_name/01_fastq_gz/special_project_name

**out_dir**

/data/lyat/projects/project001/mixcr/set01/special_project_name/01_out

**sample_names**

"S1","S2","S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15","S16","S17","S18","S19","S20","S21","S22","S23","S24","S25","S26","S27","S28","S29","S30","S31","S32","S33","S34","S35","S36","S37","S38","S39","S40","S41","S42","S43","S44","S45","S46","S47","S48","S49","S50","S51","S52","S53","S54","S55","S56","S57","S58","S59","S60","S61","S62","S63","S64","S65","S66","S67","S68","S69","S70","S71","S72","S73","S74","S75","S76","S77","S78","S79","S80","S81","S82"

**FASTQ R1 style:** \_R1.fastq.gz

**FASTQ R2 style:** \_R2.fastq.gz

**For sample_names: Prepare your list of FASTQ names in a very specific way**

The names should be in list format, with quotation marks surrounding each one.

You can convert a column from Excel to this format by using

https://convert.town/column-to-comma-separated-list

Specify the comma as delimiter and simple quotation marks ("") for the Item Prefix and Item Suffix.

**About the Quotations:**

They should be this style of quotation (""), not this style (“”). This (“”) style is called “smart quotations” and they will not work in Biowulf!

"S1","S2","S3","S4","S5","S6","S7","S8","S9","S10","S11","S12","S13","S14","S15","S16","S17","S18","S19","S20","S21","S22","S23","S24","S25","S26","S27","S28","S29","S30","S31","S32","S33","S34","S35","S36","S37","S38","S39","S40","S41","S42","S43","S44","S45","S46","S47","S48","S49","S50","S51","S52","S53","S54","S55","S56","S57","S58","S59","S60","S61","S62","S63","S64","S65","S66","S67","S68","S69","S70","S71","S72","S73","S74","S75","S76","S77","S78","S79","S80","S81","S82"

# Option 1: Minimal Coding Method

## ▶️1. Run the MIXCR Start Tool

**Download the MIXCR Start Tool that Ann Ly created from**

L:\\Lab-Wiestner\\Ann_Ly\\004_special_tools\\mixcr_start_tool

Alternatively, you can get it from my Github. This is the faster way.

**Downloads the MIXCR Start Tool (by Ann Ly) to your Biowulf space.**

Make sure you download the tool near where you will be working with your files.

You can do this by typing into the command line:

git clone https://github.com/atly2000/mixcr_start_tool.git

**You will see a new folder in your working directory called “mixcr_start_tool.”**

- I refer to this as my “mixcr_start_tool” app.
- Next, enter this folder!

cd mixcr_start_tool

**Start the MIXCR Start Tool.**

**You can do this by typing into the command line:**

bash 00_mixcr_start_tool.sh

You will see this menu appear

\-------------------------------------------------------------------------------------------

MIXCR Start TOOL

\-------------------------------------------------------------------------------------------

Hi! This is Ann Ly. I'm a MD/PhD student in Adrian Wiestner's lab.

I can help you prepare for your MIXCR run. When I ask you for some info, just paste it.

If you don't have all this info, we can't run MIXCR.

Make sure you have all the information we need to make MIXCR work.

\-------------------------------------------------------------------------------------------

Menu Navigation Tips

If you change your mind on adding info anytime, you can click Ctrl+C to exit.

Step 1 (make_folders) must be done first.

Steps 2-7 can be done in any order.

After you finish Steps 2-7, select Step 8, the ready_to_go option.

\-------------------------------------------------------------------------------------------

1) make_folders 4) out_dir 7) experiment_info

2) sample_names 5) b_dir 8) ready_to_go

3) fastq_dir 6) fastq_format 9) quit

What information do you want to add?:

To get ready for MIXCR, you should proceed through each item in the menu from steps 1-7.

### 1\. Make_Folders

When you type “1”, this opens the make_folders option.

It creates the folders that will be used to make the inputs for MIXCR.

Select “y” for yes. Once you do, I’ll make the folders for you.

Do you need me to set up the key folders? Only say yes if you are running a completely fresh analysis.

Do you want to continue? (y/n): y

Ok, I made the key folders.

You will see that new folders appear.

### 2\. Sample_Names

Paste your list of sample names in comma-seperated, quotation marks surrounding each name format.

For example,

"S1","S2","S3","S4","S5"

### 3\. Fastq_dir

Paste the location of your FASTQ files.

**For example, I would paste:**

/data/lyat/projects/project001/fastq/01_lymph_node/special_project_name/01_fastq_gz/special_project_name

### 4\. Out_dir

Paste the location where you would like the MIXCR output to go.

**For example, I would paste**

/data/lyat/projects/project001/mixcr/set01/special_project_name/01_out

### 5\. B_dir

Paste the location where you would like the MIXCR IGH, IGK, IGL output to go.

**For example, I would paste**

/data/lyat/projects/project001/mixcr/set01/special_project_name/02_b_chain

### 6\. Specify FASTQ Format

**Note the extension of your fastq files.**

Paste the extension style that they are in when specified.

**ex: \_1.fastq.gz or \_R1.fastq.gz or \_1.fastq or \_R1.fastq**

**ex: \_2.fastq.gz or \_R2.fastq.gz or \_2.fastq or \_R2.fastq**

In my case, I pasted these for each of the styles:

- **FASTQ R1 style:** \_R1.fastq.gz
- **FASTQ R2 style:** \_R2.fastq.gz

### 7\. Experiment Info

**This is where you can edit experiment type and species.**

If you are using Human RNA, then: preset=rna-seq, species=hsa.

- A full list of MIXCR Experiment Types, or presets, can be found here: https://mixcr.com/mixcr/reference/overview-built-in-presets/
- The full list of MIXCR compatible species can be found here: https://mixcr.com/mixcr/reference/mixcr-align/#command-line-options

For example I would paste

- rna-seq
- mmu

**What preset are you using?** Ex.(rna-seq, exome-seq, etc) : rna-seq

**What species are you using?** Ex.(hsa, mmu etc) : mmu

### 8\. Ready to Go

Once Steps 1-6 are done, tell me that we are ready to go by selecting option “8”!

I will combine all the information you listed in steps 1-6.

This will fully prepare the inputs for MIXCR, **and create the final MIXCR script.**

If you want to make any changes, you can always go back to Steps 1-6 and change your input information.

**However, to carry over this information into the final MIXCR script/run, you must select Option 8 again.**

## ▶️2. Verify that all files are there using “tree”

Type “tree” into the command line.

This list of files will appear! It’s all the files generated by the app so that MIXCR can run.

tree

.

├── 00_mixcr_start_tool.sh

├── input

│ ├── b_dir.txt

│ ├── fastq_dir.txt

│ ├── out_dir.txt

│ ├── preset.txt

│ ├── sample_names.txt

│ ├── species.txt

│ ├── status_dir.txt

│ ├── style_R1.txt

│ └── style_R2.txt

├── prep_scripts

│ ├── 01_mixcr_analyze_script_maker.py

│ └── 02_mixcr_script_maker.py

├── run_scripts

│ ├── 01_mixcr_run.swarm

│ ├── 02_mixcr_export.sh

│ └── swarm_report

└── templates

├── 01_TEMPLATE_mixcr_analyze_script_maker.py

└── 02_TEMPLATE_mixcr_export_script_maker.py

## ▶️3. Run the Commands specific to MIXCR

**First, navigate to the run_scripts folder within the mixcr_start_tool folder.**

cd run_scripts

### 1\. Run MIXCR

First, we are running the 01_mixcr_run.swarm script, which runs the main MIXCR run.

The status updates will be placed in this “swarm_report” folder, which is within the run_scripts folder.

swarm -f 01_mixcr_run.swarm -t 12 -g 80 --time 24:00:00 --module mixcr --logdir ./swarm_report/

After you hit enter, Biowulf will spit out a number.

**Write this number down. This is your JOB_ID,** which you will need to monitor the status of the MIXCR run.

- The swarm_report folder contents should share the same JOB_ID as the one that was spit out.
- When you read each status report file, you can see what **FASTQ file is being read in that job.**
- If you have multiple FASTQ files, the JOB will have many sub jobs ex: \_1, \_2, \_3, etc.
- They are **not necessarily following your FASTQ file order. Please read each Job status file to check which FASTQ file is actually being processed by that job.**

Notes

- You can change the 24:00:00 to any time you want. 24 hours specified here is sufficient.
- You can also change “t” the threads, from 12 to any number or “g” the gigabytes from 80 to any value you want.
- Go to https://hpcnihapps.cit.nih.gov/auth/dashboard/ to monitor the status of this job.
    - Select “job Info”
    - You can only go to the next step once all associated jobs are “complete.”
    - **DO NOT run MIXCR EXPORT** if you see any green or red jobs.
    - If jobs are green that means that they are still running.
    - If any jobs turn red, that means they failed. You will have to repeat them alone.
        - This takes some extra scripting.
        - You will have to run that run separately from everyone else, or re-run the entire MIXCR analysis to be safe.

You can also monitor the % complete by checking the mixcr_start_tool/run_scripts/swarm_report files associated with the job ID. I suggest using “tail \*.o” command to show the last few lines of all the “.o” (output) files.

### 2\. Run MIXCR Export

After that first step is done (takes many hours. 5-6 hours), come back to the run_scripts folder and run this.

This should take 2-3 hours at most.

sbatch --mem=10g --cpus-per-task=12 02_mixcr_export.sh

- The status update file will be placed directly into “run_scripts” folder.
- **Write this number down. This is your JOB_ID,** which you will need to monitor the status of the MIXCR run. The status update file that is created shares this same JOB ID.

## ▶️4. MIXCR is Done! Your outputs will be at out_dir and b_dir that you specified.

## ▶️5. Optional: Place the data in a readable way

Run these parts using R.

### 1\. Add helper files and folders

**Create a metadata file in .csv format and place it in a folder called “input”**

Call it sample_table.csv

It needs 4 columns:

- **fastq_id**: ID of the FASTQ file
- **patient_id**: patient or sample ID
- **time_point**: can also be treatment group, condition etc.
- **source_name**: unique identifier. Should not have any repeats in this column
    - Create this by merging patient_id column with time_point column.
    - In reality, you can really use any unique combination

I can contain extra columns too. At minimum you need these four.

**Upload the contents of the “b_dir” outputs from MIXCR** to a folder called “**mixcr_output.”**

They look something like this.

**Create a folder called “output.”**

**The layout of all the files like this**

### 2\. Merge IGH, IGK, and IGL into the same table

Run this Rscript, which uses the folders you just made.

The outputs will be in output/ folder.

| 01_mixcr_lineup_get_counts.R |
| --- |
| library(data.table) #to use fread<br><br>library(dplyr)<br><br>library(tidyr)<br><br>#Load Metadata<br><br>sample_table <- read.csv("input/sample_table.csv")<br><br>fastq_id <- sample_table$fastq_id<br><br>sample <- fastq_id<br><br>#\___\___\___Make the Table of reports_\___\___\___#<br><br>#First, import the .tsv files generated by MIXCR ExportChains<br><br>main_dir <- "mixcr_export/"<br><br>chains <- c("IGH", "IGK", "IGL")<br><br>file_name <- paste0(rep(sample, each=3), "\_", chains, "\_top.tsv")<br><br>#Check for missing files<br><br>file_name_long <- paste0("mixcr_export/",rep(sample, each=3), "\_", chains, "\_top.tsv")<br><br>file_status <- file.exists(file_name_long)<br><br>missing_files <- file_name_long\[!file_status\]<br><br>print("These files are missing: make dummy files for them:")<br><br>print(missing_files)<br><br>print("If nothing was listed, ignore this warning.")<br><br>file_list <- file_name<br><br>cols_keep <- c("readCount","bestVGene","bestDGene","bestJGene","bestCGene","nSeqCDR3","targetSequences")<br><br>#Initialize using the first file<br><br>countData <- data.frame(fread(paste0(main_dir,file_list\[1\])))\[1, cols_keep,drop=FALSE\] #Takes row 1 and the columns to keep<br><br>countData2 <- countData<br><br>#Add remaining files<br><br>for(i in 2:length(file_list)) {<br><br>countData2 = rbind(countData2, data.frame(fread(paste0(main_dir,file_list\[i\])))\[1, cols_keep,drop=FALSE\])<br><br>}<br><br>#Rename rows to the order specified<br><br>col_sample_chain <- paste0(rep(sample, each=3), "\_", chains)<br><br>col_sample<- paste0(rep(sample, each=3))<br><br>col_chain <- rep(chains, times=length(sample))<br><br>countData2$file <- file_name<br><br>countData2$sample_chain <- col_sample_chain<br><br>countData2$fastq_id <- col_sample<br><br>countData2$chain <- col_chain<br><br>#Add the Remaining Metadata<br><br>combine_table &lt;- countData2 %&gt;%<br><br>left_join(sample_table, by = "fastq_id")<br><br>combine_table\[combine_table == ""\] <- NA<br><br>write.csv(combine_table,"output/01_main_mixcr_summary.csv",row.names=F)<br><br>#Load In Key Table<br><br>table_in <- read.csv("output/01_main_mixcr_summary.csv")<br><br>#For each patient_id, sum the total number of reads. Show % of that IGH, IGK, or IGL<br><br>#In the case where IGK > IGL, say it's kappa skewed.<br><br>df &lt;- table_in %&gt;%<br><br>group_by(source_name) %>%<br><br>mutate(total_readCount = sum(readCount)) %>%<br><br>ungroup()<br><br>df$proportion <- df$readCount / df$total_readCount<br><br>light_chain_calls &lt;- df %&gt;%<br><br>filter(chain %in% c("IGK", "IGL")) %>%<br><br>select(source_name, chain, proportion) %>%<br><br>pivot_wider(names_from = chain, values_from = proportion) %>%<br><br>mutate(kappa_lambda = case_when(<br><br>IGK > IGL ~ "kappa",<br><br>IGL > IGK ~ "lambda"), diff_IGL_IGK = IGL - IGK)%>%<br><br>mutate(close_call = if_else(abs(diff_IGL_IGK) < 0.1, "close call", "OK"))<br><br>#############<br><br>df_time <- df<br><br>#Handle the three time points<br><br>IGH_match &lt;- df_time %&gt;%<br><br>filter(chain == "IGH") %>%<br><br>select(patient_id, time_point, bestVGene) %>%<br><br>pivot_wider(names_from = time_point, values_from = bestVGene)<br><br>write.csv(df,"output/02_main_mixcr_summary_ver02.csv",row.names=F)<br><br>write.csv(light_chain_calls,"output/03_mixcr_light_chain_calls.csv",row.names=F)<br><br>write.csv(IGH_match,"output/04_mixcr_IGH_compare.csv",row.names=F) |
| --- |

#### ⚠️Troubleshooting Missing Files

The script can stall if some samples don’t have IGH, IGK, or IGL files.

Identify the missing files, then create dummy files for them.

A dummy file has the name of the missing file, but contains:

| cloneId | readCount | readFraction | targetSequences | targetQualities | allVHitsWithScore | allDHitsWithScore | allJHitsWithScore | allCHitsWithScore | allVAlignments | allDAlignments | allJAlignments | allCAlignments | nSeqFR1 | minQualFR1 | nSeqCDR1 | minQualCDR1 | nSeqFR2 | minQualFR2 | nSeqCDR2 | minQualCDR2 | nSeqFR3 | minQualFR3 | nSeqCDR3 | minQualCDR3 | nSeqFR4 | minQualFR4 | aaSeqFR1 | aaSeqCDR1 | aaSeqFR2 | aaSeqCDR2 | aaSeqFR3 | aaSeqCDR3 | aaSeqFR4 | refPoints | bestVGene | bestDGene | bestJGene | bestCGene |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1   | 0   | 0   | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  | NA  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

#### 

#### Results Interpretation

01_main_mixcr_summary.csv → compiles all the MIXCR outputs into a legible format

02_main_mixcr_summary_ver02.csv → combines the MIXCR output with your metadata

03_mixcr_light_chain_calls.csv → light chain calls per sample

04_mixcr_IGH_compare.csv → use this file to check for IGHV mismatches between “time_points”



