%========================Medianfilter function=================
% B is the output image with median filter
% I is the input original image
% n is mask size. eg:3*3 mask, then n=3.
%==============================================================
function I2=median(I,n,m,f,g,h,o);
[a,b]=size(I);
I1=zeros(a+n-1,b+m-1);
I1(1+(n-1)/2:a+(n-1)/2,1+(m-1)/2:b+(m-1)/2)=I(:,:);
for i=1:a % 2~513
    for j=1:b     
       Mask=zeros(n*m,1);
        conter=1;
          for p=1:n
              for q=1:m
                  Mask(conter)=I1(i+p-1,j+q-1);
                  conter=conter+1;
              end
          end
          med=sort(Mask); 
          B(i,j)=med((n*m+1)/2);              
    end
end
B=uint8(B);
I2=I;
I2(f:f+h,g:g+o)=B(f:f+h,g:g+o);
%===================================================================