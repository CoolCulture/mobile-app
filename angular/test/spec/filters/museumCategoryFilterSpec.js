'use strict';

describe('Filter: museumCategoryFilter', function () {

  // load the filter's module
  beforeEach(module('coolCultureApp'));

  // initialize a new instance of the filter before each test
  var museumCategoryFilter;
  var allMuseums;

  beforeEach(inject(function ($filter) {
    museumCategoryFilter = $filter('museumCategoryFilter');
    allMuseums = [
    					{"id":"1",
    					"name":"Art and Science Museum",
    					"categories":[
    						"Art",
    						"Science"
    						]
    					},
    					{"id":"2",
    					"name":"Art Museum",
    					"categories":[
    						"Art"
    						]
    					},
    					{"id":"3",
    					"name":"History and Science Museum",
    					"categories":[
    						"Science",
    						"History"
    						]
    					},
    					{"id":"4",
    					"name":"Other Museum",
    					"categories":[
    						"Other"
    						]
    					},
    					{"id":"5",
    					"name":"History Museum",
    					"categories":[
    						"History"
    						]
    					},
    					{"id":"6",
    					"name":"Science and Other Museum",
    					"categories":[
    						"Science",
    						"Other"
    						]
    					}
    					];
  }));

  it('should return museums that match any field in search criteria', function () {
    var museumCategories = ['Art', 'History'];
    var expectedMuseums = [
    					{"id":"1",
    					"name":"Art and Science Museum",
    					"categories":[
    						"Art",
    						"Science"
    						]
    					},
    					{"id":"2",
    					"name":"Art Museum",
    					"categories":[
    						"Art"
    						]
    					},
    					{"id":"3",
    					"name":"History and Science Museum",
    					"categories":[
    						"Science",
    						"History"
    						]
    					},
    					{"id":"5",
    					"name":"History Museum",
    					"categories":[
    						"History"
    						]
    					}
    					];
    expect(museumCategoryFilter(allMuseums, museumCategories)).toEqual(expectedMuseums);
  });

	it('should return all museums when given no filters', function () {
		var noCategories = [];
    	expect(museumCategoryFilter(allMuseums, noCategories)).toEqual(allMuseums);
	})

});
