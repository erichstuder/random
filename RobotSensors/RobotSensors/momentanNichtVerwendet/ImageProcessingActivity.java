package erichstuder.robotsensors;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Set;

import erichstuder.robotsensors.R;

import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.Size;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;


public class ImageProcessingActivity extends Activity implements OnClickListener, Camera.PictureCallback{
	
	/*Request Codes for Activities. Code will be returned to onActivity Result to identify the Request*/
	private final int NO_REQUEST_CODE   = 0; //no Code will be returned
	private final int REQUEST_ENABLE_BT = 1;
	/**/
	
	
	private String TAG = "ImageProcessingActivity";
	
	private Camera mCamera = null;
	private BluetoothServer nxtBluetooth;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.image_processing_activity);
	    
	    nxtBluetooth = new BluetoothServer(null);//Achtung!!!!!!!!

        CameraPreview mPreview;
                
        try {
            mCamera = Camera.open(); // attempt to get a Camera instance
        }
        catch (Exception e){
            // Camera is not available (in use or does not exist)
        }
        
        Parameters parameters = mCamera.getParameters();
        Size prevSize = parameters.getPreviewSize();
        
        //mPreview = new CameraPreview(this, mCamera,0);
        
        FrameLayout preview1 = (FrameLayout) findViewById(R.id.camera_preview1);
        
        Button button1 = (Button)findViewById(R.id.button1);
        button1.setOnClickListener(this);
        
        //preview1.addView(mPreview);
	}
	
	//protected void onResume(){
		//super.onResume();
		//FrameLayout preview = (FrameLayout) findViewById(R.id.camera_preview1);
		
		//this.findViewById(R.id.camera_preview1)
		//Log.v(TAG, ""+preview.getWidth());
		/*View view = (View)this.findViewById(R.layout.image_processing_activity);
        //Log.v(TAG, findViewById(R.layout.image_processing_activity).toString());
        Log.v(TAG, ""+view);
		*/
	//}
	
	public void onClick(View v){
		mCamera.takePicture(null, null, this);
		
		//Log.v(TAG, ""+getApplicationContext());

		//nxtBluetooth.turnOnBluetooth(this,REQUEST_ENABLE_BT);
		//nxtBluetooth.sendFile();
	}
	
	public void onPictureTaken(byte[] data, Camera camera){
		mCamera.startPreview();
		ImageView imageView1 = (ImageView) findViewById(R.id.imageView1);
		Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
		//imageView1.setImageBitmap(bitmap);
		
		//resize the bitmap
		/*int width = bitmap.getWidth();
		int height = bitmap.getHeight();
		int newWidth  = 100;
		int newHeight = 64;
		float scaleWidth = ((float) newWidth) / width;
		float scaleHeight = ((float) newHeight) / height;
		
		Matrix matrix = new Matrix();
		matrix.postScale(scaleWidth, scaleHeight);
		Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, false);*/
		//resizedBitmap.
		//Bitmap resizedBitmap = Bitmap.createScaledBitmap(bitmap, 100, 64, false);
		
		//Log.v(TAG, bitmap.getConfig().toString());
		bitmap = Bitmap.createScaledBitmap(bitmap, 100, 64, false);
		//bitmap = RGBtoBW(bitmap);
		//bitmap = RGBtoGray(bitmap);
		bitmap = dithering(bitmap);
		//bitmap = dummy(bitmap);
		imageView1.setImageBitmap(bitmap);
		
		
		
	}
	
	private Bitmap RGBtoGray(Bitmap bitmap){
		Bitmap.Config config = bitmap.getConfig();
		
		final int NR_OF_PIXELS = bitmap.getWidth()*bitmap.getHeight();
		//int[] pixels = new int[NR_OF_PIXELS];
		//float brightness;
		int pixel;
		int color;
		
		final float R_WEIGHT = 0.2989f;
		final float G_WEIGHT = 0.5870f;
		final float B_WEIGHT = 0.1140f;
		
		Bitmap ret = bitmap.copy(Bitmap.Config.ARGB_8888, true);
		
		switch(config){
			case ARGB_8888:
				for(int x=0;x<bitmap.getWidth();x++){
					for(int y=0;y<bitmap.getHeight();y++){
						pixel = bitmap.getPixel(x,y);
						color = (int)(Color.red(pixel)*R_WEIGHT + Color.green(pixel)*G_WEIGHT +Color.blue(pixel)*B_WEIGHT);
						ret.setPixel(x, y, Color.argb(255, color, color, color));
					}
				}
			break;
			default:
			break;
		}
		return ret;
	}
	
	/*private Bitmap dummy(Bitmap bitmap){
		for(int x=0;x<bitmap.getWidth();x++){
			for(int y=0;y<bitmap.getHeight();y++){
				bitmap.setPixel(x, y, Color.RED);		
			}
		}
		return bitmap;
	}*/
	
	private Bitmap dithering(Bitmap bitmap){
		
		final int THRESHOLD = 128;
		
		final float R_WEIGHT = 0.2989f;
		final float G_WEIGHT = 0.5870f;
		final float B_WEIGHT = 0.1140f;
		
		int[][] accu = new int[bitmap.getWidth()][bitmap.getHeight()];
		
		int pixel;
		int brightness;
		
		for(int x=0;x<bitmap.getWidth();x++){
			for(int y=0;y<bitmap.getHeight();y++){
				pixel = bitmap.getPixel(x,y);
				
				//brightness = Color.red(pixel)*R_WEIGHT + Color.green(pixel)*G_WEIGHT +Color.blue(pixel)*B_WEIGHT + accu[x][y];
				brightness = (int)(((pixel >> 16) & 0xFF)*R_WEIGHT + ((pixel >> 8) & 0xFF)*G_WEIGHT +(pixel & 0xFF)*B_WEIGHT + accu[x][y]);
				
				
				//Log.v(TAG, ""+brightness);
				//bitmap.setPixel(x, y, Color.RED);
				if(brightness < THRESHOLD){
					
					bitmap.setPixel(x, y, Color.BLACK);
					
					try{
						//bitmap.setPixel(x+1, y  , Color.red(bitmap.getPixel(x+1, y  ))+((brightness*7)/16));
						accu[x+1][y  ] = Color.red(bitmap.getPixel(x+1, y  ))+((brightness*7)/16);
					}catch(Exception e){}
					
					try{
						//bitmap.setPixel(x-1, y+1, Color.red(bitmap.getPixel(x-1, y+1))+((brightness*3)/16));
						accu[x-1][y+1] = Color.red(bitmap.getPixel(x-1, y+1))+((brightness*3)/16);
					}catch(Exception e){}
					
					try{
						//bitmap.setPixel(x  , y+1, Color.red(bitmap.getPixel(x  , y+1))+((brightness*5)/16));
						accu[x  ][y+1] = Color.red(bitmap.getPixel(x  , y+1))+((brightness*5)/16);
					}catch(Exception e){}
					
					try{
						//bitmap.setPixel(x+1, y+1, Color.red(bitmap.getPixel(x+1, y+1))+((brightness  )/16));
						accu[x+1][y+1] = Color.red(bitmap.getPixel(x+1, y+1))+((brightness  )/16);
					}catch(Exception e){}
					
					
                    /*PointOut(x,59-y);
                    if(x<59        ) picture[(x+1)+ y   *60] += (picture[x+y*60]*7)/16;
					if(x>0  && y<59) picture[(x-1)+(y+1)*60] += (picture[x+y*60]*3)/16;
					if(        y<59) picture[ x   +(y+1)*60] += (picture[x+y*60]*5)/16;
					if(x<59 && y<59) picture[(x+1)+(y+1)*60] += (picture[x+y*60]  )/16;*/

	 			}else{
	 				bitmap.setPixel(x, y, Color.WHITE);
	 				
	 				brightness = 255-brightness;
	 				brightness = -brightness;
	 				
					try{
						//bitmap.setPixel(x+1, y  , Color.red(bitmap.getPixel(x+1, y  ))+((brightness*7)/16));
						accu[x+1][y  ] = Color.red(bitmap.getPixel(x+1, y  ))+((brightness*7)/16);
					}catch(Exception e){}
					
					try{
						//bitmap.setPixel(x-1, y+1, Color.red(bitmap.getPixel(x-1, y+1))+((brightness*3)/16));
						accu[x-1][y+1] = Color.red(bitmap.getPixel(x-1, y+1))+((brightness*3)/16);
					}catch(Exception e){}
					
					try{
						//bitmap.setPixel(x  , y+1, Color.red(bitmap.getPixel(x  , y+1))+((brightness*5)/16));
						accu[x  ][y+1] = Color.red(bitmap.getPixel(x  , y+1))+((brightness*5)/16);
					}catch(Exception e){}
					
					try{
						//bitmap.setPixel(x+1, y+1, Color.red(bitmap.getPixel(x+1, y+1))+((brightness  )/16));
						accu[x+1][y+1] = Color.red(bitmap.getPixel(x+1, y+1))+((brightness  )/16);
					}catch(Exception e){}
	 				
	 				
                 	/*if(x<59        ) picture[(x+1)+ y   *60] -= (((0xFF - picture[x+y*60])*7)/16);
					if(x>0  && y<59) picture[(x-1)+(y+1)*60] -= (((0xFF - picture[x+y*60])*3)/16);
					if(        y<59) picture[ x   +(y+1)*60] -= (((0xFF - picture[x+y*60])*5)/16);
					if(x<59 && y<59) picture[(x+1)+(y+1)*60] -= (((0xFF - picture[x+y*60])  )/16);*/
				}
			}
		}
		return bitmap;
	}
	
	private Bitmap RGBtoBW(Bitmap bitmap){
		Bitmap.Config config = bitmap.getConfig();
		
		final int NR_OF_PIXELS = bitmap.getWidth()*bitmap.getHeight();
		int[] pixels = new int[NR_OF_PIXELS];
		float brightness;
		int pixel;
		
		final float R_WEIGHT = 0.2989f;
		final float G_WEIGHT = 0.5870f;
		final float B_WEIGHT = 0.1140f;
		final float THRESHOLD = 128;
		
		switch(config){
			case ARGB_8888:
				bitmap.getPixels(pixels, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
				for(int i=0; i<NR_OF_PIXELS ; i++){
					pixel = pixels[i];
					brightness = Color.red(pixel)*R_WEIGHT + Color.green(pixel)*G_WEIGHT +Color.blue(pixel)*B_WEIGHT;
					if(brightness > THRESHOLD){
						pixels[i] = Color.WHITE;
					}else{
						pixels[i] = Color.BLACK;
					}
				}
			break;
			default:
			break;
		}
		Bitmap ret = bitmap.copy(Bitmap.Config.ARGB_8888, true);
		ret.setPixels(pixels, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
		return ret;
	}
	
	
	protected void onActivityResult(int requestCode, int resultCode, Intent data){
		switch(requestCode){
			case REQUEST_ENABLE_BT:
				if(resultCode == RESULT_OK){
					//Set<BluetoothDevice> nxtDevices = nxtBluetooth.getPairedNxtDevices();
					//BluetoothDevice device = (BluetoothDevice)nxtDevices.toArray()[0];
					//try {
						//nxtBluetooth.connectToNxt(device);
					//} catch (IOException e) {
						// TODO Auto-generated catch block
					//	e.printStackTrace();
					//}
					//nxtBluetooth.doBeep();
					//nxtBluetooth.sendFile();
				}
			break;
			
		}
	}
}
