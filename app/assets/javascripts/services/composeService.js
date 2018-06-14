'use strict';

app.factory('ComposeService', [
    '$http',
    '$rootScope',
    function($http, $rootScope) {
      var service = {};

      service.PostText = function(args, successCB, errorCB) {
        var data = $.param({text: args})
        $http.post('/api/get-text-sentiment', data)
        .success(function(response) {
          successCB(response.response);
        })
        .error(function(response) {
          errorCB(response.response);
        });
      }

      service.PostUrl = function(args, successCB, errorCB) {
        var data = $.param({url: args});
        $http.post('/api/get-url-sentiment', data)
        .success(function(response) {
          successCB(response.response);
        })
        .error(function(response) {
          errorCB(response.response);
        });
      }

    return service;
  }
]);
