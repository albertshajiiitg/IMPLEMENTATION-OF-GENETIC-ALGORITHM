function result = scale(x,x_min,x_max)
        decoded_val = 0;
        l=length(x);
       for i=0:l-1
            decoded_val=decoded_val+ x(l-i)*2^i;
       end
       result = x_min+((x_max-x_min)/((2^l)-1))*decoded_val;
end