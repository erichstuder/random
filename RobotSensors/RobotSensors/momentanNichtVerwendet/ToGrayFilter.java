package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;

public class ToGrayFilter extends Block {
	
	private final String name = "To Gray Filter";
	final float R_WEIGHT = 0.2989f;
	final float G_WEIGHT = 0.5870f;
	final float B_WEIGHT = 0.1140f;
	
	final int NON_TRANSPARENT = Color.BLACK;
	
	//Activity activity = null;
	Context context = null;
	
	public ToGrayFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		int r,g,b,pixel,gray;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			//image[i]=image[i] & BLUE_MASK;
			pixel = image[i];
			r = (int)(((pixel >> 16) & 0xFF) * R_WEIGHT);
			g = (int)(((pixel >> 8 ) & 0xFF) * G_WEIGHT);
			b = (int)(((pixel      ) & 0xFF) * B_WEIGHT);
			gray = r+g+b;
			image[i] =NON_TRANSPARENT+(gray<<16)+(gray<<8)+gray;	
		}
		
		return null;
	}
	
	public String getName(){
		return name;
	}
}
