'use strict';

describe('Filter: displayMuseumIdFilter', function () {

  // load the filter's module
  beforeEach(module('coolCultureApp'));

  // initialize a new instance of the filter before each test
  var displayMuseumIdFilter;
  beforeEach(inject(function ($filter) {
    displayMuseumIdFilter = $filter('displayMuseumIdFilter');
  }));

  it('should return the input with parentheses and dashes removed', function () {
    var museum_id = 'museum-of-modern-art';
    expect(displayMuseumIdFilter(museum_id)).toBe('MUSEUM OF MODERN ART');
  });

});
