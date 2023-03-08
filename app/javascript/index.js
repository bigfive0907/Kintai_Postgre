function set(num) {
  // 桁数が1桁だったら先頭に0を加えて2桁に調整する
  var ret;
  if( num < 10 ) { ret = "0" + num; }
  else { ret = num; }
  return ret;
}

function showClock2() {
  var now = new Date();
  var nowHour = set( now.getHours() );
  var nowMin  = set( now.getMinutes() );
  var nowSec  = set( now.getSeconds() );
  var msg =  nowHour + " : " + nowMin + " : " + nowSec ;
  var text = document.getElementById("ClockArea");
  text.innerHTML = msg;
}
setInterval('showClock2()',1000);

const buttonOpen = document.getElementById('modalOpen');
const modal = document.getElementById('easyModal');
const buttonClose = document.getElementsByClassName('modalClose')[0];


