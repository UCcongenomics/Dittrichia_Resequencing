#!/bin/bash

# Path to the reference genome fasta file
reference_genome="/projects/dittrichia/dittrichia_primary_nu_ch_mi.fasta"

# Directory containing the resequencing data
input_dir="fastp_dittrichia_fastqs"

# Path to the BWA executable
bwa_path="bwa"

# Path to the Samtools executable
samtools_path="samtools"

# Path to the Picard Tools executable
picard_path="/software/picard/build/libs/"

# Create the output directory for the mapped reads
output_dir="/projects/dittrichia/mapped_reads1"

# Iterate over the input files in the directory
for input_file_r1_fastp in "${input_dir}"/*.fastp.R1.fastq.gz; do
    # Extract the base name by removing the extension
    base_name=$(basename "${input_file_r1_fastp}" ".fastp.R1.fastq.gz")

    # Construct the paths for the input and output files
    input_file_r2_fastp="${input_dir}/${base_name}.fastp.R2.fastq.gz"
    output_sorted_bam="${output_dir}/${base_name}.sorted.bam"
    output_markdup_bam="${output_dir}/${base_name}.markdup.bam"
    output_markdup_metrics="${output_dir}/${base_name}.markdup_metrics.txt"
    output_rm_bam="${output_dir}/${base_name}.rm_dup.bam"
    # Mark duplicates using Picard Tools
    java -jar "${picard_path}/picard.jar" MarkDuplicates \
        INPUT="${output_sorted_bam}" \
        OUTPUT="${output_markdup_bam}" \
        METRICS_FILE="${output_markdup_metrics}" \
        ASSUME_SORTED=true \
        CREATE_INDEX=true 

    java -jar "${picard_path}/picard.jar" MarkDuplicates \
        INPUT="${output_sorted_bam}" \
        OUTPUT="${output_rm_bam}" \
        METRICS_FILE="${output_markdup_metrics}" \
        ASSUME_SORTED=true \
        CREATE_INDEX=true \
        REMOVE_DUPLICATES=true
    echo "duplicates removed: ${base_name}"
done
