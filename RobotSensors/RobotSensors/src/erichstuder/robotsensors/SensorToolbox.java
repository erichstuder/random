/*!
 *   \cond
 */

package erichstuder.robotsensors;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.Locale;

import erichstuder.robotsensors.SpeechToText.SpeechRecognizerCallback;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.graphics.Bitmap.Config;
import android.hardware.Camera;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.Size;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Handler;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.widget.FrameLayout;
import android.widget.ImageView;


public class SensorToolbox implements SpeechRecognizerCallback {
	
	public final int PICTURE_ACCU_SIZE = 4;
	public final byte FRONT = 0x00;
	public final byte BACK = 0x01;
	
	private SensorToolboxCallback callback;
	private Activity activity;
	private RGB8888[] pictureAccu = null;
	private Camera camera = null;
	private SensorEventListener gyroscope_read_fast_event_listener=null;//TODO verallgemeinern
	
	
	//TODO private final Object wordBufferSync = new Object(); //TODO überall einsetzen
	private SpeechToText speechToText = null;
	private ArrayList<String> wordBuffer = null;
	
	//
	private long oldTimestamp;
	private double angle;
	private float oldValue;
	private float maxGravity;
	private double gravityAngle;

/*!
 *  \endcond
 */

	/*!
	 * \page modulDoc Moduls
	 * \anchor modulDocAnchor
	 */
	/*!
	 * \page cmdDoc Commands
	 * \anchor cmdDocAnchor
	 */ 
	/*!
	 * \page cmdStructure Telegram Structure
	 * Every telegram has the following structure:\n
	 * telegram size LSB; telegram size MSB; 0xEE; 0x00; \ref modulDocAnchor "Modul"; \ref cmdDocAnchor "Command"; additional data bytes\n
	 * \n
	 * In this chapter the telegram structure is documented.\n
	 * For every Modul all possible Comands are listed. 
	 */

	
	public static enum Modul{
		/*!
		 * \page modulDoc
		 * \section Camera Camera
		 * Represents the camera\n
		CAMERA = 0x00 */
		CAMERA  (0x00),
		
		/*!
		 * \page modulDoc
		 * \section PictureAccu Picture Accu
		 * Saves pictures and offers image-processing\n
		PICTURE_ACCU = 0x01 */
		PICTURE_ACCU  (0x01),
		
		/*!
		 * \page modulDoc
		 * \section Gyroscope Gyroscope
		 * Represents the gyroscope sensor\n
		GYROSCOPE = 0x04 */
		GYROSCOPE  (0x04),
		
		//TODO umbenennen in Main-Modul
		/*!
		 * \page modulDoc
		 * \section RobotSensors RobotSensors
		 * Represents the main-modul\n
		ROBOT_SENSORS = 0x05 */
		ROBOT_SENSORS  (0x05), //Main-Modul
		
		/*!
		 * \page modulDoc
		 * \section Microphone Microphone
		 * Represents the microphone\n
		MICROPHONE = 0x07 */
		MICROPHONE  (0x07),
		
		/*!
		 * \page modulDoc
		 * \section Brightness Brightness
		 * Represents the brightness sensor\n
		BRIGHTNESS = 0x08 */
		BRIGHTNESS  (0x08),
		
		/*!
		 * \page modulDoc
		 * \section Time Time
		 * Represents the internal watch\n
		TIME = 0x09 */
		TIME  (0x09),
		
		//ab V 1.1
		
		/*!
		 * \page modulDoc
		 * \section Accelerometer Accelerometer
		 * Represents the acceleration sensor\n
		ACCELEROMETER = 0x0A */
		ACCELEROMETER  (0x0A),

		/*!
		 * \page modulDoc
		 * \section MagneticField Magnetic Field
		 * Represents the magnetic field sensor\n
		MAGNETIC_FIELD = 0x0B */
		MAGNETIC_FIELD  (0x0B),
		
		/*!
		 * \page modulDoc
		 * \section Pressure Pressure
		 * Represents the pressure sensor\n
		PRESSURE = 0x0C */
		PRESSURE  (0x0C),
		
		/*!
		 * \page modulDoc
		 * \section Proximity Proximity
		 * Represents the proximity sensor\n
		PROXIMITY = 0x0D */
		PROXIMITY  (0x0D),
		
		//ab V 1.2
		
		/*!
		 * \page modulDoc
		 * \section RelativeHumidity Relative Humidity
		 * Represents the humidity sensor\n
		RELATIVE_HUMIDITY = 0x0E */
		RELATIVE_HUMIDITY  (0x0E),
		
		/*!
		 * \page modulDoc
		 * \section AmbientTemperature Ambient Temperature
		 * Represents the ambient temperature sensor\n
		AMBIENT_TEMPERATURE = 0x0F */
		AMBIENT_TEMPERATURE  (0x0F),
		
		
		/*!
		 * \page modulDoc
		 * \section SpeechRecognizer Speech Recognizer
		 * Represents the speech recognition\n
		SPEECH_RECOGNIZER = 0x10 */
		SPEECH_RECOGNIZER  (0x10);
		
		
		
		private byte value;
		
		private Modul(int value){this.value = (byte)value;}
		
		public byte toByte(){return value;}
		
		public static Modul toModul(int value){
			for(Modul modul : Modul.values()){
				if(modul.value == value) return modul;
			}
			return null;
		}
	};


	public static enum Cmd{
		
		/*!
		 * \page cmdDoc
		 * \section Read Read
		 * Reads a value\n
		READ = 0x00 */
		READ  (0x00),
		
		/*!
		 * \page cmdDoc
		 * \section StartReadFast Start Read Fast
		 * Starts a Read-Fast-Session\n
		 * Normally Robot Sensors is only answering once on a request. But after this command it will go on sending its data as fast as possible.\n 
		START_READ_FAST = 0x01 */
		START_READ_FAST  (0x01),
		
		/*!
		 * \page cmdDoc
		 * \section FastValue Fast Value
		 * Represents a value of a Read-Fast-Session \n
		FAST_VALUE = 0x02 */
		FAST_VALUE  (0x02),
		
		/*!
		 * \page cmdDoc
		 * \section Show Show
		SHOW = 0x03 */
		SHOW  (0x03),
		
		/*!
		 * \page cmdDoc
		 * \section Start Start
		START = 0x05 */
		START  (0x05),
		
