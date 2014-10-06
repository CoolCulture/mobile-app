'use strict';

describe('Service: Checkins', function () {

  // load the service's module
  beforeEach(module('coolCultureApp'));

  // instantiate service
  var Checkins, httpBackend;
  beforeEach(inject(function (_Checkins_, _$httpBackend_) {
    Checkins = _Checkins_;
    httpBackend = _$httpBackend_;
  }));

  it('with valid last name and family id should checkin to museum', function () {

    httpBackend.expect('POST', '/api/checkins')
      .respond(201, '{ "numberOfChildren": 3, "numberOfAdults": 2 }');

    var museumCheckin = {
                                          "museum_id": "museum-of-modern-art",
                                          "family_card_id": "12345",
                                          "last_name": "Cooling",
                                          "checkin": {
                                            "number_of_children" : "3",
                                            "number_of_adults" : "2"
                                          }
                                        };

    Checkins.save(museumCheckin, function(checkin){
      expect(checkin.numberOfAdults).toBe(2);
      expect(checkin.numberOfChildren).toBe(3);
    });

    httpBackend.flush();
  });

   it('with invalid last name and family id should checkin to museum', function () {

    httpBackend.expect('POST', '/api/checkins')
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

    Checkins.save({},museumCheckin,null,function(response){
      expect(response.data).toBe(null);
    });

    httpBackend.flush();
  });

  it('should get specific checkin', function () {

    httpBackend.expect('GET', '/api/checkins/the-slug')
      .respond(200, '{"date":"2014-04-04","family_card_id":10000,"last_name":"Cooling", "number_of_adults":3,"number_of_children":2}');

    Checkins.get({id: 'the-slug'}, function(checkin){
      expect(checkin.number_of_adults).toBe(3);
      expect(checkin.number_of_children).toBe(2);
      expect(checkin.date).toBe('2014-04-04');
      expect(checkin.family_card_id).toBe(10000);
      expect(checkin.last_name).toBe('Cooling');
    });

    httpBackend.flush();
  });

});
