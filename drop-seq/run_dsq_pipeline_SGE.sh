#!/bin/bash

# Author : Karthik Shekhar, 05/26/2016
# Master file for invoking Drop-seq pipline 
# SGE invocation
# usage : ./run_dsq_pipeline_LSF.sh [fastqPath]
# assumes : files are organized as $fastqPath/SampleX_R1.fastq.gz and $fastqPath/SampleX_R2.fastq.gz

#Values depend on sample
fastqPath=$1
refFastaPath=/broad/mccarroll/software/metadata/individual_reference/GRCh37.75_GRCm38.81/m38_transgene/m38_transgene.fasta
metaDataDir=/broad/mccarroll/software/metadata/individual_reference/GRCh37.75_GRCm38.81/m38_transgene
numCells=(1500 3000 3000) 
queue=regevlab
baseDir=`readlink -f ..`

rm -rf ../Analysis ../bsub_logs ../bam* ../*DGE ../temp* ../QC* ./run_files ../synthesis_err_stats
mkdir -p ../bsub_logs
mkdir -p ../Analysis
mkdir -p ../QC_files
mkdir -p ../QC_reports
mkdir -p ../tempQC
mkdir -p ../bam_reads
mkdir -p ../synthesis_err_stats
mkdir -p run_files

mkdir -p ../bams_HUMAN_MOUSE
mkdir -p ../UMI_DGE
mkdir -p ../reads_DGE

l=0
for fq1 in $fastqPath/*R1*;
do

#STEP 1 : CREATE NEW INSTANCE OF RUN FILE FOR SAMPLE
fq2=${fq1/R1/R2}

#Get absolute paths
fq1=`readlink -f ${fq1}`
fq2=`readlink -f ${fq2}`

bfq1=`basename ${fq1}`
bfq2=`basename ${fq2}`

b0=`echo ${bfq1} | grep -P '^[a-zA-Z0-9\_]*_R1' -o`
b=${b0/_R1/}
sed "s|fName|${b}|g;s|fastq1|${fq1}|g;s|fastq2|${fq2}|g;s|bamFileName|${b}|g;s|numCellsNum|${numCells[l]}|g;s|refFasta|${refFastaPath}|g;s|metaDataLoc|${metaDataDir}|g;s|basedir|${baseDir}|g" < run_Alignment_SGE.sh > run_Alignment_SGE_${b}.sh
errfile=${baseDir}/bsub_logs/${b}.err
outfile=${baseDir}/bsub_logs/${b}.out
sed -i "s|error.err|${errfile}|g;s|out.out|${outfile}|g" run_Alignment_SGE_${b}.sh
chmod +x run_Alignment_SGE_${b}.sh
mv run_Alignment_SGE_${b}.sh run_files

qsub run_files/run_Alignment_SGE_${b}.sh -e ${baseDir}/bsub_logs/${b}.err -o ${baseDir}/bsub_logs/${b}.out

echo ${numCells[l]}
l=`expr $l + 1`
done