		/*!
		 * \page cmdDoc
		 * \section BrightestPoint Brightest Point
		 * Calculates the point with the highest brightness\n
		BRIGHTEST_POINT = 0x06 */
		BRIGHTEST_POINT  (0x06),
		
		/*!
		 * \page cmdDoc
		 * \section Stop Stop
		STOP = 0x07 */
		STOP  (0x07),
		
		/*!
		 * \page cmdDoc
		 * \section LightOn Light On
		 * Turns the light on\n
		LIGHT_ON = 0x08 */
		LIGHT_ON  (0x08),
		
		/*!
		 * \page cmdDoc
		 * \section LightOff Light Off
		 * Turns the light off\n
		LIGHT_OFF = 0x09 */
		LIGHT_OFF  (0x09),
		
		/*!
		 * \page cmdDoc
		 * \section ReadNoiseLevel Read Noise Level
		 * Reads the noise level\n
		READ_NOISE_LEVEL = 0x0A */
		READ_NOISE_LEVEL  (0x0A),
		
		/*!
		 * \page cmdDoc
		 * \section MeanColor Mean Color
		 * Calculates the mean color\n
		MEAN_COLOR = 0x0B */
		MEAN_COLOR  (0x0B),
		
		/*!
		 * \page cmdDoc
		 * \section DarkestPoint Darkest Point
		 * Calculates the point with the lowest brightness\n
		DARKEST_POINT = 0x0C */
		DARKEST_POINT  (0x0C),
		
		/*!
		 * \page cmdDoc
		 * \section Cut Cut
		CUT = 0x0D */
		CUT  (0x0D),
		
		/*!
		 * \page cmdDoc
		 * \section Copy Copy
		COPY = 0x0E */
		COPY  (0x0E),
		
		/*!
		 * \page cmdDoc
		 * \section Subtract Subtract
		SUBTRACT = 0x0F */
		SUBTRACT  (0x0F);
		
		private byte value;
		
		private Cmd(int value){this.value = (byte)value;}
		
		public byte toByte(){return value;}
		
		public static Cmd toCmd(int value){
			for(Cmd cmd : Cmd.values()){
				if(cmd.value == value) return cmd;
			}
			return null;
		}
	};
	
	public static enum Status{
		SUCCESS(0x00),
		//ALREADY_RUNNING(0x02),
		ERROR(0x01);
		
		private byte value;
		private Status(int value){this.value = (byte)value;}
		public byte toByte(){return value;}
	};
	
	
	public static enum Mode{
		NORMAL     (0x00),
		HIGH_PASSED(0x01),
		LOW_PASSED (0x02);
		
		private byte value;
		private Mode(int value){this.value = (byte)value;}
		//public byte toByte(){return value;}
		
		public static Mode toMode(int value){
			for(Mode m : Mode.values()){
				if(value == m.value){
					return m;
				}
			}
			return null;
		}
	}
	
	
/*!
 *  \cond
 */
	
	public SensorToolbox(Activity activity, SensorToolboxCallback cb){
		if(activity == null) throw new NullPointerException("activity must not be null");
		this.activity = activity;
		if(cb == null) throw new NullPointerException("cb must not be null");
		this.callback = cb;
		
		this.pictureAccu = new RGB8888[PICTURE_ACCU_SIZE];
	}
	
	/*public void setCallback(SensorToolboxCallback cb){
		if(cb == null) throw new NullPointerException("cb must not be null");
		this.callback = cb;
	}*/
	
