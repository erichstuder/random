import javax.bluetooth.UUID;

import javax.swing.JFrame;
import javax.swing.JTable;


public class Main {

	//private static final UUID SERIAL_PORT_SERVICE_CLASS_UUID = new UUID("00001101-0000-1000-8000-00805F9B34FB",false);
	private static final UUID SERIAL_PORT_SERVICE_CLASS_UUID = new UUID("0000110100001000800000805F9B34FB",false);
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		new BluetoothClient(SERIAL_PORT_SERVICE_CLASS_UUID);
		
		//wait(1000);
		JFrame frame = new JFrame("RobotSensors Demo");
		frame.setSize(200, 200);
		
		
		//frame.dispatchEvent(new WindowEvent(frame, WindowEvent.WINDOW_CLOSING));
		
		JTable table = new JTable(10,2); 
		table.setValueAt("Hallo", 2, 1);
		
		
		frame.add(table);
		frame.setVisible(true);
		//while();
		//while(true);
	}

}
