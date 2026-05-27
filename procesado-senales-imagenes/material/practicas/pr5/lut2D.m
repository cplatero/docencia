function imgSal2D = lut2D(tablaBayes,imgEnt2D)

imgSal2D = zeros(size(imgEnt2D));
for i=1:(size(tablaBayes,1)-1)
    imgSal2D((imgEnt2D>=tablaBayes(i,1)) & (imgEnt2D<tablaBayes(i+1,1)) )...
            =tablaBayes(i,2);
end
imgSal2D(imgEnt2D>=1) = tablaBayes(end,2);