class StepTwo extends React.Component {
    constructor(props) {
        super(props);
        this.handleChangeFocus =  this.handleChangeFocus.bind(this);
        this.handleChangeViewing =  this.handleChangeViewing.bind(this);
        this.handleChangeMessage =  this.handleChangeMessage.bind(this);
        this._trixRef = React.createRef();
    }

    handleChangeMessage(message){
        this.props.updateDate({message: message});
    }

    componentDidMount(){
        this._trixRef.current.addEventListener('trix-change', function (a) {
            this.handleChangeMessage(a.target.value);
        }.bind(this));
    }


    handleChangeFocus(e){
        let resumes = this.props.resumes;

        if (!resumes[e].checked){
            Object.keys(resumes).forEach(function (value) {
                resumes[value].checked = false;
            }.bind(this));
            resumes[e].checked = true;
            this.props.updateDate({resumes: resumes});
        }
    }


    handleChangeViewing(){
        this.props.updateDate({view: !this.props.view,
                               price: this.props.onChangePrice(null, !this.props.view) });
    }



    render(){
        let old_resumes;
        if (this.props.resumes !== null) {
            old_resumes = <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <button type="button" className={"btn btn-default " + (this.props.view ? "btn-primary" : "btn-success") + " btn-md"} onClick={this.handleChangeViewing}>
                   <span className= {this.props.view ? "glyphicon glyphicon-ok" : "glyphicon glyphicon-plus"} /> Select a resume
                </button>
                <p />
                { this.props.view ? Object.keys(this.props.resumes).map(function (value, i) {
                    return (<Resume resume={this.props.resumes[value].resume}
                                    onchange={this.handleChangeFocus}
                                    name="letter[resume]"
                                    check={this.props.resumes[value].checked}
                                    key={i}
                                    keyResume={i}/>);
                }.bind(this)) : null}
            </div>
        }
        return(<div className="row">
            {old_resumes}
            <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <div className="form-group">
                    <label>A brief message </label>
                    <br/>
                    <textarea id="letter_description" className="none" defaultValue={this.props.message}/>
                    <trix-editor ref={this._trixRef} input={"letter_description"} />
                </div>
            </div>
        </div>);
    }
}