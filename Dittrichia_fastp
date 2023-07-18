#!/bin/bash

# Directory containing the input FASTQ files
input_dir="/waveser/raw/RachelMeyer/dittrichia_novaseq_backup"
#input_dir="/projects/dittrichia/test"

# Directory to store the output FASTP files
output_dir="/projects/dittrichia/fastp_dittrichia_fastqs"

# Fastp settings
fastp_options="--trim_poly_g --trim_poly_x -t 1 -T 1 --n_base_limit 5 --detect_adapter_for_pe --qualified_quality_phred 20 --cut_mean_quality 30 --average_qual 25 --low_complexity_filter --thread 8 --dont_overwrite --length_required 25 --correction --dedup --trim_poly_g -5 -3 -r -W 5"

# Iterate over the input R1 files in the directory
for input_file_r1 in "${input_dir}"/*_R1_*.fastq.gz; do
    # Extract the base name by removing "_R1_" and the extension
    base_name=$(basename "${input_file_r1}" | sed 's/_R1_.*//')

    # Construct the paths for the input and output files
    input_file_r2="${input_dir}/${base_name}_R2_001.fastq.gz"
    output_file1="${output_dir}/${base_name}.fastp.R1.fastq.gz"
    output_file2="${output_dir}/${base_name}.fastp.R2.fastq.gz"
    html_report="${output_dir}/${base_name}.fastp.html"
    json_report="${output_dir}/${base_name}.fastp.json"

    # Run fastp on the input files
    fastp --in1 "${input_file_r1}" --out1 "${output_file1}" \
          --in2 "${input_file_r2}" --out2 "${output_file2}" \
          --html "${html_report}" \
          --json "${json_report}" ${fastp_options}

    echo "Processed: ${base_name}"
done
