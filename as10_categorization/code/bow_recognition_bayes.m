function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

K = size(vBoWPos, 2); % number of visual words
p_car = 0;
p_nocar = 0;

% check probability for all visual words
for k=1:K
    % for positive
    if (sigmaPos(k) < 0.5)
        sigmaPos(k) = 0.5 ;
    end
    % log(P(visual work k in img | muPos(k), sigmaPos(k))
    log_k_pos = log(normpdf(histogram(k),muPos(k),sigmaPos(k)));
    p_car = p_car + log_k_pos;
    % for negative
    if (sigmaNeg(k) < 0.5)
        sigmaNeg(k) = 0.5 ;
    end
    % log(P(visual work k in img | muNeg(k), sigmaNeg(k))
    log_k_neg = log(normpdf(histogram(k),muNeg(k),sigmaNeg(k)));
    p_nocar = p_nocar + log_k_neg;
end

label = 0;

if p_car > p_nocar
    label = 1;
end

end