var http = require('http');
var netstat = require('node-netstat');

const exec = require('child_process').exec;
const log = a => console.log(a);

const SERVICEPORT=18231; 
const SERVICEHOST='92.247.187.47';

// nb:recursive retries...
function selectPort() {
	let port;

	port = Math.floor(Math.random() * 30000 + 1024);
	console.log(`try: port ${port}`);

	let cmd = `lsof -i :${port} | grep COMMAND | wc -l`;

	let val = new Promise( (res, rej) => {
		const child = exec(cmd,
			(error, stdout, stderr) => {
			let taken = parseInt(stdout);

			console.log(taken ? "port: taken. retry" : "not used");

			if (taken) {
				res(selectPort());
			} else {
				res(port);
			}
		});
	});

	return val;
}

function handleRequest(request, response){
	selectPort().then(port => {
		console.log("send: resp.");
		response.statusCode = 200;
		response.setHeader('Content-Type', 'text/plain');
		response.write(port + "\n");
		response.end();
	});
}

var server = http.createServer(handleRequest);

server.listen(SERVICEPORT, SERVICEHOST, function(){
	console.log("Random port selector at: http://%s:%s", SERVICEHOST, SERVICEPORT);
});

