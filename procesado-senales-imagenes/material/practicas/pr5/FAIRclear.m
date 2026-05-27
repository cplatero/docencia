% function clearFAIR
% (c) Jan Modersitzki 2008/08/12, see FAIR and FAIRcopyright.m.
% clears current setting

function clearFAIR;
fprintf('clear FAIR modules\n')
clear; close all;
viewImage('clear');
inter('clear');
trafo('clear');
PIRregularizer('clear');
distance('clear');
regularizer('clear');
FAIRplots('clear'); 
