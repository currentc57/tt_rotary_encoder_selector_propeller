# tt_rotary_encoder_selector
A rotary encoder knob library for a Time Triggered architecture on P1.

  This object reads a standard rotary encoder knob with optional push switch in the knob.
  This object is designed to work in a Time Triggered architecture.
  The readEncoder method should be called frequently enough to not miss steps, every 5-10ms works well.
  The readSwitch methos should be called at a rate that works to debouce the switch, every 20-25ms is good.
  The get methods will return position, direction, delta, and switch position.
  getDelta will return the delta since last called and optionaly reset the delta.
