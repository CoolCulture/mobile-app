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

  it('should format activity times correctly', function(){
    var activity = {date: null};
    expect(scope.formatActivityTime(activity)).toBe(null);
    activity = {date: '2014-10-31'}
    expect(scope.formatActivityTime(activity)).toBe("10/31/2014");
    activity.startTime = "10:00 AM";
    expect(scope.formatActivityTime(activity)).toBe("10/31/2014, 10:00 AM");
    activity.endTime = "2:00 PM";
    expect(scope.formatActivityTime(activity)).toBe("10/31/2014, 10:00 AM - 2:00 PM");
  });
});
