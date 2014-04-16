'use strict';

angular.module('coolCultureApp')
  .controller('MainCtrl', function ($scope, $rootScope, $window, $location) {
        $scope.slide = '';
        $rootScope.back = function() {
          $scope.slide = 'slide-right';
          $window.history.back();
        };
        $rootScope.go = function(path){
          $scope.slide = 'slide-left';
          $location.url(path);
        };

        $rootScope.loading = false;
      });
