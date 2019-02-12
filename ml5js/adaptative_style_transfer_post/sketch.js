let pg
let socket


function setup() {
    createCanvas(windowWidth, windowHeight)
    pixelDensity(1)

    pg = createGraphics(width, height)
    pg.pixelDensity(1)


    socket = io.connect("http://localhost:8005");
}


function draw() {
    background(0)
    pg.ellipse(mouseX, mouseY, 50, 50)

    image(pg, 0, 0)


}


function mouseClicked() {
    //console.log(pg.canvas.toDataURL('image/jpeg'))
    socket.emit('query', {
        data: pg.canvas.toDataURL('image/jpeg')
    });
}
