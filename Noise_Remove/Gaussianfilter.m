function I2=Gauss(J,M,N,sigma,ff,gg,h,o)
I2=J;
 [X Y]=meshgrid(round(-N/2):round(M/2), round(-N/2):round(M/2));
 f=1/(2*pi*sigma^2)*exp(-(X.^2+Y.^2)/(2*sigma^2));
 f1=f./sum(f(:));
 r=conv2(double(J(:, :, 1)),f1,'same');
 g=conv2(double(J(:, :, 2)),f1,'same');
 b=conv2(double(J(:, :, 3)),f1,'same');
 I = cat(3, r, g, b);
 I=uint8(I);

I2(ff:ff+h,gg:gg+o)=I(ff:ff+h,gg:gg+o);

end