function [scData, timepoints] = loadScRNAseqData()
[filename, foldername] = uigetfile({'*.xlsx','*.xls'}, 'Select a Single cell RNA seq cluster data file');

try
    [~,sheets] = xlsfinfo([foldername,filename]);
    scData = cell(1,length(sheets));
    if ~isempty(sheets)
        timepoints = [];
        for i = 1:length(sheets)
            t = str2double(sheets{i});
            if isnan(t)
                errordlg('Please ensure that the sheet names are all numeric values corresponding to the timepoints','Sheet Name Error','modal');
                return;
            end    
            
            if mod(t,1) > 0
                errordlg('Sheet names can only be integers','Non-integer Timepoint Error','modal');
                return;
            end
            
            tmp = readtable([foldername,filename],'Sheet',sheets{i},'ReadVariableNames',0);
            tmp = table2cell(tmp);            
            if size(tmp,1) < 101
                errordlg('Too few cells. At least 100 cells needed for single cell data','SC data error','modal');
                return;
            end
            
            if size(tmp,2) > 1
                errordlg('Each sheet should only have one column with cell types','SC data error','modal');
                return;
            end
            
            cols = tmp(1,:);
            if ~iscellstr(cols)
                errordlg('Please ensure that the first row in each worksheet has the column name','Column Name Error','modal');
                return;
            end
            
            if i == 1
                base_cols = cols;
            end
            
            if ~isequal(base_cols,cols)
                errordlg('Please ensure that the column names are the same in each sheet (timepoint)','Column Name Mismatch Error','modal');
                return;
            end
                
            scData{1,i} = tmp;
            timepoints = [timepoints t];
        end

    end   
catch
end
