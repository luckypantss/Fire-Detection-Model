function [cFireSegImg, fireSegImg] = fireSeg(fireImg, nPixels, isPlot)
% This function segments the fire by using superpixels to get the mean
% intensity for each segmented area. The functions take inputs:
% fireImg - The image which is to be segmented
% nPixels - By how many pixels it should be segmented
% isPlot - True for plots, and false if no plot is wanted:

    % Segmenting the image using superpixels:
    [superLabel, nLabels]       =   superpixels(fireImg, nPixels);
    sPixelBoundMask             =   boundarymask(superLabel);
    


    % Generating the mean RBG color of each superpixel*:
    fireImgSuperPixel       =   zeros(size(fireImg),'like',fireImg);
    pixelIndexList          =   label2idx(superLabel);
    nRows                   =   size(fireImg,1);
    nCols                   =   size(fireImg,2);
    
    for l = 1 : nLabels
        rPindx          =   pixelIndexList{l};
        gPindx          =   pixelIndexList{l} + nRows * nCols;
        bPindx          =   pixelIndexList{l} + 2 * nRows * nCols;
    
        fireImgSuperPixel(rPindx)       =   mean(fireImg(rPindx));
        fireImgSuperPixel(gPindx)       =   mean(fireImg(gPindx));
        fireImgSuperPixel(bPindx)       =   mean(fireImg(bPindx));
    end    
    
    
    % Segmenting corresponding to the fire-like colours:
    fireSegImg          =   uint8(zeros(size(fireImg)));
    fireSegImgBin       =   logical(zeros(size(fireImg,1),size(fireImg,2)));
    
    for i = 1 : size(fireImg,1)
        for j = 1: size(fireImg,2)
            
            % Getting the RBG value for one pixel
            R       =   fireImgSuperPixel(i,j,1);
            G       =   fireImgSuperPixel(i,j,2);
            B       =   fireImgSuperPixel(i,j,3);
            
            
            % Checking if pixel corresponds to fire:
            if R > 190 && G > 80 && B < 100                        % Red/orange  
                fireSegImg(i,j,1) = fireImgSuperPixel(i,j,1);
                fireSegImg(i,j,2) = fireImgSuperPixel(i,j,2);
                fireSegImg(i,j,3) = 0;
    
                fireSegImgBin(i,j) = true;
    
            elseif R > 200 && G > 195 && B < 100                   % Yellow 
                fireSegImg(i,j,1) = fireImgSuperPixel(i,j,1);
                fireSegImg(i,j,2) = fireImgSuperPixel(i,j,2);
                fireSegImg(i,j,3) = 0;
    
                fireSegImgBin(i,j) = true;
    
            end
        end
    end
    
    % Preforming closing on the binary image: 
    se                          = strel('disk',8);
    cFireSegImg                 = medfilt2(imclose(fireSegImgBin,se));

    if isPlot == true

        figure
        nexttile
        imshow(imoverlay(fireImg,sPixelBoundMask,'cyan'))
        title('Shows the segmented superpixel regions')
        
        nexttile
        imshow(fireImgSuperPixel,'InitialMagnification',67)
        title('Showing the superpixeled image')

        figure
        idisp(fireImgSuperPixel)
        title('Showing the superpixeled image')

        figure
        idisp(cFireSegImg)
        title('Shows the segmented areas of the image')

        figure
        idisp(fireSegImg)
        title('Shows the binary image of the segmented potential fire')
    end
    
end

% * This part was inspired & partly taken from https://se.mathworks.com/help/images/ref/superpixels.html
