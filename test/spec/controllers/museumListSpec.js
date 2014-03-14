'use strict';

describe('Controller: MuseumListCtrl', function () {

  // load the controller's module
  beforeEach(module('coolCultureApp'));

  var MuseumListCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function ($controller, $rootScope) {
    scope = $rootScope.$new();
    MuseumListCtrl = $controller('MuseumListCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of museums to the scope', function () {
    expect(scope.museums.length).toBe(3);
  });
});
