'use strict';

describe('Controller: MuseumDetailCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var MuseumDetailCtrl,
    scope, routeParams;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    routeParams = {id: '1'};
    MuseumDetailCtrl = $controller('MuseumDetailCtrl', {
      $scope: scope,
      $routeParams: routeParams
    });
  }));


});
