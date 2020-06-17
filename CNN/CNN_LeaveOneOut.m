%% Yongsen Ma <yma@cs.wm.edu>
% Department of Computer Science
% College of William and Mary
% Sign Gesture Recognition using Convolutional Neural Network

function [info, perf] = data_to_cnn(csi,label)
    %tic;

	csi_tensor = csi;
    word = categorical(label);

    [M,N,S,T] = size(csi_tensor);
    Nw = 4; % number of classes
    Nt = T;

    rng('shuffle');
    convKernelSize = 256;
    convChanNum = 10;
    poolSize = 4;
    n_epoch = 30;
    learn_rate = 0.001;
    l2_factor = 0.1;

    % Convolutional Neural Network settings
    layers = [
                imageInputLayer([M N S]);
                convolution2dLayer( [1 convKernelSize],convChanNum,'Stride', [1 64]);
                batchNormalizationLayer;
                reluLayer;
                maxPooling2dLayer([1 poolSize],'Stride', [1 4]);
                %dropoutLayer(0.6);
                fullyConnectedLayer(Nw);
                softmaxLayer;
                classificationLayer
              ];

    %K = 5; % K-fold cross validation
    K = 1; % Leave one out cross validation

    % cv = cvpartition(Nt,'leaveout');
    test_stats = zeros(K,15);

    for k=1:K
        % get training/testing input
%        trainIdx = find(training(cv,k));
%        testIdx = find(test(cv,k));
        tic;

        trainIdx = [1:6600];
        trainIdx = trainIdx';
        testIdx = [6601:8800];
        testIdx = testIdx';
        trainCsi = csi_tensor(:,:,:,trainIdx);
        trainWord = word(trainIdx,1);
        testCsi = csi_tensor(:,:,:,testIdx);
        testWord = word(testIdx,1);
        valData = {testCsi,testWord};

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
        
        [trainedNet,tr{k,1}] = trainNetwork(trainCsi,trainWord,layers,options);
        t1 = toc; % training end time

        [YTest, scores] = classify(trainedNet,testCsi);
        TTest = testWord;
        tr{k,2} = scores; % classify scores
        tr{k,3} = TTest;
        tr{k,4} = YTest;
        test_accuracy = sum(YTest == TTest)/numel(TTest);

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
        test_stats(k,5) = test_accuracy; % accuracy
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
