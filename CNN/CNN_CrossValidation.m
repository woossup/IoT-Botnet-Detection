%% Woosub Jung <wsjung@cs.wm.edu>
% Department of Computer Science
% College of William and Mary
% SmartGate

function [info, perf] = CNN_CrossValidation(power,label)
    
	power_tensor = power;
    class = categorical(label);

    [M,N,S,T] = size(power_tensor);
    Nw = 4; % number of classes
    Nt = T;
    
    rng('shuffle');
    convKernelSize = 512;
    convChanNum = 10;
    poolSize = 4;
    n_epoch = 30;
    learn_rate = 0.001;
    l2_factor = 0.01;

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

    K = 5; % K-fold corss validation
    cv = cvpartition(Nt,'kfold',K);
    test_stats = zeros(K,15);

    for k=1:K
        
        % get training/testing input
        trainIdx = find(training(cv,k));
        testIdx = find(test(cv,k));
        trainPower = power_tensor(:,:,:,trainIdx);
        trainClass = class(trainIdx,1);
        testPower = power_tensor(:,:,:,testIdx);
        testClass = class(testIdx,1);
        valData = {testPower,testClass};

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
        tic;

        [trainedNet,tr{k,1}] = trainNetwork(trainPower,trainClass,layers,options);
        t1 = toc; % training end time

        [YTest, scores] = classify(trainedNet,testPower);
        TTest = testClass;
        tr{k,2} = scores; % classify scores
        tr{k,3} = TTest;
        tr{k,4} = YTest;
        test_sensitivity = sum(YTest == TTest)/numel(TTest);

        % plot confusion matrix
        ttest = dummyvar(double(TTest))';
        tpredict = dummyvar(double(YTest))';
        [lent,~] = size(ttest);
        [lenp,~] = size(tpredict);
        if lenp<lent
           tpredict(lenp+1:lent,:) = 0;
        end
        [c,cm,ind,per] = confusion(ttest,tpredict);
        plotconfusion(ttest,tpredict);
        t2 = toc; % testing end time
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
        
        test_stats(k,:)
    end

    info = tr;
    perf = test_stats;
    perf_mean = mean(perf,1)
end
