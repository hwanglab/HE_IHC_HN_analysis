## Integrative Spatial Analysis of H&E and IHC Images Identifies Prognostic Immune Subtypes correlated with Progression Free Survival in HPV-Related Oropharyngeal Squamous Cell Carcinoma

Many people with a certain type of throat cancer (HPV+ OPSCC) get better, but about 20% have the disease come back or spread. It's important to find signs that can tell which patients might face these issues. Our study looked closely at the variety of immune cells in these cancers. Using computer methods and special slides, we studied the types and roles of these cells. We grouped patients based on these cell patterns. Our findings suggest that patients with more specific immune cells in their tumors tend to have better chances of not seeing their disease return.


![Final_Manuscript_fig_1](https://github.com/hwanglab/HE_IHC_HN_analysis/assets/96131627/b133b708-49fc-4265-990f-dbc9e59ae1e6)




1. The Jupyter notebook named KM_plots_paper_submission.ipynb produces all the plots required for the paper.<br>
2. plot-cox.R produce Figure 4 in the manuscript.<br>
3. The registration codes for the H&E and IHC images can be foung in [https://github.com/hwanglab/WSI_registration.git]<br>
4. The data folder contains processed data for all the patients in a csv file format.
5. For the TIL, Stroma, Tumor predictions on a tile level on H&E, we used pretrained model from [https://github.com/hwanglab/TILs_Analysis.git]
6. For the grid level prediction and patient level predictions of Immune inflamed, Immune excluded and Immune desert are performed using Immune_pheno.ipynb

## Registration

For registration, please see [here](https://github.com/hwanglab/WSI_registration)

## License

© This project is licensed under GPL - see the [LICENSE](https://github.com/hwanglab/HE_IHC_HN_analysis/blob/master/LICENSE) file for details.

## Acknowledgements
This study was funded internally at Mayo Clinic, Florida. We thank the patients and their families. 

## Contact
Reach out to the [Hwang Lab](https://www.hwanglab.org/).

<div align="center">
    <img src="https://github.com/hwanglab/HE_IHC_HN_analysis/assets/52568892/b7f928d1-09cc-4923-975e-8aebf3fc4907" alt="hwanglab_mayo" width="600"/>
</div>
