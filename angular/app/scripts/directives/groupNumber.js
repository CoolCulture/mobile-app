'use strict';

angular.module('coolCultureApp')
  .directive('groupNumber', function () {
    return {
      template:  "<div class='badge badge-group-number' "+
                        "ng-class='{active: option == number}'"+
                        "ng-repeat='option in options' "+
                        "ng-click='activate(option)'>{{option}} "+
                      "</div>",
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
