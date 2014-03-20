'use strict';

describe('Directive: subwayLines', function () {

  // load the directive's module
  beforeEach(module('coolCultureApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make list out the list of subwayLines', inject(function ($compile) {
    scope.lines = ['4','5','6'];
    element = angular.element('<subway-lines lines="lines"></subway-lines>');
    element = $compile(element)(scope);
    scope.$digest();

    expect(element.find('span').eq(0).hasClass('badge-4')).toBe(true);
    expect(element.find('span').eq(1).hasClass('badge-5')).toBe(true);
    expect(element.find('span').eq(2).hasClass('badge-6')).toBe(true);
  }));
});
