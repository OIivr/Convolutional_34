# Convolutional Coding over BEC (MATLAB)

This repo implements a convolutional (3,4) encoder and two decoding methods over the Binary Erasure Channel (BEC).

## Files

- `conv_encoder_34.m` — (3,4) convolutional encoder using generator matrices `H0`, `H1`, `H2` with memory `M=2`.
- `SW_decoder.m` — sliding window decoder that solves a linear system per window to recover erasures.
- `peeling_decoder.m` — iterative decoder for erasure recovery using a sparse parity-check matrix `H`.
- `conv_34_simulate.m` — runs FER/BER simulations over varying erasure probabilities (`p`) and plots FER.

## Simulation Setup

- Code rate: 3/4 (`k=3`, `n=4`)
- Erasure decoding tested for `p ∈ (0.001, 0.15)`
- 500 trials per erasure probability
- Outputs: FER and BER vs. `p` (only FER plotted)

## Notes

- Only BEC supported
- All parameters are hardcoded (no argument parsing)
- Matrix `H` is fixed and used in both decoders
