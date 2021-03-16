# Funnel web spiders are a menace

[![Status](https://img.shields.io/badge/Status-in%20preparation-red.svg?style=flat-square)]()
[![License (GPL version 3)](https://img.shields.io/badge/License-GNU%20GPL%20version%203-brightgreen.svg?style=flat-square)](http://opensource.org/licenses/GPL-3.0)
[![DOI](https://img.shields.io/badge/DOI-10.5281/TODO.svg?style=flat-square)](https://dx.doi.org/10.5281)

[Jeffrey O. Hanson](http://www.jeffrey-hanson.com)

Correspondance should be addressed to [jeffrey.hanson@uqconnect.edu.au](mailto:jeffrey.hanson@uqconnect.edu.au)

**This repository provides an example for organizing scientific projects. All data, findings, and conclusions are satire. This work does not provide any real world insight.**

### Research summary

Funnel web spiders are ferocious beasts that terrorize humans across Australia. In particular, they wreak havoc on the local tourism industry of Fraser Island. Here we examine the population of funnel web spiders found along the walking path from a camp site in Fraser Island to Lake Boomanjin. To achieve this, we subdivided the walking path into multiple transects and surveyed each transect multiple times over 8 days. We then used open _n_-mixture models to estimate population size within each transect. Our models indicate that over 800 spiders could occur along this walking track. Fortunately, our models suggest that few spiders occur near the camp site -- meaning that tourists may be relatively safe along long as they do not stray too far from the camp site. In conclusion, the dense infestation of spiders poses a serious threat to the safety of tourists and we recommend for their immediate eradication.

### Overview

This repository contains the data and code that underpins the findings in our manuscript "_Funnel web spiders are a menace_". [After downloading this repository from a persistent digital data archive](https://dx.doi.org/10.5281/TODO), you can rerun the entire analysis on your own computer using the system command `make clean all`. The files in this repository are organized as follows:
* article
  + manuscript main text, figures, tables, and supporting information.
* data
  + _raw_: raw data used to run the analysis.
  + _intermediate_: intermediate data generated during processing.
  + _final_: results used in the paper.
* code
  + _parameters_: settings for running the analyses in [TOML format](https://github.com/toml-lang/toml).
  + [_R_](www.r-project.org): code used to run the analysis.
  + [_rmarkdown_](wwww.rmarkdown.rstudio.com): files used to compile the manuscript.

### Software required

* Operating system
	+ Ubuntu (Trusty 14.04 LTS)
* Programs
	+ R (version 4.0.3)
	+ GNU make
	+ pandoc
	+ pandoc-citeproc
	+ LaTeX
