function [y] = WSOLA_Trans(x, TSM)
%WSOLA_TRANS Summary of this function goes here
%   Detailed explanation goes here

idxs_se = TransientDetection(x, 512, 512/4);
y = [];
for i = 1 : length(idxs_se)
    
    if idxs_se(i, 3) == 1
       y_tmp = OLA(x(idxs_se(i, 1):idxs_se(i, 2)), 256, TSM); 
%        y_tmp = x(idxs_se(i, 1):idxs_se(i, 2));
    else
       y_tmp = WSOLA_Driedger(x(idxs_se(i, 1):idxs_se(i, 2)), 2048, TSM);
    end
    y = [y; y_tmp];
end
y = y/max(abs(y));