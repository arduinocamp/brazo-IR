//Brazo robotico controlado por IR
//Autores:
//Jose Manuel Escuder Martinez
//Jose Chorva Aguilella
//Manuel Hidalgo 
//Juan Antonio Caravaca Plaza

#include <Servo.h>
//Variables del programa		 


int ir_pin = 12;				//Sensor pin 1 wired through a 220 ohm resistor
int led_pin = 13;			//"Ready to Recieve" flag, not needed but nice
int debug = 0;				//Serial connection must be started to debug
int start_bit = 2000;			//Start bit threshold (Microseconds)
int bin_1 = 1000;			//Binary 1 threshold (Microseconds)
int bin_0 = 400;			//Binary 0 threshold (Microseconds)

/*
 base_rot_izquierda;   //tecla 1
 base_pos_inicial;     //tecla 2
 base_rot_derecha;     //tecla 3
 hombro_bajar;         //tecla 4
 hombro_pos_inicial;   //tecla 5
 hombro_subir;         //tecla 6
 codo_bajar;           //tecla 7
 codo_pos_inicial;     //tecla 8
 codo_subir;           //tecla 9
 mano_cerrar;          //tecla --/-
 mano_pos_inicial;     //tecla 0
 mano_abrir;           //tecla rara
//*/

Servo rotarHombro;
Servo elevarHombro;
Servo codo;
Servo mano;

  int rotaHombroDefecto = 90;
  int elevaHombroDefecto = 90;
  int codoDefecto = 90;
  int manoDefecto = 90;


  int rotaHombroActual = rotaHombroDefecto;
  int elevaHombroActual = elevaHombroDefecto;
  int codoActual = codoDefecto;
  int manoActual = manoDefecto;


void setup() 
{  
//configurar servos

rotarHombro.attach(3);
elevarHombro.attach(5);
codo.attach(6);
mano.attach(9);

  // Inicializar servos
 rotarHombro.write(rotaHombroDefecto);
 elevarHombro.write(elevaHombroDefecto);
 codo.write(codoDefecto);
 mano.write(manoDefecto);
 
  // Inicializa entradas/salidas
  pinMode(led_pin, OUTPUT);	   //This shows when we're ready to recieve
  pinMode(ir_pin, INPUT);
  digitalWrite(led_pin, LOW);	    //not ready yet
//  Serial.begin(9600);
}

void loop() 
{
  int key = getIRKey();		    //Fetch the key
//  Serial.print("Key Recieved: ");
//  Serial.println(key);
  
  switch(key)
  {
    ////////////////////////
    //rotar hombro
    ////////////////////////
    case 128:
    {
      rotaHombroActual = rotaHombroActual - 1;
      rotarHombro.write(rotaHombroActual);
//        Serial.print("Rotando hombro con el 1");
      break;
    }
    case 129:
    {
      while(rotaHombroDefecto < rotaHombroActual)
      {
        rotaHombroActual = rotaHombroActual - 1;
        rotarHombro.write(rotaHombroActual);
        delay(10);
      }
      while(rotaHombroDefecto > rotaHombroActual)
      {
        rotaHombroActual = rotaHombroActual + 1;
        rotarHombro.write(rotaHombroActual);
        delay(10);
      }
//         Serial.print("Posicion por defecto del hombro");
      break;
    }
    case 130:
    {
      rotaHombroActual = rotaHombroActual + 1;
      rotarHombro.write(rotaHombroActual);
//        Serial.print("Rotando hombro con el 3");
      break;
    }
    ////////////////////////
    //elevar hombro
    ////////////////////////
    case 131:
    {
      elevaHombroActual = elevaHombroActual - 1;
      elevarHombro.write(elevaHombroActual);
      break;
    }
    case 132:
    {
      while(elevaHombroDefecto < elevaHombroActual)
      {
        elevaHombroActual = elevaHombroActual - 1;
        elevarHombro.write(elevaHombroActual);
        delay(10);
      }
      while(elevaHombroDefecto > elevaHombroActual)
      {
        elevaHombroActual = elevaHombroActual + 1;
        elevarHombro.write(elevaHombroActual);
        delay(10);
      }

      break;
    }
    case 133:
    {
      elevaHombroActual = elevaHombroActual + 1;
      elevarHombro.write(elevaHombroActual);
      break;
    }
    ////////////////////////
    //control codo
    ////////////////////////
    case 134:
    {
      codoActual = codoActual - 1;
      codo.write(codoActual);
      break;
    }
    case 135:
    {
      while(codoDefecto < codoActual)
      {
        codoActual = codoActual - 1;
        codo.write(codoActual);
        delay(10);
      }
      while(codoDefecto > codoActual)
      {
        codoActual = codoActual + 1;
        codo.write(codoActual);
        delay(10);
      }
      break;
    }
    case 136:
    {
      codoActual = codoActual + 1;
      codo.write(codoActual);
      break;
    }
    ////////////////////////
    //control mano
    ////////////////////////
    case 157:
    {
      manoActual = manoActual - 1;
      mano.write(manoActual);
      break;
    }
    case 137:
    {
      while(manoDefecto < manoActual)
      {
        manoActual = manoActual - 1;
        mano.write(manoActual);
        delay(10);
      }
      while(manoDefecto > manoActual)
      {
        manoActual = manoActual + 1;
        mano.write(manoActual);
        delay(10);
      }
      break;
    }
    case 187:
    {
      manoActual = manoActual + 1;
      mano.write(manoActual);
      break;
    }
  }
}



//Decodifica el codigo del mando
int getIRKey() 
{
  int data[12];
  digitalWrite(led_pin, HIGH);	   //Ok, i'm ready to recieve

  while(pulseIn(ir_pin, LOW) < 2200)
  { //Wait for a start bit
  }
  data[0] = pulseIn(ir_pin, LOW);	//Start measuring bits, I only want low pulses
  data[1] = pulseIn(ir_pin, LOW);
  data[2] = pulseIn(ir_pin, LOW);
  data[3] = pulseIn(ir_pin, LOW);
  data[4] = pulseIn(ir_pin, LOW);
  data[5] = pulseIn(ir_pin, LOW);
  data[6] = pulseIn(ir_pin, LOW);
  data[7] = pulseIn(ir_pin, LOW);
  data[8] = pulseIn(ir_pin, LOW);
  data[9] = pulseIn(ir_pin, LOW);
  data[10] = pulseIn(ir_pin, LOW);
  data[11] = pulseIn(ir_pin, LOW);
  digitalWrite(led_pin, LOW);

  if(debug == 1) 
  {
    Serial.println("-----");
  }
  for(int i=0;i<11;i++) 		  //Parse them
  {
    if (debug == 1) 
    {
	  Serial.println(data[i]);
    }
    if(data[i] > bin_1) 		  //is it a 1?
    {
	data[i] = 1;
    }
    else 
    {
      if(data[i] > bin_0) 		//is it a 0?
      {
        data[i] = 0;
      } 
      else 
      {
        data[i] = 2;			  //Flag the data as invalid; I don't know what it is!
      }
    }
  }

  for(int i=0;i<11;i++)		  //Pre-check data for errors
  {
    if(data[i] > 1)
    { 
      return -1;			     //Return -1 on invalid data
    }
  }

  int result = 0;
  int seed = 1;
  for(int i=0;i<11;i++) 		  //Convert bits to integer
  {
    if(data[i] == 1) 
    {
	result += seed;
    }
    seed = seed * 2;
  }
  return result;			     //Return key number
}


