class Alert extends React.Component{
    constructor(props){
        super(props);
        this.state={editing: false,
                    errorKey: false,
                    errorEmail: false,
                    dataset: null,
                    location_id:this.props.location_id};
        this.postToServer = this.postToServer.bind(this);
        this.handlerEdit = this.handlerEdit.bind(this);
        this.handlerBack = this.handlerBack.bind(this);
        this.handlerCheck = this.handlerCheck.bind(this);
        this.checkEmail = this.checkEmail.bind(this);
        this.handleInput = this.handleInput.bind(this);
        this.handleSearchLocations = this.handleSearchLocations.bind(this);
        this._email = React.createRef();
        this._key = React.createRef();
        this._location = React.createRef();
    }

    componentDidMount(){
        setTimeout(function () {$("#alert").modal('show')}, 2000);
    }

    checkEmail(arg){
        let reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        if(reg.test(arg)) {
            return true;
        } else{
            return false;
        }
    }

    postToServer() {
        if (this.state.editing) {
            if (this.handlerCheck()) {
                $.post("/clientforalert",
                    {
                        clientforalert: {
                            key: this._key.current.value,
                            email: this._email.current.value,
                            location_id: (this._location.current.value==="" || this._location.current.value==="Australia") ? "" : this.state.location_id
                        }
                    });
                $("#alert").modal('hide');
            }
        } else {
            if (this._email.current.value !== "" && this.checkEmail(this._email.current.value)) {
                this.setState({errorEmail:false});
                $.post("/clientforalert",
                    {
                        clientforalert: {
                            key: this.props.keys,
                            email: this._email.current.value,
                            location_id: this.props.location_id
                        }
                    });
                $("#alert").modal('hide');
            } else {
                this.setState({errorEmail:true});
            }
        }
    }
    handlerCheck(){
        let flag = true;
        let errorKey = false;
        let errorEmail = false;
        if (this._key.current.value===""){
            errorKey = true;
            flag = false;
        } else {
            errorKey = false;
        }
        if (this._location.current.value===""){
            this._location.current.value = "Australia"
        }
        if (this._email.current.value !=="" && this.checkEmail(this._email.current.value)){
            errorEmail = false;
        } else {
            errorEmail = true;
            flag = false;
        }
        this.setState({ errorKey: errorKey,
                        errorEmail: errorEmail});

        return flag;
    }

    handlerEdit(){
        this.setState({ editing:true,
                        location_id: this.props.location_id});
    }

    handlerBack(){
        this.setState({editing:false});
    }

    handleInput(){
        let not_found = true;
        if (this.state.dataset !==null){
            for(let i=0; i< this.state.dataset.length; i++){
                if (this.state.dataset[i].name === this._location.current.value){
                    this.setState({location_id: this.state.dataset[i].id});
                    not_found = false;
                    break;
                } else if (this.state.location_id !=="" ){
                    this.setState({location_id: ""})
                }
            }
        }
        if (not_found && this._location.current.value.length>0) {
            this.handleSearchLocations(this.props.url +"search_locations/" + this._location.current.value+".json");
        }
    }

    handleSearchLocations(url){
        $.ajax({url:url,
            success: function (data) {
                this.setState({dataset:data});
            }.bind(this)});
    }

    render(){
        let display;
        let buttonBack;
        let dataset;
        if ( this.state.dataset !== null ) {
            dataset = this.state.dataset.map(function(location) {
                return(
                    <option key={location.id} data-id = {location.id} value={location.name} />);
            }.bind(this));
        }
        if (this.state.editing){
            display = <div>
                        <div className="form-group">
                            <input ref={this._key} type="text" className="form-control" placeholder="keywords" defaultValue={this.props.keys}/>
                            {this.state.errorKey ? <div className="alert alert-danger">Please enter valid keywords</div> : null }
                        </div>
                        <div className="form-group">
                            <input list="list_of_locations" ref={this._location} type="text" className="form-control" onInput={this.handleInput} placeholder="Where: city" defaultValue={this.props.location_name}/>
                            <datalist id="list_of_locations">
                                {dataset}
                            </datalist>
                        </div>
                    </div>;
            buttonBack = <button type="button" className="btn btn-default" onClick={this.handlerBack}>
                            Back
                        </button>;
        }else {
            display = <p><strong>{this.props.keys}</strong> in <strong>{this.props.location_name}</strong> (<a
                onClick={this.handlerEdit}>edit</a>) </p>;
            buttonBack = null;
        }
        return(
            <div className="modal fade" id="alert" tabIndex="-1" role="dialog" aria-labelledby="jobAlert" aria-hidden="true">
                <div className="modal-dialog modal-md">
                    <div className="modal-content">
                        <div className="modal-header">
                            <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">
                                            &times;
                                        </span>
                            </button>
                            <h3 className="modal-title">Send daily alerts for similar jobs to this email:</h3>
                        </div>
                        <div className="modal-body">
                            <div className="container-fluid">
                                {display}
                                <div className="form-group">
                                    <input ref={this._email} autoFocus type="text" className="form-control"  placeholder="name@email.com.au"/>
                                    {this.state.errorEmail ? <div className="alert alert-danger">Please enter a valid email</div> : null }
                                </div>
                            </div>
                        </div>

                        <div className="modal-footer">
                            {buttonBack}
                            <button type="button" className="btn btn-success" onClick={this.postToServer}>
                                Activate
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}