'use strict';

describe('Filter: museumBoroughFilter', function () {

  // load the filter's module
  beforeEach(module('coolCultureApp'));

  // initialize a new instance of the filter before each test
  var museumBoroughFilter;
  var allMuseums;

  beforeEach(inject(function ($filter) {
    museumBoroughFilter = $filter('museumBoroughFilter');
    allMuseums = [
    				{"id":"1",
    				"name":"Brooklyn Museum",
    				"borough":"Brooklyn"
    				},
    				{"id":"2",
    				"name":"Manhattan Museum",
    				"borough":"Manhattan"
    				},
                    {"id":"3",
                    "name":"Staten Island Museum",
                    "borough":"Staten Island"
                    },
    				{"id":"3",
    				"name":"Staten Island Museum 2",
    				"borough":"Staten Island"
    				}
    			];
  }));

  it('should return museums that match any field in search criteria', function () {
    var museumBoroughs = ['Brooklyn', 'Staten Island'];
    var expectedMuseums = [
                    {"id":"1",
                    "name":"Brooklyn Museum",
                    "borough":"Brooklyn"
                    },
                    {"id":"3",
                    "name":"Staten Island Museum",
                    "borough":"Staten Island"
                    },
                    {"id":"3",
                    "name":"Staten Island Museum 2",
                    "borough":"Staten Island"
                    }
                ];
    expect(museumBoroughFilter(allMuseums, museumBoroughs)).toEqual(expectedMuseums);
  });

	it('should return all museums when given no filters', function () {
		var noBoroughs = [];
    	expect(museumBoroughFilter(allMuseums, noBoroughs)).toEqual(allMuseums);
	})

});