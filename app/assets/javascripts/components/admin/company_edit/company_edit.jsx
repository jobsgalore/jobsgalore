class CompanyEdit extends React.Component {
    constructor(props) {
        super(props);
        this.state = {  notSave: true,
                        name: this.props.name,
                        site: this.props.site,
                        size: this.props.size.value,
                        locationDefaultName: this.props.location.defaultName,
                        locationDefaultId: this.props.location.defaultId,
                        industry: this.props.industry.value,
                        agency: this.props.recruitmentagency,
                        description: this.props.description};
        this.save = this.save.bind(this);
        this.notSave = this.notSave.bind(this);
        this._fieldName = React.createRef();
        this._fieldSite = React.createRef();
        this._fieldSize = React.createRef();
        this._fieldLocationId = React.createRef();
        this._fieldLocationName = React.createRef();
        this._fieldIndustry = React.createRef();
        this._fieldAgency = React.createRef();
        this._fieldDescription = React.createRef();
    }

    notSave(){
        this.setState({notSave: true});
    }
    save(){
        let company = {name: this._fieldName.current.value,
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
    render(){
        let btn_save;
        if (this.state.notSave){
            btn_save = <button type="button" className="btn btn-danger btn-block" onClick={this.save}>
                Save
            </button>;
        } else {
            btn_save = <button type="button" className="btn btn-info btn-block">
                Done
            </button>;
        }
        let sizes = this.props.size.all.map(function (elem) {
            return(<option key ={elem.id} value={elem.id}>  {elem.name} </option>);
        }.bind(this));
        let industries = this.props.industry.all.map(function (elem) {
            return(<option key ={elem.id} value={elem.id}>  {elem.name} </option>);
        }.bind(this));
        return(<div>
            <div className="form-group">
                <label>Name</label>
                <br/>
                <input ref={this._fieldName} className="form-control" type="text" defaultValue={this.state.name}/>
            </div>
            <div className="form-group">
                <label >Site</label>
                <br/>
                <input ref={this._fieldSite} className="form-control" type="text" defaultValue={this.state.site}/>
            </div>
            <div className="form-group">
                <label>Size</label>
                <br/>
                <select ref={this._fieldSize} defaultValue={this.state.size} className="selectpicker form-control" data-style="btn-default">
                    {sizes}
                </select>
            </div>
            <div className="form-group">
                <label>Location</label>
                <br/>
                <Autocomplete   key = "first"
                                nameRef={this._fieldLocationName}
                                idRef={this._fieldLocationId}
                                className = {this.props.location.className}
                                name = {this.props.location.name}
                                id = {this.props.location.id}
                                route = {this.props.location.route}
                                defaultName = {this.state.locationDefaultName}
                                defaultId = {this.state.locationDefaultId} />
            </div>
            <div className="form-group">
                <label>Industry</label>
                <br/>
                <select ref={this._fieldIndustry} defaultValue={this.state.industry} className="form-control">
                {industries}
                </select>
            </div>
            <div className="form-group">
                <div className="custom-control custom-checkbox">
                    <input type="checkbox" ref={this._fieldAgency} defaultChecked={this.state.agency} className="custom-control-input"/> &nbsp;
                    <label>Recruitment agency</label>
                </div>
            </div>
            <div className="form-group">
                <label>Description</label>
                <br/>
                <textarea name="letter[text]" defaultValue={this.state.description}  ref={this._fieldDescription} className="none" id="letter_description"/>
                <trix-editor input="letter_description"  />
            </div>
            <div className="row">
                <div className="col-sm-offset-6 col-md-offset-6 col-lg-offset-6 col-xs-12 col-md-6 col-sm-6 col-lg-6">
                    {btn_save}
                </div>
            </div>
        </div>);
    }
}
