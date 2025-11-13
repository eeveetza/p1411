function L = tl_p1411_belowroof(f, d, type, variations)
%pl_1411_belowroof: path loss according to P.1411-11 §4.1.1
%   L = tl_p1411_belowroof(f, d, type, variations)
%
%   This function computes the path loss as defined in ITU-R P.1411-13
%   (Section 4.1.1: Site-general model for propagation within street canyons)
%   where both the Tx and Rx stations are located below-rooftop,
%   regardless of their antenna heights
%
%     Input parameters:
%     f       -   Frequency (GHz): 0.45 - 300
%     d       -   3D direct distance between the Tx and Rx stations (m)
%     type    -   Environment type, according to Table 4:
%                 1 - Urban high-rise, Urban low-rise/Suburban, LoS
%                     0.45 <= f <= 82, 5 <= d <= 660
%                     82 < f <= 159,  5 <= d <= 500
%                     159 < f <= 255, 5 <= d <= 250
%                     255 < f <= 300, 5 <= d <= 155
%                 2 - Urban high-rise, NLoS
%                     0.8 <= f <= 82, 20 < d < 715
%                     82 < f <= 159,  20 <= d <= 150
%                 3 - Urban low-rise/Suburban, NLOS
%                     0.45 <= f <= 73, 10 <= d <= 250
%                     73 < f <= 159,  10 <= d <= 150
%                     159 < f <= 255, 10 <= d <= 80
%                 4 - Residential
%                     0.8 <= f <= 73, 30 < d < 170
%    variations - when set to true,


%     Output parameters:
%     L     -   Path loss not exceeded for p% according to P.1411-13 §4.1.1
%
%     Example:
%     L = tl_p1411_belowroof(f, d, type, variations)


%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    02MAY17     Ivica Stevanovic, OFCOM         Initial version
%     v1    05NOV19     Ivica Stevanovic, OFCOM         Aligned with P.1411-10
%     v2    28NOV22     Ivica Stevanovic, OFCOM         aligned with P.1411-11 (upper frequency limit)
%     v3    09OCT25     Ivica Stevanovic, OFCOM         aligned with P.1411-13


% Checking passed parameter to the defined limits


switch type
    case 1
        if f < 0.45 || f > 300
            warning('Frequency is outside the valid domain [0.45, 300] GHz');
        end
        if (f >= 0.45 && f <= 82)
            if (d < 5 || d > 660)
                warning('3D distance between Tx and Rx is outside the valid domain [5, 660] m for frequency range [0.45, 82] GHz');
            end

        elseif (f > 82 && f <= 159)
            if (d < 5 || d > 500)
                warning('3D distance between Tx and Rx is outside the valid domain [5, 500] m for frequency range (82, 159] GHz');
            end

        elseif (f > 159 && f <= 255)
            if (d < 5 || d > 250)
                warning('3D distance between Tx and Rx is outside the valid domain [5, 250] m for frequency range (159, 255] GHz');
            end

        elseif (f > 255 && f <= 300)
            if (d < 5 || d > 155)
                warning('3D distance between Tx and Rx is outside the valid domain [5, 155] m for frequency range (255, 300] GHz');
            end
        end
        
        alpha = 2.07;
        beta = 31.23;
        gamma = 2.06;
        sigma = 4.91;
        
    case 2
        if f < 0.8 || f > 159
            warning('Frequency is outside of the valid domain [0.8, 159] GHz');
        end
        if (f >= 0.8 && f <= 82)
            if (d < 20 || d > 715)
                warning('3D distance between Tx and Rx is outside the valid domain [20, 715] m for frequency range [0.8, 82] GHz');
            end
        elseif (f >= 82 && f <= 159)
            if (d < 20 || d > 150)
                warning('3D distance between Tx and Rx is outside the valid domain [20, 150] m for frequency range (82, 159] GHz');
            end
        end
            
        
        alpha = 3.73;
        beta = 16.02;
        gamma = 2.26;
        sigma = 7.62;
        
    case 3
        if f < 0.45 || f > 255
            warning('Frequency is outside of the valid domain [0.45, 255] GHz');
        end
        if (f >= 0.45 && f <= 73)
            if (d < 10 || d > 250)
                warning('3D distance between Tx and Rx is outside the valid domain [10, 250] m for frequency range [0.45, 73] GHz');
            end

        elseif (f > 73 && f <= 159)
            if (d < 10 || d > 150)
                warning('3D distance between Tx and Rx is outside the valid domain [10, 150] m for frequency range (73, 159] GHz');
            end

        elseif (f > 159 && f <= 255)
            if (d < 10 || d > 80)
                warning('3D distance between Tx and Rx is outside the valid domain [10, 80] m for frequency range (159, 255] GHz');
            end
        end

        
        alpha = 4.52;
        beta =  6.04;
        gamma = 2.14;
        sigma = 8.02;
        
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


