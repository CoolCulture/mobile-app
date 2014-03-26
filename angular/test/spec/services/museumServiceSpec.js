'use strict';

describe('Service: MuseumService', function () {

  // load the service's module
  beforeEach(module('coolCultureApp'));

  // instantiate service
  var MuseumService, httpBackend;
  beforeEach(inject(function (_MuseumService_, _$httpBackend_) {
    MuseumService = _MuseumService_;
    httpBackend = _$httpBackend_;
  }));

  it('should request all museums', function () {

    httpBackend.expect('GET', '/api/museums.json')
      .respond(200, '[ {"id": "1", "name": "American Museum of Natural History" }]');

    MuseumService.requestAllMuseums().success(function(museums){
      expect(museums.length).toBe(1);
    });

    httpBackend.flush();
  });

  it('should request specific museum with id', function () {

    httpBackend.expect('GET', '/api/museums/1.json')
      .respond(200, '[ {"id": "1", "name": "American Museum of Natural History" }]'
    );

      MuseumService.requestMuseum(1).success(function(museum) {
        expect(museum.name).toBe('American Museum of Natural History')
      });
  });
});
