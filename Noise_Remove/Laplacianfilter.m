function I=lap(J,M,N,sigma)
[X Y]=meshgrid(round(-N/2):round(M/2), round(-N/2):round(M/2));

 f=-1/(pi*sigma^4)*(1-(X^2+Y^2)/(2*sigma^2)).*exp(-(X.^2+Y.^2)/(2*sigma^2));
 f1=f-mean(f(:));
 r=conv2(double(J(:, :, 1)),f1,'same');
 g=conv2(double(J(:, :, 2)),f1,'same');
 b=conv2(double(J(:, :, 3)),f1,'same');
 
 
 
 I = cat(3, r, g, b);
 I=uint8(I);
end