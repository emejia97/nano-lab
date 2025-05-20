function [wavenums, specs, Nm, ERS, HMB1] = calc_ERS_HMB1(fp, lambda_ex, t)
%calcERSR6G -- Summary --
%   This function takes raw and processed (adjusted) spatial Raman spectra 
% data and calculates the average ERS and R6G peak values over time. The R6G
% peaks that are used are 1183, 1310, & 1360 cm^-1. The R6G data is 
% ERS-calibrated to reduce the coefficient of variation of the spatial
% data.
%
% Inputs:
%   AdjFP = adjusted data filepath
%   RawFP = raw data filepath
%   t = time vector
%   lambda_ex = laser excitation wavelength
%
% Outputs:
%   Nm = number of measurements
%   Ns = number of samples within each spatial measurements (total number
%        of pixels)
%   ERS = minimum-subtracted ERS data
%   R6G = ERS-calibrated R6G data (I_R6G / I_ERS; I_R6G is from processed 
%         data)
%

Nm = length(fp); % # of measurements

sData(Nm).d = '';
sDataERS(Nm).d = '';

for i = 1:Nm

    fp_s = cell2mat(fp(i));

    %slash_idx = find(fp == '/');
    %sname = fp((slash_idx+1):end); % sample name

    L = load(fp_s + " (CRR) (SG) (Sub BG).mat");
    f = fieldnames(L);
    s = f{1};
    sData(i).d = getfield(L,s);

    L = load(fp_s + " (CRR) (SG).mat");
    f = fieldnames(L);
    s = f{1};
    sDataERS(i).d = getfield(L,s);

end

s1 = [sData(:).d];
s1ERS = [sDataERS(:).d];

specs = s1; % no ERS calibration

lambda_det = s1(1).axisscale{2,1}; %nm - detected wavelengths

wavenums = 1e7/lambda_ex - 1e7./lambda_det; % cm^-1 - wavenumbers


d11c0ERS = s1ERS(1).data(1,:);

ERS_index = find(d11c0ERS == max(d11c0ERS));

filter_size = 5;

ERS_index_range = (ERS_index - floor(filter_size/2)):(ERS_index + floor(filter_size/2));


for i = 1:Nm
    minRaw = min(s1ERS(i).data);
    ERS_sub = s1ERS(i).data - minRaw;

    figure
    plot(ERS_sub)

    ERS_avg = mean(ERS_sub(ERS_index_range));

    specs(i).data = specs(i).data ./ ERS_avg; % ERS calibration

    figure
    plot(specs(i).data)
end


HMB1_index1 = find(wavenums > 680 & wavenums < 685);
HMB1_index2 = find(wavenums > 833 & wavenums < 837);
HMB1_index3 = find(wavenums > 993 & wavenums < 997);
%HMB1_index4 = find(wavenums > 1445 & wavenums < 1449);
%HMB1_index5 = find(wavenums > 1653 & wavenums < 1656);

filter_size = 5;

ERS_index_range = (ERS_index - floor(filter_size/2)):(ERS_index + floor(filter_size/2));

index_range1 = (HMB1_index1 - floor(filter_size/2)):(HMB1_index1 + floor(filter_size/2));
index_range2 = (HMB1_index2 - floor(filter_size/2)):(HMB1_index2 + floor(filter_size/2));
index_range3 = (HMB1_index3 - floor(filter_size/2)):(HMB1_index3 + floor(filter_size/2));
%index_range4 = (HMB1_index4 - floor(filter_size/2)):(HMB1_index4 + floor(filter_size/2));
%index_range5 = (HMB1_index5 - floor(filter_size/2)):(HMB1_index5 + floor(filter_size/2));

ERS = zeros([Nm, 1]); % ERS measurements and samples for each measurement
HMB1 = zeros([Nm, 1]); % R6G measurements and samples for each measurement
% Row = measurement
% Col = samples for that measurement

for i = 1:Nm
    minRaw = min(s1ERS(i).data);

    ERS_sub = s1ERS(i).data(ERS_index_range) - minRaw;

    ERS(i) = mean(ERS_sub);

    % avg value within the wavenumber window
    HMB1_mean1 = mean(s1(i).data(index_range1)) ./ ERS(i); %
    HMB1_mean2 = mean(s1(i).data(index_range2)) ./ ERS(i); %
    HMB1_mean3 = mean(s1(i).data(index_range3)) ./ ERS(i); %
    %HMB1_mean4 = mean(s1(i).data(index_range4)) ./ ERS(i); %
    %HMB1_mean5 = mean(s1(i).data(index_range5)) ./ ERS(i); %

    %avg value of the HMB-1 peaks
    HMB1(i) = mean([HMB1_mean1, HMB1_mean2, HMB1_mean3]);
end

end