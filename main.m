% =========================================================
% Supersonic Spray Image Processing using MATLAB
% Tandem Injection Penetration Analysis
%
% This project performs:
% 1. Image averaging
% 2. Binary image processing
% 3. Canny edge detection
% 4. Spray boundary extraction
% 5. Penetration profile plotting
% 6. Excel data export
%
% Author: Rakuditi Sai Praneeth
% =========================================================

clc
clear
close all

%% =========================================================
% PART 1 : INPUT FOLDER
% =========================================================

% Folder containing experimental TIFF images
inputFolder = 'F:\0.25lpm_29_only_liq';

%% =========================================================
% PART 2 : READ IMAGE FILES
% =========================================================

% Read .tif files
imageFiles = dir(fullfile(inputFolder, '*.tif'));

% If no .tif files found, search for .tiff files
if isempty(imageFiles)
    imageFiles = dir(fullfile(inputFolder, '*.tiff'));
end

% Total number of images
numImages = length(imageFiles);

disp(['Total images found: ', num2str(numImages)])

% Display first few image names
if numImages >= 3
    disp('Sample image files:')
    disp(imageFiles(1).name)
    disp(imageFiles(2).name)
    disp(imageFiles(3).name)
else
    error('No TIFF images found in the folder.')
end

%% =========================================================
% PART 3 : READ FIRST IMAGE
% =========================================================

firstImage = imread(fullfile(inputFolder, imageFiles(1).name));

% Convert RGB image to grayscale if needed
if size(firstImage,3) == 3
    firstImage = rgb2gray(firstImage);
end

% Convert image to double precision
firstImage = im2double(firstImage);

% Display first grayscale image
figure
imshow(firstImage, [])
title('First Grayscale Image')

%% =========================================================
% PART 4 : CREATE MATRICES FOR IMAGE AVERAGING
% =========================================================

[rows, cols] = size(firstImage);

sum1000 = zeros(rows, cols);
sum2000 = zeros(rows, cols);
sum3000 = zeros(rows, cols);

%% =========================================================
% PART 5 : READ AND PROCESS IMAGES
% =========================================================

for k = 1:3000

    % Read kth image
    I = imread(fullfile(inputFolder, imageFiles(k).name));

    % Convert RGB to grayscale if required
    if ndims(I) == 3
        I = rgb2gray(I);
    end

    % Convert image to double
    I = im2double(I);

    % Convert grayscale image to binary
    BW = imbinarize(I, 0.35);

    % Convert logical image to double
    BW = double(BW);

    % Sum first 1000 images
    if k <= 1000
        sum1000 = sum1000 + BW;
    end

    % Sum first 2000 images
    if k <= 2000
        sum2000 = sum2000 + BW;
    end

    % Sum first 3000 images
    if k <= 3000
        sum3000 = sum3000 + BW;
    end

end

%% =========================================================
% PART 6 : COMPUTE AVERAGE BINARY IMAGES
% =========================================================

avg1000 = sum1000 / 1000;
avg2000 = sum2000 / 2000;
avg3000 = sum3000 / 3000;

%% =========================================================
% PART 7 : DISPLAY AVERAGED IMAGES
% =========================================================

figure

subplot(1,3,1)
imshow(avg1000, [])
title('Average Binary - 1000 Images')

subplot(1,3,2)
imshow(avg2000, [])
title('Average Binary - 2000 Images')

subplot(1,3,3)
imshow(avg3000, [])
title('Average Binary - 3000 Images')

%% =========================================================
% PART 8 : SAVE AVERAGED IMAGES
% =========================================================

imwrite(mat2gray(avg1000), 'avg_binary_1000.png');
imwrite(mat2gray(avg2000), 'avg_binary_2000.png');
imwrite(mat2gray(avg3000), 'avg_binary_3000.png');

%% =========================================================
% PART 9 : CANNY EDGE DETECTION
% =========================================================

edge1000 = edge(avg1000, 'canny', 0.02);
edge2000 = edge(avg2000, 'canny', 0.02);
edge3000 = edge(avg3000, 'canny', 0.02);

%% =========================================================
% PART 10 : DISPLAY EDGE DETECTION RESULTS
% =========================================================

figure

subplot(1,3,1)
imshow(edge1000)
title('Canny Edge - Avg1000')

subplot(1,3,2)
imshow(edge2000)
title('Canny Edge - Avg2000')

subplot(1,3,3)
imshow(edge3000)
title('Canny Edge - Avg3000')

%% =========================================================
% PART 11 : SAVE EDGE DETECTION RESULTS
% =========================================================

imwrite(edge1000, 'edge_avg1000.png');
imwrite(edge2000, 'edge_avg2000.png');
imwrite(edge3000, 'edge_avg3000.png');

%% =========================================================
% PART 12 : INPUT PARAMETERS FOR BOUNDARY EXTRACTION
% =========================================================

% Pixel resolution
pixelSize = 0.1123;   % mm per pixel

% Reference origin point
x0 = 137;
y0 = 339;

% Sampling interval
stepSize = 15;

