% decoder func
function decoded = peeling_decoder (H, c)
    decoded = c;
    [m, n] = size(H);

    % Loop until no more updates
    while true
        updated = false;

        for i = 1:m
            involved_vars = find(H(i, :) == 1);
            values = decoded(involved_vars);
            num_unknown = sum(isnan(values));
            if num_unknown == 1
                idx_unknown = involved_vars(isnan(values));

                known_values = values(~isnan(values));
                parity_sum = mod(sum(known_values), 2);

                decoded(idx_unknown) = mod(-parity_sum, 2);
                updated = true;
            end
        end

        if ~updated
            break;
        end
    end
    decoded_blocks = reshape(decoded, 4, []).';
    message_blocks = decoded_blocks(:, 1:3);
    decoded = reshape(message_blocks.', 1, []);
end