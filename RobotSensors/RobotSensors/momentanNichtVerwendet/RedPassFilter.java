package erichstuder.robotsensors;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;

public class RedPassFilter extends Block{
	
	private final String name = "Red Pass Filter";
	final int RED_MASK = Color.RED;
	//Activity activity = null;
	Context context = null;
	
	public RedPassFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			image[i]=image[i] & RED_MASK;
		}
		return null;
	}
	
	
	public String getName(){
		return name;
	}
}
