function result = multi_quad(x1,x2)
    result = x1+x2-2*x1*x1-x2*x2+x1*x2; 
    result= 1/(result*result +1);
    
end