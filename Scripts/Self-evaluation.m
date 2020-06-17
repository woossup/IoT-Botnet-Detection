

%%% Self Evaluation - Access Point



%% Training



% Class 1

self_service = [access_point(:,1:1980), access_point_ftp(:,1:220)]; % 2200



% Class 2

self_reboot = [device_reboot(:,1:2200)]; % 2200



% Class 3

self_idle = [device_idle(:,1:2200)]; % 2200



% Class 4

self_mirai = [mirai_with_router(:,1:700), mirai_when_idle(:,1:800), mirai_loader(:,1:700) ];  % 2200



%% Merge

self_sample = [self_service, self_reboot, self_idle, self_mirai]; % 8800



%

self_final = normalize(self_sample);

self_final = reshape(self_final,[1,7500,1,8800]);



%% Label



self_label = [];



%% Training



for i = 1:2200

  self_label=[self_label;0];  

end



for i = 1:2200

  self_label=[self_label;1]; 

end



for i = 1:2200

  self_label=[self_label;2];  

end



for i = 1:2200

  self_label=[self_label;3]; 

end



%% Clear Variables

clearvars self_service self_reboot self_idle self_mirai self_sample i;



%% Classification

[net_info, perf] = onedcnn(self_final,self_label);



