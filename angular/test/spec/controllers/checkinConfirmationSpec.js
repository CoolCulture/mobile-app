'use strict';

describe('Controller: CheckinConfirmationCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var CheckinConfirmationCtrl,
    scope, routeParams;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope, $httpBackend) {
    scope = $rootScope.$new();
    routeParams = {id: 'museum-modern-art', family_card_id: 10000};

    CheckinConfirmationCtrl = $controller('CheckinConfirmationCtrl', {
      $scope: scope,
      $routeParams: routeParams
    });
  }));

  it('should assign group number and museum id', function(){
    expect(scope.checkinTicket.museumId).toBe('museum-modern-art');
    expect(scope.checkinTicket.familyCardId).toBe(10000);
  });
});
