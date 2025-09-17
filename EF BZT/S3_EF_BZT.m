clear; clc; close all;

%% neat BZT (no need to modify this)
rhob = 5.9*10^21; % density of neat BZT
deff = 26.385*10^-4; 
%deff = 2.74e-6; % effective depth of focal volume

Ir = 0.52; % neat BZT intensity

%units in cm (10^-2)
R = 50e-4; 

Ar = pi*R^2; % focused illumination area

Nr = Ar * deff * rhob; % number of BZT molecules contributing to neat Raman intensity 

%% SERS BZT

rhos = 6.8*10^14; % packing density of BZT on Au surfaced (constant)

% SA = metal surface area contributing to enhancement of Raman signal
% (MODIFY THIS IF SURFACE GEOMETRY CHANGES)
%units in cm (10^-2 m)
h = 300e-7; % height
r = 95e-7;  % radius
p = 400e-7; % periodicity (pitch)

SA = (pi*R^2)*(1+(2*pi*r*h)/p^2); % surface area for nanopillars

Ns = SA * rhos; % number of BZT molecules contributing to SERS intensity

%% File path definition & data loading (IMPORTANT NOTE: Constants are defined assuming 20x objective & 2mW power for SERS measurement)

S3_BZT = "../EF BZT";

% --- note that background subtracted & baseline corrected data is used ---
fname_BZT = "Single Spectrum_008_Spec.Data 2 (CRR) (Sub BG).mat";
%fname_BZT = "Single Spectrum_009_Spec.Data 2 (CRR) (Sub BG).mat";

lambda_ex = 784.800; %nm - excitation wavelength
filter_size = 3; % spectral window size
[wavenums, spectra, Is] = calcBZT(S3_BZT, fname_BZT, lambda_ex, filter_size); % 1065cm^-1 BZT peak

%Is is the SERS BZT intensity

figure(1)
plot(wavenums, spectra)
xlabel("Wavenumber (cm^{-1})")
ylabel("Intensity (counts)")
title("BZT SERS Raman Spectrum")


%{
h = histfit(spectra.*EF0,7);
h(1).FaceColor = [255/255 222/255 139/255];
%h(1).FaceAlpha = 0.4;
h(2).Color = [0 0 0];
%h(1).EdgeColor = 'none';
title 'Figure 2d: SERS EF Distribution'
xlabel 'SERS EF'
ylabel 'Count'
xlim([0.1e4 14.1e5])

%}

%% EF calculation
EF = (Is / Ir) * (Nr / Ns);

fprintf("EF = %0.003e \r\n", EF);


%% function definitions

function [wavenums, spectraBZT, I_BZT] = calcBZT(fp, fn_BZT, lambda_ex, filter_size)

    fp_BZT = fp + '/' + fn_BZT;

    s_BZT = get_struct_name(fn_BZT);

    L = load(fp_BZT);
    sData.d = getfield(L,s_BZT);

    s = [sData(:).d];
    
    lambda_det = s.axisscale{2,1}; %nm - detected wavelengths
    
    wavenums = 1e7/lambda_ex - 1e7./lambda_det; % cm^-1 - wavenumbers
    
    spectraBZT = s.data(1,:);
    
    BZT_index = find(wavenums > 1063 & wavenums < 1067); % 1065cm^-1 BZT peak

    BZT_index_range = (BZT_index - floor(filter_size/2)):(BZT_index + floor(filter_size/2));

    % avg value within the wavenumber window
    BZT_mean = mean(s.data(1, BZT_index_range));% / ERS;

    I_BZT = double(BZT_mean);

end

function struct_name = get_struct_name(filename)
    % Remove the file extension
    [~, name, ~] = fileparts(filename);
    
    % Replace spaces with underscores
    name = strrep(name, ' ', '_');
    
    % Remove parentheses and replace them with underscores
    name = regexprep(name, '\((.*?)\)', '_$1_');
    
    % Remove periods
    name = strrep(name, '.', '');
    
    % Remove any duplicate underscores
    name = regexprep(name, '_+', '_');
    
    % Remove leading/trailing underscores
    name = regexprep(name, '^_|_$', '');
    
    % Return the modified filename
    struct_name = name;
end