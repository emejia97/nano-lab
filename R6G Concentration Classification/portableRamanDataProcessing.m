clc; clear; close all;

path = "D:\research\Zhou MDE Raman Impedance Cow\R6G Concentration Classification\portable Raman data\";

filenames = ["R6G_E1s.csv", "R6G_E5s.csv", "R6G_E10s.csv"];
filenames_dk = ["DK_E1s.csv", "DK_E5s.csv", "DK_E10s.csv"];

i = 1;
data = readmatrix(path + filenames(i));
data_dk = readmatrix(path + filenames_dk(i));

wavenums = data(:, 1);
I_raw = data(:, 2);
I_dk = data_dk(:, 2);

I_sub = I_raw - I_dk;

I_backadj = msbackadj(wavenums,I_sub,'ShowPlot',true);

figure
plot(wavenums, I_backadj)
xlabel("Wavenumber (rel. cm^{-1})")
ylabel("Intensity")

xlim([500, 2000]);

