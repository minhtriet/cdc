function step3_gen_CDC_det(sport)

    clearvars -except sport

    load([sport '_scnn_proposal.mat']);
    % seg_swin is supposed to be a tall matrix
    seg_swin = seg_swin';
    seg_swin = seg_swin(seg_swin(:,10)>0.7,:);
    load([sport, '_proball.mat']);
    proball = proball';
    load([sport, '_metadata.mat']);

    FPS=25;

    for i=1:length(seg_swin)
        i
        prob = proball(videoid==seg_swin(i,1),:);        
        seg_swin(i,3) = max(1,seg_swin(i,3)-seg_swin(i,2)/8);
        seg_swin(i,4) = min(seg_swin(i,4)+seg_swin(i,2)/8,size(prob,1));        
        prob = prob(seg_swin(i,3):seg_swin(i,4),:);
        mprob = mean(prob);
        [~,seg_swin(i,11)] = max(mprob);
        [mu,sigma] = normfit(prob(:,seg_swin(i,11)));
        minthre = mu-sigma;
        ind = find((prob(:,seg_swin(i,11)) >= minthre) ==1);
        s = seg_swin(i,3);
        seg_swin(i,5) = seg_swin(i,3)/FPS;
        seg_swin(i,6) = seg_swin(i,4)/FPS;
        seg_swin(i,2) = seg_swin(i,4)-seg_swin(i,3)+1;
        seg_swin(i,9) = mean(prob(ind(1):ind(end),seg_swin(i,11)));
    
    seg_swin(:,11) = seg_swin(:,11) - 1;

    save([sport '_res_seg_swin.mat'],'seg_swin');

end
