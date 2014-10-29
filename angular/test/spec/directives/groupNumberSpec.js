'use strict';

describe('Directive: groupNumber', function () {

  // load the directive's module
  beforeEach(module('coolCultureApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make list out the list of subwayLines', inject(function ($compile) {
    scope.numberOfChildren = 2;
    scope.options = ['1','2','3','4','5'];

    element = angular.element('<group-number options="options" number="numberOfChildren"></group-number>');
    element = $compile(element)(scope);
    scope.$digest();

    expect(element.find('div').eq(1).hasClass('active')).toBe(true);
  }));
});
