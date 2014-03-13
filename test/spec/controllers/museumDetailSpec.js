'use strict';

describe('Controller: MuseumDetailCtrl', function () {

  // load the controller's module
  beforeEach(module('mobileAppApp'));

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

  it('should have the details of the museum with id included in route', function (){
    expect(scope.museum.name).toBe('Museum of Modern Art');
  });
});
