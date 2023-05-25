#!/usr/bin/env python

import sys
from Bio import SeqIO
import os
import argparse


parser=argparse.ArgumentParser(description='Concatenate sequences by organism')
parser.add_argument('-d', help='Path to directory with aligned clusters',type=str)
parser.add_argument('-o', help='Name of the output file',type=str)

args = parser.parse_args()
Dir = args.d
output_file = args.o

# Create a dictionary to contain the orthologues of an organism
ortho_organism = {}

# do it for every file ending with .fst.aln in the dir
for file in os.listdir(Dir): ## for every file in Dir
    if file.endswith('.fst.aln'): ## if it ends with .fst.aln
        file_path = os.path.join(Dir, file) ## target file
        
# Read the FASTA file and save the seqs in the corresponding organism
        with open(file_path, 'r') as f:
            for record in SeqIO.parse(f, 'fasta'):
                organism = record.id.split('_')[0]  # To get the organism name (ids contain organism name followed by underscore and number of the protein in the genomic annotation of the organism)
               
                if organism not in ortho_organism:
                    ortho_organism[organism] = []
                ortho_organism[organism].append(str(record.seq))
                
# Write the concatenated sequences of each organism in a single file
with open(output_file, 'w') as f:
    for organism, orthos in ortho_organism.items():
        concatenated_seq = ''.join(orthos)
        f.write(f'>{organism}\n{concatenated_seq}\n')

