function [transient_block_values, idxs] = TransientDetection(x, block_size, hop_size)
time_block = myBlocking(x, block_size, hop_size);
freq_block = fft(time_block .* hann(block_size));
num_block = size(freq_block, 2);
idxs = (1 : num_block) * hop_size - hop_size + 1 + block_size / 2;
transient_block_values = zeros(num_block, 1);
spectrum_m_2 = freq_block(:, 1);
spectrum_m_1 = freq_block(:, 2);
H = zeros(7, 1);
c = 1.5;
Thresh_E = 0.4;
bark_cutoffs = bark_bands(block_size, 44100);
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
end

