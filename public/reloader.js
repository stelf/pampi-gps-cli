
const ifr = document.getElementById('actual');

function whenRead() {
  let ifr = document.getElementById('appframe');

  setInterval(() =>
    fetch("http://dev2-bg.plan-vision.com:3000/?rand=" + Math.floor((1 + Math.random()) * 0x10000), {
      mode: 'no-cors'
    }).then(res => {
      if ( res.status === 0 && ifr.src.indexOf('dev2-bg.plan-vision.com') > -1 ) {
        console.log("connection to server seems fine");
      }

      if ( res.status === 0 && ifr.src.indexOf('dev2-bg.plan-vision.com') === -1 ) {
        console.log("not connected. need to load eet.");
        ifr.src = "http://dev2-bg.plan-vision.com:3000";
      } 

    }).catch(err => {
      console.log("interface down or connection totally unavailable.");
      ifr.src ="loader.html";
    }), 5 * 1000);
}
