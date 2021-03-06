function step1_gen_test_metadata(sport)
    frmdir = ['/media/data/mtriet/dataset/', sport, '_frames_eval/']; 
    bindir = ['/media/data/mtriet/cdc/huawei/predata/', sport, '_eval/window/'];    
    folder = dir(frmdir); 
    binfolder = dir(bindir);
    
    % count number of frames
    
    videoid = zeros(36182*32,1); % 36182*32=1157824
    frmid = zeros(36182*32,1);
    kept_frm_index = zeros(36182*32,1);

    count = 0;
    index = 0;
    for folder_index = 3:size(folder,1)
        folder_index
        img = dir( [frmdir folder(folder_index).name '/*jpg'] );
        bin = dir( [bindir binfolder(folder_index).name '/*bin'] );
        tmp = strsplit(folder(folder_index).name,'_');
%        videoid((count+1):(count+size(img,1))) = str2num(tmp{end - 1});  % ordinal number of a video
        videoid((count+1):(count+size(img,1))) = str2num(tmp{end});  % ordinal number of a video
        frmid((count+1):(count+size(img,1))) = 1:size(img,1);
        kept_frm_index((count+1):(count+32*(size(bin,1)-1))) = (index+1):(index+32*(size(bin,1)-1));
        kept_frm_index(((count+32*(size(bin,1)-1))+1):(count+size(img,1))) ... 
            = ((index+32*size(bin,1)+32*(size(bin,1)-1))+1-size(img,1)):(index+32*size(bin,1));
        count = count + size(img,1);
        index = index + 32*size(bin,1);
    end
    
    videoid = videoid(1:count); % 36182*32=1157824
    frmid = frmid(1:count);
    kept_frm_index = kept_frm_index(1:count); 
    keyboard;
    save([sport, '_metadata.mat'],'videoid','frmid','kept_frm_index');
    disp('done')
end
