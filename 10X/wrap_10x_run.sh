#! /bin/bash

#$ -cwd
#$ -q long
#$ -P regevlab

#$ -e error.err
#$ -o out.log


source /broad/software/scripts/useuse 
export PATH=/ahg/regevdata/projects/10X_runs/CELL_RANGER/cellranger-1.0.1:$PATH
which cellranger
which bcl2fastq

id=P17_Retina
bcl_path=/ahg/regev_nextseq/Data/160422_NB501164_0150_AH3MVGBGXY
fastq_path=H3MVGBGXY/outs/fastq_path

#comma seperated

transcriptome_path=/ahg/regevdata/projects/10X_runs/REFERENCES/refdata-cellranger-1.0.0/mm10

echo $id

cellranger demux --run=${bcl_path}

cellranger run --id=${id} \
	       --transcriptome=${transcriptome_path} \
	       --fastqs=${fastq_path} \
	       --jobmode=sge \
	       --indices=SI-3A-C1,SI-3A-C2,SI-3A-C3 \
	       --maxjobs=12 \
	       --mempercore=16 \
	       #--uiport=3600
