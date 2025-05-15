% Encoding func
function encoded_message = conv_encoder_34(message, n, k, M, H0, H1, H2)
    % Number of input blocks
    Len = length(message) / k;
    
    % Add padding for memory
    message = [zeros(1, M * k), message];
    total_blocks = Len + M;
    
    encoded_message = zeros(1, total_blocks * n);
    
    % Encode
    for i = 1:total_blocks
        % Get current and previous blocks
        curr = get_block(message, i, k);
        prev1 = get_block(message, i-1, k);
        prev2 = get_block(message, i-2, k);
        
        parity = mod(H0*curr' + H1*prev1' + H2*prev2', 2);
        
        % store the starting index where each block will be placed
        write_pos = (i-1)*n + 1;
        encoded_message(write_pos:write_pos+n-1) = [curr, parity];
    end
    
    encoded_message = encoded_message(M*n + 1 : end);
end

% Helper function that returns the block at a specific index (or zeros if out of bounds)
function block = get_block(input, block_idx, block_len)
    if block_idx < 1
        block = zeros(1, block_len);
    else
        start = (block_idx - 1) * block_len + 1;
        block = input(start : start + block_len - 1);
    end
end