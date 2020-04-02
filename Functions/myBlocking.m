function xmat = myBlocking(x, block_size, hop_size) 
[len, ~] = size(x); % if necessary, update the length of x after zero padding
num_blocks = ceil((len - block_size) / hop_size) + 1;

% zero padding
x = [x;zeros(hop_size - mod(len - block_size, hop_size) ,1)];

% initialization
xmat = zeros(block_size, num_blocks); % the matrix for block storation

for i = 0 : num_blocks - 1
    
    % compute the start index and end index for current block
    start_index = i * hop_size + 1;
    end_index = start_index + block_size - 1;
    
    % fill in the corresponding column of the matrix with current block
    xmat(:,i + 1) = x(start_index : end_index);
end