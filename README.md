# Spray Image Processing and Penetration Analysis in Subsonic Crossflow using MATLAB

MATLAB-based image processing and edge detection workflow developed for experimental spray penetration analysis in crossflow conditions.

This work was carried out during my research internship at IIT Jodhpur in the field of experimental fluid mechanics and multiphase flow analysis.

---

# Project Overview

This repository focuses on the experimental analysis of liquid jet injection into subsonic crossflow using MATLAB image processing techniques.

The experimental condition considered in this study includes:

- Crossflow velocity: **29 m/s**
- Liquid jet flow rate: **1.5 LPM**

The workflow was developed to process high-speed experimental spray images and extract spray penetration characteristics using:
- image averaging,
- binary thresholding,
- Canny edge detection,
- spray boundary extraction,
- and penetration profile analysis.

---

# Objectives

The main objectives of this work are:

- To process raw experimental spray images
- To improve spray visibility through image averaging
- To identify spray boundaries using Canny edge detection
- To extract upper penetration profiles
- To compare penetration behavior for different averaged image datasets
- To generate processed datasets for future CFD/VOF validation studies

---

# Experimental Image Processing Workflow

The MATLAB workflow used in this project consists of:

```text
Raw TIFF Images
        ↓
Grayscale Conversion
        ↓
Binary Thresholding
        ↓
Image Averaging
        ↓
Canny Edge Detection
        ↓
Boundary Extraction
        ↓
Penetration Profile Plotting
        ↓
Excel Data Export
```

---
## Pixel Calibration

A pixel-to-millimeter calibration was performed using the known injector diameter from the experimental setup.

- Injector diameter used for calibration: **4.38 mm**

The injector edges were identified from the calibration image, and the total number of pixels spanning the injector diameter was calculated using:

```text
Number of pixels = Final pixel position − Initial pixel position + 1
```

Using the known physical injector diameter, the pixel resolution was obtained as:

```text
1 pixel = 0.1123 mm
```

This calibration factor was then used to convert extracted spray boundary coordinates from pixel units into physical dimensions (mm) for penetration analysis.
# Methodology

## 1. Raw Image Acquisition

High-speed TIFF spray images obtained from the experimental setup were used as the input dataset.

The complete raw image dataset used in this work is provided separately through Google Drive.

---

## 2. Binary Image Averaging

The images were converted into binary format and averaged over:
- 1000 images
- 2000 images
- 3000 images

Image averaging was performed to:
- reduce noise,
- improve spray visibility,
- and obtain clearer penetration boundaries.

---

## 3. Canny Edge Detection

Canny edge detection was applied to the averaged images using different threshold values to determine:
- better edge continuity,
- reduced noise effects,
- and accurate spray boundary extraction.

Different threshold values were tested in order to identify the most reliable edge detection condition.

---

## 4. Boundary Extraction

Upper spray boundary points were extracted from the processed edge-detected images using sampled streamwise locations.

The extracted boundary coordinates were then converted from pixels into physical dimensions using injector diameter calibration.

---

## 5. Penetration Analysis

The processed penetration profiles were plotted and compared for different averaged image datasets.

The generated data can further be used for:
- experimental validation,
- CFD comparison,
- and future VOF-based numerical studies.

---

# Repository Structure

```text
spray-image-processing-matlab/

│── README.md
│── main.m

├── images/
│     ├── raw experimental images
│     ├── averaged binary images
│     ├── edge detection images
│     ├── calibration images

├── results/
│     ├── penetration profile plots
│     ├── comparison graphs
│     ├── processed outputs
│     ├── excel exported datasets
```

---

# Sample Results

## Averaged Binary Image

![Binary](images/avg_binary_3000.png)

---

## Canny Edge Detection Result

![Edge](images/edge_avg3000_T002.png)

---

## Penetration Comparison Plot

![Plot](results/comparison_plot.png)

---

# Raw Experimental Dataset

The complete raw experimental image dataset used in this study is available through the Google Drive link below:

[(https://drive.google.com/drive/folders/1kZqIiEn5slwM8AJ4aAb_qv5sQetPcFnr?usp=sharing)]

The drive folder contains:
- raw TIFF spray images,
- calibration images,
- experimental frames,
- and additional processing datasets used during the analysis.

---

# MATLAB Techniques Used

- Image Averaging
- Binary Thresholding
- Canny Edge Detection
- Boundary Extraction
- Pixel-to-mm Calibration
- Experimental Spray Penetration Analysis
- Excel Data Export

---

# Future Scope

Future improvements and extensions of this work include:

- VOF-based CFD validation
- Automated spray angle extraction
- Adaptive thresholding techniques
- Automated penetration tracking
- Comparison between experimental and numerical penetration profiles
- Multiphase flow visualization studies

---

# Author

## Rakuditi Sai Praneeth

Mechanical Engineering Undergraduate  
National Institute of Technology Silchar

Research Interests:
- Computational Fluid Dynamics (CFD)
- Compressible and Multiphase Flows
- Experimental Fluid Mechanics
- Supersonic and High-Speed Aerodynamics
