//Board: Arduino Leonardo


void setup(){
  Serial1.begin(9600);
}

void loop(){
  Serial1.println("Hello Arduino!");
  delay(2000);
}
