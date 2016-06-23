function gabor

imSize = 100;                           % image size: n X n
lamda = 10;                             % wavelength (number of pixels per cycle)
theta = 15;                             % grating orientation
sigma = 10;                             % gaussian standard deviation in pixels
phase = .25;                            % phase (0 -> 1)
trim = .005;                            % trim off gaussian values smaller than this
%make linear ramp
X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;                 % rescale X -> -.5 to .5
figure;                                 % make new figure window
plot(X0);                               % plot ramp

%plot a one-dimensional sinewave

sinX = sin(X0 * 2*pi);                  % convert to radians and do sine
plot(sinX);                             % plot a 1D sinewave!

%mess about with wavelength and phase

freq = imSize/lamda;                    % compute frequency from wavelength
Xf = X0 * freq * 2*pi;                  % convert X to radians: 0 -> ( 2*pi * frequency)
sinX = sin(Xf) ;                        % make new sinewave
plot(sinX, 'r-');                       % plot in red
phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
sinX = sin( Xf + phaseRad) ;            % make phase-shifted sinewave
hold on;                                % superimpose next plot on last
plot(sinX, 'g-');                       % plot in green
hold off;                               % next plot overwrites this one

%Now make a 2D grating

Start with a 2D ramp use meshgrid to make 2 matrices with ramp values across columns (Xm) or across rows (Ym) respectively

[Xm Ym] = meshgrid(X0, X0);             % 2D matrices
imagesc( [ Xm Ym ] );                   % display Xm and Ym
colorbar; axis off                      % add colour bar to see values

%Put 2D ramps through sine

Xf = Xm * freq * 2*pi;
grating = sin( Xf + phaseRad);          % make 2D sinewave
imagesc( grating, [-1 1] );             % display
colormap gray(256);                     % use gray colormap (0: black, 1: white)
axis off; axis image;                   % use gray colormap

%Change orientation by adding Xm and Ym together in different proportions

thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
grating = sin( XYf + phaseRad);                   % make 2D sinewave
imagesc( grating, [-1 1] );                     % display
axis off; axis image;    % use gray colormap

%Make a gaussian mask

%first look at the 1D function

s = sigma / imSize;                     % gaussian width as fraction of imageSize
Xg = exp( -( ( (X0.^2) ) ./ (2* s^2) ));% formula for 1D gaussian
Xg = normpdf(X0, 0, (20/imSize)); Xg = Xg/max(Xg);  % alternative using normalized probability function (stats toolbox)
plot(Xg)

%Make 2D gaussian blob

gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
imagesc( gauss, [-1 1] );                        % display
axis off; axis image;     % use gray colormap

%Now multply grating and gaussian to get a GABOR

gauss(gauss < trim) = 0;                 % trim around edges (for 8-bit colour displays)
gabor = grating .* gauss;                % use .* dot-product
imagesc( gabor, [-1 1] );                        % display
axis off; axis image;                    % use gray colormap
axis image; axis off; colormap gray(256);
set(gca,'pos', [0 0 1 1]);               % display nicely without borders
set(gcf, 'menu', 'none', 'Color',[.5 .5 .5]); % without background
end