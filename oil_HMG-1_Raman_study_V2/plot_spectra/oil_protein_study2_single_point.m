clear; clc; close all;

path_S1_bare = 'S1 bare/bare NPA 10x';

path_S1_oil_10x = 'S1 oil 10x/NPA w oil 10x';
path_S1_oil_20x = 'S1 oil 20x/NPA w oil 20x';

path_S2_HMB1_10x = 'S2 HMB-1 10x/NPA w HMB-1';
path_S2_HMB1_10x_pos2 = 'S2 HMB-1 10x pos2/NPA w HMB-1 pos2';
path_S2_HMB1_10x_E30_pos2 = 'S2 HMB-1 10x pos2 E30/NPA w HMB-1 pos2 E30';

path_S2_HMB1_20x = 'S2 HMB-1 20x/NPA w HMB-1 20x';
path_S2_HMB1_20x_E30 = 'S2 HMB-1 20x E30/NPA w HMB-1 20x E30';

path_S2_HMB1_dried = 'S2 dried HMB-1/dried HMB-1';

paths = {path_S1_bare, path_S1_oil_10x, path_S1_oil_20x, path_S2_HMB1_10x, ...
         path_S2_HMB1_10x_pos2, path_S2_HMB1_10x_E30_pos2, path_S2_HMB1_20x, ...
         path_S2_HMB1_20x_E30, path_S2_HMB1_dried};

lambda_ex = 784.500; %nm - excitation wavelength

fp = [paths(1), paths(3)];
N = length(fp);

%specs = zeros(N,1);
%ERS = zeros(N,1);
%HMB1 = zeros(N,1);

[wavenums, specs, Nm, ERS, HMB1] = calc_ERS_HMB1(fp, lambda_ex);


figure
plot(wavenums, specs(1).data)
hold on
plot(wavenums, specs(2).data)
hold off

figure
plot(wavenums, specs(2).data - specs(1).data)


figure
bar(["Bare NPA", "HMB-1"], HMB1)