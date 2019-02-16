me.arg(0) => string filename;
Std.atoi(me.arg(1)) => int COUNT;
if (COUNT == 1000000) 14 => count;
if (COUNT > 24) 24 => COUNT;
Gain out;
<<< COUNT >>>;

/*
out => WvOut2 wv => blackhole;
wv.wavFilename(filename);
*/

out => dac; //for testing

//put tune code below

45::second => dur LENGTH;

Math.max(0.8 - COUNT / 29., 0.03)::second => dur BEAT;


Math.random2( -2, 2 ) => int offset;

0 => int bassOct;
if (COUNT > 16) 12 => bassOct;

[53, 55, 56, 58, 60, 61, 62, 64, 65] @=> int scale_oct[];
[52, 54, 56, 57, 59, 61, 64] @=> int scale_nice[];

Bass b;

spork ~b.play(Std.mtof(40 + offset + bassOct), LENGTH);
spork ~pads();
spork ~offsetChange();
40::second => now;
now + 5::second => time stop;
while (now < stop) {
	(stop - now) / 5::second => float interp;
	out.gain(interp);
	10::ms => now;
}

fun void offsetChange() {
	1 => int numBeats;
	if (COUNT < 5) {
		5 => numBeats;
	} else if (COUNT < 12) {
		3 => numBeats;
	} else if (COUNT < 18) {
		2 => numBeats;
	}
	while (BEAT * numBeats => now) {
		if (Math.randomf() > 0.5) {
			offset + Math.random2( -3, 3 ) => offset;
			if (offset < -8) -8 => offset;
			if (offset > 8) 8 => offset;
			b.setFreq(Std.mtof(40 + offset + bassOct));
			<<< "change" >>>;
		}
	}
}


fun void pads() {
	Pad p;
	p.setEnvDur(BEAT / 4);
	while (true) {
		if (Math.randomf() > 0.1) {
			if (COUNT > 4) {
				p.setFreq(Std.mtof(scale_oct[Math.random2( 0, scale_oct.cap()  - 1 )] + offset));
			} else p.setFreq(Std.mtof(scale_nice[Math.random2( 0, scale_nice.cap()  - 1 )] + offset));
			spork ~p.play(BEAT * 3 / 4);
		}
		BEAT => now;
	}
}

class Bass {
	TriOsc s => LPF l => Chorus c => ADSR adsr => NRev n => out;
	TriOsc t => l;
	//t.freq(37.5);
	t.gain(0.1);
	s.gain(0.3);
	c.modFreq(0.1 + COUNT / 30);
	c.modDepth(0.2 + COUNT / 20);
	c.mix(0.3);
	//s.freq(75);
	l.freq(250);
	n.mix(0.01);
	10::ms => dur decay;

	0.3 + COUNT / 20 => float lfoRate;
	1600 + COUNT * 600 => float lfoDepth;

	adsr.set(5::ms, 5::ms, 0.9, decay);

	100 => float freq;

	fun void setFreq(float freque) {
		freque => freq;
		s.freq(freq);
		t.freq(freq * 0.03);
	}

	fun void play(dur duration) {
		play (freq, duration);
	}


	fun void play(float freque, dur duration) { //also sets freq
		freque => freq;
		s.freq(freq);
		t.freq(freq / 2);
		adsr.keyOn();
		now + duration - decay => time stop;
		while (now < stop) {
			l.freq(600 + (Math.sin( now/1::second * Math.TWO_PI * lfoRate) / 2. + 0.5) * lfoDepth);
			10::ms => now;
		}
		duration - decay => now;
		adsr.keyOff();
		decay => now;
	}
}

class Pad {
	SawOsc s => Chorus c => Chorus d => Pan2 p1 => LPF l => Envelope e => NRev n => out;
	TriOsc t => Chorus f => Pan2 p2 => l;

	0.75::second => dur envDur;

	p1.pan(0.1);
	p2.pan(-0.1);
	t.freq(300);
	t.gain(0.25);
	c.modFreq(0.1 + COUNT / 40);
	c.modDepth(0.1 + COUNT / 50);
	d.modFreq(0.151342);
	d.modDepth(0.1);
	f.modFreq(0.3);
	f.modDepth(0.1);
	s.gain(0.1);
	s.freq(300);
	l.freq(1500);
	Math.max(0.2 - COUNT / 100., 0.001) => n.mix;
	e.duration(envDur);


	600 => float startFreq;
	2000 => float endFreq;

	fun void setFreq(float freq) {
		s.freq(freq);
		t.freq(freq + 0.01);

	}

	fun void setEnvDur(dur duration) {
		duration => envDur;
		e.duration(envDur);
	}

	fun void play(dur duration) {
		
        now + envDur => time stop;
        e.keyOn();
        while (now < stop) {
            (stop - now) / (envDur) => float interp; //goes from 1 to 0
            l.freq(startFreq * interp + endFreq * (1 - interp));
            1::ms => now;
        }
        duration - 2 * envDur => now;
        now + envDur => stop;
        e.keyOff();
        while (now < stop) {
            (stop - now) / (envDur) => float interp; //goes from 1 to 0
            l.freq(endFreq * interp + startFreq * (1 - interp));
            1::ms => now;
        }
    }
}



//wv.closeFile(filename);