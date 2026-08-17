#Commands Generator for MIXCR Export
#Written by Ann Ly 8/16/26
#Please do not remove this note. 

list_original=[PATIENT_LIST]


list_original.sort() 
out_dir = 'OUT_LIST'
b_dir ="B_LIST"


print("#!/bin/bash")
print("module load mixcr")

for i in range(len(list_original)): 
  chains=["IGH","IGK","IGL"]
  print('echo "Here comes '+list_original[i]+'"')
  for chain_num in range(len(chains)):
    print("mixcr exportClones --chains "+ chains[chain_num]+" \\")
    print("-readCount -readFraction \\")
    print("-vGene -dGene -jGene \\")
    print("-cGene \\")
    print("-f \\")
    print(out_dir+"/"+list_original[i]+".contigs.clns "+b_dir+"/"+list_original[i]+"_"+chains[chain_num]+"_top.tsv")
  print("")
