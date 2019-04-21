package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;

public class Gain2xFilter extends Block {
	private final String name = "Gain 2x";
	//final int RED_STOP_MASK = Color.CYAN;
	final int NON_TRANSPARENT = Color.BLACK;
	//Activity activity = null;
	Context context = null;
	
	public Gain2xFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		
		int r,g,b,pixel;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			pixel = image[i];
			
			r = (pixel >> 15) & 0x1FE;
			g = (pixel >> 7 ) & 0x1FE;
			b = (pixel << 1 ) & 0x1FE;
			
			if(r>255) r=255;
			if(g>255) g=255;
			if(b>255) b=255;
			
			image[i] = NON_TRANSPARENT+(r<<16)+(g<<8)+b;
		}
		return null;
	}
	
	
	public String getName(){
		return name;
	}
}
