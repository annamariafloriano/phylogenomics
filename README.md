# phylogenomics
Phylogenomics_wOrthofinder.sh is a simple script that allows to infer phylogenies using a phylogenomics approach - it runs orthofinder, muscle, gblocks, modeltest and RAxML

Run it as: sh Phylogenomics_wOrthofinder.sh -i [data_folder] -t [number of threads] {...}

#
Careful: before running this, it is better to check and maybe change names of the organisms in the header of the FASTA files
example of "good names":
>wNOstrABC_1
>wNOstrABC_2
and so on

#
Careful: check that orthofinder, modeltest-ng and RAxML-HPCthreads is installed on the machine you are using
