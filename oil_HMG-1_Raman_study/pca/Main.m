clc;clear;close all
path = "C:\Users\eliez\Desktop\Ben-Protein Data_r1\nano-lab\data_savedbyEli";
NPA = import_singlePoint(path+"\1_bare NPA 10x (CRR) (SG) (Sub BG).txt", [2, Inf]);

oil_NPA_20x = import_singlePoint(path+"\5_NPA w oil 20x (CRR) (SG) (Sub BG).txt", [2, Inf]);
HMB_NPA = import_singlePoint(path+"\11_NPA w HMB-1 20x (CRR) (SG) (Sub BG).txt", [2, Inf]);

plot(NPA(:,1),NPA(:,2))
hold on
plot(oil_NPA_20x(:,1),oil_NPA_20x(:,2)+ 500)

plot(HMB_NPA(:,1),HMB_NPA(:,2)+1000)

axis([400 1800 -200 1500])
%index for bounds of spectra: 400 to 1300 wavenumber
first=find(HMB_NPA(:,1) >400,1);
last =find(HMB_NPA(:,1) >1300,1);
legend('bare NPA 10x','oil NPA 20x','HMB NPA 20x')
% figure
% 
% HMB_NPA = import_singlePoint(path+"\12_NPA w HMB-1 20x E30 (CRR) (Average 3) (Sub BG).txt", [2, Inf]);
% plot(HMB_NPA(:,1),HMB_NPA(:,2))
% plot(HMB_NPA(:,1),HMB_NPA(:,2))

%% averages
warning('off', 'all')
%% HMB1 protein
load(path+'\area scan NPA w HMB-1 20x (CRR) (SG) (Sub BG).mat');
A = area_scan_NPA_w_HMB1_20x_CRR_SG_Sub_BG.data;
X = A(:,first:last); %only work with segment of data

X_norm = zscore(X);

% Step 2: Perform PCA
[coeff, score, latent, tsquared, explained, mu] = pca(X_norm);

% % Step 3: Visualize the explained variance
figure;
pareto(explained);
xlabel('Principal Component');
ylabel('Variance Explained (%)');
title('Explained Variance by Principal Components');

% Step 4: Visualize the scores of the first two principal components
figure;
scatter(score(:,1), score(:,2), 25, 'filled');
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');
title('PCA Scores Plot');
grid on;
hold on
% 
% % Step 5: Visualize the loadings of the first principal component
% figure;
% plot(coeff(:,1));
% xlabel('Raman Shift Index');
% ylabel('PC1 Loading');
% title('Loadings of Principal Component 1');
% grid on;

%% oil
load(path+'\area scan NPA w oil 20x (CRR) (SG) (Sub BG).mat');
 A = area_scan_NPA_w_oil_20x_CRR_SG_Sub_BG.data;
 X = A(:,first:last);

X_norm = zscore(X);

% Step 2: Perform PCA
[coeff, score, latent, tsquared, explained, mu] = pca(X_norm);

scatter(score(:,1), score(:,2), 25, 'filled','k');

%% bare NPA

load(path+'\area scan bare NPA 10x (CRR) (SG) (Sub BG).mat');
A = area_scan_bare_NPA_10x_CRR_SG_Sub_BG.data;
X = A(:,first:last);

X_norm = zscore(X);

% Step 2: Perform PCA
[coeff, score, latent, tsquared, explained, mu] = pca(X_norm);

scatter(score(:,1), score(:,2), 25, 'filled','g');


%% HMB1 protein dried

load(path+'\large area scan dried HMB-1 (CRR) (SG) (Sub BG).mat');
A = large_area_scan_dried_HMB1_CRR_SG_Sub_BG.data;
X = A(:,first:last);

X_norm = zscore(X);

% Step 2: Perform PCA
[coeff, score, latent, tsquared, explained, mu] = pca(X_norm);

scatter(score(:,1), score(:,2), 25, 'filled','r');
