me.arg(0) => string filename;
Std.atoi(me.arg(1)) => int COUNT;

Gain out => WvOut2 wv => blackhole;
wv.wavFilename(filename);

//put tune code below

SinOsc s => out;
s.freq(220);

3::second => now;











wv.closeFile(filename);