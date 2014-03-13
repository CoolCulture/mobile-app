'use strict';

describe('Controller: MuseumCtrl', function () {

  // load the controller's module
  beforeEach(module('mobileAppApp'));

  var MuseumCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    MuseumCtrl = $controller('MuseumCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of museums to the scope', function () {
    expect(scope.museums.length).toBe(3);
  });
});
