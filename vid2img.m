function [J] = vid2img (I)
% This functions converts all frames of the video I into a cell J, storing 
% the frames as image-matrices.
    
    % Generating a cell to store images: 
    n           =   I.NumFrames; 
    J           =   cell(n,1);
    
    % Looping through the frames and inserting image to cell:
    for i = 1 : n
    
        J{i}    =  read(I,i);
    
    end

end
