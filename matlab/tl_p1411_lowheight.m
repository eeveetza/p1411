function L = tl_p1411_lowheight(fMHz, dm, type, p, varargin)
%tl_p1411_lowheight: path loss according to P.1411-9 §4.3.1
%   L = tl_p1411_lowheight(fMHz, dm, type, p)
%   L = tl_p1411_lowheight(fMHz, dm, type, p, w)
%
%   This function computes the path loss as defined in ITU-R P.1411-11 
%   (Section 4.3.1: Site-general model) not exceeded for probability p,
%   between two terminals of low hight from below roof-top to near street
%   level (1.9 m < h < 3 m).
%
%     Input parameters:
%     fMHz    -   Frequency (MHz): 300 - 3000
%     dm      -   3D direct distance between the Tx and Rx stations (m)
%     type    -   Environment type:
%                 1 - suburban
%                 2 - urban
%                 3 - dense urban/high-rise
%     p       -   location percentage (%): 0 - 100 
%     w       -   transition region between LoS and NLoS (m)
%
%     Output parameters:
%     L     -   Path loss not exceeded for p% according to P.1411-11 §4.3.1
%
%     Example:
%     L = tl_p1411_aboveroof(fGHz, dm, type, p)


%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    11JAN18     Ivica Stevanovic, OFCOM         Initial version

% the width w is introduced to provide a transition region between the LoS
% and NLoS regions with a typical value of w = 20 m.

w = 20;

if nargin >=5
    w=varargin{1};
end

% Checking passed parameter to the defined limits

if p <= 0 || p >= 100
    error('Location percentage is outside of the valid domain (0, 100) %%'); 
end    

Lurban = 0;

switch type
    case 1
        Lurban = 0;        
    case 2
        Lurban = 6.8;
    case 3
        Lurban = 2.3;
    otherwise
        error('Wrong value in the envionmental variable type.');
       
end

if fMHz < 300 || fMHz > 3000
    warning('Frequency is outside of the valid domain [300, 3000] MHz'); 
end  

% Step 1: Calculate the median value of the line-of-sight loss (Eq 58)

LLoSMedian = 32.45 + 20*log10(fMHz) + 20*log10(dm/1000);

% Step 2: For the required location percentage, calulate the LoS location
% correction (Eq 59)

sigma = 7;
DeltaLLoS = 1.5624*sigma * (sqrt(-2*log(1-p/100))-1.1774);

% Step 3: Add the LoS location correction to the median value of LoS loss
% (Eq. 60);

LLoS = LLoSMedian + DeltaLLoS;

% Step 4: Calculate the median value of the NLos loss (Eq. 61)

LNLoSMedian = 9.5 + 45*log10(fMHz)+40*log10(dm/1000) + Lurban;

% Step 5: For the required location percentage p (%) add the NLoS location
% correction (Eq. 62)

DeltaLNLoS = norminv(p/100, 0, sigma);

% Add the NLoS location correction to the median value of NLoS loss (Eq.
% 63)

LNLoS = LNLoSMedian + DeltaLNLoS;

% Step 7: For the required location pecentage calculate the distance dLos
% for which the LoS fraction FLoS equals p (Eq. 64)

if p < 45
    dLoS = 212*(log10(p/100)).^2 - 64*log10(p/100);
else
    dLoS = 79.2 - 70*(p/100);
end

% Step 8: Calculate the pathloss

if (dm < dLoS)
    
    L = LLoS;

elseif (dm > dLoS + w)
    
    L = LNLoS;
    
else
    
    % Step 1: Calculate the median value of the line-of-sight loss (Eq 58)

    LLoSMedian = 32.45 + 20*log10(fMHz) + 20*log10(dLoS/1000);

    % Step 3: Add the LoS location correction to the median value of LoS loss
    % (Eq. 60);

    LLoS = LLoSMedian + DeltaLLoS;
    
    % Step 4: Calculate the median value of the NLos loss (Eq. 61)

    LNLoSMedian = 9.5 + 45*log10(fMHz)+40*log10((dLoS + w)/1000) + Lurban;

    % Add the NLoS location correction to the median value of NLoS loss (Eq.
    % 63)

    LNLoS = LNLoSMedian + DeltaLNLoS;
    
    L = LLoS + (LNLoS - LLoS)*(dm - dLoS)/w;
    
end

return
end
    


