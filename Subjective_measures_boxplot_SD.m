clear all
clc
close all

user_start=1;

[responses_VW2_ref, responses_VW2_effect, responses_VWBoxe_ref, responses_VWBoxe_effect,...
    responses_SD2_ref, responses_SD2_effect, responses_SDBar_ref, responses_SDBar_effect,...
    responses_SDUnderwater_ref, responses_SDUnderwater_effect, responses_SDTouvet_ref, responses_SDTouvet_effect,...
    preference_VW2, preference_VWBoxe, preference_SD2, preference_SDBar, preference_SDUnderwater, preference_SDTouvet,...
    detection_VW2, detection_VWBoxe, detection_SD2, detection_SDBar, detection_SDUnderwater, detection_SDTouvet,...
    orderfordetection_VW2, orderfordetection_VWBoxe, orderfordetection_SD2, orderfordetection_SDBar, orderfordetection_SDUnderwater, orderfordetection_SDTouvet...
    ] = all_subjective_measures_Jan2019(user_start);

plotNames = {'Perceived quality', 'Perceived quality variation', 'Comfort', 'Responsiveness to head motion', 'Assessment of available time'};
nb_of_questions = length(plotNames);

colors = [0 0 0; 1 0 0];

foldername = 'figures_SD/';
filenames = {'visualquality','qualityvar','comfort','responsiveness','timeav'};

%% Plot answers to all questions as boxplots
%{
for i = [1,3] %:nb_of_questions
    figh=figure('Position', get(0, 'Screensize'));
    set(figh, 'DefaultTextFontSize', 28);
%     tensor_for_box = zeros([length(responses_VW2_ref(:,i)) 6 2]);
    tensor_for_box = zeros([length(responses_VW2_ref(:,i)) 4 2]);
%     tensor_for_box(:,1,:)=[responses_VW2_ref(:,i),responses_VW2_effect(:,i)];
%     tensor_for_box(:,2,:)=[responses_VWBoxe_ref(:,i),responses_VWBoxe_effect(:,i)];
%     tensor_for_box(:,3,:)=[responses_SD2_ref(:,i),responses_SD2_effect(:,i)];
%     tensor_for_box(:,4,:)=[responses_SDBar_ref(:,i),responses_SDBar_effect(:,i)];
%     tensor_for_box(:,5,:)=[responses_SDUnderwater_ref(:,i),responses_SDUnderwater_effect(:,i)];
%     tensor_for_box(:,6,:)=[responses_SDTouvet_ref(:,i),responses_SDTouvet_effect(:,i)];
    tensor_for_box(:,1,:)=[responses_SD2_ref(:,i),responses_SD2_effect(:,i)];
    tensor_for_box(:,2,:)=[responses_SDBar_ref(:,i),responses_SDBar_effect(:,i)];
    tensor_for_box(:,3,:)=[responses_SDUnderwater_ref(:,i),responses_SDUnderwater_effect(:,i)];
    tensor_for_box(:,4,:)=[responses_SDTouvet_ref(:,i),responses_SDTouvet_effect(:,i)];

%     tensor_for_box = zeros([3*length(responses_VW2_ref(:,i)) 2 2]);
%     tensor_for_box(:,2,:)=[[responses_SDBar_ref(:,i);responses_SDUnderwater_ref(:,i);responses_SDTouvet_ref(:,i)],[responses_SDBar_effect(:,i);responses_SDUnderwater_effect(:,i);responses_SDTouvet_effect(:,i)]];
%     padding_length=length(tensor_for_box(:,2,1))-length(responses_SD2_ref(:,i));
%     tensor_for_box(:,1,:)=[[responses_SD2_ref(:,i);NaN*ones(padding_length,1)],[responses_SD2_effect(:,i);NaN*ones(padding_length,1)]];
    
    iosr.statistics.boxPlot({'Comb. Explo (SD)','Bar (SD)', 'Underwater (SD)', 'Touvet (SD)'},tensor_for_box,...
        'notch',false,...
        'medianColor','g',...
        'showMean',true,'meanSize',10,'meanColor','k','lineWidth',2,...
        'symbolMarker',{'o','d'},...
        'boxcolor',{[0.2 0.3 0.9]; [0.9 0.3 0.2]},... %'boxcolor','auto',...
        'style','hierarchy',...
        'xSeparator',true,...
        'groupLabels',{{'ref','effect'}},...
        'groupLabelFontSize',28);
    box on
    %title(plotNames{i})
    if i==1, ylabel('visual quality score'); end
    if i==3, ylabel('comfort score'); end
    if i==4, ylabel('responsiveness score'); end
    ylim([0,5.5]);
    set(gca, 'FontSize',28)
    saveas(figh,[foldername filenames{i}],'fig');
    saveas(figh,[foldername filenames{i}],'epsc');
end
%}

