// Copyright (c) 2018 ml5
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/* ===
ML5 Example
KNN_Image
KNN Image Classifier example with p5.js
=== */

let knn;
let video;

var sounds = [] // un tableau pour stocker nos sons
var myPart // un metronome
var beat = 0 // la position du sequenceur
var bpm = 90 // la vitesse de défilement

var lastDetection = 0;

function preload() {
    sounds[0] = loadSound('sounds/76504__meowtek__bd-c64-m.wav');
    sounds[1] = loadSound('sounds/76506__meowtek__snare3-env1.wav');
    sounds[2] = loadSound('sounds/76638__meowtek__hat-c64-3.wav');
}

function setup() {
    noCanvas();
    video = createCapture(VIDEO).parent('videoContainer');
    // Create a KNN Image Classifier
    knn = new ml5.KNNImageClassifier(2, 1, modelLoaded, video.elt);

    createButtons();

    myPart = new p5.Part(); // on créer un objet Part qui va nous permettre de modifier la vitesse de lecture
    // on créer une phrase qui appelle la fonction 'step' à chaque temps. C'est dans cette fonction que l'on va jouer les sons
    var pulse = new p5.Phrase('pulse', step, [1, 1, 1, 1]);
    myPart.addPhrase(pulse); // on ajoute notre phrase à l'objet part
    myPart.setBPM(bpm);
    myPart.start();
    myPart.loop();
}

function createButtons() {
    // Save and Load buttons
    save = select('#save');
    save.mousePressed(function () {
        knn.save('test');
    });

    load = select('#load');
    load.mousePressed(function () {
        knn.load('KNN-preload.json', updateExampleCounts);
    });

    testSound = select('#testSound');
    testSound.mousePressed(function () {
        sounds[0].play()
    });

    // Train buttons
    buttonA = select('#buttonA');
    buttonA.mousePressed(function () {
        train(1);
    });

    buttonB = select('#buttonB');
    buttonB.mousePressed(function () {
        train(2);
    });

    buttonC = select('#buttonC');
    buttonC.mousePressed(function () {
        train(3);
    });

    buttonD = select('#buttonD');
    buttonD.mousePressed(function () {
        train(4);
    });

    // Reset buttons
    resetBtnA = select('#resetA');
    resetBtnA.mousePressed(function () {
        clearClass(1);
        updateExampleCounts();
    });

    resetBtnB = select('#resetB');
    resetBtnB.mousePressed(function () {
        clearClass(2);
        updateExampleCounts();
    });

    resetBtnC = select('#resetC');
    resetBtnC.mousePressed(function () {
        clearClass(3);
        updateExampleCounts();
    });

    resetBtnD = select('#resetD');
    resetBtnD.mousePressed(function () {
        clearClass(4);
        updateExampleCounts();
    });

    // Predict Button
    buttonPredict = select('#buttonPredict');
    buttonPredict.mousePressed(predict);
}

// A function to be called when the model has been loaded
function modelLoaded() {
    select('#loading').html('Model loaded!');
}

// Train the Classifier on a frame from the video.
function train(category) {
    let msg;
    if (category == 1) {
        msg = 'A';
    } else if (category == 2) {
        msg = 'B';
    } else if (category == 3) {
        msg = 'C';
    } else if (category == 4) {
        msg = 'D';
    }
    select('#training').html(msg);
    knn.addImageFromVideo(category);
    updateExampleCounts();
}

// Predict the current frame.
function predict() {
    knn.predictFromVideo(gotResults);

}

// Show the results
function gotResults(results) {
    let msg;

    if (results.classIndex == 1) {
        msg = 'A';
        lastDetection = 0;
    } else if (results.classIndex == 2) {
        msg = 'B';
        lastDetection = 1;
    } else if (results.classIndex == 3) {
        msg = 'C';
        lastDetection = 2;
    } else if (results.classIndex == 4) {
        msg = 'D';
        lastDetection = 3;
    }
    select('#result').html(msg);

    // Update confidence
    select('#confidenceA').html(results.confidences[1]);
    select('#confidenceB').html(results.confidences[2]);
    select('#confidenceC').html(results.confidences[3]);
    select('#confidenceD').html(results.confidences[4]);

    setTimeout(function () {
        predict();
    }, 10);

    console.log(lastDetection)
}

// Clear the data in one class
function clearClass(classIndex) {
    knn.clearClass(classIndex);
}

// Update the example count for each class
function updateExampleCounts() {
    let counts = knn.getClassExampleCount();
    select('#exampleA').html(counts[1]);
    select('#exampleB').html(counts[2]);
    select('#exampleC').html(counts[3]);
    select('#exampleD').html(counts[4]);
}

function mousePressed() {
    //  sounds[0].play()
}


function step() {
    // on vérifie si la checkbox représentant le temps 'beat' est cochée dans le tableau de checkbox controllant les bassdrums
    if (lastDetection == 0) {
        //sounds[0].play(0) // si c'est le cas on jour le premier son du tableau de son
    }
    // on recommence avec la deuxième ligne
    if (lastDetection == 1) {
        sounds[0].play()
    }
    if (lastDetection == 2) {
        sounds[1].play()
    }
    if (lastDetection == 3) {
        sounds[2].play()
    }
}
