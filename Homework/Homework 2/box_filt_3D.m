%%% ----------------- 3D box filter in spectral domaim-------------- %%%
%%% note: f should be the ratio L/d (where d is the filter scale)    %%%
%%% f should correspond to a vector of integers with the same number %%%
%%% of elements as requested outputs
function [varargout] = box_filt_3D(x,f)

N=size(x);
x_h = fftn(x); %take the 3D spectrum of x
for III=1:nargout
    x_hat = x_h;

    for k=1:N(1)
        kk=k-1;
        if(kk > N(1)/2); kk=kk-N(3); end

        for j=1:N(2)
            jj=j-1;
            if(jj > N(1)/2); jj=jj-N(2); end

            for i=1:N(3)
                ii=i-1;
                if(ii > N(1)/2); ii=ii-N(1); end
                
                wv = sqrt(ii^2+jj^2+kk^2); %wavenumber magnitude
                %multiply by the box filter transfer function (Note we have
                %assumed prod(N)^(1/3)=N(1))
                if(wv <= 1e-7)
                    x_hat(i,j,k) = x_hat(i,j,k);
                else
                x_hat(i,j,k) = x_hat(i,j,k)*sin((2*pi/f(III))*wv/2)/((2*pi/f(III))*wv/2); 
                end
            end
        end
    end
    varargout(III) = {ifftn(x_hat,'symmetric')};
end
