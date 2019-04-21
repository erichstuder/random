package erichstuder.robotsensors;

import java.util.Arrays;


//besserer Name: ARGB8 TODO
public class RGB8888 {
	private int[] data = null;
	private int width = 0;
	private int height = 0;
	
	public RGB8888(int[] data, int width, int height){
		this.data = data;
		this.height = height;
		this.width = width;
	}
	
	public RGB8888(RGB8888 image){
		if(image != null){
			int[] data = image.getData();
			this.data = Arrays.copyOf(data, data.length);
			this.height = image.getHeight();
			this.width = image.getWidth();
		}else{
			this.data = null;
			this.height = 0;
			this.width = 0;
		}
	}
	
	public int[] getData(){return data;}
	
	public int getWidth(){return width;}
	
	public int getHeight(){return height;}
	
	public void set(int[] data, int width, int height){
		this.data = data;
		this.height = height;
		this.width = width;
	}
}
