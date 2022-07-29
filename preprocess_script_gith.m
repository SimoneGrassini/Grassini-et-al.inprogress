
for subjID = 1:30
%LOAD
EEG = pop_loadset('filename',[num2str(subjID) '.set'], 'filepath','C:\Users\AA\Documents\nature3\');

%Select channel location
EEG=pop_chanedit(EEG, 'lookup','C:\\Users\\AA\\Documents\\eeglab-develop\\plugins\\dipfit4.3\\standard_BEM\\elec\\standard_1005.elc','eval','chans = pop_chancenter( chans, [],[]);');


%Select events
EEG = pop_selectevent( EEG, 'omittype',{'0, Impedance'},'deleteevents','on');


     EEG = pop_selectevent( EEG, 'omittype',{'0, Impedance' '3001, 1111###EEG','3001, 2222###EEG','3001, 3333###EEG' '3001, 3001###audio' '3002, 3002###audio' '3099, 3099###EEG' '3255, 3255###EEG' },'deleteevents','on');
            EEG = pop_select( EEG, 'nochannel',{'M1' 'M2' 'EOG'});


%Trim data over limits
      EEG  = pop_eegtrim( EEG, 100, 1000); 
        
    
    %Downsample the data.
    EEG = pop_resample(EEG, 256);
 
%  High-pass filter the data 

 EEG = pop_eegfiltnew(EEG, 'locutoff',1,'plotfreqz',0);

EEG = pop_eegfiltnew(EEG, 'hicutoff',40,'plotfreqz',0);


 %Apply clean_rawdata() to ONLY reject bad channels using Artifact Subspace Reconstruction (ASR).

EEGorig = EEG;

    EEG = pop_clean_rawdata (EEG, 'FlatlineCriterion', 5, 'Highpass', 'off', 'ChannelCriterion', 0.85, 'LineNoiseCriterion', 4, 'BurstCriterion', 'off', 'WindowCriterion', 'off', 'BurstRejection', 'off', 'Distance', 'Euclidian', 'WindowCriterionTolerance', 'off');
  
    %  Interpolate all the removed channels after calculating dataRank
dataRank = 61-(EEGorig.nbchan - EEG.nbchan)

EEG = pop_interp(EEG, EEGorig.chanlocs, 'spherical');
 
 
    % Re-reference the data to average adding 0el
    EEG.nbchan = EEG.nbchan+1;
    EEG.data(end+1,:) = zeros(1, EEG.pnts);
    EEG.chanlocs(1,EEG.nbchan).labels = 'initialReference';
    EEG = pop_reref(EEG, []);
    EEG = pop_select( EEG,'nochannel',{'initialReference'});
    
    
 
  %S epoching
 EEG = pop_epoch( EEG, {  '3011, 3011###EEG'  '3012, 3012###EEG'  '3013, 3013###EEG'  '3021, 3021###EEG'  '3022, 3022###EEG'  '3023, 3023###EEG'  '3031, 3031###EEG'  '3032, 3032###EEG'  '3033, 3033###EEG'  '3041, 3041###EEG'  '3042, 3042###EEG'  '3043, 3043###EEG'  }, [-0.2           1], 'newname', 'EEProbe continuous data epochs epochs epochs', 'epochinfo', 'yes');

 % Rejecting bad epochs
     EEG = pop_eegthresh(EEG,1,[1:EEG.nbchan] ,-500,500,-0.2,1,2,0);
EEG = pop_rejepoch( EEG, find(EEG.reject.rejthresh) ,0);


EEG = pop_jointprob(EEG,1,[1:EEG.nbchan] ,6,2,0,0,0,[],0);
EEG = pop_rejepoch( EEG, find(EEG.reject.rejjp) ,0);

%ICA decomposition

EEG = pop_runica(EEG, 'icatype','cudaica', 'options',{'extended',1,'pca',dataRank});
      
%ICA eliminate bad ICs
     EEG = pop_iclabel(EEG, 'default');

     EEG = pop_icflag(EEG,[NaN NaN;0.8 1;0.8 1;0.8 1;0.8 1;0.8 1;NaN NaN]);

     %SAVE
    
EEG = pop_saveset( EEG, 'filename',[num2str(subjID) '.set'],'filepath', 'C:\Users\AA\Documents\nature3\preprocessed');
clear all
close all
 

end