var cordova = require('cordova'),
    exec = require('cordova/exec');
window.echo = function(str, callback) {
    cordova.exec(callback, function(err) {
        callback('Nothing to echo.');
    }, "EchoABC", "echo", [str]);
};
module.exports = window.echo;
