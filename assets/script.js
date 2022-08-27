window.addEventListener('message', function(event) {
    var type = event.data.type;

    if(type=='open'){
        $('#page').fadeIn('fast');
    }

    if(type=='close'){
        $('#page').fadeOut('fast');
    };

    if(type=='update'){
        Object.entries(event.data.data).forEach(([type, info]) => {
            if(type=='police' && info > 4){
                $(`#police`).html('4+');
                return
            }
            $(`#${type}`).html(info);
        });
    }
})