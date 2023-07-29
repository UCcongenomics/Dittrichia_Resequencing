#!/bin/bash

# Directory containing the merged .bam files
input_dir="/projects/dittrichia/mapped_reads1"

# Path to the Picard Tools executable
picard_path="/software/picard/build/libs/"

# Create the output directory for the duplicate-marked reads
output_dir="/projects/dittrichia/mapped_reads1/rm_dup_bams"

mkdir -p "${output_dir}"

# Iterate over the input files in the directory
for input_merged_bam in "${input_dir}"/*.merged.bam; do
    # Extract the base name by removing the extension
    base_name=$(basename "${input_merged_bam}" ".merged.bam")

    # Construct the paths for the output files
    output_markdup_bam="${output_dir}/${base_name}.markdup.bam"
    output_markdup_metrics="${output_dir}/${base_name}.markdup_metrics.txt"
    output_rm_bam="${output_dir}/${base_name}.rm_dup.bam"

    # Mark duplicates using Picard Tools
    java -jar "${picard_path}/picard.jar" MarkDuplicates \
        INPUT="${input_merged_bam}" \
        OUTPUT="${output_markdup_bam}" \
        METRICS_FILE="${output_markdup_metrics}" \
        ASSUME_SORTED=true \
        CREATE_INDEX=true 

    # Remove duplicates using Picard Tools
    java -jar "${picard_path}/picard.jar" MarkDuplicates \
        INPUT="${input_merged_bam}" \
        OUTPUT="${output_rm_bam}" \
        METRICS_FILE="${output_markdup_metrics}" \
        ASSUME_SORTED=true \
        CREATE_INDEX=true \
        REMOVE_DUPLICATES=true

    echo "Duplicates marked and removed for: ${base_name}"
done
