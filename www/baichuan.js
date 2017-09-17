var cordova = require('cordova');
var defaultSuccessHandler = function() {
    console.warn('baichuan exec success', arguments);
};
var defaultErrorHandler = function() {
    console.warn('baichuan exec fail', arguments);
};
module.exports = {
    /**
     * pageArgs: {
         *      type: 'itemDetailPage/shopPage/addCartPage/myOrdersPage/myCartsPage/page',
         *      itemId: '',
         *      shopId: '',
         *      allOrder: true/false,
         *      url: '',
         *      status: 0-4,    // 所要展示订单的订单状态
         *  }
     * [taokeArgs: {
         *      pid: '',
         *      adzoneid: '',
         *      subPid: '',
         *      unionId: '',
         *      key: ''
         *  }
     * showArgs: {
         *      openType: 'Auto/H5/Native', // 打开页面的方式
         *      backUrl: '',                // 指定手淘回跳的地址
         *      nativeFailMode: 'NONE/JumpBROWER/JumpDOWNLOAD/JumpH5',  // 跳手淘/天猫失败后的处理策略
         *
         *      // Android
         *      clientType: '',
         *      pageClose: true/false,
         *      proxyWebview: true/false,
         *      showTitleBar: true/false,
         *      title: '',
         *
         *      // IOS
         *      linkKey: '',    // applink使用，优先拉起的linkKey，手淘：@"taobao_scheme"
         *  }
     * exArgs: {
         *      自定义
         *  }]
     */
    showPage: function(pageArgs, options, success, error) {
        if(typeof options === 'function') {
            error = success;
            success = options;
            options = undefined;
        }
        options = options || [];
        var taokeArgs = options[0], showArgs = options[1], exArgs = options[2];
        success = success || defaultSuccessHandler;
        error = error || defaultErrorHandler;
        cordova.exec(success, error, 'BaichuanPlugin', 'showPage', [pageArgs, taokeArgs, showArgs, exArgs]);
    },
    /**
     * settings: {
         *      forceH5: true/false,
         *      syncForTaoke: true/false,
         *      taokeParams: 同上,
         *      channel: ['', ''],
         *      ISVCode: '',
         *      ISVVersion: '',
         *  }
     */
    setting: function(settings, success, error) {
        success = success || defaultSuccessHandler;
        error = error || defaultErrorHandler;
        cordova.exec(success, error, 'BaichuanPlugin', 'setting', [settings]);
    },
    /**
     * action: login/getSession/logout
     */
    auth: function(action, success, error) {
        success = success || defaultSuccessHandler;
        error = error || defaultErrorHandler;
        cordova.exec(success, error, 'BaichuanPlugin', 'auth', [action]);
    }
};