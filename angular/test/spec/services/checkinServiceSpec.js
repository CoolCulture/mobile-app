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

  it('with valid last name and family id should checkin to museum', function () {

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

   it('with invalid last name and family id should checkin to museum', function () {

    httpBackend.expect('POST', '/api/checkin')
      .respond(422, null);

    var museumCheckin = {
                                          "museum_id": "museum-does-not-exist",
                                          "family_card_id": "12345",
                                          "last_name": "WrongLastName",
                                          "checkin": {
                                            "number_of_children" : "3",
                                            "number_of_adults" : "2"
                                          }
                                        };

    CheckinService.checkin(museumCheckin).error(function(data){
      expect(data).toBe(null);
    });

    httpBackend.flush();
  });

  it('should get specific checkin', function () {

    httpBackend.expect('GET', '/api/checkin?family_card_id=12345&museum_id=museum-of-modern-art')
      .respond(200, '{"date":"2014-04-04","family_card_id":10000,"last_name":"Cooling", "number_of_adults":3,"number_of_children":2}');

    var museumCheckin = {
                                          "museum_id": "museum-of-modern-art",
                                          "family_card_id": "12345"
                                        };

    CheckinService.getCheckin(museumCheckin).success(function(data){
      expect(data.number_of_adults).toBe(3);
      expect(data.number_of_children).toBe(2);
      expect(data.date).toBe('2014-04-04');
      expect(data.family_card_id).toBe(10000);
      expect(data.last_name).toBe('Cooling');
    });

    httpBackend.flush();
  });

});
