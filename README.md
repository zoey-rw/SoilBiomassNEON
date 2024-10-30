# SoilBiomassNEON
Code for estimating soil microbial biomass from phospholipid fatty acid (PLFA) collected by NEON.

This repo has all PLFA data from NEON's 2024 release within the `raw_data` directory. To use for a different set of files, first download the PLFA data from NEON using the `neonUtilities` package:

```
# # install neonUtilities - can skip if already installed
# install.packages("neonUtilities")

library(neonUtilities)
plfaData <- loadByProduct(site = "HARV",
						#site="all", # Can download all sites at once
						dpID = "DP1.10104.001", 
						package = "expanded", check.size = F)

# Save data files as an RDS object for easy loading back into R
saveRDS(plfaData, "./raw_data/NEON_plfa_HARV.rds")

# To save a file explaining the variables included:
write_csv(plfaData$variables_10104, "./reference_data/NEON_PLFA_variable_key.csv")
```
Then, run the `estimateMicrobialBiomass.r` script, which will overwrite the `NEON_microbial_biomass_PLFA.rds` output file in this repository.

![Example plot](https://github.com/zoey-rw/SoilBiomassNEON/blob/main/fungi_plot.png?raw=true)
This is an example of the one output metrics: the proportion of fungal biomass in soils across NEON infrastructure (sites here are organized by latitude).

## About
# How are PLFAs converted to biomass?
Phospholipid fatty acids (PLFAs) are found in many types of organisms, but specific PLFAs found in bacteria and multicellular organisms can be used to identify certain lineages. Most PLFAs are not perfectly unique to one lineage, but trends in certain PLFAs can be used as biomarkers for biomass of bacteria, fungi, and overall microbial biomass. 

This code in this repository sums the abundance of PLFAs that are well-established biomarkers of lineages (Lewe et al. 2021, Quideau et al. 2016, Olsson et al 1995). To use your own classifications, add a row to the file called PLFA_to_biomass_key.csv.

If you notice an error or would recommend a change to the PLFA/biomass classifications, please create an issue or pull request with suggestions! 

# References 

Lewe, Natascha, et al. "Phospholipid fatty acid (PLFA) analysis as a tool to estimate absolute abundances from compositional 16S rRNA bacterial metabarcoding data." Journal of Microbiological Methods 188 (2021): 106271.

Olsson, Pål Axel, et al. "The use of phospholipid and neutral lipid fatty acids to estimate biomass of arbuscular mycorrhizal fungi in soil." Mycological Research 99.5 (1995): 623-629.

Quideau, Sylvie A., et al. "Extraction and analysis of microbial phospholipid fatty acids in soils." JoVE (Journal of Visualized Experiments) 114 (2016): e54360.

# Credits & Acknowledgements

The National Ecological Observatory Network is a project solely funded by the National Science Foundation and managed under cooperative agreement by Battelle. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.

# Disclaimer
Information and documents contained within this repository are available as-is. Codes or documents, or their use, may not be supported or maintained under any program or service and may not be compatible with data currently available from the NEON Data Portal.
