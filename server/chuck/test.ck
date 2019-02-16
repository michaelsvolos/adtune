// arguments: rec:<filename>

// get name
me.arg(0) => string filename;
if( filename.length() == 0 ) "foo.wav" => filename;

Gain g => WvOut w => blackhole;
// this is the output file name
filename => w.wavFilename;
<<<"writing to file:", "'" + w.filename() + "'">>>;
// any gain you want for the output
.5 => g.gain;

SinOsc s => g;

// infinite time loop...
// ctrl-c will stop it, or modify to desired duration
5::second => now;
w.closeFile();
