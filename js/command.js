function cmd(xargs) {

    const _data = {};
    _data.rnd = 'command';
    _data.cmd = xargs;
    $.ajax({
        url: 'Handler.ashx',
        type: 'GET',
        data: _data,
        timeout: 1000,
        dataType: "html",
        error: function () {
            alert("请求处理异常！");
        }, success: function (result) {
            console.log(result);
        }
    });
}