function data_stats = calcStats2(data, Ns, varargin)
%calcStats -- Summary --
%   This function takes averaged spatial Raman data and computes a single
%   average value at each time point. The median, standard deviation, 
%   T-interval, and 95% confidence interval are also computed. 
%
% Inputs:
%   data = averaged spatial ERS or R6G data
%   Ns = number of samples within each spatial measurements (total number
%        of pixels)
%
% Outputs:
%   data_avg = averaged data over time
%   data_med = median data over time
%   data_ti = T-interval of the data over time
%   data_CI = 95% confidence interval of the data over time
%

if nargin > 2
    [varargin{:}] = convertStringsToChars(varargin{:});
end

% Default
alpha = 0.05;

if nargin >= 3
    if isnumeric(varargin{1})
        alpha = varargin{1};
    elseif isstring(varargin{1}) || ischar(varargin{1})
        data = normalize(data, varargin{1});
    end
end

if nargin == 4
    if isstring(varargin{1}) || ischar(varargin{1})
        data = normalize(data, varargin{2});
    end
end

data_stats = [mean(data), median(data), mode(data), std(data)];

data_avg = data_stats(:,1);
data_med = data_stats(:,2);
data_std = data_stats(:,4);

UB = 1 - alpha/2; % t-distribution upper bound
LB = 1 - UB;      % t-distribution lower bound

data_SEM = data_std / sqrt(Ns); % Standard Error
dof = Ns - 1;                   % degrees of freedom
%data_ts = tinv([0.025 0.975],dof); % T-Score (95% confidence interval)
%data_ts = tinv([0.005 0.995],dof); % T-Score (99% confidence interval)
data_ts = tinv([LB UB],dof); % T-Score (variable % confidence interval)
data_ti = data_ts.*data_SEM;    % T-Intervals
data_CI = data_avg + data_ti;   % Confidence Intervals

data_stats = [data_avg, data_med, data_std, data_ti, data_CI];

end