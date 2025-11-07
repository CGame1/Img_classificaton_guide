# Cross-Validation with YOLO


Welcome! This repo provides access to Jupyter notebooks that demonstrate how to (1) implement [cross-validation with YOLO]("https://colab.research.google.com/github/CGame1/Img_classificaton_guide/blob/main/notebooks/CrossVal_with_Yolo.ipynb") for image classification in Python and (2) [deploy a trained YOLO model]("https://colab.research.google.com/github/CGame1/Img_classificaton_guide/blob/main/notebooks/Yolo_classifier_deployment_colab.ipynb"), from [Hugging Face]("https://huggingface.co/") for example, on new images 📷🌊🐙🤖

 

These are designed to be beginner-friendly, with the option to run them entirely online using Google Colab — no installation or GPU required. However, if you're more comfortable with Python and Jupyter, you can also clone thia repository and run it locally. 

No data is required, as the code also downloads an open-source [dataset](https://huggingface.co/datasets/CGame1/schulz_bank_biotopes) from [Hugging Face](https://huggingface.co/). Note that this is a copy of the original [dataset](https://doi.pangaea.de/10.1594/PANGAEA.949920) (for faster access), see [Meyer et al., 2023](https://www.sciencedirect.com/science/article/pii/S0967063722002333#da0010) for details.

This resource is a supplement to our paper: *Deep Blueprint: A Literature Review and Guide to Automated Image Classification for Ecologists*
 (see below).

*For R users*: A shiny app (and associated R code) is also available [here](https://github.com/Npiechaud/Benthic-Images-CV/tree/main/shiny_app) for preparing the YOLO training set.

![Classification workflow](https://github.com/CGame1/Img_classificaton_guide/blob/main/docs/workflow.png?raw=true)
*Figure 1: Simplified and idealized diagram of an ML scenario. Each box represents a key task and corresponds to a section of this paper to aid comprehension.  While presented largely linearly for clarity, real-world ML workflows are often iterative and non-linear and the need to revisit specific sections may vary depending on the scenario.*



## 📚 How to Cite This Work


If you use this code, please cite our **preprint**:

> Game, C.A., Piechaud, N. and Howell, K.L. (2025)  **“Deep Blueprint: A Literature Review and Guide to Automated Image Classification for Ecologists,” **  *bioRxiv*, p. 2025.11.03.686223. Available at:  [https://doi.org/10.1101/2025.11.03.686223](https://doi.org/10.1101/2025.11.03.686223). 

Or use the following BibTeX entry:

```bibtex

@article {Game2025.11.03.686223,
	author = {Game, Chloe A. and Piechaud, Nils and Howell, Kerry L.},
	title = {Deep Blueprint: A Literature Review and Guide to Automated Image Classification for Ecologists},
	elocation-id = {2025.11.03.686223},
	year = {2025},
	doi = {10.1101/2025.11.03.686223},
	publisher = {Cold Spring Harbor Laboratory},
	URL = {https://www.biorxiv.org/content/early/2025/11/04/2025.11.03.686223},
	eprint = {https://www.biorxiv.org/content/early/2025/11/04/2025.11.03.686223.full.pdf},
	journal = {bioRxiv}
}


