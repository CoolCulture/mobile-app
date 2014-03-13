'use strict';

describe('Service: Museumservice', function () {

  // load the service's module
  beforeEach(module('mobileAppApp'));

  // instantiate service
  var Museumservice;
  beforeEach(inject(function (_Museumservice_) {
    Museumservice = _Museumservice_;
  }));

  it('should do something', function () {
    expect(!!Museumservice).toBe(true);
  });

});
