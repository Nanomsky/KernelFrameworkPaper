
function [xtr, ytr, xte, yte, xva, yva] = splitsequence(DgCell, train, test)

%train=0.6;
%test=0.2;
rng(0)

rnd = randperm(length(DgCell));

indtr = round(length(rnd)* train);
indte = round(length(rnd)* test);

xtr = DgCell(1:indtr,1);
ytr = cell2mat(DgCell(1:indtr,2));

xte = DgCell(1+indtr: indte+indtr,1);
yte = cell2mat(DgCell(1+indtr: indte+indtr,2));

xva = DgCell((1+ indte+indtr): end,1);
yva = cell2mat(DgCell((1+ indte+indtr): end,2));
