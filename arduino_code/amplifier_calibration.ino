#define COUNTS_PER_RESULT 10000
#define PWM_MAX 60

unsigned long count = 0;
unsigned char pwmOutput = 0;

//online mean and standard deviation calculation
double filteredM = 0;
double filteredV = 0;
double ampedM = 0;
double ampedV = 0;
double gainM = 0;
double gainV = 0;


bool amp_cal_led_on = false;
void stepOutput()
{
  count = 0;
  pwmOutput += 1;
  filteredM = 0;
  filteredV = 0;
  ampedM = 0;
  ampedV = 0;
  gainM = 0;
  gainV = 0;
  analogWrite(PIN_PWM_OUT, pwmOutput);
  delay(50);
  
  digitalWrite(LED_AMP_CAL, amp_cal_led_on ? LOW : HIGH);
  amp_cal_led_on = ! amp_cal_led_on;
}

void amp_cal_loop()
{
  if (!mode_initialised)
  {
    Serial.println("#pwmOutputSetting filVal filValStdev ampVal ampValStdev gain gainStdev");
    mode_initialised = true;
    pinMode(PIN_PWM_OUT, OUTPUT);
  }

  if (count >= COUNTS_PER_RESULT)
  {//we have enough samples for this PWM settings, print the average and increase the input voltage
    Serial.print(pwmOutput);
    Serial.print(",");
    Serial.print(filteredM*5.0/1024, 5);
    Serial.print(",");
    Serial.print(sqrt(filteredV/(COUNTS_PER_RESULT-1))*5.0/1024, 5);
    Serial.print(",");
    Serial.print(ampedM*5.0/1024, 5);
    Serial.print(",");
    Serial.print(sqrt(ampedV/(COUNTS_PER_RESULT-1))*5.0/1024,5);
    Serial.print(",");
    Serial.print(gainM,5);
    Serial.print(",");
    Serial.println(sqrt(gainV/(COUNTS_PER_RESULT-1)),5);
    stepOutput();
  }

  if (pwmOutput > PWM_MAX)
  {
    delay(1000);
    mode_initialised = false;
    current_mode = MODE_MENU;
    digitalWrite(LED_AMP_CAL, LOW);
    return;
  }

  unsigned long filVal = analogRead(PIN_LM35);
  unsigned long ampVal = analogRead(PIN_LM35_AMP);
  double oldM = filteredM;
  filteredM += (1.0*filVal-filteredM)/(count + 1);
  filteredV += (1.0*filVal-filteredM)*(1.0*filVal - oldM);
  oldM = ampedM;
  ampedM += (1.0*ampVal-ampedM)/(count + 1);
  ampedV += (1.0*ampVal-ampedM)*(1.0*ampVal- oldM);

  if(filVal > 0)
  {
    double gainVal = ampVal*1.0/filVal;
    oldM = gainM;
    gainM += (1.0*gainVal-gainM)/(count + 1);
    gainV += (1.0*gainVal-gainM)*(1.0*gainVal - oldM);
  }

  count++;
}
