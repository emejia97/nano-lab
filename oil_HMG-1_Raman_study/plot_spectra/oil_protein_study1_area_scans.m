clear; clc; close all;

path_S1_bare = 'AS S1 bare NPA 10x/area scan bare NPA 10x';

path_S1_oil_10x = 'AS S1 NPA w oil 10x/area scan NPA w oil 10x';
path_S1_oil_20x = 'AS S1 NPA w oil 20x/area scan NPA w oil 20x';

path_S2_HMB1_10x = 'AS S2 NPA w HMB-1 10x/area scan NPA w HMB-1 10x';
path_S2_HMB1_20x = 'AS S2 NPA w HMB-1 20x/area scan NPA w HMB-1 20x';

path_S2_HMB1_dried = 'LAS S2 dried HMB-1/large area scan dried HMB-1';

%paths = {path_S1_bare, path_S1_oil_10x, path_S1_oil_20x, ... 
%         path_S2_HMB1_10x, path_S2_HMB1_20x, path_S2_HMB1_dried};

paths = {path_S1_bare, path_S1_oil_20x, path_S2_HMB1_20x, path_S2_HMB1_dried};

lambda_ex = 784.500; %nm - excitation wavelength

fp = paths;
N = length(fp);


[wavenums, specs] = extractSpecs(fp, lambda_ex, N);

%figure
%plot(wavenums, specs.data(1,:))


%% outlier removal with Isolation Forest for each area scan at each timestamp - do this one time only

numTrees = 200; % Number of trees in the forest
ContaminationFraction = 0.05;
showPCA = false;
nIter = 2;

for i = 1:4
    specs(i).data = removeOutliers(specs(i).data, numTrees, ContaminationFraction, nIter, showPCA);
end

Ns_specs1 = size(specs(1).data, 1);

%% Plot

c1 = "#0072BD"; % 
c2 = "#D95319"; % 
c3 = "#EDB120"; % 
c4 = "#7E2F8E"; %

avg_spec_bare = mean(specs(1).data, 1);
std_spec_bare = std(specs(1).data, 1);
spec_bare_UB = avg_spec_bare + std_spec_bare;
spec_bare_LB = avg_spec_bare - std_spec_bare;

fac = 0.03;

avg_spec_oil_20x = mean(specs(2).data, 1);
avg_spec_oil_20x = avg_spec_oil_20x + fac*max(abs(avg_spec_bare));
std_spec_oil_20x = std(specs(2).data, 1);
spec_oil_20x_UB = avg_spec_oil_20x + std_spec_oil_20x;
spec_oil_20x_LB = avg_spec_oil_20x - std_spec_oil_20x;

avg_spec_HMB1_20x = mean(specs(3).data, 1);
avg_spec_HMB1_20x = avg_spec_HMB1_20x + 2*fac*max(abs(avg_spec_oil_20x));
std_spec_HMB1_20x = std(specs(3).data, 1);
spec_HMB1_20x_UB = avg_spec_HMB1_20x + std_spec_HMB1_20x;
spec_HMB1_20x_LB = avg_spec_HMB1_20x - std_spec_HMB1_20x;

avg_spec_HMB1_d_20x = mean(specs(4).data, 1);
avg_spec_HMB1_d_20x = avg_spec_HMB1_d_20x + 3*fac*max(abs(avg_spec_HMB1_20x));
std_spec_HMB1_d_20x = std(specs(4).data, 1);
spec_HMB1_d_20x_UB = avg_spec_HMB1_d_20x + std_spec_HMB1_d_20x;
spec_HMB1_d_20x_LB = avg_spec_HMB1_d_20x - std_spec_HMB1_d_20x;

figure
p1 = plot(wavenums, avg_spec_bare, 'LineWidth', 1);
p1.Color = c1;