%% =========================================================
% PART 13 : USE CANNY EDGE IMAGES
% =========================================================

BW1000 = edge1000;
BW2000 = edge2000;
BW3000 = edge3000;

%% =========================================================
% PART 14 : DEFINE COMMON X LOCATIONS
% =========================================================

[rows, cols] = size(BW1000);

xCols = x0:stepSize:cols;

nPts = length(xCols);

% Preallocate arrays
x_mm      = nan(nPts,1);
y1000_mm  = nan(nPts,1);
y2000_mm  = nan(nPts,1);
y3000_mm  = nan(nPts,1);

%% =========================================================
% PART 15 : EXTRACT UPPER BOUNDARY POINTS
% =========================================================

for i = 1:nPts

    xcol = xCols(i);

    % Convert x distance into mm
    x_pixel = xcol - x0 + 1;
    x_mm(i) = x_pixel * pixelSize;

    %% Avg1000
    edgeRows = find(BW1000(:, xcol));

    if ~isempty(edgeRows)
        upperRow = edgeRows(1);
        y_pixel = y0 - upperRow;
        y1000_mm(i) = y_pixel * pixelSize;
    end

    %% Avg2000
    edgeRows = find(BW2000(:, xcol));

    if ~isempty(edgeRows)
        upperRow = edgeRows(1);
        y_pixel = y0 - upperRow;
        y2000_mm(i) = y_pixel * pixelSize;
    end

    %% Avg3000
    edgeRows = find(BW3000(:, xcol));

    if ~isempty(edgeRows)
        upperRow = edgeRows(1);
        y_pixel = y0 - upperRow;
        y3000_mm(i) = y_pixel * pixelSize;
    end

end

%% =========================================================
% PART 16 : PLOT PENETRATION PROFILES
% =========================================================

figure
plot(x_mm, y1000_mm, 'ro-', 'LineWidth', 2)
xlabel('x from origin (mm)')
ylabel('Upper boundary y (mm)')
title('Upper Boundary Profile - Avg1000')
grid on

figure
plot(x_mm, y2000_mm, 'bo-', 'LineWidth', 2)
xlabel('x from origin (mm)')
ylabel('Upper boundary y (mm)')
title('Upper Boundary Profile - Avg2000')
grid on

figure
plot(x_mm, y3000_mm, 'ko-', 'LineWidth', 2)
xlabel('x from origin (mm)')
ylabel('Upper boundary y (mm)')
title('Upper Boundary Profile - Avg3000')
grid on

%% =========================================================
% PART 17 : COMPARISON PLOT
% =========================================================

figure

plot(x_mm, y1000_mm, 'r-o', 'LineWidth', 2)
hold on

plot(x_mm, y2000_mm, 'b-o', 'LineWidth', 2)

plot(x_mm, y3000_mm, 'k-o', 'LineWidth', 2)

xlabel('x from origin (mm)')
ylabel('Upper boundary y (mm)')

title('Comparison of Upper Boundary Profiles')

legend('Avg1000', 'Avg2000', 'Avg3000', 'Location', 'best')

grid on

%% =========================================================
% PART 18 : DISPLAY EXTRACTED SAMPLE POINTS
% =========================================================

% Avg1000
figure
imshow(BW1000, [])
hold on

plot(x0, y0, 'rs', 'MarkerSize', 8, 'LineWidth', 2)

valid1000 = ~isnan(y1000_mm);

plot(xCols(valid1000), ...
     y0 - y1000_mm(valid1000)/pixelSize, ...
     'go', 'MarkerSize', 6, 'LineWidth', 1.5)

title('Sampled Upper Boundary Points - Avg1000')

% Avg2000
figure
imshow(BW2000, [])
hold on

plot(x0, y0, 'rs', 'MarkerSize', 8, 'LineWidth', 2)

valid2000 = ~isnan(y2000_mm);

plot(xCols(valid2000), ...
     y0 - y2000_mm(valid2000)/pixelSize, ...
     'go', 'MarkerSize', 6, 'LineWidth', 1.5)

title('Sampled Upper Boundary Points - Avg2000')

% Avg3000
figure
imshow(BW3000, [])
hold on

plot(x0, y0, 'rs', 'MarkerSize', 8, 'LineWidth', 2)

valid3000 = ~isnan(y3000_mm);

plot(xCols(valid3000), ...
     y0 - y3000_mm(valid3000)/pixelSize, ...
     'go', 'MarkerSize', 6, 'LineWidth', 1.5)

title('Sampled Upper Boundary Points - Avg3000')

%% =========================================================
% PART 19 : EXPORT RESULTS TO EXCEL
% =========================================================

resultsTable = table( ...
    x_mm, ...
    y1000_mm, ...
    y2000_mm, ...
    y3000_mm, ...
    'VariableNames', ...
    {'x_mm','y1000_mm','y2000_mm','y3000_mm'});

writetable(resultsTable, 'upper_boundary_comparison.xlsx');

disp('Excel file saved successfully.')
disp(resultsTable)

%% =========================================================
% END OF PROGRAM
% =========================================================