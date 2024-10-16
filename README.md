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
## About
# How are PLFAs converted to biomass?
Phospholipid fatty acids (PLFAs) are found in many types of organisms, but specific PLFAs found in bacteria and multicellular organisms can be used to identify certain lineages. Most PLFAs are not perfectly unique to one lineage, but trends in certain PLFAs can be used as biomarkers for biomass of bacteria, fungi, and overall microbial biomass. 

This code in this repository sums the abundance of PLFAs that are well-established biomarkers of lineages. To use your own classifications, add a row to the file called PLFA_key.csv.


# Credits & Acknowledgements

The National Ecological Observatory Network is a project solely funded by the National Science Foundation and managed under cooperative agreement by Battelle. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.

# Disclaimer
Information and documents contained within this repository are available as-is. Codes or documents, or their use, may not be supported or maintained under any program or service and may not be compatible with data currently available from the NEON Data Portal.
