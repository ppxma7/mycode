function [diagSubtraction] = diagMinusOffDiag(mat)
%diagMinusOffDiag - Subtract mean off diagonals from mean diagonals in a symmetric
%matrix
%
% ma July 2025

if isequal(size(mat,1), size(mat,2))
    diagonal_mean = mean(diag(mat));
    off_diagonal_mean = mean(mat(:)) - diagonal_mean;
    diagSubtraction = diagonal_mean - off_diagonal_mean;
else
    error('Must have symmetric matrix')
end