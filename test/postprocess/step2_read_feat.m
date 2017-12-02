function [] = step2_read_feat(sport)
    %
    class_num = containers.Map
    class_num('fb') = 6
    class_num('bb') = 8
    inputdir = '../feat/';

    folder = dir(inputdir); 

    prob = zeros(36182*32,class_num(sport));

    count = 0;
    for folder_index = 3:size(folder,1)
        tic
        folder_index
        img = dir( [inputdir folder(folder_index).name '/*prob'] ); % be careful whether all are jpg
        for img_index = 1:size(img,1)
            [~,tmp] = read_binary_blob([inputdir folder(folder_index).name '/' img(img_index).name]);
            for i=1:32
                for c=1:class_num(sport)
                    prob(count+i,c) = tmp(32*(c-1)+i);
                end
            end
            count = count + 32;
        end
        toc
    end

    [max_class_score,max_class_index] = max(prob,[],2);

    save([sport, '_read_res.mat'],'prob','max_class_score','max_class_index');

    clear prob;
    clear proball;
    
    load([sport, '_read_res.mat']);
    load([sport, '_metadata.mat']);

    prob = prob(kept_frm_index,:);
    % proball = prob(:,2:class_num(sport))';  % last score was ambiguous class, actually 1st score

    proball = prob(:,1:class_num(sport))';  % last score was ambiguous class, actually 1st score
    save([sport, '_proball.mat'],'proball','videoid');
end
