%
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
% Denys Rozumnyi, HS 2019
rng(1)
%training
all_pnn = [];
all_pbc = [];
for sizeCodebook = 20:40:420
    disp('creating codebook');
    vCenters = create_codebook('../data/cars-training-pos','../data/cars-training-neg',sizeCodebook);
    %keyboard;
    disp('processing positve training images');
    vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
    disp('processing negative training images');
    vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
    %vBoWPos_test = vBoWPos;
    %vBoWNeg_test = vBoWNeg;
    %keyboard;
    disp('processing positve testing images');
    vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
    disp('processing negative testing images');
    vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);

    nrPos = size(vBoWPos_test,1);
    nrNeg = size(vBoWNeg_test,1);

    test_histograms = [vBoWPos_test;vBoWNeg_test];
    labels = [ones(nrPos,1);zeros(nrNeg,1)];

    disp('______________________________________')
    disp('Nearest Neighbor classifier')
    pnn = bow_recognition_multi_check(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
    disp('______________________________________')
    disp('Bayesian classifier')
    pbc = bow_recognition_multi_check(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
    disp('______________________________________')
    
    all_pnn = [all_pnn, pnn];
    all_pbc = [all_pbc, pbc];
end


%%
x = 20:40:420;
plot(x, all_pnn);
grid on
hold on
plot(x, all_pbc)
legend('Nearest Neighbor','Bayesian', 'Location', 'southwest', 'FontSize', 16)
xlabel('Codebook Size', 'FontSize', 20)
ylabel('Accuracy', 'FontSize', 20)
title('Codebook Size vs Accuracy', 'FontSize', 20)




