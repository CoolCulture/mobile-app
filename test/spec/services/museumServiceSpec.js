'use strict';

describe('Service: MuseumService', function () {

  // load the service's module
  beforeEach(module('coolCultureApp'));

  // instantiate service
  var MuseumService;
  beforeEach(inject(function (_MuseumService_) {
    MuseumService = _MuseumService_;
  }));

  it('should request all museums', function () {
    var museums = MuseumService.requestAllMuseums();

    expect(museums.length).toBe(11);
  });

  it('should request specific museum with id', function () {
    var museum = MuseumService.requestMuseum(1);

    expect(museum.name).toBe('American Museum of Natural History');
  });
});
