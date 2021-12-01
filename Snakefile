"""
Snakefile for running genome assembly
on Octopus bimaculoides HiFi reads

Simply running `snakemake` will run all analysis
defined by the arguments above.

"""

import pathlib
import sys
import os
import subprocess
import numpy as np
import glob




# ###############################################################################
# GENERAL RULES & GLOBALS
# ###############################################################################

# Where you would like all output files from analysis to live

cwd = os.getcwd()
output_dir = cwd + "/output"
input_dir = "/projects/kernlab/shared/data/octBim/hifi_reads/real/"
prefix = "octoBim.asm"
out_pre = output_dir + "/" + prefix
hifiasm_exec = "hifiasm/hifiasm"

infile = glob.glob(f"{input_dir}/*.gz")
s_param = ["0.1","0.2","0.3","0.4","0.5"]
# Run full pipeline!
rule all:
   input: expand( out_pre +".{s_par}.p_ctg.assembly_stats", s_par=s_param)



# ###############################################################################
# hifiasm
# ###############################################################################

gfa = expand(out_pre + ".{s_par}.p_ctg.gfa", s_par=s_param)

rule run_hifiasm:
    input: infile
    output: out_pre+".{s_par}.p_ctg.gfa"
    threads:20
    shell: "hifiasm/hifiasm -o " + out_pre +".{wildcards.s_par} -s {wildcards.s_par} -t {threads} --primary  {input}"

rule gfa_to_fastq:
    input: out_pre+".{s_par}.p_ctg.gfa"
    output: out_pre+".{s_par}.p_ctg.fastq.gz"
    threads: 3
    shell: "awk \'/^S/{{print \">\"$2\"\\n\"$3}}\' {input} | fold | gzip > {output}"

rule assembly_stats:
    input: out_pre+".{s_par}.p_ctg.fastq.gz"
    output: out_pre+".{s_par}.p_ctg.assembly_stats"
    threads:1
    shell: "assembly-stats {input} > {output}"
