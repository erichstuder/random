package erichstuder.robotsensors;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.util.Log;

public class ImageToolbox {
	private ImageToolbox(){}//konstrukotr blockieren
	
	
	private final static float R_WEIGHT = 0.212655f;//0.2989f;
	private final static float G_WEIGHT = 0.715158f;//0.5870f;
	private final static float B_WEIGHT = 0.072187f;//0.1140f;
	
	/*
	http://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
    Luminance (standard, objective): (0.2126*R) + (0.7152*G) + (0.0722*B)
    Luminance (perceived option 1): (0.299*R + 0.587*G + 0.114*B)
    Luminance (perceived option 2, slower to calculate): sqrt( 0.241*R^2 + 0.691*G^2 + 0.068*B^2 )
	
	Photometric/digital ITU-R:
	Y = 0.2126 R + 0.7152 G + 0.0722 B
	
	rY = 0.212655;
	gY = 0.715158;
	bY = 0.072187;
	
	Digital CCIR601 (gives more weight to the R and B components):
	Y = 0.299 R + 0.587 G + 0.114 B
	
	If you are willing to trade accuracy for perfomance, there are two approximation formulas for this one:
	Y = 0.33 R + 0.5 G + 0.16 B
	Y = 0.375 R + 0.5 G + 0.125 B
	These can be calculated quickly as
	Y = (R+R+B+G+G+G)/6
	Y = (R+R+R+B+G+G+G+G)>>3
	*/
	
	
	
	public static float brightestPoint(RGB8888 image, Point pt) {
		if(image == null || pt == null) return -1;
		
		int[] data = image.getData();
		final int NR_OF_PIXELS = data.length;
		int width = image.getWidth();
		int height = image.getHeight();
		float r,g,b,grey, brightestValue;
		int pixel;
		int brightestX, brightestY, brightestIndex;
		
		brightestIndex=0;
		brightestValue=0;

		for(int i=0; i<NR_OF_PIXELS; i++){
			pixel = data[i];
			r = ((pixel >> 16) & 0xFF) * R_WEIGHT;
			g = ((pixel >> 8 ) & 0xFF) * G_WEIGHT;
			b = ((pixel      ) & 0xFF) * B_WEIGHT;
			grey = r+g+b;
			
			if(grey > brightestValue){
				brightestValue = grey;
				brightestIndex = i;
			}
		}
		
		brightestX = brightestIndex % width;
		brightestY = brightestIndex / width;
		
		Bitmap bitmap = Bitmap.createBitmap(width,height,Bitmap.Config.ARGB_8888);
		bitmap.setPixels(data, 0, width, 0, 0, width, height);
		Canvas canvas = new Canvas(bitmap);
		
		Paint paint = new Paint();
		paint.setColor(Color.RED);
		paint.setStyle(Paint.Style.STROKE);
		paint.setStrokeWidth(10);
		canvas.drawCircle(brightestX, brightestY, 20, paint);
		
		bitmap.getPixels(data, 0, width, 0, 0, width, height);
		image.set(data, width, height);
		
		pt.set(brightestX, brightestY);
		
		return brightestValue;
	}
	
