package erichstuder.robotsensors;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Random;
import java.util.UUID;

import erichstuder.robotsensors.BluetoothServer.BluetoothEventListener;
import erichstuder.robotsensors.R;
import erichstuder.robotsensors.SensorToolbox.SensorToolboxCallback;
import erichstuder.robotsensors.SpeechToText.SpeechRecognizerCallback;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.ImageFormat;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.hardware.Camera;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.Size;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.MediaRecorder;
import android.media.MediaRecorder.OnInfoListener;
import android.os.Bundle;
import android.os.Environment;
import android.os.PowerManager;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;


//Ad network-specific imports (AdMob).
import com.google.ads.Ad;
import com.google.ads.AdListener;
import com.google.ads.AdRequest;
import com.google.ads.AdView;
import com.google.ads.AdRequest.ErrorCode;

public class ControlledExtActivity extends Activity implements BluetoothEventListener, SensorToolboxCallback, SpeechRecognizerCallback{
	private SensorToolbox sensorToolbox;
	
	public final byte ROBOT_SENSORS_ID_1 = (byte) 0xEE;
	public final byte ROBOT_SENSORS_ID_2 = (byte) 0x00;
	

	private static final UUID SERIAL_PORT_SERVICE_CLASS_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
	
	private BluetoothServer bluetoothServer;
	
	//private static final int REQUEST_CODE = 1234;

	@Override
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
	    this.setContentView(R.layout.controlled_ext_activity);
	    
	    /**/
	    //FrameLayout previewLayout = (FrameLayout) findViewById(R.id.preview);
	    //previewLayout.setBackgroundColor(Color.RED);
	    /**/
	    
	    Eula.show(this);
	    
	    sensorToolbox = new SensorToolbox(this, this);
	    
	    /*debug*/
	    sensorToolbox.DEBUG();
	    /**/

	    this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);//TODO evtl. ins Layout verschieben
	    
	    
		bluetoothServer = new BluetoothServer(SERIAL_PORT_SERVICE_CLASS_UUID, this);
		bluetoothServer.setEventListener(this);
		bluetoothServer.start();
 
		
		String extStorageDirectory = Environment.getExternalStorageDirectory().getAbsolutePath();
		String extAppPath = extStorageDirectory + "/RobotSensors";
		File extAppDir = new File(extAppPath);
		if( ! extAppDir.exists()){
			extAppDir.mkdir(); 
		}
		
		//important files for documentation in the folder "assets"
		String fileNames[] = {"refman.pdf", "robotSensors.nxc", "example.nxc", "example_speech_recognition.nxc"};
		
		for(String fileName : fileNames){
			try {
				InputStream  in  = getAssets().open(fileName);
				OutputStream out = new FileOutputStream(extAppPath + "/" + fileName);
				byte[] buffer = new byte[1024];
		        int cnt;
		        while((cnt = in.read(buffer)) != -1){
		          out.write(buffer, 0, cnt);
		        }
		        in.close();
		        in = null;
		        out.flush();
		        out.close();
		        out = null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		//this.saveLogCat();
    	
		
		///debug
//		try {
//			new SpeechToText(this, this).start();
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		///debug
	}
	
	
	
	
    /**
     * Handle the results from the voice recognition activity.
     */
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data)
//    {
//        if (requestCode == REQUEST_CODE && resultCode == RESULT_OK)
//        {
//            // Populate the wordsList with the String values the recognition engine thought it heard
//            ArrayList<String> matches = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
//            //wordsList.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1,matches));
//            int i=0;
//            for(String s : matches){
//            	Log.v("erich","nr."+i+" text:"+s);
//            	i++;
//            }
//        }
//        super.onActivityResult(requestCode, resultCode, data);
//    }

    @Override
    protected void onStart(){
    	super.onStart();
    	//Log.v("erich","onStart"); 
    }
    
    @Override
    protected void onRestart(){
    	super.onRestart();
    	//nxtBluetooth.iAmBack();
    	//Log.v("erich","onRestart");
    }

    @Override
    protected void onResume(){
    	super.onResume();
    	//Log.v("erich","onResume");
    }
    
    @Override
    protected void onPause(){
    	//nxtBluetooth.iAmGone();
    	super.onPause();
    	//Log.v("erich","onPause");
    }
    
    @Override
    protected void onStop(){
    	super.onStop();
    	//Log.v("erich","onStop");
    }
	
    @Override
	public void onDestroy(){//TODO es ist nicht immer garantiert, dass onDestroy auch aufgerufen wird!!!
    	sensorToolbox.onDestroy();//TODO genauer
    	super.onDestroy();
		//partialWakeLock.release();
		//Log.v("erich","onDestroy");
	}
    
//    private void saveLogCat(){
//    	//http://stackoverflow.com/questions/6175002/write-android-logcat-data-to-a-file
//		try {
//			//Runtime.getRuntime().exec("logcat -c");
//			
//			String extStorageDirectory = Environment.getExternalStorageDirectory().getAbsolutePath();
//			String extAppPath = extStorageDirectory + "/RobotSensors";
//			//File extAppDir = new File(extAppPath);
//			
//			String fileName = "logcat.txt";
//		    
//			Log.v("erich","file machen");
//			File outputFile = new File(extAppPath,fileName);
//			
//			
//			// @SuppressWarnings("unused")
//			//Process process = Runtime.getRuntime().exec("logcat -f "+outputFile.getAbsolutePath());
//			Runtime.getRuntime().exec("logcat -f "+outputFile.getAbsolutePath());
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//    }
	
	
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.controlled_ext_activity_menu, menu);
        return true;
    }
    
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.documentation:
            	AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setMessage("Documentation can be found on the SD-Card in the folder 'RobotSensors'. Connect your smartphone to a computer. On the top level you will find the folder.");
                builder.create().show();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
    
    

	@Override
	public void onIncomingData(byte[] data){
		
		
		//TODO dieser Code sollte nicht hier stehen
		do{
			if(data.length >= 2){
				int size = data[0] + (data[1]<<8);
				data = Arrays.copyOfRange(data, 2, data.length);//längenangabe abschneiden
				
				if(data.length >= size){
					byte[] temp = Arrays.copyOfRange(data, 0, size);//nachricht herauskopieren
					data = Arrays.copyOfRange(data, size, data.length);//nachricht abschneiden
	
					if(temp.length>=2 && temp[0] == ROBOT_SENSORS_ID_1 && temp[1] == ROBOT_SENSORS_ID_2){
						sensorToolbox.request(Arrays.copyOfRange(temp, 2, temp.length));//ID abschneiden
					}
				}else{
					data = new byte[0];
				}
			}
		}while(data.length >= 2);	
	}


	@Override
	public void onRequestFinished(byte[] requestAnswer) {
		bluetoothServer.send(requestAnswer);
		
	}


	@Override
	public void onSpeechRecognized(String string) {
		for(String s : string.split(" ")){
			Log.v("erich", s);
		}
	}
    
}