hold on
f1 = fill([wavenums, fliplr(wavenums)], [spec_bare_UB, fliplr(spec_bare_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f1.FaceColor = c1;

p2 = plot(wavenums, avg_spec_oil_20x, 'LineWidth', 1);
p2.Color = c2;
f2 = fill([wavenums, fliplr(wavenums)], [spec_oil_20x_UB, fliplr(spec_oil_20x_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f2.FaceColor = c2;


p3 = plot(wavenums, avg_spec_HMB1_20x, 'LineWidth', 1);
p3.Color = c3;
f3 = fill([wavenums, fliplr(wavenums)], [spec_HMB1_20x_UB, fliplr(spec_HMB1_20x_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f3.FaceColor = c3;


p3 = plot(wavenums, avg_spec_HMB1_d_20x, 'LineWidth', 1);
p3.Color = c4;
f3 = fill([wavenums, fliplr(wavenums)], [spec_HMB1_d_20x_UB, fliplr(spec_HMB1_d_20x_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f3.FaceColor = c4;

hold off

xlim([400,1800])
legend("Bare NPA", "", "oil NPA 20x", "", "HMB NPA 20x", "", "Dried HMB NPA 20x", "")
xlabel("Wavenumber (rel. cm^{-1})")
ylabel("Intensity (arb.)")


fac = 0.4;

spec_oil_sub_bare = specs(2).data(1:Ns_specs1, :) - specs(1).data;

avg_spec_oil_sub_bare = mean(spec_oil_sub_bare, 1);
std_spec_oil_sub_bare = std(spec_oil_sub_bare, 1);
spec_oil_sub_bare_UB = avg_spec_oil_sub_bare + std_spec_oil_sub_bare;
spec_oil_sub_bare_LB = avg_spec_oil_sub_bare - std_spec_oil_sub_bare;


spec_HMB1_sub_bare = specs(3).data(1:Ns_specs1, :) - specs(1).data;

avg_spec_HMB1_sub_bare = mean(spec_HMB1_sub_bare, 1);
avg_spec_HMB1_sub_bare = avg_spec_HMB1_sub_bare + 2*fac*max(abs(avg_spec_oil_sub_bare));
std_spec_HMB1_sub_bare = std(spec_HMB1_sub_bare, 1);
spec_HMB1_sub_bare_UB = avg_spec_HMB1_sub_bare + std_spec_HMB1_sub_bare;
spec_HMB1_sub_bare_LB = avg_spec_HMB1_sub_bare - std_spec_HMB1_sub_bare;


spec_HMB1d_sub_bare = specs(4).data(1:Ns_specs1,:) - specs(1).data;
%avg_spec_HMB1d_sub_bare = mean(specs(4).data) - mean(specs(1).data);

avg_spec_HMB1d_sub_bare = mean(spec_HMB1d_sub_bare, 1);
avg_spec_HMB1d_sub_bare = avg_spec_HMB1d_sub_bare + 2.5*fac*max(abs(avg_spec_HMB1_sub_bare));
std_spec_HMB1d_sub_bare = std(spec_HMB1d_sub_bare, 1);
spec_HMB1d_sub_bare_UB = avg_spec_HMB1d_sub_bare + std_spec_HMB1d_sub_bare;
spec_HMB1d_sub_bare_LB = avg_spec_HMB1d_sub_bare - std_spec_HMB1d_sub_bare;


figure
p1 = plot(wavenums, avg_spec_oil_sub_bare, 'LineWidth', 1);
p1.Color = c2;

hold on
f1 = fill([wavenums, fliplr(wavenums)], [spec_oil_sub_bare_UB, fliplr(spec_oil_sub_bare_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f1.FaceColor = c2;


p2 = plot(wavenums, avg_spec_HMB1_sub_bare, 'LineWidth', 1);
p2.Color = c3;
f2 = fill([wavenums, fliplr(wavenums)], [spec_HMB1_sub_bare_UB, fliplr(spec_HMB1_sub_bare_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f2.FaceColor = c3;


p3 = plot(wavenums, avg_spec_HMB1d_sub_bare, 'LineWidth', 1);
p3.Color = c4;
f3 = fill([wavenums, fliplr(wavenums)], [spec_HMB1d_sub_bare_UB, fliplr(spec_HMB1d_sub_bare_LB)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
f3.FaceColor = c4;

hold off

xlim([400,1800])
legend("Subbed oil NPA 20x", "", "Subbed HMB NPA 20x", "", "Subbed Dried HMB NPA 20x", "")
xlabel("Wavenumber (rel. cm^{-1})")
ylabel("Intensity (arb.)")
ylim([-0.02, 0.09])

%% PCA

X1 = specs(1).data(:, wavenums > 400 & wavenums < 1800);
X2 = specs(2).data(:, wavenums > 400 & wavenums < 1800);
X3 = specs(3).data(:, wavenums > 400 & wavenums < 1800);
X4 = specs(4).data(1:Ns_specs1, wavenums > 400 & wavenums < 1800);

%X = [X1; X2; X3; X4];
X = [X1; X2; X3];

X1 = spec_oil_sub_bare(:, wavenums > 400 & wavenums < 1800);
X2 = spec_HMB1_sub_bare(:, wavenums > 400 & wavenums < 1800);
X3 = spec_HMB1d_sub_bare(:, wavenums > 400 & wavenums < 1800);

spec1_sz = size(X1);
spec2_sz = size(X2);
spec3_sz = size(X3);
%spec4_sz = size(X4);

% Create the group labels (cell array of strings or categorical array).
%{
groupLabels = [repmat("Bare", spec1_sz(1), 1);
               repmat("Oil", spec2_sz(1), 1);
               repmat("HMG-1", spec3_sz(1), 1);
               repmat("HMG-1 Dry", spec4_sz(1), 1)];
%}

groupLabels = [repmat("Oil", spec1_sz(1), 1);
               repmat("HMG-1", spec2_sz(1), 1);
               repmat("HMG-1 Dry", spec3_sz(1), 1)];

%groupLabelsCell = repelem({'Control A','Control B','Control C','Experimental'}, samplesPerGroup);
% Convert to a categorical array (optional but often convenient):
groupLabels = categorical(groupLabels);

%----------------------------------------------------------------------
% 2. Perform PCA
%    - 'score' are the principal component scores (900 x 1024).
%    - 'coeff' are the principal component loadings (1024 x 1024).
%    - 'explained' are the variance percentages for each component, etc.
%----------------------------------------------------------------------
[coeff, score, latent, tsquared, explained] = pca(X);

%----------------------------------------------------------------------
% 3. Plot the first two principal components, with points colored
%    according to their respective group labels
%----------------------------------------------------------------------
figure;
gscatter(score(:,1), score(:,2), groupLabels);

xlabel(sprintf('PC1 (%.1f%%)', explained(1)));
ylabel(sprintf('PC2 (%.1f%%)', explained(2)));
title("PCA Score Plot of 3 Spectral Groups");
legend('Location','best');
grid on;