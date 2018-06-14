'use strict'

app.controller('ComposeController', [
  '$scope',
  '$rootScope',
  '$http',
  'ComposeService',
  function(
    $scope,
    $rootScope,
    $http,
    ComposeService) {

  var init = function () {
      $scope.sentiment = {};

      $scope.updateUrl = function(sentiment) {
        $scope.sentiment = angular.copy(sentiment);
        postUrl($scope.sentiment.url)
      };

      $scope.updateText = function(sentiment) {
        $scope.sentiment = angular.copy(sentiment);
        postText($scope.sentiment.text);
      }

      $scope.reset = function() {
        $scope.sentiment = {};
      };

      $scope.reset();

      function postText(args){
        ComposeService.PostText(args,
          function successCB(response) {
            if(response.status == 'success'){
              $scope.data = response.data;
            }
          },
          function errorCB(response) {
            console.log('Get DO Error: ', response);
          }
        );
      }

      function postUrl(args){
        ComposeService.PostUrl(args,
          function successCB(response) {
            console.log("URLresponse::::::: ", response);
            if(response.status == 'success'){
              $scope.data = response;
            }
          },
          function errorCB(response) {
            console.log('Get DO Error: ', response);
          }
        );
      }
  };

  init();
}]);
