cordova.define("cordova/plugin/IAPPlugin",
  function (require, exports, module) {
    var exec = require('cordova/exec');

    function IAPPlugin() {};

    
    IAPPlugin.prototype.productList = function(productList, successCallback, errorCallback){
        exec(successCallback, errorCallback, "IAPPlugin", "productList", [productList]);
    };

    module.exports = new IAPPlugin();
});