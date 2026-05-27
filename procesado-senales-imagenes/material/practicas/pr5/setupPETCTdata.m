% (c) Jan Modersitzki 2009/03/24, see FAIR.2 and FAIRcopyright.m.
% Initializing HNSP data to be used in FAIR.
% Original data from 
%@article{ShekharEtAl2005,
% author = {Raj Shekhar and Vivek Walimbe and Shanker Raja and Vladimir Zagrodsky
%           and Mangesh Kanvinde and Guiyun Wu and Bohdan Bybel},
% title = {Automated 3-Dimensional Elastic Registration of Whole-Body {PET}
%          and {CT} from Separate or Combined Scanners},
% journal = {J. of Nuclear Medicine},
% volume = {46},
% number = {9},
% year = {2005},
% pages = {1488--1496},
%}
% -----------------------------------------------------------------------------

outfile = [mfilename('fullpath'),'.mat'];
example = 'PETCT';

if exist(outfile,'file'),
  load(outfile);
  viewImage('reset',viewOptn{:});
  inter('reset',interOptn{:});
  return
end;

% set view options and interpolation options
viewOptn = {'viewImage','viewImage2D','colormap','gray(256)'};
viewImage('reset',viewOptn{:});

message = @(str) fprintf('%% %s  [ %s ]  % s\n',...
  char(ones(1,10)*'-'),str,char(ones(1,60-length(str))*'-'));
message(mfilename)

get2Ddata(outfile,'PET-CT-PET.jpg','PET-CT-CT.jpg',...
  'omegaT',[0,50,0,50],'omegaR',[0,50,0,50],'m',[128,128]);
load(outfile);

