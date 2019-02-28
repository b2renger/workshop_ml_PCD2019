let pg
let socket

// The SketchRNN model
let model;
// Start by drawing
let previous_pen = 'down';
// Current location of drawing
let x, y;
// The current "stroke" of the drawing
let strokePath;


function setup() {
    createCanvas(800, 600)
    pixelDensity(1)

    pg = createGraphics(800, 600)
    pg.pixelDensity(1)
    pg.background(255)
    pg.fill(0, 255, 0)
    imageMode(CENTER)

    socket = io.connect("http://localhost:3005");

    // Load the model
    // See a list of all supported models: https://github.com/ml5js/ml5-library/blob/master/src/SketchRNN/models.js
    model = ml5.SketchRNN('bulldozer', modelReady);


}


function draw() {
    background(0)


    // If something new to draw
    if (strokePath) {
        // If the pen is down, draw a line
        if (previous_pen == 'down') {
            pg.stroke(0);
            pg.strokeWeight(3.0);
            pg.line(x, y, x + strokePath.dx, y + strokePath.dy);
        }
        // Move the pen
        x += strokePath.dx;
        y += strokePath.dy;
        // The pen state actually refers to the next stroke
        previous_pen = strokePath.pen;

        // If the drawing is complete
        if (strokePath.pen !== 'end') {
            strokePath = null;
            model.generate(gotStroke);
        }
    }


    image(pg, width / 2, height / 2)


}

function mouseDragged() {
    let x = map(mouseX, 0, width, 0, pg.width)
    let y = map(mouseY, 0, height, 0, pg.height)

    pg.push()
    pg.ellipse(x, y, 25, 25)
    pg.pop()
}

// A new stroke path
function gotStroke(err, s) {
  strokePath = s;
}



function keyTyped() {

    if (key === 's') {
        console.log(pg.canvas.toDataURL('image/jpeg'))
        socket.emit('query', {
            "contentImage": pg.canvas.toDataURL('image/jpeg')
        });
    }
    if (key === 'e') {
        pg.background(255)
    }
    if (key === 'd') {
        background(220);
        // Start in the middle
        x = width / 2;
        y = height / 2;
        model.reset();
        // Generate the first stroke path
        model.generate(gotStroke);
    }
}

/// The model is ready
function modelReady() {
 console.log("model ready")
}
