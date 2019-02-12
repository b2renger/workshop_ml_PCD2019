let pg
let socket


function setup() {
    createCanvas(800, 600)
    pixelDensity(1)

    pg = createGraphics(800, 600)
    pg.pixelDensity(1)
    pg.background(255)
    pg.fill(0, 255, 0)
    imageMode(CENTER)

    socket = io.connect("http://localhost:3005");
}


function draw() {
    background(0)



    image(pg, width / 2, height / 2)


}

function mouseDragged() {
    let x = map(mouseX, 0, width, 0, pg.width)
    let y = map(mouseY, 0, height, 0, pg.height)

    pg.push()
    pg.ellipse(x , y, 25, 25)
    pg.pop()
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
}
