# IoT-Botnet-Detection

This website contains datasets of Power Consumption traces for IoT Botnet Detection.


## Cite the Paper

Woosub Jung, Hongyang Zhao, Minglong Sun, Gang Zhou
IoT Botnet Detection via Power Consumption Modeling
Elsevier Smart Health, 2019. DOI: https://doi.org/10.1016/j.smhl.2019.100103


## Files

This repository contains the following files. You agree to the [Terms of Use for Botnet-Detection Dataset](#terms-of-use-for-botnet-detection-dataset) to download and use the files.

| Files   | Description | Size |
| ------- | ----------- | ---- |
| ![Botnet_Detection.mat](https://drive.google.com/file/d/1LSLPUBZJIRWWAOmC7DUyxTgWG1pMZxnF/view?usp=sharing)   | Segmented Power Traces of IoT Devices. |  1.06GB    |
|         |             |      |
| READ.me | Readme      |      |

------

## Instructions

### 1. Load the Dataset

Load the dataset into the Matlab workspace by running `load('Botnet_Detection.mat');`. 

### 2. Variables

- Each instance consists of 7,500 data points since a single instance is 1.5 seconds data and the sampling rate is 5kHz.
- For example, in mirai_with_camera, there are 910 instances collected when camera being attacked.

![variables](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Instructions/variables.png?raw=true)

### 3. Display a single Instance

- Each column represents a single instance.
- You can select a column and plot it.

![instance](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Instructions/instance.png?raw=true)

### 4. Script for Input Dataset

- Our model has four classes, and each class consists of 2,200 instances. 
- Depending on what you test, you may modify or run the attached scripts.
- The following example shows parts of self-evaluation on Router Device

```matlab
%%% Self Evaluation - Access Point
%% Training
% Class 1
self_service = [access_point(:,1:1980), access_point_ftp(:,1:220)]; % 2200 
% Class 2
self_reboot = [device_reboot(:,1:2200)]; % 2200
% Class 3
self_idle = [device_idle(:,1:2200)]; % 2200
% Class 4
self_mirai = [mirai_with_router(:,1:700), mirai_when_idle(:,1:800), mirai_loader(:,1:700) ]; % 2200
...
```

### 5. Run our CNN model

- After Step 3, run `[net_info,perf]=onedcnn(chosen_dataset,chosen_label);` for testing/traininig the dataset.


## CNN Model

The following shows how Botnet-Detection CNN works.


------
## Terms of Use for Botnet-Detection Dataset

You need to read and agree to the following terms of use to download and use the Botnet-Detection Dataset.

`1. Definitions`

The following terms, unless the context requires otherwise, have the following meanings:

"Data Team": means the employees and students at William & Mary who are working on the Botnet-Detection Dataset;

"Botnet-Detection Dataset": means the power consumption traces collected by the Data Team;

"Licensee", "You", "Yours": means the person or entity acquiring a license hereunder for access to and use of the Botnet-Detection Dataset.

`2. Grant of License`

William & Mary hereby grants to You a non-exclusive, non-transferable, revocable license to use the Botnet-Detection Dataset solely for Your non-commercial, educational, and research purposes only, but without any right to copy or reproduce, publish or otherwise make available to the public or communicated to the public, sell, rent or lend the whole or any constituent part of the Botnet-Detection Dataset thereof. The Botnet-Detection Dataset shall not be redistributed without the express written prior approval of William & Mary. You agree not to reverse engineer, separate or otherwise tamper with the Botnet-Detection Dataset so that data can be extracted and used outside the scope of that permitted in this Agreement.

You agree to acknowledge the source of the Botnet-Detection Dataset in all of Your publications and presentations based wholly or in part on the Botnet-Detection Dataset. You agree to provide a disclaimer in any publication or presentation to the effect that William & Mary does not bear any responsibility for Your analysis or interpretation of the Dataset.

You agree and acknowledge that William & Mary may hold, process, and store any personal data submitted by You for validation and statistical purposes and the purposes of the administration and management of the Botnet-Detection dataset. You agree that any personal data submitted by You is accurate to the best of his or her knowledge.

William & Mary provides the Botnet-Detection Dataset "AS IS," without any warranty or promise of technical support, and disclaims any liability of any kind for any damages whatsoever resulting from use of the Botnet-Detection Dataset.

WILLIAM & MARY MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH RESPECT TO THE BOTNET-DETECTION DATASET, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, WHICH ARE HEREBY EXPRESSLY DISCLAIMED.

Your acceptance and use of the Botnet-Detection Dataset binds you to the terms and conditions of this License as stated herein.
