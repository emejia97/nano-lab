clear; clc; close all;

RGB = orderedcolors("gem"); % default plot colors

pts = 12; % font size
lw = 2; % line width

TiO2_nk = readmatrix("TiO2_ALD_06172025.xlsx");

lambda = TiO2_nk(:,1);
n = TiO2_nk(:,2);
k = TiO2_nk(:,3);

figure
yyaxis left;
plot(lambda, n, "Color", RGB(1,:), "LineWidth", lw)
ylabel("n")

yyaxis right;
plot(lambda, k, "Color", RGB(2,:), "LineWidth", lw)
ylabel("k")

legend("n", "k")

xlabel("Wavelength (nm)")

fontsize(pts,"points")

exportgraphics(gca, 'TiO2_nk.eps', 'ContentType', 'vector'); % Save as EPS
exportgraphics(gca, 'TiO2_nk.png'); % Save as PNG

% metadata

include_surface_roughness = true;
roughness = 0.0;

Einf = 1.435;
UV_pole_amp = 152.0684;
UV_pole_en = 13.678;
IR_pole_amp = -0.2860;

type = "Cody-Lorentz";
amp1 = 70.696;
Br1 = 44.111;
Eo1 = 3.224;
Eg1 = 2.458;
Ep1 = 1.859;
Et1 = 0.348;
Eu1 = 0.208;
Common_Eg = "off";

angle_offset = 0;

psi = [65, 70, 75]; % unitless, unitless, degree
delta = [65, 70, 75]; % unitless, unitless, degree

