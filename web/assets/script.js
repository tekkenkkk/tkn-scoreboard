window.addEventListener('message', function(event) {
    switch(event.data.action){
        case 'toggle':
            if (event.data.state) {
                $('#page').fadeIn('fast');
            } else {
                $('#page').fadeOut('fast');
            }
            break;
        case 'update':
            Object.entries(event.data.data).forEach(([type, info]) => {
                $(`#${type}`).html(info);
            });
            break;
    }
})