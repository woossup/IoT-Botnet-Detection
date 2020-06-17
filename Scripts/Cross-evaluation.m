%%% Cross Evaluation - Voice Assistant + Router + Camera
%% Training

% Class 1
cross_service = [google_assistant(:,1:550), access_point(:,1:500), access_point_ftp(:,1:50), camera_detection(:,1:550), camera_only(:,1:550)]; % 2200

% Class 2
cross_reboot = [device_reboot(:,1:2200)]; % 2200

% Class 3
cross_idle = [device_idle(:,1:2200)]; % 2200

% Class 4
cross_mirai = [mirai_with_google(:,1:440), mirai_with_camera(:,1:440), mirai_with_router(:,1:440), mirai_when_idle(:,1:440), mirai_loader(:,1:440) ];  % 2200

%% Merge
cross_sample = [cross_service, cross_reboot, cross_idle, cross_mirai]; % 8800

%
cross_final = normalize(cross_sample);
cross_final = reshape(cross_sample,[1,7500,1,8800]);

%% Label
cross_label = [];

% Training cross

for i = 1:2200
  cross_label=[cross_label;0];  
end

for i = 1:2200
  cross_label=[cross_label;1]; 
end

for i = 1:2200
  cross_label=[cross_label;2];  
end

for i = 1:2200
  cross_label=[cross_label;3]; 
end

%% Clear Variables
clearvars cross_service cross_reboot cross_idle cross_mirai cross_sample i;
