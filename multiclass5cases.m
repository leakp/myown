%%example for 5 very different subjects (of which 2 very similar)
load('C:\Users\user\Documents\Experiments\FearCloud_Eyelab\data\midlevel\singletrialfixmaps\N27\kernel_defualt_nonull_N_EV_60\labels.mat')
load('C:\Users\user\Documents\Experiments\FearCloud_Eyelab\data\midlevel\singletrialfixmaps\N27\kernel_defualt_nonull_N_EV_60\trialload.mat')
choosesubs = [4 9 12 18 24];
    
fix = Fixmat(unique(labels.sub(ismember(labels.easy_sub,choosesubs))),1:5);
fix.getsubmaps; 
fix.plot;


ind   = ismember(labels.easy_sub,choosesubs);
label = labels.easy_sub(ind);
data  = trialload(ind,:);
cc = 0;
for n = unique(label)
    cc=cc+1;
    label(label==n) = cc;
end

addpath('C:/Users/user/Documents/GitHub/LIBSVM-multi-classification/src/')
cmd = '-t 0 -c 1 -q';

%make partition
P    = cvpartition(label,'Holdout',.2);

trainLabel = label(P.training)';
trainData  = data(P.training,:);
testLabel  = label(P.test)';
testData   = data(P.test,:);
%%
% #######################
% Train the SVM in one-vs-rest (OVR) mode
% #######################

model = ovrtrainBot(trainLabel, trainData, cmd);

% #######################
% Classify samples using OVR model
% #######################
[predict_label, accuracy, decis_values] = ovrpredictBot(testLabel, testData, model);
[decis_value_winner, label_out] = max(decis_values,[],2);
%%
% #######################
% Make confusion matrix
% #######################
[confusionMatrix,order] = confusionmat(testLabel,label_out);
% Note: For confusionMatrix
% column: predicted class label
% row: ground-truth class label
% But we need the conventional confusion matrix which has
% column: actual
% row: predicted
NTest = sum(P.test);
figure; imagesc(confusionMatrix');
xlabel('actual class label');
ylabel('predicted class label');
totalAccuracy = trace(confusionMatrix)/NTest;
disp(['Total accuracy from the SVM: ',num2str(totalAccuracy*100),'%']);

%%