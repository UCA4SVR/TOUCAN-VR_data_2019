function [responses_VW2_ref, responses_VW2_effect, responses_VWBoxe_ref, responses_VWBoxe_effect,...
    responses_SD2_ref, responses_SD2_effect, responses_SDBar_ref, responses_SDBar_effect,...
    responses_SDUnderwater_ref, responses_SDUnderwater_effect, responses_SDTouvet_ref, responses_SDTouvet_effect,...
    preference_VW2, preference_VWBoxe, preference_SD2, preference_SDBar, preference_SDUnderwater, preference_SDTouvet,...
    detection_VW2, detection_VWBoxe, detection_SD2, detection_SDBar, detection_SDUnderwater, detection_SDTouvet,...
    orderfordetection_VW2, orderfordetection_VWBoxe, orderfordetection_SD2, orderfordetection_SDBar, orderfordetection_SDUnderwater, orderfordetection_SDTouvet...
    ]= all_subjective_measures_Jan2019(user_start)
% One line per user
% Question answers in order on columns: 'Perceived quality' | 'Perceived
% quality variation' | 'Comfort' | 'Responsiveness to head motion' |
% 'Assessment of available time'

if nargin==0
    user_start=1;
end

videos_vec = {'VW2', 'VW Boxe', 'SD2', 'SD Bar', 'SD Underwater', 'SD Touvet'};
cols_start_video = [3 + (0:5)*13];
cols_mapping_video = [3+ (0:5)*4];

[num_res, txt_res, data_res] = xlsread('./Resulting_questionnaires/Questionnaire_on_experiments_withuserID.xlsx');
[num_mapping, txt_mapping, data_mapping] = xlsread('./Resulting_questionnaires/Table_users_videos.xlsx');

nb_total_users = size(num_res,1);

%% Responses to common questions -------------

responses_VW2_ref = [];
responses_VW2_effect = [];
responses_VWBoxe_ref = [];
responses_VWBoxe_effect = [];
responses_SD2_ref = [];
responses_SD2_effect = [];
responses_SDBar_ref = [];
responses_SDBar_effect = [];
responses_SDUnderwater_ref = [];
responses_SDUnderwater_effect = [];
responses_SDTouvet_ref = [];
responses_SDTouvet_effect = [];

for ind_user = user_start+1:nb_total_users+1 % to skip first row with column description
    
    user_id = data_res{ind_user,1};
    ind_row_mapping = find(cell2mat(data_mapping(2:end,1))==user_id)+1;
    
    for ind_video = 1:length(videos_vec)
        col_mapping_video = cols_mapping_video(ind_video);
        col_start_video = cols_start_video(ind_video);
        if contains(string(data_mapping{ind_row_mapping,col_mapping_video}),'ref')
            col_start_ref = col_start_video;
            col_end_ref = col_start_ref + 4;
            col_start_effect = col_start_video + 7;
            col_end_effect = col_start_effect + 4;
        else
            col_start_ref = col_start_video + 7;
            col_end_ref = col_start_ref + 4;
            col_start_effect = col_start_video;
            col_end_effect = col_start_effect + 4;
        end
        if string(videos_vec{ind_video})=='VW2'
            responses_VW2_ref = [responses_VW2_ref ; cell2mat(data_res(ind_user,col_start_ref:col_end_ref))];
            responses_VW2_effect = [responses_VW2_effect ; cell2mat(data_res(ind_user,col_start_effect:col_end_effect))];
        elseif string(videos_vec{ind_video})=='VW Boxe'
            responses_VWBoxe_ref = [responses_VWBoxe_ref ; cell2mat(data_res(ind_user,col_start_ref:col_end_ref))];
            responses_VWBoxe_effect = [responses_VWBoxe_effect ; cell2mat(data_res(ind_user,col_start_effect:col_end_effect))];
        elseif string(videos_vec{ind_video})=='SD2'
            responses_SD2_ref = [responses_SD2_ref ; cell2mat(data_res(ind_user,col_start_ref:col_end_ref))];
            responses_SD2_effect = [responses_SD2_effect ; cell2mat(data_res(ind_user,col_start_effect:col_end_effect))];
        elseif string(videos_vec{ind_video})=='SD Bar'
            responses_SDBar_ref = [responses_SDBar_ref ; cell2mat(data_res(ind_user,col_start_ref:col_end_ref))];
            responses_SDBar_effect = [responses_SDBar_effect ; cell2mat(data_res(ind_user,col_start_effect:col_end_effect))];
        elseif string(videos_vec{ind_video})=='SD Underwater'
            responses_SDUnderwater_ref = [responses_SDUnderwater_ref ; cell2mat(data_res(ind_user,col_start_ref:col_end_ref))];
            responses_SDUnderwater_effect = [responses_SDUnderwater_effect ; cell2mat(data_res(ind_user,col_start_effect:col_end_effect))];
        elseif string(videos_vec{ind_video})=='SD Touvet'
            responses_SDTouvet_ref = [responses_SDTouvet_ref ; cell2mat(data_res(ind_user,col_start_ref:col_end_ref))];
            responses_SDTouvet_effect = [responses_SDTouvet_effect ; cell2mat(data_res(ind_user,col_start_effect:col_end_effect))];
        end
    
    end
