h = openserial(1,"9600,n,8,1");
//xpause(3);
//buf = readserial(h)

//xpause(3);


//buf = readserial(h)
n=1;
vector=0;
while n<100
    
    temp = strtod(readserial(h));
    
    if ~isnan(temp) then
        //mprintf("%f",temp);
        vector(n)=temp;
        n=n+1;
    end
    
    sleep(100);
    
    plot(vector);

end
//buf

closeserial(h);
