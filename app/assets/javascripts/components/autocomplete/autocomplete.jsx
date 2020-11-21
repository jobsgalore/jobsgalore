class Autocomplete extends React.Component{
    constructor(props) {
        super(props);
        this.state = {  display:'none',
            autocomplete: null,
            input_id:null,
            locations: null,
            defaultId: this.props.defaultId,
            defaultName: this.props.defaultName,
            input: !this.props.not_id};
        this._nameRef =  this.props.nameRef || React.createRef();
        this._idRef =  this.props.idRef || React.createRef();
        this.handleInput = this.handleInput.bind(this);
    }
    componentDidMount(){
        this.setState({autocomplete: document.querySelector('#' + this.props.id)});
        if (this.state.input) {
            this.setState({input_id: document.querySelector('#input_get' + this.props.id)});
        }
    }
    handleInput(){
        let not_found = true;
        if (this.state.input && this.state.locations !==null){
            for(let i=0; i< this.state.locations.length; i++){
                if (this.state.locations[i].name === this.state.autocomplete.value){
                    this.state.input_id.value =(this.state.locations[i].id);
                    not_found = false;
                    break;
                }
            }
        }
        if (not_found && this.state.autocomplete.value.length>0) {
            this.handleSearchLocations(this.props.route+this.state.autocomplete.value+".json");
        }

    }

    handleSearchLocations(url){
        $.ajax({url:url,
            success: function (data) {
                this.setState({locations:data});
            }.bind(this)});
    }

    render(){
        let locations = null;
        const ilStyle={display:'none'};
        if ( this.state.locations !== null ) {
            locations = this.state.locations.map(function(location) {
                return(
                    <option key={'location_li'+this.state.id+location.id} data-id = {location.id} value={location.name} />);
            }.bind(this));
        }
        let input_id = null;
        if (this.state.input) {
            input_id = <input ref={this._idRef}
                              key={this.props.name + "_id]"}
                              id={"input_get"+this.props.id}
                              name={this.props.name + "_id]"}
                              defaultValue = {this.state.defaultId}
                              className={this.props.className}
                              style = {ilStyle}/>;
        }
        return(
            <div>
                <input list={this.props.name}
                       ref={this._nameRef}
                       key = {this.state.input ? this.props.name + "_name]" : this.props.name}
                       name={this.state.input ? this.props.name + "_name]" : this.props.name}
                       autoComplete = "off"
                       className={this.props.className}
                       onInput={this.handleInput}
                       defaultValue = {this.state.defaultName}
                       placeholder={this.props.place_holder}
                       type="text"
                       id={this.props.id}
                       style={this.props.style}/>
                {input_id}
                <datalist id={this.props.name} >
                    {locations}
                </datalist>
            </div>
        );
    }
}