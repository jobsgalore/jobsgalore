class Grid_Inputs extends React.Component{
    constructor(props){
        super(props);
        this.state = {  emails: this.props.emails ? this.props.emails : [],
                        modal_location_id: this.props.location_id,
                        modal_location_name: this.props.location_name,
                        modal_email: null,
                        modal_fio: null,
                        modal_phone: null,
                        modal_send_email: true,
                        modal_contact: null,
                        flag: true,
                        notSave: true};
        this.editItem = this.editItem.bind(this);
        this.newItem = this.newItem.bind(this);
        this.deleteItem = this.deleteItem.bind(this);
        this.pushItem = this.pushItem.bind(this);
        this.pushToServer = this.pushToServer.bind(this);
        this.notSave = this.notSave.bind(this);
        this.update = this.update.bind(this);
        this._modalWindow = React.createRef();
        this._fieldEmail = React.createRef();
        this._fieldPhone = React.createRef();
        this._fieldFio = React.createRef();
        this._fieldLocationId = React.createRef();
        this._fieldLocationName = React.createRef();
        this._fieldSendEmail = React.createRef();
        this._fieldMain = React.createRef();
        this._fieldContact = React.createRef();
    }

    update(){
        $.ajax({
            type: "GET",
            url: this.props.update_route,
            success: function (data) {
                this.setState({emails: data ? data : []});
            }.bind(this),
            dataType: 'json'
        });
    }

    editItem(index){
        this.setState({edit: index});
        this.setState({ modal_location_id: this.state.emails[index].location_id,
                        modal_location_name: this.state.emails[index].location_name,
                        modal_email: this.state.emails[index].email,
                        modal_fio: this.state.emails[index].fio,
                        modal_phone:this.state.emails[index].phone,
                        modal_send_email: this.state.emails[index].send_email,
                        modal_main: this.state.emails[index].main,
                        modal_contact: this.state.emails[index].contact});
        $(this._modalWindow.current).modal('show');
    }

    deleteItem(index){
        let array = this.state.emails;
        delete array[index];
        this.setState({emails: array});
    }

    newItem(){
        this.setState({edit: null});
        this.setState({ modal_location_id: this.props.location_id,
                        modal_location_name: this.props.location_name,
                        modal_email: null,
                        modal_fio: null,
                        modal_phone: null,
                        modal_send_email: true,
                        modal_main: null});
        $(this._modalWindow.current).modal('show');
    }

    pushToServer(){
        $.ajax({
            type: "PATCH",
            url: this.props.route,
            data: {action_executed: "update_emails", data: JSON.stringify(this.state.emails)},
            success: function (data, textStatus) {
                    this.setState({notSave: false});
                    setTimeout(this.notSave,500);
                }.bind(this),
            dataType: 'json'
        });

    }
    notSave(){
        this.setState({notSave: true});
        this.update();
    }
    pushItem(index){
        item = {
            location_name: this._fieldLocationName.current.value,
            location_id: this._fieldLocationId.current.value,
            email:this._fieldEmail.current.value,
            fio:this._fieldFio.current.value,
            phone: this._fieldPhone.current.value,
            send_email:this._fieldSendEmail.current.checked,
            main:this._fieldMain.current.checked,
            contact:this._fieldContact.current.checked
        };
        arr = this.state.emails;
        if (index === null){
            item.id = null;
            arr.push(item);
        } else{
            item.id = arr[index].id;
            arr[index] = item;
        }
        this.setState({emails: arr});
        $(this._modalWindow.current).modal('hide');
    }

    render(){
        let btn_save;
        if (this.state.notSave){
            btn_save = <button type="button" className="btn btn-danger btn-block" onClick={this.pushToServer}>
                Save
            </button>;
        } else {
            btn_save = <button type="button" className="btn btn-info btn-block">
                Done
            </button>;
        }
        let keyForModal = Math.floor(Math.random() * (10 - 1)) + 1;
        let modal = <div className="modal" id="formModal"  ref={this._modalWindow} tabIndex="-1" role="dialog">
                        <div key={keyForModal} className="modal-dialog" role="document">
                            <div className="modal-content">
                                <div className="modal-header">
                                    <h5 className="modal-title">{this.state.edit === null ? "New" : "Edit" }</h5>
                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div className="modal-body">
                                    <div className="form-group">
                                        <label htmlFor="fio">Client's Full Name *</label>
                                        <br/>
                                        <input id="fio" ref={this._fieldFio} defaultValue={this.state.modal_fio} className = "form-control" required="required" type ="text"/>
                                    </div>
                                    <div className="form-group">
                                        <label htmlFor="phone">Phone number</label>
                                        <br/>
                                        <input id="phone" ref={this._fieldPhone} defaultValue={this.state.modal_phone} className="form-control" required="required" type="text"/>
                                    </div>
                                    <div className="form-group">
                                        <label htmlFor="email">Email *</label>
                                        <br/>
                                        <input id="email" ref={this._fieldEmail} defaultValue={this.state.modal_email} className="form-control" required="required" type="text"/>
                                    </div>
                                    <div className="form-group">
                                        <label htmlFor="location">Location</label>
                                        <br/>
                                        <Autocomplete   key = {this.state.modal_location_id}
                                                        nameRef={this._fieldLocationName}
                                                        idRef={this._fieldLocationId}
                                                        style={{width: '100%'}}
                                                        className="form-control dropdown-toggle"
                                                        route='/search_locations/'
                                                        defaultId={this.state.modal_location_id}
                                                        defaultName={this.state.modal_location_name}
                                                        name='modal[location'
                                                        id="modal_location"
                                                        place_holder="Where: city"/>
                                    </div>
                                    <div className="form-group">
                                        <div className="custom-control custom-checkbox">
                                            <input type="checkbox" ref={this._fieldMain} defaultChecked={this.state.modal_main} className="custom-control-input" id="main" />
                                            &nbsp;
                                            <label className="custom-control-label" htmlFor="main">Main</label>
                                        </div>
                                    </div>
                                    <div className="form-group">
                                        <div className="custom-control custom-checkbox">
                                            <input type="checkbox" ref={this._fieldSendEmail} defaultChecked={this.state.modal_send_email} className="custom-control-input" id="send_email" />
                                            &nbsp;
                                            <label className="custom-control-label" htmlFor="send_email">Send Email</label>
                                        </div>
                                    </div>
                                    <div className="form-group">
                                        <div className="custom-control custom-checkbox">
                                            <input type="checkbox" ref={this._fieldContact} defaultChecked={this.state.modal_contact} className="custom-control-input" id="contact" />
                                            &nbsp;
                                            <label className="custom-control-label" htmlFor="contact">Contact</label>
                                        </div>
                                    </div>
                                </div>
                                <div className="modal-footer">
                                    <button type="button" className="btn btn-primary" onClick={() => this.pushItem(this.state.edit)}>Save changes</button>
                                    <button type="button" className="btn btn-secondary" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>;
        let btn = function(index){
            return(<div className="btn-group pull-right">
                <div className="btn-group">
                    <a className="btn btn-primary btn-block" onClick={() => this.editItem(index)}>
                        <i className="glyphicon glyphicon-pencil"></i>
                    </a>
                </div>
                <div className="btn-group">
                    <a className="btn btn-danger btn-block" onClick={() => this.deleteItem(index)}>
                        <i className="glyphicon glyphicon-remove"></i>
                    </a>
                </div>
            </div>);
        }.bind(this);
        let tbody = null;
        if ((typeof this.state.emails !== "undefined") && (this.state.emails !==null)) {
            tbody = this.state.emails.map(function (email, index) {
                return (
                    <tr key={index}>
                        <td>{email.id}</td>
                        <td>{email.email}</td>
                        <td>{email.fio}</td>
                        <td>{email.phone}</td>
                        <td>{email.main ? "true" : "false"}</td>
                        <td>{email.send_email ? "true" : "false"}</td>
                        <td>{email.contact ? "true" : "false"}</td>
                        <td>{email.location_name}</td>
                        <td>{btn(index)}</td>
                    </tr>);
            }.bind(this));
        }
        return(<div>
                    <table className="table table-bordered table-striped table-hover">
                        <thead>
                            <tr scope="col">
                                <th>ID</th>
                                <th>Email</th>
                                <th>Full Name</th>
                                <th>Phone number</th>
                                <th>Main</th>
                                <th>Send Email</th>
                                <th>Contact</th>
                                <th>Location</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {tbody}
                        </tbody>
                    </table>
                    <div className="row">
                        <div className="col-xs-12 col-md-6 col-sm-6 col-lg-6">
                            <button type="button" className="btn btn-primary btn-block" onClick={() => this.newItem(null)}>
                                Add a new email
                            </button>
                        </div>
                        <div className="col-xs-12 col-md-6 col-sm-6 col-lg-6">
                            {btn_save}
                        </div>
                    </div>
                    {modal}
             </div>
        );
    }
}