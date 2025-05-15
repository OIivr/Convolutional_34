% Decoding func
function decoded_message = SW_decoder(input, n, H, W)
    window_size = W*n;
    y_padded = [zeros(1, 8), input];
    % Loop over the blocks, processing each window
    for i = 1:n:length(y_padded) - window_size + 1
        y_W = y_padded(i:i+window_size-1);
    
        % Find known positions (indices where y_W is not NaN)
        erased_indices = isnan(y_W);
        num_unknowns = sum(erased_indices);
        if num_unknowns == 0
            continue
        end
        
        known_indices = ~erased_indices;
        
        y_known = y_W(known_indices);   % Known values of y_W
        H_known = H(:, known_indices);  % Submatrix of H corresponding to known values
        
        s = mod(H_known * y_known', 2);
        H_submatrix = H(:, erased_indices);
        if rank (H_submatrix) >= num_unknowns 
        
            % Solve the system H_submatrix * z = s for z
            z_real = H_submatrix \ s;
            z = mod(round(z_real), 2);
    
            % Insert the decoded values back into the erased positions
            decoded_y_W = y_W;
            decoded_y_W(erased_indices) = z;
    
            % Now update the padded y sequence with the corrected values
            y_padded(i:i + window_size - 1) = decoded_y_W;
        end
    end
    
    decoded_msg = []; % List changes size every loop (not optimal, probably should preallocate)
    y_padded = y_padded(9:end);
    for i = 1:n:length(y_padded) - n + 1
        block = y_padded(i:i + n - 1);
        decoded_msg = [decoded_msg, block(1:3)];  % Take only the first 3 bits
    end
    decoded_message = decoded_msg;
end