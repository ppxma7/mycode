function varargout = spm_prf_fcn_gaussian_somato(P,M,U,varargin)
% spm_prf_fcn_gaussian_somato - 2D Gaussian pRF response function for somatosensory data.
%
% This function models the neuronal response as a 2D Gaussian over a somatosensory 
% surface. The predicted neural response at each time point is given by:
%
%    z(t) = beta * sum( exp(-((x - P.x).^2 + (y - P.y).^2) / (2*P.width^2)) )
%
% where the sum is taken over all stimulus locations active at time t.
%
% Inputs:
%   P - parameter structure with fields:
%         P.x     - horizontal coordinate of the pRF center
%         P.y     - vertical coordinate of the pRF center
%         P.width - standard deviation (spread) of the pRF
%         P.beta  - scaling factor (gain)
%
%   M - model structure (e.g., containing M.dt, the microtime bin length)
%
%   U - stimulus input structure array, one element per TR volume. Each U(t)
%       should contain:
%         U(t).x   - vector of x coordinates of stimulated locations (if any)
%         U(t).y   - vector of y coordinates of stimulated locations (if any)
%         U(t).ind - indices into the microtime bins for the current TR.
%         U(t).nbins - total number of microtime bins (injected by spm_prf_analyse)
%
%   varargin - optional action string and additional arguments.
%
% Without extra arguments, the function returns the predicted BOLD response y
% (after integration) and the intermediate neural response Z.
%
% Examples:
%   [y,Z] = spm_prf_fcn_gaussian_somato(P,M,U);
%   S = spm_prf_fcn_gaussian_somato(P,M,U,'get_summary');
%
% See spm_prf_analyse for details.
%
% -------------------------------------------------------------------------
% Copyright (C) <Year> Your Name
%
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation.
% -------------------------------------------------------------------------

if nargin < 4
    %%% --- Compute the predicted timeseries ---
    n = length(U); 
    % Initialize neural response vector over microtime bins.
    z = zeros(1, U(1).nbins);
    
    % Loop over each TR volume (time point)
    for t = 1:n
        % Get microtime indices for this TR
        ind = U(t).ind;  
        
        % Check if a stimulus was presented at time t by looking for x and y fields.
        if isfield(U(t), 'x') && isfield(U(t), 'y') && ~isempty(U(t).x)
            % Make sure the stimulus coordinates are column vectors.
            stim_x = U(t).x(:);
            stim_y = U(t).y(:);
            
            % Compute squared Euclidean distance from the pRF center.
            d2 = (stim_x - P.x).^2 + (stim_y - P.y).^2;
            
            % Calculate the Gaussian response at each stimulated location.
            prf_response = exp(-d2 / (2 * P.width^2));
            
            % Sum the responses from all stimulated locations and scale by beta.
            z(ind) = P.beta * sum(prf_response);
        end
    end
    
    % Integrate the neural response using the BOLD model.
    Z.u = z';
    Z.dt = M.dt;
    y = spm_int(P, M, Z);
    
    varargout{1} = y;
    varargout{2} = Z;
else
    %%% --- Additional actions for information and initialization ---
    action = varargin{1};
    switch action
        case 'get_parameters'
            % Return parameters for display.
            varargout{1} = P;
        case 'get_summary'
            % Return a summary of the pRF parameters.
            varargout{1} = struct('x', P.x, 'y', P.y, 'width', P.width, 'beta', P.beta);
        case 'is_above_threshold'
            % For display purposes, return a logical vector (here, always 1).
            varargout{1} = 1;
        case 'get_response'
            % Return the instantaneous response at specified coordinates.
            % varargin{2} should be a [2 x n] matrix of coordinates.
            xy = varargin{2};
            d2 = (xy(1,:) - P.x).^2 + (xy(2,:) - P.y).^2;
            varargout{1} = P.beta * exp(-d2 / (2 * P.width^2));
        case 'get_priors'
            % Define priors for the parameters. Adjust these as appropriate.
            pE.x     = 0;
            pE.y     = 0;
            pE.width = 1;
            pE.beta  = 1;
            
            pC.x     = 1;
            pC.y     = 1;
            pC.width = 1;
            pC.beta  = 1;
            
            varargout{1} = pE;
            varargout{2} = pC;
        case 'glm_initialize'
            % Optionally, initialize parameters using a quick estimation.
            y = varargin{2};
            varargout{1} = P;  % For now, simply return the existing parameters.
        otherwise
            error('Unknown action');
    end
end
