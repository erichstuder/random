package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;

public class RedStopFilter extends Block{
	private final String name = "Red Stop Filter";
	final int RED_STOP_MASK = Color.CYAN;
	//Activity activity = null;
	Context context = null;
	
	public RedStopFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			image[i]=image[i] & RED_STOP_MASK;
		}
		return null;
	}
	
	
	public String getName(){
		return name;
	}
}
