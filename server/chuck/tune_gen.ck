me.arg(0) => string filename;
Std.atoi(me.arg(1)) => int COUNT;
if (COUNT == 1000000) 14 => COUNT;
if (COUNT > 24) 24 => COUNT;
Gain out;



out => WvOut2 wv => blackhole;
wv.wavFilename(filename);

<<< "file opened" >>>;

//out => dac; //for testing

//put tune code below

45::second => dur LENGTH;

(60. / (75 + COUNT * 25))::second => dur BEAT;
<<< BEAT >>>;



Math.random2( -2, 2 ) => int offset;

0 => int bassOct;
if (COUNT > 15) 12 => bassOct;

[53, 55, 56, 58, 60, 61, 62, 64, 65] @=> int scale_oct[];
[52, 54, 56, 57, 59, 61, 64] @=> int scale_nice[];

[1., 0, 0, 0, 
0, 0, 0.6, 0, 
0, 0, 0, 0, 
0, 0, 0, 0] @=> float bd_probs_slow[];

[0., 0, 0, 0, 
0, 0, 0, 0, 
1., 0, 0, 0,
0, 0, 0, 0] @=> float snare_probs_slow[];

[1., 0, 1, 0, 
1, 0, 0.8, 0,
1, 0, 0.8, 0,
1, 0, 1, 0] @=> float hat_probs_slow[];




[1., 0, 0, 0, 
0, 0, 0, 0, 
1, 0, 0, 0, 
0.4, 0, 0, 0] @=> float bd_probs_med[];

[0., 0, 0, 0, 
1., 0, 0, 0, 
0, 0, 0, 0,
1, 0, 0.1, 0] @=> float snare_probs_med[];

[1., 0, 0.3, 0, 
1, 0, 0.3, 0,
1, 0, 0.3, 0,
1, 0, 0.3, 0] @=> float hat_probs_med[];


[1., 0, 1, 0.5, 
1, 0, 0, 0.5, 
1, 0, 1, 0.5, 
1, 0, 0, 0.5] @=> float bd_probs_fast[];

[1., 0, 0, 0, 
1., 0, 0.2, 0, 
1, 0, 0.1, 0,
1, 0, 0.2, 0] @=> float snare_probs_fast[];

[1., 0, 1, 0, 
1, 0, 1, 0,
1, 0, 1, 0,
1, 0, 1, 0] @=> float hat_probs_fast[];


Bass b;
Pad p;
BD bd;
Snare s;
Hat h;
p.setEnvDur(BEAT / 4);
3::ms => now;

spork ~b.play(Std.mtof(40 + offset + bassOct), LENGTH);
spork ~pads();
spork ~offsetChange();
spork ~drums();

40::second => now;
now + 5::second => time stop;
while (now < stop) {
	(stop - now) / 5::second => float interp;
	out.gain(interp);
	10::ms => now;
}



fun void drums() {
	
	0 => int index;
	while (BEAT / 4 => now) {
		if (COUNT < 11) {
			if (Math.randomf() < bd_probs_slow[index]) spork ~bd.play();
			if (Math.randomf() < snare_probs_slow[index]) spork ~s.play();
			if (Math.randomf() < hat_probs_slow[index]) spork ~h.play();
		} else if (COUNT < 16) {
			if (Math.randomf() < bd_probs_med[index]) spork ~bd.play();
			if (Math.randomf() < snare_probs_med[index]) spork ~s.play();
			if (Math.randomf() < hat_probs_med[index]) spork ~h.play();
		} else {
			if (Math.randomf() < bd_probs_fast[index]) spork ~bd.play();
			if (Math.randomf() < snare_probs_fast[index]) spork ~s.play();
			if (Math.randomf() < hat_probs_fast[index]) spork ~h.play();
		}
		(index + 1) % 16 => index;
	}
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
		}
	}
}


