function [bark_cutoffs] = bark_bands(fft_size, fs)
bark_bands_hz = [20, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, 2000, fs/2];
bark_cutoffs = round(bark_bands_hz * fft_size / fs);
end

