#!/bin/bash

# Path to the reference genome fasta file
reference_genome="/projects/dittrichia/dittrichia_primary_nu_ch_mi.fasta"

# Directory containing the resequencing data
input_dir="/projects/dittrichia/test"

# Path to the BWA executable
bwa_path="bwa"

# Path to the Samtools executable
samtools_path="samtools"

# Path to the Picard Tools executable
#picard_path="/path/to/picard"

# Create the output directory for the mapped reads
output_dir="/projects/dittrichia/mapped_reads"
mkdir -p "${output_dir}"

# Iterate over the input files in the directory
for input_file_r1_fastp in "${input_dir}"/*.fastp.R1.fastq.gz; do
    # Extract the base name by removing the extension
    base_name=$(basename "${input_file_r1_fastp}" ".fastp.R1.fastq.gz")

    # Construct the paths for the input and output files
    input_file_r2_fastp="${input_dir}/${base_name}.fastp.R2.fastq.gz"
    output_sam="${output_dir}/${base_name}.sam"
    output_bam="${output_dir}/${base_name}.bam"
    output_sorted_bam="${output_dir}/${base_name}.sorted.bam"
 #   output_markdup_bam="${output_dir}/${base_name}.markdup.bam"
 #   output_markdup_metrics="${output_dir}/${base_name}.markdup_metrics.txt"

    # Run BWA mem to map the reads to the reference genome
    "${bwa_path}" mem -t 8 "${reference_genome}" "${input_file_r1_fastp}" "${input_file_r2_fastp}" > "${output_sam}"

    # Convert SAM to BAM
    "${samtools_path}" view -@ 8 -bS "${output_sam}" > "${output_bam}"

    # Remove SAM file
     rm "${output_sam}"

    # Sort the BAM file
    "${samtools_path}" sort -@ 8 -o "${output_sorted_bam}" "${output_bam}"

    # Index the sorted BAM file
    "${samtools_path}" index "${output_sorted_bam}"

    # Mark duplicates using Picard Tools
  #  java -jar "${picard_path}/picard.jar" MarkDuplicates \
   #     INPUT="${output_sorted_bam}" \
    #    OUTPUT="${output_markdup_bam}" \
     #   METRICS_FILE="${output_markdup_metrics}" \
      #  ASSUME_SORTED=true \
       # CREATE_INDEX=true

    echo "Mapped, processed: ${base_name}"
