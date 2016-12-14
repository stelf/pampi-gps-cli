
const ifr = document.getElementById('actual');

// hostReachable() taken from
// from: https://gist.github.com/jpsilvashy/5725579

function whenRead() {
  const loc = "http://dev2-bg.plan-vision.com:3000/?rand=" + Math.floor((1 + Math.random()) * 0x10000);
  let ifr = document.getElementById('appframe');

  setInterval(() =>
    fetch(loc, {
      mode: "no-cors"
    }).then(res => {
      if ( ifr.src.indexOf('dev2-bg.plan-vision.com') === -1 ) {
        console.log("not connected. need to load");
        ifr.src = "http://dev2-bg.plan-vision.com:3000";
      } else {
        console.log("main thread is good");
      }
    }).catch(err => {
      console.log("connection unavailable");
      ifr.src ="loading.html";
    }), 5* 1000);
}
