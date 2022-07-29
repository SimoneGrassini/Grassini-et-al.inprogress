[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'channels', 'spec', 'on');


STUDY = pop_specparams(STUDY, 'topofreq', [8 13] );
STUDY = pop_specparams(STUDY, 'freqrange',[8 13], 'subtractsubjectmean', 'off' );

[STUDY specdata specfreqs pgroup pcond pinter] = std_specplot(STUDY,ALLEEG, 'channels',{'AF4' 'F4' 'F6' 'AF3' 'F3' 'F5' });

nature = specdata{1}
urban = specdata {2}
neutral= specdata {3}

neutral = squeeze(neutral (1,:,:))
nature = squeeze(nature (1,:,:))
urban = squeeze(urban (1,:,:))

% % 
% neutral = mean(neutral,1)
% 
% nature = mean(nature,1)
% 
% urban = mean(urban,1)

neutral = (10.^((neutral)/10));
% neutral = log(neutral)

nature = (10.^((nature)/10));
% nature = log(nature)
urban = (10.^((urban)/10));
% urban = log(urban)

nature = log(mean(nature(1:3,:))) - log(mean(nature(4:6,:)))
urban = log(mean(urban(1:3,:))) - log(mean(urban(4:6,:)))
neutral = log(mean(neutral(1:3,:))) - log(mean(neutral(4:6,:)))


export  = [nature;urban;neutral]
export = transpose(export)

[STUDY erpdata] = std_erpplot(STUDY,ALLEEG,'channels',{ 'POz' });
baseline1 = erpdata {1}
nature1 = erpdata {2}
urban1= erpdata {3}

[STUDY erpdata] = std_erpplot(STUDY,ALLEEG,'channels',{ 'Oz' });
baseline2 = erpdata {1}
nature2 = erpdata {2}
urban2= erpdata {3}

[STUDY erpdata] = std_erpplot(STUDY,ALLEEG,'channels',{ 'O1' });
baseline3 = erpdata {1}
nature3 = erpdata {2}
urban3= erpdata {3}


[STUDY erpdata] = std_erpplot(STUDY,ALLEEG,'channels',{ 'O2' });
baseline4 = erpdata {1}
nature4 = erpdata {2}
urban4= erpdata {3}



baseline = (baseline1+ baseline2 + baseline3 + baseline4 )/4
nature = (nature1+ nature2 + nature3+ nature4 )/4
urban= (urban1+ urban2 + urban3 + urban4)/4

baseline = mean(baseline (96:109,:))

nature = mean(nature (96:109,:))


urban = mean(urban (96:109,:))





export  = [baseline;nature;urban]

export = transpose(export)


% 
% neutral = squeeze(neutral (1,:,:))
% nature = squeeze(nature (1,:,:))
% urban = squeeze(urban (1,:,:))
% baseline = squeeze(baseline (1,:,:))


%%%%%%%%%%%%
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, 'channels',...
    'erp','off','erpparams',{'rmbase' [-500 0] },...
    'scalp','off',...
    'spec','on','specparams',{'freqrange' [1 40] 'specmode' 'psd' 'logtrials' 'off', 'winsize', 512},...
    'ersp','off','erspparams',{'cycles' [3 0.8] 'nfreqs' 100 'ntimesout' 200},...
    'itc','off');
