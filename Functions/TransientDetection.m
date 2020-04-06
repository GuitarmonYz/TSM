function idxs_se = TransientDetection(x, block_size, hop_size)
time_block = myBlocking(x, block_size, hop_size);
freq_block = fft(time_block .* hann(block_size));
num_block = size(freq_block, 2);
transient_block_values = zeros(num_block, 1);
spectrum_m_2 = freq_block(:, 1);
spectrum_m_1 = freq_block(:, 2);
H = zeros(7, 1);
c = 1.5;
Thresh_E = 0.4;
bark_cutoffs = bark_bands(block_size, 44100);
bark_cutoffs(1) = 1;
for i = 3 : num_block
    % detect transient based on phase
    spectrum_m = freq_block(:, i);
    gamma = stationary_measure(spectrum_m, spectrum_m_1, spectrum_m_2);
    H(mod(i, 7)+1) = gamma;
    gamma_m = gamma / max(H);
    delta_m = median(H(H~=0) / max(H)) * c;
%     if gamma_m >= delta_m
%         transient_block_values(i) = 1;
%     end
    % detect transient based on energy
    band_count = 0;
    for j = 1 : length(bark_cutoffs)-1
        E_m = sum(abs(spectrum_m(bark_cutoffs(j):bark_cutoffs(j+1))).^2);
        E_m_1 = sum(abs(spectrum_m_1(bark_cutoffs(j):bark_cutoffs(j+1))).^2);
        delta_e = (E_m - E_m_1) / E_m;
        if (delta_e > Thresh_E)
            band_count = band_count + 1;
        end
    end
    
    if band_count >= 5 && gamma_m >= delta_m
        transient_block_values(i) = 1;
    end
    
    % update buffer
    spectrum_m_2 = spectrum_m_1;
    spectrum_m_1 = spectrum_m;
end
transient_idxs = find(transient_block_values == 1);
start = transient_idxs(1);
transient_se_idxs = [];
for i = 2 : length(transient_idxs)
    if (transient_idxs(i) ~= transient_idxs(i-1) + 1)
        end_ = transient_idxs(i-1);
        transient_se_idxs = [transient_se_idxs; [start, end_, 1]];
        start = transient_idxs(i);
    end
end
idxs_se = [];
start = 1;
for i = 1 : size(transient_se_idxs, 1)
    idxs_se = [idxs_se; [start, transient_se_idxs(i, 1)-1, 0]; transient_se_idxs(i,:)];
    start = transient_se_idxs(i, 2) + 1;
end
idxs_se = [idxs_se; [transient_se_idxs(size(transient_se_idxs, 1), 2) + 1, num_block, 0]];
idxs_se(:, 1:2) = idxs_se(:, 1:2) * hop_size;
idxs_se(1:2:end, 1) = idxs_se(1:2:end, 1) + block_size - hop_size + 1;
idxs_se(1:2:end, 2) = idxs_se(1:2:end, 2) + hop_size + block_size/2;
idxs_se(2:2:end, 1) = idxs_se(2:2:end, 1) + block_size/2 + 1;
idxs_se(2:2:end, 2) = idxs_se(2:2:end, 2) + block_size;
idxs_se(1, 1) = 1;
idxs_se(end, 2) = length(x);
end

