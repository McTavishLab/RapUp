---

title: Extensiphy Tutorial

author: Jasper Toscani Field

output: html_document

---
# Extensiphy tutorial

Hello!

This tutorial will walk you through installing and using **Extensiphy**, a program for rapidly updating multiple sequence alignments. I try not to assume too much knowledge of programming and program use standards so this tutorial should be accessable for beginning and advanced bioinformaticians.


## Description

Extensiphy is a tool for updating an existing multiple sequence alignment and a phylogeny inferred from that alignment. Say you built a phylogeny for a group of bacteria during an outbreak and then received some new sequencing data that you wish to quickly incorporate into the phylogeny. Extensiphy makes it convenient to do this while also ensuring you can easily do this again any time you acquire new data.

### Use cases and required files

You can use Extensiphy in multiple ways. Depending on the input and output you wish to receive, you will need different data in different formats.Here are some example use cases:

##### You want an alignment with new taxa added and a tree from that alignment
You need:
* Alignment file (fasta format)
* Directory of paired-end read files
* (Optional but recommended) a tree generated from input alignment

##### You want multiple single locus files and a tree from all of those alignment files
You need:
* Multiple seperate locus multiple sequence alignment files (fasta format) **OR**
  * A single concatenated multiple sequence alignment file 
  * A CSV file illustrating locus lengths and positions
* Directory of paired-end read files
* (Optional but recommended) a tree generated from combining all the loci


### A Few Notes on Code Examples

The code snippets I have included in this tutorial can be copied straight into your terminal unless they include something like: 
```bash
path/to/file/or/program
```
This notation indicates that you should replace this string segment with the absolute or relative path to the program/file/directory as indicated. Additionally, You'll see '$' (dollar signs) in front of code snippets. These should not be included when you copy and past the code into your terminal window. These dollar signs are only included to indicate the line with the actual code snippet and not the results of the command.


### Dependencies

Unfortunately, Extensiphy requires some dependencies. You know what they say about not reinventing the wheel. We'll walk through the basics of installation and adding the installed programs to your path so that Extensiphy can use them.

Using Extensiphy is limited to Linux at the moment. Using Ubuntu will ensure the smoothest performance. If you want to use another distro, you'll have to make sure you install analogous one-liners and all that. You have been warned.

