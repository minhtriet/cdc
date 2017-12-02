function [ ] = compute_framelevel_mAP(sport)
clearvars -except sport;

load([sport '_gt.mat']);   % load ground truth
no_classes = containers.Map({'fb', 'bb'}, {6, 8});

ap=zeros(no_classes(sport)-1 ,1);
load(['../../test/postprocess/' sport '_proball.mat']);
prob = proball';

%% simple temporal smoothing via NMS of 5-frames window
probsmooth = squeeze(max(cat(1,reshape(prob,[1,size(prob)]),reshape([prob(1,:);prob(1:(end-1),:)],[1,size(prob)]),...
    reshape([prob(2:end,:);prob(end,:)],[1,size(prob)]),reshape([prob(1:2,:);prob(1:(end-2),:)],...
    [1,size(prob)]),reshape([prob(3:end,:);prob((end-1):end,:)],[1,size(prob)]))));

%% eval
prob = probsmooth;
save(['../../' sport, '_proball_cdc.mat'],'proball','videoid');
%prob(prob(:,6)>prob(:,9),9) = prob(prob(:,6)>prob(:,9),6);	% assign cliff diving as diving

% remove bg
prob=prob(gt(:, 1) == 0,:);
videoid=videoid(gt(:, 1) == 0,:);
gt=gt(gt(:, 1)==0,:);

for i=2:no_classes(sport)
  i
  ground_t = gt(1:end,i);
  fprintf([num2str(sum(ground_t)) '\n']);
  ap(i-1) = apcal(prob(1:end,i),ground_t);
end

map = mean(ap)
