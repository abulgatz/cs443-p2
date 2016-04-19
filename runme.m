rf = imread('sample2_changetogray_suzie038_frame1.bmp');
tf = imread('sample2_changetogray_suzie039_frame2.bmp');

rf = rgb2gray(rf);
tf = rgb2gray(tf);

[motionVectors, mcFrame] = blockMatchingSequential(tf, rf, 16, 7);
FD = computeFrameDifference(tf, rf);
DFD = computeFrameDifference(tf, mcFrame);

subplot(2,3,1);
imshow(rf);
title('Reference');

subplot(2,3,2);
imshow(tf);
title('Target');

subplot(2,3,3);
imshow(mcFrame);
title('Motion Compensated');

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
