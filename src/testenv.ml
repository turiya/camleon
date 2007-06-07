#use "synthesizer.ml"
#use "spectralizer.ml"
#use "scopes.ml"

let synth = new Synth.synthesizer ()
let datagen = synth#generate_sinusoid_samples
let spectgen = new Analysis.spectralizer ~bands:48
let osc = new Scopes.oscilloscope ~barsize:160 ()
let spectrogen = new Scopes.spectroscope ~barsize:160