%% Plot answer to the preference question
videos_vec = {'SD: Comb. Explo', 'Bar, Underwater, Touvet'}; %, 'Comb. Rides', 'Boxing'
%pref_mat = [preference_SD2, sum([preference_SDBar, preference_SDUnderwater, preference_SDTouvet],2)/3]; %,preference_VW2,preference_VWBoxe
pref_mat = {preference_SD2,[preference_SDBar;preference_SDUnderwater;preference_SDTouvet]}; %,preference_VW2,preference_VWBoxe
%%{
alpha = 0.1; %0.05
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 26);
place=[0.3 0.8];
hold on
for video_ind=1:length(videos_vec)
    preference = pref_mat{video_ind};
    pd = fitdist(preference,'binomial');
    pd_ci = paramci(pd,alpha);
    confint_low = pd.p-pd_ci(1,2);
    confint_high = pd_ci(2,2)-pd.p;
    bar(place(video_ind), pd.p, 0.1, 'FaceColor',[0.9 0.3 0.2],'EdgeColor',[0 .2 .9],'LineWidth',1.5)
    errorbar(place(video_ind), pd.p,confint_low,confint_high,'k.')
end
%lg=legend('Fraction of users preferring effect over reference');
%lg.FontSize=26;
ylabel('Fraction of users preferring effect');
set(gca, 'XTick', place)
set(gca, 'XTickLabel', videos_vec)
set(gca, 'ylim', [0 1])
set(gca, 'xlim', [0 1.1])
set(gca, 'FontSize',26)
hold off
saveas(figh,[foldername 'preference'],'fig');
saveas(figh,[foldername 'preference'],'epsc');
%%}

%% Plot fraction of users giving a qual<=3 in ref and effect
mos_cut=2;

question_ind=1; % considering mos on quality
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind),responses_SDUnderwater_ref(:,question_ind),responses_SDTouvet_ref(:,question_ind)];
% resp_mat_effect = [responses_SD2_effect(:,question_ind),responses_SDBar_effect(:,question_ind),responses_SDUnderwater_effect(:,question_ind),responses_SDTouvet_effect(:,question_ind)];
resp_mat_ref = [[responses_SD2_ref(:,question_ind);NaN*ones(36,1)],[responses_SDBar_ref(:,question_ind);responses_SDUnderwater_ref(:,question_ind);responses_SDTouvet_ref(:,question_ind)]];
resp_mat_effect = [[responses_SD2_effect(:,question_ind);NaN*ones(36,1)],[responses_SDBar_effect(:,question_ind);responses_SDUnderwater_effect(:,question_ind);responses_SDTouvet_effect(:,question_ind)]];
%%{
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 28);
hold on
pd_videos=[];
% cilow_videos=[];
% cihigh_videos=[];
for video_ind=1:length(videos_vec)
    responses_vid_ref = resp_mat_ref(:,video_ind);
    responses_vid_effect = resp_mat_effect(:,video_ind);
    pd_mos=[];
    ind_users = (responses_vid_ref<=mos_cut);
    frac_users = sum(ind_users)/length(ind_users);
    pd_mos = [pd_mos,frac_users];
    ind_users = (responses_vid_effect<=mos_cut);
    frac_users = sum(ind_users)/length(ind_users);
    pd_mos = [pd_mos,frac_users];
    pd_videos=[pd_videos;pd_mos];
end

b=bar(pd_videos)
b(1).FaceColor=[0.2 0.3 0.9];
b(2).FaceColor=[0.9 0.3 0.2];
% errorbar(pd_videos,cilow_videos,cihigh_videos,'.')
cell_leg=cell(1,2);
cell_leg{1,1}=['  in ref.'];
cell_leg{1,2}=['  in effect'];
lg=legend(cell_leg);
lg.Title.String = ['visual quality rated\newlinewith score <' num2str(mos_cut+1)];
lg.FontSize=26;
ylabel('fraction of users')
set(gca, 'XTick', [1:length(videos_vec)])
set(gca, 'XTickLabel', videos_vec)
set(gca, 'ylim', [0 0.7])
set(gca, 'FontSize',28)
hold off
saveas(figh,[foldername 'worstcase_' filenames{question_ind}],'fig');
saveas(figh,[foldername 'worstcase_' filenames{question_ind}],'epsc');
%}

