
const TypeOfSearch = Object.freeze(
    [{code:1, name:"Find Company"},
    {code:2, name:"Find Jobs"},
    {code:3, name:"Find Resumes"}]
);

const Salary = Object.freeze(
   [{code: 0, name:'Any Salary'},
       {code: 30000, name:'$30,000+'},
       {code: 50000, name:'$50,000+'},
       {code: 70000, name:'$70,000+'},
       {code: 90000, name:'$90,000+'},
       {code: 110000, name:'$110,000+'},
       {code: 130000, name:'$130,000+'}]
);

const Urgent = Object.freeze(
    [{code: false, name:'All Jobs'},
        {code: true, name:'Urgent'}]
);


class SearchNew extends React.Component{
    constructor(props){
    super(props);
    let stateVariable ={};
        if (this.props.search){
            const {type, open, value, location_name, location_id, salary, urgent, category} = this.props.search;
            stateVariable = {
                type_search_code: TypeOfSearch[Number(type) - 1].code,
                type_search_name: TypeOfSearch[Number(type ) - 1].name,
                active_options: open === 'true',
                value: value,
                location_name: location_name,
                location_id: location_id ,
                salary: salary,
                urgent: urgent === "true",
                categories: this.props.categories,
                category: (category !== '' && category !== null && category !== undefined) ? Number(category) : ''
            };
        } else {
            stateVariable = {
                type_search_code: TypeOfSearch[1].code,
                type_search_name: TypeOfSearch[1].name,
                active_options: false,
                value: '',
                location_name: '',
                location_id: '',
                salary: null,
                urgent: false,
                categories: this.props.categories,
                category: ''
            };
        }
        this.state = stateVariable;
        this.handleClickItem =  this.handleClickItem.bind(this);
        this.handleOnClickOptions = this.handleOnClickOptions.bind(this);
        this.handleOnClickUrgent = this.handleOnClickUrgent.bind(this);
        this.uuid = parseInt(Math.random()*1000000);
    }

    handleClickItem(e) {
        if (e.target.id.indexOf('Search') !== -1) {
            this.setState({ type_search_name: e.target.text,
                            type_search_code: e.target.dataset.id });
        }
    }

    handleOnClickOptions() {
        this.setState({active_options: !this.state.active_options});
    }

    handleOnClickUrgent(){
        this.setState({urgent: !this.state.urgent});
    }

    render() {
        const {active_options, type_search_code, categories, category} = this.state;
        const {name, url_industries} = this.props;
        let options = null;

        // Кнопка выбора З.П
        let salary = <DropdownButton key = "main_search[salary]" elements ={Salary} name = "main_search[salary]" defaultValue = {this.state.salary}/>


        //Кнопка срочности
        let urgent = <DropdownButton key = "main_search[urgent]"  elements ={Urgent} name = "main_search[urgent]" defaultValue = {this.state.urgent}/>

        //Кнопка категорий
        let cat = <DropdownButton key = "main_search[category]"  elements ={categories} name = "main_search[category]" defaultValue = {category}/>

        //В зависимости от класса отображаем разные кнопки
        if (active_options) {
            if (type_search_code == 1) {
                options = <div className="row" style={{marginTop: 10}}>
                    {cat}
                </div>;
            } else if (type_search_code == 2) {
                options = <div className="row" style={{marginTop: 10}}>
                    {salary}
                    <div className="form-group indent"/>
                    {urgent}
                </div>;
            } else if (type_search_code == 3) {
                options = <div className="row" style={{marginTop: 10}}>
                   {salary}
                    <div className="form-group indent"/>
                   {urgent}
                    <div className="form-group indent"/>
                   {cat}
                </div>;
            }
        }

        return(<div>
                <div className="row">
                    <div className="form-group">
                        <Autocomplete className="border_radius_left form-control input-lg" route='/dictionary/'
                                      defaultName={this.state.value}
                                      name={name + '[value]'}
                                      id={"input_search_value_" +this.uuid}
                                      place_holder={ `${this.state.type_search_name}: ${type_search_code == 1 ? "name" : "title"}, keywords`}
                                      not_id={true}/>
                    </div>
                    <div className="form-group" >
                        <Autocomplete className="form-control input-lg border_radius_is_not" route='/search_locations/'
                                      defaultId={this.state.location_id}
                                      defaultName={this.state.location_name}
                                      name={name + '[location'}
                                      id={"location_search_" +this.uuid}
                                      place_holder="Where: city"/>
                    </div>
                        <div className="form-group" >
                            <div className="input-group">
                                <button className="btn btn-default dropdown-toggle btn-lg border_radius_is_not" type="button" data-toggle="dropdown"
                                    aria-haspopup="true">
                                <span className="caret"/>
                            </button>
                            <ul className="dropdown-menu">
                                <li>
                                    <a id="Search_1"
                                       data-id={TypeOfSearch[1].code}
                                       onClick={this.handleClickItem}>{TypeOfSearch[1].name}
                                    </a>
                                </li>
                                <li>
                                    <a id="Search_2"
                                       data-id={TypeOfSearch[2].code}
                                       onClick={this.handleClickItem}>{TypeOfSearch[2].name}
                                    </a>
                                </li>
                                <li>
                                    <a id="Search_3"
                                       data-id={TypeOfSearch[0].code}
                                       onClick={this.handleClickItem}>{TypeOfSearch[0].name}
                                    </a>
                                </li>
                            </ul>
                            <button className="btn btn-default btn-lg  border_radius_rigth" type="submit">
                                <i className="glyphicon glyphicon-search glyphicon-big"/>
                            </button>
                            <input id="input_search" name={name + '[type]'} value={type_search_code}
                                   hidden={true} readOnly={true}/>
                        </div>
                    </div>
                    <div className="form-group">
                        <button type="button" className="btn btn-default btn-lg btn_options" onClick={this.handleOnClickOptions} >
                            <i className="glyphicon glyphicon-option-vertical glyphicon-big"/>
                        </button>
                        <input id="input_action" name={name + '[open]'} value={active_options}
                               hidden={true} readOnly={true}/>
                    </div>
                </div>
                {options}
            </div>
        );
    }
}