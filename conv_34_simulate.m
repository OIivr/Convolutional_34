clf;
% Code parameters
n = 4;
k = 3; % R = 3/4
M = 2;
L = 2;
W = L + M + 1;

H0 = [1 1 0];
H1 = [1 0 1];
H2 = [1 1 1];

H = [1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1;
     1 1 1 0 1 0 1 0 1 1 0 1 0 0 0 0 1 1 1 0 1 0 1 0 1 1 0 1 1 1 1 0 1 0 1 0 1 1 0 1];

% Simulation parameters
Num_trial = 500;
F=0;
B=0;
p=0;
for I=1:150
    disp(I);
    p=p+10^(-3);
    P(I)=p;
%p = 0.05; %0.95;
m_per_block = 10;


m=randi([0,1],1,k*m_per_block);
disp(m);

%%%%%%%%%Encoding%%%%%%%%%%%%
c = conv_encoder_34(m, n, k, M, H0, H1, H2); % encoder
len = length(c);

FER=0;
BER=0;
for trial=1:Num_trial
    if mod(trial, 100000) == 0
        disp('trial'); disp(trial);
    end

    %  Noising
    E = rand(1, len) < (1-p);
    r = c;
    pos=find(E==0);
    r(pos) = NaN;
    L = isnan(r);

    %%%%%%%%%%%%Decoding%%%%%%%%%%%
    decoded_out = peeling_decoder(H, r);  % Decoder

    erasure = sum(decoded_out ~= m);
    if erasure~=0
        FER=FER+1;
        BER=BER+erasure;
    end
end %trials

FER_percent = (FER / Num_trial); % * 100;
BER_percent = (BER / (Num_trial*m_per_block*k)); % * 100;

disp("FER (%):")
disp(FER_percent)
disp("BER (%):")
disp(BER_percent)
F(I)=FER_percent;
B(I)=BER_percent;
end
semilogy(P(1:150),F(1:150));
xlabel('probability p');
ylabel('FER');
grid on;
