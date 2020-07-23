# ESSCompress v2.0

A tool to compress a set of k-mers represented in FASTA/FASTQ file(s).


## Installation

### Requirements

- Linux operating system (64 bit)

### Steps

1. Download the latest Linux 64-bit [binaries](https://github.com/medvedevgroup/ESSCompress/releases/download/v2.0/essCompress-v2.0-linux-64.tar.gz).   
`wget https://github.com/medvedevgroup/ESSCompress/releases/download/v2.0/essCompress-v2.0-linux-64.tar.gz`

2. Extract the `.tar.gz` file and change into uncompressed directory.   
`tar xvzf essCompress-v2.0-linux-64.tar.gz`   
`cd essCompress-v2.0/`


3. You will see two scripts in the directory: `essCompress` and `essDecompress`.
	- Use the command `./essCompress` and `./essDecompress` to get directions on how to use the tool.



## Quick start with a step-by-step example

*This example assumes that you are currently inside the base directory `essCompress-v2.0` after you have completed installing the tool as per the the instructions.*

Lets say you have a small fasta file of sequences, i.e. examples/smallExample.fa, and   
`cat examples/smallExample.fa` returns

```
>
AAAAAAACCCCCCCCCC
>
CCCCCCCCCCA
```
We can compress it using k=11 as follows
```
./essCompress -k 11 -i examples/smallExample.fa
```  
Now `ls examples` will show both original input file and compressed file in the same directory:

```
smallExample.fa
smallExample.fa.essc
...
```
smallExample.fa.essc is a compressed binary file generated by MFCompress, so it is not in a readable format.

To decompress into a readable format, you can run
```
./essDecompress examples/smallExample.fa.essc   
```

You'll now see the decompressed file example.fa.essd in the same directory.   
`cat examples/smallExample.fa.essd ` will return:    

```
>
AAAAAAACCCCCCCCCCA
```
Notice that the decompressed fasta file is not the same as the original file, but it contains the same k-mers as smallExample.fa. You can double check this using the command   
`./aux/essAuxValidate 11 smallExample.fa smallExample.fa.essd`   
If they contain the same k-mers (i.e. 11-mers), you will see an output like this:

```
### SUCCESS: The two files contain same k-mers! ###
```


## Usage details

### essCompress: compression of a k-mer set

       Syntax: ./essCompress [parameters]   

       mandatory parameters:  
       -i [filepath]     Full path for input file.        
	   -k [INT]          k-mer size (must be >=4)

	   optional parameters:  
	   -a [INT]          DEFAULT=1. Sets a threshold X, such that k-mers that appear less than X times in the input dataset are filtered out. 	   -f		     Fast compression mode: uses less memory, but achieves smaller compression ratio.
	   -h                Print this Help.
	   -v                Enable verbose mode: print more useful information.
	   -c                Verify correctness: check that all the distinct k-mers in the input file appears exactly once in the compressed output file.



#### Input for essCompress

Two important input parameters are
* input [-i]   
* k-mer size [-k]   

File input format can be   
	1. a single fasta or fastq file (either gzipped or not)   
	2. a text file containing the list of multiple fasta/fastq files (one file per line)	 

To pass a single file as input and compress: `./essCompress -i examples/11mers.fa -k 11`

To pass several files as input, generate the list of files (one file per line) as follows:

```
ls -1 examples/*.fa > list_reads   
./essCompress -i list_reads -k 5
```

ESS-Compress uses BCALM 2 under the hood, which does not care about paired-end information, all given reads contribute to k-mers in the graph (as long as such k-mers pass the abundance threshold).



#### Output for essCompress
The compressed output is in a file with `.essc` extension.





### essDecompress: decompression of .essc file

        Syntax: ./essDecompress [file_to_decompress]

*Input*: a *.essc* file generated by essCompress   
*Output*: a fasta file with *.essd* extension, where all the distinct k-mers represented by the input .essc file appear exactly once. In other words, output is a [spectrum-preserving string set](http://doi.org/10.1007/978-3-030-45257-5_10).


## Installation from source

### Pre-requisites
- Linux operating system (64 bit)

- Git

- GCC >= 4.8 or a C++11 capable compiler   

- CMake 3.1+   

### Steps

Download source and install:

       git clone https://github.com/medvedevgroup/ESSCompress
       cd ESSCompress
       ./INSTALL

Upon successful execution of this script, you will see linux binaries for [BCALM](https://github.com/GATB/bcalm) (`essAuxBcalm`), [DSK](https://github.com/GATB/dsk) (`essAuxDsk` and `essAuxDsk2ascii`) and [MFCompress](http://bioinformatics.ua.pt/software/mfcompress/) (`essAuxMFCompressC` and `essAuxMFCompressD`) in the `aux` folder, along with `essAuxValidate`, `essAuxCompress` and `essAuxDecompress`.



## Citation

If using ESS-Compresss in your research, please cite
* Amatur Rahman, Rayan Chikhi and Paul Medvedev, Disk compression of k-mer sets, WABI 2020.
