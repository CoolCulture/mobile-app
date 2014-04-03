'use strict';

describe('Filter: siteUrlFilter', function () {

  // load the filter's module
  beforeEach(module('coolCultureApp'));

  // initialize a new instance of the filter before each test
  var siteUrlFilter;
  beforeEach(inject(function ($filter) {
    siteUrlFilter = $filter('siteUrlFilter');
  }));

  it('should prepend http:// to misformatted siteUrl', function () {
    var siteUrl = 'www.google.com';
    expect(siteUrlFilter(siteUrl)).toBe('http://www.google.com');
  });

  it('should not prepend http:// to correctly formatted siteUrl', function () {
    var siteUrl = 'http://www.google.com';
    expect(siteUrlFilter(siteUrl)).toBe('http://www.google.com');
  });

});
