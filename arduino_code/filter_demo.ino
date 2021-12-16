#define PRINT_EVERY 5 //ms
#define SPEED_INCREASE_EVERY 200 //ms
#define MAX_OFF 1100000 //us
#define MAX_ON 1100000 //us

uint32_t off_micros = MAX_OFF;
uint32_t on_micros = MAX_ON;
uint8_t duty_cycle = 50; //%
uint32_t speed_increase = 25000; //microseconds/cycle

uint32_t last_switch = 0;
uint32_t last_print = 0;
uint32_t last_speed_increase = 0;
bool state = 0;
bool done = false;

void filter_demo_loop()
{
  if (!mode_initialised)
  {
    Serial.println("Output,Filtered");
    mode_initialised = true;
    pinMode(PIN_PWM_OUT, OUTPUT);
  }

  if (state && micros() > last_switch + on_micros)
  {
    digitalWrite(PIN_PWM_OUT, LOW);
    state = false;
    last_switch = micros();
  }
  else if (!state && micros() > last_switch + off_micros)
  {
    digitalWrite(PIN_PWM_OUT, HIGH);
    state = true;
    last_switch = micros();
  }

  if (millis() > last_print+PRINT_EVERY)
  {
    last_print = millis();
    Serial.print(analogRead(PIN_PWM_IN));
    Serial.print(",");
    Serial.println(analogRead(PIN_LM35));
  }

  
  if (millis() > last_speed_increase+SPEED_INCREASE_EVERY)
  {
    last_speed_increase = millis();

    if (off_micros > speed_increase* duty_cycle/100 && on_micros > speed_increase * duty_cycle/100)
    {
      off_micros -= speed_increase * duty_cycle/100;
      on_micros -= speed_increase * duty_cycle/100;
    }
    else if(!done)
    {
      analogWrite(PIN_PWM_OUT, 128);
      done = true;
    }
  }
  //Serial.println(filter_demo_pwm_counter);
  //Serial.println(filter_demo_step);
  //delayMicroseconds(filter_demo_delay);
}
