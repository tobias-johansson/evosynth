//
//  commands.h
//  midi
//
//  Created by Tobias Johansson on 2014-02-15.
//  Copyright (c) 2014 JONI. All rights reserved.
//

#ifndef midi_commands_h
#define midi_commands_h


//       Parameter            CC#

#define Osc_1_Frequency       20
#define Osc_1_Freq_Fine       21
#define Osc_1_Shape           22
#define Glide_1               23
#define Osc_2_Frequency       24
#define Osc_2_Freq_Fine       25
#define Osc_2_Shape           26
#define Glide_2               27
#define Osc_Mix               28
#define Noise_Level           29
#define Sub_Oscillator_1      30
#define Sub_Oscillator_2      31
#define Filter_Frequency     102
#define Resonance            103
#define Filter_Key_Amt       104
#define Filter_Audio_Mod     105
#define Filter_Env_Amt       106
#define Filter_Env_Vel_Amt   107
#define Filter_Delay         108
#define Filter_Attack        109
#define Filter_Decay         110
#define Filter_Sustain       111
#define Filter_Release       112
#define VCA_Level            113
#define Amp_Env_Amt          115
#define Amp_Velocity_Amt     116
#define Amp_Delay            117
#define Amp_Attack           118
#define Amp_Decay            119
#define Amp_Sustain           75
#define Amp_Release           76
#define Env_3_Destination     85
#define Env_3_Amt             86
#define Env_3_Velocity_Amt    87
#define Env_3_Delay           88
#define Env_3_Attack          89
#define Env_3_Decay           90
#define Env_3_Sustain         77
#define Env_3_Release         78
#define BPM                   14
#define Clock_Divide          15


#define COMMANDS_LIST \
Osc_1_Frequency,      \
Osc_1_Freq_Fine,   \
Osc_1_Shape,   \
Glide_1,   \
Osc_2_Frequency,   \
Osc_2_Freq_Fine,   \
Osc_2_Shape,   \
Glide_2,   \
Osc_Mix,   \
Noise_Level,   \
Sub_Oscillator_1,   \
Sub_Oscillator_2,   \
Filter_Frequency,   \
Resonance,   \
Filter_Key_Amt,   \
Filter_Audio_Mod,   \
Filter_Env_Amt,   \
Filter_Env_Vel_Amt,   \
Filter_Delay,   \
Filter_Attack,   \
Filter_Decay,   \
Filter_Sustain,   \
Filter_Release,   \
VCA_Level,   \
Amp_Env_Amt,   \
Amp_Velocity_Amt,   \
Amp_Delay,   \
Amp_Attack,   \
Amp_Decay,   \
Amp_Sustain,   \
Amp_Release,   \
Env_3_Destination,   \
Env_3_Amt,   \
Env_3_Velocity_Amt,   \
Env_3_Delay,   \
Env_3_Attack,   \
Env_3_Decay,   \
Env_3_Sustain,   \
Env_3_Release,   \
BPM,   \
Clock_Divide

#define COMMAND_NAMES \
@"Osc_1_Frequency",      \
@"Osc_1_Freq_Fine",   \
@"Osc_1_Shape",   \
@"Glide_1",   \
@"Osc_2_Frequency",   \
@"Osc_2_Freq_Fine",   \
@"Osc_2_Shape",   \
@"Glide_2",   \
@"Osc_Mix",   \
@"Noise_Level",   \
@"Sub_Oscillator_1",   \
@"Sub_Oscillator_2",   \
@"Filter_Frequency",   \
@"Resonance",   \
@"Filter_Key_Amt",   \
@"Filter_Audio_Mod",   \
@"Filter_Env_Amt",   \
@"Filter_Env_Vel_Amt",   \
@"Filter_Delay",   \
@"Filter_Attack",   \
@"Filter_Decay",   \
@"Filter_Sustain",   \
@"Filter_Release",   \
@"VCA_Level",   \
@"Amp_Env_Amt",   \
@"Amp_Velocity_Amt",   \
@"Amp_Delay",   \
@"Amp_Attack",   \
@"Amp_Decay",   \
@"Amp_Sustain",   \
@"Amp_Release",   \
@"Env_3_Destination",   \
@"Env_3_Amt",   \
@"Env_3_Velocity_Amt",   \
@"Env_3_Delay",   \
@"Env_3_Attack",   \
@"Env_3_Decay",   \
@"Env_3_Sustain",   \
@"Env_3_Release",   \
@"BPM",   \
@"Clock_Divide"

#define COMMANDS_LIST_SIZE 41

#endif
