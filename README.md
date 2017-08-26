# cordova-plugin-baichuan

Cordova plugin for Baichuan SDK (阿里百川Cordova插件)

# Usage

## Show page 打开淘宝页面

```js
Baichuan.showPage(pageArgs, [taokeArgs, showArgs, exArgs], success, error);

/**
 * pageArgs: {
     *      type: 'itemDetailPage/shopPage/addCartPage/myOrdersPage/myCartsPage/page',
     *      itemId: '',
     *      shopId: '',
     *      allOrder: true/false,
     *      url: ''
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
```

## 全局设置页面

```js
Baichuan.setting(settings, success, error);

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
```

# Prepare 安装预备(必读)

  1. [注册您的百川账号](http://baichuan.taobao.com/portal/index.htm)
   
  2. 创建 百川无线应用
      
  3. 完善你的应用 基本信息
      
  4. 申请开通 初级电商能力
      
  5. 生成安全图片，放置正确位置
     
# Install

```cordova plugin add https://github.com/wenin819/cordova-plugin-baichuan.git```

# 注意事项
## Android

1. 根据实际情况，`AndroidManifest.xml`可能需要变动，如`application`需要加`tools:replace="android:label,android:allowBackup"`;
1. 不能直接Debug运行，这样会异常闪退，直接运行是没有这个问题。

## IOS

1. 可能需要手工加`Other Linker Flags`，对应的配置项为：`-lstdc++ -ObjC`；

# 参考链接
1. [更多百川信息](http://baichuan.taobao.com/doc2/detail?spm=a3c0d.7662649.0.0.XTcmuf&treeId=30&articleId=103655&docType=1)
1. [接入准备工作，安全图片生成](http://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.cO4gRJ&treeId=129&articleId=105645&docType=1)
1. [百川电商 Android SDK3.1接入文档](http://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.o0Y63N&treeId=129&articleId=105647&docType=1)
1. [百川电商 IOS SDK3.1接入文档](http://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.Mckp69&treeId=129&articleId=105648&docType=1)
