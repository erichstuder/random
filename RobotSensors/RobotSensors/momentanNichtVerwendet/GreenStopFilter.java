package erichstuder.robotsensors;

import android.content.Context;
import android.graphics.Color;

public class GreenStopFilter extends Block{
	private final String name = "Green Stop Filter";
	final int GREEN_STOP_MASK = Color.MAGENTA;
	//Activity activity = null;
	Context context = null;
	
	public GreenStopFilter(Context context){
		super(context);
		this.setText(name);
		this.context = context;
	}
	
	public Object doFilter(int[] image, int width, int height){
		final int NR_OF_PIXELS = image.length;
		
		for(int i=0; i<NR_OF_PIXELS; i++){
			image[i]=image[i] & GREEN_STOP_MASK;
		}
		
		return null;
	}
	
	
	public String getName(){
		return name;
	}
}
