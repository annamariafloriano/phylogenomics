# you can use the path to the tools and scripts by uncommenting and modifying these lines:
# notice that you will also have to uncomment other lines throughout the pipeline and comment others (they are indicated in the pipeline)
#Gblocks="/PATH/TO/Gblocks"
#Concatenate="/PATH/TO/Concatenate.pl"
#orthofinder="/PATH/TO/orthofinder"
#modeltest-ng="/PATH/TO/modeltest-ng"
#raxmlHPC-PTHREADS="PATH/TO/raxmlHPC-PTHREADS"
#muscle="/PATH/TO/muscle"

while getopts i:t:c:b: flag
do
    case "${flag}" in
        i) input=${OPTARG};; # input folder of protein FASTA files
		t) threads=${OPTARG};; # number of threads to use
		c) Concatenate=${OPTARG};; # path to the script to concatenate FASTAs
		b) bootstrap=${OPTARG};; # number of bootstraps

	esac
done

#run orthofinder
orthofinder -f $input -t $threads -S blast
# if you are running this by uncommenting the paths, comment the previous orthofinder command and uncomment the following:
# $orthofinder -f $input -t $threads -S blast

cp -r $input/OrthoFinder/*/Single_Copy_Orthologue_Sequences/ .

#align single copy panorthologs and give the extension .aln to the files
for i in Single_Copy_Orthologue_Sequences/*.fa; do muscle -in $i -out $i.aln; done
# if you are running this by uncommenting the paths, comment the previous muscle command and uncomment the following:
# for i in Single_Copy_Orthologue_Sequences/*.fa; do $muscle -in $i -out $i.aln; done

#run Gblocks
for a in Single_Copy_Orthologue_Sequences/*.aln; do Gblocks $a -t=p; done
# if you are running this by uncommenting the paths, comment the previous Gblocks command and uncomment the following:
#for a in Single_Copy_Orthologue_Sequences/*.aln; do $Gblocks $a -t=p; done


# create a folder and put the polished alignments in it
mkdir Single_Copy_Orthologue_Sequences_AlnGb
cp Single_Copy_Orthologue_Sequences/*gb Single_Copy_Orthologue_Sequences_AlnGb/

perl $Concatenate Single_Copy_Orthologue_Sequences_AlnGb/ > Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta


modeltest-ng -i Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta -p $threads -T raxml -d aa
# if you are running this by uncommenting the path, comment the previous modeltest-ng command and uncomment the following:
# $modeltest-ng -i Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta -p $threads -T raxml -d aa

model=$(awk '/AICc/,0' Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta.out | grep "raxmlHPC-SSE3" | cut -d "-" -f 4 | cut -d " " -f2)

# run RAxML
raxmlHPC-PTHREADS -T $threads -f a -s Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta -n Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta.boot -m "${model}" -x 1234 -# $bootstrap -p 123
# if you are running this by uncommenting the path, comment the previous RAxML command and uncomment the following:
# $raxmlHPC-PTHREADS -T $threads -f a -# $bootstrap -s Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta -n Single_Copy_Orthologue_Sequences_AlnGb.cat.fasta.boot -m "${model}" -x 1234 -p 123

echo ""
echo ""
echo "Thank you for using this script!"
echo "AM Floriano"
echo ""
echo ""
