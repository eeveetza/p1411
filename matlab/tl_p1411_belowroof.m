function L = tl_p1411_belowroof(f, d, type, variations)
%pl_1411_belowroof: path loss according to P.1411-11 §4.1.1
%   L = tl_p1411_belowroof(f, d, type, variations)
%
%   This function computes the path loss as defined in ITU-R P.1411-11
%   (Section 4.1.1: Site-general model for propagation within street canyons)
%   where both the Tx and Rx stations are located below-rooftop,
%   regardless of their antenna heights
%
%     Input parameters:
%     f       -   Frequency (GHz): 0.8 - 82
%     d       -   3D direct distance between the Tx and Rx stations (m)
%     type    -   Environment type, according to Table 4:
%                 1 - Urban high-rise, Urban low-rise/Suburban, LoS
%                     0.8 <= f <= 82, 5 < d < 660
%                 2 - Urban high-rise, NLoS
%                     0.8 <= f <= 82, 30 < d < 715
%                 3 - Urban low-rise/Suburban, NLOS
%                     10 <= f <= 73, 30 < d < 250
%                 4 - Residential
%                     0.8 <= f <= 73, 30 < d < 170
%    variations - when set to true,


%     Output parameters:
%     L     -   Path loss not exceeded for p% according to P.1411-11 §4.1.1
%
%     Example:
%     L = tl_p1411_belowroof(f, d, type, variations)


%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    02MAY17     Ivica Stevanovic, OFCOM         Initial version
%     v1    05NOV19     Ivica Stevanovic, OFCOM         Aligned with P.1411-10
%     v2    28NOV22     Ivica Stevanovic, OFCOM         aligned with P.1411-11 (upper frequency limit)


% Checking passed parameter to the defined limits


switch type
    case 1
        if f < 0.8 || f > 82
            warning('Frequency is outside of the valid domain [0.8, 73] GHz');
        end
        if d < 5 || d > 660
            warning('3D distance between Tx and Rx is outside the valid domain [5, 660] m');
        end
        
        alpha = 2.12;
        beta = 29.2;
        gamma = 2.11;
        sigma = 5.06;
        
    case 2
        if f < 0.8 || f > 82
            warning('Frequency is outside of the valid domain [0.8, 38] GHz');
        end
        if d < 30 || d > 715
            warning('3D distance between Tx and Rx is outside the valid domain [30, 715] m');
        end
        
        alpha = 4.00;
        beta = 10.2;
        gamma = 2.36;
        sigma = 7.6;
        
    case 3
        if f < 10 || f > 73
            warning('Frequency is outside the valid domain [10, 73] GHz');
        end
        if d < 30 || d > 250
            warning('3D distance between Tx and Rx is outside the valid domain [30, 250] m');
        end
        
        alpha = 5.06;
        beta = -4.68;
        gamma = 2.02;
        sigma = 9.33;
        
    case 4
        if f < 0.8 || f > 73
            warning('Frequency is outside the valid domain [0.8, 73] GHz');
        end
        if d < 30 || d > 170
            warning('3D distance between Tx and Rx is outside the valid domain [30, 170] m');
        end
        
        alpha = 3.01;
        beta =  18.8;
        gamma = 2.07;
        sigma = 3.07;
        
        
    otherwise
        error('Wrong value in the envionmental variable type.');
        
        
end


L = 10*alpha*log10(d) + beta + 10*gamma*log10(f) ;


if (variations)
    if (type == 2 || type == 3)
        % add standard deviation with capping so that the excess path loss is never negative
        % for NLOS Urban high-rise or NLOS Urban low-rise and Suburban
        
        Lfs = 20*log10(4*pi*f*1e9/3e8)+20*log10(d);
        
        mu = L - Lfs;
        
        A = mu + sigma*randn(1);
        
        L = 10.0 * log10(10.^(0.1*A) + 1.0) + Lfs;
    else
        L = L + sigma*randn(1);
        
    end
    
   
end

return
end


