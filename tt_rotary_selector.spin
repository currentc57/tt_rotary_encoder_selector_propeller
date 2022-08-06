'' =================================================================================================
''
''   File....... tt_rotary_selector.spin
''   Purpose.... to read a rotary encoder knob with push switch in a TT based program
''   Author..... Charles Current
''
''   E-mail..... charles@charlescurrent.com
''   Started.... 28-JUL-2022
''   Updated....
''
'' =================================================================================================
{{
  This object reads a standard rotary encoder knob with optional push switch in knob.
  This object is designed to work in a Time Triggered architecture.
  The readEncoder method should be called regularly and frequently enough to not miss steps, every 5-10ms works well.
  The readSwitch methos should be called at a rate that works to debouce the switch, every 20-25ms is good.
  The getXX methods will return position, direction, delta, and switch position.
  getDelta with return the delta since last called and optionaly reset the delta.
}}

'------------------------------------------------------------------------------
CON  { pins used in this object }
  ENC_A     = 16    { I }                               'rotary encoder inputs
  ENC_B     = 17    { I }
  SWITCH    = 18    { I }                               'encoder push switch
'------------------------------------------------------------------------------
CON  { other constants used in this object }
  ENC_TICKS     = 5                                     'tick intervals for tasks
  SWITCH_TICKS  = 25
  
  ENC_START     = 0                                     'starting offsets for tasks, keeps them from running in same tick
  SWITCH_START  = 1 
  
  CW            = 1
  CCW           = -1
'------------------------------------------------------------------------------
VAR
  long prev_a
  long enc_pos
  long enc_dir
  long enc_cnt

  long prev_switch
  long switch_pressed
  long switch_cnt
  
  long prev_pos
'------------------------------------------------------------------------------
PUB null ' this is not a stand alone object

'------------------------------------------------------------------------------
PUB setup
  prev_a := ina[ENC_A]                                  'get initial states
  prev_switch := ina[SWITCH]
      
'------------------------------------------------------------------------------
PUB getSw : state
  return switch_pressed
'------------------------------------------------------------------------------
PUB getPos : position
  return enc_pos
'------------------------------------------------------------------------------
PUB getDir : direction
  return enc_dir
'------------------------------------------------------------------------------
PUB getDelta(reset) : delta
  delta := enc_pos - prev_pos
  if reset == TRUE
    prev_pos := enc_pos
  return delta

'------------------------------------------------------------------------------
PUB readSwitch | cur_switch     ''reads the knob push switch, must be called regularly at a frequency that will debounce, every 20-25ms is good
  dira[SWITCH]~

  switch_cnt := 0
  cur_switch := ina[SWITCH]

  if prev_switch == cur_switch                       'if the switch state has been the same for 2 cycles
    switch_pressed :=  NOT cur_switch                'it's considered debounced and valid

  prev_switch := cur_switch
  

'------------------------------------------------------------------------------
PUB readEncoder | cur_state, cur_a, cur_b     ''reads the encoder position, must be called frequently, every 5-10ms is good  
  dira[ENC_A]~
  dira[ENC_B]~

  cur_state := ina[ENC_A..ENC_B]                      'get the current encoder output and separate the a and b phase states
  cur_b := cur_state & %01                            'and out a to leave b
  cur_a := cur_state >> 1                             'shift out b to leave a

  if cur_a <> prev_a                                  'if encoder a phase changed state display the direction on the LEDs
    if cur_b == cur_a                                 'if b leads a it's turning CCW
      enc_pos++
      enc_dir := CW
    else                                              'if a leads b it's turning CW
      enc_pos--
      enc_dir := CCW

  prev_a := cur_a
  
'------------------------------------------------------------------------------
CON { license }

{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

}}
