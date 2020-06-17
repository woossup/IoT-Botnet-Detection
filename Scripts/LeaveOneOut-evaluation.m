%%% LOSO - Camera

%% Training

% Class 1
loso_normal_training = [router(:,1:770), router_ftp(:,1:55) voice_assistant(:,1:825)]; % 1650 

% Class 2
loso_reboot_training = [reboot(:,1:1650)]; % 1650

% Class 3
loso_idle_training = [idle(:,1:1650)]; % 1650

% Class 4
loso_mirai_training = [mirai_with_router(:,1:550), mirai_with_voice(:,1:550), mirai_idle(:,1:275), mirai_loader(:,1:275)];
loso_mirai_training = [loso_mirai_training(:,1:1650)];      % 1650

%% Testing

% Class 1
loso_normal_test = [camera_motion(:,826:1100), camera_streaming(:,826:1100)]; % 550

% Class 2
loso_reboot_test = [reboot(:,1651:2200)]; % 550

% Class 3
loso_idle_test = [idle(:,1651:2200)]; % 550

% Class 4
loso_mirai_test = [mirai_with_camera(:,1:550)];% 550

%% Merge
loso_training = [loso_normal_training, loso_reboot_training, loso_idle_training, loso_mirai_training]; % 6600
loso_test = [loso_normal_test, loso_reboot_test, loso_idle_test, loso_mirai_test];    % 2200

%
loso_final = [loso_training, loso_test];
loso_final = normalize(loso_final);
loso_final = reshape(loso_final,[1,7500,1,8800]);

%% Label

loso_label = [];

% Training
for i = 1:1650
    loso_label=[loso_label;0];  
end

for i = 1:1650
    loso_label=[loso_label;1]; 
end

for i = 1:1650
    loso_label=[loso_label;2];  
end

for i = 1:1650
    loso_label=[loso_label;3]; 
end

% Test
for i = 1:550
    loso_label=[loso_label;0];  
end

for i = 1:550
    loso_label=[loso_label;1]; 
end

for i = 1:550
    loso_label=[loso_label;2];  
end

for i = 1:550
    loso_label=[loso_label;3]; 
end

%% Clear Variables
clearvars loso_normal_training loso_reboot_training loso_idle_training loso_mirai_training loso_normal_test loso_reboot_test loso_idle_test loso_mirai_test loso_training loso_test i;

