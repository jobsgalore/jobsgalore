class EmailJobs{
    constructor(tilte, text, url, params){
        this.body = $('.wrapper');
        this.title = tilte;
        this.text = text;
        this.url = url;
        this.params = params;
        this.input = null;
    }

    createModal(){
        this.body.append('<form class="modal fade" id="EmailModal" tabindex="-1" role="dialog" onsubmit ="return false">' +
                              '<div class="modal-dialog" role="document">'+
                                    '<div class="modal-content">'+
                                        '<div class="modal-header">' +
                                            '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'+
                                            `<h4 class="modal-title text-center" id="myModalLabel">${this.title}</h4>` +
                                        '</div>' +
                                        '<div class="modal-body">'+
                                            `<label htmlFor="emp">${this.text}</label>`+
                                            '<br/>' +
                                            '<input id="emp" class = "form-control" required="required" type ="email"/>' +
                                        '</div>' +
                                        '<div class="modal-footer">'+
                                            '<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>'+
                                            '<button type="button" id="btn_send" class="btn btn-primary">Email</button>'+
                           '</div></div></div></div>');
        this.modal = $('#EmailModal');
        this.modal.find('#btn_send').on('click',()=>{this.handlerSend()});
        this.modal.on('hidden.bs.modal', () => (this.handlerHidden()));
    }

    handlerHidden(){
        this.modal.remove();
    }

    getEmail(){
        if (this.input == null) {
            this.input = this.modal.find('#emp')
        }
        return this.input.val()
    }

    handlerSend(){
        this.params['email'] = this.getEmail();
       $.post(this.url,
           {send: this.params},
           (data) => {console.log(data)},
           'json');
       this.hide()
    }

    hide(){
        this.modal.modal('hide');
    }

    show(){
        this.modal.modal({ show: true});
    }

}