	public void request(byte[] data){

		//this.onIncomingData(data)
        if(data.length == 0){return;}//TODO notwendig???
        
        ByteArrayInputStream dataStream = new ByteArrayInputStream(data);

       
        
	    
	    Modul modul = Modul.toModul(dataStream.read());
	    Cmd cmd = Cmd.toCmd(dataStream.read());
/*!
 *  \endcond
 */	    
	    switch(modul){

	    /*!
	     *  \section GYROSCOPE
	     *  \ref Gyroscope
	     */
		case GYROSCOPE:
			switch(cmd){
			
		    /*!
		     *  \subsection GYROSCOPE_START_READ_FAST START_READ_FAST
		     *  \ref StartReadFast
		     */
			case START_READ_FAST:
				this.GYROSCOPE_START_READ_FAST();
				/*!
				 * \subsubsection GYROSCOPE_START_READ_FAST_RETURN return
				 * Returns either SUCCESS or ERROR
				 */
				break;
				
			/*!
		     *  \subsection GYROSCOPE_READ READ
		     *  \ref Read
		     */
			case READ:
				this.GYROSCOPE_READ();
				break;
			}
		break;
		
		/*!
	     *  \section CAMERA
	     *  \ref Camera
	     */
		case CAMERA:
			switch(cmd){
			
			/*!
		     *  \subsection CAMERA_READ READ
		     *  \ref Read
		     */
			case READ:
				this.CAMERA_READ(dataStream.read());
				break;
				
			/*!
		     *  \subsection CAMERA_START START
		     *  \ref Start
		     */
			case START:
				this.CAMERA_START(dataStream.read());
				break;
			
			/*!
		     *  \subsection CAMERA_STOP STOP
		     *  \ref Stop
		     */	
			case STOP:
				this.CAMERA_STOP();
				break;
				
			/*!
		     *  \subsection CAMERA_LIGHT_ON LIGHT_ON
		     *  \ref LightOn
		     */			
			case LIGHT_ON:
				this.CAMERA_LIGHT_ON();
				break;
				
			/*!
		     *  \subsection CAMERA_LIGHT_OFF LIGHT_OFF
		     *  \ref LightOff
		     */
			case LIGHT_OFF:
				this.CAMERA_LIGHT_OFF();
				break;
			}
		break;
		/*!
	     *  \section PICTURE_ACCU
	     *  \ref PictureAccu
	     */
		case PICTURE_ACCU:
			switch(cmd){
			
			/*!
		     *  \subsection PICTURE_ACCU_SHOW SHOW
		     *  \ref Show
		     */
			case SHOW:
				this.PICTURE_ACCU_SHOW(dataStream.read());
				break;
			
			/*!
		     *  \subsection PICTURE_ACCU_BRIGHTEST_POINT BRIGHTEST_POINT
		     *  \ref BrightestPoint
		     */
			case BRIGHTEST_POINT:
				this.PICTURE_ACCU_BRIGHTEST_POINT(dataStream.read());
				break;

			/*!
		     *  \subsection PICTURE_ACCU_DARKEST_POINT DARKEST_POINT
		     *  \ref DarkestPoint
		     */	
			case DARKEST_POINT:
				this.PICTURE_ACCU_DARKEST_POINT(dataStream.read());
				break;
			
			/*!
		     *  \subsection PICTURE_ACCU_MEAN_COLOR MEAN_COLOR
		     *  \ref MeanColor
		     */
			case MEAN_COLOR:
				this.PICTURE_ACCU_MEAN_COLOR(dataStream.read());
				break;

			/*!
		     *  \subsection PICTURE_ACCU_CUT CUT
		     *  \ref Cut
		     */
			case CUT:
				int accuIndex = dataStream.read();
				int left	= dataStream.read() + (dataStream.read() << 8);
				int right	= dataStream.read() + (dataStream.read() << 8);
				int top		= dataStream.read() + (dataStream.read() << 8);
				int bottom	= dataStream.read() + (dataStream.read() << 8);
				this.PICTURE_ACCU_CUT(accuIndex, left, right, top, bottom);
				break;
			
			/*!
		     *  \subsection PICTURE_ACCU_COPY COPY
		     *  \ref Copy
		     */
			case COPY:
				int source = dataStream.read();
				int target = dataStream.read();
				this.PICTURE_ACCU_COPY(source, target);
				break;
	        
			
				/*!
			     *  \subsection PICTURE_ACCU_COMPARE COMPARE
			     *  \ref Compare
			     */
			case SUBTRACT:
				int accuIndexA = dataStream.read();
				int accuIndexB = dataStream.read();
				this.PICTURE_ACCU_SUBTRACT(accuIndexA, accuIndexB);
				break;
			}
			
			
		break;
		/*!
	     *  \section MICROPHONE
	     *  \ref Microphone
	     */
		case MICROPHONE:
			switch(cmd){
			/*!
		     *  \subsection MICROPHONE_READ_NOISE_LEVEL READ_NOISE_LEVEL
		     *  \ref ReadNoiseLevel
		     */
			case READ_NOISE_LEVEL:
				this.MICROPHONE_READ_NOISE_LEVEL();
				break;
			}
		break;
		/*!
	     *  \section BRIGHTNESS
	     *  \ref Brightness
	     */
		case BRIGHTNESS:
			switch(cmd){
			/*!
		     * \subsection BRIGHTNESS_READ READ
		     * \ref Read
		     */
			case READ:	
				this.BRIGHTNESS_READ();
				break;
	    	}
		break;

		/*!
	     * \section TIME
	     * \ref Time
	     */
		case TIME:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection TIME_READ READ
		     * \ref Read
		     */
			case READ:
				this.TIME_READ();
				break;
			}
		break;
		
		//ab V 1.1
		
		/*!
	     * \section ACCELEROMETER
	     * \ref Accelerometer
	     */
		case ACCELEROMETER:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection ACCELEROMETER_READ READ
		     * \ref Read
		     */
			case READ:
				int mode = dataStream.read();
				this.ACCELEROMETER_READ(Mode.toMode(mode));
				break;
			}
		break;
		
		/*!
	     * \section MAGNETIC_FIELD
	     * \ref MagneticField
	     */
		case MAGNETIC_FIELD:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection MAGNETIC_FIELD_READ READ
		     * \ref Read
		     */
			case READ:
				this.MAGNETIC_FIELD_READ();
				break;
			}
		break;
		
		/*!
	     * \section PRESSURE
	     * \ref Pressure
	     */
		case PRESSURE:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection PRESSURE_READ READ
		     * \ref Read
		     */
			case READ:
				this.PRESSURE_READ();
				break;
			}
		break;
		
		/*!
	     * \section PROXIMITY
	     * \ref Proximity
	     */
		case PROXIMITY:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection PROXIMITY_READ READ
		     * \ref Read
		     */
			case READ:
				callCallback(Modul.PROXIMITY, Cmd.READ, Status.ERROR); //Workaround
				//this.PROXIMITY_READ();
				break;
			}
		break;
		
		/*!
	     * \section RELATIVE_HUMIDITY
	     * \ref RelativeHumidity
	     */
		case RELATIVE_HUMIDITY:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection RELATIVE_HUMIDITY_READ READ
		     * \ref Read
		     */
			case READ:
				this.RELATIVE_HUMIDITY_READ();
				break;
			}
		break;
		
		/*!
	     * \section AMBIENT_TEMPERATURE
	     * \ref AmbientTemperature
	     */
		case AMBIENT_TEMPERATURE:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection AMBIENT_TEMPERATURE_READ READ
		     * \ref Read
		     */
			case READ:
				this.AMBIENT_TEMPERATURE_READ();
				break;
			}
		break;

		/*!
	     * \section AMBIENT_TEMPERATURE
	     * \ref AmbientTemperature
	     */
		case SPEECH_RECOGNIZER:
			switch(cmd){
			/*!
			 * \page cmdStructure
		     * \subsection SPEECH_RECOGNIZER_START START
		     * \ref Start
		     */
			case START:
				this.SPEECH_RECOGNIZER_START();
				break;

			/*!
			 * \page cmdStructure
		     * \subsection SPEECH_RECOGNIZER_STOP STOP
		     * \ref Stop
		     */
			case STOP:
				this.SPEECH_RECOGNIZER_STOP();
				break;

		    /*!
			 * \page cmdStructure
		     * \subsection SPEECH_RECOGNIZER_READ READ
		     * \ref Read
		     */
			case READ:
				this.SPEECH_RECOGNIZER_READ();
				break;
			}
		break;
	    }
	}
	
/*!
 *   \cond	
 */
