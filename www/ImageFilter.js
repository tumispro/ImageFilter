/*
Copyright (c) 2012 Drew Dahlman MIT LICENSE
*/

var ImageFilter = function () {};

ImageFilter.prototype.clean = function (options) {
    cordova.exec(null, null, "ImageFilter", "clean", [options]);
};

ImageFilter.prototype.none = function (done, error, options) {
    //console.log(options+" "+done);
    var defaults = {
        image: '',
        save: '',
    };
    for(var key in defaults) {
        if(typeof options[key] !== "undefined") defaults[key] = options[key];
    }

    return cordova.exec(done,error,"ImageFilter","none",[defaults]);
};

ImageFilter.prototype.sunnySide = function (done, error, options) {
    var defaults = {
        image: '',
        save: '',
    };
    for(var key in defaults) {
        if(typeof options[key] !== "undefined") defaults[key] = options[key];
    }
    return cordova.exec(done, error, "ImageFilter","sunnySide",[defaults]);
};

ImageFilter.prototype.worn = function (done, error ,options) {
    var defaults = {
        image: '',
        save: '',
    };
    for(var key in defaults) {
        if(typeof options[key] !== "undefined") defaults[key] = options[key];
    }
   	return cordova.exec(done,error,"ImageFilter","worn",[defaults]);
};

ImageFilter.prototype.vintage = function (done,error,options) {
    var defaults = {
        image: '',
        save: '',
    };
    for(var key in defaults) {
        if(typeof options[key] !== "undefined") defaults[key] = options[key];
    }
    return cordova.exec(done,error,"ImageFilter","vintage",[defaults]);
};

ImageFilter.prototype.stark = function (done,error,options) {
    var defaults = {
        image: '',
        save: '',
    };
    for(var key in defaults) {
        if(typeof options[key] !== "undefined") defaults[key] = options[key];
    }
    return cordova.exec(done,error,"ImageFilter","stark",[defaults]);
};

ImageFilter.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.ImageFilter = new ImageFilter();
  return window.plugins.ImageFilter;
};

cordova.addConstructor(ImageFilter.install);