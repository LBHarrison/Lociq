# Lociq

## Background

In short, the Lociq program is a MLST generator for closed, circular sequences that uses both sequence and structural components.  The program was designed with plasmid biology in mind as plasmid molecules are prone to selective pressures and recombination events that affect both plasmid sequence and plasmid structure.


## Installation:

First, make a directory for Lociq.  Navigate to your directory of choice and clone Lociq from github:
```
git clone https://github.com/lbharrison/lociq.git
cd lociq
```
Installing the dependencies occurs in three stages: conda, git and R

### I. conda

Lociq requires the installation of both [Roary](https://github.com/sanger-pathogens/Roary) and [AMRFinder](https://github.com/ncbi/amr/wiki).

These may be installed individually, or through the [conda](https://anaconda.org/) environment.

The easiest way to do this through the conda environment is to install the dependencies from a list then update the AMRFinder database:

```
conda create --name lociq --file lociq.lst
conda activate lociq
amrfinder --update
```

If installing from the list isn't a viable/preferred option, the following approach has been successful.

N.B. Order of installation is important!

```
conda create --name lociq
conda activate lociq
conda install -c "bioconda/label/cf201901" roary
conda install -c bioconda ncbi-amrfinderplus
conda update --all
amrfinder --update
```

If you choose to avoid the [conda](https://anaconda.org/) installation, please ensure that  [Roary](https://github.com/sanger-pathogens/Roary) and [AMRFinder](https://github.com/ncbi/amr/wiki) are globally executable


### II. git

The next stage involves installing the program named [piggy](https://github.com/harry-thorpe/piggy.git) which identifies the conserved intergenic regions in a dataset

Installation is possible through GitHub.  Again, order of installation is important.  Please do not attempt installation of [piggy](https://github.com/harry-thorpe/piggy.git) until [Roary](https://github.com/sanger-pathogens/Roary) has sucessfully been installed.

```
git clone https://github.com/harry-thorpe/piggy.git
```


### III. R

Finally, the [R](https://cran.r-project.org/) environment needs to be prepared for the Lociq pipeline

First, enter the [R](https://cran.r-project.org/) environment

```
R
```

Second, install the "[remotes](https://cran.r-project.org/web/packages/remotes/index.html)", "[pacman](https://cran.r-project.org/web/packages/pacman/index.html)" and "[optparse](https://cran.r-project.org/web/packages/optparse/index.html)" packages (~30 seconds)

```
install.packages(c("remotes", "pacman", "optparse"))
```

Third, install "[plyr](https://cran.r-project.org/web/packages/plyr/index.html)","[tidyr](https://cran.r-project.org/web/packages/tidyr/index.html)","[dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)","[Hmisc](https://cran.r-project.org/web/packages/Hmisc/index.html)" Through the [pacman]((https://cran.r-project.org/web/packages/pacman/index.html)) package(~10 minutes)

```
library(pacman)
p_install_version(c("plyr","tidyr","dplyr","Hmisc"), c("1.8.6", "1.2.0", "1.0.9", "4.7-1"))
```

Now, install the "[DECIPHER](https://bioconductor.org/packages/release/bioc/html/DECIPHER.html)" package through Bioconductor (~5 minutes)

```
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("DECIPHER")
```

The last package set to install is "[corrplot](https://cran.r-project.org/web/packages/corrplot/index.html)" and the packages for the shiny app "[shiny](https://cran.r-project.org/web/packages/shiny/index.html)", "[shinythemes](https://cran.r-project.org/web/packages/shinythemes/index.html)", "[DT](https://cran.r-project.org/web/packages/DT/index.html)", and "[genoPlotR](https://cran.r-project.org/web/packages/genoPlotR/index.html)"(~60 seconds)

```
library(remotes)
install_version("corrplot","0.84")

library(pacman)
p_install_version(c("shiny","shinythemes","DT","genoPlotR"), c("1.7.3", "1.2.0", "0.27", "0.8.11"))
```

Finally, check to ensure the [R](https://cran.r-project.org/) dependencies were successfully installed with the following:

```
system("./checkdep.R")
```

If no more packages need to be installed, simply exit from the [R](https://cran.r-project.org/) environment

```
quit()
```

Optional:  Sample datasets may be accessed and prepared from here:  https://github.com/lbharrison/lociq_sample



## Usage:
### Examples
To test and see if everything is set up properly, prepare the sample datasets and enter the following (~30 minutes):

```
./T.step1 -G ~/Project/Lociq/db/GFF/ -P ~/Project/Lociq/piggy/bin/piggy

./R.step2 -m ~/Project/Lociq/db/combinedplasmid.csv -i 0.9 -o 0.1 -p IncC_1__JN157804

./T.step3 -p IncC_1__JN157804 -D ~/Project/Lociq/db/plsdb -M ~/Project/Lociq/db/plsdb.names -i 0.9 -o 0.01

./T.step4 -d ~/Project/Lociq/db/plsdb -f ~/Project/Lociq/IncC_1__JN157804/validated/IncC_1__JN157804_validated.fasta -i 1000 -p IncC_1__JN157804

./T.step5 -p IncC_1__JN157804 -d ~/Project/Lociq/db/plsdb -f ~/Project/Lociq/IncC_1__JN157804/validated/IncC_1__JN157804_validated.fasta

./T.step6 -p IncC_1__JN157804 -n addition -i new.fasta
```
Note - the example commands make the following assumptions:
- the Lociq program was cloned into the ~/Project folder
- the Piggy program was cloned into the ~/Project/Lociq folder
- the Lociq sample datasets were extracted and prepared into the ~/Project/Lociq/db folder

Please update the commands to reflect the correct paths, if necessary


This will perform the entire analysis from pangenome construction to plasmid subtyping of the IncC plasmids plus the analysis of a new plasmid set (new.fasta) output into the ./addition directory

### Example Step Descriptions

Construct the pangenome (~5 minutes)
- ./T.step1 -G (path to gff files) -P (piggy executable)

Identify loci in plasmid group of interest (~2 minutes)
- ./R.step2 -m (metadata file for in-house dataset) -i (within group threshold) -o (outside group threshold) -p (plasmid type of interest)

Validate loci against reference database (~2 minutes)
- ./T.step3 -p (plasmid type of interest) -D (reference database) -M (reference database metadata) -i (within group threshold) -o (outside group threshold)

Identify conserved plasmid fragments (~3 minutes)
- ./T.step4 -d (reference database) -f (validated loci fasta) -i (inter-loci distance threshold) -p (plasmid type of interest)


Analyze reference database to define sequence and structure types (~20 minutes)
- ./T.step5 -p (plasmid type of interest) -d (reference database) -f (validated loci fasta)

As needed, analyze new plasmid sequences (Optional) (~15 seconds per plasmid)
- ./T.step6 -p (plasmid type of interest) -n (name of new project) -i (fasta file to analyze)


## Program Details:

### Step 1: Construct the Pangenome
#### Description:
The first step generates the combined pangenome of coding and intergenic regions contained in the plasmid dataset.  The pangenome is presented as a binary matrix and organized by heirarchical clustering in R.
#### Required Files:
1. directory containing gff files of closed plasmid sequences

#### Output:
1. ./roary/gene.pam1 - presence/absence matrix of loci
2. ./roary/merged.gff - merged annotation files for all sequences in dataset
3. ./roary/Step1.Rdata - Data file for the 1st stage of R analysis

#### Template:
./T.step1 -G (path to gff files) -P (piggy executable)

### Step 2: Typing Loci I

#### Description:
The second step identifies which loci are both indicative of and selective for a plasmid type of interest.  The program evaluates the prevalence of each typing locus among plasmids of a given type versus the prevalence of the locus among plasmids that are not of that plasmid type.  Loci that meet user-defined stringency requirements are the unvalidated typing loci.  Coding region loci are recovered directly from the merged annotation file.  Intergenic region loci are also collected from the merged annotation file, and the consensus sequence of each intergenic locus is reported.

#### Required files:
1. A presence/absence metadata file that assigns plasmid type to plasmids in the local dataset

#### Output:
1. /(plasmid-type-of-interest)/(plasmid-type-of-interest\)\_Loci_highlight_PAM.png - gene/IGR PAM with the plasmid type of interest highlighted
2. /(plasmid-type-of-interest)/(plasmid-type-of-interest)\_unvalidated_prevalence_plot.png - a scatterplot of loci with prevalence within group along the y-axis and outside the group along the x-axis
3. /(plasmid-type-of-interest)/unvalidated_loci.fasta - sequences of loci that pass user defined threshold values, but have not yet been validated against an external database
4. /(plasmid-type-of-interest)/data/Step2.Rdata - Data file for the 2nd stage of R analysis

#### Template:
./R.step2 -m (metadata file for in-house dataset) -i (within group threshold) -o (outside group threshold) -p (plasmid type of interest)


### Step 3: Typing Loci II

#### Description:
The third step evaluates the prevalence of the unvalidated typing loci among plasmids in an external database.  This step is intended to reduce the bias in loci selection that could result if the initial sample dataset does not represent the general plasmid population.

#### Required files:
1. Reference database of closed plasmid sequences
2. Metadata for closed plasmid sequence database, same format as metadata file for local dataset

#### Output:
1. /(plasmid-type-of-interest)/(plasmid-type-of-interest)\_validated_prevalence_plot.png - a scatterplot of loci with prevalence within group along the y-axis and outside the group along the x-axis
2. /(plasmid-type-of-interest)/(plasmid-type-of-interest)\_prevalence_plot_no_threshold.png - Same as above, but without the threshold values.  Useful for troubleshooting if no loci pass validation.
3. /(plasmid-type-of-interest)/validated/(plasmid-type-of-interest)\_validated.fasta - plasmid typing loci that have passed the validation screening
4. /(plasmid-type-of-interest)/data/Step3.Rdata - Data file for the 3rd stage of R analysis

#### Template:
./T.step3 -p (plasmid type of interest) -D (reference database) -M (reference database metadata) -i (within group threshold) -o (outside group threshold)


### Step 4: Plasmid Fragment ID

#### Template:
./T.step4 -d (reference database) -f (validated loci fasta) -i (inter-loci distance threshold) -p (plasmid type of interest)

#### Required files:
1. Reference database of closed plasmid sequences
2. Fasta file of validated typing loci (generated in Step 3)

#### Output:
1. /(plasmid-type-of-interest)/(plasmid-type-of-interest)\_Interaction_Matrix_(user-defined-interfragment-distance-threshold).png - correlogram depicting plasmid fragments
2. /(plasmid-type-of-interest)/fragments/fragment.stats - R & p values for plasmid fragment correlation coefficients
3. /(plasmid-type-of-interest)/fragments/indexing.loci - Plasmid typing loci that are used to index the starting position of the sequence.  Most frequent indexing locus is listed first.
4. /(plasmid-type-of-interest)/fragments/loci.index - Reference file detailing which locus belongs to which fragment
5. /(plasmid-type-of-interest)/data/Step4.Rdata - Data file for the 4th stage of R analysis

#### Description:
The fourth step identifies conserved, contiguous regions of loci among the plasmid dataset.  This is done by 1. analyzing the proximity of all loci within each plasmid, 2. assigning neighboring loci into groups based on a user-defined threshold distance, 3. generating an all-to-all tally of how often any two loci are present in the same neighboring group and 4. generating a correlation matrix of the interactions and identifying the conserved contiguous plasmid fragments in the population using a Pearson's correllation coefficient ccutoff value of 0.9.


### Step 5: Plasmid Subtyping

#### Description:
The fifth step codifies the typing loci alleles, assigns fragment type, sequence type loci type and interfragment distances, identifies AMR and stress genes, generates a summary of plasmid types and prepares the data for visualization in an R-shiny app.

#### Template:
./T.step5 -p (plasmid type of interest) -d (reference database) -f (validated loci fasta)

#### Required Input:
1. Reference database of closed plasmid sequences
2. Fasta file of validated typing loci (generated in Step 3)

#### Output:
1. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_summary.csv - Summary Results File of Sequence, Loci, Fragment Type and Interfragment distances.  <--- __This Is The Main Output For The Program__
2. /(plasmid-type-of-interest)/analysis/indexed.fasta - plasmid sequences rewritten to start at the plasmid index location
3. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_AMR.results - bulk records of plasmid AMR data and position
4. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_Loci_Allele_Sequence.csv - sequence definitions of typing loci/alleles
5. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_plasmid.data - annotation data for plasmid visualization
6. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_plasmid.results - bulk records of plasmid structural data
7. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_Reference_Structure_FragmentLoci.csv - reference file for how loci order defines the fragment pattern ID
8. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_SequenceType.csv - Reference file defining fragment sequence type from allelic pattern
9. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_PlasmidFragment.csv - Reference file defining the fragment structure type of the plasmid based on the order of fragments
10. /(plasmid-type-of-interest)/results/(plasmid-type-of-interest)\_PlasmidLoci.csv- Reference file defining the plasmid loci structure type based on the combined fragment structure types present on the plasmid

*Note.1, some spreadsheet programs drop trailing zeroes and "1.10" will be indistinguishable from "1.1".  Proceed with caution and verify data integrity with a text editor.*

*Note.2, Fragment Pattern ID's are based off the ordinal arrangement of fragments with identical neighbors condensed.  For example, plasmid fragment order (1,1,2,3,4) and plasmid fragment order (1,2,3,4,4) are both categorized as plasmid order (1,2,3,4).  This is done to keep the Fragment ID values consistent even if the user changes the inter-loci distance threshold to separate plasmid fragments.*

### Step 6: New Plasmid Analysis

#### Description:
The sixth step is used to analyze new plasmid sequences.  Once you have generated the typing metrics for a given plasmid type, analysis of new plasmid sequences can be performed by executing the sixth step alone.

#### Template:
./T.step6 -p (plasmid-type-of-interest) -n (name-of-new-project) -i (fasta file to analyze)

#### Required Input:
1. New plasmid sequence in \*.fasta format
2. Typing metrics for plasmid of interest (generated in Step 5)

#### Output:
The output for this step is the same as step 5, however it will be in in the ./(name-of-new-project) directory

## Visualization:

To launch the companion application to view the results, enter the following:

```
./lociq.viz <plasmid-type-of-interest>
```

OR

```
./lociq.viz <name-of-project>
```

In essence, the plasmid-type-of-interest and name-of-project simply refer to the parent directory where your results of interest are already stored.
