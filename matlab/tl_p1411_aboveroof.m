function L = tl_p1411_aboveroof(f, d, type, variations)
%tl_p1411_aboveroof: path loss according to P.1411-8 §4.2.1
%   L = tl_p1411_aboveroof(f, d, type, variations)
%
%   This function computes the path loss as defined in ITU-R P.1411-11 
%   (Section 4.2.1: Site-general model) 
%   where one of the stations is located above-rooftop and the other station
%   is located below-rooftop, regardless of their antenna heights
%
%     Input parameters:
%     f       -   Frequency (GHz): 2.2 - 73
%     d       -   3D direct distance between the Tx and Rx stations (m)
%     type    -   Environment type, according to Table 8:
%                 1 - Urban high-rise, Urban low-rise/Suburban, LoS
%                     2.2 <= f <= 73, 55 < d < 1200
%                 2 - Urban high-rise, NLoS
%                     2.2 <= f <= 66.5, 360 < d < 1200
%     variations -  computed if set to true

%
%     Output parameters:
%     L     -   Path loss not exceeded for p% according to P.1411-11 §4.2.1
%
%     Example:
%     L = tl_p1411_aboveroof(f, d, type, variations)


%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    02MAY17     Ivica Stevanovic, OFCOM         Initial version


% Checking passed parameter to the defined limits

   

switch type
    case 1
        if f < 2.2 || f > 73
           warning('Frequency is outside the valid domain [2.2, 73] GHz'); 
        end
        if d < 55 || d > 1200
           warning('3D distance between Tx and Rx is outside the valid domain [55, 1200] m'); 
        end
        
        alpha = 2.29;
        beta = 28.6;
        gamma = 1.96;
        sigma = 3.48;
        
    case 2
        if f < 2.2 || f > 66.5
           warning('Frequency is outside the valid domain [2.2, 66.5] GHz'); 
        end
        if d < 260 || d > 1200
           warning('3D distance between Tx and Rx is outside the valid domain [260, 1200] m'); 
        end
        
        alpha = 4.39;
        beta = -6.27;
        gamma = 2.30;
        sigma = 6.89;

          
    otherwise
        error('Wrong value in the envionmental variable type.');
        

end

L = 10*alpha*log10(d) + beta + 10*gamma*log10(f);

if (variations)
     L = L + sigma*randn(1);
end

return
end
    


