var express = require('express'),
    auth = require('http-auth'),
    fs = require('fs'),
    app = express();

var appEnv = process.env.APP_ENV;

var passwdFile = __dirname + '/../config/' + appEnv + '.htpasswd';

if (fs.existsSync(passwdFile)) {

  var basic = auth.basic({
      realm: appEnv,
      file: passwdFile
  });

  var basicAuth = auth.connect(basic);
  var skipAuthChecker = function(req, res, next) {
    var stringToCheck = req.headers['user-agent'];
    var pattern = 'Google Page Speed Insights';
    var shouldAuth = stringToCheck.indexOf(pattern) == -1;
    if(shouldAuth) {
      basicAuth(req, res, next);
    } else {
      next();
    }
  }

  app.use(skipAuthChecker);

}

app.use(express.static('./dist/'));

app.all('*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

app.set('port', process.env.PORT || 5000);

app.listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});
