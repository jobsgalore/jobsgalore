class SendMessage extends React.Component{
    constructor(props){
        super(props);
    }

    render(){
        let step;
        if (this.props.resumes == null){
            step = <Autorization title = {this.props.title}
                                 location = {this.props.location}
                                 sign_in={this.props.sign_in}
                                 sign_up={this.props.sign_up}
                                 linkedin_url = {this.props.linkedin_url}
            />;
        } else {
            step = <div>
                <form action={this.props.send_url} method='post'>
                    <div className="form-group">
                        <label>A brief message</label>
                        <br/>
                        <textarea name="letter[text]" className="none" id="letter_description"/>
                        <trix-editor input="letter_description"  />
                        <input type="text" value={this.props.title.id} name="letter[resume]" className="none" />
                    </div>
                    <div className="row hidden-sm hidden-xs">
                        <div className="col-xs-6 col-lg-6 col-md-offset-6 col-lg-offset-6" >
                            <input type="submit" className="btn btn-primary btn-block" value="Send a message"/>
                        </div>
                    </div>
                    <div className="row sticky hidden-lg hidden-md" >
                        <div className="col-xs-12 col-lg-12 btn_margin text-center" >
                            <input type="submit" className="btn btn-primary btn-block btn-circle" value="Send a message"/>
                        </div>
                    </div>
                    <br/>
                </form>
            </div>
        }
        return(
            <div>
                <h4> Are you sending message to:</h4>
                <h3><strong><a href={this.props.title.link}>{this.props.title.name}</a></strong></h3>
                <p>
                    <span className="text-warning">
                        {this.props.location.name}
                    </span>
                </p>
                <hr className="colorgraph"/>
                {step}
            </div>
        );
    }
}