package erichstuder.robotsensors;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;
import java.util.UUID;


//import com.lego.minddroid.BTCommunicator;
//import com.lego.minddroid.R;

import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Point;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;

public class BluetoothServer extends BroadcastReceiver{

    // this is the only OUI registered by LEGO, see http://standards.ieee.org/regauth/oui/index.shtml
    //private static final String OUI_LEGO = "00:16:53";
    
    private BluetoothAdapter mBluetoothAdapter;
    
    private BluetoothEventListener eventListener = null;
    private OutputStream outputStream;
    private BluetoothSocket btSocket;
    
    private Thread serverThread = null;
    
    private UUID uuid;
    private Activity activity;
    
    
    //private static final int BLUETOOTH_ENABLE_REQUEST_CODE = 0;
    
	
	public BluetoothServer(final UUID uuid, Activity activity){
		this.uuid = uuid;
		this.activity = activity;
	}
	
	public void setEventListener(BluetoothEventListener eventListener){
		this.eventListener = eventListener;
	}
	
	
	public void start(){
		mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if(mBluetoothAdapter == null){
			AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setMessage("Bluetooth is not supported!!");
            builder.create().show();
			return;
		}
		
		//turn on bluetooth
		if( ! mBluetoothAdapter.isEnabled()){
            try{
            	//Bluetooth einschalten mit User-Bestätigung
            	IntentFilter intentFilter = new IntentFilter();
                intentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        		activity.registerReceiver(this, intentFilter);
        		
            	Intent enableBluetooth = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            	activity.startActivity(enableBluetooth);
            }catch(Exception e){
            	e.printStackTrace();
            }
		}else{
			startServerTask();
		}
	}
	
	private void startServerTask(){
		serverThread = new Thread(){
			public void run(){
				try {
					BluetoothServerSocket btServerSocket = mBluetoothAdapter.listenUsingRfcommWithServiceRecord("BluetoothServer", uuid);
					//Google sagt für name soll man App name verwenden: http://developer.android.com/guide/topics/connectivity/bluetooth.html#ConnectingAsAServer
					
					btSocket = btServerSocket.accept();
				    btServerSocket.close();

			        final InputStream inputStream = btSocket.getInputStream();
			        outputStream = btSocket.getOutputStream();
			        //btSocket.getRemoteDevice().ged

		    		byte[] buffer = new byte[1024];//1024 = maximale Nachrichtenlänge??
			        //Google nimmt auch diesen Wert: http://developer.android.com/guide/topics/connectivity/bluetooth.html

			        while(true){
			            int byteCnt;
						byteCnt = inputStream.read(buffer);
						byte[] data = new byte[byteCnt];
						for(int i=0; i<byteCnt; i++){
							data[i]=buffer[i];
						}

						if(eventListener != null){
							eventListener.onIncomingData(data);
			            }
			        }	
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		};
		
		serverThread.start();
	}
	
	public void stop(){
		try {
			if(this.btSocket != null){
				this.btSocket.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	

	public void send(byte[] message){

		try{
			ByteArrayOutputStream messageLong = new ByteArrayOutputStream();
			
			//if(isLegoDevice(btSocket.getRemoteDevice())){
				messageLong.write(message.length+2);
				messageLong.write((message.length+2)>>8);
			//}
			//messageLong.write(0x80);
			//messageLong.write(0x09);
			//messageLong.write(mailbox);
			//messageLong.write(message.length+1);
			
			messageLong.write(0xEE);//my personal cmd. Einfach eine Markierung (0x00,0x01,0x80,0x81 werden von der LegoFirmware bereits verwendet)
			messageLong.write(0x00);//dieses Byte wird von der orginal Lego Firmware auf 0 gesetzt, deshalb wird der Beginn der Nachricht um 2 Byte nach hinten verschoben.
			
			//messageLong.write(0x80);
			//messageLong.write(0x03);
			
			messageLong.write(message);
			//messageLong.write(0x00);//wird glaube ich nur für Mailbox als Abschluss benötigt
			//Log.v("erich","a");
			
//			String m = "sent: ";
//			for(byte b : messageLong.toByteArray()){
//				m+=" "+b;
//			}
//			Log.v("erich",m);
			
			outputStream.write(messageLong.toByteArray());
			outputStream.flush();
			
		}catch(IOException e){
			e.printStackTrace();
		}
		
	}
	
//	public void sendToMailbox(byte[] message, int mailbox){
//		try{
//			ByteArrayOutputStream messageLong = new ByteArrayOutputStream();
//			
//			if(isLegoDevice(btSocket.getRemoteDevice())){
//				messageLong.write(message.length+5);
//				messageLong.write((message.length+5)>>8);
//			}
//			messageLong.write(0x80);
//			messageLong.write(0x09);
//			messageLong.write(mailbox);
//			messageLong.write(message.length+1);
//			
//			//messageLong.write(0xEE);//my personal cmd. Einfach eine Markierung (0x00,0x01,0x80,0x81 werden von der LegoFirmware bereits verwendet)
//			//messageLong.write(0x00);//dieses Byte wird von der orginal Lego Firmware auf 0 gesetzt, deshalb wird der Beginn der Nachricht um 2 Byte nach hinten verschoben.
//			
//			messageLong.write(message);
//			messageLong.write(0x00);//wird glaube ich nur für Mailbox als Abschluss benötigt
//			//Log.v("erich","a");
//			
//			outputStream.write(messageLong.toByteArray());
//			outputStream.flush();
//			
//			String m = "";
//			for(byte b : message){
//				m += b + " ";
//			}
//			Log.v("erich","gesendete Daten: "+m);
//			
//			Log.v("erich","Daten am mailbox gesendet");
//		}catch(IOException e){
//			Log.v("erich",e.toString());
//		}
//		
//	}

//	public static boolean isLegoDevice(BluetoothDevice btDevice){
//		return btDevice.getAddress().startsWith(OUI_LEGO);
//	} //Die App hat eigentlich nichts mit Lego zu tun!!!

    public interface BluetoothEventListener{
    	public void onIncomingData(byte[] data);
    }
    
    
    // implements BroadcastReceiver
	@Override
	public void onReceive(Context context, Intent intent) {
		int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF);
		
		if(context.equals(activity)){
			switch(state){
			case BluetoothAdapter.STATE_ON:
				//Log.v("erich","BluetoothAdapter.STATE_ON");
				if(serverThread == null){
					startServerTask();
				}
				break;
			case BluetoothAdapter.STATE_OFF:
				//Log.v("erich","BluetoothAdapter.STATE_OFF");
				break;
			}
		}
	}

}