[Dependencies](https://github.com/McTavishLab/extensiphy) (Links to separate programs you'll need to install can be found at the bottom of the Extensiphy readme):


### Pathing

Extensiphy will need to automatically look for its dependency programs in your computers PATH. If you're new to the inner workings of computers, think of your PATH as a set of programs or locations on your computer that your computer automatically knows the location of. The following is a basic tutorial on adding programs to your PATH.

First you'll need to find the ```.bash_profile``` file on your computer. This file lives in your home directory when you first open a terminal. Here's how you find it:

```bash
open terminal
$ls -a
.bash_profile
other_files_in_your_home_directory

$echo $PATH
home/your_name/bin:home/your_name/other_folders/in_your/path:

$vim .bash_profile
```
At this point you'll need to add the programs you've downloaded and unpacked to your .bash_profile in the following format. Add all of this as one line, filling in the appropriate absolute pathing. If you don't see this file when using `ls -a` then you need to create it.

```bash

export PATH="/home/your_name/path/to/program:$PATH"

```

An example of what I see is:

```bash

export PATH="/home/jasper/src/SPAdes-3.13.0-Linux:$PATH"

```

Once you've added all your programs to your PATH, close the terminal window and reopen it. Then use the `which` command to see if your computer knows where the program is located

```bash

$which bwa-mem2

/home/your_name/bwa-mem2_folder/bwa-mem2

```

I installed hisat2 in a bin folder so I see:

```bash

/home/jasper/bin/bwa-mem2

```



## Running Extensiphy

### Extensiphy Help Menu
Extensiphy takes command line arguments to update an alignment with new taxa sequences. Lets look at the options used by Extensiphy. Extensiphy use revolves around calling the 

```bash
$./multi_map.sh
```

command followed by flags (dashes next to a letter corresponding the command you wish to use or input).

```bash
$./multi_map.sh -h
```

has the following output:

```bash
Extensiphy is a program for quickly adding genomic sequence data to multiple sequence alignments and phylogenies. 
     View the README for more specific information. 
     Inputs are generally a multiple sequence file in. 
     fasta format and a directory of. 
     Fastq paired-end read sequences.     


 EXAMPLE COMMAND:     

 /path/to/multi_map.sh -a /path/to/alignment_file -d /path/to/directory_of_reads [any other options]     

 (-a) alignment in fasta format,     
 (-d) directory of paired end fastq read files for all query taxa,     
 (-u) produce only an updated alignment or perform full phylogenetic estimation (ALIGN or PHYLO) (DEFAULT: ALIGN)
    
 (-t) tree in Newick format produced from the input alignment that you wish to update with new sequences or specify NONE to perform new inference (DEFAULT: NONE),     
 (-m) alignment type (SINGLE_LOCUS_FILES, PARSNP_XMFA or CONCAT_MSA) (DEFAULT: CONCAT_MSA),     
 (-o) directory name to hold results (DEFAULT: creates rapup_run),     
 (-i) clean up intermediate output files to save HD space (Options: CLEAN, KEEP)(DEFAULT: KEEP),     
 (-r) Selected a reference sequence from the alignment file for read mapping or leave as default and a random reference will be chosen (DEFAULT: RANDOM),     
 (-p) number of taxa to process in parallel,     
 (-c) number of threads per taxon being processed,     
 (-e) set read-type as single end (SE) or pair-end (PE) (DEFAULT: PE)     
 (-1, -2) suffix (ex: R1.fastq or R2.fastq) for both sets of paired end files (DEFAULTS: R1.fq and R2.fq),     
 (-g) output format (CONCAT_MSA or SINGLE_LOCUS_FILES) (DEFAULT: CONCAT_MSA),     
 (-s) specify the suffix (.fa, .fasta, etc) (DEFAULT: .fasta),     
 (-b) bootstrapping tree ON or OFF (DEFAULT: OFF)     


 if using single locus MSA files as input,     
 (-f) csv file name to keep track of individual loci when concatenated (DEFAULT: loci_positions.csv),     
 (-n) Set size of loci size cutoff used as input or output (Options: int number)(DEFAULT: 700)
```

Extensiphy has a number of default settings for these so you will not always have to explicitly use all of these options for every run. The use of these flags depends on the input you wish to use and the output you desire to have at the end of a run.

First lets try a basic test case. Within the Extensiphy folder is a folder called 

```bash
testdata
```

### A Basic Extensiphy Run
This folder contains a variety of files for testing your installation and use of Extensiphy.
combo.fas is the alignment file we want to update.
The files ending in R1.fq and R2.fq are the raw reads files in fastq format. These reads are paired-end files. When using Extensiphy, you need to specify the name of the folder that contains all the reads corresponding to samples you wish to add to your alignment.

Lets use Extensiphy to update a multiple sequence alignment with some new data. Run this command in the Extensiphy folder:

```bash

$./multi_map.sh -a ./testdata/combo.fas -d ./testdata -o first_extensiphy_run

```

This command takes in an alignment file (combo.fas) with the *-a* flag and a directory containing some paired-end read files with the -d flag. The *-o* flag specifies the name of our output folder. The other flags use their default values in this case. The result of this is that Extensiphy will add the taxa sequences from the read files to combo.fas and produce the updated alignment file; extended.aln. Regardless of the name of the Extensiphy run directory, all output files (alignments and phylogenies) will be in the *outputs* folder:

```bash
~/first_extensiphy_run/outputs/extended.aln
```

If you decided to install RAxML, you can use Extensiphy to estimate a phylogeny from the updated alignment using this command:

```bash
$./multi_map.sh -a ./testdata/combo.fas -d ./testdata -o first_extensiphy_run -u PHYLO
```
The *-u* flag tells Extensiphy that you want to change the use case. Extensiphy only updates the alignment by default. Adding [-u PHYLO] to your command will indicate that a phylogeny should be estimated from the updated alignment.


Additionally, Extensiphy can use RAxML's starting tree functionality. If an alignment AND a phylogeny based on that phylogeny are input into Extensiphy, RAxML can use the original tree as a starting tree when estimating the relationships of the new, updated phylogeny. Lets run a command to take as intput the same alignment and a tree that was produced from that alignment before adding new sequences. Run the following command:

```bash
$./multi_map.sh -a ./testdata/combo.fas -u PHYLO -t ./testdata/combo.tre -d ./testdata -o second_extensiphy_run
```

The [-t] flag indicates that you're assigning a tree file as input that corresponds with the alignment file you indicated. The tree file is then used as a starting tree when performing the new, full maximum likelihood search instead of a randomly generated tree.

Lets look at the original tree that DOESN'T included our new sequences: ![sequences](images/tree_image_3.png?raw=true)

Now, if either run completed successfully you'll see a full phylogenetic tree that looks like this: ![this](images/tree_image_2.png?raw=true)

We just added 3 new taxa to a starting multiple sequence alignment and obtained a tree that includes these new taxa. Notice that the new sequences we wanted to add (taxon_30, taxon_31 and taxon_32) have been added to the clade highlighted in the red box.

Selecting a particular reference from the alignment may be important to a particular analysis. You can select a reference by using the -r flag followed by the name of the taxon/sequence. First, lets look at a list of our included taxa. Run the following command in the Extensiphy directory:

```bash
grep ">" ./testdata/combo.fas
```

You should see something like this:

```bash
>taxon_12
>taxon_16.ref
>taxon_22
>taxon_25
>taxon_10
>taxon_17
>taxon_20
>taxon_23
>taxon_21
>taxon_18
>taxon_13
>taxon_15
>taxon_14
>taxon_27
>taxon_11
>taxon_1
>taxon_28
>taxon_26
>taxon_19
>taxon_24
```

Lets take one of our taxa and use that sequence as the reference. I chose taxon_11 because its on a long branch far from where we expect our sequences to placed in the tree. Make sure you leave off the carrot (>) from the taxon name. Run this command:

```bash
$./multi_map.sh -a ./testdata/combo.fas -d ./testdata -t ./testdata/combo.tre -o third_Extensiphy_run -r taxon_11
```

Did you get the same tree as the output of our original run?



### Starting with Multiple Single Locus Alignments
Lets try starting with multiple single locus files instead of a single, concatenated sequence file. Use the following commands to look at our single locus files:

```bash
$ls /testdata/single_locus_align_dir/
/testdata/single_locus_align_dir/single_locus_1_.fasta
/testdata/single_locus_align_dir/single_locus_2_.fasta
```

Both of these files contain the homologous sequence for a number of taxa. The first one is a rather big sequence of over 10,000 bases. The second one is a smaller sequence of 4 bases. Take a look at them like so:

```bash
$head -2 /testdata/single_locus_align_dir/single_locus_1_.fasta
$head -2 /testdata/single_locus_align_dir/single_locus_2_.fasta
```

You'll see that one file's sequence is indeed very large while the second file's sequence is only a few letters. This is deliberate to display a function of Extensiphy when selecting which data to input. Extensiphy should only be used with loci over 1,000 bases long. If taking these files as input, the smaller sequence file will be identified and removed before construction of a concatenated sequence. Lets run a new analyses.

Now, enter the following command:

```bash
$./multi_map.sh -a ./testdata/single_locus_align_dir -d ./testdata -m SINGLE_LOCUS_FILES -o fourth_Extensiphy_run
```

The -m flag allows you to specify a number of input options. by using -m SINGLE_LOCUS_FILES, we are indicating that the alignment option (-a) will point to a directory containing multiple single locus alignment files that share all the sample taxon names. It is VERY important that all the taxa labels have the same names or this function will not work. This run will take the single loci MSA files, check for loci longer than the cut-off of 1,000 nucleotides and construct a concatenated alignment of those loci. A file capturing the length and positions of those loci can be found in the

```bash
loci_positions.csv
```

file. This file is a comma delimited file capturing the loci's position in the concatenated alignment, the loci's file name and the loci's length. This will be useful if you decide to split your concatenated multiple sequence alignment back into single locus (gene) alignment files or just want to know how long each locus in your concatenated alignment is.


If you have already produced a species-tree from multiple single locus alignments, Extensiphy can take that tree as input along with your separate locus files. Run the following command to read in some multiple single locus alignments and the tree corresponding to the relationships inferred from all of the combined loci. We'll also give our new Extensiphy run output folder a new name so we can distinguish it from our old run.

```bash
$./multi_map.sh -a ./testdata/single_locus_align_dir -d ./testdata -t ./testdata/combo.tre -m SINGLE_LOCUS_FILES -o split_Extensiphy_run

```

Maybe you also want to output single locus alignment files that have been updated with your new query sequences. Run this command to do that:

```bash
$./multi_map.sh -a ./testdata/single_locus_align_dir -d ./testdata -t ./testdata/combo.tre -m SINGLE_LOCUS_FILES -g SINGLE_LOCUS_FILES -o locus_out_Extensiphy_run

```

The -g flag allows you to specify the format you wish your output alignments to take (CONCAT_MSA or SINGLE_LOCUS_FILES). When selecting SINGLE_LOCUS_FILES, a concatenated alignment file is produced ASWELL as a folder that contains the separated single locus alignment files in fasta format. Lets take a look at them.

From the Extensiphy folder, run:

```bash
$ls ./locus_out_Extensiphy_run/combine_and_infer/updated_single_loci/
single_locus_1_.fasta
```

You'll notice that there is only a single file here corresponding to a single locus alignment. This is because one of the loci we tried to input into Extensiphy was only 4 nucleotides long, far short of the 1000 nucleotide cutoff for using Extensiphy!

As an additional use-case, Extensiphy can take Parsnp output files as inputs. This time, we'll use a raw Parsnp file (parsnp.xmfa) file as our input alignment. Parsnp is an automatic homologous locus selection tool for bacterial sequences. The output is not in a standard .fasta format so there is normally some additional processing necessary. Alternatively, Extensiphy will convert the .xmfa file to a fasta file when you add new sequences to the alignment. Use this command:

```bash
$./multi_map.sh -a ./testdata/parsnp.xmfa -d ./testdata -t ./testdata/combo.tre -m PARSNP_XMFA -o parsnp_Extensiphy_run

```

This concludes the tutorial. Hopefully you understand a little more about using Extensiphy and how to apply Extensiphy to your use-case and data.
