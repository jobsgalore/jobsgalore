class MainPageSearch extends React.Component{
    constructor(props) {
        super(props);
        this.uuid = parseInt(Math.random()*1000000);
        this.state = {value: this.props.search ? this.props.search.value : '',
            location_name: this.props.search ? this.props.search.location_name : '',
            location_id: this.props.search ? this.props.search.location_id : ''};
    }

    render() {
        const value = this.props.search ? this.props.search.value : "";
        const location_name = this.props.search ? this.props.search.location_name : "";
        const location_id = this.props.search ? this.props.search.location_id : "";
        const name = this.props.name;
        const hidden = {display: 'none'};
        const style = {
            width: '100%',
            borderRadius: 20,
            fontSize: 16,
            height: 40,
            margin: '5px 5px 5px 0px'
        };
        return(<div>
                <div className="col-xs-12">
                    <form action="/search" acceptCharset="UTF-8" method="get">
                        <Autocomplete style={style} className="form-control" route='/dictionary/'
                                      defaultName={value}
                                      name={name + '[value]'}
                                      id={"main_page_value_" +this.uuid}
                                      place_holder="What: title, keywords" not_id={true}/>
                        <Autocomplete style={style} className="form-control" route='/search_locations/'
                                      defaultId={location_id}
                                      defaultName={location_name}
                                      name={name + '[location'}
                                      id={"main_page_locaton_" +this.uuid}
                                      place_holder="Where: city"/>
                        <input id="input_search" name="main_search[type]" readOnly="" value="2" style={hidden}/>
                        <input id="input_action" name="main_search[open]" readOnly="" value="false"
                                   style={hidden}/>
                        <div className="text-center" >
                            <input type="submit" className="btn btn-primary  btn-circle btn-block" value="Search jobs"/>
                        </div>
                     </form>
                </div>
        </div>);
    }
}
