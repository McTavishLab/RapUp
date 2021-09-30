# Extensiphy
### Overview

Extensiphy is a pipeline that assembles homologous loci by aligning reads to a reference from a multiple sequence alignment, calls consensus, adds to the existing alignment. Homologous loci may be kept concatenated or split back into individual alignments prior to phylogenetic estimation.

![Extensiphy_worlflow](./doc/images/EP_workflow_2.png)

Extensiphy takes an alignment and sets of sequencing reads from query taxa (a). Reads are aligned to a reference sequence and a consensus sequence is called (b). The new sequence is added to the alignment and the updated alignment is used to estimate a phylogeny (c).

### Tutorial

We *HIGHLY* recommend you run through the tutorial before using Extensiphy on your own dataset. The tutorial will walk through how to install program dependencies for use with Extensiphy and how to run Extensiphy using different data types and options. Try the tutorial in the tutorial folder. You can copy code snippets into your terminal window.

### Depenencies and Installation

The easiest way to install the depenencies for Extensiphy is to use Conda. You can use the following commands to install all of the dependencies for Extensiphy.

Add appropriate channels to your conda install:

```bash
conda config --prepend channels conda-forge
conda config --prepend channels bioconda
```

Run this command to create a new environment (extensiphy_env) and add the necessary dependencies:

```bash
conda create -n extensiphy_env samtools bwa-mem2 seqtk bcftools fastx-toolkit dendropy raxml
```

Activate your installation

```bash
conda activate extensiphy_env
```


### Setup and Use

The simplest and most hassle free way to run EP is using docker.
We also share conda (link) and direct install recipes (link)

**link to docker approach**


**link conda approach**


**link to manual approach**



Extensiphy now takes inputs in the commandline without requiring a config file.
Extensiphy allows for control over both how many Extensiphy runs happen
in parallel and how many threads are allocated to each Extensiphy run
Make sure you dont ask your computer to work too hard by adding more runs and threads than your computer can handle
find out how many cores you have available and calculate (cores * extensiphy_runs) you wish to run as the same time
if you have 8 cores available, consider starting 2 runs with 3 threads available to each,
then adjust to your optimum setting.

### First Run
Once you've cloned this repo and installed all dependencies to your PATH, begin here. Dependencies are outlined at the bottom of this readme.

If you only plan on using Extensiphy to add data to an existing alignment and tree, use the following command:

```bash
./multi_map.sh -a ./testdata/combo.fas -t ./testdata/combo.tre -d ./testdata
```

** you will know this worked if ... **

If you plan to generate a starting alignment and tree that you wish to add sequences to, test gon_phyling with this command:

```bash
./gon_phyling.sh -d ./gon_phy_testdata
```

#### IMPORTANT!!

Extensiphy requires that you limit the loci you include for updating to sequences with lengths of 1000bp or above. This is to protect the read mapping and basecall accuracy. This is checked when using individual locus alignments as input but when using a concatenated alignment, the user must make this assessment themselves.

### Extensiphy Controls and Flags For Use:

#### Required flags
- (-a) alignment in fasta format,
- (-d) directory of paired end fastq read files for all query taxa,

#### Optional flags
- (-t) tree in Newick format produced from the input alignment that you wish to update with new sequences or specify NONE to perform new inference (DEFAULT: NONE),
- (-1, -2) suffix (ex: R1.fastq or R2.fastq) for both sets of paired end files. Required if suffix is different than default (DEFAULTS: R1.fq and R2.fq),
- (-m) alignment type (SINGLE_LOCUS_FILES, PARSNP_XMFA or CONCAT_MSA) (DEFAULT: CONCAT_MSA),
- (-o) directory name to hold results (DEFAULT: creates rapup_run),
- (-r) Selected a reference sequence from the alignment file for read mapping or leave as default and a random reference will be chosen (DEFAULT: RANDOM),
- (-p) number of taxa to process in parallel,
- (-c) number of threads per taxon being processed,
- (-g) output format (CONCAT_MSA or SINGLE_LOCUS_FILES) (DEFAULT: CONCAT_MSA),
- (-s) specify the suffix (.fa, .fasta, etc) (DEFAULT: .fasta),
- (-b) bootstrapping tree ON or OFF (DEFAULT: OFF)
- (-i) set whether to clean up intermediate output files to save disk space)(KEEP, CLEAN)(DEFAULT: KEEP)

 if using single locus MSA files as input,
- (-f) csv file name to keep track of individual loci when concatenated (DEFAULT: loci_positions.csv),

