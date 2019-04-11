# [FastHybridKit](http://361teach.com/2019/04/08/FastHybridKit/) [ ![jssdk](https://img.shields.io/badge/jssdk-0.0.1-green.svg)](http://mianshizhijia.oss-cn-hangzhou.aliyuncs.com/FastHybridKit/jssdk.js) [![pod](https://img.shields.io/badge/pod-1.6.1-brightgreen.svg)](https://cocoapods.org/) ![license](https://img.shields.io/badge/license-MIT-yellow.svg)

## Features

<div>
<img src="http://mianshizhijia.oss-cn-hangzhou.aliyuncs.com/resourse_image/nav.gif" width="20%"> 
  
<img src="http://mianshizhijia.oss-cn-hangzhou.aliyuncs.com/resourse_image/toNative.gif" width="20%">

<img src="http://mianshizhijia.oss-cn-hangzhou.aliyuncs.com/resourse_image/storage.gif" width="20%">

<img src="http://mianshizhijia.oss-cn-hangzhou.aliyuncs.com/resourse_image/other.gif" width="20%">
</div>

# Content 

 - [FastHybridKit是什么](#fasthybridkit%E6%98%AF%E4%BB%80%E4%B9%88)
- [示例](#%E7%A4%BA%E4%BE%8B)
- [扩展](#%E6%89%A9%E5%B1%95)
- [如何使用FastHybridKit](#%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8fasthybridkit)
   - [Web 端](#web-%E7%AB%AF)
   - [iOS 端](#ios-%E7%AB%AF)
- [安全控制](#%E5%AE%89%E5%85%A8%E6%8E%A7%E5%88%B6)


## FastHybridKit是什么

**FastHybridKit**定义了一套**JS**中间层，业务端代码能用统一的方式调用**Native**端的事件，同时在**Native**端利用类名的映射，和参数格式固定化，达到动态跳转任意原生界面的目的，实现轻量级的热更新。

## 示例

* 获取Token
  
   * Api: `getToken`
   * 参数: 传入一个匿名函数，并拿到回调
  
  ``` js
  var $$ = function(id){
        return document.getElementById(id);
    }
    $$('getToken').addEventListener('click', function(e){
        gl.getToken(function(res){
            $$('getToken').innerHTML = res;
        })
    })
  ```

* 友盟统计
   
   * Api: `UMAnalytics`
   * 参数: 事件ID, 事件描述

``` js
$$('UMAnalytics').addEventListener('click', function(e){
        gl.UMAnalytics('123', 'Page A')
    })
```

* 对话框
   
   * Api: `dialog`
   * 参数: 内容，确认函数回调，取消函数回调
  
``` js
$$('dialog').addEventListener('click', function(e){
        gl.dialog('德玛西亚，永世长存', function(ok){
            gl.toast('Choice OK')
        }, function(cancle){
            gl.toast('Choice Cancle')
        })
    })
```
  
* Toast
  
  * Api: `toast`
  * 参数: 内容
  
``` js
$$('toast').addEventListener('click', function(e){
        gl.toast('Hybrid Demo')
    })
```

* 打开新的H5页面
  
  * Api: `openH5`
  * 参数: `nav_hidden`(是否隐藏), `title`(标题), `url`(链接)
  * 参数格式: 对象

``` js
$$('openH5').addEventListener('click', function(e){
        gl.openH5({nav_hidden:false, title:"MyBlog", url:"http://361teach.com"})
    })
```

* 跳转原生
  
  * Api: open
  * 方式1: 直接调用  （只针对某一端）
  * 参数1: (某端)类名， 自己包装传参
  * 方式2: 根据注册的方法表调用 iOS 安卓都响应
  * 参数2: 类名，参数， （考虑到安卓、iOS 参数命名不同 ，jssdk 负责为各端包装参数）

示例1 
``` js
// className 为 iOS 端的类名
$$('openNative').addEventListener('click', function(e){
        var className = $$('pageName').value;
        var args = $$('args').value;
        gl.open({n:className, v:{arg:args}})
    })
```

示例2

``` js
// match_detail 为 jssdk里注册的方法 实现双端响应
$$('openNative').addEventListener('click', function(e){
        gl.open({n:'match_detail', v:{sid:1}})
    })
```

* 设置导航
  
  * Api: `nav`
  * 参数: `nav_hidden`(是否隐藏导航), `title`（标题）, `left`(左Itmes),`right`(右items)

``` js
$$('nav').addEventListener('click', function(e){
        var className = $$('nav_pageName').value;
        var args = $$('nav_args').value;
        gl.nav({nav_hidden: false, title:'Hybrid', left:[], right:[{icon:'', func:'openNative:', vars:{n:className, v:{arg: args}}}]})
    })
```

* 扩展Web存储
  
  * Api: webStorage
  * 参数: `key`,  `value`
  
``` js
 $$('webStorage').addEventListener('click', function(e){
        var k = $$('keyInput').value
        var v = $$('valueInput').value
        gl.webStorage(k,v);
    })
```

* 打开外部浏览器
   
   * Api: `openBrowser`
   * 参数: `urL`
  
``` js
 $$('openBrowser').addEventListener('click', function(e){
        gl.openBrowser('http://361teach.com')
    })
```

## 扩展

如果**jssdk**里的功能无法满足你的业务需求，可以自己进行扩展

1. 扩展新的功能
    
    在**jssdk**的`gl`对象上添加新的属性，同时还需要在**Native**注册新的方法名

2. 扩展新的模块名
   
   **jssdk**维护一个方法注册列表
   ``` js
   nativeClsDict: {
			match_detail: function (i) {
				if (gl.platform.android) {
					return ["your class name", {
							sid: i.sid || "",
							CurrentIndex: i.CurrentIndex || 0,
							Tran: i.Tran || ""
						}
					];
				}
				return ["your class name", {
						id: i.sid,
						linkType: i.CurrentIndex || 0,
						currentIndex: 0
					}
				];
			},
		}
   ```
   如果要跳转新的模块，在这个注册列表里定义新的模块名，并配置参数，同时更新H5引入的**jssdk**版本

## 如何使用FastHybridKit

### Web 端

1. 引入`demo`中提供的**jssdk**地址, 不建议这么做，无法动态扩展
    ``` js
    <script type="text/javascript" src="http://mianshizhijia.oss-cn-hangzhou.aliyuncs.com/FastHybridKit/jssdk.js"></script>
    ```
2. 将**jsdk**下载下来，上传到自己公司服务器，或者打包在项目中，便于维护和扩展
   
### iOS 端

**iOS**端只需将**JSTool**手动引入项目中，并依赖[YYModel](https://github.com/ibireme/YYModel)，和[SDWebImage](https://github.com/SDWebImage/SDWebImage)

## 安全控制

出于安全考虑，不建议用cdn的方式引入**jssdk**，容易被拦截从而获取得到`token`和和其它关键信息的方法，直接打包到项目中，又无法动态的更新，可以使用预下载的方式，使用`md5`校验，防止被篡改，同时采用分级管理，内部使用的等级较高，使用全部Api，暴露给外部（比如广告商）权限较低，不涉及隐私方法的调用.

# 延伸阅读
[深入解析WebViewJavascriptBridge](https://www.jianshu.com/p/bf8eaa63062e)
