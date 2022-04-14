# phylogenomics
Phylogenomics_wOrthofinder.sh is a simple script that allows to infer phylogenies using a phylogenomics approach - it runs orthofinder, muscle, gblocks, modeltest and RAxML

Run it as: sh Phylogenomics_wOrthofinder.sh -i [data_folder] -t [number of threads] {...}

#
Please notice:

[1]
Careful: before running this, it is better to check and maybe change names of the organisms in the header of the FASTA files
example of "good names":
>wNOstrABC_1
>wNOstrABC_2
and so on

[2]
requires: 
orthofinder, modeltest-ng, RAxML-HPCthreads, Gblocks, muscle, a script to concatenate sequences.

[3]
Change the headers in the input FASTAs to have the accession numbers of the genomes in the beginning of the sequences names to avoid issues with the names length. I provided an easy way to change the names back in the final tree using R (and the package ape) in renameTreeTips.
