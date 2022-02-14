
% % 创建文件夹
% for num = 1:32
%     dir_name = sprintf('E:\\Data_process\\FunImg\\Sub_%02d', num);
%     mkdir(dir_name)
% end

% c开头 3 12 13 16不是整齐的 

%% c开头, t1文件
for num = 1:16
    file = sprintf('E:\\fMRI_Data\\c%02d\\anat\\t1_mpr\\t1.nii', num);
    file2 = sprintf('E:\\fMRI_Data\\c%02d\\t1\\vol.nii', num);
    dest = sprintf('E:\\Data_process\\T1Img\\Sub_%02d', num);
    dest2 = sprintf('E:\\Data_process\\T1Img\\Sub_%02d\\t1.nii', num);
    
    if exist(file, 'file')
        copyfile(file, dest);
        disp([file, '  copy to ', dest]);
    elseif exist(file2, 'file')
        copyfile(file2, dest2);
        disp([file2, '  copy to ', dest2]);
    end
    
end

%% p开头，t1文件
for num = 1:16
    file = sprintf('E:\\fMRI_Data\\p%02d\\anat\\t1_mpr\\t1.nii', num);
    file2 = sprintf('E:\\fMRI_Data\\p%02d\\t1\\vol.nii', num);
    dest = sprintf('E:\\Data_process\\T1Img\\Sub_%02d', num+16);
    dest2 = sprintf('E:\\Data_process\\T1Img\\Sub_%02d\\t1.nii', num+16);
    
    if exist(file, 'file')
        copyfile(file, dest);
        disp([file, '  copy to ', dest]);
    elseif exist(file2, 'file')
        copyfile(file2, dest2);
        disp([file2, '  copy to ', dest2]);
    end
    
end

%% c开头，rest文件
for num = 1:16
    file = sprintf('E:\\fMRI_Data\\c%02d\\func\\rest_mb\\rest.nii', num);
    dest = sprintf('E:\\Data_process\\FunImg\\Sub_%02d', num);
    
    if exist(file, 'file')
        copyfile(file, dest);
        disp([file, '  copy to ', dest]);
    end
end

%% p开头，rest文件
for num = 1:16
    file = sprintf('E:\\fMRI_Data\\p%02d\\func\\rest_mb\\rest.nii', num);
    dest = sprintf('E:\\Data_process\\FunImg\\Sub_%02d', num+16);
    
    if exist(file, 'file')
        copyfile(file, dest);
        disp([file, '  copy to ', dest]);
    end
end

%% 不整齐的700个
for num = [3, 12, 13, 16]
    for i  = 1:700
        file = sprintf('E:\\fMRI_Data\\c%02d\\rest\\f%03d.nii', num, i);
        if i==1
            if exist(file, 'file')
                disp([file, ' exist.']);
            else
                break
            end
        end
        dest = sprintf('E:\\Data_process\\FunImg\\Sub_%02d', num);
        copyfile(file, dest);
        if i ==1 || mod(i, 100) ==0
            disp([file, ' copy to ', dest]);
        end
        
    end
end




