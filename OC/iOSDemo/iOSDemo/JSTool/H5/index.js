gl.ready(function(){
    var $$ = function(id){
        return document.getElementById(id);
    }
    $$('getToken').addEventListener('click', function(e){
        gl.getToken(function(res){
            $$('getToken').innerHTML = res;
        })
    })
    $$('getAppInfo').addEventListener('click', function(e){
        gl.info(function(res){
            gl.dialog(res, function(ok){
                gl.toast('Choice OK')
            }, function(cancle){
                gl.toast('Choice Cancle')
            })
        })
    })
    $$('openH5').addEventListener('click', function(e){
        gl.openH5({nav_hidden:false, title:"MyBlog", url:"http://361teach.com"})
    })
    $$('login').addEventListener('click', function(e){
        gl.toLogin(function(res){

        });
        gl.toast('登录事件')
    })
    $$('UMAnalytics').addEventListener('click', function(e){
        gl.UMAnalytics('123', 'Page A')
        gl.toast('统计事件')
    })
    $$('txtCopy').addEventListener('click', function(e){
        gl.txtCopy('复制成功了')
    })
    $$('back').addEventListener('click', function(e){
        gl.back(0,function(res){
            
        })
        gl.toast('返回事件')
    })
    $$('toast').addEventListener('click', function(e){
        gl.toast('Hybrid Demo')
    })
    $$('getResource').addEventListener('click', function(e){
        var alert = $$('alert');
        if(alert.style.display === 'none') {
            alert.style.display = 'block';
            gl.getResource(function(res){
                $$('image').src = res.imagePath;
            })
        } else{
            alert.style.display = 'none';
        }
    })
    $$('share').addEventListener('click', function(e){
        gl.share(function(res){
            
        })
        gl.toast('分享事件')
    })
    $$('openNative').addEventListener('click', function(e){
        var className = $$('pageName').value;
        var args = $$('args').value;
        gl.open({n:className, v:{arg:args}})
    })
    $$('nav').addEventListener('click', function(e){
        var className = $$('nav_pageName').value;
        var args = $$('nav_args').value;
        gl.nav({nav_hidden: false, title:'Hybrid', left:[], right:[{icon:'', func:'openNative:', vars:{n:className, v:{arg: args}}}]})
    })
    $$('closeWin').addEventListener('click', function(e){
        gl.closeWin()
        gl.dialog('关闭当前视图 仅限于View', function(ok){
            gl.toast('Choice OK')
        }, function(cancle){
            gl.toast('Choice Cancle')
        })
       
    })
    $$('openBrowser').addEventListener('click', function(e){
        gl.openBrowser('http://361teach.com')
    })
    $$('webStorage').addEventListener('click', function(e){
        var k = $$('keyInput').value
        var v = $$('valueInput').value
        gl.webStorage(k,v);
    })

    $$('getStorage').addEventListener('click',function(e){
        var k = $$('getKeyInput').value
        gl.getStorage(k,function(res){
            gl.dialog(res?res:'无结果', function(ok){
                gl.toast('Choice OK')
            }, function(cancle){
                gl.toast('Choice Cancle')
            })
        })
    })
    $$('removeStorage').addEventListener('click', function(e){
        var k = $$('delKeyInput').value
        gl.removeStorage(k)
    })
    $$('dialog').addEventListener('click', function(e){
        gl.dialog('德玛西亚，永世长存', function(ok){
            gl.toast('Choice OK')
        }, function(cancle){
            gl.toast('Choice Cancle')
        })
    })
    $$('alert').addEventListener('click', function(e){
        var alert = $$('alert');
        if(alert.style.display === 'none') {
            alert.style.display = 'block';
        } else{
            alert.style.display = 'none';
        }
    })
})


