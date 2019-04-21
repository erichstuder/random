package erichstuder.robotsensors;

import java.io.IOException;
import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.PreviewCallback;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

//grösstenteils kopiert von http://developer.android.com/guide/topics/media/camera.html
//E. Studer 30.10.12

/** A basic Camera preview class */
public class CameraPreview extends SurfaceView implements SurfaceHolder.Callback {
    private SurfaceHolder mHolder;
    private Camera mCamera;
    private int cameraId;
    //private int displayOrientation = 0;
    private PreviewCallback previewCallback = null;
    private static final String TAG = "CameraPreview"; //sinnvoll?

    //private int width = 0;
    //private int height = 0;
    
    public CameraPreview(Context context, int cameraId) {
        super(context);
        
        this.cameraId = cameraId;

        // Install a SurfaceHolder.Callback so we get notified when the
        // underlying surface is created and destroyed.
        mHolder = getHolder();
        mHolder.addCallback(this);

        // deprecated setting, but required on Android versions prior to 3.0 TODO
        //mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
    }
    
    
    /*public void setDisplayOrientation(int orientation){
    	if(mCamera == null){
    		this.displayOrientation = orientation;
    	}else{
    		mCamera.setDisplayOrientation(orientation);
    	}
    }*/
    
    public void setPreviewCallback(PreviewCallback previewCallback){
    	this.previewCallback = previewCallback;
    	
    	if(mCamera != null){
    		try{
    			mCamera.setPreviewCallback(previewCallback);
    		}catch(RuntimeException e){Log.v("setPreviewCallback",e.toString());}//probably: "Method called after release"
    	}
    }

    public void surfaceCreated(SurfaceHolder holder) {
        // The Surface has been created, now tell the camera where to draw the preview.
    	
    	Log.d(TAG, "surfaceCreated");
    	
    	//if(!this.isShown())return;

        try {
        	mCamera = Camera.open(cameraId);
        	
        	//Parameters params = mCamera.getParameters();
        	//params.setPreviewSize(176, 144);
        	//mCamera.setParameters(params);
        	
        	//mCamera.setDisplayOrientation(displayOrientation);
            mCamera.setPreviewDisplay(holder);
            mCamera.startPreview();
            
            /*Parameters params = mCamera.getParameters();
            mCamera.setDisplayOrientation(90);
            mCamera.setParameters(params);*/
            
            mCamera.setPreviewCallback(previewCallback);
            
            //Parameters params = mCamera.getParameters();
            //Log.v(TAG, "actual: height:"+params.getPreviewSize().height +"  width:"+params.getPreviewSize().width);
            /*List<Size> list = params.getSupportedPreviewSizes();
            for(Size s : list){
            	Log.v(TAG, "height:"+s.height +"  width:"+s.width);
            }*/
            //params.setPreviewSize(176, 144);
            
            //Camera.Parameters parameters = mCamera.getParameters();
            //parameters.setColorEffect(Camera.Parameters.EFFECT_SEPIA);
            //mCamera.setParameters(parameters);
            //Camera.Parameters.EFFECT_SEPIA
            
        } catch (IOException e) {
            Log.d(TAG, "Error setting camera preview1: " + e.getMessage());
        } catch (Exception e){
        	Log.d(TAG, "Error setting camera preview2: " + e.getMessage());
        }
    }
    
    /*public void startPreview(){
    	if(mCamera != null){
    		mCamera.startPreview();
    		//this.isRunning = true;
    	}
    }*/

    /*public void stopPreview(){
    	if(mCamera != null){
    		mCamera.stopPreview();
    	}
    }*/
    
    public void surfaceDestroyed(SurfaceHolder holder) {
    	Log.d(TAG, "surfaceDestroyed");
        /*try {
        	mCamera.setPreviewCallback(null);
        } catch (Exception e){
        	// ignore: tried to stop a non-existent camera
        }*/
    	
    	//mHolder.addCallback(null);
    	//Camera localCam = mCamera;
    	//mCamera = null;//verhindern, dass jemand startPreview aufrufen kann, wenn bereits stopPreview aufgerufen wurde.
    	
    	
    	
    	try {
    		mCamera.setPreviewCallback(null);
        } catch (Exception e){
          // ignore: tried to stop a non-existent preview
        }
    	
    	try {
    		mCamera.stopPreview();
        } catch (Exception e){
          // ignore: tried to stop a non-existent preview
        }
        
        try {
        	mCamera.release();
        } catch (Exception e){
          // ignore: tried to stop a non-existent camera
        }
        
        mCamera = null;
        
        Log.d(TAG, "surfaceDestroyed Ende");
        
    }

    public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {
    	
    	Log.d(TAG, "surfaceChanged");
    	
    	//width = w;
    	//height = h;
    	
        // If your preview can change or rotate, take care of those events here.
        // Make sure to stop the preview before resizing or reformatting it.

        /*if (mHolder.getSurface() == null){
          // preview surface does not exist
          return;
        }

        // stop preview before making changes
        try {
            mCamera.stopPreview();
        } catch (Exception e){
          // ignore: tried to stop a non-existent preview
        }

        // set preview size and make any resize, rotate or
        // reformatting changes here

        // start preview with new settings
        try {
            mCamera.setPreviewDisplay(mHolder);
            mCamera.startPreview();

        } catch (Exception e){
            Log.d(TAG, "Error starting camera preview: " + e.getMessage());
        }*/
    }
    
    /*public int getHeight(){
    	return height;
    }
    
    public int getWidth(){
    	return width;
    }*/
}