////////////////////////////////////////////////////////////////
	
	private void BRIGHTNESS_READ(){
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					int lux = Math.round(event.values[0]); //bisher wurden allerdings nie Kommastellen beobachtet.
					long timestampMs32bit = event.timestamp/1000000;
					
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					
					data.write(lux);
					data.write(lux >>> 8);
					
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		
		standardSensor(Sensor.TYPE_LIGHT, Modul.BRIGHTNESS, Cmd.READ, dataArranger);
	}
	
	
	private void MICROPHONE_READ_NOISE_LEVEL(){
        try {
        	final MediaRecorder recorder = new MediaRecorder();
    		recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
    		//recorder.setOutputFile("/dev/null");
    		recorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP); 
    		recorder.setOutputFile("/dev/null");
    		recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
        	
			recorder.prepare();
			recorder.start();
			recorder.getMaxAmplitude();//LautstärkenMessung starten
			
			new Thread(new Runnable(){

				@Override
				public void run() {
					try {
						Thread.sleep(100);//ausgepröbelt
					} catch (InterruptedException e1) {
						e1.printStackTrace(); //dürfte gar nie passieren
					}
					int amplitude = recorder.getMaxAmplitude();
					recorder.stop();
					recorder.release();
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					data.write((byte) amplitude       );
					data.write((byte)(amplitude >>> 8));

					callCallback(Modul.MICROPHONE, Cmd.READ_NOISE_LEVEL, Status.SUCCESS, data.toByteArray());
					//Log.v("erich",""+amplitude);
//					if(amplitude > 32767){//im internet stand in einigen Foren, dass 32767 das Maximum sei => bei meinem Handy HTC ONE S auch (gemessen)	
//					}
					
				}}).start();
		} catch (IllegalStateException e1) {
			e1.printStackTrace();
			callCallback(Modul.MICROPHONE, Cmd.READ_NOISE_LEVEL, Status.ERROR);
		} catch (IOException e1) {
			e1.printStackTrace();
			callCallback(Modul.MICROPHONE, Cmd.READ_NOISE_LEVEL, Status.ERROR);
		} catch (RuntimeException e){
			e.printStackTrace();
			callCallback(Modul.MICROPHONE, Cmd.READ_NOISE_LEVEL, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_CUT(int accuIndex, int left, int right, int top, int bottom){
		if(pictureAccu != null && accuIndex >= 0 && accuIndex < PICTURE_ACCU_SIZE && pictureAccu[accuIndex] != null){
			try {
				ImageToolbox.cut(pictureAccu[accuIndex], left, right, top, bottom);
				callCallback(Modul.PICTURE_ACCU, Cmd.CUT, Status.SUCCESS);
			} catch (Exception e) {
				callCallback(Modul.PICTURE_ACCU, Cmd.CUT, Status.ERROR);
				e.printStackTrace();
			}
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.CUT, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_COPY(int source, int target){
		if(source >= 0 && source < PICTURE_ACCU_SIZE && target >= 0 && target < PICTURE_ACCU_SIZE){
			pictureAccu[target] = new RGB8888(pictureAccu[source]);//null ist kein problem
			callCallback(Modul.PICTURE_ACCU, Cmd.COPY, Status.SUCCESS);
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.COPY, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_SUBTRACT(int accuIndexA, int accuIndexB){
		if(accuIndexA >= 0 && accuIndexA < PICTURE_ACCU_SIZE && accuIndexB >= 0 && accuIndexB < PICTURE_ACCU_SIZE){//TODO pictureAccu könnte null sein!
			if( ImageToolbox.subtract(pictureAccu[accuIndexA], pictureAccu[accuIndexB]) >= 0){
				callCallback(Modul.PICTURE_ACCU, Cmd.SUBTRACT, Status.SUCCESS);
			}else{
				callCallback(Modul.PICTURE_ACCU, Cmd.SUBTRACT, Status.ERROR);
			}
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.SUBTRACT, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_MEAN_COLOR(int accuIndex){
		if(pictureAccu != null && accuIndex >= 0 && accuIndex < PICTURE_ACCU_SIZE && pictureAccu[accuIndex] != null){
			int[] meanColor = ImageToolbox.meanColor(pictureAccu[accuIndex]);
			if(meanColor != null){
				byte[] data = {
						(byte) meanColor[0],
						(byte) meanColor[1],
						(byte) meanColor[2],
				};
				callCallback(Modul.PICTURE_ACCU, Cmd.MEAN_COLOR, Status.SUCCESS, data);
			}else{
				callCallback(Modul.PICTURE_ACCU, Cmd.MEAN_COLOR, Status.ERROR);
			}
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.MEAN_COLOR, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_DARKEST_POINT(int accuIndex){
		if(pictureAccu != null && accuIndex >= 0 && accuIndex < PICTURE_ACCU_SIZE && pictureAccu[accuIndex] != null){
			RGB8888 image = pictureAccu[accuIndex];
			int width = image.getWidth();
			int height = image.getHeight();
			Point pt = new Point();
			Float intensity = ImageToolbox.darkestPoint(image, pt);
			if(intensity >= 0){
				byte[] data = {
						(byte) width,
						(byte)(width >>> 8),
						(byte) height,
						(byte)(height >>> 8),
						(byte) pt.x,
						(byte)(pt.x >>> 8),
						(byte) pt.y,
						(byte)(pt.y >>> 8),
						(byte)Math.round(intensity),
				};
				callCallback(Modul.PICTURE_ACCU, Cmd.DARKEST_POINT, Status.SUCCESS, data);
			}else{
				callCallback(Modul.PICTURE_ACCU, Cmd.DARKEST_POINT, Status.ERROR);
			}
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.DARKEST_POINT, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_BRIGHTEST_POINT(int accuIndex){
		if(pictureAccu != null && accuIndex >= 0 && accuIndex < PICTURE_ACCU_SIZE && pictureAccu[accuIndex] != null){
			RGB8888 image = pictureAccu[accuIndex];
			int width = image.getWidth();
			int height = image.getHeight();
			Point pt = new Point();
			Float intensity = ImageToolbox.brightestPoint(image, pt);
			if(intensity >= 0){
				byte[] data = {
						(byte) width,
						(byte)(width >>> 8),
						(byte) height,
						(byte)(height >>> 8),
						(byte) pt.x,
						(byte)(pt.x >>> 8),
						(byte) pt.y,
						(byte)(pt.y >>> 8),
						(byte)Math.round(intensity),
				};
				callCallback(Modul.PICTURE_ACCU, Cmd.BRIGHTEST_POINT, Status.SUCCESS, data);
			}else{
				callCallback(Modul.PICTURE_ACCU, Cmd.BRIGHTEST_POINT, Status.ERROR);
			}
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.BRIGHTEST_POINT, Status.ERROR);
		}
	}
	
	private void PICTURE_ACCU_SHOW(int accuIndex){
		//int accuIndex = dataStream.read();
		
		if(pictureAccu != null && accuIndex >= 0 && accuIndex < PICTURE_ACCU_SIZE && pictureAccu[accuIndex] != null && activity != null){
			
			RGB8888 image = pictureAccu[accuIndex];
			
			final ImageView previewImageView = new ImageView(activity);
			
			previewImageView.setImageBitmap(Bitmap.createBitmap(image.getData(), image.getWidth(), image.getHeight(), Config.ARGB_8888));

			activity.runOnUiThread(new Runnable(){
				@Override
				public void run() {
					FrameLayout previewLayout = (FrameLayout) activity.findViewById(R.id.preview);
					previewLayout.removeAllViews();
    				previewLayout.addView(previewImageView);
    				callCallback(Modul.PICTURE_ACCU, Cmd.SHOW, Status.SUCCESS);
				}
			});
		}else{
			callCallback(Modul.PICTURE_ACCU, Cmd.SHOW, Status.ERROR);
		}
	}
	    
	private void CAMERA_LIGHT_OFF(){
		if(camera != null){
			try{
				Parameters params = camera.getParameters();
				params.setFlashMode(Parameters.FLASH_MODE_OFF);
				camera.setParameters(params);
				callCallback(Modul.CAMERA, Cmd.LIGHT_OFF, Status.SUCCESS);
			}catch(RuntimeException e){//probably when camera has no LED (e.g. front camera)
				callCallback(Modul.CAMERA, Cmd.LIGHT_OFF, Status.ERROR);
			}
		}else{
			callCallback(Modul.CAMERA, Cmd.LIGHT_OFF, Status.ERROR);
		}
		
	}
	private void CAMERA_LIGHT_ON(){
		if(camera != null){
			try{
				Parameters params = camera.getParameters();
				params.setFlashMode(Parameters.FLASH_MODE_TORCH);
				camera.setParameters(params);
				callCallback(Modul.CAMERA, Cmd.LIGHT_ON, Status.SUCCESS);
			}catch(RuntimeException e){//probably when camera has no LED (e.g. front camera)
				callCallback(Modul.CAMERA, Cmd.LIGHT_ON, Status.ERROR);
			}
		}else{
			callCallback(Modul.CAMERA, Cmd.LIGHT_ON, Status.ERROR);
		}
	}
	
	private void CAMERA_STOP(){
		activity.runOnUiThread(new Runnable(){
			@Override
			public void run() {
				//wozu werden die views zuerst entfernt?
				//Weil es sein könnte, dass das App aus dem Ruhezustand wieder hervorgeholt wird. (siehe weiter unten)
				//Preview würde nach "release()" wieder gestartet => "java.lang.RuntimeException: Method called after release()".
				//(allenfalls weiter unten bei onDestroy auch noch ergänzen)
				FrameLayout dummyPreview = (FrameLayout) activity.findViewById(R.id.dummyPreview);
				dummyPreview.removeAllViews(); //==> sollte im optimalen Fall surfaceDestroyed(...) auslösen
				//Log.v("erich","wurde surfaceDestroyed vorher ausgelöst?"); //TODO funktioniert das jetzt???
				if(camera != null){
					try {
			    		camera.stopPreview();
			        } catch (Exception e){/*ignore: tried to stop a non-existent preview*/}
			        
			        try {
			        	camera.release();
			        } catch (Exception e){/*ignore: tried to release a non-existent camera*/}
			        
					camera = null;
				}
				callCallback(Modul.CAMERA, Cmd.STOP, Status.SUCCESS);
			}
		});
	}
	    
	private void CAMERA_START(int cameraIdentifier){
		
		final int cameraId;

		if(cameraIdentifier == FRONT){//facingFront camera
			cameraId = firstCamera(true);
		}else if(cameraIdentifier == BACK){//facingBack camera
			cameraId = firstCamera(false);
		}else{
			cameraId = cameraIdentifier;//CAMERA_INDEX
		}
		
		if(cameraId>=0 && cameraId<Camera.getNumberOfCameras() && camera==null && activity != null){
			activity.runOnUiThread(new Runnable(){
				@Override
				public void run() {
					camera = Camera.open(cameraId);
					
					SurfaceView surfaceView = new SurfaceView(activity);
					
					FrameLayout dummyPreview = (FrameLayout) activity.findViewById(R.id.dummyPreview);
		        	dummyPreview.addView(surfaceView);
		        	SurfaceHolder surfaceHolder = surfaceView.getHolder();
		        	
					surfaceHolder.addCallback(new SurfaceHolder.Callback() {
						
						@Override
						public void surfaceDestroyed(SurfaceHolder holder) {
					    	if(camera != null){
								try {
						    		camera.stopPreview();
						        } catch (Exception e){/*ignore: tried to stop a non-existent preview*/}
					    	}
//					        try {
//					        	//Log.v("erich","surfaceHolder camera.release()");
//					        	camera.release();
//					        } catch (Exception e){/*ignore: tried to release a non-existent camera*/}
//					        
//					        camera = null;
						}
						
						@Override
						public void surfaceCreated(SurfaceHolder holder) {
							if(camera != null){
								try {
									camera.setPreviewDisplay(holder);
									camera.startPreview();
								} catch (IOException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}

//							try {
//								Log.v("erich","try to get camera");
//								camera = Camera.open(cameraId);
//								//Parameters params = camera.getParameters();
//								//params.setFocusMode(Parameters.FOCUS_MODE_MACRO);
//								//camera.setParameters(params);
//								camera.setPreviewDisplay(holder);
//								camera.startPreview();
//
//								callCallback(Modul.CAMERA, Cmd.START, Status.SUCCESS);
//								//Log.v("erich","camera gestartet");
//							} catch (IOException e) {
//								// TODO Auto-generated catch block
//								e.printStackTrace();
//								callCallback(Modul.CAMERA, Cmd.START, Status.ERROR);
//							}
						}
						
						@Override
						public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {/*TODO Auto-generated method stub*/}
					});
					callCallback(Modul.CAMERA, Cmd.START, Status.SUCCESS);
				}
			});
		}else{
			callCallback(Modul.CAMERA, Cmd.START, Status.ERROR);
			//Log.v("erich","Fehler in camera start");
		}
	}
	
	
	private void CAMERA_READ(final int accuIndex){
		
		if(pictureAccu!= null && accuIndex >= 0 && accuIndex < PICTURE_ACCU_SIZE && camera != null){
			
			//camera.autoFocus(null);//TODO evtl warten bis fertig
			
			camera.setOneShotPreviewCallback(new PreviewCallback(){
				@Override
				public void onPreviewFrame(byte[] data, Camera camera) {
					Size previewSize = camera.getParameters().getPreviewSize();
					int width = previewSize.width;
					int height = previewSize.height;

					pictureAccu[accuIndex] = new RGB8888(ImageToolbox.convertYUV420_NV21toRGB8888(data, width, height),width, height);

					byte[] message = {
						(byte) width,
						(byte)(width >>> 8),
						(byte) height,
						(byte)(height >>> 8)
					};
					callCallback(Modul.CAMERA, Cmd.READ, Status.SUCCESS, message);
				}
				
			});

		}else{
			callCallback(Modul.CAMERA, Cmd.READ, Status.ERROR);
			//Log.v("erich","Aufnahmefehler");
		}
	}
	
	
	private void ACCELEROMETER_READ(Mode mode){
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					for(float v : event.values){
						int a_cm = Math.round(v * 100);//Wandlung auf cm/s^2
						data.write((byte) a_cm       );
						data.write((byte)(a_cm >>> 8));
					}
					
					long timestampMs32bit = event.timestamp/1000000;
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		switch(mode){
		case NORMAL:
			standardSensor(Sensor.TYPE_ACCELEROMETER, Modul.ACCELEROMETER, Cmd.READ, dataArranger);	
			break;
		case HIGH_PASSED:
			standardSensor(Sensor.TYPE_LINEAR_ACCELERATION, Modul.ACCELEROMETER, Cmd.READ, dataArranger);	
			break;
		case LOW_PASSED:
			standardSensor(Sensor.TYPE_GRAVITY, Modul.ACCELEROMETER, Cmd.READ, dataArranger);	
			break;
		default:
			callCallback(Modul.ACCELEROMETER, Cmd.READ, Status.ERROR);
			break;
		}
		
	}
	
	
	private void MAGNETIC_FIELD_READ(){
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					for(float v : event.values){
						int b = Math.round(v * 100);//Skalierung um uT * 100
						data.write((byte) b       );
						data.write((byte)(b >>> 8));
					}
					
					long timestampMs32bit = event.timestamp/1000000;
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		
		standardSensor(Sensor.TYPE_MAGNETIC_FIELD, Modul.MAGNETIC_FIELD, Cmd.READ, dataArranger);	
	}
	
	
	private void PRESSURE_READ(){
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					int p = Math.round(event.values[0]);//in hPa = millibar
					data.write((byte) p       );
					data.write((byte)(p >>> 8));
					
					long timestampMs32bit = event.timestamp/1000000;
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		
		standardSensor(Sensor.TYPE_PRESSURE, Modul.PRESSURE, Cmd.READ, dataArranger);	
	}
	
//	//erster Wert ist default Wert (HTC ONE S: 9cm). Und bei binären Werten 0 oder 9cm ändert das signal nicht oft.
//	//allenfalls mit proximityStart lösen
//	private void PROXIMITY_READ(){
//		DataArranger dataArranger = new DataArranger(){
//			@Override
//			public byte[] arrange(SensorEvent event) {
//
//				try {
//					ByteArrayOutputStream data = new ByteArrayOutputStream();
//					int d = Math.round(10 * event.values[0]);//Wandlung in mm
//					data.write((byte) d       );
//					data.write((byte)(d >>> 8));
//					
//					long timestampMs32bit = event.timestamp/1000000;
//					data.write(longTo4ByteArray(timestampMs32bit));
//					
//					return data.toByteArray();
//					
//				} catch (IOException e) {
//					e.printStackTrace();
//					return null;
//				}
//			}
//		};
//		
//		standardSensor(Sensor.TYPE_PROXIMITY, Modul.PROXIMITY, Cmd.READ, dataArranger);	
//	}
	
	
	private void RELATIVE_HUMIDITY_READ(){
		
		if (android.os.Build.VERSION.SDK_INT < 14) {//dieser Sensor ist erst ab Api Level 14 verfügbar
			callCallback(Modul.RELATIVE_HUMIDITY, Cmd.READ, Status.ERROR);
			return;
		}
			
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					int rH = Math.round(100 * event.values[0]);//Faktor 100 => 10000 = 100.00%
					data.write((byte) rH       );
					data.write((byte)(rH >>> 8));
					
					long timestampMs32bit = event.timestamp/1000000;
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		
		standardSensor(Sensor.TYPE_RELATIVE_HUMIDITY, Modul.RELATIVE_HUMIDITY, Cmd.READ, dataArranger);
	}

	
	//komplexer Sensor. im Moment weggelassen
	//private void ROTATION_VECTOR_READ(){} //Important note: For historical reasons the roll angle is positive in the clockwise direction (mathematically speaking, it should be positive in the counter-clockwise direction). 	
	
	//komplexer Sensor. im Moment weggelassen
	//private void ORIENTATION_READ(){}
		
	private void AMBIENT_TEMPERATURE_READ(){		
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					
					int temp = Math.round(event.values[0] * 100);//Wandlung auf Celsius*10^-2
					data.write((byte) temp       );
					data.write((byte)(temp >>> 8));
					
					long timestampMs32bit = event.timestamp/1000000;
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		
		if(android.os.Build.VERSION.SDK_INT < 3){
			callCallback(Modul.AMBIENT_TEMPERATURE, Cmd.READ, Status.ERROR);
		}else if (android.os.Build.VERSION.SDK_INT < 14) {
			//dieser Sensor ist erst ab Api Level 3 verfügbar
			standardSensor(Sensor.TYPE_TEMPERATURE, Modul.AMBIENT_TEMPERATURE, Cmd.READ, dataArranger);
		}else{
			//dieser Sensor ist erst ab Api Level 14 verfügbar
			standardSensor(Sensor.TYPE_AMBIENT_TEMPERATURE, Modul.AMBIENT_TEMPERATURE, Cmd.READ, dataArranger);	
		}
	}
	
	
	private void GYROSCOPE_READ(){
		DataArranger dataArranger = new DataArranger(){
			@Override
			public byte[] arrange(SensorEvent event) {

				try {
					ByteArrayOutputStream data = new ByteArrayOutputStream();
					for(float v : event.values){
						int v_deg = Math.round(v/((float)(2*Math.PI))*360);
						data.write((byte) v_deg       );
						data.write((byte)(v_deg >>> 8));
					}
					
					long timestampMs32bit = event.timestamp/1000000;
					data.write(longTo4ByteArray(timestampMs32bit));
					
					return data.toByteArray();
					
				} catch (IOException e) {
					e.printStackTrace();
					return null;
				}
			}
		};
		
		standardSensor(Sensor.TYPE_GYROSCOPE, Modul.GYROSCOPE, Cmd.READ, dataArranger);	
	}
	
	private void GYROSCOPE_START_READ_FAST(){
		if(gyroscope_read_fast_event_listener == null){
			SensorManager sensorManager = (SensorManager) activity.getSystemService(Context.SENSOR_SERVICE);
			Sensor sensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
			
	        gyroscope_read_fast_event_listener = new SensorEventListener(){
				public void onAccuracyChanged(Sensor sensor, int accuracy) {}
	
				public void onSensorChanged(SensorEvent event){
					try {
						ByteArrayOutputStream data = new ByteArrayOutputStream();
						for(float v : event.values){
							int v_deg = Math.round(v/((float)(2*Math.PI))*360);
							data.write((byte) v_deg       );
							data.write((byte)(v_deg >>> 8));
						}
						long timestampMs32bit = event.timestamp/1000000;
						data.write(longTo4ByteArray(timestampMs32bit));
						callCallback(Modul.GYROSCOPE, Cmd.FAST_VALUE, Status.SUCCESS, data.toByteArray());
					} catch (IOException e) {
						e.printStackTrace();
						callCallback(Modul.GYROSCOPE, Cmd.FAST_VALUE, Status.ERROR);
					}
					
	        	}
	        };
	        
	        sensorManager.registerListener(	gyroscope_read_fast_event_listener,
						    		        sensor,
						    		        SensorManager.SENSOR_DELAY_FASTEST);
	        callCallback(Modul.GYROSCOPE, Cmd.START_READ_FAST, Status.SUCCESS);
        }else{
        	callCallback(Modul.GYROSCOPE, Cmd.START_READ_FAST, Status.ERROR);
        }	
		
	}
	
	//for debugging only
	public void DEBUG(){
		if(gyroscope_read_fast_event_listener == null){
			SensorManager sensorManager = (SensorManager) activity.getSystemService(Context.SENSOR_SERVICE);
			//final Sensor gyroscopeSensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
			final Sensor gyroscopeSensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
			
			final Sensor gravitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY);
			
			oldTimestamp = 0;
			angle=0;
			oldValue=0.0f;
			
	        gyroscope_read_fast_event_listener = new SensorEventListener(){
				public void onAccuracyChanged(Sensor sensor, int accuracy) {}
	
				public void onSensorChanged(SensorEvent event){
					FrameLayout previewLayout = (FrameLayout) activity.findViewById(R.id.preview);
//					int val = Math.round(event.values[0]/((float)(2*Math.PI))*360);
//					if(val > 127) val=127;
//					if(val < -128) val = -128;
//					val += 128;
					
					if(event.sensor.equals(gravitySensor)){
//						Log.v("erich","maxGravity: "+Math.sqrt(event.values[0]*event.values[0]+event.values[1]*event.values[1]+event.values[2]*event.values[2]));
//						Log.v("erich","gravity x: "+event.values[0]);
						//Log.v("erich","gravity y: "+event.values[1]);
//						Log.v("erich","gravity z: "+event.values[2]);
						double temp = event.values[1]/9.81;
						if(temp > 1) temp  = 1;
						if(temp < -1) temp =-1;
						gravityAngle = Math.asin(temp)/(2*Math.PI)*360;
					}
					
					if(event.sensor.equals(gyroscopeSensor) ){
						//allenfalls durch laufenden mittelwert korrigieren
//						if(oldTimestamp != 0){
//							double temp = ((event.timestamp-oldTimestamp)*(event.values[0] + 5.326322E-7f));
//							angle += (temp*360)/(2*Math.PI*1e9);
//							
//						}
						
						//double delta = gravityAngle - angle;
						//angle += 0.05*delta;
						
						//Log.v("erich", "angle: "+angle);
						
					    //oldValue = event.values[0] + 5.326322E-7f;
						//oldTimestamp = event.timestamp;
						
						
						//int val = (int)(angle+128);
						int val = (int)(event.values[1]*10+128);
						
						if(val > 255) val=255;
						if(val < 0  ) val=  0;
					    previewLayout.setBackgroundColor(0xff000000 | val << 16 | val << 8 | val);
					}
					
					
					
//					if(angle > 1){
//						Log.v("erich", "grösser 1: "+event.timestamp);
//						Log.v("erich", "grösser 1: "+oldTimestamp);
//						Log.v("erich", "grösser 1: "+event.values[0]);
//						
//					}
					

				    
				    
	        	}
	        };
	        
	        sensorManager.registerListener(	gyroscope_read_fast_event_listener,
						    		        gyroscopeSensor,
						    		        SensorManager.SENSOR_DELAY_FASTEST);
	        
//	        sensorManager.registerListener(	gyroscope_read_fast_event_listener,
//	        								gravitySensor,
//	        								SensorManager.SENSOR_DELAY_FASTEST);
        }
	}
	
	private void TIME_READ(){
		GregorianCalendar calendar = new GregorianCalendar();
		int year      = calendar.get(GregorianCalendar.YEAR);
		int month     = calendar.get(GregorianCalendar.MONTH);
		int day       = calendar.get(GregorianCalendar.DAY_OF_MONTH);
		int dayOfWeek = calendar.get(GregorianCalendar.DAY_OF_WEEK);
		int hour      = calendar.get(GregorianCalendar.HOUR_OF_DAY);
		int minute    = calendar.get(GregorianCalendar.MINUTE);
		int second    = calendar.get(GregorianCalendar.SECOND);
		int millis    = calendar.get(GregorianCalendar.MILLISECOND);
		
		ByteArrayOutputStream data = new ByteArrayOutputStream();
		data.write((byte) year         );
		data.write((byte)(year >>> 8  ));
		data.write((byte) month        );
		data.write((byte) day          );
		data.write((byte) dayOfWeek    );
		data.write((byte) hour         );
		data.write((byte) minute       );
		data.write((byte) second       );
		data.write((byte) millis       );
		data.write((byte)(millis >>> 8));
		
		callCallback(Modul.TIME, Cmd.READ, Status.SUCCESS, data.toByteArray());
	}
	
	
	private void SPEECH_RECOGNIZER_START(){
		//run in main thread
		Handler mainHandler = new Handler(activity.getMainLooper());
		
		final SensorToolbox sensorToolbox = this;
		mainHandler.post(new Runnable(){
			@Override
			public void run() {
				try {
					if(speechToText == null){
						speechToText = new SpeechToText(activity,sensorToolbox);
					}
					speechToText.start();
					synchronized(sensorToolbox){
						wordBuffer = new ArrayList<String>();
					}
					
					callCallback(Modul.SPEECH_RECOGNIZER, Cmd.START, Status.SUCCESS);
				} catch (Exception e) {
					e.printStackTrace();
					callCallback(Modul.SPEECH_RECOGNIZER, Cmd.START, Status.ERROR);
				}
			}
		});	
	}
	
	
	private void SPEECH_RECOGNIZER_STOP(){
		//run in main thread
		Handler mainHandler = new Handler(activity.getMainLooper());
		
		final SensorToolbox sensorToolbox = this;
		mainHandler.post(new Runnable(){
			@Override
			public void run() {
				try {
					if(speechToText != null){
						speechToText.stop();
					}
					
					synchronized(sensorToolbox){
						wordBuffer = null;
					}
					
					callCallback(Modul.SPEECH_RECOGNIZER, Cmd.STOP, Status.SUCCESS);
				} catch (Exception e) {
					e.printStackTrace();
					callCallback(Modul.SPEECH_RECOGNIZER, Cmd.STOP, Status.ERROR);
				}
			}
		});
		
		//callCallback(Modul.SPEECH_RECOGNIZER, Cmd.STOP, Status.SUCCESS);
	}
	
	private void SPEECH_RECOGNIZER_READ(){
		synchronized(this){
			if(wordBuffer != null && wordBuffer.size()>0){
				try {
					ByteArrayOutputStream word = new ByteArrayOutputStream();
					
					word.write(wordBuffer.get(0).getBytes());
					word.write(0);
					
					callCallback(Modul.SPEECH_RECOGNIZER, Cmd.READ, Status.SUCCESS, word.toByteArray());//was steht am ende des strings?
					//wordBuffer.
					//wordBuffer = new ArrayList<String>(wordBuffer.subList(1, wordBuffer.size()));
					//ByteArrayOutputStream
					
					wordBuffer = new ArrayList<String>(wordBuffer.subList(1, wordBuffer.size()));
				} catch (IOException e) {
					e.printStackTrace();
					callCallback(Modul.SPEECH_RECOGNIZER, Cmd.READ, Status.ERROR);
				}
			}else{
				callCallback(Modul.SPEECH_RECOGNIZER, Cmd.READ, Status.ERROR);
			}
		}
	}
	
	private void callCallback(Modul modul, Cmd cmd, Status status){
		callCallback(modul,cmd,status,null);
	}
	
	private void callCallback(Modul modul, Cmd cmd, Status status, byte[] data){
		//if(modul == null || cmd == null || status == null) return; //TODO
		
		try {
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			baos.write(modul.toByte());
			baos.write(cmd.toByte());
			baos.write(status.toByte());
			if(data != null) baos.write(data);
			this.callback.onRequestFinished(baos.toByteArray());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private int firstCamera(boolean facingFront){
	    Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
	    
	    int cameraCount = Camera.getNumberOfCameras();
	    
	    for ( int camIdx = 0; camIdx < cameraCount; camIdx++ ) {
	        Camera.getCameraInfo( camIdx, cameraInfo );
	        if(facingFront == true){
	        	if ( cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_FRONT ) {
		            return camIdx;
		        }
	        }else{//facingFront == false
	        	if ( cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_BACK ) {
	        		return camIdx;
	        	}
	        }
	    }
	    return -1;
	}
	
	
	public void onDestroy(){
		//Log.v("erich","SensorToolbox onDestroy");
		if(camera != null){
			try {
	    		camera.stopPreview();
	        } catch (Exception e){/*ignore: tried to stop a non-existent preview*/}
	        
	        try {
	        	camera.release();
	        } catch (Exception e){/*ignore: tried to release a non-existent camera*/}
	        
			camera = null;
		}
	}


	public interface SensorToolboxCallback{
		public void onRequestFinished(byte[] requestAnswer);//TODO public, private, protected, ...
	}
	
	
	private void standardSensor(int sensorType, final Modul modul, final Cmd cmd, final DataArranger dataArranger){
		
		final SensorManager sensorManager = (SensorManager) activity.getSystemService(Context.SENSOR_SERVICE);
		if(sensorManager == null){
			callCallback(modul, cmd, Status.ERROR);
		}
		
	    Sensor sensor = sensorManager.getDefaultSensor(sensorType);
	    if(sensor == null){
			callCallback(modul, cmd, Status.ERROR);
		}
	    
	    sensorManager.registerListener(	new SensorEventListener(){ 
											boolean firstTime = true;
											public void onAccuracyChanged(Sensor sensor, int accuracy) {}
								
											public void onSensorChanged(SensorEvent event){
												//TODO allenfalls die ersten 3 Werte verwerfen, da einige Sensoren scheinbar zu Beginn ihren default Wert senden.
												//http://stackoverflow.com/questions/16721289/android-proximity-sensor-incorrect-value
												if(firstTime == false) return;
												firstTime = false;
												sensorManager.unregisterListener(this);

												callCallback(modul, cmd, Status.SUCCESS, dataArranger.arrange(event));
								        	}
								        },
								        sensor,
								        SensorManager.SENSOR_DELAY_FASTEST);
	}
	
	//TODO evtl. in andere Klasse auslagern
	private byte[] longTo4ByteArray(long i){
		return new byte[]{
			(byte) i,
			(byte)(i >>>  8),
			(byte)(i >>> 16),
			(byte)(i >>> 24),
		};
	}
	
	interface DataArranger{
		public byte[] arrange(SensorEvent event);
	}


	@Override
	public void onSpeechRecognized(String string) {		
		for(String s : string.toLowerCase().split(" ")){
			synchronized(this){
				wordBuffer.add(s);
			}
		}
	}
}
/*!
 *   \endcond
 */
