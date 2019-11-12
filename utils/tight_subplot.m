function h=tight_subplot(m, n, row, col, gutter, margins, varargin)
%TIGHT_SUBPLOT Replacement for SUBPLOT. Easier to specify size of grid, row/col, gutter, and margins
%
% TIGHT_SUBPLOT(M, N, ROW, COL) places a subplot on an M by N grid, at a
% specified ROW and COL.
%
% TIGHT_SUBPLOT(M, N, ROW, COL, GUTTER=.002) indicates the width of the spacing
% between subplots, in terms of proportion of the figure size. If GUTTER is
% a 2-length vector, the first number specifies the width of the spacing
% between columns, and the second number specifies the width of the spacing
% between rows. If GUTTER is a scalar, it specifies both widths. For
% instance, GUTTER = .05 will make each gutter equal to 5% of the figure
% width or height.
%
% TIGHT_SUBPLOT(M, N, ROW, COL, GUTTER=.002, MARGINS=[.06 .01 .04 .04]) indicates the margin on
% all four sides of the subplots. MARGINS = [LEFT RIGHT BOTTOM TOP]. This
% allows room for titles, labels, etc.
%
% Will Adler 2015
% will@wtadler.com
% 
% Right now, this lacks the ability to do subplots that span row/column ranges.
% Inspired by subplot_tight by Nikolay S. (http://vision.technion.ac.il/~kolian1/).

if nargin<5 || isempty(gutter)
    gutter = [.002, .002]; %horizontal, vertical
end

if length(gutter)==1
    gutter(2)=gutter;
elseif length(gutter) > 2
    error('GUTTER must be of length 1 or 2')
end

if nargin<6 || isempty(margins)
    margins = [.06 .01 .04 .04]; % L R B T
end

Lmargin = margins(1);
Rmargin = margins(2);
Bmargin = margins(3);
Tmargin = margins(4);

height = (1-Bmargin-Tmargin-(m-1)*gutter(2))/m;% plot height
width  = (1-Lmargin-Rmargin-(n-1)*gutter(1))/n; % plot width
bottom = (m-row)*(height+gutter(2))+Bmargin; % bottom pos
left   = (col-1)*(width +gutter(1))+Lmargin;            % left pos

pos_vec= [left bottom width height];

h=subplot('Position', pos_vec, varargin{:});
end