#!/bin/bash
#######################################################################
# ======= PBS OPTIONS ======= 
#PBS -q mamba
#PBS -N Read_mapping
#PBS -l nodes=1:ppn=1
#PBS -l walltime=1:00:00
#PBS -V
# send PBS output to /dev/null  (we redirect it below)
#PBS -o /dev/null
#PBS -e /dev/null
# ===== END PBS OPTIONS =====

#######################################################################
SHORT_JOBID=`echo $PBS_JOBID |cut -d. -f1`
exec 1>$PBS_O_WORKDIR/$PBS_JOBNAME-$SHORT_JOBID.out 2>&1


module load bowtie2/2.1.0
module load samtools/0.1.18
module load bcftools/1.3.1



bowtie2-build NC_007898.fasta chloroplast_index
bowtie2 -x chloroplast_index -U SRR1763779.fastq -S chloroplast.sam


samtools view -uS chloroplast.sam | samtools sort - chloroplast_sort
samtools index chloroplast_sort.bam
samtools mpileup -uf  NC_007898.fasta chloroplast_sort.bam | bcftools call -c - | vcfutils.pl vcf2fq > output.fq

seqtk seq -a output.fq > out.fa