end

%% Response on preference
preference_VW2 = [];
preference_VWBoxe = [];
preference_SD2 = [];
preference_SDBar = [];
preference_SDUnderwater = [];
preference_SDTouvet = [];

for ind_user = user_start+1:nb_total_users+1 % to skip first row with column description
    
    user_id = data_res{ind_user,1};
    ind_row_mapping = find(cell2mat(data_mapping(2:end,1))==user_id)+1;
    
    for ind_video = 1:length(videos_vec)
        col_mapping_video = cols_mapping_video(ind_video);
        col_start_video = cols_start_video(ind_video);
        col_response = col_start_video + 6;
        if contains(string(data_mapping{ind_row_mapping,col_mapping_video}),'ref')
            if contains(string(data_res{ind_user,col_response}),'The former (the previous)')
                preference = 0;%-1;
            else
                preference = 1;
            end
        else
            if contains(string(data_res{ind_user,col_response}),'The former (the previous)')
                preference = 1;
            else
                preference = 0;%-1;
            end
        end
        if string(videos_vec{ind_video})=='VW2'
            preference_VW2 = [preference_VW2 ; preference];
        elseif string(videos_vec{ind_video})=='VW Boxe'
            preference_VWBoxe = [preference_VWBoxe ; preference];
        elseif string(videos_vec{ind_video})=='SD2'
            preference_SD2 = [preference_SD2 ; preference];
        elseif string(videos_vec{ind_video})=='SD Bar'
            preference_SDBar = [preference_SDBar ; preference];
        elseif string(videos_vec{ind_video})=='SD Underwater'
            preference_SDUnderwater = [preference_SDUnderwater ; preference];
        elseif string(videos_vec{ind_video})=='SD Touvet'
            preference_SDTouvet = [preference_SDTouvet ; preference];
        end
    
    end
end

%% Response on detection of effect, after human-processing of open comments
[num_res, txt_res, data_res] = xlsread('./Resulting_questionnaires/Questionnaire_on_experiments_withuserID_openanswprocessed.xlsx');
detection_VW2 = [];
detection_VWBoxe = [];
detection_SD2 = [];
detection_SDBar = [];
detection_SDUnderwater = [];
detection_SDTouvet = [];
orderfordetection_VW2 = [];
orderfordetection_VWBoxe = [];
orderfordetection_SD2 = [];
orderfordetection_SDBar = [];
orderfordetection_SDUnderwater = [];
orderfordetection_SDTouvet = [];

for ind_user = user_start+1:nb_total_users+1 % to skip first row with column description
    
    user_id = data_res{ind_user,1};
    ind_row_mapping = find(cell2mat(data_mapping(2:end,1))==user_id)+1;
    
    for ind_video = 1:length(videos_vec)
        col_mapping_video = cols_mapping_video(ind_video);
        col_start_video = cols_start_video(ind_video);
        if contains(string(data_mapping{ind_row_mapping,col_mapping_video}),'ref')
            col_response = col_start_video + 12;
            order = 2;
        else
            col_response = col_start_video + 5;
            order = 1;
        end
        detection = data_res{ind_user,col_response};
        % fusing 1 and 2
        detection(detection==2)=1;
        if string(videos_vec{ind_video})=='VW2'
            detection_VW2 = [detection_VW2 ; detection];
            orderfordetection_VW2 = [orderfordetection_VW2 ; order];
        elseif string(videos_vec{ind_video})=='VW Boxe'
            detection_VWBoxe = [detection_VWBoxe ; detection];
            orderfordetection_VWBoxe = [orderfordetection_VWBoxe ; order];
        elseif string(videos_vec{ind_video})=='SD2'
            detection_SD2 = [detection_SD2 ; detection];
            orderfordetection_SD2 = [orderfordetection_SD2 ; order];
        elseif string(videos_vec{ind_video})=='SD Bar'
            detection_SDBar = [detection_SDBar ; detection];
            orderfordetection_SDBar = [orderfordetection_SDBar ; order];
        elseif string(videos_vec{ind_video})=='SD Underwater'
            detection_SDUnderwater = [detection_SDUnderwater ; detection];
            orderfordetection_SDUnderwater = [orderfordetection_SDUnderwater ; order];
        elseif string(videos_vec{ind_video})=='SD Touvet'
            detection_SDTouvet = [detection_SDTouvet ; detection];
            orderfordetection_SDTouvet = [orderfordetection_SDTouvet ; order];
        end
    
    end
end


