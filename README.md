
This repository contains BayesCAT, a software package implementing a Bayesian Co-estimation of Alignment and Tree, described in [Shim and Larget 2014](https://github.com/heejungshim/BayesCAT/tree/master/doc/paper).

BayesCAT is a free software, you can redistribute it and/or modify it under
the terms of the GNU General Public License (GPLv3+).

The GNU General Public License does not permit this software to be
redistributed in proprietary programs.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## BayesCAT

The BayesCAT software implements a joint model for co-estimating phylogeny and sequence alignment. Traditionally, phylogeny and sequence alignment are estimated separately: first estimate a multiple sequence alignment and then infer a phylogeny based on the sequence alignment estimated in the previous step. However, uncertainty in the alignment estimation is ignored, resulting, possibly, in overstated certainty in phylogeny estimates. The implemented joint model for co-estimating phylogeny and sequence alignment improves estimates from the traditional approach by accounting for uncertainty in the alignment in phylogenetic inferences. 

Compared to alternative joint methods, our insertion and deletion (indel) model allows arbitrary-length overlapping indel events and a general distribution for indel fragment size. In addition, we explicitly model a completely history of indel events on the tree. Therefore, our approach enables us to infer more information about the indel process.

The implemented methods for joint estimation of phylogeny and sequence alignment  
+ infer phylogeny while accounting for uncertainty in the alignment
+ summarize alignment samples
+ infer more information about the indel process.

## Binary executable file

Binary executable file for Linux is in the `BayesCAT/bin/` directory (complied on 11/19/2014).

## Installation

cd into the `BayesCAT/src` directory

    make

Then, binary executable file will be created in the `BayesCAT/src` directory.

## User manual 

User manual is in the `BayesCAT/doc/manual` directory.

## News

See the [`NEWS`](https://github.com/heejungshim/BayesCAT/blob/master/NEWS) file.

## Bug reports

Report bugs as issues on this repository or email the [mailing list](bayescatusers@googlegroups.com).

## How to cite WaveQTL

Heejung Shim and Bret Larget (2014). [BayesCAT: Bayesian Co-estimation of Alignment and Tree](https://github.com/heejungshim/BayesCAT/tree/master/doc/paper). Under review.

## Author

[Heejung Shim](https://github.com/heejungshim) (University of Chicago)


