class Duplicate extends React.Component{
    constructor(props) {
        super(props);
        this.state = {  notSave: true};
        this.save = this.save.bind(this);
        this.notSave = this.notSave.bind(this);
        this._iDCopany= React.createRef();
    }

    save(){
        if (this._iDCopany.current.value !== ''){
            let id = {dup_id: this._iDCopany.current.value};
            $.ajax({
                type: "PATCH",
                url: this.props.route,
                data: {action_executed: "absorb", data: id},
                success: function (data, textStatus) {
                    this.setState({notSave: false});
                    setTimeout(this.notSave,500);
                }.bind(this),
                dataType: 'json'
            });
        }
        let company = {id: this._fieldName.current.value,
            site: this._fieldSite.current.value,
            size_id: this._fieldSize.current.value,
            location_id: this._fieldLocationId.current.value,
            industry_id: this._fieldIndustry.current.value,
            recrutmentagency: this._fieldAgency.current.checked,
            description: this._fieldDescription.current.value
        };
        $.ajax({
            type: "PATCH",
            url: this.props.route,
            data: {action_executed: "update_company", data: JSON.stringify(company)},
            success: function (data, textStatus) {
                this.setState({notSave: false});
                setTimeout(this.notSave,500);
            }.bind(this),
            dataType: 'json'
        });
    }
    notSave(){
        this.setState({notSave: true});
    }

    render(){
        let btn_save;
        if (this.state.notSave){
            btn_save = <button type="button" className="btn btn-danger btn-block" onClick={this.save}>
                Absorb
            </button>;
        } else {
            btn_save = <button type="button" className="btn btn-info btn-block">
                Done
            </button>;
        }
        return(<div>
            <div className="form-group">
                <label>Fill ID duplicate company</label>
                <br/>
                <input ref={this._iDCopany} className="form-control" type="text"/>
            </div>
                <div className="row">
                    <div className="col-sm-offset-6 col-md-offset-6 col-lg-offset-6 col-xs-12 col-md-6 col-sm-6 col-lg-6">
                        {btn_save}
                    </div>
                </div>
        </div>
        )
    }

    /*constructor(props){
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
    }*/
}