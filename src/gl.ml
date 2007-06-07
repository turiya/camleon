(* $Id: simple.ml,v 1.1 2003/09/25 13:54:10 raffalli Exp $ *)

(* open Tk *)
let init_gl ~w ~h =
	GlMat.mode `projection;
	GlMat.ortho ~x:(-1.0,1.0) ~y:(-1.0,1.0) ~z:(-1.0,1.0);
	GlDraw.color (1.0, 1.0, 1.0)

let draw_cb () =
	GlClear.clear [`color];
	GlMat.load_identity ();
	(*GlDraw.vertex ~x:(Random.float(-1.0)) ~y:(Random.float(-1.0)) ();
	GlDraw.vertex ~x:(-0.5) ~y:(0.5) ();
	GlDraw.vertex ~x:(0.5) ~y:(0.5) ();
	GlDraw.vertex ~x:(0.5) ~y:(-0.5) ();*)
	GlDraw.color (Random.float 1.0, Random.float 1.0, Random.float 1.0);
	GlDraw.rect (Random.float (-1.0), Random.float (-1.0)) (Random.float 1.0, Random.float 1.0);
	Glut.swapBuffers ()

let reshape_cb ~w ~h =
	let
		ratio = (float_of_int w) /. (float_of_int h)
	in
		GlMat.mode `projection;
		GlMat.load_identity ();
		GluMat.perspective 45.0 ratio(0.1, 100.0);
		GlMat.mode `modelview;
		GlMat.load_identity ()

let idle_cb () =
	Thread.delay 0.1;
	draw_cb ()

let main () =
	let
		width = 640 and
		height = 480
	in
		ignore(Glut.init Sys.argv);
		Glut.initDisplayMode ~alpha:true ~depth:true ~double_buffer:true ();
		Glut.initWindowSize ~w:width ~h:height ;
		ignore(Glut.createWindow ~title:"lablglut & LablGL");
		Glut.displayFunc draw_cb;
		Glut.idleFunc(Some idle_cb);
		init_gl ~w:width ~h:height;
		Glut.mainLoop()

let _ = main ();

