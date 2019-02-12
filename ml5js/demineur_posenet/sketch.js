// 'p' pour switcher entre le mode edit et le mode play
// 'b' pour ajouter une bombe
// cliquer sur une bombe et laisser appuyer pour la déplacer
// cliquer sur une bombe et appuyer sur 't' pour réduire la valeur du timer
// cliquer sur une bombe et appuyer sur 'y' pour augmenter la valeur du timer
// cliquer sur une bombe et appuyer sur 'r' pour augmenter la taille de la bombe
// cliquer sur une bombe et appuyer sur 'e' pour diminuer la taille de la bombe
// actualiser la page pour recommencer

let video;
let poseNet;
let poses = [];
let skeletons = [];
var ready = false


var play = false
var gameOver = false

var bombs = []
var selectedBomb = null;




function setup() {
    createCanvas(windowWidth, windowHeight)
    video = createCapture(VIDEO);
    video.size(width, height);
    background(0)

    // Create a new poseNet method with a single detection
    poseNet = ml5.poseNet(video, modelReady);
    // This sets up an event that fills the global variable "poses"
    // with an array every time new poses are detected
    poseNet.on('pose', function (results) {
        poses = results;
    });
    // Hide the video element, and just show the canvas
    video.hide();
}

function modelReady() {
    ready = true
}

function draw() {
    if (ready) {
        image(video, 0, 0, width, height);

        // We can call both functions to draw all keypoints and the skeletons
        drawKeypoints();
        drawGame();
    }
}

// A function to draw ellipses over the detected keypoints
function drawKeypoints() {
    // Loop through all the poses detected
    for (let i = 0; i < poses.length; i++) {
        // For each pose detected, loop through all the keypoints
        for (let j = 0; j < poses[i].pose.keypoints.length; j++) {
            // A keypoint is an object describing a body part (like rightArm or leftShoulder)
            let keypoint = poses[i].pose.keypoints[j];
            // Only draw an ellipse is the pose probability is bigger than 0.2
            if (keypoint.score > 0.2) {
                fill(255, 0, 0);
                noStroke();
                ellipse(keypoint.position.x, keypoint.position.y, 10, 10);
            }
        }
    }
}

/**function distance(keypoint[i].x, keypoint[i].y, bombs[i].x, bombs[i].y)){
    return Math.sqrt(sqr(bombs[i].y - keypoint[i].y) + sqr(bombs[i].x - keypoint[i].x));**/

function drawGame() {
    // jeu

    if (!gameOver) {

        // dessiner toutes les bombes
        for (var i = 0; i < bombs.length; i++) {
            bombs[i].draw();
        }

        // si on est dans le mode jeu
        if (play) {

            // console.log("play")
            for (var l = 0; l < bombs.length; l++) {
                // on fait défiler le temps
                bombs[l].update();

                // si la souris est au dessus d'une bombe on la supprime
                /*
                if (dist(mouseX, mouseY, bombs[l].x, bombs[l].y) < bombs[l].rad) {
                    bombs.splice(l, 1) // supprimer la bombe à l'index i
                }*/
                for (var k = 0; k < poses.length; k++) {
                    // For each pose detected, loop through all the keypoints
                    for (var j = 0; j < poses[k].pose.keypoints.length; j++) {

                        // A keypoint is an object describing a body part (like rightArm or leftShoulder)
                        let keypoint = poses[k].pose.keypoints[j];

                        if (dist(keypoint.position.x, keypoint.position.y, bombs[l].x, bombs[l].y) < bombs[l].rad/2) {
                            bombs.splice(l, 1) // supprimer la bombe à l'index i
                            return
                        }

                    }
                }
            }
            fill(255)
            text("play mode", 50, 50)
        }


        // sinon
        else {
            for (var i = 0; i < bombs.length; i++) {
                // si la souris est au dessus d'un bombe et que l'on clique on déplace la bombe
                if (dist(mouseX, mouseY, bombs[i].x, bombs[i].y) < bombs[i].rad / 2) {
                    if (mouseIsPressed) {
                        bombs[i].move(mouseX, mouseY)
                        selectedBomb = i
                        console.log(selectedBomb)
                    }
                }
            }
            fill(255)
            text("edit mode", 50, 50)
        }
    }

    // écran de fin
    else {
        push()
        fill(255)
        textAlign(CENTER, CENTER)
        textSize(46)
        text("You Loose", width * 0.5, height * 0.5)
        pop()
    }
}

function keyPressed() {
    if (key == 'p' || key == 'P') {
        play = !play
    }

    if (key == 'b' || key == 'B') {
        bombs.push(new Bomb(random(width), random(height), random(75, 150), int(random(15, 30))))
    }


    if (key == 't' || key == 'T' && selectedBomb != null && play == false) {
        bombs[selectedBomb].timer += -1
    }
    if (key == 'y' || key == 'Y' && selectedBomb != null && play == false) {
        bombs[selectedBomb].timer += 1
    }
    if (key == 'r' || key == 'R' && selectedBomb != null && play == false) {
        bombs[selectedBomb].rad += 1
    }
    if (key == 'e' || key == 'E' && selectedBomb != null && play == false) {
        bombs[selectedBomb].rad += -1
    }
}

function windowResized() {
    resizeCanvas(windowWidth, windowHeight)
}

function Bomb(x, y, rad, timer) {
    this.x = x;
    this.y = y;
    this.rad = rad

    this.timer = timer;
    this.psecond = second();

    this.draw = function () {
        push();
        fill(255, 0, 0)
        ellipse(this.x, this.y, this.rad, this.rad)
        fill(255)
        textAlign(CENTER, CENTER)
        text(this.timer, this.x, this.y)
        pop();
    }

    this.update = function () {
        if (this.psecond != second()) {
            this.timer = this.timer - 1
            this.psecond = second()
        }
        if (this.timer < 0) {
            gameOver = true
        }
    }

    this.move = function (x, y) {
        this.x = x
        this.y = y
    }

}
