'use strict';

describe('Service: CheckinService', function () {

  // load the service's module
  beforeEach(module('coolCultureApp'));

  // instantiate service
  var CheckinService, httpBackend;
  beforeEach(inject(function (_CheckinService_, _$httpBackend_) {
    CheckinService = _CheckinService_;
    httpBackend = _$httpBackend_;
  }));

  it('with valid should checkin to museum', function () {

    httpBackend.expect('POST', '/api/checkin')
      .respond(201, '{ "number_of_children": 3, "number_of_adults": 2 }');

    var museumCheckin = {
                                          "museum_id": "museum-of-modern-art",
                                          "family_card_id": "12345",
                                          "last_name": "Cooling",
                                          "checkin": {
                                            "number_of_children" : "3",
                                            "number_of_adults" : "2"
                                          }
                                        };

    CheckinService.checkin(museumCheckin).success(function(data){
      expect(data.number_of_adults).toBe(2);
      expect(data.number_of_children).toBe(3);
    });

    httpBackend.flush();
  });
});
