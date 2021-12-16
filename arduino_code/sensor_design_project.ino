#define PIN_LED_R 5
#define PIN_LED_G 6
#define PIN_LED_Y 8
#define PIN_LED_B 7

#define PIN_PWM_OUT 3
#define PIN_PWM_IN A5
#define PIN_PD_DATA A1
#define PIN_PD_DC A0
#define PIN_PD_TI A4
#define PIN_LM35_AMP A2
#define PIN_LM35 A3

#define MODE_FILTER_DEMO 0
#define MODE_AMP_CAL 1
#define MODE_DATA 2
#define MODE_MENU 3
#define MODE_PLOT 4


#define LED_ON PIN_LED_R
#define LED_FILTER_DEMO PIN_LED_G
#define LED_AMP_CAL PIN_LED_B
#define LED_DATA PIN_LED_Y

#define DEFAULT_MODE MODE_MENU

uint8_t current_mode = DEFAULT_MODE;
boolean mode_initialised = false;

void amp_cal_loop();
void filter_demo_loop();
void data_loop(bool, bool);

void menu_loop()
{
  if (!mode_initialised)
  {
    Serial.println(F("Please select mode:"));
    Serial.println(String(MODE_FILTER_DEMO) + ": Filter demo");
    Serial.println(String(MODE_AMP_CAL) + ": Amplifier calibration");
    Serial.println(String(MODE_DATA) + ": Data collection");
    Serial.println(String(MODE_PLOT) + ": Plot photodiode");
    digitalWrite(PIN_LED_B, HIGH);
    digitalWrite(PIN_LED_Y, HIGH);
    digitalWrite(PIN_LED_G, HIGH);
    mode_initialised = true;
  }

  if (Serial.available() > 0)
  {
    mode_initialised = false;

    int value = Serial.parseInt();
    if (value >= 0 && value < 5)
      current_mode = value;

    Serial.flush();
  }
}


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(PIN_PWM_OUT, OUTPUT);
  pinMode(PIN_LED_R, OUTPUT);
  pinMode(PIN_LED_G, OUTPUT);
  pinMode(PIN_LED_B, OUTPUT);
  pinMode(PIN_LED_Y, OUTPUT);
  digitalWrite(LED_ON, HIGH);
  current_mode = DEFAULT_MODE;
  Serial.println("Please select mode:");
}

void loop() {
  // put your main code here, to run repeatedly:
  switch (current_mode)
  {
    case MODE_AMP_CAL:
      amp_cal_loop();
      break;
    case MODE_FILTER_DEMO:
      filter_demo_loop();
      break;
    case MODE_DATA:
      data_loop(true, true);
      break;
    case MODE_PLOT:
      data_loop(false, false);
      break;
    default://menu
      menu_loop();
  }
}