	public static float darkestPoint(RGB8888 image, Point pt) {
		if(image == null || pt == null) return -1;
		
		int[] data = image.getData();
		final int NR_OF_PIXELS = data.length;
		int width = image.getWidth();
		int height = image.getHeight();
		float r,g,b,grey, darkestValue;
		int pixel;
		int darkestX, darkestY, darkestIndex;
		
		darkestIndex=0;
		darkestValue=1000;//mögliches Maximum liegt bei etwa 255

		for(int i=0; i<NR_OF_PIXELS; i++){
			pixel = data[i];
			r = ((pixel >> 16) & 0xFF) * R_WEIGHT;
			g = ((pixel >> 8 ) & 0xFF) * G_WEIGHT;
			b = ((pixel      ) & 0xFF) * B_WEIGHT;
			grey = r+g+b;
			
			if(grey < darkestValue){
				darkestValue = grey;
				darkestIndex = i;
			}
		}
		
		darkestX = darkestIndex % width;
		darkestY = darkestIndex / width;
		
		//TODO muss wirklich ein neues Bild erzeugt werden?
		Bitmap bitmap = Bitmap.createBitmap(width,height,Bitmap.Config.ARGB_8888);
		bitmap.setPixels(data, 0, width, 0, 0, width, height);
		Canvas canvas = new Canvas(bitmap);
		
		Paint paint = new Paint();
		paint.setColor(Color.RED);
		paint.setStyle(Paint.Style.STROKE);
		paint.setStrokeWidth(10);
		canvas.drawCircle(darkestX, darkestY, 20, paint);
		
		bitmap.getPixels(data, 0, width, 0, 0, width, height);
		image.set(data, width, height);
		
		pt.set(darkestX, darkestY);
		
		return darkestValue;
	}
	
	
	public static int[] meanColor(RGB8888 image) {
		
		if(image == null) return null;
		
		long rSum,gSum,bSum;
		rSum=0;
		gSum=0;
		bSum=0;
		for(int pixel : image.getData()){
			rSum += ((pixel >>> 16) & 0xFF);
			gSum += ((pixel >>>  8) & 0xFF);
			bSum += ((pixel       ) & 0xFF);
		}
		
		long size = image.getWidth() * image.getHeight();
		return new int[]{(int)(rSum/size), (int)(gSum/size), (int)(bSum/size)};
	}
	
	
    /**
     * Converts YUV420 NV21 to RGB8888
     * 
     * @param data byte array on YUV420 NV21 format.
     * @param width pixels width
     * @param height pixels height
     * @return a RGB8888 pixels int array. Where each int is a pixels ARGB. 
     */
    public static int[] convertYUV420_NV21toRGB8888(byte[] data, int width, int height) {
        final int size = width*height;
        int offset = size;
        int[] pixels = new int[size];
        int u, v;
        int[] n = new int[4];
        int r,g,b;
        float y;
        
        for(int i=0, k=0; i < size; i+=2, k+=2) {
            u = data[offset+k+1]&0xff;
            v = data[offset+k  ]&0xff;
            u = u-128;
            v = v-128;

            n[0]=i;
            n[1]=i+1;
            n[2]=width+i;
            n[3]=width+i+1;
            
            for(int x:n){
//            	y = data[x] & 0xff;
//            	r = y + (int)1.402f*v;
//            	g = y - (int)(0.344f*u +0.714f*v);
//            	b = y + (int)1.772f*u;
                
            	//http://www.fourcc.org/fccyvrgb.php mit dieser Variante scheinen die Farben satter.
            	y = data[x] & 0xff;
            	y = 1.164f*(y-16);
				r = (int)(y + 2.018f*v);
				g = (int)(y - (0.813f*u +0.391f*v));
				b = (int)(y + 1.596f*u);
                
                r = r>255 ? 255 : r<0 ? 0 : r;
                g = g>255 ? 255 : g<0 ? 0 : g;
                b = b>255 ? 255 : b<0 ? 0 : b;
                
            	pixels[x] = 0xff000000 | (r<<16) | (g<<8) | b;
                //pixels[x] = 0xFF0000FF;
            }

            if (i!=0 && (i+2)%width==0)
                i+=width;
        }
        return pixels;
    }
    
    public static void cut(RGB8888 image, int left, int right, int top, int bottom) throws Exception{
    	if(image == null){
    		throw new NullPointerException("image must not be null");
    	}

    	int width = image.getWidth();
    	int height = image.getHeight();

    	if(left < 0 || right < 0 || top < 0 || bottom < 0 || left+right > width || top+bottom > height){
    		throw new Exception("parameter out of range");
    	}

    	int newWidth  = width-left-right;
    	int newHeight = height-top-bottom;
    	int newData[] = new int[newHeight * newWidth];
    	int data[] = image.getData();
    	
    	int leftIndex = left-1;
    	int rightIndex = width-right;
    	int topIndex = top-1;
    	int bottomIndex = height-bottom;
    	
    	for(int n=0; n<newData.length; n++){
    		newData[n] = Color.BLACK;
    	}
    	
    	int n=0;
    	for(int y=0; y<height; y++){
	    	for(int x=0; x<width; x++){
	    		if(x > leftIndex && x < rightIndex && y > topIndex && y < bottomIndex){
	    			newData[n] = data[y*width+x];
	    			n++;
	    		}
	    	}
    	}
    	//Log.v("erich",""+width);
    	//Log.v("erich",""+height);
    	//Log.v("erich",""+newWidth);
    	//Log.v("erich",""+newHeight);
    	

    	image.set(newData, newWidth, newHeight);
    }
    
    
    //anders lösen => compare ist zu weit gefasst TODO
    public static float subtract(RGB8888 imageA, RGB8888 imageB){
    	if(imageA == null || imageB == null){ 
    		return -1;
    	}
    	
    	int[] dataA = imageA.getData();
    	int[] dataB = imageB.getData();
    	if((imageA.getWidth() != imageB.getWidth()) || (imageA.getHeight() != imageB.getHeight())){
    		return -1;
    	}
    	
    	float ret = 0;
    	int length = dataA.length;
    	int aA, rA, gA, bA, aB, rB, gB, bB;
    	int pixelA, pixelB;
    	for(int i=0; i<length; i++){
    		
    		pixelA = dataA[i];
    		//aA = (pixelA >>> 24) & 0xFF; 
    		rA = (pixelA >>> 16) & 0xFF;
			gA = (pixelA >>> 8 ) & 0xFF;
			bA = (pixelA       ) & 0xFF;
    		
    		pixelB = dataB[i];
    		//aB = (pixelB >>> 24) & 0xFF; 
    		rB = (pixelB >>> 16) & 0xFF;
			gB = (pixelB >>> 8 ) & 0xFF;
			bB = (pixelB       ) & 0xFF;
			
			//aA = Math.abs(aA-aB);
			rA = Math.abs(rA-rB);
			gA = Math.abs(gA-gB);
			bA = Math.abs(bA-bB);
			
			dataA[i] = 0xff000000 | (rA<<16) | (gA<<8) | bA;
    		
    	}
    	
    	return ret/(length*3); //value expressing the difference in range 0..255 //0: no difference; 255: maximum difference
    }
}
