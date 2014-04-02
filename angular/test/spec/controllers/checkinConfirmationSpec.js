'use strict';

describe('Controller: CheckinConfirmationCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var CheckinConfirmationCtrl,
    scope, routeParams;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope, $httpBackend) {
    scope = $rootScope.$new();
    routeParams = {id: 'museum-modern-art', number: 3};

    CheckinConfirmationCtrl = $controller('CheckinConfirmationCtrl', {
      $scope: scope,
      $routeParams: routeParams
    });
  }));

  it('should assign group number and museum id', function(){
    expect(scope.museum_id).toBe('museum-modern-art');
    expect(scope.groupNumber).toBe(3);
  });
});
