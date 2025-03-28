function [pixelMatrix] = isFire(fireSegImg)
% This functions checks if there are multiple colors associated with one
% centroid, the aim is to be able to distinguish how well the segmented
% area is in seeing it as a fire. Input:
%
% FireSegImg    = The segmented RBG image.

    % Loop to see if centroid contains different colors:
    windowSize          =   5;
    window              =   ceil(windowSize/2);
    pixelMatrix         =   zeros(size(fireSegImg,1),size(fireSegImg,2));
    
    for i = windowSize : size(fireSegImg,1)-windowSize
        for j = windowSize : size(fireSegImg,2)-windowSize

            if fireSegImg(i,j) ~= 0
                for k =  i - window  : i + window 
                    for l = j - window  : j + window 

                        if fireSegImg(k,l) ~= fireSegImg(i,j) ...
                                && fireSegImg(k,l) ~= 0

                            pixelMatrix(i,j) = 1;
                        end

                    end
                end

            end
        end
    end
end
            