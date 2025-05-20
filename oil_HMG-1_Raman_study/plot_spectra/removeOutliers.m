function [cleaned_spec, newSize] = removeOutliers(spec, numTrees, ContaminationFraction, nIter, showPCA)
%removeOutliers -- Summary --
%   
%   
%   
%
%

working_spec = spec;

for i = 1:nIter    
    [nSamples, nFeatures] = size(working_spec);
    
    % Create the Isolation Forest model
    [~, tf] = iforest(working_spec, 'NumLearners', numTrees, 'ContaminationFraction', ContaminationFraction); % Adjust contamination as needed
    
    % Remove outliers
    cleaned_spec = working_spec(~tf, :);
    newSize = size(cleaned_spec);
    
    if showPCA
        % Visualize with PCA
        [coeff, score] = pca(working_spec);
        figure;
        gscatter(score(:,1), score(:,2), tf);
        xlabel('PC 1');
        ylabel('PC 2');
        title('PCA of Spectral Data with Outlier Detection');
        legend('Inliers', 'Outliers');
    end

    working_spec = cleaned_spec;

end


end