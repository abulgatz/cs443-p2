function runme(targetFrameName,referenceFrameName,N,p)
    rf = imread(referenceFrameName);
    tf = imread(targetFrameName);

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
end