# IoT-Botnet-Detection

This website contains datasets of Power Consumption traces for IoT Botnet Detection.


## Cite the Paper

IoT Botnet Detection via Power Consumption Modeling
Woosub Jung, Hongyang Zhao, Minglong Sun, Gang Zhou
Elsevier Smart Health, 2019. DOI: https://doi.org/10.1016/j.smhl.2019.100103


## Files

This repository contains the following files. You agree to the Terms of Use for Botnet-Detection Dataset to download and use the files.

| Files   | Description | Size |
| ------- | ----------- | ---- |
| Botnet-Detection.mat   | Segmented Power Traces of IoT Devices. |  1.06GB    |
|         |             |      |
| READ.me | Readme      |      |

## Instructions

### 1. Variables

- Each instance consists of 7,500 data points since a single instance is 1.5 seconds data and the sampling rate is 5kHz.
- For example, in mirai_with_camera, there are 910 instances collected when camera being attacked.

![variables](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Instructions/variables.png)

### 2. Display a single Instance

- Each column represents a single instance.
- You can select a column and plot it.

![instance](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Instructions/instance.png)

### 3. Script for Intput Dataset

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

### 4. Run our CNN model

- After Step 3, run the following commmand to test/train chosen datasets.

```matlab
%% Classification
[net_info,perf]=onedcnn(self_final,self_label);
```

## Example

The following shows an example of how to train the dataset.


## Terms of Use for Botnet-Detection Dataset

You need to read and agree to the following terms of use to download and use the Botnet-Detection Dataset.

1. Definitions

The following terms, unless the context requires otherwise, have the following meanings:

"Data Team": means the employees and students at William & Mary who are working on the Botnet-Detection Datset;

"Botnet-Detection Dataset": means the power consumption traces collected by the Data Team;

"Licensee", "You", "Youres": means the person or entity acquiring a license hereunder for access to and use of the Botnet-Detection Dataset.

2. Grant of License

William & Mary hereby grants to You a non-exclusive, non-transferable, revocable license to use the Botnet-Detection Dataset solely for Your non-commercial, educational, and research purposes only, but without any right to copy or reproduce, publish or otherwise make available to the public or communicated to the public, sell, rent or lend the whole or any constituent part of the Botnet-Detection Dataset thereof. The Botnet-Detection Dataset shall not be redistributed without the espress written prior approval of William & Mary. You agree not to reverse engineer, seperate or otherwise tamper with the Botnet-Detection Dataset so that data can be extracted and used outside the scope of that permitted in this Agreement.

You agree to acknowledge the source of the Botnet-Detection Dataset in all of Your publications and presentations based wholly or in part on the Botnet-Detection Dataset. You agree to provide a disclaimer in any publication or presentation to the effect that William & Mary does not bear any responsibility for Your analysis or interpretation of the Dataset.

You agree and acknowledge that William & Mary may hold, process, and store any personal data submitted by You for validation and statistical purposes and for the purposes of the administration and management of Botnet-Detection dataset. You agree that any personal data submitted by You is accurate to the best of his or her knowledge.

William & Mary provides the Botnet-Detection Dataset "AS IS," without any warranty or promise of technical support, and disclaims any liability of any kind for any damages whatsoever resulting from use of the Botnet-Detection Dataset.

WILLIAM & MARY MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH RESPECT TO THE BOTNET-DETECTION DATASET, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, WHICH ARE HEREBY EXPRESSLY DISCLAIMED.

Your acceptance and use of the Botnet-Detection Dataset binds you to ther terms and conditions of this License as stated herein.
