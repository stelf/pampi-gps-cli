#!/usr/bin/env node

const config = require('./config')
const os = require('os');
const gpsd = require('node-gpsd');
const request = require('request');
const ps = require('ps-node');
const process = require('process');
const spawn = require('child_process').spawn;

function checkssh() {
    return new Promise( (res, rej) => {
        ps.lookup({
            command: 'autossh',
            user: 'root',
            psargs: 'ax',
        }, function(err, resultList ) {
            if (err) {
                return rej(new Error(err));
            }
            if(resultList.length) {
                return res(parseInt(resultList[0].pid));
            }

            res(false);
        });
    });
}

function eth1ready() {
	let iflist = os.networkInterfaces();

	return (iflist.eth1 && iflist.eth1[0].address);
}

var listener;


var daemon = new gpsd.Daemon({
    program: '/usr/sbin/gpsd',
    device: '/dev/ttyS0',
    verbose: true,
    port: 2947
});

let curr = [];
let lt;

daemon.start(function() {
    debugger;

    var listener = new gpsd.Listener();

    listener.on('TPV', td => {
        if (td.speed >= 0 && td.lon && td.lat && td.time) {
            td.radius = Math.sqrt((td.epx * td.epx) + (td.epy * td.epy));
            console.log(`${td.lon} / ${td.lat} / r ${td.radius} / s ${td.speed} `);

            td.imei = config.IMEI;
            td.t = (new Date(td.time)).getTime();

            var g = { imei: td.imei,
                t: td.t,
                lon: td.lon, lat: td.lat,
                speed: td.speed, radius: td.radius };

            curr.push(g);
        } else {
            console.log("partial obj: " + JSON.stringify(td));
        }
    });

    listener.connect(function() {
        listener.watch();
        // listener.watch({ class: 'WATCH', json: true, nmea: true});
        });
});

/*
function getListener() {
    console.log("connectingent...");
    listener = new gpsd.Listener({
        port: 2947,
        hostname: 'localhost',
        logger:  {
            info: function(e) {},
            warn: console.warn,
            error: console.error
        },
        parse: true
    });
}

getListener();

*/

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

    console.log(`* TX: ${JSON.stringify(res)}`);

	let pdata = JSON.stringify(res);

	request({
        uri: config.SERVER,
        method: 'POST',
        json: res
	}, function(error, resp, body) {
		console.log(error);
		console.log(body);
	});

	curr.length = 0;
}

let crun = false;

function checknet() {
    if (crun) return;
    crun = true;

	if (eth1ready()) {
        checkssh().then( res => {
            if (!res) {
                console.log('! respawn autossh process');
                var sp = spawn(config.AUTOSSH, [], {detached: true, stdio: 'ignore'});
                console.info(`Using SERVER: ${config.SERVER}.`);
                sp.unref();
            } else {
                // console.log('eth1 is running, so is ssh');
            }
        });
	} else {
        checkssh().then( res => {
            if (res) {
                console.log('! eth1 is down kill autossh PID' + res);
                process.kill(res, 'SIGKILL');
            } else {
                // console.log('eth1 is down, so is ssh');
            }
        });
    }
    crun = false;
}

setInterval(sendres, 10 * 1000);
setInterval(checknet, 3000);

