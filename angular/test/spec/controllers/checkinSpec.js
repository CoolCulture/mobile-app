'use strict';

describe('Controller: CheckinCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var CheckinCtrl,
    scope, routeParams, CheckinServiceMock;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    routeParams = {id: 'museum-modern-art'};
    CheckinServiceMock = {
      checkin : function(data) {
      }
    };

    CheckinCtrl = $controller('CheckinCtrl', {
      $scope: scope,
      CheckinService: CheckinServiceMock,
      $routeParams: routeParams
    });
  }));

  it('should assign default checkin data with museum id', function(){
    expect(scope.checkinData.museum_id).toBe('museum-modern-art');
    expect(scope.checkinData.family_card_id).toBe('');
    expect(scope.checkinData.last_name).toBe('');
    expect(scope.checkinData.checkin.number_of_adults).toBe(0);
    expect(scope.checkinData.checkin.number_of_children).toBe(0);
  });

  it('should check in to museum family when checkin is called', function() {
    scope.checkinData = {
      museum_id: 'museum-modern-art',
      family_card_id: '12345',
      last_name: 'Cooling',
      checkin: {
        number_of_children: 2,
        number_of_adults: 3
      }
    };

    spyOn(CheckinServiceMock, 'checkin').andCallThrough();

    scope.checkin();

    expect(CheckinServiceMock.checkin).toHaveBeenCalled();
  });

});
