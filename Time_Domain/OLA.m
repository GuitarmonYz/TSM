function [y] = OLA(x, N, TSM)
%OLA Summary of this function goes here
%User Parameters
alpha = 1/TSM;
wn = 0.5*(1 - cos(2*pi*(0:N-1)'/(N-1))); %hanning window
Ss = N/4;               %Synthesis hop
%Setup
Output_length = ceil(alpha*length(x));
sPosWin = 1:Ss:Output_length+N/2;     %array of synthesis positions
aPosWin = round(interp1([1 Output_length],[1 size(x,1)],sPosWin,'linear','extrap'));
Sa = [0 aPosWin(2:end)-aPosWin(1:end-1)];
%WSOLA
y = zeros(Output_length, 1);
minFac = min(Ss./Sa);
xC = [zeros(N/2,1) ; x; zeros(ceil(1/minFac)*N,1)];
yC = zeros(Output_length + 2*N, 1);
% ow = zeros(Output_length + 2*N, 1);
for n = 1:length(aPosWin)-1
    curr_syn_win_range = sPosWin(n):sPosWin(n) + N-1;
    curr_ana_win_range = aPosWin(n):aPosWin(n)+N-1;
    %OLA
    yC(curr_syn_win_range) = yC(curr_syn_win_range)+xC(curr_ana_win_range).*wn;
%     ow(curr_syn_win_range) = ow(curr_syn_win_range)+wn;
end
%Process the last frame
yC(sPosWin(end):sPosWin(end)+N-1) = yC(sPosWin(end):sPosWin(end)+N-1) + xC(aPosWin(n):aPosWin(n)+N-1).*wn;
% ow(sPosWin(end):sPosWin(end)+N-1) = ow(sPosWin(end):sPosWin(end)+N-1) + wn;
%Normalise the output
% ow(ow<10^-3) = 1; % avoid potential division by zero
% yC = yC./ow;
%Remove zero padding
y = yC(N/2+1:length(y)+N/2);
% y = y(N+1:end)/max(abs(y));
end

