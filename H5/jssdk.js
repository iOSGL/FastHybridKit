!function () {
	function n(n) {
		if (!window.AndroidClient) {
			if (window.WebViewJavascriptBridge)
				return n(WebViewJavascriptBridge);
			if (document.addEventListener("WebViewJavascriptBridgeReady",
					function (i) {
					n(WebViewJavascriptBridge)
				},
					!1), window.WVJBCallbacks)
				return window.WVJBCallbacks.push(n);
			window.WVJBCallbacks = [n];
			var i = document.createElement("iframe");
			i.style.display = "none",
			i.src = "wvjbscheme://__BRIDGE_LOADED__",
			document.documentElement.appendChild(i),
			setTimeout(function () {
				document.documentElement.removeChild(i)
			},
				0)
		}
	}
	n(function (bridge) {
		bridge.init && "function" == typeof bridge.init && bridge.init(function (n, i) {}),
		bridge.registerHandler("jsCallBack",
			function (n, i) {
			var o = JSON.parse(n),
			a = o.id,
			e = o.val,
			c = gl.callbacks[a];
			c && (c.type && "json" == c.type && e && (e = JSON.parse(e)), c.success(e))
		})
	}),
	gl = {
		VERSION: "1.0.0",
		ready: function (i) {
			n(function () {
				i()
			}),
			window.AndroidClient && i()
		},
		IsHttps: (("https:" == document.location.protocol) ? true : false),
		platform: {
			ios: typeof(window.WebViewJavascriptBridge) == "object" || typeof(window.WVJBCallbacks) == "object",
			android: typeof(window.AndroidClient) == "object",
		},
		nativeClsDict: {
			match_detail: function (i) {
				if (gl.platform.android) {
					return ["activity.glMatchDetailActivity", {
							sid: i.sid || "",
							CurrentIndex: i.CurrentIndex || 0,
							Tran: i.Tran || ""
						}
					];
				}
				return ["FenxiPageVC", {
						id: i.sid,
						linkType: i.CurrentIndex || 0,
						currentIndex: 0
					}
				];
			},
		},
		callbacks: {},
		iosConnect: n,
		jsCallBack: function (n, i) {
			var o = gl.callbacks[n];
			o && (o.type && "json" == o.type && i && (i = JSON.parse(i)), o.success(i))
		},
		isEmpty: function(obj){
			if(typeof obj == "undefined" || obj == null || obj == ""){
				return true;
			}else{
				return false;
			}
		},
		addEventListener: function (e, f) {
			gl.callbacks.fireEvent = {
				type: "",
				success: function (e) {
					var ev = document.createEvent("HTMLEvents");
					ev.initEvent(e, false, true);
					document.dispatchEvent(ev);
				}
			};
			console.log("JC---:" + e);
			document.addEventListener(e, f);
		},
		getResource: function (i) {
			i && (gl.callbacks.getResource = {
					type: "json",
					success: i
				},
				window.AndroidClient && window.AndroidClient.getResource(), n(function (n) {
					n.callHandler("getResource", "",
						function (n) {})
				}))
		},
		getLocation: function (i) {
			i && (gl.callbacks.getLocation = {
					type: "json",
					success: i
				},
				window.AndroidClient && window.AndroidClient.getLocation(), n(function (n) {
					n.callHandler("getLocation", "",
						function (n) {})
				}))
		},
		closeWin: function () {
			window.AndroidClient && window.AndroidClient.closeWin(),
			n(function (n) {
				n.callHandler("closeWin", "",
					function (n) {})
			})
		},
		camera: function (i) {
			gl.callbacks.cameraPreview = {
				type: "json",
				success: i.preview
			},
			gl.callbacks.cameraSuccess = {
				type: "json",
				success: i.success
			},
			gl.callbacks.cameraFail = {
				type: "json",
				success: i.fail
			};
			var o = JSON.stringify(i);
			window.AndroidClient && window.AndroidClient.camera(o),
			n(function (n) {
				n.callHandler("camera", o,
					function (n) {})
			})
		},
		setData: function (i) {
			var o = JSON.stringify(i);
			window.AndroidClient && window.AndroidClient.setData(o),
			n(function (n) {
				n.callHandler("setData", o,
					function (n) {})
			})
		},
		share: function (i, o, a) {
			gl.callbacks.shareSuccess = {
				type: "",
				success: o
			};
			gl.callbacks.shareFailed = {
				type: "",
				success: a
			};

			gl.info(function (res) {

				//当share的linkurl前缀不是http开头时将h5Patch作为前缀拼接到linkurl上;
				if (res.h5Path && i.linkurl && i.linkurl.substr(0, 4) !== "http") {
					i.linkurl = res.h5Path + i.linkurl;
				}

				var d = JSON.stringify(i);
				window.AndroidClient && window.AndroidClient.share(d),
				n(function (n) {
					n.callHandler("share", d,
						function (n) {})
				})
			});
		},
		pay: function (t, i, o, a) {
			i = {
				type: t,
				data: i
			};
			var d = JSON.stringify(i);
			gl.callbacks.paySuccess = {
				type: "",
				success: o
			},
			gl.callbacks.payFailed = {
				type: "",
				success: a
			},
			window.AndroidClient && window.AndroidClient.pay(d),
			n(function (n) {
				n.callHandler("pay", d,
					function (n) {})
			})
		},
		shareInfo: function (i) {
			window.AndroidClient && window.AndroidClient.shareInfo(i),
			n(function (n) {
				n.callHandler("shareInfo", i,
					function (n) {})
			})
		},
		scanQR: function (i) {
			i && (gl.callbacks.scanQR = {
					type: "",
					success: i
				},
				window.AndroidClient && window.AndroidClient.scanQR(), n(function (n) {
					n.callHandler("scanQR", "",
						function (n) {})
				}))
		},
		toast: function (i, t) {
			if (typeof(i) == "string") {
				i = {
					text: i,
					time: t || 1000
				};
			}
			var d = JSON.stringify(i);
			window.AndroidClient && window.AndroidClient.toast(d),
			n(function (n) {
				n.callHandler("toast", d,
					function (n) {})
			})
		},
		dialog: function (i, a, b) {
			var o = JSON.stringify(i);
			gl.callbacks.dialogSuccess = {
				type: "",
				success: a
			},
			gl.callbacks.dialogCancel = {
				type: "",
				success: b
			},
			window.AndroidClient && window.AndroidClient.dialog(o),
			n(function (n) {
				n.callHandler("dialog", o,
					function (n) {})
			})
		},
		progress: function () {
			window.AndroidClient && window.AndroidClient.progress(),
			n(function (n) {
				n.callHandler("progress", "",
					function (n) {})
			})
		},
		hideProgress: function () {
			window.AndroidClient && window.AndroidClient.hideProgress(),
			n(function (n) {
				n.callHandler("hideProgress", "",
					function (n) {})
			})
		},
		hideMore: function () {
			window.AndroidClient && window.AndroidClient.hideMore(),
			n(function (n) {
				n.callHandler("hideMore", "",
					function (n) {})
			})
		},
		showMore: function () {
			window.AndroidClient && window.AndroidClient.showMore(),
			n(function (n) {
				n.callHandler("showMore", "",
					function (n) {})
			})
		},
		txtCopy: function (i) {
			window.AndroidClient && window.AndroidClient.txtCopy(i),
			n(function (n) {
				n.callHandler("txtCopy", i,
					function (n) {})
			})
		},
		toLogin: function (i) {

			gl.callbacks.loginSuccess = {
				type: "json",
				success: i
			},
			window.AndroidClient && window.AndroidClient.toLogin(),
			n(function (n) {
				n.callHandler("toLogin", "",
					function (n) {})
			})

		},
		openH5: function (i, t) {
			if (typeof(i) == "string") {
				i = {
					url: i,
					title: t || "",
					nav_hidden: false,
					nav: {}
				};
			}
			if (t == "" || i.title == "") {
				i.nav_hidden = true; //兼容当title等于空的时候不显示nav
			}

			var httpProtocol = "http://";

			//当使用"//"作为协议字符串时，根据jssdk是否启用https做相应协议字符串变更；
			if (i.url.substr(0, 2) == "//") {
				if (gl.IsHttps) {
					httpProtocol = "https://";
				}
				i.url = i.url.replace("//", httpProtocol);
			}

			gl.info(function (res) {
				//当openH5的Url前缀不是http开头时将h5Patch作为前缀拼接到Url上;
				if (res.h5Path && i.url.substr(0, 4) !== "http") {
					i.url = res.h5Path + i.url;
				}

				var o = JSON.stringify(i);
				window.AndroidClient && window.AndroidClient.openH5(o),
				n(function (n) {
					n.callHandler("openH5", o,
						function (n) {})
				})

			});
		},
		open: function (i) {
			if (typeof(i) == "number") {
				window.AndroidClient && window.AndroidClient.open(i),
				n(function (n) {
					n.callHandler("open", i,
						function (n) {})
				})
				return;
			}
			if (typeof(i) == "string") {
				i = {
					n: i,
					v: {}
				};
			}

			var f,
			a = gl.nativeClsDict[i.n];
			a && (f = a(i.v)) && (i = {
					n: f[0],
					v: f[1]
				});

			if (typeof(i) != "object" || i.n == "") {
				console.log("open ,原生模块【" + i.n + "】不存在");
				return;
			}

			var httpProtocol = "http://";

			//当使用"//"作为协议字符串时，根据jssdk是否启用https做相应协议字符串变更；
			if (i.v["url"] && i.v.url.substr(0, 2) == "//") {
				if (gl.IsHttps) {
					httpProtocol = "https://";
				}
				i.v.url = i.v.url.replace("//", httpProtocol);
			}

			var d = JSON.stringify(i);
			window.AndroidClient && window.AndroidClient.openNative(d),
			n(function (n) {
				n.callHandler("openNative", d,
					function (n) {})
			})
		},
		openBrowser: function (a) {
			window.AndroidClient && window.AndroidClient.openBrowser(a),
			n(function (n) {
				n.callHandler("openBrowser", a,
					function (n) {})
			})
		},
		payAction: function (i) {
			var a = JSON.stringify(i);
			window.AndroidClient && window.AndroidClient.payAction(a),
			n(function (n) {
				n.callHandler("payAction", a,
					function (n) {})
			})
		},
		back: function (i) {
			gl.callbacks.back = {
				type: "",
				success: i
			},
			window.AndroidClient && window.AndroidClient.back(i),
			n(function (n) {
				n.callHandler("back", i,
					function (n) {})
			})
		},
		getToken: function (i) {
			i && (gl.callbacks.getToken = {
					type: "json",
					success: i
				},
				window.AndroidClient && window.AndroidClient.getToken(),
				n(function (n) {
					n.callHandler("getToken", "",
						function (n) {})
				}))
		},
		info: function (i) {
			i && (gl.callbacks.info = {
					type: "json",
					success: i
				},
				window.AndroidClient && window.AndroidClient.info(), n(function (n) {
					n.callHandler("info", "",
						function (n) {})
				}))
		},
		getState: function (i) {
			window.AndroidClient && window.AndroidClient.getState(i),
			n(function (n) {
				n.callHandler("getState", i,
					function (n) {})
			})
		},
		phoneBind: function (i) {
			gl.callbacks.phoneBindSuccess = {
				type: "string",
				success: i
			},
			window.AndroidClient && window.AndroidClient.phoneBind(),
			n(function (n) {
				n.callHandler("phoneBind", "",
					function (n) {})
			})
		},
		currentPage: function (i) {
			window.AndroidClient && window.AndroidClient.currentPage(i),
			n(function (n) {
				n.callHandler("currentPage", i,
					function (n) {})
			})
		},
		nav: function (i) {
			var a = JSON.stringify(i);
			window.AndroidClient && window.AndroidClient.nav(a),
			n(function (n) {
				n.callHandler("nav", a,
					function (n) {})
			})
		},
		pagetoolbar: function (i, o, a) {
			gl.callbacks.shareSuccess = {
				type: "",
				success: o
			};
			gl.callbacks.shareFailed = {
				type: "",
				success: a
			};
			gl.info(function (res) {

				//当share的linkurl前缀不是http开头时将h5Patch作为前缀拼接到linkurl上;
				if (res.h5Path && i.share && i.share.linkurl && i.share.linkurl.substr(0, 4) !== "http") {
					i.share.linkurl = res.h5Path + i.share.linkurl;
				}

				var d = JSON.stringify(i);
				window.AndroidClient && window.AndroidClient.pagetoolbar(d),
				n(function (n) {
					n.callHandler("pagetoolbar", d,
						function (n) {})
				})
			});
		},
		UMAnalytics: function (i, l) {
			var x;
			if (gl.platform.android) {
				x = {
					eventId: i,
					label: l || ""
				}
			} else {
				x = {
					eventID: i,
					label: l || ""
				}
			}
			var a = JSON.stringify(x);
			window.AndroidClient && window.AndroidClient.UMAnalytics(a),
			n(function (n) {
				n.callHandler("UMAnalytics", a,
					function (n) {})
			})
		},
		webStorage: function (key, val) {
			if(gl.isEmpty(key)) {
				gl.toast('key不能为空')
				return;
			}
			if(gl.isEmpty(val)) {
				gl.toast('val不能为空')
				return;
			}
			var x = {
				storageKey: key + "",
				storageValue: val + "",
			}
			var a = JSON.stringify(x);
			n(function (n) {
				n.callHandler("webStorage", a,
					function (n) {})
			})
		},
		getStorage: function (key, o) {
			if(gl.isEmpty(key)){
				gl.toast('key不能为空')
				return;
			}
			gl.callbacks.getStorageData = {
				type: "json",
				success: o
			};
			n(function (n) {
				n.callHandler("getStorage", key+"",
					function (n) {})
			})
		},
		removeStorage: function (key) {
			if(gl.isEmpty(key)){
				gl.toast('key不能为空')
				return;
			}
			n(function (n) {
				n.callHandler("removeStorage", key+"",
					function (n) {})
			})
		},
	},
	window.gl = gl
}
();
