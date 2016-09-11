const os = require('os');
const gpsd = require('node-gpsd');
const request = require('request');

function eth1ready() {
	let iflist = os.networkInterfaces();
	
	if (iflist.eth1 && iflist.eth1[0].address) {
		console.log("eth1 connected");	
		return true;
	} else { 
		console.log("eth1 not connected");	
		return false;
	}
}

var listener = new gpsd.Listener({
    port: 2947,
    hostname: 'localhost',
    logger:  {
        info: function(e) {
		console.log(e);
	},
        warn: console.warn,
        error: console.error
    },
    parse: true
});

listener.connect(function() {
    console.log('Connected');
});

let curr = [];
let lt;

listener.watch({ class: 'WATCH', json: true, nmea: false });
listener.on('TPV', td => {
	if (td.speed >= 0 && td.lon && td.lat && td.time) {
		td.radius = Math.sqrt((td.epx * td.epx) + (td.epy * td.epy));
		console.log(`${td.lon} / ${td.lat} / r ${td.radius} / s ${td.speed} `);

		td.imei = 'BUS0001';
		td.t = (new Date(td.time)).getTime();

		var g = { imei: td.imei, 
			t: td.t,
			lon: td.lon, lat: td.lat, 
			speed: td.speed, radius: td.radius };

		curr.push(g);
	}
});

function sendres() {
	if (!curr.length) return false;
	if (!eth1ready()) return false;

	let res = {t: 0, lon: 0, speed: 0, lat: 0, radius: 0, imei:curr[0].imei};

	curr.forEach(e => {
		res.t = res.t > e.t ? res.t : e.t;
		res.lon += e.lon / curr.length;
		res.lat += e.lat / curr.length;
		res.radius += e.radius / curr.length;
		res.speed += e.speed / curr.length;
	});

	res.speed *= 3.6;

	console.log(">>>> sending over this thing >>>> ");
	console.log(res);

	let pdata = JSON.stringify(res);

	request({
              uri: 'http://dev2-bg.plan-vision.com:3000/recv',
	      method: 'POST',
              json: res
	}, function(error, resp, body) {
		console.log(error);
		console.log(body);
	});

	curr.length = 0;
}

setInterval(sendres, 10 * 1000);