### Output Files!
- concatenated file: found in your output folder [OUTDIR]/combine_and_infer/extended.aln
- Phylogeny in newick file format: found in your output folder [OUTDIR]/combine_and_infer/RAxML_bestTree.consensusFULL
- taxon specific intermediate files: found in your output folder [OUTDIR]/[TAXON_NAME]. .sam, .bam and .vcf files can be found in here for any additional analyses.

### Gon_phyling Controls and Flags For Use

INPUT OPTIONS:
- (-d) directory of paired end reads. All output folders and files will be contained here
- (-g) the name of the genome you wish to use as a reference during loci selection (if any)(DEFAULT: NONE)
- (-1, -2) suffixes of paired-end input files in read directory (DEFAULT: -1 R1.fastq -2 R2.fastq)

 OUTPUT
- (-b) bootstrapping setting. Do you want to perform 100 boostrap replicates and add the support values to the best tree? (DEFAULT: OFF)
- (-o) output type. Output either a concatenated multiple sequence alignment only or also output separate loci alignment files (DEFAULT: LOCI) (OPTIONS: LOCI, LOCUS)
- (-l) Locus position file. Use if selecting -o LOCUS. Outputs a csv file tracking the loci names and their positions within the concatenated MSA (DEFAULT: gon_phy_locus_positions.csv)

 RUNNING PROGRAM
- (-r) gon_phyling runs. This is the number of genomes assembled at a single time (DEFAULT: 2)
- (-c) Threads for each gon_phyling run. Figure out how many cores you have available and input [# of threads x # of parrallel genome assemblies] = cores you can allocate. (DEFAULT: 2)

## If all you have is raw reads and you need to create a starting tree:
Creating a starting tree!
You need a tree and alignment with any number of taxa in order to update these with new taxa.
gon_phyling.sh is a simple pipeline to de novo assemble reads before using parsnp for loci selection and finally phylogenetic inference.

1. Move some fraction of your reads to a new directory for assembly and starting tree inference.
2. run: 
```bash
./gon_phyling.sh -d [PATH/TO/NEW/READ/DIRECTORY] -1 [READ SUFFIX 1] -2 [READ SUFFIX 2]
```
3. Use the produced alignment file, tree file and the rest of the reads as the inputs for a full Extensiphy run by running:
```bash
 multi_map.sh -a [PATH/TO/ALIGNMENT/FILE] -d [PATH/TO/READ/DIRECTORY] -t [PATH/TO/TREE/FILE] -1 [READ SUFFIX 1] -2 [READ SUFFIX 2].
```

### Tutorial

For a more indepth walkthrough of how to install dependencies for use with Extensiphy and how to run Extensiphy using different data types and options, try the tutorial in the tutorial folder. You can copy code snippets into your terminal window.

## Information

### Advanced User Notes

**Using Extensiphy is limited to Linux at the moment.** Using Ubuntu will ensure the smoothest performance. If you want to use another distro, you'll have to make sure you install analogous one-liners and all that. You have been warned.


### Requirements

You can forgo installing dependencies with Conda and instead install everything by hand if you feel comfortable with computer pathing. 

Dependencies (Separate programs you'll need to install):

1. [Python 3](https://www.python.org/)
2. [bwa-mem2](https://github.com/bwa-mem2/bwa-mem2)
3. [RAxMLHPC](https://github.com/stamatak/standard-RAxML)
4. [Seqtk](https://github.com/lh3/seqtk)
5. [Samtools](http://www.htslib.org/)
6. [Bcftools](http://www.htslib.org/)
7. [Fastx](http://hannonlab.cshl.edu/fastx_toolkit/download.html)
8. [Dendropy](https://dendropy.org/)

Additionally, Extensiphy comes with an additional pipeline for generating a phylogenetic tree from scratch: **Gon\_phyling**. These programs are not required for running Extensiphy itself but Gon\_ling can be useful if you have a lot of data and aren't interested in hand selecting the loci/genes you include in your alignment. Gon\_phyling's dependencies are as follows:

1. [PARSNP](https://harvest.readthedocs.io/en/latest/content/parsnp.html)
2. [Spades](https://github.com/ablab/spades)
3. [BBmap](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/bbmap-guide/) (BBDUK.sh)
4. [RAxMLHPC](https://github.com/stamatak/standard-RAxML)


### Apt-get dependency install
Almost all programs for running Extensiphy are available with apt-get. Hisat2 is not available with apt-get. Run the commands found below to install:

```bash
apt-get install raxml
apt-get install seqtk
apt-get install samtools
apt-get install bcftools
apt-get install fastx-toolkit
pip install dendropy
```

Installs with apt-get for Gon\_phyling are not currently available. You will have to install these programs manually or with conda.

