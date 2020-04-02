function [gamma] = stationary_measure(spectrum_m, spectrum_m_1, spectrum_m_2)

phase_m_1 = angle(spectrum_m_1);
phase_m_2 = angle(spectrum_m_2);
phase_bar = princarg(2 * phase_m_1 - phase_m_2);
mag_bar = abs(spectrum_m_1);

spectrum_bar = mag_bar .* complex(cos(phase_bar), sin(phase_bar));
gamma = sum(norm(spectrum_m - spectrum_bar));
end