fun void pads() {
	
	while (true) {
		if (Math.randomf() > 0.1) {
			if (COUNT > 12) {
				0 => int randOct;
				if (Math.randomf() > 0.6) 12 => randOct;
				p.setFreq(Std.mtof(scale_oct[Math.random2( 0, scale_oct.cap() - 1 )] + offset + randOct));
			} else if (COUNT > 4) {
				p.setFreq(Std.mtof(scale_oct[Math.random2( 0, scale_oct.cap() - 1 )] + offset));
			} else p.setFreq(Std.mtof(scale_nice[Math.random2( 0, scale_nice.cap() - 1 )] + offset));
			spork ~p.play(BEAT * 3 / 4);
		}
		BEAT => now;
	}
}

class Bass {
	TriOsc s => LPF l => Chorus c => ADSR adsr => out;
	TriOsc t => l;
	//t.freq(37.5);
	t.gain(0.2);
	s.gain(0.4);
	c.modFreq(0.1 + COUNT / 30);
	c.modDepth(0.2 + COUNT / 20);
	c.mix(0.3);
	//s.freq(75);
	l.freq(250);
	//n.mix(0.01);
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
		t.freq(freq * 0.03);
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
	SawOsc s => Chorus c => Chorus d => Pan2 p1 => LPF l => Envelope e => NRev n => Pan2 pan => out;
	TriOsc t => Chorus f => Pan2 p2 => l;

	0.75::second => dur envDur;

	p1.pan(0.1);
	p2.pan(-0.1);
	t.freq(300);
	t.gain(0.3);
	c.modFreq(0.1 + COUNT / 15);
	c.modDepth(0.1 + COUNT / 15);
	d.modFreq(0.151342);
	d.modDepth(0.1);
	f.modFreq(0.3);
	f.modDepth(0.1);
	s.gain(0.3);
	s.freq(300);
	l.freq(1500);
	Math.max(0.2 - COUNT / 60., 0.001) => n.mix;
	e.duration(envDur);


	600 + COUNT * 40 => float startFreq;
	2000 + COUNT * 40=> float endFreq;

	fun void setFreq(float freq) {
		s.freq(freq);
		t.freq(freq + 0.01);

	}

	fun void setEnvDur(dur duration) {
		duration => envDur;
		e.duration(envDur);
	}

	fun void play(dur duration) {
		pan.pan(Math.random2f( -0.3, 0.3 ));
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

class BD {
    SinOsc s => Envelope e => dac;
    Noise no => LPF l => Envelope f => dac;;
    l.freq(2500);
    no.gain(0.12);
    f.duration(5::ms);
    
    //n.mix(0.0);
    s.gain(0.6);
    130 => float startFreq;
    40 => float endFreq;
    5::ms => dur onDur;
    350::ms => dur offDur;
    60::ms => dur fallDur;
    s.freq(startFreq);
    e.duration(onDur);

    fun void noise_play() {
    	f.keyOn();
    	10::ms => now;
    	f.keyOff();
    	20::ms => now;
    }

    fun void play() {
    	spork ~noise_play();
        s.freq(startFreq);
        e.duration(onDur);
        e.keyOn();
        
        now + fallDur => time stop;
        while (now < stop) {
            (stop - now) / fallDur => float interp; //goes from 1 to 0
            s.freq(startFreq * interp + endFreq * (1 - interp));
            1::ms => now;
        }
        e.duration(offDur);
        e.keyOff();
        onDur + offDur + 600::ms => now;
    }
}

class Snare {
	Noise no => BPF b => ADSR adsr => NRev n => dac;
	SinOsc t => adsr;
	b.freq(200);
	b.Q(0.3);
	t.freq(200);
	n.mix(0.008);
	t.gain(0.8);
	
	no.gain(0.3);
	adsr.set(1::ms, 120::ms, 0, 50::ms);

	fun void play() {
		adsr.keyOn();
		10::ms => now;
		adsr.keyOff();
		10::ms => now;
	}
}

class Hat {
    Shakers s => NRev n => Pan2 pan => dac;
    s.gain(0.4`);
    n.mix(0.025);
    s.preset(11);
    s.energy(1.0);
    s.decay(0.5);
    s.objects(0);
    fun void play() {
        if (Math.randomf() > 0.5) {
            pan.pan(0.3);
        } else pan.pan(-0.3);
        s.preset(11);
        s.noteOn(1);
        20::ms => now;
        s.noteOff(0);
    }
}




<<< "write successful, closing file..." >>>;
wv.closeFile(filename);
<<< "file closed" >>>;