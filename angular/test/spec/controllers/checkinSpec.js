'use strict';

describe('Controller: CheckinCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var CheckinCtrl,
    scope, routeParams;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    routeParams = {id: '1'};
    CheckinCtrl = $controller('CheckinCtrl', {
      $scope: scope,
      $routeParams: routeParams
    });
  }));


});
