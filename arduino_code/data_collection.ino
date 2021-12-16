#define DATA_AVERAGE_SAMPLES 64
#define LED_HEART PIN_LED_G
//#define SAMPLE_DELAY 0

uint8_t pd_avg_samples = 0;
unsigned long data_sum = 0;
unsigned long dc_sum = 0;
unsigned long lm35_sum = 0;
unsigned long lm35_amp_sum = 0;

void data_print(bool print_time, bool print_temp)
{
  if (data_sum > dc_sum - DATA_AVERAGE_SAMPLES*40)
    digitalWrite(LED_HEART, LOW); //This threshold is arbitrary, it would be better to look at the size of the last peak
  else
    analogWrite(LED_HEART, 255-(dc_sum-data_sum)/DATA_AVERAGE_SAMPLES*3);
  if (print_time)
  {
    Serial.print(millis());
    Serial.print(",");
  }

  Serial.print(data_sum/DATA_AVERAGE_SAMPLES);
  data_sum = 0;
  Serial.print(",");
  Serial.print(dc_sum/DATA_AVERAGE_SAMPLES);
  dc_sum = 0;
  if (print_temp)
  {
    Serial.print(",");
    Serial.print(lm35_sum/DATA_AVERAGE_SAMPLES);
    lm35_sum = 0;
    Serial.print(",");
    Serial.print(lm35_amp_sum/DATA_AVERAGE_SAMPLES);
    lm35_amp_sum = 0;
  }
  Serial.println();
}

void data_loop(bool print_time, bool print_temp)
{
  if (!mode_initialised)
  {
    Serial.print("#");
    if (print_time)
      Serial.print("millis,");
    Serial.print("PD_output,PD_DC");
    if (print_temp)
      Serial.print(",LM35,LM35_amped");
    Serial.println();
    digitalWrite(PIN_LED_G, LOW);
    digitalWrite(PIN_LED_B, LOW);
    digitalWrite(PIN_LED_Y, LOW);
    mode_initialised = true;
  }

  if (pd_avg_samples == DATA_AVERAGE_SAMPLES)
  {
    pd_avg_samples = 0;
    data_print(print_time, print_temp);
    return;
  }
  data_sum += analogRead(PIN_PD_DATA);
  dc_sum += analogRead(PIN_PD_DC);
  lm35_sum += analogRead(PIN_LM35);
  lm35_amp_sum += analogRead(PIN_LM35_AMP);

  pd_avg_samples++;
  #ifdef SAMPLE_DELAY
    delay(SAMPLE_DELAY);
  #endif
}
