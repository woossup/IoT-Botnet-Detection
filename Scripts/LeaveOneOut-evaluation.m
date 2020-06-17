%%% Leave-Mastua-Out

%% Training



% Class 1

loso_normal_training = [camera_detection(:,1:825), camera_only(:,1:825)]; % 1650 

% Class 2

loso_reboot_training = [device_reboot(:,1:1650)]; % 1650

% Class 3

loso_idle_training = [device_idle(:,1:1650)]; % 1650

% Class 4

loso_masuta_training = [mirai_when_idle(:,1:413),mirai_with_camera(:,1:412), sora_when_idle(:,1:413), sora_with_camera(:,1:412)];   % 1650



%% Testing

% Class 1

loso_normal_test = [camera_detection(:,826:1100), camera_only(:,826:1100)]; % 550

% Class 2

loso_reboot_test = [device_reboot(:,1651:2200)]; % 550

% Class 3

loso_idle_test = [device_idle(:,1651:2200)]; % 550

% Class 4

loso_masuta_test = [masuta_when_idle(:,1:275), masuta_with_camera(:,1:275)];% 550



%% Merge

loso_training = [loso_normal_training, loso_reboot_training, loso_idle_training, loso_masuta_training]; % 6600

loso_test = [loso_normal_test, loso_reboot_test, loso_idle_test, loso_masuta_test];  % 2200



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

clearvars loso_normal_training loso_reboot_training loso_idle_training loso_masuta_training loso_normal_test loso_reboot_test loso_idle_test loso_masuta_test loso_training loso_test i;



%% Classification

[net_info, perf] = leaveoneout(loso_final,loso_label);
