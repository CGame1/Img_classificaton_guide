# Cross-Validation with YOLO


Welcome! This repo provides access to a Jupyter notebook that demonstrates how to implement cross-validation with YOLO for image classification in Python. 📷🌊🐙🤖

The notebook is designed to be beginner-friendly, with the option to run it entirely online using [Google Colab](https://colab.research.google.com/github/CGame1/Img_classificaton_guide/blob/main/notebooks/CrossVal_with_Yolo_colab.ipynb) — no installation or GPU required. However, if you're more comfortable with Python and Jupyter, you can also clone the repository and run it locally. 

No data is required, as the code also downloads an open-source [dataset](https://huggingface.co/datasets/CGame1/schulz_bank_biotopes) from [Hugging Face](https://huggingface.co/). Note that this is a copy of the original [dataset](https://doi.pangaea.de/10.1594/PANGAEA.949920) (for faster access), see [Meyer et al., 2023](https://www.sciencedirect.com/science/article/pii/S0967063722002333#da0010) for details.

The notebook also contains code to deploy trained YOLO models, from Hugging Face for example, on new data 

This resource is a supplement to our paper: *Deep Blueprint: A Literature Review and Guide to Automated Image Classification for Ecologists*
 (see below).


*For R users*: A shiny app (and associated R code) is also available [here](https://github.com/Npiechaud/Benthic-Images-CV/tree/main/shiny_app) for select tasks.

![Classification workflow](https://github.com/CGame1/Img_classificaton_guide/blob/main/docs/workflow.png?raw=true)
---


## 📚 How to Cite This Work


If you find this code useful, please consider citing our **preprint**:

> Your Name, Another Author, and Third Author. **“Title of the Paper.”** *Journal Name*, vol. XX, no. X, Year, pp. XX–XX. DOI: [https://doi.org/your-doi](https://doi.org/your-doi)

Or use the following BibTeX entry:

```bibtex
@article{your2025paper,
  title     = {Title of the Paper},
  author    = {Your Name and Another Author and Third Author},
  journal   = {Journal Name},
  volume    = {XX},
  number    = {X},
  pages     = {XX--XX},
  year      = {2025},
  doi       = {10.xxxx/your-doi}
}

