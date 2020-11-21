class Autorization extends React.Component{
    constructor(props){
        super(props);
    }

    render(){
        return(
            <div>
                <div className="form-group">
                    <label>Aready a member?</label>
                    <div className="row">
                        <div className="col-xs-6 col-sm-6 col-md-6">
                            <a className="btn btn-success btn-block" href={this.props.sign_in}>Sign in</a>
                        </div>
                        <div className="hidden-xs col-sm-6 col-md-6 social-share-button">
                            <a className="btn btn-linkedin btn-block" href={this.props.linkedin_url}>
                                <i className="i ssb-icon ssb-linkedin text-left btn" aria-hidden="true"/>&nbsp;Sign in with linkedIn</a>
                        </div>
                        <div className="col-xs-6 hidden-md hidden-sm hidden-lg social-share-button">
                            <a className="btn btn-linkedin btn-block" href={this.props.linkedin_url}>
                                <i className="i ssb-icon ssb-linkedin text-left btn" aria-hidden="true"/>&nbsp;LinkedIn</a>
                        </div>
                    </div>
                </div>
                <hr className="colorgraph"/>
                <p><strong> Personal information:</strong></p>
                <form method="post" action={this.props.sign_up} >
                    <div className='row'>
                        <div className="col-xs-12 col-sm-6 col-md-6">
                            <div className="form-group">
                                <label>*Your first name</label>
                                <input type='text' ref={this._inputName} autoFocus name="client[firstname]" className="form-control" placeholder="First Name" required="required"/>
                            </div>
                        </div>
                        <div className="col-xs-12 col-sm-6 col-md-6">
                            <div className="form-group">
                                <label>*Your surname</label>
                                <input type='text' ref={this._inputSurname}  name="client[lastname]" className="form-control" placeholder="Surname" required="required"/>
                            </div>
                        </div>
                    </div>
                    <div className="form-group">
                        <label>*Your location</label>
                        <br/>
                        <Autocomplete className="form-control dropdown-toggle"
                                      name="client[location"
                                      id= "client_location_id"
                                      route='/search_locations/'
                                      nameRef ={this._inputLocationName}
                                      idRef = {this._inputLocationId}
                                      defaultName= {this.props.location.name}
                                      defaultId={this.props.location.id} />
                    </div>
                    <div className="form-group">
                        <label>*Your phone number</label>
                        <InputMask inputRef={this._inputPhone} id="phone" name="client[phone]" class_name="form-control" dataformat="dd dddd dddddd" placeholder="02 9999 9999"/>
                    </div>
                    <div className="form-group">
                        <label>*Your e-mail</label>
                        <input type='email' ref={this._inputEmail} name="client[email]" className="form-control" placeholder="example@mail.com.au" required="required"/>
                    </div>
                    <div className="form-group">
                        <label>*Password</label>
                        (6 characters minimum)
                        <br/>
                        <input type='password' ref={this._inputPassword}  name="client[password]" autoComplete="off" className="form-control" placeholder="**************" required="required"/>
                    </div>
                    <div className="row">
                        <div className="form-group">
                            <div className="col-xs-6 col-sm-6 col-md-6">
                                <input type="submit" className="btn btn-primary btn-block" value="Continue"/>
                            </div>
                        </div>
                    </div>
                </form>
                <hr className="colorgraph"/>
            </div>
        );
    }
}