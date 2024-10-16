library(tidyverse)

# Read in the PLFA data and keys from Github repository
plfaData <- readRDS(url("https://github.com/zoey-rw/SoilBiomassNEON/raw/refs/heads/main/raw_data/NEON_plfa.rds"))

plfa_var_key = read_csv(url("https://raw.githubusercontent.com/zoey-rw/SoilBiomassNEON/refs/heads/main/reference_data/PLFA_to_biomass_key.csv"))

# Or local files
#plfaData <- readRDS("./raw_data/NEON_plfa.rds")
#plfa_var_key = read_csv("./reference_data/NEON_PLFA_variable_key.csv")

# Select variables for important PLFA markers, as well as sample identifiers and quality flags
variables_to_keep = plfa_var_key$neonVariable %>% unique() %>% 
    c("biomassID", "siteID","dataQF","analysisResultsQF",
      "cis18To1n9ScaledConcentration","c20To5n3ScaledConcentration","c16To1n7ScaledConcentration")

# Subset the dataframe to columns of interest
# Using data that has been "scaled" to an internal standard 
plfa_scaled = plfaData$sme_scaledMicrobialBiomass %>% 
    filter(analysisResultsQF == "OK") %>% 
    select(all_of(variables_to_keep))


gram_positive_bac = plfa_var_key %>% 
    filter(grepl("Gram-positive", paste(targetGroup, targetGroupBroad))) %>% 
    select(neonVariable) %>% unlist

gram_negative_bac = plfa_var_key %>% 
    filter(grepl("Gram-negative", paste(targetGroup, targetGroupBroad))) %>% 
    select(neonVariable) %>% unlist

arbuscular_fungi = plfa_var_key %>% 
    filter(grepl("Gram-arbuscular", paste(targetGroup, targetGroupBroad))) %>% 
    select(neonVariable) %>% unlist

sap_ecto_fungi = plfa_var_key %>% 
    filter(grepl("saprotrophic", paste(targetGroup, targetGroupBroad))) %>% 
    select(neonVariable) %>% unlist

fungi_minus_amf = plfa_var_key %>% 
    filter(grepl("fungi", paste(targetGroup, targetGroupBroad))) %>% 
    select(neonVariable) %>% unlist
    
# Includes many organisms, not just microbes
total_biomass = "totalLipidScaledConcentration"


arbuscular_fungi = c(arbuscular_fungi, "c20To5n3ScaledConcentration")
bacteria = c(gram_positive_bac, gram_negative_bac)
fungi = c(fungi_minus_amf, sap_ecto_fungi, arbuscular_fungi)
bacteria_fungi_total = c(bacteria, fungi)


plfa_grouped = plfa_scaled %>% #group_by(sampleID, biomassID, siteID) %>% 
    mutate(gram_positive_sum = rowSums(across(!!gram_positive_bac),na.rm=T),
           gram_negative_sum = rowSums(across(!!gram_negative_bac),na.rm=T),
           sap_ecto_fungi_sum = rowSums(across(!!sap_ecto_fungi), na.rm=T),
           fungi_minus_amf_sum =  rowSums(across(!!fungi_minus_amf),na.rm=T),
           arbuscular_fungi_sum = rowSums(across(!!arbuscular_fungi),na.rm=T),
           total_biomass = rowSums(across(!!total_biomass),na.rm=T),
           bacteria_fungi_total =  rowSums(across(!!bacteria_fungi_total),na.rm=T),
           total_fungi = fungi_minus_amf_sum + arbuscular_fungi_sum + sap_ecto_fungi_sum,
           total_bacteria = gram_positive_sum + gram_negative_sum,
           proportion_fungi = total_fungi/bacteria_fungi_total,
           proportion_bacteria = total_bacteria/bacteria_fungi_total,
           proportion_sap_ecto_fungi = sap_ecto_fungi_sum/bacteria_fungi_total,
           proportion_arbuscular_fungi = arbuscular_fungi_sum/bacteria_fungi_total)

biomass_to_save = plfa_grouped %>% select(siteID, biomassID,                                           proportion_fungi,  proportion_bacteria,total_fungi, total_bacteria, 
                                          proportion_sap_ecto_fungi, proportion_arbuscular_fungi, 
                                          bacteria_fungi_total,
                                          total_biomass) 

saveRDS(biomass_to_save, "./NEON_microbial_biomass_PLFA.rds")

# Quick look at how observations vary across sites!
biomass_to_save %>% ggplot() + geom_point(aes(x = siteID, y = proportion_fungi))
