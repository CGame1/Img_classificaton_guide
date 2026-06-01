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


If you use this code, please cite our **paper**:

<!-- > Game, C.A., Piechaud, N. and Howell, K.L. (2025)  **“Deep Blueprint: A Literature Review and Guide to Automated Image Classification for Ecologists”**,  *bioRxiv*, p. 2025.11.03.686223. Available at:  [https://doi.org/10.1101/2025.11.03.686223](https://doi.org/10.1101/2025.11.03.686223).  -->

> Game, C. A., Piechaud, N., & Howell, K. L. (2026). **"Deep blueprint: A literature review and guide to automated image classification for ecologists"** Journal of Animal Ecology, 00, 1–28. Available at:  [https://doi.org/10.1111/1365-2656.70271](https://doi.org/10.1111/1365-2656.70271)

Or use the following BibTeX entry:

<!-- @article {Game2025.11.03.686223,
	author = {Game, Chloe A. and Piechaud, Nils and Howell, Kerry L.},
	title = {Deep Blueprint: A Literature Review and Guide to Automated Image Classification for Ecologists},
	elocation-id = {2025.11.03.686223},
	year = {2025},
	doi = {10.1101/2025.11.03.686223},
	publisher = {Cold Spring Harbor Laboratory},
	URL = {https://www.biorxiv.org/content/early/2025/11/04/2025.11.03.686223},
	eprint = {https://www.biorxiv.org/content/early/2025/11/04/2025.11.03.686223.full.pdf},
	journal = {bioRxiv}
} -->

```bibtex
@article{Game2026,
author = {Game, Chloe A. and Piechaud, Nils and Howell, Kerry L.},
title = {Deep blueprint: A literature review and guide to automated image classification for ecologists},
journal = {Journal of Animal Ecology},
volume = {00},
number = {n/a},
pages = {1-28},
keywords = {benthic imagery, biotope classification, convolutional neural networks, deep learning, deep-sea ecology, image classification, machine learning, tutorial},
doi = {https://doi.org/10.1111/1365-2656.70271},
url = {https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/1365-2656.70271},
eprint = {https://besjournals.onlinelibrary.wiley.com/doi/pdf/10.1111/1365-2656.70271}
}