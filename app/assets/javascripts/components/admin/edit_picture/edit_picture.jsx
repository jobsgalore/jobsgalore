class EditPicture extends React.Component {
    constructor(props) {
        super(props);
        this.state = {  notSave: true,
                        image: this.props.image ? this.props.image : this.props.defaultImage }
        this.notSave = this.notSave.bind(this);
        this.save = this.save.bind(this);
        this.update = this.update.bind(this);
        this.refInput = React.createRef();
    }
    notSave(){
        this.setState({notSave: true});
        this.update();
    }
    save(){
        let fd = new FormData();
        fd.append("action_executed", "update_logo");
        fd.append("data[img]", this.refInput.current.files[0]);
        $.ajax({
            type: "PATCH",
            url: this.props.route,
            async: false,
            cache: false,
            contentType: false,
            processData: false,
            data: fd,
            success: function (data, textStatus) {
                this.setState({notSave: false});
                setTimeout(this.notSave,500);
            }.bind(this),
            dataType: 'json'
        });
    }
    update(){
        $.ajax({
            type: "get",
            url: this.props.update_route,
            success: function (data) {
                this.setState({image: data.logo_uid});
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
        return(<div className="form-group text-center">
                    <img className="img-thumbnail"
                         src={this.state.image}
                         width="300" height="300" />
                    <p />
                    <Fileinput  key = {this.state.image} refInput={this.refInput} id = "company_logo" name = "company[logo]" place_holder = "empty"/>
                    <br />
                    <div className="row">
                        <div className="col-sm-offset-6 col-md-offset-6 col-lg-offset-6 col-xs-12 col-md-6 col-sm-6 col-lg-6">
                            {btn_save}
                        </div>
                    </div>
                </div>)
    }

}