%% Plot fraction of users prefering effect vs assessed visual quality in ref
question_ind=1;
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind),responses_SDUnderwater_ref(:,question_ind),responses_SDTouvet_ref(:,question_ind)];
resp_mat_ref = [[responses_SD2_ref(:,question_ind);NaN*ones(36,1)],[responses_SDBar_ref(:,question_ind);responses_SDUnderwater_ref(:,question_ind);responses_SDTouvet_ref(:,question_ind)]];
pref_mat = [[preference_SD2;NaN*ones(36,1)],[preference_SDBar;preference_SDUnderwater;preference_SDTouvet]];
% % Test per video
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind)];
% pref_mat = [preference_SD2,preference_SDBar];
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDUnderwater_ref(:,question_ind)];
% pref_mat = [preference_SD2,preference_SDUnderwater];
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDTouvet_ref(:,question_ind)];
% pref_mat = [preference_SD2,preference_SDTouvet];

%%{
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 26);
end_mos=5;
hold on
pd_videos=[];
% cilow_videos=[];
% cihigh_videos=[];
for video_ind=1:length(videos_vec)
    preference = pref_mat(:,video_ind);
    responses_vid_ref = resp_mat_ref(:,video_ind);
    pd_mos=[];
%     cimos_low=[];
%     cimos_high=[];
    for mos=1:end_mos
        ind_users = (responses_vid_ref==mos);
        frac_users=0;
        if sum(ind_users)>1, frac_users = sum(preference(ind_users))/sum(ind_users); end
        pd_mos = [pd_mos,frac_users];
%         pd = fitdist(preference(ind_users),'binomial');
%         pd_mos = [pd_mos,pd.p];
%         pd_ci = paramci(pd,alpha);
%         confint_low = pd.p-pd_ci(1,2);
%         confint_high = pd_ci(2,2)-pd.p;
%         cimos_low = [cimos_low,confint_low];
%         cimos_high = [cimos_high,confint_high];
    end
    pd_videos=[pd_videos;pd_mos];
%     cilow_videos=[cilow_videos;cimos_low];
%     cihigh_videos=[cihigh_videos;cimos_high];
end

bar(pd_videos);
% errorbar(pd_videos,cilow_videos,cihigh_videos,'.')
cell_leg=cell(1,end_mos);
for mos=1:end_mos, cell_leg{1,mos}=['   ' num2str(mos)]; end
ylabel('Fraction of users prefering effect')
lg=legend(cell_leg);
lg.Title.String='Visual quality\newlinein ref. rated at:';
lg.FontSize=22;
set(gca, 'XTick', [1:length(videos_vec)])
set(gca, 'XTickLabel', videos_vec)
set(gca, 'ylim', [0 1])
set(gca, 'FontSize',24)
hold off
saveas(figh,[foldername 'prefvsMOS_' filenames{question_ind}],'fig');
saveas(figh,[foldername 'prefvsMOS_' filenames{question_ind}],'epsc');
%%}

%% Plot fraction of users prefering effect vs assessed comfort ref
question_ind=3;
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind),responses_SDUnderwater_ref(:,question_ind),responses_SDTouvet_ref(:,question_ind)];
resp_mat_ref = [[responses_SD2_ref(:,question_ind);NaN*ones(36,1)],[responses_SDBar_ref(:,question_ind);responses_SDUnderwater_ref(:,question_ind);responses_SDTouvet_ref(:,question_ind)]];
pref_mat = [[preference_SD2;NaN*ones(36,1)],[preference_SDBar;preference_SDUnderwater;preference_SDTouvet]];
% % Test per video
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind)];
% pref_mat = [preference_SD2,preference_SDBar];
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDUnderwater_ref(:,question_ind)];
% pref_mat = [preference_SD2,preference_SDUnderwater];
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDTouvet_ref(:,question_ind)];
% pref_mat = [preference_SD2,preference_SDTouvet];
% resp_mat_ref = [[responses_SD2_ref(:,question_ind);NaN*ones(18,1)],[responses_SDBar_ref(:,question_ind);responses_SDTouvet_ref(:,question_ind)]];
% pref_mat = [[preference_SD2;NaN*ones(18,1)],[preference_SDBar;preference_SDTouvet]];

%%{
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 26);
end_mos=5;
hold on
pd_videos=[];
% cilow_videos=[];
% cihigh_videos=[];
for video_ind=1:length(videos_vec)
    preference = pref_mat(:,video_ind);
    responses_vid_ref = resp_mat_ref(:,video_ind);
    pd_mos=[];
