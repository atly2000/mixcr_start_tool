#Commands Generator for MIXCR Analyze
#Written by Ann Ly 8/16/26
#Please do not remove this note. 

list_original=[PATIENT_LIST]

list_original.sort() 
fastq_dir='FASTQ_LIST'
out_dir = 'OUT_LIST'


print("#SWARM --sbatch='--export=FASTQ_DIR="+fastq_dir+",OUT_DIR="+out_dir+"'")
for i in range(len(list_original)): 
 print("mixcr analyze rna-seq \\")
 print("--species hsa \\")
 print("${FASTQ_DIR}/"+list_original[i]+"STYLE_R1 \\")
 print("${FASTQ_DIR}/"+list_original[i]+"STYLE_R2 \\")
 print("${OUT_DIR}/"+list_original[i]+" \\")
 print("-f \\")
 print("-t 8") 

