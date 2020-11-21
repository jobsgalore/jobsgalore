class NewResume extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            text: this.props.text,
            title:null,
            industry:null,
            location_name:this.props.location.name,
            location_id:this.props.location.id};
        this._fileInput = React.createRef();
        this.handleOnClickResume =  this.handleOnClickResume.bind(this);
        this.handleLinkedIn = this.handleLinkedIn.bind(this);
        this.handleChange = this.handleChange.bind(this);
    }


    componentWillReceiveProps(nextProps) {
        if (nextProps.text !== this.state.text && !this._updated) {
            this.setState({ text: nextProps.text });
        }
        if (this._updated) this._updated = false;
    }

    handleOnClickResume(){
        this.props.onchange('new_resume');
    }

    handleLinkedIn(){
        experiment('create_resume', 'Заходим из реакт. Загрузка из LinkedIn' );
        $.get(this.props.linkedin_resume_url, function(data) {
            this.setState({ title:data.title,
                            industry: {id: data.industry_id},
                            location_id:data.location_id,
                            location_name:data.location_name,
                            flagVisible: !this.state.flagVisible});
            let ed = $("trix-editor")[0];
            ed.editor.setSelectedRange([0, 0]);
            ed.editor.insertHTML(data.description);
        }.bind(this));
    }

    handleChange(){
        experiment('create_resume', 'Заходим из реакт. Загрузка файла' );
        readURL(this._fileInput.current)
    };
    render(){
        let flag;
        let field_new_resume;
        let buttonLinkedIn;
        if (this.props.user_from_linkedin){
            buttonLinkedIn = <div className="row">
                                <div className="form-group">
                                    <div className="col-md-12 col-md-6 col-sm-6 col-lg-6 social-share-button">
                                        <a className="btn btn-linkedin btn-block" onClick={this.handleLinkedIn}>
                                            <i className="ssb-icon ssb-linkedin text-left btn" aria-hidden="true"/>
                                            &nbsp;|&nbsp;Resume from LinkedIn
                                        </a>
                                    </div>
                                    <div className="col-xs-12 col-md-6 col-sm-6 col-lg-6">
                                        <div className = "hidden-md hidden-lg hidden-sm">
                                            <p/>
                                        </div>
                                        <label className="btn btn-warning btn-block" htmlFor="inp">
                                            <i className="glyphicon glyphicon-upload" />
                                            &nbsp;|&nbsp;Upload a resume (.txt .docx)
                                        </label>
                                        <input id="inp" ref = {this._fileInput} onChange={this.handleChange} type="file" accept=".txt, .docx" style={{"display":"none"}} />
                                    </div>
                                </div>
                            </div>
        } else {
            buttonLinkedIn = <div className="row">
                <div className="form-group">
                    <div className="col-xs-12 col-md-6 col-sm-6 col-lg-6">
                        <div className = "hidden-md hidden-lg hidden-sm">
                            <p/>
                        </div>
                        <label className="btn btn-warning btn-block" htmlFor="inp">
                            <i className="glyphicon glyphicon-upload" />
                            &nbsp;|&nbsp;Upload a resume (.txt .docx)
                        </label>
                        <input id="inp" ref = {this._fileInput} onChange={this.handleChange} type="file" accept=".txt, .docx" style={{"display":"none"}} />
                    </div>
                </div>
            </div>
        }
        if (this.props.check){
            field_new_resume =  <div className="panel-body">
                {buttonLinkedIn}
                <br/>
                <div className="form-group">
                    <label>Title</label><em> (Put your profession or skills here, not your name.)</em>
                    <br/>
                    <input type="text" defaultValue={this.state.title} name={this.props.name+"[title]"} className="form-control" required="required" />
                </div>
                <div className="row">
                    <div className="col-md-6 col-lx-6 col-sm-12 col-xs-12">
                        <div className="form-group">
                            <label>Desired Salary </label><em> (Optional)</em>
                            <br/>
                            <div className="input-group">
                                <span className="input-group-addon">$</span>
                                <input type="text" name={this.props.name+"[salary]"} className="form-control"/>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-6 col-lx-6 col-sm-12 col-xs-12">
                        <div className="form-group">
                            <label>Location</label>
                            <br/>
                            <Autocomplete className = "form-control dropdown-toggle"
                                          name = {this.props.name+"[location"}
                                          id = "resume_location_id"
                                          route = "/search_locations/"
                                          defaultName = {this.state.location_name}
                                          defaultId = {this.state.location_id}/>
                        </div>
                    </div>
                </div>
                <div className="form-group">
                    <label>Professional area </label>
                    <br/>
                    <Category style={{width:'100%'}}
                              key = {this.state.flagVisible}
                              defaultValue={this.state.industry}
                              className="form-control navbar-btn"
                              name={this.props.name+"[category]"}
                              url_industries = {this.props.url_industries}/>
                </div>
                <div className="form-group">
                    <label>Resume (CV)</label>
                    <br/>
                    <textarea name={this.props.name+"[description]"} className="none"   id="resume_description" />
                    <trix-editor input="resume_description"  />
                </div>
            </div>;
        };
        return(
            <div>
                <div className="panel panel-info" >
                    <div className="panel-heading " onClick={this.handleOnClickResume} >
                        <input type="radio" id="new_resume_head" name={this.props.nameCheckbox} value="New resume" checked={this.props.check}/> New resume
                    </div>
                    {field_new_resume}
                </div>
            </div>
        );
    }
}