%     cimos_low=[];
%     cimos_high=[];
    for mos=1:end_mos
        ind_users = (responses_vid_ref==mos);
        frac_users=0;
        if sum(ind_users)>1, frac_users = sum(preference(ind_users))/sum(ind_users); end
        pd_mos = [pd_mos,frac_users];
%         pd = fitdist(preference(ind_users),'binomial');
%         pd_mos = [pd_mos,pd.p];
%         pd_ci = paramci(pd,alpha);
%         confint_low = pd.p-pd_ci(1,2);
%         confint_high = pd_ci(2,2)-pd.p;
%         cimos_low = [cimos_low,confint_low];
%         cimos_high = [cimos_high,confint_high];
    end
    pd_videos=[pd_videos;pd_mos];
%     cilow_videos=[cilow_videos;cimos_low];
%     cihigh_videos=[cihigh_videos;cimos_high];
end

bar(pd_videos);
% errorbar(pd_videos,cilow_videos,cihigh_videos,'.')
cell_leg=cell(1,end_mos);
for mos=1:end_mos, cell_leg{1,mos}=['   ' num2str(mos)]; end
ylabel('Fraction of users prefering effect')
lg=legend(cell_leg);
lg.Title.String='Comfort\newlinein ref. rated at:';
lg.FontSize=22;
set(gca, 'XTick', [1:length(videos_vec)])
set(gca, 'XTickLabel', videos_vec)
set(gca, 'ylim', [0 1])
set(gca, 'FontSize',24)
hold off
saveas(figh,[foldername 'prefvsComfort_' filenames{question_ind}],'fig');
saveas(figh,[foldername 'prefvsComfort_' filenames{question_ind}],'epsc');
%%}

%% Plot fraction of users giving a comfort<=3 in ref and effect
mos_cut=3;

question_ind=3; % considering mos on quality
% resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind),responses_SDUnderwater_ref(:,question_ind),responses_SDTouvet_ref(:,question_ind)];
% resp_mat_effect = [responses_SD2_effect(:,question_ind),responses_SDBar_effect(:,question_ind),responses_SDUnderwater_effect(:,question_ind),responses_SDTouvet_effect(:,question_ind)];
resp_mat_ref = [[responses_SD2_ref(:,question_ind);NaN*ones(36,1)],[responses_SDBar_ref(:,question_ind);responses_SDUnderwater_ref(:,question_ind);responses_SDTouvet_ref(:,question_ind)]];
resp_mat_effect = [[responses_SD2_effect(:,question_ind);NaN*ones(36,1)],[responses_SDBar_effect(:,question_ind);responses_SDUnderwater_effect(:,question_ind);responses_SDTouvet_effect(:,question_ind)]];
% % Per video
resp_mat_ref = [responses_SD2_ref(:,question_ind),responses_SDBar_ref(:,question_ind)];
resp_mat_effect = [responses_SD2_effect(:,question_ind),responses_SDBar_effect(:,question_ind)];

%%{
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 28);
hold on
pd_videos=[];
% cilow_videos=[];
% cihigh_videos=[];
for video_ind=1:length(videos_vec)
    responses_vid_ref = resp_mat_ref(:,video_ind);
    responses_vid_effect = resp_mat_effect(:,video_ind);
    pd_mos=[];
    ind_users = (responses_vid_ref<=mos_cut);
    frac_users = sum(ind_users)/length(ind_users);
    pd_mos = [pd_mos,frac_users];
    ind_users = (responses_vid_effect<=mos_cut);
    frac_users = sum(ind_users)/length(ind_users);
    pd_mos = [pd_mos,frac_users];
    pd_videos=[pd_videos;pd_mos];
end

b=bar(pd_videos)
b(1).FaceColor=[0.2 0.3 0.9];
b(2).FaceColor=[0.9 0.3 0.2];
% errorbar(pd_videos,cilow_videos,cihigh_videos,'.')
cell_leg=cell(1,2);
cell_leg{1,1}=['  in ref.'];
cell_leg{1,2}=['  in effect'];
lg=legend(cell_leg);
lg.Title.String = ['comfort rated\newlinewith score <' num2str(mos_cut+1)];
lg.FontSize=26;
ylabel('fraction of users')
set(gca, 'XTick', [1:length(videos_vec)])
set(gca, 'XTickLabel', videos_vec)
set(gca, 'ylim', [0 0.7])
set(gca, 'FontSize',28)
hold off
saveas(figh,[foldername 'worstcase_' filenames{question_ind}],'fig');
saveas(figh,[foldername 'worstcase_' filenames{question_ind}],'epsc');
%}