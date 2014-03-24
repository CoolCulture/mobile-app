'use strict';

describe('Filter: phoneNumberFilter', function () {

  // load the filter's module
  beforeEach(module('coolCultureApp'));

  // initialize a new instance of the filter before each test
  var phoneNumberFilter;
  beforeEach(inject(function ($filter) {
    phoneNumberFilter = $filter('phoneNumberFilter');
  }));

  it('should return the input with parentheses and dashes removed', function () {
    var phoneNumber = '(212)-555-5555';
    expect(phoneNumberFilter(phoneNumber)).toBe('2125555555');
  });

});
