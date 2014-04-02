'use strict';

angular.module('coolCultureApp')
  .directive('groupNumber', function () {
    return {
      template:  "<a class='badge badge-group-number' "+
                        "ng-class='{active: option == number}'"+
                        "ng-repeat='option in options' "+
                        "ng-click='activate(option)'>{{option}} "+
                      "</a>",
      restrict: 'E',
      controller: function($scope){
            $scope.activate = function(option){
                $scope.number = option;
            };
        },
      scope: {
        options: '=options',
        number: '=number'
      }
    };
  });
