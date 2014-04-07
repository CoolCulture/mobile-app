'use strict';

describe('Filter: museumAdmissionFilter', function () {

  // load the filter's module
  beforeEach(module('coolCultureApp'));

  // initialize a new instance of the filter before each test
  var museumAdmissionFilter;
  var allMuseums;

  beforeEach(inject(function ($filter) {
    museumAdmissionFilter = $filter('museumAdmissionFilter');
    allMuseums = [
                    {"id":"1",
                    "name":"Art and Science Museum",
                    "freeAdmission": true,
                    "suggestedDonation": false
                    },
                    {"id":"2",
                    "name":"History Museum",
                    "freeAdmission": false,
                    "suggestedDonation": false
                    },
                    {"id":"3",
                    "name":"Science Museum",
                    "freeAdmission": true,
                    "suggestedDonation": true
                    },
					{"id":"4",
					"name":"Art Museum",
					"freeAdmission": false,
                    "suggestedDonation": true
					}
    			];
  }));

  it('should return museums with free admission if "Free" is one of the admission types', function () {
    var museumAdmissions = ['Free'];
    var expectedMuseums = [
                            {"id":"1",
                            "name":"Art and Science Museum",
                            "freeAdmission": true,
                            "suggestedDonation": false
                            },
                            {"id":"3",
                            "name":"Science Museum",
                            "freeAdmission": true,
                            "suggestedDonation": true
                            }
                        ];
    expect(museumAdmissionFilter(allMuseums, museumAdmissions)).toEqual(expectedMuseums);
  });

  it('should return museums with suggested donation admission if "Suggested Donation" is one of the admission types', function () {
    var museumAdmissions = ['Suggested Donation'];
    var expectedMuseums = [
                            {"id":"3",
                            "name":"Science Museum",
                            "freeAdmission": true,
                            "suggestedDonation": true
                            },
                            {"id":"4",
                            "name":"Art Museum",
                            "freeAdmission": false,
                            "suggestedDonation": true
                            }
                        ];
    expect(museumAdmissionFilter(allMuseums, museumAdmissions)).toEqual(expectedMuseums);
  });

	it('should return all museums when given no admission types', function () {
		var noAdmissionTypes = [];
    	expect(museumAdmissionFilter(allMuseums, noAdmissionTypes)).toEqual(allMuseums);
	})

});
