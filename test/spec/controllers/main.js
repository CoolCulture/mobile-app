'use strict';

describe('Controller: MainCtrl', function () {

  // load the controller's module
  beforeEach(module('mobileAppApp'));

  var MainCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    MainCtrl = $controller('MainCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function () {
    expect(scope.awesomeThings.length).toBe(3);
  });

  it('should be able to add', function () {
    expect(2+2).toBe(4);
  });

});

