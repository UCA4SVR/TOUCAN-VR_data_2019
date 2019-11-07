clear all
clc
close all

[duration_hits_VW2, duration_hits_VWBoxe] = all_objective_measures_Jan2019();

foldername = 'figures/';

%% Hit duration vs hit order
duration_hits=[duration_hits_VW2,duration_hits_VWBoxe];
[s,d] = cellfun(@size,duration_hits);
hit_max=7;%max(d);

wall_start=[18000,57000,105000,160000];

tensor_duration=zeros([length(duration_hits_VW2) 5 hit_max]);
for i=1:length(duration_hits_VW2)
    duration_vec = duration_hits_VW2{i};
    ind_F1 = (duration_vec(2,:) < wall_start(2));
    ind_Trike = (duration_vec(2,:) >= wall_start(2) & duration_vec(2,:) < wall_start(3));
    ind_AssassinsCreed = (duration_vec(2,:) >= wall_start(3) & duration_vec(2,:) < wall_start(4));
    ind_TotalWar = (duration_vec(2,:) >= wall_start(4));
    
    dur_vec=duration_vec(1,ind_F1); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_duration(i,1,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(1,ind_Trike); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_duration(i,2,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(1,ind_AssassinsCreed); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_duration(i,3,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(1,ind_TotalWar); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_duration(i,4,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    
end
for i=1:length(duration_hits_VWBoxe)
    duration_vec = duration_hits_VWBoxe{i};
    if isempty(duration_vec), duration_vec=NaN; end
    dur_vec=duration_vec; dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_duration(i,5,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
end
%{
figh=figure('Position', get(0, 'Screensize'));
set(gca, 'FontSize',24)
set(figh, 'DefaultTextFontSize', 28);
%for 7 bars
% bar_colors={[0,0.447,0.741],[0.85,0.325,0.098],[0.929,0.694,0.125],...
%     [0.494,0.184,0.556],[0.466,0.674,0.188],[0.301,0.745,0.933],[0.635,0.078,0.184]};
% bar_colors={'r','m','b','g','c','y','w'}; %[0 0.5 1]
bar_colors={[1 0 0],[1 0 1],[0 0.5 1],[0 1 0],[0 1 1],[1 1 0],[1 1 1]};
    
cell_hitind={'1'};
for i=2:hit_max, cell_hitind{i}=num2str(i); end
bh=iosr.statistics.boxPlot({'F1','Trike','Assassins Creed','Total War','Boxing'},tensor_duration,...
        'notch',false,...
        'medianColor','k',...
        'boxcolor',bar_colors,...%'auto',...%'themeColors',{[0.2 0.3 0.9]; [0.9 0.3 0.2]},...
        'style','hierarchy',...
        'xSeparator',true,...
        'groupLabels',{cell_hitind},...
        'groupLabelFontSize',30,...
        'sampleSize',true,'sampleFontSize',16,...
        'showLegend',false); %true
    box on
ylim([0 8e3])
yl=ylabel('duration of hit (ms)');
set(gca, 'FontSize',24)
yl.FontSize=36;
saveas(figh,[foldername 'hitdurvsorder'],'fig');
saveas(figh,[foldername 'hitdurvsorder'],'epsc');

%% Hit start time vs hit order
duration_hits=[duration_hits_VW2,duration_hits_VWBoxe];
[s,d] = cellfun(@size,duration_hits);
hit_max=7;%max(d);

wall_start=[18000,57000,105000,160000];

tensor_start=zeros([length(duration_hits_VW2) 5 hit_max]);
for i=1:length(duration_hits_VW2)
    duration_vec = duration_hits_VW2{i};
    ind_F1 = (duration_vec(2,:) < wall_start(2));
    ind_Trike = (duration_vec(2,:) >= wall_start(2) & duration_vec(2,:) < wall_start(3));
    ind_AssassinsCreed = (duration_vec(2,:) >= wall_start(3) & duration_vec(2,:) < wall_start(4));
    ind_TotalWar = (duration_vec(2,:) >= wall_start(4));
    
    dur_vec=duration_vec(2,ind_F1)-wall_start(1); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_start(i,1,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(2,ind_Trike)-wall_start(2); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_start(i,2,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(2,ind_AssassinsCreed)-wall_start(3); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_start(i,3,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(2,ind_TotalWar)-wall_start(4); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_start(i,4,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    
end
for i=1:length(duration_hits_VWBoxe)
    duration_vec = duration_hits_VWBoxe{i};
    if isempty(duration_vec), duration_vec=NaN; end
    if ~isnan(duration_vec), dur_vec=duration_vec(2,:)-25000; else, dur_vec=duration_vec; end; 
    dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_start(i,5,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
end

figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 28);
set(gca, 'FontSize',24)
%for 7 bars
% bar_colors={[0,0.447,0.741],[0.85,0.325,0.098],[0.929,0.694,0.125],...
%     [0.494,0.184,0.556],[0.466,0.674,0.188],[0.301,0.745,0.933],[0.635,0.078,0.184]};
% bar_colors={'r','m','b','g','c','y','w'}; %[0 0.5 1]
bar_colors={[1 0 0],[1 0 1],[0 0.5 1],[0 1 0],[0 1 1],[1 1 0],[1 1 1]};
    
cell_hitind={'1'};
for i=2:hit_max, cell_hitind{i}=num2str(i); end
bh=iosr.statistics.boxPlot({'F1','Trike','Assassins Creed','Total War','Boxing'},tensor_start,...
        'notch',false,...
        'medianColor','k',...
        'boxcolor',bar_colors,...%'auto',...%'themeColors',{[0.2 0.3 0.9]; [0.9 0.3 0.2]},...
        'style','hierarchy',...
        'xSeparator',true,...
        'groupLabels',{cell_hitind},...
        'groupLabelFontSize',30,...
        'sampleSize',true,'sampleFontSize',16,...
        'showLegend',false); %true
    box on
%ylim([0 10000])
yl=ylabel('time of hit (ms)');
set(gca, 'FontSize',24)
yl.FontSize=36;
saveas(figh,[foldername 'hittimevsorder'],'fig');
saveas(figh,[foldername 'hittimevsorder'],'epsc');
%}
%% Histogram of number of hits for each wall

mat_nbhits_userxwall = sum(~isnan(tensor_duration),3);
mat_wallxnb = zeros(5,hit_max);
for ind_wall=1:5
    for ind_nb=0:hit_max
        mat_wallxnb(ind_wall,ind_nb+1)=sum(mat_nbhits_userxwall(:,ind_wall)==ind_nb);
    end
end

% restricting to: 0, 0 or 1, more than 2
mat_restr= zeros(5,3);
mat_restr(:,1)=mat_wallxnb(:,1);
mat_restr(:,2)=sum(mat_wallxnb(:,1:3),2);
mat_restr(:,3)=sum(mat_wallxnb(:,4:end),2);

figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 30);

%bar(mat_wallxnb,'hist')
h=bar(mat_restr)

set(gca,'XTick',1:5)
set(gca,'XtickLabel',{'F1','Trike','Assassins Creed','Total War','Boxing'})
lg=legend('0 hit','less than 2 hits','more than 3 hits');
lg.FontSize=28;
yl=ylabel('number of users')
set(gca, 'FontSize',24)
yl.FontSize=36;
saveas(figh,[foldername 'nbofhits_eachwall'],'fig');
saveas(figh,[foldername 'nbofhits_eachwall'],'epsc');

%% Hit depth vs hit order
duration_hits=[duration_hits_VW2,duration_hits_VWBoxe];
[s,d] = cellfun(@size,duration_hits);
hit_max=7;%max(d);

wall_start=[18000,57000,105000,160000];

tensor_depth=zeros([length(duration_hits_VW2) 5 hit_max]);
for i=1:length(duration_hits_VW2)
    duration_vec = duration_hits_VW2{i};
    ind_F1 = (duration_vec(2,:) < wall_start(2));
    ind_Trike = (duration_vec(2,:) >= wall_start(2) & duration_vec(2,:) < wall_start(3));
    ind_AssassinsCreed = (duration_vec(2,:) >= wall_start(3) & duration_vec(2,:) < wall_start(4));
    ind_TotalWar = (duration_vec(2,:) >= wall_start(4));
    
    dur_vec=duration_vec(3,ind_F1); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_depth(i,1,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(3,ind_Trike); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_depth(i,2,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(3,ind_AssassinsCreed); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_depth(i,3,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    dur_vec=duration_vec(3,ind_TotalWar); dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_depth(i,4,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
    
end
for i=1:length(duration_hits_VWBoxe)
    duration_vec = duration_hits_VWBoxe{i};
    if isempty(duration_vec), duration_vec=NaN; end
    if ~isnan(duration_vec), dur_vec=duration_vec(3,:); else, dur_vec=duration_vec; end; 
    dur_vec=dur_vec(1,1:min(size(dur_vec,2),hit_max));
    tensor_depth(i,5,:)=[dur_vec,NaN*ones(1,hit_max-size(dur_vec,2))];
end

figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 22);
%for 7 bars
% bar_colors={[0,0.447,0.741],[0.85,0.325,0.098],[0.929,0.694,0.125],...
%     [0.494,0.184,0.556],[0.466,0.674,0.188],[0.301,0.745,0.933],[0.635,0.078,0.184]};
% bar_colors={'r','m','b','g','c','y','w'}; %[0 0.5 1]
bar_colors={[1 0 0],[1 0 1],[0 0.5 1],[0 1 0],[0 1 1],[1 1 0],[1 1 1]};
    
cell_hitind={'1'};
for i=2:hit_max, cell_hitind{i}=num2str(i); end
bh=iosr.statistics.boxPlot({'F1','Trike','Assassins Creed','Total War','Boxing'},tensor_depth,...
        'notch',false,...
        'medianColor','k',...
        'boxcolor',bar_colors,...%'auto',...%'themeColors',{[0.2 0.3 0.9]; [0.9 0.3 0.2]},...
        'style','hierarchy',...
        'xSeparator',true,...
        'groupLabels',{cell_hitind},...
        'groupLabelFontSize',20,...
        'sampleSize',true,'sampleFontSize',12,...
        'showLegend',false); %true
    box on
%ylim([0 10000])
ylabel('depth of hit (ms)')
set(gca, 'FontSize',24)
saveas(figh,[foldername 'hitdepthvsorder'],'fig');
saveas(figh,[foldername 'hitdepthvsorder'],'epsc');


%% Scatter plot between each pair {comfort, responsiveness} vs {nb of hits, time in wall, depth in wall}

[responses_VW2_ref, responses_VW2_effect, responses_VWBoxe_ref, responses_VWBoxe_effect,...
    responses_SD2_ref, responses_SD2_effect, responses_SDBar_ref, responses_SDBar_effect,...
    responses_SDUnderwater_ref, responses_SDUnderwater_effect, responses_SDTouvet_ref, responses_SDTouvet_effect,...
    preference_VW2, preference_VWBoxe, preference_SD2, preference_SDBar, preference_SDUnderwater, preference_SDTouvet,...
    detection_VW2, detection_VWBoxe, detection_SD2, detection_SDBar, detection_SDUnderwater, detection_SDTouvet,...
    orderfordetection_VW2, orderfordetection_VWBoxe, orderfordetection_SD2, orderfordetection_SDBar, orderfordetection_SDUnderwater, orderfordetection_SDTouvet...
    ] = all_subjective_measures_Jan2019(3);
question_ind=1;
quality_VW2 = responses_VW2_effect(:,question_ind);
quality_VWBoxe = responses_VWBoxe_effect(:,question_ind);
question_ind=3;
comfort_VW2 = responses_VW2_effect(:,question_ind);
comfort_VWBoxe = responses_VWBoxe_effect(:,question_ind);
question_ind=4;
responsiveness_VW2 = responses_VW2_effect(:,question_ind);
responsiveness_VWBoxe = responses_VWBoxe_effect(:,question_ind);

avg_hits_users_VW2=sum(sum(~isnan(tensor_duration(:,1:4,:)),3),2)/4;
avg_hitduration_users_VW2=nanmedian(nanmedian((tensor_duration(:,1:4,:)),3),2);
avg_hitdepth_users_VW2=nanmedian(nanmedian((tensor_depth(:,1:4,:)),3),2);
avg_hits_users_VWBoxe=sum(sum(~isnan(tensor_duration(:,5,:)),3),2);
avg_hitduration_users_VWBoxe=nanmedian(nanmedian((tensor_duration(:,5,:)),3),2);
avg_hitdepth_users_VWBoxe=nanmedian(nanmedian((tensor_depth(:,5,:)),3),2);
avg_hitduration_users_VWBoxe(isnan(avg_hitduration_users_VWBoxe))=0;
avg_hitdepth_users_VWBoxe(isnan(avg_hitdepth_users_VWBoxe))=0;

disp('Correlation matrix between num of hits, hit duration, hit depth, and comfort, responsiveness, quality:')
corr_matrix = corrcoef([[avg_hits_users_VW2;avg_hits_users_VWBoxe],[avg_hitduration_users_VW2;avg_hitduration_users_VWBoxe],[avg_hitdepth_users_VW2;avg_hitdepth_users_VWBoxe],...
    [comfort_VW2;comfort_VWBoxe],[responsiveness_VW2;responsiveness_VWBoxe],[quality_VW2;quality_VWBoxe]])

%% hits vs comfort and duration vs responsiveness
%%{
hits_vec=[];
duration_vec=[];
depth_vec=[];
mos_vec=[];
for level_MOS=1:5
    ind_VW2 = (comfort_VW2==level_MOS);
    ind_VWBoxe = (comfort_VWBoxe==level_MOS);
    if sum([ind_VW2;ind_VWBoxe])
        mos_vec=[mos_vec;repmat(level_MOS,sum([ind_VW2;ind_VWBoxe]),1)];
        hits_vec=[hits_vec;avg_hits_users_VW2(ind_VW2);avg_hits_users_VWBoxe(ind_VWBoxe)];
        duration_vec=[duration_vec;avg_hitduration_users_VW2(ind_VW2);avg_hitduration_users_VWBoxe(ind_VWBoxe)];
        depth_vec=[depth_vec;avg_hitdepth_users_VW2(ind_VW2);avg_hitdepth_users_VWBoxe(ind_VWBoxe)];
    end
end
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 28);
boxplot(hits_vec,mos_vec,'Widths',0.5);
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'g');
set(findobj(gca,'type','line'),'linew',2)
xlabel('comfort score')
ylabel('Num. of hits per wall')
ylim([0 6])
set(gca, 'FontSize',28)
saveas(figh,[foldername 'comfortvshits'],'fig');
saveas(figh,[foldername 'comfortvshits'],'epsc');
%}

%% hits vs comfort vs quality
%%{
quality_vec=[];
mos_vec=[];
for level_MOS=1:5
    ind_VW2 = (comfort_VW2==level_MOS);
    ind_VWBoxe = (comfort_VWBoxe==level_MOS);
    if sum([ind_VW2;ind_VWBoxe])
        mos_vec=[mos_vec;repmat(level_MOS,sum([ind_VW2;ind_VWBoxe]),1)];
        quality_vec=[quality_vec;quality_VW2(ind_VW2);quality_VWBoxe(ind_VWBoxe)];
    end
end
figh=figure('Position', get(0, 'Screensize'));
set(figh, 'DefaultTextFontSize', 28);
boxplot(quality_vec,mos_vec,'Widths',0.5);
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'g');
set(findobj(gca,'type','line'),'linew',2)
xlabel('comfort score')
ylabel('quality score')
ylim([0 6])
set(gca, 'FontSize',28)
saveas(figh,[foldername 'comfortvsqual'],'fig');
saveas(figh,[foldername 'comfortvsqual'],'epsc');
%}


