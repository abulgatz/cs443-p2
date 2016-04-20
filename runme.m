rf = imread('sample1_akiyo_frame1.bmp');
tf = imread('sample1_akiyo_frame2.bmp');

N = 16;
p = 7;

rf = rgb2gray(rf);
tf = rgb2gray(tf);

[motionVectors, mcFrame] = blockMatchingSequential(tf, rf, N, p);
FD = computeFrameDifference(tf, rf);
DFD = computeFrameDifference(tf, mcFrame);

imgLines = drawMotionVectors(mcFrame,motionVectors, N);

subplot(2,3,1);
imshow(rf);
title('Reference');

subplot(2,3,2);
imshow(tf);
title('Target');

subplot(2,3,3);
imshow(mcFrame);
title('Motion Compensated');

subplot(2,3,4);
imshow(imgLines);
title('Motion Vectors');

subplot(2,3,5);
imshow(FD);
title('FD');

subplot(2,3,6);
imshow(DFD);
title('DFD');

mse = computeMSE(tf, mcFrame);
psnr = computePSNR(mse);

disp('mse: ');
disp(mse);

disp('psnr: ');
disp(psnr);
