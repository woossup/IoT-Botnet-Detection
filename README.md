# IoT-Botnet-Detection via Power Consumption Modeling

This website contains datasets of Power Consumption traces for IoT Botnet Detection.
##### 2020 Mostly Downloaded Paper Award


## Cite the Paper

Woosub Jung, Hongyang Zhao, Minglong Sun, Gang Zhou
IoT Botnet Detection via Power Consumption Modeling
Elsevier Smart Health, 2020. DOI: https://doi.org/10.1016/j.smhl.2019.100103


## Files

This repository contains the following files. You agree to the [Terms of Use for Botnet-Detection Dataset](#terms-of-use-for-botnet-detection-dataset) to download and use the files.

| Files   | Description | Size |
| ------- | ----------- | ---- |
| [Botnet_Detection.mat](https://drive.google.com/file/d/1LSLPUBZJIRWWAOmC7DUyxTgWG1pMZxnF/view?usp=sharing)   | Segmented Power Traces of IoT Devices. |  1.06GB    |
| [Self-evaluation.m](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Scripts/Self-evaluation.m) | MATLAB source code for preparing Self-evaluation tests.  | 825B     |
| [Cross-evaluation.m](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Scripts/Cross-evaluation.m) | MATLAB source code for preparing Cross-evaluation tests.  | 1KB     |
| [LeaveOneOut-evaluation.m](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Scripts/LeaveOneOut-evaluation.m) | MATLAB source code for preparing LeaveOneOut-evaluation tests.  |  2KB    |
| [BotnetDetection_CNN.m](https://github.com/woossup/IoT-Botnet-Detection/blob/master/CNN/CNN_CrossValidation.m) | MATLAB source code for cross-validation training and testing using the dataset. |  4KB    |
| [training_screenshot.png](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Instructions/training_screenshot.png?raw=true) |A screen shot of the training process. |  191KB     |
| [READ.me](https://github.com/woossup/IoT-Botnet-Detection/blob/master/README.md) | Readme      |  10KB    |

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
%%% Self Evaluation - Router
%% Training

% Class 1
self_service = [router(:,1:1980), router_ftp(:,1:220)]; % 2200

% Class 2
self_reboot = [reboot(:,1:2200)]; % 2200

% Class 3
self_idle = [idle(:,1:2200)]; % 2200

% Class 4
self_mirai = [mirai_with_router(:,1:700), mirai_idle(:,1:800), mirai_loader(:,1:700) ];  % 2200

...
```

### 5. Run our CNN model

- After Step 3, run `[net_info,perf]=CNN_CrossValidation(chosen_final,chosen_label);` for traininig/testing the dataset.
- The following figure shows the training process.

![training_process](https://github.com/woossup/IoT-Botnet-Detection/blob/master/Instructions/training_screenshot.png?raw=true)

## CNN Model

The following shows how Botnet-Detection CNN works.

### 1. Prepare data for Training

```matlab
power_tensor = power;
class = categorical(label);
```
`power_tensor` and `class` are the Power Trace input and labels.

### 2. Parameter Settings

```matlab
% [M,N,S] : Power Matrix for each instance
[M,N,S,T] = size(power_tensor);
Nw = 4; % number of classes
Nt = T; % total number of instances

% CNN Hyperparameters
convKernelSize = 512;
convChanNum = 10;
poolSize = 4;
n_epoch = 30;
learn_rate = 0.001;
l2_factor = 0.01;
```

### 3. Divide the dataset into training and testing subsets

```matlab
K = 5; % K-fold corss validation
cv = cvpartition(Nt,'kfold',K);
test_stats = zeros(K,15);
k = 1 % for k=1:K
trainIdx = find(training(cv,k));
testIdx = find(test(cv,k));
trainPower = power_tensor(:,:,:,trainIdx);
trainClass = class(trainIdx,1);
testPower = power_tensor(:,:,:,testIdx);
testClass = class(testIdx,1);
valData = {testPower,testClass};
```

### 4. Set neural network and training options

```matlab
% Convolutional Neural Network settings
layers = [
    imageInputLayer([M N S]);
    convolution2dLayer( [1 convKernelSize],convChanNum,'Stride', [1 128]);
    batchNormalizationLayer;
    reluLayer;
    maxPooling2dLayer([1 poolSize],'Stride', [1 4]);
    fullyConnectedLayer(Nw);
    softmaxLayer;
    classificationLayer
];
% Convolutional Neural Network training options
options = trainingOptions('sgdm','ExecutionEnvironment','parallel',...
        'MaxEpochs',n_epoch,...
        'InitialLearnRate',learn_rate,...
        'L2Regularization',l2_factor,...
        'ValidationData',valData,...
        'ValidationFrequency',10,...
        'ValidationPatience',Inf,...
        'Shuffle','every-epoch',...
        'Verbose',false,...
        'Plots','training-progress');
```
- MATLAB 2017b or newer versions are needed to use `batchNormalizationLayer()` for network layers and `ValidationData` for training options. For `trainingOptions()`, `'ExecutionEnvironmnet'` can be `'cpu'`, `'gpu'`, or `'parallel'`.

### 5. Train and test the neural network; calculate recognition accuracy

```matlab
[trainedNet,tr{k,1}] = trainNetwork(trainPower,trainClass,layers,options);
t1 = toc; % training end time
[YTest, scores] = classify(trainedNet,testPower);
TTest = testClass;
tr{k,2} = scores; % classify scores
tr{k,3} = TTest;
tr{k,4} = YTest;
test_sensitivity = sum(YTest == TTest)/numel(TTest);
```
 
### 6. Plot the confusion matrix
```matlab
% plot confusion matrix
ttest = dummyvar(double(TTest))';
tpredict = dummyvar(double(YTest))';
[c,cm,ind,per] = confusion(ttest,tpredict);
plotconfusion(ttest,tpredict);
```

### 7. Calculate performance metrics
```matlab
test_stats(k,1:4) = mean(per); % 'FN','FP','TP','TN'
test_stats(k,5) = test_sensitivity; % sensitivity
test_stats(k,6) = t1; % training time
test_stats(k,7) = t2; % testing time               
test_stats(k,8) = test_stats(k,2)/(test_stats(k,4) + test_stats(k,2)); % FPR
test_stats(k,9) = test_stats(k,3)/(test_stats(k,3) + test_stats(k,1)); % TPR
test_stats(k,10) = test_stats(k,4)/(test_stats(k,4) + test_stats(k,2)); % TNR
test_stats(k,11) = test_stats(k,1)/(test_stats(k,3) + test_stats(k,1)); % FNR
test_stats(k,12) = test_stats(k,3)/(test_stats(k,2) + test_stats(k,3)); % Presicion
test_stats(k,13) = (test_stats(k,3)+test_stats(k,4))/(test_stats(k,1) + test_stats(k,2) + test_stats(k,3) + test_stats(k,4)); % Accuracy
test_stats(k,14) = (test_stats(k,1)+test_stats(k,2))/(test_stats(k,1) + test_stats(k,2) + test_stats(k,3) + test_stats(k,4)); % Error rate
test_stats(k,15) = 2*(test_stats(k,12)*test_stats(k,9))/(test_stats(k,12)+test_stats(k,9)); % F Measure1        
```

------
## Terms of Use for Botnet-Detection Dataset

You need to read and agree to the following terms of use to download and use the Botnet-Detection Dataset.

`1. Definitions`

>The following terms, unless the context requires otherwise, have the following meanings:
>
>"Data Team": means the employees and students at William & Mary who are working on the Botnet-Detection Dataset;
>
>"Botnet-Detection Dataset": means the power consumption traces collected by the Data Team;
>
>"Licensee", "You", "Yours": means the person or entity acquiring a license hereunder for access to and use of the Botnet-Detection Dataset.


`2. Grant of License`

>William & Mary hereby grants to You a non-exclusive, non-transferable, revocable license to use the Botnet-Detection Dataset solely for Your non-commercial, educational, and research purposes only, but without any right to copy or reproduce, publish or otherwise make available to the public or communicated to the public, sell, rent or lend the whole or any constituent part of the Botnet-Detection Dataset thereof. The Botnet-Detection Dataset shall not be redistributed without the express written prior approval of William & Mary. You agree not to reverse engineer, separate or otherwise tamper with the Botnet-Detection Dataset so that data can be extracted and used outside the scope of that permitted in this Agreement.
>
>You agree to acknowledge the source of the Botnet-Detection Dataset in all of Your publications and presentations based wholly or in part on the Botnet-Detection Dataset. You agree to provide a disclaimer in any publication or presentation to the effect that William & Mary does not bear any responsibility for Your analysis or interpretation of the Dataset.
>
>You agree and acknowledge that William & Mary may hold, process, and store any personal data submitted by You for validation and statistical purposes and the purposes of the administration and management of the Botnet-Detection dataset. You agree that any personal data submitted by You is accurate to the best of his or her knowledge.
>
>William & Mary provides the Botnet-Detection Dataset "AS IS," without any warranty or promise of technical support, and disclaims any liability of any kind for any damages whatsoever resulting from use of the Botnet-Detection Dataset.
>
>WILLIAM & MARY MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH RESPECT TO THE BOTNET-DETECTION DATASET, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, WHICH ARE HEREBY EXPRESSLY DISCLAIMED.
>
>Your acceptance and use of the Botnet-Detection Dataset binds you to the terms and conditions of this License as stated herein.
