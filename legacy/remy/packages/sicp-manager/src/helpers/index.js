/*
In the node.js intro tutorial (http://nodejs.org/), they show a basic tcp 
server, but for some reason omit a client connecting to it.  I added an 
example at the bottom.

Save the following server in example.js:
*/

var net = require('net');

var server = net.createServer(function(socket) {
	socket.write('Echo server\r\n');
	socket.pipe(socket);
});

server.listen(1337, '127.0.0.1');

/*
And connect with a tcp client from the command line using netcat, the *nix 
utility for reading and writing across tcp/udp network connections.  I've only 
used it for debugging myself.

$ netcat 127.0.0.1 1337

You should see:
> Echo server

*/

/* Or use this example tcp client written in node.js.  (Originated with 
example code from 
http://www.hacksparrow.com/tcp-socket-programming-in-node-js.html.) */

var net = require('net');


//console.log(Buffer.from('01','binary'))
//process.exit()


console.log('Booting');
var client = new net.Socket();

function setLED(red,green,blue){
     
    console.log('Sending LED ');
    const messageSize = 9
    const arr = new Uint8Array(messageSize)

    arr[0] = messageSize
    arr[1] = 0x01
    arr[2] = 0x00
    arr[3] = 0xF3
    arr[4] = 0x01
    arr[5] = red
    arr[6] = green
    arr[7] = blue
    var checksum = 0
    for (let index = 0; index < messageSize-1; index++) {
        checksum = checksum ^ arr[index]
    }
    arr[8] = checksum

    client.write(arr)
}   

function setLEDOff(){
     
    console.log('Turning off LED ');
    const messageSize = 6
    const arr = new Uint8Array(messageSize)

    arr[0] = messageSize
    arr[1] = 0x01
    arr[2] = 0x00
    arr[3] = 0xF3
    arr[4] = 0x00
    
    var checksum = 0
    for (let index = 0; index < messageSize-1; index++) {
        checksum = checksum ^ arr[index]
    }
    arr[8] = checksum

    client.write(arr)
}   

function getPlatform(){
     
    console.log('Getting platform');
    const messageSize = 6
    const arr = new Uint8Array(messageSize)

    arr[0] = messageSize
    arr[1] = 0x01
    arr[2] = 0x00
    arr[3] = 0xA2
    arr[4] = 0x01
    
    var checksum = 0
    for (let index = 0; index < messageSize-1; index++) {
        checksum = checksum ^ arr[index]
    }
    arr[8] = checksum

    client.write(arr)
}   

function sleep(ms){
    return new Promise((resolve, reject) => {
        setTimeout(()=>{resolve()},ms)
    });
}

//var host = '192.168.68.115'
var host = '10.145.64.40'
client.connect(5000, host, async function() {
    console.log('Connected');

    while (true) {
        setLED(0,0,0)
        process.exit(1)
        await sleep(700)
        setLED(255,0,0)
        await sleep(700)
        setLED(50,50,50)
        await sleep(300)
        setLED(0,255,0)
        await sleep(800)
            
    }


    
    //setBrowserOn(255,0,255)
	//client.write('Hello, server! Love, Client.');
},);

 client.on('data', function(data) {
 	console.log('Received: ' + data);
// 	client.destroy(); // kill client after server's response
 });

client.on('close', function() {
	console.log('Connection closed');
});