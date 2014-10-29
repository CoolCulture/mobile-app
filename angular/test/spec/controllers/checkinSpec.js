'use strict';

describe('Controller: CheckinCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var CheckinCtrl,
    scope, routeParams, CheckinsMock, deferred, data;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope, $httpBackend) {
    scope = $rootScope.$new();
    routeParams = {id: 'museum-modern-art'};

    CheckinsMock = {
      get : function(data) {
      }
    };

    CheckinCtrl = $controller('CheckinCtrl', {
      $scope: scope,
      Checkins: CheckinsMock,
      $routeParams: routeParams
    });
  }));

  it('should assign default checkin data with museum id', function(){
    expect(scope.checkinData.museumId).toBe('museum-modern-art');
    expect(scope.checkinData.familyCardId).toBe('');
    expect(scope.checkinData.lastName).toBe('');
    expect(scope.checkinData.checkin.numberOfAdults).toBe(0);
    expect(scope.checkinData.checkin.numberOfChildren).toBe(0);
  });

  xit('should check in to museum family when checkin is called', function() {
    scope.checkinData = {
      museumId: 'museum-modern-art',
      familyCardId: '12345',
      lastName: 'Cooling',
      checkin: {
        numberOfChildren: 2,
        numberOfAdults: 3
      }
    };

    spyOn(CheckinsMock, 'checkin').andCallThrough();

    scope.checkin();

    expect(CheckinsMock.get).toHaveBeenCalled();
  });

});
