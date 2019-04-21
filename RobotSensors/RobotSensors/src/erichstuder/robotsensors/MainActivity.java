package erichstuder.robotsensors;

//import java.io.IOException;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Set;
import java.util.UUID;

import erichstuder.robotsensors.R;

import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.SurfaceView;

import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.widget.FrameLayout;
import android.widget.TextView;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothSocket;
//import android.bluetooth.;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;


public class MainActivity extends Activity implements SensorEventListener{ //implements SurfaceHolder.Callback{ //PictureCallback{


	
	
	private Camera mCamera;
    //private CameraPreview mPreview;
    private static final String TAG = "MainActivity";
    private BluetoothServer nxtBluetooth;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        
//        SensorManager sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
//        Sensor sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
//        sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_FASTEST);
        
        

    	//Log.v("onCreate","aaa"); 
        
        //nxtBluetooth = new NxtBluetooth();
        //nxtBluetooth.turnOnBluetooth(getApplicationContext());
        
        //Intent myIntent = new Intent(this, ImageProcessingActivity.class);
        //Intent myIntent = new Intent(this, PlayAroundActivity.class);
        Intent myIntent = new Intent(this, ControlledExtActivity.class);
        
        
        myIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        getApplicationContext().startActivity(myIntent);
        
        
        /*BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        
        mBluetoothAdapter.cancelDiscovery();
        
        Set<BluetoothDevice> BTDevices = mBluetoothAdapter.getBondedDevices();
        
        Log.v(TAG,"Number of Devices: "+BTDevices.size());
        
        Object[] BTArray = BTDevices.toArray();
        //for(int i = 0;i<BTDevices.size();i++){
        //	Log.v(TAG,"Number of Devices: "+((BluetoothDevice)BTArray[i]).toString());	
        //}
        
        BluetoothDevice nxt = (BluetoothDevice)BTArray[0];
        
        BluetoothSocket socket;
        OutputStream outStream;
        //
        try {
			//socket = nxt.createRfcommSocketToServiceRecord(UUID.fromString("1234"));
        	socket = nxt.createRfcommSocketToServiceRecord(UUID.fromString("00001101-0000-1000-8000-00805F9B34FB"));
        	
        	
			socket.connect();
			outStream = socket.getOutputStream();

			//byte data[] = {0x06,0x00,0x00,0x09,0x00,0x02,'A',0x00};
			byte data[] = {0x06,0x00,0x00,0x09,0x00,0x02,'A',0x00};
			
			//for(int i=0;i<10;i++){
				outStream.write(data);
			//}
			//outStream.write(123);
			outStream.flush();
			//outStream.close();
			//socket.close();
        } catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Log.v(TAG,"!!!!!!!!!!!!!!Nicht connected!!!!!!!!!!!!!!!");
		}*/
        

        
        /********Kamera Preview
        // Create an instance of Camera
        mCamera = this.getCameraInstance();
        // Create our Preview view and set it as the content of our activity.
        mPreview = new CameraPreview(this, mCamera);
        FrameLayout preview = (FrameLayout) findViewById(R.id.camera_preview);
        preview.addView(mPreview);
        *****************/
        
        
        
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	super.onCreateOptionsMenu(menu); //hinzugefüt am 19.11.12
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return true;
    }
    
    
    protected void onStart(){
    	super.onStart();
    	//Log.v("onStart","aaa"); 
    }
    
    protected void onRestart(){
    	super.onRestart();
    	//Log.v("onRestart","aaa");
    }

    protected void onResume(){
    	super.onResume();
    	//Log.v("onResume","aaa");
    }

    protected void onPause(){
    	//nxtBluetooth.iAmGone();
    	super.onPause();
    	//Log.v("onPause","aaa");
    }

    protected void onStop(){
    	super.onStop();
    	//Log.v("onStop","aaa");
    }
	
	public void onDestroy(){
		//Log.v("onDestroy","aaa");
		super.onDestroy();
	}
    
    /*public void onPictureTaken(byte[] data, Camera camera){
        //int a = Camera.getNumberOfCameras();
        //TextView textView = (TextView)findViewById(R.id.textView1);
        //textView.setTextSize(30f);
        //textView.setText("Daten erhalten"); //tCamera.getNumberOfCameras());
    }*/
    
    /** A safe way to get an instance of the Camera object. */
    /*public static Camera getCameraInstance(){
        Camera c = null;
        try {
            c = Camera.open(); // attempt to get a Camera instance
        }
        catch (Exception e){
            // Camera is not available (in use or does not exist)
        }
        return c; // returns null if camera is unavailable
    }*/

    
    public void onFound(BluetoothDevice device){
    	
    }
    
    public void onFinish(){
    	
    }
    
    public void onActivityResult(){
    	
    }

	@Override
	public void onAccuracyChanged(Sensor arg0, int arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onSensorChanged(SensorEvent event){
//		for(float value : event.values){
//			Log.v("erich",""+value);
//		}
//		Log.v("erich","___________");
	}
    
}


